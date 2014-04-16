From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/8] blk-mq: add blk_mq_start_hw_queues
Date: Wed, 16 Apr 2014 09:44:56 +0200
Message-ID: <1397634299-7466-6-git-send-email-hch@lst.de>
References: <1397634299-7466-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1397634299-7466-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Add a helper to unconditionally kick contexts of a queue.  This will
be needed by the SCSI layer to provide fair queueing between multiple
devices on a single host.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c         |   11 +++++++++++
 include/linux/blk-mq.h |    1 +
 2 files changed, 12 insertions(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 128b5e5..7946f0b 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -699,6 +699,17 @@ void blk_mq_start_hw_queue(struct blk_mq_hw_ctx *hctx)
 }
 EXPORT_SYMBOL(blk_mq_start_hw_queue);
 
+void blk_mq_start_hw_queues(struct request_queue *q)
+{
+	struct blk_mq_hw_ctx *hctx;
+	int i;
+
+	queue_for_each_hw_ctx(q, hctx, i)
+		blk_mq_start_hw_queue(hctx);
+}
+EXPORT_SYMBOL(blk_mq_start_hw_queues);
+
+
 void blk_mq_start_stopped_hw_queues(struct request_queue *q, bool async)
 {
 	struct blk_mq_hw_ctx *hctx;
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index ae868e7..391377e 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -158,6 +158,7 @@ void blk_mq_complete_request(struct request *rq);
 void blk_mq_stop_hw_queue(struct blk_mq_hw_ctx *hctx);
 void blk_mq_start_hw_queue(struct blk_mq_hw_ctx *hctx);
 void blk_mq_stop_hw_queues(struct request_queue *q);
+void blk_mq_start_hw_queues(struct request_queue *q);
 void blk_mq_start_stopped_hw_queues(struct request_queue *q, bool async);
 void blk_mq_delay_queue(struct blk_mq_hw_ctx *hctx, unsigned long msecs);
 
-- 
1.7.10.4
