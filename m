From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] remove one layer of internal queueing from sym2
Date: Wed, 26 Nov 2003 14:32:26 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031126133226.GA5525@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:17551 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S264156AbTKZNcb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Nov 2003 08:32:31 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: willy@debian.org
Cc: linux-scsi@vger.kernel.org

->queuecommand can just return 1 to defer the command, no need to queue
internally.  And while you're at it could you look at killing
SYM_OPT_HANDLE_DEVICE_QUEUEING?  We're handling QUEUE_FULL conditions
just fine at the midlayer.  Similarly  SYM_OPT_HANDLE_DIR_UNKNOWN and
SYM_OPT_LIMIT_COMMAND_REORDERING shouldn't be needed anymore these
days.



===== drivers/scsi/sym53c8xx_2/sym_glue.c 1.39 vs edited =====
--- 1.39/drivers/scsi/sym53c8xx_2/sym_glue.c	Sun Nov 23 09:56:03 2003
+++ edited/drivers/scsi/sym53c8xx_2/sym_glue.c	Sun Nov 23 21:43:00 2003
@@ -51,6 +51,7 @@
  */
 #define SYM_GLUE_C
 
+#include <linux/completion.h>
 #include <linux/ctype.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
@@ -148,18 +149,17 @@
  *  It is allocated on the eh thread stack.
  */
 struct sym_eh_wait {
-	struct semaphore sem;
+	struct completion eh_done;
 	struct timer_list timer;
 	void (*old_done)(struct scsi_cmnd *);
-	int to_do;
 	int timed_out;
+	int wait:1;
 };
 
 /*
  *  Driver private area in the SCSI command structure.
  */
 struct sym_ucmd {		/* Override the SCSI pointer structure */
-	SYM_QUEHEAD link_cmdq;	/* Must stay at offset ZERO */
 	dma_addr_t data_mapping;
 	u_char	data_mapped;
 	struct sym_eh_wait *eh_wait;
@@ -243,7 +243,6 @@
  */
 void sym_xpt_done(struct sym_hcb *np, struct scsi_cmnd *ccb)
 {
-	sym_remque(&SYM_UCMD_PTR(ccb)->link_cmdq);
 	unmap_scsi_data(np, ccb);
 	ccb->scsi_done(ccb);
 }
@@ -467,71 +466,6 @@
 }
 
 /*
- *  Queue a SCSI command.
- */
-static int sym_queue_command(struct sym_hcb *np, struct scsi_cmnd *ccb)
-{
-/*	struct scsi_device        *device    = ccb->device; */
-	struct sym_tcb *tp;
-	struct sym_lcb *lp;
-	struct sym_ccb *cp;
-	int	order;
-
-	/*
-	 *  Minimal checkings, so that we will not 
-	 *  go outside our tables.
-	 */
-	if (ccb->device->id == np->myaddr ||
-	    ccb->device->id >= SYM_CONF_MAX_TARGET ||
-	    ccb->device->lun >= SYM_CONF_MAX_LUN) {
-		sym_xpt_done2(np, ccb, CAM_DEV_NOT_THERE);
-		return 0;
-	}
-
-	/*
-	 *  Retreive the target descriptor.
-	 */
-	tp = &np->target[ccb->device->id];
-
-	/*
-	 *  Complete the 1st INQUIRY command with error 
-	 *  condition if the device is flagged NOSCAN 
-	 *  at BOOT in the NVRAM. This may speed up 
-	 *  the boot and maintain coherency with BIOS 
-	 *  device numbering. Clearing the flag allows 
-	 *  user to rescan skipped devices later.
-	 *  We also return error for devices not flagged 
-	 *  for SCAN LUNS in the NVRAM since some mono-lun 
-	 *  devices behave badly when asked for some non 
-	 *  zero LUN. Btw, this is an absolute hack.:-)
-	 */
-	if (ccb->cmnd[0] == 0x12 || ccb->cmnd[0] == 0x0) {
-		if ((tp->usrflags & SYM_SCAN_BOOT_DISABLED) ||
-		    ((tp->usrflags & SYM_SCAN_LUNS_DISABLED) && 
-		     ccb->device->lun != 0)) {
-			tp->usrflags &= ~SYM_SCAN_BOOT_DISABLED;
-			sym_xpt_done2(np, ccb, CAM_DEV_NOT_THERE);
-			return 0;
-		}
-	}
-
-	/*
-	 *  Select tagged/untagged.
-	 */
-	lp = sym_lp(np, tp, ccb->device->lun);
-	order = (lp && lp->s.reqtags) ? M_SIMPLE_TAG : 0;
-
-	/*
-	 *  Queue the SCSI IO.
-	 */
-	cp = sym_get_ccb(np, ccb->device->id, ccb->device->lun, order);
-	if (!cp)
-		return 1;	/* Means resource shortage */
-	sym_queue_scsiio(np, ccb, cp);
-	return 0;
-}
-
-/*
  *  Setup buffers and pointers that address the CDB.
  */
 static inline int sym_setup_cdb(struct sym_hcb *np, struct scsi_cmnd *ccb, struct sym_ccb *cp)
@@ -693,30 +627,6 @@
 	}
 }
 
-
-/*
- *  Requeue awaiting commands.
- */
-static void sym_requeue_awaiting_cmds(struct sym_hcb *np)
-{
-	struct scsi_cmnd *cmd;
-	struct sym_ucmd *ucp = SYM_UCMD_PTR(cmd);
-	SYM_QUEHEAD tmp_cmdq;
-	int sts;
-
-	sym_que_move(&np->s.wait_cmdq, &tmp_cmdq);
-
-	while ((ucp = (struct sym_ucmd *) sym_remque_head(&tmp_cmdq)) != 0) {
-		sym_insque_tail(&ucp->link_cmdq, &np->s.busy_cmdq);
-		cmd = SYM_SCMD_PTR(ucp);
-		sts = sym_queue_command(np, cmd);
-		if (sts) {
-			sym_remque(&ucp->link_cmdq);
-			sym_insque_head(&ucp->link_cmdq, &np->s.wait_cmdq);
-		}
-	}
-}
-
 /*
  * queuecommand method.  Entered with the host adapter lock held and
  * interrupts disabled.
@@ -726,36 +636,79 @@
 {
 	struct sym_hcb *np = SYM_SOFTC_PTR(cmd);
 	struct sym_ucmd *ucp = SYM_UCMD_PTR(cmd);
-	int sts = 0;
+	unsigned int pun = cmd->device->id;
+	unsigned int lun = cmd->device->id;
+	struct sym_tcb *tp;
+	struct sym_lcb *lp;
+	struct sym_ccb *cp;
+	int order;
 
 	cmd->scsi_done     = done;
 	cmd->host_scribble = NULL;
 	memset(ucp, 0, sizeof(*ucp));
 
 	/*
+	 *  Minimal checkings, so that we will not 
+	 *  go outside our tables.
+	 */
+	if (pun == np->myaddr)
+		goto invalid;
+	if (pun >= SYM_CONF_MAX_TARGET || lun >= SYM_CONF_MAX_LUN)
+		goto invalid;
+
+	/*
 	 *  Shorten our settle_time if needed for 
 	 *  this command not to time out.
 	 */
 	if (np->s.settle_time_valid && cmd->timeout_per_command) {
 		unsigned long tlimit = jiffies + cmd->timeout_per_command;
 		tlimit -= SYM_CONF_TIMER_INTERVAL*2;
-		if (time_after(np->s.settle_time, tlimit)) {
+		if (time_after(np->s.settle_time, tlimit))
 			np->s.settle_time = tlimit;
-		}
 	}
 
-	if (np->s.settle_time_valid || !sym_que_empty(&np->s.wait_cmdq)) {
-		sym_insque_tail(&ucp->link_cmdq, &np->s.wait_cmdq);
-		goto out;
-	}
+	if (np->s.settle_time_valid)
+		return 1;
 
-	sym_insque_tail(&ucp->link_cmdq, &np->s.busy_cmdq);
-	sts = sym_queue_command(np, cmd);
-	if (sts) {
-		sym_remque(&ucp->link_cmdq);
-		sym_insque_tail(&ucp->link_cmdq, &np->s.wait_cmdq);
+	tp = &np->target[pun];
+	lp = sym_lp(np, tp, lun);
+
+	/*
+	 *  Complete the 1st INQUIRY command with error 
+	 *  condition if the device is flagged NOSCAN 
+	 *  at BOOT in the NVRAM. This may speed up 
+	 *  the boot and maintain coherency with BIOS 
+	 *  device numbering. Clearing the flag allows 
+	 *  user to rescan skipped devices later.
+	 *  We also return error for devices not flagged 
+	 *  for SCAN LUNS in the NVRAM since some mono-lun 
+	 *  devices behave badly when asked for some non 
+	 *  zero LUN. Btw, this is an absolute hack.:-)
+	 */
+	if (cmd->cmnd[0] == 0x12 || cmd->cmnd[0] == 0x0) {
+		if ((tp->usrflags & SYM_SCAN_BOOT_DISABLED) ||
+		    ((tp->usrflags & SYM_SCAN_LUNS_DISABLED) && lun != 0)) {
+			tp->usrflags &= ~SYM_SCAN_BOOT_DISABLED;
+			goto invalid;
+		}
 	}
-out:
+
+	/*
+	 *  Select tagged/untagged.
+	 */
+	order = (lp && lp->s.reqtags) ? M_SIMPLE_TAG : 0;
+
+	/*
+	 *  Queue the SCSI IO.
+	 */
+	cp = sym_get_ccb(np, pun, lun, order);
+	if (!cp)
+		return 1;
+
+	sym_queue_scsiio(np, cmd, cp);
+	return 0;
+ invalid:
+	sym_xpt_done2(np, cmd, CAM_DEV_NOT_THERE);
 	return 0;
 }
 
@@ -764,25 +717,13 @@
  */
 static irqreturn_t sym53c8xx_intr(int irq, void *dev_id, struct pt_regs * regs)
 {
-	unsigned long flags;
 	struct sym_hcb *np = (struct sym_hcb *)dev_id;
-
-	if (DEBUG_FLAGS & DEBUG_TINY) printf_debug ("[");
+	unsigned long flags;
 
 	spin_lock_irqsave(np->s.host->host_lock, flags);
-
 	sym_interrupt(np);
-
-	/*
-	 * push queue walk-through to tasklet
-	 */
-	if (!sym_que_empty(&np->s.wait_cmdq) && !np->s.settle_time_valid)
-		sym_requeue_awaiting_cmds(np);
-
 	spin_unlock_irqrestore(np->s.host->host_lock, flags);
 
-	if (DEBUG_FLAGS & DEBUG_TINY) printf_debug ("]\n");
-
 	return IRQ_HANDLED;
 }
 
@@ -795,12 +736,7 @@
 	unsigned long flags;
 
 	spin_lock_irqsave(np->s.host->host_lock, flags);
-
 	sym_timer(np);
-
-	if (!sym_que_empty(&np->s.wait_cmdq) && !np->s.settle_time_valid)
-		sym_requeue_awaiting_cmds(np);
-
 	spin_unlock_irqrestore(np->s.host->host_lock, flags);
 }
 
@@ -808,17 +744,12 @@
 /*
  *  What the eh thread wants us to perform.
  */
-#define SYM_EH_ABORT		0
-#define SYM_EH_DEVICE_RESET	1
-#define SYM_EH_BUS_RESET	2
-#define SYM_EH_HOST_RESET	3
-
-/*
- *  What we will do regarding the involved SCSI command.
- */
-#define SYM_EH_DO_IGNORE	0
-#define SYM_EH_DO_COMPLETE	1
-#define SYM_EH_DO_WAIT		2
+enum sym_eh_action {
+	SYM_EH_ABORT,
+	SYM_EH_DEVICE_RESET,
+	SYM_EH_BUS_RESET,
+	SYM_EH_HOST_RESET
+};
 
 /*
  *  Our general completion handler.
@@ -826,44 +757,50 @@
 static void __sym_eh_done(struct scsi_cmnd *cmd, int timed_out)
 {
 	struct sym_eh_wait *ep = SYM_UCMD_PTR(cmd)->eh_wait;
+
 	if (!ep)
 		return;
 
 	/* Try to avoid a race here (not 100% safe) */
 	if (!timed_out) {
 		ep->timed_out = 0;
-		if (ep->to_do == SYM_EH_DO_WAIT && !del_timer(&ep->timer))
+		if (ep->wait && !del_timer(&ep->timer))
 			return;
 	}
 
 	/* Revert everything */
-	SYM_UCMD_PTR(cmd)->eh_wait = 0;
+	SYM_UCMD_PTR(cmd)->eh_wait = NULL;
 	cmd->scsi_done = ep->old_done;
 
 	/* Wake up the eh thread if it wants to sleep */
-	if (ep->to_do == SYM_EH_DO_WAIT)
-		up(&ep->sem);
+	if (ep->wait)
+		complete(&ep->eh_done);
 }
 
 /*
  *  scsi_done() alias when error recovery is in progress. 
  */
-static void sym_eh_done(struct scsi_cmnd *cmd) { __sym_eh_done(cmd, 0); }
+static void sym_eh_done(struct scsi_cmnd *cmd)
+{
+	__sym_eh_done(cmd, 0);
+}
 
 /*
  *  Some timeout handler to avoid waiting too long.
  */
-static void sym_eh_timeout(u_long p) { __sym_eh_done((struct scsi_cmnd *)p, 1); }
+static void sym_eh_timeout(u_long p)
+{
+	__sym_eh_done((struct scsi_cmnd *)p, 1);
+}
 
 /*
  *  Generic method for our eh processing.
  *  The 'op' argument tells what we have to do.
  */
-static int sym_eh_handler(int op, char *opname, struct scsi_cmnd *cmd)
+static int sym_eh_handler(enum sym_eh_action op, char *opname, struct scsi_cmnd *cmd)
 {
 	struct sym_hcb *np = SYM_SOFTC_PTR(cmd);
 	SYM_QUEHEAD *qp;
-	int to_do = SYM_EH_DO_IGNORE;
 	int sts = -1;
 	struct sym_eh_wait eh, *ep = &eh;
 	char devname[20];
@@ -872,48 +809,23 @@
 
 	printf_warning("%s: %s operation started.\n", devname, opname);
 
-#if 0
-	/* This one should be the result of some race, thus to ignore */
-	if (cmd->serial_number != cmd->serial_number_at_timeout)
-		goto prepare;
-#endif
-
-	/* This one is not queued to the core driver -> to complete here */ 
-	FOR_EACH_QUEUED_ELEMENT(&np->s.wait_cmdq, qp) {
-		if (SYM_SCMD_PTR(qp) == cmd) {
-			to_do = SYM_EH_DO_COMPLETE;
-			goto prepare;
-		}
-	}
-
 	/* This one is queued in some place -> to wait for completion */
 	FOR_EACH_QUEUED_ELEMENT(&np->busy_ccbq, qp) {
 		struct sym_ccb *cp = sym_que_entry(qp, struct sym_ccb, link_ccbq);
-		if (cp->cam_ccb == cmd) {
-			to_do = SYM_EH_DO_WAIT;
-			goto prepare;
-		}
+		if (cp->cam_ccb == cmd)
+			goto found;
 	}
 
-prepare:
-	/* Prepare stuff to either ignore, complete or wait for completion */
-	switch(to_do) {
-	default:
-	case SYM_EH_DO_IGNORE:
-		goto finish;
-		break;
-	case SYM_EH_DO_WAIT:
-		init_MUTEX_LOCKED(&ep->sem);
-		/* fall through */
-	case SYM_EH_DO_COMPLETE:
-		ep->old_done = cmd->scsi_done;
-		cmd->scsi_done = sym_eh_done;
-		SYM_UCMD_PTR(cmd)->eh_wait = ep;
-	}
+	goto finish;
+
+ found:
+	init_completion(&ep->eh_done);
+	ep->old_done = cmd->scsi_done;
+	cmd->scsi_done = sym_eh_done;
+	SYM_UCMD_PTR(cmd)->eh_wait = ep;
 
 	/* Try to proceed the operation we have been asked for */
-	sts = -1;
-	switch(op) {
+	switch (op) {
 	case SYM_EH_ABORT:
 		sts = sym_abort_scsiio(np, cmd, 1);
 		break;
@@ -930,41 +842,40 @@
 		sts = 0;
 		break;
 	default:
+		sts = -1;
 		break;
 	}
 
 	/* On error, restore everything and cross fingers :) */
 	if (sts) {
-		SYM_UCMD_PTR(cmd)->eh_wait = 0;
+		SYM_UCMD_PTR(cmd)->eh_wait = NULL;
 		cmd->scsi_done = ep->old_done;
-		to_do = SYM_EH_DO_IGNORE;
+		goto finish;
 	}
 
-finish:
-	ep->to_do = to_do;
-	/* Complete the command with locks held as required by the driver */
-	if (to_do == SYM_EH_DO_COMPLETE)
-		sym_xpt_done2(np, cmd, CAM_REQ_ABORTED);
-
-	/* Wait for completion with locks released, as required by kernel */
-	if (to_do == SYM_EH_DO_WAIT) {
-		init_timer(&ep->timer);
-		ep->timer.expires = jiffies + (5*HZ);
-		ep->timer.function = sym_eh_timeout;
-		ep->timer.data = (u_long)cmd;
-		ep->timed_out = 1;	/* Be pessimistic for once :) */
-		add_timer(&ep->timer);
-		spin_unlock_irq(np->s.host->host_lock);
-		down(&ep->sem);
-		spin_lock_irq(np->s.host->host_lock);
-		if (ep->timed_out)
-			sts = -2;
-	}
-	printf_warning("%s: %s operation %s.\n", devname, opname,
-			sts==0?"complete":sts==-2?"timed-out":"failed");
-	return sts? SCSI_FAILED : SCSI_SUCCESS;
-}
+	ep->wait = 1;
 
+	init_timer(&ep->timer);
+	ep->timer.expires = jiffies + (5*HZ);
+	ep->timer.function = sym_eh_timeout;
+	ep->timer.data = (u_long)cmd;
+	ep->timed_out = 1;	/* Be pessimistic for once :) */
+	add_timer(&ep->timer);
+
+	spin_unlock_irq(np->s.host->host_lock);
+	wait_for_completion(&ep->eh_done);
+	spin_lock_irq(np->s.host->host_lock);
+
+	if (ep->timed_out)
+		sts = -2;
+
+ finish:
+	printf_warning("%s: %s operation %s.\n", devname, opname, sts == 0 ?
+			"complete" : sts == -2 ?
+			"timed-out":
+			"failed");
+	return sts ? FAILED : SUCCESS;
+}
 
 /*
  * Error handlers called from the eh thread (one thread per HBA).
@@ -1778,12 +1689,6 @@
 	spin_lock_irqsave(instance->host_lock, flags);
 	if (sym_reset_scsi_bus(np, 0))
 		goto reset_failed;
-
-	/*
-	 *  Initialize some queue headers.
-	 */
-	sym_que_init(&np->s.wait_cmdq);
-	sym_que_init(&np->s.busy_cmdq);
 
 	/*
 	 *  Start the SCRIPTS.
===== drivers/scsi/sym53c8xx_2/sym_glue.h 1.16 vs edited =====
--- 1.16/drivers/scsi/sym53c8xx_2/sym_glue.h	Sun Nov 23 09:56:03 2003
+++ edited/drivers/scsi/sym53c8xx_2/sym_glue.h	Sun Nov 23 21:13:44 2003
@@ -382,9 +382,6 @@
 	u_short		io_ws;		/* IO window size		*/
 	int		irq;		/* IRQ number			*/
 
-	SYM_QUEHEAD	wait_cmdq;	/* Awaiting SCSI commands	*/
-	SYM_QUEHEAD	busy_cmdq;	/* Enqueued SCSI commands	*/
-
 	struct timer_list timer;	/* Timer handler link header	*/
 	u_long		lasttime;
 	u_long		settle_time;	/* Resetting the SCSI BUS	*/
