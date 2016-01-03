From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v4 50/78] ncr5380: Change instance->host_lock to hostdata->lock
Date: Sun, 03 Jan 2016 16:05:51 +1100
Message-ID: <20160103050514.261837458@telegraphics.com.au>
References: <20160103050501.042035135@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:49459 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828AbcACFSY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Jan 2016 00:18:24 -0500
Content-Disposition: inline; filename=ncr5380-adopt-new-spin-lock
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

NCR5380.c presently uses the instance->host_lock spin lock. Convert this
to a new spin lock that protects the NCR5380_hostdata struct.

atari_NCR5380.c previously used local_irq_save/restore() rather than a
spin lock. Convert this to hostdata->lock in irq mode. For SMP platforms,
the interrupt handler now also acquires the spin lock.

This brings all locking in the two core drivers into agreement.

Adding this locking also means that a bunch of volatile qualifiers can be
removed from the members of the NCR5380_hostdata struct. This is done in
a subsequent patch.

Proper locking will allow the abort handler to locate a command being
aborted. This is presently impossible if the abort handler is invoked when
the command has been moved from a queue to a pointer on the stack. (If
eh_abort_handler can't determine whether a command has been completed
or is still being processed then it can't decide whether to return
success or failure.)

The hostdata spin lock is now held when calling NCR5380_select() and
NCR5380_information_transfer(). Where possible, the lock is dropped for
polling and PIO transfers.

Clean up the now-redundant SELECT_ENABLE_REG writes, that used to provide
limited mutual exclusion between information_transfer() and reselect().

Accessing hostdata->connected without data races means taking the lock;
cleanup these accesses.

The new spin lock falls away for m68k and other UP builds, so this should
have little impact there. In the SMP case the new lock should be
uncontested even when the SCSI bus is contested.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Tested-by: Ondrej Zary <linux@rainbow-software.org>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>

---
 drivers/scsi/NCR5380.c       |   82 ++++++++++++++++----------
 drivers/scsi/NCR5380.h       |    1 
 drivers/scsi/atari_NCR5380.c |  135 +++++++++++++++++--------------------------
 3 files changed, 109 insertions(+), 109 deletions(-)

Index: linux/drivers/scsi/NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/NCR5380.h	2016-01-03 16:04:08.000000000 +1100
+++ linux/drivers/scsi/NCR5380.h	2016-01-03 16:04:09.000000000 +1100
@@ -256,6 +256,7 @@ struct NCR5380_hostdata {
 	volatile struct scsi_cmnd *connected;	/* currently connected command */
 	volatile struct scsi_cmnd *issue_queue;	/* waiting to be issued */
 	volatile struct scsi_cmnd *disconnected_queue;	/* waiting for reconnect */
+	spinlock_t lock;			/* protects this struct */
 	int flags;
 	struct scsi_eh_save ses;
 	char info[256];
Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2016-01-03 16:04:08.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2016-01-03 16:04:09.000000000 +1100
@@ -546,15 +546,13 @@ static struct {
 static void NCR5380_print(struct Scsi_Host *instance)
 {
 	unsigned char status, data, basr, mr, icr, i;
-	unsigned long flags;
 
-	local_irq_save(flags);
 	data = NCR5380_read(CURRENT_SCSI_DATA_REG);
 	status = NCR5380_read(STATUS_REG);
 	mr = NCR5380_read(MODE_REG);
 	icr = NCR5380_read(INITIATOR_COMMAND_REG);
 	basr = NCR5380_read(BUS_AND_STATUS_REG);
-	local_irq_restore(flags);
+
 	printk("STATUS_REG: %02x ", status);
 	for (i = 0; signals[i].mask; ++i)
 		if (status & signals[i].mask)
@@ -684,14 +682,12 @@ static void __maybe_unused NCR5380_print
 {
 	struct NCR5380_hostdata *hostdata;
 	struct scsi_cmnd *ptr;
-	unsigned long flags;
 
 	NCR5380_dprint(NDEBUG_ANY, instance);
 	NCR5380_dprint_phase(NDEBUG_ANY, instance);
 
 	hostdata = (struct NCR5380_hostdata *)instance->hostdata;
 
-	local_irq_save(flags);
 	if (!hostdata->connected)
 		printk("scsi%d: no currently connected command\n", HOSTNO);
 	else
@@ -704,8 +700,6 @@ static void __maybe_unused NCR5380_print
 	for (ptr = (struct scsi_cmnd *) hostdata->disconnected_queue; ptr;
 	     ptr = NEXT(ptr))
 		lprint_Scsi_Cmnd(ptr);
-
-	local_irq_restore(flags);
 	printk("\n");
 }
 
@@ -732,7 +726,7 @@ static int __maybe_unused NCR5380_show_i
 
 	hostdata = (struct NCR5380_hostdata *)instance->hostdata;
 
-	local_irq_save(flags);
+	spin_lock_irqsave(&hostdata->lock, flags);
 	if (!hostdata->connected)
 		seq_printf(m, "scsi%d: no currently connected command\n", HOSTNO);
 	else
@@ -746,7 +740,7 @@ static int __maybe_unused NCR5380_show_i
 	     ptr = NEXT(ptr))
 		show_Scsi_Cmnd(ptr, m);
 
-	local_irq_restore(flags);
+	spin_unlock_irqrestore(&hostdata->lock, flags);
 	return 0;
 }
 
@@ -784,6 +778,7 @@ static int __init NCR5380_init(struct Sc
 #if defined (REAL_DMA)
 	hostdata->dma_len = 0;
 #endif
+	spin_lock_init(&hostdata->lock);
 	hostdata->connected = NULL;
 	hostdata->issue_queue = NULL;
 	hostdata->disconnected_queue = NULL;
@@ -946,7 +941,7 @@ static int NCR5380_queue_command(struct
 	if (!NCR5380_acquire_dma_irq(instance))
 		return SCSI_MLQUEUE_HOST_BUSY;
 
-	local_irq_save(flags);
+	spin_lock_irqsave(&hostdata->lock, flags);
 
 	/*
 	 * Insert the cmd into the issue queue. Note that REQUEST SENSE
@@ -966,7 +961,7 @@ static int NCR5380_queue_command(struct
 		LIST(cmd, tmp);
 		SET_NEXT(tmp, cmd);
 	}
-	local_irq_restore(flags);
+	spin_unlock_irqrestore(&hostdata->lock, flags);
 
 	dprintk(NDEBUG_QUEUES, "scsi%d: command added to %s of queue\n", H_NO(cmd),
 		  (cmd->cmnd[0] == REQUEST_SENSE) ? "head" : "tail");
@@ -1006,7 +1001,6 @@ static void NCR5380_main(struct work_str
 	struct Scsi_Host *instance = hostdata->host;
 	struct scsi_cmnd *tmp, *prev;
 	int done;
-	unsigned long flags;
 
 	/*
 	 * ++roman: Just disabling the NCR interrupt isn't sufficient here,
@@ -1014,9 +1008,8 @@ static void NCR5380_main(struct work_str
 	 * alter queues and touch the Falcon lock.
 	 */
 
-	local_save_flags(flags);
+	spin_lock_irq(&hostdata->lock);
 	do {
-		local_irq_disable();	/* Freeze request queues */
 		done = 1;
 
 		if (!hostdata->connected) {
@@ -1043,7 +1036,6 @@ static void NCR5380_main(struct work_str
 				        tmp, scmd_id(tmp), hostdata->busy[scmd_id(tmp)],
 				        lun);
 				/*  When we find one, remove it from the issue queue. */
-				/* ++guenther: possible race with Falcon locking */
 				if (
 #ifdef SUPPORT_TAGS
 				    !is_lun_busy( tmp, tmp->cmnd[0] != REQUEST_SENSE)
@@ -1051,8 +1043,6 @@ static void NCR5380_main(struct work_str
 				    !(hostdata->busy[tmp->device->id] & (1 << lun))
 #endif
 				    ) {
-					/* ++guenther: just to be sure, this must be atomic */
-					local_irq_disable();
 					if (prev) {
 						REMOVE(prev, NEXT(prev), tmp, NEXT(tmp));
 						SET_NEXT(prev, NEXT(tmp));
@@ -1063,9 +1053,6 @@ static void NCR5380_main(struct work_str
 					SET_NEXT(tmp, NULL);
 					hostdata->retain_dma_intr++;
 
-					/* reenable interrupts after finding one */
-					local_irq_restore(flags);
-
 					/*
 					 * Attempt to establish an I_T_L nexus here.
 					 * On success, instance->hostdata->connected is set.
@@ -1090,13 +1077,10 @@ static void NCR5380_main(struct work_str
 #endif
 					if (!NCR5380_select(instance, tmp)) {
 						/* OK or bad target */
-						local_irq_disable();
 						hostdata->retain_dma_intr--;
 						maybe_release_dma_irq(instance);
-						local_irq_restore(flags);
 					} else {
 						/* Need to retry */
-						local_irq_disable();
 						LIST(tmp, hostdata->issue_queue);
 						SET_NEXT(tmp, hostdata->issue_queue);
 						hostdata->issue_queue = tmp;
@@ -1104,7 +1088,6 @@ static void NCR5380_main(struct work_str
 						cmd_free_tag(tmp);
 #endif
 						hostdata->retain_dma_intr--;
-						local_irq_restore(flags);
 						done = 0;
 						dprintk(NDEBUG_MAIN, "scsi%d: main(): select() failed, "
 							    "returned to issue_queue\n", HOSTNO);
@@ -1120,7 +1103,6 @@ static void NCR5380_main(struct work_str
 		    && !hostdata->dma_len
 #endif
 		    ) {
-			local_irq_restore(flags);
 			dprintk(NDEBUG_MAIN, "scsi%d: main: performing information transfer\n",
 				    HOSTNO);
 			NCR5380_information_transfer(instance);
@@ -1128,7 +1110,7 @@ static void NCR5380_main(struct work_str
 			done = 0;
 		}
 	} while (!done);
-	local_irq_restore(flags);
+	spin_unlock_irq(&hostdata->lock);
 }
 
 
@@ -1257,6 +1239,9 @@ static irqreturn_t NCR5380_intr(int irq,
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	int handled = 0;
 	unsigned char basr;
+	unsigned long flags;
+
+	spin_lock_irqsave(&hostdata->lock, flags);
 
 	basr = NCR5380_read(BUS_AND_STATUS_REG);
 	if (basr & BASR_IRQ) {
@@ -1316,6 +1301,8 @@ static irqreturn_t NCR5380_intr(int irq,
 #endif
 	}
 
+	spin_unlock_irqrestore(&hostdata->lock, flags);
+
 	return IRQ_RETVAL(handled);
 }
 
@@ -1355,7 +1342,6 @@ static int NCR5380_select(struct Scsi_Ho
 	unsigned char *data;
 	int len;
 	int err;
-	unsigned long flags;
 
 	NCR5380_dprint(NDEBUG_ARBITRATION, instance);
 	dprintk(NDEBUG_ARBITRATION, "scsi%d: starting arbitration, id = %d\n", HOSTNO,
@@ -1366,11 +1352,6 @@ static int NCR5380_select(struct Scsi_Ho
 	 * data bus during SELECTION.
 	 */
 
-	local_irq_save(flags);
-	if (hostdata->connected) {
-		local_irq_restore(flags);
-		return -1;
-	}
 	NCR5380_write(TARGET_COMMAND_REG, 0);
 
 	/*
@@ -1384,10 +1365,11 @@ static int NCR5380_select(struct Scsi_Ho
 	 * Bus Free Delay, arbitration will begin.
 	 */
 
-	local_irq_restore(flags);
+	spin_unlock_irq(&hostdata->lock);
 	err = NCR5380_poll_politely2(instance, MODE_REG, MR_ARBITRATE, 0,
 	                INITIATOR_COMMAND_REG, ICR_ARBITRATION_PROGRESS,
 	                                       ICR_ARBITRATION_PROGRESS, HZ);
+	spin_lock_irq(&hostdata->lock);
 	if (!(NCR5380_read(MODE_REG) & MR_ARBITRATE)) {
 		/* Reselection interrupt */
 		return -1;
@@ -1398,6 +1380,7 @@ static int NCR5380_select(struct Scsi_Ho
 		             "select: arbitration timeout\n");
 		return -1;
 	}
+	spin_unlock_irq(&hostdata->lock);
 
 	/* The SCSI-2 arbitration delay is 2.4 us */
 	udelay(3);
@@ -1405,11 +1388,11 @@ static int NCR5380_select(struct Scsi_Ho
 	/* Check for lost arbitration */
 	if ((NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_LOST) ||
 	    (NCR5380_read(CURRENT_SCSI_DATA_REG) & hostdata->id_higher_mask) ||
-	    (NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_LOST) ||
-	    hostdata->connected) {
+	    (NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_LOST)) {
 		NCR5380_write(MODE_REG, MR_BASE);
 		dprintk(NDEBUG_ARBITRATION, "scsi%d: lost arbitration, deasserting MR_ARBITRATE\n",
 			   HOSTNO);
+		spin_lock_irq(&hostdata->lock);
 		return -1;
 	}
 
@@ -1430,6 +1413,8 @@ static int NCR5380_select(struct Scsi_Ho
 	else
 		udelay(2);
 
+	spin_lock_irq(&hostdata->lock);
+
 	/* NCR5380_reselect() clears MODE_REG after a reselection interrupt */
 	if (!(NCR5380_read(MODE_REG) & MR_ARBITRATE))
 		return -1;
@@ -1457,14 +1442,10 @@ static int NCR5380_select(struct Scsi_Ho
 	 * Reselect interrupts must be turned off prior to the dropping of BSY,
 	 * otherwise we will trigger an interrupt.
 	 */
-
-	if (hostdata->connected) {
-		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-		return -1;
-	}
-
 	NCR5380_write(SELECT_ENABLE_REG, 0);
 
+	spin_unlock_irq(&hostdata->lock);
+
 	/*
 	 * The initiator shall then wait at least two deskew delays and release
 	 * the BSY signal.
@@ -1505,6 +1486,7 @@ static int NCR5380_select(struct Scsi_Ho
 	                            msecs_to_jiffies(250));
 
 	if ((NCR5380_read(STATUS_REG) & (SR_SEL | SR_IO)) == (SR_SEL | SR_IO)) {
+		spin_lock_irq(&hostdata->lock);
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 		NCR5380_reselect(instance);
 		if (!hostdata->connected)
@@ -1515,6 +1497,7 @@ static int NCR5380_select(struct Scsi_Ho
 	}
 
 	if (err < 0) {
+		spin_lock_irq(&hostdata->lock);
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 		cmd->result = DID_BAD_TARGET << 16;
 #ifdef SUPPORT_TAGS
@@ -1554,6 +1537,7 @@ static int NCR5380_select(struct Scsi_Ho
 	/* Wait for start of REQ/ACK handshake */
 
 	err = NCR5380_poll_politely(instance, STATUS_REG, SR_REQ, SR_REQ, HZ);
+	spin_lock_irq(&hostdata->lock);
 	if (err < 0) {
 		shost_printk(KERN_ERR, instance, "select: REQ timeout\n");
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
@@ -1583,6 +1567,7 @@ static int NCR5380_select(struct Scsi_Ho
 	NCR5380_transfer_pio(instance, &phase, &len, &data);
 	dprintk(NDEBUG_SELECTION, "scsi%d: nexus established.\n", HOSTNO);
 	/* XXX need to handle errors here */
+
 	hostdata->connected = cmd;
 #ifndef SUPPORT_TAGS
 	hostdata->busy[cmd->device->id] |= (1 << cmd->device->lun);
@@ -1849,7 +1834,6 @@ static int NCR5380_transfer_dma(struct S
 	SETUP_HOSTDATA(instance);
 	register int c = *count;
 	register unsigned char p = *phase;
-	unsigned long flags;
 
 #if defined(CONFIG_SUN3)
 	/* sanity check */
@@ -1865,7 +1849,6 @@ static int NCR5380_transfer_dma(struct S
 		c, (p & SR_IO) ? "to" : "from", *data);
 
 	/* netbsd turns off ints here, why not be safe and do it too */
-	local_irq_save(flags);
 
 	/* send start chain */
 	sun3scsi_dma_start(c, *data);
@@ -1885,8 +1868,6 @@ static int NCR5380_transfer_dma(struct S
 	dregs->csr |= CSR_DMA_ENABLE;
 #endif
 
-	local_irq_restore(flags);
-
 	sun3_dma_active = 1;
 
 #else /* !defined(CONFIG_SUN3) */
@@ -1913,11 +1894,9 @@ static int NCR5380_transfer_dma(struct S
 		/* On the Medusa, it is a must to initialize the DMA before
 		 * starting the NCR. This is also the cleaner way for the TT.
 		 */
-		local_irq_save(flags);
 		hostdata->dma_len = (p & SR_IO) ?
 			NCR5380_dma_read_setup(instance, d, c) :
 			NCR5380_dma_write_setup(instance, d, c);
-		local_irq_restore(flags);
 	}
 
 	if (p & SR_IO)
@@ -1931,11 +1910,9 @@ static int NCR5380_transfer_dma(struct S
 		/* On the Falcon, the DMA setup must be done after the last */
 		/* NCR access, else the DMA setup gets trashed!
 		 */
-		local_irq_save(flags);
 		hostdata->dma_len = (p & SR_IO) ?
 			NCR5380_dma_read_setup(instance, d, c) :
 			NCR5380_dma_write_setup(instance, d, c);
-		local_irq_restore(flags);
 	}
 #endif /* !defined(CONFIG_SUN3) */
 
@@ -1963,7 +1940,6 @@ static int NCR5380_transfer_dma(struct S
 static void NCR5380_information_transfer(struct Scsi_Host *instance)
 {
 	SETUP_HOSTDATA(instance);
-	unsigned long flags;
 	unsigned char msgout = NOP;
 	int sink = 0;
 	int len;
@@ -1972,13 +1948,13 @@ static void NCR5380_information_transfer
 #endif
 	unsigned char *data;
 	unsigned char phase, tmp, extended_msg[10], old_phase = 0xff;
-	struct scsi_cmnd *cmd = (struct scsi_cmnd *) hostdata->connected;
+	struct scsi_cmnd *cmd;
 
 #ifdef SUN3_SCSI_VME
 	dregs->csr |= CSR_INTR;
 #endif
 
-	while (1) {
+	while ((cmd = hostdata->connected)) {
 		tmp = NCR5380_read(STATUS_REG);
 		/* We only have a valid SCSI phase when REQ is asserted */
 		if (tmp & SR_REQ) {
@@ -2112,9 +2088,13 @@ static void NCR5380_information_transfer
 					}
 				} else
 #endif /* defined(REAL_DMA) */
+				{
+					spin_unlock_irq(&hostdata->lock);
 					NCR5380_transfer_pio(instance, &phase,
 							     (int *)&cmd->SCp.this_residual,
 							     (unsigned char **)&cmd->SCp.ptr);
+					spin_lock_irq(&hostdata->lock);
+				}
 #if defined(CONFIG_SUN3) && defined(REAL_DMA)
 				/* if we had intended to dma that command clear it */
 				if (sun3_dma_setup_done == cmd)
@@ -2124,7 +2104,6 @@ static void NCR5380_information_transfer
 			case PHASE_MSGIN:
 				len = 1;
 				data = &tmp;
-				NCR5380_write(SELECT_ENABLE_REG, 0);	/* disable reselects */
 				NCR5380_transfer_pio(instance, &phase, &len, &data);
 				cmd->SCp.Message = tmp;
 
@@ -2136,7 +2115,6 @@ static void NCR5380_information_transfer
 					dprintk(NDEBUG_QUEUES, "scsi%d: command for target %d, lun %llu "
 						  "completed\n", HOSTNO, cmd->device->id, cmd->device->lun);
 
-					local_irq_save(flags);
 					hostdata->connected = NULL;
 #ifdef SUPPORT_TAGS
 					cmd_free_tag(cmd);
@@ -2152,8 +2130,6 @@ static void NCR5380_information_transfer
 #else
 					hostdata->busy[cmd->device->id] &= ~(1 << cmd->device->lun);
 #endif
-					/* Enable reselect interrupts */
-					NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 
 					/*
 					 * I'm not sure what the correct thing to do here is :
@@ -2211,13 +2187,10 @@ static void NCR5380_information_transfer
 					 * disconnected queue.
 					 */
 					maybe_release_dma_irq(instance);
-					local_irq_restore(flags);
 					return;
 				case MESSAGE_REJECT:
 					/* Accept message by clearing ACK */
 					NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-					/* Enable reselect interrupts */
-					NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 					switch (hostdata->last_message) {
 					case HEAD_OF_QUEUE_TAG:
 					case ORDERED_QUEUE_TAG:
@@ -2241,12 +2214,10 @@ static void NCR5380_information_transfer
 				case DISCONNECT:
 					/* Accept message by clearing ACK */
 					NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-					local_irq_save(flags);
 					LIST(cmd,hostdata->disconnected_queue);
 					SET_NEXT(cmd, hostdata->disconnected_queue);
 					hostdata->connected = NULL;
 					hostdata->disconnected_queue = cmd;
-					local_irq_restore(flags);
 					dprintk(NDEBUG_QUEUES, "scsi%d: command for target %d lun %llu was "
 						  "moved from connected to the "
 						  "disconnected_queue\n", HOSTNO,
@@ -2277,8 +2248,6 @@ static void NCR5380_information_transfer
 				case RESTORE_POINTERS:
 					/* Accept message by clearing ACK */
 					NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-					/* Enable reselect interrupts */
-					NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 					break;
 				case EXTENDED_MESSAGE:
 					/*
@@ -2297,6 +2266,8 @@ static void NCR5380_information_transfer
 					/* Accept first byte by clearing ACK */
 					NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 
+					spin_unlock_irq(&hostdata->lock);
+
 					dprintk(NDEBUG_EXTENDED, "scsi%d: receiving extended message\n", HOSTNO);
 
 					len = 2;
@@ -2335,6 +2306,11 @@ static void NCR5380_information_transfer
 							   HOSTNO, extended_msg[2], extended_msg[1]);
 						tmp = 0;
 					}
+
+					spin_lock_irq(&hostdata->lock);
+					if (!hostdata->connected)
+						return;
+
 					/* Fall through to reject message */
 
 					/*
@@ -2367,7 +2343,6 @@ static void NCR5380_information_transfer
 				hostdata->last_message = msgout;
 				NCR5380_transfer_pio(instance, &phase, &len, &data);
 				if (msgout == ABORT) {
-					local_irq_save(flags);
 #ifdef SUPPORT_TAGS
 					cmd_free_tag(cmd);
 #else
@@ -2376,7 +2351,6 @@ static void NCR5380_information_transfer
 					hostdata->connected = NULL;
 					cmd->result = DID_ERROR << 16;
 					maybe_release_dma_irq(instance);
-					local_irq_restore(flags);
 					cmd->scsi_done(cmd);
 					NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 					return;
@@ -2404,9 +2378,11 @@ static void NCR5380_information_transfer
 				NCR5380_dprint(NDEBUG_ANY, instance);
 			} /* switch(phase) */
 		} else {
+			spin_unlock_irq(&hostdata->lock);
 			NCR5380_poll_politely(instance, STATUS_REG, SR_REQ, SR_REQ, HZ);
+			spin_lock_irq(&hostdata->lock);
 		}
-	} /* while (1) */
+	}
 }
 
 /*
@@ -2639,9 +2615,9 @@ int NCR5380_abort(struct scsi_cmnd *cmd)
 
 	scmd_printk(KERN_NOTICE, cmd, "aborting command\n");
 
-	NCR5380_print_status(instance);
+	spin_lock_irqsave(&hostdata->lock, flags);
 
-	local_irq_save(flags);
+	NCR5380_print_status(instance);
 
 	dprintk(NDEBUG_ABORT, "scsi%d: abort called basr 0x%02x, sr 0x%02x\n", HOSTNO,
 		    NCR5380_read(BUS_AND_STATUS_REG),
@@ -2683,11 +2659,11 @@ int NCR5380_abort(struct scsi_cmnd *cmd)
 			hostdata->busy[cmd->device->id] &= ~(1 << cmd->device->lun);
 #endif
 			maybe_release_dma_irq(instance);
-			local_irq_restore(flags);
+			spin_unlock_irqrestore(&hostdata->lock, flags);
 			cmd->scsi_done(cmd);
 			return SUCCESS;
 		} else {
-			local_irq_restore(flags);
+			spin_unlock_irqrestore(&hostdata->lock, flags);
 			printk("scsi%d: abort of connected command failed!\n", HOSTNO);
 			return FAILED;
 		}
@@ -2707,7 +2683,7 @@ int NCR5380_abort(struct scsi_cmnd *cmd)
 			SET_NEXT(tmp, NULL);
 			tmp->result = DID_ABORT << 16;
 			maybe_release_dma_irq(instance);
-			local_irq_restore(flags);
+			spin_unlock_irqrestore(&hostdata->lock, flags);
 			dprintk(NDEBUG_ABORT, "scsi%d: abort removed command from issue queue.\n",
 				    HOSTNO);
 			/* Tagged queuing note: no tag to free here, hasn't been assigned
@@ -2729,7 +2705,7 @@ int NCR5380_abort(struct scsi_cmnd *cmd)
 	 */
 
 	if (hostdata->connected) {
-		local_irq_restore(flags);
+		spin_unlock_irqrestore(&hostdata->lock, flags);
 		dprintk(NDEBUG_ABORT, "scsi%d: abort failed, command connected.\n", HOSTNO);
 		return FAILED;
 	}
@@ -2762,17 +2738,16 @@ int NCR5380_abort(struct scsi_cmnd *cmd)
 	for (tmp = (struct scsi_cmnd *) hostdata->disconnected_queue; tmp;
 	     tmp = NEXT(tmp)) {
 		if (cmd == tmp) {
-			local_irq_restore(flags);
 			dprintk(NDEBUG_ABORT, "scsi%d: aborting disconnected command.\n", HOSTNO);
 
-			if (NCR5380_select(instance, cmd))
+			if (NCR5380_select(instance, cmd)) {
+				spin_unlock_irq(&hostdata->lock);
 				return FAILED;
-
+			}
 			dprintk(NDEBUG_ABORT, "scsi%d: nexus reestablished.\n", HOSTNO);
 
 			do_abort(instance);
 
-			local_irq_save(flags);
 			for (prev = (struct scsi_cmnd **)&(hostdata->disconnected_queue),
 			     tmp = (struct scsi_cmnd *)hostdata->disconnected_queue;
 			     tmp; prev = NEXTADDR(tmp), tmp = NEXT(tmp)) {
@@ -2791,7 +2766,7 @@ int NCR5380_abort(struct scsi_cmnd *cmd)
 					hostdata->busy[cmd->device->id] &= ~(1 << cmd->device->lun);
 #endif
 					maybe_release_dma_irq(instance);
-					local_irq_restore(flags);
+					spin_unlock_irqrestore(&hostdata->lock, flags);
 					tmp->scsi_done(tmp);
 					return SUCCESS;
 				}
@@ -2804,7 +2779,7 @@ int NCR5380_abort(struct scsi_cmnd *cmd)
 	 * released after the abort, in case it is kept due to some bug.
 	 */
 	maybe_release_dma_irq(instance);
-	local_irq_restore(flags);
+	spin_unlock_irqrestore(&hostdata->lock, flags);
 
 	/*
 	 * Case 5 : If we reached this point, the command was not found in any of
@@ -2836,7 +2811,7 @@ static int NCR5380_bus_reset(struct scsi
 	int i;
 	unsigned long flags;
 
-	local_irq_save(flags);
+	spin_lock_irqsave(&hostdata->lock, flags);
 
 #if (NDEBUG & NDEBUG_ANY)
 	scmd_printk(KERN_INFO, cmd, "performing bus reset\n");
@@ -2876,7 +2851,7 @@ static int NCR5380_bus_reset(struct scsi
 #endif
 
 	maybe_release_dma_irq(instance);
-	local_irq_restore(flags);
+	spin_unlock_irqrestore(&hostdata->lock, flags);
 
 	return SUCCESS;
 }
Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2016-01-03 16:04:08.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2016-01-03 16:04:09.000000000 +1100
@@ -612,6 +612,7 @@ static int __maybe_unused NCR5380_show_i
 {
 	struct NCR5380_hostdata *hostdata;
 	struct scsi_cmnd *ptr;
+	unsigned long flags;
 
 	hostdata = (struct NCR5380_hostdata *) instance->hostdata;
 
@@ -619,7 +620,7 @@ static int __maybe_unused NCR5380_show_i
 	seq_printf(m, "Highwater I/O busy spin counts: write %d, read %d\n",
 	        hostdata->spin_max_w, hostdata->spin_max_r);
 #endif
-	spin_lock_irq(instance->host_lock);
+	spin_lock_irqsave(&hostdata->lock, flags);
 	if (!hostdata->connected)
 		seq_printf(m, "scsi%d: no currently connected command\n", instance->host_no);
 	else
@@ -631,7 +632,7 @@ static int __maybe_unused NCR5380_show_i
 	seq_printf(m, "scsi%d: disconnected_queue\n", instance->host_no);
 	for (ptr = (struct scsi_cmnd *) hostdata->disconnected_queue; ptr; ptr = (struct scsi_cmnd *) ptr->host_scribble)
 		lprint_Scsi_Cmnd(ptr, m);
-	spin_unlock_irq(instance->host_lock);
+	spin_unlock_irqrestore(&hostdata->lock, flags);
 	return 0;
 }
 
@@ -691,6 +692,7 @@ static int NCR5380_init(struct Scsi_Host
 #ifdef REAL_DMA
 	hostdata->dmalen = 0;
 #endif
+	spin_lock_init(&hostdata->lock);
 	hostdata->connected = NULL;
 	hostdata->issue_queue = NULL;
 	hostdata->disconnected_queue = NULL;
@@ -830,7 +832,7 @@ static int NCR5380_queue_command(struct
 	cmd->host_scribble = NULL;
 	cmd->result = 0;
 
-	spin_lock_irqsave(instance->host_lock, flags);
+	spin_lock_irqsave(&hostdata->lock, flags);
 
 	/* 
 	 * Insert the cmd into the issue queue. Note that REQUEST SENSE 
@@ -848,7 +850,7 @@ static int NCR5380_queue_command(struct
 		LIST(cmd, tmp);
 		tmp->host_scribble = (unsigned char *) cmd;
 	}
-	spin_unlock_irqrestore(instance->host_lock, flags);
+	spin_unlock_irqrestore(&hostdata->lock, flags);
 
 	dprintk(NDEBUG_QUEUES, "scsi%d : command added to %s of queue\n", instance->host_no, (cmd->cmnd[0] == REQUEST_SENSE) ? "head" : "tail");
 
@@ -877,10 +879,10 @@ static void NCR5380_main(struct work_str
 	struct scsi_cmnd *tmp, *prev;
 	int done;
 	
-	spin_lock_irq(instance->host_lock);
+	spin_lock_irq(&hostdata->lock);
 	do {
-		/* Lock held here */
 		done = 1;
+
 		if (!hostdata->connected) {
 			dprintk(NDEBUG_MAIN, "scsi%d : not connected\n", instance->host_no);
 			/*
@@ -930,11 +932,10 @@ static void NCR5380_main(struct work_str
 					}
 					if (hostdata->connected)
 						break;
-					/* lock held here still */
 				}	/* if target/lun is not busy */
 			}	/* for */
-			/* exited locked */
 		}	/* if (!hostdata->connected) */
+
 		if (hostdata->connected
 #ifdef REAL_DMA
 		    && !hostdata->dmalen
@@ -946,8 +947,7 @@ static void NCR5380_main(struct work_str
 			done = 0;
 		}
 	} while (!done);
-	
-	spin_unlock_irq(instance->host_lock);
+	spin_unlock_irq(&hostdata->lock);
 }
 
 #ifndef DONT_USE_INTR
@@ -994,7 +994,7 @@ static irqreturn_t NCR5380_intr(int irq,
 	unsigned char basr;
 	unsigned long flags;
 
-	spin_lock_irqsave(instance->host_lock, flags);
+	spin_lock_irqsave(&hostdata->lock, flags);
 
 	basr = NCR5380_read(BUS_AND_STATUS_REG);
 	if (basr & BASR_IRQ) {
@@ -1058,7 +1058,7 @@ static irqreturn_t NCR5380_intr(int irq,
 		shost_printk(KERN_NOTICE, instance, "interrupt without IRQ bit\n");
 	}
 
-	spin_unlock_irqrestore(instance->host_lock, flags);
+	spin_unlock_irqrestore(&hostdata->lock, flags);
 
 	return IRQ_RETVAL(handled);
 }
@@ -1125,11 +1125,11 @@ static int NCR5380_select(struct Scsi_Ho
 	 * Bus Free Delay, arbitration will begin.
 	 */
 
-	spin_unlock_irq(instance->host_lock);
+	spin_unlock_irq(&hostdata->lock);
 	err = NCR5380_poll_politely2(instance, MODE_REG, MR_ARBITRATE, 0,
 	                INITIATOR_COMMAND_REG, ICR_ARBITRATION_PROGRESS,
 	                                       ICR_ARBITRATION_PROGRESS, HZ);
-	spin_lock_irq(instance->host_lock);
+	spin_lock_irq(&hostdata->lock);
 	if (!(NCR5380_read(MODE_REG) & MR_ARBITRATE)) {
 		/* Reselection interrupt */
 		return -1;
@@ -1140,6 +1140,7 @@ static int NCR5380_select(struct Scsi_Ho
 		             "select: arbitration timeout\n");
 		return -1;
 	}
+	spin_unlock_irq(&hostdata->lock);
 
 	/* The SCSI-2 arbitration delay is 2.4 us */
 	udelay(3);
@@ -1148,6 +1149,7 @@ static int NCR5380_select(struct Scsi_Ho
 	if ((NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_LOST) || (NCR5380_read(CURRENT_SCSI_DATA_REG) & hostdata->id_higher_mask) || (NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_LOST)) {
 		NCR5380_write(MODE_REG, MR_BASE);
 		dprintk(NDEBUG_ARBITRATION, "scsi%d : lost arbitration, deasserting MR_ARBITRATE\n", instance->host_no);
+		spin_lock_irq(&hostdata->lock);
 		return -1;
 	}
 
@@ -1168,6 +1170,8 @@ static int NCR5380_select(struct Scsi_Ho
 	else
 		udelay(2);
 
+	spin_lock_irq(&hostdata->lock);
+
 	/* NCR5380_reselect() clears MODE_REG after a reselection interrupt */
 	if (!(NCR5380_read(MODE_REG) & MR_ARBITRATE))
 		return -1;
@@ -1196,6 +1200,8 @@ static int NCR5380_select(struct Scsi_Ho
 	 */
 	NCR5380_write(SELECT_ENABLE_REG, 0);
 
+	spin_unlock_irq(&hostdata->lock);
+
 	/*
 	 * The initiator shall then wait at least two deskew delays and release 
 	 * the BSY signal.
@@ -1235,6 +1241,7 @@ static int NCR5380_select(struct Scsi_Ho
 	                            msecs_to_jiffies(250));
 
 	if ((NCR5380_read(STATUS_REG) & (SR_SEL | SR_IO)) == (SR_SEL | SR_IO)) {
+		spin_lock_irq(&hostdata->lock);
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 		NCR5380_reselect(instance);
 		if (!hostdata->connected)
@@ -1244,6 +1251,7 @@ static int NCR5380_select(struct Scsi_Ho
 	}
 
 	if (err < 0) {
+		spin_lock_irq(&hostdata->lock);
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 		cmd->result = DID_BAD_TARGET << 16;
 		cmd->scsi_done(cmd);
@@ -1280,9 +1288,8 @@ static int NCR5380_select(struct Scsi_Ho
 
 	/* Wait for start of REQ/ACK handshake */
 
-	spin_unlock_irq(instance->host_lock);
 	err = NCR5380_poll_politely(instance, STATUS_REG, SR_REQ, SR_REQ, HZ);
-	spin_lock_irq(instance->host_lock);
+	spin_lock_irq(&hostdata->lock);
 	if (err < 0) {
 		shost_printk(KERN_ERR, instance, "select: REQ timeout\n");
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
@@ -1302,6 +1309,7 @@ static int NCR5380_select(struct Scsi_Ho
 	NCR5380_transfer_pio(instance, &phase, &len, &data);
 	dprintk(NDEBUG_SELECTION, "scsi%d : nexus established.\n", instance->host_no);
 	/* XXX need to handle errors here */
+
 	hostdata->connected = cmd;
 	hostdata->busy[cmd->device->id] |= (1 << (cmd->device->lun & 0xFF));
 
@@ -1805,9 +1813,9 @@ static void NCR5380_information_transfer
 #endif
 	unsigned char *data;
 	unsigned char phase, tmp, extended_msg[10], old_phase = 0xff;
-	struct scsi_cmnd *cmd = (struct scsi_cmnd *) hostdata->connected;
+	struct scsi_cmnd *cmd;
 
-	while (1) {
+	while ((cmd = hostdata->connected)) {
 		tmp = NCR5380_read(STATUS_REG);
 		/* We only have a valid SCSI phase when REQ is asserted */
 		if (tmp & SR_REQ) {
@@ -1883,8 +1891,12 @@ static void NCR5380_information_transfer
 						cmd->SCp.this_residual -= transfersize - len;
 				} else
 #endif				/* defined(PSEUDO_DMA) || defined(REAL_DMA_POLL) */
+				{
+					spin_unlock_irq(&hostdata->lock);
 					NCR5380_transfer_pio(instance, &phase, (int *) &cmd->SCp.this_residual, (unsigned char **)
 							     &cmd->SCp.ptr);
+					spin_lock_irq(&hostdata->lock);
+				}
 				break;
 			case PHASE_MSGIN:
 				len = 1;
@@ -2016,6 +2028,9 @@ static void NCR5380_information_transfer
 					extended_msg[0] = EXTENDED_MESSAGE;
 					/* Accept first byte by clearing ACK */
 					NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
+
+					spin_unlock_irq(&hostdata->lock);
+
 					dprintk(NDEBUG_EXTENDED, "scsi%d : receiving extended message\n", instance->host_no);
 
 					len = 2;
@@ -2050,6 +2065,11 @@ static void NCR5380_information_transfer
 						printk("scsi%d: extended message code %02x length %d is too long\n", instance->host_no, extended_msg[2], extended_msg[1]);
 						tmp = 0;
 					}
+
+					spin_lock_irq(&hostdata->lock);
+					if (!hostdata->connected)
+						return;
+
 					/* Fall through to reject message */
 
 					/* 
@@ -2109,11 +2129,11 @@ static void NCR5380_information_transfer
 				NCR5380_dprint(NDEBUG_ANY, instance);
 			}	/* switch(phase) */
 		} else {
-			spin_unlock_irq(instance->host_lock);
+			spin_unlock_irq(&hostdata->lock);
 			NCR5380_poll_politely(instance, STATUS_REG, SR_REQ, SR_REQ, HZ);
-			spin_lock_irq(instance->host_lock);
+			spin_lock_irq(&hostdata->lock);
 		}
-	}			/* while (1) */
+	}
 }
 
 /*
@@ -2309,10 +2329,12 @@ static int NCR5380_abort(struct scsi_cmn
 	struct Scsi_Host *instance = cmd->device->host;
 	struct NCR5380_hostdata *hostdata = (struct NCR5380_hostdata *) instance->hostdata;
 	struct scsi_cmnd *tmp, **prev;
+	unsigned long flags;
 
 	scmd_printk(KERN_WARNING, cmd, "aborting command\n");
 
-	spin_lock_irq(instance->host_lock);
+	spin_lock_irqsave(&hostdata->lock, flags);
+
 	NCR5380_print_status(instance);
 
 	dprintk(NDEBUG_ABORT, "scsi%d : abort called\n", instance->host_no);
@@ -2359,7 +2381,7 @@ static int NCR5380_abort(struct scsi_cmn
 			REMOVE(5, *prev, tmp, tmp->host_scribble);
 			(*prev) = (struct scsi_cmnd *) tmp->host_scribble;
 			tmp->host_scribble = NULL;
-			spin_unlock_irq(instance->host_lock);
+			spin_unlock_irqrestore(&hostdata->lock, flags);
 			tmp->result = DID_ABORT << 16;
 			dprintk(NDEBUG_ABORT, "scsi%d : abort removed command from issue queue.\n", instance->host_no);
 			tmp->scsi_done(tmp);
@@ -2383,7 +2405,7 @@ static int NCR5380_abort(struct scsi_cmn
  */
 
 	if (hostdata->connected) {
-		spin_unlock_irq(instance->host_lock);
+		spin_unlock_irqrestore(&hostdata->lock, flags);
 		dprintk(NDEBUG_ABORT, "scsi%d : abort failed, command connected.\n", instance->host_no);
 		return FAILED;
 	}
@@ -2417,7 +2439,7 @@ static int NCR5380_abort(struct scsi_cmn
 			dprintk(NDEBUG_ABORT, "scsi%d : aborting disconnected command.\n", instance->host_no);
 
 			if (NCR5380_select(instance, cmd)) {
-				spin_unlock_irq(instance->host_lock);
+				spin_unlock_irq(&hostdata->lock);
 				return FAILED;
 			}
 			dprintk(NDEBUG_ABORT, "scsi%d : nexus reestablished.\n", instance->host_no);
@@ -2429,7 +2451,7 @@ static int NCR5380_abort(struct scsi_cmn
 					REMOVE(5, *prev, tmp, tmp->host_scribble);
 					*prev = (struct scsi_cmnd *) tmp->host_scribble;
 					tmp->host_scribble = NULL;
-					spin_unlock_irq(instance->host_lock);
+					spin_unlock_irqrestore(&hostdata->lock, flags);
 					tmp->result = DID_ABORT << 16;
 					tmp->scsi_done(tmp);
 					return SUCCESS;
@@ -2444,7 +2466,7 @@ static int NCR5380_abort(struct scsi_cmn
  * so we won't panic, but we will notify the user in case something really
  * broke.
  */
-	spin_unlock_irq(instance->host_lock);
+	spin_unlock_irqrestore(&hostdata->lock, flags);
 	printk(KERN_WARNING "scsi%d : warning : SCSI command probably completed successfully\n"
 			"         before abortion\n", instance->host_no);
 	return FAILED;
@@ -2461,8 +2483,10 @@ static int NCR5380_abort(struct scsi_cmn
 static int NCR5380_bus_reset(struct scsi_cmnd *cmd)
 {
 	struct Scsi_Host *instance = cmd->device->host;
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
+	unsigned long flags;
 
-	spin_lock_irq(instance->host_lock);
+	spin_lock_irqsave(&hostdata->lock, flags);
 
 #if (NDEBUG & NDEBUG_ANY)
 	scmd_printk(KERN_INFO, cmd, "performing bus reset\n");
@@ -2471,7 +2495,7 @@ static int NCR5380_bus_reset(struct scsi
 
 	do_reset(instance);
 
-	spin_unlock_irq(instance->host_lock);
+	spin_unlock_irqrestore(&hostdata->lock, flags);
 
 	return SUCCESS;
 }


