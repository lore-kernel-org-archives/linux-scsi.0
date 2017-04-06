From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 17/25] blk-mq: remove the error argument to blk_mq_complete_request
Date: Thu,  6 Apr 2017 17:39:36 +0200
Message-ID: <20170406153944.10058-18-hch@lst.de>
References: <20170406153944.10058-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170406153944.10058-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <jbacik@fb.com>, James Smart <james.smart@broadcom.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

Now that we always have a ->complete callback we can remove the direct
call to blk_mq_end_request, as well as the error argument to
blk_mq_complete_request.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c                    | 14 +++-----------
 drivers/block/loop.c              |  4 ++--
 drivers/block/mtip32xx/mtip32xx.c |  4 ++--
 drivers/block/nbd.c               |  4 ++--
 drivers/block/null_blk.c          |  2 +-
 drivers/block/virtio_blk.c        |  2 +-
 drivers/block/xen-blkfront.c      |  2 +-
 drivers/md/dm-rq.c                |  2 +-
 drivers/nvme/host/core.c          |  2 +-
 drivers/nvme/host/nvme.h          |  2 +-
 drivers/scsi/scsi_lib.c           |  2 +-
 include/linux/blk-mq.h            |  2 +-
 12 files changed, 17 insertions(+), 25 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index f7cd3208bcdf..393f350ebb90 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -441,14 +441,8 @@ static void blk_mq_stat_add(struct request *rq)
 
 static void __blk_mq_complete_request(struct request *rq)
 {
-	struct request_queue *q = rq->q;
-
 	blk_mq_stat_add(rq);
-
-	if (!q->softirq_done_fn)
-		blk_mq_end_request(rq, rq->errors);
-	else
-		blk_mq_ipi_complete_request(rq);
+	blk_mq_ipi_complete_request(rq);
 }
 
 /**
@@ -459,16 +453,14 @@ static void __blk_mq_complete_request(struct request *rq)
  *	Ends all I/O on a request. It does not handle partial completions.
  *	The actual completion happens out-of-order, through a IPI handler.
  **/
-void blk_mq_complete_request(struct request *rq, int error)
+void blk_mq_complete_request(struct request *rq)
 {
 	struct request_queue *q = rq->q;
 
 	if (unlikely(blk_should_fake_timeout(q)))
 		return;
-	if (!blk_mark_rq_complete(rq)) {
-		rq->errors = error;
+	if (!blk_mark_rq_complete(rq))
 		__blk_mq_complete_request(rq);
-	}
 }
 EXPORT_SYMBOL(blk_mq_complete_request);
 
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 6924ec611a49..7d49d919543a 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -465,7 +465,7 @@ static void lo_rw_aio_complete(struct kiocb *iocb, long ret, long ret2)
 	struct loop_cmd *cmd = container_of(iocb, struct loop_cmd, iocb);
 
 	cmd->ret = ret;
-	blk_mq_complete_request(cmd->rq, 0);
+	blk_mq_complete_request(cmd->rq);
 }
 
 static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
@@ -1683,7 +1683,7 @@ static void loop_handle_cmd(struct loop_cmd *cmd)
 	/* complete non-aio request */
 	if (!cmd->use_aio || ret) {
 		cmd->ret = ret ? -EIO : 0;
-		blk_mq_complete_request(cmd->rq, 0);
+		blk_mq_complete_request(cmd->rq);
 	}
 }
 
diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index ec998e80cfaf..be6bbe5ce613 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -242,7 +242,7 @@ static void mtip_async_complete(struct mtip_port *port,
 	rq = mtip_rq_from_tag(dd, tag);
 
 	cmd->status = status;
-	blk_mq_complete_request(rq, 0);
+	blk_mq_complete_request(rq);
 }
 
 /*
@@ -4110,7 +4110,7 @@ static void mtip_no_dev_cleanup(struct request *rq, void *data, bool reserv)
 
 	if (likely(!reserv)) {
 		cmd->status = -ENODEV;
-		blk_mq_complete_request(rq, 0);
+		blk_mq_complete_request(rq);
 	} else if (test_bit(MTIP_PF_IC_ACTIVE_BIT, &dd->port->flags)) {
 
 		cmd = mtip_cmd_from_tag(dd, MTIP_TAG_INTERNAL);
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 4f045fab9659..4f78c5a01d11 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -498,7 +498,7 @@ static void recv_work(struct work_struct *work)
 			break;
 		}
 
-		blk_mq_complete_request(blk_mq_rq_from_pdu(cmd), 0);
+		blk_mq_complete_request(blk_mq_rq_from_pdu(cmd));
 	}
 
 	/*
@@ -519,7 +519,7 @@ static void nbd_clear_req(struct request *req, void *data, bool reserved)
 		return;
 	cmd = blk_mq_rq_to_pdu(req);
 	cmd->status = -EIO;
-	blk_mq_complete_request(req, 0);
+	blk_mq_complete_request(req);
 }
 
 static void nbd_clear_que(struct nbd_device *nbd)
diff --git a/drivers/block/null_blk.c b/drivers/block/null_blk.c
index 24ca85a70fd8..c27cccec368b 100644
--- a/drivers/block/null_blk.c
+++ b/drivers/block/null_blk.c
@@ -281,7 +281,7 @@ static inline void null_handle_cmd(struct nullb_cmd *cmd)
 	case NULL_IRQ_SOFTIRQ:
 		switch (queue_mode)  {
 		case NULL_Q_MQ:
-			blk_mq_complete_request(cmd->rq, 0);
+			blk_mq_complete_request(cmd->rq);
 			break;
 		case NULL_Q_RQ:
 			blk_complete_request(cmd->rq);
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index dea2a58d6734..f94614257462 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -201,7 +201,7 @@ static void virtblk_done(struct virtqueue *vq)
 		while ((vbr = virtqueue_get_buf(vblk->vqs[qid].vq, &len)) != NULL) {
 			struct request *req = blk_mq_rq_from_pdu(vbr);
 
-			blk_mq_complete_request(req, 0);
+			blk_mq_complete_request(req);
 			req_done = true;
 		}
 		if (unlikely(virtqueue_is_broken(vq)))
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 08172f679a64..ae47f7f7cd10 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -1647,7 +1647,7 @@ static irqreturn_t blkif_interrupt(int irq, void *dev_id)
 			BUG();
 		}
 
-		blk_mq_complete_request(req, 0);
+		blk_mq_complete_request(req);
 	}
 
 	rinfo->ring.rsp_cons = i;
diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index e1cea42ec2a6..18d0bb305930 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -358,7 +358,7 @@ static void dm_complete_request(struct request *rq, int error)
 	if (!rq->q->mq_ops)
 		blk_complete_request(rq);
 	else
-		blk_mq_complete_request(rq, 0);
+		blk_mq_complete_request(rq);
 }
 
 /*
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index fbc7d64b6f10..9bf758e3c911 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -117,7 +117,7 @@ void nvme_cancel_request(struct request *req, void *data, bool reserved)
 	if (blk_queue_dying(req->q))
 		status |= NVME_SC_DNR;
 	nvme_req(req)->status = status;
-	blk_mq_complete_request(req, 0);
+	blk_mq_complete_request(req);
 
 }
 EXPORT_SYMBOL_GPL(nvme_cancel_request);
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 4dc930d3545d..72dc98f6a6c6 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -251,7 +251,7 @@ static inline void nvme_end_request(struct request *req, __le16 status,
 
 	rq->status = le16_to_cpu(status) >> 1;
 	rq->result = result;
-	blk_mq_complete_request(req, 0);
+	blk_mq_complete_request(req);
 }
 
 void nvme_complete_rq(struct request *req);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 8c7652f04900..2e84515674bb 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1887,7 +1887,7 @@ static int scsi_mq_prep_fn(struct request *req)
 static void scsi_mq_done(struct scsi_cmnd *cmd)
 {
 	trace_scsi_dispatch_cmd_done(cmd);
-	blk_mq_complete_request(cmd->request, 0);
+	blk_mq_complete_request(cmd->request);
 }
 
 static int scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index bdea90d75274..05c551e22eec 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -227,7 +227,7 @@ void blk_mq_add_to_requeue_list(struct request *rq, bool at_head,
 void blk_mq_kick_requeue_list(struct request_queue *q);
 void blk_mq_delay_kick_requeue_list(struct request_queue *q, unsigned long msecs);
 void blk_mq_abort_requeue_list(struct request_queue *q);
-void blk_mq_complete_request(struct request *rq, int error);
+void blk_mq_complete_request(struct request *rq);
 
 bool blk_mq_queue_stopped(struct request_queue *q);
 void blk_mq_stop_hw_queue(struct blk_mq_hw_ctx *hctx);
-- 
2.11.0
