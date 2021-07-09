Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10243C07E99
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 20:28:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC910613CA
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 20:28:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230441AbhGIUao (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Jul 2021 16:30:44 -0400
Received: from mail-pf1-f170.google.com ([209.85.210.170]:38906 "EHLO
        mail-pf1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbhGIUao (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jul 2021 16:30:44 -0400
Received: by mail-pf1-f170.google.com with SMTP id j9so4125677pfc.5
        for <linux-scsi@vger.kernel.org>; Fri, 09 Jul 2021 13:28:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yIqcARBqiGZX6Ca+A19nIR5VcgpsR9u3VP5zuFHwlX4=;
        b=L4KpIIQhVkCvonxUP2/xSdXWwOQaWJe+GZRzILTCXzx936LDLxqN5X05h28v6PVvX0
         icLAzbSN+SOntXJC2z+XzQsGpNlwj2WnIuUScULkXn01A1MGnZWJTw1vxrXRtZ5xgbG2
         vJnBronIY8YrlxuqfamAY7w+tzx9O1jJqcx9pwFeHX6cWCMVjb+BZ+Vjd/tvCRb/r9Rv
         0XQL9RuMUILEoFYS1Xa6uONlYvi5bEb+A1atP71VnlBFB9BwuCqb9HkPXIypm97G2ARN
         pvx5QQYNSHWxlzpqV+fulPh/G/nvJCAHspsU4n8d4OhpJpBn6Eyj9ZV4bYvaXxH+/bZA
         oizw==
X-Gm-Message-State: AOAM530Asng790z/0wqgXAG3gYglWCBUMWvq/FBEQ633MtmhqFZFyW5E
        i9PduOSnnD+oON7/L3blIzk=
X-Google-Smtp-Source: ABdhPJysOAuKCh/VE9K/BqoBsP1DL1/sutZzKYvXBEi0nK1sVVOFr/1tGa9M6U+fOzzJtx62GzEgmQ==
X-Received: by 2002:a63:f306:: with SMTP id l6mr40590868pgh.46.1625862479994;
        Fri, 09 Jul 2021 13:27:59 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:eeaf:c266:e6cc:b591])
        by smtp.gmail.com with ESMTPSA id e16sm8812927pgl.54.2021.07.09.13.27.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jul 2021 13:27:59 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>
Subject: [PATCH v2 18/19] scsi: ufs: Retry aborted SCSI commands instead of completing these successfully
Date:   Fri,  9 Jul 2021 13:26:37 -0700
Message-Id: <20210709202638.9480-20-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709202638.9480-1-bvanassche@acm.org>
References: <20210709202638.9480-1-bvanassche@acm.org>
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
 drivers/scsi/ufs/ufshcd.c | 38 ++++++++++++++++++++++++++------------
 1 file changed, 26 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index ae21240a6548..46126964669d 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5202,10 +5202,12 @@ static irqreturn_t ufshcd_uic_cmd_compl(struct ufs_hba *hba, u32 intr_status)
 /**
  * ufshcd_transfer_req_compl - handle SCSI and query command completion
  * @hba: per adapter instance
- * @completed_reqs: requests to complete
+ * @completed_reqs: bitmask that indicates which requests to complete
+ * @retry_requests: whether to ask the SCSI core to retry completed requests
  */
 static void ufshcd_transfer_req_compl(struct ufs_hba *hba,
-				      unsigned long completed_reqs)
+				      unsigned long completed_reqs,
+				      bool retry_requests)
 {
 	struct ufshcd_lrb *lrbp;
 	struct scsi_cmnd *cmd;
@@ -5221,7 +5223,8 @@ static void ufshcd_transfer_req_compl(struct ufs_hba *hba,
 			if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))
 				ufshcd_update_monitor(hba, lrbp);
 			ufshcd_add_command_trace(hba, index, UFS_CMD_COMP);
-			result = ufshcd_transfer_rsp_status(hba, lrbp);
+			result = retry_requests ? DID_BUS_BUSY << 16 :
+				ufshcd_transfer_rsp_status(hba, lrbp);
 			scsi_dma_unmap(cmd);
 			cmd->result = result;
 			/* Mark completed command as NULL in LRB */
@@ -5247,13 +5250,15 @@ static void ufshcd_transfer_req_compl(struct ufs_hba *hba,
 /**
  * ufshcd_trc_handler - handle transfer requests completion
  * @hba: per adapter instance
+ * @retry_requests: whether or not to ask to retry requests
  * @use_utrlcnr: get completed requests from UTRLCNR
  *
  * Returns
  *  IRQ_HANDLED - If interrupt is valid
  *  IRQ_NONE    - If invalid interrupt
  */
-static irqreturn_t ufshcd_trc_handler(struct ufs_hba *hba, bool use_utrlcnr)
+static irqreturn_t ufshcd_trc_handler(struct ufs_hba *hba, bool retry_requests,
+				      bool use_utrlcnr)
 {
 	unsigned long completed_reqs;
 	unsigned long flags;
@@ -5289,7 +5294,7 @@ static irqreturn_t ufshcd_trc_handler(struct ufs_hba *hba, bool use_utrlcnr)
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
 	if (completed_reqs) {
-		ufshcd_transfer_req_compl(hba, completed_reqs);
+		ufshcd_transfer_req_compl(hba, completed_reqs, retry_requests);
 		return IRQ_HANDLED;
 	} else {
 		return IRQ_NONE;
@@ -5768,7 +5773,14 @@ static void ufshcd_exception_event_handler(struct work_struct *work)
 /* Complete requests that have door-bell cleared */
 static void ufshcd_complete_requests(struct ufs_hba *hba)
 {
-	ufshcd_trc_handler(hba, false);
+	ufshcd_trc_handler(hba, /*retry_requests=*/false,
+			   /*use_utrlcnr=*/false);
+	ufshcd_tmc_handler(hba);
+}
+
+static void ufshcd_retry_aborted_requests(struct ufs_hba *hba)
+{
+	ufshcd_trc_handler(hba, /*retry_requests=*/true, /*use_utrlcnr=*/false);
 	ufshcd_tmc_handler(hba);
 }
 
@@ -6088,8 +6100,7 @@ static void ufshcd_err_handler(struct Scsi_Host *host)
 	}
 
 lock_skip_pending_xfer_clear:
-	/* Complete the requests that are cleared by s/w */
-	ufshcd_complete_requests(hba);
+	ufshcd_retry_aborted_requests(hba);
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	hba->silence_err_logs = false;
@@ -6390,7 +6401,8 @@ static irqreturn_t ufshcd_sl_intr(struct ufs_hba *hba, u32 intr_status)
 		retval |= ufshcd_tmc_handler(hba);
 
 	if (intr_status & UTP_TRANSFER_REQ_COMPL)
-		retval |= ufshcd_trc_handler(hba, ufshcd_use_utrlcnr(hba));
+		retval |= ufshcd_trc_handler(hba, /*retry_requests=*/false,
+					     ufshcd_use_utrlcnr(hba));
 
 	return retval;
 }
@@ -6804,7 +6816,8 @@ static int ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)
 			err = ufshcd_clear_cmd(hba, pos);
 			if (err)
 				break;
-			ufshcd_transfer_req_compl(hba, pos);
+			ufshcd_transfer_req_compl(hba, pos,
+						  /*retry_requests=*/true);
 		}
 	}
 
@@ -6966,7 +6979,8 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 		dev_err(hba->dev,
 		"%s: cmd was completed, but without a notifying intr, tag = %d",
 		__func__, tag);
-		ufshcd_transfer_req_compl(hba, 1UL << tag);
+		ufshcd_transfer_req_compl(hba, 1UL << tag,
+					  /*retry_requests=*/false);
 		goto release;
 	}
 
@@ -7032,7 +7046,7 @@ static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
 	 */
 	ufshcd_hba_stop(hba);
 	hba->silence_err_logs = true;
-	ufshcd_complete_requests(hba);
+	ufshcd_retry_aborted_requests(hba);
 	hba->silence_err_logs = false;
 
 	/* scale up clocks to max frequency before full reinitialization */
