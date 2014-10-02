From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 29/29] atari_NCR5380: Refactor Falcon locking
Date: Thu, 02 Oct 2014 16:56:57 +1000
Message-ID: <20141002065635.206191540@telegraphics.com.au>
References: <20141002065628.256592712@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:33745 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859AbaJBNEP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2014 09:04:15 -0400
Content-Disposition: inline; filename=atari_NCR5380-refactor-falcon-locking
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org

Simplify falcon_release_lock_if_possible() by making callers responsible for
disabling local IRQ's, which they must do anyway to correctly synchronize
the ST DMA "lock" with core driver data structures. Move this synchronization
logic to the core driver with which it is tightly coupled.

Other LLD's like sun3_scsi and mac_scsi that can make use of this core driver
can just stub out the NCR5380_acquire_dma_irq() and NCR5380_release_dma_irq()
calls so the compiler will eliminate the ST DMA code.

Remove a redundant local_irq_save/restore pair (irq's are disabled for
interrupt handlers these days). Revise the locking for atari_scsi_bus_reset():
use local_irq_save/restore() instead of atari_turnoff/turnon_irq(). There is
no guarantee that atari_scsi still holds the ST DMA "lock" during EH, so
atari_turnoff/turnon_irq() could end up dropping an IDE or floppy interrupt.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/atari_NCR5380.c |   72 ++++++++++++++++++++++++++-----------------
 drivers/scsi/atari_scsi.c    |   47 ++++++++++------------------
 2 files changed, 62 insertions(+), 57 deletions(-)

Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2014-10-02 16:56:25.000000000 +1000
+++ linux/drivers/scsi/atari_NCR5380.c	2014-10-02 16:56:26.000000000 +1000
@@ -924,7 +924,7 @@ static int NCR5380_queue_command(struct
 	 * alter queues and touch the lock.
 	 */
 	/* perhaps stop command timer here */
-	if (!falcon_get_lock())
+	if (!NCR5380_acquire_dma_irq(instance))
 		return SCSI_MLQUEUE_HOST_BUSY;
 	/* perhaps restart command timer here */
 
@@ -960,6 +960,18 @@ static int NCR5380_queue_command(struct
 	return 0;
 }
 
+static inline void maybe_release_dma_irq(struct Scsi_Host *instance)
+{
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
+
+	/* Caller does the locking needed to set & test these data atomically */
+	if (!hostdata->disconnected_queue &&
+	    !hostdata->issue_queue &&
+	    !hostdata->connected &&
+	    !hostdata->retain_dma_intr)
+		NCR5380_release_dma_irq(instance);
+}
+
 /*
  * Function : NCR5380_main (void)
  *
@@ -1081,9 +1093,11 @@ static void NCR5380_main(struct work_str
 					cmd_get_tag(tmp, tmp->cmnd[0] != REQUEST_SENSE);
 #endif
 					if (!NCR5380_select(instance, tmp)) {
+						local_irq_disable();
 						hostdata->retain_dma_intr--;
 						/* release if target did not response! */
-						falcon_release_lock_if_possible(hostdata);
+						maybe_release_dma_irq(instance);
+						local_irq_restore(flags);
 						break;
 					} else {
 						local_irq_disable();
@@ -2082,11 +2096,12 @@ static void NCR5380_information_transfer
 				case COMMAND_COMPLETE:
 					/* Accept message by clearing ACK */
 					NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-					/* ++guenther: possible race with Falcon locking */
-					hostdata->retain_dma_intr++;
-					hostdata->connected = NULL;
 					dprintk(NDEBUG_QUEUES, "scsi%d: command for target %d, lun %d "
 						  "completed\n", HOSTNO, cmd->device->id, cmd->device->lun);
+
+					local_irq_save(flags);
+					hostdata->retain_dma_intr++;
+					hostdata->connected = NULL;
 #ifdef SUPPORT_TAGS
 					cmd_free_tag(cmd);
 					if (status_byte(cmd->SCp.Status) == QUEUE_FULL) {
@@ -2145,17 +2160,17 @@ static void NCR5380_information_transfer
 
 						dprintk(NDEBUG_AUTOSENSE, "scsi%d: performing request sense\n", HOSTNO);
 
-						local_irq_save(flags);
 						LIST(cmd,hostdata->issue_queue);
 						SET_NEXT(cmd, hostdata->issue_queue);
 						hostdata->issue_queue = (struct scsi_cmnd *) cmd;
-						local_irq_restore(flags);
 						dprintk(NDEBUG_QUEUES, "scsi%d: REQUEST SENSE added to head of "
 							  "issue queue\n", H_NO(cmd));
 					} else {
 						cmd->scsi_done(cmd);
 					}
 
+					local_irq_restore(flags);
+
 					NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 					/*
 					 * Restore phase bits to 0 so an interrupted selection,
@@ -2166,12 +2181,14 @@ static void NCR5380_information_transfer
 					while ((NCR5380_read(STATUS_REG) & SR_BSY) && !hostdata->connected)
 						barrier();
 
+					local_irq_save(flags);
 					hostdata->retain_dma_intr--;
 					/* ++roman: For Falcon SCSI, release the lock on the
 					 * ST-DMA here if no other commands are waiting on the
 					 * disconnected queue.
 					 */
-					falcon_release_lock_if_possible(hostdata);
+					maybe_release_dma_irq(instance);
+					local_irq_restore(flags);
 					return;
 				case MESSAGE_REJECT:
 					/* Accept message by clearing ACK */
@@ -2330,6 +2347,7 @@ static void NCR5380_information_transfer
 				hostdata->last_message = msgout;
 				NCR5380_transfer_pio(instance, &phase, &len, &data);
 				if (msgout == ABORT) {
+					local_irq_save(flags);
 #ifdef SUPPORT_TAGS
 					cmd_free_tag(cmd);
 #else
@@ -2337,9 +2355,10 @@ static void NCR5380_information_transfer
 #endif
 					hostdata->connected = NULL;
 					cmd->result = DID_ERROR << 16;
-					cmd->scsi_done(cmd);
 					NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
-					falcon_release_lock_if_possible(hostdata);
+					maybe_release_dma_irq(instance);
+					local_irq_restore(flags);
+					cmd->scsi_done(cmd);
 					return;
 				}
 				msgout = NOP;
@@ -2392,7 +2411,6 @@ static void NCR5380_reselect(struct Scsi
 	unsigned char msg[3];
 	unsigned char *data;
 	struct scsi_cmnd *tmp = NULL, *prev;
-/*	unsigned long flags; */
 
 	/*
 	 * Disable arbitration, etc. since the host adapter obviously
@@ -2472,8 +2490,6 @@ static void NCR5380_reselect(struct Scsi
 		    && (tag == tmp->tag)
 #endif
 		    ) {
-			/* ++guenther: prevent race with falcon_release_lock */
-			hostdata->retain_dma_intr++;
 			if (prev) {
 				REMOVE(prev, NEXT(prev), tmp, NEXT(tmp));
 				SET_NEXT(prev, NEXT(tmp));
@@ -2511,7 +2527,6 @@ static void NCR5380_reselect(struct Scsi
 	hostdata->connected = tmp;
 	dprintk(NDEBUG_RESELECTION, "scsi%d: nexus established, target = %d, lun = %d, tag = %d\n",
 		   HOSTNO, tmp->device->id, tmp->device->lun, tmp->tag);
-	hostdata->retain_dma_intr--;
 }
 
 
@@ -2587,12 +2602,12 @@ int NCR5380_abort(struct scsi_cmnd *cmd)
 #else
 			hostdata->busy[cmd->device->id] &= ~(1 << cmd->device->lun);
 #endif
+			maybe_release_dma_irq(instance);
 			local_irq_restore(flags);
 			cmd->scsi_done(cmd);
-			falcon_release_lock_if_possible(hostdata);
 			return SUCCESS;
 		} else {
-/*			local_irq_restore(flags); */
+			local_irq_restore(flags);
 			printk("scsi%d: abort of connected command failed!\n", HOSTNO);
 			return FAILED;
 		}
@@ -2611,13 +2626,13 @@ int NCR5380_abort(struct scsi_cmnd *cmd)
 			(*prev) = NEXT(tmp);
 			SET_NEXT(tmp, NULL);
 			tmp->result = DID_ABORT << 16;
+			maybe_release_dma_irq(instance);
 			local_irq_restore(flags);
 			dprintk(NDEBUG_ABORT, "scsi%d: abort removed command from issue queue.\n",
 				    HOSTNO);
 			/* Tagged queuing note: no tag to free here, hasn't been assigned
 			 * yet... */
 			tmp->scsi_done(tmp);
-			falcon_release_lock_if_possible(hostdata);
 			return SUCCESS;
 		}
 	}
@@ -2695,15 +2710,22 @@ int NCR5380_abort(struct scsi_cmnd *cmd)
 #else
 					hostdata->busy[cmd->device->id] &= ~(1 << cmd->device->lun);
 #endif
+					maybe_release_dma_irq(instance);
 					local_irq_restore(flags);
 					tmp->scsi_done(tmp);
-					falcon_release_lock_if_possible(hostdata);
 					return SUCCESS;
 				}
 			}
 		}
 	}
 
+	/* Maybe it is sufficient just to release the ST-DMA lock... (if
+	 * possible at all) At least, we should check if the lock could be
+	 * released after the abort, in case it is kept due to some bug.
+	 */
+	maybe_release_dma_irq(instance);
+	local_irq_restore(flags);
+
 	/*
 	 * Case 5 : If we reached this point, the command was not found in any of
 	 *	    the queues.
@@ -2714,15 +2736,8 @@ int NCR5380_abort(struct scsi_cmnd *cmd)
 	 * broke.
 	 */
 
-	local_irq_restore(flags);
 	printk(KERN_INFO "scsi%d: warning : SCSI command probably completed successfully before abortion\n", HOSTNO);
 
-	/* Maybe it is sufficient just to release the ST-DMA lock... (if
-	 * possible at all) At least, we should check if the lock could be
-	 * released after the abort, in case it is kept due to some bug.
-	 */
-	falcon_release_lock_if_possible(hostdata);
-
 	return FAILED;
 }
 
@@ -2738,14 +2753,15 @@ int NCR5380_abort(struct scsi_cmnd *cmd)
 
 static int NCR5380_bus_reset(struct scsi_cmnd *cmd)
 {
-	SETUP_HOSTDATA(cmd->device->host);
+	struct Scsi_Host *instance = cmd->device->host;
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	int i;
 	unsigned long flags;
 #if defined(RESET_RUN_DONE)
 	struct scsi_cmnd *connected, *disconnected_queue;
 #endif
 
-	NCR5380_print_status(cmd->device->host);
+	NCR5380_print_status(instance);
 
 	/* get in phase */
 	NCR5380_write(TARGET_COMMAND_REG,
@@ -2870,6 +2886,8 @@ static int NCR5380_bus_reset(struct scsi
 #ifdef REAL_DMA
 	hostdata->dma_len = 0;
 #endif
+
+	maybe_release_dma_irq(instance);
 	local_irq_restore(flags);
 
 	/* we did no complete reset of all commands, so a wakeup is required */
Index: linux/drivers/scsi/atari_scsi.c
===================================================================
--- linux.orig/drivers/scsi/atari_scsi.c	2014-10-02 16:56:25.000000000 +1000
+++ linux/drivers/scsi/atari_scsi.c	2014-10-02 16:56:26.000000000 +1000
@@ -109,6 +109,9 @@
 #define NCR5380_dma_xfer_len(instance, cmd, phase) \
         atari_dma_xfer_len(cmd->SCp.this_residual, cmd, !((phase) & SR_IO))
 
+#define NCR5380_acquire_dma_irq(instance)      falcon_get_lock()
+#define NCR5380_release_dma_irq(instance)      falcon_release_lock()
+
 #include "NCR5380.h"
 
 
@@ -448,23 +451,13 @@ static void atari_scsi_fetch_restbytes(v
  * connected command and the disconnected queue is empty.
  */
 
-static void falcon_release_lock_if_possible(struct NCR5380_hostdata *hostdata)
+static void falcon_release_lock(void)
 {
-	unsigned long flags;
-
 	if (IS_A_TT())
 		return;
 
-	local_irq_save(flags);
-
-	if (!hostdata->disconnected_queue &&
-	    !hostdata->issue_queue &&
-	    !hostdata->connected &&
-	    !hostdata->retain_dma_intr &&
-	    stdma_is_locked_by(scsi_falcon_intr))
+	if (stdma_is_locked_by(scsi_falcon_intr))
 		stdma_release();
-
-	local_irq_restore(flags);
 }
 
 /* This function manages the locking of the ST-DMA.
@@ -788,36 +781,30 @@ static void atari_scsi_falcon_reg_write(
 static int atari_scsi_bus_reset(struct scsi_cmnd *cmd)
 {
 	int rv;
-	struct NCR5380_hostdata *hostdata = shost_priv(cmd->device->host);
+	unsigned long flags;
+
+	local_irq_save(flags);
 
-	/* For doing the reset, SCSI interrupts must be disabled first,
-	 * since the 5380 raises its IRQ line while _RST is active and we
-	 * can't disable interrupts completely, since we need the timer.
-	 */
-	/* And abort a maybe active DMA transfer */
-	if (IS_A_TT()) {
-		atari_turnoff_irq(IRQ_TT_MFP_SCSI);
 #ifdef REAL_DMA
+	/* Abort a maybe active DMA transfer */
+	if (IS_A_TT()) {
 		tt_scsi_dma.dma_ctrl = 0;
-#endif
 	} else {
-		atari_turnoff_irq(IRQ_MFP_FSCSI);
-#ifdef REAL_DMA
 		st_dma.dma_mode_status = 0x90;
 		atari_dma_active = 0;
 		atari_dma_orig_addr = NULL;
-#endif
 	}
+#endif
 
 	rv = NCR5380_bus_reset(cmd);
 
-	if (IS_A_TT())
-		atari_turnon_irq(IRQ_TT_MFP_SCSI);
-	else
-		atari_turnon_irq(IRQ_MFP_FSCSI);
+	/* The 5380 raises its IRQ line while _RST is active but the ST DMA
+	 * "lock" has been released so this interrupt may end up handled by
+	 * floppy or IDE driver (if one of them holds the lock). The NCR5380
+	 * interrupt flag has been cleared already.
+	 */
 
-	if (rv == SUCCESS)
-		falcon_release_lock_if_possible(hostdata);
+	local_irq_restore(flags);
 
 	return rv;
 }


