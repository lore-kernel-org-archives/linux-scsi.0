From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 11/71] ncr5380: Simplify bus reset handlers
Date: Wed, 18 Nov 2015 19:35:06 +1100
Message-ID: <20151118083458.141699017@telegraphics.com.au>
References: <20151118083455.331768508@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-cleanup-bus-reset-handler
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Make use of do_reset() in the bus reset handler in atari_NCR5380.c. The
version in NCR5380.c already does so. Keep them in sync.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---

Bus reset handlers in both core drivers still have serious problems for
EH purposes. Those problems are addressed later in this series.

---
 drivers/scsi/NCR5380.c       |   20 +++++++++++---------
 drivers/scsi/atari_NCR5380.c |   30 ++++++++++++------------------
 2 files changed, 23 insertions(+), 27 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2015-11-18 19:33:15.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2015-11-18 19:33:17.000000000 +1100
@@ -668,7 +668,7 @@ static void prepare_info(struct Scsi_Hos
  *	Locks: called functions disable irqs
  */
 
-static void NCR5380_print_status(struct Scsi_Host *instance)
+static void __maybe_unused NCR5380_print_status(struct Scsi_Host *instance)
 {
 	NCR5380_dprint(NDEBUG_ANY, instance);
 	NCR5380_dprint_phase(NDEBUG_ANY, instance);
@@ -2693,24 +2693,26 @@ static int NCR5380_abort(struct scsi_cmn
 }
 
 
-/* 
- * Function : int NCR5380_bus_reset (struct scsi_cmnd *cmd)
- * 
- * Purpose : reset the SCSI bus.
- *
- * Returns : SUCCESS
+/**
+ * NCR5380_bus_reset - reset the SCSI bus
+ * @cmd: SCSI command undergoing EH
  *
- * Locks: host lock taken by caller
+ * Returns SUCCESS
  */
 
 static int NCR5380_bus_reset(struct scsi_cmnd *cmd)
 {
 	struct Scsi_Host *instance = cmd->device->host;
 
+	spin_lock_irq(instance->host_lock);
+
+#if (NDEBUG & NDEBUG_ANY)
+	scmd_printk(KERN_INFO, cmd, "performing bus reset\n");
 	NCR5380_print_status(instance);
+#endif
 
-	spin_lock_irq(instance->host_lock);
 	do_reset(instance);
+
 	spin_unlock_irq(instance->host_lock);
 
 	return SUCCESS;
Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2015-11-18 19:33:15.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2015-11-18 19:33:17.000000000 +1100
@@ -719,7 +719,7 @@ static void lprint_Scsi_Cmnd(struct scsi
 	printk("\n");
 }
 
-static void NCR5380_print_status(struct Scsi_Host *instance)
+static void __maybe_unused NCR5380_print_status(struct Scsi_Host *instance)
 {
 	struct NCR5380_hostdata *hostdata;
 	struct scsi_cmnd *ptr;
@@ -2982,13 +2982,11 @@ int NCR5380_abort(struct scsi_cmnd *cmd)
 }
 
 
-/*
- * Function : int NCR5380_reset (struct scsi_cmnd *cmd)
- *
- * Purpose : reset the SCSI bus.
- *
- * Returns : SUCCESS or FAILURE
+/**
+ * NCR5380_bus_reset - reset the SCSI bus
+ * @cmd: SCSI command undergoing EH
  *
+ * Returns SUCCESS
  */
 
 static int NCR5380_bus_reset(struct scsi_cmnd *cmd)
@@ -2998,22 +2996,19 @@ static int NCR5380_bus_reset(struct scsi
 	int i;
 	unsigned long flags;
 
+	local_irq_save(flags);
+
+#if (NDEBUG & NDEBUG_ANY)
+	scmd_printk(KERN_INFO, cmd, "performing bus reset\n");
 	NCR5380_print_status(instance);
+#endif
+
+	do_reset(instance);
 
-	/* get in phase */
-	NCR5380_write(TARGET_COMMAND_REG,
-		      PHASE_SR_TO_TCR(NCR5380_read(STATUS_REG)));
-	/* assert RST */
-	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_RST);
-	udelay(40);
 	/* reset NCR registers */
-	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 	NCR5380_write(MODE_REG, MR_BASE);
 	NCR5380_write(TARGET_COMMAND_REG, 0);
 	NCR5380_write(SELECT_ENABLE_REG, 0);
-	/* ++roman: reset interrupt condition! otherwise no interrupts don't get
-	 * through anymore ... */
-	(void)NCR5380_read(RESET_PARITY_INTERRUPT_REG);
 
 	/* After the reset, there are no more connected or disconnected commands
 	 * and no busy units; so clear the low-level status here to avoid
@@ -3028,7 +3023,6 @@ static int NCR5380_bus_reset(struct scsi
 	if (hostdata->disconnected_queue)
 		dprintk(NDEBUG_ABORT, "scsi%d: reset aborted disconnected command(s)\n", H_NO(cmd));
 
-	local_irq_save(flags);
 	hostdata->issue_queue = NULL;
 	hostdata->connected = NULL;
 	hostdata->disconnected_queue = NULL;
