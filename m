From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 1/2] blk-mq: add callback of .cleanup_rq
Date: Sat, 20 Jul 2019 11:06:36 +0800
Message-ID: <20190720030637.14447-2-ming.lei@redhat.com>
References: <20190720030637.14447-1-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190720030637.14447-1-ming.lei@redhat.com>
Sender: stable-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Ming Lei <ming.lei@redhat.com>, "Ewan D . Milne" <emilne@redhat.com>, Bart Van Assche <bvanassche@acm.org>, Hannes Reinecke <hare@suse.com>, Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

dm-rq needs to free request which has been dispatched and not completed
by underlying queue. However, the underlying queue may have allocated
private data for this request in .queue_rq(), so the request private
part is leaked.

Add one new callback of .cleanup_rq() to free the request private data.

Another use case is to free request when the hctx is dead during
cpu hotplug context.

Cc: Ewan D. Milne <emilne@redhat.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com
Cc: <stable@vger.kernel.org>
Fixes: 396eaf21ee17 ("blk-mq: improve DM's blk-mq IO merging via blk_insert_cloned_request feedback")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-mq.c         | 3 +++
 include/linux/blk-mq.h | 7 +++++++
 2 files changed, 10 insertions(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index b038ec680e84..fc38d95c557f 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -502,6 +502,9 @@ void blk_mq_free_request(struct request *rq)
 	struct blk_mq_ctx *ctx = rq->mq_ctx;
 	struct blk_mq_hw_ctx *hctx = rq->mq_hctx;
 
+	if (q->mq_ops->cleanup_rq)
+		q->mq_ops->cleanup_rq(rq);
+
 	if (rq->rq_flags & RQF_ELVPRIV) {
 		if (e && e->type->ops.finish_request)
 			e->type->ops.finish_request(rq);
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 3fa1fa59f9b2..5882675c1989 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -140,6 +140,7 @@ typedef int (poll_fn)(struct blk_mq_hw_ctx *);
 typedef int (map_queues_fn)(struct blk_mq_tag_set *set);
 typedef bool (busy_fn)(struct request_queue *);
 typedef void (complete_fn)(struct request *);
+typedef void (cleanup_rq_fn)(struct request *);
 
 
 struct blk_mq_ops {
@@ -200,6 +201,12 @@ struct blk_mq_ops {
 	/* Called from inside blk_get_request() */
 	void (*initialize_rq_fn)(struct request *rq);
 
+	/*
+	 * Called before freeing one request which isn't completed yet,
+	 * and usually for freeing the driver private part
+	 */
+	cleanup_rq_fn		*cleanup_rq;
+
 	/*
 	 * If set, returns whether or not this queue currently is busy
 	 */
-- 
2.20.1
