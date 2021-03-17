Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MIME_HEADER_CTYPE_ONLY,
	SPF_HELO_NONE,SPF_PASS,T_TVD_MIME_NO_HEADERS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A404C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 19:10:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CAF2964F53
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 19:10:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233053AbhCQTJl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 15:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233082AbhCQTJ2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 15:09:28 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CADDC06174A
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 12:09:28 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id 205so176873pgh.9
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 12:09:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=o+bG5rBdd14xaeDgDoPWCsLWtA4YXQ0HW9pZ0TH1P8U=;
        b=ImXm0qx8duLdeotAVMKxJH+q9JdcvgSp6UWK3Qqpyw5edhQXS1+clfcb2rSPe/WDPA
         0cKZyxH5/bsos5SKttAGpuVQhiM1QGy4cSfHL7+0b+lqIDyQKAb6qs/XjB8TBtQz6C1D
         3DhmQ8TOnssneYnFy8A7pyft0rZD55fq3wZ6U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=o+bG5rBdd14xaeDgDoPWCsLWtA4YXQ0HW9pZ0TH1P8U=;
        b=qwA6MZgRHZX0O3neYwheKCHmLDGg9bOEsAe7+DYYZb9TIONdfOklpn0WwuBOnFuBb/
         cK1st3xRA2nrGXifMb066t5ln92j7265dzm7kJaA8gwZPdsc9oaxtHB2ZUGnTeopwm6X
         auRpBA2+NF3y/ii44vADnuaadYLucQQEIe//44Da+ur9MllNt5oQh88b/75c4ZlproVT
         Sgzt0HJ05dFTxsywmjJUvb5K91qxApAsodl3aPVGVoxWcx83VxxAaxyuMF1+OFP6w6xq
         XqQmiQdChhekhT7h95ds6rRaepSBUVMY07OO9I6z0/5zI4xRU5rPQ94XgmcatwvDfRPB
         iJpA==
X-Gm-Message-State: AOAM532ig7g66pNK9K0pvHtkQaUnfrYSxC2ARRjaBahGH/7/7WSRvjLF
        +BGi9jP5NeE5gK5qsa5FZ5/OatmYoVtqZYmZD+dFom2obmq+ZPGGmmz8ilXc4nMmI9ghc4jWF09
        r1BwO5KaPYrDcW6AAhamEW68BFUoMPIP73cnz8WKJE4Hum266NnuJ/3u8ac6+q8Z0nMpzR4WxtB
        h/KLuGz5aLorM6
X-Google-Smtp-Source: ABdhPJx1P9uI09wtZhrqXB5FkG4+Ys2vEOp/mFaY0fmIkG5XJfcu6zGC7sCDoWHltTb76ub4rFXS8w==
X-Received: by 2002:a63:471f:: with SMTP id u31mr3870022pga.252.1616008167205;
        Wed, 17 Mar 2021 12:09:27 -0700 (PDT)
Received: from dhcp-10-123-20-75.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id w2sm20569437pgh.54.2021.03.17.12.09.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 12:09:26 -0700 (PDT)
From:   Chandrakanth Patil <chandrakanth.patil@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        kiran-kumar.kasturi@broadcom.com, sankar.patra@broadcom.com,
        sasikumar.pc@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
        anand.lodnoor@broadcom.com,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH 4/5] megaraid_sas: Handle missing interrupts while re-enabling IRQs
Date:   Thu, 18 Mar 2021 00:38:23 +0530
Message-Id: <20210317190824.3050-5-chandrakanth.patil@broadcom.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20210317190824.3050-1-chandrakanth.patil@broadcom.com>
References: <20210317190824.3050-1-chandrakanth.patil@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000ca606605bdc03842"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000ca606605bdc03842

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
 drivers/scsi/megaraid/megaraid_sas.h        |  1 +
 drivers/scsi/megaraid/megaraid_sas_base.c   |  2 ++
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 22 +++++++++++++++------
 3 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index d7185aa21eb5..689bc519b4c5 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -2213,6 +2213,7 @@ struct megasas_irq_context {
 	struct irq_poll irqpoll;
 	bool irq_poll_scheduled;
 	bool irq_line_enable;
+	atomic_t in_use;
 };
 
 struct MR_DRV_SYSTEM_INFO {
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index f3716f7e1d10..a3584b507749 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -5630,6 +5630,7 @@ megasas_setup_irqs_ioapic(struct megasas_instance *instance)
 	pdev = instance->pdev;
 	instance->irq_context[0].instance = instance;
 	instance->irq_context[0].MSIxIndex = 0;
+	atomic_set(&instance->irq_context[0].in_use, 0);
 	snprintf(instance->irq_context->name, MEGASAS_MSIX_NAME_LEN, "%s%u",
 		"megasas", instance->host->host_no);
 	if (request_irq(pci_irq_vector(pdev, 0),
@@ -5666,6 +5667,7 @@ megasas_setup_irqs_msix(struct megasas_instance *instance, u8 is_probe)
 	for (i = 0; i < instance->msix_vectors; i++) {
 		instance->irq_context[i].instance = instance;
 		instance->irq_context[i].MSIxIndex = i;
+		atomic_set(&instance->irq_context[i].in_use, 0);
 		snprintf(instance->irq_context[i].name, MEGASAS_MSIX_NAME_LEN, "%s%u-msix%u",
 			"megasas", instance->host->host_no, i);
 		if (request_irq(pci_irq_vector(pdev, i),
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 54f8a8073ca0..d151d2e0b1c8 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -3478,7 +3478,7 @@ complete_cmd_fusion(struct megasas_instance *instance, u32 MSIxIndex,
 	struct fusion_context *fusion;
 	struct megasas_cmd *cmd_mfi;
 	struct megasas_cmd_fusion *cmd_fusion;
-	u16 smid, num_completed;
+	u16 smid, num_completed = 0;
 	u8 reply_descript_type, *sense, status, extStatus;
 	u32 device_id, data_length;
 	union desc_value d_val;
@@ -3493,6 +3493,9 @@ complete_cmd_fusion(struct megasas_instance *instance, u32 MSIxIndex,
 	if (atomic_read(&instance->adprecovery) == MEGASAS_HW_CRITICAL_ERROR)
 		return IRQ_HANDLED;
 
+	if (!atomic_add_unless(&irq_context->in_use, 1, 1))
+		return num_completed;
+
 	desc = fusion->reply_frames_desc[MSIxIndex] +
 				fusion->last_reply_idx[MSIxIndex];
 
@@ -3503,10 +3506,10 @@ complete_cmd_fusion(struct megasas_instance *instance, u32 MSIxIndex,
 	reply_descript_type = reply_desc->ReplyFlags &
 		MPI2_RPY_DESCRIPT_FLAGS_TYPE_MASK;
 
-	if (reply_descript_type == MPI2_RPY_DESCRIPT_FLAGS_UNUSED)
+	if (reply_descript_type == MPI2_RPY_DESCRIPT_FLAGS_UNUSED) {
+		atomic_dec(&irq_context->in_use);
 		return IRQ_NONE;
-
-	num_completed = 0;
+	}
 
 	while (d_val.u.low != cpu_to_le32(UINT_MAX) &&
 	       d_val.u.high != cpu_to_le32(UINT_MAX)) {
@@ -3619,6 +3622,7 @@ complete_cmd_fusion(struct megasas_instance *instance, u32 MSIxIndex,
 					irq_context->irq_line_enable = true;
 					irq_poll_sched(&irq_context->irqpoll);
 				}
+				atomic_dec(&irq_context->in_use);
 				return num_completed;
 			}
 		}
@@ -3636,6 +3640,7 @@ complete_cmd_fusion(struct megasas_instance *instance, u32 MSIxIndex,
 				instance->reply_post_host_index_addr[0]);
 		megasas_check_and_restore_queue_depth(instance);
 	}
+	atomic_dec(&irq_context->in_use);
 	return num_completed;
 }
 
@@ -3676,6 +3681,7 @@ static void megasas_sync_irqs(unsigned long instance_addr)
 		if (irq_ctx->irq_poll_scheduled) {
 			irq_ctx->irq_poll_scheduled = false;
 			enable_irq(irq_ctx->os_irq);
+			complete_cmd_fusion(instance, irq_ctx->MSIxIndex, irq_ctx);
 		}
 	}
 }
@@ -3707,6 +3713,7 @@ int megasas_irqpoll(struct irq_poll *irqpoll, int budget)
 		irq_poll_complete(irqpoll);
 		irq_ctx->irq_poll_scheduled = false;
 		enable_irq(irq_ctx->os_irq);
+		complete_cmd_fusion(instance, irq_ctx->MSIxIndex, irq_ctx);
 	}
 
 	return num_entries;
@@ -3723,6 +3730,7 @@ megasas_complete_cmd_dpc_fusion(unsigned long instance_addr)
 {
 	struct megasas_instance *instance =
 		(struct megasas_instance *)instance_addr;
+	struct megasas_irq_context *irq_ctx;
 	u32 count, MSIxIndex;
 
 	count = instance->msix_vectors > 0 ? instance->msix_vectors : 1;
@@ -3731,8 +3739,10 @@ megasas_complete_cmd_dpc_fusion(unsigned long instance_addr)
 	if (atomic_read(&instance->adprecovery) == MEGASAS_HW_CRITICAL_ERROR)
 		return;
 
-	for (MSIxIndex = 0 ; MSIxIndex < count; MSIxIndex++)
-		complete_cmd_fusion(instance, MSIxIndex, NULL);
+	for (MSIxIndex = 0 ; MSIxIndex < count; MSIxIndex++) {
+		irq_ctx = &instance->irq_context[MSIxIndex];
+		complete_cmd_fusion(instance, MSIxIndex, irq_ctx);
+	}
 }
 
 /**
-- 
2.18.1


--000000000000ca606605bdc03842
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
MDIwAgxLE6Al5lQBqzmVPS8wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEILMfMCpI
MnOfl99V0LYcxZir89f8C4dgw7H+eew6t5zpMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJ
KoZIhvcNAQkFMQ8XDTIxMDMxNzE5MDkyN1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASow
CwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZI
hvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQBD5UlP//aCYTGcaDm+ab8SL8Fw
DTk+vX3q13+/rQM3NIxCQ/Ehbb48skp2QYZReXUVAV3eko1l4KRpgX46UUA3b3oA8r9Yb+hygp3x
STwTsfzecelLwTm1O8f8VqYdiycK58M98o95Kz6ieSk9QMt+kwbM/UOPp3ekf/VtEAJjHmkWVPoC
NXdkwLQTkeAZ+x1KKQH4JVm5Iyd2Wg5HcImAW/Q9K9Cj4x1knGGzqN3L2wg8HgmAQtKnuTXCgV7B
9vwsws+ULd4QYGI3l1+K8xy3+5XfpvcxMOPKgt+aOHRNmFQxArkc6+z2mfqaPEo0u0ILs8HoXnfB
eDlLFJOus92T
--000000000000ca606605bdc03842--
