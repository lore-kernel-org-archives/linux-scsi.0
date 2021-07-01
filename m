Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4481DC11F67
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 21:14:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2EB426128A
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 21:14:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234239AbhGAVQe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Jul 2021 17:16:34 -0400
Received: from mail-pg1-f170.google.com ([209.85.215.170]:37878 "EHLO
        mail-pg1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233274AbhGAVQe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jul 2021 17:16:34 -0400
Received: by mail-pg1-f170.google.com with SMTP id t9so7391315pgn.4
        for <linux-scsi@vger.kernel.org>; Thu, 01 Jul 2021 14:14:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E5XEtWvYP8TIaUoT+UrcdfyoMCBR6EzVmjef5NoSi9c=;
        b=jR3y9Ab6lSEkGwwqkQp2V1AGUXUtSco3bixyPZKxonZ/Kv3ZxpWnZJhXKe3T09/xlk
         o735NTXLeb0dst6W4JA6RVl4NDyQoO8wQSBzkYAElM/AC4UWbTjsGwRfhXFeAKZgqKwK
         oCRPXeSHLVEokfcNeVKMpTjvhbjZLdDzTmjto/BfXT+gGqeT9WoyalwNoLRfZIVTj6ZV
         HPDsxT99kW5r0ocesqWSpG/WB9ia106bLZdC25qkWJgDFfS53pCkkmL4m3Z0xqog5M0V
         0GIfhIjxtfj5NVJ/tqcpqKtIalds72ma+JNKmhzxe4VrbmWJ9QaJtsmouv6q5lHY6eKB
         pchQ==
X-Gm-Message-State: AOAM533ELbzOnIIh9brsd8X9kxVHM2pR5l3T+d4vZ2XzpxSBtuLo+aez
        PEPBEdicK4h+paBLYCY90Qg=
X-Google-Smtp-Source: ABdhPJxWq9gX2cB8k7lhfYyvb91oNkcNs7MBRdnCTSbXgrssTi5panlx2hCSyzJ70oz/omZBuoXEBQ==
X-Received: by 2002:a63:da0a:: with SMTP id c10mr1480485pgh.255.1625174042117;
        Thu, 01 Jul 2021 14:14:02 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:6a75:b07:a0d:8bd5])
        by smtp.gmail.com with ESMTPSA id k25sm900832pfa.213.2021.07.01.14.13.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 14:14:00 -0700 (PDT)
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
Subject: [PATCH 21/21] ufs: Retry aborted SCSI commands instead of completing these successfully
Date:   Thu,  1 Jul 2021 14:12:24 -0700
Message-Id: <20210701211224.17070-22-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210701211224.17070-1-bvanassche@acm.org>
References: <20210701211224.17070-1-bvanassche@acm.org>
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
index cfb2d00c325c..72dea37c9f17 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5198,10 +5198,12 @@ static irqreturn_t ufshcd_uic_cmd_compl(struct ufs_hba *hba, u32 intr_status)
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
@@ -5217,7 +5219,8 @@ static void ufshcd_transfer_req_compl(struct ufs_hba *hba,
 			if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))
 				ufshcd_update_monitor(hba, lrbp);
 			ufshcd_add_command_trace(hba, index, UFS_CMD_COMP);
-			result = ufshcd_transfer_rsp_status(hba, lrbp);
+			result = retry_requests ? DID_BUS_BUSY << 16 :
+				ufshcd_transfer_rsp_status(hba, lrbp);
 			scsi_dma_unmap(cmd);
 			cmd->result = result;
 			/* Mark completed command as NULL in LRB */
@@ -5243,13 +5246,15 @@ static void ufshcd_transfer_req_compl(struct ufs_hba *hba,
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
 	unsigned long completed_reqs = 0;
 	unsigned long flags;
@@ -5285,7 +5290,7 @@ static irqreturn_t ufshcd_trc_handler(struct ufs_hba *hba, bool use_utrlcnr)
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
 	if (completed_reqs) {
-		ufshcd_transfer_req_compl(hba, completed_reqs);
+		ufshcd_transfer_req_compl(hba, completed_reqs, retry_requests);
 		return IRQ_HANDLED;
 	} else {
 		return IRQ_NONE;
@@ -5764,7 +5769,14 @@ static void ufshcd_exception_event_handler(struct work_struct *work)
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
 
@@ -6083,8 +6095,7 @@ static void ufshcd_err_handler(struct Scsi_Host *host)
 	}
 
 lock_skip_pending_xfer_clear:
-	/* Complete the requests that are cleared by s/w */
-	ufshcd_complete_requests(hba);
+	ufshcd_retry_aborted_requests(hba);
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	hba->silence_err_logs = false;
@@ -6385,7 +6396,8 @@ static irqreturn_t ufshcd_sl_intr(struct ufs_hba *hba, u32 intr_status)
 		retval |= ufshcd_tmc_handler(hba);
 
 	if (intr_status & UTP_TRANSFER_REQ_COMPL)
-		retval |= ufshcd_trc_handler(hba, ufshcd_use_utrlcnr(hba));
+		retval |= ufshcd_trc_handler(hba, /*retry_requests=*/false,
+					     ufshcd_use_utrlcnr(hba));
 
 	return retval;
 }
@@ -6803,7 +6815,8 @@ static int ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)
 			err = ufshcd_clear_cmd(hba, pos);
 			if (err)
 				break;
-			ufshcd_transfer_req_compl(hba, pos);
+			ufshcd_transfer_req_compl(hba, pos,
+						  /*retry_requests=*/true);
 		}
 	}
 
@@ -6963,7 +6976,8 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 		dev_err(hba->dev,
 		"%s: cmd was completed, but without a notifying intr, tag = %d",
 		__func__, tag);
-		ufshcd_transfer_req_compl(hba, 1UL << tag);
+		ufshcd_transfer_req_compl(hba, 1UL << tag,
+					  /*retry_requests=*/false);
 		goto release;
 	}
 
@@ -7026,7 +7040,7 @@ static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
 	 */
 	ufshcd_hba_stop(hba);
 	hba->silence_err_logs = true;
-	ufshcd_complete_requests(hba);
+	ufshcd_retry_aborted_requests(hba);
 	hba->silence_err_logs = false;
 
 	/* scale up clocks to max frequency before full reinitialization */
