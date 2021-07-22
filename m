Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D72AC07E9D
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 03:36:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32A866124B
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 03:36:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbhGVCz2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Jul 2021 22:55:28 -0400
Received: from mail-pj1-f44.google.com ([209.85.216.44]:39551 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231200AbhGVCz1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Jul 2021 22:55:27 -0400
Received: by mail-pj1-f44.google.com with SMTP id k4-20020a17090a5144b02901731c776526so2286790pjm.4
        for <linux-scsi@vger.kernel.org>; Wed, 21 Jul 2021 20:36:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CPTnZvmh5CiGmNU2dDkIwtdfKd25dHm9/RJV51wnB4I=;
        b=EXmVQu9pNOGweIU5QLIY4iPaz3s/S3z6XWw9fJiPC/H3CRhhOtYEvsVwKlVxvOPY1u
         ZYRmk1YsE4eQqgxWA5U6SdqLM76xP/Ul8DBk20Ev8pa8E2CPuw8AVPUk5alfztyAKoWb
         4mnT8+bWh7MvJ1D0Eyw3aS/uFMO09NLcrNQfD222Td712MwMeG2j++YnCgRGhqUaF4LG
         bFB6Ip7EZMyuB76q8ZnD9iX3Q7ncnfsr818QbjJoJzGUUH/xkJcdK75T6CulYJCUECHf
         UD61OxwasczvL4w6lSa4i4jz96IlLp3O2/H4ILg4Z0OG2megNkBMPBFZThIEbw71byGp
         yh8Q==
X-Gm-Message-State: AOAM530MpAfMFF+k7oqwAvX8QrJl4LUTzc/S6vkAPFLTG87I9Fef7QIv
        NUF5OcnjuMcUgGvsKkPTFwo=
X-Google-Smtp-Source: ABdhPJzYRVCkEailPNWgK6rMskUTgVrmw8sjnSMY6yWSeYXsRLld2ZEduvS/QTtA8noD+nW5XCHdLQ==
X-Received: by 2002:a17:902:c40a:b029:12b:45c1:21b5 with SMTP id k10-20020a170902c40ab029012b45c121b5mr30086673plk.17.1626924962845;
        Wed, 21 Jul 2021 20:36:02 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:30e2:954a:f4a0:3224])
        by smtp.gmail.com with ESMTPSA id n6sm32060258pgb.60.2021.07.21.20.36.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 20:36:02 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>
Subject: [PATCH v3 17/18] scsi: ufs: Retry aborted SCSI commands instead of completing these successfully
Date:   Wed, 21 Jul 2021 20:34:38 -0700
Message-Id: <20210722033439.26550-18-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722033439.26550-1-bvanassche@acm.org>
References: <20210722033439.26550-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Neither SAM nor the UFS standard require that the UFS controller fills in
the completion status of commands that have been aborted (LUN RESET aborts
pending commands). Hence do not rely on the completion status provided by
the UFS controller for aborted commands but instead ask the SCSI core to
retry SCSI commands that have been aborted.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Can Guo <cang@codeaurora.org>
Cc: Asutosh Das <asutoshd@codeaurora.org>
Cc: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 35 +++++++++++++++++++++++------------
 1 file changed, 23 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 8d87fb214281..3cfbc467f7c0 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5207,10 +5207,12 @@ static irqreturn_t ufshcd_uic_cmd_compl(struct ufs_hba *hba, u32 intr_status)
 /**
  * __ufshcd_transfer_req_compl - handle SCSI and query command completion
  * @hba: per adapter instance
- * @completed_reqs: requests to complete
+ * @completed_reqs: bitmask that indicates which requests to complete
+ * @retry_requests: whether to ask the SCSI core to retry completed requests
  */
 static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
-					unsigned long completed_reqs)
+					unsigned long completed_reqs,
+					bool retry_requests)
 {
 	struct ufshcd_lrb *lrbp;
 	struct scsi_cmnd *cmd;
@@ -5226,7 +5228,8 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 			if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))
 				ufshcd_update_monitor(hba, lrbp);
 			ufshcd_add_command_trace(hba, index, UFS_CMD_COMP);
-			result = ufshcd_transfer_rsp_status(hba, lrbp);
+			result = retry_requests ? DID_BUS_BUSY << 16 :
+				ufshcd_transfer_rsp_status(hba, lrbp);
 			scsi_dma_unmap(cmd);
 			cmd->result = result;
 			/* Mark completed command as NULL in LRB */
@@ -5252,12 +5255,14 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 /**
  * ufshcd_transfer_req_compl - handle SCSI and query command completion
  * @hba: per adapter instance
+ * @retry_requests: whether or not to ask to retry requests
  *
  * Returns
  *  IRQ_HANDLED - If interrupt is valid
  *  IRQ_NONE    - If invalid interrupt
  */
-static irqreturn_t ufshcd_transfer_req_compl(struct ufs_hba *hba)
+static irqreturn_t ufshcd_transfer_req_compl(struct ufs_hba *hba,
+					     bool retry_requests)
 {
 	unsigned long completed_reqs, flags;
 	u32 tr_doorbell;
@@ -5283,7 +5288,8 @@ static irqreturn_t ufshcd_transfer_req_compl(struct ufs_hba *hba)
 	spin_unlock_irqrestore(&hba->outstanding_lock, flags);
 
 	if (completed_reqs) {
-		__ufshcd_transfer_req_compl(hba, completed_reqs);
+		__ufshcd_transfer_req_compl(hba, completed_reqs,
+					    retry_requests);
 		return IRQ_HANDLED;
 	} else {
 		return IRQ_NONE;
@@ -5762,7 +5768,13 @@ static void ufshcd_exception_event_handler(struct work_struct *work)
 /* Complete requests that have door-bell cleared */
 static void ufshcd_complete_requests(struct ufs_hba *hba)
 {
-	ufshcd_transfer_req_compl(hba);
+	ufshcd_transfer_req_compl(hba, /*retry_requests=*/false);
+	ufshcd_tmc_handler(hba);
+}
+
+static void ufshcd_retry_aborted_requests(struct ufs_hba *hba)
+{
+	ufshcd_transfer_req_compl(hba, /*retry_requests=*/true);
 	ufshcd_tmc_handler(hba);
 }
 
@@ -6082,8 +6094,7 @@ static void ufshcd_err_handler(struct Scsi_Host *host)
 	}
 
 lock_skip_pending_xfer_clear:
-	/* Complete the requests that are cleared by s/w */
-	ufshcd_complete_requests(hba);
+	ufshcd_retry_aborted_requests(hba);
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	hba->silence_err_logs = false;
@@ -6384,7 +6395,7 @@ static irqreturn_t ufshcd_sl_intr(struct ufs_hba *hba, u32 intr_status)
 		retval |= ufshcd_tmc_handler(hba);
 
 	if (intr_status & UTP_TRANSFER_REQ_COMPL)
-		retval |= ufshcd_transfer_req_compl(hba);
+		retval |= ufshcd_transfer_req_compl(hba, /*retry_requests=*/false);
 
 	return retval;
 }
@@ -6803,7 +6814,7 @@ static int ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)
 			err = ufshcd_clear_cmd(hba, pos);
 			if (err)
 				break;
-			__ufshcd_transfer_req_compl(hba, pos);
+			__ufshcd_transfer_req_compl(hba, pos, /*retry_requests=*/true);
 		}
 	}
 
@@ -6965,7 +6976,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 		dev_err(hba->dev,
 		"%s: cmd was completed, but without a notifying intr, tag = %d",
 		__func__, tag);
-		__ufshcd_transfer_req_compl(hba, 1UL << tag);
+		__ufshcd_transfer_req_compl(hba, 1UL << tag, /*retry_requests=*/false);
 		goto release;
 	}
 
@@ -7032,7 +7043,7 @@ static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
 	 */
 	ufshcd_hba_stop(hba);
 	hba->silence_err_logs = true;
-	ufshcd_complete_requests(hba);
+	ufshcd_retry_aborted_requests(hba);
 	hba->silence_err_logs = false;
 
 	/* scale up clocks to max frequency before full reinitialization */
