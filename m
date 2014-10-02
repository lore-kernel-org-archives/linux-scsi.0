From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 8/8] IB/srp: Add multichannel support
Date: Thu, 02 Oct 2014 18:45:55 +0200
Message-ID: <542D8143.3050305@acm.org>
References: <541C27BF.6070609@acm.org>	<541C28E0.7010705@acm.org>	<CACVXFVPzz37J-613NZCfPStUBxf0rLOtz71LJ07PpCxYg5nn+g@mail.gmail.com>	<541C49EC.6030404@acm.org> <CACVXFVPH_qPFUTT+796BZmWxeeG4tJ-Pyp8hqGqqSwt3YYkEqA@mail.gmail.com> <541C4D2F.9060907@acm.org> <541C4DF1.4090604@kernel.dk> <542C270B.5020002@acm.org> <542C31C4.1020702@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <542C31C4.1020702-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Robert Elliott <Elliott-VXdhtT5mjnY@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 10/01/14 18:54, Jens Axboe wrote:
> Lets get rid of the blk_mq_tag struct and just have it be an u32 or 
> something. We could potentially typedef it, but I'd prefer to just have 
> it be an unsigned 32-bit int.
> 
> Probably also need some init time safety checks that 16-bits is enough 
> to hold BLK_MQ_MAX_DEPTH. Just in case that is ever bumped, or the queue 
> prefixing changes.
> 
> And I think we need to name this better. Your comment correctly 
> describes that this generates a unique tag queue wide, but the name of 
> the function implies that we just return the request tag. Most drivers 
> wont use this. Perhaps add a queue flag that tells us that we should 
> generate these tags and have it setup ala:
> 
> u32 blk_mq_unique_rq_tag(struct request *rq)
> {
>      struct request_queue *q = rq->q;
>      u32 tag = rq->tag & ((1 << 16) - 1);
>      struct blk_mq_hw_ctx *hctx;
> 
>      hctx = q->mq_ops->map_queue(q, rq->mq_ctx->cpu);
>      return tag | (hctx->queue_num << 16);
> }
> 
> u32 blk_mq_rq_tag(struct request *rq)
> {
>      struct request_queue *q = rq->q;
> 
>      if (q->mq_ops &&
>          test_bit(QUEUE_FLAG_UNIQUE_TAGS, &q->queue_flags))
>          return blk_mq_unique_rq_tag(rq);
> 
>      return rq->tag;
> }

Would it be acceptable to let blk_mq_rq_tag() always return the
hardware context number and the per-hctx tag ? Block and SCSI LLD 
drivers that do not need the hardware context number can still use 
rq->tag. Drivers that need both can use blk_mq_rq_tag(). That way we do 
not have to introduce a new queue flag. How about the patch below 
(which is still missing a BLK_MQ_MAX_DEPTH check):

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index c1b9242..8cfbc7b 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -595,6 +595,30 @@ int blk_mq_tag_update_depth(struct blk_mq_tags *tags, unsigned int tdepth)
 	return 0;
 }
 
+/**
+ * blk_mq_rq_tag() - return a tag that is unique queue-wide
+ *
+ * The tag field in struct request is unique per hardware queue but not
+ * queue-wide. Hence this function.
+ *
+ * Note: When called for a non-multiqueue request queue, the hardware context
+ * index is set to zero.
+ */
+u32 blk_mq_rq_tag(struct request *rq)
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
+	return blk_mq_build_rq_tag(hwq, rq->tag);
+}
+EXPORT_SYMBOL(blk_mq_rq_tag);
+
 ssize_t blk_mq_tag_sysfs_show(struct blk_mq_tags *tags, char *page)
 {
 	char *orig_page = page;
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index eac4f31..c5be535 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -166,6 +166,19 @@ bool blk_mq_can_queue(struct blk_mq_hw_ctx *);
 struct request *blk_mq_alloc_request(struct request_queue *q, int rw,
 		gfp_t gfp, bool reserved);
 struct request *blk_mq_tag_to_rq(struct blk_mq_tags *tags, unsigned int tag);
+u32 blk_mq_rq_tag(struct request *rq);
+static inline u32 blk_mq_build_rq_tag(int hwq, int tag)
+{
+	return (hwq << 16) | (tag & ((1 << 16) - 1));
+}
+static inline u16 blk_mq_rq_tag_to_hwq(u32 rq_tag)
+{
+	return rq_tag >> 16;
+}
+static inline u16 blk_mq_rq_tag_to_tag(u32 rq_tag)
+{
+	return rq_tag & ((1 << 16) - 1);
+}
 
 struct blk_mq_hw_ctx *blk_mq_map_queue(struct request_queue *, const int ctx_index);
 struct blk_mq_hw_ctx *blk_mq_alloc_single_hw_queue(struct blk_mq_tag_set *, unsigned int, int);
-- 
1.8.4.5


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
