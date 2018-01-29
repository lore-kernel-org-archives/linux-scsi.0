From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH V4] blk-mq: introduce BLK_STS_DEV_RESOURCE
Date: Mon, 29 Jan 2018 15:33:00 -0500
Message-ID: <20180129203300.50595-1-snitzer@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

This status is returned from driver to block layer if device related
resource is unavailable, but driver can guarantee that IO dispatch
will be triggered in future when the resource is available.

Convert some drivers to return BLK_STS_DEV_RESOURCE.  Also, if driver
returns BLK_STS_RESOURCE and SCHED_RESTART is set, rerun queue after
a delay (BLK_MQ_DELAY_QUEUE) to avoid IO stalls.  BLK_MQ_DELAY_QUEUE is
3 ms because both scsi-mq and nvmefc are using that magic value.

Suggested-by: Jens Axboe <axboe@kernel.dk>
Tested-by: Laurence Oberman <loberman@redhat.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---

V4:
        - cleanup header and code comments
        - rerun queue after BLK_MQ_QUEUE_DELAY (3ms) instead of 10ms
        - eliminate nvmefc's queue rerun now that blk-mq does it
V3:
        - fix typo, and improvement document
        - add tested-by tag
V2:
        - add comments on the new introduced status
        - patch style fix
        - both are suggested by Christoph

 block/blk-core.c             |  1 +
 block/blk-mq.c               | 20 ++++++++++++++++----
 drivers/block/null_blk.c     |  2 +-
 drivers/block/virtio_blk.c   |  2 +-
 drivers/block/xen-blkfront.c |  2 +-
 drivers/md/dm-rq.c           |  5 ++---
 drivers/nvme/host/fc.c       | 12 ++----------
 drivers/scsi/scsi_lib.c      |  6 +++---
 include/linux/blk_types.h    | 14 ++++++++++++++
 9 files changed, 41 insertions(+), 23 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index cdae69be68e9..38279d4ae08b 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -145,6 +145,7 @@ static const struct {
 	[BLK_STS_MEDIUM]	= { -ENODATA,	"critical medium" },
 	[BLK_STS_PROTECTION]	= { -EILSEQ,	"protection" },
 	[BLK_STS_RESOURCE]	= { -ENOMEM,	"kernel resource" },
+	[BLK_STS_DEV_RESOURCE]	= { -ENOMEM,	"device resource" },
 	[BLK_STS_AGAIN]		= { -EAGAIN,	"nonblocking retry" },
 
 	/* device mapper special case, should not leak out: */
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 43e7449723e0..dd097ca5f1e9 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1160,6 +1160,8 @@ static bool blk_mq_mark_tag_wait(struct blk_mq_hw_ctx **hctx,
 	return true;
 }
 
+#define BLK_MQ_QUEUE_DELAY	3		/* ms units */
+
 bool blk_mq_dispatch_rq_list(struct request_queue *q, struct list_head *list,
 			     bool got_budget)
 {
@@ -1167,6 +1169,7 @@ bool blk_mq_dispatch_rq_list(struct request_queue *q, struct list_head *list,
 	struct request *rq, *nxt;
 	bool no_tag = false;
 	int errors, queued;
+	blk_status_t ret = BLK_STS_OK;
 
 	if (list_empty(list))
 		return false;
@@ -1179,7 +1182,6 @@ bool blk_mq_dispatch_rq_list(struct request_queue *q, struct list_head *list,
 	errors = queued = 0;
 	do {
 		struct blk_mq_queue_data bd;
-		blk_status_t ret;
 
 		rq = list_first_entry(list, struct request, queuelist);
 		if (!blk_mq_get_driver_tag(rq, &hctx, false)) {
@@ -1224,7 +1226,7 @@ bool blk_mq_dispatch_rq_list(struct request_queue *q, struct list_head *list,
 		}
 
 		ret = q->mq_ops->queue_rq(hctx, &bd);
-		if (ret == BLK_STS_RESOURCE) {
+		if (ret == BLK_STS_RESOURCE || ret == BLK_STS_DEV_RESOURCE) {
 			/*
 			 * If an I/O scheduler has been configured and we got a
 			 * driver tag for the next request already, free it
@@ -1255,6 +1257,8 @@ bool blk_mq_dispatch_rq_list(struct request_queue *q, struct list_head *list,
 	 * that is where we will continue on next queue run.
 	 */
 	if (!list_empty(list)) {
+		bool needs_restart;
+
 		spin_lock(&hctx->lock);
 		list_splice_init(list, &hctx->dispatch);
 		spin_unlock(&hctx->lock);
@@ -1278,10 +1282,17 @@ bool blk_mq_dispatch_rq_list(struct request_queue *q, struct list_head *list,
 		 * - Some but not all block drivers stop a queue before
 		 *   returning BLK_STS_RESOURCE. Two exceptions are scsi-mq
 		 *   and dm-rq.
+		 *
+		 * If driver returns BLK_STS_RESOURCE and SCHED_RESTART
+		 * bit is set, run queue after 10ms to avoid IO stalls
+		 * that could otherwise occur if the queue is idle.
 		 */
-		if (!blk_mq_sched_needs_restart(hctx) ||
+		needs_restart = blk_mq_sched_needs_restart(hctx);
+		if (!needs_restart ||
 		    (no_tag && list_empty_careful(&hctx->dispatch_wait.entry)))
 			blk_mq_run_hw_queue(hctx, true);
+		else if (needs_restart && (ret == BLK_STS_RESOURCE))
+			blk_mq_delay_run_hw_queue(hctx, BLK_MQ_QUEUE_DELAY);
 	}
 
 	return (queued + errors) != 0;
@@ -1762,6 +1773,7 @@ static blk_status_t __blk_mq_issue_directly(struct blk_mq_hw_ctx *hctx,
 		*cookie = new_cookie;
 		break;
 	case BLK_STS_RESOURCE:
+	case BLK_STS_DEV_RESOURCE:
 		__blk_mq_requeue_request(rq);
 		break;
 	default:
@@ -1824,7 +1836,7 @@ static void blk_mq_try_issue_directly(struct blk_mq_hw_ctx *hctx,
 	hctx_lock(hctx, &srcu_idx);
 
 	ret = __blk_mq_try_issue_directly(hctx, rq, cookie, false);
-	if (ret == BLK_STS_RESOURCE)
+	if (ret == BLK_STS_RESOURCE || ret == BLK_STS_DEV_RESOURCE)
 		blk_mq_sched_insert_request(rq, false, true, false);
 	else if (ret != BLK_STS_OK)
 		blk_mq_end_request(rq, ret);
diff --git a/drivers/block/null_blk.c b/drivers/block/null_blk.c
index 5b94e530570c..4bc25fc4e73c 100644
--- a/drivers/block/null_blk.c
+++ b/drivers/block/null_blk.c
@@ -1230,7 +1230,7 @@ static blk_status_t null_handle_cmd(struct nullb_cmd *cmd)
 				return BLK_STS_OK;
 			} else
 				/* requeue request */
-				return BLK_STS_RESOURCE;
+				return BLK_STS_DEV_RESOURCE;
 		}
 	}
 
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 68846897d213..79908e6ddbf2 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -276,7 +276,7 @@ static blk_status_t virtio_queue_rq(struct blk_mq_hw_ctx *hctx,
 		/* Out of mem doesn't actually happen, since we fall back
 		 * to direct descriptors */
 		if (err == -ENOMEM || err == -ENOSPC)
-			return BLK_STS_RESOURCE;
+			return BLK_STS_DEV_RESOURCE;
 		return BLK_STS_IOERR;
 	}
 
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 891265acb10e..e126e4cac2ca 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -911,7 +911,7 @@ static blk_status_t blkif_queue_rq(struct blk_mq_hw_ctx *hctx,
 out_busy:
 	blk_mq_stop_hw_queue(hctx);
 	spin_unlock_irqrestore(&rinfo->ring_lock, flags);
-	return BLK_STS_RESOURCE;
+	return BLK_STS_DEV_RESOURCE;
 }
 
 static void blkif_complete_rq(struct request *rq)
diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index b7d175e94a02..348a0cb6963a 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -404,7 +404,7 @@ static blk_status_t dm_dispatch_clone_request(struct request *clone, struct requ
 
 	clone->start_time = jiffies;
 	r = blk_insert_cloned_request(clone->q, clone);
-	if (r != BLK_STS_OK && r != BLK_STS_RESOURCE)
+	if (r != BLK_STS_OK && r != BLK_STS_RESOURCE && r != BLK_STS_DEV_RESOURCE)
 		/* must complete clone in terms of original request */
 		dm_complete_request(rq, r);
 	return r;
@@ -496,7 +496,7 @@ static int map_request(struct dm_rq_target_io *tio)
 		trace_block_rq_remap(clone->q, clone, disk_devt(dm_disk(md)),
 				     blk_rq_pos(rq));
 		ret = dm_dispatch_clone_request(clone, rq);
-		if (ret == BLK_STS_RESOURCE) {
+		if (ret == BLK_STS_RESOURCE || ret == BLK_STS_DEV_RESOURCE) {
 			blk_rq_unprep_clone(clone);
 			tio->ti->type->release_clone_rq(clone);
 			tio->clone = NULL;
@@ -769,7 +769,6 @@ static blk_status_t dm_mq_queue_rq(struct blk_mq_hw_ctx *hctx,
 		/* Undo dm_start_request() before requeuing */
 		rq_end_stats(md, rq);
 		rq_completed(md, rq_data_dir(rq), false);
-		blk_mq_delay_run_hw_queue(hctx, 100/*ms*/);
 		return BLK_STS_RESOURCE;
 	}
 
diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index b76ba4629e02..54e679541ad6 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -35,8 +35,6 @@ enum nvme_fc_queue_flags {
 	NVME_FC_Q_LIVE,
 };
 
-#define NVMEFC_QUEUE_DELAY	3		/* ms units */
-
 #define NVME_FC_DEFAULT_DEV_LOSS_TMO	60	/* seconds */
 
 struct nvme_fc_queue {
@@ -2231,7 +2229,7 @@ nvme_fc_start_fcp_op(struct nvme_fc_ctrl *ctrl, struct nvme_fc_queue *queue,
 	 * the target device is present
 	 */
 	if (ctrl->rport->remoteport.port_state != FC_OBJSTATE_ONLINE)
-		goto busy;
+		return BLK_STS_RESOURCE;
 
 	if (!nvme_fc_ctrl_get(ctrl))
 		return BLK_STS_IOERR;
@@ -2311,16 +2309,10 @@ nvme_fc_start_fcp_op(struct nvme_fc_ctrl *ctrl, struct nvme_fc_queue *queue,
 				ret != -EBUSY)
 			return BLK_STS_IOERR;
 
-		goto busy;
+		return BLK_STS_RESOURCE;
 	}
 
 	return BLK_STS_OK;
-
-busy:
-	if (!(op->flags & FCOP_FLAGS_AEN) && queue->hctx)
-		blk_mq_delay_run_hw_queue(queue->hctx, NVMEFC_QUEUE_DELAY);
-
-	return BLK_STS_RESOURCE;
 }
 
 static inline blk_status_t nvme_fc_is_ready(struct nvme_fc_queue *queue,
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index d9ca1dfab154..55be2550c555 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2030,9 +2030,9 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 	case BLK_STS_OK:
 		break;
 	case BLK_STS_RESOURCE:
-		if (atomic_read(&sdev->device_busy) == 0 &&
-		    !scsi_device_blocked(sdev))
-			blk_mq_delay_run_hw_queue(hctx, SCSI_QUEUE_DELAY);
+		if (atomic_read(&sdev->device_busy) ||
+		    scsi_device_blocked(sdev))
+			ret = BLK_STS_DEV_RESOURCE;
 		break;
 	default:
 		/*
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 2d973ac54b09..6a8ad60e7f09 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -39,6 +39,20 @@ typedef u8 __bitwise blk_status_t;
 
 #define BLK_STS_AGAIN		((__force blk_status_t)12)
 
+/*
+ * BLK_STS_DEV_RESOURCE is returned from driver to block layer if device
+ * related resource is unavailable, but driver can guarantee that queue
+ * will be rerun in future once the resource is available (whereby
+ * dispatching requests).
+ *
+ * Difference with BLK_STS_RESOURCE:
+ * If driver isn't sure if the queue will be rerun once device resource
+ * is made available, please return BLK_STS_RESOURCE.  For example: when
+ * memory allocation, DMA Mapping or other system resource allocation
+ * fails and IO can't be submitted to device.
+ */
+#define BLK_STS_DEV_RESOURCE	((__force blk_status_t)13)
+
 /**
  * blk_path_error - returns true if error may be path related
  * @error: status the request was completed with
-- 
2.15.0
