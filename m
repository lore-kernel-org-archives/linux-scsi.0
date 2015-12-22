From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v3 28/77] ncr5380: Drop DEF_SCSI_QCMD macro
Date: Tue, 22 Dec 2015 12:18:06 +1100
Message-ID: <20151222011745.645515446@telegraphics.com.au>
References: <20151222011737.980475848@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:40457 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbbLVCbN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Dec 2015 21:31:13 -0500
Content-Disposition: inline; filename=ncr5380-drop-DEF_SCSI_QCMD
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>

Remove the DEF_SCSI_QCMD macro (already removed from atari_NCR5380.c). The
lock provided by DEF_SCSI_QCMD is only needed for queue data structures.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/NCR5380.c       |   30 +++++++++++++++---------------
 drivers/scsi/atari_NCR5380.c |    2 +-
 2 files changed, 16 insertions(+), 16 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2015-12-22 12:16:14.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2015-12-22 12:16:15.000000000 +1100
@@ -808,22 +808,21 @@ static void NCR5380_exit(struct Scsi_Hos
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
@@ -831,7 +830,7 @@ static int NCR5380_queue_command_lck(str
 	case WRITE_10:
 		printk("scsi%d : WRITE attempted with NO_WRITE debugging flag set\n", instance->host_no);
 		cmd->result = (DID_ERROR << 16);
-		done(cmd);
+		cmd->scsi_done(cmd);
 		return 0;
 	}
 #endif				/* (NDEBUG & NDEBUG_NO_WRITE) */
@@ -842,9 +841,10 @@ static int NCR5380_queue_command_lck(str
 	 */
 
 	cmd->host_scribble = NULL;
-	cmd->scsi_done = done;
 	cmd->result = 0;
 
+	spin_lock_irqsave(instance->host_lock, flags);
+
 	/* 
 	 * Insert the cmd into the issue queue. Note that REQUEST SENSE 
 	 * commands are added to the head of the queue since any command will
@@ -861,6 +861,8 @@ static int NCR5380_queue_command_lck(str
 		LIST(cmd, tmp);
 		tmp->host_scribble = (unsigned char *) cmd;
 	}
+	spin_unlock_irqrestore(instance->host_lock, flags);
+
 	dprintk(NDEBUG_QUEUES, "scsi%d : command added to %s of queue\n", instance->host_no, (cmd->cmnd[0] == REQUEST_SENSE) ? "head" : "tail");
 
 	/* Run the coroutine if it isn't already running. */
@@ -869,8 +871,6 @@ static int NCR5380_queue_command_lck(str
 	return 0;
 }
 
-static DEF_SCSI_QCMD(NCR5380_queue_command)
-
 /**
  *	NCR5380_main	-	NCR state machines
  *
Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2015-12-22 12:16:12.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2015-12-22 12:16:15.000000000 +1100
@@ -930,7 +930,7 @@ static void NCR5380_exit(struct Scsi_Hos
  * @instance: the relevant SCSI adapter
  * @cmd: SCSI command
  *
- * cmd is added to the per instance issue_queue, with minor
+ * cmd is added to the per-instance issue queue, with minor
  * twiddling done to the host specific fields of cmd.  If the
  * main coroutine is not running, it is restarted.
  */


