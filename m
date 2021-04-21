Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A873C43603
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 17:50:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC45961409
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 17:50:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245027AbhDURvC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 13:51:02 -0400
Received: from mx2.suse.de ([195.135.220.15]:52328 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245065AbhDURtN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Apr 2021 13:49:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D50E5B2DE;
        Wed, 21 Apr 2021 17:48:01 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 23/42] nsp32: use standard macros to set SCSI result
Date:   Wed, 21 Apr 2021 19:47:30 +0200
Message-Id: <20210421174749.11221-24-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210421174749.11221-1-hare@suse.de>
References: <20210421174749.11221-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use standard macros to set the SCSI result to avoid shift and mask
error.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/nsp32.c | 47 ++++++++++++++++++++++----------------------
 1 file changed, 24 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index 134bbd2d8b66..4a12ee577f2a 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -461,7 +461,7 @@ static int nsp32_selection_autopara(struct scsi_cmnd *SCpnt)
 	if (phase != BUSMON_BUS_FREE) {
 		nsp32_msg(KERN_WARNING, "bus busy");
 		show_busphase(phase & BUSMON_PHASE_MASK);
-		SCpnt->result = DID_BUS_BUSY << 16;
+		set_host_byte(SCpnt, DID_BUS_BUSY);
 		return FALSE;
 	}
 
@@ -473,7 +473,7 @@ static int nsp32_selection_autopara(struct scsi_cmnd *SCpnt)
 	 */
 	if (data->msgout_len == 0) {
 		nsp32_msg(KERN_ERR, "SCSI MsgOut without any message!");
-		SCpnt->result = DID_ERROR << 16;
+		set_host_byte(SCpnt, DID_ERROR);
 		return FALSE;
 	} else if (data->msgout_len > 0 && data->msgout_len <= 3) {
 		msgout = 0;
@@ -596,7 +596,7 @@ static int nsp32_selection_autoscsi(struct scsi_cmnd *SCpnt)
 	phase = nsp32_read1(base, SCSI_BUS_MONITOR);
 	if ((phase & BUSMON_BSY) || (phase & BUSMON_SEL)) {
 		nsp32_msg(KERN_WARNING, "bus busy");
-		SCpnt->result = DID_BUS_BUSY << 16;
+		set_host_byte(SCpnt, DID_BUS_BUSY);
 		status = 1;
 		goto out;
         }
@@ -632,7 +632,7 @@ static int nsp32_selection_autoscsi(struct scsi_cmnd *SCpnt)
 	 */
 	if (data->msgout_len == 0) {
 		nsp32_msg(KERN_ERR, "SCSI MsgOut without any message!");
-		SCpnt->result = DID_ERROR << 16;
+		set_host_byte(SCpnt, DID_ERROR);
 		status = 1;
 		goto out;
 	} else if (data->msgout_len > 0 && data->msgout_len <= 3) {
@@ -762,11 +762,10 @@ static int nsp32_arbitration(struct scsi_cmnd *SCpnt, unsigned int base)
 
 	if (arbit & ARBIT_WIN) {
 		/* Arbitration succeeded */
-		SCpnt->result = DID_OK << 16;
 		nsp32_index_write1(base, EXT_PORT, LED_ON); /* PCI LED on */
 	} else if (arbit & ARBIT_FAIL) {
 		/* Arbitration failed */
-		SCpnt->result = DID_BUS_BUSY << 16;
+		set_host_byte(SCpnt, DID_BUS_BUSY);
 		status = FALSE;
 	} else {
 		/*
@@ -774,7 +773,7 @@ static int nsp32_arbitration(struct scsi_cmnd *SCpnt, unsigned int base)
 		 * something lock up! guess no connection.
 		 */
 		nsp32_dbg(NSP32_DEBUG_AUTOSCSI, "arbit timeout");
-		SCpnt->result = DID_NO_CONNECT << 16;
+		set_host_byte(SCpnt, DID_NO_CONNECT);
 		status = FALSE;
         }
 
@@ -907,10 +906,12 @@ static int nsp32_queuecommand_lck(struct scsi_cmnd *SCpnt, void (*done)(struct s
 		  SCpnt->device->id, SCpnt->device->lun, SCpnt->cmnd[0], SCpnt->cmd_len,
 		  scsi_sg_count(SCpnt), scsi_sglist(SCpnt), scsi_bufflen(SCpnt));
 
+	set_host_byte(SCpnt, DID_OK);
+	set_status_byte(SCpnt, SAM_STAT_GOOD);
 	if (data->CurrentSC != NULL) {
 		nsp32_msg(KERN_ERR, "Currentsc != NULL. Cancel this command request");
 		data->CurrentSC = NULL;
-		SCpnt->result   = DID_NO_CONNECT << 16;
+		set_host_byte(SCpnt, DID_NO_CONNECT);
 		done(SCpnt);
 		return 0;
 	}
@@ -918,7 +919,7 @@ static int nsp32_queuecommand_lck(struct scsi_cmnd *SCpnt, void (*done)(struct s
 	/* check target ID is not same as this initiator ID */
 	if (scmd_id(SCpnt) == SCpnt->device->host->this_id) {
 		nsp32_dbg(NSP32_DEBUG_QUEUECOMMAND, "target==host???");
-		SCpnt->result = DID_BAD_TARGET << 16;
+		set_host_byte(SCpnt, DID_BAD_TARGET);
 		done(SCpnt);
 		return 0;
 	}
@@ -926,7 +927,7 @@ static int nsp32_queuecommand_lck(struct scsi_cmnd *SCpnt, void (*done)(struct s
 	/* check target LUN is allowable value */
 	if (SCpnt->device->lun >= MAX_LUN) {
 		nsp32_dbg(NSP32_DEBUG_QUEUECOMMAND, "no more lun");
-		SCpnt->result = DID_BAD_TARGET << 16;
+		set_host_byte(SCpnt, DID_BAD_TARGET);
 		done(SCpnt);
 		return 0;
 	}
@@ -958,7 +959,7 @@ static int nsp32_queuecommand_lck(struct scsi_cmnd *SCpnt, void (*done)(struct s
 	ret = nsp32_setup_sg_table(SCpnt);
 	if (ret == FALSE) {
 		nsp32_msg(KERN_ERR, "SGT fail");
-		SCpnt->result = DID_ERROR << 16;
+		set_host_byte(SCpnt, DID_ERROR);
 		nsp32_scsi_done(SCpnt);
 		return 0;
 	}
@@ -1181,7 +1182,7 @@ static irqreturn_t do_nsp32_isr(int irq, void *dev_id)
 		nsp32_msg(KERN_INFO, "card disconnect");
 		if (data->CurrentSC != NULL) {
 			nsp32_msg(KERN_INFO, "clean up current SCSI command");
-			SCpnt->result = DID_BAD_TARGET << 16;
+			set_host_byte(SCpnt, DID_BAD_TARGET);
 			nsp32_scsi_done(SCpnt);
 		}
 		goto out;
@@ -1199,7 +1200,7 @@ static irqreturn_t do_nsp32_isr(int irq, void *dev_id)
 		nsp32_msg(KERN_INFO, "detected someone do bus reset");
 		nsp32_do_bus_reset(data);
 		if (SCpnt != NULL) {
-			SCpnt->result = DID_RESET << 16;
+			set_host_byte(SCpnt, DID_RESET);
 			nsp32_scsi_done(SCpnt);
 		}
 		goto out;
@@ -1227,7 +1228,7 @@ static irqreturn_t do_nsp32_isr(int irq, void *dev_id)
 			nsp32_dbg(NSP32_DEBUG_INTR,
 				  "selection timeout occurred");
 
-			SCpnt->result = DID_TIME_OUT << 16;
+			set_host_byte(SCpnt, DID_TIME_OUT);
 			nsp32_scsi_done(SCpnt);
 			goto out;
 		}
@@ -1309,7 +1310,8 @@ static irqreturn_t do_nsp32_isr(int irq, void *dev_id)
 			 * low level driver to indicate status), then checks 
 			 * status_byte (SCSI status byte).
 			 */
-			SCpnt->result =	(int)nsp32_read1(base, SCSI_CSB_IN);
+			set_status_byte(SCpnt,
+					nsp32_read1(base, SCSI_CSB_IN));
 		}
 
 		if (auto_stat & ILLEGAL_PHASE) {
@@ -1666,20 +1668,19 @@ static int nsp32_busfree_occur(struct scsi_cmnd *SCpnt, unsigned short execph)
 		nsp32_dbg(NSP32_DEBUG_BUSFREE, "command complete");
 
 		SCpnt->SCp.Status  = nsp32_read1(base, SCSI_CSB_IN);
-		SCpnt->SCp.Message = 0;
+		SCpnt->SCp.Message = COMMAND_COMPLETE;
 		nsp32_dbg(NSP32_DEBUG_BUSFREE, 
 			  "normal end stat=0x%x resid=0x%x\n",
 			  SCpnt->SCp.Status, scsi_get_resid(SCpnt));
-		SCpnt->result = (DID_OK             << 16) |
-			        (SCpnt->SCp.Message <<  8) |
-			        (SCpnt->SCp.Status  <<  0);
+		set_msg_byte(SCpnt, SCpnt->SCp.Message);
+		set_status_byte(SCpnt, SCpnt->SCp.Status);
 		nsp32_scsi_done(SCpnt);
 		/* All operation is done */
 		return TRUE;
 	} else if (execph & MSGIN_04_VALID) {
 		/* MsgIn 04: Disconnect */
-		SCpnt->SCp.Status  = nsp32_read1(base, SCSI_CSB_IN);
-		SCpnt->SCp.Message = 4;
+		set_status_byte(SCpnt, nsp32_read1(base, SCSI_CSB_IN));
+		SCpnt->SCp.Message = DISCONNECT;
 		
 		nsp32_dbg(NSP32_DEBUG_BUSFREE, "disconnect");
 		return TRUE;
@@ -1689,7 +1690,7 @@ static int nsp32_busfree_occur(struct scsi_cmnd *SCpnt, unsigned short execph)
 
 		/* DID_ERROR? */
 		//SCpnt->result   = (DID_OK << 16) | (SCpnt->SCp.Message << 8) | (SCpnt->SCp.Status << 0);
-		SCpnt->result = DID_ERROR << 16;
+		set_host_byte(SCpnt, DID_ERROR);
 		nsp32_scsi_done(SCpnt);
 		return TRUE;
 	}
@@ -2812,7 +2813,7 @@ static int nsp32_eh_abort(struct scsi_cmnd *SCpnt)
 	nsp32_write2(base, TRANSFER_CONTROL, 0);
 	nsp32_write2(base, BM_CNT,           0);
 
-	SCpnt->result = DID_ABORT << 16;
+	set_host_byte(SCpnt, DID_ABORT);
 	nsp32_scsi_done(SCpnt);
 
 	nsp32_dbg(NSP32_DEBUG_BUSRESET, "abort success");
-- 
2.29.2

