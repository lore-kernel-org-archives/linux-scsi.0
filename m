From: Ming Lei <ming.lei@canonical.com>
Subject: [PATCH 2/6] blk-mq: introduce init_flush_rq callback and its pair
Date: Sun,  7 Sep 2014 16:39:18 +0800
Message-ID: <1410079162-9872-3-git-send-email-ming.lei@canonical.com>
References: <1410079162-9872-1-git-send-email-ming.lei@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1410079162-9872-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@canonical.com>
List-Id: linux-scsi@vger.kernel.org

Currently pdu of the flush rq is simlpy copied from another rq,
turns out it isn't a good approach:

	- it isn't enough to initialize pointer field well, and
	easy to cause bugs if some pointers filed are included
	in pdu

	- the copy isn't necessary, because the pdu should just
	serve for submitting flush req purpose, like non-flush
	case, and flush case of legacy block driver

	- actually init_flush_rq/exit_flush_rq is needed for
	seting up flush request.

So introduce these two callbacks for driver to handle the case
easily.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 block/blk-flush.c      |   11 +++++++++++
 block/blk-mq.c         |    2 ++
 block/blk-mq.h         |    1 +
 include/linux/blk-mq.h |    9 +++++++++
 4 files changed, 23 insertions(+)

diff --git a/block/blk-flush.c b/block/blk-flush.c
index 75ca6cd0..14654e1 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -485,5 +485,16 @@ int blk_mq_init_flush(struct request_queue *q)
 				GFP_KERNEL);
 	if (!q->flush_rq)
 		return -ENOMEM;
+
+	if (q->mq_ops->init_flush_rq)
+		return q->mq_ops->init_flush_rq(q, q->flush_rq);
+
 	return 0;
 }
+
+void blk_mq_exit_flush(struct request_queue *q)
+{
+	/* flush_rq is freed centrally for both mq and legacy queue */
+	if (q->mq_ops->exit_flush_rq)
+		q->mq_ops->exit_flush_rq(q, q->flush_rq);
+}
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 23386c0..1daef32 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1868,6 +1868,8 @@ void blk_mq_free_queue(struct request_queue *q)
 {
 	struct blk_mq_tag_set	*set = q->tag_set;
 
+	blk_mq_exit_flush(q);
+
 	blk_mq_del_queue_tag_set(q);
 
 	blk_mq_exit_hw_queues(q, set, set->nr_hw_queues);
diff --git a/block/blk-mq.h b/block/blk-mq.h
index b0bd9bc..ea9974f 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -28,6 +28,7 @@ struct blk_mq_ctx {
 void __blk_mq_complete_request(struct request *rq);
 void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx, bool async);
 int blk_mq_init_flush(struct request_queue *q);
+void blk_mq_exit_flush(struct request_queue *q);
 void blk_mq_freeze_queue(struct request_queue *q);
 void blk_mq_free_queue(struct request_queue *q);
 void blk_mq_clone_flush_request(struct request *flush_rq,
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index a1e31f2..d24c13e 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -85,6 +85,8 @@ typedef int (init_request_fn)(void *, struct request *, unsigned int,
 		unsigned int, unsigned int);
 typedef void (exit_request_fn)(void *, struct request *, unsigned int,
 		unsigned int);
+typedef int (init_flush_rq_fn)(struct request_queue *, struct request *);
+typedef void (exit_flush_rq_fn)(struct request_queue *, struct request *);
 
 struct blk_mq_ops {
 	/*
@@ -119,6 +121,13 @@ struct blk_mq_ops {
 	 */
 	init_request_fn		*init_request;
 	exit_request_fn		*exit_request;
+
+	/*
+	 * Called after flush request allocated by the block layer to
+	 * allow the driver to set up driver specific data.
+	 */
+	init_flush_rq_fn	*init_flush_rq;
+	exit_flush_rq_fn	*exit_flush_rq;
 };
 
 enum {
-- 
1.7.9.5
