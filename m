From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH-v2 16/16] target/iblock: Convert to inline bio/bvec + blk_poll
Date: Tue,  7 Jun 2016 04:12:41 +0000
Message-ID: <1465272761-26045-17-git-send-email-nab@linux-iscsi.org>
References: <1465272761-26045-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1465272761-26045-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, Martin Petersen <martin.petersen@oracle.com>, Sagi Grimberg <sagi@grimberg.me>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Dave B Minturn <dave.b.minturn@intel.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts IBLOCK to use inline_bio and inline_bvec
as part of target_iostate, and converts iblock_execute_rw()
and iblock_execute_write_same() accordingly.

Also, it follows nvme-target/io-cmd code and uses blk_poll()
for both cases with submit_bio() cookie.

Cc: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_iblock.c | 118 +++++++++++++-----------------------
 include/target/target_core_base.h   |   4 ++
 2 files changed, 47 insertions(+), 75 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index b898dd7..f84c151 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -304,32 +304,21 @@ static void iblock_bio_done(struct bio *bio)
 		smp_mb__after_atomic();
 	}
 
-	bio_put(bio);
+	if (bio != &ios->inline_bio)
+		bio_put(bio);
 
 	iblock_complete_cmd(ios);
 }
 
-
-
 static struct bio *
-iblock_get_bio(struct target_iostate *ios, sector_t lba, u32 sg_num)
+iblock_get_bio(struct target_iostate *ios, sector_t lba)
 {
 	struct iblock_dev *ib_dev = IBLOCK_DEV(ios->se_dev);
-	struct bio *bio;
-
-	/*
-	 * Only allocate as many vector entries as the bio code allows us to,
-	 * we'll loop later on until we have handled the whole request.
-	 */
-	if (sg_num > BIO_MAX_PAGES)
-		sg_num = BIO_MAX_PAGES;
-
-	bio = bio_alloc_bioset(GFP_NOIO, sg_num, ib_dev->ibd_bio_set);
-	if (!bio) {
-		pr_err("Unable to allocate memory for bio\n");
-		return NULL;
-	}
+	struct bio *bio = &ios->inline_bio;
 
+	bio_init(bio);
+	bio->bi_max_vecs = IOS_MAX_INLINE_BIOVEC;
+	bio->bi_io_vec = ios->inline_bvec;
 	bio->bi_bdev = ib_dev->ibd_bd;
 	bio->bi_private = ios;
 	bio->bi_end_io = &iblock_bio_done;
@@ -338,17 +327,6 @@ iblock_get_bio(struct target_iostate *ios, sector_t lba, u32 sg_num)
 	return bio;
 }
 
-static void iblock_submit_bios(struct bio_list *list, int rw)
-{
-	struct blk_plug plug;
-	struct bio *bio;
-
-	blk_start_plug(&plug);
-	while ((bio = bio_list_pop(list)))
-		submit_bio(rw, bio);
-	blk_finish_plug(&plug);
-}
-
 static void iblock_end_io_flush(struct bio *bio)
 {
 	struct target_iostate *ios = bio->bi_private;
@@ -450,13 +428,14 @@ iblock_execute_write_same(struct target_iostate *ios,
 {
 	struct target_iomem *iomem = ios->iomem;
 	struct block_device *bdev = IBLOCK_DEV(ios->se_dev)->ibd_bd;
+	struct request_queue *q = bdev_get_queue(bdev);
 	struct scatterlist *sg;
 	struct bio *bio;
-	struct bio_list list;
 	struct se_device *dev = ios->se_dev;
 	sector_t block_lba = target_to_linux_sector(dev, ios->t_task_lba);
 	sector_t num_blocks = get_sectors(ios);
 	sector_t sectors = target_to_linux_sector(dev, num_blocks);
+	blk_qc_t cookie;
 
 	if (ios->prot_op) {
 		pr_err("WRITE_SAME: Protection information with IBLOCK"
@@ -477,25 +456,23 @@ iblock_execute_write_same(struct target_iostate *ios,
 		return iblock_execute_write_same_direct(bdev, ios, iomem,
 							num_blocks);
 
-	bio = iblock_get_bio(ios, block_lba, 1);
+	bio = iblock_get_bio(ios, block_lba);
 	if (!bio)
 		goto fail;
 
-	bio_list_init(&list);
-	bio_list_add(&list, bio);
-
 	atomic_set(&ios->backend_pending, 1);
 
 	while (sectors) {
 		while (bio_add_page(bio, sg_page(sg), sg->length, sg->offset)
 				!= sg->length) {
+			struct bio *prev = bio;
 
-			bio = iblock_get_bio(ios, block_lba, 1);
-			if (!bio)
-				goto fail_put_bios;
+			bio = bio_alloc(GFP_KERNEL, 1);
+			bio->bi_bdev = bdev;
+			bio->bi_iter.bi_sector = block_lba;
 
-			atomic_inc(&ios->backend_pending);
-			bio_list_add(&list, bio);
+			bio_chain(bio, prev);
+			cookie = submit_bio(WRITE, prev);
 		}
 
 		/* Always in 512 byte units for Linux/Block */
@@ -503,12 +480,11 @@ iblock_execute_write_same(struct target_iostate *ios,
 		sectors -= 1;
 	}
 
-	iblock_submit_bios(&list, WRITE);
+	cookie = submit_bio(WRITE, bio);
+	blk_poll(q, cookie);
+
 	return 0;
 
-fail_put_bios:
-	while ((bio = bio_list_pop(&list)))
-		bio_put(bio);
 fail:
 	return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 }
@@ -669,18 +645,15 @@ iblock_execute_rw(struct target_iostate *ios, struct scatterlist *sgl, u32 sgl_n
 		  void (*t_comp_func)(struct target_iostate *ios, u16))
 {
 	struct se_device *dev = ios->se_dev;
+	struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
+	struct request_queue *q = bdev_get_queue(ib_dev->ibd_bd);
 	sector_t block_lba = target_to_linux_sector(dev, ios->t_task_lba);
-	struct bio *bio, *bio_start;
-	struct bio_list list;
+	struct bio *bio;
 	struct scatterlist *sg;
-	u32 sg_num = sgl_nents;
-	unsigned bio_cnt;
-	int rw = 0;
-	int i;
+	blk_qc_t cookie;
+	int sg_num = sgl_nents, rw = 0, i;
 
 	if (data_direction == DMA_TO_DEVICE) {
-		struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
-		struct request_queue *q = bdev_get_queue(ib_dev->ibd_bd);
 		/*
 		 * Force writethrough using WRITE_FUA if a volatile write cache
 		 * is not enabled, or if initiator set the Force Unit Access bit.
@@ -705,16 +678,17 @@ iblock_execute_rw(struct target_iostate *ios, struct scatterlist *sgl, u32 sgl_n
 		return 0;
 	}
 
-	bio = iblock_get_bio(ios, block_lba, sgl_nents);
+	bio = iblock_get_bio(ios, block_lba);
 	if (!bio)
 		goto fail;
 
-	bio_start = bio;
-	bio_list_init(&list);
-	bio_list_add(&list, bio);
-
 	atomic_set(&ios->backend_pending, 2);
-	bio_cnt = 1;
+
+	if (ios->prot_type && dev->dev_attrib.pi_prot_type) {
+		int rc = iblock_alloc_bip(ios, ios->iomem, bio);
+		if (rc)
+			goto fail_put_bios;
+	}
 
 	for_each_sg(sgl, sg, sgl_nents, i) {
 		/*
@@ -724,18 +698,14 @@ iblock_execute_rw(struct target_iostate *ios, struct scatterlist *sgl, u32 sgl_n
 		 */
 		while (bio_add_page(bio, sg_page(sg), sg->length, sg->offset)
 				!= sg->length) {
-			if (bio_cnt >= IBLOCK_MAX_BIO_PER_TASK) {
-				iblock_submit_bios(&list, rw);
-				bio_cnt = 0;
-			}
+			struct bio *prev = bio;
 
-			bio = iblock_get_bio(ios, block_lba, sg_num);
-			if (!bio)
-				goto fail_put_bios;
+			bio = bio_alloc(GFP_KERNEL, min(sg_num, BIO_MAX_PAGES));
+			bio->bi_bdev = ib_dev->ibd_bd;
+			bio->bi_iter.bi_sector = block_lba;
 
-			atomic_inc(&ios->backend_pending);
-			bio_list_add(&list, bio);
-			bio_cnt++;
+			bio_chain(bio, prev);
+			cookie = submit_bio(rw, prev);
 		}
 
 		/* Always in 512 byte units for Linux/Block */
@@ -743,19 +713,17 @@ iblock_execute_rw(struct target_iostate *ios, struct scatterlist *sgl, u32 sgl_n
 		sg_num--;
 	}
 
-	if (ios->prot_type && dev->dev_attrib.pi_prot_type) {
-		int rc = iblock_alloc_bip(ios, ios->iomem, bio_start);
-		if (rc)
-			goto fail_put_bios;
-	}
+	cookie = submit_bio(rw, bio);
+	blk_poll(q, cookie);
 
-	iblock_submit_bios(&list, rw);
 	iblock_complete_cmd(ios);
 	return 0;
 
 fail_put_bios:
-	while ((bio = bio_list_pop(&list)))
-		bio_put(bio);
+	bio->bi_error = -EIO;
+	bio_endio(bio);
+	iblock_complete_cmd(ios);
+	return 0;
 fail:
 	return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 }
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 60a180f..2083340 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -449,6 +449,8 @@ struct target_iomem {
 	unsigned int		t_prot_nents;
 };
 
+#define IOS_MAX_INLINE_BIOVEC		8
+
 struct target_iostate {
 	unsigned long long	t_task_lba;
 	unsigned int		t_task_nolb;
@@ -473,6 +475,8 @@ struct target_iostate {
 	/* Used by IBLOCK for BIO submission + completion */
 	atomic_t		backend_pending;
 	atomic_t		backend_err_cnt;
+	struct bio		inline_bio;
+	struct bio_vec		inline_bvec[IOS_MAX_INLINE_BIOVEC];
 };
 
 struct se_cmd {
-- 
1.9.1
