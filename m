From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH v8 10/10] block, nvme: Introduce blk_mq_req_flags_t
Date: Tue, 10 Oct 2017 14:03:46 -0700
Message-ID: <20171010210346.14574-11-bart.vanassche@wdc.com>
References: <20171010210346.14574-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:10106 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932985AbdJJVDv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Oct 2017 17:03:51 -0400
In-Reply-To: <20171010210346.14574-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, Ming Lei <ming.lei@redhat.com>, Bart Van Assche <bart.vanassche@wdc.com>, linux-nvme@lists.infradead.org, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>

Several block layer and NVMe core functions accept a combination
of BLK_MQ_REQ_* flags through the 'flags' argument but there is
no verification at compile time whether the right type of block
layer flags is passed. Make it possible for sparse to verify this.
This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: linux-nvme@lists.infradead.org
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Ming Lei <ming.lei@redhat.com>
---
 block/blk-core.c          | 12 ++++++------
 block/blk-mq.c            |  4 ++--
 block/blk-mq.h            |  2 +-
 drivers/nvme/host/core.c  |  5 +++--
 drivers/nvme/host/nvme.h  |  5 +++--
 include/linux/blk-mq.h    | 17 +++++++++++------
 include/linux/blk_types.h |  2 ++
 include/linux/blkdev.h    |  4 ++--
 8 files changed, 30 insertions(+), 21 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 3847ea42e341..3bd4d42cee80 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -799,7 +799,7 @@ EXPORT_SYMBOL(blk_alloc_queue);
  * @q: request queue pointer
  * @flags: BLK_MQ_REQ_NOWAIT and/or BLK_MQ_REQ_PREEMPT
  */
-int blk_queue_enter(struct request_queue *q, unsigned int flags)
+int blk_queue_enter(struct request_queue *q, blk_mq_req_flags_t flags)
 {
 	const bool preempt = flags & BLK_MQ_REQ_PREEMPT;
 
@@ -1224,7 +1224,7 @@ int blk_update_nr_requests(struct request_queue *q, unsigned int nr)
  * Returns request pointer on success, with @q->queue_lock *not held*.
  */
 static struct request *__get_request(struct request_list *rl, unsigned int op,
-				     struct bio *bio, unsigned int flags)
+				     struct bio *bio, blk_mq_req_flags_t flags)
 {
 	struct request_queue *q = rl->q;
 	struct request *rq;
@@ -1407,7 +1407,7 @@ static struct request *__get_request(struct request_list *rl, unsigned int op,
  * Returns request pointer on success, with @q->queue_lock *not held*.
  */
 static struct request *get_request(struct request_queue *q, unsigned int op,
-				   struct bio *bio, unsigned int flags)
+				   struct bio *bio, blk_mq_req_flags_t flags)
 {
 	const bool is_sync = op_is_sync(op);
 	DEFINE_WAIT(wait);
@@ -1457,7 +1457,7 @@ static struct request *get_request(struct request_queue *q, unsigned int op,
 
 /* flags: BLK_MQ_REQ_PREEMPT and/or BLK_MQ_REQ_NOWAIT. */
 static struct request *blk_old_get_request(struct request_queue *q,
-					   unsigned int op, unsigned int flags)
+				unsigned int op, blk_mq_req_flags_t flags)
 {
 	struct request *rq;
 	gfp_t gfp_mask = flags & BLK_MQ_REQ_NOWAIT ? GFP_ATOMIC :
@@ -1494,7 +1494,7 @@ static struct request *blk_old_get_request(struct request_queue *q,
  * @flags: BLK_MQ_REQ_* flags, e.g. BLK_MQ_REQ_NOWAIT.
  */
 struct request *blk_get_request_flags(struct request_queue *q, unsigned int op,
-				      unsigned int flags)
+				      blk_mq_req_flags_t flags)
 {
 	struct request *req;
 
@@ -2290,7 +2290,7 @@ blk_qc_t generic_make_request(struct bio *bio)
 	current->bio_list = bio_list_on_stack;
 	do {
 		struct request_queue *q = bio->bi_disk->queue;
-		unsigned int flags = bio->bi_opf & REQ_NOWAIT ?
+		blk_mq_req_flags_t flags = bio->bi_opf & REQ_NOWAIT ?
 			BLK_MQ_REQ_NOWAIT : 0;
 
 		if (likely(blk_queue_enter(q, flags) == 0)) {
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 44a06e8541f2..8fa03e3f97ca 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -380,7 +380,7 @@ static struct request *blk_mq_get_request(struct request_queue *q,
 }
 
 struct request *blk_mq_alloc_request(struct request_queue *q, unsigned int op,
-		unsigned int flags)
+		blk_mq_req_flags_t flags)
 {
 	struct blk_mq_alloc_data alloc_data = { .flags = flags };
 	struct request *rq;
@@ -406,7 +406,7 @@ struct request *blk_mq_alloc_request(struct request_queue *q, unsigned int op,
 EXPORT_SYMBOL(blk_mq_alloc_request);
 
 struct request *blk_mq_alloc_request_hctx(struct request_queue *q,
-		unsigned int op, unsigned int flags, unsigned int hctx_idx)
+	unsigned int op, blk_mq_req_flags_t flags, unsigned int hctx_idx)
 {
 	struct blk_mq_alloc_data alloc_data = { .flags = flags };
 	struct request *rq;
diff --git a/block/blk-mq.h b/block/blk-mq.h
index ef15b3414da5..1f0f7bb3c7e4 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -108,7 +108,7 @@ static inline void blk_mq_put_ctx(struct blk_mq_ctx *ctx)
 struct blk_mq_alloc_data {
 	/* input parameter */
 	struct request_queue *q;
-	unsigned int flags;
+	blk_mq_req_flags_t flags;
 	unsigned int shallow_depth;
 
 	/* input & output parameter */
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index bb2aad078637..01947cd82b5a 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -292,7 +292,7 @@ static struct nvme_ns *nvme_get_ns_from_disk(struct gendisk *disk)
 }
 
 struct request *nvme_alloc_request(struct request_queue *q,
-		struct nvme_command *cmd, unsigned int flags, int qid)
+		struct nvme_command *cmd, blk_mq_req_flags_t flags, int qid)
 {
 	unsigned op = nvme_is_write(cmd) ? REQ_OP_DRV_OUT : REQ_OP_DRV_IN;
 	struct request *req;
@@ -560,7 +560,8 @@ EXPORT_SYMBOL_GPL(nvme_setup_cmd);
  */
 int __nvme_submit_sync_cmd(struct request_queue *q, struct nvme_command *cmd,
 		union nvme_result *result, void *buffer, unsigned bufflen,
-		unsigned timeout, int qid, int at_head, int flags)
+		unsigned timeout, int qid, int at_head,
+		blk_mq_req_flags_t flags)
 {
 	struct request *req;
 	int ret;
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index d3f3c4447515..61b25e8c222c 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -314,14 +314,15 @@ void nvme_start_freeze(struct nvme_ctrl *ctrl);
 
 #define NVME_QID_ANY -1
 struct request *nvme_alloc_request(struct request_queue *q,
-		struct nvme_command *cmd, unsigned int flags, int qid);
+		struct nvme_command *cmd, blk_mq_req_flags_t flags, int qid);
 blk_status_t nvme_setup_cmd(struct nvme_ns *ns, struct request *req,
 		struct nvme_command *cmd);
 int nvme_submit_sync_cmd(struct request_queue *q, struct nvme_command *cmd,
 		void *buf, unsigned bufflen);
 int __nvme_submit_sync_cmd(struct request_queue *q, struct nvme_command *cmd,
 		union nvme_result *result, void *buffer, unsigned bufflen,
-		unsigned timeout, int qid, int at_head, int flags);
+		unsigned timeout, int qid, int at_head,
+		blk_mq_req_flags_t flags);
 int nvme_set_queue_count(struct nvme_ctrl *ctrl, int *count);
 void nvme_start_keep_alive(struct nvme_ctrl *ctrl);
 void nvme_stop_keep_alive(struct nvme_ctrl *ctrl);
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index ee9fc3fb7fca..80505e5b9684 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -197,16 +197,21 @@ void blk_mq_free_request(struct request *rq);
 bool blk_mq_can_queue(struct blk_mq_hw_ctx *);
 
 enum {
-	BLK_MQ_REQ_NOWAIT	= (1 << 0), /* return when out of requests */
-	BLK_MQ_REQ_RESERVED	= (1 << 1), /* allocate from reserved pool */
-	BLK_MQ_REQ_INTERNAL	= (1 << 2), /* allocate internal/sched tag */
-	BLK_MQ_REQ_PREEMPT	= (1 << 3), /* set RQF_PREEMPT */
+	/* return when out of requests */
+	BLK_MQ_REQ_NOWAIT	= (__force blk_mq_req_flags_t)(1 << 0),
+	/* allocate from reserved pool */
+	BLK_MQ_REQ_RESERVED	= (__force blk_mq_req_flags_t)(1 << 1),
+	/* allocate internal/sched tag */
+	BLK_MQ_REQ_INTERNAL	= (__force blk_mq_req_flags_t)(1 << 2),
+	/* set RQF_PREEMPT */
+	BLK_MQ_REQ_PREEMPT	= (__force blk_mq_req_flags_t)(1 << 3),
 };
 
 struct request *blk_mq_alloc_request(struct request_queue *q, unsigned int op,
-		unsigned int flags);
+		blk_mq_req_flags_t flags);
 struct request *blk_mq_alloc_request_hctx(struct request_queue *q,
-		unsigned int op, unsigned int flags, unsigned int hctx_idx);
+		unsigned int op, blk_mq_req_flags_t flags,
+		unsigned int hctx_idx);
 struct request *blk_mq_tag_to_rq(struct blk_mq_tags *tags, unsigned int tag);
 
 enum {
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index a2d2aa709cef..03325d576cab 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -162,6 +162,8 @@ struct bio {
  */
 #define BIO_RESET_BITS	BVEC_POOL_OFFSET
 
+typedef __u32 __bitwise blk_mq_req_flags_t;
+
 /*
  * Operations and flags common to the bio and request structures.
  * We use 8 bits for encoding the operation, and the remaining 24 for flags.
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 0a4638cf0687..d1b7e18ce1c6 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -943,7 +943,7 @@ extern void blk_put_request(struct request *);
 extern void __blk_put_request(struct request_queue *, struct request *);
 extern struct request *blk_get_request_flags(struct request_queue *,
 					     unsigned int op,
-					     unsigned int flags);
+					     blk_mq_req_flags_t flags);
 extern struct request *blk_get_request(struct request_queue *, unsigned int op,
 				       gfp_t gfp_mask);
 extern void blk_requeue_request(struct request_queue *, struct request *);
@@ -967,7 +967,7 @@ extern int scsi_cmd_ioctl(struct request_queue *, struct gendisk *, fmode_t,
 extern int sg_scsi_ioctl(struct request_queue *, struct gendisk *, fmode_t,
 			 struct scsi_ioctl_command __user *);
 
-extern int blk_queue_enter(struct request_queue *q, unsigned int flags);
+extern int blk_queue_enter(struct request_queue *q, blk_mq_req_flags_t flags);
 extern void blk_queue_exit(struct request_queue *q);
 extern void blk_start_queue(struct request_queue *q);
 extern void blk_start_queue_async(struct request_queue *q);
-- 
2.14.2
