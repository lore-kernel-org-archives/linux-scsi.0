Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A166C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 21:54:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EEC366109E
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 21:54:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235535AbhJLV4w (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 17:56:52 -0400
Received: from mail-pg1-f169.google.com ([209.85.215.169]:36641 "EHLO
        mail-pg1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232260AbhJLV4v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 17:56:51 -0400
Received: by mail-pg1-f169.google.com with SMTP id 75so381943pga.3
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2021 14:54:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LiruX+gaFvTYyGA2/t12ddUO4dqs2L3X5cwyEoDUAMU=;
        b=6ABrtVV2Bq3ayJD8uBXdeeef08o1EIHFJqFqox8rJP22iSkKKRqFVWhUAjZ8a1/OYb
         fagtUysLgufNBk+o1z0PIFdv1TmvV6h9l/xQR7CcL6q+ujOUJBZPK0FJiEaF37vQrzD0
         9/YDthjjQqXWyGbcquq71fJwyMwrSjKq2hAolCUNmNzTMVR7phYyCeiv7DgP0vyrPlbd
         y3vHztr0aBx/ERowxyq+/yfOaOxdW8OPWIwOS1tCG/2rDdYqLw89/1oSxtnoS1FUolXD
         VVoR1GnawgC5ePmNxZ4ouMBDijVgxZQfM/l2zCvnki3t1pnbA9pigk0jdFnupjFP2hnE
         sHcQ==
X-Gm-Message-State: AOAM532nC35KQDTRBkDrJuy1wbA950ND/UrmK98BCQxiLgRqPgHDn/0f
        SxIOjDp0PPebBuL5SEEemos=
X-Google-Smtp-Source: ABdhPJzjV0Px+H5b6qiP7E0dvZgNDMaHAieqIUwcqJwM33f8temr2NSL9ilHUGVZI5E3g7rudivfIQ==
X-Received: by 2002:a62:8f8e:0:b0:44c:f130:9291 with SMTP id n136-20020a628f8e000000b0044cf1309291mr22148631pfd.19.1634075689412;
        Tue, 12 Oct 2021 14:54:49 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8c1a:acb2:4eff:5d13])
        by smtp.gmail.com with ESMTPSA id m73sm12038730pfd.152.2021.10.12.14.54.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 14:54:48 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>, Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 1/5] scsi: ufs: Revert "Retry aborted SCSI commands instead of completing these successfully"
Date:   Tue, 12 Oct 2021 14:54:29 -0700
Message-Id: <20211012215433.3725777-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211012215433.3725777-1-bvanassche@acm.org>
References: <20211012215433.3725777-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Commit 73dc3c4ac703 ("scsi: ufs: Retry aborted SCSI commands instead of
completing these successfully") is not necessary. If a SCSI command is
aborted successfully the UFS controller has not modified the command
status and the command status still has the value assigned by
ufshcd_prepare_req_desc_hdr(), namely OCS_INVALID_COMMAND_STATUS. The
function ufshcd_transfer_rsp_status() requeues commands that have an
invalid command status. Hence revert commit 73dc3c4ac703.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 35 ++++++++++++-----------------------
 1 file changed, 12 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index d91a405fd181..a89fe61cb8cf 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5266,12 +5266,10 @@ static irqreturn_t ufshcd_uic_cmd_compl(struct ufs_hba *hba, u32 intr_status)
 /**
  * __ufshcd_transfer_req_compl - handle SCSI and query command completion
  * @hba: per adapter instance
- * @completed_reqs: bitmask that indicates which requests to complete
- * @retry_requests: whether to ask the SCSI core to retry completed requests
+ * @completed_reqs: requests to complete
  */
 static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
-					unsigned long completed_reqs,
-					bool retry_requests)
+					unsigned long completed_reqs)
 {
 	struct ufshcd_lrb *lrbp;
 	struct scsi_cmnd *cmd;
@@ -5287,8 +5285,7 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 			if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))
 				ufshcd_update_monitor(hba, lrbp);
 			ufshcd_add_command_trace(hba, index, UFS_CMD_COMP);
-			result = retry_requests ? DID_BUS_BUSY << 16 :
-				ufshcd_transfer_rsp_status(hba, lrbp);
+			result = ufshcd_transfer_rsp_status(hba, lrbp);
 			scsi_dma_unmap(cmd);
 			cmd->result = result;
 			/* Mark completed command as NULL in LRB */
@@ -5314,14 +5311,12 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 /**
  * ufshcd_transfer_req_compl - handle SCSI and query command completion
  * @hba: per adapter instance
- * @retry_requests: whether or not to ask to retry requests
  *
  * Returns
  *  IRQ_HANDLED - If interrupt is valid
  *  IRQ_NONE    - If invalid interrupt
  */
-static irqreturn_t ufshcd_transfer_req_compl(struct ufs_hba *hba,
-					     bool retry_requests)
+static irqreturn_t ufshcd_transfer_req_compl(struct ufs_hba *hba)
 {
 	unsigned long completed_reqs, flags;
 	u32 tr_doorbell;
@@ -5350,8 +5345,7 @@ static irqreturn_t ufshcd_transfer_req_compl(struct ufs_hba *hba,
 	spin_unlock_irqrestore(&hba->outstanding_lock, flags);
 
 	if (completed_reqs) {
-		__ufshcd_transfer_req_compl(hba, completed_reqs,
-					    retry_requests);
+		__ufshcd_transfer_req_compl(hba, completed_reqs);
 		return IRQ_HANDLED;
 	} else {
 		return IRQ_NONE;
@@ -5850,13 +5844,7 @@ static void ufshcd_exception_event_handler(struct work_struct *work)
 /* Complete requests that have door-bell cleared */
 static void ufshcd_complete_requests(struct ufs_hba *hba)
 {
-	ufshcd_transfer_req_compl(hba, /*retry_requests=*/false);
-	ufshcd_tmc_handler(hba);
-}
-
-static void ufshcd_retry_aborted_requests(struct ufs_hba *hba)
-{
-	ufshcd_transfer_req_compl(hba, /*retry_requests=*/true);
+	ufshcd_transfer_req_compl(hba);
 	ufshcd_tmc_handler(hba);
 }
 
@@ -6183,7 +6171,8 @@ static void ufshcd_err_handler(struct Scsi_Host *host)
 	}
 
 lock_skip_pending_xfer_clear:
-	ufshcd_retry_aborted_requests(hba);
+	/* Complete the requests that are cleared by s/w */
+	ufshcd_complete_requests(hba);
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	hba->silence_err_logs = false;
@@ -6493,7 +6482,7 @@ static irqreturn_t ufshcd_sl_intr(struct ufs_hba *hba, u32 intr_status)
 		retval |= ufshcd_tmc_handler(hba);
 
 	if (intr_status & UTP_TRANSFER_REQ_COMPL)
-		retval |= ufshcd_transfer_req_compl(hba, /*retry_requests=*/false);
+		retval |= ufshcd_transfer_req_compl(hba);
 
 	return retval;
 }
@@ -6912,7 +6901,7 @@ static int ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)
 			err = ufshcd_clear_cmd(hba, pos);
 			if (err)
 				break;
-			__ufshcd_transfer_req_compl(hba, pos, /*retry_requests=*/true);
+			__ufshcd_transfer_req_compl(hba, pos);
 		}
 	}
 
@@ -7074,7 +7063,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 		dev_err(hba->dev,
 		"%s: cmd was completed, but without a notifying intr, tag = %d",
 		__func__, tag);
-		__ufshcd_transfer_req_compl(hba, 1UL << tag, /*retry_requests=*/false);
+		__ufshcd_transfer_req_compl(hba, 1UL << tag);
 		goto release;
 	}
 
@@ -7142,7 +7131,7 @@ static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
 	ufshpb_reset_host(hba);
 	ufshcd_hba_stop(hba);
 	hba->silence_err_logs = true;
-	ufshcd_retry_aborted_requests(hba);
+	ufshcd_complete_requests(hba);
 	hba->silence_err_logs = false;
 
 	/* scale up clocks to max frequency before full reinitialization */
