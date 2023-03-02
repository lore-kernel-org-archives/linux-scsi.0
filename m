Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B84B1C6FA8E
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Mar 2023 10:54:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbjCBKyg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Mar 2023 05:54:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbjCBKyf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Mar 2023 05:54:35 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B9C14EC5
        for <linux-scsi@vger.kernel.org>; Thu,  2 Mar 2023 02:54:34 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id p20so15899743plw.13
        for <linux-scsi@vger.kernel.org>; Thu, 02 Mar 2023 02:54:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1677754474;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=2q9jrcy1DNS8CTC6w1q2MZ59aRtYLDMjt9hejdQuq7A=;
        b=KfIuk8AHmAYXYsKo4ZEgwGXbY9YkmHrILgneq/mkrEZSOjR2ax9+65Frx+x+hAfS0t
         erU/EEfeJYR+BZzux328LcmaQX6txCyIasNeywiT0HLw8KHGZpK3SpdXpDkfIwoBSQrF
         4JlFB0OIMOz+kQgVAAynd9WKBBFkrylFBlmwY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677754474;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2q9jrcy1DNS8CTC6w1q2MZ59aRtYLDMjt9hejdQuq7A=;
        b=ziPttXGCf8131jiW96Wvth/whteFCk5BOc2ELXIM+Nxls5aZW50ILCRtzRwDZo8jwx
         5JgqJ+8Y1y+UEH1ReXq1JMRDfRBpACqyE3h03rVxHVBk3l7zFiwNdsVFDB1wKna62jFl
         WsJWBYgqb/P+dlXGlgADhyNepDxbcnAgpOnCrb9sigsz64Su7aoPn/9NHp8AMP3TC7j0
         0KBj2G+kf+myLGmDI/A3UhmWzkIYxwxixM58khSJetIV/5NwWAe4snfeoHS+eMoWkkoF
         w9YlALgEPOKDPIvySMoezrQTsD6ZP22RKK/bVjjiIiVgMTiILjAN+rI70JKb2hktc1uR
         5VMA==
X-Gm-Message-State: AO0yUKWxjuwew7tLk7sCj/CnxUpZbETj3/YxpMcBYT7wFy5GYUmVjYVa
        GitaSAMzBAJ7MqNa2qO1L+Qy49X5ZjT03N/e5q1zkgVoES9xI+enDA8UGOaUerCi3Dg8gKaBlQ/
        Lx1d+YqowPmuvVSLfhZPmNWnf5iGHPwtouRkYvymOrN7XEhMVZLx0wiPNDTr0AMDLB6nXVM7XP+
        6iKDSRNyt2KdjejeI=
X-Google-Smtp-Source: AK7set+5NcDBoqHKfLcE+lbWaC52iM2hkUYcp1+mghrWhNebsP9s8YJ6PhWji2SZFj3UC/Q3YPGwnQ==
X-Received: by 2002:a05:6a20:9144:b0:bb:b903:d836 with SMTP id x4-20020a056a20914400b000bbb903d836mr11117053pzc.54.1677754473578;
        Thu, 02 Mar 2023 02:54:33 -0800 (PST)
Received: from dhcp-10-123-20-35.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id x14-20020a63170e000000b00502e1c50af3sm8865873pgl.45.2023.03.02.02.54.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 02:54:32 -0800 (PST)
From:   Chandrakanth Patil <chandrakanth.patil@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     sumit.saxena@broadcom.com,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Subject: [PATCH 2/3] megaraid_sas: Add crash dump mode capability bit in MFI capabilities
Date:   Thu,  2 Mar 2023 16:23:41 +0530
Message-Id: <20230302105342.34933-3-chandrakanth.patil@broadcom.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230302105342.34933-1-chandrakanth.patil@broadcom.com>
References: <20230302105342.34933-1-chandrakanth.patil@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000072641a05f5e8a789"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--00000000000072641a05f5e8a789
Content-Transfer-Encoding: 8bit

In kdump kernel mode, the driver works in reduced functionality mode with
some features disabled such as reduced MSIX count and RDPQ disabled etc.
However, the firmware is not aware of this mode, in some cases, which
results in undefined behavior.

To address this, the driver informs the firmware about the kdump mode
driver through MPI capabilities bit during driver initialization.
So firmware can adjust its behavior accordingly.

Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas.h        | 6 ++++--
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 3 +++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 2ef9d41fc6f4..c2bace65105b 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -1760,7 +1760,8 @@ union megasas_sgl_frame {
 typedef union _MFI_CAPABILITIES {
 	struct {
 #if   defined(__BIG_ENDIAN_BITFIELD)
-	u32     reserved:16;
+	u32     reserved:15;
+	u32	support_memdump:1;
 	u32	support_fw_exposed_dev_list:1;
 	u32	support_nvme_passthru:1;
 	u32     support_64bit_mode:1;
@@ -1794,7 +1795,8 @@ typedef union _MFI_CAPABILITIES {
 	u32     support_64bit_mode:1;
 	u32	support_nvme_passthru:1;
 	u32	support_fw_exposed_dev_list:1;
-	u32     reserved:16;
+	u32	support_memdump:1;
+	u32     reserved:15;
 #endif
 	} mfi_capabilities;
 	__le32		reg;
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index fe70f8f11435..7ebfbe0c2ba7 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -1201,6 +1201,9 @@ megasas_ioc_init_fusion(struct megasas_instance *instance)
 	drv_ops->mfi_capabilities.support_nvme_passthru = 1;
 	drv_ops->mfi_capabilities.support_fw_exposed_dev_list = 1;
 
+	if (reset_devices)
+		drv_ops->mfi_capabilities.support_memdump = 1;
+
 	if (instance->consistent_mask_64bit)
 		drv_ops->mfi_capabilities.support_64bit_mode = 1;
 
-- 
2.31.1


--00000000000072641a05f5e8a789
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
XzCCBV4wggRGoAMCAQICDEdtED9Zj45VgZuf5zANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMjA5MTAwOTM0MzhaFw0yNTA5MTAwOTM0MzhaMIGa
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xGzAZBgNVBAMTEkNoYW5kcmFrYW50aCBQYXRpbDEuMCwGCSqG
SIb3DQEJARYfY2hhbmRyYWthbnRoLnBhdGlsQGJyb2FkY29tLmNvbTCCASIwDQYJKoZIhvcNAQEB
BQADggEPADCCAQoCggEBAOPMhBafUXswA97gXTj1d5WoUBuCuq3xszdg5lAM1AHavwkVYXn9nKUH
7QgAR6GV/PyPyloLcAeIkTarJRpxB885+xOyR4EAA8zRk9mirwq7GotMjSmRA81Ne5tpqZObHbsv
ELVogt2xoFkQFwDZznRDVQ1RRWO8gLU/7clg4TWqNxSsRF7PfM2U1sk6If8qHVMdtHLukGibl0Tv
4SxjDQ1M8uqWXeJcdYM4lQc+PSKyTNqPy/KLt1enu6lmA236FXBhPFSg3+EeZ9Ma7ZMj++uMpnwz
jLZb2F4wVMfuh/ZTi4ty6G3wQ/OIFcK4EkaKubAqreTT+LEu5XOFi10KHncCAwEAAaOCAeAwggHc
MA4GA1UdDwEB/wQEAwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9z
ZWN1cmUuZ2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNy
dDBBBggrBgEFBQcwAYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFs
c2lnbjJjYTIwMjAwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBz
Oi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+
oDygOoY4aHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAy
MC5jcmwwKgYDVR0RBCMwIYEfY2hhbmRyYWthbnRoLnBhdGlsQGJyb2FkY29tLmNvbTATBgNVHSUE
DDAKBggrBgEFBQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQU
tI7aNGRrv6gHqOPkFli9EdvR2xcwDQYJKoZIhvcNAQELBQADggEBAI0Px1+MF4ubFWlBurQFxZRv
/K8V2fysp6NhKRpdJ43KozsApD438TU9DdNe8wW1MrCV3sRXZhlEkkukkfppzYRuoemmIdd4Rajh
Dh+uglOx3CYSKKOEWSbVIaDVMBQvVtqfZlGJgLRmLpO2agb8V/eY85IoMoM9hJkTll7OoTo+Lhon
W2v5XKnfV6+4iODhAb65bwLbcNq6dxzr1Yy/fGnIBfoR2qrX9UBDDxjZRpxJGdt7i0CcvsX7p2ia
SgP+hUBq9GTgLiFqCGyh/gCm2DTB/TyYel0QsIP29qWC1F5mG+GOoSjagi/2SxnNI6LzK+4xfgvc
80IlL0UapzuyZFExggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxT
aWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAy
MDIwAgxHbRA/WY+OVYGbn+cwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEICTRzcTS
apmu1n+SoLiMHOMxai2i3ZEHDiH2zGhAXRaDMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJ
KoZIhvcNAQkFMQ8XDTIzMDMwMjEwNTQzNFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASow
CwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZI
hvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQDOT0RCXvuZnwl7f9pbCESlmwuZ
fLe0tXKxCPevMrpsiirQLg1DV7vmI8lr4cyPXbefRydt1k4UWNrTdw/jK1gMFL53wjQgp5ihGBKe
UJ4ykgIYjfuomVRCMBz+I6COjbLDi1mybAmcuLSJLfhKTDs+6dhJPH7TFbMAkjHtLcvK1eUzPzi/
9AB1wbaR95ZAYfMTrUDv5tt3vcNdWQfyeBRKskS7WcTYfJJuA5xaju1e9ZOZ0qYp2kt1znKsWEoI
cI0P61Lz8wj5d/sIONa2WNQhq2gLyepWBZ/Fa1ox7LJcAcrM/3MoI2uPRiQp0TSgceYcOYjPdTaj
wHXv3fnm+Tb7
--00000000000072641a05f5e8a789--
