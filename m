From: Lin Ming <ming.m.lin@intel.com>
Subject: [RFC v2 PATCH 2/4] block: add queue runtime pm callbacks
Date: Thu, 17 May 2012 23:48:04 +0800
Message-ID: <1337269686-3781-3-git-send-email-ming.m.lin@intel.com>
References: <1337269686-3781-1-git-send-email-ming.m.lin@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1337269686-3781-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Alan Stern <stern@rowland.harvard.edu>, Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, Lin Ming <ming.m.lin@intel.com>
List-Id: linux-scsi@vger.kernel.org

Add runtime pm suspend/resume callbacks to request queue.
As an example, implement these callbacks in sd driver.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 block/blk-settings.c   |    8 ++++++++
 drivers/scsi/sd.c      |   21 +++++++++++++++++++++
 include/linux/blkdev.h |    6 ++++++
 3 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index d3234fc..120d9fc 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -99,6 +99,14 @@ void blk_queue_lld_busy(struct request_queue *q, lld_busy_fn *fn)
 }
 EXPORT_SYMBOL_GPL(blk_queue_lld_busy);
 
+void blk_queue_runtime_pm(struct request_queue *q,
+		runtime_pm_fn *suspend_fn, runtime_pm_fn *resume_fn)
+{
+	q->runtime_suspend = suspend_fn;
+	q->runtime_resume = resume_fn;
+}
+EXPORT_SYMBOL_GPL(blk_queue_runtime_pm);
+
 /**
  * blk_set_default_limits - reset limits to default values
  * @lim:  the queue_limits structure to reset
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 1205a8b..0335cde 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -938,6 +938,25 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 	return scsi_prep_return(q, rq, ret);
 }
 
+static int sd_block_runtime_suspend(struct request_queue *q)
+{
+	struct scsi_device *sdp = q->queuedata;
+
+	pm_runtime_mark_last_busy(&sdp->sdev_gendev);
+	pm_runtime_put_autosuspend(&sdp->sdev_gendev);
+
+	return 0;
+}
+
+static int sd_block_runtime_resume(struct request_queue *q)
+{
+	struct scsi_device *sdp = q->queuedata;
+
+	pm_runtime_get(&sdp->sdev_gendev);
+
+	return 0;
+}
+
 /**
  *	sd_open - open a scsi disk device
  *	@inode: only i_rdev member may be used
@@ -2616,6 +2635,8 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
 
 	blk_queue_prep_rq(sdp->request_queue, sd_prep_fn);
 	blk_queue_unprep_rq(sdp->request_queue, sd_unprep_fn);
+	blk_queue_runtime_pm(sdp->request_queue,
+		sd_block_runtime_suspend, sd_block_runtime_resume);
 
 	gd->driverfs_dev = &sdp->sdev_gendev;
 	gd->flags = GENHD_FL_EXT_DEVT;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 2aa2466..f52f518 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -216,6 +216,7 @@ typedef void (softirq_done_fn)(struct request *);
 typedef int (dma_drain_needed_fn)(struct request *);
 typedef int (lld_busy_fn) (struct request_queue *q);
 typedef int (bsg_job_fn) (struct bsg_job *);
+typedef int (runtime_pm_fn) (struct request_queue *q);
 
 enum blk_eh_timer_return {
 	BLK_EH_NOT_HANDLED,
@@ -289,6 +290,9 @@ struct request_queue {
 	rq_timed_out_fn		*rq_timed_out_fn;
 	dma_drain_needed_fn	*dma_drain_needed;
 	lld_busy_fn		*lld_busy_fn;
+	runtime_pm_fn		*runtime_suspend;
+	runtime_pm_fn		*runtime_resume;
+	int			rpm_status;
 
 	/*
 	 * Dispatch queue sorting
@@ -855,6 +859,8 @@ extern void blk_queue_segment_boundary(struct request_queue *, unsigned long);
 extern void blk_queue_prep_rq(struct request_queue *, prep_rq_fn *pfn);
 extern void blk_queue_unprep_rq(struct request_queue *, unprep_rq_fn *ufn);
 extern void blk_queue_merge_bvec(struct request_queue *, merge_bvec_fn *);
+extern void blk_queue_runtime_pm(struct request_queue *q,
+		runtime_pm_fn *, runtime_pm_fn *);
 extern void blk_queue_dma_alignment(struct request_queue *, int);
 extern void blk_queue_update_dma_alignment(struct request_queue *, int);
 extern void blk_queue_softirq_done(struct request_queue *, softirq_done_fn *);
-- 
1.7.2.5
