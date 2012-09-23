From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 1/2] block: Rename queue dead flag
Date: Sun, 23 Sep 2012 18:17:49 +0200
Message-ID: <505F362D.4020206@acm.org>
References: <505F35C9.6070509@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [178.239.52.149] ([178.239.52.149]:46504 "EHLO wimaserver10.be"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754095Ab2IWQSC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Sep 2012 12:18:02 -0400
In-Reply-To: <505F35C9.6070509@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Chanho Min <chanho.min@lge.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, James Bottomley <jbottomley@parallels.com>

This patch is the result of running the command below and manually
fixing up indentation:

git grep -lE 'blk_queue_dead|QUEUE_FLAG_DEAD' |
  xargs sed -i .tmp -e 's/blk_queue_dead/blk_queue_dying/g' \
	-e 's/QUEUE_FLAG_DEAD/QUEUE_FLAG_DYING/g'

Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>
Cc: Chanho Min <chanho.min@lge.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-cgroup.c      |    2 +-
 block/blk-core.c        |   16 ++++++++--------
 block/blk-exec.c        |    2 +-
 block/blk-sysfs.c       |    4 ++--
 block/blk-throttle.c    |    2 +-
 block/blk.h             |    2 +-
 drivers/block/ub.c      |    2 +-
 drivers/scsi/scsi_lib.c |    2 +-
 include/linux/blkdev.h  |    4 ++--
 9 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index f3b44a6..5cbdad5 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -231,7 +231,7 @@ struct blkcg_gq *blkg_lookup_create(struct blkcg *blkcg,
 	 * we shouldn't allow anything to go through for a bypassing queue.
 	 */
 	if (unlikely(blk_queue_bypass(q)))
-		return ERR_PTR(blk_queue_dead(q) ? -EINVAL : -EBUSY);
+		return ERR_PTR(blk_queue_dying(q) ? -EINVAL : -EBUSY);
 	return __blkg_lookup_create(blkcg, q, NULL);
 }
 EXPORT_SYMBOL_GPL(blkg_lookup_create);
diff --git a/block/blk-core.c b/block/blk-core.c
index ee3cb3a..b37ac03 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -484,7 +484,7 @@ void blk_cleanup_queue(struct request_queue *q)
 
 	/* mark @q DEAD, no new request or merges will be allowed afterwards */
 	mutex_lock(&q->sysfs_lock);
-	queue_flag_set_unlocked(QUEUE_FLAG_DEAD, q);
+	queue_flag_set_unlocked(QUEUE_FLAG_DYING, q);
 	spin_lock_irq(lock);
 
 	/*
@@ -501,7 +501,7 @@ void blk_cleanup_queue(struct request_queue *q)
 
 	queue_flag_set(QUEUE_FLAG_NOMERGES, q);
 	queue_flag_set(QUEUE_FLAG_NOXMERGES, q);
-	queue_flag_set(QUEUE_FLAG_DEAD, q);
+	queue_flag_set(QUEUE_FLAG_DYING, q);
 	spin_unlock_irq(lock);
 	mutex_unlock(&q->sysfs_lock);
 
@@ -723,7 +723,7 @@ EXPORT_SYMBOL(blk_init_allocated_queue);
 
 bool blk_get_queue(struct request_queue *q)
 {
-	if (likely(!blk_queue_dead(q))) {
+	if (likely(!blk_queue_dying(q))) {
 		__blk_get_queue(q);
 		return true;
 	}
@@ -877,7 +877,7 @@ static struct request *__get_request(struct request_list *rl, int rw_flags,
 	const bool is_sync = rw_is_sync(rw_flags) != 0;
 	int may_queue;
 
-	if (unlikely(blk_queue_dead(q)))
+	if (unlikely(blk_queue_dying(q)))
 		return NULL;
 
 	may_queue = elv_may_queue(q, rw_flags);
@@ -1057,7 +1057,7 @@ retry:
 	if (rq)
 		return rq;
 
-	if (!(gfp_mask & __GFP_WAIT) || unlikely(blk_queue_dead(q))) {
+	if (!(gfp_mask & __GFP_WAIT) || unlikely(blk_queue_dying(q))) {
 		blk_put_rl(rl);
 		return NULL;
 	}
@@ -1909,7 +1909,7 @@ int blk_insert_cloned_request(struct request_queue *q, struct request *rq)
 		return -EIO;
 
 	spin_lock_irqsave(q->queue_lock, flags);
-	if (unlikely(blk_queue_dead(q))) {
+	if (unlikely(blk_queue_dying(q))) {
 		spin_unlock_irqrestore(q->queue_lock, flags);
 		return -ENODEV;
 	}
@@ -2891,7 +2891,7 @@ static void queue_unplugged(struct request_queue *q, unsigned int depth,
 	/*
 	 * Don't mess with dead queue.
 	 */
-	if (unlikely(blk_queue_dead(q))) {
+	if (unlikely(blk_queue_dying(q))) {
 		spin_unlock(q->queue_lock);
 		return;
 	}
@@ -3000,7 +3000,7 @@ void blk_flush_plug_list(struct blk_plug *plug, bool from_schedule)
 		/*
 		 * Short-circuit if @q is dead
 		 */
-		if (unlikely(blk_queue_dead(q))) {
+		if (unlikely(blk_queue_dying(q))) {
 			__blk_end_request_all(rq, -ENODEV);
 			continue;
 		}
diff --git a/block/blk-exec.c b/block/blk-exec.c
index 8b6dc5b..4aec98d 100644
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -60,7 +60,7 @@ void blk_execute_rq_nowait(struct request_queue *q, struct gendisk *bd_disk,
 
 	spin_lock_irq(q->queue_lock);
 
-	if (unlikely(blk_queue_dead(q))) {
+	if (unlikely(blk_queue_dying(q))) {
 		rq->errors = -ENXIO;
 		if (rq->end_io)
 			rq->end_io(rq, rq->errors);
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 9628b29..6898f17 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -432,7 +432,7 @@ queue_attr_show(struct kobject *kobj, struct attribute *attr, char *page)
 	if (!entry->show)
 		return -EIO;
 	mutex_lock(&q->sysfs_lock);
-	if (blk_queue_dead(q)) {
+	if (blk_queue_dying(q)) {
 		mutex_unlock(&q->sysfs_lock);
 		return -ENOENT;
 	}
@@ -454,7 +454,7 @@ queue_attr_store(struct kobject *kobj, struct attribute *attr,
 
 	q = container_of(kobj, struct request_queue, kobj);
 	mutex_lock(&q->sysfs_lock);
-	if (blk_queue_dead(q)) {
+	if (blk_queue_dying(q)) {
 		mutex_unlock(&q->sysfs_lock);
 		return -ENOENT;
 	}
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index e287c19..1da8497 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -303,7 +303,7 @@ static struct throtl_grp *throtl_lookup_create_tg(struct throtl_data *td,
 		/* if %NULL and @q is alive, fall back to root_tg */
 		if (!IS_ERR(blkg))
 			tg = blkg_to_tg(blkg);
-		else if (!blk_queue_dead(q))
+		else if (!blk_queue_dying(q))
 			tg = td_root_tg(td);
 	}
 
diff --git a/block/blk.h b/block/blk.h
index 2a0ea32..a066ceb 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -96,7 +96,7 @@ static inline struct request *__elv_next_request(struct request_queue *q)
 			q->flush_queue_delayed = 1;
 			return NULL;
 		}
-		if (unlikely(blk_queue_dead(q)) ||
+		if (unlikely(blk_queue_dying(q)) ||
 		    !q->elevator->type->ops.elevator_dispatch_fn(q, 0))
 			return NULL;
 	}
diff --git a/drivers/block/ub.c b/drivers/block/ub.c
index fcec022..f32e4d6 100644
--- a/drivers/block/ub.c
+++ b/drivers/block/ub.c
@@ -2394,7 +2394,7 @@ static void ub_disconnect(struct usb_interface *intf)
 		del_gendisk(lun->disk);
 		/*
 		 * I wish I could do:
-		 *    queue_flag_set(QUEUE_FLAG_DEAD, q);
+		 *    queue_flag_set(QUEUE_FLAG_DYING, q);
 		 * As it is, we rely on our internal poisoning and let
 		 * the upper levels to spin furiously failing all the I/O.
 		 */
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index faa790f..593fc71 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1406,7 +1406,7 @@ static int scsi_lld_busy(struct request_queue *q)
 	struct scsi_device *sdev = q->queuedata;
 	struct Scsi_Host *shost;
 
-	if (blk_queue_dead(q))
+	if (blk_queue_dying(q))
 		return 0;
 
 	shost = sdev->host;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 4a2ab7c..c6ab0db 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -436,7 +436,7 @@ struct request_queue {
 #define QUEUE_FLAG_STOPPED	2	/* queue is stopped */
 #define	QUEUE_FLAG_SYNCFULL	3	/* read queue has been filled */
 #define QUEUE_FLAG_ASYNCFULL	4	/* write queue has been filled */
-#define QUEUE_FLAG_DEAD		5	/* queue being torn down */
+#define QUEUE_FLAG_DYING	5	/* queue being torn down */
 #define QUEUE_FLAG_BYPASS	6	/* act as dumb FIFO queue */
 #define QUEUE_FLAG_BIDI		7	/* queue supports bidi requests */
 #define QUEUE_FLAG_NOMERGES     8	/* disable merge attempts */
@@ -520,7 +520,7 @@ static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
 
 #define blk_queue_tagged(q)	test_bit(QUEUE_FLAG_QUEUED, &(q)->queue_flags)
 #define blk_queue_stopped(q)	test_bit(QUEUE_FLAG_STOPPED, &(q)->queue_flags)
-#define blk_queue_dead(q)	test_bit(QUEUE_FLAG_DEAD, &(q)->queue_flags)
+#define blk_queue_dying(q)	test_bit(QUEUE_FLAG_DYING, &(q)->queue_flags)
 #define blk_queue_bypass(q)	test_bit(QUEUE_FLAG_BYPASS, &(q)->queue_flags)
 #define blk_queue_nomerges(q)	test_bit(QUEUE_FLAG_NOMERGES, &(q)->queue_flags)
 #define blk_queue_noxmerges(q)	\
-- 
1.7.10.4

