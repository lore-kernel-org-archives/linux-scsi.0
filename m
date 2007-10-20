From: michaelc@cs.wisc.edu
Subject: [PATCH 02/10] rm block device arg from bio map user
	functions
Date: Sat, 20 Oct 2007 00:44:36 -0500
Message-ID: <11928590862112-git-send-email-michaelc@cs.wisc.edu>
References: <11928590843394-git-send-email-michaelc@cs.wisc.edu>
	<1192859085521-git-send-email-michaelc@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1192859085521-git-send-email-michaelc@cs.wisc.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-scsi@vger.kernel.org, dm-devel@redhat.com, jens.axboe@oracle.com
Cc: Mike Christie <michaelc@cs.wisc.edu>
List-Id: linux-scsi@vger.kernel.org

From: Mike Christie <michaelc@cs.wisc.edu>

Everyone is passing in NULL, so let's just drop the
block device argument from the bio mapping functions.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 block/ll_rw_blk.c   |    4 ++--
 fs/bio.c            |   17 ++++++-----------
 include/linux/bio.h |    5 ++---
 3 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 3935469..7c90e9b 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -2383,7 +2383,7 @@ static int __blk_rq_map_user(struct request_queue *q, struct request *rq,
 	 */
 	uaddr = (unsigned long) ubuf;
 	if (!(uaddr & queue_dma_alignment(q)) && !(len & queue_dma_alignment(q)))
-		bio = bio_map_user(q, NULL, uaddr, len, reading);
+		bio = bio_map_user(q, uaddr, len, reading);
 	else
 		bio = bio_copy_user(q, uaddr, len, reading);
 
@@ -2508,7 +2508,7 @@ int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
 	/* we don't allow misaligned data like bio_map_user() does.  If the
 	 * user is using sg, they're expected to know the alignment constraints
 	 * and respect them accordingly */
-	bio = bio_map_user_iov(q, NULL, iov, iov_count, rq_data_dir(rq)== READ);
+	bio = bio_map_user_iov(q, iov, iov_count, rq_data_dir(rq)== READ);
 	if (IS_ERR(bio))
 		return PTR_ERR(bio);
 
diff --git a/fs/bio.c b/fs/bio.c
index 0781e65..f85139a 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -602,7 +602,6 @@ out_bmd:
 }
 
 static struct bio *__bio_map_user_iov(struct request_queue *q,
-				      struct block_device *bdev,
 				      struct sg_iovec *iov, int iov_count,
 				      int write_to_vm)
 {
@@ -696,7 +695,6 @@ static struct bio *__bio_map_user_iov(struct request_queue *q,
 	if (!write_to_vm)
 		bio->bi_rw |= (1 << BIO_RW);
 
-	bio->bi_bdev = bdev;
 	bio->bi_flags |= (1 << BIO_USER_MAPPED);
 	return bio;
 
@@ -715,7 +713,6 @@ static struct bio *__bio_map_user_iov(struct request_queue *q,
 /**
  *	bio_map_user	-	map user address into bio
  *	@q: the struct request_queue for the bio
- *	@bdev: destination block device
  *	@uaddr: start of user address
  *	@len: length in bytes
  *	@write_to_vm: bool indicating writing to pages or not
@@ -723,21 +720,20 @@ static struct bio *__bio_map_user_iov(struct request_queue *q,
  *	Map the user space address into a bio suitable for io to a block
  *	device. Returns an error pointer in case of error.
  */
-struct bio *bio_map_user(struct request_queue *q, struct block_device *bdev,
-			 unsigned long uaddr, unsigned int len, int write_to_vm)
+struct bio *bio_map_user(struct request_queue *q, unsigned long uaddr,
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
  *	@q: the struct request_queue for the bio
- *	@bdev: destination block device
  *	@iov:	the iovec.
  *	@iov_count: number of elements in the iovec
  *	@write_to_vm: bool indicating writing to pages or not
@@ -745,13 +741,12 @@ struct bio *bio_map_user(struct request_queue *q, struct block_device *bdev,
  *	Map the user space address into a bio suitable for io to a block
  *	device. Returns an error pointer in case of error.
  */
-struct bio *bio_map_user_iov(struct request_queue *q, struct block_device *bdev,
-			     struct sg_iovec *iov, int iov_count,
-			     int write_to_vm)
+struct bio *bio_map_user_iov(struct request_queue *q, struct sg_iovec *iov,
+			     int iov_count, int write_to_vm)
 {
 	struct bio *bio;
 
-	bio = __bio_map_user_iov(q, bdev, iov, iov_count, write_to_vm);
+	bio = __bio_map_user_iov(q, iov, iov_count, write_to_vm);
 
 	if (IS_ERR(bio))
 		return bio;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 4da4413..b76eb77 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -315,11 +315,10 @@ extern int bio_add_page(struct bio *, struct page *, unsigned int,unsigned int);
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
1.5.1.2
