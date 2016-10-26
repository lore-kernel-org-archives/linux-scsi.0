From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 02/12] blk-mq: Introduce blk_mq_hctx_stopped()
Date: Wed, 26 Oct 2016 15:51:33 -0700
Message-ID: <0de50789-e3b7-0a07-73c1-4fb87b1f957e@sandisk.com>
References: <b22edafc-725f-0419-d074-34d35d57d126@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <b22edafc-725f-0419-d074-34d35d57d126-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, James Bottomley <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ming Lei <tom.leiming-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Multiple functions test the BLK_MQ_S_STOPPED bit so introduce
a helper function that performs this test.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Hannes Reinecke <hare-IBi9RG/b67k@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
---
 block/blk-mq.c | 12 ++++++------
 block/blk-mq.h |  5 +++++
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index b5dcafb..b52b3a6 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -787,7 +787,7 @@ static void __blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx)
 	struct list_head *dptr;
 	int queued;
 
-	if (unlikely(test_bit(BLK_MQ_S_STOPPED, &hctx->state)))
+	if (unlikely(blk_mq_hctx_stopped(hctx)))
 		return;
 
 	WARN_ON(!cpumask_test_cpu(raw_smp_processor_id(), hctx->cpumask) &&
@@ -912,8 +912,8 @@ static int blk_mq_hctx_next_cpu(struct blk_mq_hw_ctx *hctx)
 
 void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx, bool async)
 {
-	if (unlikely(test_bit(BLK_MQ_S_STOPPED, &hctx->state) ||
-	    !blk_mq_hw_queue_mapped(hctx)))
+	if (unlikely(blk_mq_hctx_stopped(hctx) ||
+		     !blk_mq_hw_queue_mapped(hctx)))
 		return;
 
 	if (!async && !(hctx->flags & BLK_MQ_F_BLOCKING)) {
@@ -938,7 +938,7 @@ void blk_mq_run_hw_queues(struct request_queue *q, bool async)
 	queue_for_each_hw_ctx(q, hctx, i) {
 		if ((!blk_mq_hctx_has_pending(hctx) &&
 		    list_empty_careful(&hctx->dispatch)) ||
-		    test_bit(BLK_MQ_S_STOPPED, &hctx->state))
+		    blk_mq_hctx_stopped(hctx))
 			continue;
 
 		blk_mq_run_hw_queue(hctx, async);
@@ -988,7 +988,7 @@ void blk_mq_start_stopped_hw_queues(struct request_queue *q, bool async)
 	int i;
 
 	queue_for_each_hw_ctx(q, hctx, i) {
-		if (!test_bit(BLK_MQ_S_STOPPED, &hctx->state))
+		if (!blk_mq_hctx_stopped(hctx))
 			continue;
 
 		clear_bit(BLK_MQ_S_STOPPED, &hctx->state);
@@ -1332,7 +1332,7 @@ static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
 		blk_mq_put_ctx(data.ctx);
 		if (!old_rq)
 			goto done;
-		if (test_bit(BLK_MQ_S_STOPPED, &data.hctx->state) ||
+		if (blk_mq_hctx_stopped(data.hctx) ||
 		    blk_mq_direct_issue_request(old_rq, &cookie) != 0)
 			blk_mq_insert_request(old_rq, false, true, true);
 		goto done;
diff --git a/block/blk-mq.h b/block/blk-mq.h
index e5d2524..ac772da 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -100,6 +100,11 @@ static inline void blk_mq_set_alloc_data(struct blk_mq_alloc_data *data,
 	data->hctx = hctx;
 }
 
+static inline bool blk_mq_hctx_stopped(struct blk_mq_hw_ctx *hctx)
+{
+	return test_bit(BLK_MQ_S_STOPPED, &hctx->state);
+}
+
 static inline bool blk_mq_hw_queue_mapped(struct blk_mq_hw_ctx *hctx)
 {
 	return hctx->nr_ctx && hctx->tags;
-- 
2.10.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
