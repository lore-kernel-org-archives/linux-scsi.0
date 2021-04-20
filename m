Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 457EFC433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:11:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 184EF613AA
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:11:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234623AbhDTALe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:11:34 -0400
Received: from mail-pg1-f176.google.com ([209.85.215.176]:44623 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234261AbhDTALB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:11:01 -0400
Received: by mail-pg1-f176.google.com with SMTP id y32so25382947pga.11
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:10:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CfLglHRzR42uzEc4wX3Es6j6ZdkaLSNj18LAjvhQXwg=;
        b=W/o+uPL52WoDvcmmgtbEc36NT6cOLOdhPrCiZxPoQ2B08jsiq3/+pAN6cYL491NhSs
         u7M6PKEYYLE2RZyRErngmoU+6WyqAfzOrL5GZ2w7IBevFOuwI4kpN4aAHF8JPBRj2uDD
         M4LazLUlO12Kh6P1yDG1KQsNUZ3bDxPChqoZsNme2Gj/TilgYk7soOZWFypCsvWow6J/
         8UOau9ZaBAwlrIQIieaFUqxEtcQcbK2zq8xzdp8WeUcz0pCL/cpPV9j5DUQ2UCXYY7z1
         0voS+i/97sqsPuVAU+B+j3ssP3pE7Tc1FT9hK57gsj8E7jRs8nPNvbng7XK5TmTvjCIQ
         OCcg==
X-Gm-Message-State: AOAM532hCu2OhO3DBU/ZEhQ4Fo55Gdka9bbsdsQVAHux/2PXm2vXgGLA
        X58pHu29xwThiFfNWPV32Rw=
X-Google-Smtp-Source: ABdhPJzNM9oRXzfCLSRAW6ei9cvcLiUPdLeJ4JoaLZFUBKZxdMlS8naxCEAFS21UYvsSRX88D21cRA==
X-Received: by 2002:a65:4889:: with SMTP id n9mr14100454pgs.91.1618877431130;
        Mon, 19 Apr 2021 17:10:31 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.10.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:10:30 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com
Subject: [PATCH 086/117] qla4xxx: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:08:14 -0700
Message-Id: <20210420000845.25873-87-bvanassche@acm.org>
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

Cc: Nilesh Javali <njavali@marvell.com>
Cc: Manish Rangankar <mrangankar@marvell.com>
Cc: GR-QLogic-Storage-Upstream@marvell.com
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla4xxx/ql4_bsg.c | 76 +++++++++++++++++-----------------
 drivers/scsi/qla4xxx/ql4_isr.c | 32 +++++++-------
 drivers/scsi/qla4xxx/ql4_os.c  | 14 +++----
 3 files changed, 61 insertions(+), 61 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_bsg.c b/drivers/scsi/qla4xxx/ql4_bsg.c
index c447a9d598a1..8f1c8879a6e9 100644
--- a/drivers/scsi/qla4xxx/ql4_bsg.c
+++ b/drivers/scsi/qla4xxx/ql4_bsg.c
@@ -55,17 +55,17 @@ qla4xxx_read_flash(struct bsg_job *bsg_job)
 	rval = qla4xxx_get_flash(ha, flash_dma, offset, length);
 	if (rval) {
 		ql4_printk(KERN_ERR, ha, "%s: get flash failed\n", __func__);
-		bsg_reply->result = DID_ERROR << 16;
+		bsg_reply->status.combined = DID_ERROR << 16;
 		rval = -EIO;
 	} else {
 		bsg_reply->reply_payload_rcv_len =
 			sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
 					    bsg_job->reply_payload.sg_cnt,
 					    flash, length);
-		bsg_reply->result = DID_OK << 16;
+		bsg_reply->status.combined = DID_OK << 16;
 	}
 
-	bsg_job_done(bsg_job, bsg_reply->result,
+	bsg_job_done(bsg_job, bsg_reply->status.combined,
 		     bsg_reply->reply_payload_rcv_len);
 	dma_free_coherent(&ha->pdev->dev, length, flash, flash_dma);
 leave:
@@ -125,12 +125,12 @@ qla4xxx_update_flash(struct bsg_job *bsg_job)
 	rval = qla4xxx_set_flash(ha, flash_dma, offset, length, options);
 	if (rval) {
 		ql4_printk(KERN_ERR, ha, "%s: set flash failed\n", __func__);
-		bsg_reply->result = DID_ERROR << 16;
+		bsg_reply->status.combined = DID_ERROR << 16;
 		rval = -EIO;
 	} else
-		bsg_reply->result = DID_OK << 16;
+		bsg_reply->status.combined = DID_OK << 16;
 
-	bsg_job_done(bsg_job, bsg_reply->result,
+	bsg_job_done(bsg_job, bsg_reply->status.combined,
 		     bsg_reply->reply_payload_rcv_len);
 	dma_free_coherent(&ha->pdev->dev, length, flash, flash_dma);
 leave:
@@ -179,17 +179,17 @@ qla4xxx_get_acb_state(struct bsg_job *bsg_job)
 	if (rval) {
 		ql4_printk(KERN_ERR, ha, "%s: get ip state failed\n",
 			   __func__);
-		bsg_reply->result = DID_ERROR << 16;
+		bsg_reply->status.combined = DID_ERROR << 16;
 		rval = -EIO;
 	} else {
 		bsg_reply->reply_payload_rcv_len =
 			sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
 					    bsg_job->reply_payload.sg_cnt,
 					    status, sizeof(status));
-		bsg_reply->result = DID_OK << 16;
+		bsg_reply->status.combined = DID_OK << 16;
 	}
 
-	bsg_job_done(bsg_job, bsg_reply->result,
+	bsg_job_done(bsg_job, bsg_reply->status.combined,
 		     bsg_reply->reply_payload_rcv_len);
 leave:
 	return rval;
@@ -250,17 +250,17 @@ qla4xxx_read_nvram(struct bsg_job *bsg_job)
 	rval = qla4xxx_get_nvram(ha, nvram_dma, offset, len);
 	if (rval) {
 		ql4_printk(KERN_ERR, ha, "%s: get nvram failed\n", __func__);
-		bsg_reply->result = DID_ERROR << 16;
+		bsg_reply->status.combined = DID_ERROR << 16;
 		rval = -EIO;
 	} else {
 		bsg_reply->reply_payload_rcv_len =
 			sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
 					    bsg_job->reply_payload.sg_cnt,
 					    nvram, len);
-		bsg_reply->result = DID_OK << 16;
+		bsg_reply->status.combined = DID_OK << 16;
 	}
 
-	bsg_job_done(bsg_job, bsg_reply->result,
+	bsg_job_done(bsg_job, bsg_reply->status.combined,
 		     bsg_reply->reply_payload_rcv_len);
 	dma_free_coherent(&ha->pdev->dev, len, nvram, nvram_dma);
 leave:
@@ -324,12 +324,12 @@ qla4xxx_update_nvram(struct bsg_job *bsg_job)
 	rval = qla4xxx_set_nvram(ha, nvram_dma, offset, len);
 	if (rval) {
 		ql4_printk(KERN_ERR, ha, "%s: set nvram failed\n", __func__);
-		bsg_reply->result = DID_ERROR << 16;
+		bsg_reply->status.combined = DID_ERROR << 16;
 		rval = -EIO;
 	} else
-		bsg_reply->result = DID_OK << 16;
+		bsg_reply->status.combined = DID_OK << 16;
 
-	bsg_job_done(bsg_job, bsg_reply->result,
+	bsg_job_done(bsg_job, bsg_reply->status.combined,
 		     bsg_reply->reply_payload_rcv_len);
 	dma_free_coherent(&ha->pdev->dev, len, nvram, nvram_dma);
 leave:
@@ -369,12 +369,12 @@ qla4xxx_restore_defaults(struct bsg_job *bsg_job)
 	rval = qla4xxx_restore_factory_defaults(ha, region, field0, field1);
 	if (rval) {
 		ql4_printk(KERN_ERR, ha, "%s: set nvram failed\n", __func__);
-		bsg_reply->result = DID_ERROR << 16;
+		bsg_reply->status.combined = DID_ERROR << 16;
 		rval = -EIO;
 	} else
-		bsg_reply->result = DID_OK << 16;
+		bsg_reply->status.combined = DID_OK << 16;
 
-	bsg_job_done(bsg_job, bsg_reply->result,
+	bsg_job_done(bsg_job, bsg_reply->status.combined,
 		     bsg_reply->reply_payload_rcv_len);
 leave:
 	return rval;
@@ -428,17 +428,17 @@ qla4xxx_bsg_get_acb(struct bsg_job *bsg_job)
 	rval = qla4xxx_get_acb(ha, acb_dma, acb_type, len);
 	if (rval) {
 		ql4_printk(KERN_ERR, ha, "%s: get acb failed\n", __func__);
-		bsg_reply->result = DID_ERROR << 16;
+		bsg_reply->status.combined = DID_ERROR << 16;
 		rval = -EIO;
 	} else {
 		bsg_reply->reply_payload_rcv_len =
 			sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
 					    bsg_job->reply_payload.sg_cnt,
 					    acb, len);
-		bsg_reply->result = DID_OK << 16;
+		bsg_reply->status.combined = DID_OK << 16;
 	}
 
-	bsg_job_done(bsg_job, bsg_reply->result,
+	bsg_job_done(bsg_job, bsg_reply->status.combined,
 		     bsg_reply->reply_payload_rcv_len);
 	dma_free_coherent(&ha->pdev->dev, len, acb, acb_dma);
 leave:
@@ -461,7 +461,7 @@ static void ql4xxx_execute_diag_cmd(struct bsg_job *bsg_job)
 	if (test_bit(DPC_RESET_HA, &ha->dpc_flags)) {
 		ql4_printk(KERN_INFO, ha, "%s: Adapter reset in progress. Invalid Request\n",
 			   __func__);
-		bsg_reply->result = DID_ERROR << 16;
+		bsg_reply->status.combined = DID_ERROR << 16;
 		goto exit_diag_mem_test;
 	}
 
@@ -485,9 +485,9 @@ static void ql4xxx_execute_diag_cmd(struct bsg_job *bsg_job)
 			  mbox_sts[7]));
 
 	if (status == QLA_SUCCESS)
-		bsg_reply->result = DID_OK << 16;
+		bsg_reply->status.combined = DID_OK << 16;
 	else
-		bsg_reply->result = DID_ERROR << 16;
+		bsg_reply->status.combined = DID_ERROR << 16;
 
 	/* Send mbox_sts to application */
 	bsg_job->reply_len = sizeof(struct iscsi_bsg_reply) + sizeof(mbox_sts);
@@ -497,9 +497,9 @@ static void ql4xxx_execute_diag_cmd(struct bsg_job *bsg_job)
 exit_diag_mem_test:
 	DEBUG2(ql4_printk(KERN_INFO, ha,
 			  "%s: bsg_reply->result = x%x, status = %s\n",
-			  __func__, bsg_reply->result, STATUS(status)));
+			  __func__, bsg_reply->status.combined, STATUS(status)));
 
-	bsg_job_done(bsg_job, bsg_reply->result,
+	bsg_job_done(bsg_job, bsg_reply->status.combined,
 		     bsg_reply->reply_payload_rcv_len);
 }
 
@@ -668,14 +668,14 @@ static void qla4xxx_execute_diag_loopback_cmd(struct bsg_job *bsg_job)
 	if (test_bit(AF_LOOPBACK, &ha->flags)) {
 		ql4_printk(KERN_INFO, ha, "%s: Loopback Diagnostics already in progress. Invalid Request\n",
 			   __func__);
-		bsg_reply->result = DID_ERROR << 16;
+		bsg_reply->status.combined = DID_ERROR << 16;
 		goto exit_loopback_cmd;
 	}
 
 	if (test_bit(DPC_RESET_HA, &ha->dpc_flags)) {
 		ql4_printk(KERN_INFO, ha, "%s: Adapter reset in progress. Invalid Request\n",
 			   __func__);
-		bsg_reply->result = DID_ERROR << 16;
+		bsg_reply->status.combined = DID_ERROR << 16;
 		goto exit_loopback_cmd;
 	}
 
@@ -685,14 +685,14 @@ static void qla4xxx_execute_diag_loopback_cmd(struct bsg_job *bsg_job)
 	if (is_qla8032(ha) || is_qla8042(ha)) {
 		status = qla4_83xx_pre_loopback_config(ha, mbox_cmd);
 		if (status != QLA_SUCCESS) {
-			bsg_reply->result = DID_ERROR << 16;
+			bsg_reply->status.combined = DID_ERROR << 16;
 			goto exit_loopback_cmd;
 		}
 
 		status = qla4_83xx_wait_for_loopback_config_comp(ha,
 								 wait_for_link);
 		if (status != QLA_SUCCESS) {
-			bsg_reply->result = DID_TIME_OUT << 16;
+			bsg_reply->status.combined = DID_TIME_OUT << 16;
 			goto restore;
 		}
 	}
@@ -707,9 +707,9 @@ static void qla4xxx_execute_diag_loopback_cmd(struct bsg_job *bsg_job)
 				&mbox_sts[0]);
 
 	if (status == QLA_SUCCESS)
-		bsg_reply->result = DID_OK << 16;
+		bsg_reply->status.combined = DID_OK << 16;
 	else
-		bsg_reply->result = DID_ERROR << 16;
+		bsg_reply->status.combined = DID_ERROR << 16;
 
 	DEBUG2(ql4_printk(KERN_INFO, ha,
 			  "%s: mbox_sts: %08X %08X %08X %08X %08X %08X %08X %08X\n",
@@ -725,7 +725,7 @@ static void qla4xxx_execute_diag_loopback_cmd(struct bsg_job *bsg_job)
 	if (is_qla8032(ha) || is_qla8042(ha)) {
 		status = qla4_83xx_post_loopback_config(ha, mbox_cmd);
 		if (status != QLA_SUCCESS) {
-			bsg_reply->result = DID_ERROR << 16;
+			bsg_reply->status.combined = DID_ERROR << 16;
 			goto exit_loopback_cmd;
 		}
 
@@ -737,15 +737,15 @@ static void qla4xxx_execute_diag_loopback_cmd(struct bsg_job *bsg_job)
 		status = qla4_83xx_wait_for_loopback_config_comp(ha,
 								 wait_for_link);
 		if (status != QLA_SUCCESS) {
-			bsg_reply->result = DID_TIME_OUT << 16;
+			bsg_reply->status.combined = DID_TIME_OUT << 16;
 			goto exit_loopback_cmd;
 		}
 	}
 exit_loopback_cmd:
 	DEBUG2(ql4_printk(KERN_INFO, ha,
 			  "%s: bsg_reply->result = x%x, status = %s\n",
-			  __func__, bsg_reply->result, STATUS(status)));
-	bsg_job_done(bsg_job, bsg_reply->result,
+			  __func__, bsg_reply->status.combined, STATUS(status)));
+	bsg_job_done(bsg_job, bsg_reply->status.combined,
 		     bsg_reply->reply_payload_rcv_len);
 }
 
@@ -841,9 +841,9 @@ int qla4xxx_process_vendor_specific(struct bsg_job *bsg_job)
 	default:
 		ql4_printk(KERN_ERR, ha, "%s: invalid BSG vendor command: "
 			   "0x%x\n", __func__, bsg_req->msgcode);
-		bsg_reply->result = (DID_ERROR << 16);
+		bsg_reply->status.combined = (DID_ERROR << 16);
 		bsg_reply->reply_payload_rcv_len = 0;
-		bsg_job_done(bsg_job, bsg_reply->result,
+		bsg_job_done(bsg_job, bsg_reply->status.combined,
 			     bsg_reply->reply_payload_rcv_len);
 		return -ENOSYS;
 	}
diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
index 6f0e77dc2a34..d31b7dcb6be4 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -145,7 +145,7 @@ static void qla4xxx_status_entry(struct scsi_qla_host *ha,
 
 	ddb_entry = srb->ddb;
 	if (ddb_entry == NULL) {
-		cmd->result = DID_NO_CONNECT << 16;
+		cmd->status.combined = DID_NO_CONNECT << 16;
 		goto status_entry_exit;
 	}
 
@@ -157,7 +157,7 @@ static void qla4xxx_status_entry(struct scsi_qla_host *ha,
 	case SCS_COMPLETE:
 
 		if (sts_entry->iscsiFlags & ISCSI_FLAG_RESIDUAL_OVER) {
-			cmd->result = DID_ERROR << 16;
+			cmd->status.combined = DID_ERROR << 16;
 			break;
 		}
 
@@ -166,7 +166,7 @@ static void qla4xxx_status_entry(struct scsi_qla_host *ha,
 			if (!scsi_status && ((scsi_bufflen(cmd) - residual) <
 				cmd->underflow)) {
 
-				cmd->result = DID_ERROR << 16;
+				cmd->status.combined = DID_ERROR << 16;
 
 				DEBUG2(printk("scsi%ld:%d:%d:%llu: %s: "
 					"Mid-layer Data underrun0, "
@@ -180,7 +180,7 @@ static void qla4xxx_status_entry(struct scsi_qla_host *ha,
 			}
 		}
 
-		cmd->result = DID_OK << 16 | scsi_status;
+		cmd->status.combined = DID_OK << 16 | scsi_status;
 
 		if (scsi_status != SAM_STAT_CHECK_CONDITION)
 			break;
@@ -192,7 +192,7 @@ static void qla4xxx_status_entry(struct scsi_qla_host *ha,
 	case SCS_INCOMPLETE:
 		/* Always set the status to DID_ERROR, since
 		 * all conditions result in that status anyway */
-		cmd->result = DID_ERROR << 16;
+		cmd->status.combined = DID_ERROR << 16;
 		break;
 
 	case SCS_RESET_OCCURRED:
@@ -200,7 +200,7 @@ static void qla4xxx_status_entry(struct scsi_qla_host *ha,
 			      ha->host_no, cmd->device->channel,
 			      cmd->device->id, cmd->device->lun, __func__));
 
-		cmd->result = DID_RESET << 16;
+		cmd->status.combined = DID_RESET << 16;
 		break;
 
 	case SCS_ABORTED:
@@ -208,7 +208,7 @@ static void qla4xxx_status_entry(struct scsi_qla_host *ha,
 			      ha->host_no, cmd->device->channel,
 			      cmd->device->id, cmd->device->lun, __func__));
 
-		cmd->result = DID_RESET << 16;
+		cmd->status.combined = DID_RESET << 16;
 		break;
 
 	case SCS_TIMEOUT:
@@ -216,7 +216,7 @@ static void qla4xxx_status_entry(struct scsi_qla_host *ha,
 			      ha->host_no, cmd->device->channel,
 			      cmd->device->id, cmd->device->lun));
 
-		cmd->result = DID_TRANSPORT_DISRUPTED << 16;
+		cmd->status.combined = DID_TRANSPORT_DISRUPTED << 16;
 
 		/*
 		 * Mark device missing so that we won't continue to send
@@ -236,7 +236,7 @@ static void qla4xxx_status_entry(struct scsi_qla_host *ha,
 				      cmd->device->channel, cmd->device->id,
 				      cmd->device->lun, __func__));
 
-			cmd->result = DID_ERROR << 16;
+			cmd->status.combined = DID_ERROR << 16;
 			break;
 		}
 
@@ -266,7 +266,7 @@ static void qla4xxx_status_entry(struct scsi_qla_host *ha,
 						   scsi_bufflen(cmd),
 						   residual));
 
-				cmd->result = DID_ERROR << 16;
+				cmd->status.combined = DID_ERROR << 16;
 				break;
 			}
 
@@ -298,11 +298,11 @@ static void qla4xxx_status_entry(struct scsi_qla_host *ha,
 					  residual,
 					  scsi_bufflen(cmd)));
 
-			cmd->result = DID_ERROR << 16 | scsi_status;
+			cmd->status.combined = DID_ERROR << 16 | scsi_status;
 			goto check_scsi_status;
 		}
 
-		cmd->result = DID_OK << 16 | scsi_status;
+		cmd->status.combined = DID_OK << 16 | scsi_status;
 
 check_scsi_status:
 		if (scsi_status == SAM_STAT_CHECK_CONDITION)
@@ -324,14 +324,14 @@ static void qla4xxx_status_entry(struct scsi_qla_host *ha,
 		if (iscsi_is_session_online(ddb_entry->sess))
 			qla4xxx_mark_device_missing(ddb_entry->sess);
 
-		cmd->result = DID_TRANSPORT_DISRUPTED << 16;
+		cmd->status.combined = DID_TRANSPORT_DISRUPTED << 16;
 		break;
 
 	case SCS_QUEUE_FULL:
 		/*
 		 * SCSI Mid-Layer handles device queue full
 		 */
-		cmd->result = DID_OK << 16 | sts_entry->scsiStatus;
+		cmd->status.combined = DID_OK << 16 | sts_entry->scsiStatus;
 		DEBUG2(printk("scsi%ld:%d:%llu: %s: QUEUE FULL detected "
 			      "compl=%02x, scsi=%02x, state=%02x, iFlags=%02x,"
 			      " iResp=%02x\n", ha->host_no, cmd->device->id,
@@ -343,7 +343,7 @@ static void qla4xxx_status_entry(struct scsi_qla_host *ha,
 		break;
 
 	default:
-		cmd->result = DID_ERROR << 16;
+		cmd->status.combined = DID_ERROR << 16;
 		break;
 	}
 
@@ -529,7 +529,7 @@ void qla4xxx_process_response_queue(struct scsi_qla_host *ha)
 
 			/* ETRY normally by sending it back with
 			 * DID_BUS_BUSY */
-			srb->cmd->result = DID_BUS_BUSY << 16;
+			srb->cmd->status.combined = DID_BUS_BUSY << 16;
 			kref_put(&srb->srb_ref, qla4xxx_srb_compl);
 			break;
 
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index ad3afe30f617..5746c16dfc48 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -4106,20 +4106,20 @@ static int qla4xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	if (test_bit(AF_EEH_BUSY, &ha->flags)) {
 		if (test_bit(AF_PCI_CHANNEL_IO_PERM_FAILURE, &ha->flags))
-			cmd->result = DID_NO_CONNECT << 16;
+			cmd->status.combined = DID_NO_CONNECT << 16;
 		else
-			cmd->result = DID_REQUEUE << 16;
+			cmd->status.combined = DID_REQUEUE << 16;
 		goto qc_fail_command;
 	}
 
 	if (!sess) {
-		cmd->result = DID_IMM_RETRY << 16;
+		cmd->status.combined = DID_IMM_RETRY << 16;
 		goto qc_fail_command;
 	}
 
 	rval = iscsi_session_chkready(sess);
 	if (rval) {
-		cmd->result = rval;
+		cmd->status.combined = rval;
 		goto qc_fail_command;
 	}
 
@@ -4802,7 +4802,7 @@ static void qla4xxx_abort_active_cmds(struct scsi_qla_host *ha, int res)
 	for (i = 0; i < ha->host->can_queue; i++) {
 		srb = qla4xxx_del_from_active_array(ha, i);
 		if (srb != NULL) {
-			srb->cmd->result = res;
+			srb->cmd->status.combined = res;
 			kref_put(&srb->srb_ref, qla4xxx_srb_compl);
 		}
 	}
@@ -9283,7 +9283,7 @@ static int qla4xxx_eh_device_reset(struct scsi_cmnd *cmd)
 		      "scsi%ld: DEVICE_RESET cmd=%p jiffies = 0x%lx, to=%x,"
 		      "dpc_flags=%lx, status=%x allowed=%d\n", ha->host_no,
 		      cmd, jiffies, cmd->request->timeout / HZ,
-		      ha->dpc_flags, cmd->result, cmd->allowed));
+		      ha->dpc_flags, cmd->status.combined, cmd->allowed));
 
 	rval = qla4xxx_isp_check_reg(ha);
 	if (rval != QLA_SUCCESS) {
@@ -9350,7 +9350,7 @@ static int qla4xxx_eh_target_reset(struct scsi_cmnd *cmd)
 		      "scsi%ld: TARGET_DEVICE_RESET cmd=%p jiffies = 0x%lx, "
 		      "to=%x,dpc_flags=%lx, status=%x allowed=%d\n",
 		      ha->host_no, cmd, jiffies, cmd->request->timeout / HZ,
-		      ha->dpc_flags, cmd->result, cmd->allowed));
+		      ha->dpc_flags, cmd->status.combined, cmd->allowed));
 
 	rval = qla4xxx_isp_check_reg(ha);
 	if (rval != QLA_SUCCESS) {
