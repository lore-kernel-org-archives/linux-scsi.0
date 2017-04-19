From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 15/23] xen-blkfront: don't use req->errors
Date: Wed, 19 Apr 2017 21:27:00 +0200
Message-ID: <20170419192708.22098-16-hch@lst.de>
References: <20170419192708.22098-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170419192708.22098-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <jbacik@fb.com>, James Smart <james.smart@broadcom.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

xen-blkfron is the last users using rq->errros for passing back error to
blk-mq, and I'd like to get rid of that.  In the longer run the driver
should be moving more of the completion processing into .complete, but
this is the minimal change to move forward for now.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Roger Pau Monné <roger.pau@citrix.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/block/xen-blkfront.c | 36 +++++++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 11 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index abed296ce605..57866355c060 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -115,6 +115,15 @@ struct split_bio {
 	atomic_t pending;
 };
 
+struct blkif_req {
+	int	error;
+};
+
+static inline struct blkif_req *blkif_req(struct request *rq)
+{
+	return blk_mq_rq_to_pdu(rq);
+}
+
 static DEFINE_MUTEX(blkfront_mutex);
 static const struct block_device_operations xlvbd_block_fops;
 
@@ -907,8 +916,14 @@ static int blkif_queue_rq(struct blk_mq_hw_ctx *hctx,
 	return BLK_MQ_RQ_QUEUE_BUSY;
 }
 
+static void blkif_complete_rq(struct request *rq)
+{
+	blk_mq_end_request(rq, blkif_req(rq)->error);
+}
+
 static const struct blk_mq_ops blkfront_mq_ops = {
 	.queue_rq = blkif_queue_rq,
+	.complete = blkif_complete_rq,
 };
 
 static void blkif_set_queue_limits(struct blkfront_info *info)
@@ -969,7 +984,7 @@ static int xlvbd_init_blk_queue(struct gendisk *gd, u16 sector_size,
 		info->tag_set.queue_depth = BLK_RING_SIZE(info);
 	info->tag_set.numa_node = NUMA_NO_NODE;
 	info->tag_set.flags = BLK_MQ_F_SHOULD_MERGE | BLK_MQ_F_SG_MERGE;
-	info->tag_set.cmd_size = 0;
+	info->tag_set.cmd_size = sizeof(struct blkif_req);
 	info->tag_set.driver_data = info;
 
 	if (blk_mq_alloc_tag_set(&info->tag_set))
@@ -1543,7 +1558,6 @@ static irqreturn_t blkif_interrupt(int irq, void *dev_id)
 	unsigned long flags;
 	struct blkfront_ring_info *rinfo = (struct blkfront_ring_info *)dev_id;
 	struct blkfront_info *info = rinfo->dev_info;
-	int error;
 
 	if (unlikely(info->connected != BLKIF_STATE_CONNECTED))
 		return IRQ_HANDLED;
@@ -1587,37 +1601,36 @@ static irqreturn_t blkif_interrupt(int irq, void *dev_id)
 			continue;
 		}
 
-		error = (bret->status == BLKIF_RSP_OKAY) ? 0 : -EIO;
+		blkif_req(req)->error = (bret->status == BLKIF_RSP_OKAY) ? 0 : -EIO;
 		switch (bret->operation) {
 		case BLKIF_OP_DISCARD:
 			if (unlikely(bret->status == BLKIF_RSP_EOPNOTSUPP)) {
 				struct request_queue *rq = info->rq;
 				printk(KERN_WARNING "blkfront: %s: %s op failed\n",
 					   info->gd->disk_name, op_name(bret->operation));
-				error = -EOPNOTSUPP;
+				blkif_req(req)->error = -EOPNOTSUPP;
 				info->feature_discard = 0;
 				info->feature_secdiscard = 0;
 				queue_flag_clear(QUEUE_FLAG_DISCARD, rq);
 				queue_flag_clear(QUEUE_FLAG_SECERASE, rq);
 			}
-			blk_mq_complete_request(req, error);
 			break;
 		case BLKIF_OP_FLUSH_DISKCACHE:
 		case BLKIF_OP_WRITE_BARRIER:
 			if (unlikely(bret->status == BLKIF_RSP_EOPNOTSUPP)) {
 				printk(KERN_WARNING "blkfront: %s: %s op failed\n",
 				       info->gd->disk_name, op_name(bret->operation));
-				error = -EOPNOTSUPP;
+				blkif_req(req)->error = -EOPNOTSUPP;
 			}
 			if (unlikely(bret->status == BLKIF_RSP_ERROR &&
 				     rinfo->shadow[id].req.u.rw.nr_segments == 0)) {
 				printk(KERN_WARNING "blkfront: %s: empty %s op failed\n",
 				       info->gd->disk_name, op_name(bret->operation));
-				error = -EOPNOTSUPP;
+				blkif_req(req)->error = -EOPNOTSUPP;
 			}
-			if (unlikely(error)) {
-				if (error == -EOPNOTSUPP)
-					error = 0;
+			if (unlikely(blkif_req(req)->error)) {
+				if (blkif_req(req)->error == -EOPNOTSUPP)
+					blkif_req(req)->error = 0;
 				info->feature_fua = 0;
 				info->feature_flush = 0;
 				xlvbd_flush(info);
@@ -1629,11 +1642,12 @@ static irqreturn_t blkif_interrupt(int irq, void *dev_id)
 				dev_dbg(&info->xbdev->dev, "Bad return from blkdev data "
 					"request: %x\n", bret->status);
 
-			blk_mq_complete_request(req, error);
 			break;
 		default:
 			BUG();
 		}
+
+		blk_mq_complete_request(req, 0);
 	}
 
 	rinfo->ring.rsp_cons = i;
-- 
2.11.0
