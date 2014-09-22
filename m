From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/2] block: fix blk_abort_request on blk-mq
Date: Mon, 22 Sep 2014 15:59:30 +0200
Message-ID: <1411394371-16254-2-git-send-email-hch@lst.de>
References: <1411394371-16254-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1411394371-16254-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c      | 2 +-
 block/blk-timeout.c | 5 ++++-
 block/blk.h         | 2 ++
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 966c920..aeac4b7 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -531,7 +531,7 @@ struct blk_mq_timeout_data {
 	unsigned int next_set;
 };
 
-static void blk_mq_rq_timed_out(struct request *req, bool reserved)
+void blk_mq_rq_timed_out(struct request *req, bool reserved)
 {
 	struct blk_mq_ops *ops = req->q->mq_ops;
 	enum blk_eh_timer_return ret = BLK_EH_RESET_TIMER;
diff --git a/block/blk-timeout.c b/block/blk-timeout.c
index 8bae410..c3c14ce 100644
--- a/block/blk-timeout.c
+++ b/block/blk-timeout.c
@@ -158,7 +158,10 @@ void blk_abort_request(struct request *req)
 	if (blk_mark_rq_complete(req))
 		return;
 	blk_delete_timer(req);
-	blk_rq_timed_out(req);
+	if (req->q->mq_ops)
+		blk_mq_rq_timed_out(req, false);
+	else
+		blk_rq_timed_out(req);
 }
 EXPORT_SYMBOL_GPL(blk_abort_request);
 
diff --git a/block/blk.h b/block/blk.h
index e515a28..159e973 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -250,4 +250,6 @@ static inline int blk_throtl_init(struct request_queue *q) { return 0; }
 static inline void blk_throtl_exit(struct request_queue *q) { }
 #endif /* CONFIG_BLK_DEV_THROTTLING */
 
+extern void blk_mq_rq_timed_out(struct request *req, bool reserved);
+
 #endif /* BLK_INTERNAL_H */
-- 
1.9.1
