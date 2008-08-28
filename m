From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 1/5] block: add gfp_mask argument to blk_rq_map_user and blk_rq_map_user_iov
Date: Thu, 28 Aug 2008 16:17:05 +0900
Message-ID: <1219907829-27365-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <20080828070725.GP20055@kernel.dk>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:39578 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752841AbYH1HTJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Aug 2008 03:19:09 -0400
In-Reply-To: <20080828070725.GP20055@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org, dougg@torque.net, michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Currently, blk_rq_map_user and blk_rq_map_user_iov always do
GFP_KERNEL allocation.

This adds gfp_mask argument to blk_rq_map_user and blk_rq_map_user_iov
so sg can use it (sg always does GFP_ATOMIC allocation).

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Douglas Gilbert <dougg@torque.net>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 block/blk-map.c             |   20 ++++++++++++--------
 block/bsg.c                 |    5 +++--
 block/scsi_ioctl.c          |    5 +++--
 drivers/cdrom/cdrom.c       |    2 +-
 drivers/scsi/scsi_tgt_lib.c |    2 +-
 fs/bio.c                    |   33 +++++++++++++++++++--------------
 include/linux/bio.h         |    9 +++++----
 include/linux/blkdev.h      |    5 +++--
 8 files changed, 47 insertions(+), 34 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index ea1bf53..ac21b73 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -41,7 +41,8 @@ static int __blk_rq_unmap_user(struct bio *bio)
 }
 
 static int __blk_rq_map_user(struct request_queue *q, struct request *rq,
-			     void __user *ubuf, unsigned int len)
+			     void __user *ubuf, unsigned int len,
+			     gfp_t gfp_mask)
 {
 	unsigned long uaddr;
 	unsigned int alignment;
@@ -57,9 +58,9 @@ static int __blk_rq_map_user(struct request_queue *q, struct request *rq,
 	uaddr = (unsigned long) ubuf;
 	alignment = queue_dma_alignment(q) | q->dma_pad_mask;
 	if (!(uaddr & alignment) && !(len & alignment))
-		bio = bio_map_user(q, NULL, uaddr, len, reading);
+		bio = bio_map_user(q, NULL, uaddr, len, reading, gfp_mask);
 	else
-		bio = bio_copy_user(q, uaddr, len, reading);
+		bio = bio_copy_user(q, uaddr, len, reading, gfp_mask);
 
 	if (IS_ERR(bio))
 		return PTR_ERR(bio);
@@ -90,6 +91,7 @@ static int __blk_rq_map_user(struct request_queue *q, struct request *rq,
  * @rq:		request structure to fill
  * @ubuf:	the user buffer
  * @len:	length of user data
+ * @gfp_mask:	memory allocation flags
  *
  * Description:
  *    Data will be mapped directly for zero copy I/O, if possible. Otherwise
@@ -105,7 +107,7 @@ static int __blk_rq_map_user(struct request_queue *q, struct request *rq,
  *    unmapping.
  */
 int blk_rq_map_user(struct request_queue *q, struct request *rq,
-		    void __user *ubuf, unsigned long len)
+		    void __user *ubuf, unsigned long len, gfp_t gfp_mask)
 {
 	unsigned long bytes_read = 0;
 	struct bio *bio = NULL;
@@ -132,7 +134,7 @@ int blk_rq_map_user(struct request_queue *q, struct request *rq,
 		if (end - start > BIO_MAX_PAGES)
 			map_len -= PAGE_SIZE;
 
-		ret = __blk_rq_map_user(q, rq, ubuf, map_len);
+		ret = __blk_rq_map_user(q, rq, ubuf, map_len, gfp_mask);
 		if (ret < 0)
 			goto unmap_rq;
 		if (!bio)
@@ -160,6 +162,7 @@ EXPORT_SYMBOL(blk_rq_map_user);
  * @iov:	pointer to the iovec
  * @iov_count:	number of elements in the iovec
  * @len:	I/O byte count
+ * @gfp_mask:	memory allocation flags
  *
  * Description:
  *    Data will be mapped directly for zero copy I/O, if possible. Otherwise
@@ -175,7 +178,8 @@ EXPORT_SYMBOL(blk_rq_map_user);
  *    unmapping.
  */
 int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
-			struct sg_iovec *iov, int iov_count, unsigned int len)
+			struct sg_iovec *iov, int iov_count, unsigned int len,
+			gfp_t gfp_mask)
 {
 	struct bio *bio;
 	int i, read = rq_data_dir(rq) == READ;
@@ -194,9 +198,9 @@ int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
 	}
 
 	if (unaligned || (q->dma_pad_mask & len))
-		bio = bio_copy_user_iov(q, iov, iov_count, read);
+		bio = bio_copy_user_iov(q, iov, iov_count, read, gfp_mask);
 	else
-		bio = bio_map_user_iov(q, NULL, iov, iov_count, read);
+		bio = bio_map_user_iov(q, NULL, iov, iov_count, read, gfp_mask);
 
 	if (IS_ERR(bio))
 		return PTR_ERR(bio);
diff --git a/block/bsg.c b/block/bsg.c
index 0aae8d7..e7a142e 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -283,7 +283,8 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr, int has_write_perm)
 		next_rq->cmd_type = rq->cmd_type;
 
 		dxferp = (void*)(unsigned long)hdr->din_xferp;
-		ret =  blk_rq_map_user(q, next_rq, dxferp, hdr->din_xfer_len);
+		ret =  blk_rq_map_user(q, next_rq, dxferp, hdr->din_xfer_len,
+				       GFP_KERNEL);
 		if (ret)
 			goto out;
 	}
@@ -298,7 +299,7 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr, int has_write_perm)
 		dxfer_len = 0;
 
 	if (dxfer_len) {
-		ret = blk_rq_map_user(q, rq, dxferp, dxfer_len);
+		ret = blk_rq_map_user(q, rq, dxferp, dxfer_len, GFP_KERNEL);
 		if (ret)
 			goto out;
 	}
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 3aab80a..f49d6a1 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -315,10 +315,11 @@ static int sg_io(struct file *file, struct request_queue *q,
 		}
 
 		ret = blk_rq_map_user_iov(q, rq, iov, hdr->iovec_count,
-					  hdr->dxfer_len);
+					  hdr->dxfer_len, GFP_KERNEL);
 		kfree(iov);
 	} else if (hdr->dxfer_len)
-		ret = blk_rq_map_user(q, rq, hdr->dxferp, hdr->dxfer_len);
+		ret = blk_rq_map_user(q, rq, hdr->dxferp, hdr->dxfer_len,
+				      GFP_KERNEL);
 
 	if (ret)
 		goto out;
diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 74031de..e861d24 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -2097,7 +2097,7 @@ static int cdrom_read_cdda_bpc(struct cdrom_device_info *cdi, __u8 __user *ubuf,
 
 		len = nr * CD_FRAMESIZE_RAW;
 
-		ret = blk_rq_map_user(q, rq, ubuf, len);
+		ret = blk_rq_map_user(q, rq, ubuf, len, GFP_KERNEL);
 		if (ret)
 			break;
 
diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
index 257e097..2a4fd82 100644
--- a/drivers/scsi/scsi_tgt_lib.c
+++ b/drivers/scsi/scsi_tgt_lib.c
@@ -362,7 +362,7 @@ static int scsi_map_user_pages(struct scsi_tgt_cmd *tcmd, struct scsi_cmnd *cmd,
 	int err;
 
 	dprintk("%lx %u\n", uaddr, len);
-	err = blk_rq_map_user(q, rq, (void *)uaddr, len);
+	err = blk_rq_map_user(q, rq, (void *)uaddr, len, GFP_KERNEL);
 	if (err) {
 		/*
 		 * TODO: need to fixup sg_tablesize, max_segment_size,
diff --git a/fs/bio.c b/fs/bio.c
index 6a637b5..3d2e9ad 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -558,13 +558,14 @@ int bio_uncopy_user(struct bio *bio)
  *	@iov:	the iovec.
  *	@iov_count: number of elements in the iovec
  *	@write_to_vm: bool indicating writing to pages or not
+ *	@gfp_mask: memory allocation flags
  *
  *	Prepares and returns a bio for indirect user io, bouncing data
  *	to/from kernel pages as necessary. Must be paired with
  *	call bio_uncopy_user() on io completion.
  */
 struct bio *bio_copy_user_iov(struct request_queue *q, struct sg_iovec *iov,
-			      int iov_count, int write_to_vm)
+			      int iov_count, int write_to_vm, gfp_t gfp_mask)
 {
 	struct bio_map_data *bmd;
 	struct bio_vec *bvec;
@@ -587,12 +588,12 @@ struct bio *bio_copy_user_iov(struct request_queue *q, struct sg_iovec *iov,
 		len += iov[i].iov_len;
 	}
 
-	bmd = bio_alloc_map_data(nr_pages, iov_count, GFP_KERNEL);
+	bmd = bio_alloc_map_data(nr_pages, iov_count, gfp_mask);
 	if (!bmd)
 		return ERR_PTR(-ENOMEM);
 
 	ret = -ENOMEM;
-	bio = bio_alloc(GFP_KERNEL, nr_pages);
+	bio = bio_alloc(gfp_mask, nr_pages);
 	if (!bio)
 		goto out_bmd;
 
@@ -605,7 +606,7 @@ struct bio *bio_copy_user_iov(struct request_queue *q, struct sg_iovec *iov,
 		if (bytes > len)
 			bytes = len;
 
-		page = alloc_page(q->bounce_gfp | GFP_KERNEL);
+		page = alloc_page(q->bounce_gfp | gfp_mask);
 		if (!page) {
 			ret = -ENOMEM;
 			break;
@@ -647,26 +648,27 @@ out_bmd:
  *	@uaddr: start of user address
  *	@len: length in bytes
  *	@write_to_vm: bool indicating writing to pages or not
+ *	@gfp_mask: memory allocation flags
  *
  *	Prepares and returns a bio for indirect user io, bouncing data
  *	to/from kernel pages as necessary. Must be paired with
  *	call bio_uncopy_user() on io completion.
  */
 struct bio *bio_copy_user(struct request_queue *q, unsigned long uaddr,
-			  unsigned int len, int write_to_vm)
+			  unsigned int len, int write_to_vm, gfp_t gfp_mask)
 {
 	struct sg_iovec iov;
 
 	iov.iov_base = (void __user *)uaddr;
 	iov.iov_len = len;
 
-	return bio_copy_user_iov(q, &iov, 1, write_to_vm);
+	return bio_copy_user_iov(q, &iov, 1, write_to_vm, gfp_mask);
 }
 
 static struct bio *__bio_map_user_iov(struct request_queue *q,
 				      struct block_device *bdev,
 				      struct sg_iovec *iov, int iov_count,
-				      int write_to_vm)
+				      int write_to_vm, gfp_t gfp_mask)
 {
 	int i, j;
 	int nr_pages = 0;
@@ -692,12 +694,12 @@ static struct bio *__bio_map_user_iov(struct request_queue *q,
 	if (!nr_pages)
 		return ERR_PTR(-EINVAL);
 
-	bio = bio_alloc(GFP_KERNEL, nr_pages);
+	bio = bio_alloc(gfp_mask, nr_pages);
 	if (!bio)
 		return ERR_PTR(-ENOMEM);
 
 	ret = -ENOMEM;
-	pages = kcalloc(nr_pages, sizeof(struct page *), GFP_KERNEL);
+	pages = kcalloc(nr_pages, sizeof(struct page *), gfp_mask);
 	if (!pages)
 		goto out;
 
@@ -776,19 +778,21 @@ static struct bio *__bio_map_user_iov(struct request_queue *q,
  *	@uaddr: start of user address
  *	@len: length in bytes
  *	@write_to_vm: bool indicating writing to pages or not
+ *	@gfp_mask: memory allocation flags
  *
  *	Map the user space address into a bio suitable for io to a block
  *	device. Returns an error pointer in case of error.
  */
 struct bio *bio_map_user(struct request_queue *q, struct block_device *bdev,
-			 unsigned long uaddr, unsigned int len, int write_to_vm)
+			 unsigned long uaddr, unsigned int len, int write_to_vm,
+			 gfp_t gfp_mask)
 {
 	struct sg_iovec iov;
 
 	iov.iov_base = (void __user *)uaddr;
 	iov.iov_len = len;
 
-	return bio_map_user_iov(q, bdev, &iov, 1, write_to_vm);
+	return bio_map_user_iov(q, bdev, &iov, 1, write_to_vm, gfp_mask);
 }
 
 /**
@@ -798,18 +802,19 @@ struct bio *bio_map_user(struct request_queue *q, struct block_device *bdev,
  *	@iov:	the iovec.
  *	@iov_count: number of elements in the iovec
  *	@write_to_vm: bool indicating writing to pages or not
+ *	@gfp_mask: memory allocation flags
  *
  *	Map the user space address into a bio suitable for io to a block
  *	device. Returns an error pointer in case of error.
  */
 struct bio *bio_map_user_iov(struct request_queue *q, struct block_device *bdev,
 			     struct sg_iovec *iov, int iov_count,
-			     int write_to_vm)
+			     int write_to_vm, gfp_t gfp_mask)
 {
 	struct bio *bio;
 
-	bio = __bio_map_user_iov(q, bdev, iov, iov_count, write_to_vm);
-
+	bio = __bio_map_user_iov(q, bdev, iov, iov_count, write_to_vm,
+				 gfp_mask);
 	if (IS_ERR(bio))
 		return bio;
 
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 13aba20..200b185 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -325,11 +325,11 @@ extern int bio_add_pc_page(struct request_queue *, struct bio *, struct page *,
 			   unsigned int, unsigned int);
 extern int bio_get_nr_vecs(struct block_device *);
 extern struct bio *bio_map_user(struct request_queue *, struct block_device *,
-				unsigned long, unsigned int, int);
+				unsigned long, unsigned int, int, gfp_t);
 struct sg_iovec;
 extern struct bio *bio_map_user_iov(struct request_queue *,
 				    struct block_device *,
-				    struct sg_iovec *, int, int);
+				    struct sg_iovec *, int, int, gfp_t);
 extern void bio_unmap_user(struct bio *);
 extern struct bio *bio_map_kern(struct request_queue *, void *, unsigned int,
 				gfp_t);
@@ -337,9 +337,10 @@ extern struct bio *bio_copy_kern(struct request_queue *, void *, unsigned int,
 				 gfp_t, int);
 extern void bio_set_pages_dirty(struct bio *bio);
 extern void bio_check_pages_dirty(struct bio *bio);
-extern struct bio *bio_copy_user(struct request_queue *, unsigned long, unsigned int, int);
+extern struct bio *bio_copy_user(struct request_queue *, unsigned long,
+				 unsigned int, int, gfp_t);
 extern struct bio *bio_copy_user_iov(struct request_queue *, struct sg_iovec *,
-				     int, int);
+				     int, int, gfp_t);
 extern int bio_uncopy_user(struct bio *);
 void zero_fill_bio(struct bio *bio);
 extern struct bio_vec *bvec_alloc_bs(gfp_t, int, unsigned long *, struct bio_set *);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ed9324f..9512c5b 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -710,11 +710,12 @@ extern void __blk_stop_queue(struct request_queue *q);
 extern void __blk_run_queue(struct request_queue *);
 extern void blk_run_queue(struct request_queue *);
 extern void blk_start_queueing(struct request_queue *);
-extern int blk_rq_map_user(struct request_queue *, struct request *, void __user *, unsigned long);
+extern int blk_rq_map_user(struct request_queue *, struct request *,
+			   void __user *, unsigned long, gfp_t);
 extern int blk_rq_unmap_user(struct bio *);
 extern int blk_rq_map_kern(struct request_queue *, struct request *, void *, unsigned int, gfp_t);
 extern int blk_rq_map_user_iov(struct request_queue *, struct request *,
-			       struct sg_iovec *, int, unsigned int);
+			       struct sg_iovec *, int, unsigned int, gfp_t);
 extern int blk_execute_rq(struct request_queue *, struct gendisk *,
 			  struct request *, int);
 extern void blk_execute_rq_nowait(struct request_queue *, struct gendisk *,
-- 
1.5.5.GIT

