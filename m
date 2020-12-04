Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12F57C2BB48
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 10:04:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7E5F22525
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 10:04:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729212AbgLDKDq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Dec 2020 05:03:46 -0500
Received: from mx2.suse.de ([195.135.220.15]:51214 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729408AbgLDKDp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 4 Dec 2020 05:03:45 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7B34BAF3E;
        Fri,  4 Dec 2020 10:01:48 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 36/37] dc395x: drop internal result accessors
Date:   Fri,  4 Dec 2020 11:01:39 +0100
Message-Id: <20201204100140.140863-37-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20201204100140.140863-1-hare@suse.de>
References: <20201204100140.140863-1-hare@suse.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Drop the internal SCSI result accessors and use the
midlayer-defined ones.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/dc395x.c | 85 +++++++++++++++++++++------------------------------
 1 file changed, 34 insertions(+), 51 deletions(-)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index b1125012bee0..f44e5390ef0d 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -160,22 +160,6 @@
 #define DC395x_write16(acb,address,value)	outw((value), acb->io_port_base + (address))
 #define DC395x_write32(acb,address,value)	outl((value), acb->io_port_base + (address))
 
-/* cmd->result */
-#define RES_TARGET		0x000000FF	/* Target State */
-#define RES_TARGET_LNX  STATUS_MASK	/* Only official ... */
-#define RES_ENDMSG		0x0000FF00	/* End Message */
-#define RES_DID			0x00FF0000	/* DID_ codes */
-#define RES_DRV			0xFF000000	/* DRIVER_ codes */
-
-#define MK_RES(drv,did,msg,tgt) ((int)(drv)<<24 | (int)(did)<<16 | (int)(msg)<<8 | (int)(tgt))
-#define MK_RES_LNX(drv,did,msg,tgt) ((int)(drv)<<24 | (int)(did)<<16 | (int)(msg)<<8 | (int)(tgt)<<1)
-
-#define SET_RES_TARGET(who,tgt) { who &= ~RES_TARGET; who |= (int)(tgt); }
-#define SET_RES_TARGET_LNX(who,tgt) { who &= ~RES_TARGET_LNX; who |= (int)(tgt) << 1; }
-#define SET_RES_MSG(who,msg) { who &= ~RES_ENDMSG; who |= (int)(msg) << 8; }
-#define SET_RES_DID(who,did) { who &= ~RES_DID; who |= (int)(did) << 16; }
-#define SET_RES_DRV(who,drv) { who &= ~RES_DRV; who |= (int)(drv) << 24; }
-
 #define TAG_NONE 255
 
 /*
@@ -986,7 +970,8 @@ static int dc395x_queue_command_lck(struct scsi_cmnd *cmd, void (*done)(struct s
 		cmd, cmd->device->id, (u8)cmd->device->lun, cmd->cmnd[0]);
 
 	/* Assume BAD_TARGET; will be cleared later */
-	cmd->result = DID_BAD_TARGET << 16;
+	cmd->result = 0;
+	set_host_byte(cmd, DID_BAD_TARGET);
 
 	/* ignore invalid targets */
 	if (cmd->device->id >= acb->scsi_host->max_id ||
@@ -1250,7 +1235,8 @@ static int dc395x_eh_abort(struct scsi_cmnd *cmd)
 		free_tag(dcb, srb);
 		list_add_tail(&srb->list, &acb->srb_free_list);
 		dprintkl(KERN_DEBUG, "eh_abort: Command was waiting\n");
-		cmd->result = DID_ABORT << 16;
+		cmd->result = 0;
+		set_host_byte(cmd, DID_ABORT);
 		return SUCCESS;
 	}
 	srb = find_cmd(cmd, &dcb->srb_going_list);
@@ -3178,6 +3164,7 @@ static void srb_done(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
 	dprintkdbg(DBG_SG, "srb_done: srb=%p sg=%i(%i/%i) buf=%p\n",
 		   srb, scsi_sg_count(cmd), srb->sg_index, srb->sg_count,
 		   scsi_sgtalbe(cmd));
+	cmd->result = 0;
 	status = srb->target_status;
 	if (srb->flag & AUTO_REQSENSE) {
 		dprintkdbg(DBG_0, "srb_done: AUTO_REQSENSE1\n");
@@ -3187,7 +3174,7 @@ static void srb_done(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
 		 */
 		srb->flag &= ~AUTO_REQSENSE;
 		srb->adapter_status = 0;
-		srb->target_status = CHECK_CONDITION << 1;
+		srb->target_status = SAM_STAT_CHECK_CONDITION;
 		if (debug_enabled(DBG_1)) {
 			switch (cmd->sense_buffer[2] & 0x0f) {
 			case NOT_READY:
@@ -3234,23 +3221,22 @@ static void srb_done(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
 					*((unsigned int *)(cmd->sense_buffer + 3)));
 		}
 
-		if (status == (CHECK_CONDITION << 1)) {
-			cmd->result = DID_BAD_TARGET << 16;
+		if (status == SAM_STAT_CHECK_CONDITION) {
+			set_host_byte(cmd, DID_BAD_TARGET);
 			goto ckc_e;
 		}
 		dprintkdbg(DBG_0, "srb_done: AUTO_REQSENSE2\n");
 
 		if (srb->total_xfer_length
-		    && srb->total_xfer_length >= cmd->underflow)
-			cmd->result =
-			    MK_RES_LNX(DRIVER_SENSE, DID_OK,
-				       srb->end_message, CHECK_CONDITION);
-		/*SET_RES_DID(cmd->result,DID_OK) */
-		else
-			cmd->result =
-			    MK_RES_LNX(DRIVER_SENSE, DID_OK,
-				       srb->end_message, CHECK_CONDITION);
-
+		    && srb->total_xfer_length >= cmd->underflow) {
+			set_driver_byte(cmd, DRIVER_SENSE);
+			set_msg_byte(cmd, srb->end_message);
+			set_status_byte(cmd, SAM_STAT_CHECK_CONDITION);
+		} else {
+			set_driver_byte(cmd, DRIVER_SENSE);
+			set_msg_byte(cmd, srb->end_message);
+			set_status_byte(cmd, SAM_STAT_CHECK_CONDITION);
+		}
 		goto ckc_e;
 	}
 
@@ -3259,10 +3245,10 @@ static void srb_done(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
 		/*
 		 * target status..........................
 		 */
-		if (status_byte(status) == CHECK_CONDITION) {
+		if (status == SAM_STAT_CHECK_CONDITION) {
 			request_sense(acb, dcb, srb);
 			return;
-		} else if (status_byte(status) == QUEUE_FULL) {
+		} else if (status == SAM_STAT_TASK_SET_FULL) {
 			tempcnt = (u8)list_size(&dcb->srb_going_list);
 			dprintkl(KERN_INFO, "QUEUE_FULL for dev <%02i-%i> with %i cmnds\n",
 			     dcb->target_id, dcb->target_lun, tempcnt);
@@ -3278,12 +3264,12 @@ static void srb_done(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
 		} else if (status == SCSI_STAT_SEL_TIMEOUT) {
 			srb->adapter_status = H_SEL_TIMEOUT;
 			srb->target_status = 0;
-			cmd->result = DID_NO_CONNECT << 16;
+			set_host_byte(cmd, DID_NO_CONNECT);
 		} else {
 			srb->adapter_status = 0;
-			SET_RES_DID(cmd->result, DID_ERROR);
-			SET_RES_MSG(cmd->result, srb->end_message);
-			SET_RES_TARGET(cmd->result, status);
+			set_host_byte(cmd, DID_ERROR);
+			set_msg_byte(cmd, srb->end_message);
+			set_status_byte(cmd, status);
 
 		}
 	} else {
@@ -3293,16 +3279,16 @@ static void srb_done(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
 		status = srb->adapter_status;
 		if (status & H_OVER_UNDER_RUN) {
 			srb->target_status = 0;
-			SET_RES_DID(cmd->result, DID_OK);
-			SET_RES_MSG(cmd->result, srb->end_message);
+			set_host_byte(cmd, DID_OK);
+			set_msg_byte(cmd, srb->end_message);
 		} else if (srb->status & PARITY_ERROR) {
-			SET_RES_DID(cmd->result, DID_PARITY);
-			SET_RES_MSG(cmd->result, srb->end_message);
+			set_host_byte(cmd, DID_PARITY);
+			set_msg_byte(cmd, srb->end_message);
 		} else {	/* No error */
 
 			srb->adapter_status = 0;
 			srb->target_status = 0;
-			SET_RES_DID(cmd->result, DID_OK);
+			set_host_byte(cmd, DID_OK);
 		}
 	}
 
@@ -3323,14 +3309,14 @@ static void srb_done(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
 		base = scsi_kmap_atomic_sg(sg, scsi_sg_count(cmd), &offset, &len);
 		ptr = (struct ScsiInqData *)(base + offset);
 
-		if (!ckc_only && (cmd->result & RES_DID) == 0
+		if (!ckc_only && host_byte(cmd->result) == DID_OK
 		    && cmd->cmnd[2] == 0 && scsi_bufflen(cmd) >= 8
 		    && dir != DMA_NONE && ptr && (ptr->Vers & 0x07) >= 2)
 			dcb->inquiry7 = ptr->Flags;
 
 	/*if( srb->cmd->cmnd[0] == INQUIRY && */
 	/*  (host_byte(cmd->result) == DID_OK || status_byte(cmd->result) & CHECK_CONDITION) ) */
-		if ((cmd->result == (DID_OK << 16) ||
+		if (cmd->result == 0 ||
 		     status_byte(cmd->result) == CHECK_CONDITION)) {
 			if (!dcb->init_tcq_flag) {
 				add_dev(acb, dcb, ptr);
@@ -3382,16 +3368,14 @@ static void doing_srb_done(struct AdapterCtlBlk *acb, u8 did_flag,
 		struct scsi_cmnd *p;
 
 		list_for_each_entry_safe(srb, tmp, &dcb->srb_going_list, list) {
-			int result;
-
 			p = srb->cmd;
-			result = MK_RES(0, did_flag, 0, 0);
 			printk("G:%p(%02i-%i) ", p,
 			       p->device->id, (u8)p->device->lun);
 			list_del(&srb->list);
 			free_tag(dcb, srb);
 			list_add_tail(&srb->list, &acb->srb_free_list);
-			p->result = result;
+			p->result = 0;
+			set_host_byte(p, did_flag);
 			pci_unmap_srb_sense(acb, srb);
 			pci_unmap_srb(acb, srb);
 			if (force) {
@@ -3412,14 +3396,13 @@ static void doing_srb_done(struct AdapterCtlBlk *acb, u8 did_flag,
 
 		/* Waiting queue */
 		list_for_each_entry_safe(srb, tmp, &dcb->srb_waiting_list, list) {
-			int result;
 			p = srb->cmd;
 
-			result = MK_RES(0, did_flag, 0, 0);
 			printk("W:%p<%02i-%i>", p, p->device->id,
 			       (u8)p->device->lun);
 			list_move_tail(&srb->list, &acb->srb_free_list);
-			p->result = result;
+			p->result = 0;
+			set_host_byte(p, did_flag);
 			pci_unmap_srb_sense(acb, srb);
 			pci_unmap_srb(acb, srb);
 			if (force) {
-- 
2.16.4

