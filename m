Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00851C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7E7C613AC
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233508AbhDTAKZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:10:25 -0400
Received: from mail-pj1-f51.google.com ([209.85.216.51]:35787 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233532AbhDTAKK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:10:10 -0400
Received: by mail-pj1-f51.google.com with SMTP id j21-20020a17090ae615b02901505b998b45so6028392pjy.0
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:09:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mJgrlv/bajIW447gGrGIyMDt6KKVT4p81R1iEtYq2Oc=;
        b=ckNoGg9wg1/CbLolmLaUpfp65drEPsuR7u/DG0e4Ylvwt+48lsKc3hAOHK9n0QEvxc
         bauNZ/VQiJt08Twq7ZMeumHlRbB9dlgWJoGc4mIj1/jq8xcuG+ztAPs68EyA2VEPIxs9
         ECH8nzzzb5bhSHoQ93ShOoMZOyFwVJMxnwNU1ijW/1xR+c5mYSRfADiDoxxCqzVDAxZK
         crxo8fc5p0kquNVCnFKRRGQ6DCpqAimcbp+TQg3HKy9PeTGMhs7RiWEJ+x55IWKUfcbY
         Bwh534cBg8oxopQT3zZIeojORDEcJfcw8ZlJv6P1Z+d07F8zAa7b/10IxUHiZQtyRGum
         Nezg==
X-Gm-Message-State: AOAM532V6NDlpkEC/xHxG+5EdJJ+o8/CC9dSCYjlCUhoKziSDyJF/m6v
        N+Sc/VqVAcDUsu8kdnfaVDc=
X-Google-Smtp-Source: ABdhPJyrtXhvGQXjcRPZkoXq1FenNwh3VP6BOhkIfUflkz81QfvlNmdhilduMZYxkUY72A06k/CTdA==
X-Received: by 2002:a17:902:fe8a:b029:e6:5f:62e with SMTP id x10-20020a170902fe8ab02900e6005f062emr25719367plm.48.1618877379734;
        Mon, 19 Apr 2021 17:09:39 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.09.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:09:39 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Oliver Neukum <oliver@neukum.org>,
        Ali Akcaagac <aliakc@web.de>,
        Jamie Lenehan <lenehan@twibble.org>
Subject: [PATCH 041/117] dc395x: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:07:29 -0700
Message-Id: <20210420000845.25873-42-bvanassche@acm.org>
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

Cc: Oliver Neukum <oliver@neukum.org>
Cc: Ali Akcaagac <aliakc@web.de>
Cc: Jamie Lenehan <lenehan@twibble.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/dc395x.c | 44 +++++++++++++++++++++----------------------
 1 file changed, 21 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 6252352ddd96..da52758a374b 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -160,10 +160,8 @@
 #define DC395x_write16(acb,address,value)	outw((value), acb->io_port_base + (address))
 #define DC395x_write32(acb,address,value)	outl((value), acb->io_port_base + (address))
 
-#define RES_DID			0x00FF0000	/* DID_ codes */
-
-#define MK_RES(drv,did,msg,tgt) ((int)(drv)<<24 | (int)(did)<<16 | (int)(msg)<<8 | (int)(tgt))
-#define MK_RES_LNX(drv,did,msg,tgt) ((int)(drv)<<24 | (int)(did)<<16 | (int)(msg)<<8 | (int)(tgt)<<1)
+#define MK_RES(drv,did,msg_byte,tgt) ((union scsi_status){.b={.driver = (drv), .host = (did), .msg = (msg_byte), .status = (tgt)}})
+#define MK_RES_LNX(drv,did,msg,tgt) MK_RES((drv),(did),(msg),(tgt)<<1)
 
 #define TAG_NONE 255
 
@@ -975,7 +973,7 @@ static int dc395x_queue_command_lck(struct scsi_cmnd *cmd, void (*done)(struct s
 		cmd, cmd->device->id, (u8)cmd->device->lun, cmd->cmnd[0]);
 
 	/* Assume BAD_TARGET; will be cleared later */
-	cmd->result = DID_BAD_TARGET << 16;
+	cmd->status.combined = DID_BAD_TARGET << 16;
 
 	/* ignore invalid targets */
 	if (cmd->device->id >= acb->scsi_host->max_id ||
@@ -1002,7 +1000,7 @@ static int dc395x_queue_command_lck(struct scsi_cmnd *cmd, void (*done)(struct s
 
 	/* set callback and clear result in the command */
 	cmd->scsi_done = done;
-	cmd->result = 0;
+	cmd->status.combined = 0;
 
 	srb = list_first_entry_or_null(&acb->srb_free_list,
 			struct ScsiReqBlk, list);
@@ -1239,7 +1237,7 @@ static int dc395x_eh_abort(struct scsi_cmnd *cmd)
 		free_tag(dcb, srb);
 		list_add_tail(&srb->list, &acb->srb_free_list);
 		dprintkl(KERN_DEBUG, "eh_abort: Command was waiting\n");
-		cmd->result = DID_ABORT << 16;
+		cmd->status.combined = DID_ABORT << 16;
 		return SUCCESS;
 	}
 	srb = find_cmd(cmd, &dcb->srb_going_list);
@@ -3175,7 +3173,7 @@ static void srb_done(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
 		 */
 		srb->flag &= ~AUTO_REQSENSE;
 		srb->adapter_status = 0;
-		srb->target_status = CHECK_CONDITION << 1;
+		srb->target_status = SAM_STAT_CHECK_CONDITION;
 		if (debug_enabled(DBG_1)) {
 			switch (cmd->sense_buffer[2] & 0x0f) {
 			case NOT_READY:
@@ -3222,20 +3220,20 @@ static void srb_done(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
 					*((unsigned int *)(cmd->sense_buffer + 3)));
 		}
 
-		if (status == (CHECK_CONDITION << 1)) {
-			cmd->result = DID_BAD_TARGET << 16;
+		if (status == SAM_STAT_CHECK_CONDITION) {
+			cmd->status.combined = DID_BAD_TARGET << 16;
 			goto ckc_e;
 		}
 		dprintkdbg(DBG_0, "srb_done: AUTO_REQSENSE2\n");
 
 		if (srb->total_xfer_length
 		    && srb->total_xfer_length >= cmd->underflow)
-			cmd->result =
+			cmd->status =
 			    MK_RES_LNX(DRIVER_SENSE, DID_OK,
 				       srb->end_message, CHECK_CONDITION);
 		/*set_host_byte(cmd,DID_OK) */
 		else
-			cmd->result =
+			cmd->status =
 			    MK_RES_LNX(DRIVER_SENSE, DID_OK,
 				       srb->end_message, CHECK_CONDITION);
 
@@ -3266,13 +3264,13 @@ static void srb_done(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
 		} else if (status == SCSI_STAT_SEL_TIMEOUT) {
 			srb->adapter_status = H_SEL_TIMEOUT;
 			srb->target_status = 0;
-			cmd->result = DID_NO_CONNECT << 16;
+			cmd->status = (union scsi_status){
+				.b.host = DID_NO_CONNECT};
 		} else {
 			srb->adapter_status = 0;
 			set_host_byte(cmd, DID_ERROR);
 			set_msg_byte(cmd, srb->end_message);
 			set_status_byte(cmd, status);
-
 		}
 	} else {
 		/*
@@ -3311,15 +3309,15 @@ static void srb_done(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
 		base = scsi_kmap_atomic_sg(sg, scsi_sg_count(cmd), &offset, &len);
 		ptr = (struct ScsiInqData *)(base + offset);
 
-		if (!ckc_only && (cmd->result & RES_DID) == 0
+		if (!ckc_only && cmd->status.b.host == DID_OK
 		    && cmd->cmnd[2] == 0 && scsi_bufflen(cmd) >= 8
 		    && dir != DMA_NONE && ptr && (ptr->Vers & 0x07) >= 2)
 			dcb->inquiry7 = ptr->Flags;
 
 	/*if( srb->cmd->cmnd[0] == INQUIRY && */
-	/*  (host_byte(cmd->result) == DID_OK || status_byte(cmd->result) & CHECK_CONDITION) ) */
-		if ((cmd->result == (DID_OK << 16) ||
-		     status_byte(cmd->result) == CHECK_CONDITION)) {
+	/*  (host_byte(cmd->status) == DID_OK || status_byte(cmd->status) & CHECK_CONDITION) ) */
+		if ((cmd->status.combined == (DID_OK << 16) ||
+		     status_byte(cmd->status) == CHECK_CONDITION)) {
 			if (!dcb->init_tcq_flag) {
 				add_dev(acb, dcb, ptr);
 				dcb->init_tcq_flag = 1;
@@ -3346,7 +3344,7 @@ static void srb_done(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
 	if (srb != acb->tmp_srb) {
 		/* Add to free list */
 		dprintkdbg(DBG_0, "srb_done: (0x%p) done result=0x%08x\n",
-			cmd, cmd->result);
+			cmd, cmd->status.combined);
 		list_move_tail(&srb->list, &acb->srb_free_list);
 	} else {
 		dprintkl(KERN_ERR, "srb_done: ERROR! Completed cmd with tmp_srb\n");
@@ -3370,7 +3368,7 @@ static void doing_srb_done(struct AdapterCtlBlk *acb, u8 did_flag,
 		struct scsi_cmnd *p;
 
 		list_for_each_entry_safe(srb, tmp, &dcb->srb_going_list, list) {
-			int result;
+			union scsi_status result;
 
 			p = srb->cmd;
 			result = MK_RES(0, did_flag, 0, 0);
@@ -3379,7 +3377,7 @@ static void doing_srb_done(struct AdapterCtlBlk *acb, u8 did_flag,
 			list_del(&srb->list);
 			free_tag(dcb, srb);
 			list_add_tail(&srb->list, &acb->srb_free_list);
-			p->result = result;
+			p->status = result;
 			pci_unmap_srb_sense(acb, srb);
 			pci_unmap_srb(acb, srb);
 			if (force) {
@@ -3400,14 +3398,14 @@ static void doing_srb_done(struct AdapterCtlBlk *acb, u8 did_flag,
 
 		/* Waiting queue */
 		list_for_each_entry_safe(srb, tmp, &dcb->srb_waiting_list, list) {
-			int result;
+			union scsi_status result;
 			p = srb->cmd;
 
 			result = MK_RES(0, did_flag, 0, 0);
 			printk("W:%p<%02i-%i>", p, p->device->id,
 			       (u8)p->device->lun);
 			list_move_tail(&srb->list, &acb->srb_free_list);
-			p->result = result;
+			p->status = result;
 			pci_unmap_srb_sense(acb, srb);
 			pci_unmap_srb(acb, srb);
 			if (force) {
