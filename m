From: Lin Ming <ming.m.lin@intel.com>
Subject: [RFC v2 PATCH 3/4] block: implement block layer runtime pm
Date: Thu, 17 May 2012 23:48:05 +0800
Message-ID: <1337269686-3781-4-git-send-email-ming.m.lin@intel.com>
References: <1337269686-3781-1-git-send-email-ming.m.lin@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1337269686-3781-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Alan Stern <stern@rowland.harvard.edu>, Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, Lin Ming <ming.m.lin@intel.com>
List-Id: linux-scsi@vger.kernel.org

A new queue field "nr_pending" is added to record the nummber of
requests pending. When queue becomes empty, an auto delayed suspend is
requested. If the queue continue to be empty for some time then it'll be
actually suspended. The time interval can be set via runtime pm sysfs
interface: autosuspend_delay_ms.

If new request comes and queue goes out of empty, then device is async
resumed.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 block/blk-core.c       |   12 ++++++++++++
 block/elevator.c       |    9 +++++++++
 drivers/scsi/sd.c      |   28 ++++++++++++++++++++++++++++
 include/linux/blkdev.h |    1 +
 4 files changed, 50 insertions(+), 0 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 1f61b74..b0e381e 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1129,6 +1129,12 @@ void __blk_put_request(struct request_queue *q, struct request *req)
 	if (unlikely(--req->ref_count))
 		return;
 
+	/* PM request is not accounted */
+	if (!(req->cmd_flags & REQ_PM)) {
+		if (!(--q->nr_pending) && q->runtime_suspend)
+			q->runtime_suspend(q);
+	}
+
 	elv_completed_request(q, req);
 
 	/* this is a bio leak */
@@ -1917,6 +1923,12 @@ struct request *blk_peek_request(struct request_queue *q)
 	int ret;
 
 	while ((rq = __elv_next_request(q)) != NULL) {
+		/* Only PM request is allowed to go if the queue is suspended */
+		if (q->rpm_status != RPM_ACTIVE && !(rq->cmd_flags & REQ_PM)) {
+			rq = NULL;
+			break;
+		}
+
 		if (!(rq->cmd_flags & REQ_STARTED)) {
 			/*
 			 * This is the first time the device driver
diff --git a/block/elevator.c b/block/elevator.c
index f016855..ac67bff 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -546,6 +546,9 @@ void elv_requeue_request(struct request_queue *q, struct request *rq)
 
 	rq->cmd_flags &= ~REQ_STARTED;
 
+	/* __elv_add_request will increment the count */
+	if (!(rq->cmd_flags & REQ_PM))
+		q->nr_pending--;
 	__elv_add_request(q, rq, ELEVATOR_INSERT_REQUEUE);
 }
 
@@ -587,6 +590,12 @@ void __elv_add_request(struct request_queue *q, struct request *rq, int where)
 {
 	trace_block_rq_insert(q, rq);
 
+	if (!(rq->cmd_flags & REQ_PM)) {
+		if (q->nr_pending++ == 0 && q->runtime_resume)
+			/* async resume */
+			q->runtime_resume(q);
+	}
+
 	rq->q = q;
 
 	if (rq->cmd_flags & REQ_SOFTBARRIER) {
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 0335cde..2c3c8e7 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2878,11 +2878,21 @@ static void sd_shutdown(struct device *dev)
 static int sd_suspend(struct device *dev, pm_message_t mesg)
 {
 	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
+	struct request_queue *q = sdkp->disk->queue;
 	int ret = 0;
 
 	if (!sdkp)
 		return 0;	/* this can happen */
 
+	spin_lock_irq(q->queue_lock);
+	if (q->nr_pending) {
+		spin_unlock_irq(q->queue_lock);
+		ret = -EBUSY;
+		goto done;
+	}
+	q->rpm_status = RPM_SUSPENDING;
+	spin_unlock_irq(q->queue_lock);
+
 	if (sdkp->WCE) {
 		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
 		ret = sd_sync_cache(sdkp);
@@ -2893,6 +2903,12 @@ static int sd_suspend(struct device *dev, pm_message_t mesg)
 	if ((mesg.event & PM_EVENT_SLEEP) && sdkp->device->manage_start_stop) {
 		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
 		ret = sd_start_stop_device(sdkp, 0);
+		spin_lock_irq(q->queue_lock);
+		if (!ret)
+			q->rpm_status = RPM_SUSPENDED;
+		else
+			q->rpm_status = RPM_ACTIVE;
+		spin_unlock_irq(q->queue_lock);
 	}
 
 done:
@@ -2903,13 +2919,25 @@ static int sd_suspend(struct device *dev, pm_message_t mesg)
 static int sd_resume(struct device *dev)
 {
 	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
+	struct request_queue *q = sdkp->disk->queue;
 	int ret = 0;
 
 	if (!sdkp->device->manage_start_stop)
 		goto done;
 
+	spin_lock_irq(q->queue_lock);
+	q->rpm_status = RPM_RESUMING;
+	spin_unlock_irq(q->queue_lock);
+
 	sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
 	ret = sd_start_stop_device(sdkp, 1);
+	if (!ret) {
+		spin_lock_irq(q->queue_lock);
+		q->rpm_status = RPM_ACTIVE;
+		pm_runtime_mark_last_busy(dev);
+		__blk_run_queue(sdkp->disk->queue);
+		spin_unlock_irq(q->queue_lock);
+	}
 
 done:
 	scsi_disk_put(sdkp);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index f52f518..bde2021 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -349,6 +349,7 @@ struct request_queue {
 	unsigned int		nr_congestion_on;
 	unsigned int		nr_congestion_off;
 	unsigned int		nr_batching;
+	unsigned int		nr_pending;
 
 	unsigned int		dma_drain_size;
 	void			*dma_drain_buffer;
-- 
1.7.2.5
