From: michaelc@cs.wisc.edu
Subject: [PATCH 2/5] block: add function to issue compare and write
Date: Thu, 16 Oct 2014 00:37:12 -0500
Message-ID: <1413437835-13778-3-git-send-email-michaelc@cs.wisc.edu>
References: <1413437835-13778-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:39636 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789AbaJPFha (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Oct 2014 01:37:30 -0400
In-Reply-To: <1413437835-13778-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, ceph-devel@vger.kernel.org, axboe@kernel.dk

From: Mike Christie <michaelc@cs.wisc.edu>

This patch adds block layer helpers to send a compare and write request.
It differs from requests like discard and write same in that there is a
setup function and a issue one. I did this to allow callers add multiple
pages with variying offsets and lengths.

For the miscompare failure case I am currently having drivers return
-ECANCELED, but was not sure if there is a better return code.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 block/blk-lib.c           |   79 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/blk_types.h |    6 ++-
 include/linux/blkdev.h    |    6 +++
 3 files changed, 89 insertions(+), 2 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 8411be3..fbb1a91 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -141,6 +141,85 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 }
 EXPORT_SYMBOL(blkdev_issue_discard);
 
+struct bio_cmp_and_write_data {
+	int			err;
+	struct completion	*wait;
+};
+
+static void bio_cmp_and_write_end_io(struct bio *bio, int err)
+{
+	struct bio_cmp_and_write_data *data = bio->bi_private;
+
+	data->err = err;
+	complete(data->wait);
+	bio_put(bio);
+}
+
+/**
+ * blkdev_setup_cmp_and_write - setup a bio for a compare and write operation
+ * @bdev:	blockdev to issue discard for
+ * @sector:	start sector
+ * @gfp_mask:	memory allocation flags (for bio_alloc)
+ * @nr_pages:	number of pages that contain the data to be written and compared
+ *
+ * This function should be called to allocate the bio used for
+ * blkdev_issue_cmp_and_write. The caller should add the pages to be compared
+ * followed by the write pages using bio_add_pc_page.
+ */
+struct bio *blkdev_setup_cmp_and_write(struct block_device *bdev,
+				       sector_t sector, gfp_t gfp_mask,
+				       int nr_pages)
+{
+	struct bio *bio;
+
+	bio = bio_alloc(gfp_mask, nr_pages);
+	if (!bio)
+		return NULL;
+
+	bio->bi_iter.bi_sector = sector;
+	bio->bi_end_io = bio_cmp_and_write_end_io;
+	bio->bi_bdev = bdev;
+	return bio;
+}
+EXPORT_SYMBOL(blkdev_setup_cmp_and_write);
+
+/**
+ * blkdev_issue_cmp_and_write - queue a compare and write operation
+ * @bio:	bio prepd with blkdev_setup_cmp_and_write.
+ * Description:
+ *    Issue a compare and write bio for the sectors in question. For the
+ *    execution of this request the handler should atomically read @nr_sects
+ *    from starting sector @sector, compare them, and if matched write
+ *    @nr_sects to @sector.
+ *
+ *    If the compare fails and data is not written the handler should return
+ *    -ECANCELED.
+ */
+int blkdev_issue_cmp_and_write(struct bio *bio)
+{
+	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
+	DECLARE_COMPLETION_ONSTACK(wait);
+	struct bio_cmp_and_write_data data;
+	unsigned int max_cmp_and_write_sectors;
+
+	max_cmp_and_write_sectors = q->limits.max_cmp_and_write_sectors;
+	if (max_cmp_and_write_sectors == 0)
+		return -EOPNOTSUPP;
+
+	if (max_cmp_and_write_sectors < bio->bi_iter.bi_size >> 9)
+		return -EINVAL;
+
+	data.err = 0;
+	data.wait = &wait;
+	bio->bi_private = &data;
+
+	submit_bio(REQ_WRITE | REQ_CMP_AND_WRITE, bio);
+	/* Wait for bio in-flight */
+	wait_for_completion_io(&wait);
+	return data.err;
+}
+EXPORT_SYMBOL(blkdev_issue_cmp_and_write);
+
 /**
  * blkdev_issue_write_same - queue a write same operation
  * @bdev:	target blockdev
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 66c2167..37d1eff 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -160,7 +160,7 @@ enum rq_flag_bits {
 	__REQ_DISCARD,		/* request to discard sectors */
 	__REQ_SECURE,		/* secure discard (used with __REQ_DISCARD) */
 	__REQ_WRITE_SAME,	/* write same block many times */
-
+	__REQ_CMP_AND_WRITE,	/* compare data and write if matched */
 	__REQ_NOIDLE,		/* don't anticipate more IO after this one */
 	__REQ_FUA,		/* forced unit access */
 	__REQ_FLUSH,		/* request for cache flush */
@@ -203,14 +203,16 @@ enum rq_flag_bits {
 #define REQ_PRIO		(1ULL << __REQ_PRIO)
 #define REQ_DISCARD		(1ULL << __REQ_DISCARD)
 #define REQ_WRITE_SAME		(1ULL << __REQ_WRITE_SAME)
+#define REQ_CMP_AND_WRITE	(1ULL << __REQ_CMP_AND_WRITE)
 #define REQ_NOIDLE		(1ULL << __REQ_NOIDLE)
 
+
 #define REQ_FAILFAST_MASK \
 	(REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER)
 #define REQ_COMMON_MASK \
 	(REQ_WRITE | REQ_FAILFAST_MASK | REQ_SYNC | REQ_META | REQ_PRIO | \
 	 REQ_DISCARD | REQ_WRITE_SAME | REQ_NOIDLE | REQ_FLUSH | REQ_FUA | \
-	 REQ_SECURE)
+	 REQ_SECURE | REQ_CMP_AND_WRITE)
 #define REQ_CLONE_MASK		REQ_COMMON_MASK
 
 #define BIO_NO_ADVANCE_ITER_MASK	(REQ_DISCARD|REQ_WRITE_SAME)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 6d03206..746d5b4 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -696,6 +696,9 @@ static inline bool blk_check_merge_flags(unsigned int flags1,
 	if ((flags1 & REQ_WRITE_SAME) != (flags2 & REQ_WRITE_SAME))
 		return false;
 
+	if (flags1 & REQ_CMP_AND_WRITE || flags2 & REQ_CMP_AND_WRITE)
+		return false;
+
 	return true;
 }
 
@@ -1167,6 +1170,9 @@ static inline struct request *blk_map_queue_find_tag(struct blk_queue_tag *bqt,
 
 #define BLKDEV_DISCARD_SECURE  0x01    /* secure discard */
 
+extern struct bio *blkdev_setup_cmp_and_write(struct block_device *, sector_t,
+		gfp_t, int);
+extern int blkdev_issue_cmp_and_write(struct bio *bio);
 extern int blkdev_issue_flush(struct block_device *, gfp_t, sector_t *);
 extern int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, unsigned long flags);
-- 
1.7.1

