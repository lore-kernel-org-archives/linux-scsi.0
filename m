From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6/6] blk-mq: pass a reserved argument to the timeout handler
Date: Sat, 13 Sep 2014 16:40:13 -0700
Message-ID: <1410651613-1993-7-git-send-email-hch@lst.de>
References: <1410651613-1993-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1410651613-1993-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Robert Elliott <elliott@hp.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Allow blk-mq to pass an argument to the timeout handler to indicate
if we're timing out a reserved or regular command.  For many drivers
those need to be handled different.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c          |  6 +++---
 drivers/scsi/scsi_lib.c | 10 +++++++++-
 include/linux/blk-mq.h  |  3 ++-
 3 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index c14d397..85eb540 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -516,7 +516,7 @@ struct blk_mq_timeout_data {
 	unsigned int next_set;
 };
 
-static void blk_mq_rq_timed_out(struct request *req)
+static void blk_mq_rq_timed_out(struct request *req, bool reserved)
 {
 	struct blk_mq_ops *ops = req->q->mq_ops;
 	enum blk_eh_timer_return ret = BLK_EH_RESET_TIMER;
@@ -534,7 +534,7 @@ static void blk_mq_rq_timed_out(struct request *req)
 		return;
 
 	if (ops->timeout)
-		ret = ops->timeout(req);
+		ret = ops->timeout(req, reserved);
 
 	switch (ret) {
 	case BLK_EH_HANDLED:
@@ -562,7 +562,7 @@ static void blk_mq_check_expired(struct blk_mq_hw_ctx *hctx,
 
 	if (time_after_eq(jiffies, rq->deadline)) {
 		if (!blk_mark_rq_complete(rq))
-			blk_mq_rq_timed_out(rq);
+			blk_mq_rq_timed_out(rq, reserved);
 	} else if (!data->next_set || time_after(data->next, rq->deadline)) {
 		data->next = rq->deadline;
 		data->next_set = 1;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index e95adaa..dc01ab2 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1932,6 +1932,14 @@ out:
 	return ret;
 }
 
+static enum blk_eh_timer_return scsi_timeout(struct request *req,
+		bool reserved)
+{
+	if (reserved)
+		return BLK_EH_RESET_TIMER;
+	return scsi_times_out(req);
+}
+
 static int scsi_init_request(void *data, struct request *rq,
 		unsigned int hctx_idx, unsigned int request_idx,
 		unsigned int numa_node)
@@ -2043,7 +2051,7 @@ static struct blk_mq_ops scsi_mq_ops = {
 	.map_queue	= blk_mq_map_queue,
 	.queue_rq	= scsi_queue_rq,
 	.complete	= scsi_softirq_done,
-	.timeout	= scsi_times_out,
+	.timeout	= scsi_timeout,
 	.init_request	= scsi_init_request,
 	.exit_request	= scsi_exit_request,
 };
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 0eb0f64..3253495 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -79,6 +79,7 @@ struct blk_mq_tag_set {
 
 typedef int (queue_rq_fn)(struct blk_mq_hw_ctx *, struct request *, bool);
 typedef struct blk_mq_hw_ctx *(map_queue_fn)(struct request_queue *, const int);
+typedef enum blk_eh_timer_return (timeout_fn)(struct request *, bool);
 typedef int (init_hctx_fn)(struct blk_mq_hw_ctx *, void *, unsigned int);
 typedef void (exit_hctx_fn)(struct blk_mq_hw_ctx *, unsigned int);
 typedef int (init_request_fn)(void *, struct request *, unsigned int,
@@ -103,7 +104,7 @@ struct blk_mq_ops {
 	/*
 	 * Called on request timeout
 	 */
-	rq_timed_out_fn		*timeout;
+	timeout_fn		*timeout;
 
 	softirq_done_fn		*complete;
 
-- 
1.9.1
