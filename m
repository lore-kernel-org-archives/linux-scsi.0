From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: [PATCH 08/14] scsi: rename scsi_queue_insert to scsi_attempt_requeue_command
Date: Tue,  2 Sep 2008 09:05:37 -0700
Message-ID: <1220371543-15099-9-git-send-email-andmike@linux.vnet.ibm.com>
References: <1220371543-15099-1-git-send-email-andmike@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:42919 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbYIBQFt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Sep 2008 12:05:49 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m82G5msw023500
	for <linux-scsi@vger.kernel.org>; Tue, 2 Sep 2008 12:05:48 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m82G5mDi188568
	for <linux-scsi@vger.kernel.org>; Tue, 2 Sep 2008 12:05:48 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m82G5mvU021262
	for <linux-scsi@vger.kernel.org>; Tue, 2 Sep 2008 12:05:48 -0400
In-Reply-To: <1220371543-15099-1-git-send-email-andmike@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This renames scsi_queue_insert to scsi_attempt_requeue_command, because
it may not be able to requeue the command if there are not retries left
or if failfast is set. The naming is also meant to better match
the other requeue function, scsi_requeue_command, which will always
requeue a command.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
---
 drivers/scsi/scsi.c       |    4 ++--
 drivers/scsi/scsi_error.c |    3 ++-
 drivers/scsi/scsi_lib.c   |   22 ++++++++++++++--------
 drivers/scsi/scsi_priv.h  |    2 +-
 4 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index ee6be59..b87fbb2 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -672,7 +672,7 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 		 * future requests should not occur until the device 
 		 * transitions out of the suspend state.
 		 */
-		scsi_queue_insert(cmd, SCSI_MLQUEUE_DEVICE_BUSY);
+		scsi_attempt_requeue_command(cmd, SCSI_MLQUEUE_DEVICE_BUSY);
 
 		SCSI_LOG_MLQUEUE(3, printk("queuecommand : device blocked \n"));
 
@@ -756,7 +756,7 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 	if (rtn) {
 		if (scsi_delete_timer(cmd)) {
 			atomic_inc(&cmd->device->iodone_cnt);
-			scsi_queue_insert(cmd,
+			scsi_attempt_requeue_command(cmd,
 					  (rtn == SCSI_MLQUEUE_DEVICE_BUSY) ?
 					  rtn : SCSI_MLQUEUE_HOST_BUSY);
 		}
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 6b8cbb1..45c7d24 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1563,7 +1563,8 @@ void scsi_eh_flush_done_q(struct list_head *done_q)
 							  " retry cmd: %p\n",
 							  current->comm,
 							  scmd));
-			scsi_queue_insert(scmd, SCSI_MLQUEUE_DIS_RETRY);
+			scsi_attempt_requeue_command(scmd,
+						     SCSI_MLQUEUE_DIS_RETRY);
 		} else {
 			/*
 			 * If just we got sense for the device (called
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 51a737f..9bbc11d 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -92,9 +92,9 @@ static void scsi_unprep_request(struct request *req)
 }
 
 /*
- * Function:    scsi_queue_insert()
+ * Function:    scsi_attempt_requeue_command()
  *
- * Purpose:     Insert a command in the midlevel queue.
+ * Purpose:     Attempt to insert a command in the midlevel queue.
  *
  * Arguments:   cmd    - command that we are adding to queue.
  *              reason - why we are inserting command to queue.
@@ -103,14 +103,20 @@ static void scsi_unprep_request(struct request *req)
  *
  * Returns:     Nothing.
  *
- * Notes:       We do this for one of two cases.  Either the host is busy
- *              and it cannot accept any more commands for the time being,
- *              or the device returned QUEUE_FULL and can accept no more
- *              commands.
+ * Notes:       We do this for multiple cases.
+ *
+ *		Host or device queueing:
+ *		Either the host or device is busy and it cannot accept any more
+ *		commands for the time being.
+ *
+ * 		SCSI error processing:
+ * 		The scsi-eh has decided to requeue a command after getting
+ * 		a command it believes ir retryable.
+ *
  * Notes:       This could be called either from an interrupt context or a
  *              normal process context.
  */
-int scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
+int scsi_attempt_requeue_command(struct scsi_cmnd *cmd, int reason)
 {
 	struct Scsi_Host *host = cmd->device->host;
 	struct scsi_device *device = cmd->device;
@@ -1457,7 +1463,7 @@ static void scsi_softirq_done(struct request *rq)
 	if (scsi_disposition_finish(disposition))
 		scsi_finish_command(cmd);
 	else if (scsi_disposition_retry(disposition))
-		scsi_queue_insert(cmd, disposition);
+		scsi_attempt_requeue_command(cmd, disposition);
 	else
 		if (!scsi_eh_scmd_add(cmd, 0))
 			scsi_finish_command(cmd);
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 79f0f75..e702513 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -66,7 +66,7 @@ int scsi_eh_get_sense(struct list_head *work_q,
 /* scsi_lib.c */
 extern int scsi_maybe_unblock_host(struct scsi_device *sdev);
 extern void scsi_device_unbusy(struct scsi_device *sdev);
-extern int scsi_queue_insert(struct scsi_cmnd *cmd, int reason);
+extern int scsi_attempt_requeue_command(struct scsi_cmnd *cmd, int reason);
 extern void scsi_next_command(struct scsi_cmnd *cmd);
 extern void scsi_io_completion(struct scsi_cmnd *, unsigned int);
 extern void scsi_run_host_queues(struct Scsi_Host *shost);
-- 
1.5.5.1

