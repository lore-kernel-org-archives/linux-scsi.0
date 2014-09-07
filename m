From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 8/8] scsi: merge scsi_finish_command and scsi_io_completion
Date: Sun,  7 Sep 2014 09:31:09 -0700
Message-ID: <1410107469-896-9-git-send-email-hch@lst.de>
References: <1410107469-896-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:35033 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601AbaIGQ3Q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Sep 2014 12:29:16 -0400
Received: from [50.247.105.171] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1XQfL0-0006TC-AL
	for linux-scsi@vger.kernel.org; Sun, 07 Sep 2014 16:29:15 +0000
In-Reply-To: <1410107469-896-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/scsi/scsi_eh.txt | 12 +++---
 drivers/scsi/scsi.c            | 58 -----------------------------
 drivers/scsi/scsi_lib.c        | 84 +++++++++++++++++++++++++++---------------
 drivers/scsi/scsi_priv.h       |  1 -
 4 files changed, 59 insertions(+), 96 deletions(-)

diff --git a/Documentation/scsi/scsi_eh.txt b/Documentation/scsi/scsi_eh.txt
index a0c8511..8a7ac48 100644
--- a/Documentation/scsi/scsi_eh.txt
+++ b/Documentation/scsi/scsi_eh.txt
@@ -57,13 +57,11 @@ looks at the scmd->result value and sense data to determine what to do
 with the command.
 
  - SUCCESS
-	scsi_finish_command() is invoked for the command.  The
-	function does some maintenance chores and then calls
-	scsi_io_completion() to finish the I/O.
-	scsi_io_completion() then notifies the block layer on
-	the completed request by calling blk_end_request and
-	friends or figures out what to do with the remainder
-	of the data in case of an error.
+	scsi_finish_command() is invoked for the command.  The function
+	does some maintenance chores and then  notifies the block layer on
+	the completed request by calling blk_end_request / __blk_mq_end_io
+	or figures out what to do with the remainder of the data in case
+	of an error.
 
  - NEEDS_RETRY
  - ADD_TO_MLQUEUE
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index a86ccb7..cdc0686 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -626,64 +626,6 @@ void scsi_cmd_get_serial(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 EXPORT_SYMBOL(scsi_cmd_get_serial);
 
 /**
- * scsi_finish_command - cleanup and pass command back to upper layer
- * @cmd: the command
- *
- * Description: Pass command off to upper layer for finishing of I/O
- *              request, waking processes that are waiting on results,
- *              etc.
- */
-void scsi_finish_command(struct scsi_cmnd *cmd)
-{
-	struct scsi_device *sdev = cmd->device;
-	struct scsi_target *starget = scsi_target(sdev);
-	struct Scsi_Host *shost = sdev->host;
-	struct scsi_driver *drv;
-	unsigned int good_bytes;
-
-	scsi_device_unbusy(sdev);
-
-	/*
-	 * Clear the flags that say that the device/target/host is no longer
-	 * capable of accepting new commands.
-	 */
-	if (atomic_read(&shost->host_blocked))
-		atomic_set(&shost->host_blocked, 0);
-	if (atomic_read(&starget->target_blocked))
-		atomic_set(&starget->target_blocked, 0);
-	if (atomic_read(&sdev->device_blocked))
-		atomic_set(&sdev->device_blocked, 0);
-
-	/*
-	 * If we have valid sense information, then some kind of recovery
-	 * must have taken place.  Make a note of this.
-	 */
-	if (SCSI_SENSE_VALID(cmd))
-		cmd->result |= (DRIVER_SENSE << 24);
-
-	SCSI_LOG_MLCOMPLETE(4, sdev_printk(KERN_INFO, sdev,
-				"Notifying upper driver of completion "
-				"(result %x)\n", cmd->result));
-
-	good_bytes = scsi_bufflen(cmd);
-        if (cmd->request->cmd_type != REQ_TYPE_BLOCK_PC) {
-		int old_good_bytes = good_bytes;
-		drv = scsi_cmd_to_driver(cmd);
-		if (drv->done)
-			good_bytes = drv->done(cmd);
-		/*
-		 * USB may not give sense identifying bad sector and
-		 * simply return a residue instead, so subtract off the
-		 * residue if drv->done() error processing indicates no
-		 * change to the completion length.
-		 */
-		if (good_bytes == old_good_bytes)
-			good_bytes -= scsi_get_resid(cmd);
-	}
-	scsi_io_completion(cmd, good_bytes);
-}
-
-/**
  * scsi_adjust_queue_depth - Let low level drivers change a device's queue depth
  * @sdev: SCSI Device in question
  * @tagged: Do we use tagged queueing (non-0) or do we treat
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index cc5d404..e0eb809 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -868,44 +868,68 @@ scsi_handle_ioerror(struct scsi_cmnd *cmd, int result,
 	return true;
 }
 
-/*
- * Function:    scsi_io_completion()
- *
- * Purpose:     Completion processing for block device I/O requests.
- *
- * Arguments:   cmd   - command that is finished.
- *
- * Lock status: Assumed that no lock is held upon entry.
- *
- * Returns:     Nothing
- *
- * Notes:       We will finish off the specified number of sectors.  If we
- *		are done, the command block will be released and the queue
- *		function will be goosed.  If we are not done then we have to
- *		figure out what to do next:
- *
- *		a) We can call scsi_requeue_command().  The request
- *		   will be unprepared and put back on the queue.  Then
- *		   a new command will be created for it.  This should
- *		   be used if we made forward progress, or if we want
- *		   to switch from READ(10) to READ(6) for example.
- *
- *		b) We can call __scsi_queue_insert().  The request will
- *		   be put back on the queue and retried using the same
- *		   command as before, possibly after a delay.
+/**
+ * scsi_finish_command - handle I/O completion on a command
+ * @cmd:	command to complete
  *
- *		c) We can call scsi_end_request() with -EIO to fail
- *		   the remainder of the request.
+ * Finish off the number of bytes returned by the driver.  If the whole command
+ * has been completed return it to the block layer.  If it hasn't figure out
+ * what to do based on the result from the driver and the sense code.
  */
-void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
+void scsi_finish_command(struct scsi_cmnd *cmd)
 {
-	int result = cmd->result;
 	struct request *req = cmd->request;
-	int error = 0;
+	struct scsi_device *sdev = cmd->device;
+	struct scsi_target *starget = scsi_target(sdev);
+	struct Scsi_Host *shost = sdev->host;
 	struct scsi_sense_hdr sshdr;
+	struct scsi_driver *drv;
+	unsigned int good_bytes;
 	int sense_valid = 0;
 	int sense_deferred = 0;
+	int error = 0, result;
+
+	scsi_device_unbusy(sdev);
+
+	/*
+	 * Clear the flags that say that the device/target/host is no longer
+	 * capable of accepting new commands.
+	 */
+	if (atomic_read(&shost->host_blocked))
+		atomic_set(&shost->host_blocked, 0);
+	if (atomic_read(&starget->target_blocked))
+		atomic_set(&starget->target_blocked, 0);
+	if (atomic_read(&sdev->device_blocked))
+		atomic_set(&sdev->device_blocked, 0);
+
+	/*
+	 * If we have valid sense information, then some kind of recovery
+	 * must have taken place.  Make a note of this.
+	 */
+	if (SCSI_SENSE_VALID(cmd))
+		cmd->result |= (DRIVER_SENSE << 24);
+
+	SCSI_LOG_MLCOMPLETE(4, sdev_printk(KERN_INFO, sdev,
+				"Notifying upper driver of completion "
+				"(result %x)\n", cmd->result));
+
+	good_bytes = scsi_bufflen(cmd);
+        if (cmd->request->cmd_type != REQ_TYPE_BLOCK_PC) {
+		int old_good_bytes = good_bytes;
+		drv = scsi_cmd_to_driver(cmd);
+		if (drv->done)
+			good_bytes = drv->done(cmd);
+		/*
+		 * USB may not give sense identifying bad sector and
+		 * simply return a residue instead, so subtract off the
+		 * residue if drv->done() error processing indicates no
+		 * change to the completion length.
+		 */
+		if (good_bytes == old_good_bytes)
+			good_bytes -= scsi_get_resid(cmd);
+	}
 
+	result = cmd->result;
 	if (result) {
 		sense_valid = scsi_command_normalize_sense(cmd, &sshdr);
 		if (sense_valid)
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 2dc4a83..87c6c5a 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -83,7 +83,6 @@ int scsi_noretry_cmd(struct scsi_cmnd *scmd);
 extern int scsi_maybe_unblock_host(struct scsi_device *sdev);
 extern void scsi_device_unbusy(struct scsi_device *sdev);
 extern void scsi_queue_insert(struct scsi_cmnd *cmd, int reason);
-extern void scsi_io_completion(struct scsi_cmnd *, unsigned int);
 extern void scsi_run_host_queues(struct Scsi_Host *shost);
 extern struct request_queue *scsi_alloc_queue(struct scsi_device *sdev);
 extern struct request_queue *scsi_mq_alloc_queue(struct scsi_device *sdev);
-- 
1.9.1

