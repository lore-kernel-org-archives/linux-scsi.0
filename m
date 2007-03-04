From: michaelc@cs.wisc.edu
Subject: [PATCH 2/7] rm block device arg from bio map user
Date: Sun, 04 Mar 2007 12:31:19 -0600
Message-ID: <11730330851234-git-send-email-michaelc@cs.wisc.edu>
References: <1173033084706-git-send-email-michaelc@cs.wisc.edu> <11730330852430-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36400 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752230AbXCDSbg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 4 Mar 2007 13:31:36 -0500
In-Reply-To: <11730330852430-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jens.axboe@oracle.com, dougg@torque.net
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

Everyone is passing in NULL, so let's just
make it a little more simple and drop the
block device argument from the bio mapping
functions.
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 block/ll_rw_blk.c   |    4 ++--
 fs/bio.c            |   17 ++++++-----------
 include/linux/bio.h |    5 ++---
 3 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 38c293b..7a108d5 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -2343,7 +2343,7 @@ static int __blk_rq_map_user(request_que
 	 */
 	uaddr = (unsigned long) ubuf;
 	if (!(uaddr & queue_dma_alignment(q)) && !(len & queue_dma_alignment(q)))
-		bio = bio_map_user(q, NULL, uaddr, len, reading);
+		bio = bio_map_user(q, uaddr, len, reading);
 	else
 		bio = bio_copy_user(q, uaddr, len, reading);
 
@@ -2479,7 +2479,7 @@ int blk_rq_map_user_iov(request_queue_t 
 	/* we don't allow misaligned data like bio_map_user() does.  If the
 	 * user is using sg, they're expected to know the alignment constraints
 	 * and respect them accordingly */
-	bio = bio_map_user_iov(q, NULL, iov, iov_count, rq_data_dir(rq)== READ);
+	bio = bio_map_user_iov(q, iov, iov_count, rq_data_dir(rq)== READ);
 	if (IS_ERR(bio))
 		return PTR_ERR(bio);
 
diff --git a/fs/bio.c b/fs/bio.c
index 7618bcb..8ae7223 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -601,7 +601,6 @@ out_bmd:
 }
 
 static struct bio *__bio_map_user_iov(request_queue_t *q,
-				      struct block_device *bdev,
 				      struct sg_iovec *iov, int iov_count,
 				      int write_to_vm)
 {
@@ -694,7 +693,6 @@ static struct bio *__bio_map_user_iov(re
 	if (!write_to_vm)
 		bio->bi_rw |= (1 << BIO_RW);
 
-	bio->bi_bdev = bdev;
 	bio->bi_flags |= (1 << BIO_USER_MAPPED);
 	return bio;
 
@@ -713,7 +711,6 @@ static struct bio *__bio_map_user_iov(re
 /**
  *	bio_map_user	-	map user address into bio
  *	@q: the request_queue_t for the bio
- *	@bdev: destination block device
  *	@uaddr: start of user address
  *	@len: length in bytes
  *	@write_to_vm: bool indicating writing to pages or not
@@ -721,21 +718,20 @@ static struct bio *__bio_map_user_iov(re
  *	Map the user space address into a bio suitable for io to a block
  *	device. Returns an error pointer in case of error.
  */
-struct bio *bio_map_user(request_queue_t *q, struct block_device *bdev,
-			 unsigned long uaddr, unsigned int len, int write_to_vm)
+struct bio *bio_map_user(request_queue_t *q, unsigned long uaddr,
+			 unsigned int len, int write_to_vm)
 {
 	struct sg_iovec iov;
 
 	iov.iov_base = (void __user *)uaddr;
 	iov.iov_len = len;
 
-	return bio_map_user_iov(q, bdev, &iov, 1, write_to_vm);
+	return bio_map_user_iov(q, &iov, 1, write_to_vm);
 }
 
 /**
  *	bio_map_user_iov - map user sg_iovec table into bio
  *	@q: the request_queue_t for the bio
- *	@bdev: destination block device
  *	@iov:	the iovec.
  *	@iov_count: number of elements in the iovec
  *	@write_to_vm: bool indicating writing to pages or not
@@ -743,13 +739,12 @@ struct bio *bio_map_user(request_queue_t
  *	Map the user space address into a bio suitable for io to a block
  *	device. Returns an error pointer in case of error.
  */
-struct bio *bio_map_user_iov(request_queue_t *q, struct block_device *bdev,
-			     struct sg_iovec *iov, int iov_count,
-			     int write_to_vm)
+struct bio *bio_map_user_iov(request_queue_t *q, struct sg_iovec *iov,
+			     int iov_count, int write_to_vm)
 {
 	struct bio *bio;
 
-	bio = __bio_map_user_iov(q, bdev, iov, iov_count, write_to_vm);
+	bio = __bio_map_user_iov(q, iov, iov_count, write_to_vm);
 
 	if (IS_ERR(bio))
 		return bio;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 08daf32..cfb6a7d 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -298,11 +298,10 @@ extern int bio_add_page(struct bio *, st
 extern int bio_add_pc_page(struct request_queue *, struct bio *, struct page *,
 			   unsigned int, unsigned int);
 extern int bio_get_nr_vecs(struct block_device *);
-extern struct bio *bio_map_user(struct request_queue *, struct block_device *,
-				unsigned long, unsigned int, int);
+extern struct bio *bio_map_user(struct request_queue *, unsigned long,
+				unsigned int, int);
 struct sg_iovec;
 extern struct bio *bio_map_user_iov(struct request_queue *,
-				    struct block_device *,
 				    struct sg_iovec *, int, int);
 extern void bio_unmap_user(struct bio *);
 extern struct bio *bio_map_kern(struct request_queue *, void *, unsigned int,
-- 
1.4.1.1

