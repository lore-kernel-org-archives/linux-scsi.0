From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v4 69/78] ncr5380: Fix whitespace in comments using regexp
Date: Sun, 03 Jan 2016 16:06:10 +1100
Message-ID: <20160103050520.752909053@telegraphics.com.au>
References: <20160103050501.042035135@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-regexp-comment-whitespace
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hanging indentation was a poor choice for the text inside comments. It
has been used in the wrong places and done badly elsewhere. There is
little consistency within any file. One fork of the core driver uses
tabs for this indentation while the other uses spaces. Better to use
flush-left alignment throughout.

This patch is the result of the following substitution. It replaces tabs
and spaces at the start of a comment line with a single space.

perl -i -pe 's,^(\t*[/ ]\*)[ \t]+,$1 ,' drivers/scsi/{atari_,}NCR5380.c 

This removes some unimportant discrepancies between the two core driver
forks so that the important ones become obvious, to facilitate
reunification.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Tested-by: Ondrej Zary <linux@rainbow-software.org>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>

---
 drivers/scsi/NCR5380.c       |  206 +++++++++++++++++++++----------------------
 drivers/scsi/atari_NCR5380.c |  108 +++++++++++-----------
 2 files changed, 157 insertions(+), 157 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2016-01-03 16:04:42.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2016-01-03 16:04:44.000000000 +1100
@@ -1,15 +1,15 @@
 /*
  * NCR 5380 generic driver routines.  These should make it *trivial*
- *      to implement 5380 SCSI drivers under Linux with a non-trantor
- *      architecture.
+ * to implement 5380 SCSI drivers under Linux with a non-trantor
+ * architecture.
  *
- *      Note that these routines also work with NR53c400 family chips.
+ * Note that these routines also work with NR53c400 family chips.
  *
  * Copyright 1993, Drew Eckhardt
- *      Visionary Computing
- *      (Unix and Linux consulting and custom programming)
- *      drew@colorado.edu
- *      +1 (303) 666-5836
+ * Visionary Computing
+ * (Unix and Linux consulting and custom programming)
+ * drew@colorado.edu
+ * +1 (303) 666-5836
  *
  * For more information, please consult
  *
@@ -32,15 +32,15 @@
 /*
  * Further development / testing that should be done :
  * 1.  Cleanup the NCR5380_transfer_dma function and DMA operation complete
- *     code so that everything does the same thing that's done at the
- *     end of a pseudo-DMA read operation.
+ * code so that everything does the same thing that's done at the
+ * end of a pseudo-DMA read operation.
  *
  * 2.  Fix REAL_DMA (interrupt driven, polled works fine) -
- *     basically, transfer size needs to be reduced by one
- *     and the last byte read as is done with PSEUDO_DMA.
+ * basically, transfer size needs to be reduced by one
+ * and the last byte read as is done with PSEUDO_DMA.
  *
  * 4.  Test SCSI-II tagged queueing (I have no devices which support
- *      tagged queueing)
+ * tagged queueing)
  */
 
 #ifndef notyet
@@ -118,24 +118,24 @@
  *
  * These macros control options :
  * AUTOPROBE_IRQ - if defined, the NCR5380_probe_irq() function will be
- *      defined.
+ * defined.
  *
  * AUTOSENSE - if defined, REQUEST SENSE will be performed automatically
- *      for commands that return with a CHECK CONDITION status.
+ * for commands that return with a CHECK CONDITION status.
  *
  * DIFFERENTIAL - if defined, NCR53c81 chips will use external differential
- *      transceivers.
+ * transceivers.
  *
  * DONT_USE_INTR - if defined, never use interrupts, even if we probe or
- *      override-configure an IRQ.
+ * override-configure an IRQ.
  *
  * PSEUDO_DMA - if defined, PSEUDO DMA is used during the data transfer phases.
  *
  * REAL_DMA - if defined, REAL DMA is used during the data transfer phases.
  *
  * REAL_DMA_POLL - if defined, REAL DMA is used but the driver doesn't
- *      rely on phase mismatch and EOP interrupts to determine end
- *      of phase.
+ * rely on phase mismatch and EOP interrupts to determine end
+ * of phase.
  *
  * These macros MUST be defined :
  *
@@ -144,17 +144,17 @@
  * NCR5380_write(register, value) - write to the specific register
  *
  * NCR5380_implementation_fields  - additional fields needed for this
- *      specific implementation of the NCR5380
+ * specific implementation of the NCR5380
  *
  * Either real DMA *or* pseudo DMA may be implemented
  * REAL functions :
  * NCR5380_REAL_DMA should be defined if real DMA is to be used.
  * Note that the DMA setup functions should return the number of bytes
- *      that they were able to program the controller for.
+ * that they were able to program the controller for.
  *
  * Also note that generic i386/PC versions of these macros are
- *      available as NCR5380_i386_dma_write_setup,
- *      NCR5380_i386_dma_read_setup, and NCR5380_i386_dma_residual.
+ * available as NCR5380_i386_dma_write_setup,
+ * NCR5380_i386_dma_read_setup, and NCR5380_i386_dma_residual.
  *
  * NCR5380_dma_write_setup(instance, src, count) - initialize
  * NCR5380_dma_read_setup(instance, dst, count) - initialize
@@ -174,10 +174,10 @@ static int do_abort(struct Scsi_Host *);
 static void do_reset(struct Scsi_Host *);
 
 /**
- *	initialize_SCp		-	init the scsi pointer field
- *	@cmd: command block to set up
+ * initialize_SCp		-	init the scsi pointer field
+ * @cmd: command block to set up
  *
- *	Set up the internal fields in the SCSI command.
+ * Set up the internal fields in the SCSI command.
  */
 
 static inline void initialize_SCp(struct scsi_cmnd *cmd)
@@ -318,10 +318,10 @@ mrs[] = {
 };
 
 /**
- *	NCR5380_print	-	print scsi bus signals
- *	@instance:	adapter state to dump
+ * NCR5380_print	-	print scsi bus signals
+ * @instance:	adapter state to dump
  *
- *	Print the SCSI bus signals for debugging purposes
+ * Print the SCSI bus signals for debugging purposes
  */
 
 static void NCR5380_print(struct Scsi_Host *instance)
@@ -355,10 +355,10 @@ static void NCR5380_print(struct Scsi_Ho
 
 
 /**
- *	NCR5380_print_phase	-	show SCSI phase
- *	@instance: adapter to dump
+ * NCR5380_print_phase	-	show SCSI phase
+ * @instance: adapter to dump
  *
- * 	Print the current SCSI phase for debugging purposes
+ * Print the current SCSI phase for debugging purposes
  */
 
 static void NCR5380_print_phase(struct Scsi_Host *instance)
@@ -380,13 +380,13 @@ static void NCR5380_print_phase(struct S
 static int probe_irq __initdata;
 
 /**
- *	probe_intr	-	helper for IRQ autoprobe
- *	@irq: interrupt number
- *	@dev_id: unused
- *	@regs: unused
+ * probe_intr	-	helper for IRQ autoprobe
+ * @irq: interrupt number
+ * @dev_id: unused
+ * @regs: unused
  *
- *	Set a flag to indicate the IRQ in question was received. This is
- *	used by the IRQ probe code.
+ * Set a flag to indicate the IRQ in question was received. This is
+ * used by the IRQ probe code.
  */
 
 static irqreturn_t __init probe_intr(int irq, void *dev_id)
@@ -396,12 +396,12 @@ static irqreturn_t __init probe_intr(int
 }
 
 /**
- *	NCR5380_probe_irq	-	find the IRQ of an NCR5380
- *	@instance: NCR5380 controller
- *	@possible: bitmask of ISA IRQ lines
+ * NCR5380_probe_irq	-	find the IRQ of an NCR5380
+ * @instance: NCR5380 controller
+ * @possible: bitmask of ISA IRQ lines
  *
- *	Autoprobe for the IRQ line used by the NCR5380 by triggering an IRQ
- *	and then looking to see what interrupt actually turned up.
+ * Autoprobe for the IRQ line used by the NCR5380 by triggering an IRQ
+ * and then looking to see what interrupt actually turned up.
  */
 
 static int __init __maybe_unused NCR5380_probe_irq(struct Scsi_Host *instance,
@@ -447,10 +447,10 @@ static int __init __maybe_unused NCR5380
 }
 
 /**
- *	NCR58380_info - report driver and host information
- *	@instance: relevant scsi host instance
+ * NCR58380_info - report driver and host information
+ * @instance: relevant scsi host instance
  *
- *	For use as the host template info() handler.
+ * For use as the host template info() handler.
  */
 
 static const char *NCR5380_info(struct Scsi_Host *instance)
@@ -522,17 +522,17 @@ static int __maybe_unused NCR5380_show_i
 #endif
 
 /**
- *	NCR5380_init	-	initialise an NCR5380
- *	@instance: adapter to configure
- *	@flags: control flags
+ * NCR5380_init	-	initialise an NCR5380
+ * @instance: adapter to configure
+ * @flags: control flags
  *
- *	Initializes *instance and corresponding 5380 chip,
- *      with flags OR'd into the initial flags value.
+ * Initializes *instance and corresponding 5380 chip,
+ * with flags OR'd into the initial flags value.
  *
- *	Notes : I assume that the host, hostno, and id bits have been
- *      set correctly.  I don't care about the irq and other fields.
+ * Notes : I assume that the host, hostno, and id bits have been
+ * set correctly.  I don't care about the irq and other fields.
  *
- *	Returns 0 for success
+ * Returns 0 for success
  */
 
 static int NCR5380_init(struct Scsi_Host *instance, int flags)
@@ -648,8 +648,8 @@ static int NCR5380_maybe_reset_bus(struc
 }
 
 /**
- *	NCR5380_exit	-	remove an NCR5380
- *	@instance: adapter to remove
+ * NCR5380_exit	-	remove an NCR5380
+ * @instance: adapter to remove
  */
 
 static void NCR5380_exit(struct Scsi_Host *instance)
@@ -801,12 +801,12 @@ static void requeue_cmd(struct Scsi_Host
 }
 
 /**
- *	NCR5380_main	-	NCR state machines
+ * NCR5380_main	-	NCR state machines
  *
- *	NCR5380_main is a coroutine that runs as long as more work can
- *      be done on the NCR5380 host adapters in a system.  Both
- *      NCR5380_queue_command() and NCR5380_intr() will try to start it
- *      in case it is not running.
+ * NCR5380_main is a coroutine that runs as long as more work can
+ * be done on the NCR5380 host adapters in a system.  Both
+ * NCR5380_queue_command() and NCR5380_intr() will try to start it
+ * in case it is not running.
  */
 
 static void NCR5380_main(struct work_struct *work)
@@ -979,31 +979,31 @@ static irqreturn_t NCR5380_intr(int irq,
 
 /*
  * Function : int NCR5380_select(struct Scsi_Host *instance,
- *                               struct scsi_cmnd *cmd)
+ * struct scsi_cmnd *cmd)
  *
  * Purpose : establishes I_T_L or I_T_L_Q nexus for new or existing command,
- *      including ARBITRATION, SELECTION, and initial message out for
- *      IDENTIFY and queue messages.
+ * including ARBITRATION, SELECTION, and initial message out for
+ * IDENTIFY and queue messages.
  *
  * Inputs : instance - instantiation of the 5380 driver on which this
- *      target lives, cmd - SCSI command to execute.
+ * target lives, cmd - SCSI command to execute.
  *
  * Returns cmd if selection failed but should be retried,
  * NULL if selection failed and should not be retried, or
  * NULL if selection succeeded (hostdata->connected == cmd).
  *
  * Side effects :
- *      If bus busy, arbitration failed, etc, NCR5380_select() will exit
- *              with registers as they should have been on entry - ie
- *              SELECT_ENABLE will be set appropriately, the NCR5380
- *              will cease to drive any SCSI bus signals.
- *
- *      If successful : I_T_L or I_T_L_Q nexus will be established,
- *              instance->connected will be set to cmd.
- *              SELECT interrupt will be disabled.
+ * If bus busy, arbitration failed, etc, NCR5380_select() will exit
+ * with registers as they should have been on entry - ie
+ * SELECT_ENABLE will be set appropriately, the NCR5380
+ * will cease to drive any SCSI bus signals.
+ *
+ * If successful : I_T_L or I_T_L_Q nexus will be established,
+ * instance->connected will be set to cmd.
+ * SELECT interrupt will be disabled.
  *
- *      If failed (no target) : cmd->scsi_done() will be called, and the
- *              cmd->result host byte set to DID_BAD_TARGET.
+ * If failed (no target) : cmd->scsi_done() will be called, and the
+ * cmd->result host byte set to DID_BAD_TARGET.
  */
 
 static struct scsi_cmnd *NCR5380_select(struct Scsi_Host *instance,
@@ -1212,8 +1212,8 @@ static struct scsi_cmnd *NCR5380_select(
 	 * until it wraps back to 0.
 	 *
 	 * XXX - it turns out that there are some broken SCSI-II devices,
-	 *       which claim to support tagged queuing but fail when more than
-	 *       some number of commands are issued at once.
+	 * which claim to support tagged queuing but fail when more than
+	 * some number of commands are issued at once.
 	 */
 
 	/* Wait for start of REQ/ACK handshake */
@@ -1261,19 +1261,19 @@ out:
 
 /*
  * Function : int NCR5380_transfer_pio (struct Scsi_Host *instance,
- *      unsigned char *phase, int *count, unsigned char **data)
+ * unsigned char *phase, int *count, unsigned char **data)
  *
  * Purpose : transfers data in given phase using polled I/O
  *
  * Inputs : instance - instance of driver, *phase - pointer to
- *      what phase is expected, *count - pointer to number of
- *      bytes to transfer, **data - pointer to data pointer.
+ * what phase is expected, *count - pointer to number of
+ * bytes to transfer, **data - pointer to data pointer.
  *
  * Returns : -1 when different phase is entered without transferring
- *      maximum number of bytes, 0 if all bytes or transferred or exit
- *      is in same phase.
+ * maximum number of bytes, 0 if all bytes or transferred or exit
+ * is in same phase.
  *
- *      Also, *phase, *count, *data are modified in place.
+ * Also, *phase, *count, *data are modified in place.
  *
  * XXX Note : handling for bus free may be useful.
  */
@@ -1353,11 +1353,11 @@ static int NCR5380_transfer_pio(struct S
 /*
  * We have several special cases to consider during REQ/ACK handshaking :
  * 1.  We were in MSGOUT phase, and we are on the last byte of the
- *      message.  ATN must be dropped as ACK is dropped.
+ * message.  ATN must be dropped as ACK is dropped.
  *
  * 2.  We are in a MSGIN phase, and we are on the last byte of the
- *      message.  We must exit with ACK asserted, so that the calling
- *      code may raise ATN before dropping ACK to reject the message.
+ * message.  We must exit with ACK asserted, so that the calling
+ * code may raise ATN before dropping ACK to reject the message.
  *
  * 3.  ACK and ATN are clear and the target may proceed as normal.
  */
@@ -1478,20 +1478,20 @@ timeout:
 #if defined(REAL_DMA) || defined(PSEUDO_DMA) || defined (REAL_DMA_POLL)
 /*
  * Function : int NCR5380_transfer_dma (struct Scsi_Host *instance,
- *      unsigned char *phase, int *count, unsigned char **data)
+ * unsigned char *phase, int *count, unsigned char **data)
  *
  * Purpose : transfers data in given phase using either real
- *      or pseudo DMA.
+ * or pseudo DMA.
  *
  * Inputs : instance - instance of driver, *phase - pointer to
- *      what phase is expected, *count - pointer to number of
- *      bytes to transfer, **data - pointer to data pointer.
+ * what phase is expected, *count - pointer to number of
+ * bytes to transfer, **data - pointer to data pointer.
  *
  * Returns : -1 when different phase is entered without transferring
- *      maximum number of bytes, 0 if all bytes or transferred or exit
- *      is in same phase.
+ * maximum number of bytes, 0 if all bytes or transferred or exit
+ * is in same phase.
  *
- *      Also, *phase, *count, *data are modified in place.
+ * Also, *phase, *count, *data are modified in place.
  */
 
 
@@ -1547,8 +1547,8 @@ static int NCR5380_transfer_dma(struct S
 	dprintk(NDEBUG_DMA, "scsi%d : mode reg = 0x%X\n", instance->host_no, NCR5380_read(MODE_REG));
 
 	/*
-	 *	On the PAS16 at least I/O recovery delays are not needed here.
-	 *	Everyone else seems to want them.
+	 * On the PAS16 at least I/O recovery delays are not needed here.
+	 * Everyone else seems to want them.
 	 */
 
 	if (p & SR_IO) {
@@ -1724,17 +1724,17 @@ static int NCR5380_transfer_dma(struct S
  * Function : NCR5380_information_transfer (struct Scsi_Host *instance)
  *
  * Purpose : run through the various SCSI phases and do as the target
- *      directs us to.  Operates on the currently connected command,
- *      instance->connected.
+ * directs us to.  Operates on the currently connected command,
+ * instance->connected.
  *
  * Inputs : instance, instance for which we are doing commands
  *
  * Side effects : SCSI things happen, the disconnected queue will be
- *      modified if a command disconnects, *instance->connected will
- *      change.
+ * modified if a command disconnects, *instance->connected will
+ * change.
  *
  * XXX Note : we need to watch for bus free or a reset condition here
- *      to recover from an unexpected bus free condition.
+ * to recover from an unexpected bus free condition.
  */
 
 static void NCR5380_information_transfer(struct Scsi_Host *instance) {
@@ -2050,8 +2050,8 @@ static void NCR5380_information_transfer
  * Function : void NCR5380_reselect (struct Scsi_Host *instance)
  *
  * Purpose : does reselection, initializing the instance->connected
- *      field to point to the scsi_cmnd for which the I_T_L or I_T_L_Q
- *      nexus has been reestablished,
+ * field to point to the scsi_cmnd for which the I_T_L or I_T_L_Q
+ * nexus has been reestablished,
  *
  * Inputs : instance - this instance of the NCR5380.
  */
@@ -2172,12 +2172,12 @@ static void NCR5380_reselect(struct Scsi
  * Function : void NCR5380_dma_complete (struct Scsi_Host *instance)
  *
  * Purpose : called by interrupt handler when DMA finishes or a phase
- *      mismatch occurs (which would finish the DMA transfer).
+ * mismatch occurs (which would finish the DMA transfer).
  *
  * Inputs : instance - this instance of the NCR5380.
  *
  * Returns : pointer to the scsi_cmnd structure for which the I_T_L
- *      nexus has been reestablished, on failure NULL is returned.
+ * nexus has been reestablished, on failure NULL is returned.
  */
 
 #ifdef REAL_DMA
Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2016-01-03 16:04:40.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2016-01-03 16:04:44.000000000 +1100
@@ -1,15 +1,15 @@
 /*
  * NCR 5380 generic driver routines.  These should make it *trivial*
- *	to implement 5380 SCSI drivers under Linux with a non-trantor
- *	architecture.
+ * to implement 5380 SCSI drivers under Linux with a non-trantor
+ * architecture.
  *
- *	Note that these routines also work with NR53c400 family chips.
+ * Note that these routines also work with NR53c400 family chips.
  *
  * Copyright 1993, Drew Eckhardt
- *	Visionary Computing
- *	(Unix and Linux consulting and custom programming)
- *	drew@colorado.edu
- *	+1 (303) 666-5836
+ * Visionary Computing
+ * (Unix and Linux consulting and custom programming)
+ * drew@colorado.edu
+ * +1 (303) 666-5836
  *
  * For more information, please consult
  *
@@ -93,10 +93,10 @@
  *
  * These macros control options :
  * AUTOSENSE - if defined, REQUEST SENSE will be performed automatically
- *	for commands that return with a CHECK CONDITION status.
+ * for commands that return with a CHECK CONDITION status.
  *
  * DIFFERENTIAL - if defined, NCR53c81 chips will use external differential
- *	transceivers.
+ * transceivers.
  *
  * REAL_DMA - if defined, REAL DMA is used during the data transfer phases.
  *
@@ -109,17 +109,17 @@
  * NCR5380_write(register, value) - write to the specific register
  *
  * NCR5380_implementation_fields  - additional fields needed for this
- *      specific implementation of the NCR5380
+ * specific implementation of the NCR5380
  *
  * Either real DMA *or* pseudo DMA may be implemented
  * REAL functions :
  * NCR5380_REAL_DMA should be defined if real DMA is to be used.
  * Note that the DMA setup functions should return the number of bytes
- *	that they were able to program the controller for.
+ * that they were able to program the controller for.
  *
  * Also note that generic i386/PC versions of these macros are
- *	available as NCR5380_i386_dma_write_setup,
- *	NCR5380_i386_dma_read_setup, and NCR5380_i386_dma_residual.
+ * available as NCR5380_i386_dma_write_setup,
+ * NCR5380_i386_dma_read_setup, and NCR5380_i386_dma_residual.
  *
  * NCR5380_dma_write_setup(instance, src, count) - initialize
  * NCR5380_dma_read_setup(instance, dst, count) - initialize
@@ -974,7 +974,7 @@ static void NCR5380_main(struct work_str
  * Function : void NCR5380_dma_complete (struct Scsi_Host *instance)
  *
  * Purpose : Called by interrupt handler when DMA finishes or a phase
- *	mismatch occurs (which would finish the DMA transfer).
+ * mismatch occurs (which would finish the DMA transfer).
  *
  * Inputs : instance - this instance of the NCR5380.
  */
@@ -1161,31 +1161,31 @@ static irqreturn_t NCR5380_intr(int irq,
 
 /*
  * Function : int NCR5380_select(struct Scsi_Host *instance,
- *                               struct scsi_cmnd *cmd)
+ * struct scsi_cmnd *cmd)
  *
  * Purpose : establishes I_T_L or I_T_L_Q nexus for new or existing command,
- *	including ARBITRATION, SELECTION, and initial message out for
- *	IDENTIFY and queue messages.
+ * including ARBITRATION, SELECTION, and initial message out for
+ * IDENTIFY and queue messages.
  *
  * Inputs : instance - instantiation of the 5380 driver on which this
- *	target lives, cmd - SCSI command to execute.
+ * target lives, cmd - SCSI command to execute.
  *
  * Returns cmd if selection failed but should be retried,
  * NULL if selection failed and should not be retried, or
  * NULL if selection succeeded (hostdata->connected == cmd).
  *
  * Side effects :
- *	If bus busy, arbitration failed, etc, NCR5380_select() will exit
- *		with registers as they should have been on entry - ie
- *		SELECT_ENABLE will be set appropriately, the NCR5380
- *		will cease to drive any SCSI bus signals.
- *
- *	If successful : I_T_L or I_T_L_Q nexus will be established,
- *		instance->connected will be set to cmd.
- *		SELECT interrupt will be disabled.
+ * If bus busy, arbitration failed, etc, NCR5380_select() will exit
+ * with registers as they should have been on entry - ie
+ * SELECT_ENABLE will be set appropriately, the NCR5380
+ * will cease to drive any SCSI bus signals.
+ *
+ * If successful : I_T_L or I_T_L_Q nexus will be established,
+ * instance->connected will be set to cmd.
+ * SELECT interrupt will be disabled.
  *
- *	If failed (no target) : cmd->scsi_done() will be called, and the
- *		cmd->result host byte set to DID_BAD_TARGET.
+ * If failed (no target) : cmd->scsi_done() will be called, and the
+ * cmd->result host byte set to DID_BAD_TARGET.
  */
 
 static struct scsi_cmnd *NCR5380_select(struct Scsi_Host *instance,
@@ -1398,8 +1398,8 @@ static struct scsi_cmnd *NCR5380_select(
 	 * until it wraps back to 0.
 	 *
 	 * XXX - it turns out that there are some broken SCSI-II devices,
-	 *	     which claim to support tagged queuing but fail when more than
-	 *	     some number of commands are issued at once.
+	 * which claim to support tagged queuing but fail when more than
+	 * some number of commands are issued at once.
 	 */
 
 	/* Wait for start of REQ/ACK handshake */
@@ -1461,19 +1461,19 @@ out:
 
 /*
  * Function : int NCR5380_transfer_pio (struct Scsi_Host *instance,
- *      unsigned char *phase, int *count, unsigned char **data)
+ * unsigned char *phase, int *count, unsigned char **data)
  *
  * Purpose : transfers data in given phase using polled I/O
  *
  * Inputs : instance - instance of driver, *phase - pointer to
- *	what phase is expected, *count - pointer to number of
- *	bytes to transfer, **data - pointer to data pointer.
+ * what phase is expected, *count - pointer to number of
+ * bytes to transfer, **data - pointer to data pointer.
  *
  * Returns : -1 when different phase is entered without transferring
- *	maximum number of bytes, 0 if all bytes are transferred or exit
- *	is in same phase.
+ * maximum number of bytes, 0 if all bytes are transferred or exit
+ * is in same phase.
  *
- *	Also, *phase, *count, *data are modified in place.
+ * Also, *phase, *count, *data are modified in place.
  *
  * XXX Note : handling for bus free may be useful.
  */
@@ -1560,11 +1560,11 @@ static int NCR5380_transfer_pio(struct S
 		/*
 		 * We have several special cases to consider during REQ/ACK handshaking :
 		 * 1.  We were in MSGOUT phase, and we are on the last byte of the
-		 *	message.  ATN must be dropped as ACK is dropped.
+		 * message.  ATN must be dropped as ACK is dropped.
 		 *
 		 * 2.  We are in a MSGIN phase, and we are on the last byte of the
-		 *	message.  We must exit with ACK asserted, so that the calling
-		 *	code may raise ATN before dropping ACK to reject the message.
+		 * message.  We must exit with ACK asserted, so that the calling
+		 * code may raise ATN before dropping ACK to reject the message.
 		 *
 		 * 3.  ACK and ATN are clear and the target may proceed as normal.
 		 */
@@ -1687,20 +1687,20 @@ timeout:
 #if defined(REAL_DMA)
 /*
  * Function : int NCR5380_transfer_dma (struct Scsi_Host *instance,
- *      unsigned char *phase, int *count, unsigned char **data)
+ * unsigned char *phase, int *count, unsigned char **data)
  *
  * Purpose : transfers data in given phase using either real
- *	or pseudo DMA.
+ * or pseudo DMA.
  *
  * Inputs : instance - instance of driver, *phase - pointer to
- *	what phase is expected, *count - pointer to number of
- *	bytes to transfer, **data - pointer to data pointer.
+ * what phase is expected, *count - pointer to number of
+ * bytes to transfer, **data - pointer to data pointer.
  *
  * Returns : -1 when different phase is entered without transferring
- *	maximum number of bytes, 0 if all bytes or transferred or exit
- *	is in same phase.
+ * maximum number of bytes, 0 if all bytes or transferred or exit
+ * is in same phase.
  *
- *	Also, *phase, *count, *data are modified in place.
+ * Also, *phase, *count, *data are modified in place.
  */
 
 
@@ -1799,17 +1799,17 @@ static int NCR5380_transfer_dma(struct S
  * Function : NCR5380_information_transfer (struct Scsi_Host *instance)
  *
  * Purpose : run through the various SCSI phases and do as the target
- *	directs us to.  Operates on the currently connected command,
- *	instance->connected.
+ * directs us to.  Operates on the currently connected command,
+ * instance->connected.
  *
  * Inputs : instance, instance for which we are doing commands
  *
  * Side effects : SCSI things happen, the disconnected queue will be
- *	modified if a command disconnects, *instance->connected will
- *	change.
+ * modified if a command disconnects, *instance->connected will
+ * change.
  *
  * XXX Note : we need to watch for bus free or a reset condition here
- *	to recover from an unexpected bus free condition.
+ * to recover from an unexpected bus free condition.
  */
 
 static void NCR5380_information_transfer(struct Scsi_Host *instance)
@@ -1919,7 +1919,7 @@ static void NCR5380_information_transfer
 				 */
 
 				/* ++roman: I suggest, this should be
-				 *   #if def(REAL_DMA)
+				 * #if def(REAL_DMA)
 				 * instead of leaving REAL_DMA out.
 				 */
 
@@ -2215,8 +2215,8 @@ static void NCR5380_information_transfer
  * Function : void NCR5380_reselect (struct Scsi_Host *instance)
  *
  * Purpose : does reselection, initializing the instance->connected
- *	field to point to the scsi_cmnd for which the I_T_L or I_T_L_Q
- *	nexus has been reestablished,
+ * field to point to the scsi_cmnd for which the I_T_L or I_T_L_Q
+ * nexus has been reestablished,
  *
  * Inputs : instance - this instance of the NCR5380.
  */
