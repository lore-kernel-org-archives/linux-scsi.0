From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] Fix a use-after-free triggered by device removal
Date: Thu, 13 Sep 2012 20:27:29 +0200
Message-ID: <50522591.5000900@acm.org>
References: <91D94272-CA62-4E68-87D7-CE77DE776CC9@cs.wisc.edu> <5048E45E.1070302@acm.org> <5048E80B.5010101@cs.wisc.edu> <5048F0D9.6080403@acm.org> <20120906232031.GU29092@google.com> <50499AC6.1050008@acm.org> <20120910233843.GI7677@google.com> <504EDD54.9000408@acm.org> <20120912205338.GV7677@google.com> <50518AC3.2070009@acm.org> <20120913165340.GX7677@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [178.239.52.149] ([178.239.52.149]:53646 "EHLO wimaserver10.be"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751188Ab2IMS1w (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Sep 2012 14:27:52 -0400
In-Reply-To: <20120913165340.GX7677@google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>, Chanho Min <chanho.min@lge.com>

On 09/13/12 18:53, Tejun Heo wrote:
> Oh yeah, I definitely think this is something which needs to be solved
> from the block layer but I'm hoping this could cover the case Chanho
> is trying to solve too.  They're different but similar problems - you
> don't want blk_cleanup_queue() to finish while someone is executing
> inside it and you don't want anyone to enter it after
> blk_cleanup_queue() is finished, so I really think we should have
> block layer solution which fixes both problems.  That should be
> possible, right?

If I do not receive further feedback I'll start testing the patch below
(on top of the patch at the start of this thread):

[PATCH] Avoid that request_fn() gets invoked after draining the queue finished

---
 block/blk-core.c       |    4 ++++
 include/linux/blkdev.h |    2 ++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index a668b71..575b7c4 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -305,6 +305,9 @@ EXPORT_SYMBOL(blk_sync_queue);
  */
 void __blk_run_queue_uncond(struct request_queue *q)
 {
+	if (unlikely(blk_queue_drained(q)))
+		return;
+
 	q->request_fn_active++;
 	q->request_fn(q);
 	q->request_fn_active--;
@@ -532,6 +535,7 @@ void blk_cleanup_queue(struct request_queue *q)
 	blk_sync_queue(q);
 
 	spin_lock_irq(lock);
+	queue_flag_set(QUEUE_FLAG_DRAINED, q);
 	if (q->queue_lock != &q->__queue_lock)
 		q->queue_lock = &q->__queue_lock;
 	spin_unlock_irq(lock);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 132334e..ceebc39 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -456,6 +456,7 @@ struct request_queue {
 #define QUEUE_FLAG_ADD_RANDOM  16	/* Contributes to random pool */
 #define QUEUE_FLAG_SECDISCARD  17	/* supports SECDISCARD */
 #define QUEUE_FLAG_SAME_FORCE  18	/* force complete on same CPU */
+#define QUEUE_FLAG_DRAINED     19	/* queue tear-down finished */
 
 #define QUEUE_FLAG_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
 				 (1 << QUEUE_FLAG_STACKABLE)	|	\
@@ -526,6 +527,7 @@ static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
 #define blk_queue_tagged(q)	test_bit(QUEUE_FLAG_QUEUED, &(q)->queue_flags)
 #define blk_queue_stopped(q)	test_bit(QUEUE_FLAG_STOPPED, &(q)->queue_flags)
 #define blk_queue_dead(q)	test_bit(QUEUE_FLAG_DEAD, &(q)->queue_flags)
+#define blk_queue_drained(q)	test_bit(QUEUE_FLAG_DRAINED, &(q)->queue_flags)
 #define blk_queue_bypass(q)	test_bit(QUEUE_FLAG_BYPASS, &(q)->queue_flags)
 #define blk_queue_nomerges(q)	test_bit(QUEUE_FLAG_NOMERGES, &(q)->queue_flags)
 #define blk_queue_noxmerges(q)	\
-- 
1.7.7


