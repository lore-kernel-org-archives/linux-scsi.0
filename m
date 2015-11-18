From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 61/71] ncr5380: Fix EH during arbitration and selection
Date: Wed, 18 Nov 2015 19:35:56 +1100
Message-ID: <20151118083516.944145264@telegraphics.com.au>
References: <20151118083455.331768508@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-fix-abort-during-select
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

During arbitration and selection, the relevant command is invisible to
exception handlers and can be found only in a pointer on the stack of a
different thread.

When eh_abort_handler can't find a given command, it can't decide whether
that command was completed already or is still in arbitration or selection
phase. But it must return either SUCCESS (e.g. command completed earlier)
or FAILED (could not abort the nexus, try bus reset).

The solution is to make sure all commands belonging to the LLD are always
visible to exception handlers. Add another scsi_cmnd pointer to the
hostdata struct to track the command in arbitration or selection phase.

Replace 'retain_dma_irq' with the new 'selecting' pointer, to bring
atari_NCR5380.c into line with NCR5380.c.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/NCR5380.c       |   78 +++++++++++++++++++++++++++++----------
 drivers/scsi/NCR5380.h       |    4 +-
 drivers/scsi/atari_NCR5380.c |   84 +++++++++++++++++++++++++++++++------------
 3 files changed, 121 insertions(+), 45 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2015-11-18 19:34:27.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2015-11-18 19:34:29.000000000 +1100
@@ -908,9 +908,9 @@ static void NCR5380_main(struct work_str
 			 * entire unit.
 			 */
 
-			if (!NCR5380_select(instance, cmd)) {
-				dsprintk(NDEBUG_MAIN, instance, "main: selected target %d for command %p\n",
-				         scmd_id(cmd), cmd);
+			cmd = NCR5380_select(instance, cmd);
+			if (!cmd) {
+				dsprintk(NDEBUG_MAIN, instance, "main: select complete\n");
 			} else {
 				dsprintk(NDEBUG_MAIN | NDEBUG_QUEUES, instance,
 				         "main: select failed, returning %p to queue\n", cmd);
@@ -1057,9 +1057,9 @@ static irqreturn_t NCR5380_intr(int irq,
  * Inputs : instance - instantiation of the 5380 driver on which this 
  *      target lives, cmd - SCSI command to execute.
  * 
- * Returns : -1 if selection failed but should be retried.
- *      0 if selection failed and should not be retried.
- *      0 if selection succeeded completely (hostdata->connected == cmd).
+ * Returns cmd if selection failed but should be retried,
+ * NULL if selection failed and should not be retried, or
+ * NULL if selection succeeded (hostdata->connected == cmd).
  *
  * Side effects : 
  *      If bus busy, arbitration failed, etc, NCR5380_select() will exit 
@@ -1077,7 +1077,8 @@ static irqreturn_t NCR5380_intr(int irq,
  *	Locks: caller holds hostdata lock in IRQ mode
  */
  
-static int NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *cmd)
+static struct scsi_cmnd *NCR5380_select(struct Scsi_Host *instance,
+                                        struct scsi_cmnd *cmd)
 {
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	unsigned char tmp[3], phase;
@@ -1088,6 +1089,15 @@ static int NCR5380_select(struct Scsi_Ho
 	NCR5380_dprint(NDEBUG_ARBITRATION, instance);
 	dprintk(NDEBUG_ARBITRATION, "scsi%d : starting arbitration, id = %d\n", instance->host_no, instance->this_id);
 
+	/*
+	 * Arbitration and selection phases are slow and involve dropping the
+	 * lock, so we have to watch out for EH. An exception handler may
+	 * change 'selecting' to NULL. This function will then return NULL
+	 * so that the caller will forget about 'cmd'. (During information
+	 * transfer phases, EH may change 'connected' to NULL.)
+	 */
+	hostdata->selecting = cmd;
+
 	/* 
 	 * Set the phase bits to 0, otherwise the NCR5380 won't drive the 
 	 * data bus during SELECTION.
@@ -1113,13 +1123,13 @@ static int NCR5380_select(struct Scsi_Ho
 	spin_lock_irq(&hostdata->lock);
 	if (!(NCR5380_read(MODE_REG) & MR_ARBITRATE)) {
 		/* Reselection interrupt */
-		return -1;
+		goto out;
 	}
 	if (err < 0) {
 		NCR5380_write(MODE_REG, MR_BASE);
 		shost_printk(KERN_ERR, instance,
 		             "select: arbitration timeout\n");
-		return -1;
+		goto out;
 	}
 	spin_unlock_irq(&hostdata->lock);
 
@@ -1131,7 +1141,7 @@ static int NCR5380_select(struct Scsi_Ho
 		NCR5380_write(MODE_REG, MR_BASE);
 		dprintk(NDEBUG_ARBITRATION, "scsi%d : lost arbitration, deasserting MR_ARBITRATE\n", instance->host_no);
 		spin_lock_irq(&hostdata->lock);
-		return -1;
+		goto out;
 	}
 
 	/* After/during arbitration, BSY should be asserted.
@@ -1150,7 +1160,7 @@ static int NCR5380_select(struct Scsi_Ho
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 		dsprintk(NDEBUG_ARBITRATION, instance, "arbitration lost, negating SEL\n");
 		spin_lock_irq(&hostdata->lock);
-		return -1;
+		goto out;
 	}
 	/* 
 	 * Again, bus clear + bus settle time is 1.2us, however, this is 
@@ -1166,7 +1176,13 @@ static int NCR5380_select(struct Scsi_Ho
 
 	/* NCR5380_reselect() clears MODE_REG after a reselection interrupt */
 	if (!(NCR5380_read(MODE_REG) & MR_ARBITRATE))
-		return -1;
+		goto out;
+
+	if (!hostdata->selecting) {
+		NCR5380_write(MODE_REG, MR_BASE);
+		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
+		goto out;
+	}
 
 	dprintk(NDEBUG_ARBITRATION, "scsi%d : won arbitration\n", instance->host_no);
 
@@ -1239,18 +1255,21 @@ static int NCR5380_select(struct Scsi_Ho
 		if (!hostdata->connected)
 			NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 		printk("scsi%d : reselection after won arbitration?\n", instance->host_no);
-		return -1;
+		goto out;
 	}
 
 	if (err < 0) {
 		spin_lock_irq(&hostdata->lock);
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-		cmd->result = DID_BAD_TARGET << 16;
-		complete_cmd(instance, cmd);
 		NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
-		dprintk(NDEBUG_SELECTION, "scsi%d : target did not respond within 250ms\n",
-		        instance->host_no);
-		return 0;
+		/* Can't touch cmd if it has been reclaimed by the scsi ML */
+		if (hostdata->selecting) {
+			cmd->result = DID_BAD_TARGET << 16;
+			complete_cmd(instance, cmd);
+			dsprintk(NDEBUG_SELECTION, instance, "target did not respond within 250ms\n");
+			cmd = NULL;
+		}
+		goto out;
 	}
 
 	/* 
@@ -1286,7 +1305,11 @@ static int NCR5380_select(struct Scsi_Ho
 		shost_printk(KERN_ERR, instance, "select: REQ timeout\n");
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 		NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
-		return -1;
+		goto out;
+	}
+	if (!hostdata->selecting) {
+		do_abort(instance);
+		goto out;
 	}
 
 	dprintk(NDEBUG_SELECTION, "scsi%d : target %d selected, going into MESSAGE OUT phase.\n", instance->host_no, cmd->device->id);
@@ -1307,7 +1330,13 @@ static int NCR5380_select(struct Scsi_Ho
 
 	initialize_SCp(cmd);
 
-	return 0;
+	cmd = NULL;
+
+out:
+	if (!hostdata->selecting)
+		return NULL;
+	hostdata->selecting = NULL;
+	return cmd;
 }
 
 /* 
@@ -2359,6 +2388,15 @@ static int NCR5380_abort(struct scsi_cmn
 		cmd->scsi_done(cmd); /* No tag or busy flag to worry about */
 	}
 
+	if (hostdata->selecting == cmd) {
+		dsprintk(NDEBUG_ABORT, instance,
+		         "abort: cmd %p == selecting\n", cmd);
+		hostdata->selecting = NULL;
+		cmd->result = DID_ABORT << 16;
+		complete_cmd(instance, cmd);
+		goto out;
+	}
+
 	if (list_del_cmd(&hostdata->disconnected, cmd)) {
 		dsprintk(NDEBUG_ABORT, instance,
 		         "abort: removed %p from disconnected list\n", cmd);
Index: linux/drivers/scsi/NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/NCR5380.h	2015-11-18 19:34:24.000000000 +1100
+++ linux/drivers/scsi/NCR5380.h	2015-11-18 19:34:29.000000000 +1100
@@ -256,6 +256,7 @@ struct NCR5380_hostdata {
 #endif
 	unsigned char last_message;		/* last message OUT */
 	struct scsi_cmnd *connected;		/* currently connected cmnd */
+	struct scsi_cmnd *selecting;		/* cmnd to be connected */
 	struct list_head unissued;		/* waiting to be issued */
 	struct list_head autosense;		/* priority issue queue */
 	struct list_head disconnected;		/* waiting for reconnect */
@@ -266,7 +267,6 @@ struct NCR5380_hostdata {
 	char info[256];
 	int read_overruns;                /* number of bytes to cut from a
 	                                   * transfer to handle chip overruns */
-	int retain_dma_intr;
 	struct work_struct main_task;
 #ifdef SUPPORT_TAGS
 	struct tag_alloc TagAlloc[8][8];	/* 8 targets and 8 LUNs */
@@ -329,7 +329,7 @@ static irqreturn_t NCR5380_intr(int irq,
 static void NCR5380_main(struct work_struct *work);
 static const char *NCR5380_info(struct Scsi_Host *instance);
 static void NCR5380_reselect(struct Scsi_Host *instance);
-static int NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *cmd);
+static struct scsi_cmnd *NCR5380_select(struct Scsi_Host *, struct scsi_cmnd *);
 #if defined(PSEUDO_DMA) || defined(REAL_DMA) || defined(REAL_DMA_POLL)
 static int NCR5380_transfer_dma(struct Scsi_Host *instance, unsigned char *phase, int *count, unsigned char **data);
 #endif
Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2015-11-18 19:34:27.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2015-11-18 19:34:29.000000000 +1100
@@ -882,7 +882,7 @@ static inline void maybe_release_dma_irq
 	    list_empty(&hostdata->unissued) &&
 	    list_empty(&hostdata->autosense) &&
 	    !hostdata->connected &&
-	    !hostdata->retain_dma_intr)
+	    !hostdata->selecting)
 		NCR5380_release_dma_irq(instance);
 }
 
@@ -1003,14 +1003,11 @@ static void NCR5380_main(struct work_str
 #ifdef SUPPORT_TAGS
 			cmd_get_tag(cmd, cmd->cmnd[0] != REQUEST_SENSE);
 #endif
-			hostdata->retain_dma_intr++;
-			if (!NCR5380_select(instance, cmd)) {
-				dsprintk(NDEBUG_MAIN, instance, "main: selected target %d for command %p\n",
-				         scmd_id(cmd), cmd);
-				hostdata->retain_dma_intr--;
+			cmd = NCR5380_select(instance, cmd);
+			if (!cmd) {
+				dsprintk(NDEBUG_MAIN, instance, "main: select complete\n");
 				maybe_release_dma_irq(instance);
 			} else {
-				hostdata->retain_dma_intr--;
 				dsprintk(NDEBUG_MAIN | NDEBUG_QUEUES, instance,
 				         "main: select failed, returning %p to queue\n", cmd);
 				requeue_cmd(instance, cmd);
@@ -1238,9 +1235,9 @@ static irqreturn_t NCR5380_intr(int irq,
  * Inputs : instance - instantiation of the 5380 driver on which this
  *	target lives, cmd - SCSI command to execute.
  *
- * Returns : -1 if selection failed but should be retried.
- *      0 if selection failed and should not be retried.
- *      0 if selection succeeded completely (hostdata->connected == cmd).
+ * Returns cmd if selection failed but should be retried,
+ * NULL if selection failed and should not be retried, or
+ * NULL if selection succeeded (hostdata->connected == cmd).
  *
  * Side effects :
  *	If bus busy, arbitration failed, etc, NCR5380_select() will exit
@@ -1256,7 +1253,8 @@ static irqreturn_t NCR5380_intr(int irq,
  *		cmd->result host byte set to DID_BAD_TARGET.
  */
 
-static int NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *cmd)
+static struct scsi_cmnd *NCR5380_select(struct Scsi_Host *instance,
+                                        struct scsi_cmnd *cmd)
 {
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	unsigned char tmp[3], phase;
@@ -1269,6 +1267,15 @@ static int NCR5380_select(struct Scsi_Ho
 		   instance->this_id);
 
 	/*
+	 * Arbitration and selection phases are slow and involve dropping the
+	 * lock, so we have to watch out for EH. An exception handler may
+	 * change 'selecting' to NULL. This function will then return NULL
+	 * so that the caller will forget about 'cmd'. (During information
+	 * transfer phases, EH may change 'connected' to NULL.)
+	 */
+	hostdata->selecting = cmd;
+
+	/*
 	 * Set the phase bits to 0, otherwise the NCR5380 won't drive the
 	 * data bus during SELECTION.
 	 */
@@ -1293,13 +1300,13 @@ static int NCR5380_select(struct Scsi_Ho
 	spin_lock_irq(&hostdata->lock);
 	if (!(NCR5380_read(MODE_REG) & MR_ARBITRATE)) {
 		/* Reselection interrupt */
-		return -1;
+		goto out;
 	}
 	if (err < 0) {
 		NCR5380_write(MODE_REG, MR_BASE);
 		shost_printk(KERN_ERR, instance,
 		             "select: arbitration timeout\n");
-		return -1;
+		goto out;
 	}
 	spin_unlock_irq(&hostdata->lock);
 
@@ -1314,7 +1321,7 @@ static int NCR5380_select(struct Scsi_Ho
 		dprintk(NDEBUG_ARBITRATION, "scsi%d: lost arbitration, deasserting MR_ARBITRATE\n",
 			   HOSTNO);
 		spin_lock_irq(&hostdata->lock);
-		return -1;
+		goto out;
 	}
 
 	/* After/during arbitration, BSY should be asserted.
@@ -1333,7 +1340,7 @@ static int NCR5380_select(struct Scsi_Ho
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 		dsprintk(NDEBUG_ARBITRATION, instance, "arbitration lost, negating SEL\n");
 		spin_lock_irq(&hostdata->lock);
-		return -1;
+		goto out;
 	}
 
 	/*
@@ -1350,7 +1357,13 @@ static int NCR5380_select(struct Scsi_Ho
 
 	/* NCR5380_reselect() clears MODE_REG after a reselection interrupt */
 	if (!(NCR5380_read(MODE_REG) & MR_ARBITRATE))
-		return -1;
+		goto out;
+
+	if (!hostdata->selecting) {
+		NCR5380_write(MODE_REG, MR_BASE);
+		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
+		goto out;
+	}
 
 	dprintk(NDEBUG_ARBITRATION, "scsi%d: won arbitration\n", HOSTNO);
 
@@ -1426,17 +1439,21 @@ static int NCR5380_select(struct Scsi_Ho
 			NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 		printk(KERN_ERR "scsi%d: reselection after won arbitration?\n",
 		       HOSTNO);
-		return -1;
+		goto out;
 	}
 
 	if (err < 0) {
 		spin_lock_irq(&hostdata->lock);
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-		cmd->result = DID_BAD_TARGET << 16;
-		complete_cmd(instance, cmd);
 		NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
-		dprintk(NDEBUG_SELECTION, "scsi%d: target did not respond within 250ms\n", HOSTNO);
-		return 0;
+		/* Can't touch cmd if it has been reclaimed by the scsi ML */
+		if (hostdata->selecting) {
+			cmd->result = DID_BAD_TARGET << 16;
+			complete_cmd(instance, cmd);
+			dsprintk(NDEBUG_SELECTION, instance, "target did not respond within 250ms\n");
+			cmd = NULL;
+		}
+		goto out;
 	}
 
 	/*
@@ -1472,7 +1489,11 @@ static int NCR5380_select(struct Scsi_Ho
 		shost_printk(KERN_ERR, instance, "select: REQ timeout\n");
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 		NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
-		return -1;
+		goto out;
+	}
+	if (!hostdata->selecting) {
+		do_abort(instance);
+		goto out;
 	}
 
 	dprintk(NDEBUG_SELECTION, "scsi%d: target %d selected, going into MESSAGE OUT phase.\n",
@@ -1508,7 +1529,13 @@ static int NCR5380_select(struct Scsi_Ho
 
 	initialize_SCp(cmd);
 
-	return 0;
+	cmd = NULL;
+
+out:
+	if (!hostdata->selecting)
+		return NULL;
+	hostdata->selecting = NULL;
+	return cmd;
 }
 
 /*
@@ -2572,6 +2599,15 @@ static int NCR5380_abort(struct scsi_cmn
 		cmd->scsi_done(cmd); /* No tag or busy flag to worry about */
 	}
 
+	if (hostdata->selecting == cmd) {
+		dsprintk(NDEBUG_ABORT, instance,
+		         "abort: cmd %p == selecting\n", cmd);
+		hostdata->selecting = NULL;
+		cmd->result = DID_ABORT << 16;
+		complete_cmd(instance, cmd);
+		goto out;
+	}
+
 	if (list_del_cmd(&hostdata->disconnected, cmd)) {
 		dsprintk(NDEBUG_ABORT, instance,
 		         "abort: removed %p from disconnected list\n", cmd);
@@ -2689,6 +2725,8 @@ static int NCR5380_bus_reset(struct scsi
 	 * commands!
 	 */
 
+	hostdata->selecting = NULL;
+
 	if (hostdata->connected)
 		dsprintk(NDEBUG_ABORT, instance, "reset aborted a connected command\n");
 	hostdata->connected = NULL;
