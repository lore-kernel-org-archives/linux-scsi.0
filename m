From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 8/8] IB/srp: Add multichannel support
Date: Wed, 01 Oct 2014 18:08:43 +0200
Message-ID: <542C270B.5020002@acm.org>
References: <541C27BF.6070609@acm.org>	<541C28E0.7010705@acm.org>	<CACVXFVPzz37J-613NZCfPStUBxf0rLOtz71LJ07PpCxYg5nn+g@mail.gmail.com>	<541C49EC.6030404@acm.org> <CACVXFVPH_qPFUTT+796BZmWxeeG4tJ-Pyp8hqGqqSwt3YYkEqA@mail.gmail.com> <541C4D2F.9060907@acm.org> <541C4DF1.4090604@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <541C4DF1.4090604-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Robert Elliott <Elliott-VXdhtT5mjnY@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 09/19/14 17:38, Jens Axboe wrote:
> ctx was meant to be private, unfortunately it's leaked a bit into other
> parts of block/. But it's still private within that, at least.
> 
> Lets not add more stuff to struct request, it's already way too large.
> We could add an exported
> 
> struct blk_mq_hw_ctx *blk_mq_request_to_hctx(struct request *rq)
> {
> 	struct request_queue *q = rq->q;
> 
> 	return q->mq_ops->map_queue(q, rq->mq_ctx->cpu);
> }
> 
> for this.

How about the patch below ? That patch makes it easy for SCSI LLDs to obtain
the hardware context index.
 
[PATCH] blk-mq: Add blk_get_mq_tag()

The queuecommand() callback functions in SCSI low-level drivers
must know which hardware context has been selected by the block
layer. Since passing the hctx pointer directly to the queuecommand
callback function would require modification of all SCSI LLDs,
add a function to the block layer that allows to query the hardware
context index.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
---
 block/blk-mq-tag.c     | 24 ++++++++++++++++++++++++
 include/linux/blk-mq.h | 16 ++++++++++++++++
 2 files changed, 40 insertions(+)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index c1b9242..5618759 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -595,6 +595,30 @@ int blk_mq_tag_update_depth(struct blk_mq_tags *tags, unsigned int tdepth)
 	return 0;
 }
 
+/**
+ * blk_get_mq_tag() - return a tag that is unique queue-wide
+ *
+ * The tag field in struct request is unique per hardware queue but not
+ * queue-wide. Hence this function. It is not only safe to use this function
+ * for multiqueue request queues but also for single-queue request queues.
+ * Note: rq->tag == -1 if tagging is not enabled for single-queue request
+ * queues.
+ */
+struct blk_mq_tag blk_get_mq_tag(struct request *rq)
+{
+	struct request_queue *q = rq->q;
+	struct blk_mq_tag tag = { rq->tag & ((1 << 16) - 1) };
+	struct blk_mq_hw_ctx *hctx;
+
+	if (q->mq_ops) {
+		hctx = q->mq_ops->map_queue(q, rq->mq_ctx->cpu);
+		tag.tag |= hctx->queue_num << 16;
+	}
+
+	return tag;
+}
+EXPORT_SYMBOL(blk_get_mq_tag);
+
 ssize_t blk_mq_tag_sysfs_show(struct blk_mq_tags *tags, char *page)
 {
 	char *orig_page = page;
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index eac4f31..eb419bc 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -88,6 +88,13 @@ struct blk_mq_tag_set {
 	struct list_head	tag_list;
 };
 
+/**
+ * struct blk_mq_tag - hardware queue index and per-queue tag
+ */
+struct blk_mq_tag {
+	u32 tag;
+};
+
 typedef int (queue_rq_fn)(struct blk_mq_hw_ctx *, struct request *);
 typedef struct blk_mq_hw_ctx *(map_queue_fn)(struct request_queue *, const int);
 typedef int (init_hctx_fn)(struct blk_mq_hw_ctx *, void *, unsigned int);
@@ -166,6 +173,15 @@ bool blk_mq_can_queue(struct blk_mq_hw_ctx *);
 struct request *blk_mq_alloc_request(struct request_queue *q, int rw,
 		gfp_t gfp, bool reserved);
 struct request *blk_mq_tag_to_rq(struct blk_mq_tags *tags, unsigned int tag);
+struct blk_mq_tag blk_get_mq_tag(struct request *rq);
+static inline u16 blk_mq_tag_to_hwq(struct blk_mq_tag t)
+{
+	return t.tag >> 16;
+}
+static inline u16 blk_mq_tag_to_tag(struct blk_mq_tag t)
+{
+	return t.tag & ((1 << 16) - 1);
+}
 
 struct blk_mq_hw_ctx *blk_mq_map_queue(struct request_queue *, const int ctx_index);
 struct blk_mq_hw_ctx *blk_mq_alloc_single_hw_queue(struct blk_mq_tag_set *, unsigned int, int);
-- 
1.8.4.5


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
