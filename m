Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E38F2C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 21:40:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4A236139E
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 21:40:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbhJTVm5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Oct 2021 17:42:57 -0400
Received: from mail-pj1-f47.google.com ([209.85.216.47]:54254 "EHLO
        mail-pj1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230494AbhJTVmy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Oct 2021 17:42:54 -0400
Received: by mail-pj1-f47.google.com with SMTP id ls18so3405790pjb.3
        for <linux-scsi@vger.kernel.org>; Wed, 20 Oct 2021 14:40:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dGhXWWCEdMXqbsq/PQWDI2vvIv8qSxaz59TMoXFkcxk=;
        b=FnkSoEOK/c/uxd6wKdSLBaJqCnRQFt5xlQrViRTrbH9fCBkJRxYP+pFTcRyDRvlp/n
         eywB6Vb1OD6CF+DPztlVtAMuw0RzqtTKGtRf36fGFtkNxr/WPaH1j66w8aQi3CJeC4vo
         Q465iwBiBUZMARfKwiAUlx0VjHNsCD3BqnXFv/meEQ5DY3jn15+yWX3A2K8l9gdqhFfg
         4o7x8DWGYyBlthi/CSQ5SAaaCRjSesBZ6wbZLFo+WkSwhEW2dOkaMVDxMjlREZjvNqVJ
         rq1FLA6IGTuJ7pm2XeRQbRjA02WQebBHmdCUG7RsskCRCOehL9D07trMFj1r19Lf3QTJ
         BgWQ==
X-Gm-Message-State: AOAM530gzEPyHqROqJjj/ck0IYDQVXh0lfChuu3+LC7YVqeRjChZqCUG
        fVj59bGzI1t+jGqgVMX5U9g=
X-Google-Smtp-Source: ABdhPJwBnFqW9F/RYxK01cWOupCSHW5h29RFo9IvI/Z3848cCiHz+Ua/PtNAUeuRfTklbBiak8nA1Q==
X-Received: by 2002:a17:902:b213:b0:13e:cd44:b4b5 with SMTP id t19-20020a170902b21300b0013ecd44b4b5mr1459298plr.18.1634766038914;
        Wed, 20 Oct 2021 14:40:38 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:200d:62ea:db33:9047])
        by smtp.gmail.com with ESMTPSA id 21sm6707694pjg.57.2021.10.20.14.40.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 14:40:38 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>, Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH v2 01/10] scsi: ufs: Revert "Retry aborted SCSI commands instead of completing these successfully"
Date:   Wed, 20 Oct 2021 14:40:15 -0700
Message-Id: <20211020214024.2007615-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
In-Reply-To: <20211020214024.2007615-1-bvanassche@acm.org>
References: <20211020214024.2007615-1-bvanassche@acm.org>
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
 drivers/scsi/ufs/ufshcd.c | 33 +++++++++++----------------------
 1 file changed, 11 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 10f5805ae3f6..53dd42f95eed 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5248,11 +5248,9 @@ static irqreturn_t ufshcd_uic_cmd_compl(struct ufs_hba *hba, u32 intr_status)
  * __ufshcd_transfer_req_compl - handle SCSI and query command completion
  * @hba: per adapter instance
  * @completed_reqs: bitmask that indicates which requests to complete
- * @retry_requests: whether to ask the SCSI core to retry completed requests
  */
 static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
-					unsigned long completed_reqs,
-					bool retry_requests)
+					unsigned long completed_reqs)
 {
 	struct ufshcd_lrb *lrbp;
 	struct scsi_cmnd *cmd;
@@ -5268,8 +5266,7 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 			if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))
 				ufshcd_update_monitor(hba, lrbp);
 			ufshcd_add_command_trace(hba, index, UFS_CMD_COMP);
-			result = retry_requests ? DID_BUS_BUSY << 16 :
-				ufshcd_transfer_rsp_status(hba, lrbp);
+			result = ufshcd_transfer_rsp_status(hba, lrbp);
 			scsi_dma_unmap(cmd);
 			cmd->result = result;
 			/* Mark completed command as NULL in LRB */
@@ -5295,14 +5292,12 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
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
@@ -5331,8 +5326,7 @@ static irqreturn_t ufshcd_transfer_req_compl(struct ufs_hba *hba,
 	spin_unlock_irqrestore(&hba->outstanding_lock, flags);
 
 	if (completed_reqs) {
-		__ufshcd_transfer_req_compl(hba, completed_reqs,
-					    retry_requests);
+		__ufshcd_transfer_req_compl(hba, completed_reqs);
 		return IRQ_HANDLED;
 	} else {
 		return IRQ_NONE;
@@ -5831,13 +5825,7 @@ static void ufshcd_exception_event_handler(struct work_struct *work)
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
 
@@ -6186,7 +6174,8 @@ static void ufshcd_err_handler(struct work_struct *work)
 	}
 
 lock_skip_pending_xfer_clear:
-	ufshcd_retry_aborted_requests(hba);
+	/* Complete the requests that are cleared by s/w */
+	ufshcd_complete_requests(hba);
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	hba->silence_err_logs = false;
@@ -6478,7 +6467,7 @@ static irqreturn_t ufshcd_sl_intr(struct ufs_hba *hba, u32 intr_status)
 		retval |= ufshcd_tmc_handler(hba);
 
 	if (intr_status & UTP_TRANSFER_REQ_COMPL)
-		retval |= ufshcd_transfer_req_compl(hba, /*retry_requests=*/false);
+		retval |= ufshcd_transfer_req_compl(hba);
 
 	return retval;
 }
@@ -6898,7 +6887,7 @@ static int ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)
 			err = ufshcd_clear_cmd(hba, pos);
 			if (err)
 				break;
-			__ufshcd_transfer_req_compl(hba, 1U << pos, false);
+			__ufshcd_transfer_req_compl(hba, 1U << pos);
 		}
 	}
 
@@ -7060,7 +7049,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 		dev_err(hba->dev,
 		"%s: cmd was completed, but without a notifying intr, tag = %d",
 		__func__, tag);
-		__ufshcd_transfer_req_compl(hba, 1UL << tag, /*retry_requests=*/false);
+		__ufshcd_transfer_req_compl(hba, 1UL << tag);
 		goto release;
 	}
 
@@ -7126,7 +7115,7 @@ static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
 	ufshpb_reset_host(hba);
 	ufshcd_hba_stop(hba);
 	hba->silence_err_logs = true;
-	ufshcd_retry_aborted_requests(hba);
+	ufshcd_complete_requests(hba);
 	hba->silence_err_logs = false;
 
 	/* scale up clocks to max frequency before full reinitialization */
