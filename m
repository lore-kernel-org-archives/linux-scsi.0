From: Lin Ming <ming.m.lin@intel.com>
Subject: [RFC PATCH 2/3] block: add queue runtime pm callback
Date: Tue, 15 May 2012 16:48:16 +0800
Message-ID: <1337071697-30920-3-git-send-email-ming.m.lin@intel.com>
References: <1337071697-30920-1-git-send-email-ming.m.lin@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1337071697-30920-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Add ->runtime_pm callback and ->pm_status to request queue.
As an example, implement a simple queue runtime_pm callback
in sd driver.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 block/blk-settings.c   |    6 ++++++
 drivers/scsi/sd.c      |   32 ++++++++++++++++++++++++++++++++
 include/linux/blkdev.h |    5 +++++
 3 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index d3234fc..51be5f9 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -99,6 +99,12 @@ void blk_queue_lld_busy(struct request_queue *q, lld_busy_fn *fn)
 }
 EXPORT_SYMBOL_GPL(blk_queue_lld_busy);
 
+void blk_queue_runtime_pm(struct request_queue *q, runtime_pm_fn *fn)
+{
+	q->runtime_pm = fn;
+}
+EXPORT_SYMBOL_GPL(blk_queue_runtime_pm);
+
 /**
  * blk_set_default_limits - reset limits to default values
  * @lim:  the queue_limits structure to reset
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index e34bc07..a4f049a 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -938,6 +938,22 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 	return scsi_prep_return(q, rq, ret);
 }
 
+static int sd_runtime_pm_fn(struct request_queue *q, pm_message_t mesg)
+{
+	struct scsi_device *sdp = q->queuedata;
+
+	if (mesg.event == PM_EVENT_SUSPEND) {
+		q->pm_status = RPM_SUSPENDING;
+		pm_runtime_put(&sdp->sdev_gendev);
+	}
+	else if (mesg.event == PM_EVENT_RESUME) {
+		q->pm_status = RPM_RESUMING;
+		pm_runtime_get(&sdp->sdev_gendev);
+	}
+
+	return 0;
+}
+
 /**
  *	sd_open - open a scsi disk device
  *	@inode: only i_rdev member may be used
@@ -2616,6 +2632,7 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
 
 	blk_queue_prep_rq(sdp->request_queue, sd_prep_fn);
 	blk_queue_unprep_rq(sdp->request_queue, sd_unprep_fn);
+	blk_queue_runtime_pm(sdp->request_queue, sd_runtime_pm_fn);
 
 	gd->driverfs_dev = &sdp->sdev_gendev;
 	gd->flags = GENHD_FL_EXT_DEVT;
@@ -2872,6 +2889,13 @@ static int sd_suspend(struct device *dev, pm_message_t mesg)
 	if ((mesg.event & PM_EVENT_SLEEP) && sdkp->device->manage_start_stop) {
 		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
 		ret = sd_start_stop_device(sdkp, 0);
+		if (!ret) {
+			struct request_queue *q = sdkp->disk->queue;
+
+			spin_lock_irq(q->queue_lock);
+			q->pm_status = RPM_SUSPENDED;
+			spin_unlock_irq(q->queue_lock);
+		}
 	}
 
 done:
@@ -2889,6 +2913,14 @@ static int sd_resume(struct device *dev)
 
 	sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
 	ret = sd_start_stop_device(sdkp, 1);
+	if (!ret) {
+		struct request_queue *q = sdkp->disk->queue;
+
+		spin_lock_irq(q->queue_lock);
+		q->pm_status = RPM_ACTIVE;
+		__blk_run_queue(sdkp->disk->queue);
+		spin_unlock_irq(q->queue_lock);
+	}
 
 done:
 	scsi_disk_put(sdkp);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 2aa2466..b5b212c 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -216,6 +216,7 @@ typedef void (softirq_done_fn)(struct request *);
 typedef int (dma_drain_needed_fn)(struct request *);
 typedef int (lld_busy_fn) (struct request_queue *q);
 typedef int (bsg_job_fn) (struct bsg_job *);
+typedef int (runtime_pm_fn) (struct request_queue *q, pm_message_t mesg);
 
 enum blk_eh_timer_return {
 	BLK_EH_NOT_HANDLED,
@@ -289,6 +290,7 @@ struct request_queue {
 	rq_timed_out_fn		*rq_timed_out_fn;
 	dma_drain_needed_fn	*dma_drain_needed;
 	lld_busy_fn		*lld_busy_fn;
+	runtime_pm_fn		*runtime_pm;
 
 	/*
 	 * Dispatch queue sorting
@@ -346,6 +348,8 @@ struct request_queue {
 	unsigned int		nr_congestion_off;
 	unsigned int		nr_batching;
 
+	int			pm_status;
+
 	unsigned int		dma_drain_size;
 	void			*dma_drain_buffer;
 	unsigned int		dma_pad_mask;
@@ -855,6 +859,7 @@ extern void blk_queue_segment_boundary(struct request_queue *, unsigned long);
 extern void blk_queue_prep_rq(struct request_queue *, prep_rq_fn *pfn);
 extern void blk_queue_unprep_rq(struct request_queue *, unprep_rq_fn *ufn);
 extern void blk_queue_merge_bvec(struct request_queue *, merge_bvec_fn *);
+extern void blk_queue_runtime_pm(struct request_queue *q, runtime_pm_fn *);
 extern void blk_queue_dma_alignment(struct request_queue *, int);
 extern void blk_queue_update_dma_alignment(struct request_queue *, int);
 extern void blk_queue_softirq_done(struct request_queue *, softirq_done_fn *);
-- 
1.7.2.5
