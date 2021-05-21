Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MIME_HEADER_CTYPE_ONLY,
	SPF_HELO_NONE,SPF_PASS,T_TVD_MIME_NO_HEADERS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBDE8C43461
	for <linux-scsi@archiver.kernel.org>; Fri, 21 May 2021 10:27:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9D10613CE
	for <linux-scsi@archiver.kernel.org>; Fri, 21 May 2021 10:27:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233375AbhEUK2q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 May 2021 06:28:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232748AbhEUK2P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 May 2021 06:28:15 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A178C061346
        for <linux-scsi@vger.kernel.org>; Fri, 21 May 2021 03:26:46 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id v12so10727824plo.10
        for <linux-scsi@vger.kernel.org>; Fri, 21 May 2021 03:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=trD0HR5ofX2zNaBcRboTUg0QwmGCTdH42uzh+rhcgOw=;
        b=S6m1nWrkhwYCWEr+TMUsOGvbgFCkKjuqGxtYUNCDTUMiuadVNgj2IgpA1mqrytWX/B
         yQHyOw3Ke7uPlfIPTOIOEZkZOcEo6s7BZUA/8IyYHwkOgipahJ5J8WJhQ5W0vZq8D0P+
         323YzGxts+ErypQVsNZ8Bb6fXl1wnk2AuF/2U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=trD0HR5ofX2zNaBcRboTUg0QwmGCTdH42uzh+rhcgOw=;
        b=ae6zqpsGa0RHr1uyXXfb+UkO4pxDdd8i6xkTNB2/McqQeP9XQTy1LCQBmeMZb3Q1Ni
         1qs0xWCU7G0cxwICWkbBen/qTXC1dSqDp65PXdjmNA23jTZ8UKZovtfzDHU9NnBRyX14
         TxuzSysLOa077KqCEnIHCBjhV5LVdHjc0ScFENT5TmIcZkR64ZCWPTQpSpBpsKodobUa
         Mx8DzV8LA4K8wNYvHA3qXUkydAc5ARD/ijuybo4xRgJgFbbvWrxJhbI66EuwlFHpLQgu
         aEXVj0G4uh++CnuuVZ4mpWoZGJgZvDQwstpTh/4LlB1ZC36itAkwUI1uhR9pykk5ue0N
         Eplg==
X-Gm-Message-State: AOAM531bXHmt4O60ruapQaTQEnF/+J1ocbJvuHVWHOiu0kOz2J6di4tZ
        S+UvQBIByg5uVDjPgMuWuFvTr5CvVRhI5UYyfjyX786aMvbLELxG5REYVVpjvrRYFqRfmIdRqWX
        qh0GUxgqf0LG7zk0bkB8TmWIA0hCtuGZkn849Et/r7fChJdwmvm92zg2CQGr/soHh0vFgIk9QfM
        OVnbSo7keQHFSuH9E=
X-Google-Smtp-Source: ABdhPJwbfbkYy6QFnvN7f5XReqTU+R+Saz6vExDlV4NPGNOWk2qSocEB37p9bNS4R3gefA/ZgzE5yg==
X-Received: by 2002:a17:902:e8c8:b029:ee:f249:e416 with SMTP id v8-20020a170902e8c8b02900eef249e416mr11352335plg.3.1621592805575;
        Fri, 21 May 2021 03:26:45 -0700 (PDT)
Received: from dhcp-10-123-20-83.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id j3sm4197858pfe.98.2021.05.21.03.26.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 May 2021 03:26:45 -0700 (PDT)
From:   Chandrakanth Patil <chandrakanth.patil@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH v2 4/5] megaraid_sas: Handle missing interrupts while re-enabling IRQs
Date:   Fri, 21 May 2021 15:55:47 +0530
Message-Id: <20210521102548.11156-5-chandrakanth.patil@broadcom.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20210521102548.11156-1-chandrakanth.patil@broadcom.com>
References: <20210521102548.11156-1-chandrakanth.patil@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000002c69bc05c2d47f9b"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000002c69bc05c2d47f9b

While reenabling the IRQ after irq poll there may be a small window for
the firmware to post the replies with interrupts raised. In that case,
driver will not see the interrupts which lead to IOs timeout.

This issue hits only when there is a high IOs completion on a single reply
queue, which forces the driver to switch between the interrupt and IRQ
context.

To fix this, driver will process the reply queue one more time after
enabling the IRQ.

Link: https://lore.kernel.org/linux-scsi/20201102072746.27410-1-sreekanth.reddy@broadcom.com/
Cc: Tomas Henzl <thenzl@redhat.com>
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index f79c19010c92..8b8d68e75318 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -3745,6 +3745,7 @@ static void megasas_sync_irqs(unsigned long instance_addr)
 		if (irq_ctx->irq_poll_scheduled) {
 			irq_ctx->irq_poll_scheduled = false;
 			enable_irq(irq_ctx->os_irq);
+			complete_cmd_fusion(instance, irq_ctx->MSIxIndex, irq_ctx);
 		}
 	}
 }
@@ -3776,6 +3777,7 @@ int megasas_irqpoll(struct irq_poll *irqpoll, int budget)
 		irq_poll_complete(irqpoll);
 		irq_ctx->irq_poll_scheduled = false;
 		enable_irq(irq_ctx->os_irq);
+		complete_cmd_fusion(instance, irq_ctx->MSIxIndex, irq_ctx);
 	}
 
 	return num_entries;
@@ -3792,6 +3794,7 @@ megasas_complete_cmd_dpc_fusion(unsigned long instance_addr)
 {
 	struct megasas_instance *instance =
 		(struct megasas_instance *)instance_addr;
+	struct megasas_irq_context *irq_ctx = NULL;
 	u32 count, MSIxIndex;
 
 	count = instance->msix_vectors > 0 ? instance->msix_vectors : 1;
@@ -3800,8 +3803,10 @@ megasas_complete_cmd_dpc_fusion(unsigned long instance_addr)
 	if (atomic_read(&instance->adprecovery) == MEGASAS_HW_CRITICAL_ERROR)
 		return;
 
-	for (MSIxIndex = 0 ; MSIxIndex < count; MSIxIndex++)
+	for (MSIxIndex = 0 ; MSIxIndex < count; MSIxIndex++) {
+		irq_ctx = &instance->irq_context[MSIxIndex];
 		complete_cmd_fusion(instance, MSIxIndex, NULL);
+	}
 }
 
 /**
-- 
2.18.1


--0000000000002c69bc05c2d47f9b
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
MDIwAgxLE6Al5lQBqzmVPS8wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIPP44f7h
I72EDw5XfRQYqQtCm13Dg3Hv+WhxtOtvidMXMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJ
KoZIhvcNAQkFMQ8XDTIxMDUyMTEwMjY0NlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASow
CwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZI
hvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAiXUGCWEL93KQdUSPBswhYWqMQ
frzCSwiBuh3/zRlNuxpaE1o2eLaMsYI1TT6uFtKLcH4w4fc6znuGHZx13yVpNk2gjsIK1YcKYTUD
PpJY8kJW/lqPLkCeEwJW2U1hqWTic0OFXqKdhfQ2FCFhdcWc4+g5x3GaMHeG4JDxSRffl3Tp9AN2
dJDzjtSgrkzL3GnEKaONrrhHvMyPc4MA4tKjiai5ltfwuMUHVhxozv3/+2mrMq3/k4pVn1Sugnzc
j8zCfuE1ImoX66xtLwPz3oxiVvl3wvmb+8dsl+sA+PNu45QOGjpONFch02liPbUfvB1a+RleFlqO
KB9p2G7AJ62w
--0000000000002c69bc05c2d47f9b--
