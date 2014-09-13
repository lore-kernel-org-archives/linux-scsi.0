From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/6] blk-mq: fix and simplify tag iteration for the timeout handler
Date: Sat, 13 Sep 2014 16:40:11 -0700
Message-ID: <1410651613-1993-5-git-send-email-hch@lst.de>
References: <1410651613-1993-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1410651613-1993-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Robert Elliott <elliott@hp.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Don't do a kmalloc from timer to handle timeouts, chances are we could be
under heavy load or similar and thus just miss out on the timeouts.
Fortunately it is very easy to just iterate over all in use tags, and doing
this properly actually cleans up the blk_mq_busy_iter API as well, and
prepares us for the next patch by passing a reserved argument to the
iterator.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq-tag.c      | 46 +++++++++++---------------
 block/blk-mq.c          | 85 +++++++++++++++----------------------------------
 include/linux/blk-mq.h  |  6 +++-
 include/scsi/scsi_tcq.h |  2 +-
 4 files changed, 50 insertions(+), 89 deletions(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index c1b9242..d6ea458 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -392,45 +392,37 @@ void blk_mq_put_tag(struct blk_mq_hw_ctx *hctx, unsigned int tag,
 		__blk_mq_put_reserved_tag(tags, tag);
 }
 
-static void bt_for_each_free(struct blk_mq_bitmap_tags *bt,
-			     unsigned long *free_map, unsigned int off)
+static void bt_for_each(struct blk_mq_hw_ctx *hctx,
+		struct blk_mq_bitmap_tags *bt, unsigned int off,
+		busy_iter_fn *fn, void *data, bool reserved)
 {
-	int i;
+	struct request *rq;
+	int bit, i;
 
 	for (i = 0; i < bt->map_nr; i++) {
 		struct blk_align_bitmap *bm = &bt->map[i];
-		int bit = 0;
-
-		do {
-			bit = find_next_zero_bit(&bm->word, bm->depth, bit);
-			if (bit >= bm->depth)
-				break;
 
-			__set_bit(bit + off, free_map);
-			bit++;
-		} while (1);
+		for (bit = find_first_bit(&bm->word, bm->depth);
+		     bit < bm->depth;
+		     bit = find_next_bit(&bm->word, bm->depth, bit + 1)) {
+		     	rq = blk_mq_tag_to_rq(hctx->tags, off + bit);
+			if (rq->q == hctx->queue)
+				fn(hctx, rq, data, reserved);
+		}
 
 		off += (1 << bt->bits_per_word);
 	}
 }
 
-void blk_mq_tag_busy_iter(struct blk_mq_tags *tags,
-			  void (*fn)(void *, unsigned long *), void *data)
+void blk_mq_tag_busy_iter(struct blk_mq_hw_ctx *hctx, busy_iter_fn *fn,
+		void *priv)
 {
-	unsigned long *tag_map;
-	size_t map_size;
-
-	map_size = ALIGN(tags->nr_tags, BITS_PER_LONG) / BITS_PER_LONG;
-	tag_map = kzalloc(map_size * sizeof(unsigned long), GFP_ATOMIC);
-	if (!tag_map)
-		return;
-
-	bt_for_each_free(&tags->bitmap_tags, tag_map, tags->nr_reserved_tags);
-	if (tags->nr_reserved_tags)
-		bt_for_each_free(&tags->breserved_tags, tag_map, 0);
+	struct blk_mq_tags *tags = hctx->tags;
 
-	fn(data, tag_map);
-	kfree(tag_map);
+ 	if (tags->nr_reserved_tags)
+		bt_for_each(hctx, &tags->breserved_tags, 0, fn, priv, true);
+	bt_for_each(hctx, &tags->bitmap_tags, tags->nr_reserved_tags, fn, priv,
+			false);
 }
 EXPORT_SYMBOL(blk_mq_tag_busy_iter);
 
diff --git a/block/blk-mq.c b/block/blk-mq.c
index d1230ea..2d96b0d 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -511,58 +511,6 @@ struct request *blk_mq_tag_to_rq(struct blk_mq_tags *tags, unsigned int tag)
 }
 EXPORT_SYMBOL(blk_mq_tag_to_rq);
 
-struct blk_mq_timeout_data {
-	struct blk_mq_hw_ctx *hctx;
-	unsigned long *next;
-	unsigned int *next_set;
-};
-
-static void blk_mq_timeout_check(void *__data, unsigned long *free_tags)
-{
-	struct blk_mq_timeout_data *data = __data;
-	struct blk_mq_hw_ctx *hctx = data->hctx;
-	unsigned int tag;
-
-	 /* It may not be in flight yet (this is where
-	 * the REQ_ATOMIC_STARTED flag comes in). The requests are
-	 * statically allocated, so we know it's always safe to access the
-	 * memory associated with a bit offset into ->rqs[].
-	 */
-	tag = 0;
-	do {
-		struct request *rq;
-
-		tag = find_next_zero_bit(free_tags, hctx->tags->nr_tags, tag);
-		if (tag >= hctx->tags->nr_tags)
-			break;
-
-		rq = blk_mq_tag_to_rq(hctx->tags, tag++);
-		if (rq->q != hctx->queue)
-			continue;
-		if (!test_bit(REQ_ATOM_STARTED, &rq->atomic_flags))
-			continue;
-
-		blk_rq_check_expired(rq, data->next, data->next_set);
-	} while (1);
-}
-
-static void blk_mq_hw_ctx_check_timeout(struct blk_mq_hw_ctx *hctx,
-					unsigned long *next,
-					unsigned int *next_set)
-{
-	struct blk_mq_timeout_data data = {
-		.hctx		= hctx,
-		.next		= next,
-		.next_set	= next_set,
-	};
-
-	/*
-	 * Ask the tagging code to iterate busy requests, so we can
-	 * check them for timeout.
-	 */
-	blk_mq_tag_busy_iter(hctx->tags, blk_mq_timeout_check, &data);
-}
-
 static enum blk_eh_timer_return blk_mq_rq_timed_out(struct request *rq)
 {
 	struct request_queue *q = rq->q;
@@ -584,13 +532,30 @@ static enum blk_eh_timer_return blk_mq_rq_timed_out(struct request *rq)
 
 	return q->mq_ops->timeout(rq);
 }
+		
+struct blk_mq_timeout_data {
+	unsigned long next;
+	unsigned int next_set;
+};
+
+static void blk_mq_check_expired(struct blk_mq_hw_ctx *hctx,
+		struct request *rq, void *priv, bool reserved)
+{
+	struct blk_mq_timeout_data *data = priv;
+
+	if (test_bit(REQ_ATOM_STARTED, &rq->atomic_flags))
+		blk_rq_check_expired(rq, &data->next, &data->next_set);
+}
 
-static void blk_mq_rq_timer(unsigned long data)
+static void blk_mq_rq_timer(unsigned long priv)
 {
-	struct request_queue *q = (struct request_queue *) data;
+	struct request_queue *q = (struct request_queue *)priv;
+	struct blk_mq_timeout_data data = {
+		.next		= 0,
+		.next_set	= 0,
+	};
 	struct blk_mq_hw_ctx *hctx;
-	unsigned long next = 0;
-	int i, next_set = 0;
+	int i;
 
 	queue_for_each_hw_ctx(q, hctx, i) {
 		/*
@@ -600,12 +565,12 @@ static void blk_mq_rq_timer(unsigned long data)
 		if (!hctx->nr_ctx || !hctx->tags)
 			continue;
 
-		blk_mq_hw_ctx_check_timeout(hctx, &next, &next_set);
+		blk_mq_tag_busy_iter(hctx, blk_mq_check_expired, &data);
 	}
 
-	if (next_set) {
-		next = blk_rq_timeout(round_jiffies_up(next));
-		mod_timer(&q->timeout, next);
+	if (data.next_set) {
+		data.next = blk_rq_timeout(round_jiffies_up(data.next));
+		mod_timer(&q->timeout, data.next);
 	} else {
 		queue_for_each_hw_ctx(q, hctx, i)
 			blk_mq_tag_idle(hctx);
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index cb217c1..0eb0f64 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -86,6 +86,9 @@ typedef int (init_request_fn)(void *, struct request *, unsigned int,
 typedef void (exit_request_fn)(void *, struct request *, unsigned int,
 		unsigned int);
 
+typedef void (busy_iter_fn)(struct blk_mq_hw_ctx *, struct request *, void *,
+		bool);
+
 struct blk_mq_ops {
 	/*
 	 * Queue request
@@ -174,7 +177,8 @@ void blk_mq_stop_hw_queues(struct request_queue *q);
 void blk_mq_start_hw_queues(struct request_queue *q);
 void blk_mq_start_stopped_hw_queues(struct request_queue *q, bool async);
 void blk_mq_delay_queue(struct blk_mq_hw_ctx *hctx, unsigned long msecs);
-void blk_mq_tag_busy_iter(struct blk_mq_tags *tags, void (*fn)(void *data, unsigned long *), void *data);
+void blk_mq_tag_busy_iter(struct blk_mq_hw_ctx *hctx, busy_iter_fn *fn,
+		void *priv);
 
 /*
  * Driver command data is immediately after the request. So subtract request
diff --git a/include/scsi/scsi_tcq.h b/include/scsi/scsi_tcq.h
index cdcc90b..e645835 100644
--- a/include/scsi/scsi_tcq.h
+++ b/include/scsi/scsi_tcq.h
@@ -68,7 +68,7 @@ static inline void scsi_activate_tcq(struct scsi_device *sdev, int depth)
 		return;
 
 	if (!shost_use_blk_mq(sdev->host) &&
-	    blk_queue_tagged(sdev->request_queue))
+	    !blk_queue_tagged(sdev->request_queue))
 		blk_queue_init_tags(sdev->request_queue, depth,
 				    sdev->host->bqt);
 
-- 
1.9.1
