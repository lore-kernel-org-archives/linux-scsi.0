From: malahal@us.ibm.com
Subject: [RFC] [PATCH 2/2] blk request timeout handler patches
Date: Thu, 4 Oct 2007 11:20:03 -0700
Message-ID: <20071004182003.GC16689@us.ibm.com>
References: <20071004181259.GA16689@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:42100 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756376AbXJDSUF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Oct 2007 14:20:05 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l94IK5L8023218
	for <linux-scsi@vger.kernel.org>; Thu, 4 Oct 2007 14:20:05 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l94IK5u6620432
	for <linux-scsi@vger.kernel.org>; Thu, 4 Oct 2007 14:20:05 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l94IK4cj007707
	for <linux-scsi@vger.kernel.org>; Thu, 4 Oct 2007 14:20:04 -0400
Content-Disposition: inline
In-Reply-To: <20071004181259.GA16689@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jens.axboe@oracle.com

Fix scsi_dispatch_cmd() to stop timers.

Signed-off-by: Malahal Naineni <malahal@us.ibm.com>


diff -r 870bb598c977 drivers/scsi/scsi.c
--- a/drivers/scsi/scsi.c	Thu Sep 27 00:25:38 2007 -0700
+++ b/drivers/scsi/scsi.c	Thu Sep 27 01:04:10 2007 -0700
@@ -471,14 +471,19 @@ int scsi_dispatch_cmd(struct scsi_cmnd *
 	unsigned long timeout;
 	int rtn = 0;
 
+	/*
+	 * We will use a queued command if possible, otherwise we will
+	 * emulate the queuing and calling of completion function ourselves.
+	 */
+	atomic_inc(&cmd->device->iorequest_cnt);
+
 	/* check if the device is still usable */
 	if (unlikely(cmd->device->sdev_state == SDEV_DEL)) {
 		/* in SDEV_DEL we error all commands. DID_NO_CONNECT
 		 * returns an immediate error upwards, and signals
 		 * that the device is no longer present */
 		cmd->result = DID_NO_CONNECT << 16;
-		atomic_inc(&cmd->device->iorequest_cnt);
-		__blk_complete_request(cmd->request);
+		scsi_done(cmd);
 		/* return 0 (because the command has been processed) */
 		goto out;
 	}
@@ -491,7 +496,8 @@ int scsi_dispatch_cmd(struct scsi_cmnd *
 		 * future requests should not occur until the device 
 		 * transitions out of the suspend state.
 		 */
-		scsi_queue_insert(cmd, SCSI_MLQUEUE_DEVICE_BUSY);
+
+		scsi_queue_retry(cmd, SCSI_MLQUEUE_DEVICE_BUSY);
 
 		SCSI_LOG_MLQUEUE(3, printk("queuecommand : device blocked \n"));
 
@@ -536,12 +542,6 @@ int scsi_dispatch_cmd(struct scsi_cmnd *
 	scsi_log_send(cmd);
 
 	/*
-	 * We will use a queued command if possible, otherwise we will
-	 * emulate the queuing and calling of completion function ourselves.
-	 */
-	atomic_inc(&cmd->device->iorequest_cnt);
-
-	/*
 	 * Before we queue this command, check if the command
 	 * length exceeds what the host adapter can handle.
 	 */
@@ -571,12 +571,8 @@ int scsi_dispatch_cmd(struct scsi_cmnd *
 	}
 	spin_unlock_irqrestore(host->host_lock, flags);
 	if (rtn) {
-		if (blk_delete_timer(cmd->request)) {
-			atomic_inc(&cmd->device->iodone_cnt);
-			scsi_queue_insert(cmd,
-					  (rtn == SCSI_MLQUEUE_DEVICE_BUSY) ?
-					  rtn : SCSI_MLQUEUE_HOST_BUSY);
-		}
+		scsi_queue_retry(cmd, (rtn == SCSI_MLQUEUE_DEVICE_BUSY) ?
+						rtn : SCSI_MLQUEUE_HOST_BUSY);
 		SCSI_LOG_MLQUEUE(3,
 		    printk("queuecommand : request rejected\n"));
 	}
diff -r 870bb598c977 drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c	Thu Sep 27 00:25:38 2007 -0700
+++ b/drivers/scsi/scsi_lib.c	Thu Sep 27 01:16:28 2007 -0700
@@ -160,6 +160,36 @@ int scsi_queue_insert(struct scsi_cmnd *
 
 	return 0;
 }
+
+/*
+ * Function:    scsi_queue_retry()
+ *
+ * Purpose:     Try inserting a command in the midlevel queue.
+ *
+ * Arguments:   cmd    - command that we are adding to queue.
+ *              reason - why we are inserting command to queue.
+ *
+ * Lock status: Assumed that lock is not held upon entry.
+ *
+ * Returns:     Nothing.
+ *
+ * Notes:       This is very similar to scsi_queue_insert except that we
+ *              call this function when we don't know if the blk layer timer
+ *              is active or not. We could implement this either by calling
+ *              blk_delete_timer and inserting in the midlevel queue if we
+ *              successfully delete the timer OR setting appropriate result
+ *              field in the cmd and letting it go through the normal done
+ *              routines which will retry the command. For now, We call
+ *              blk_delete_timer!
+ */
+void scsi_queue_retry(struct scsi_cmnd *cmd, int reason)
+{
+	if (blk_delete_timer(cmd->request)) {
+		atomic_inc(&cmd->device->iodone_cnt);
+		scsi_queue_insert(cmd, reason);
+	}
+}
+
 
 /**
  * scsi_execute - insert request and wait for the result
diff -r 870bb598c977 drivers/scsi/scsi_priv.h
--- a/drivers/scsi/scsi_priv.h	Thu Sep 27 00:25:38 2007 -0700
+++ b/drivers/scsi/scsi_priv.h	Thu Sep 27 01:03:39 2007 -0700
@@ -64,6 +64,7 @@ extern int scsi_maybe_unblock_host(struc
 extern int scsi_maybe_unblock_host(struct scsi_device *sdev);
 extern void scsi_device_unbusy(struct scsi_device *sdev);
 extern int scsi_queue_insert(struct scsi_cmnd *cmd, int reason);
+extern void scsi_queue_retry(struct scsi_cmnd *cmd, int reason);
 extern void scsi_next_command(struct scsi_cmnd *cmd);
 extern void scsi_run_host_queues(struct Scsi_Host *shost);
 extern struct request_queue *scsi_alloc_queue(struct scsi_device *sdev);
