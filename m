From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 3/4] scsi: Change return type of scsi_queue_insert() into
 void
Date: Mon, 25 Jun 2012 18:16:04 +0000
Message-ID: <4FE8AAE4.3000208@acm.org>
References: <4FE8A9FC.6040805@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay04ant.iops.be ([212.53.5.219]:45882 "EHLO
	relay04ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435Ab2FYSQH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Jun 2012 14:16:07 -0400
In-Reply-To: <4FE8A9FC.6040805@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>

The return value of scsi_queue_insert() is ignored by all its
callers, hence change the return type of this function into
void.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <JBottomley@parallels.com>
Cc: <stable@kernel.org>
---
 drivers/scsi/scsi_lib.c  |    8 +++-----
 drivers/scsi/scsi_priv.h |    2 +-
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index c26ef49..082c1e5 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -109,7 +109,7 @@ static void scsi_unprep_request(struct request *req)
  * for a requeue after completion, which should only occur in this
  * file.
  */
-static int __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, int unbusy)
+static void __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, int unbusy)
 {
 	struct Scsi_Host *host = cmd->device->host;
 	struct scsi_device *device = cmd->device;
@@ -162,8 +162,6 @@ static int __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, int unbusy)
 	spin_unlock_irqrestore(q->queue_lock, flags);
 
 	kblockd_schedule_work(q, &device->requeue_work);
-
-	return 0;
 }
 
 /*
@@ -185,9 +183,9 @@ static int __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, int unbusy)
  * Notes:       This could be called either from an interrupt context or a
  *              normal process context.
  */
-int scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
+void scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
 {
-	return __scsi_queue_insert(cmd, reason, 1);
+	__scsi_queue_insert(cmd, reason, 1);
 }
 /**
  * scsi_execute - insert request and wait for the result
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 2b8d8b5..cacb0e7 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -79,7 +79,7 @@ int scsi_noretry_cmd(struct scsi_cmnd *scmd);
 /* scsi_lib.c */
 extern int scsi_maybe_unblock_host(struct scsi_device *sdev);
 extern void scsi_device_unbusy(struct scsi_device *sdev);
-extern int scsi_queue_insert(struct scsi_cmnd *cmd, int reason);
+extern void scsi_queue_insert(struct scsi_cmnd *cmd, int reason);
 extern void scsi_next_command(struct scsi_cmnd *cmd);
 extern void scsi_io_completion(struct scsi_cmnd *, unsigned int);
 extern void scsi_run_host_queues(struct Scsi_Host *shost);
