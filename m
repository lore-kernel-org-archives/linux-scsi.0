From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi_lib: don't decrement busy counters when inserting
	commands
Date: Fri, 02 Jan 2009 10:42:21 -0600
Message-ID: <1230914541.3304.9.camel@localhost.localdomain>
References: <1229493343215-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:59035 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751741AbZABQm0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Jan 2009 11:42:26 -0500
In-Reply-To: <1229493343215-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>

On Tue, 2008-12-16 at 23:55 -0600, michaelc@cs.wisc.edu wrote:
> From: Mike Christie <michaelc@cs.wisc.edu>
> 
> This patch fixes a regression in scsi-misc introduced with:
> 312efe5efcdb02d604ea37a41d965f32ca276d6a
> [SCSI] simplify scsi_io_completion().
> 
> The problem is that in previous kernels scsi_io_completion would call
> scsi_requeue_command, but now it can call scsi_queue_insert for
> something like a UNIT_ATTENTION (for netapp targets we get
> UNIT_ATTENTION when restarting a iscsi session). And scsi_queue_insert
> will call scsi_device_unbusy, but in the scsi_io_completion code path
> scsi_finish_command has already called this so we now end up
> with invalid host, target and device busy values.
> 
> Patch was made over scsi-misc.

This is a bad bug, but not quite the way I'd like to fix it.  Whether
the queue should be unbusied or not is really separate from the block
action, so it should have its own flag (plus it's not really a flag many
people should be using).  Since, really, the wrong use is confined to
the defining file, how about this:

James

---

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f2f51e0..c6d48eb 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -91,26 +91,19 @@ static void scsi_unprep_request(struct request *req)
 	scsi_put_command(cmd);
 }
 
-/*
- * Function:    scsi_queue_insert()
- *
- * Purpose:     Insert a command in the midlevel queue.
- *
- * Arguments:   cmd    - command that we are adding to queue.
- *              reason - why we are inserting command to queue.
- *
- * Lock status: Assumed that lock is not held upon entry.
- *
- * Returns:     Nothing.
- *
- * Notes:       We do this for one of two cases.  Either the host is busy
- *              and it cannot accept any more commands for the time being,
- *              or the device returned QUEUE_FULL and can accept no more
- *              commands.
- * Notes:       This could be called either from an interrupt context or a
- *              normal process context.
+/**
+ * __scsi_queue_insert - private queue insertion
+ * @cmd: The SCSI command being requeued
+ * @reason:  The reason for the requeue
+ * @unbusy: Whether the queue should be unbusied
+ *
+ * This is a private queue insertion.  The public interface
+ * scsi_queue_insert() always assumes the queue should be unbusied
+ * because it's always called before the completion.  This function is
+ * for a requeue after completion, which should only occur in this
+ * file.
  */
-int scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
+static int __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, int unbusy)
 {
 	struct Scsi_Host *host = cmd->device->host;
 	struct scsi_device *device = cmd->device;
@@ -150,7 +143,8 @@ int scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
 	 * Decrement the counters, since these commands are no longer
 	 * active on the host/device.
 	 */
-	scsi_device_unbusy(device);
+	if (unbusy)
+		scsi_device_unbusy(device);
 
 	/*
 	 * Requeue this command.  It will go before all other commands
@@ -172,6 +166,29 @@ int scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
 	return 0;
 }
 
+/*
+ * Function:    scsi_queue_insert()
+ *
+ * Purpose:     Insert a command in the midlevel queue.
+ *
+ * Arguments:   cmd    - command that we are adding to queue.
+ *              reason - why we are inserting command to queue.
+ *
+ * Lock status: Assumed that lock is not held upon entry.
+ *
+ * Returns:     Nothing.
+ *
+ * Notes:       We do this for one of two cases.  Either the host is busy
+ *              and it cannot accept any more commands for the time being,
+ *              or the device returned QUEUE_FULL and can accept no more
+ *              commands.
+ * Notes:       This could be called either from an interrupt context or a
+ *              normal process context.
+ */
+int scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
+{
+	return __scsi_queue_insert(cmd, reason, 1);
+}
 /**
  * scsi_execute - insert request and wait for the result
  * @sdev:	scsi device
@@ -1071,11 +1088,11 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 		break;
 	case ACTION_RETRY:
 		/* Retry the same command immediately */
-		scsi_queue_insert(cmd, SCSI_MLQUEUE_EH_RETRY);
+		__scsi_queue_insert(cmd, SCSI_MLQUEUE_EH_RETRY, 0);
 		break;
 	case ACTION_DELAYED_RETRY:
 		/* Retry the same command after a delay */
-		scsi_queue_insert(cmd, SCSI_MLQUEUE_DEVICE_BUSY);
+		__scsi_queue_insert(cmd, SCSI_MLQUEUE_DEVICE_BUSY, 0);
 		break;
 	}
 }


