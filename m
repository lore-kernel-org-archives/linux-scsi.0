From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH v8 09/10] block, scsi: Make SCSI quiesce and resume work reliably
Date: Tue, 10 Oct 2017 14:03:45 -0700
Message-ID: <20171010210346.14574-10-bart.vanassche@wdc.com>
References: <20171010210346.14574-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:10106 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933004AbdJJVDy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Oct 2017 17:03:54 -0400
In-Reply-To: <20171010210346.14574-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, Ming Lei <ming.lei@redhat.com>, Bart Van Assche <bart.vanassche@wdc.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>

The contexts from which a SCSI device can be quiesced or resumed are:
* Writing into /sys/class/scsi_device/*/device/state.
* SCSI parallel (SPI) domain validation.
* The SCSI device power management methods. See also scsi_bus_pm_ops.

It is essential during suspend and resume that neither the filesystem
state nor the filesystem metadata in RAM changes. This is why while
the hibernation image is being written or restored that SCSI devices
are quiesced. The SCSI core quiesces devices through scsi_device_quiesce()
and scsi_device_resume(). In the SDEV_QUIESCE state execution of
non-preempt requests is deferred. This is realized by returning
BLKPREP_DEFER from inside scsi_prep_state_check() for quiesced SCSI
devices. Avoid that a full queue prevents power management requests
to be submitted by deferring allocation of non-preempt requests for
devices in the quiesced state. This patch has been tested by running
the following commands and by verifying that after resume the fio job
is still running:

for d in /sys/class/block/sd*[a-z]; do
  hcil=$(readlink "$d/device")
  hcil=${hcil#../../../}
  echo 4 > "$d/queue/nr_requests"
  echo 1 > "/sys/class/scsi_device/$hcil/device/queue_depth"
done
bdev=$(readlink /dev/disk/by-uuid/5217d83f-213e-4b42-b86e-20013325ba6c)
bdev=${bdev#../../}
hcil=$(readlink "/sys/block/$bdev/device")
hcil=${hcil#../../../}
fio --name="$bdev" --filename="/dev/$bdev" --buffered=0 --bs=512 --rw=randread \
  --ioengine=libaio --numjobs=4 --iodepth=16 --iodepth_batch=1 --thread \
  --loops=$((2**31)) &
pid=$!
sleep 1
systemctl hibernate
sleep 10
kill $pid

Reported-by: Oleksandr Natalenko <oleksandr@natalenko.name>
References: "I/O hangs after resuming from suspend-to-ram" (https://marc.info/?l=linux-block&m=150340235201348).
Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 block/blk-core.c        | 42 +++++++++++++++++++++++++++++++++++-------
 block/blk-mq.c          |  4 ++--
 block/blk-timeout.c     |  2 +-
 drivers/scsi/scsi_lib.c | 29 +++++++++++++++++++----------
 fs/block_dev.c          |  4 ++--
 include/linux/blkdev.h  |  2 +-
 6 files changed, 60 insertions(+), 23 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index ed992cbd107f..3847ea42e341 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -372,6 +372,7 @@ void blk_clear_preempt_only(struct request_queue *q)
 
 	spin_lock_irqsave(q->queue_lock, flags);
 	queue_flag_clear(QUEUE_FLAG_PREEMPT_ONLY, q);
+	wake_up_all(&q->mq_freeze_wq);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 }
 EXPORT_SYMBOL_GPL(blk_clear_preempt_only);
@@ -793,15 +794,40 @@ struct request_queue *blk_alloc_queue(gfp_t gfp_mask)
 }
 EXPORT_SYMBOL(blk_alloc_queue);
 
-int blk_queue_enter(struct request_queue *q, bool nowait)
+/**
+ * blk_queue_enter() - try to increase q->q_usage_counter
+ * @q: request queue pointer
+ * @flags: BLK_MQ_REQ_NOWAIT and/or BLK_MQ_REQ_PREEMPT
+ */
+int blk_queue_enter(struct request_queue *q, unsigned int flags)
 {
+	const bool preempt = flags & BLK_MQ_REQ_PREEMPT;
+
 	while (true) {
+		bool success = false;
 		int ret;
 
-		if (percpu_ref_tryget_live(&q->q_usage_counter))
+		rcu_read_lock_sched();
+		if (percpu_ref_tryget_live(&q->q_usage_counter)) {
+			/*
+			 * The code that sets the PREEMPT_ONLY flag is
+			 * responsible for ensuring that that flag is globally
+			 * visible before the queue is unfrozen.
+			 */
+			if (preempt || !blk_queue_preempt_only(q)) {
+				success = true;
+			} else {
+				percpu_ref_put(&q->q_usage_counter);
+				WARN_ONCE("%s: Attempt to allocate non-preempt request in preempt-only mode.\n",
+					  kobject_name(q->kobj.parent));
+			}
+		}
+		rcu_read_unlock_sched();
+
+		if (success)
 			return 0;
 
-		if (nowait)
+		if (flags & BLK_MQ_REQ_NOWAIT)
 			return -EBUSY;
 
 		/*
@@ -814,7 +840,8 @@ int blk_queue_enter(struct request_queue *q, bool nowait)
 		smp_rmb();
 
 		ret = wait_event_interruptible(q->mq_freeze_wq,
-				!atomic_read(&q->mq_freeze_depth) ||
+				(atomic_read(&q->mq_freeze_depth) == 0 &&
+				 (preempt || !blk_queue_preempt_only(q))) ||
 				blk_queue_dying(q));
 		if (blk_queue_dying(q))
 			return -ENODEV;
@@ -1442,8 +1469,7 @@ static struct request *blk_old_get_request(struct request_queue *q,
 	/* create ioc upfront */
 	create_io_context(gfp_mask, q->node);
 
-	ret = blk_queue_enter(q, !(gfp_mask & __GFP_DIRECT_RECLAIM) ||
-			      (op & REQ_NOWAIT));
+	ret = blk_queue_enter(q, flags);
 	if (ret)
 		return ERR_PTR(ret);
 	spin_lock_irq(q->queue_lock);
@@ -2264,8 +2290,10 @@ blk_qc_t generic_make_request(struct bio *bio)
 	current->bio_list = bio_list_on_stack;
 	do {
 		struct request_queue *q = bio->bi_disk->queue;
+		unsigned int flags = bio->bi_opf & REQ_NOWAIT ?
+			BLK_MQ_REQ_NOWAIT : 0;
 
-		if (likely(blk_queue_enter(q, bio->bi_opf & REQ_NOWAIT) == 0)) {
+		if (likely(blk_queue_enter(q, flags) == 0)) {
 			struct bio_list lower, same;
 
 			/* Create a fresh bio_list for all subordinate requests */
diff --git a/block/blk-mq.c b/block/blk-mq.c
index bdbfe760bda0..44a06e8541f2 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -386,7 +386,7 @@ struct request *blk_mq_alloc_request(struct request_queue *q, unsigned int op,
 	struct request *rq;
 	int ret;
 
-	ret = blk_queue_enter(q, flags & BLK_MQ_REQ_NOWAIT);
+	ret = blk_queue_enter(q, flags);
 	if (ret)
 		return ERR_PTR(ret);
 
@@ -425,7 +425,7 @@ struct request *blk_mq_alloc_request_hctx(struct request_queue *q,
 	if (hctx_idx >= q->nr_hw_queues)
 		return ERR_PTR(-EIO);
 
-	ret = blk_queue_enter(q, true);
+	ret = blk_queue_enter(q, flags);
 	if (ret)
 		return ERR_PTR(ret);
 
diff --git a/block/blk-timeout.c b/block/blk-timeout.c
index e3e9c9771d36..1eba71486716 100644
--- a/block/blk-timeout.c
+++ b/block/blk-timeout.c
@@ -134,7 +134,7 @@ void blk_timeout_work(struct work_struct *work)
 	struct request *rq, *tmp;
 	int next_set = 0;
 
-	if (blk_queue_enter(q, true))
+	if (blk_queue_enter(q, BLK_MQ_REQ_NOWAIT | BLK_MQ_REQ_PREEMPT))
 		return;
 	spin_lock_irqsave(q->queue_lock, flags);
 
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 1c16a247fae6..462e3fe385db 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2926,21 +2926,30 @@ static void scsi_wait_for_queuecommand(struct scsi_device *sdev)
 int
 scsi_device_quiesce(struct scsi_device *sdev)
 {
+	struct request_queue *q = sdev->request_queue;
 	int err;
 
+	/* If the SCSI device has already been quiesced, do nothing. */
+	if (blk_set_preempt_only(q))
+		return 0;
+
+	blk_mq_freeze_queue(q);
+	/*
+	 * Ensure that the effect of blk_set_preempt_only() will be visible
+	 * for percpu_ref_tryget() callers that occur after the queue
+	 * unfreeze even if the queue was already frozen before this function
+	 * was called. See also https://lwn.net/Articles/573497/.
+	 */
+	synchronize_rcu();
+	blk_mq_unfreeze_queue(q);
+
 	mutex_lock(&sdev->state_mutex);
 	err = scsi_device_set_state(sdev, SDEV_QUIESCE);
-	mutex_unlock(&sdev->state_mutex);
-
 	if (err)
-		return err;
+		blk_clear_preempt_only(q);
+	mutex_unlock(&sdev->state_mutex);
 
-	scsi_run_queue(sdev->request_queue);
-	while (atomic_read(&sdev->device_busy)) {
-		msleep_interruptible(200);
-		scsi_run_queue(sdev->request_queue);
-	}
-	return 0;
+	return err;
 }
 EXPORT_SYMBOL(scsi_device_quiesce);
 
@@ -2962,7 +2971,7 @@ void scsi_device_resume(struct scsi_device *sdev)
 	mutex_lock(&sdev->state_mutex);
 	if (sdev->sdev_state == SDEV_QUIESCE &&
 	    scsi_device_set_state(sdev, SDEV_RUNNING) == 0)
-		scsi_run_queue(sdev->request_queue);
+		blk_clear_preempt_only(sdev->request_queue);
 	mutex_unlock(&sdev->state_mutex);
 }
 EXPORT_SYMBOL(scsi_device_resume);
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 93d088ffc05c..98cf2d7ee9d3 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -674,7 +674,7 @@ int bdev_read_page(struct block_device *bdev, sector_t sector,
 	if (!ops->rw_page || bdev_get_integrity(bdev))
 		return result;
 
-	result = blk_queue_enter(bdev->bd_queue, false);
+	result = blk_queue_enter(bdev->bd_queue, 0);
 	if (result)
 		return result;
 	result = ops->rw_page(bdev, sector + get_start_sect(bdev), page, false);
@@ -710,7 +710,7 @@ int bdev_write_page(struct block_device *bdev, sector_t sector,
 
 	if (!ops->rw_page || bdev_get_integrity(bdev))
 		return -EOPNOTSUPP;
-	result = blk_queue_enter(bdev->bd_queue, false);
+	result = blk_queue_enter(bdev->bd_queue, 0);
 	if (result)
 		return result;
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 89555eea742b..0a4638cf0687 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -967,7 +967,7 @@ extern int scsi_cmd_ioctl(struct request_queue *, struct gendisk *, fmode_t,
 extern int sg_scsi_ioctl(struct request_queue *, struct gendisk *, fmode_t,
 			 struct scsi_ioctl_command __user *);
 
-extern int blk_queue_enter(struct request_queue *q, bool nowait);
+extern int blk_queue_enter(struct request_queue *q, unsigned int flags);
 extern void blk_queue_exit(struct request_queue *q);
 extern void blk_start_queue(struct request_queue *q);
 extern void blk_start_queue_async(struct request_queue *q);
-- 
2.14.2
