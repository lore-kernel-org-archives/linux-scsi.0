From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/8] bsg: refactor bsg_ioctl
Date: Sun, 11 Nov 2018 14:32:08 +0100
Message-ID: <20181111133211.13926-6-hch@lst.de>
References: <20181111133211.13926-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181111133211.13926-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, martin.petersen@oracle.com, ooo@electrozaur.com
Cc: Johannes Thumshirn <jthumshirn@suse.de>, Benjamin Block <bblock@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Move all actual functionality into helpers, just leaving the dispatch
in this function.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bsg.c | 158 ++++++++++++++++++++++++----------------------------
 1 file changed, 72 insertions(+), 86 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index 9a442c23a715..8bf3af9543d0 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -138,32 +138,35 @@ static const struct bsg_ops bsg_scsi_ops = {
 	.free_rq		= bsg_scsi_free_rq,
 };
 
-static struct request *
-bsg_map_hdr(struct request_queue *q, struct sg_io_v4 *hdr, fmode_t mode)
+static int bsg_sg_io(struct request_queue *q, fmode_t mode, void __user *uarg)
 {
 	struct request *rq, *next_rq = NULL;
+	struct bio *bio, *bidi_bio = NULL;
+	struct sg_io_v4 hdr;
 	int ret;
 
-	if (!q->bsg_dev.class_dev)
-		return ERR_PTR(-ENXIO);
+	if (copy_from_user(&hdr, uarg, sizeof(hdr)))
+		return -EFAULT;
 
-	if (hdr->guard != 'Q')
-		return ERR_PTR(-EINVAL);
+	if (!q->bsg_dev.class_dev)
+		return -ENXIO;
 
-	ret = q->bsg_dev.ops->check_proto(hdr);
+	if (hdr.guard != 'Q')
+		return -EINVAL;
+	ret = q->bsg_dev.ops->check_proto(&hdr);
 	if (ret)
-		return ERR_PTR(ret);
+		return ret;
 
-	rq = blk_get_request(q, hdr->dout_xfer_len ?
+	rq = blk_get_request(q, hdr.dout_xfer_len ?
 			REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN, 0);
 	if (IS_ERR(rq))
-		return rq;
+		return PTR_ERR(rq);
 
-	ret = q->bsg_dev.ops->fill_hdr(rq, hdr, mode);
+	ret = q->bsg_dev.ops->fill_hdr(rq, &hdr, mode);
 	if (ret)
 		goto out;
 
-	rq->timeout = msecs_to_jiffies(hdr->timeout);
+	rq->timeout = msecs_to_jiffies(hdr.timeout);
 	if (!rq->timeout)
 		rq->timeout = q->sg_timeout;
 	if (!rq->timeout)
@@ -171,7 +174,7 @@ bsg_map_hdr(struct request_queue *q, struct sg_io_v4 *hdr, fmode_t mode)
 	if (rq->timeout < BLK_MIN_SG_TIMEOUT)
 		rq->timeout = BLK_MIN_SG_TIMEOUT;
 
-	if (hdr->dout_xfer_len && hdr->din_xfer_len) {
+	if (hdr.dout_xfer_len && hdr.din_xfer_len) {
 		if (!test_bit(QUEUE_FLAG_BIDI, &q->queue_flags)) {
 			ret = -EOPNOTSUPP;
 			goto out;
@@ -184,42 +187,29 @@ bsg_map_hdr(struct request_queue *q, struct sg_io_v4 *hdr, fmode_t mode)
 		}
 
 		rq->next_rq = next_rq;
-		ret = blk_rq_map_user(q, next_rq, NULL, uptr64(hdr->din_xferp),
-				       hdr->din_xfer_len, GFP_KERNEL);
+		ret = blk_rq_map_user(q, next_rq, NULL, uptr64(hdr.din_xferp),
+				       hdr.din_xfer_len, GFP_KERNEL);
 		if (ret)
 			goto out_free_nextrq;
 	}
 
-	if (hdr->dout_xfer_len) {
-		ret = blk_rq_map_user(q, rq, NULL, uptr64(hdr->dout_xferp),
-				hdr->dout_xfer_len, GFP_KERNEL);
-	} else if (hdr->din_xfer_len) {
-		ret = blk_rq_map_user(q, rq, NULL, uptr64(hdr->din_xferp),
-				hdr->din_xfer_len, GFP_KERNEL);
+	if (hdr.dout_xfer_len) {
+		ret = blk_rq_map_user(q, rq, NULL, uptr64(hdr.dout_xferp),
+				hdr.dout_xfer_len, GFP_KERNEL);
+	} else if (hdr.din_xfer_len) {
+		ret = blk_rq_map_user(q, rq, NULL, uptr64(hdr.din_xferp),
+				hdr.din_xfer_len, GFP_KERNEL);
 	}
 
 	if (ret)
 		goto out_unmap_nextrq;
-	return rq;
 
-out_unmap_nextrq:
+	bio = rq->bio;
 	if (rq->next_rq)
-		blk_rq_unmap_user(rq->next_rq->bio);
-out_free_nextrq:
-	if (rq->next_rq)
-		blk_put_request(rq->next_rq);
-out:
-	q->bsg_dev.ops->free_rq(rq);
-	blk_put_request(rq);
-	return ERR_PTR(ret);
-}
-
-static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
-				    struct bio *bio, struct bio *bidi_bio)
-{
-	int ret;
+		bidi_bio = rq->next_rq->bio;
 
-	ret = rq->q->bsg_dev.ops->complete_rq(rq, hdr);
+	blk_execute_rq(q, NULL, rq, !(hdr.flags & BSG_FLAG_Q_AT_TAIL));
+	ret = rq->q->bsg_dev.ops->complete_rq(rq, &hdr);
 
 	if (rq->next_rq) {
 		blk_rq_unmap_user(bidi_bio);
@@ -229,6 +219,20 @@ static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
 	blk_rq_unmap_user(bio);
 	rq->q->bsg_dev.ops->free_rq(rq);
 	blk_put_request(rq);
+
+	if (copy_to_user(uarg, &hdr, sizeof(hdr)))
+		return -EFAULT;
+	return ret;
+
+out_unmap_nextrq:
+	if (rq->next_rq)
+		blk_rq_unmap_user(rq->next_rq->bio);
+out_free_nextrq:
+	if (rq->next_rq)
+		blk_put_request(rq->next_rq);
+out:
+	q->bsg_dev.ops->free_rq(rq);
+	blk_put_request(rq);
 	return ret;
 }
 
@@ -363,31 +367,39 @@ static int bsg_release(struct inode *inode, struct file *file)
 	return bsg_put_device(bd);
 }
 
+static int bsg_get_command_q(struct bsg_device *bd, int __user *uarg)
+{
+	return put_user(bd->max_queue, uarg);
+}
+
+static int bsg_set_command_q(struct bsg_device *bd, int __user *uarg)
+{
+	int queue;
+
+	if (get_user(queue, uarg))
+		return -EFAULT;
+	if (queue < 1)
+		return -EINVAL;
+
+	spin_lock_irq(&bd->lock);
+	bd->max_queue = queue;
+	spin_unlock_irq(&bd->lock);
+	return 0;
+}
+
 static long bsg_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct bsg_device *bd = file->private_data;
-	int __user *uarg = (int __user *) arg;
-	int ret;
+	void __user *uarg = (void __user *) arg;
 
 	switch (cmd) {
-		/*
-		 * our own ioctls
-		 */
+	/*
+	 * Our own ioctls
+	 */
 	case SG_GET_COMMAND_Q:
-		return put_user(bd->max_queue, uarg);
-	case SG_SET_COMMAND_Q: {
-		int queue;
-
-		if (get_user(queue, uarg))
-			return -EFAULT;
-		if (queue < 1)
-			return -EINVAL;
-
-		spin_lock_irq(&bd->lock);
-		bd->max_queue = queue;
-		spin_unlock_irq(&bd->lock);
-		return 0;
-	}
+		return bsg_get_command_q(bd, uarg);
+	case SG_SET_COMMAND_Q:
+		return bsg_set_command_q(bd, uarg);
 
 	/*
 	 * SCSI/sg ioctls
@@ -400,36 +412,10 @@ static long bsg_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case SG_GET_RESERVED_SIZE:
 	case SG_SET_RESERVED_SIZE:
 	case SG_EMULATED_HOST:
-	case SCSI_IOCTL_SEND_COMMAND: {
-		void __user *uarg = (void __user *) arg;
+	case SCSI_IOCTL_SEND_COMMAND:
 		return scsi_cmd_ioctl(bd->queue, NULL, file->f_mode, cmd, uarg);
-	}
-	case SG_IO: {
-		struct request *rq;
-		struct bio *bio, *bidi_bio = NULL;
-		struct sg_io_v4 hdr;
-		int at_head;
-
-		if (copy_from_user(&hdr, uarg, sizeof(hdr)))
-			return -EFAULT;
-
-		rq = bsg_map_hdr(bd->queue, &hdr, file->f_mode);
-		if (IS_ERR(rq))
-			return PTR_ERR(rq);
-
-		bio = rq->bio;
-		if (rq->next_rq)
-			bidi_bio = rq->next_rq->bio;
-
-		at_head = (0 == (hdr.flags & BSG_FLAG_Q_AT_TAIL));
-		blk_execute_rq(bd->queue, NULL, rq, at_head);
-		ret = blk_complete_sgv4_hdr_rq(rq, &hdr, bio, bidi_bio);
-
-		if (copy_to_user(uarg, &hdr, sizeof(hdr)))
-			return -EFAULT;
-
-		return ret;
-	}
+	case SG_IO:
+		return bsg_sg_io(bd->queue, file->f_mode, uarg);
 	default:
 		return -ENOTTY;
 	}
-- 
2.19.1
