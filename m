From: Michael Reed <mdr@sgi.com>
Subject: [PATCH 2/2] Prevent infinite retries due to DID_RESET return status
Date: Wed, 31 Jan 2007 12:54:25 -0600
Message-ID: <45C0E5E1.8040703@sgi.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020807090407040709080406"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:45844 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933331AbXAaSyc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Jan 2007 13:54:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Jeremy Higdon <jeremy@sgi.com>

This is a multi-part message in MIME format.
--------------020807090407040709080406
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Limit lifetime of scsi commands receiving DID_RESET status.

Signed-off-by: Michael Reed <mdr@sgi.com>


--------------020807090407040709080406
Content-Type: text/x-patch;
 name="DID_RESET_new_2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="DID_RESET_new_2.patch"

Limit lifetime of scsi commands receiving DID_RESET status.

Signed-off-by: Michael Reed <mdr@sgi.com>

--- rg61u/include/scsi/scsi.h	2006-10-31 21:08:47.000000000 -0600
+++ rg61/include/scsi/scsi.h	2007-01-29 15:58:40.633779567 -0600
@@ -353,6 +353,7 @@ struct scsi_lun {
 #define SCSI_MLQUEUE_HOST_BUSY   0x1055
 #define SCSI_MLQUEUE_DEVICE_BUSY 0x1056
 #define SCSI_MLQUEUE_EH_RETRY    0x1057
+#define SCSI_MLQUEUE_DID_RESET   0x1058
 
 /*
  *  Use these to separate status msg and our bytes
--- rg61u/drivers/scsi/scsi_lib.c	2007-01-29 15:11:11.466213588 -0600
+++ rg61/drivers/scsi/scsi_lib.c	2007-01-29 15:58:40.637779387 -0600
@@ -101,10 +101,10 @@ static void scsi_unprep_request(struct r
  *
  * Returns:     Nothing.
  *
- * Notes:       We do this for one of two cases.  Either the host is busy
+ * Notes:       We do this for one of three cases.  1) the host is busy
  *              and it cannot accept any more commands for the time being,
- *              or the device returned QUEUE_FULL and can accept no more
- *              commands.
+ *              2) the device returned QUEUE_FULL and can accept no more
+ *              commands, or 3) the LLDD returned DID_RESET.
  * Notes:       This could be called either from an interrupt context or a
  *              normal process context.
  */
@@ -138,9 +138,11 @@ int scsi_queue_insert(struct scsi_cmnd *
 
 	/*
 	 * Decrement the counters, since these commands are no longer
-	 * active on the host/device.
+	 * active on the host/device.  If the reason is SCSI_MLQUEUE_DID_RESET
+	 * then scsi_device_unbusy() was called by scsi_finish_command().
 	 */
-	scsi_device_unbusy(device);
+	if (reason != SCSI_MLQUEUE_DID_RESET)
+		scsi_device_unbusy(device);
 
 	/*
 	 * Requeue this command.  It will go before all other commands
@@ -792,6 +794,33 @@ static void scsi_release_buffers(struct 
 }
 
 /*
+ * Function:    scsi_command_expired()
+ *
+ * Purpose:     Check scsi a command's age before retrying it.
+ *
+ * Arguments:   cmd	- command that we are checking for timeout.
+ *
+ * Returns:     non-zero if command has exceeded its lifetime
+ *              zero otherwise
+ *
+ * Notes:       A command's lifetime is considered to be the number
+ *              of (retries permitted plus one) * command timeout.
+ *
+ */
+static int scsi_command_expired(struct scsi_cmnd *cmd)
+{
+	int ret = 0;
+	unsigned long wait_for = (cmd->allowed + 1) * cmd->timeout_per_command;
+	if (time_before(cmd->jiffies_at_alloc + wait_for, jiffies)) {
+		sdev_printk(KERN_ERR, cmd->device,
+			    "timing out command, waited %lus\n",
+			    wait_for/HZ);
+		ret = 1;
+	}
+	return ret;
+}
+
+/*
  * Function:    scsi_io_completion()
  *
  * Purpose:     Completion processing for block device I/O requests.
@@ -962,12 +991,26 @@ void scsi_io_completion(struct scsi_cmnd
 		}
 	}
 	if (host_byte(result) == DID_RESET) {
-		/* Third party bus reset or reset for error recovery
-		 * reasons.  Just retry the request and see what
-		 * happens.
+		/*
+		 * Third party bus reset or reset for error recovery reasons.
+		 * If no data was transferred and the command has not expired,
+		 * just reinsert the command  on the queue.  If the command
+		 * HAS expired, we fall through to call scsi_end_request.
+		 *
+		 * If data was transferred, regenerate the command to transfer
+		 * only untransferred data by calling scsi_requeue_command().
 		 */
-		scsi_requeue_command(q, cmd);
-		return;
+		if (!good_bytes) {
+			if (!(scsi_command_expired(cmd))) {
+				scsi_queue_insert(cmd, SCSI_MLQUEUE_DID_RESET);
+				return;
+			}
+			/* fall through to call scsi_end_request() */
+		}
+		else {
+			scsi_requeue_command(q, cmd);
+			return;
+		}
 	}
 	if (result) {
 		if (!(req->cmd_flags & REQ_QUIET)) {
@@ -1381,17 +1424,12 @@ static void scsi_kill_request(struct req
 static void scsi_softirq_done(struct request *rq)
 {
 	struct scsi_cmnd *cmd = rq->completion_data;
-	unsigned long wait_for = (cmd->allowed + 1) * cmd->timeout_per_command;
 	int disposition;
 
 	INIT_LIST_HEAD(&cmd->eh_entry);
 
 	disposition = scsi_decide_disposition(cmd);
-	if (disposition != SUCCESS &&
-	    time_before(cmd->jiffies_at_alloc + wait_for, jiffies)) {
-		sdev_printk(KERN_ERR, cmd->device,
-			    "timing out command, waited %lus\n",
-			    wait_for/HZ);
+	if (disposition != SUCCESS && scsi_command_expired(cmd)) {
 		disposition = SUCCESS;
 	}
 			

--------------020807090407040709080406--
