From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH, RFC] blk-mq: use a delayed work item for timeouts
Date: Mon, 12 Oct 2015 21:29:14 +0200
Message-ID: <1444678154-24766-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38132 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbbJLTdF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Oct 2015 15:33:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@fb.com
Cc: hare@suse.de, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org

For some pending NVMe work I'd really love to be able to get my timeouts
from process context.  So far it seems only SCSI and NVMe use the blk-mq
timeout handler, and both don't seem to be particularly excited about
being called from time context.  Does anyone have an objection against
the patch below that switches it to use a delayed work item?  I could
make use of this quickly for NVMe, but for SCSI we still have to deal
with the old request code which can't be switched to a delayed work
as easily.
---
 block/blk-mq.c         | 11 ++++++-----
 include/linux/blkdev.h |  5 ++++-
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index d921cd5..a7ae387 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -635,9 +635,10 @@ static void blk_mq_check_expired(struct blk_mq_hw_ctx *hctx,
 	}
 }
 
-static void blk_mq_rq_timer(unsigned long priv)
+static void blk_mq_rq_timer_work(struct work_struct *work)
 {
-	struct request_queue *q = (struct request_queue *)priv;
+	struct request_queue *q =
+		container_of(work, struct request_queue, timeout_work.work);
 	struct blk_mq_timeout_data data = {
 		.next		= 0,
 		.next_set	= 0,
@@ -648,7 +649,7 @@ static void blk_mq_rq_timer(unsigned long priv)
 
 	if (data.next_set) {
 		data.next = blk_rq_timeout(round_jiffies_up(data.next));
-		mod_timer(&q->timeout, data.next);
+		mod_delayed_work(system_wq, &q->timeout_work, data.next);
 	} else {
 		struct blk_mq_hw_ctx *hctx;
 
@@ -2008,7 +2009,7 @@ struct request_queue *blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
 			    PERCPU_REF_INIT_ATOMIC, GFP_KERNEL))
 		goto err_hctxs;
 
-	setup_timer(&q->timeout, blk_mq_rq_timer, (unsigned long) q);
+	INIT_DELAYED_WORK(&q->timeout_work, blk_mq_rq_timer_work);
 	blk_queue_rq_timeout(q, set->timeout ? set->timeout : 30 * HZ);
 
 	q->nr_queues = nr_cpu_ids;
@@ -2173,7 +2174,7 @@ static int blk_mq_queue_reinit_notify(struct notifier_block *nb,
 		 * timeout handler can't touch hw queue during the
 		 * reinitialization
 		 */
-		del_timer_sync(&q->timeout);
+		cancel_delayed_work_sync(&q->timeout_work);
 	}
 
 	list_for_each_entry(q, &all_q_list, all_q_node)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 19c2e94..ecce48f 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -401,7 +401,10 @@ struct request_queue {
 	unsigned int		request_fn_active;
 
 	unsigned int		rq_timeout;
-	struct timer_list	timeout;
+	union {
+		struct timer_list	timeout;	/* legacy */
+		struct delayed_work	timeout_work;	/* blk-mq */
+	};
 	struct list_head	timeout_list;
 
 	struct list_head	icq_list;
-- 
1.9.1

