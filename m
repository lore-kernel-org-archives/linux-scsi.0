From: mchristi@redhat.com
Subject: [PATCH 32/45] block: prepare mq request creation to
	use REQ_OPs
Date: Sun,  5 Jun 2016 14:32:12 -0500
Message-ID: <1465155145-10812-33-git-send-email-mchristi@redhat.com>
References: <1465155145-10812-1-git-send-email-mchristi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ocfs2-devel-bounces@oss.oracle.com>
In-Reply-To: <1465155145-10812-1-git-send-email-mchristi@redhat.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
To: linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org, konrad.wilk@oracle.com, drbd-dev@lists.linbit.com, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org, target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, osd-dev@open-osd.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com
Cc: Mike Christie <mchristi@redhat.com>
List-Id: linux-scsi@vger.kernel.org

From: Mike Christie <mchristi@redhat.com>

This patch modifies the blk mq request creation code to use
separate variables for the operation and flags, because in the
the next patches the struct request users will be converted like
was done for bios.

Signed-off-by: Mike Christie <mchristi@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 block/blk-mq.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 29cbc1b..3393f29 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -159,16 +159,17 @@ bool blk_mq_can_queue(struct blk_mq_hw_ctx *hctx)
 EXPORT_SYMBOL(blk_mq_can_queue);
 
 static void blk_mq_rq_ctx_init(struct request_queue *q, struct blk_mq_ctx *ctx,
-			       struct request *rq, unsigned int rw_flags)
+			       struct request *rq, int op,
+			       unsigned int op_flags)
 {
 	if (blk_queue_io_stat(q))
-		rw_flags |= REQ_IO_STAT;
+		op_flags |= REQ_IO_STAT;
 
 	INIT_LIST_HEAD(&rq->queuelist);
 	/* csd/requeue_work/fifo_time is initialized before use */
 	rq->q = q;
 	rq->mq_ctx = ctx;
-	rq->cmd_flags |= rw_flags;
+	req_set_op_attrs(rq, op, op_flags);
 	/* do not touch atomic flags, it needs atomic ops against the timer */
 	rq->cpu = -1;
 	INIT_HLIST_NODE(&rq->hash);
@@ -203,11 +204,11 @@ static void blk_mq_rq_ctx_init(struct request_queue *q, struct blk_mq_ctx *ctx,
 	rq->end_io_data = NULL;
 	rq->next_rq = NULL;
 
-	ctx->rq_dispatched[rw_is_sync(rw_flags)]++;
+	ctx->rq_dispatched[rw_is_sync(op | op_flags)]++;
 }
 
 static struct request *
-__blk_mq_alloc_request(struct blk_mq_alloc_data *data, int rw)
+__blk_mq_alloc_request(struct blk_mq_alloc_data *data, int op, int op_flags)
 {
 	struct request *rq;
 	unsigned int tag;
@@ -222,7 +223,7 @@ __blk_mq_alloc_request(struct blk_mq_alloc_data *data, int rw)
 		}
 
 		rq->tag = tag;
-		blk_mq_rq_ctx_init(data->q, data->ctx, rq, rw);
+		blk_mq_rq_ctx_init(data->q, data->ctx, rq, op, op_flags);
 		return rq;
 	}
 
@@ -246,7 +247,7 @@ struct request *blk_mq_alloc_request(struct request_queue *q, int rw,
 	hctx = q->mq_ops->map_queue(q, ctx->cpu);
 	blk_mq_set_alloc_data(&alloc_data, q, flags, ctx, hctx);
 
-	rq = __blk_mq_alloc_request(&alloc_data, rw);
+	rq = __blk_mq_alloc_request(&alloc_data, rw, 0);
 	if (!rq && !(flags & BLK_MQ_REQ_NOWAIT)) {
 		__blk_mq_run_hw_queue(hctx);
 		blk_mq_put_ctx(ctx);
@@ -254,7 +255,7 @@ struct request *blk_mq_alloc_request(struct request_queue *q, int rw,
 		ctx = blk_mq_get_ctx(q);
 		hctx = q->mq_ops->map_queue(q, ctx->cpu);
 		blk_mq_set_alloc_data(&alloc_data, q, flags, ctx, hctx);
-		rq =  __blk_mq_alloc_request(&alloc_data, rw);
+		rq =  __blk_mq_alloc_request(&alloc_data, rw, 0);
 		ctx = alloc_data.ctx;
 	}
 	blk_mq_put_ctx(ctx);
@@ -1169,7 +1170,8 @@ static struct request *blk_mq_map_request(struct request_queue *q,
 	struct blk_mq_hw_ctx *hctx;
 	struct blk_mq_ctx *ctx;
 	struct request *rq;
-	int rw = bio_data_dir(bio);
+	int op = bio_data_dir(bio);
+	int op_flags = 0;
 	struct blk_mq_alloc_data alloc_data;
 
 	blk_queue_enter_live(q);
@@ -1177,20 +1179,20 @@ static struct request *blk_mq_map_request(struct request_queue *q,
 	hctx = q->mq_ops->map_queue(q, ctx->cpu);
 
 	if (rw_is_sync(bio->bi_rw))
-		rw |= REQ_SYNC;
+		op_flags |= REQ_SYNC;
 
-	trace_block_getrq(q, bio, rw);
+	trace_block_getrq(q, bio, op);
 	blk_mq_set_alloc_data(&alloc_data, q, BLK_MQ_REQ_NOWAIT, ctx, hctx);
-	rq = __blk_mq_alloc_request(&alloc_data, rw);
+	rq = __blk_mq_alloc_request(&alloc_data, op, op_flags);
 	if (unlikely(!rq)) {
 		__blk_mq_run_hw_queue(hctx);
 		blk_mq_put_ctx(ctx);
-		trace_block_sleeprq(q, bio, rw);
+		trace_block_sleeprq(q, bio, op);
 
 		ctx = blk_mq_get_ctx(q);
 		hctx = q->mq_ops->map_queue(q, ctx->cpu);
 		blk_mq_set_alloc_data(&alloc_data, q, 0, ctx, hctx);
-		rq = __blk_mq_alloc_request(&alloc_data, rw);
+		rq = __blk_mq_alloc_request(&alloc_data, op, op_flags);
 		ctx = alloc_data.ctx;
 		hctx = alloc_data.hctx;
 	}
-- 
2.7.2
