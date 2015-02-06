From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 34/36] aha1542: rework locking
Date: Fri,  6 Feb 2015 23:11:55 +0100
Message-ID: <1423260717-15944-35-git-send-email-linux@rainbow-software.org>
References: <1423260717-15944-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56963 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758236AbbBFWP4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Feb 2015 17:15:56 -0500
Received: from stip-static-68.213-81-217.telecom.sk ([213.81.217.68] helo=gsql.ggedos.sk)
	by gsystem.sk with esmtpsa (TLS1.1:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <linux@rainbow-software.org>)
	id 1YJr8I-0006fF-TU
	for linux-scsi@vger.kernel.org; Fri, 06 Feb 2015 23:12:14 +0100
In-Reply-To: <1423260717-15944-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Remove aha1542_lock and use host_lock instead.
Remove interrupt and queuecommand function wrappers.
Remove locking from lowlevel _out and _in functions, they now can
onle be called (at runtime) with host_lock being held.
Remove ssleep(4) in aha1542_reset as we can't sleep while holding a spinlock.
It's useless anyway as wait_mask will wait until the controller is idle and
kernel waits for 10 seconds (HOST_RESET_SETTLE_TIME) after that.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/aha1542.c |  118 ++++++++++++++----------------------------------
 1 file changed, 34 insertions(+), 84 deletions(-)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index a19fcb0..7b5d396 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -62,8 +62,6 @@ struct aha1542_hostdata {
 	struct ccb ccb[AHA1542_MAILBOXES];
 };
 
-static DEFINE_SPINLOCK(aha1542_lock);
-
 static inline void aha1542_intr_reset(u16 base)
 {
 	outb(IRST, CONTROL(base));
@@ -91,41 +89,25 @@ static inline bool wait_mask(u16 port, u8 mask, u8 allof, u8 noneof, int timeout
 	return true;
 }
 
-/* This is a bit complicated, but we need to make sure that an interrupt
-   routine does not send something out while we are in the middle of this.
-   Fortunately, it is only at boot time that multi-byte messages
-   are ever sent. */
 static int aha1542_outb(unsigned int base, u8 val)
 {
-	unsigned long flags;
-
 	while (1) {
 		if (!wait_mask(STATUS(base), CDF, 0, CDF, 0))
 			return 1;
-		spin_lock_irqsave(&aha1542_lock, flags);
-		if (inb(STATUS(base)) & CDF) {
-			spin_unlock_irqrestore(&aha1542_lock, flags);
+		if (inb(STATUS(base)) & CDF)
 			continue;
-		}
 		outb(val, DATA(base));
-		spin_unlock_irqrestore(&aha1542_lock, flags);
 		return 0;
 	}
 }
 
 static int aha1542_out(unsigned int base, u8 *buf, int len)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&aha1542_lock, flags);
 	while (len--) {
-		if (!wait_mask(STATUS(base), CDF, 0, CDF, 0)) {
-			spin_unlock_irqrestore(&aha1542_lock, flags);
+		if (!wait_mask(STATUS(base), CDF, 0, CDF, 0))
 			return 1;
-		}
 		outb(*buf++, DATA(base));
 	}
-	spin_unlock_irqrestore(&aha1542_lock, flags);
 	if (!wait_mask(INTRFLAGS(base), INTRMASK, HACC, 0, 0))
 		return 1;
 
@@ -137,17 +119,11 @@ static int aha1542_out(unsigned int base, u8 *buf, int len)
 
 static int aha1542_in(unsigned int base, u8 *buf, int len, int timeout)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&aha1542_lock, flags);
 	while (len--) {
-		if (!wait_mask(STATUS(base), DF, DF, 0, timeout)) {
-			spin_unlock_irqrestore(&aha1542_lock, flags);
+		if (!wait_mask(STATUS(base), DF, DF, 0, timeout))
 			return 1;
-		}
 		*buf++ = inb(DATA(base));
 	}
-	spin_unlock_irqrestore(&aha1542_lock, flags);
 	return 0;
 }
 
@@ -260,9 +236,9 @@ static int aha1542_test_port(struct Scsi_Host *sh)
 	return 1;
 }
 
-/* A "high" level interrupt handler */
-static void aha1542_intr_handle(struct Scsi_Host *sh)
+static irqreturn_t aha1542_interrupt(int irq, void *dev_id)
 {
+	struct Scsi_Host *sh = dev_id;
 	struct aha1542_hostdata *aha1542 = shost_priv(sh);
 	void (*my_done)(struct scsi_cmnd *) = NULL;
 	int errstatus, mbi, mbo, mbistatus;
@@ -292,7 +268,8 @@ static void aha1542_intr_handle(struct Scsi_Host *sh)
 #endif
 	number_serviced = 0;
 
-	while (1 == 1) {
+	spin_lock_irqsave(sh->host_lock, flags);
+	while (1) {
 		flag = inb(INTRFLAGS(sh->io_port));
 
 		/* Check for unusual interrupts.  If any of these happen, we should
@@ -309,7 +286,6 @@ static void aha1542_intr_handle(struct Scsi_Host *sh)
 		}
 		aha1542_intr_reset(sh->io_port);
 
-		spin_lock_irqsave(&aha1542_lock, flags);
 		mbi = aha1542->aha1542_last_mbi_used + 1;
 		if (mbi >= 2 * AHA1542_MAILBOXES)
 			mbi = AHA1542_MAILBOXES;
@@ -323,18 +299,17 @@ static void aha1542_intr_handle(struct Scsi_Host *sh)
 		} while (mbi != aha1542->aha1542_last_mbi_used);
 
 		if (mb[mbi].status == 0) {
-			spin_unlock_irqrestore(&aha1542_lock, flags);
+			spin_unlock_irqrestore(sh->host_lock, flags);
 			/* Hmm, no mail.  Must have read it the last time around */
 			if (!number_serviced)
 				shost_printk(KERN_WARNING, sh, "interrupt received, but no mail.\n");
-			return;
+			return IRQ_HANDLED;
 		};
 
 		mbo = (scsi2int(mb[mbi].ccbptr) - (isa_virt_to_bus(&ccb[0]))) / sizeof(struct ccb);
 		mbistatus = mb[mbi].status;
 		mb[mbi].status = 0;
 		aha1542->aha1542_last_mbi_used = mbi;
-		spin_unlock_irqrestore(&aha1542_lock, flags);
 
 #ifdef DEBUG
 		if (ccb[mbo].tarstat | ccb[mbo].hastat)
@@ -352,10 +327,11 @@ static void aha1542_intr_handle(struct Scsi_Host *sh)
 		tmp_cmd = aha1542->int_cmds[mbo];
 
 		if (!tmp_cmd || !tmp_cmd->scsi_done) {
+			spin_unlock_irqrestore(sh->host_lock, flags);
 			shost_printk(KERN_WARNING, sh, "Unexpected interrupt\n");
 			shost_printk(KERN_WARNING, sh, "tarstat=%x, hastat=%x idlun=%x ccb#=%d\n", ccb[mbo].tarstat,
 			       ccb[mbo].hastat, ccb[mbo].idlun, mbo);
-			return;
+			return IRQ_HANDLED;
 		}
 		my_done = tmp_cmd->scsi_done;
 		kfree(tmp_cmd->host_scribble);
@@ -394,21 +370,8 @@ static void aha1542_intr_handle(struct Scsi_Host *sh)
 	};
 }
 
-/* A quick wrapper for do_aha1542_intr_handle to grab the spin lock */
-static irqreturn_t do_aha1542_intr_handle(int dummy, void *dev_id)
+static int aha1542_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 {
-	unsigned long flags;
-	struct Scsi_Host *sh = dev_id;
-
-	spin_lock_irqsave(sh->host_lock, flags);
-	aha1542_intr_handle(sh);
-	spin_unlock_irqrestore(sh->host_lock, flags);
-	return IRQ_HANDLED;
-}
-
-static int aha1542_queuecommand_lck(struct scsi_cmnd *cmd, void (*done) (struct scsi_cmnd *))
-{
-	struct Scsi_Host *sh = cmd->device->host;
 	struct aha1542_hostdata *aha1542 = shost_priv(sh);
 	u8 direction;
 	u8 target = cmd->device->id;
@@ -422,7 +385,7 @@ static int aha1542_queuecommand_lck(struct scsi_cmnd *cmd, void (*done) (struct
 	if (*cmd->cmnd == REQUEST_SENSE) {
 		/* Don't do the command - we have the sense data already */
 		cmd->result = 0;
-		done(cmd);
+		cmd->scsi_done(cmd);
 		return 0;
 	}
 #ifdef DEBUG
@@ -440,7 +403,7 @@ static int aha1542_queuecommand_lck(struct scsi_cmnd *cmd, void (*done) (struct
 	/* Use the outgoing mailboxes in a round-robin fashion, because this
 	   is how the host adapter will scan for them */
 
-	spin_lock_irqsave(&aha1542_lock, flags);
+	spin_lock_irqsave(sh->host_lock, flags);
 	mbo = aha1542->aha1542_last_mbo_used + 1;
 	if (mbo >= AHA1542_MAILBOXES)
 		mbo = 0;
@@ -460,10 +423,9 @@ static int aha1542_queuecommand_lck(struct scsi_cmnd *cmd, void (*done) (struct
 					   screwing with this cdb. */
 
 	aha1542->aha1542_last_mbo_used = mbo;
-	spin_unlock_irqrestore(&aha1542_lock, flags);
 
 #ifdef DEBUG
-	shost_printk(KERN_DEBUG, sh, "Sending command (%d %p)...", mbo, done);
+	shost_printk(KERN_DEBUG, sh, "Sending command (%d %p)...", mbo, cmd->scsi_done);
 #endif
 
 	any2scsi(mb[mbo].ccbptr, isa_virt_to_bus(&ccb[mbo]));	/* This gets trashed for some reason */
@@ -492,6 +454,7 @@ static int aha1542_queuecommand_lck(struct scsi_cmnd *cmd, void (*done) (struct
 		if (cptr == NULL) {
 			/* free the claimed mailbox slot */
 			aha1542->int_cmds[mbo] = NULL;
+			spin_unlock_irqrestore(sh->host_lock, flags);
 			return SCSI_MLQUEUE_HOST_BUSY;
 		}
 		scsi_for_each_sg(cmd, sg, sg_count, i) {
@@ -518,23 +481,15 @@ static int aha1542_queuecommand_lck(struct scsi_cmnd *cmd, void (*done) (struct
 
 #ifdef DEBUG
 	print_hex_dump_bytes("sending: ", DUMP_PREFIX_NONE, &ccb[mbo], sizeof(ccb[mbo]) - 10);
+	printk("aha1542_queuecommand: now waiting for interrupt ");
 #endif
-
-	if (done) {
-#ifdef DEBUG
-		printk("aha1542_queuecommand: now waiting for interrupt ");
-#endif
-		cmd->scsi_done = done;
-		mb[mbo].status = 1;
-		aha1542_outb(cmd->device->host->io_port, CMD_START_SCSI);
-	} else
-		printk("aha1542_queuecommand: done can't be NULL\n");
+	mb[mbo].status = 1;
+	aha1542_outb(cmd->device->host->io_port, CMD_START_SCSI);
+	spin_unlock_irqrestore(sh->host_lock, flags);
 
 	return 0;
 }
 
-static DEF_SCSI_QCMD(aha1542_queuecommand)
-
 /* Initialize mailboxes */
 static void setup_mailboxes(struct Scsi_Host *sh)
 {
@@ -786,8 +741,7 @@ static struct Scsi_Host *aha1542_hw_init(struct scsi_host_template *tpnt, struct
 
 	setup_mailboxes(sh);
 
-	if (request_irq(sh->irq, do_aha1542_intr_handle, 0,
-					"aha1542", sh)) {
+	if (request_irq(sh->irq, aha1542_interrupt, 0, "aha1542", sh)) {
 		shost_printk(KERN_ERR, sh, "Unable to allocate IRQ.\n");
 		goto unregister;
 	}
@@ -841,7 +795,8 @@ static int aha1542_release(struct Scsi_Host *sh)
  */
 static int aha1542_dev_reset(struct scsi_cmnd *cmd)
 {
-	struct aha1542_hostdata *aha1542 = shost_priv(cmd->device->host);
+	struct Scsi_Host *sh = cmd->device->host;
+	struct aha1542_hostdata *aha1542 = shost_priv(sh);
 	unsigned long flags;
 	struct mailbox *mb = aha1542->mb;
 	u8 target = cmd->device->id;
@@ -849,7 +804,7 @@ static int aha1542_dev_reset(struct scsi_cmnd *cmd)
 	int mbo;
 	struct ccb *ccb = aha1542->ccb;
 
-	spin_lock_irqsave(&aha1542_lock, flags);
+	spin_lock_irqsave(sh->host_lock, flags);
 	mbo = aha1542->aha1542_last_mbo_used + 1;
 	if (mbo >= AHA1542_MAILBOXES)
 		mbo = 0;
@@ -870,7 +825,6 @@ static int aha1542_dev_reset(struct scsi_cmnd *cmd)
 					   screwing with this cdb. */
 
 	aha1542->aha1542_last_mbo_used = mbo;
-	spin_unlock_irqrestore(&aha1542_lock, flags);
 
 	any2scsi(mb[mbo].ccbptr, isa_virt_to_bus(&ccb[mbo]));	/* This gets trashed for some reason */
 
@@ -887,7 +841,8 @@ static int aha1542_dev_reset(struct scsi_cmnd *cmd)
 	 * Now tell the 1542 to flush all pending commands for this 
 	 * target 
 	 */
-	aha1542_outb(cmd->device->host->io_port, CMD_START_SCSI);
+	aha1542_outb(sh->io_port, CMD_START_SCSI);
+	spin_unlock_irqrestore(sh->host_lock, flags);
 
 	scmd_printk(KERN_WARNING, cmd,
 		"Trying device reset for target\n");
@@ -897,9 +852,12 @@ static int aha1542_dev_reset(struct scsi_cmnd *cmd)
 
 static int aha1542_reset(struct scsi_cmnd *cmd, u8 reset_cmd)
 {
-	struct aha1542_hostdata *aha1542 = shost_priv(cmd->device->host);
+	struct Scsi_Host *sh = cmd->device->host;
+	struct aha1542_hostdata *aha1542 = shost_priv(sh);
+	unsigned long flags;
 	int i;
 
+	spin_lock_irqsave(sh->host_lock, flags);
 	/* 
 	 * This does a scsi reset for all devices on the bus.
 	 * In principle, we could also reset the 1542 - should
@@ -908,27 +866,19 @@ static int aha1542_reset(struct scsi_cmnd *cmd, u8 reset_cmd)
 	 */
 	outb(reset_cmd, CONTROL(cmd->device->host->io_port));
 
-	/*
-	 * Wait for the thing to settle down a bit.  Unfortunately
-	 * this is going to basically lock up the machine while we
-	 * wait for this to complete.  To be 100% correct, we need to
-	 * check for timeout, and if we are doing something like this
-	 * we are pretty desperate anyways.
-	 */
-	ssleep(4);
-	spin_lock_irq(cmd->device->host->host_lock);
-
 	if (!wait_mask(STATUS(cmd->device->host->io_port),
 	     STATMASK, INIT | IDLE, STST | DIAGF | INVDCMD | DF | CDF, 0)) {
-		spin_unlock_irq(cmd->device->host->host_lock);
+		spin_unlock_irqrestore(sh->host_lock, flags);
 		return FAILED;
 	}
+
 	/*
 	 * We need to do this too before the 1542 can interact with
 	 * us again after host reset.
 	 */
 	if (reset_cmd & HRST)
 		setup_mailboxes(cmd->device->host);
+
 	/*
 	 * Now try to pick up the pieces.  For all pending commands,
 	 * free any internal data structures, and basically clear things
@@ -958,7 +908,7 @@ static int aha1542_reset(struct scsi_cmnd *cmd, u8 reset_cmd)
 		}
 	}
 
-	spin_unlock_irq(cmd->device->host->host_lock);
+	spin_unlock_irqrestore(sh->host_lock, flags);
 	return SUCCESS;
 }
 
-- 
Ondrej Zary

