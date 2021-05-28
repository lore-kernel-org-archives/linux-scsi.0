Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MIME_HEADER_CTYPE_ONLY,
	SPF_HELO_NONE,SPF_PASS,T_TVD_MIME_NO_HEADERS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4CA3C4708C
	for <linux-scsi@archiver.kernel.org>; Fri, 28 May 2021 13:13:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 976AC613EB
	for <linux-scsi@archiver.kernel.org>; Fri, 28 May 2021 13:13:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236030AbhE1NP0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 May 2021 09:15:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235839AbhE1NPZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 May 2021 09:15:25 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4CC4C061574
        for <linux-scsi@vger.kernel.org>; Fri, 28 May 2021 06:13:50 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id m124so2484165pgm.13
        for <linux-scsi@vger.kernel.org>; Fri, 28 May 2021 06:13:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=wzxfpjVtIraPMe7H/NX9OF2A7cgktUA9c1+ylZvVABY=;
        b=dBSFP+a0wSZp/OLMFw4h62jfJVvp5iHpX7j7XjqqYKGtQuGJt6RzskjdbTdQvTLWsQ
         BHYH+n+mzitVw5VxqFPxGAtWM9fQqXfBzkFGMmzNGVeMOQokznlI7fA4/C1f3rzhNsJv
         WiYSPy8NeAbth+RhN63dsZrkAgCdfyNBmiP9E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=wzxfpjVtIraPMe7H/NX9OF2A7cgktUA9c1+ylZvVABY=;
        b=n3UhXg+DxF4cUSCUxetoKCeMuPaQVxLKpkCUVaQgntoZExhRZWPbYKqMMnyyfe7v8O
         R8RgylJij7ON1jwfMvpYul4eZ2W+9ylaxtSA2fdfH1gFNkB5ZLFKnRAXRjdlPtpjdsQK
         0qEPks7U5C8PQZu/BhnNNEJ+w8bGlRb3bAK9r210Lm28LBFQIGOIjDmhDbae1yLTS/Y0
         i6lAiI8UrBb9QJ8pFn9LoSNqilywgqAHd6h82Uu2iVBIJTFdNdOHbH3QkHcCynUmUQv+
         0rOmh59cAxNehXidHeM276TrfEvSVinEeQuuvO24Y3gbbH8bB3jMfm1b3P4l0c29JntC
         FI/Q==
X-Gm-Message-State: AOAM530yASCIjNVtEf5iuDZ9aLwuhe8U0feESijkW5b42gS76S2kmmFd
        /CnRidEEcls8JZgDicfONA8YUn/e9waC0CKtbCl/Gc1vC4ntSBxIMOthhvDaINo9Yi0/4ijOEEN
        UzO0qGdvA8jCsP7H8qq9ZhDF9QhnN5UGj4/43PbsTXrrQS0cMzm78WbcLeFk+jg4Jj2tH4zAh7w
        OC4OYsfwFzJSEDtqA=
X-Google-Smtp-Source: ABdhPJywd37noY9xk4QXmR3mLwcKYobwUgxyQjp8MA7c5G0cfBRXXkbq8qLH8utrr9TF3lYiFrc7kg==
X-Received: by 2002:a63:5664:: with SMTP id g36mr8876728pgm.357.1622207629751;
        Fri, 28 May 2021 06:13:49 -0700 (PDT)
Received: from dhcp-10-123-20-83.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id o2sm4238434pfu.80.2021.05.28.06.13.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 06:13:49 -0700 (PDT)
From:   Chandrakanth Patil <chandrakanth.patil@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        stable@vger.kernel.org
Subject: [PATCH v3 1/5] megaraid_sas: Send all non-RW IOs for TYPE_ENCLOSURE device through firmware
Date:   Fri, 28 May 2021 18:43:03 +0530
Message-Id: <20210528131307.25683-2-chandrakanth.patil@broadcom.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20210528131307.25683-1-chandrakanth.patil@broadcom.com>
References: <20210528131307.25683-1-chandrakanth.patil@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000008d37ed05c363a50a"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000008d37ed05c363a50a

Driver issues all non-ReadWrite IOs for TYPE_ENCLOSURE devices through
the fast path with invalid dev handle and fast path inturn directs all
the IOs to the firmware. As firmware stopped handling those IOs from
SAS3.5 generation of controllers (Ventura and its onward generations)
lead to IOs failure.

The driver will issue all the non-ReadWrite IOs for TYPE_ENCLOSURE devices
directly to firmware from SAS3.5 generation of controllers.

Cc: <stable@vger.kernel.org> # v5.11+
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 2221175ae051..cd94a0c81f83 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -3203,6 +3203,8 @@ megasas_build_io_fusion(struct megasas_instance *instance,
 {
 	int sge_count;
 	u8  cmd_type;
+	u16 pd_index = 0;
+	u8 drive_type = 0;
 	struct MPI2_RAID_SCSI_IO_REQUEST *io_request = cmd->io_request;
 	struct MR_PRIV_DEVICE *mr_device_priv_data;
 	mr_device_priv_data = scp->device->hostdata;
@@ -3237,8 +3239,12 @@ megasas_build_io_fusion(struct megasas_instance *instance,
 		megasas_build_syspd_fusion(instance, scp, cmd, true);
 		break;
 	case NON_READ_WRITE_SYSPDIO:
-		if (instance->secure_jbod_support ||
-		    mr_device_priv_data->is_tm_capable)
+		pd_index = MEGASAS_PD_INDEX(scp);
+		drive_type = instance->pd_list[pd_index].driveType;
+		if ((instance->secure_jbod_support ||
+		     mr_device_priv_data->is_tm_capable) ||
+		     (instance->adapter_type >= VENTURA_SERIES &&
+		     drive_type == TYPE_ENCLOSURE))
 			megasas_build_syspd_fusion(instance, scp, cmd, false);
 		else
 			megasas_build_syspd_fusion(instance, scp, cmd, true);
-- 
2.18.1


--0000000000008d37ed05c363a50a
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
MDIwAgxLE6Al5lQBqzmVPS8wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIK5MDBDk
N1Wm3XdLwqM8ZIxoiYJ5f1nv8P5cVmtb5sOSMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJ
KoZIhvcNAQkFMQ8XDTIxMDUyODEzMTM1MFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASow
CwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZI
hvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQCDAhqqCKpf+6v7IsqFzxrP+yNf
FeQtwnGhe+InWf3lgoCgPIR9PZ4EAZxfp4Xu+0+DQ0tVFXjzGANaAoN2qrdoRQOUoOipG+Q0q9z/
au8yNDLEKdq3DXW5Qoy0p2ToLQpd7HFhqYA2rzQ4MgwQ/K8i2Mkm6NE3L746vAIngnAXSMIaNKk4
oWTq6FJd7jZMyZ/pQxiDuTcGZ4VDDyECK4zMta1rR5F7E4MTFH5RTA49mVcM36nsrGeuAeiQlrRb
+a+7E0fg7vu0g8l0s51DiFa9SOJxookSGnT9w+CbwW7Br5yO8IEB0QsirjvBjolG+9lLIRvUexuo
+L5n/MxDi/vg
--0000000000008d37ed05c363a50a--
