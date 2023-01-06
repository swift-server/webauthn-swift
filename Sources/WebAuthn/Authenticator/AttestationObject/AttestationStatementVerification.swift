//===----------------------------------------------------------------------===//
//
// This source file is part of the WebAuthn Swift open source project
//
// Copyright (c) 2022 the WebAuthn Swift project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of WebAuthn Swift project authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

import SwiftCBOR
import Crypto

struct AttestationStatementVerification {
    static func verifyPacked(attestationObject: AttestationObject, clientDataHash: SHA256.Digest) throws {
        let statement = attestationObject.attestationStatement
        // guard let formatCBOR = decodedAttestationObject["fmt"], case let .utf8String(format) = formatCBOR else {
        guard let algCBOR = statement["alg"],
            case let .negativeInt(alg) = algCBOR,
            let coseAlg = COSEAlgorithmIdentifier(rawValue: -1 - Int(alg)) else {
            throw PackedError.invalidOrMissingAlg
        }

        guard let sigCBOR = statement["sig"],
              case let .byteString(sig) = sigCBOR else {
            throw PackedError.invalidOrMissingSig
        }

        let verificationData = attestationObject.rawAuthenticatorData + clientDataHash

        if let x5cCBOR = statement["x5c"],
            case let .array(certificates) = x5cCBOR,
            case let .byteString(attestnCert) = certificates.first {
            // Basic or AttCA attestation

            print("X5C CERTIFICATE CHAIN VALIDATION NOT IMPLEMENTED YET")
        } else {
            // Self Attestation

        }
    }
}

extension AttestationStatementVerification {
    enum PackedError: Error {
        case invalidOrMissingAlg
        case invalidOrMissingSig
    }
}