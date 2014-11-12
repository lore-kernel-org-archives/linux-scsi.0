From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v3 32/37] atari_NCR5380: Merge from NCR5380.c
Date: Wed, 12 Nov 2014 16:12:18 +1100
Message-ID: <20141112051154.045479555@telegraphics.com.au>
References: <20141112051146.525489687@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:40989 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446AbaKLFnU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Nov 2014 00:43:20 -0500
Content-Disposition: inline; filename=atari_NCR5380-merge-from-NCR5380-comments-printk-etc
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org

The NCR5380.c core driver has moved on since the atari_NCR5380.c fork.
Some of those changes are also relevant to atari_NCR5380.c so apply them
there as well.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>

---
 drivers/scsi/atari_NCR5380.c |  209 +++++++++++++++++--------------------------
 1 file changed, 87 insertions(+), 122 deletions(-)

Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2014-11-12 16:11:35.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2014-11-12 16:11:38.000000000 +1100
@@ -104,27 +104,7 @@
 
 /*
  * Design
- * Issues :
  *
- * The other Linux SCSI drivers were written when Linux was Intel PC-only,
- * and specifically for each board rather than each chip.  This makes their
- * adaptation to platforms like the Mac (Some of which use NCR5380's)
- * more difficult than it has to be.
- *
- * Also, many of the SCSI drivers were written before the command queuing
- * routines were implemented, meaning their implementations of queued
- * commands were hacked on rather than designed in from the start.
- *
- * When I designed the Linux SCSI drivers I figured that
- * while having two different SCSI boards in a system might be useful
- * for debugging things, two of the same type wouldn't be used.
- * Well, I was wrong and a number of users have mailed me about running
- * multiple high-performance SCSI boards in a server.
- *
- * Finally, when I get questions from users, I have no idea what
- * revision of my driver they are running.
- *
- * This driver attempts to address these problems :
  * This is a generic 5380 driver.  To use it on a different platform,
  * one simply writes appropriate system specific macros (ie, data
  * transfer - some PC's will use the I/O bus, 68K's must use
@@ -139,11 +119,6 @@
  * allowing multiple commands to propagate all the way to a SCSI-II device
  * while a command is already executing.
  *
- * To solve the multiple-boards-in-the-same-system problem,
- * there is a separate instance structure for each instance
- * of a 5380 in the system.  So, multiple NCR5380 drivers will
- * be able to coexist with appropriate changes to the high level
- * SCSI code.
  *
  * Issues specific to the NCR5380 :
  *
@@ -168,19 +143,17 @@
  * Architecture :
  *
  * At the heart of the design is a coroutine, NCR5380_main,
- * which is started when not running by the interrupt handler,
- * timer, and queue command function.  It attempts to establish
- * I_T_L or I_T_L_Q nexuses by removing the commands from the
- * issue queue and calling NCR5380_select() if a nexus
- * is not established.
+ * which is started from a workqueue for each NCR5380 host in the
+ * system.  It attempts to establish I_T_L or I_T_L_Q nexuses by
+ * removing the commands from the issue queue and calling
+ * NCR5380_select() if a nexus is not established.
  *
  * Once a nexus is established, the NCR5380_information_transfer()
  * phase goes through the various phases as instructed by the target.
  * if the target goes into MSG IN and sends a DISCONNECT message,
  * the command structure is placed into the per instance disconnected
- * queue, and NCR5380_main tries to find more work.  If USLEEP
- * was defined, and the target is idle for too long, the system
- * will try to sleep.
+ * queue, and NCR5380_main tries to find more work.  If the target is
+ * idle for too long, the system will try to sleep.
  *
  * If a command has disconnected, eventually an interrupt will trigger,
  * calling NCR5380_intr()  which will in turn call NCR5380_reselect
@@ -206,6 +179,9 @@
  * AUTOSENSE - if defined, REQUEST SENSE will be performed automatically
  *	for commands that return with a CHECK CONDITION status.
  *
+ * DIFFERENTIAL - if defined, NCR53c81 chips will use external differential
+ *	transceivers.
+ *
  * LINKED - if defined, linked commands are supported.
  *
  * REAL_DMA - if defined, REAL DMA is used during the data transfer phases.
@@ -218,6 +194,9 @@
  *
  * NCR5380_write(register, value) - write to the specific register
  *
+ * NCR5380_implementation_fields  - additional fields needed for this
+ *      specific implementation of the NCR5380
+ *
  * Either real DMA *or* pseudo DMA may be implemented
  * REAL functions :
  * NCR5380_REAL_DMA should be defined if real DMA is to be used.
@@ -236,20 +215,6 @@
  * NCR5380_pwrite(instance, src, count)
  * NCR5380_pread(instance, dst, count);
  *
- * If nothing specific to this implementation needs doing (ie, with external
- * hardware), you must also define
- *
- * NCR5380_queue_command
- * NCR5380_reset
- * NCR5380_abort
- *
- * to be the global entry points into the specific driver, ie
- * #define NCR5380_queue_command t128_queue_command.
- *
- * If this is not done, the routines will be defined as static functions
- * with the NCR5380* names and the user must provide a globally
- * accessible wrapper function.
- *
  * The generic driver is initialized by calling NCR5380_init(instance),
  * after setting the appropriate host specific fields and ID.  If the
  * driver wishes to autoprobe for an IRQ line, the NCR5380_probe_irq(instance,
@@ -489,13 +454,11 @@ static void merge_contiguous_buffers(str
 #endif /* !defined(CONFIG_SUN3) */
 }
 
-/*
- * Function : void initialize_SCp(struct scsi_cmnd *cmd)
- *
- * Purpose : initialize the saved data pointers for cmd to point to the
- *	start of the buffer.
+/**
+ * initialize_SCp - init the scsi pointer field
+ * @cmd: command block to set up
  *
- * Inputs : cmd - scsi_cmnd structure to have pointers reset.
+ * Set up the internal fields in the SCSI command.
  */
 
 static inline void initialize_SCp(struct scsi_cmnd *cmd)
@@ -548,12 +511,11 @@ static struct {
 	{0, NULL}
 };
 
-/*
- * Function : void NCR5380_print(struct Scsi_Host *instance)
- *
- * Purpose : print the SCSI bus signals for debugging purposes
+/**
+ * NCR5380_print - print scsi bus signals
+ * @instance: adapter state to dump
  *
- * Input : instance - which NCR5380
+ * Print the SCSI bus signals for debugging purposes
  */
 
 static void NCR5380_print(struct Scsi_Host *instance)
@@ -596,12 +558,13 @@ static struct {
 	{PHASE_UNKNOWN, "UNKNOWN"}
 };
 
-/*
- * Function : void NCR5380_print_phase(struct Scsi_Host *instance)
+/**
+ * NCR5380_print_phase - show SCSI phase
+ * @instance: adapter to dump
  *
- * Purpose : print the current SCSI phase for debugging purposes
+ * Print the current SCSI phase for debugging purposes
  *
- * Input : instance - which NCR5380
+ * Locks: none
  */
 
 static void NCR5380_print_phase(struct Scsi_Host *instance)
@@ -710,13 +673,12 @@ static void prepare_info(struct Scsi_Hos
 	         "");
 }
 
-/*
- * Function : void NCR5380_print_status (struct Scsi_Host *instance)
- *
- * Purpose : print commands in the various queues, called from
- *	NCR5380_abort and NCR5380_debug to aid debugging.
+/**
+ * NCR5380_print_status - dump controller info
+ * @instance: controller to dump
  *
- * Inputs : instance, pointer to this instance.
+ * Print commands in the various queues, called from NCR5380_abort
+ * to aid debugging.
  */
 
 static void lprint_Scsi_Cmnd(struct scsi_cmnd *cmd)
@@ -807,16 +769,18 @@ static int __maybe_unused NCR5380_show_i
 	return 0;
 }
 
-/*
- * Function : void NCR5380_init (struct Scsi_Host *instance)
- *
- * Purpose : initializes *instance and corresponding 5380 chip.
+/**
+ * NCR5380_init - initialise an NCR5380
+ * @instance: adapter to configure
+ * @flags: control flags
  *
- * Inputs : instance - instantiation of the 5380 driver.
+ * Initializes *instance and corresponding 5380 chip,
+ * with flags OR'd into the initial flags value.
  *
  * Notes : I assume that the host, hostno, and id bits have been
- *	set correctly.  I don't care about the irq and other fields.
+ * set correctly. I don't care about the irq and other fields.
  *
+ * Returns 0 for success
  */
 
 static int __init NCR5380_init(struct Scsi_Host *instance, int flags)
@@ -861,27 +825,26 @@ static int __init NCR5380_init(struct Sc
 	return 0;
 }
 
+/**
+ * NCR5380_exit - remove an NCR5380
+ * @instance: adapter to remove
+ *
+ * Assumes that no more work can be queued (e.g. by NCR5380_intr).
+ */
+
 static void NCR5380_exit(struct Scsi_Host *instance)
 {
-	/* Empty, as we didn't schedule any delayed work */
+	cancel_work_sync(&NCR5380_tqueue);
 }
 
-/*
- * Function : int NCR5380_queue_command (struct scsi_cmnd *cmd,
- *	void (*done)(struct scsi_cmnd *))
- *
- * Purpose :  enqueues a SCSI command
- *
- * Inputs : cmd - SCSI command, done - function called on completion, with
- *	a pointer to the command descriptor.
- *
- * Returns : 0
- *
- * Side effects :
- *      cmd is added to the per instance issue_queue, with minor
- *	twiddling done to the host specific fields of cmd.  If the
- *	main coroutine is not running, it is restarted.
- *
+/**
+ * NCR5380_queue_command - queue a command
+ * @instance: the relevant SCSI adapter
+ * @cmd: SCSI command
+ *
+ * cmd is added to the per instance issue_queue, with minor
+ * twiddling done to the host specific fields of cmd.  If the
+ * main coroutine is not running, it is restarted.
  */
 
 static int NCR5380_queue_command(struct Scsi_Host *instance,
@@ -935,6 +898,13 @@ static int NCR5380_queue_command(struct
 
 	local_irq_save(flags);
 
+	/*
+	 * Insert the cmd into the issue queue. Note that REQUEST SENSE
+	 * commands are added to the head of the queue since any command will
+	 * clear the contingent allegiance condition that exists and the
+	 * sense data is only guaranteed to be valid while the condition exists.
+	 */
+
 	if (!(hostdata->issue_queue) || (cmd->cmnd[0] == REQUEST_SENSE)) {
 		LIST(cmd, hostdata->issue_queue);
 		SET_NEXT(cmd, hostdata->issue_queue);
@@ -977,16 +947,15 @@ static inline void maybe_release_dma_irq
 		NCR5380_release_dma_irq(instance);
 }
 
-/*
- * Function : NCR5380_main (void)
+/**
+ * NCR5380_main - NCR state machines
  *
- * Purpose : NCR5380_main is a coroutine that runs as long as more work can
- *	be done on the NCR5380 host adapters in a system.  Both
- *	NCR5380_queue_command() and NCR5380_intr() will try to start it
- *	in case it is not running.
+ * NCR5380_main is a coroutine that runs as long as more work can
+ * be done on the NCR5380 host adapters in a system.  Both
+ * NCR5380_queue_command() and NCR5380_intr() will try to start it
+ * in case it is not running.
  *
- * NOTE : NCR5380_main exits with interrupts *disabled*, the caller should
- *  reenable them.  This prevents reentrancy and kernel stack overflow.
+ * Locks: called as its own thread with no locks held.
  */
 
 static void NCR5380_main(struct work_struct *work)
@@ -1239,15 +1208,14 @@ static void NCR5380_dma_complete(struct
 #endif /* REAL_DMA */
 
 
-/*
- * Function : void NCR5380_intr (int irq)
- *
- * Purpose : handle interrupts, reestablishing I_T_L or I_T_L_Q nexuses
- *	from the disconnected queue, and restarting NCR5380_main()
- *	as required.
- *
- * Inputs : int irq, irq that caused this interrupt.
- *
+/**
+ * NCR5380_intr - generic NCR5380 irq handler
+ * @irq: interrupt number
+ * @dev_id: device info
+ *
+ * Handle interrupts, reestablishing I_T_L or I_T_L_Q nexuses
+ * from the disconnected queue, and restarting NCR5380_main()
+ * as required.
  */
 
 static irqreturn_t NCR5380_intr(int irq, void *dev_id)
@@ -1540,7 +1508,7 @@ static int NCR5380_select(struct Scsi_Ho
 	 * selection.
 	 */
 
-	timeout = jiffies + 25;
+	timeout = jiffies + (250 * HZ / 1000);
 
 	/*
 	 * XXX very interesting - we're seeing a bounce where the BSY we
@@ -2123,9 +2091,8 @@ static void NCR5380_information_transfer
 						 * If the watchdog timer fires, all future
 						 * accesses to this device will use the
 						 * polled-IO. */
-						printk(KERN_NOTICE "scsi%d: switching target %d "
-							   "lun %llu to slow handshake\n", HOSTNO,
-							   cmd->device->id, cmd->device->lun);
+						scmd_printk(KERN_INFO, cmd,
+							"switching to slow handshake\n");
 						cmd->device->borken = 1;
 						NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE |
 							ICR_ASSERT_ATN);
@@ -2445,20 +2412,18 @@ static void NCR5380_information_transfer
 					 */
 				default:
 					if (!tmp) {
-						printk(KERN_DEBUG "scsi%d: rejecting message ", HOSTNO);
+						printk(KERN_INFO "scsi%d: rejecting message ",
+						       instance->host_no);
 						spi_print_msg(extended_msg);
 						printk("\n");
 					} else if (tmp != EXTENDED_MESSAGE)
-						printk(KERN_DEBUG "scsi%d: rejecting unknown "
-						       "message %02x from target %d, lun %llu\n",
-						       HOSTNO, tmp, cmd->device->id, cmd->device->lun);
+						scmd_printk(KERN_INFO, cmd,
+						            "rejecting unknown message %02x\n",
+						            tmp);
 					else
-						printk(KERN_DEBUG "scsi%d: rejecting unknown "
-						       "extended message "
-						       "code %02x, length %d from target %d, lun %llu\n",
-						       HOSTNO, extended_msg[1], extended_msg[0],
-						       cmd->device->id, cmd->device->lun);
-
+						scmd_printk(KERN_INFO, cmd,
+						            "rejecting unknown extended message code %02x, length %d\n",
+						            extended_msg[1], extended_msg[0]);
 
 					msgout = MESSAGE_REJECT;
 					NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_ATN);


