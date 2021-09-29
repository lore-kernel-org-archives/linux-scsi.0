Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8964C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 12:41:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6AB761406
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 12:41:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343874AbhI2Mm6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 08:42:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343839AbhI2Mm5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 08:42:57 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8A0FC06161C
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 05:41:16 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id n18so2539572pgm.12
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 05:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5AxNibumVQwdFWj4YbAxjEyvCaj9DuKN4ka6CCBZ+yY=;
        b=Uj5ByApOxjJ50YqYxams2yYm2iwHwSlskFLHf/jb5lOcY4bDY+2qakRhjEnyGn77BI
         5g4ZjbK36PwY6T4E9VjPOGovf+W+EDM+e+dlVmuQdDC8rob1+V05QQEAmCw2k3M+mzfg
         K4cEEChgYXX+gq7xrqwimLzsUOeo6MBTzdwcM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5AxNibumVQwdFWj4YbAxjEyvCaj9DuKN4ka6CCBZ+yY=;
        b=YBslGuQ2ba2eg8cQHXSt7+pqaENDRo/Kp2X+4jjyAeH+LjOZ2fEwoGV6s1mHyNhdVT
         bphZI3qvMpZdJkRnwAUWSZyM9ZL4b/EwaQ99lgbMYsZLmPumeFLS0Y6gkTgw5koyf+06
         MSQJvzIQAzaLBx/i2kq0n9ZnNmoQgHVlj+22gqUMhxrAGtHrkZnaMUjsNHrcSt7nghI0
         esxHn9k/mNBJOQ19pfSQfifYK0+nv8HbcxHvP2rIEyWh7A1C9c7BLtUqefzFjsc5r/Ud
         vdMB7dumZFjPkkjLR7sf8uusa9Ks6WSF0amVIykENVeZdwvePnUnazuCZDEU4YXV+rs+
         6GDA==
X-Gm-Message-State: AOAM5336e9Iz5TBY2WHu5ImE9ABhxkE86lwq+eFs8NGTAxV+tDLGFTRI
        g8EwwSmn3you8d8VkwwMWZksTKs8m9Oofbvfo0mupApEqP2RdsGky97FqhPQNVrOk/tgQk2K1yC
        lGZcTWMa44fMaOmwLgEDpTvkiXfFx6FUDVQcn6qXTB1HA+KUuCtfBgVSVnvZci6px8toZyixXX3
        IvJlIyFCY=
X-Google-Smtp-Source: ABdhPJy6wo03r5Gf23A9Aat/Wgoelf05/7QtAsjBhPtU7txRSJ+8AfB2LMWOn+QER3n816BkBAUQsw==
X-Received: by 2002:a63:d351:: with SMTP id u17mr9315667pgi.174.1632919275583;
        Wed, 29 Sep 2021 05:41:15 -0700 (PDT)
Received: from dhcp-10-123-20-83.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id g9sm2528080pfh.13.2021.09.29.05.41.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 05:41:15 -0700 (PDT)
From:   Sumit Saxena <sumit.saxena@broadcom.com>
To:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com
Cc:     chandrakanth.patil@broadcom.com, kashyap.desai@broadcom.com,
        Sumit Saxena <sumit.saxena@broadcom.com>
Subject: [PATCH 1/3] megaraid_sas: fix concurrent access to ISR between IRQ polling and real interrupt
Date:   Wed, 29 Sep 2021 18:10:20 +0530
Message-Id: <20210929124022.24605-2-sumit.saxena@broadcom.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20210929124022.24605-1-sumit.saxena@broadcom.com>
References: <20210929124022.24605-1-sumit.saxena@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000684ce005cd21a59c"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000684ce005cd21a59c

IRQ polling thread calls ISR after enable_irq() to handle any missed IO
completion. atomic flag "in_used" was added to have the synchronization
between the IRQ polling thread and the interrupt context.
There is a bug around it leading to a race condition.

Below is the sequence:
-IRQ polling thread accesses ISR, fetches the reply descriptor.
-Real interrupt arrives and pre-empts polling thread(see enable_irq()
 is already called).
-Interrupt context picks the same reply descriptor as fetched by polling
 thread, processes it, and exits.
-Polling thread resumes and processes the descriptor which is already
 processed by interrupt thread leads to kernel crash.

Setting the "in_used" flag before fetching the reply descriptor ensures
synchronized access to ISR.

Link: https://www.spinics.net/lists/linux-scsi/msg159440.html
Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
Fixes: 9bedd36e9146 (scsi: megaraid_sas: Handle missing interrupts while re-enabling IRQs)
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 26d0cf9353dd..eb5ceb75a15e 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -3530,6 +3530,9 @@ complete_cmd_fusion(struct megasas_instance *instance, u32 MSIxIndex,
 	if (atomic_read(&instance->adprecovery) == MEGASAS_HW_CRITICAL_ERROR)
 		return IRQ_HANDLED;
 
+	if (irq_context && !atomic_add_unless(&irq_context->in_used, 1, 1))
+		return 0;
+
 	desc = fusion->reply_frames_desc[MSIxIndex] +
 				fusion->last_reply_idx[MSIxIndex];
 
@@ -3540,11 +3543,11 @@ complete_cmd_fusion(struct megasas_instance *instance, u32 MSIxIndex,
 	reply_descript_type = reply_desc->ReplyFlags &
 		MPI2_RPY_DESCRIPT_FLAGS_TYPE_MASK;
 
-	if (reply_descript_type == MPI2_RPY_DESCRIPT_FLAGS_UNUSED)
+	if (reply_descript_type == MPI2_RPY_DESCRIPT_FLAGS_UNUSED) {
+		if (irq_context)
+			atomic_dec(&irq_context->in_used);
 		return IRQ_NONE;
-
-	if (irq_context && !atomic_add_unless(&irq_context->in_used, 1, 1))
-		return 0;
+	}
 
 	num_completed = 0;
 
-- 
2.18.1


--000000000000684ce005cd21a59c
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
GmgWG68YahkDuVSTTt2beZdyMeDwq/KifJFo18EkhcL3e7rmDAh8SniUI/0o3HX6hrgdmUI1wSdz
uIVL/m6Ok9mIl2U5kvguitOSC0bVaQPfNzlj+7PCKBECAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZc3VtaXQuc2F4ZW5hQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUNz+JSIXEXl2uQ4Utcnx7FnFi
hhowDQYJKoZIhvcNAQELBQADggEBAL0HLbxgPSW4BFbbIMN3A/ifBg4Lzaph8ARJOnZpGQivo9jG
kQOd95knQi9Lm95JlBAJZCqXXj7QS+dnE71tsFeHWcHNNxHrTSwn4Xi5EqaRjLC6g4IEPyZHWDrD
zzJidgfwQvfZONkf4IXnnrIEFle+26/gPs2kOjCeLMo6XGkNC4HNla1ol1htToQaNN8974pCqwIC
rTXcWqD03VkqSOo+oPP/NAgFAZVfpeuBoK2Xv8zYlrF49Q4hxgFpWhaiDsZUSdWIS7vg1ak1n+6L
3aHRY/lheSkOn/uJWXsqsTDp613hVtOTEDsHSQK32yTGr8jN/oRQgJASuUqQFdD4VzAxggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwoQTpBmhDxj9JoN1ow
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIEAgJlWax7IBLIut92D13SI6YSwHYGDo
r7Tgl/+bMX2dMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDky
OTEyNDExNlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQCLq1V36mWsbYsMcH9UagPBYnszR+id+ACTdvz4TAIudyk5BA18
c4CP/ZpudJrJk3sB9OsAUjSDnvx+97GniTVUczFNHn/+XxU+sOankh2bYjlmcKNFibexEdVY7dV5
IZrQav8kKZX79g3LnCwf8XMDc3WJ+Esplm8SLEXUJlRAKx7fHSpQj5f+coTHzjPF4y2m303W2twX
tsiiqS499rnj0i6mtvl+VymxRoiieYPgxwVHWxlhAectidicUVG6KSz7K/uL0C10280qIQ8oDgu4
6ZFGmqsNljKtJb5haqTFDBQR7CKEceIT0qq9e2k9DyedE8udnbPvBDYxC0xvuxJs
--000000000000684ce005cd21a59c--
