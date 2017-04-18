From: Christoph Hellwig <hch@bombadil.infradead.org>
Subject: blk-mq: remove the error argument to blk_mq_complete_request
Date: Tue, 18 Apr 2017 08:52:21 -0700
Message-ID: <20170418155229.5977-16-hch@bombadil.infradead.org>
References: <20170418155229.5977-1-hch@bombadil.infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:54419 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757447AbdDRPws (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Apr 2017 11:52:48 -0400
In-Reply-To: <20170418155229.5977-1-hch@bombadil.infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <jbacik@fb.com>, James Smart <james.smart@broadcom.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>

From: Christoph Hellwig <hch@lst.de>

Now that we always have a ->complete callback we can remove the direct
call to blk_mq_end_request, as well as the error argument to
blk_mq_complete_request.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c                    | 15 +++------------
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
 12 files changed, 17 insertions(+), 26 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index e2ef7b460924..0c19df66f5a0 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -442,17 +442,10 @@ static void blk_mq_stat_add(struct request *rq)
 
 static void __blk_mq_complete_request(struct request *rq)
 {
-	struct request_queue *q = rq->q;
-
 	if (rq->internal_tag != -1)
 		blk_mq_sched_completed_request(rq);
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
@@ -463,16 +456,14 @@ static void __blk_mq_complete_request(struct request *rq)
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
index 86351b3f7350..994403efee19 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -465,7 +465,7 @@ static void lo_rw_aio_complete(struct kiocb *iocb, long ret, long ret2)
 	struct loop_cmd *cmd = container_of(iocb, struct loop_cmd, iocb);
 
 	cmd->ret = ret;
-	blk_mq_complete_request(cmd->rq, 0);
+	blk_mq_complete_request(cmd->rq);
 }
 
 static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
@@ -1685,7 +1685,7 @@ static void loop_handle_cmd(struct loop_cmd *cmd)
 	/* complete non-aio request */
 	if (!cmd->use_aio || ret) {
 		cmd->ret = ret ? -EIO : 0;
-		blk_mq_complete_request(cmd->rq, 0);
+		blk_mq_complete_request(cmd->rq);
 	}
 }
 
diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 7406de29db58..66a6bd83faae 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -242,7 +242,7 @@ static void mtip_async_complete(struct mtip_port *port,
 	rq = mtip_rq_from_tag(dd, tag);
 
 	cmd->status = status;
-	blk_mq_complete_request(rq, 0);
+	blk_mq_complete_request(rq);
 }
 
 /*
@@ -4109,7 +4109,7 @@ static void mtip_no_dev_cleanup(struct request *rq, void *data, bool reserv)
 
 	if (likely(!reserv)) {
 		cmd->status = -ENODEV;
-		blk_mq_complete_request(rq, 0);
+		blk_mq_complete_request(rq);
 	} else if (test_bit(MTIP_PF_IC_ACTIVE_BIT, &dd->port->flags)) {
 
 		cmd = mtip_cmd_from_tag(dd, MTIP_TAG_INTERNAL);
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 12ec881fd699..65341ed3fa11 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -635,7 +635,7 @@ static void recv_work(struct work_struct *work)
 			break;
 		}
 
-		blk_mq_complete_request(blk_mq_rq_from_pdu(cmd), 0);
+		blk_mq_complete_request(blk_mq_rq_from_pdu(cmd));
 	}
 	atomic_dec(&config->recv_threads);
 	wake_up(&config->recv_wq);
@@ -651,7 +651,7 @@ static void nbd_clear_req(struct request *req, void *data, bool reserved)
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
index 1173be21f6f6..bff7e3bdb4ed 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -363,7 +363,7 @@ static void dm_complete_request(struct request *rq, int error)
 	if (!rq->q->mq_ops)
 		blk_complete_request(rq);
 	else
-		blk_mq_complete_request(rq, 0);
+		blk_mq_complete_request(rq);
 }
 
 /*
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 805f250315ec..8dc664798293 100644
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
index 550037f5efea..c6ef6c30e2f0 100644
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
index 1c3fcb50fa4d..99749fc30adb 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1904,7 +1904,7 @@ static int scsi_mq_prep_fn(struct request *req)
 static void scsi_mq_done(struct scsi_cmnd *cmd)
 {
 	trace_scsi_dispatch_cmd_done(cmd);
-	blk_mq_complete_request(cmd->request, 0);
+	blk_mq_complete_request(cmd->request);
 }
 
 static int scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index d75de612845d..0c4dadb85f62 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -228,7 +228,7 @@ void blk_mq_add_to_requeue_list(struct request *rq, bool at_head,
 void blk_mq_kick_requeue_list(struct request_queue *q);
 void blk_mq_delay_kick_requeue_list(struct request_queue *q, unsigned long msecs);
 void blk_mq_abort_requeue_list(struct request_queue *q);
-void blk_mq_complete_request(struct request *rq, int error);
+void blk_mq_complete_request(struct request *rq);
 
 bool blk_mq_queue_stopped(struct request_queue *q);
 void blk_mq_stop_hw_queue(struct blk_mq_hw_ctx *hctx);
-- 
2.11.0
