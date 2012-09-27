From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 3/3] Make blk_cleanup_queue() wait until request_fn finished
Date: Thu, 27 Sep 2012 18:39:12 +0200
Message-ID: <50648130.4060902@acm.org>
References: <50648014.7080308@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [178.239.52.149] ([178.239.52.149]:44153 "EHLO wimaserver10.be"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752005Ab2I0QjY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Sep 2012 12:39:24 -0400
In-Reply-To: <50648014.7080308@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>

Some request_fn implementations, e.g. scsi_request_fn(), unlock
the queue lock. Make sure that blk_cleanup_queue() waits until all
active request_fn invocations have finished. This fixes a potential
use-after-free at the end of scsi_request_fn().

Reported-by: Chanho Min <chanho.min@lge.com>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-core.c        |    7 +++++--
 drivers/scsi/scsi_lib.c |   10 +---------
 include/linux/blkdev.h  |    5 +++++
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index b5436b6..e41b291 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -308,7 +308,9 @@ void __blk_run_queue_uncond(struct request_queue *q)
 	if (unlikely(blk_queue_dead(q)))
 		return;
 
+	q->request_fn_active++;
 	q->request_fn(q);
+	q->request_fn_active--;
 }
 
 /**
@@ -407,6 +409,7 @@ void blk_drain_queue(struct request_queue *q, bool drain_all)
 			__blk_run_queue(q);
 
 		drain |= q->nr_rqs_elvpriv;
+		drain |= q->request_fn_active;
 
 		/*
 		 * Unfortunately, requests are queued at and tracked from
@@ -494,8 +497,8 @@ EXPORT_SYMBOL_GPL(blk_queue_bypass_end);
  * blk_cleanup_queue - shutdown a request queue
  * @q: request queue to shutdown
  *
- * Mark @q DEAD, drain all pending requests, destroy and put it.  All
- * future requests will be failed immediately with -ENODEV.
+ * Mark @q as dying, drain all pending requests, mark @q as dead, destroy and
+ * put it.  All future requests will be failed immediately with -ENODEV.
  */
 void blk_cleanup_queue(struct request_queue *q)
 {
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 593fc71..03571a3 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1517,10 +1517,6 @@ static void scsi_request_fn(struct request_queue *q)
 	struct scsi_cmnd *cmd;
 	struct request *req;
 
-	if(!get_device(&sdev->sdev_gendev))
-		/* We must be tearing the block queue down already */
-		return;
-
 	/*
 	 * To start with, we keep looping until the queue is empty, or until
 	 * the host is no longer able to accept any more requests.
@@ -1629,11 +1625,7 @@ out_delay:
 	if (sdev->device_busy == 0)
 		blk_delay_queue(q, SCSI_QUEUE_DELAY);
 out:
-	/* must be careful here...if we trigger the ->remove() function
-	 * we cannot be holding the q lock */
-	spin_unlock_irq(q->queue_lock);
-	put_device(&sdev->sdev_gendev);
-	spin_lock_irq(q->queue_lock);
+	;
 }
 
 u64 scsi_calculate_bounce_limit(struct Scsi_Host *shost)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 9b9855f..ef5b80a 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -377,6 +377,11 @@ struct request_queue {
 
 	unsigned int		nr_sorted;
 	unsigned int		in_flight[2];
+	/*
+	 * Number of active request_fn() calls for those request_fn()
+	 * implementations that unlock the queue_lock, e.g. scsi_request_fn().
+	 */
+	unsigned int		request_fn_active;
 
 	unsigned int		rq_timeout;
 	struct timer_list	timeout;
-- 
1.7.10.4

