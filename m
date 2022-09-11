Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 725F0C6FA86
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Sep 2022 22:15:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbiIKWPd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Sep 2022 18:15:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbiIKWPQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Sep 2022 18:15:16 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0DD313CD2
        for <linux-scsi@vger.kernel.org>; Sun, 11 Sep 2022 15:15:15 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id s18so2034945qtx.6
        for <linux-scsi@vger.kernel.org>; Sun, 11 Sep 2022 15:15:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=JU3vs/7rqX0UJ0IwFjnMfE7xAS/CQpFJrRFbzc/2/qc=;
        b=QyR5Xy0xexiE001I4C4W0U/UoER0usguvkS4sh0QCZtcS6L3y5yZjp5bbfMTQxKD9L
         lqkfjuUCMJ0d+SQ2UlZr8Sgq8qw1G1UnByLWUFRh+opVUhs7mkFHEEgvWtv77WIHfxqs
         gJY234XTc5GLePoKCIhbEiokqzy97ih2RpZBT3kZGEX6QPZeZF8pH7Gli719kWYd0Jke
         B0+XEXrcB/6UC8tASqgUnFJiEyXnlPXMtghuMiCUzApn1sJAoev/UPFugmBlxTufJCYH
         mAUdFiG4QFWxzoRERCIunEFDhJ3YemPsiU3RnJMS6B5DBRc24Ho/hRMSlf0kfF8bOZbb
         EYyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=JU3vs/7rqX0UJ0IwFjnMfE7xAS/CQpFJrRFbzc/2/qc=;
        b=2jIY3TW8NJkJqhrS37j+646k0dw/iGqOUk1xXikJnFOn+3hLr9fhoLU4osOapASISQ
         M4DqsVGCzX0SQZ/PAzqhkct63PM/fzHpW1Vz/MYU3w1DHcDLqrF+7PeAXVly8lAoM3Zp
         9ThYt6ofUEyN+4/JQ3ccRa7cbJpuImCHOg9Isv5PFjAnbYWT+Vus3ArMQtEac2Il3uV0
         67SA+x/23M14gB8lR6sSX831aWNgLLxAlVmeOfOkj8zwvgLbKLOFWK56tg1Ew13MXyC6
         f3zI1KBZc3vMfswtyGVaGxBtimDZUFt5+WjTRhZVgGKVaI05L/mTA7BUzocvnn4I0L8w
         ZS3A==
X-Gm-Message-State: ACgBeo2lHkVfxnTXjrABSjPmY8aqq+czMBlZjfhdqMjc9TwcJDg94AMx
        ALFb/JWVfuDljWr3DLdicHQZMyfyKzk=
X-Google-Smtp-Source: AA6agR7B+OqM5ONjX1h7fU5mHsvArWxE/COihFopjZ3EacANmBUx/mcluS1XkAxrpBz8E+K1Ai90fA==
X-Received: by 2002:a05:622a:1c3:b0:344:56b5:f14b with SMTP id t3-20020a05622a01c300b0034456b5f14bmr21556783qtw.152.1662934514730;
        Sun, 11 Sep 2022 15:15:14 -0700 (PDT)
Received: from localhost.localdomain (ip98-164-255-77.oc.oc.cox.net. [98.164.255.77])
        by smtp.gmail.com with ESMTPSA id x8-20020a05622a000800b0035a70d82d7bsm5324305qtw.47.2022.09.11.15.15.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Sep 2022 15:15:14 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 05/13] lpfc: Fix multiple NVME remoteport registration calls for the same NPort ID
Date:   Sun, 11 Sep 2022 15:14:57 -0700
Message-Id: <20220911221505.117655-6-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220911221505.117655-1-jsmart2021@gmail.com>
References: <20220911221505.117655-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When a target makes the mistake of registering a FC4 type with
the fabric, but then rejects a PRLI of that type, the lpfc driver
incorrectly retries the PRLI causing multiple registrations with
the transport. The driver needs to detect the reject reason data
and stop any retry.

Rework the PRLI reject scenarios.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_disc.h |  1 -
 drivers/scsi/lpfc/lpfc_els.c  | 76 +++++++++++++++++------------------
 drivers/scsi/lpfc/lpfc_hw.h   |  1 +
 3 files changed, 37 insertions(+), 41 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
index fb945692d683..f82615d87c4b 100644
--- a/drivers/scsi/lpfc/lpfc_disc.h
+++ b/drivers/scsi/lpfc/lpfc_disc.h
@@ -187,7 +187,6 @@ struct lpfc_node_rrq {
 #define NLP_RNID_SND       0x00000400	/* sent RNID request for this entry */
 #define NLP_ELS_SND_MASK   0x000007e0	/* sent ELS request for this entry */
 #define NLP_NVMET_RECOV    0x00001000   /* NVMET auditing node for recovery. */
-#define NLP_FCP_PRLI_RJT   0x00002000   /* Rport does not support FCP PRLI. */
 #define NLP_UNREG_INP      0x00008000	/* UNREG_RPI cmd is in progress */
 #define NLP_DROPPED        0x00010000	/* Init ref count has been dropped */
 #define NLP_DELAY_TMO      0x00020000	/* delay timeout is running for node */
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 4c372553e2aa..642d90af4f09 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -2200,10 +2200,6 @@ lpfc_issue_els_plogi(struct lpfc_vport *vport, uint32_t did, uint8_t retry)
 	if (!elsiocb)
 		return 1;
 
-	spin_lock_irq(&ndlp->lock);
-	ndlp->nlp_flag &= ~NLP_FCP_PRLI_RJT;
-	spin_unlock_irq(&ndlp->lock);
-
 	pcmd = (uint8_t *)elsiocb->cmd_dmabuf->virt;
 
 	/* For PLOGI request, remainder of payload is service parameters */
@@ -4676,47 +4672,52 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		}
 		switch (stat.un.b.lsRjtRsnCode) {
 		case LSRJT_UNABLE_TPC:
-			/* The driver has a VALID PLOGI but the rport has
-			 * rejected the PRLI - can't do it now.  Delay
-			 * for 1 second and try again.
-			 *
-			 * However, if explanation is REQ_UNSUPPORTED there's
-			 * no point to retry PRLI.
+			/* Special case for PRLI LS_RJTs. Recall that lpfc
+			 * uses a single routine to issue both PRLI FC4 types.
+			 * If the PRLI is rejected because that FC4 type
+			 * isn't really supported, don't retry and cause
+			 * multiple transport registrations.  Otherwise, parse
+			 * the reason code/reason code explanation and take the
+			 * appropriate action.
 			 */
-			if ((cmd == ELS_CMD_PRLI || cmd == ELS_CMD_NVMEPRLI) &&
-			    stat.un.b.lsRjtRsnCodeExp !=
-			    LSEXP_REQ_UNSUPPORTED) {
-				delay = 1000;
-				maxretry = lpfc_max_els_tries + 1;
-				retry = 1;
-				break;
-			}
-
-			/* Legacy bug fix code for targets with PLOGI delays. */
-			if (stat.un.b.lsRjtRsnCodeExp ==
-			    LSEXP_CMD_IN_PROGRESS) {
+			lpfc_printf_vlog(vport, KERN_INFO,
+					 LOG_DISCOVERY | LOG_ELS | LOG_NODE,
+					 "0153 ELS cmd x%x LS_RJT by x%x. "
+					 "RsnCode x%x RsnCodeExp x%x\n",
+					 cmd, did, stat.un.b.lsRjtRsnCode,
+					 stat.un.b.lsRjtRsnCodeExp);
+
+			switch (stat.un.b.lsRjtRsnCodeExp) {
+			case LSEXP_CANT_GIVE_DATA:
+			case LSEXP_CMD_IN_PROGRESS:
 				if (cmd == ELS_CMD_PLOGI) {
 					delay = 1000;
 					maxretry = 48;
 				}
 				retry = 1;
 				break;
-			}
-			if (stat.un.b.lsRjtRsnCodeExp ==
-			    LSEXP_CANT_GIVE_DATA) {
-				if (cmd == ELS_CMD_PLOGI) {
+			case LSEXP_REQ_UNSUPPORTED:
+			case LSEXP_NO_RSRC_ASSIGN:
+				/* These explanation codes get no retry. */
+				if (cmd == ELS_CMD_PRLI ||
+				    cmd == ELS_CMD_NVMEPRLI)
+					break;
+				fallthrough;
+			default:
+				/* Limit the delay and retry action to a limited
+				 * cmd set.  There are other ELS commands where
+				 * a retry is not expected.
+				 */
+				if (cmd == ELS_CMD_PLOGI ||
+				    cmd == ELS_CMD_PRLI ||
+				    cmd == ELS_CMD_NVMEPRLI) {
 					delay = 1000;
-					maxretry = 48;
+					maxretry = lpfc_max_els_tries + 1;
+					retry = 1;
 				}
-				retry = 1;
-				break;
-			}
-			if (cmd == ELS_CMD_PLOGI) {
-				delay = 1000;
-				maxretry = lpfc_max_els_tries + 1;
-				retry = 1;
 				break;
 			}
+
 			if ((phba->sli3_options & LPFC_SLI3_NPIV_ENABLED) &&
 			  (cmd == ELS_CMD_FDISC) &&
 			  (stat.un.b.lsRjtRsnCodeExp == LSEXP_OUT_OF_RESOURCE)){
@@ -4797,13 +4798,8 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			 */
 			if (stat.un.b.lsRjtRsnCodeExp ==
 			    LSEXP_REQ_UNSUPPORTED) {
-				if (cmd == ELS_CMD_PRLI) {
-					spin_lock_irq(&ndlp->lock);
-					ndlp->nlp_flag |= NLP_FCP_PRLI_RJT;
-					spin_unlock_irq(&ndlp->lock);
-					retry = 0;
+				if (cmd == ELS_CMD_PRLI)
 					goto out_retry;
-				}
 			}
 			break;
 		}
diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
index 071983e2cdfe..cbaf9a0f12c3 100644
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -703,6 +703,7 @@ struct ls_rjt {	/* Structure is in Big Endian format */
 #define LSEXP_OUT_OF_RESOURCE   0x29
 #define LSEXP_CANT_GIVE_DATA    0x2A
 #define LSEXP_REQ_UNSUPPORTED   0x2C
+#define LSEXP_NO_RSRC_ASSIGN    0x52
 			uint8_t vendorUnique;	/* FC Word 0, bit  0: 7 */
 		} b;
 	} un;
-- 
2.35.3

