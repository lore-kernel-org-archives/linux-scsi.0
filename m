From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 50/71] ncr5380: Change instance->host_lock to hostdata->lock
Date: Wed, 18 Nov 2015 19:35:45 +1100
Message-ID: <20151118083511.171699690@telegraphics.com.au>
References: <20151118083455.331768508@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-adopt-new-spin-lock
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

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

---
 drivers/scsi/NCR5380.c       |   83 ++++++++++++++++---------
 drivers/scsi/NCR5380.h       |    1 
 drivers/scsi/atari_NCR5380.c |  139 +++++++++++++++++--------------------------
 3 files changed, 112 insertions(+), 111 deletions(-)

Index: linux/drivers/scsi/NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/NCR5380.h	2015-11-18 19:34:01.000000000 +1100
+++ linux/drivers/scsi/NCR5380.h	2015-11-18 19:34:10.000000000 +1100
@@ -257,6 +257,7 @@ struct NCR5380_hostdata {
 	volatile struct scsi_cmnd *connected;	/* currently connected command */
 	volatile struct scsi_cmnd *issue_queue;	/* waiting to be issued */
 	volatile struct scsi_cmnd *disconnected_queue;	/* waiting for reconnect */
+	spinlock_t lock;			/* protects this struct */
 	int flags;
 	struct scsi_eh_save ses;
 	char info[256];
Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2015-11-18 19:34:08.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2015-11-18 19:34:10.000000000 +1100
@@ -557,15 +557,13 @@ static struct {
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
@@ -696,14 +694,12 @@ static void __maybe_unused NCR5380_print
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
@@ -716,8 +712,6 @@ static void __maybe_unused NCR5380_print
 	for (ptr = (struct scsi_cmnd *) hostdata->disconnected_queue; ptr;
 	     ptr = NEXT(ptr))
 		lprint_Scsi_Cmnd(ptr);
-
-	local_irq_restore(flags);
 	printk("\n");
 }
 
@@ -744,7 +738,7 @@ static int __maybe_unused NCR5380_show_i
 
 	hostdata = (struct NCR5380_hostdata *)instance->hostdata;
 
-	local_irq_save(flags);
+	spin_lock_irqsave(&hostdata->lock, flags);
 	if (!hostdata->connected)
 		seq_printf(m, "scsi%d: no currently connected command\n", HOSTNO);
 	else
@@ -758,7 +752,7 @@ static int __maybe_unused NCR5380_show_i
 	     ptr = NEXT(ptr))
 		show_Scsi_Cmnd(ptr, m);
 
-	local_irq_restore(flags);
+	spin_unlock_irqrestore(&hostdata->lock, flags);
 	return 0;
 }
 
@@ -795,6 +789,7 @@ static int __init NCR5380_init(struct Sc
 #if defined (REAL_DMA)
 	hostdata->dma_len = 0;
 #endif
+	spin_lock_init(&hostdata->lock);
 	hostdata->connected = NULL;
 	hostdata->issue_queue = NULL;
 	hostdata->disconnected_queue = NULL;
@@ -943,7 +938,7 @@ static int NCR5380_queue_command(struct
 	if (!NCR5380_acquire_dma_irq(instance))
 		return SCSI_MLQUEUE_HOST_BUSY;
 
-	local_irq_save(flags);
+	spin_lock_irqsave(&hostdata->lock, flags);
 
 	/*
 	 * Insert the cmd into the issue queue. Note that REQUEST SENSE
@@ -963,7 +958,7 @@ static int NCR5380_queue_command(struct
 		LIST(cmd, tmp);
 		SET_NEXT(tmp, cmd);
 	}
-	local_irq_restore(flags);
+	spin_unlock_irqrestore(&hostdata->lock, flags);
 
 	dprintk(NDEBUG_QUEUES, "scsi%d: command added to %s of queue\n", H_NO(cmd),
 		  (cmd->cmnd[0] == REQUEST_SENSE) ? "head" : "tail");
@@ -1003,7 +998,6 @@ static void NCR5380_main(struct work_str
 	struct Scsi_Host *instance = hostdata->host;
 	struct scsi_cmnd *tmp, *prev;
 	int done;
-	unsigned long flags;
 
 	/*
 	 * ++roman: Just disabling the NCR interrupt isn't sufficient here,
@@ -1011,9 +1005,8 @@ static void NCR5380_main(struct work_str
 	 * alter queues and touch the Falcon lock.
 	 */
 
-	local_save_flags(flags);
+	spin_lock_irq(&hostdata->lock);
 	do {
-		local_irq_disable();	/* Freeze request queues */
 		done = 1;
 
 		if (!hostdata->connected) {
@@ -1040,7 +1033,6 @@ static void NCR5380_main(struct work_str
 				        tmp, scmd_id(tmp), hostdata->busy[scmd_id(tmp)],
 				        lun);
 				/*  When we find one, remove it from the issue queue. */
-				/* ++guenther: possible race with Falcon locking */
 				if (
 #ifdef SUPPORT_TAGS
 				    !is_lun_busy( tmp, tmp->cmnd[0] != REQUEST_SENSE)
@@ -1048,8 +1040,6 @@ static void NCR5380_main(struct work_str
 				    !(hostdata->busy[tmp->device->id] & (1 << lun))
 #endif
 				    ) {
-					/* ++guenther: just to be sure, this must be atomic */
-					local_irq_disable();
 					if (prev) {
 						REMOVE(prev, NEXT(prev), tmp, NEXT(tmp));
 						SET_NEXT(prev, NEXT(tmp));
@@ -1060,9 +1050,6 @@ static void NCR5380_main(struct work_str
 					SET_NEXT(tmp, NULL);
 					hostdata->retain_dma_intr++;
 
-					/* reenable interrupts after finding one */
-					local_irq_restore(flags);
-
 					/*
 					 * Attempt to establish an I_T_L nexus here.
 					 * On success, instance->hostdata->connected is set.
@@ -1087,13 +1074,10 @@ static void NCR5380_main(struct work_str
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
@@ -1101,7 +1085,6 @@ static void NCR5380_main(struct work_str
 						cmd_free_tag(tmp);
 #endif
 						hostdata->retain_dma_intr--;
-						local_irq_restore(flags);
 						done = 0;
 						dprintk(NDEBUG_MAIN, "scsi%d: main(): select() failed, "
 							    "returned to issue_queue\n", HOSTNO);
@@ -1117,7 +1100,6 @@ static void NCR5380_main(struct work_str
 		    && !hostdata->dma_len
 #endif
 		    ) {
-			local_irq_restore(flags);
 			dprintk(NDEBUG_MAIN, "scsi%d: main: performing information transfer\n",
 				    HOSTNO);
 			NCR5380_information_transfer(instance);
@@ -1125,7 +1107,7 @@ static void NCR5380_main(struct work_str
 			done = 0;
 		}
 	} while (!done);
-	local_irq_restore(flags);
+	spin_unlock_irq(&hostdata->lock);
 }
 
 
@@ -1254,6 +1236,9 @@ static irqreturn_t NCR5380_intr(int irq,
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	int handled = 0;
 	unsigned char basr;
+	unsigned long flags;
+
+	spin_lock_irqsave(&hostdata->lock, flags);
 
 	basr = NCR5380_read(BUS_AND_STATUS_REG);
 	if (basr & BASR_IRQ) {
@@ -1313,6 +1298,8 @@ static irqreturn_t NCR5380_intr(int irq,
 #endif
 	}
 
+	spin_unlock_irqrestore(&hostdata->lock, flags);
+
 	return IRQ_RETVAL(handled);
 }
 
@@ -1352,7 +1339,6 @@ static int NCR5380_select(struct Scsi_Ho
 	unsigned char *data;
 	int len;
 	int err;
-	unsigned long flags;
 
 	NCR5380_dprint(NDEBUG_ARBITRATION, instance);
 	dprintk(NDEBUG_ARBITRATION, "scsi%d: starting arbitration, id = %d\n", HOSTNO,
@@ -1363,11 +1349,6 @@ static int NCR5380_select(struct Scsi_Ho
 	 * data bus during SELECTION.
 	 */
 
-	local_irq_save(flags);
-	if (hostdata->connected) {
-		local_irq_restore(flags);
-		return -1;
-	}
 	NCR5380_write(TARGET_COMMAND_REG, 0);
 
 	/*
@@ -1381,10 +1362,11 @@ static int NCR5380_select(struct Scsi_Ho
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
@@ -1395,6 +1377,7 @@ static int NCR5380_select(struct Scsi_Ho
 		             "select: arbitration timeout\n");
 		return -1;
 	}
+	spin_unlock_irq(&hostdata->lock);
 
 	/* The SCSI-2 arbitration delay is 2.4 us */
 	udelay(3);
@@ -1402,11 +1385,11 @@ static int NCR5380_select(struct Scsi_Ho
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
 
@@ -1421,12 +1404,12 @@ static int NCR5380_select(struct Scsi_Ho
 	 * Seems to work with only Mustek scanner attached.
 	 */
 	if (!(hostdata->flags & FLAG_DTC3181E) &&
-	    ((NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_LOST) ||
-	     hostdata->connected)) {
+	    (NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_LOST)) {
 		NCR5380_write(MODE_REG, MR_BASE);
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 		dprintk(NDEBUG_ARBITRATION, "scsi%d: lost arbitration, deasserting ICR_ASSERT_SEL\n",
 			   HOSTNO);
+		spin_lock_irq(&hostdata->lock);
 		return -1;
 	}
 
@@ -1440,6 +1423,8 @@ static int NCR5380_select(struct Scsi_Ho
 	else
 		udelay(2);
 
+	spin_lock_irq(&hostdata->lock);
+
 	/* NCR5380_reselect() clears MODE_REG after a reselection interrupt */
 	if (!(NCR5380_read(MODE_REG) & MR_ARBITRATE))
 		return -1;
@@ -1467,14 +1452,10 @@ static int NCR5380_select(struct Scsi_Ho
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
@@ -1515,6 +1496,7 @@ static int NCR5380_select(struct Scsi_Ho
 	                            msecs_to_jiffies(250));
 
 	if ((NCR5380_read(STATUS_REG) & (SR_SEL | SR_IO)) == (SR_SEL | SR_IO)) {
+		spin_lock_irq(&hostdata->lock);
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 		NCR5380_reselect(instance);
 		if (!hostdata->connected)
@@ -1525,6 +1507,7 @@ static int NCR5380_select(struct Scsi_Ho
 	}
 
 	if (err < 0) {
+		spin_lock_irq(&hostdata->lock);
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 		cmd->result = DID_BAD_TARGET << 16;
 #ifdef SUPPORT_TAGS
@@ -1564,6 +1547,7 @@ static int NCR5380_select(struct Scsi_Ho
 	/* Wait for start of REQ/ACK handshake */
 
 	err = NCR5380_poll_politely(instance, STATUS_REG, SR_REQ, SR_REQ, HZ);
+	spin_lock_irq(&hostdata->lock);
 	if (err < 0) {
 		shost_printk(KERN_ERR, instance, "select: REQ timeout\n");
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
@@ -1593,6 +1577,7 @@ static int NCR5380_select(struct Scsi_Ho
 	NCR5380_transfer_pio(instance, &phase, &len, &data);
 	dprintk(NDEBUG_SELECTION, "scsi%d: nexus established.\n", HOSTNO);
 	/* XXX need to handle errors here */
+
 	hostdata->connected = cmd;
 #ifndef SUPPORT_TAGS
 	hostdata->busy[cmd->device->id] |= (1 << cmd->device->lun);
@@ -1859,7 +1844,6 @@ static int NCR5380_transfer_dma(struct S
 	SETUP_HOSTDATA(instance);
 	register int c = *count;
 	register unsigned char p = *phase;
-	unsigned long flags;
 
 #if defined(CONFIG_SUN3)
 	/* sanity check */
@@ -1875,7 +1859,6 @@ static int NCR5380_transfer_dma(struct S
 		c, (p & SR_IO) ? "to" : "from", *data);
 
 	/* netbsd turns off ints here, why not be safe and do it too */
-	local_irq_save(flags);
 
 	/* send start chain */
 	sun3scsi_dma_start(c, *data);
@@ -1895,8 +1878,6 @@ static int NCR5380_transfer_dma(struct S
 	dregs->csr |= CSR_DMA_ENABLE;
 #endif
 
-	local_irq_restore(flags);
-
 	sun3_dma_active = 1;
 
 #else /* !defined(CONFIG_SUN3) */
@@ -1923,11 +1904,9 @@ static int NCR5380_transfer_dma(struct S
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
@@ -1941,11 +1920,9 @@ static int NCR5380_transfer_dma(struct S
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
 
@@ -1973,7 +1950,6 @@ static int NCR5380_transfer_dma(struct S
 static void NCR5380_information_transfer(struct Scsi_Host *instance)
 {
 	SETUP_HOSTDATA(instance);
-	unsigned long flags;
 	unsigned char msgout = NOP;
 	int sink = 0;
 	int len;
@@ -1982,13 +1958,13 @@ static void NCR5380_information_transfer
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
@@ -2122,9 +2098,13 @@ static void NCR5380_information_transfer
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
@@ -2134,7 +2114,6 @@ static void NCR5380_information_transfer
 			case PHASE_MSGIN:
 				len = 1;
 				data = &tmp;
-				NCR5380_write(SELECT_ENABLE_REG, 0);	/* disable reselects */
 				NCR5380_transfer_pio(instance, &phase, &len, &data);
 				cmd->SCp.Message = tmp;
 
@@ -2146,7 +2125,6 @@ static void NCR5380_information_transfer
 					dprintk(NDEBUG_QUEUES, "scsi%d: command for target %d, lun %llu "
 						  "completed\n", HOSTNO, cmd->device->id, cmd->device->lun);
 
-					local_irq_save(flags);
 					hostdata->connected = NULL;
 #ifdef SUPPORT_TAGS
 					cmd_free_tag(cmd);
@@ -2162,8 +2140,6 @@ static void NCR5380_information_transfer
 #else
 					hostdata->busy[cmd->device->id] &= ~(1 << cmd->device->lun);
 #endif
-					/* Enable reselect interrupts */
-					NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 
 					/*
 					 * I'm not sure what the correct thing to do here is :
@@ -2221,13 +2197,10 @@ static void NCR5380_information_transfer
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
@@ -2251,12 +2224,10 @@ static void NCR5380_information_transfer
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
@@ -2287,8 +2258,6 @@ static void NCR5380_information_transfer
 				case RESTORE_POINTERS:
 					/* Accept message by clearing ACK */
 					NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-					/* Enable reselect interrupts */
-					NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 					break;
 				case EXTENDED_MESSAGE:
 					/*
@@ -2307,6 +2276,8 @@ static void NCR5380_information_transfer
 					/* Accept first byte by clearing ACK */
 					NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 
+					spin_unlock_irq(&hostdata->lock);
+
 					dprintk(NDEBUG_EXTENDED, "scsi%d: receiving extended message\n", HOSTNO);
 
 					len = 2;
@@ -2345,6 +2316,11 @@ static void NCR5380_information_transfer
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
@@ -2377,7 +2353,6 @@ static void NCR5380_information_transfer
 				hostdata->last_message = msgout;
 				NCR5380_transfer_pio(instance, &phase, &len, &data);
 				if (msgout == ABORT) {
-					local_irq_save(flags);
 #ifdef SUPPORT_TAGS
 					cmd_free_tag(cmd);
 #else
@@ -2386,7 +2361,6 @@ static void NCR5380_information_transfer
 					hostdata->connected = NULL;
 					cmd->result = DID_ERROR << 16;
 					maybe_release_dma_irq(instance);
-					local_irq_restore(flags);
 					cmd->scsi_done(cmd);
 					NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 					return;
@@ -2414,9 +2388,11 @@ static void NCR5380_information_transfer
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
@@ -2649,9 +2625,9 @@ int NCR5380_abort(struct scsi_cmnd *cmd)
 
 	scmd_printk(KERN_NOTICE, cmd, "aborting command\n");
 
-	NCR5380_print_status(instance);
+	spin_lock_irqsave(&hostdata->lock, flags);
 
-	local_irq_save(flags);
+	NCR5380_print_status(instance);
 
 	dprintk(NDEBUG_ABORT, "scsi%d: abort called basr 0x%02x, sr 0x%02x\n", HOSTNO,
 		    NCR5380_read(BUS_AND_STATUS_REG),
@@ -2693,11 +2669,11 @@ int NCR5380_abort(struct scsi_cmnd *cmd)
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
@@ -2717,7 +2693,7 @@ int NCR5380_abort(struct scsi_cmnd *cmd)
 			SET_NEXT(tmp, NULL);
 			tmp->result = DID_ABORT << 16;
 			maybe_release_dma_irq(instance);
-			local_irq_restore(flags);
+			spin_unlock_irqrestore(&hostdata->lock, flags);
 			dprintk(NDEBUG_ABORT, "scsi%d: abort removed command from issue queue.\n",
 				    HOSTNO);
 			/* Tagged queuing note: no tag to free here, hasn't been assigned
@@ -2739,7 +2715,7 @@ int NCR5380_abort(struct scsi_cmnd *cmd)
 	 */
 
 	if (hostdata->connected) {
-		local_irq_restore(flags);
+		spin_unlock_irqrestore(&hostdata->lock, flags);
 		dprintk(NDEBUG_ABORT, "scsi%d: abort failed, command connected.\n", HOSTNO);
 		return FAILED;
 	}
@@ -2772,17 +2748,16 @@ int NCR5380_abort(struct scsi_cmnd *cmd)
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
@@ -2801,7 +2776,7 @@ int NCR5380_abort(struct scsi_cmnd *cmd)
 					hostdata->busy[cmd->device->id] &= ~(1 << cmd->device->lun);
 #endif
 					maybe_release_dma_irq(instance);
-					local_irq_restore(flags);
+					spin_unlock_irqrestore(&hostdata->lock, flags);
 					tmp->scsi_done(tmp);
 					return SUCCESS;
 				}
@@ -2814,7 +2789,7 @@ int NCR5380_abort(struct scsi_cmnd *cmd)
 	 * released after the abort, in case it is kept due to some bug.
 	 */
 	maybe_release_dma_irq(instance);
-	local_irq_restore(flags);
+	spin_unlock_irqrestore(&hostdata->lock, flags);
 
 	/*
 	 * Case 5 : If we reached this point, the command was not found in any of
@@ -2846,7 +2821,7 @@ static int NCR5380_bus_reset(struct scsi
 	int i;
 	unsigned long flags;
 
-	local_irq_save(flags);
+	spin_lock_irqsave(&hostdata->lock, flags);
 
 #if (NDEBUG & NDEBUG_ANY)
 	scmd_printk(KERN_INFO, cmd, "performing bus reset\n");
@@ -2886,7 +2861,7 @@ static int NCR5380_bus_reset(struct scsi
 #endif
 
 	maybe_release_dma_irq(instance);
-	local_irq_restore(flags);
+	spin_unlock_irqrestore(&hostdata->lock, flags);
 
 	return SUCCESS;
 }
Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2015-11-18 19:34:08.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2015-11-18 19:34:10.000000000 +1100
@@ -624,6 +624,7 @@ static int __maybe_unused NCR5380_show_i
 {
 	struct NCR5380_hostdata *hostdata;
 	struct scsi_cmnd *ptr;
+	unsigned long flags;
 
 	hostdata = (struct NCR5380_hostdata *) instance->hostdata;
 
@@ -631,7 +632,7 @@ static int __maybe_unused NCR5380_show_i
 	seq_printf(m, "Highwater I/O busy spin counts: write %d, read %d\n",
 	        hostdata->spin_max_w, hostdata->spin_max_r);
 #endif
-	spin_lock_irq(instance->host_lock);
+	spin_lock_irqsave(&hostdata->lock, flags);
 	if (!hostdata->connected)
 		seq_printf(m, "scsi%d: no currently connected command\n", instance->host_no);
 	else
@@ -643,7 +644,7 @@ static int __maybe_unused NCR5380_show_i
 	seq_printf(m, "scsi%d: disconnected_queue\n", instance->host_no);
 	for (ptr = (struct scsi_cmnd *) hostdata->disconnected_queue; ptr; ptr = (struct scsi_cmnd *) ptr->host_scribble)
 		lprint_Scsi_Cmnd(ptr, m);
-	spin_unlock_irq(instance->host_lock);
+	spin_unlock_irqrestore(&hostdata->lock, flags);
 	return 0;
 }
 
@@ -702,6 +703,7 @@ static int NCR5380_init(struct Scsi_Host
 #ifdef REAL_DMA
 	hostdata->dmalen = 0;
 #endif
+	spin_lock_init(&hostdata->lock);
 	hostdata->connected = NULL;
 	hostdata->issue_queue = NULL;
 	hostdata->disconnected_queue = NULL;
@@ -826,7 +828,7 @@ static int NCR5380_queue_command(struct
 	cmd->host_scribble = NULL;
 	cmd->result = 0;
 
-	spin_lock_irqsave(instance->host_lock, flags);
+	spin_lock_irqsave(&hostdata->lock, flags);
 
 	/* 
 	 * Insert the cmd into the issue queue. Note that REQUEST SENSE 
@@ -844,7 +846,7 @@ static int NCR5380_queue_command(struct
 		LIST(cmd, tmp);
 		tmp->host_scribble = (unsigned char *) cmd;
 	}
-	spin_unlock_irqrestore(instance->host_lock, flags);
+	spin_unlock_irqrestore(&hostdata->lock, flags);
 
 	dprintk(NDEBUG_QUEUES, "scsi%d : command added to %s of queue\n", instance->host_no, (cmd->cmnd[0] == REQUEST_SENSE) ? "head" : "tail");
 
@@ -873,10 +875,10 @@ static void NCR5380_main(struct work_str
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
@@ -926,11 +928,10 @@ static void NCR5380_main(struct work_str
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
@@ -942,8 +943,7 @@ static void NCR5380_main(struct work_str
 			done = 0;
 		}
 	} while (!done);
-	
-	spin_unlock_irq(instance->host_lock);
+	spin_unlock_irq(&hostdata->lock);
 }
 
 #ifndef DONT_USE_INTR
@@ -990,7 +990,7 @@ static irqreturn_t NCR5380_intr(int irq,
 	unsigned char basr;
 	unsigned long flags;
 
-	spin_lock_irqsave(instance->host_lock, flags);
+	spin_lock_irqsave(&hostdata->lock, flags);
 
 	basr = NCR5380_read(BUS_AND_STATUS_REG);
 	if (basr & BASR_IRQ) {
@@ -1054,7 +1054,7 @@ static irqreturn_t NCR5380_intr(int irq,
 		shost_printk(KERN_NOTICE, instance, "interrupt without IRQ bit\n");
 	}
 
-	spin_unlock_irqrestore(instance->host_lock, flags);
+	spin_unlock_irqrestore(&hostdata->lock, flags);
 
 	return IRQ_RETVAL(handled);
 }
@@ -1121,11 +1121,11 @@ static int NCR5380_select(struct Scsi_Ho
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
@@ -1136,6 +1136,7 @@ static int NCR5380_select(struct Scsi_Ho
 		             "select: arbitration timeout\n");
 		return -1;
 	}
+	spin_unlock_irq(&hostdata->lock);
 
 	/* The SCSI-2 arbitration delay is 2.4 us */
 	udelay(3);
@@ -1144,6 +1145,7 @@ static int NCR5380_select(struct Scsi_Ho
 	if ((NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_LOST) || (NCR5380_read(CURRENT_SCSI_DATA_REG) & hostdata->id_higher_mask) || (NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_LOST)) {
 		NCR5380_write(MODE_REG, MR_BASE);
 		dprintk(NDEBUG_ARBITRATION, "scsi%d : lost arbitration, deasserting MR_ARBITRATE\n", instance->host_no);
+		spin_lock_irq(&hostdata->lock);
 		return -1;
 	}
 
@@ -1162,6 +1164,7 @@ static int NCR5380_select(struct Scsi_Ho
 		NCR5380_write(MODE_REG, MR_BASE);
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 		dprintk(NDEBUG_ARBITRATION, "scsi%d : lost arbitration, deasserting ICR_ASSERT_SEL\n", instance->host_no);
+		spin_lock_irq(&hostdata->lock);
 		return -1;
 	}
 	/* 
@@ -1174,6 +1177,8 @@ static int NCR5380_select(struct Scsi_Ho
 	else
 		udelay(2);
 
+	spin_lock_irq(&hostdata->lock);
+
 	/* NCR5380_reselect() clears MODE_REG after a reselection interrupt */
 	if (!(NCR5380_read(MODE_REG) & MR_ARBITRATE))
 		return -1;
@@ -1202,6 +1207,8 @@ static int NCR5380_select(struct Scsi_Ho
 	 */
 	NCR5380_write(SELECT_ENABLE_REG, 0);
 
+	spin_unlock_irq(&hostdata->lock);
+
 	/*
 	 * The initiator shall then wait at least two deskew delays and release 
 	 * the BSY signal.
@@ -1241,6 +1248,7 @@ static int NCR5380_select(struct Scsi_Ho
 	                            msecs_to_jiffies(250));
 
 	if ((NCR5380_read(STATUS_REG) & (SR_SEL | SR_IO)) == (SR_SEL | SR_IO)) {
+		spin_lock_irq(&hostdata->lock);
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 		NCR5380_reselect(instance);
 		if (!hostdata->connected)
@@ -1250,6 +1258,7 @@ static int NCR5380_select(struct Scsi_Ho
 	}
 
 	if (err < 0) {
+		spin_lock_irq(&hostdata->lock);
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 		cmd->result = DID_BAD_TARGET << 16;
 		cmd->scsi_done(cmd);
@@ -1286,9 +1295,8 @@ static int NCR5380_select(struct Scsi_Ho
 
 	/* Wait for start of REQ/ACK handshake */
 
-	spin_unlock_irq(instance->host_lock);
 	err = NCR5380_poll_politely(instance, STATUS_REG, SR_REQ, SR_REQ, HZ);
-	spin_lock_irq(instance->host_lock);
+	spin_lock_irq(&hostdata->lock);
 	if (err < 0) {
 		shost_printk(KERN_ERR, instance, "select: REQ timeout\n");
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
@@ -1308,6 +1316,7 @@ static int NCR5380_select(struct Scsi_Ho
 	NCR5380_transfer_pio(instance, &phase, &len, &data);
 	dprintk(NDEBUG_SELECTION, "scsi%d : nexus established.\n", instance->host_no);
 	/* XXX need to handle errors here */
+
 	hostdata->connected = cmd;
 	hostdata->busy[cmd->device->id] |= (1 << (cmd->device->lun & 0xFF));
 
@@ -1811,9 +1820,9 @@ static void NCR5380_information_transfer
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
@@ -1889,8 +1898,12 @@ static void NCR5380_information_transfer
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
@@ -2022,6 +2035,9 @@ static void NCR5380_information_transfer
 					extended_msg[0] = EXTENDED_MESSAGE;
 					/* Accept first byte by clearing ACK */
 					NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
+
+					spin_unlock_irq(&hostdata->lock);
+
 					dprintk(NDEBUG_EXTENDED, "scsi%d : receiving extended message\n", instance->host_no);
 
 					len = 2;
@@ -2056,6 +2072,11 @@ static void NCR5380_information_transfer
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
@@ -2115,11 +2136,11 @@ static void NCR5380_information_transfer
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
@@ -2315,10 +2336,12 @@ static int NCR5380_abort(struct scsi_cmn
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
@@ -2365,7 +2388,7 @@ static int NCR5380_abort(struct scsi_cmn
 			REMOVE(5, *prev, tmp, tmp->host_scribble);
 			(*prev) = (struct scsi_cmnd *) tmp->host_scribble;
 			tmp->host_scribble = NULL;
-			spin_unlock_irq(instance->host_lock);
+			spin_unlock_irqrestore(&hostdata->lock, flags);
 			tmp->result = DID_ABORT << 16;
 			dprintk(NDEBUG_ABORT, "scsi%d : abort removed command from issue queue.\n", instance->host_no);
 			tmp->scsi_done(tmp);
@@ -2389,7 +2412,7 @@ static int NCR5380_abort(struct scsi_cmn
  */
 
 	if (hostdata->connected) {
-		spin_unlock_irq(instance->host_lock);
+		spin_unlock_irqrestore(&hostdata->lock, flags);
 		dprintk(NDEBUG_ABORT, "scsi%d : abort failed, command connected.\n", instance->host_no);
 		return FAILED;
 	}
@@ -2423,7 +2446,7 @@ static int NCR5380_abort(struct scsi_cmn
 			dprintk(NDEBUG_ABORT, "scsi%d : aborting disconnected command.\n", instance->host_no);
 
 			if (NCR5380_select(instance, cmd)) {
-				spin_unlock_irq(instance->host_lock);
+				spin_unlock_irq(&hostdata->lock);
 				return FAILED;
 			}
 			dprintk(NDEBUG_ABORT, "scsi%d : nexus reestablished.\n", instance->host_no);
@@ -2435,7 +2458,7 @@ static int NCR5380_abort(struct scsi_cmn
 					REMOVE(5, *prev, tmp, tmp->host_scribble);
 					*prev = (struct scsi_cmnd *) tmp->host_scribble;
 					tmp->host_scribble = NULL;
-					spin_unlock_irq(instance->host_lock);
+					spin_unlock_irqrestore(&hostdata->lock, flags);
 					tmp->result = DID_ABORT << 16;
 					tmp->scsi_done(tmp);
 					return SUCCESS;
@@ -2450,7 +2473,7 @@ static int NCR5380_abort(struct scsi_cmn
  * so we won't panic, but we will notify the user in case something really
  * broke.
  */
-	spin_unlock_irq(instance->host_lock);
+	spin_unlock_irqrestore(&hostdata->lock, flags);
 	printk(KERN_WARNING "scsi%d : warning : SCSI command probably completed successfully\n"
 			"         before abortion\n", instance->host_no);
 	return FAILED;
@@ -2467,8 +2490,10 @@ static int NCR5380_abort(struct scsi_cmn
 static int NCR5380_bus_reset(struct scsi_cmnd *cmd)
 {
 	struct Scsi_Host *instance = cmd->device->host;
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
+	unsigned long flags;
 
-	spin_lock_irq(instance->host_lock);
+	spin_lock_irqsave(&hostdata->lock, flags);
 
 #if (NDEBUG & NDEBUG_ANY)
 	scmd_printk(KERN_INFO, cmd, "performing bus reset\n");
@@ -2477,7 +2502,7 @@ static int NCR5380_bus_reset(struct scsi
 
 	do_reset(instance);
 
-	spin_unlock_irq(instance->host_lock);
+	spin_unlock_irqrestore(&hostdata->lock, flags);
 
 	return SUCCESS;
 }
