From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v3 69/77] ncr5380: Merge changes from atari_NCR5380.c
Date: Tue, 22 Dec 2015 12:18:47 +1100
Message-ID: <20151222011756.785537093@telegraphics.com.au>
References: <20151222011737.980475848@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:40485 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891AbbLVCbZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Dec 2015 21:31:25 -0500
Content-Disposition: inline; filename=ncr5380-merge-trivia-from-atari_NCR5380
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>

In the past, NCR5380.c was overlooked by those working on atari_NCR5380.c
and this caused needless divergence. All of the changes in this patch were
taken from atari_NCR5380.c.

This removes some unimportant discrepancies between the two core driver
forks so that 'diff' can be used to reveal the important ones, to
facilitate reunification.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/NCR5380.c |  155 +++++++++++++++++++++++++++----------------------
 1 file changed, 87 insertions(+), 68 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2015-12-22 12:17:19.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2015-12-22 12:17:23.000000000 +1100
@@ -174,7 +174,7 @@ static int do_abort(struct Scsi_Host *);
 static void do_reset(struct Scsi_Host *);
 
 /**
- * initialize_SCp		-	init the scsi pointer field
+ * initialize_SCp - init the scsi pointer field
  * @cmd: command block to set up
  *
  * Set up the internal fields in the SCSI command.
@@ -264,19 +264,6 @@ static inline int NCR5380_poll_politely(
 	                                        reg, bit, val, wait);
 }
 
-static struct {
-	unsigned char value;
-	const char *name;
-} phases[] __maybe_unused = {
-	{PHASE_DATAOUT, "DATAOUT"},
-	{PHASE_DATAIN, "DATAIN"},
-	{PHASE_CMDOUT, "CMDOUT"},
-	{PHASE_STATIN, "STATIN"},
-	{PHASE_MSGOUT, "MSGOUT"},
-	{PHASE_MSGIN, "MSGIN"},
-	{PHASE_UNKNOWN, "UNKNOWN"}
-};
-
 #if NDEBUG
 static struct {
 	unsigned char mask;
@@ -311,6 +298,7 @@ mrs[] = {
 	{MR_TARGET, "MODE TARGET"},
 	{MR_ENABLE_PAR_CHECK, "MODE PARITY CHECK"},
 	{MR_ENABLE_PAR_INTR, "MODE PARITY INTR"},
+	{MR_ENABLE_EOP_INTR, "MODE EOP INTR"},
 	{MR_MONITOR_BSY, "MODE MONITOR BSY"},
 	{MR_DMA_MODE, "MODE DMA"},
 	{MR_ARBITRATE, "MODE ARBITRATION"},
@@ -318,8 +306,8 @@ mrs[] = {
 };
 
 /**
- * NCR5380_print	-	print scsi bus signals
- * @instance:	adapter state to dump
+ * NCR5380_print - print scsi bus signals
+ * @instance: adapter state to dump
  *
  * Print the SCSI bus signals for debugging purposes
  */
@@ -353,9 +341,21 @@ static void NCR5380_print(struct Scsi_Ho
 	printk("\n");
 }
 
+static struct {
+	unsigned char value;
+	const char *name;
+} phases[] = {
+	{PHASE_DATAOUT, "DATAOUT"},
+	{PHASE_DATAIN, "DATAIN"},
+	{PHASE_CMDOUT, "CMDOUT"},
+	{PHASE_STATIN, "STATIN"},
+	{PHASE_MSGOUT, "MSGOUT"},
+	{PHASE_MSGIN, "MSGIN"},
+	{PHASE_UNKNOWN, "UNKNOWN"}
+};
 
 /**
- * NCR5380_print_phase	-	show SCSI phase
+ * NCR5380_print_phase - show SCSI phase
  * @instance: adapter to dump
  *
  * Print the current SCSI phase for debugging purposes
@@ -370,7 +370,9 @@ static void NCR5380_print_phase(struct S
 	if (!(status & SR_REQ))
 		shost_printk(KERN_DEBUG, instance, "REQ not asserted, phase unknown.\n");
 	else {
-		for (i = 0; (phases[i].value != PHASE_UNKNOWN) && (phases[i].value != (status & PHASE_MASK)); ++i);
+		for (i = 0; (phases[i].value != PHASE_UNKNOWN) &&
+		     (phases[i].value != (status & PHASE_MASK)); ++i)
+			;
 		shost_printk(KERN_DEBUG, instance, "phase %s\n", phases[i].name);
 	}
 }
@@ -511,7 +513,7 @@ static int __maybe_unused NCR5380_write_
 }
 
 static int __maybe_unused NCR5380_show_info(struct seq_file *m,
-	struct Scsi_Host *instance)
+                                            struct Scsi_Host *instance)
 {
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 
@@ -522,7 +524,7 @@ static int __maybe_unused NCR5380_show_i
 #endif
 
 /**
- * NCR5380_init	-	initialise an NCR5380
+ * NCR5380_init - initialise an NCR5380
  * @instance: adapter to configure
  * @flags: control flags
  *
@@ -530,7 +532,7 @@ static int __maybe_unused NCR5380_show_i
  * with flags OR'd into the initial flags value.
  *
  * Notes : I assume that the host, hostno, and id bits have been
- * set correctly.  I don't care about the irq and other fields.
+ * set correctly. I don't care about the irq and other fields.
  *
  * Returns 0 for success
  */
@@ -541,10 +543,9 @@ static int NCR5380_init(struct Scsi_Host
 	int i;
 	unsigned long deadline;
 
-	if(in_interrupt())
-		printk(KERN_ERR "NCR5380_init called with interrupts off!\n");
-
+	hostdata->host = instance;
 	hostdata->id_mask = 1 << instance->this_id;
+	hostdata->id_higher_mask = 0;
 	for (i = hostdata->id_mask; i <= 0x80; i <<= 1)
 		if (i > hostdata->id_mask)
 			hostdata->id_higher_mask |= i;
@@ -569,8 +570,6 @@ static int NCR5380_init(struct Scsi_Host
 	if (!hostdata->work_q)
 		return -ENOMEM;
 
-	hostdata->host = instance;
-
 	prepare_info(instance);
 
 	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
@@ -648,8 +647,10 @@ static int NCR5380_maybe_reset_bus(struc
 }
 
 /**
- * NCR5380_exit	-	remove an NCR5380
+ * NCR5380_exit - remove an NCR5380
  * @instance: adapter to remove
+ *
+ * Assumes that no more work can be queued (e.g. by NCR5380_intr).
  */
 
 static void NCR5380_exit(struct Scsi_Host *instance)
@@ -714,7 +715,7 @@ static int NCR5380_queue_command(struct
 		cmd->scsi_done(cmd);
 		return 0;
 	}
-#endif				/* (NDEBUG & NDEBUG_NO_WRITE) */
+#endif /* (NDEBUG & NDEBUG_NO_WRITE) */
 
 	cmd->result = 0;
 
@@ -801,7 +802,7 @@ static void requeue_cmd(struct Scsi_Host
 }
 
 /**
- * NCR5380_main	-	NCR state machines
+ * NCR5380_main - NCR state machines
  *
  * NCR5380_main is a coroutine that runs as long as more work can
  * be done on the NCR5380 host adapters in a system.  Both
@@ -1067,7 +1068,9 @@ static struct scsi_cmnd *NCR5380_select(
 	udelay(3);
 
 	/* Check for lost arbitration */
-	if ((NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_LOST) || (NCR5380_read(CURRENT_SCSI_DATA_REG) & hostdata->id_higher_mask) || (NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_LOST)) {
+	if ((NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_LOST) ||
+	    (NCR5380_read(CURRENT_SCSI_DATA_REG) & hostdata->id_higher_mask) ||
+	    (NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_LOST)) {
 		NCR5380_write(MODE_REG, MR_BASE);
 		dsprintk(NDEBUG_ARBITRATION, instance, "lost arbitration, deasserting MR_ARBITRATE\n");
 		spin_lock_irq(&hostdata->lock);
@@ -1133,7 +1136,7 @@ static struct scsi_cmnd *NCR5380_select(
 	 * The initiator shall then wait at least two deskew delays and release
 	 * the BSY signal.
 	 */
-	udelay(1);		/* wingel -- wait two bus deskew delay >2*45ns */
+	udelay(1);        /* wingel -- wait two bus deskew delay >2*45ns */
 
 	/* Reset BSY */
 	NCR5380_write(INITIATOR_COMMAND_REG, (ICR_BASE | ICR_ASSERT_DATA | ICR_ASSERT_ATN | ICR_ASSERT_SEL));
@@ -1270,7 +1273,7 @@ out:
  * bytes to transfer, **data - pointer to data pointer.
  *
  * Returns : -1 when different phase is entered without transferring
- * maximum number of bytes, 0 if all bytes or transferred or exit
+ * maximum number of bytes, 0 if all bytes are transferred or exit
  * is in same phase.
  *
  * Also, *phase, *count, *data are modified in place.
@@ -1284,7 +1287,10 @@ out:
  * counts, we will always do a pseudo DMA or DMA transfer.
  */
 
-static int NCR5380_transfer_pio(struct Scsi_Host *instance, unsigned char *phase, int *count, unsigned char **data) {
+static int NCR5380_transfer_pio(struct Scsi_Host *instance,
+				unsigned char *phase, int *count,
+				unsigned char **data)
+{
 	unsigned char p = *phase, tmp;
 	int c = *count;
 	unsigned char *d = *data;
@@ -1295,7 +1301,7 @@ static int NCR5380_transfer_pio(struct S
 	 * REGISTER match the STATUS REGISTER
 	 */
 
-	 NCR5380_write(TARGET_COMMAND_REG, PHASE_SR_TO_TCR(p));
+	NCR5380_write(TARGET_COMMAND_REG, PHASE_SR_TO_TCR(p));
 
 	do {
 		/*
@@ -1314,6 +1320,7 @@ static int NCR5380_transfer_pio(struct S
 			NCR5380_dprint_phase(NDEBUG_PIO, instance);
 			break;
 		}
+
 		/* Do actual transfer from SCSI bus to / from memory */
 		if (!(p & SR_IO))
 			NCR5380_write(OUTPUT_DATA_REG, *d);
@@ -1451,12 +1458,14 @@ static int do_abort(struct Scsi_Host *in
 	NCR5380_write(TARGET_COMMAND_REG, PHASE_SR_TO_TCR(tmp));
 
 	if (tmp != PHASE_MSGOUT) {
-		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_ATN | ICR_ASSERT_ACK);
+		NCR5380_write(INITIATOR_COMMAND_REG,
+		              ICR_BASE | ICR_ASSERT_ATN | ICR_ASSERT_ACK);
 		rc = NCR5380_poll_politely(instance, STATUS_REG, SR_REQ, 0, 3 * HZ);
 		if (rc < 0)
 			goto timeout;
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_ATN);
 	}
+
 	tmp = ABORT;
 	msgptr = &tmp;
 	len = 1;
@@ -1495,7 +1504,11 @@ timeout:
  */
 
 
-static int NCR5380_transfer_dma(struct Scsi_Host *instance, unsigned char *phase, int *count, unsigned char **data) {
+static int NCR5380_transfer_dma(struct Scsi_Host *instance,
+				unsigned char *phase, int *count,
+				unsigned char **data)
+{
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	register int c = *count;
 	register unsigned char p = *phase;
 	register unsigned char *d = *data;
@@ -1506,8 +1519,6 @@ static int NCR5380_transfer_dma(struct S
 	unsigned char saved_data = 0, overrun = 0, residue;
 #endif
 
-	struct NCR5380_hostdata *hostdata = shost_priv(instance);
-
 	if ((tmp = (NCR5380_read(STATUS_REG) & PHASE_MASK)) != p) {
 		*phase = tmp;
 		return -1;
@@ -1737,7 +1748,8 @@ static int NCR5380_transfer_dma(struct S
  * to recover from an unexpected bus free condition.
  */
 
-static void NCR5380_information_transfer(struct Scsi_Host *instance) {
+static void NCR5380_information_transfer(struct Scsi_Host *instance)
+{
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	unsigned char msgout = NOP;
 	int sink = 0;
@@ -1764,11 +1776,13 @@ static void NCR5380_information_transfer
 				NCR5380_write(TARGET_COMMAND_REG, PHASE_SR_TO_TCR(tmp));
 
 				NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_ATN | ICR_ASSERT_ACK);
-				while (NCR5380_read(STATUS_REG) & SR_REQ);
+				while (NCR5380_read(STATUS_REG) & SR_REQ)
+					;
 				NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_ATN);
 				sink = 0;
 				continue;
 			}
+
 			switch (phase) {
 			case PHASE_DATAOUT:
 #if (NDEBUG & NDEBUG_NO_DATAOUT)
@@ -1794,6 +1808,7 @@ static void NCR5380_information_transfer
 					         cmd->SCp.this_residual,
 					         cmd->SCp.buffers_residual);
 				}
+
 				/*
 				 * The preferred transfer method is going to be
 				 * PSEUDO-DMA for systems that are strictly PIO,
@@ -1812,13 +1827,15 @@ static void NCR5380_information_transfer
 
 				if (transfersize) {
 					len = transfersize;
-					if (NCR5380_transfer_dma(instance, &phase, &len, (unsigned char **) &cmd->SCp.ptr)) {
+					if (NCR5380_transfer_dma(instance, &phase,
+					    &len, (unsigned char **)&cmd->SCp.ptr)) {
 						/*
-						 * If the watchdog timer fires, all future accesses to this
-						 * device will use the polled-IO.
+						 * If the watchdog timer fires, all future
+						 * accesses to this device will use the
+						 * polled-IO.
 						 */
 						scmd_printk(KERN_INFO, cmd,
-							    "switching to slow handshake\n");
+							"switching to slow handshake\n");
 						cmd->device->borken = 1;
 						sink = 1;
 						do_abort(instance);
@@ -1894,25 +1911,24 @@ static void NCR5380_information_transfer
 						break;
 					}
 					break;
-				case DISCONNECT:{
-						/* Accept message by clearing ACK */
-						NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-						hostdata->connected = NULL;
-						list_add(&ncmd->list, &hostdata->disconnected);
-						dsprintk(NDEBUG_INFORMATION | NDEBUG_QUEUES,
-						         instance, "connected command %p for target %d lun %llu moved to disconnected queue\n",
-						         cmd, scmd_id(cmd), cmd->device->lun);
+				case DISCONNECT:
+					/* Accept message by clearing ACK */
+					NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
+					hostdata->connected = NULL;
+					list_add(&ncmd->list, &hostdata->disconnected);
+					dsprintk(NDEBUG_INFORMATION | NDEBUG_QUEUES,
+					         instance, "connected command %p for target %d lun %llu moved to disconnected queue\n",
+					         cmd, scmd_id(cmd), cmd->device->lun);
 
-						/*
-						 * Restore phase bits to 0 so an interrupted selection,
-						 * arbitration can resume.
-						 */
-						NCR5380_write(TARGET_COMMAND_REG, 0);
+					/*
+					 * Restore phase bits to 0 so an interrupted selection,
+					 * arbitration can resume.
+					 */
+					NCR5380_write(TARGET_COMMAND_REG, 0);
 
-						/* Enable reselect interrupts */
-						NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
-						return;
-					}
+					/* Enable reselect interrupts */
+					NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
+					return;
 					/*
 					 * The SCSI data pointer is *IMPLICITLY* saved on a disconnect
 					 * operation, in violation of the SCSI spec so we can safely
@@ -2002,15 +2018,17 @@ static void NCR5380_information_transfer
 						printk("\n");
 					} else if (tmp != EXTENDED_MESSAGE)
 						scmd_printk(KERN_INFO, cmd,
-							"rejecting unknown message %02x\n",tmp);
+						            "rejecting unknown message %02x\n",
+						            tmp);
 					else
 						scmd_printk(KERN_INFO, cmd,
-							"rejecting unknown extended message code %02x, length %d\n", extended_msg[1], extended_msg[0]);
+						            "rejecting unknown extended message code %02x, length %d\n",
+						            extended_msg[1], extended_msg[0]);
 
 					msgout = MESSAGE_REJECT;
 					NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_ATN);
 					break;
-				}	/* switch (tmp) */
+				} /* switch (tmp) */
 				break;
 			case PHASE_MSGOUT:
 				len = 1;
@@ -2045,7 +2063,7 @@ static void NCR5380_information_transfer
 			default:
 				shost_printk(KERN_ERR, instance, "unknown phase\n");
 				NCR5380_dprint(NDEBUG_ANY, instance);
-			}	/* switch(phase) */
+			} /* switch(phase) */
 		} else {
 			spin_unlock_irq(&hostdata->lock);
 			NCR5380_poll_politely(instance, STATUS_REG, SR_REQ, SR_REQ, HZ);
@@ -2064,7 +2082,8 @@ static void NCR5380_information_transfer
  * Inputs : instance - this instance of the NCR5380.
  */
 
-static void NCR5380_reselect(struct Scsi_Host *instance) {
+static void NCR5380_reselect(struct Scsi_Host *instance)
+{
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	unsigned char target_mask;
 	unsigned char lun, phase;
@@ -2161,8 +2180,8 @@ static void NCR5380_reselect(struct Scsi
 		shost_printk(KERN_ERR, instance, "target bitmask 0x%02x lun %d not in disconnected queue.\n",
 		             target_mask, lun);
 		/*
-		 * Since we have an established nexus that we can't do anything with,
-		 * we must abort it.
+		 * Since we have an established nexus that we can't do anything
+		 * with, we must abort it.
 		 */
 		do_abort(instance);
 		return;


