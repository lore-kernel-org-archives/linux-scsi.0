From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 2/4] bsg: add bidi support
Date: Mon, 9 Jul 2007 22:02:56 +0900
Message-ID: <20070708152658G.fujita.tomonori@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mfo11.iij4u.or.jp ([210.138.174.81]:50429 "EHLO
	mfo11.iij4u.or.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbXGINSy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jul 2007 09:18:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org, tomof@acm.org

bsg uses the rq->next_rq pointer for a bidi request.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/bsg.c |   74 +++++++++++++++++++++++++++++++++++++++--------------------
 1 files changed, 49 insertions(+), 25 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index 5f4abc9..13ecc95 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -95,6 +95,7 @@ struct bsg_command {
 	struct list_head list;
 	struct request *rq;
 	struct bio *bio;
+	struct bio *bidi_bio;
 	int err;
 	struct sg_io_v4 hdr;
 	struct sg_io_v4 __user *uhdr;
@@ -243,16 +244,6 @@ bsg_validate_sgv4_hdr(request_queue_t *q, struct sg_io_v4 *hdr, int *rw)
 	if (hdr->protocol || hdr->subprotocol)
 		return -EINVAL;
 
-	/*
-	 * looks sane, if no data then it should be fine from our POV
-	 */
-	if (!hdr->dout_xfer_len && !hdr->din_xfer_len)
-		return 0;
-
-	/* not supported currently */
-	if (hdr->dout_xfer_len && hdr->din_xfer_len)
-		return -EINVAL;
-
 	*rw = hdr->dout_xfer_len ? WRITE : READ;
 
 	return 0;
@@ -265,7 +256,7 @@ static struct request *
 bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr)
 {
 	request_queue_t *q = bd->queue;
-	struct request *rq;
+	struct request *rq, *next_rq = NULL;
 	int ret, rw = 0; /* shut up gcc */
 	unsigned int dxfer_len;
 	void *dxferp = NULL;
@@ -282,11 +273,30 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr)
 	 * map scatter-gather elements seperately and string them to request
 	 */
 	rq = blk_get_request(q, rw, GFP_KERNEL);
+	if (!rq)
+		return ERR_PTR(-ENOMEM);
 	ret = blk_fill_sgv4_hdr_rq(q, rq, hdr, test_bit(BSG_F_WRITE_PERM,
 						       &bd->flags));
-	if (ret) {
-		blk_put_request(rq);
-		return ERR_PTR(ret);
+	if (ret)
+		goto out;
+
+	if (rw == WRITE && hdr->din_xfer_len) {
+		if (!test_bit(QUEUE_FLAG_BIDI, &q->queue_flags)) {
+			ret = -EOPNOTSUPP;
+			goto out;
+		}
+
+		next_rq = blk_get_request(q, READ, GFP_KERNEL);
+		if (!next_rq) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		rq->next_rq = next_rq;
+
+		dxferp = (void*)(unsigned long)hdr->din_xferp;
+		ret =  blk_rq_map_user(q, next_rq, dxferp, hdr->din_xfer_len);
+		if (ret)
+			goto out;
 	}
 
 	if (hdr->dout_xfer_len) {
@@ -300,14 +310,17 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr)
 
 	if (dxfer_len) {
 		ret = blk_rq_map_user(q, rq, dxferp, dxfer_len);
-		if (ret) {
-			dprintk("failed map at %d\n", ret);
-			blk_put_request(rq);
-			rq = ERR_PTR(ret);
-		}
+		if (ret)
+			goto out;
 	}
-
 	return rq;
+out:
+	blk_put_request(rq);
+	if (next_rq) {
+		blk_rq_unmap_user(next_rq->bio);
+		blk_put_request(next_rq);
+	}
+	return ERR_PTR(ret);
 }
 
 /*
@@ -346,6 +359,8 @@ static void bsg_add_command(struct bsg_device *bd, request_queue_t *q,
 	 */
 	bc->rq = rq;
 	bc->bio = rq->bio;
+	if (rq->next_rq)
+		bc->bidi_bio = rq->next_rq->bio;
 	bc->hdr.duration = jiffies;
 	spin_lock_irq(&bd->lock);
 	list_add_tail(&bc->list, &bd->busy_list);
@@ -402,7 +417,7 @@ static struct bsg_command *bsg_get_done_cmd(struct bsg_device *bd)
 }
 
 static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
-				    struct bio *bio)
+				    struct bio *bio, struct bio *bidi_bio)
 {
 	int ret = 0;
 
@@ -431,6 +446,11 @@ static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
 			ret = -EFAULT;
 	}
 
+	if (rq->next_rq) {
+		blk_rq_unmap_user(bidi_bio);
+		blk_put_request(rq->next_rq);
+	}
+
 	blk_rq_unmap_user(bio);
 	blk_put_request(rq);
 
@@ -477,7 +497,8 @@ static int bsg_complete_all_commands(struct bsg_device *bd)
 		if (IS_ERR(bc))
 			break;
 
-		tret = blk_complete_sgv4_hdr_rq(bc->rq, &bc->hdr, bc->bio);
+		tret = blk_complete_sgv4_hdr_rq(bc->rq, &bc->hdr, bc->bio,
+						bc->bidi_bio);
 		if (!ret)
 			ret = tret;
 
@@ -511,7 +532,8 @@ __bsg_read(char __user *buf, size_t count, struct bsg_device *bd,
 		 * after completing the request. so do that here,
 		 * bsg_complete_work() cannot do that for us
 		 */
-		ret = blk_complete_sgv4_hdr_rq(bc->rq, &bc->hdr, bc->bio);
+		ret = blk_complete_sgv4_hdr_rq(bc->rq, &bc->hdr, bc->bio,
+					       bc->bidi_bio);
 
 		if (copy_to_user(buf, (char *) &bc->hdr, sizeof(bc->hdr)))
 			ret = -EFAULT;
@@ -868,7 +890,7 @@ bsg_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 	}
 	case SG_IO: {
 		struct request *rq;
-		struct bio *bio;
+		struct bio *bio, *bidi_bio = NULL;
 		struct sg_io_v4 hdr;
 
 		if (copy_from_user(&hdr, uarg, sizeof(hdr)))
@@ -879,8 +901,10 @@ bsg_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 			return PTR_ERR(rq);
 
 		bio = rq->bio;
+		if (rq->next_rq)
+			bidi_bio = rq->next_rq->bio;
 		blk_execute_rq(bd->queue, NULL, rq, 0);
-		blk_complete_sgv4_hdr_rq(rq, &hdr, bio);
+		blk_complete_sgv4_hdr_rq(rq, &hdr, bio, bidi_bio);
 
 		if (copy_to_user(uarg, &hdr, sizeof(hdr)))
 			return -EFAULT;
-- 
1.4.4.4

