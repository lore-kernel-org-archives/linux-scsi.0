From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 7/8] blk-mq: rename mq_flush_work struct request member
Date: Wed, 16 Apr 2014 09:44:58 +0200
Message-ID: <1397634299-7466-8-git-send-email-hch@lst.de>
References: <1397634299-7466-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1397634299-7466-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

We will use this work_struct to requeue scsi commands from the complention
handler as well, so give it a more generic name.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-flush.c      |    6 +++---
 include/linux/blkdev.h |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/block/blk-flush.c b/block/blk-flush.c
index c41fc19..ec7a224 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -134,7 +134,7 @@ static void mq_flush_run(struct work_struct *work)
 {
 	struct request *rq;
 
-	rq = container_of(work, struct request, mq_flush_work);
+	rq = container_of(work, struct request, requeue_work);
 
 	memset(&rq->csd, 0, sizeof(rq->csd));
 	blk_mq_insert_request(rq, false, true, false);
@@ -143,8 +143,8 @@ static void mq_flush_run(struct work_struct *work)
 static bool blk_flush_queue_rq(struct request *rq, bool add_front)
 {
 	if (rq->q->mq_ops) {
-		INIT_WORK(&rq->mq_flush_work, mq_flush_run);
-		kblockd_schedule_work(&rq->mq_flush_work);
+		INIT_WORK(&rq->requeue_work, mq_flush_run);
+		kblockd_schedule_work(&rq->requeue_work);
 		return false;
 	} else {
 		if (add_front)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 95bb551..7128808 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -98,7 +98,7 @@ struct request {
 	struct list_head queuelist;
 	union {
 		struct call_single_data csd;
-		struct work_struct mq_flush_work;
+		struct work_struct requeue_work;
 		unsigned long fifo_time;
 	};
 
-- 
1.7.10.4
