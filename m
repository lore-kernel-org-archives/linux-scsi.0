From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 03/12] blk-mq: Introduce blk_mq_queue_stopped()
Date: Wed, 26 Oct 2016 15:52:05 -0700
Message-ID: <f68b2997-8b0d-7aea-2859-5fbda4f6bf71@sandisk.com>
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

The function blk_queue_stopped() allows to test whether or not a
traditional request queue has been stopped. Introduce a helper
function that allows block drivers to query easily whether or not
one or more hardware contexts of a blk-mq queue have been stopped.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Reviewed-by: Hannes Reinecke <hare-IBi9RG/b67k@public.gmane.org>
Reviewed-by: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Reviewed-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 block/blk-mq.c         | 20 ++++++++++++++++++++
 include/linux/blk-mq.h |  1 +
 2 files changed, 21 insertions(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index b52b3a6..4643fa8 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -946,6 +946,26 @@ void blk_mq_run_hw_queues(struct request_queue *q, bool async)
 }
 EXPORT_SYMBOL(blk_mq_run_hw_queues);
 
+/**
+ * blk_mq_queue_stopped() - check whether one or more hctxs have been stopped
+ * @q: request queue.
+ *
+ * The caller is responsible for serializing this function against
+ * blk_mq_{start,stop}_hw_queue().
+ */
+bool blk_mq_queue_stopped(struct request_queue *q)
+{
+	struct blk_mq_hw_ctx *hctx;
+	int i;
+
+	queue_for_each_hw_ctx(q, hctx, i)
+		if (blk_mq_hctx_stopped(hctx))
+			return true;
+
+	return false;
+}
+EXPORT_SYMBOL(blk_mq_queue_stopped);
+
 void blk_mq_stop_hw_queue(struct blk_mq_hw_ctx *hctx)
 {
 	cancel_work(&hctx->run_work);
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 535ab2e..aa93000 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -223,6 +223,7 @@ void blk_mq_delay_kick_requeue_list(struct request_queue *q, unsigned long msecs
 void blk_mq_abort_requeue_list(struct request_queue *q);
 void blk_mq_complete_request(struct request *rq, int error);
 
+bool blk_mq_queue_stopped(struct request_queue *q);
 void blk_mq_stop_hw_queue(struct blk_mq_hw_ctx *hctx);
 void blk_mq_start_hw_queue(struct blk_mq_hw_ctx *hctx);
 void blk_mq_stop_hw_queues(struct request_queue *q);
-- 
2.10.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
