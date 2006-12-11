From: Michael Reed <mdr@sgi.com>
Subject: [RFC] Prevent infinite retries due to DID_RESET return status
Date: Mon, 11 Dec 2006 15:42:34 -0600
Message-ID: <457DD0CA.9010509@sgi.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000201050502030800000508"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:51943 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S937673AbWLKVnI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Dec 2006 16:43:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Jeremy Higdon <jeremy@sgi.com>

This is a multi-part message in MIME format.
--------------000201050502030800000508
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Due to a firmware mismatch between a host and target (names withheld to
protect the innocent?), the LLDD was returning DID_RESET for every
i/o command.  This patch modifies the scsi layer to take into account
when the command which received DID_RESET was issued and eventually
give up on it instead of unconditionally reissuing it forever
when it receives a DID_RESET.  With this patch, on my test system,
the command receiving the constant DID_RESET times out after about
360 seconds.

The premise for this patch is that no command should have an infinite
lifetime.  The impetus for this patch was a system which would not
reach a command prompt without disconnecting the storage from the
host.

The significant change in this patch is to call scsi_retry_command()
instead of scsi_requeue_command() if the command which receives a
DID_RESET did not complete any i/o (good_bytes==0).  scsi_retry_command()
does not release the command and regenerate it like scsi_requeue_command()
does, hence jiffies_at_alloc reflects when the command was first issued.

This patch is based upon 2.6.19.  Thanks for taking the time to
look at this.

Mike









--------------000201050502030800000508
Content-Type: text/x-patch;
 name="did_reset.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="did_reset.patch"

--- kdbu/drivers/scsi/scsi_priv.h	2006-10-09 01:58:19.000000000 -0500
+++ kdb/drivers/scsi/scsi_priv.h	2006-12-07 14:15:19.925332776 -0600
@@ -28,7 +28,7 @@ extern int scsi_dispatch_cmd(struct scsi
 extern int scsi_setup_command_freelist(struct Scsi_Host *shost);
 extern void scsi_destroy_command_freelist(struct Scsi_Host *shost);
 extern void __scsi_done(struct scsi_cmnd *cmd);
-extern int scsi_retry_command(struct scsi_cmnd *cmd);
+extern int scsi_retry_command(struct scsi_cmnd *cmd, int reason);
 #ifdef CONFIG_SCSI_LOGGING
 void scsi_log_send(struct scsi_cmnd *cmd);
 void scsi_log_completion(struct scsi_cmnd *cmd, int disposition);
--- kdbu/include/scsi/scsi.h	2006-10-31 21:08:47.000000000 -0600
+++ kdb/include/scsi/scsi.h	2006-12-07 14:13:09.188052974 -0600
@@ -353,6 +353,7 @@ struct scsi_lun {
 #define SCSI_MLQUEUE_HOST_BUSY   0x1055
 #define SCSI_MLQUEUE_DEVICE_BUSY 0x1056
 #define SCSI_MLQUEUE_EH_RETRY    0x1057
+#define SCSI_MLQUEUE_DID_RESET   0x1058
 
 /*
  *  Use these to separate status msg and our bytes
--- kdbu/drivers/scsi/scsi.c	2006-10-09 01:58:19.000000000 -0500
+++ kdb/drivers/scsi/scsi.c	2006-12-07 14:15:49.835794930 -0600
@@ -673,7 +673,7 @@ void __scsi_done(struct scsi_cmnd *cmd)
  *              level drivers should not become re-entrant as a result of
  *              this.
  */
-int scsi_retry_command(struct scsi_cmnd *cmd)
+int scsi_retry_command(struct scsi_cmnd *cmd, int reason)
 {
         /*
          * Zero the sense information from the last time we tried
@@ -681,7 +681,7 @@ int scsi_retry_command(struct scsi_cmnd 
          */
 	memset(cmd->sense_buffer, 0, sizeof(cmd->sense_buffer));
 
-	return scsi_queue_insert(cmd, SCSI_MLQUEUE_EH_RETRY);
+	return scsi_queue_insert(cmd, reason);
 }
 
 /*
--- kdbu/drivers/scsi/scsi_lib.c	2006-11-29 21:09:07.000000000 -0600
+++ kdb/drivers/scsi/scsi_lib.c	2006-12-11 14:22:52.756579311 -0600
@@ -65,6 +65,7 @@ static struct scsi_host_sg_pool scsi_sg_
 #undef SP
 
 static void scsi_run_queue(struct request_queue *q);
+static void scsi_release_buffers(struct scsi_cmnd *cmd);
 
 /*
  * Function:	scsi_unprep_request()
@@ -100,10 +101,10 @@ static void scsi_unprep_request(struct r
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
@@ -137,9 +138,11 @@ int scsi_queue_insert(struct scsi_cmnd *
 
 	/*
 	 * Decrement the counters, since these commands are no longer
-	 * active on the host/device.
+	 * active on the host/device.  If the reason is SCSI_MLQUEUE_DID_RESET
+	 * then scsi_device_unbusy() was previously called.
 	 */
-	scsi_device_unbusy(device);
+	if (reason != SCSI_MLQUEUE_DID_RESET)
+		scsi_device_unbusy(device);
 
 	/*
 	 * Requeue this command.  It will go before all other commands
@@ -601,6 +604,7 @@ static void scsi_requeue_command(struct 
 	struct request *req = cmd->request;
 	unsigned long flags;
 
+	scsi_release_buffers(cmd);
 	scsi_unprep_request(req);
 	spin_lock_irqsave(q->queue_lock, flags);
 	blk_requeue_request(q, req);
@@ -646,6 +650,7 @@ void scsi_run_host_queues(struct Scsi_Ho
  * Lock status: Assumed that lock is not held upon entry.
  *
  * Returns:     cmd if requeue required, NULL otherwise.
+ * 		If cmd is returned then its buffers have not been released.
  *
  * Notes:       This is called for block device requests in order to
  *              mark some number of sectors as complete.
@@ -688,6 +693,7 @@ static struct scsi_cmnd *scsi_end_reques
 		}
 	}
 
+	scsi_release_buffers(cmd);
 	add_disk_randomness(req->rq_disk);
 
 	spin_lock_irqsave(q->queue_lock, flags);
@@ -786,6 +792,33 @@ static void scsi_release_buffers(struct 
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
+ * Notes:       A commands lifetime is considered to be the number
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
@@ -824,8 +857,6 @@ void scsi_io_completion(struct scsi_cmnd
 	int sense_valid = 0;
 	int sense_deferred = 0;
 
-	scsi_release_buffers(cmd);
-
 	if (result) {
 		sense_valid = scsi_command_normalize_sense(cmd, &sshdr);
 		if (sense_valid)
@@ -961,9 +992,20 @@ void scsi_io_completion(struct scsi_cmnd
 		/* Third party bus reset or reset for error recovery
 		 * reasons.  Just retry the request and see what
 		 * happens.
+		 * If no data was transferred, just reissue this
+		 * command.  If data was transferred, regenerate
+		 * the command to transfer only untransferred data.
 		 */
-		scsi_requeue_command(q, cmd);
-		return;
+		if (!good_bytes) {
+			if (!(scsi_command_expired(cmd))) {
+				scsi_retry_command(cmd, SCSI_MLQUEUE_DID_RESET);
+				return;
+			}
+		}
+		else {
+			scsi_requeue_command(q, cmd);
+			return;
+		}
 	}
 	if (result) {
 		if (!(req->cmd_flags & REQ_QUIET)) {
@@ -1358,17 +1400,12 @@ static void scsi_kill_request(struct req
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
 			
@@ -1379,7 +1416,7 @@ static void scsi_softirq_done(struct req
 			scsi_finish_command(cmd);
 			break;
 		case NEEDS_RETRY:
-			scsi_retry_command(cmd);
+			scsi_retry_command(cmd, SCSI_MLQUEUE_EH_RETRY);
 			break;
 		case ADD_TO_MLQUEUE:
 			scsi_queue_insert(cmd, SCSI_MLQUEUE_DEVICE_BUSY);

--------------000201050502030800000508--
