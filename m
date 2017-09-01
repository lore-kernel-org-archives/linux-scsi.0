From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 2/8] block: Fix declaration of blk-mq scheduler functions
Date: Fri,  1 Sep 2017 20:36:25 +0900
Message-ID: <20170901113631.12323-3-damien.lemoal@wdc.com>
References: <20170901113631.12323-1-damien.lemoal@wdc.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170901113631.12323-1-damien.lemoal@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: linux-scsi@vger.kernel.org

The functions blk_mq_sched_free_hctx_data(), blk_mq_sched_try_merge(),
blk_mq_sched_try_insert_merge() and blk_mq_sched_request_inserted() are
all exported symbols but declared only internally in
block/blk-mq-sched.h. Move their declaration to include/linux/blk-mq.h
to make them available to block external scheduler modules.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 block/blk-mq-sched.h   |  7 -------
 include/linux/blk-mq.h | 10 ++++++++++
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/block/blk-mq-sched.h b/block/blk-mq-sched.h
index 9267d0b7c197..3b725f8fbebe 100644
--- a/block/blk-mq-sched.h
+++ b/block/blk-mq-sched.h
@@ -4,16 +4,9 @@
 #include "blk-mq.h"
 #include "blk-mq-tag.h"
 
-void blk_mq_sched_free_hctx_data(struct request_queue *q,
-				 void (*exit)(struct blk_mq_hw_ctx *));
-
 void blk_mq_sched_assign_ioc(struct request *rq, struct bio *bio);
 
-void blk_mq_sched_request_inserted(struct request *rq);
-bool blk_mq_sched_try_merge(struct request_queue *q, struct bio *bio,
-				struct request **merged_request);
 bool __blk_mq_sched_bio_merge(struct request_queue *q, struct bio *bio);
-bool blk_mq_sched_try_insert_merge(struct request_queue *q, struct request *rq);
 void blk_mq_sched_restart(struct blk_mq_hw_ctx *hctx);
 
 void blk_mq_sched_insert_request(struct request *rq, bool at_head,
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index a369174a9679..128742552549 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -284,6 +284,16 @@ void blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set, int nr_hw_queues);
 void blk_mq_quiesce_queue_nowait(struct request_queue *q);
 
 /*
+ * Scheduler helper functions.
+ */
+void blk_mq_sched_free_hctx_data(struct request_queue *q,
+				 void (*exit)(struct blk_mq_hw_ctx *));
+bool blk_mq_sched_try_merge(struct request_queue *q, struct bio *bio,
+			    struct request **merged_request);
+bool blk_mq_sched_try_insert_merge(struct request_queue *q, struct request *rq);
+void blk_mq_sched_request_inserted(struct request *rq);
+
+/*
  * Driver command data is immediately after the request. So subtract request
  * size to get back to the original request, add request size to get the PDU.
  */
-- 
2.13.5
