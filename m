From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v2 28/72] ncr5380: Drop DEF_SCSI_QCMD macro
Date: Sun, 06 Dec 2015 12:31:54 +1100
Message-ID: <20151206013133.855492620@telegraphics.com.au>
References: <20151206013126.995379403@telegraphics.com.au>
Return-path: <linux-m68k-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-drop-DEF_SCSI_QCMD
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Remove the DEF_SCSI_QCMD macro (already removed from atari_NCR5380.c). The
lock provided by DEF_SCSI_QCMD is only needed for queue data structures.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/NCR5380.c       |   30 +++++++++++++++---------------
 drivers/scsi/atari_NCR5380.c |    2 +-
 2 files changed, 16 insertions(+), 16 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2015-12-06 12:30:15.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2015-12-06 12:30:16.000000000 +1100
@@ -803,22 +803,21 @@ static void NCR5380_exit(struct Scsi_Hos
 }
 
 /**
- *	NCR5380_queue_command 		-	queue a command
- *	@cmd: SCSI command
- *	@done: completion handler
+ * NCR5380_queue_command - queue a command
+ * @instance: the relevant SCSI adapter
+ * @cmd: SCSI command
  *
- *      cmd is added to the per instance issue_queue, with minor 
- *      twiddling done to the host specific fields of cmd.  If the 
- *      main coroutine is not running, it is restarted.
- *
- *	Locks: host lock taken by caller
+ * cmd is added to the per-instance issue queue, with minor
+ * twiddling done to the host specific fields of cmd.  If the
+ * main coroutine is not running, it is restarted.
  */
 
-static int NCR5380_queue_command_lck(struct scsi_cmnd *cmd, void (*done) (struct scsi_cmnd *))
+static int NCR5380_queue_command(struct Scsi_Host *instance,
+                                 struct scsi_cmnd *cmd)
 {
-	struct Scsi_Host *instance = cmd->device->host;
-	struct NCR5380_hostdata *hostdata = (struct NCR5380_hostdata *) instance->hostdata;
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	struct scsi_cmnd *tmp;
+	unsigned long flags;
 
 #if (NDEBUG & NDEBUG_NO_WRITE)
 	switch (cmd->cmnd[0]) {
@@ -826,7 +825,7 @@ static int NCR5380_queue_command_lck(str
 	case WRITE_10:
 		printk("scsi%d : WRITE attempted with NO_WRITE debugging flag set\n", instance->host_no);
 		cmd->result = (DID_ERROR << 16);
-		done(cmd);
+		cmd->scsi_done(cmd);
 		return 0;
 	}
 #endif				/* (NDEBUG & NDEBUG_NO_WRITE) */
@@ -837,9 +836,10 @@ static int NCR5380_queue_command_lck(str
 	 */
 
 	cmd->host_scribble = NULL;
-	cmd->scsi_done = done;
 	cmd->result = 0;
 
+	spin_lock_irqsave(instance->host_lock, flags);
+
 	/* 
 	 * Insert the cmd into the issue queue. Note that REQUEST SENSE 
 	 * commands are added to the head of the queue since any command will
@@ -856,6 +856,8 @@ static int NCR5380_queue_command_lck(str
 		LIST(cmd, tmp);
 		tmp->host_scribble = (unsigned char *) cmd;
 	}
+	spin_unlock_irqrestore(instance->host_lock, flags);
+
 	dprintk(NDEBUG_QUEUES, "scsi%d : command added to %s of queue\n", instance->host_no, (cmd->cmnd[0] == REQUEST_SENSE) ? "head" : "tail");
 
 	/* Run the coroutine if it isn't already running. */
@@ -864,8 +866,6 @@ static int NCR5380_queue_command_lck(str
 	return 0;
 }
 
-static DEF_SCSI_QCMD(NCR5380_queue_command)
-
 /**
  *	NCR5380_main	-	NCR state machines
  *
Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2015-12-06 12:30:12.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2015-12-06 12:30:16.000000000 +1100
@@ -925,7 +925,7 @@ static void NCR5380_exit(struct Scsi_Hos
  * @instance: the relevant SCSI adapter
  * @cmd: SCSI command
  *
- * cmd is added to the per instance issue_queue, with minor
+ * cmd is added to the per-instance issue queue, with minor
  * twiddling done to the host specific fields of cmd.  If the
  * main coroutine is not running, it is restarted.
  */
