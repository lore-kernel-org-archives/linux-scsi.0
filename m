From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v6 02/13] block: Let blk_drain_queue() caller obtain the queue
 lock
Date: Wed, 28 Nov 2012 13:43:38 +0100
Message-ID: <50B606FA.7010702@acm.org>
References: <50B60619.4080406@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:41988 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754699Ab2K1Mnj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Nov 2012 07:43:39 -0500
In-Reply-To: <50B60619.4080406@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, Hannes Reinecke <hare@suse.de>

Let the caller of blk_drain_queue() obtain the queue lock to improve
readability of the patch called "Avoid that request_fn is invoked on
a dead queue".

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Chanho Min <chanho.min@lge.com>
---
 block/blk-core.c |   30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index adbca41..9bcf21b 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -349,7 +349,7 @@ void blk_put_queue(struct request_queue *q)
 EXPORT_SYMBOL(blk_put_queue);
 
 /**
- * blk_drain_queue - drain requests from request_queue
+ * __blk_drain_queue - drain requests from request_queue
  * @q: queue to drain
  * @drain_all: whether to drain all requests or only the ones w/ ELVPRIV
  *
@@ -357,15 +357,17 @@ EXPORT_SYMBOL(blk_put_queue);
  * If not, only ELVPRIV requests are drained.  The caller is responsible
  * for ensuring that no new requests which need to be drained are queued.
  */
-void blk_drain_queue(struct request_queue *q, bool drain_all)
+static void __blk_drain_queue(struct request_queue *q, bool drain_all)
+	__releases(q->queue_lock)
+	__acquires(q->queue_lock)
 {
 	int i;
 
+	lockdep_assert_held(q->queue_lock);
+
 	while (true) {
 		bool drain = false;
 
-		spin_lock_irq(q->queue_lock);
-
 		/*
 		 * The caller might be trying to drain @q before its
 		 * elevator is initialized.
@@ -401,11 +403,14 @@ void blk_drain_queue(struct request_queue *q, bool drain_all)
 			}
 		}
 
-		spin_unlock_irq(q->queue_lock);
-
 		if (!drain)
 			break;
+
+		spin_unlock_irq(q->queue_lock);
+
 		msleep(10);
+
+		spin_lock_irq(q->queue_lock);
 	}
 
 	/*
@@ -416,13 +421,9 @@ void blk_drain_queue(struct request_queue *q, bool drain_all)
 	if (q->request_fn) {
 		struct request_list *rl;
 
-		spin_lock_irq(q->queue_lock);
-
 		blk_queue_for_each_rl(rl, q)
 			for (i = 0; i < ARRAY_SIZE(rl->wait); i++)
 				wake_up_all(&rl->wait[i]);
-
-		spin_unlock_irq(q->queue_lock);
 	}
 }
 
@@ -446,7 +447,10 @@ void blk_queue_bypass_start(struct request_queue *q)
 	spin_unlock_irq(q->queue_lock);
 
 	if (drain) {
-		blk_drain_queue(q, false);
+		spin_lock_irq(q->queue_lock);
+		__blk_drain_queue(q, false);
+		spin_unlock_irq(q->queue_lock);
+
 		/* ensure blk_queue_bypass() is %true inside RCU read lock */
 		synchronize_rcu();
 	}
@@ -504,7 +508,9 @@ void blk_cleanup_queue(struct request_queue *q)
 	mutex_unlock(&q->sysfs_lock);
 
 	/* drain all requests queued before DYING marking */
-	blk_drain_queue(q, true);
+	spin_lock_irq(lock);
+	__blk_drain_queue(q, true);
+	spin_unlock_irq(lock);
 
 	/* @q won't process any more request, flush async actions */
 	del_timer_sync(&q->backing_dev_info.laptop_mode_wb_timer);
-- 
1.7.10.4

