From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v4 52/78] ncr5380: Remove H_NO macro and introduce dsprintk
Date: Sun, 03 Jan 2016 16:05:53 +1100
Message-ID: <20160103050514.801912771@telegraphics.com.au>
References: <20160103050501.042035135@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=atari_NCR5380-remove-H_NO-and-introduce-dsprintk
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Replace all H_NO and some HOSTNO macros (both peculiar to atari_NCR5380.c)
with a new dsprintk macro that's more useful and more consistent. The new
macro avoids a lot of boilerplate in new code in subsequent patches. Keep
NCR5380.c in sync. Remaining HOSTNO macros are removed as side-effects
of subsequent patches.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Tested-by: Ondrej Zary <linux@rainbow-software.org>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>

---
 drivers/scsi/NCR5380.c       |    9 ++++---
 drivers/scsi/NCR5380.h       |    5 +++
 drivers/scsi/atari_NCR5380.c |   54 +++++++++++++++++++++----------------------
 3 files changed, 38 insertions(+), 30 deletions(-)

Index: linux/drivers/scsi/NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/NCR5380.h	2016-01-03 16:04:09.000000000 +1100
+++ linux/drivers/scsi/NCR5380.h	2016-01-03 16:04:14.000000000 +1100
@@ -285,6 +285,11 @@ struct NCR5380_hostdata {
 	do { if ((NDEBUG) & (flg)) \
 		printk(KERN_DEBUG fmt, ## __VA_ARGS__); } while (0)
 
+#define dsprintk(flg, host, fmt, ...) \
+	do { if ((NDEBUG) & (flg)) \
+		shost_printk(KERN_DEBUG, host, fmt, ## __VA_ARGS__); \
+	} while (0)
+
 #if NDEBUG
 #define NCR5380_dprint(flg, arg) \
 	do { if ((NDEBUG) & (flg)) NCR5380_print(arg); } while (0)
Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2016-01-03 16:04:12.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2016-01-03 16:04:14.000000000 +1100
@@ -207,7 +207,6 @@
 #define	NEXTADDR(cmd)		((struct scsi_cmnd **)&(cmd)->host_scribble)
 
 #define	HOSTNO		instance->host_no
-#define	H_NO(cmd)	(cmd)->device->host->host_no
 
 static int do_abort(struct Scsi_Host *);
 static void do_reset(struct Scsi_Host *);
@@ -280,7 +279,8 @@ static void __init init_tags(struct NCR5
 static int is_lun_busy(struct scsi_cmnd *cmd, int should_be_tagged)
 {
 	u8 lun = cmd->device->lun;
-	SETUP_HOSTDATA(cmd->device->host);
+	struct Scsi_Host *instance = cmd->device->host;
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 
 	if (hostdata->busy[cmd->device->id] & (1 << lun))
 		return 1;
@@ -290,8 +290,8 @@ static int is_lun_busy(struct scsi_cmnd
 		return 0;
 	if (hostdata->TagAlloc[scmd_id(cmd)][lun].nr_allocated >=
 	    hostdata->TagAlloc[scmd_id(cmd)][lun].queue_size) {
-		dprintk(NDEBUG_TAGS, "scsi%d: target %d lun %d: no free tags\n",
-			   H_NO(cmd), cmd->device->id, lun);
+		dsprintk(NDEBUG_TAGS, instance, "target %d lun %d: no free tags\n",
+		         scmd_id(cmd), lun);
 		return 1;
 	}
 	return 0;
@@ -306,7 +306,8 @@ static int is_lun_busy(struct scsi_cmnd
 static void cmd_get_tag(struct scsi_cmnd *cmd, int should_be_tagged)
 {
 	u8 lun = cmd->device->lun;
-	SETUP_HOSTDATA(cmd->device->host);
+	struct Scsi_Host *instance = cmd->device->host;
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 
 	/* If we or the target don't support tagged queuing, allocate the LUN for
 	 * an untagged command.
@@ -316,18 +317,16 @@ static void cmd_get_tag(struct scsi_cmnd
 	    !cmd->device->tagged_supported) {
 		cmd->tag = TAG_NONE;
 		hostdata->busy[cmd->device->id] |= (1 << lun);
-		dprintk(NDEBUG_TAGS, "scsi%d: target %d lun %d now allocated by untagged "
-			   "command\n", H_NO(cmd), cmd->device->id, lun);
+		dsprintk(NDEBUG_TAGS, instance, "target %d lun %d now allocated by untagged command\n",
+		         scmd_id(cmd), lun);
 	} else {
 		struct tag_alloc *ta = &hostdata->TagAlloc[scmd_id(cmd)][lun];
 
 		cmd->tag = find_first_zero_bit(ta->allocated, MAX_TAGS);
 		set_bit(cmd->tag, ta->allocated);
 		ta->nr_allocated++;
-		dprintk(NDEBUG_TAGS, "scsi%d: using tag %d for target %d lun %d "
-			   "(now %d tags in use)\n",
-			   H_NO(cmd), cmd->tag, cmd->device->id,
-			   lun, ta->nr_allocated);
+		dsprintk(NDEBUG_TAGS, instance, "using tag %d for target %d lun %d (%d tags allocated)\n",
+		         cmd->tag, scmd_id(cmd), lun, ta->nr_allocated);
 	}
 }
 
@@ -339,21 +338,22 @@ static void cmd_get_tag(struct scsi_cmnd
 static void cmd_free_tag(struct scsi_cmnd *cmd)
 {
 	u8 lun = cmd->device->lun;
-	SETUP_HOSTDATA(cmd->device->host);
+	struct Scsi_Host *instance = cmd->device->host;
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 
 	if (cmd->tag == TAG_NONE) {
 		hostdata->busy[cmd->device->id] &= ~(1 << lun);
-		dprintk(NDEBUG_TAGS, "scsi%d: target %d lun %d untagged cmd finished\n",
-			   H_NO(cmd), cmd->device->id, lun);
+		dsprintk(NDEBUG_TAGS, instance, "target %d lun %d untagged cmd freed\n",
+		         scmd_id(cmd), lun);
 	} else if (cmd->tag >= MAX_TAGS) {
-		printk(KERN_NOTICE "scsi%d: trying to free bad tag %d!\n",
-		       H_NO(cmd), cmd->tag);
+		shost_printk(KERN_NOTICE, instance,
+		             "trying to free bad tag %d!\n", cmd->tag);
 	} else {
 		struct tag_alloc *ta = &hostdata->TagAlloc[scmd_id(cmd)][lun];
 		clear_bit(cmd->tag, ta->allocated);
 		ta->nr_allocated--;
-		dprintk(NDEBUG_TAGS, "scsi%d: freed tag %d for target %d lun %d\n",
-			   H_NO(cmd), cmd->tag, cmd->device->id, lun);
+		dsprintk(NDEBUG_TAGS, instance, "freed tag %d for target %d lun %d\n",
+		         cmd->tag, scmd_id(cmd), lun);
 	}
 }
 
@@ -815,8 +815,7 @@ static int NCR5380_queue_command(struct
 	switch (cmd->cmnd[0]) {
 	case WRITE_6:
 	case WRITE_10:
-		printk(KERN_NOTICE "scsi%d: WRITE attempted with NO_WRITE debugging flag set\n",
-		       H_NO(cmd));
+		shost_printk(KERN_DEBUG, instance, "WRITE attempted with NDEBUG_NO_WRITE set\n");
 		cmd->result = (DID_ERROR << 16);
 		cmd->scsi_done(cmd);
 		return 0;
@@ -875,8 +874,8 @@ static int NCR5380_queue_command(struct
 	}
 	spin_unlock_irqrestore(&hostdata->lock, flags);
 
-	dprintk(NDEBUG_QUEUES, "scsi%d: command added to %s of queue\n", H_NO(cmd),
-		  (cmd->cmnd[0] == REQUEST_SENSE) ? "head" : "tail");
+	dsprintk(NDEBUG_QUEUES, instance, "command %p added to %s of queue\n",
+	         cmd, (cmd->cmnd[0] == REQUEST_SENSE) ? "head" : "tail");
 
 	/* Kick off command processing */
 	queue_work(hostdata->work_q, &hostdata->main_task);
@@ -2079,8 +2078,9 @@ static void NCR5380_information_transfer
 						LIST(cmd,hostdata->issue_queue);
 						SET_NEXT(cmd, hostdata->issue_queue);
 						hostdata->issue_queue = (struct scsi_cmnd *) cmd;
-						dprintk(NDEBUG_QUEUES, "scsi%d: REQUEST SENSE added to head of "
-							  "issue queue\n", H_NO(cmd));
+						dsprintk(NDEBUG_QUEUES, instance,
+						         "REQUEST SENSE cmd %p added to head of issue queue\n",
+						         cmd);
 					} else {
 						cmd->scsi_done(cmd);
 					}
@@ -2746,11 +2746,11 @@ static int NCR5380_bus_reset(struct scsi
 	 */
 
 	if (hostdata->issue_queue)
-		dprintk(NDEBUG_ABORT, "scsi%d: reset aborted issued command(s)\n", H_NO(cmd));
+		dsprintk(NDEBUG_ABORT, instance, "reset aborted issued command(s)\n");
 	if (hostdata->connected)
-		dprintk(NDEBUG_ABORT, "scsi%d: reset aborted a connected command\n", H_NO(cmd));
+		dsprintk(NDEBUG_ABORT, instance, "reset aborted a connected command\n");
 	if (hostdata->disconnected_queue)
-		dprintk(NDEBUG_ABORT, "scsi%d: reset aborted disconnected command(s)\n", H_NO(cmd));
+		dsprintk(NDEBUG_ABORT, instance, "reset aborted disconnected command(s)\n");
 
 	hostdata->issue_queue = NULL;
 	hostdata->connected = NULL;
Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2016-01-03 16:04:12.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2016-01-03 16:04:14.000000000 +1100
@@ -755,7 +755,7 @@ static int NCR5380_queue_command(struct
 	switch (cmd->cmnd[0]) {
 	case WRITE_6:
 	case WRITE_10:
-		printk("scsi%d : WRITE attempted with NO_WRITE debugging flag set\n", instance->host_no);
+		shost_printk(KERN_DEBUG, instance, "WRITE attempted with NDEBUG_NO_WRITE set\n");
 		cmd->result = (DID_ERROR << 16);
 		cmd->scsi_done(cmd);
 		return 0;
@@ -790,7 +790,8 @@ static int NCR5380_queue_command(struct
 	}
 	spin_unlock_irqrestore(&hostdata->lock, flags);
 
-	dprintk(NDEBUG_QUEUES, "scsi%d : command added to %s of queue\n", instance->host_no, (cmd->cmnd[0] == REQUEST_SENSE) ? "head" : "tail");
+	dsprintk(NDEBUG_QUEUES, instance, "command %p added to %s of queue\n",
+	         cmd, (cmd->cmnd[0] == REQUEST_SENSE) ? "head" : "tail");
 
 	/* Kick off command processing */
 	queue_work(hostdata->work_q, &hostdata->main_task);
@@ -1888,7 +1889,9 @@ static void NCR5380_information_transfer
 						cmd->host_scribble = (unsigned char *)
 						    hostdata->issue_queue;
 						hostdata->issue_queue = (struct scsi_cmnd *) cmd;
-						dprintk(NDEBUG_QUEUES, "scsi%d : REQUEST SENSE added to head of issue queue\n", instance->host_no);
+						dsprintk(NDEBUG_QUEUES, instance,
+						         "REQUEST SENSE cmd %p added to head of issue queue\n",
+						         cmd);
 					} else {
 						cmd->scsi_done(cmd);
 					}
