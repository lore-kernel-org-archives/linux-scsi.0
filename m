From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v4 68/78] ncr5380: Fix trailing whitespace using regexp
Date: Sun, 03 Jan 2016 16:06:09 +1100
Message-ID: <20160103050520.246369360@telegraphics.com.au>
References: <20160103050501.042035135@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:49458 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910AbcACFS3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Jan 2016 00:18:29 -0500
Content-Disposition: inline; filename=ncr5380-regexp-trailing-whitespace
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

This patch is the result of the following substitution. It removes any
tabs and spaces at the end of a line.

perl -i -pe 's,[\t ]+$,,' drivers/scsi/{atari_,}NCR5380.c 

This removes some unimportant discrepancies between the two core driver
forks so that the important ones become obvious, to facilitate
reunification.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Tested-by: Ondrej Zary <linux@rainbow-software.org>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>

---

Changes since v3:
- Now split into two patches (one for each regexp). This may make review
  easier though it means many lines are now changed twice.

---
 drivers/scsi/NCR5380.c |  372 ++++++++++++++++++++++++-------------------------
 1 file changed, 186 insertions(+), 186 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2016-01-03 16:04:40.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2016-01-03 16:04:42.000000000 +1100
@@ -1,4 +1,4 @@
-/* 
+/*
  * NCR 5380 generic driver routines.  These should make it *trivial*
  *      to implement 5380 SCSI drivers under Linux with a non-trantor
  *      architecture.
@@ -6,12 +6,12 @@
  *      Note that these routines also work with NR53c400 family chips.
  *
  * Copyright 1993, Drew Eckhardt
- *      Visionary Computing 
+ *      Visionary Computing
  *      (Unix and Linux consulting and custom programming)
  *      drew@colorado.edu
  *      +1 (303) 666-5836
  *
- * For more information, please consult 
+ * For more information, please consult
  *
  * NCR 5380 Family
  * SCSI Protocol Controller
@@ -30,16 +30,16 @@
  */
 
 /*
- * Further development / testing that should be done : 
+ * Further development / testing that should be done :
  * 1.  Cleanup the NCR5380_transfer_dma function and DMA operation complete
- *     code so that everything does the same thing that's done at the 
+ *     code so that everything does the same thing that's done at the
  *     end of a pseudo-DMA read operation.
  *
  * 2.  Fix REAL_DMA (interrupt driven, polled works fine) -
- *     basically, transfer size needs to be reduced by one 
+ *     basically, transfer size needs to be reduced by one
  *     and the last byte read as is done with PSEUDO_DMA.
- * 
- * 4.  Test SCSI-II tagged queueing (I have no devices which support 
+ *
+ * 4.  Test SCSI-II tagged queueing (I have no devices which support
  *      tagged queueing)
  */
 
@@ -56,27 +56,27 @@
 /*
  * Design
  *
- * This is a generic 5380 driver.  To use it on a different platform, 
+ * This is a generic 5380 driver.  To use it on a different platform,
  * one simply writes appropriate system specific macros (ie, data
- * transfer - some PC's will use the I/O bus, 68K's must use 
+ * transfer - some PC's will use the I/O bus, 68K's must use
  * memory mapped) and drops this file in their 'C' wrapper.
  *
- * As far as command queueing, two queues are maintained for 
+ * As far as command queueing, two queues are maintained for
  * each 5380 in the system - commands that haven't been issued yet,
- * and commands that are currently executing.  This means that an 
- * unlimited number of commands may be queued, letting 
- * more commands propagate from the higher driver levels giving higher 
- * throughput.  Note that both I_T_L and I_T_L_Q nexuses are supported, 
- * allowing multiple commands to propagate all the way to a SCSI-II device 
+ * and commands that are currently executing.  This means that an
+ * unlimited number of commands may be queued, letting
+ * more commands propagate from the higher driver levels giving higher
+ * throughput.  Note that both I_T_L and I_T_L_Q nexuses are supported,
+ * allowing multiple commands to propagate all the way to a SCSI-II device
  * while a command is already executing.
  *
  *
- * Issues specific to the NCR5380 : 
+ * Issues specific to the NCR5380 :
  *
- * When used in a PIO or pseudo-dma mode, the NCR5380 is a braindead 
- * piece of hardware that requires you to sit in a loop polling for 
- * the REQ signal as long as you are connected.  Some devices are 
- * brain dead (ie, many TEXEL CD ROM drives) and won't disconnect 
+ * When used in a PIO or pseudo-dma mode, the NCR5380 is a braindead
+ * piece of hardware that requires you to sit in a loop polling for
+ * the REQ signal as long as you are connected.  Some devices are
+ * brain dead (ie, many TEXEL CD ROM drives) and won't disconnect
  * while doing long seek operations. [...] These
  * broken devices are the exception rather than the rule and I'd rather
  * spend my time optimizing for the normal case.
@@ -87,23 +87,23 @@
  * which is started from a workqueue for each NCR5380 host in the
  * system.  It attempts to establish I_T_L or I_T_L_Q nexuses by
  * removing the commands from the issue queue and calling
- * NCR5380_select() if a nexus is not established. 
+ * NCR5380_select() if a nexus is not established.
  *
  * Once a nexus is established, the NCR5380_information_transfer()
  * phase goes through the various phases as instructed by the target.
  * if the target goes into MSG IN and sends a DISCONNECT message,
  * the command structure is placed into the per instance disconnected
- * queue, and NCR5380_main tries to find more work.  If the target is 
+ * queue, and NCR5380_main tries to find more work.  If the target is
  * idle for too long, the system will try to sleep.
  *
  * If a command has disconnected, eventually an interrupt will trigger,
  * calling NCR5380_intr()  which will in turn call NCR5380_reselect
  * to reestablish a nexus.  This will run main if necessary.
  *
- * On command termination, the done function will be called as 
+ * On command termination, the done function will be called as
  * appropriate.
  *
- * SCSI pointers are maintained in the SCp field of SCSI command 
+ * SCSI pointers are maintained in the SCp field of SCSI command
  * structures, being initialized after the command is connected
  * in NCR5380_select, and set as appropriate in NCR5380_information_transfer.
  * Note that in violation of the standard, an implicit SAVE POINTERS operation
@@ -113,18 +113,18 @@
 /*
  * Using this file :
  * This file a skeleton Linux SCSI driver for the NCR 5380 series
- * of chips.  To use it, you write an architecture specific functions 
+ * of chips.  To use it, you write an architecture specific functions
  * and macros and include this file in your driver.
  *
- * These macros control options : 
- * AUTOPROBE_IRQ - if defined, the NCR5380_probe_irq() function will be 
+ * These macros control options :
+ * AUTOPROBE_IRQ - if defined, the NCR5380_probe_irq() function will be
  *      defined.
- * 
+ *
  * AUTOSENSE - if defined, REQUEST SENSE will be performed automatically
- *      for commands that return with a CHECK CONDITION status. 
+ *      for commands that return with a CHECK CONDITION status.
  *
  * DIFFERENTIAL - if defined, NCR53c81 chips will use external differential
- *      transceivers. 
+ *      transceivers.
  *
  * DONT_USE_INTR - if defined, never use interrupts, even if we probe or
  *      override-configure an IRQ.
@@ -134,25 +134,25 @@
  * REAL_DMA - if defined, REAL DMA is used during the data transfer phases.
  *
  * REAL_DMA_POLL - if defined, REAL DMA is used but the driver doesn't
- *      rely on phase mismatch and EOP interrupts to determine end 
+ *      rely on phase mismatch and EOP interrupts to determine end
  *      of phase.
  *
  * These macros MUST be defined :
- * 
+ *
  * NCR5380_read(register)  - read from the specified register
  *
- * NCR5380_write(register, value) - write to the specific register 
+ * NCR5380_write(register, value) - write to the specific register
  *
- * NCR5380_implementation_fields  - additional fields needed for this 
+ * NCR5380_implementation_fields  - additional fields needed for this
  *      specific implementation of the NCR5380
  *
  * Either real DMA *or* pseudo DMA may be implemented
- * REAL functions : 
+ * REAL functions :
  * NCR5380_REAL_DMA should be defined if real DMA is to be used.
- * Note that the DMA setup functions should return the number of bytes 
+ * Note that the DMA setup functions should return the number of bytes
  *      that they were able to program the controller for.
  *
- * Also note that generic i386/PC versions of these macros are 
+ * Also note that generic i386/PC versions of these macros are
  *      available as NCR5380_i386_dma_write_setup,
  *      NCR5380_i386_dma_read_setup, and NCR5380_i386_dma_residual.
  *
@@ -165,7 +165,7 @@
  * NCR5380_pread(instance, dst, count);
  *
  * The generic driver is initialized by calling NCR5380_init(instance),
- * after setting the appropriate host specific fields and ID.  If the 
+ * after setting the appropriate host specific fields and ID.  If the
  * driver wishes to autoprobe for an IRQ line, the NCR5380_probe_irq(instance,
  * possible) function may be used.
  */
@@ -182,8 +182,8 @@ static void do_reset(struct Scsi_Host *)
 
 static inline void initialize_SCp(struct scsi_cmnd *cmd)
 {
-	/* 
-	 * Initialize the Scsi Pointer field so that all of the commands in the 
+	/*
+	 * Initialize the Scsi Pointer field so that all of the commands in the
 	 * various queues are valid.
 	 */
 
@@ -268,12 +268,12 @@ static struct {
 	unsigned char value;
 	const char *name;
 } phases[] __maybe_unused = {
-	{PHASE_DATAOUT, "DATAOUT"}, 
-	{PHASE_DATAIN, "DATAIN"}, 
-	{PHASE_CMDOUT, "CMDOUT"}, 
-	{PHASE_STATIN, "STATIN"}, 
-	{PHASE_MSGOUT, "MSGOUT"}, 
-	{PHASE_MSGIN, "MSGIN"}, 
+	{PHASE_DATAOUT, "DATAOUT"},
+	{PHASE_DATAIN, "DATAIN"},
+	{PHASE_CMDOUT, "CMDOUT"},
+	{PHASE_STATIN, "STATIN"},
+	{PHASE_MSGOUT, "MSGOUT"},
+	{PHASE_MSGIN, "MSGIN"},
 	{PHASE_UNKNOWN, "UNKNOWN"}
 };
 
@@ -281,39 +281,39 @@ static struct {
 static struct {
 	unsigned char mask;
 	const char *name;
-} signals[] = { 
-	{SR_DBP, "PARITY"}, 
-	{SR_RST, "RST"}, 
-	{SR_BSY, "BSY"}, 
-	{SR_REQ, "REQ"}, 
-	{SR_MSG, "MSG"}, 
-	{SR_CD, "CD"}, 
-	{SR_IO, "IO"}, 
-	{SR_SEL, "SEL"}, 
+} signals[] = {
+	{SR_DBP, "PARITY"},
+	{SR_RST, "RST"},
+	{SR_BSY, "BSY"},
+	{SR_REQ, "REQ"},
+	{SR_MSG, "MSG"},
+	{SR_CD, "CD"},
+	{SR_IO, "IO"},
+	{SR_SEL, "SEL"},
 	{0, NULL}
-}, 
+},
 basrs[] = {
-	{BASR_ATN, "ATN"}, 
-	{BASR_ACK, "ACK"}, 
+	{BASR_ATN, "ATN"},
+	{BASR_ACK, "ACK"},
 	{0, NULL}
-}, 
-icrs[] = { 
-	{ICR_ASSERT_RST, "ASSERT RST"}, 
-	{ICR_ASSERT_ACK, "ASSERT ACK"}, 
-	{ICR_ASSERT_BSY, "ASSERT BSY"}, 
-	{ICR_ASSERT_SEL, "ASSERT SEL"}, 
-	{ICR_ASSERT_ATN, "ASSERT ATN"}, 
-	{ICR_ASSERT_DATA, "ASSERT DATA"}, 
+},
+icrs[] = {
+	{ICR_ASSERT_RST, "ASSERT RST"},
+	{ICR_ASSERT_ACK, "ASSERT ACK"},
+	{ICR_ASSERT_BSY, "ASSERT BSY"},
+	{ICR_ASSERT_SEL, "ASSERT SEL"},
+	{ICR_ASSERT_ATN, "ASSERT ATN"},
+	{ICR_ASSERT_DATA, "ASSERT DATA"},
 	{0, NULL}
-}, 
-mrs[] = { 
-	{MR_BLOCK_DMA_MODE, "MODE BLOCK DMA"}, 
-	{MR_TARGET, "MODE TARGET"}, 
-	{MR_ENABLE_PAR_CHECK, "MODE PARITY CHECK"}, 
-	{MR_ENABLE_PAR_INTR, "MODE PARITY INTR"}, 
-	{MR_MONITOR_BSY, "MODE MONITOR BSY"}, 
-	{MR_DMA_MODE, "MODE DMA"}, 
-	{MR_ARBITRATE, "MODE ARBITRATION"}, 
+},
+mrs[] = {
+	{MR_BLOCK_DMA_MODE, "MODE BLOCK DMA"},
+	{MR_TARGET, "MODE TARGET"},
+	{MR_ENABLE_PAR_CHECK, "MODE PARITY CHECK"},
+	{MR_ENABLE_PAR_INTR, "MODE PARITY INTR"},
+	{MR_MONITOR_BSY, "MODE MONITOR BSY"},
+	{MR_DMA_MODE, "MODE DMA"},
+	{MR_ARBITRATE, "MODE ARBITRATION"},
 	{0, NULL}
 };
 
@@ -388,7 +388,7 @@ static int probe_irq __initdata;
  *	Set a flag to indicate the IRQ in question was received. This is
  *	used by the IRQ probe code.
  */
- 
+
 static irqreturn_t __init probe_intr(int irq, void *dev_id)
 {
 	probe_irq = irq;
@@ -420,7 +420,7 @@ static int __init __maybe_unused NCR5380
 
 	/*
 	 * A interrupt is triggered whenever BSY = false, SEL = true
-	 * and a bit set in the SELECT_ENABLE_REG is asserted on the 
+	 * and a bit set in the SELECT_ENABLE_REG is asserted on the
 	 * SCSI bus.
 	 *
 	 * Note that the bus is only driven when the phase control signals
@@ -435,7 +435,7 @@ static int __init __maybe_unused NCR5380
 
 	while (probe_irq == NO_IRQ && time_before(jiffies, timeout))
 		schedule_timeout_uninterruptible(1);
-	
+
 	NCR5380_write(SELECT_ENABLE_REG, 0);
 	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 
@@ -530,7 +530,7 @@ static int __maybe_unused NCR5380_show_i
  *      with flags OR'd into the initial flags value.
  *
  *	Notes : I assume that the host, hostno, and id bits have been
- *      set correctly.  I don't care about the irq and other fields. 
+ *      set correctly.  I don't care about the irq and other fields.
  *
  *	Returns 0 for success
  */
@@ -561,7 +561,7 @@ static int NCR5380_init(struct Scsi_Host
 	INIT_LIST_HEAD(&hostdata->disconnected);
 
 	hostdata->flags = flags;
-	
+
 	INIT_WORK(&hostdata->main_task, NCR5380_main);
 	hostdata->work_q = alloc_workqueue("ncr5380_%d",
 	                        WQ_UNBOUND | WQ_MEM_RECLAIM,
@@ -720,10 +720,10 @@ static int NCR5380_queue_command(struct
 
 	spin_lock_irqsave(&hostdata->lock, flags);
 
-	/* 
-	 * Insert the cmd into the issue queue. Note that REQUEST SENSE 
+	/*
+	 * Insert the cmd into the issue queue. Note that REQUEST SENSE
 	 * commands are added to the head of the queue since any command will
-	 * clear the contingent allegiance condition that exists and the 
+	 * clear the contingent allegiance condition that exists and the
 	 * sense data is only guaranteed to be valid while the condition exists.
 	 */
 
@@ -803,9 +803,9 @@ static void requeue_cmd(struct Scsi_Host
 /**
  *	NCR5380_main	-	NCR state machines
  *
- *	NCR5380_main is a coroutine that runs as long as more work can 
- *      be done on the NCR5380 host adapters in a system.  Both 
- *      NCR5380_queue_command() and NCR5380_intr() will try to start it 
+ *	NCR5380_main is a coroutine that runs as long as more work can
+ *      be done on the NCR5380 host adapters in a system.  Both
+ *      NCR5380_queue_command() and NCR5380_intr() will try to start it
  *      in case it is not running.
  */
 
@@ -816,7 +816,7 @@ static void NCR5380_main(struct work_str
 	struct Scsi_Host *instance = hostdata->host;
 	struct scsi_cmnd *cmd;
 	int done;
-	
+
 	do {
 		done = 1;
 
@@ -975,37 +975,37 @@ static irqreturn_t NCR5380_intr(int irq,
 	return IRQ_RETVAL(handled);
 }
 
-#endif 
+#endif
 
-/* 
+/*
  * Function : int NCR5380_select(struct Scsi_Host *instance,
  *                               struct scsi_cmnd *cmd)
  *
  * Purpose : establishes I_T_L or I_T_L_Q nexus for new or existing command,
- *      including ARBITRATION, SELECTION, and initial message out for 
- *      IDENTIFY and queue messages. 
+ *      including ARBITRATION, SELECTION, and initial message out for
+ *      IDENTIFY and queue messages.
  *
- * Inputs : instance - instantiation of the 5380 driver on which this 
+ * Inputs : instance - instantiation of the 5380 driver on which this
  *      target lives, cmd - SCSI command to execute.
- * 
+ *
  * Returns cmd if selection failed but should be retried,
  * NULL if selection failed and should not be retried, or
  * NULL if selection succeeded (hostdata->connected == cmd).
  *
- * Side effects : 
- *      If bus busy, arbitration failed, etc, NCR5380_select() will exit 
+ * Side effects :
+ *      If bus busy, arbitration failed, etc, NCR5380_select() will exit
  *              with registers as they should have been on entry - ie
  *              SELECT_ENABLE will be set appropriately, the NCR5380
  *              will cease to drive any SCSI bus signals.
  *
- *      If successful : I_T_L or I_T_L_Q nexus will be established, 
- *              instance->connected will be set to cmd.  
+ *      If successful : I_T_L or I_T_L_Q nexus will be established,
+ *              instance->connected will be set to cmd.
  *              SELECT interrupt will be disabled.
  *
- *      If failed (no target) : cmd->scsi_done() will be called, and the 
+ *      If failed (no target) : cmd->scsi_done() will be called, and the
  *              cmd->result host byte set to DID_BAD_TARGET.
  */
- 
+
 static struct scsi_cmnd *NCR5380_select(struct Scsi_Host *instance,
                                         struct scsi_cmnd *cmd)
 {
@@ -1028,14 +1028,14 @@ static struct scsi_cmnd *NCR5380_select(
 	 */
 	hostdata->selecting = cmd;
 
-	/* 
-	 * Set the phase bits to 0, otherwise the NCR5380 won't drive the 
+	/*
+	 * Set the phase bits to 0, otherwise the NCR5380 won't drive the
 	 * data bus during SELECTION.
 	 */
 
 	NCR5380_write(TARGET_COMMAND_REG, 0);
 
-	/* 
+	/*
 	 * Start arbitration.
 	 */
 
@@ -1081,8 +1081,8 @@ static struct scsi_cmnd *NCR5380_select(
 	NCR5380_write(INITIATOR_COMMAND_REG,
 		      ICR_BASE | ICR_ASSERT_SEL | ICR_ASSERT_BSY);
 
-	/* 
-	 * Again, bus clear + bus settle time is 1.2us, however, this is 
+	/*
+	 * Again, bus clear + bus settle time is 1.2us, however, this is
 	 * a minimum so we'll udelay ceil(1.2)
 	 */
 
@@ -1105,14 +1105,14 @@ static struct scsi_cmnd *NCR5380_select(
 
 	dsprintk(NDEBUG_ARBITRATION, instance, "won arbitration\n");
 
-	/* 
-	 * Now that we have won arbitration, start Selection process, asserting 
+	/*
+	 * Now that we have won arbitration, start Selection process, asserting
 	 * the host and target ID's on the SCSI bus.
 	 */
 
 	NCR5380_write(OUTPUT_DATA_REG, (hostdata->id_mask | (1 << scmd_id(cmd))));
 
-	/* 
+	/*
 	 * Raise ATN while SEL is true before BSY goes false from arbitration,
 	 * since this is the only way to guarantee that we'll get a MESSAGE OUT
 	 * phase immediately after selection.
@@ -1121,7 +1121,7 @@ static struct scsi_cmnd *NCR5380_select(
 	NCR5380_write(INITIATOR_COMMAND_REG, (ICR_BASE | ICR_ASSERT_BSY | ICR_ASSERT_DATA | ICR_ASSERT_ATN | ICR_ASSERT_SEL));
 	NCR5380_write(MODE_REG, MR_BASE);
 
-	/* 
+	/*
 	 * Reselect interrupts must be turned off prior to the dropping of BSY,
 	 * otherwise we will trigger an interrupt.
 	 */
@@ -1130,7 +1130,7 @@ static struct scsi_cmnd *NCR5380_select(
 	spin_unlock_irq(&hostdata->lock);
 
 	/*
-	 * The initiator shall then wait at least two deskew delays and release 
+	 * The initiator shall then wait at least two deskew delays and release
 	 * the BSY signal.
 	 */
 	udelay(1);		/* wingel -- wait two bus deskew delay >2*45ns */
@@ -1138,17 +1138,17 @@ static struct scsi_cmnd *NCR5380_select(
 	/* Reset BSY */
 	NCR5380_write(INITIATOR_COMMAND_REG, (ICR_BASE | ICR_ASSERT_DATA | ICR_ASSERT_ATN | ICR_ASSERT_SEL));
 
-	/* 
+	/*
 	 * Something weird happens when we cease to drive BSY - looks
-	 * like the board/chip is letting us do another read before the 
+	 * like the board/chip is letting us do another read before the
 	 * appropriate propagation delay has expired, and we're confusing
 	 * a BSY signal from ourselves as the target's response to SELECTION.
 	 *
 	 * A small delay (the 'C++' frontend breaks the pipeline with an
 	 * unnecessary jump, making it work on my 386-33/Trantor T128, the
-	 * tighter 'C' code breaks and requires this) solves the problem - 
-	 * the 1 us delay is arbitrary, and only used because this delay will 
-	 * be the same on other platforms and since it works here, it should 
+	 * tighter 'C' code breaks and requires this) solves the problem -
+	 * the 1 us delay is arbitrary, and only used because this delay will
+	 * be the same on other platforms and since it works here, it should
 	 * work there.
 	 *
 	 * wingel suggests that this could be due to failing to wait
@@ -1159,8 +1159,8 @@ static struct scsi_cmnd *NCR5380_select(
 
 	dsprintk(NDEBUG_SELECTION, instance, "selecting target %d\n", scmd_id(cmd));
 
-	/* 
-	 * The SCSI specification calls for a 250 ms timeout for the actual 
+	/*
+	 * The SCSI specification calls for a 250 ms timeout for the actual
 	 * selection.
 	 */
 
@@ -1191,9 +1191,9 @@ static struct scsi_cmnd *NCR5380_select(
 		goto out;
 	}
 
-	/* 
-	 * No less than two deskew delays after the initiator detects the 
-	 * BSY signal is true, it shall release the SEL signal and may 
+	/*
+	 * No less than two deskew delays after the initiator detects the
+	 * BSY signal is true, it shall release the SEL signal and may
 	 * change the DATA BUS.                                     -wingel
 	 */
 
@@ -1202,11 +1202,11 @@ static struct scsi_cmnd *NCR5380_select(
 	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_ATN);
 
 	/*
-	 * Since we followed the SCSI spec, and raised ATN while SEL 
+	 * Since we followed the SCSI spec, and raised ATN while SEL
 	 * was true but before BSY was false during selection, the information
 	 * transfer phase should be a MESSAGE OUT phase so that we can send the
 	 * IDENTIFY message.
-	 * 
+	 *
 	 * If SCSI-II tagged queuing is enabled, we also send a SIMPLE_QUEUE_TAG
 	 * message (2 bytes) with a tag ID that we increment with every command
 	 * until it wraps back to 0.
@@ -1259,16 +1259,16 @@ out:
 	return cmd;
 }
 
-/* 
- * Function : int NCR5380_transfer_pio (struct Scsi_Host *instance, 
+/*
+ * Function : int NCR5380_transfer_pio (struct Scsi_Host *instance,
  *      unsigned char *phase, int *count, unsigned char **data)
  *
  * Purpose : transfers data in given phase using polled I/O
  *
- * Inputs : instance - instance of driver, *phase - pointer to 
- *      what phase is expected, *count - pointer to number of 
+ * Inputs : instance - instance of driver, *phase - pointer to
+ *      what phase is expected, *count - pointer to number of
  *      bytes to transfer, **data - pointer to data pointer.
- * 
+ *
  * Returns : -1 when different phase is entered without transferring
  *      maximum number of bytes, 0 if all bytes or transferred or exit
  *      is in same phase.
@@ -1279,7 +1279,7 @@ out:
  */
 
 /*
- * Note : this code is not as quick as it could be, however it 
+ * Note : this code is not as quick as it could be, however it
  * IS 100% reliable, and for the actual data transfer where speed
  * counts, we will always do a pseudo DMA or DMA transfer.
  */
@@ -1289,8 +1289,8 @@ static int NCR5380_transfer_pio(struct S
 	int c = *count;
 	unsigned char *d = *data;
 
-	/* 
-	 * The NCR5380 chip will only drive the SCSI bus when the 
+	/*
+	 * The NCR5380 chip will only drive the SCSI bus when the
 	 * phase specified in the appropriate bits of the TARGET COMMAND
 	 * REGISTER match the STATUS REGISTER
 	 */
@@ -1298,9 +1298,9 @@ static int NCR5380_transfer_pio(struct S
 	 NCR5380_write(TARGET_COMMAND_REG, PHASE_SR_TO_TCR(p));
 
 	do {
-		/* 
-		 * Wait for assertion of REQ, after which the phase bits will be 
-		 * valid 
+		/*
+		 * Wait for assertion of REQ, after which the phase bits will be
+		 * valid
 		 */
 
 		if (NCR5380_poll_politely(instance, STATUS_REG, SR_REQ, SR_REQ, HZ) < 0)
@@ -1322,7 +1322,7 @@ static int NCR5380_transfer_pio(struct S
 
 		++d;
 
-		/* 
+		/*
 		 * The SCSI standard suggests that in MSGOUT phase, the initiator
 		 * should drop ATN on the last byte of the message phase
 		 * after REQ has been asserted for the handshake but before
@@ -1351,11 +1351,11 @@ static int NCR5380_transfer_pio(struct S
 		dsprintk(NDEBUG_HANDSHAKE, instance, "REQ negated, handshake complete\n");
 
 /*
- * We have several special cases to consider during REQ/ACK handshaking : 
- * 1.  We were in MSGOUT phase, and we are on the last byte of the 
+ * We have several special cases to consider during REQ/ACK handshaking :
+ * 1.  We were in MSGOUT phase, and we are on the last byte of the
  *      message.  ATN must be dropped as ACK is dropped.
  *
- * 2.  We are in a MSGIN phase, and we are on the last byte of the  
+ * 2.  We are in a MSGIN phase, and we are on the last byte of the
  *      message.  We must exit with ACK asserted, so that the calling
  *      code may raise ATN before dropping ACK to reject the message.
  *
@@ -1400,7 +1400,7 @@ static int NCR5380_transfer_pio(struct S
  * it. When the driver is initialized, the NCR5380_intr() handler has not yet
  * been installed. And when in EH we may have released the ST DMA interrupt.
  */
- 
+
 static void do_reset(struct Scsi_Host *instance)
 {
 	unsigned long flags;
@@ -1432,12 +1432,12 @@ static int do_abort(struct Scsi_Host *in
 	/* Request message out phase */
 	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_ATN);
 
-	/* 
-	 * Wait for the target to indicate a valid phase by asserting 
-	 * REQ.  Once this happens, we'll have either a MSGOUT phase 
-	 * and can immediately send the ABORT message, or we'll have some 
+	/*
+	 * Wait for the target to indicate a valid phase by asserting
+	 * REQ.  Once this happens, we'll have either a MSGOUT phase
+	 * and can immediately send the ABORT message, or we'll have some
 	 * other phase and will have to source/sink data.
-	 * 
+	 *
 	 * We really don't care what value was on the bus or what value
 	 * the target sees, so we just handshake.
 	 */
@@ -1447,7 +1447,7 @@ static int do_abort(struct Scsi_Host *in
 		goto timeout;
 
 	tmp = NCR5380_read(STATUS_REG) & PHASE_MASK;
-	
+
 	NCR5380_write(TARGET_COMMAND_REG, PHASE_SR_TO_TCR(tmp));
 
 	if (tmp != PHASE_MSGOUT) {
@@ -1476,17 +1476,17 @@ timeout:
 }
 
 #if defined(REAL_DMA) || defined(PSEUDO_DMA) || defined (REAL_DMA_POLL)
-/* 
- * Function : int NCR5380_transfer_dma (struct Scsi_Host *instance, 
+/*
+ * Function : int NCR5380_transfer_dma (struct Scsi_Host *instance,
  *      unsigned char *phase, int *count, unsigned char **data)
  *
  * Purpose : transfers data in given phase using either real
  *      or pseudo DMA.
  *
- * Inputs : instance - instance of driver, *phase - pointer to 
- *      what phase is expected, *count - pointer to number of 
+ * Inputs : instance - instance of driver, *phase - pointer to
+ *      what phase is expected, *count - pointer to number of
  *      bytes to transfer, **data - pointer to data pointer.
- * 
+ *
  * Returns : -1 when different phase is entered without transferring
  *      maximum number of bytes, 0 if all bytes or transferred or exit
  *      is in same phase.
@@ -1533,7 +1533,7 @@ static int NCR5380_transfer_dma(struct S
 #else
 	/*
 	 * Note : on my sample board, watch-dog timeouts occurred when interrupts
-	 * were not disabled for the duration of a single DMA transfer, from 
+	 * were not disabled for the duration of a single DMA transfer, from
 	 * before the setting of DMA mode to after transfer of the last byte.
 	 */
 
@@ -1546,7 +1546,7 @@ static int NCR5380_transfer_dma(struct S
 
 	dprintk(NDEBUG_DMA, "scsi%d : mode reg = 0x%X\n", instance->host_no, NCR5380_read(MODE_REG));
 
-	/* 
+	/*
 	 *	On the PAS16 at least I/O recovery delays are not needed here.
 	 *	Everyone else seems to want them.
 	 */
@@ -1661,24 +1661,24 @@ static int NCR5380_transfer_dma(struct S
 			hostdata->flags & FLAG_NO_DMA_FIXUP ? c : c - 1);
 		if (!foo && !(hostdata->flags & FLAG_NO_DMA_FIXUP)) {
 			/*
-			 * We can't disable DMA mode after successfully transferring 
+			 * We can't disable DMA mode after successfully transferring
 			 * what we plan to be the last byte, since that would open up
-			 * a race condition where if the target asserted REQ before 
+			 * a race condition where if the target asserted REQ before
 			 * we got the DMA mode reset, the NCR5380 would have latched
 			 * an additional byte into the INPUT DATA register and we'd
 			 * have dropped it.
-			 * 
-			 * The workaround was to transfer one fewer bytes than we 
-			 * intended to with the pseudo-DMA read function, wait for 
+			 *
+			 * The workaround was to transfer one fewer bytes than we
+			 * intended to with the pseudo-DMA read function, wait for
 			 * the chip to latch the last byte, read it, and then disable
 			 * pseudo-DMA mode.
-			 * 
+			 *
 			 * After REQ is asserted, the NCR5380 asserts DRQ and ACK.
 			 * REQ is deasserted when ACK is asserted, and not reasserted
 			 * until ACK goes false.  Since the NCR5380 won't lower ACK
 			 * until DACK is asserted, which won't happen unless we twiddle
-			 * the DMA port or we take the NCR5380 out of DMA mode, we 
-			 * can guarantee that we won't handshake another extra 
+			 * the DMA port or we take the NCR5380 out of DMA mode, we
+			 * can guarantee that we won't handshake another extra
 			 * byte.
 			 */
 
@@ -1698,8 +1698,8 @@ static int NCR5380_transfer_dma(struct S
 		foo = NCR5380_pwrite(instance, d, c);
 		if (!foo && !(hostdata->flags & FLAG_NO_DMA_FIXUP)) {
 			/*
-			 * Wait for the last byte to be sent.  If REQ is being asserted for 
-			 * the byte we're interested, we'll ACK it and it will go false.  
+			 * Wait for the last byte to be sent.  If REQ is being asserted for
+			 * the byte we're interested, we'll ACK it and it will go false.
 			 */
 			if (NCR5380_poll_politely2(instance,
 			     BUS_AND_STATUS_REG, BASR_DRQ, BASR_DRQ,
@@ -1723,17 +1723,17 @@ static int NCR5380_transfer_dma(struct S
 /*
  * Function : NCR5380_information_transfer (struct Scsi_Host *instance)
  *
- * Purpose : run through the various SCSI phases and do as the target 
- *      directs us to.  Operates on the currently connected command, 
+ * Purpose : run through the various SCSI phases and do as the target
+ *      directs us to.  Operates on the currently connected command,
  *      instance->connected.
  *
  * Inputs : instance, instance for which we are doing commands
  *
- * Side effects : SCSI things happen, the disconnected queue will be 
+ * Side effects : SCSI things happen, the disconnected queue will be
  *      modified if a command disconnects, *instance->connected will
  *      change.
  *
- * XXX Note : we need to watch for bus free or a reset condition here 
+ * XXX Note : we need to watch for bus free or a reset condition here
  *      to recover from an unexpected bus free condition.
  */
 
@@ -1780,7 +1780,7 @@ static void NCR5380_information_transfer
 				return;
 #endif
 			case PHASE_DATAIN:
-				/* 
+				/*
 				 * If there is no room left in the current buffer in the
 				 * scatter-gather list, move onto the next one.
 				 */
@@ -1795,7 +1795,7 @@ static void NCR5380_information_transfer
 					         cmd->SCp.buffers_residual);
 				}
 				/*
-				 * The preferred transfer method is going to be 
+				 * The preferred transfer method is going to be
 				 * PSEUDO-DMA for systems that are strictly PIO,
 				 * since we can let the hardware do the handshaking.
 				 *
@@ -1871,8 +1871,8 @@ static void NCR5380_information_transfer
 							complete_cmd(instance, cmd);
 					}
 
-					/* 
-					 * Restore phase bits to 0 so an interrupted selection, 
+					/*
+					 * Restore phase bits to 0 so an interrupted selection,
 					 * arbitration can resume.
 					 */
 					NCR5380_write(TARGET_COMMAND_REG, 0);
@@ -1903,8 +1903,8 @@ static void NCR5380_information_transfer
 						         instance, "connected command %p for target %d lun %llu moved to disconnected queue\n",
 						         cmd, scmd_id(cmd), cmd->device->lun);
 
-						/* 
-						 * Restore phase bits to 0 so an interrupted selection, 
+						/*
+						 * Restore phase bits to 0 so an interrupted selection,
 						 * arbitration can resume.
 						 */
 						NCR5380_write(TARGET_COMMAND_REG, 0);
@@ -1913,14 +1913,14 @@ static void NCR5380_information_transfer
 						NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 						return;
 					}
-					/* 
+					/*
 					 * The SCSI data pointer is *IMPLICITLY* saved on a disconnect
-					 * operation, in violation of the SCSI spec so we can safely 
+					 * operation, in violation of the SCSI spec so we can safely
 					 * ignore SAVE/RESTORE pointers calls.
 					 *
-					 * Unfortunately, some disks violate the SCSI spec and 
+					 * Unfortunately, some disks violate the SCSI spec and
 					 * don't issue the required SAVE_POINTERS message before
-					 * disconnecting, and we have to break spec to remain 
+					 * disconnecting, and we have to break spec to remain
 					 * compatible.
 					 */
 				case SAVE_POINTERS:
@@ -1983,8 +1983,8 @@ static void NCR5380_information_transfer
 
 					/* Fall through to reject message */
 
-					/* 
-					 * If we get something weird that we aren't expecting, 
+					/*
+					 * If we get something weird that we aren't expecting,
 					 * reject it.
 					 */
 				default:
@@ -2021,10 +2021,10 @@ static void NCR5380_information_transfer
 			case PHASE_CMDOUT:
 				len = cmd->cmd_len;
 				data = cmd->cmnd;
-				/* 
-				 * XXX for performance reasons, on machines with a 
-				 * PSEUDO-DMA architecture we should probably 
-				 * use the dma transfer function.  
+				/*
+				 * XXX for performance reasons, on machines with a
+				 * PSEUDO-DMA architecture we should probably
+				 * use the dma transfer function.
 				 */
 				NCR5380_transfer_pio(instance, &phase, &len, &data);
 				break;
@@ -2049,10 +2049,10 @@ static void NCR5380_information_transfer
 /*
  * Function : void NCR5380_reselect (struct Scsi_Host *instance)
  *
- * Purpose : does reselection, initializing the instance->connected 
+ * Purpose : does reselection, initializing the instance->connected
  *      field to point to the scsi_cmnd for which the I_T_L or I_T_L_Q
  *      nexus has been reestablished,
- *      
+ *
  * Inputs : instance - this instance of the NCR5380.
  */
 
@@ -2077,7 +2077,7 @@ static void NCR5380_reselect(struct Scsi
 
 	dsprintk(NDEBUG_RESELECTION, instance, "reselect\n");
 
-	/* 
+	/*
 	 * At this point, we have detected that our SCSI ID is on the bus,
 	 * SEL is true and BSY was false for at least one bus settle delay
 	 * (400 ns).
@@ -2172,7 +2172,7 @@ static void NCR5380_reselect(struct Scsi
  * Function : void NCR5380_dma_complete (struct Scsi_Host *instance)
  *
  * Purpose : called by interrupt handler when DMA finishes or a phase
- *      mismatch occurs (which would finish the DMA transfer).  
+ *      mismatch occurs (which would finish the DMA transfer).
  *
  * Inputs : instance - this instance of the NCR5380.
  *
@@ -2190,7 +2190,7 @@ static void NCR5380_dma_complete(NCR5380
 	 *
 	 * Wait for final byte to transfer, ie wait for ACK to go false.
 	 *
-	 * We should use the Last Byte Sent bit, unfortunately this is 
+	 * We should use the Last Byte Sent bit, unfortunately this is
 	 * not available on the 5380/5381 (only the various CMOS chips)
 	 *
 	 * FIXME: timeout, and need to handle long timeout/irq case


