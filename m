From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] remove sym2 host-level command queueing
Date: Tue, 14 Sep 2004 15:02:06 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040914130206.GB11300@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:3201 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S269129AbUINNCJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Sep 2004 09:02:09 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: willy@debian.org
Cc: linux-scsi@vger.kernel.org

We can just return SCSI_MLQUEUE_HOST_BUSY to the midlayer for that case.


--- 1.49/drivers/scsi/sym53c8xx_2/sym_glue.c	2004-09-13 14:36:39 +02:00
+++ edited/drivers/scsi/sym53c8xx_2/sym_glue.c	2004-09-14 16:33:41 +02:00
@@ -146,7 +146,6 @@
  *  Driver private area in the SCSI command structure.
  */
 struct sym_ucmd {		/* Override the SCSI pointer structure */
-	SYM_QUEHEAD link_cmdq;	/* Must stay at offset ZERO */
 	dma_addr_t data_mapping;
 	u_char	data_mapped;
 	struct sym_eh_wait *eh_wait;
@@ -212,7 +211,6 @@
  */
 void sym_xpt_done(struct sym_hcb *np, struct scsi_cmnd *ccb)
 {
-	sym_remque(&SYM_UCMD_PTR(ccb)->link_cmdq);
 	unmap_scsi_data(np, ccb);
 	ccb->scsi_done(ccb);
 }
@@ -648,31 +646,6 @@
 	}
 }
 
-
-/*
- *  Requeue awaiting commands.
- */
-static void sym_requeue_awaiting_cmds(struct sym_hcb *np)
-{
-	struct sym_ucmd *ucp;
-	SYM_QUEHEAD tmp_cmdq;
-	int sts;
-
-	sym_que_move(&np->s.wait_cmdq, &tmp_cmdq);
-
-	while ((ucp = (struct sym_ucmd *) sym_remque_head(&tmp_cmdq)) != 0) {
-		struct scsi_cmnd *cmd;
-
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
@@ -700,18 +673,12 @@
 		}
 	}
 
-	if (np->s.settle_time_valid || !sym_que_empty(&np->s.wait_cmdq)) {
-		sym_insque_tail(&ucp->link_cmdq, &np->s.wait_cmdq);
-		goto out;
-	}
+	if (np->s.settle_time_valid)
+		return SCSI_MLQUEUE_HOST_BUSY;
 
-	sym_insque_tail(&ucp->link_cmdq, &np->s.busy_cmdq);
 	sts = sym_queue_command(np, cmd);
-	if (sts) {
-		sym_remque(&ucp->link_cmdq);
-		sym_insque_tail(&ucp->link_cmdq, &np->s.wait_cmdq);
-	}
-out:
+	if (sts)
+		return SCSI_MLQUEUE_HOST_BUSY;
 	return 0;
 }
 
@@ -726,15 +693,7 @@
 	if (DEBUG_FLAGS & DEBUG_TINY) printf_debug ("[");
 
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
 
 	if (DEBUG_FLAGS & DEBUG_TINY) printf_debug ("]\n");
@@ -751,12 +710,7 @@
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
 
@@ -834,14 +788,6 @@
 		goto prepare;
 #endif
 
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
@@ -1731,12 +1677,6 @@
 		goto reset_failed;
 
 	/*
-	 *  Initialize some queue headers.
-	 */
-	sym_que_init(&np->s.wait_cmdq);
-	sym_que_init(&np->s.busy_cmdq);
-
-	/*
 	 *  Start the SCRIPTS.
 	 */
 	sym_start_up (np, 1);
--- 1.21/drivers/scsi/sym53c8xx_2/sym_glue.h	2004-09-13 11:16:59 +02:00
+++ edited/drivers/scsi/sym53c8xx_2/sym_glue.h	2004-09-14 16:31:47 +02:00
@@ -381,9 +381,6 @@
 	u_short		io_ws;		/* IO window size		*/
 	int		irq;		/* IRQ number			*/
 
-	SYM_QUEHEAD	wait_cmdq;	/* Awaiting SCSI commands	*/
-	SYM_QUEHEAD	busy_cmdq;	/* Enqueued SCSI commands	*/
-
 	struct timer_list timer;	/* Timer handler link header	*/
 	u_long		lasttime;
 	u_long		settle_time;	/* Resetting the SCSI BUS	*/
