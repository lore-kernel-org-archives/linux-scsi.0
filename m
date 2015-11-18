From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 69/71] ncr5380: Merge changes from atari_NCR5380.c
Date: Wed, 18 Nov 2015 19:36:04 +1100
Message-ID: <20151118083521.411167293@telegraphics.com.au>
References: <20151118083455.331768508@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-merge-trivia-from-atari_NCR5380
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In the past, NCR5380.c was overlooked by those working on atari_NCR5380.c
and this caused needless divergence. All of the changes in this patch were
taken from atari_NCR5380.c.

This removes some unimportant discrepancies between the two core driver
forks so that 'diff' can be used to reveal the important ones, to
facilitate reunification.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/NCR5380.c |  157 +++++++++++++++++++++++++++----------------------
 1 file changed, 89 insertions(+), 68 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2015-11-18 19:34:38.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2015-11-18 19:34:43.000000000 +1100
@@ -174,7 +174,7 @@ static int do_abort(struct Scsi_Host *);
 static void do_reset(struct Scsi_Host *);
 
 /**
- * initialize_SCp		-	init the scsi pointer field
+ * initialize_SCp - init the scsi pointer field
  * @cmd: command block to set up
  *
  * Set up the internal fields in the SCSI command.
@@ -275,19 +275,6 @@ static inline int NCR5380_poll_politely(
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
@@ -322,6 +309,7 @@ mrs[] = {
 	{MR_TARGET, "MODE TARGET"},
 	{MR_ENABLE_PAR_CHECK, "MODE PARITY CHECK"},
 	{MR_ENABLE_PAR_INTR, "MODE PARITY INTR"},
+	{MR_ENABLE_EOP_INTR, "MODE EOP INTR"},
 	{MR_MONITOR_BSY, "MODE MONITOR BSY"},
 	{MR_DMA_MODE, "MODE DMA"},
 	{MR_ARBITRATE, "MODE ARBITRATION"},
@@ -329,8 +317,8 @@ mrs[] = {
 };
 
 /**
- * NCR5380_print	-	print scsi bus signals
- * @instance:	adapter state to dump
+ * NCR5380_print - print scsi bus signals
+ * @instance: adapter state to dump
  *
  * Print the SCSI bus signals for debugging purposes
  */
@@ -364,9 +352,21 @@ static void NCR5380_print(struct Scsi_Ho
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
@@ -381,7 +381,9 @@ static void NCR5380_print_phase(struct S
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
@@ -523,7 +525,7 @@ static int __maybe_unused NCR5380_write_
 }
 
 static int __maybe_unused NCR5380_show_info(struct seq_file *m,
-	struct Scsi_Host *instance)
+                                            struct Scsi_Host *instance)
 {
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 
@@ -534,7 +536,7 @@ static int __maybe_unused NCR5380_show_i
 #endif
 
 /**
- * NCR5380_init	-	initialise an NCR5380
+ * NCR5380_init - initialise an NCR5380
  * @instance: adapter to configure
  * @flags: control flags
  *
@@ -542,7 +544,7 @@ static int __maybe_unused NCR5380_show_i
  * with flags OR'd into the initial flags value.
  *
  * Notes : I assume that the host, hostno, and id bits have been
- * set correctly.  I don't care about the irq and other fields.
+ * set correctly. I don't care about the irq and other fields.
  *
  * Returns 0 for success
  */
@@ -552,10 +554,9 @@ static int NCR5380_init(struct Scsi_Host
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	int i;
 
-	if(in_interrupt())
-		printk(KERN_ERR "NCR5380_init called with interrupts off!\n");
-
+	hostdata->host = instance;
 	hostdata->id_mask = 1 << instance->this_id;
+	hostdata->id_higher_mask = 0;
 	for (i = hostdata->id_mask; i <= 0x80; i <<= 1)
 		if (i > hostdata->id_mask)
 			hostdata->id_higher_mask |= i;
@@ -580,8 +581,6 @@ static int NCR5380_init(struct Scsi_Host
 	if (!hostdata->work_q)
 		return -ENOMEM;
 
-	hostdata->host = instance;
-
 	prepare_info(instance);
 
 #ifndef REAL_DMA
@@ -592,6 +591,7 @@ static int NCR5380_init(struct Scsi_Host
 	NCR5380_write(MODE_REG, MR_BASE);
 	NCR5380_write(TARGET_COMMAND_REG, 0);
 	NCR5380_write(SELECT_ENABLE_REG, 0);
+
 	return 0;
 }
 
@@ -648,8 +648,10 @@ static int NCR5380_maybe_reset_bus(struc
 }
 
 /**
- * NCR5380_exit	-	remove an NCR5380
+ * NCR5380_exit - remove an NCR5380
  * @instance: adapter to remove
+ *
+ * Assumes that no more work can be queued (e.g. by NCR5380_intr).
  */
 
 static void NCR5380_exit(struct Scsi_Host *instance)
@@ -714,7 +716,7 @@ static int NCR5380_queue_command(struct
 		cmd->scsi_done(cmd);
 		return 0;
 	}
-#endif				/* (NDEBUG & NDEBUG_NO_WRITE) */
+#endif /* (NDEBUG & NDEBUG_NO_WRITE) */
 
 	cmd->result = 0;
 
@@ -801,7 +803,7 @@ static void requeue_cmd(struct Scsi_Host
 }
 
 /**
- * NCR5380_main	-	NCR state machines
+ * NCR5380_main - NCR state machines
  *
  * NCR5380_main is a coroutine that runs as long as more work can
  * be done on the NCR5380 host adapters in a system.  Both
@@ -1067,7 +1069,9 @@ static struct scsi_cmnd *NCR5380_select(
 	udelay(3);
 
 	/* Check for lost arbitration */
-	if ((NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_LOST) || (NCR5380_read(CURRENT_SCSI_DATA_REG) & hostdata->id_higher_mask) || (NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_LOST)) {
+	if ((NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_LOST) ||
+	    (NCR5380_read(CURRENT_SCSI_DATA_REG) & hostdata->id_higher_mask) ||
+	    (NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_LOST)) {
 		NCR5380_write(MODE_REG, MR_BASE);
 		dsprintk(NDEBUG_ARBITRATION, instance, "lost arbitration, deasserting MR_ARBITRATE\n");
 		spin_lock_irq(&hostdata->lock);
@@ -1092,6 +1096,7 @@ static struct scsi_cmnd *NCR5380_select(
 		spin_lock_irq(&hostdata->lock);
 		goto out;
 	}
+
 	/*
 	 * Again, bus clear + bus settle time is 1.2us, however, this is
 	 * a minimum so we'll udelay ceil(1.2)
@@ -1144,7 +1149,7 @@ static struct scsi_cmnd *NCR5380_select(
 	 * The initiator shall then wait at least two deskew delays and release
 	 * the BSY signal.
 	 */
-	udelay(1);		/* wingel -- wait two bus deskew delay >2*45ns */
+	udelay(1);        /* wingel -- wait two bus deskew delay >2*45ns */
 
 	/* Reset BSY */
 	NCR5380_write(INITIATOR_COMMAND_REG, (ICR_BASE | ICR_ASSERT_DATA | ICR_ASSERT_ATN | ICR_ASSERT_SEL));
@@ -1281,7 +1286,7 @@ out:
  * bytes to transfer, **data - pointer to data pointer.
  *
  * Returns : -1 when different phase is entered without transferring
- * maximum number of bytes, 0 if all bytes or transferred or exit
+ * maximum number of bytes, 0 if all bytes are transferred or exit
  * is in same phase.
  *
  * Also, *phase, *count, *data are modified in place.
@@ -1295,7 +1300,10 @@ out:
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
@@ -1306,7 +1314,7 @@ static int NCR5380_transfer_pio(struct S
 	 * REGISTER match the STATUS REGISTER
 	 */
 
-	 NCR5380_write(TARGET_COMMAND_REG, PHASE_SR_TO_TCR(p));
+	NCR5380_write(TARGET_COMMAND_REG, PHASE_SR_TO_TCR(p));
 
 	do {
 		/*
@@ -1325,6 +1333,7 @@ static int NCR5380_transfer_pio(struct S
 			NCR5380_dprint_phase(NDEBUG_PIO, instance);
 			break;
 		}
+
 		/* Do actual transfer from SCSI bus to / from memory */
 		if (!(p & SR_IO))
 			NCR5380_write(OUTPUT_DATA_REG, *d);
@@ -1462,12 +1471,14 @@ static int do_abort(struct Scsi_Host *in
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
@@ -1506,7 +1517,11 @@ timeout:
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
@@ -1517,8 +1532,6 @@ static int NCR5380_transfer_dma(struct S
 	unsigned char saved_data = 0, overrun = 0, residue;
 #endif
 
-	struct NCR5380_hostdata *hostdata = shost_priv(instance);
-
 	if ((tmp = (NCR5380_read(STATUS_REG) & PHASE_MASK)) != p) {
 		*phase = tmp;
 		return -1;
@@ -1748,7 +1761,8 @@ static int NCR5380_transfer_dma(struct S
  * to recover from an unexpected bus free condition.
  */
 
-static void NCR5380_information_transfer(struct Scsi_Host *instance) {
+static void NCR5380_information_transfer(struct Scsi_Host *instance)
+{
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	unsigned char msgout = NOP;
 	int sink = 0;
@@ -1775,11 +1789,13 @@ static void NCR5380_information_transfer
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
@@ -1805,6 +1821,7 @@ static void NCR5380_information_transfer
 					         cmd->SCp.this_residual,
 					         cmd->SCp.buffers_residual);
 				}
+
 				/*
 				 * The preferred transfer method is going to be
 				 * PSEUDO-DMA for systems that are strictly PIO,
@@ -1823,13 +1840,15 @@ static void NCR5380_information_transfer
 
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
@@ -1905,25 +1924,24 @@ static void NCR5380_information_transfer
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
@@ -2013,15 +2031,17 @@ static void NCR5380_information_transfer
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
@@ -2056,7 +2076,7 @@ static void NCR5380_information_transfer
 			default:
 				shost_printk(KERN_ERR, instance, "unknown phase\n");
 				NCR5380_dprint(NDEBUG_ANY, instance);
-			}	/* switch(phase) */
+			} /* switch(phase) */
 		} else {
 			spin_unlock_irq(&hostdata->lock);
 			NCR5380_poll_politely(instance, STATUS_REG, SR_REQ, SR_REQ, HZ);
@@ -2075,7 +2095,8 @@ static void NCR5380_information_transfer
  * Inputs : instance - this instance of the NCR5380.
  */
 
-static void NCR5380_reselect(struct Scsi_Host *instance) {
+static void NCR5380_reselect(struct Scsi_Host *instance)
+{
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	unsigned char target_mask;
 	unsigned char lun, phase;
@@ -2172,8 +2193,8 @@ static void NCR5380_reselect(struct Scsi
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
