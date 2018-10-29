From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 13/14] block: add REQ_HIPRI and inherit it from IOCB_HIPRI
Date: Mon, 29 Oct 2018 10:37:37 -0600
Message-ID: <20181029163738.10172-14-axboe@kernel.dk>
References: <20181029163738.10172-1-axboe@kernel.dk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181029163738.10172-1-axboe@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

We use IOCB_HIPRI to poll for IO in the caller instead of scheduling.
This information is not available for (or after) IO submission. The
driver may make different queue choices based on the type of IO, so
make the fact that we will poll for this IO known to the lower layers
as well.

Reviewed-by: Hannes Reinecke <hare@suse.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/block_dev.c            | 2 ++
 fs/direct-io.c            | 2 ++
 fs/iomap.c                | 9 ++++++++-
 include/linux/blk_types.h | 4 +++-
 4 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 38b8ce05cbc7..8bb8090c57a7 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -232,6 +232,8 @@ __blkdev_direct_IO_simple(struct kiocb *iocb, struct iov_iter *iter,
 		bio.bi_opf = dio_bio_write_op(iocb);
 		task_io_account_write(ret);
 	}
+	if (iocb->ki_flags & IOCB_HIPRI)
+		bio.bi_opf |= REQ_HIPRI;
 
 	qc = submit_bio(&bio);
 	for (;;) {
diff --git a/fs/direct-io.c b/fs/direct-io.c
index 093fb54cd316..ffb46b7aa5f7 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -1265,6 +1265,8 @@ do_blockdev_direct_IO(struct kiocb *iocb, struct inode *inode,
 	} else {
 		dio->op = REQ_OP_READ;
 	}
+	if (iocb->ki_flags & IOCB_HIPRI)
+		dio->op_flags |= REQ_HIPRI;
 
 	/*
 	 * For AIO O_(D)SYNC writes we need to defer completions to a workqueue
diff --git a/fs/iomap.c b/fs/iomap.c
index ec15cf2ec696..50ad8c8d1dcb 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -1554,6 +1554,7 @@ iomap_dio_zero(struct iomap_dio *dio, struct iomap *iomap, loff_t pos,
 		unsigned len)
 {
 	struct page *page = ZERO_PAGE(0);
+	int flags = REQ_SYNC | REQ_IDLE;
 	struct bio *bio;
 
 	bio = bio_alloc(GFP_KERNEL, 1);
@@ -1562,9 +1563,12 @@ iomap_dio_zero(struct iomap_dio *dio, struct iomap *iomap, loff_t pos,
 	bio->bi_private = dio;
 	bio->bi_end_io = iomap_dio_bio_end_io;
 
+	if (dio->iocb->ki_flags & IOCB_HIPRI)
+		flags |= REQ_HIPRI;
+
 	get_page(page);
 	__bio_add_page(bio, page, len, 0);
-	bio_set_op_attrs(bio, REQ_OP_WRITE, REQ_SYNC | REQ_IDLE);
+	bio_set_op_attrs(bio, REQ_OP_WRITE, flags);
 
 	atomic_inc(&dio->ref);
 	return submit_bio(bio);
@@ -1663,6 +1667,9 @@ iomap_dio_bio_actor(struct inode *inode, loff_t pos, loff_t length,
 				bio_set_pages_dirty(bio);
 		}
 
+		if (dio->iocb->ki_flags & IOCB_HIPRI)
+			bio->bi_opf |= REQ_HIPRI;
+
 		iov_iter_advance(dio->submit.iter, n);
 
 		dio->size += n;
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 093a818c5b68..d6c2558d6b73 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -322,6 +322,8 @@ enum req_flag_bits {
 	/* command specific flags for REQ_OP_WRITE_ZEROES: */
 	__REQ_NOUNMAP,		/* do not free blocks when zeroing */
 
+	__REQ_HIPRI,
+
 	/* for driver use */
 	__REQ_DRV,
 	__REQ_SWAP,		/* swapping request. */
@@ -342,8 +344,8 @@ enum req_flag_bits {
 #define REQ_RAHEAD		(1ULL << __REQ_RAHEAD)
 #define REQ_BACKGROUND		(1ULL << __REQ_BACKGROUND)
 #define REQ_NOWAIT		(1ULL << __REQ_NOWAIT)
-
 #define REQ_NOUNMAP		(1ULL << __REQ_NOUNMAP)
+#define REQ_HIPRI		(1ULL << __REQ_HIPRI)
 
 #define REQ_DRV			(1ULL << __REQ_DRV)
 #define REQ_SWAP		(1ULL << __REQ_SWAP)
-- 
2.17.1
