From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 23/36] aha1524: Use struct scsi_cmnd
Date: Fri,  6 Feb 2015 23:11:44 +0100
Message-ID: <1423260717-15944-24-git-send-email-linux@rainbow-software.org>
References: <1423260717-15944-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56967 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758250AbbBFWQB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Feb 2015 17:16:01 -0500
Received: from stip-static-68.213-81-217.telecom.sk ([213.81.217.68] helo=gsql.ggedos.sk)
	by gsystem.sk with esmtpsa (TLS1.1:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <linux@rainbow-software.org>)
	id 1YJr8G-0006fF-OU
	for linux-scsi@vger.kernel.org; Fri, 06 Feb 2015 23:12:12 +0100
In-Reply-To: <1423260717-15944-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Use struct scsi_cmnd instead of Scsi_Cmnd and also rename the variables
to get rid of SC prefix

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/aha1542.c |  150 ++++++++++++++++++++++++------------------------
 1 file changed, 75 insertions(+), 75 deletions(-)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index dbe4659..dcc493d 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -86,7 +86,7 @@ struct aha1542_hostdata {
 	int bios_translation;	/* Mapping bios uses - for compatibility */
 	int aha1542_last_mbi_used;
 	int aha1542_last_mbo_used;
-	Scsi_Cmnd *SCint[AHA1542_MAILBOXES];
+	struct scsi_cmnd *int_cmds[AHA1542_MAILBOXES];
 	struct mailbox mb[2 * AHA1542_MAILBOXES];
 	struct ccb ccb[AHA1542_MAILBOXES];
 };
@@ -296,11 +296,11 @@ static int aha1542_test_port(int bse, struct Scsi_Host *shpnt)
 static void aha1542_intr_handle(struct Scsi_Host *shost)
 {
 	struct aha1542_hostdata *aha1542 = shost_priv(shost);
-	void (*my_done) (Scsi_Cmnd *) = NULL;
+	void (*my_done)(struct scsi_cmnd *) = NULL;
 	int errstatus, mbi, mbo, mbistatus;
 	int number_serviced;
 	unsigned long flags;
-	Scsi_Cmnd *SCtmp;
+	struct scsi_cmnd *tmp_cmd;
 	int flag;
 	struct mailbox *mb = aha1542->mb;
 	struct ccb *ccb = aha1542->ccb;
@@ -383,22 +383,22 @@ static void aha1542_intr_handle(struct Scsi_Host *shost)
 		printk(KERN_DEBUG "...done %d %d\n", mbo, mbi);
 #endif
 
-		SCtmp = aha1542->SCint[mbo];
+		tmp_cmd = aha1542->int_cmds[mbo];
 
-		if (!SCtmp || !SCtmp->scsi_done) {
+		if (!tmp_cmd || !tmp_cmd->scsi_done) {
 			printk(KERN_WARNING "aha1542_intr_handle: Unexpected interrupt\n");
 			printk(KERN_WARNING "tarstat=%x, hastat=%x idlun=%x ccb#=%d \n", ccb[mbo].tarstat,
 			       ccb[mbo].hastat, ccb[mbo].idlun, mbo);
 			return;
 		}
-		my_done = SCtmp->scsi_done;
-		kfree(SCtmp->host_scribble);
-		SCtmp->host_scribble = NULL;
+		my_done = tmp_cmd->scsi_done;
+		kfree(tmp_cmd->host_scribble);
+		tmp_cmd->host_scribble = NULL;
 		/* Fetch the sense data, and tuck it away, in the required slot.  The
 		   Adaptec automatically fetches it, and there is no guarantee that
 		   we will still have it in the cdb when we come back */
 		if (ccb[mbo].tarstat == 2)
-			memcpy(SCtmp->sense_buffer, &ccb[mbo].cdb[ccb[mbo].cdblen],
+			memcpy(tmp_cmd->sense_buffer, &ccb[mbo].cdb[ccb[mbo].cdblen],
 			       SCSI_SENSE_BUFFERSIZE);
 
 
@@ -435,10 +435,10 @@ static void aha1542_intr_handle(struct Scsi_Host *shost)
 			 */
 		}
 		DEB(if (errstatus) printk("aha1542_intr_handle: returning %6x\n", errstatus));
-		SCtmp->result = errstatus;
-		aha1542->SCint[mbo] = NULL;	/* This effectively frees up the mailbox slot, as
+		tmp_cmd->result = errstatus;
+		aha1542->int_cmds[mbo] = NULL;	/* This effectively frees up the mailbox slot, as
 						   far as queuecommand is concerned */
-		my_done(SCtmp);
+		my_done(tmp_cmd);
 		number_serviced++;
 	};
 }
@@ -455,14 +455,14 @@ static irqreturn_t do_aha1542_intr_handle(int dummy, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static int aha1542_queuecommand_lck(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
+static int aha1542_queuecommand_lck(struct scsi_cmnd *cmd, void (*done) (struct scsi_cmnd *))
 {
-	struct aha1542_hostdata *aha1542 = shost_priv(SCpnt->device->host);
+	struct aha1542_hostdata *aha1542 = shost_priv(cmd->device->host);
 	u8 direction;
-	u8 target = SCpnt->device->id;
-	u8 lun = SCpnt->device->lun;
+	u8 target = cmd->device->id;
+	u8 lun = cmd->device->lun;
 	unsigned long flags;
-	int bufflen = scsi_bufflen(SCpnt);
+	int bufflen = scsi_bufflen(cmd);
 	int mbo;
 	struct mailbox *mb = aha1542->mb;
 	struct ccb *ccb = aha1542->ccb;
@@ -470,33 +470,33 @@ static int aha1542_queuecommand_lck(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *
 	DEB(int i);
 
 	DEB(if (target > 1) {
-	    SCpnt->result = DID_TIME_OUT << 16;
-	    done(SCpnt); return 0;
+	    cmd->result = DID_TIME_OUT << 16;
+	    done(cmd); return 0;
 	    }
 	);
 
-	if (*SCpnt->cmnd == REQUEST_SENSE) {
+	if (*cmd->cmnd == REQUEST_SENSE) {
 		/* Don't do the command - we have the sense data already */
-		SCpnt->result = 0;
-		done(SCpnt);
+		cmd->result = 0;
+		done(cmd);
 		return 0;
 	}
 #ifdef DEBUG
-	if (*SCpnt->cmnd == READ_10 || *SCpnt->cmnd == WRITE_10)
-		i = xscsi2int(SCpnt->cmnd + 2);
-	else if (*SCpnt->cmnd == READ_6 || *SCpnt->cmnd == WRITE_6)
-		i = scsi2int(SCpnt->cmnd + 2);
+	if (*cmd->cmnd == READ_10 || *cmd->cmnd == WRITE_10)
+		i = xscsi2int(cmd->cmnd + 2);
+	else if (*cmd->cmnd == READ_6 || *cmd->cmnd == WRITE_6)
+		i = scsi2int(cmd->cmnd + 2);
 	else
 		i = -1;
 	if (done)
-		printk(KERN_DEBUG "aha1542_queuecommand: dev %d cmd %02x pos %d len %d ", target, *SCpnt->cmnd, i, bufflen);
+		printk(KERN_DEBUG "aha1542_queuecommand: dev %d cmd %02x pos %d len %d ", target, *cmd->cmnd, i, bufflen);
 	else
-		printk(KERN_DEBUG "aha1542_command: dev %d cmd %02x pos %d len %d ", target, *SCpnt->cmnd, i, bufflen);
+		printk(KERN_DEBUG "aha1542_command: dev %d cmd %02x pos %d len %d ", target, *cmd->cmnd, i, bufflen);
 	printk(KERN_DEBUG "aha1542_queuecommand: dumping scsi cmd:");
-	for (i = 0; i < SCpnt->cmd_len; i++)
-		printk("%02x ", SCpnt->cmnd[i]);
+	for (i = 0; i < cmd->cmd_len; i++)
+		printk("%02x ", cmd->cmnd[i]);
 	printk("\n");
-	if (*SCpnt->cmnd == WRITE_10 || *SCpnt->cmnd == WRITE_6)
+	if (*cmd->cmnd == WRITE_10 || *cmd->cmnd == WRITE_6)
 		return 0;	/* we are still testing, so *don't* write */
 #endif
 	/* Use the outgoing mailboxes in a round-robin fashion, because this
@@ -508,17 +508,17 @@ static int aha1542_queuecommand_lck(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *
 		mbo = 0;
 
 	do {
-		if (mb[mbo].status == 0 && aha1542->SCint[mbo] == NULL)
+		if (mb[mbo].status == 0 && aha1542->int_cmds[mbo] == NULL)
 			break;
 		mbo++;
 		if (mbo >= AHA1542_MAILBOXES)
 			mbo = 0;
 	} while (mbo != aha1542->aha1542_last_mbo_used);
 
-	if (mb[mbo].status || aha1542->SCint[mbo])
+	if (mb[mbo].status || aha1542->int_cmds[mbo])
 		panic("Unable to find empty mailbox for aha1542.\n");
 
-	aha1542->SCint[mbo] = SCpnt;	/* This will effectively prevent someone else from
+	aha1542->int_cmds[mbo] = cmd;	/* This will effectively prevent someone else from
 					   screwing with this cdb. */
 
 	aha1542->aha1542_last_mbo_used = mbo;
@@ -532,15 +532,15 @@ static int aha1542_queuecommand_lck(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *
 
 	memset(&ccb[mbo], 0, sizeof(struct ccb));
 
-	ccb[mbo].cdblen = SCpnt->cmd_len;
+	ccb[mbo].cdblen = cmd->cmd_len;
 
 	direction = 0;
-	if (*SCpnt->cmnd == READ_10 || *SCpnt->cmnd == READ_6)
+	if (*cmd->cmnd == READ_10 || *cmd->cmnd == READ_6)
 		direction = 8;
-	else if (*SCpnt->cmnd == WRITE_10 || *SCpnt->cmnd == WRITE_6)
+	else if (*cmd->cmnd == WRITE_10 || *cmd->cmnd == WRITE_6)
 		direction = 16;
 
-	memcpy(ccb[mbo].cdb, SCpnt->cmnd, ccb[mbo].cdblen);
+	memcpy(ccb[mbo].cdb, cmd->cmnd, ccb[mbo].cdblen);
 
 	if (bufflen) {
 		struct scatterlist *sg;
@@ -548,17 +548,17 @@ static int aha1542_queuecommand_lck(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *
 #ifdef DEBUG
 		unsigned char *ptr;
 #endif
-		int i, sg_count = scsi_sg_count(SCpnt);
+		int i, sg_count = scsi_sg_count(cmd);
 		ccb[mbo].op = 2;	/* SCSI Initiator Command  w/scatter-gather */
-		SCpnt->host_scribble = kmalloc(sizeof(*cptr)*sg_count,
+		cmd->host_scribble = kmalloc(sizeof(*cptr)*sg_count,
 		                                         GFP_KERNEL | GFP_DMA);
-		cptr = (struct chain *) SCpnt->host_scribble;
+		cptr = (struct chain *) cmd->host_scribble;
 		if (cptr == NULL) {
 			/* free the claimed mailbox slot */
-			aha1542->SCint[mbo] = NULL;
+			aha1542->int_cmds[mbo] = NULL;
 			return SCSI_MLQUEUE_HOST_BUSY;
 		}
-		scsi_for_each_sg(SCpnt, sg, sg_count, i) {
+		scsi_for_each_sg(cmd, sg, sg_count, i) {
 			any2scsi(cptr[i].dataptr, isa_page_to_bus(sg_page(sg))
 								+ sg->offset);
 			any2scsi(cptr[i].datalen, sg->length);
@@ -573,7 +573,7 @@ static int aha1542_queuecommand_lck(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *
 #endif
 	} else {
 		ccb[mbo].op = 0;	/* SCSI Initiator Command */
-		SCpnt->host_scribble = NULL;
+		cmd->host_scribble = NULL;
 		any2scsi(ccb[mbo].datalen, 0);
 		any2scsi(ccb[mbo].dataptr, 0);
 	};
@@ -593,9 +593,9 @@ static int aha1542_queuecommand_lck(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *
 
 	if (done) {
 		DEB(printk("aha1542_queuecommand: now waiting for interrupt "));
-		SCpnt->scsi_done = done;
+		cmd->scsi_done = done;
 		mb[mbo].status = 1;
-		aha1542_outb(SCpnt->device->host->io_port, CMD_START_SCSI);
+		aha1542_outb(cmd->device->host->io_port, CMD_START_SCSI);
 	} else
 		printk("aha1542_queuecommand: done can't be NULL\n");
 
@@ -908,13 +908,13 @@ static int aha1542_release(struct Scsi_Host *shost)
  * This is a device reset.  This is handled by sending a special command
  * to the device.
  */
-static int aha1542_dev_reset(Scsi_Cmnd * SCpnt)
+static int aha1542_dev_reset(struct scsi_cmnd *cmd)
 {
-	struct aha1542_hostdata *aha1542 = shost_priv(SCpnt->device->host);
+	struct aha1542_hostdata *aha1542 = shost_priv(cmd->device->host);
 	unsigned long flags;
 	struct mailbox *mb = aha1542->mb;
-	u8 target = SCpnt->device->id;
-	u8 lun = SCpnt->device->lun;
+	u8 target = cmd->device->id;
+	u8 lun = cmd->device->lun;
 	int mbo;
 	struct ccb *ccb = aha1542->ccb;
 
@@ -924,17 +924,17 @@ static int aha1542_dev_reset(Scsi_Cmnd * SCpnt)
 		mbo = 0;
 
 	do {
-		if (mb[mbo].status == 0 && aha1542->SCint[mbo] == NULL)
+		if (mb[mbo].status == 0 && aha1542->int_cmds[mbo] == NULL)
 			break;
 		mbo++;
 		if (mbo >= AHA1542_MAILBOXES)
 			mbo = 0;
 	} while (mbo != aha1542->aha1542_last_mbo_used);
 
-	if (mb[mbo].status || aha1542->SCint[mbo])
+	if (mb[mbo].status || aha1542->int_cmds[mbo])
 		panic("Unable to find empty mailbox for aha1542.\n");
 
-	aha1542->SCint[mbo] = SCpnt;	/* This will effectively
+	aha1542->int_cmds[mbo] = cmd;	/* This will effectively
 					   prevent someone else from
 					   screwing with this cdb. */
 
@@ -956,17 +956,17 @@ static int aha1542_dev_reset(Scsi_Cmnd * SCpnt)
 	 * Now tell the 1542 to flush all pending commands for this 
 	 * target 
 	 */
-	aha1542_outb(SCpnt->device->host->io_port, CMD_START_SCSI);
+	aha1542_outb(cmd->device->host->io_port, CMD_START_SCSI);
 
-	scmd_printk(KERN_WARNING, SCpnt,
+	scmd_printk(KERN_WARNING, cmd,
 		"Trying device reset for target\n");
 
 	return SUCCESS;
 }
 
-static int aha1542_reset(Scsi_Cmnd *SCpnt, u8 reset_cmd)
+static int aha1542_reset(struct scsi_cmnd *cmd, u8 reset_cmd)
 {
-	struct aha1542_hostdata *aha1542 = shost_priv(SCpnt->device->host);
+	struct aha1542_hostdata *aha1542 = shost_priv(cmd->device->host);
 	int i;
 
 	/* 
@@ -975,7 +975,7 @@ static int aha1542_reset(Scsi_Cmnd *SCpnt, u8 reset_cmd)
 	 * we do this?  Try this first, and we can add that later
 	 * if it turns out to be useful.
 	 */
-	outb(reset_cmd, CONTROL(SCpnt->device->host->io_port));
+	outb(reset_cmd, CONTROL(cmd->device->host->io_port));
 
 	/*
 	 * Wait for the thing to settle down a bit.  Unfortunately
@@ -985,11 +985,11 @@ static int aha1542_reset(Scsi_Cmnd *SCpnt, u8 reset_cmd)
 	 * we are pretty desperate anyways.
 	 */
 	ssleep(4);
-	spin_lock_irq(SCpnt->device->host->host_lock);
+	spin_lock_irq(cmd->device->host->host_lock);
 
-	if (!wait_mask(STATUS(SCpnt->device->host->io_port),
+	if (!wait_mask(STATUS(cmd->device->host->io_port),
 	     STATMASK, INIT | IDLE, STST | DIAGF | INVDCMD | DF | CDF, 0)) {
-		spin_unlock_irq(SCpnt->device->host->host_lock);
+		spin_unlock_irq(cmd->device->host->host_lock);
 		return FAILED;
 	}
 	/*
@@ -997,21 +997,21 @@ static int aha1542_reset(Scsi_Cmnd *SCpnt, u8 reset_cmd)
 	 * us again after host reset.
 	 */
 	if (reset_cmd & HRST)
-		setup_mailboxes(SCpnt->device->host->io_port, SCpnt->device->host);
+		setup_mailboxes(cmd->device->host->io_port, cmd->device->host);
 	/*
 	 * Now try to pick up the pieces.  For all pending commands,
 	 * free any internal data structures, and basically clear things
 	 * out.  We do not try and restart any commands or anything - 
 	 * the strategy handler takes care of that crap.
 	 */
-	printk(KERN_WARNING "Sent BUS RESET to scsi host %d\n", SCpnt->device->host->host_no);
+	printk(KERN_WARNING "Sent BUS RESET to scsi host %d\n", cmd->device->host->host_no);
 
 	for (i = 0; i < AHA1542_MAILBOXES; i++) {
-		if (aha1542->SCint[i] != NULL) {
-			Scsi_Cmnd *SCtmp;
-			SCtmp = aha1542->SCint[i];
+		if (aha1542->int_cmds[i] != NULL) {
+			struct scsi_cmnd *tmp_cmd;
+			tmp_cmd = aha1542->int_cmds[i];
 
-			if (SCtmp->device->soft_reset) {
+			if (tmp_cmd->device->soft_reset) {
 				/*
 				 * If this device implements the soft reset option,
 				 * then it is still holding onto the command, and
@@ -1020,25 +1020,25 @@ static int aha1542_reset(Scsi_Cmnd *SCpnt, u8 reset_cmd)
 				 */
 				continue;
 			}
-			kfree(SCtmp->host_scribble);
-			SCtmp->host_scribble = NULL;
-			aha1542->SCint[i] = NULL;
+			kfree(tmp_cmd->host_scribble);
+			tmp_cmd->host_scribble = NULL;
+			aha1542->int_cmds[i] = NULL;
 			aha1542->mb[i].status = 0;
 		}
 	}
 
-	spin_unlock_irq(SCpnt->device->host->host_lock);
+	spin_unlock_irq(cmd->device->host->host_lock);
 	return SUCCESS;
 }
 
-static int aha1542_bus_reset(Scsi_Cmnd *SCpnt)
+static int aha1542_bus_reset(struct scsi_cmnd *cmd)
 {
-	return aha1542_reset(SCpnt, SCRST);
+	return aha1542_reset(cmd, SCRST);
 }
 
-static int aha1542_host_reset(Scsi_Cmnd *SCpnt)
+static int aha1542_host_reset(struct scsi_cmnd *cmd)
 {
-	return aha1542_reset(SCpnt, HRST | SCRST);
+	return aha1542_reset(cmd, HRST | SCRST);
 }
 
 static int aha1542_biosparam(struct scsi_device *sdev,
-- 
Ondrej Zary

