From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 1/2] blk-mq: move blk_mq_request_started() into header file
Date: Fri,  3 Aug 2018 01:49:36 +0800
Message-ID: <20180802174937.15444-2-ming.lei@redhat.com>
References: <20180802174937.15444-1-ming.lei@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180802174937.15444-1-ming.lei@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, Ming Lei <ming.lei@redhat.com>, Josef Bacik <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, Guenter Roeck <linux@roeck-us.net>, Mark Brown <broonie@kernel.org>, Matt Hart <matthew.hart@linaro.org>, Johannes Thumshirn <jthumshirn@suse.de>, John Garry <john.garry@huawei.com>, Hannes Reinecke <hare@suse.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Define it as static inline given it might be called in fast path.

Suggested-by: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Mark Brown <broonie@kernel.org>
Cc: Matt Hart <matthew.hart@linaro.org>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
Cc: John Garry <john.garry@huawei.com>
Cc: Hannes Reinecke <hare@suse.com>,
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-mq.c         |  6 ------
 block/blk-mq.h         |  9 ---------
 include/linux/blk-mq.h | 15 ++++++++++++++-
 3 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index c92ce06fd565..7afd1c925fa8 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -619,12 +619,6 @@ void blk_mq_complete_request(struct request *rq)
 }
 EXPORT_SYMBOL(blk_mq_complete_request);
 
-int blk_mq_request_started(struct request *rq)
-{
-	return blk_mq_rq_state(rq) != MQ_RQ_IDLE;
-}
-EXPORT_SYMBOL_GPL(blk_mq_request_started);
-
 void blk_mq_start_request(struct request *rq)
 {
 	struct request_queue *q = rq->q;
diff --git a/block/blk-mq.h b/block/blk-mq.h
index 9497b47e2526..18bc448b61a3 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -90,15 +90,6 @@ extern void blk_mq_hctx_kobj_init(struct blk_mq_hw_ctx *hctx);
 
 void blk_mq_release(struct request_queue *q);
 
-/**
- * blk_mq_rq_state() - read the current MQ_RQ_* state of a request
- * @rq: target request.
- */
-static inline enum mq_rq_state blk_mq_rq_state(struct request *rq)
-{
-	return READ_ONCE(rq->state);
-}
-
 static inline struct blk_mq_ctx *__blk_mq_get_ctx(struct request_queue *q,
 					   unsigned int cpu)
 {
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 1da59c16f637..cc0359b83fb8 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -250,7 +250,6 @@ static inline u16 blk_mq_unique_tag_to_tag(u32 unique_tag)
 }
 
 
-int blk_mq_request_started(struct request *rq);
 void blk_mq_start_request(struct request *rq);
 void blk_mq_end_request(struct request *rq, blk_status_t error);
 void __blk_mq_end_request(struct request *rq, blk_status_t error);
@@ -303,6 +302,20 @@ static inline bool blk_mq_mark_complete(struct request *rq)
 			MQ_RQ_IN_FLIGHT;
 }
 
+/**
+ * blk_mq_rq_state() - read the current MQ_RQ_* state of a request
+ * @rq: target request.
+ */
+static inline enum mq_rq_state blk_mq_rq_state(struct request *rq)
+{
+	return READ_ONCE(rq->state);
+}
+
+static inline int blk_mq_request_started(struct request *rq)
+{
+	return blk_mq_rq_state(rq) != MQ_RQ_IDLE;
+}
+
 /*
  * Driver command data is immediately after the request. So subtract request
  * size to get back to the original request, add request size to get the PDU.
-- 
2.9.5
