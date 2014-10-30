From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH v3 01/11] blk-mq: Add blk_mq_unique_tag()
Date: Thu, 30 Oct 2014 14:45:11 +0100
Message-ID: <545240E7.5030206@acm.org>
References: <545240AE.6060009@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <545240AE.6060009-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Robert Elliott <Elliott-VXdhtT5mjnY@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

The queuecommand() callback functions in SCSI low-level drivers
need to know which hardware context has been selected by the
block layer. Since this information is not available in the
request structure, and since passing the hctx pointer directly to
the queuecommand callback function would require modification of
all SCSI LLDs, add a function to the block layer that allows to
query the hardware context index.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Acked-by: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Martin K. Petersen <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
---
 block/blk-mq-tag.c     | 28 ++++++++++++++++++++++++++++
 block/blk-mq.c         |  2 ++
 include/linux/blk-mq.h | 17 +++++++++++++++++
 3 files changed, 47 insertions(+)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 8317175..728b9a4 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -584,6 +584,34 @@ int blk_mq_tag_update_depth(struct blk_mq_tags *tags, unsigned int tdepth)
 	return 0;
 }
 
+/**
+ * blk_mq_unique_tag() - return a tag that is unique queue-wide
+ * @rq: request for which to compute a unique tag
+ *
+ * The tag field in struct request is unique per hardware queue but not over
+ * all hardware queues. Hence this function that returns a tag with the
+ * hardware context index in the upper bits and the per hardware queue tag in
+ * the lower bits.
+ *
+ * Note: When called for a request that is queued on a non-multiqueue request
+ * queue, the hardware context index is set to zero.
+ */
+u32 blk_mq_unique_tag(struct request *rq)
+{
+	struct request_queue *q = rq->q;
+	struct blk_mq_hw_ctx *hctx;
+	int hwq = 0;
+
+	if (q->mq_ops) {
+		hctx = q->mq_ops->map_queue(q, rq->mq_ctx->cpu);
+		hwq = hctx->queue_num;
+	}
+
+	return (hwq << BLK_MQ_UNIQUE_TAG_BITS) |
+		(rq->tag & BLK_MQ_UNIQUE_TAG_MASK);
+}
+EXPORT_SYMBOL(blk_mq_unique_tag);
+
 ssize_t blk_mq_tag_sysfs_show(struct blk_mq_tags *tags, char *page)
 {
 	char *orig_page = page;
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 68929ba..b5896d4 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2024,6 +2024,8 @@ static int blk_mq_alloc_rq_maps(struct blk_mq_tag_set *set)
  */
 int blk_mq_alloc_tag_set(struct blk_mq_tag_set *set)
 {
+	BUILD_BUG_ON(BLK_MQ_MAX_DEPTH > 1 << BLK_MQ_UNIQUE_TAG_BITS);
+
 	if (!set->nr_hw_queues)
 		return -EINVAL;
 	if (!set->queue_depth)
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index c9be158..15f7034a 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -167,6 +167,23 @@ struct request *blk_mq_alloc_request(struct request_queue *q, int rw,
 		gfp_t gfp, bool reserved);
 struct request *blk_mq_tag_to_rq(struct blk_mq_tags *tags, unsigned int tag);
 
+enum {
+	BLK_MQ_UNIQUE_TAG_BITS = 16,
+	BLK_MQ_UNIQUE_TAG_MASK = (1 << BLK_MQ_UNIQUE_TAG_BITS) - 1,
+};
+
+u32 blk_mq_unique_tag(struct request *rq);
+
+static inline u16 blk_mq_unique_tag_to_hwq(u32 unique_tag)
+{
+	return unique_tag >> BLK_MQ_UNIQUE_TAG_BITS;
+}
+
+static inline u16 blk_mq_unique_tag_to_tag(u32 unique_tag)
+{
+	return unique_tag & BLK_MQ_UNIQUE_TAG_MASK;
+}
+
 struct blk_mq_hw_ctx *blk_mq_map_queue(struct request_queue *, const int ctx_index);
 struct blk_mq_hw_ctx *blk_mq_alloc_single_hw_queue(struct blk_mq_tag_set *, unsigned int, int);
 
-- 
1.8.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
