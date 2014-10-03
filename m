From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 8/8] IB/srp: Add multichannel support
Date: Fri, 03 Oct 2014 15:01:04 +0200
Message-ID: <542E9E10.8040207@acm.org>
References: <541C27BF.6070609@acm.org>	<541C28E0.7010705@acm.org>	<CACVXFVPzz37J-613NZCfPStUBxf0rLOtz71LJ07PpCxYg5nn+g@mail.gmail.com>	<541C49EC.6030404@acm.org> <CACVXFVPH_qPFUTT+796BZmWxeeG4tJ-Pyp8hqGqqSwt3YYkEqA@mail.gmail.com> <541C4D2F.9060907@acm.org> <541C4DF1.4090604@kernel.dk> <542C270B.5020002@acm.org> <542C31C4.1020702@kernel.dk> <542D8143.3050305@acm.org> <542D8368.8080604@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <542D8368.8080604-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Robert Elliott <Elliott-VXdhtT5mjnY@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 10/02/14 18:55, Jens Axboe wrote:
> Sure, that's fine as well, but the function needs a more descriptive
> name. I try to think of it like I have never looked at the code and need
> to write a driver, it's a lot easier if the functions are named
> appropriately. Seeing blk_mq_rq_tag() and even with reading the function
> comment, I'm really none the wiser and would assume I need to use this
> function to get the tag.
> 
> So we can do the single function, but lets call it
> blk_mq_unique_rq_tag(). That's special enough that people will know this
> is something that doesn't just return the request tag. Then add an extra
> sentence to the comment you already have on when this is needed.
> 
> And lets roll those bitshift values and masks into a define or enum so
> it's collected in one place.

How about the patch below ? In that patch all comments should have been
addressed that Christoph and you have formulated so far.

Thanks,

Bart.

[PATCH] blk-mq: Add blk_mq_unique_tag()

The queuecommand() callback functions in SCSI low-level drivers
need to know which hardware context has been selected by the
block layer. Since this information is not available in the
request structure, and since passing the hctx pointer directly to
the queuecommand callback function would require modification of
all SCSI LLDs, add a function to the block layer that allows to
query the hardware context index.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
---
 block/blk-mq-tag.c     | 27 +++++++++++++++++++++++++++
 block/blk-mq.c         |  2 ++
 include/linux/blk-mq.h | 23 +++++++++++++++++++++++
 3 files changed, 52 insertions(+)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index c1b9242..b5088f0 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -595,6 +595,33 @@ int blk_mq_tag_update_depth(struct blk_mq_tags *tags, unsigned int tdepth)
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
index df8e1e0..8098aac 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2018,6 +2018,8 @@ static int blk_mq_alloc_rq_maps(struct blk_mq_tag_set *set)
  */
 int blk_mq_alloc_tag_set(struct blk_mq_tag_set *set)
 {
+	BUILD_BUG_ON(BLK_MQ_MAX_DEPTH > 1 << BLK_MQ_UNIQUE_TAG_TAG_BITS);
+
 	if (!set->nr_hw_queues)
 		return -EINVAL;
 	if (!set->queue_depth)
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index eac4f31..b53d0c2 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -167,6 +167,29 @@ struct request *blk_mq_alloc_request(struct request_queue *q, int rw,
 		gfp_t gfp, bool reserved);
 struct request *blk_mq_tag_to_rq(struct blk_mq_tags *tags, unsigned int tag);
 
+enum {
+	BLK_MQ_UNIQUE_TAG_TAG_BITS = 16,
+	BLK_MQ_UNIQUE_TAG_TAG_MASK = (1 << BLK_MQ_UNIQUE_TAG_TAG_BITS) - 1,
+};
+
+u32 blk_mq_unique_tag(struct request *rq);
+
+static inline u32 blk_mq_build_unique_tag(int hwq, int tag)
+{
+	return (hwq << BLK_MQ_UNIQUE_TAG_TAG_BITS) |
+		(tag & BLK_MQ_UNIQUE_TAG_TAG_MASK);
+}
+
+static inline u16 blk_mq_unique_tag_to_hwq(u32 unique_tag)
+{
+	return unique_tag >> BLK_MQ_UNIQUE_TAG_TAG_BITS;
+}
+
+static inline u16 blk_mq_unique_tag_to_tag(u32 unique_tag)
+{
+	return unique_tag & BLK_MQ_UNIQUE_TAG_TAG_MASK;
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
