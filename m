From: Ganesh Mahendran <opensource.ganesh@gmail.com>
Subject: [PATCH] scsi_lib: increase {host|target|device}_busy count after dispatch cmd
Date: Mon,  5 Jun 2017 17:37:58 +0800
Message-ID: <1496655478-4039-1-git-send-email-opensource.ganesh@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, bart.vanassche@sandisk.com, hch@lst.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Ganesh Mahendran <opensource.ganesh@gmail.com>
List-Id: linux-scsi@vger.kernel.org

In android system, when there are lots of threads running. Thread A
holding *host_busy* count is easily to be preempted, and if at the
same time, thread B set *host_blocked*, then all other threads will
be io blocked.

Below the detail:
1). Thread A calls scsi_request_fn() and it increases *host_busy*.
    But soon it is preempted.
2). Thread B call scsi_request_fn(), and it got failure from
    scsi_dispatch_cmd(). So it set *host_blocked*
3). All the io blocked...
4). Thread A is scheduled again, and it decreases *host_busy*
    in scsi_device_unbusy()

Afer step 2), all the io will be blocked, since scsi_host_queue_ready()
will always return 0.
----
scsi_host_queue_ready
{
	if (atomic_read(&shost->host_blocked) > 0) {
		if (busy)  ==> true after step 2
			goto starved;
}
----

The system will be unblocked after step 4).

This patch increases {host|target|device}_busy count after dispatch cmd.

Signed-off-by: Ganesh Mahendran <opensource.ganesh@gmail.com>
---
 drivers/scsi/scsi_lib.c | 66 ++++++++++++++++++++++++-------------------------
 1 file changed, 32 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 884aaa8..9cac272 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -311,6 +311,16 @@ static void scsi_init_cmd_errh(struct scsi_cmnd *cmd)
 		cmd->cmd_len = scsi_command_size(cmd->cmnd);
 }
 
+static void scsi_device_busy(struct scsi_device *sdev)
+{
+	struct Scsi_Host *shost = sdev->host;
+	struct scsi_target *starget = scsi_target(sdev);
+
+	atomic_inc(&sdev->device_busy);
+	atomic_inc(&shost->host_busy);
+	atomic_inc(&starget->target_busy);
+}
+
 void scsi_device_unbusy(struct scsi_device *sdev)
 {
 	struct Scsi_Host *shost = sdev->host;
@@ -1352,12 +1362,13 @@ static void scsi_unprep_fn(struct request_queue *q, struct request *req)
 static inline int scsi_dev_queue_ready(struct request_queue *q,
 				  struct scsi_device *sdev)
 {
+	int ret = 0;
 	unsigned int busy;
 
-	busy = atomic_inc_return(&sdev->device_busy) - 1;
+	busy = atomic_read(&sdev->device_busy);
 	if (atomic_read(&sdev->device_blocked)) {
 		if (busy)
-			goto out_dec;
+			goto out;
 
 		/*
 		 * unblock after device_blocked iterates to zero
@@ -1368,19 +1379,18 @@ static inline int scsi_dev_queue_ready(struct request_queue *q,
 			 */
 			if (!q->mq_ops)
 				blk_delay_queue(q, SCSI_QUEUE_DELAY);
-			goto out_dec;
+			goto out;
 		}
 		SCSI_LOG_MLQUEUE(3, sdev_printk(KERN_INFO, sdev,
 				   "unblocking device at zero depth\n"));
 	}
 
 	if (busy >= sdev->queue_depth)
-		goto out_dec;
+		goto out;
 
-	return 1;
-out_dec:
-	atomic_dec(&sdev->device_busy);
-	return 0;
+	ret = 1;
+out:
+	return ret;
 }
 
 /*
@@ -1407,7 +1417,7 @@ static inline int scsi_target_queue_ready(struct Scsi_Host *shost,
 	if (starget->can_queue <= 0)
 		return 1;
 
-	busy = atomic_inc_return(&starget->target_busy) - 1;
+	busy = atomic_read(&starget->target_busy);
 	if (atomic_read(&starget->target_blocked) > 0) {
 		if (busy)
 			goto starved;
@@ -1416,7 +1426,7 @@ static inline int scsi_target_queue_ready(struct Scsi_Host *shost,
 		 * unblock after target_blocked iterates to zero
 		 */
 		if (atomic_dec_return(&starget->target_blocked) > 0)
-			goto out_dec;
+			goto out;
 
 		SCSI_LOG_MLQUEUE(3, starget_printk(KERN_INFO, starget,
 				 "unblocking target at zero depth\n"));
@@ -1431,9 +1441,7 @@ static inline int scsi_target_queue_ready(struct Scsi_Host *shost,
 	spin_lock_irq(shost->host_lock);
 	list_move_tail(&sdev->starved_entry, &shost->starved_list);
 	spin_unlock_irq(shost->host_lock);
-out_dec:
-	if (starget->can_queue > 0)
-		atomic_dec(&starget->target_busy);
+out:
 	return 0;
 }
 
@@ -1451,7 +1459,7 @@ static inline int scsi_host_queue_ready(struct request_queue *q,
 	if (scsi_host_in_recovery(shost))
 		return 0;
 
-	busy = atomic_inc_return(&shost->host_busy) - 1;
+	busy = atomic_read(&shost->host_busy);
 	if (atomic_read(&shost->host_blocked) > 0) {
 		if (busy)
 			goto starved;
@@ -1460,7 +1468,7 @@ static inline int scsi_host_queue_ready(struct request_queue *q,
 		 * unblock after host_blocked iterates to zero
 		 */
 		if (atomic_dec_return(&shost->host_blocked) > 0)
-			goto out_dec;
+			goto out;
 
 		SCSI_LOG_MLQUEUE(3,
 			shost_printk(KERN_INFO, shost,
@@ -1487,8 +1495,7 @@ static inline int scsi_host_queue_ready(struct request_queue *q,
 	if (list_empty(&sdev->starved_entry))
 		list_add_tail(&sdev->starved_entry, &shost->starved_list);
 	spin_unlock_irq(shost->host_lock);
-out_dec:
-	atomic_dec(&shost->host_busy);
+out:
 	return 0;
 }
 
@@ -1781,7 +1788,7 @@ static void scsi_request_fn(struct request_queue *q)
 			goto not_ready;
 
 		if (!scsi_host_queue_ready(q, shost, sdev))
-			goto host_not_ready;
+			goto not_ready;
 	
 		if (sdev->simple_tags)
 			cmd->flags |= SCMD_TAGGED;
@@ -1800,18 +1807,16 @@ static void scsi_request_fn(struct request_queue *q)
 		cmd->scsi_done = scsi_done;
 		rtn = scsi_dispatch_cmd(cmd);
 		if (rtn) {
-			scsi_queue_insert(cmd, rtn);
+			__scsi_queue_insert(cmd, rtn, 0);
 			spin_lock_irq(q->queue_lock);
 			goto out_delay;
 		}
+		scsi_device_busy(sdev);
 		spin_lock_irq(q->queue_lock);
 	}
 
 	return;
 
- host_not_ready:
-	if (scsi_target(sdev)->can_queue > 0)
-		atomic_dec(&scsi_target(sdev)->target_busy);
  not_ready:
 	/*
 	 * lock q, handle tag, requeue req, and decrement device_busy. We
@@ -1823,7 +1828,6 @@ static void scsi_request_fn(struct request_queue *q)
 	 */
 	spin_lock_irq(q->queue_lock);
 	blk_requeue_request(q, req);
-	atomic_dec(&sdev->device_busy);
 out_delay:
 	if (!atomic_read(&sdev->device_busy) && !scsi_device_blocked(sdev))
 		blk_delay_queue(q, SCSI_QUEUE_DELAY);
@@ -1931,14 +1935,14 @@ static int scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 	if (!scsi_dev_queue_ready(q, sdev))
 		goto out_put_device;
 	if (!scsi_target_queue_ready(shost, sdev))
-		goto out_dec_device_busy;
+		goto out_put_device;
 	if (!scsi_host_queue_ready(q, shost, sdev))
-		goto out_dec_target_busy;
+		goto out_put_device;
 
 	if (!(req->rq_flags & RQF_DONTPREP)) {
 		ret = prep_to_mq(scsi_mq_prep_fn(req));
 		if (ret != BLK_MQ_RQ_QUEUE_OK)
-			goto out_dec_host_busy;
+			goto out_put_device;
 		req->rq_flags |= RQF_DONTPREP;
 	} else {
 		blk_mq_start_request(req);
@@ -1956,18 +1960,12 @@ static int scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 	if (reason) {
 		scsi_set_blocked(cmd, reason);
 		ret = BLK_MQ_RQ_QUEUE_BUSY;
-		goto out_dec_host_busy;
+		goto out_put_device;
 	}
+	scsi_device_busy(sdev);
 
 	return BLK_MQ_RQ_QUEUE_OK;
 
-out_dec_host_busy:
-	atomic_dec(&shost->host_busy);
-out_dec_target_busy:
-	if (scsi_target(sdev)->can_queue > 0)
-		atomic_dec(&scsi_target(sdev)->target_busy);
-out_dec_device_busy:
-	atomic_dec(&sdev->device_busy);
 out_put_device:
 	put_device(&sdev->sdev_gendev);
 out:
-- 
1.9.1
