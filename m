From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 02/12] blk-mq: Add blk_mq_unique_tag()
Date: Tue, 07 Oct 2014 15:03:15 +0200
Message-ID: <5433E493.9030304@acm.org>
References: <5433E43D.3010107@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from michel.telenet-ops.be ([195.130.137.88]:39966 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281AbaJGNDU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Oct 2014 09:03:20 -0400
In-Reply-To: <5433E43D.3010107@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, Robert Elliott <Elliott@hp.com>, Ming Lei <ming.lei@canonical.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>

The queuecommand() callback functions in SCSI low-level drivers
need to know which hardware context has been selected by the
block layer. Since this information is not available in the
request structure, and since passing the hctx pointer directly to
the queuecommand callback function would require modification of
all SCSI LLDs, add a function to the block layer that allows to
query the hardware context index.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@canonical.com>
Cc: Sagi Grimberg <sagig@mellanox.com>
---
 block/blk-mq-tag.c     | 27 +++++++++++++++++++++++++++
 block/blk-mq.c         |  2 ++
 include/linux/blk-mq.h | 22 ++++++++++++++++++++++
 3 files changed, 51 insertions(+)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 88d512f..2c63a2b 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -592,6 +592,33 @@ int blk_mq_tag_update_depth(struct blk_mq_tags *tags, unsigned int tdepth)
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
+ * Note: When called for a request that queued on a non-multiqueue request
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
+	return blk_mq_build_unique_tag(hwq, rq->tag);
+}
+EXPORT_SYMBOL(blk_mq_unique_tag);
+
 ssize_t blk_mq_tag_sysfs_show(struct blk_mq_tags *tags, char *page)
 {
 	char *orig_page = page;
diff --git a/block/blk-mq.c b/block/blk-mq.c
index df8e1e0..bf1959c 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2018,6 +2018,8 @@ static int blk_mq_alloc_rq_maps(struct blk_mq_tag_set *set)
  */
 int blk_mq_alloc_tag_set(struct blk_mq_tag_set *set)
 {
+	BUILD_BUG_ON(BLK_MQ_MAX_DEPTH > 1 << BLK_MQ_UNIQUE_TAG_BITS);
+
 	if (!set->nr_hw_queues)
 		return -EINVAL;
 	if (!set->queue_depth)
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index eac4f31..6050a23 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -167,6 +167,28 @@ struct request *blk_mq_alloc_request(struct request_queue *q, int rw,
 		gfp_t gfp, bool reserved);
 struct request *blk_mq_tag_to_rq(struct blk_mq_tags *tags, unsigned int tag);
 
+enum {
+	BLK_MQ_UNIQUE_TAG_BITS = 16,
+	BLK_MQ_UNIQUE_TAG_MASK = (1 << BLK_MQ_UNIQUE_TAG_BITS) - 1,
+};
+
+u32 blk_mq_unique_tag(struct request *rq);
+
+static inline u32 blk_mq_build_unique_tag(int hwq, int tag)
+{
+	return (hwq << BLK_MQ_UNIQUE_TAG_BITS) | (tag & BLK_MQ_UNIQUE_TAG_MASK);
+}
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

