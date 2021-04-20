Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9618C43461
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:14:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E42861107
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:14:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233659AbhDTCO5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 22:14:57 -0400
Received: from mail-pj1-f42.google.com ([209.85.216.42]:51128 "EHLO
        mail-pj1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233599AbhDTCOx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 22:14:53 -0400
Received: by mail-pj1-f42.google.com with SMTP id u11so15345394pjr.0
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 19:14:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2GtDDfBMucAFGKNoI0Xt/lHRGGQZ4imRbnvbPSbqrdc=;
        b=i+fO9L5WHX8qQerLsZEWyjRNqQPvEv8wvlowYHi3UN6RCyqSvN1FUL2wKW5ndyohrb
         qXjzXj8uzb7ynfg/sB+Pqnuii9IgX/rz6V58mxnMf3PTcXQQPDifMC+why38T1fM1k3R
         57HUVcMowPAjqENTvdT+lj+lVgdaHSyzE1lzs9xPZ+9ITzqT1dXLo0yZCiatqWmfmo4H
         RlHwPm5PG4EqdxAXT/WWeK1p4ymiYLWa7WEVWyVpbl/cyggqql46NCnD8ToHg3bvWZb/
         vvATlaxkQUK22iT17AU/6fSOXbvP1/LmqJACbL4/zQ9UE5MUl97ITmBfj5YBUPHoeOeS
         T94w==
X-Gm-Message-State: AOAM533Gcs/eDOHQ0iS57I//ADa1kgtuxuJKE+TM7MLqQP92q4bi9kWJ
        H8ab0tZgjYozkRuZCh8nk9I=
X-Google-Smtp-Source: ABdhPJy6P7kwqZvD50+iUwOpKIhwlYo2wqs6M0tjx32sZRndWZ5BSZxMIgWgfrEpFMx5tIyLHCpCVA==
X-Received: by 2002:a17:90a:f3cf:: with SMTP id ha15mr2247658pjb.214.1618884862931;
        Mon, 19 Apr 2021 19:14:22 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id mq2sm630984pjb.24.2021.04.19.19.14.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 19:14:22 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        Can Guo <cang@codeaurora.org>, Yue Hu <huyue2@yulong.com>
Subject: [PATCH 102/117] ufs: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 19:13:47 -0700
Message-Id: <20210420021402.27678-12-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210420000845.25873-1-bvanassche@acm.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

An explanation of the purpose of this patch is available in the patch
"scsi: Introduce the scsi_status union".

Cc: Can Guo <cang@codeaurora.org>
Cc: Yue Hu <huyue2@yulong.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufs_bsg.c |  2 +-
 drivers/scsi/ufs/ufshcd.c  | 27 +++++++++++++++------------
 2 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/ufs/ufs_bsg.c b/drivers/scsi/ufs/ufs_bsg.c
index 5b2bc1a6f922..4dcc09136a50 100644
--- a/drivers/scsi/ufs/ufs_bsg.c
+++ b/drivers/scsi/ufs/ufs_bsg.c
@@ -152,7 +152,7 @@ static int ufs_bsg_request(struct bsg_job *job)
 	kfree(desc_buff);
 
 out:
-	bsg_reply->result = ret;
+	bsg_reply->status.combined = ret;
 	job->reply_len = sizeof(struct ufs_bsg_reply);
 	/* complete the job here only if no error */
 	if (ret == 0)
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index d966d80838fb..cec555d3fcd7 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4933,7 +4933,7 @@ ufshcd_scsi_cmd_status(struct ufshcd_lrb *lrbp, enum sam_status scsi_status)
 static inline int
 ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 {
-	int result = 0;
+	union scsi_status result;
 	int ocs;
 
 	/* overall command status of utrd */
@@ -4951,7 +4951,7 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 		switch (ufshcd_get_req_rsp(lrbp->ucd_rsp_ptr)) {
 		case UPIU_TRANSACTION_RESPONSE:
 			/* Propagate the SCSI status to the SCSI midlayer. */
-			result = ufshcd_scsi_cmd_status(lrbp,
+			result.combined = ufshcd_scsi_cmd_status(lrbp,
 				ufshcd_get_rsp_upiu_result(lrbp->ucd_rsp_ptr) &
 				MASK_SCSI_STATUS);
 
@@ -4981,23 +4981,23 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 			break;
 		case UPIU_TRANSACTION_REJECT_UPIU:
 			/* TODO: handle Reject UPIU Response */
-			result = DID_ERROR << 16;
+			result.combined = DID_ERROR << 16;
 			dev_err(hba->dev,
 				"Reject UPIU not fully implemented\n");
 			break;
 		default:
 			dev_err(hba->dev,
 				"Unexpected request response code = %x\n",
-				result);
-			result = DID_ERROR << 16;
+				result.combined);
+			result.combined = DID_ERROR << 16;
 			break;
 		}
 		break;
 	case OCS_ABORTED:
-		result |= DID_ABORT << 16;
+		result.combined |= DID_ABORT << 16;
 		break;
 	case OCS_INVALID_COMMAND_STATUS:
-		result |= DID_REQUEUE << 16;
+		result.combined |= DID_REQUEUE << 16;
 		break;
 	case OCS_INVALID_CMD_TABLE_ATTR:
 	case OCS_INVALID_PRDT_ATTR:
@@ -5009,7 +5009,7 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	case OCS_INVALID_CRYPTO_CONFIG:
 	case OCS_GENERAL_CRYPTO_ERROR:
 	default:
-		result |= DID_ERROR << 16;
+		result.combined |= DID_ERROR << 16;
 		dev_err(hba->dev,
 				"OCS error from controller = %x for tag %d\n",
 				ocs, lrbp->task_tag);
@@ -5021,7 +5021,7 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	if ((host_byte(result) != DID_OK) &&
 	    (host_byte(result) != DID_REQUEUE) && !hba->silence_err_logs)
 		ufshcd_print_trs(hba, 1 << lrbp->task_tag, true);
-	return result;
+	return result.combined;
 }
 
 /**
@@ -5083,7 +5083,7 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 			ufshcd_add_command_trace(hba, index, UFS_CMD_COMP);
 			result = ufshcd_transfer_rsp_status(hba, lrbp);
 			scsi_dma_unmap(cmd);
-			cmd->result = result;
+			cmd->status.combined = result;
 			/* Mark completed command as NULL in LRB */
 			lrbp->cmd = NULL;
 			/* Do not touch lrbp after scsi done */
@@ -8437,6 +8437,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	struct scsi_sense_hdr sshdr;
 	struct scsi_device *sdp;
 	unsigned long flags;
+	union scsi_status start_stop_res;
 	int ret;
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
@@ -8471,13 +8472,15 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	 * callbacks hence set the RQF_PM flag so that it doesn't resume the
 	 * already suspended childs.
 	 */
-	ret = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
+	start_stop_res.combined =
+		scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
 			START_STOP_TIMEOUT, 0, 0, RQF_PM, NULL);
+	ret = start_stop_res.combined;
 	if (ret) {
 		sdev_printk(KERN_WARNING, sdp,
 			    "START_STOP failed for power mode: %d, result %x\n",
 			    pwr_mode, ret);
-		if (driver_byte(ret) == DRIVER_SENSE)
+		if (driver_byte(start_stop_res) == DRIVER_SENSE)
 			scsi_print_sense_hdr(sdp, NULL, &sshdr);
 	}
 
