Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A95D3C43460
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:10:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 824766109E
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:10:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233766AbhDTAKb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:10:31 -0400
Received: from mail-pg1-f173.google.com ([209.85.215.173]:45976 "EHLO
        mail-pg1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233635AbhDTAKV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:10:21 -0400
Received: by mail-pg1-f173.google.com with SMTP id d10so25385128pgf.12
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:09:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eEDSxjHmhrIBeIQH31pgycR7toiijB7+XGuk3kMoQtE=;
        b=BGpV3jF+7OM+8bHBol8iiZDo3WVo/WYmKlN4cqOO4BQug2kRnhbRCg4reRN5YIrJ2A
         GFt7oxwcxf4WqgI3XcnMZihHFzFPuSZOXMfHRxuaulDSdgD1pRvlzSOrAfIMElZOjPJR
         JIzbaU+7EYh2zTUq38Ryh+YYghZbHiOVgoxJVMOwb3yrMN5HsblUVlEUgc5A743fh4N9
         VjsIwrQ286HJIfuvom01S+z/5/kEuBeJ2roa3qtvu3aq0tKkZGqWfxajzVbw/j6h6oht
         od8VZr3e8cnP5wPncUVzOvBMgtohbM5gO9FHu45UoLzINQbPVYknkxvYSrndPz3yF4xC
         RxhQ==
X-Gm-Message-State: AOAM5300oeaGsx5x6MdKpHmUI0GQ1KlRCvmcDHzcsQrbJ9R18u4Ywiby
        /ZWA2NeSyqNt+goJ2zhGSKs=
X-Google-Smtp-Source: ABdhPJz+yV8Ip9dcnQm6cKjMZdwOntmQA5PDb6rnede/gD6FGunAwgoF0xQyh/cA8gCkKxQaWDzDYw==
X-Received: by 2002:a63:105d:: with SMTP id 29mr14385661pgq.45.1618877390921;
        Mon, 19 Apr 2021 17:09:50 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.09.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:09:50 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>
Subject: [PATCH 051/117] hpsa: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:07:39 -0700
Message-Id: <20210420000845.25873-52-bvanassche@acm.org>
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

Cc: Don Brace <don.brace@microchip.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/hpsa.c | 74 ++++++++++++++++++++++-----------------------
 1 file changed, 37 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 38369766511c..4651b233a879 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2352,10 +2352,10 @@ static int handle_ioaccel_mode2_error(struct ctlr_info *h,
 		switch (c2->error_data.status) {
 		case IOACCEL2_STATUS_SR_TASK_COMP_GOOD:
 			if (cmd)
-				cmd->result = 0;
+				cmd->status.combined = 0;
 			break;
 		case IOACCEL2_STATUS_SR_TASK_COMP_CHK_COND:
-			cmd->result |= SAM_STAT_CHECK_CONDITION;
+			cmd->status.combined |= SAM_STAT_CHECK_CONDITION;
 			if (c2->error_data.data_present !=
 					IOACCEL2_SENSE_DATA_PRESENT) {
 				memset(cmd->sense_buffer, 0,
@@ -2398,7 +2398,7 @@ static int handle_ioaccel_mode2_error(struct ctlr_info *h,
 			retry = 1;
 			break;
 		case IOACCEL2_STATUS_SR_UNDERRUN:
-			cmd->result = (DID_OK << 16);		/* host byte */
+			cmd->status.combined = (DID_OK << 16);		/* host byte */
 			ioaccel2_resid = get_unaligned_le32(
 						&c2->error_data.resid_cnt[0]);
 			scsi_set_resid(cmd, ioaccel2_resid);
@@ -2415,7 +2415,7 @@ static int handle_ioaccel_mode2_error(struct ctlr_info *h,
 			 * of the disk to get the same device node.
 			 */
 			if (dev->physical_device && dev->expose_device) {
-				cmd->result = DID_NO_CONNECT << 16;
+				cmd->status.combined = DID_NO_CONNECT << 16;
 				dev->removed = 1;
 				h->drv_req_rescan = 1;
 				dev_warn(&h->pdev->dev,
@@ -2502,7 +2502,7 @@ static void process_ioaccel2_completion(struct ctlr_info *h,
 	/* check for good status */
 	if (likely(c2->error_data.serv_response == 0 &&
 			c2->error_data.status == 0)) {
-		cmd->result = 0;
+		cmd->status.combined = 0;
 		return hpsa_cmd_free_and_done(h, c, cmd);
 	}
 
@@ -2520,7 +2520,7 @@ static void process_ioaccel2_completion(struct ctlr_info *h,
 		}
 
 		if (dev->in_reset) {
-			cmd->result = DID_RESET << 16;
+			cmd->status.combined = DID_RESET << 16;
 			return hpsa_cmd_free_and_done(h, c, cmd);
 		}
 
@@ -2579,13 +2579,13 @@ static void complete_scsi_command(struct CommandList *cp)
 	h = cp->h;
 
 	if (!cmd->device) {
-		cmd->result = DID_NO_CONNECT << 16;
+		cmd->status.combined = DID_NO_CONNECT << 16;
 		return hpsa_cmd_free_and_done(h, cp, cmd);
 	}
 
 	dev = cmd->device->hostdata;
 	if (!dev) {
-		cmd->result = DID_NO_CONNECT << 16;
+		cmd->status.combined = DID_NO_CONNECT << 16;
 		return hpsa_cmd_free_and_done(h, cp, cmd);
 	}
 	c2 = &h->ioaccel2_cmd_pool[cp->cmdindex];
@@ -2599,7 +2599,7 @@ static void complete_scsi_command(struct CommandList *cp)
 		(c2->sg[0].chain_indicator == IOACCEL2_CHAIN))
 		hpsa_unmap_ioaccel2_sg_chain_block(h, c2);
 
-	cmd->result = (DID_OK << 16);		/* host byte */
+	cmd->status.combined = (DID_OK << 16);		/* host byte */
 
 	/* SCSI command has already been cleaned up in SML */
 	if (dev->was_removed) {
@@ -2610,7 +2610,7 @@ static void complete_scsi_command(struct CommandList *cp)
 	if (cp->cmd_type == CMD_IOACCEL2 || cp->cmd_type == CMD_IOACCEL1) {
 		if (dev->physical_device && dev->expose_device &&
 			dev->removed) {
-			cmd->result = DID_NO_CONNECT << 16;
+			cmd->status.combined = DID_NO_CONNECT << 16;
 			return hpsa_cmd_free_and_done(h, cp, cmd);
 		}
 		if (likely(cp->phys_disk != NULL))
@@ -2624,7 +2624,7 @@ static void complete_scsi_command(struct CommandList *cp)
 	 */
 	if (unlikely(ei->CommandStatus == CMD_CTLR_LOCKUP)) {
 		/* DID_NO_CONNECT will prevent a retry */
-		cmd->result = DID_NO_CONNECT << 16;
+		cmd->status.combined = DID_NO_CONNECT << 16;
 		return hpsa_cmd_free_and_done(h, cp, cmd);
 	}
 
@@ -2663,7 +2663,7 @@ static void complete_scsi_command(struct CommandList *cp)
 	switch (ei->CommandStatus) {
 
 	case CMD_TARGET_STATUS:
-		cmd->result |= ei->ScsiStatus;
+		cmd->status.combined |= ei->ScsiStatus;
 		/* copy the sense data */
 		if (SCSI_SENSE_BUFFERSIZE < sizeof(ei->SenseInfo))
 			sense_data_size = SCSI_SENSE_BUFFERSIZE;
@@ -2678,7 +2678,7 @@ static void complete_scsi_command(struct CommandList *cp)
 		if (ei->ScsiStatus == SAM_STAT_CHECK_CONDITION) {
 			switch (sense_key) {
 			case ABORTED_COMMAND:
-				cmd->result |= DID_SOFT_ERROR << 16;
+				cmd->status.combined |= DID_SOFT_ERROR << 16;
 				break;
 			case UNIT_ATTENTION:
 				if (asc == 0x3F && ascq == 0x0E)
@@ -2687,7 +2687,7 @@ static void complete_scsi_command(struct CommandList *cp)
 			case ILLEGAL_REQUEST:
 				if (asc == 0x25 && ascq == 0x00) {
 					dev->removed = 1;
-					cmd->result = DID_NO_CONNECT << 16;
+					cmd->status.combined = DID_NO_CONNECT << 16;
 				}
 				break;
 			}
@@ -2702,7 +2702,7 @@ static void complete_scsi_command(struct CommandList *cp)
 				"Returning result: 0x%x\n",
 				cp, ei->ScsiStatus,
 				sense_key, asc, ascq,
-				cmd->result);
+				cmd->status.combined);
 		} else {  /* scsi status is zero??? How??? */
 			dev_warn(&h->pdev->dev, "cp %p SCSI status was 0. "
 				"Returning no connection.\n", cp),
@@ -2719,7 +2719,7 @@ static void complete_scsi_command(struct CommandList *cp)
 			 * and it's severe enough.
 			 */
 
-			cmd->result = DID_NO_CONNECT << 16;
+			cmd->status.combined = DID_NO_CONNECT << 16;
 		}
 		break;
 
@@ -2738,60 +2738,60 @@ static void complete_scsi_command(struct CommandList *cp)
 		 * This is kind of a shame because it means that any other
 		 * CMD_INVALID (e.g. driver bug) will get interpreted as a
 		 * missing target. */
-		cmd->result = DID_NO_CONNECT << 16;
+		cmd->status.combined = DID_NO_CONNECT << 16;
 	}
 		break;
 	case CMD_PROTOCOL_ERR:
-		cmd->result = DID_ERROR << 16;
+		cmd->status.combined = DID_ERROR << 16;
 		dev_warn(&h->pdev->dev, "CDB %16phN : protocol error\n",
 				cp->Request.CDB);
 		break;
 	case CMD_HARDWARE_ERR:
-		cmd->result = DID_ERROR << 16;
+		cmd->status.combined = DID_ERROR << 16;
 		dev_warn(&h->pdev->dev, "CDB %16phN : hardware error\n",
 			cp->Request.CDB);
 		break;
 	case CMD_CONNECTION_LOST:
-		cmd->result = DID_ERROR << 16;
+		cmd->status.combined = DID_ERROR << 16;
 		dev_warn(&h->pdev->dev, "CDB %16phN : connection lost\n",
 			cp->Request.CDB);
 		break;
 	case CMD_ABORTED:
-		cmd->result = DID_ABORT << 16;
+		cmd->status.combined = DID_ABORT << 16;
 		break;
 	case CMD_ABORT_FAILED:
-		cmd->result = DID_ERROR << 16;
+		cmd->status.combined = DID_ERROR << 16;
 		dev_warn(&h->pdev->dev, "CDB %16phN : abort failed\n",
 			cp->Request.CDB);
 		break;
 	case CMD_UNSOLICITED_ABORT:
-		cmd->result = DID_SOFT_ERROR << 16; /* retry the command */
+		cmd->status.combined = DID_SOFT_ERROR << 16; /* retry the command */
 		dev_warn(&h->pdev->dev, "CDB %16phN : unsolicited abort\n",
 			cp->Request.CDB);
 		break;
 	case CMD_TIMEOUT:
-		cmd->result = DID_TIME_OUT << 16;
+		cmd->status.combined = DID_TIME_OUT << 16;
 		dev_warn(&h->pdev->dev, "CDB %16phN timed out\n",
 			cp->Request.CDB);
 		break;
 	case CMD_UNABORTABLE:
-		cmd->result = DID_ERROR << 16;
+		cmd->status.combined = DID_ERROR << 16;
 		dev_warn(&h->pdev->dev, "Command unabortable\n");
 		break;
 	case CMD_TMF_STATUS:
 		if (hpsa_evaluate_tmf_status(h, cp)) /* TMF failed? */
-			cmd->result = DID_ERROR << 16;
+			cmd->status.combined = DID_ERROR << 16;
 		break;
 	case CMD_IOACCEL_DISABLED:
 		/* This only handles the direct pass-through case since RAID
 		 * offload is handled above.  Just attempt a retry.
 		 */
-		cmd->result = DID_SOFT_ERROR << 16;
+		cmd->status.combined = DID_SOFT_ERROR << 16;
 		dev_warn(&h->pdev->dev,
 				"cp %p had HP SSD Smart Path error\n", cp);
 		break;
 	default:
-		cmd->result = DID_ERROR << 16;
+		cmd->status.combined = DID_ERROR << 16;
 		dev_warn(&h->pdev->dev, "cp %p returned unknown status %x\n",
 				cp, ei->CommandStatus);
 	}
@@ -5029,7 +5029,7 @@ static int hpsa_scsi_ioaccel2_queue_command(struct ctlr_info *h,
 		cp->sg_count = (u8) use_sg;
 
 	if (phys_disk->in_reset) {
-		cmd->result = DID_RESET << 16;
+		cmd->status.combined = DID_RESET << 16;
 		return -1;
 	}
 
@@ -5620,12 +5620,12 @@ static void hpsa_command_resubmit_worker(struct work_struct *work)
 	cmd = c->scsi_cmd;
 	dev = cmd->device->hostdata;
 	if (!dev) {
-		cmd->result = DID_NO_CONNECT << 16;
+		cmd->status.combined = DID_NO_CONNECT << 16;
 		return hpsa_cmd_free_and_done(c->h, c, cmd);
 	}
 
 	if (dev->in_reset) {
-		cmd->result = DID_RESET << 16;
+		cmd->status.combined = DID_RESET << 16;
 		return hpsa_cmd_free_and_done(c->h, c, cmd);
 	}
 
@@ -5646,7 +5646,7 @@ static void hpsa_command_resubmit_worker(struct work_struct *work)
 				 * Try again via scsi mid layer, which will
 				 * then get SCSI_MLQUEUE_HOST_BUSY.
 				 */
-				cmd->result = DID_IMM_RETRY << 16;
+				cmd->status.combined = DID_IMM_RETRY << 16;
 				return hpsa_cmd_free_and_done(h, c, cmd);
 			}
 			/* else, fall thru and resubmit down CISS path */
@@ -5671,7 +5671,7 @@ static void hpsa_command_resubmit_worker(struct work_struct *work)
 		 * hpsa_ciss_submit will have already freed c
 		 * if it encountered a dma mapping failure.
 		 */
-		cmd->result = DID_IMM_RETRY << 16;
+		cmd->status.combined = DID_IMM_RETRY << 16;
 		cmd->scsi_done(cmd);
 	}
 }
@@ -5691,19 +5691,19 @@ static int hpsa_scsi_queue_command(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 
 	dev = cmd->device->hostdata;
 	if (!dev) {
-		cmd->result = DID_NO_CONNECT << 16;
+		cmd->status.combined = DID_NO_CONNECT << 16;
 		cmd->scsi_done(cmd);
 		return 0;
 	}
 
 	if (dev->removed) {
-		cmd->result = DID_NO_CONNECT << 16;
+		cmd->status.combined = DID_NO_CONNECT << 16;
 		cmd->scsi_done(cmd);
 		return 0;
 	}
 
 	if (unlikely(lockup_detected(h))) {
-		cmd->result = DID_NO_CONNECT << 16;
+		cmd->status.combined = DID_NO_CONNECT << 16;
 		cmd->scsi_done(cmd);
 		return 0;
 	}
@@ -5719,7 +5719,7 @@ static int hpsa_scsi_queue_command(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 	 * This is necessary because the SML doesn't zero out this field during
 	 * error recovery.
 	 */
-	cmd->result = 0;
+	cmd->status.combined = 0;
 
 	/*
 	 * Call alternate submit routine for I/O accelerated commands.
