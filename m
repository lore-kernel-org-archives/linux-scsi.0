From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 02/36] aha1542: remove dead code
Date: Fri,  6 Feb 2015 23:11:23 +0100
Message-ID: <1423260717-15944-3-git-send-email-linux@rainbow-software.org>
References: <1423260717-15944-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56930 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756114AbbBFWMM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Feb 2015 17:12:12 -0500
Received: from stip-static-68.213-81-217.telecom.sk ([213.81.217.68] helo=gsql.ggedos.sk)
	by gsystem.sk with esmtpsa (TLS1.1:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <linux@rainbow-software.org>)
	id 1YJr8D-0006fF-Cd
	for linux-scsi@vger.kernel.org; Fri, 06 Feb 2015 23:12:09 +0100
In-Reply-To: <1423260717-15944-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Remove dead code.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/aha1542.c |  243 +-----------------------------------------------
 drivers/scsi/aha1542.h |    6 --
 2 files changed, 1 insertion(+), 248 deletions(-)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index b7a62da..506e33e 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -570,13 +570,6 @@ static int aha1542_queuecommand_lck(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *
 
 	if (*cmd == REQUEST_SENSE) {
 		/* Don't do the command - we have the sense data already */
-#if 0
-		/* scsi_request_sense() provides a buffer of size 256,
-		   so there is no reason to expect equality */
-		if (bufflen != SCSI_SENSE_BUFFERSIZE)
-			printk(KERN_CRIT "aha1542: Wrong buffer length supplied "
-			       "for request sense (%d)\n", bufflen);
-#endif
 		SCpnt->result = 0;
 		done(SCpnt);
 		return 0;
@@ -1095,24 +1088,14 @@ static int aha1542_restart(struct Scsi_Host *shost)
 {
 	int i;
 	int count = 0;
-#if 0
-	unchar ahacmd = CMD_START_SCSI;
-#endif
 
 	for (i = 0; i < AHA1542_MAILBOXES; i++)
 		if (HOSTDATA(shost)->SCint[i] &&
 		    !(HOSTDATA(shost)->SCint[i]->device->soft_reset)) {
-#if 0
-			HOSTDATA(shost)->mb[i].status = 1;	/* Indicate ready to restart... */
-#endif
 			count++;
 		}
 	printk(KERN_DEBUG "Potential to restart %d stalled commands...\n", count);
-#if 0
-	/* start scsi command */
-	if (count)
-		aha1542_out(shost->io_port, &ahacmd, 1);
-#endif
+
 	return 0;
 }
 
@@ -1177,39 +1160,6 @@ static int aha1542_dev_reset(Scsi_Cmnd * SCpnt)
 		"Trying device reset for target\n");
 
 	return SUCCESS;
-
-
-#ifdef ERIC_neverdef
-	/* 
-	 * With the 1542 we apparently never get an interrupt to
-	 * acknowledge a device reset being sent.  Then again, Leonard
-	 * says we are doing this wrong in the first place...
-	 *
-	 * Take a wait and see attitude.  If we get spurious interrupts,
-	 * then the device reset is doing something sane and useful, and
-	 * we will wait for the interrupt to post completion.
-	 */
-	printk(KERN_WARNING "Sent BUS DEVICE RESET to target %d\n", SCpnt->target);
-
-	/*
-	 * Free the command block for all commands running on this 
-	 * target... 
-	 */
-	for (i = 0; i < AHA1542_MAILBOXES; i++) {
-		if (HOSTDATA(SCpnt->host)->SCint[i] &&
-		    HOSTDATA(SCpnt->host)->SCint[i]->target == SCpnt->target) {
-			Scsi_Cmnd *SCtmp;
-			SCtmp = HOSTDATA(SCpnt->host)->SCint[i];
-			kfree(SCtmp->host_scribble);
-			SCtmp->host_scribble = NULL;
-			HOSTDATA(SCpnt->host)->SCint[i] = NULL;
-			HOSTDATA(SCpnt->host)->mb[i].status = 0;
-		}
-	}
-	return SUCCESS;
-
-	return FAILED;
-#endif				/* ERIC_neverdef */
 }
 
 static int aha1542_bus_reset(Scsi_Cmnd * SCpnt)
@@ -1344,197 +1294,6 @@ fail:
 	return FAILED;
 }
 
-#if 0
-/*
- * These are the old error handling routines.  They are only temporarily
- * here while we play with the new error handling code.
- */
-static int aha1542_old_abort(Scsi_Cmnd * SCpnt)
-{
-#if 0
-	unchar ahacmd = CMD_START_SCSI;
-	unsigned long flags;
-	struct mailbox *mb;
-	int mbi, mbo, i;
-
-	printk(KERN_DEBUG "In aha1542_abort: %x %x\n",
-	       inb(STATUS(SCpnt->host->io_port)),
-	       inb(INTRFLAGS(SCpnt->host->io_port)));
-
-	spin_lock_irqsave(&aha1542_lock, flags);
-	mb = HOSTDATA(SCpnt->host)->mb;
-	mbi = HOSTDATA(SCpnt->host)->aha1542_last_mbi_used + 1;
-	if (mbi >= 2 * AHA1542_MAILBOXES)
-		mbi = AHA1542_MAILBOXES;
-
-	do {
-		if (mb[mbi].status != 0)
-			break;
-		mbi++;
-		if (mbi >= 2 * AHA1542_MAILBOXES)
-			mbi = AHA1542_MAILBOXES;
-	} while (mbi != HOSTDATA(SCpnt->host)->aha1542_last_mbi_used);
-	spin_unlock_irqrestore(&aha1542_lock, flags);
-
-	if (mb[mbi].status) {
-		printk(KERN_ERR "Lost interrupt discovered on irq %d - attempting to recover\n",
-		       SCpnt->host->irq);
-		aha1542_intr_handle(SCpnt->host, NULL);
-		return 0;
-	}
-	/* OK, no lost interrupt.  Try looking to see how many pending commands
-	   we think we have. */
-
-	for (i = 0; i < AHA1542_MAILBOXES; i++)
-		if (HOSTDATA(SCpnt->host)->SCint[i]) {
-			if (HOSTDATA(SCpnt->host)->SCint[i] == SCpnt) {
-				printk(KERN_ERR "Timed out command pending for %s\n",
-				       SCpnt->request->rq_disk ?
-				       SCpnt->request->rq_disk->disk_name : "?"
-				       );
-				if (HOSTDATA(SCpnt->host)->mb[i].status) {
-					printk(KERN_ERR "OGMB still full - restarting\n");
-					aha1542_out(SCpnt->host->io_port, &ahacmd, 1);
-				};
-			} else
-				printk(KERN_ERR "Other pending command %s\n",
-				       SCpnt->request->rq_disk ?
-				       SCpnt->request->rq_disk->disk_name : "?"
-				       );
-		}
-#endif
-
-	DEB(printk("aha1542_abort\n"));
-#if 0
-	spin_lock_irqsave(&aha1542_lock, flags);
-	for (mbo = 0; mbo < AHA1542_MAILBOXES; mbo++) {
-		if (SCpnt == HOSTDATA(SCpnt->host)->SCint[mbo]) {
-			mb[mbo].status = 2;	/* Abort command */
-			aha1542_out(SCpnt->host->io_port, &ahacmd, 1);	/* start scsi command */
-			spin_unlock_irqrestore(&aha1542_lock, flags);
-			break;
-		}
-	}
-	if (AHA1542_MAILBOXES == mbo)
-		spin_unlock_irqrestore(&aha1542_lock, flags);
-#endif
-	return SCSI_ABORT_SNOOZE;
-}
-
-/* We do not implement a reset function here, but the upper level code
-   assumes that it will get some kind of response for the command in
-   SCpnt.  We must oblige, or the command will hang the scsi system.
-   For a first go, we assume that the 1542 notifies us with all of the
-   pending commands (it does implement soft reset, after all). */
-
-static int aha1542_old_reset(Scsi_Cmnd * SCpnt, unsigned int reset_flags)
-{
-	unchar ahacmd = CMD_START_SCSI;
-	int i;
-
-	/*
-	 * See if a bus reset was suggested.
-	 */
-	if (reset_flags & SCSI_RESET_SUGGEST_BUS_RESET) {
-		/* 
-		 * This does a scsi reset for all devices on the bus.
-		 * In principle, we could also reset the 1542 - should
-		 * we do this?  Try this first, and we can add that later
-		 * if it turns out to be useful.
-		 */
-		outb(HRST | SCRST, CONTROL(SCpnt->host->io_port));
-
-		/*
-		 * Wait for the thing to settle down a bit.  Unfortunately
-		 * this is going to basically lock up the machine while we
-		 * wait for this to complete.  To be 100% correct, we need to
-		 * check for timeout, and if we are doing something like this
-		 * we are pretty desperate anyways.
-		 */
-		WAIT(STATUS(SCpnt->host->io_port),
-		STATMASK, INIT | IDLE, STST | DIAGF | INVDCMD | DF | CDF);
-
-		/*
-		 * We need to do this too before the 1542 can interact with
-		 * us again.
-		 */
-		setup_mailboxes(SCpnt->host->io_port, SCpnt->host);
-
-		/*
-		 * Now try to pick up the pieces.  Restart all commands
-		 * that are currently active on the bus, and reset all of
-		 * the datastructures.  We have some time to kill while
-		 * things settle down, so print a nice message.
-		 */
-		printk(KERN_WARNING "Sent BUS RESET to scsi host %d\n", SCpnt->host->host_no);
-
-		for (i = 0; i < AHA1542_MAILBOXES; i++)
-			if (HOSTDATA(SCpnt->host)->SCint[i] != NULL) {
-				Scsi_Cmnd *SCtmp;
-				SCtmp = HOSTDATA(SCpnt->host)->SCint[i];
-				SCtmp->result = DID_RESET << 16;
-				kfree(SCtmp->host_scribble);
-				SCtmp->host_scribble = NULL;
-				printk(KERN_WARNING "Sending DID_RESET for target %d\n", SCpnt->target);
-				SCtmp->scsi_done(SCpnt);
-
-				HOSTDATA(SCpnt->host)->SCint[i] = NULL;
-				HOSTDATA(SCpnt->host)->mb[i].status = 0;
-			}
-		/*
-		 * Now tell the mid-level code what we did here.  Since
-		 * we have restarted all of the outstanding commands,
-		 * then report SUCCESS.
-		 */
-		return (SCSI_RESET_SUCCESS | SCSI_RESET_BUS_RESET);
-fail:
-		printk(KERN_CRIT "aha1542.c: Unable to perform hard reset.\n");
-		printk(KERN_CRIT "Power cycle machine to reset\n");
-		return (SCSI_RESET_ERROR | SCSI_RESET_BUS_RESET);
-
-
-	} else {
-		/* This does a selective reset of just the one device */
-		/* First locate the ccb for this command */
-		for (i = 0; i < AHA1542_MAILBOXES; i++)
-			if (HOSTDATA(SCpnt->host)->SCint[i] == SCpnt) {
-				HOSTDATA(SCpnt->host)->ccb[i].op = 0x81;	/* BUS DEVICE RESET */
-				/* Now tell the 1542 to flush all pending commands for this target */
-				aha1542_out(SCpnt->host->io_port, &ahacmd, 1);
-
-				/* Here is the tricky part.  What to do next.  Do we get an interrupt
-				   for the commands that we aborted with the specified target, or
-				   do we generate this on our own?  Try it without first and see
-				   what happens */
-				printk(KERN_WARNING "Sent BUS DEVICE RESET to target %d\n", SCpnt->target);
-
-				/* If the first does not work, then try the second.  I think the
-				   first option is more likely to be correct. Free the command
-				   block for all commands running on this target... */
-				for (i = 0; i < AHA1542_MAILBOXES; i++)
-					if (HOSTDATA(SCpnt->host)->SCint[i] &&
-					    HOSTDATA(SCpnt->host)->SCint[i]->target == SCpnt->target) {
-						Scsi_Cmnd *SCtmp;
-						SCtmp = HOSTDATA(SCpnt->host)->SCint[i];
-						SCtmp->result = DID_RESET << 16;
-						kfree(SCtmp->host_scribble);
-						SCtmp->host_scribble = NULL;
-						printk(KERN_WARNING "Sending DID_RESET for target %d\n", SCpnt->target);
-						SCtmp->scsi_done(SCpnt);
-
-						HOSTDATA(SCpnt->host)->SCint[i] = NULL;
-						HOSTDATA(SCpnt->host)->mb[i].status = 0;
-					}
-				return SCSI_RESET_SUCCESS;
-			}
-	}
-	/* No active command at this time, so this means that each time we got
-	   some kind of response the last time through.  Tell the mid-level code
-	   to request sense information in order to decide what to do next. */
-	return SCSI_RESET_PUNT;
-}
-#endif    /* end of big comment block around old_abort + old_reset */
-
 static int aha1542_biosparam(struct scsi_device *sdev,
 		struct block_device *bdev, sector_t capacity, int *ip)
 {
diff --git a/drivers/scsi/aha1542.h b/drivers/scsi/aha1542.h
index 76e6abc..af91125 100644
--- a/drivers/scsi/aha1542.h
+++ b/drivers/scsi/aha1542.h
@@ -100,12 +100,6 @@ static inline void any2scsi(u8 *p, u32 v)
 
 #define scsi2int(up) ( (((long)*(up)) << 16) + (((long)(up)[1]) << 8) + ((long)(up)[2]) )
 
-#define xany2scsi(up, p)	\
-(up)[0] = ((long)(p)) >> 24;	\
-(up)[1] = ((long)(p)) >> 16;	\
-(up)[2] = ((long)(p)) >> 8;	\
-(up)[3] = ((long)(p));
-
 #define xscsi2int(up) ( (((long)(up)[0]) << 24) + (((long)(up)[1]) << 16) \
 		      + (((long)(up)[2]) <<  8) +  ((long)(up)[3]) )
 
-- 
Ondrej Zary

