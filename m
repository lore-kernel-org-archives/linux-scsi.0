Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MIME_HEADER_CTYPE_ONLY,MIME_NO_TEXT,
	SPF_HELO_NONE,SPF_PASS,T_TVD_MIME_NO_HEADERS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BFFCC433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 21 May 2021 10:26:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 228D860FD9
	for <linux-scsi@archiver.kernel.org>; Fri, 21 May 2021 10:26:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231459AbhEUK1n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 May 2021 06:27:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231644AbhEUK1b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 May 2021 06:27:31 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52FBEC06138A
        for <linux-scsi@vger.kernel.org>; Fri, 21 May 2021 03:26:09 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id v14so11150400pgi.6
        for <linux-scsi@vger.kernel.org>; Fri, 21 May 2021 03:26:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=H1qUanK32pD6OeldRAf2ES1nuxQWqOleXBQx8EsElyU=;
        b=cnq47Qx6xwijT2PMxVTuRQIhW6wcdhZBMoUz9S+indrrWe+Izn6ojx8bFx9HQKX7GB
         6u5q7V8Vjjmi5y6+kVmQoOEkLbtGgNjbGvGGQ/EmLxp/l4Nk1RG+vW0qry+Dct5zxb8t
         hl3i/i1oMH6aQcmBUaWsBebjMA3LsA+hQRCx8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=H1qUanK32pD6OeldRAf2ES1nuxQWqOleXBQx8EsElyU=;
        b=iraJ41i4wNzIqA8qRHtBnSqkm/oBCqW/olWwrUHWlYQNDBW+XLW028pAp9g6v/hjCQ
         BF3ItPe8DsKSGw4sdrLjRqD346TfAryTnLJicLQfDXim/SkOmEtinGRg2mMG8V52Ay/f
         FBnGfgb/C/qCL8UO0C1uOj2M1GId3Iih5po2w+hLkvvVlpHWTCntaGB85qHkK+RvkLmv
         A4/TbUSze7/XyhVcgKPYXmGgTVisD1o8lJyjMSPmBgCTenk+qwKn4HjNH13TI6RLv+tq
         lEd3eEMo0U211CZqDAZiMlqNY/+tRN8qrXhVfYlvAuuDo3vohKRAUP1LFR33lkyWTDn3
         D+zA==
X-Gm-Message-State: AOAM5323e/dj9Kvm3F70nR38TJGRWZveSJXfi0ejd4RebRhI0WTYpxpE
        hZ+aYRH99Km8MIS/1+RScri2D/OCs5yHv30kDpvQNUSbXVv1oUL6Bg61/28Q0AOmolG4HgrJ5Lz
        4otEdyyt3ROdopFDw3hIXoCOCtckIydVlsnQkmfx/kCs6QtjDnwq3tConi1DASNbr58I7eFh6Xl
        zHo73D4zdPxP7S918=
X-Google-Smtp-Source: ABdhPJzp5VDlFjKFtGEQoqZXUgxyvCNtAsWj0NEHW4rJptNIiEPD08Rj2Nfsy2r3zWJBebtXC/+g1Q==
X-Received: by 2002:a63:34cc:: with SMTP id b195mr9095780pga.449.1621592768286;
        Fri, 21 May 2021 03:26:08 -0700 (PDT)
Received: from dhcp-10-123-20-83.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id j3sm4197858pfe.98.2021.05.21.03.26.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 May 2021 03:26:07 -0700 (PDT)
From:   Chandrakanth Patil <chandrakanth.patil@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Subject: [PATCH v2 0/5] megaraid_sas: Update driver version to 07.717.02.00-rc1
Date:   Fri, 21 May 2021 15:55:43 +0530
Message-Id: <20210521102548.11156-1-chandrakanth.patil@broadcom.com>
X-Mailer: git-send-email 2.18.1
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000f3ab9d05c2d47cfe"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000f3ab9d05c2d47cfe

This patchset contains few critical fixes and enhancements.

v2:
     - Fixed sparse warnings reported by kbuild test robot in patch3.

Chandrakanth Patil (5):
  megaraid_sas: Send all non-RW IOs for TYPE_ENCLOSURE device through
    firmware
  megaraid_sas: Fix the resource leak in case of probe failure
  megaraid_sas: Early detection of VD deletion through RaidMap update
  megaraid_sas: Handle missing interrupts while re-enabling IRQs
  megaraid_sas: Update driver version to 07.717.02.00-rc1

 drivers/scsi/megaraid/megaraid_sas.h        | 16 +++-
 drivers/scsi/megaraid/megaraid_sas_base.c   | 96 +++++++++++++++++++--
 drivers/scsi/megaraid/megaraid_sas_fp.c     |  6 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 18 +++-
 4 files changed, 122 insertions(+), 14 deletions(-)

-- 
2.18.1


--000000000000f3ab9d05c2d47cfe
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
riBJ/K1AFUjRAjFhGV64l++td7dkmnq/X8ET75ti+w1s4FRpFqkD2m7pg5NxdsZphYIXAgMBAAGj
QjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBSP8Et/qC5FJK5N
UPpjmove4t0bvDANBgkqhkiG9w0BAQsFAAOCAQEAS0DbwFCq/sgM7/eWVEVJu5YACUGssxOGhigH
M8pr5nS5ugAtrqQK0/Xx8Q+Kv3NnSoPHRHt44K9ubG8DKY4zOUXDjuS5V2yq/BKW7FPGLeQkbLmU
Y/vcU2hnVj6DuM81IcPJaP7O2sJTqsyQiunwXUaMld16WCgaLx3ezQA3QY/tRG3XUyiXfvNnBB4V
14qWtNPeTCekTBtzc3b0F5nCH3oO4y0IrQocLP88q1UOD5F+NuvDV0m+4S4tfGCLw0FREyOdzvcy
a5QBqJnnLDMfOjsl0oZAzjsshnjJYS8Uuu7bVW/fhO4FCU29KNhyztNiUGUe65KXgzHZs7XKR1g/
XzCCBV4wggRGoAMCAQICDEsToCXmVAGrOZU9LzANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMTAyMjIxMjM4MDJaFw0yMjA5MTUxMTIzMzVaMIGa
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xGzAZBgNVBAMTEkNoYW5kcmFrYW50aCBQYXRpbDEuMCwGCSqG
SIb3DQEJARYfY2hhbmRyYWthbnRoLnBhdGlsQGJyb2FkY29tLmNvbTCCASIwDQYJKoZIhvcNAQEB
BQADggEPADCCAQoCggEBAN17vAiN630Miz8/OedJKuauChEmiA4b0QYvWMA5eDpaTmonlWoaIrq6
FEwzCFLCgTpToIzUShYM1O6fu/b6Zdy1Jvdccbj7u7mSXWF+rKJu5yg2g38x2XxWsy+/4rwqi9ix
BSrtpRGbpSxMsfxuEvtMbzZCeC4SitvLhFIMMHgUJ9E8pxXV7c0/ub5jxd/3nIOeIDoTOqJgSn40
aBqT0QvScYPWy42jL2D449cgE9PMNQy1mrSwerDqgTTgZJM4gAW7ta1nFP8cNbLJNYn3ZFEhJnOw
pXRVGaqlwpA1hmodBANNyhMlODsRuxNuqmNzINouAr/YlO2bdzlu+VTWz0MCAwEAAaOCAeAwggHc
MA4GA1UdDwEB/wQEAwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9z
ZWN1cmUuZ2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNy
dDBBBggrBgEFBQcwAYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFs
c2lnbjJjYTIwMjAwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBz
Oi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+
oDygOoY4aHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAy
MC5jcmwwKgYDVR0RBCMwIYEfY2hhbmRyYWthbnRoLnBhdGlsQGJyb2FkY29tLmNvbTATBgNVHSUE
DDAKBggrBgEFBQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQU
KHtkFTCJhYaNrtTlVnhO7+Z49xswDQYJKoZIhvcNAQELBQADggEBAB695p3nxrHwDBiZuUyc4kSq
1o3jGWXYdAgZoVOXcGSn0FFSuBT4bkoZNRXvN4AZGh7n5XjtEzGQjn++xALKCRF6K3yFfhAqsrHx
66xXjz8VYmD4J4p+TzVo8GP7si+9xJO/AW4f0FMCQ3vJdruH1PMHZYYuHFHcgyDY5CagijMkFJtD
Zpnb0pToIvDm+Ur3N2MiX3nSNdXYjeMdwB0OAs05pMciX6VfrXagLKEdSRHtOo/W/JA7fToB0eJS
Ky1ZxnSRQGTL4yIIMw43kd0GQyTIM6KyMy8uprn32g7HcYJf07P/tjC196OWjB5Qr7dSv3vtjU8N
2J0Xc13/AGfXSZ8xggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxT
aWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAy
MDIwAgxLE6Al5lQBqzmVPS8wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIIO3+vWQ
UwdtoReuWPL+Y8EhPYsRPKBeJcI2YS2HkP6NMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJ
KoZIhvcNAQkFMQ8XDTIxMDUyMTEwMjYwOFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASow
CwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZI
hvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQCHqaiEKftoRfgNa9w4hacXJ+2u
yW25quLC/G4nk5UbB/PuSdfYdyYegAEmsONIGBcAIo2Fgs1hA1GQiuocyw78rHV0BoluhQqxyWLY
0anzxShaczy36dhtcuxG5KOqE3zDB5EWLt4GtDIezXZuu789AvJg7G/s3ltaRz7p2hSqewY/ZySq
pswPSSjcIkVLCkzmyY9lQkAz9TEVClEqHHuhI0YdDsz+Y3tnXdS0T4jRfmReWyBRHHWHwSZnoDBq
yXALHrxISVg79NKvEM6EId+BLZ50YsBOuf1Hnz0ygqB0lFT8yVJrib+H5JiBrfrJUtkYnZc32aNb
VgaCOc//ZAy5
--000000000000f3ab9d05c2d47cfe--
