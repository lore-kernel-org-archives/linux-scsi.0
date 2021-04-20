Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4619AC433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CFB7613AA
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233000AbhDTAJy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:09:54 -0400
Received: from mail-pj1-f48.google.com ([209.85.216.48]:46805 "EHLO
        mail-pj1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232995AbhDTAJp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:09:45 -0400
Received: by mail-pj1-f48.google.com with SMTP id u14-20020a17090a1f0eb029014e38011b09so14624533pja.5
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:09:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c5fXAOWU6oDce/jqWQ4i5gQ9ROxPMYNfADPu4iIQBMI=;
        b=p8DLrRzKuOiEo91TupVTmjU/0awagmzrkki7jEKAJxq2tTw4n3PqZGScvruf0XzIEY
         pxQ0QHyvc3LSWlqWf+Zv9ZRLxYUAua2WTbpFC7/JuVEefFtycPsshyRyv2UqQNSMjaM0
         7n6OYvM3leiiOVIA0VtEeTmSjYcMClbc8wzM+WWgKD1Is3DoTdk8KVfwGtrYkK8cvJN9
         9BxHeOPZ2btZYUHfHG9eS2f5JIaUoqZydyfnDT18gqOKV/TVp3SNkCA4pUjE/9V1cs4O
         cC1KYFoXPwRMWmuEKr5Ps5Pi4Ew8j099D4/pvW4xWHzNlLMxIYe0T7K145oA4tRSXs3R
         uGfA==
X-Gm-Message-State: AOAM532BtprbOpP0VtPljofIDM8/gTuj7lvJaiuHv0YnzwRf3hcLwOeu
        AenIa3QL14iL0uD/gafZWpyH+dCoWF4=
X-Google-Smtp-Source: ABdhPJxSKOcFnHl2LaHBLPyxu8W0mjX3IIJWgPQiHyutjbMsE5ZxC5IG/Qw4ieIOYGgKt38J9pNutg==
X-Received: by 2002:a17:902:c407:b029:ec:aeb7:667f with SMTP id k7-20020a170902c407b02900ecaeb7667fmr4660963plk.9.1618877354539;
        Mon, 19 Apr 2021 17:09:14 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.09.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:09:13 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Adam Radford <aradford@gmail.com>
Subject: [PATCH 019/117] 3w*: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:07:07 -0700
Message-Id: <20210420000845.25873-20-bvanassche@acm.org>
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

Cc: Adam Radford <aradford@gmail.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/3w-9xxx.c | 12 ++++++------
 drivers/scsi/3w-sas.c  |  8 ++++----
 drivers/scsi/3w-xxxx.c | 20 ++++++++++----------
 3 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index 47028f5e57ab..d986a3ef6d26 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -1018,7 +1018,7 @@ static int twa_fill_sense(TW_Device_Extension *tw_dev, int request_id, int copy_
 
 	if (copy_sense) {
 		memcpy(tw_dev->srb[request_id]->sense_buffer, full_command_packet->header.sense_data, TW_SENSE_DATA_LENGTH);
-		tw_dev->srb[request_id]->result = (full_command_packet->command.newcommand.status << 1);
+		tw_dev->srb[request_id]->status.combined = (full_command_packet->command.newcommand.status << 1);
 		retval = TW_ISR_DONT_RESULT;
 		goto out;
 	}
@@ -1336,13 +1336,13 @@ static irqreturn_t twa_interrupt(int irq, void *dev_instance)
 				twa_scsiop_execute_scsi_complete(tw_dev, request_id);
 				/* If no error command was a success */
 				if (error == 0) {
-					cmd->result = (DID_OK << 16);
+					cmd->status.combined = (DID_OK << 16);
 				}
 
 				/* If error, command failed */
 				if (error == 1) {
 					/* Ask for a host reset */
-					cmd->result = (DID_OK << 16) | (CHECK_CONDITION << 1);
+					cmd->status.combined = (DID_OK << 16) | SAM_STAT_CHECK_CONDITION;
 				}
 
 				/* Report residual bytes for single sgl */
@@ -1595,7 +1595,7 @@ static int twa_reset_device_extension(TW_Device_Extension *tw_dev)
 			if (tw_dev->srb[i]) {
 				struct scsi_cmnd *cmd = tw_dev->srb[i];
 
-				cmd->result = (DID_RESET << 16);
+				cmd->status.combined = (DID_RESET << 16);
 				if (twa_command_mapped(cmd))
 					scsi_dma_unmap(cmd);
 				cmd->scsi_done(cmd);
@@ -1759,7 +1759,7 @@ static int twa_scsi_queue_lck(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_
 
 	/* Check if this FW supports luns */
 	if ((SCpnt->device->lun != 0) && (tw_dev->tw_compat_info.working_srl < TW_FW_SRL_LUNS_SUPPORTED)) {
-		SCpnt->result = (DID_BAD_TARGET << 16);
+		SCpnt->status.combined = (DID_BAD_TARGET << 16);
 		done(SCpnt);
 		retval = 0;
 		goto out;
@@ -1782,7 +1782,7 @@ static int twa_scsi_queue_lck(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_
 		twa_free_request_id(tw_dev, request_id);
 		break;
 	case 1:
-		SCpnt->result = (DID_ERROR << 16);
+		SCpnt->status.combined = (DID_ERROR << 16);
 		if (twa_command_mapped(SCpnt))
 			scsi_dma_unmap(SCpnt);
 		done(SCpnt);
diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
index 4fde39da54e4..2f025e343908 100644
--- a/drivers/scsi/3w-sas.c
+++ b/drivers/scsi/3w-sas.c
@@ -887,7 +887,7 @@ static int twl_fill_sense(TW_Device_Extension *tw_dev, int i, int request_id, in
 
 	if (copy_sense) {
 		memcpy(tw_dev->srb[request_id]->sense_buffer, header->sense_data, TW_SENSE_DATA_LENGTH);
-		tw_dev->srb[request_id]->result = (full_command_packet->command.newcommand.status << 1);
+		tw_dev->srb[request_id]->status.combined = (full_command_packet->command.newcommand.status << 1);
 		goto out;
 	}
 out:
@@ -1206,7 +1206,7 @@ static irqreturn_t twl_interrupt(int irq, void *dev_instance)
 			cmd = tw_dev->srb[request_id];
 
 			if (!error)
-				cmd->result = (DID_OK << 16);
+				cmd->status.combined = (DID_OK << 16);
 
 			/* Report residual bytes for single sgl */
 			if ((scsi_sg_count(cmd) <= 1) && (full_command_packet->command.newcommand.status == 0)) {
@@ -1367,7 +1367,7 @@ static int twl_reset_device_extension(TW_Device_Extension *tw_dev, int ioctl_res
 			struct scsi_cmnd *cmd = tw_dev->srb[i];
 
 			if (cmd) {
-				cmd->result = (DID_RESET << 16);
+				cmd->status.combined = (DID_RESET << 16);
 				scsi_dma_unmap(cmd);
 				cmd->scsi_done(cmd);
 			}
@@ -1474,7 +1474,7 @@ static int twl_scsi_queue_lck(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_
 	if (retval) {
 		tw_dev->state[request_id] = TW_S_COMPLETED;
 		twl_free_request_id(tw_dev, request_id);
-		SCpnt->result = (DID_ERROR << 16);
+		SCpnt->status.combined = (DID_ERROR << 16);
 		done(SCpnt);
 		retval = 0;
 	}
diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index a7292883b72b..370d8719ca56 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -429,7 +429,7 @@ static int tw_decode_sense(TW_Device_Extension *tw_dev, int request_id, int fill
 					/* Additional sense code qualifier */
 					tw_dev->srb[request_id]->sense_buffer[13] = tw_sense_table[i][3];
 
-					tw_dev->srb[request_id]->result = (DID_OK << 16) | (CHECK_CONDITION << 1);
+					tw_dev->srb[request_id]->status.combined = (DID_OK << 16) | SAM_STAT_CHECK_CONDITION;
 					return TW_ISR_DONT_RESULT; /* Special case for isr to not over-write result */
 				}
 			}
@@ -1159,7 +1159,7 @@ static int tw_setfeature(TW_Device_Extension *tw_dev, int parm, int param_size,
 		printk(KERN_WARNING "3w-xxxx: tw_setfeature(): Bad alignment physical address.\n");
 		tw_dev->state[request_id] = TW_S_COMPLETED;
 		tw_state_request_finish(tw_dev, request_id);
-		tw_dev->srb[request_id]->result = (DID_OK << 16);
+		tw_dev->srb[request_id]->status.combined = (DID_OK << 16);
 		tw_dev->srb[request_id]->scsi_done(tw_dev->srb[request_id]);
 	}
 	command_packet->byte8.param.sgl[0].address = param_value;
@@ -1303,7 +1303,7 @@ static int tw_reset_device_extension(TW_Device_Extension *tw_dev)
 		    (tw_dev->state[i] != TW_S_COMPLETED)) {
 			srb = tw_dev->srb[i];
 			if (srb != NULL) {
-				srb->result = (DID_RESET << 16);
+				srb->status.combined = (DID_RESET << 16);
 				scsi_dma_unmap(srb);
 				srb->scsi_done(srb);
 			}
@@ -1483,7 +1483,7 @@ static int tw_scsiop_inquiry_complete(TW_Device_Extension *tw_dev, int request_i
 		tw_dev->is_unit_present[tw_dev->srb[request_id]->device->id] = 1;
 	} else {
 		tw_dev->is_unit_present[tw_dev->srb[request_id]->device->id] = 0;
-		tw_dev->srb[request_id]->result = (DID_BAD_TARGET << 16);
+		tw_dev->srb[request_id]->status.combined = (DID_BAD_TARGET << 16);
 		return TW_ISR_DONT_RESULT;
 	}
 
@@ -1504,7 +1504,7 @@ static int tw_scsiop_mode_sense(TW_Device_Extension *tw_dev, int request_id)
 	if (tw_dev->srb[request_id]->cmnd[2] != 0x8) {
 		tw_dev->state[request_id] = TW_S_COMPLETED;
 		tw_state_request_finish(tw_dev, request_id);
-		tw_dev->srb[request_id]->result = (DID_OK << 16);
+		tw_dev->srb[request_id]->status.combined = (DID_OK << 16);
 		tw_dev->srb[request_id]->scsi_done(tw_dev->srb[request_id]);
 		return 0;
 	}
@@ -1795,7 +1795,7 @@ static int tw_scsiop_request_sense(TW_Device_Extension *tw_dev, int request_id)
 	tw_state_request_finish(tw_dev, request_id);
 
 	/* If we got a request_sense, we probably want a reset, return error */
-	tw_dev->srb[request_id]->result = (DID_ERROR << 16);
+	tw_dev->srb[request_id]->status.combined = (DID_ERROR << 16);
 	tw_dev->srb[request_id]->scsi_done(tw_dev->srb[request_id]);
 
 	return 0;
@@ -1910,7 +1910,7 @@ static int tw_scsiop_test_unit_ready_complete(TW_Device_Extension *tw_dev, int r
 		tw_dev->is_unit_present[tw_dev->srb[request_id]->device->id] = 1;
 	} else {
 		tw_dev->is_unit_present[tw_dev->srb[request_id]->device->id] = 0;
-		tw_dev->srb[request_id]->result = (DID_BAD_TARGET << 16);
+		tw_dev->srb[request_id]->status.combined = (DID_BAD_TARGET << 16);
 		return TW_ISR_DONT_RESULT;
 	}
 
@@ -1984,7 +1984,7 @@ static int tw_scsi_queue_lck(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_c
 	if (retval) {
 		tw_dev->state[request_id] = TW_S_COMPLETED;
 		tw_state_request_finish(tw_dev, request_id);
-		SCpnt->result = (DID_ERROR << 16);
+		SCpnt->status.combined = (DID_ERROR << 16);
 		done(SCpnt);
 		retval = 0;
 	}
@@ -2153,13 +2153,13 @@ static irqreturn_t tw_interrupt(int irq, void *dev_instance)
 
 				/* If no error command was a success */
 				if (error == 0) {
-					tw_dev->srb[request_id]->result = (DID_OK << 16);
+					tw_dev->srb[request_id]->status.combined = (DID_OK << 16);
 				}
 
 				/* If error, command failed */
 				if (error == 1) {
 					/* Ask for a host reset */
-					tw_dev->srb[request_id]->result = (DID_OK << 16) | (CHECK_CONDITION << 1);
+					tw_dev->srb[request_id]->status.combined = (DID_OK << 16) | SAM_STAT_CHECK_CONDITION;
 				}
 
 				/* Now complete the io */
