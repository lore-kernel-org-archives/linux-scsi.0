From: Pete Wyckoff <pw@osc.edu>
Subject: [PATCH] bsg: port to bidi
Date: Tue, 24 Apr 2007 13:27:13 -0400
Message-ID: <20070424172713.GB21882@osc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from quasar.osc.edu ([192.148.249.15]:42083 "EHLO quasar.osc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422799AbXDXR1P (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Apr 2007 13:27:15 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org

Changes required to make bsg patches work on top of bidi patches.  Adds
capability to bsg to handle bidirectional commands and extended CDBs.

Signed-off-by: Pete Wyckoff <pw@osc.edu>
---
 block/bsg.c            |  106 ++++++++++++++++++++++++++++++------------------
 block/ll_rw_blk.c      |   30 +++++++++-----
 include/linux/blkdev.h |    1 +
 3 files changed, 87 insertions(+), 50 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index 92be6fa..9d09505 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -95,6 +95,7 @@ struct bsg_command {
 	struct list_head list;
 	struct request *rq;
 	struct bio *bio;
+	struct bio *bidi_read_bio;
 	int err;
 	struct sg_io_v4 hdr;
 	struct sg_io_v4 __user *uhdr;
@@ -225,18 +226,31 @@ static struct bsg_command *bsg_get_command(struct bsg_device *bd)
 static int blk_fill_sgv4_hdr_rq(request_queue_t *q, struct request *rq,
 				struct sg_io_v4 *hdr, int has_write_perm)
 {
+	int len = hdr->request_len;
+	int cmd_len = min(len, BLK_MAX_CDB);
+
 	memset(rq->cmd, 0, BLK_MAX_CDB); /* ATAPI hates garbage after CDB */
 
 	if (copy_from_user(rq->cmd, (void *)(unsigned long)hdr->request,
-			   hdr->request_len))
+	                   cmd_len))
 		return -EFAULT;
+	if (len > BLK_MAX_CDB) {
+		rq->varlen_cdb_len = len;
+		rq->varlen_cdb = kmalloc(len, GFP_KERNEL);
+		if (rq->varlen_cdb == NULL)
+			return -ENOMEM;
+		if (copy_from_user(rq->varlen_cdb,
+		                   (void *)(unsigned long)hdr->request, len))
+			return -EFAULT;
+	}
+
 	if (blk_verify_command(rq->cmd, has_write_perm))
 		return -EPERM;
 
 	/*
 	 * fill in request structure
 	 */
-	rq->cmd_len = hdr->request_len;
+	rq->cmd_len = cmd_len;
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
 
 	rq->timeout = (hdr->timeout * HZ) / 1000;
@@ -252,12 +266,11 @@ static int blk_fill_sgv4_hdr_rq(request_queue_t *q, struct request *rq,
  * Check if sg_io_v4 from user is allowed and valid
  */
 static int
-bsg_validate_sgv4_hdr(request_queue_t *q, struct sg_io_v4 *hdr, int *rw)
+bsg_validate_sgv4_hdr(request_queue_t *q, struct sg_io_v4 *hdr,
+                      enum dma_data_direction *dir)
 {
 	if (hdr->guard != 'Q')
 		return -EINVAL;
-	if (hdr->request_len > BLK_MAX_CDB)
-		return -EINVAL;
 	if (hdr->dout_xfer_len > (q->max_sectors << 9) ||
 	    hdr->din_xfer_len > (q->max_sectors << 9))
 		return -EIO;
@@ -266,17 +279,15 @@ bsg_validate_sgv4_hdr(request_queue_t *q, struct sg_io_v4 *hdr, int *rw)
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
-	*rw = hdr->dout_xfer_len ? WRITE : READ;
+	if (hdr->dout_xfer_len) {
+		if (hdr->din_xfer_len)
+			*dir = DMA_BIDIRECTIONAL;
+		else
+			*dir = DMA_TO_DEVICE;
+	} else if (hdr->din_xfer_len)
+		*dir = DMA_FROM_DEVICE;
+	else
+		*dir = DMA_NONE;
 
 	return 0;
 }
@@ -289,7 +300,8 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr)
 {
 	request_queue_t *q = bd->queue;
 	struct request *rq;
-	int ret, rw = 0; /* shut up gcc */
+	enum dma_data_direction dir;
+	int ret;
 	unsigned int dxfer_len;
 	void *dxferp = NULL;
 
@@ -297,39 +309,45 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr)
 		hdr->dout_xfer_len, (unsigned long long) hdr->din_xferp,
 		hdr->din_xfer_len);
 
-	ret = bsg_validate_sgv4_hdr(q, hdr, &rw);
+	ret = bsg_validate_sgv4_hdr(q, hdr, &dir);
 	if (ret)
 		return ERR_PTR(ret);
 
 	/*
 	 * map scatter-gather elements seperately and string them to request
 	 */
-	rq = blk_get_request(q, rw, GFP_KERNEL);
+	rq = blk_get_request(q, dir, GFP_KERNEL);
 	ret = blk_fill_sgv4_hdr_rq(q, rq, hdr, test_bit(BSG_F_WRITE_PERM,
 						       &bd->flags));
-	if (ret) {
-		blk_put_request(rq);
-		return ERR_PTR(ret);
-	}
+	if (ret)
+		goto errout;
 
 	if (hdr->dout_xfer_len) {
 		dxfer_len = hdr->dout_xfer_len;
 		dxferp = (void*)(unsigned long)hdr->dout_xferp;
-	} else if (hdr->din_xfer_len) {
+		ret = blk_rq_map_user_bidi(q, rq, dxferp, dxfer_len, dir);
+		if (ret)
+			goto errout;
+	}
+
+	if (hdr->din_xfer_len) {
 		dxfer_len = hdr->din_xfer_len;
 		dxferp = (void*)(unsigned long)hdr->din_xferp;
-	} else
-		dxfer_len = 0;
-
-	if (dxfer_len) {
-		ret = blk_rq_map_user(q, rq, dxferp, dxfer_len);
+		ret = blk_rq_map_user_bidi(q, rq, dxferp, dxfer_len, dir);
 		if (ret) {
-			dprintk("failed map at %d\n", ret);
-			blk_put_request(rq);
-			rq = ERR_PTR(ret);
+			blk_rq_unmap_user(rq->uni.bio);
+			goto errout;
 		}
 	}
 
+	goto out;
+
+errout:
+	kfree(rq->varlen_cdb);
+ 	blk_put_request(rq);
+	rq = ERR_PTR(ret);
+
+out:
 	return rq;
 }
 
@@ -368,7 +386,9 @@ static void bsg_add_command(struct bsg_device *bd, request_queue_t *q,
 	 * add bc command to busy queue and submit rq for io
 	 */
 	bc->rq = rq;
-	bc->bio = rq_uni(rq)->bio;
+	bc->bio = rq->uni.bio;
+	bc->bidi_read_bio = (rq->cmd_flags & REQ_BIDI)
+	                    ? rq->bidi_read.bio : NULL;
 	bc->hdr.duration = jiffies;
 	spin_lock_irq(&bd->lock);
 	list_add_tail(&bc->list, &bd->busy_list);
@@ -432,7 +452,7 @@ bsg_get_done_cmd_nosignals(struct bsg_device *bd)
 }
 
 static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
-				    struct bio *bio)
+				    struct bio *bio, struct bio *bidi_read_bio)
 {
 	int ret = 0;
 
@@ -446,7 +466,7 @@ static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
 	hdr->info = 0;
 	if (hdr->device_status || hdr->transport_status || hdr->driver_status)
 		hdr->info |= SG_INFO_CHECK;
-	hdr->din_resid = rq_uni(rq)->data_len;
+	hdr->din_resid = rq_in(rq)->data_len;
 	hdr->response_len = 0;
 
 	if (rq->sense_len && hdr->response) {
@@ -462,6 +482,8 @@ static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
 	}
 
 	blk_rq_unmap_user(bio);
+	blk_rq_unmap_user(bidi_read_bio);
+	kfree(rq->varlen_cdb);
 	blk_put_request(rq);
 
 	return ret;
@@ -509,7 +531,8 @@ static int bsg_complete_all_commands(struct bsg_device *bd)
 			break;
 		}
 
-		tret = blk_complete_sgv4_hdr_rq(bc->rq, &bc->hdr, bc->bio);
+		tret = blk_complete_sgv4_hdr_rq(bc->rq, &bc->hdr, bc->bio,
+		                                bc->bidi_read_bio);
 		if (!ret)
 			ret = tret;
 
@@ -545,7 +568,8 @@ __bsg_read(char __user *buf, size_t count, bsg_command_callback get_bc,
 		 * after completing the request. so do that here,
 		 * bsg_complete_work() cannot do that for us
 		 */
-		ret = blk_complete_sgv4_hdr_rq(bc->rq, &bc->hdr, bc->bio);
+		ret = blk_complete_sgv4_hdr_rq(bc->rq, &bc->hdr, bc->bio,
+		                               bc->bidi_read_bio);
 
 		if (copy_to_user(buf, (char *) &bc->hdr, sizeof(bc->hdr)))
 			ret = -EFAULT;
@@ -905,7 +929,7 @@ bsg_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 	}
 	case SG_IO: {
 		struct request *rq;
-		struct bio *bio;
+		struct bio *bio, *bidi_read_bio;
 		struct sg_io_v4 hdr;
 
 		if (copy_from_user(&hdr, uarg, sizeof(hdr)))
@@ -915,9 +939,11 @@ bsg_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 		if (IS_ERR(rq))
 			return PTR_ERR(rq);
 
-		bio = rq_uni(rq)->bio;
+		bio = rq->uni.bio;
+		bidi_read_bio = (rq->cmd_flags & REQ_BIDI)
+		                ? rq->bidi_read.bio : NULL;
 		blk_execute_rq(bd->queue, NULL, rq, 0);
-		blk_complete_sgv4_hdr_rq(rq, &hdr, bio);
+		blk_complete_sgv4_hdr_rq(rq, &hdr, bio, bidi_read_bio);
 
 		if (copy_to_user(uarg, &hdr, sizeof(hdr)))
 			return -EFAULT;
diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index ab3629e..80b558a 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -2376,7 +2376,8 @@ static int __blk_rq_unmap_user(struct bio *bio)
 }
 
 static int __blk_rq_map_user(request_queue_t *q, struct request *rq,
-			     void __user *ubuf, unsigned int len)
+			     void __user *ubuf, unsigned int len,
+			     enum dma_data_direction dir)
 {
 	unsigned long uaddr;
 	struct bio *bio, *orig_bio;
@@ -2406,16 +2407,16 @@ static int __blk_rq_map_user(request_queue_t *q, struct request *rq,
 	 */
 	bio_get(bio);
 
-	if (!rq_uni(rq)->bio)
-		blk_rq_bio_prep(q, rq, bio);
+	if (!rq_io(rq, dir)->bio)
+		blk_rq_bio_prep_bidi(q, rq, bio, dir);
 	else if (!ll_back_merge_fn(q, rq, bio, rq->data_dir)) {
 		ret = -EINVAL;
 		goto unmap_bio;
 	} else {
-		rq_uni(rq)->biotail->bi_next = bio;
-		rq_uni(rq)->biotail = bio;
+		rq_io(rq, dir)->biotail->bi_next = bio;
+		rq_io(rq, dir)->biotail = bio;
 
-		rq_uni(rq)->data_len += bio->bi_size;
+		rq_io(rq, dir)->data_len += bio->bi_size;
 	}
 
 	return bio->bi_size;
@@ -2448,8 +2449,9 @@ unmap_bio:
  *    original bio must be passed back in to blk_rq_unmap_user() for proper
  *    unmapping.
  */
-int blk_rq_map_user(request_queue_t *q, struct request *rq, void __user *ubuf,
-		    unsigned long len)
+int blk_rq_map_user_bidi(request_queue_t *q, struct request *rq,
+                         void __user *ubuf, unsigned long len,
+			 enum dma_data_direction dir)
 {
 	unsigned long bytes_read = 0;
 	struct bio *bio = NULL;
@@ -2476,11 +2478,11 @@ int blk_rq_map_user(request_queue_t *q, struct request *rq, void __user *ubuf,
 		if (end - start > BIO_MAX_PAGES)
 			map_len -= PAGE_SIZE;
 
-		ret = __blk_rq_map_user(q, rq, ubuf, map_len);
+		ret = __blk_rq_map_user(q, rq, ubuf, map_len, dir);
 		if (ret < 0)
 			goto unmap_rq;
 		if (!bio)
-			bio = rq_uni(rq)->bio;
+			bio = rq_io(rq, dir)->bio;
 		bytes_read += ret;
 		ubuf += ret;
 	}
@@ -2492,6 +2494,14 @@ unmap_rq:
 	return ret;
 }
 
+EXPORT_SYMBOL(blk_rq_map_user_bidi);
+
+int blk_rq_map_user(request_queue_t *q, struct request *rq, void __user *ubuf,
+		    unsigned long len)
+{
+	return blk_rq_map_user_bidi(q, rq, ubuf, len, rq->data_dir);
+}
+
 EXPORT_SYMBOL(blk_rq_map_user);
 
 /**
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index c8fe1fd..6506231 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -767,6 +767,7 @@ extern void __blk_stop_queue(request_queue_t *q);
 extern void blk_run_queue(request_queue_t *);
 extern void blk_start_queueing(request_queue_t *);
 extern int blk_rq_map_user(request_queue_t *, struct request *, void __user *, unsigned long);
+extern int blk_rq_map_user_bidi(request_queue_t *, struct request *, void __user *, unsigned long, enum dma_data_direction);
 extern int blk_rq_unmap_user(struct bio *);
 extern int blk_rq_map_kern(request_queue_t *, struct request *, void *, unsigned int, gfp_t);
 extern int blk_rq_map_user_iov(request_queue_t *, struct request *,
-- 
1.5.0.6

