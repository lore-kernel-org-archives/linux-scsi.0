From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v2 03/22] ncr5380: Remove REAL_DMA and REAL_DMA_POLL macros
Date: Wed, 16 Mar 2016 14:18:44 +1100
Message-ID: <20160316031842.671706393@telegraphics.com.au>
References: <20160316031841.911913894@telegraphics.com.au>
Return-path: <linux-m68k-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-remove-REAL_DMA-macro
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>
List-Id: linux-scsi@vger.kernel.org

For the NCR5380.c core driver, these macros are never used.
If REAL_DMA were to be defined, compilation would fail.

For the atari_NCR5380.c core driver, REAL_DMA is always defined.

Hence these macros are pointless.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>

---
 drivers/scsi/NCR5380.c       |  218 +------------------------------------------
 drivers/scsi/NCR5380.h       |  112 ----------------------
 drivers/scsi/atari_NCR5380.c |   62 +-----------
 drivers/scsi/atari_scsi.c    |   32 ------
 drivers/scsi/sun3_scsi.c     |   13 --
 5 files changed, 22 insertions(+), 415 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2016-03-16 14:18:03.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2016-03-16 14:18:05.000000000 +1100
@@ -35,18 +35,10 @@
  * code so that everything does the same thing that's done at the
  * end of a pseudo-DMA read operation.
  *
- * 2.  Fix REAL_DMA (interrupt driven, polled works fine) -
- * basically, transfer size needs to be reduced by one
- * and the last byte read as is done with PSEUDO_DMA.
- *
  * 4.  Test SCSI-II tagged queueing (I have no devices which support
  * tagged queueing)
  */
 
-#ifndef notyet
-#undef REAL_DMA
-#endif
-
 #ifdef BOARD_REQUIRES_NO_DELAY
 #define io_recovery_delay(x)
 #else
@@ -131,12 +123,6 @@
  *
  * PSEUDO_DMA - if defined, PSEUDO DMA is used during the data transfer phases.
  *
- * REAL_DMA - if defined, REAL DMA is used during the data transfer phases.
- *
- * REAL_DMA_POLL - if defined, REAL DMA is used but the driver doesn't
- * rely on phase mismatch and EOP interrupts to determine end
- * of phase.
- *
  * These macros MUST be defined :
  *
  * NCR5380_read(register)  - read from the specified register
@@ -147,15 +133,9 @@
  * specific implementation of the NCR5380
  *
  * Either real DMA *or* pseudo DMA may be implemented
- * REAL functions :
- * NCR5380_REAL_DMA should be defined if real DMA is to be used.
  * Note that the DMA setup functions should return the number of bytes
  * that they were able to program the controller for.
  *
- * Also note that generic i386/PC versions of these macros are
- * available as NCR5380_i386_dma_write_setup,
- * NCR5380_i386_dma_read_setup, and NCR5380_i386_dma_residual.
- *
  * NCR5380_dma_write_setup(instance, src, count) - initialize
  * NCR5380_dma_read_setup(instance, dst, count) - initialize
  * NCR5380_dma_residual(instance); - residual count
@@ -486,12 +466,6 @@ static void prepare_info(struct Scsi_Hos
 #ifdef DIFFERENTIAL
 	         "DIFFERENTIAL "
 #endif
-#ifdef REAL_DMA
-	         "REAL_DMA "
-#endif
-#ifdef REAL_DMA_POLL
-	         "REAL_DMA_POLL "
-#endif
 #ifdef PARITY
 	         "PARITY "
 #endif
@@ -551,9 +525,8 @@ static int NCR5380_init(struct Scsi_Host
 			hostdata->id_higher_mask |= i;
 	for (i = 0; i < 8; ++i)
 		hostdata->busy[i] = 0;
-#ifdef REAL_DMA
-	hostdata->dmalen = 0;
-#endif
+	hostdata->dma_len = 0;
+
 	spin_lock_init(&hostdata->lock);
 	hostdata->connected = NULL;
 	hostdata->sensing = NULL;
@@ -850,11 +823,7 @@ static void NCR5380_main(struct work_str
 				requeue_cmd(instance, cmd);
 			}
 		}
-		if (hostdata->connected
-#ifdef REAL_DMA
-		    && !hostdata->dmalen
-#endif
-		    ) {
+		if (hostdata->connected && !hostdata->dma_len) {
 			dsprintk(NDEBUG_MAIN, instance, "main: performing information transfer\n");
 			NCR5380_information_transfer(instance);
 			done = 0;
@@ -919,34 +888,6 @@ static irqreturn_t NCR5380_intr(int irq,
 		dsprintk(NDEBUG_INTR, instance, "IRQ %d, BASR 0x%02x, SR 0x%02x, MR 0x%02x\n",
 		         irq, basr, sr, mr);
 
-#if defined(REAL_DMA)
-		if ((mr & MR_DMA_MODE) || (mr & MR_MONITOR_BSY)) {
-			/* Probably End of DMA, Phase Mismatch or Loss of BSY.
-			 * We ack IRQ after clearing Mode Register. Workarounds
-			 * for End of DMA errata need to happen in DMA Mode.
-			 */
-
-			dsprintk(NDEBUG_INTR, instance, "interrupt in DMA mode\n");
-
-			int transferred;
-
-			if (!hostdata->connected)
-				panic("scsi%d : DMA interrupt with no connected cmd\n",
-				      instance->hostno);
-
-			transferred = hostdata->dmalen - NCR5380_dma_residual(instance);
-			hostdata->connected->SCp.this_residual -= transferred;
-			hostdata->connected->SCp.ptr += transferred;
-			hostdata->dmalen = 0;
-
-			/* FIXME: we need to poll briefly then defer a workqueue task ! */
-			NCR5380_poll_politely(hostdata, BUS_AND_STATUS_REG, BASR_ACK, 0, 2 * HZ);
-
-			NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-			NCR5380_write(MODE_REG, MR_BASE);
-			NCR5380_read(RESET_PARITY_INTERRUPT_REG);
-		} else
-#endif /* REAL_DMA */
 		if ((NCR5380_read(CURRENT_SCSI_DATA_REG) & hostdata->id_mask) &&
 		    (sr & (SR_SEL | SR_IO | SR_BSY | SR_RST)) == (SR_SEL | SR_IO)) {
 			/* Probably reselected */
@@ -1495,7 +1436,7 @@ timeout:
 	return -1;
 }
 
-#if defined(REAL_DMA) || defined(PSEUDO_DMA) || defined (REAL_DMA_POLL)
+#if defined(PSEUDO_DMA)
 /*
  * Function : int NCR5380_transfer_dma (struct Scsi_Host *instance,
  * unsigned char *phase, int *count, unsigned char **data)
@@ -1525,34 +1466,14 @@ static int NCR5380_transfer_dma(struct S
 	register unsigned char *d = *data;
 	unsigned char tmp;
 	int foo;
-#if defined(REAL_DMA_POLL)
-	int cnt, toPIO;
-	unsigned char saved_data = 0, overrun = 0, residue;
-#endif
 
 	if ((tmp = (NCR5380_read(STATUS_REG) & PHASE_MASK)) != p) {
 		*phase = tmp;
 		return -1;
 	}
-#if defined(REAL_DMA) || defined(REAL_DMA_POLL)
-	if (p & SR_IO) {
-		if (!(hostdata->flags & FLAG_NO_DMA_FIXUPS))
-			c -= 2;
-	}
-	hostdata->dma_len = (p & SR_IO) ? NCR5380_dma_read_setup(instance, d, c) : NCR5380_dma_write_setup(instance, d, c);
-
-	dsprintk(NDEBUG_DMA, instance, "initializing DMA %s: length %d, address %p\n",
-	         (p & SR_IO) ? "receive" : "send", c, *data);
-#endif
 
 	NCR5380_write(TARGET_COMMAND_REG, PHASE_SR_TO_TCR(p));
 
-#ifdef REAL_DMA
-	NCR5380_write(MODE_REG, MR_BASE | MR_DMA_MODE | MR_MONITOR_BSY |
-	                        MR_ENABLE_EOP_INTR);
-#elif defined(REAL_DMA_POLL)
-	NCR5380_write(MODE_REG, MR_BASE | MR_DMA_MODE | MR_MONITOR_BSY);
-#else
 	/*
 	 * Note : on my sample board, watch-dog timeouts occurred when interrupts
 	 * were not disabled for the duration of a single DMA transfer, from
@@ -1564,7 +1485,6 @@ static int NCR5380_transfer_dma(struct S
 		                        MR_ENABLE_EOP_INTR);
 	else
 		NCR5380_write(MODE_REG, MR_BASE | MR_DMA_MODE | MR_MONITOR_BSY);
-#endif				/* def REAL_DMA */
 
 	dprintk(NDEBUG_DMA, "scsi%d : mode reg = 0x%X\n", instance->host_no, NCR5380_read(MODE_REG));
 
@@ -1584,14 +1504,8 @@ static int NCR5380_transfer_dma(struct S
 		io_recovery_delay(1);
 	}
 
-#if defined(REAL_DMA_POLL)
-	do {
-		tmp = NCR5380_read(BUS_AND_STATUS_REG);
-	} while ((tmp & BASR_PHASE_MATCH) && !(tmp & (BASR_BUSY_ERROR | BASR_END_DMA_TRANSFER)));
-
 /*
- * At this point, either we've completed DMA, or we have a phase mismatch,
- * or we've unexpectedly lost BUSY (which is a real error).
+ * A note regarding the DMA errata workarounds for early NMOS silicon.
  *
  * For DMA sends, we want to wait until the last byte has been
  * transferred out over the bus before we turn off DMA mode.  Alas, there
@@ -1618,79 +1532,18 @@ static int NCR5380_transfer_dma(struct S
  * properly, or the target switches to MESSAGE IN phase to signal a
  * disconnection (either operation bringing the DMA to a clean halt).
  * However, in order to handle scatter-receive, we must work around the
- * problem.  The chosen fix is to DMA N-2 bytes, then check for the
+ * problem.  The chosen fix is to DMA fewer bytes, then check for the
  * condition before taking the NCR5380 out of DMA mode.  One or two extra
  * bytes are transferred via PIO as necessary to fill out the original
  * request.
  */
 
 	if (p & SR_IO) {
-		if (!(hostdata->flags & FLAG_NO_DMA_FIXUPS)) {
-			udelay(10);
-			if ((NCR5380_read(BUS_AND_STATUS_REG) & (BASR_PHASE_MATCH | BASR_ACK)) ==
-			    (BASR_PHASE_MATCH | BASR_ACK)) {
-				saved_data = NCR5380_read(INPUT_DATA_REGISTER);
-				overrun = 1;
-			}
-		}
-	} else {
-		int limit = 100;
-		while (((tmp = NCR5380_read(BUS_AND_STATUS_REG)) & BASR_ACK) || (NCR5380_read(STATUS_REG) & SR_REQ)) {
-			if (!(tmp & BASR_PHASE_MATCH))
-				break;
-			if (--limit < 0)
-				break;
-		}
-	}
-
-	dsprintk(NDEBUG_DMA, "polled DMA transfer complete, basr 0x%02x, sr 0x%02x\n",
-	         tmp, NCR5380_read(STATUS_REG));
-
-	NCR5380_write(MODE_REG, MR_BASE);
-	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-
-	residue = NCR5380_dma_residual(instance);
-	c -= residue;
-	*count -= c;
-	*data += c;
-	*phase = NCR5380_read(STATUS_REG) & PHASE_MASK;
-
-	if (!(hostdata->flags & FLAG_NO_DMA_FIXUPS) &&
-	    *phase == p && (p & SR_IO) && residue == 0) {
-		if (overrun) {
-			dprintk(NDEBUG_DMA, "Got an input overrun, using saved byte\n");
-			**data = saved_data;
-			*data += 1;
-			*count -= 1;
-			cnt = toPIO = 1;
-		} else {
-			printk("No overrun??\n");
-			cnt = toPIO = 2;
-		}
-		dprintk(NDEBUG_DMA, "Doing %d-byte PIO to 0x%X\n", cnt, *data);
-		NCR5380_transfer_pio(instance, phase, &cnt, data);
-		*count -= toPIO - cnt;
-	}
-
-	dprintk(NDEBUG_DMA, "Return with data ptr = 0x%X, count %d, last 0x%X, next 0x%X\n", *data, *count, *(*data + *count - 1), *(*data + *count));
-	return 0;
-
-#elif defined(REAL_DMA)
-	return 0;
-#else				/* defined(REAL_DMA_POLL) */
-	if (p & SR_IO) {
 		foo = NCR5380_pread(instance, d,
 			hostdata->flags & FLAG_NO_DMA_FIXUP ? c : c - 1);
 		if (!foo && !(hostdata->flags & FLAG_NO_DMA_FIXUP)) {
 			/*
-			 * We can't disable DMA mode after successfully transferring
-			 * what we plan to be the last byte, since that would open up
-			 * a race condition where if the target asserted REQ before
-			 * we got the DMA mode reset, the NCR5380 would have latched
-			 * an additional byte into the INPUT DATA register and we'd
-			 * have dropped it.
-			 *
-			 * The workaround was to transfer one fewer bytes than we
+			 * The workaround was to transfer fewer bytes than we
 			 * intended to with the pseudo-DMA read function, wait for
 			 * the chip to latch the last byte, read it, and then disable
 			 * pseudo-DMA mode.
@@ -1738,9 +1591,8 @@ static int NCR5380_transfer_dma(struct S
 	*count = 0;
 	*phase = NCR5380_read(STATUS_REG) & PHASE_MASK;
 	return foo;
-#endif				/* def REAL_DMA */
 }
-#endif				/* defined(REAL_DMA) | defined(PSEUDO_DMA) */
+#endif /* PSEUDO_DMA */
 
 /*
  * Function : NCR5380_information_transfer (struct Scsi_Host *instance)
@@ -1831,7 +1683,7 @@ static void NCR5380_information_transfer
 				 * in an unconditional loop.
 				 */
 
-#if defined(PSEUDO_DMA) || defined(REAL_DMA_POLL)
+#if defined(PSEUDO_DMA)
 				transfersize = 0;
 				if (!cmd->device->borken)
 					transfersize = NCR5380_dma_xfer_len(instance, cmd, phase);
@@ -1855,7 +1707,7 @@ static void NCR5380_information_transfer
 					} else
 						cmd->SCp.this_residual -= transfersize - len;
 				} else
-#endif				/* defined(PSEUDO_DMA) || defined(REAL_DMA_POLL) */
+#endif /* PSEUDO_DMA */
 				{
 					/* Break up transfer into 3 ms chunks,
 					 * presuming 6 accesses per handshake.
@@ -2202,52 +2054,6 @@ static void NCR5380_reselect(struct Scsi
 	         scmd_id(tmp), tmp->device->lun, tmp->tag);
 }
 
-/*
- * Function : void NCR5380_dma_complete (struct Scsi_Host *instance)
- *
- * Purpose : called by interrupt handler when DMA finishes or a phase
- * mismatch occurs (which would finish the DMA transfer).
- *
- * Inputs : instance - this instance of the NCR5380.
- *
- * Returns : pointer to the scsi_cmnd structure for which the I_T_L
- * nexus has been reestablished, on failure NULL is returned.
- */
-
-#ifdef REAL_DMA
-static void NCR5380_dma_complete(NCR5380_instance * instance) {
-	struct NCR5380_hostdata *hostdata = shost_priv(instance);
-	int transferred;
-
-	/*
-	 * XXX this might not be right.
-	 *
-	 * Wait for final byte to transfer, ie wait for ACK to go false.
-	 *
-	 * We should use the Last Byte Sent bit, unfortunately this is
-	 * not available on the 5380/5381 (only the various CMOS chips)
-	 *
-	 * FIXME: timeout, and need to handle long timeout/irq case
-	 */
-
-	NCR5380_poll_politely(instance, BUS_AND_STATUS_REG, BASR_ACK, 0, 5*HZ);
-
-	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-
-	/*
-	 * The only places we should see a phase mismatch and have to send
-	 * data from the same set of pointers will be the data transfer
-	 * phases.  So, residual, requested length are only important here.
-	 */
-
-	if (!(hostdata->connected->SCp.phase & SR_CD)) {
-		transferred = instance->dmalen - NCR5380_dma_residual();
-		hostdata->connected->SCp.this_residual -= transferred;
-		hostdata->connected->SCp.ptr += transferred;
-	}
-}
-#endif				/* def REAL_DMA */
-
 /**
  * list_find_cmd - test for presence of a command in a linked list
  * @haystack: list of commands
@@ -2359,9 +2165,7 @@ static int NCR5380_abort(struct scsi_cmn
 	if (hostdata->connected == cmd) {
 		dsprintk(NDEBUG_ABORT, instance, "abort: cmd %p is connected\n", cmd);
 		hostdata->connected = NULL;
-#ifdef REAL_DMA
 		hostdata->dma_len = 0;
-#endif
 		if (do_abort(instance)) {
 			set_host_byte(cmd, DID_ERROR);
 			complete_cmd(instance, cmd);
@@ -2464,9 +2268,7 @@ static int NCR5380_bus_reset(struct scsi
 
 	for (i = 0; i < 8; ++i)
 		hostdata->busy[i] = 0;
-#ifdef REAL_DMA
 	hostdata->dma_len = 0;
-#endif
 
 	queue_work(hostdata->work_q, &hostdata->main_task);
 	spin_unlock_irqrestore(&hostdata->lock, flags);
Index: linux/drivers/scsi/NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/NCR5380.h	2016-03-16 14:16:56.000000000 +1100
+++ linux/drivers/scsi/NCR5380.h	2016-03-16 14:18:05.000000000 +1100
@@ -239,9 +239,7 @@ struct NCR5380_hostdata {
 	struct Scsi_Host *host;			/* Host backpointer */
 	unsigned char id_mask, id_higher_mask;	/* 1 << id, all bits greater */
 	unsigned char busy[8];			/* index = target, bit = lun */
-#if defined(REAL_DMA) || defined(REAL_DMA_POLL)
 	int dma_len;				/* requested length of DMA */
-#endif
 	unsigned char last_message;		/* last message OUT */
 	struct scsi_cmnd *connected;		/* currently connected cmnd */
 	struct scsi_cmnd *selecting;		/* cmnd to be connected */
@@ -319,118 +317,8 @@ static void NCR5380_main(struct work_str
 static const char *NCR5380_info(struct Scsi_Host *instance);
 static void NCR5380_reselect(struct Scsi_Host *instance);
 static struct scsi_cmnd *NCR5380_select(struct Scsi_Host *, struct scsi_cmnd *);
-#if defined(PSEUDO_DMA) || defined(REAL_DMA) || defined(REAL_DMA_POLL)
 static int NCR5380_transfer_dma(struct Scsi_Host *instance, unsigned char *phase, int *count, unsigned char **data);
-#endif
 static int NCR5380_transfer_pio(struct Scsi_Host *instance, unsigned char *phase, int *count, unsigned char **data);
 
-#if (defined(REAL_DMA) || defined(REAL_DMA_POLL))
-
-#if defined(i386) || defined(__alpha__)
-
-/**
- *	NCR5380_pc_dma_setup		-	setup ISA DMA
- *	@instance: adapter to set up
- *	@ptr: block to transfer (virtual address)
- *	@count: number of bytes to transfer
- *	@mode: DMA controller mode to use
- *
- *	Program the DMA controller ready to perform an ISA DMA transfer
- *	on this chip.
- *
- *	Locks: takes and releases the ISA DMA lock.
- */
- 
-static __inline__ int NCR5380_pc_dma_setup(struct Scsi_Host *instance, unsigned char *ptr, unsigned int count, unsigned char mode)
-{
-	unsigned limit;
-	unsigned long bus_addr = virt_to_bus(ptr);
-	unsigned long flags;
-
-	if (instance->dma_channel <= 3) {
-		if (count > 65536)
-			count = 65536;
-		limit = 65536 - (bus_addr & 0xFFFF);
-	} else {
-		if (count > 65536 * 2)
-			count = 65536 * 2;
-		limit = 65536 * 2 - (bus_addr & 0x1FFFF);
-	}
-
-	if (count > limit)
-		count = limit;
-
-	if ((count & 1) || (bus_addr & 1))
-		panic("scsi%d : attempted unaligned DMA transfer\n", instance->host_no);
-	
-	flags=claim_dma_lock();
-	disable_dma(instance->dma_channel);
-	clear_dma_ff(instance->dma_channel);
-	set_dma_addr(instance->dma_channel, bus_addr);
-	set_dma_count(instance->dma_channel, count);
-	set_dma_mode(instance->dma_channel, mode);
-	enable_dma(instance->dma_channel);
-	release_dma_lock(flags);
-	
-	return count;
-}
-
-/**
- *	NCR5380_pc_dma_write_setup		-	setup ISA DMA write
- *	@instance: adapter to set up
- *	@ptr: block to transfer (virtual address)
- *	@count: number of bytes to transfer
- *
- *	Program the DMA controller ready to perform an ISA DMA write to the
- *	SCSI controller.
- *
- *	Locks: called routines take and release the ISA DMA lock.
- */
-
-static __inline__ int NCR5380_pc_dma_write_setup(struct Scsi_Host *instance, unsigned char *src, unsigned int count)
-{
-	return NCR5380_pc_dma_setup(instance, src, count, DMA_MODE_WRITE);
-}
-
-/**
- *	NCR5380_pc_dma_read_setup		-	setup ISA DMA read
- *	@instance: adapter to set up
- *	@ptr: block to transfer (virtual address)
- *	@count: number of bytes to transfer
- *
- *	Program the DMA controller ready to perform an ISA DMA read from the
- *	SCSI controller.
- *
- *	Locks: called routines take and release the ISA DMA lock.
- */
-
-static __inline__ int NCR5380_pc_dma_read_setup(struct Scsi_Host *instance, unsigned char *src, unsigned int count)
-{
-	return NCR5380_pc_dma_setup(instance, src, count, DMA_MODE_READ);
-}
-
-/**
- *	NCR5380_pc_dma_residual		-	return bytes left 
- *	@instance: adapter
- *
- *	Reports the number of bytes left over after the DMA was terminated.
- *
- *	Locks: takes and releases the ISA DMA lock.
- */
-
-static __inline__ int NCR5380_pc_dma_residual(struct Scsi_Host *instance)
-{
-	unsigned long flags;
-	int tmp;
-
-	flags = claim_dma_lock();
-	clear_dma_ff(instance->dma_channel);
-	tmp = get_dma_residue(instance->dma_channel);
-	release_dma_lock(flags);
-	
-	return tmp;
-}
-#endif				/* defined(i386) || defined(__alpha__) */
-#endif				/* defined(REAL_DMA)  */
 #endif				/* __KERNEL__ */
 #endif				/* NCR5380_H */
Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2016-03-16 14:18:01.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2016-03-16 14:18:05.000000000 +1100
@@ -112,15 +112,9 @@
  * specific implementation of the NCR5380
  *
  * Either real DMA *or* pseudo DMA may be implemented
- * REAL functions :
- * NCR5380_REAL_DMA should be defined if real DMA is to be used.
  * Note that the DMA setup functions should return the number of bytes
  * that they were able to program the controller for.
  *
- * Also note that generic i386/PC versions of these macros are
- * available as NCR5380_i386_dma_write_setup,
- * NCR5380_i386_dma_read_setup, and NCR5380_i386_dma_residual.
- *
  * NCR5380_dma_write_setup(instance, src, count) - initialize
  * NCR5380_dma_read_setup(instance, dst, count) - initialize
  * NCR5380_dma_residual(instance); - residual count
@@ -586,9 +580,6 @@ static void prepare_info(struct Scsi_Hos
 #ifdef DIFFERENTIAL
 	         "DIFFERENTIAL "
 #endif
-#ifdef REAL_DMA
-	         "REAL_DMA "
-#endif
 #ifdef PARITY
 	         "PARITY "
 #endif
@@ -629,9 +620,8 @@ static int __init NCR5380_init(struct Sc
 #ifdef SUPPORT_TAGS
 	init_tags(hostdata);
 #endif
-#if defined (REAL_DMA)
 	hostdata->dma_len = 0;
-#endif
+
 	spin_lock_init(&hostdata->lock);
 	hostdata->connected = NULL;
 	hostdata->sensing = NULL;
@@ -974,11 +964,7 @@ static void NCR5380_main(struct work_str
 #endif
 			}
 		}
-		if (hostdata->connected
-#ifdef REAL_DMA
-		    && !hostdata->dma_len
-#endif
-		    ) {
+		if (hostdata->connected && !hostdata->dma_len) {
 			dsprintk(NDEBUG_MAIN, instance, "main: performing information transfer\n");
 			NCR5380_information_transfer(instance);
 			done = 0;
@@ -990,7 +976,6 @@ static void NCR5380_main(struct work_str
 }
 
 
-#ifdef REAL_DMA
 /*
  * Function : void NCR5380_dma_complete (struct Scsi_Host *instance)
  *
@@ -1071,7 +1056,6 @@ static void NCR5380_dma_complete(struct
 		}
 	}
 }
-#endif /* REAL_DMA */
 
 
 /**
@@ -1126,7 +1110,6 @@ static irqreturn_t NCR5380_intr(int irq,
 		dsprintk(NDEBUG_INTR, instance, "IRQ %d, BASR 0x%02x, SR 0x%02x, MR 0x%02x\n",
 		         irq, basr, sr, mr);
 
-#if defined(REAL_DMA)
 		if ((mr & MR_DMA_MODE) || (mr & MR_MONITOR_BSY)) {
 			/* Probably End of DMA, Phase Mismatch or Loss of BSY.
 			 * We ack IRQ after clearing Mode Register. Workarounds
@@ -1142,9 +1125,7 @@ static irqreturn_t NCR5380_intr(int irq,
 				NCR5380_write(MODE_REG, MR_BASE);
 				NCR5380_read(RESET_PARITY_INTERRUPT_REG);
 			}
-		} else
-#endif /* REAL_DMA */
-		if ((NCR5380_read(CURRENT_SCSI_DATA_REG) & hostdata->id_mask) &&
+		} else if ((NCR5380_read(CURRENT_SCSI_DATA_REG) & hostdata->id_mask) &&
 		    (sr & (SR_SEL | SR_IO | SR_BSY | SR_RST)) == (SR_SEL | SR_IO)) {
 			/* Probably reselected */
 			NCR5380_write(SELECT_ENABLE_REG, 0);
@@ -1710,7 +1691,7 @@ timeout:
 	return -1;
 }
 
-#if defined(REAL_DMA)
+
 /*
  * Function : int NCR5380_transfer_dma (struct Scsi_Host *instance,
  * unsigned char *phase, int *count, unsigned char **data)
@@ -1819,7 +1800,6 @@ static int NCR5380_transfer_dma(struct S
 
 	return 0;
 }
-#endif /* defined(REAL_DMA) */
 
 /*
  * Function : NCR5380_information_transfer (struct Scsi_Host *instance)
@@ -1866,7 +1846,6 @@ static void NCR5380_information_transfer
 			}
 #if defined(CONFIG_SUN3)
 			if (phase == PHASE_CMDOUT) {
-#if defined(REAL_DMA)
 				void *d;
 				unsigned long count;
 
@@ -1885,7 +1864,6 @@ static void NCR5380_information_transfer
 						sun3_dma_setup_done = cmd;
 					}
 				}
-#endif
 #ifdef SUN3_SCSI_VME
 				dregs->csr |= CSR_INTR;
 #endif
@@ -1943,12 +1921,6 @@ static void NCR5380_information_transfer
 				 * in an unconditional loop.
 				 */
 
-				/* ++roman: I suggest, this should be
-				 * #if def(REAL_DMA)
-				 * instead of leaving REAL_DMA out.
-				 */
-
-#if defined(REAL_DMA)
 #if !defined(CONFIG_SUN3)
 				transfersize = 0;
 				if (!cmd->device->borken)
@@ -1972,21 +1944,9 @@ static void NCR5380_information_transfer
 						do_abort(instance);
 						cmd->result = DID_ERROR << 16;
 						/* XXX - need to source or sink data here, as appropriate */
-					} else {
-#ifdef REAL_DMA
-						/* ++roman: When using real DMA,
-						 * information_transfer() should return after
-						 * starting DMA since it has nothing more to
-						 * do.
-						 */
+					} else
 						return;
-#else
-						cmd->SCp.this_residual -= transfersize - len;
-#endif
-					}
-				} else
-#endif /* defined(REAL_DMA) */
-				{
+				} else {
 					/* Break up transfer into 3 ms chunks,
 					 * presuming 6 accesses per handshake.
 					 */
@@ -1997,7 +1957,7 @@ static void NCR5380_information_transfer
 					                     (unsigned char **)&cmd->SCp.ptr);
 					cmd->SCp.this_residual -= transfersize - len;
 				}
-#if defined(CONFIG_SUN3) && defined(REAL_DMA)
+#if defined(CONFIG_SUN3)
 				/* if we had intended to dma that command clear it */
 				if (sun3_dma_setup_done == cmd)
 					sun3_dma_setup_done = NULL;
@@ -2305,7 +2265,7 @@ static void NCR5380_reselect(struct Scsi
 		return;
 	}
 
-#if defined(CONFIG_SUN3) && defined(REAL_DMA)
+#if defined(CONFIG_SUN3)
 	/* acknowledge toggle to MSGIN */
 	NCR5380_write(TARGET_COMMAND_REG, PHASE_SR_TO_TCR(PHASE_MSGIN));
 
@@ -2392,7 +2352,7 @@ static void NCR5380_reselect(struct Scsi
 		return;
 	}
 
-#if defined(CONFIG_SUN3) && defined(REAL_DMA)
+#if defined(CONFIG_SUN3)
 	/* engage dma setup for the command we just saw */
 	{
 		void *d;
@@ -2555,9 +2515,7 @@ static int NCR5380_abort(struct scsi_cmn
 	if (hostdata->connected == cmd) {
 		dsprintk(NDEBUG_ABORT, instance, "abort: cmd %p is connected\n", cmd);
 		hostdata->connected = NULL;
-#ifdef REAL_DMA
 		hostdata->dma_len = 0;
-#endif
 		if (do_abort(instance)) {
 			set_host_byte(cmd, DID_ERROR);
 			complete_cmd(instance, cmd);
@@ -2664,9 +2622,7 @@ static int NCR5380_bus_reset(struct scsi
 #endif
 	for (i = 0; i < 8; ++i)
 		hostdata->busy[i] = 0;
-#ifdef REAL_DMA
 	hostdata->dma_len = 0;
-#endif
 
 	queue_work(hostdata->work_q, &hostdata->main_task);
 	maybe_release_dma_irq(instance);
Index: linux/drivers/scsi/atari_scsi.c
===================================================================
--- linux.orig/drivers/scsi/atari_scsi.c	2016-03-16 14:16:56.000000000 +1100
+++ linux/drivers/scsi/atari_scsi.c	2016-03-16 14:18:05.000000000 +1100
@@ -85,7 +85,6 @@
 
 /* Definitions for the core NCR5380 driver. */
 
-#define REAL_DMA
 #define SUPPORT_TAGS
 #define MAX_TAGS                        32
 #define DMA_MIN_SIZE                    32
@@ -159,14 +158,11 @@ static inline unsigned long SCSI_DMA_GET
 	return adr;
 }
 
-#ifdef REAL_DMA
 static void atari_scsi_fetch_restbytes(void);
-#endif
 
 static unsigned char (*atari_scsi_reg_read)(unsigned char reg);
 static void (*atari_scsi_reg_write)(unsigned char reg, unsigned char value);
 
-#ifdef REAL_DMA
 static unsigned long	atari_dma_residual, atari_dma_startaddr;
 static short		atari_dma_active;
 /* pointer to the dribble buffer */
@@ -185,7 +181,6 @@ static char		*atari_dma_orig_addr;
 /* mask for address bits that can't be used with the ST-DMA */
 static unsigned long	atari_dma_stram_mask;
 #define STRAM_ADDR(a)	(((a) & atari_dma_stram_mask) == 0)
-#endif
 
 static int setup_can_queue = -1;
 module_param(setup_can_queue, int, 0);
@@ -201,8 +196,6 @@ static int setup_toshiba_delay = -1;
 module_param(setup_toshiba_delay, int, 0);
 
 
-#if defined(REAL_DMA)
-
 static int scsi_dma_is_ignored_buserr(unsigned char dma_stat)
 {
 	int i;
@@ -255,12 +248,9 @@ static void scsi_dma_buserr(int irq, voi
 }
 #endif
 
-#endif
-
 
 static irqreturn_t scsi_tt_intr(int irq, void *dev)
 {
-#ifdef REAL_DMA
 	struct Scsi_Host *instance = dev;
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	int dma_stat;
@@ -342,8 +332,6 @@ static irqreturn_t scsi_tt_intr(int irq,
 		tt_scsi_dma.dma_ctrl = 0;
 	}
 
-#endif /* REAL_DMA */
-
 	NCR5380_intr(irq, dev);
 
 	return IRQ_HANDLED;
@@ -352,7 +340,6 @@ static irqreturn_t scsi_tt_intr(int irq,
 
 static irqreturn_t scsi_falcon_intr(int irq, void *dev)
 {
-#ifdef REAL_DMA
 	struct Scsi_Host *instance = dev;
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	int dma_stat;
@@ -405,15 +392,12 @@ static irqreturn_t scsi_falcon_intr(int
 		atari_dma_orig_addr = NULL;
 	}
 
-#endif /* REAL_DMA */
-
 	NCR5380_intr(irq, dev);
 
 	return IRQ_HANDLED;
 }
 
 
-#ifdef REAL_DMA
 static void atari_scsi_fetch_restbytes(void)
 {
 	int nr;
@@ -436,7 +420,6 @@ static void atari_scsi_fetch_restbytes(v
 			*dst++ = *src++;
 	}
 }
-#endif /* REAL_DMA */
 
 
 /* This function releases the lock on the DMA chip if there is no
@@ -508,8 +491,6 @@ __setup("atascsi=", atari_scsi_setup);
 #endif /* !MODULE */
 
 
-#if defined(REAL_DMA)
-
 static unsigned long atari_scsi_dma_setup(struct Scsi_Host *instance,
 					  void *data, unsigned long count,
 					  int dir)
@@ -703,9 +684,6 @@ static unsigned long atari_dma_xfer_len(
 }
 
 
-#endif	/* REAL_DMA */
-
-
 /* NCR5380 register access functions
  *
  * There are separate functions for TT and Falcon, because the access
@@ -745,7 +723,6 @@ static int atari_scsi_bus_reset(struct s
 
 	local_irq_save(flags);
 
-#ifdef REAL_DMA
 	/* Abort a maybe active DMA transfer */
 	if (IS_A_TT()) {
 		tt_scsi_dma.dma_ctrl = 0;
@@ -754,7 +731,6 @@ static int atari_scsi_bus_reset(struct s
 		atari_dma_active = 0;
 		atari_dma_orig_addr = NULL;
 	}
-#endif
 
 	rv = NCR5380_bus_reset(cmd);
 
@@ -850,8 +826,6 @@ static int __init atari_scsi_probe(struc
 		}
 	}
 
-
-#ifdef REAL_DMA
 	/* If running on a Falcon and if there's TT-Ram (i.e., more than one
 	 * memory block, since there's always ST-Ram in a Falcon), then
 	 * allocate a STRAM_BUFFER_SIZE byte dribble buffer for transfers
@@ -867,7 +841,6 @@ static int __init atari_scsi_probe(struc
 		atari_dma_phys_buffer = atari_stram_to_phys(atari_dma_buffer);
 		atari_dma_orig_addr = 0;
 	}
-#endif
 
 	instance = scsi_host_alloc(&atari_scsi_template,
 	                           sizeof(struct NCR5380_hostdata));
@@ -897,7 +870,7 @@ static int __init atari_scsi_probe(struc
 			goto fail_irq;
 		}
 		tt_mfp.active_edge |= 0x80;	/* SCSI int on L->H */
-#ifdef REAL_DMA
+
 		tt_scsi_dma.dma_ctrl = 0;
 		atari_dma_residual = 0;
 
@@ -919,17 +892,14 @@ static int __init atari_scsi_probe(struc
 
 			hostdata->read_overruns = 4;
 		}
-#endif
 	} else {
 		/* Nothing to do for the interrupt: the ST-DMA is initialized
 		 * already.
 		 */
-#ifdef REAL_DMA
 		atari_dma_residual = 0;
 		atari_dma_active = 0;
 		atari_dma_stram_mask = (ATARIHW_PRESENT(EXTD_DMA) ? 0x00000000
 					: 0xff000000);
-#endif
 	}
 
 	NCR5380_maybe_reset_bus(instance);
Index: linux/drivers/scsi/sun3_scsi.c
===================================================================
--- linux.orig/drivers/scsi/sun3_scsi.c	2016-03-16 14:16:56.000000000 +1100
+++ linux/drivers/scsi/sun3_scsi.c	2016-03-16 14:18:05.000000000 +1100
@@ -38,7 +38,6 @@
 
 /* Definitions for the core NCR5380 driver. */
 
-#define REAL_DMA
 /* #define SUPPORT_TAGS */
 /* minimum number of bytes to do dma on */
 #define DMA_MIN_SIZE                    129
@@ -527,15 +526,9 @@ static int __init sun3_scsi_probe(struct
 	error = request_irq(instance->irq, scsi_sun3_intr, 0,
 	                    "NCR5380", instance);
 	if (error) {
-#ifdef REAL_DMA
 		pr_err(PFX "scsi%d: IRQ %d not free, bailing out\n",
 		       instance->host_no, instance->irq);
 		goto fail_irq;
-#else
-		pr_warn(PFX "scsi%d: IRQ %d not free, interrupts disabled\n",
-		        instance->host_no, instance->irq);
-		instance->irq = NO_IRQ;
-#endif
 	}
 
 	dregs->csr = 0;
@@ -565,8 +558,7 @@ static int __init sun3_scsi_probe(struct
 	return 0;
 
 fail_host:
-	if (instance->irq != NO_IRQ)
-		free_irq(instance->irq, instance);
+	free_irq(instance->irq, instance);
 fail_irq:
 	NCR5380_exit(instance);
 fail_init:
@@ -583,8 +575,7 @@ static int __exit sun3_scsi_remove(struc
 	struct Scsi_Host *instance = platform_get_drvdata(pdev);
 
 	scsi_remove_host(instance);
-	if (instance->irq != NO_IRQ)
-		free_irq(instance->irq, instance);
+	free_irq(instance->irq, instance);
 	NCR5380_exit(instance);
 	scsi_host_put(instance);
 	if (udc_regs)
