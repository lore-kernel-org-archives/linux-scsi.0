From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v2 36/36] atari_NCR5380: Remove RESET_RUN_DONE macro
Date: Mon, 27 Oct 2014 16:26:43 +1100
Message-ID: <20141027052615.815771200@telegraphics.com.au>
References: <20141027052607.105914311@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:48362 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477AbaJ0KcY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Oct 2014 06:32:24 -0400
Content-Disposition: inline; filename=atari_NCR5380-remove-RESET_RUN_DONE
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org

There's no need to run the cmd->done callback for aborted commands. Remove
the old EH code and the RESET_RUN_DONE macro.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/atari_NCR5380.c |   88 -------------------------------------------
 drivers/scsi/sun3_scsi.c     |    1 
 2 files changed, 89 deletions(-)

Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2014-10-27 16:26:03.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2014-10-27 16:26:04.000000000 +1100
@@ -2881,9 +2881,6 @@ static int NCR5380_bus_reset(struct scsi
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	int i;
 	unsigned long flags;
-#if defined(RESET_RUN_DONE)
-	struct scsi_cmnd *connected, *disconnected_queue;
-#endif
 
 	NCR5380_print_status(instance);
 
@@ -2902,89 +2899,6 @@ static int NCR5380_bus_reset(struct scsi
 	 * through anymore ... */
 	(void)NCR5380_read(RESET_PARITY_INTERRUPT_REG);
 
-	/* MSch 20140115 - looking at the generic NCR5380 driver, all of this
-	 * should go.
-	 * Catch-22: if we don't clear all queues, the SCSI driver lock will
-	 * not be reset by atari_scsi_reset()!
-	 */
-
-#if defined(RESET_RUN_DONE)
-	/* XXX Should now be done by midlevel code, but it's broken XXX */
-	/* XXX see below                                            XXX */
-
-	/* MSch: old-style reset: actually abort all command processing here */
-
-	/* After the reset, there are no more connected or disconnected commands
-	 * and no busy units; to avoid problems with re-inserting the commands
-	 * into the issue_queue (via scsi_done()), the aborted commands are
-	 * remembered in local variables first.
-	 */
-	local_irq_save(flags);
-	connected = (struct scsi_cmnd *)hostdata->connected;
-	hostdata->connected = NULL;
-	disconnected_queue = (struct scsi_cmnd *)hostdata->disconnected_queue;
-	hostdata->disconnected_queue = NULL;
-#ifdef SUPPORT_TAGS
-	free_all_tags();
-#endif
-	for (i = 0; i < 8; ++i)
-		hostdata->busy[i] = 0;
-#ifdef REAL_DMA
-	hostdata->dma_len = 0;
-#endif
-	local_irq_restore(flags);
-
-	/* In order to tell the mid-level code which commands were aborted,
-	 * set the command status to DID_RESET and call scsi_done() !!!
-	 * This ultimately aborts processing of these commands in the mid-level.
-	 */
-
-	if ((cmd = connected)) {
-		dprintk(NDEBUG_ABORT, "scsi%d: reset aborted a connected command\n", H_NO(cmd));
-		cmd->result = (cmd->result & 0xffff) | (DID_RESET << 16);
-		cmd->scsi_done(cmd);
-	}
-
-	for (i = 0; (cmd = disconnected_queue); ++i) {
-		disconnected_queue = NEXT(cmd);
-		SET_NEXT(cmd, NULL);
-		cmd->result = (cmd->result & 0xffff) | (DID_RESET << 16);
-		cmd->scsi_done(cmd);
-	}
-	if (i > 0)
-		dprintk(NDEBUG_ABORT, "scsi: reset aborted %d disconnected command(s)\n", i);
-
-	/* The Falcon lock should be released after a reset...
-	 */
-	/* ++guenther: moved to atari_scsi_reset(), to prevent a race between
-	 * unlocking and enabling dma interrupt.
-	 */
-/*	falcon_release_lock_if_possible( hostdata );*/
-
-	/* since all commands have been explicitly terminated, we need to tell
-	 * the midlevel code that the reset was SUCCESSFUL, and there is no
-	 * need to 'wake up' the commands by a request_sense
-	 */
-	return SUCCESS;
-#else /* 1 */
-
-	/* MSch: new-style reset handling: let the mid-level do what it can */
-
-	/* ++guenther: MID-LEVEL IS STILL BROKEN.
-	 * Mid-level is supposed to requeue all commands that were active on the
-	 * various low-level queues. In fact it does this, but that's not enough
-	 * because all these commands are subject to timeout. And if a timeout
-	 * happens for any removed command, *_abort() is called but all queues
-	 * are now empty. Abort then gives up the falcon lock, which is fatal,
-	 * since the mid-level will queue more commands and must have the lock
-	 * (it's all happening inside timer interrupt handler!!).
-	 * Even worse, abort will return NOT_RUNNING for all those commands not
-	 * on any queue, so they won't be retried ...
-	 *
-	 * Conclusion: either scsi.c disables timeout for all resetted commands
-	 * immediately, or we lose!  As of linux-2.0.20 it doesn't.
-	 */
-
 	/* After the reset, there are no more connected or disconnected commands
 	 * and no busy units; so clear the low-level status here to avoid
 	 * conflicts when the mid-level code tries to wake up the affected
@@ -3014,7 +2928,5 @@ static int NCR5380_bus_reset(struct scsi
 	maybe_release_dma_irq(instance);
 	local_irq_restore(flags);
 
-	/* we did no complete reset of all commands, so a wakeup is required */
 	return SUCCESS;
-#endif /* 1 */
 }
Index: linux/drivers/scsi/sun3_scsi.c
===================================================================
--- linux.orig/drivers/scsi/sun3_scsi.c	2014-10-27 16:26:00.000000000 +1100
+++ linux/drivers/scsi/sun3_scsi.c	2014-10-27 16:26:04.000000000 +1100
@@ -39,7 +39,6 @@
 /* Definitions for the core NCR5380 driver. */
 
 #define REAL_DMA
-#define RESET_RUN_DONE
 /* #define SUPPORT_TAGS */
 /* minimum number of bytes to do dma on */
 #define DMA_MIN_SIZE                    129


