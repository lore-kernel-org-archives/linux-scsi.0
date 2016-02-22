From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 5/6] ncr5380: Fix NCR5380_select() EH checks and result handling
Date: Tue, 23 Feb 2016 10:07:08 +1100
Message-ID: <20160222230705.254682595@telegraphics.com.au>
References: <20160222230703.994951661@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-simplify-NCR5380_select-state
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Add missing checks for EH abort during arbitration and selection.
Rework the handling of NCR5380_select() result to improve clarity.

Fixes: 707d62b37fbb ("ncr5380: Fix EH during arbitration and selection")
Tested-by: Michael Schmitz <schmitzmic@gmail.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/NCR5380.c       |   16 +++++++++++-----
 drivers/scsi/atari_NCR5380.c |   16 +++++++++++-----
 2 files changed, 22 insertions(+), 10 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2016-02-23 10:07:00.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2016-02-23 10:07:01.000000000 +1100
@@ -815,15 +815,17 @@ static void NCR5380_main(struct work_str
 	struct NCR5380_hostdata *hostdata =
 		container_of(work, struct NCR5380_hostdata, main_task);
 	struct Scsi_Host *instance = hostdata->host;
-	struct scsi_cmnd *cmd;
 	int done;
 
 	do {
 		done = 1;
 
 		spin_lock_irq(&hostdata->lock);
-		while (!hostdata->connected &&
-		       (cmd = dequeue_next_cmd(instance))) {
+		while (!hostdata->connected && !hostdata->selecting) {
+			struct scsi_cmnd *cmd = dequeue_next_cmd(instance);
+
+			if (!cmd)
+				break;
 
 			dsprintk(NDEBUG_MAIN, instance, "main: dequeued %p\n", cmd);
 
@@ -840,8 +842,7 @@ static void NCR5380_main(struct work_str
 			 * entire unit.
 			 */
 
-			cmd = NCR5380_select(instance, cmd);
-			if (!cmd) {
+			if (!NCR5380_select(instance, cmd)) {
 				dsprintk(NDEBUG_MAIN, instance, "main: select complete\n");
 			} else {
 				dsprintk(NDEBUG_MAIN | NDEBUG_QUEUES, instance,
@@ -1056,6 +1057,11 @@ static struct scsi_cmnd *NCR5380_select(
 		/* Reselection interrupt */
 		goto out;
 	}
+	if (!hostdata->selecting) {
+		/* Command was aborted */
+		NCR5380_write(MODE_REG, MR_BASE);
+		goto out;
+	}
 	if (err < 0) {
 		NCR5380_write(MODE_REG, MR_BASE);
 		shost_printk(KERN_ERR, instance,
Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2016-02-23 10:07:00.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2016-02-23 10:07:01.000000000 +1100
@@ -923,7 +923,6 @@ static void NCR5380_main(struct work_str
 	struct NCR5380_hostdata *hostdata =
 		container_of(work, struct NCR5380_hostdata, main_task);
 	struct Scsi_Host *instance = hostdata->host;
-	struct scsi_cmnd *cmd;
 	int done;
 
 	/*
@@ -936,8 +935,11 @@ static void NCR5380_main(struct work_str
 		done = 1;
 
 		spin_lock_irq(&hostdata->lock);
-		while (!hostdata->connected &&
-		       (cmd = dequeue_next_cmd(instance))) {
+		while (!hostdata->connected && !hostdata->selecting) {
+			struct scsi_cmnd *cmd = dequeue_next_cmd(instance);
+
+			if (!cmd)
+				break;
 
 			dsprintk(NDEBUG_MAIN, instance, "main: dequeued %p\n", cmd);
 
@@ -960,8 +962,7 @@ static void NCR5380_main(struct work_str
 #ifdef SUPPORT_TAGS
 			cmd_get_tag(cmd, cmd->cmnd[0] != REQUEST_SENSE);
 #endif
-			cmd = NCR5380_select(instance, cmd);
-			if (!cmd) {
+			if (!NCR5380_select(instance, cmd)) {
 				dsprintk(NDEBUG_MAIN, instance, "main: select complete\n");
 				maybe_release_dma_irq(instance);
 			} else {
@@ -1257,6 +1258,11 @@ static struct scsi_cmnd *NCR5380_select(
 		/* Reselection interrupt */
 		goto out;
 	}
+	if (!hostdata->selecting) {
+		/* Command was aborted */
+		NCR5380_write(MODE_REG, MR_BASE);
+		goto out;
+	}
 	if (err < 0) {
 		NCR5380_write(MODE_REG, MR_BASE);
 		shost_printk(KERN_ERR, instance,
