From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 17/31] block: Introduce request_queue.initialize_rq_fn()
Date: Tue, 23 May 2017 17:34:06 -0700
Message-ID: <20170524003420.5381-18-bart.vanassche@sandisk.com>
References: <20170524003420.5381-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170524003420.5381-1-bart.vanassche@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, Omar Sandoval <osandov@fb.com>, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

Several block drivers need to initialize the driver-private data
after having called blk_get_request() and before .prep_rq_fn() is
called, e.g. when submitting a REQ_OP_SCSI_* request. Avoid that
that initialization code has to be repeated after every
blk_get_request() call by adding a new callback function to struct
request_queue.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Omar Sandoval <osandov@fb.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: linux-block@vger.kernel.org
---
 block/blk-core.c       | 3 +++
 block/blk-mq.c         | 3 +++
 include/linux/blkdev.h | 4 ++++
 3 files changed, 10 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index 55a7b76db7c2..8a680f7bb168 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -126,6 +126,9 @@ void blk_rq_init(struct request_queue *q, struct request *rq)
 	rq->start_time = jiffies;
 	set_start_time_ns(rq);
 	rq->part = NULL;
+
+	if (q->initialize_rq_fn)
+		q->initialize_rq_fn(rq);
 }
 EXPORT_SYMBOL(blk_rq_init);
 
diff --git a/block/blk-mq.c b/block/blk-mq.c
index a69ad122ed66..2af43d4e5b96 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -241,6 +241,9 @@ void blk_mq_rq_ctx_init(struct request_queue *q, struct blk_mq_ctx *ctx,
 	rq->end_io_data = NULL;
 	rq->next_rq = NULL;
 
+	if (q->initialize_rq_fn)
+		q->initialize_rq_fn(rq);
+
 	ctx->rq_dispatched[op_is_sync(op)]++;
 }
 EXPORT_SYMBOL_GPL(blk_mq_rq_ctx_init);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 6416a5834b05..e3c03d429371 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -410,8 +410,12 @@ struct request_queue {
 	rq_timed_out_fn		*rq_timed_out_fn;
 	dma_drain_needed_fn	*dma_drain_needed;
 	lld_busy_fn		*lld_busy_fn;
+	/* Called just after a request is allocated */
 	init_rq_fn		*init_rq_fn;
+	/* Called just before a request is freed */
 	exit_rq_fn		*exit_rq_fn;
+	/* Called from inside blk_get_request() */
+	void (*initialize_rq_fn)(struct request *rq);
 
 	const struct blk_mq_ops	*mq_ops;
 
-- 
2.12.2
