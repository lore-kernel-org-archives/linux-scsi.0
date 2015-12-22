From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v3 62/77] ncr5380: Implement new eh_bus_reset_handler
Date: Tue, 22 Dec 2015 12:18:40 +1100
Message-ID: <20151222011754.875495600@telegraphics.com.au>
References: <20151222011737.980475848@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-new-eh_bus_reset_handler
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

NCR5380.c lacks a sane eh_bus_reset_handler. The atari_NCR5380.c code is
much better but it should not throw out the issue queue (that would be
a host reset) and it neglects to set the result code for commands that it
throws out. Fix these bugs and keep the two core drivers in sync.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/NCR5380.c       |   50 ++++++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/atari_NCR5380.c |   39 +++++++++++++++++++--------------
 2 files changed, 72 insertions(+), 17 deletions(-)

Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2015-12-22 12:17:07.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2015-12-22 12:17:09.000000000 +1100
@@ -2694,11 +2694,12 @@ static int NCR5380_bus_reset(struct scsi
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	int i;
 	unsigned long flags;
+	struct NCR5380_cmd *ncmd;
 
 	spin_lock_irqsave(&hostdata->lock, flags);
 
 #if (NDEBUG & NDEBUG_ANY)
-	scmd_printk(KERN_INFO, cmd, "performing bus reset\n");
+	scmd_printk(KERN_INFO, cmd, __func__);
 #endif
 	NCR5380_dprint(NDEBUG_ANY, instance);
 	NCR5380_dprint_phase(NDEBUG_ANY, instance);
@@ -2718,27 +2719,32 @@ static int NCR5380_bus_reset(struct scsi
 
 	hostdata->selecting = NULL;
 
-	if (hostdata->connected)
-		dsprintk(NDEBUG_ABORT, instance, "reset aborted a connected command\n");
-	hostdata->connected = NULL;
+	list_for_each_entry(ncmd, &hostdata->disconnected, list) {
+		struct scsi_cmnd *cmd = NCR5380_to_scmd(ncmd);
+
+		set_host_byte(cmd, DID_RESET);
+		cmd->scsi_done(cmd);
+	}
+
+	list_for_each_entry(ncmd, &hostdata->autosense, list) {
+		struct scsi_cmnd *cmd = NCR5380_to_scmd(ncmd);
+
+		set_host_byte(cmd, DID_RESET);
+		cmd->scsi_done(cmd);
+	}
+
+	if (hostdata->connected) {
+		set_host_byte(hostdata->connected, DID_RESET);
+		complete_cmd(instance, hostdata->connected);
+		hostdata->connected = NULL;
+	}
 
 	if (hostdata->sensing) {
+		set_host_byte(hostdata->connected, DID_RESET);
 		complete_cmd(instance, hostdata->sensing);
 		hostdata->sensing = NULL;
 	}
 
-	if (!list_empty(&hostdata->autosense))
-		dsprintk(NDEBUG_ABORT, instance, "reset aborted autosense list\n");
-	INIT_LIST_HEAD(&hostdata->autosense);
-
-	if (!list_empty(&hostdata->unissued))
-		dsprintk(NDEBUG_ABORT, instance, "reset aborted unissued list\n");
-	INIT_LIST_HEAD(&hostdata->unissued);
-
-	if (!list_empty(&hostdata->disconnected))
-		dsprintk(NDEBUG_ABORT, instance, "reset aborted disconnected list\n");
-	INIT_LIST_HEAD(&hostdata->disconnected);
-
 #ifdef SUPPORT_TAGS
 	free_all_tags(hostdata);
 #endif
@@ -2748,6 +2754,7 @@ static int NCR5380_bus_reset(struct scsi
 	hostdata->dma_len = 0;
 #endif
 
+	queue_work(hostdata->work_q, &hostdata->main_task);
 	maybe_release_dma_irq(instance);
 	spin_unlock_irqrestore(&hostdata->lock, flags);
 
Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2015-12-22 12:17:07.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2015-12-22 12:17:09.000000000 +1100
@@ -2482,18 +2482,66 @@ static int NCR5380_bus_reset(struct scsi
 {
 	struct Scsi_Host *instance = cmd->device->host;
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
+	int i;
 	unsigned long flags;
+	struct NCR5380_cmd *ncmd;
 
 	spin_lock_irqsave(&hostdata->lock, flags);
 
 #if (NDEBUG & NDEBUG_ANY)
-	scmd_printk(KERN_INFO, cmd, "performing bus reset\n");
+	scmd_printk(KERN_INFO, cmd, __func__);
 #endif
 	NCR5380_dprint(NDEBUG_ANY, instance);
 	NCR5380_dprint_phase(NDEBUG_ANY, instance);
 
 	do_reset(instance);
 
+	/* reset NCR registers */
+	NCR5380_write(MODE_REG, MR_BASE);
+	NCR5380_write(TARGET_COMMAND_REG, 0);
+	NCR5380_write(SELECT_ENABLE_REG, 0);
+
+	/* After the reset, there are no more connected or disconnected commands
+	 * and no busy units; so clear the low-level status here to avoid
+	 * conflicts when the mid-level code tries to wake up the affected
+	 * commands!
+	 */
+
+	hostdata->selecting = NULL;
+
+	list_for_each_entry(ncmd, &hostdata->disconnected, list) {
+		struct scsi_cmnd *cmd = NCR5380_to_scmd(ncmd);
+
+		set_host_byte(cmd, DID_RESET);
+		cmd->scsi_done(cmd);
+	}
+
+	list_for_each_entry(ncmd, &hostdata->autosense, list) {
+		struct scsi_cmnd *cmd = NCR5380_to_scmd(ncmd);
+
+		set_host_byte(cmd, DID_RESET);
+		cmd->scsi_done(cmd);
+	}
+
+	if (hostdata->connected) {
+		set_host_byte(hostdata->connected, DID_RESET);
+		complete_cmd(instance, hostdata->connected);
+		hostdata->connected = NULL;
+	}
+
+	if (hostdata->sensing) {
+		set_host_byte(hostdata->connected, DID_RESET);
+		complete_cmd(instance, hostdata->sensing);
+		hostdata->sensing = NULL;
+	}
+
+	for (i = 0; i < 8; ++i)
+		hostdata->busy[i] = 0;
+#ifdef REAL_DMA
+	hostdata->dma_len = 0;
+#endif
+
+	queue_work(hostdata->work_q, &hostdata->main_task);
 	spin_unlock_irqrestore(&hostdata->lock, flags);
 
 	return SUCCESS;
