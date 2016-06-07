From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH-v2 10/16] target/iblock: Fold iblock_req into target_iostate
Date: Tue,  7 Jun 2016 04:12:35 +0000
Message-ID: <1465272761-26045-11-git-send-email-nab@linux-iscsi.org>
References: <1465272761-26045-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1465272761-26045-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, Martin Petersen <martin.petersen@oracle.com>, Sagi Grimberg <sagi@grimberg.me>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Dave B Minturn <dave.b.minturn@intel.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch folks the two existing iblock_req members
into target_iostate, and updates associated sbc_ops
iblock_execute_rw() iblock_execute_write_same()
callbacks.

Also, go ahead and drop target_iostate->priv now
that it's unused.

Cc: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_iblock.c | 40 ++++++++++---------------------------
 drivers/target/target_core_iblock.h |  5 -----
 include/target/target_core_base.h   |  5 ++++-
 3 files changed, 14 insertions(+), 36 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 8e90ec42..daf052d 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -277,34 +277,30 @@ static unsigned long long iblock_emulate_read_cap_with_block_size(
 
 static void iblock_complete_cmd(struct target_iostate *ios)
 {
-	struct iblock_req *ibr = ios->priv;
 	u8 status;
 
-	if (!atomic_dec_and_test(&ibr->pending))
+	if (!atomic_dec_and_test(&ios->backend_pending))
 		return;
 
-	if (atomic_read(&ibr->ib_bio_err_cnt))
+	if (atomic_read(&ios->backend_err_cnt))
 		status = SAM_STAT_CHECK_CONDITION;
 	else
 		status = SAM_STAT_GOOD;
 
 	// XXX: ios status SAM completion translation
 	ios->t_comp_func(ios, status);
-
-	kfree(ibr);
 }
 
 static void iblock_bio_done(struct bio *bio)
 {
 	struct target_iostate *ios = bio->bi_private;
-	struct iblock_req *ibr = ios->priv;
 
 	if (bio->bi_error) {
 		pr_err("bio error: %p,  err: %d\n", bio, bio->bi_error);
 		/*
 		 * Bump the ib_bio_err_cnt and release bio.
 		 */
-		atomic_inc(&ibr->ib_bio_err_cnt);
+		atomic_inc(&ios->backend_err_cnt);
 		smp_mb__after_atomic();
 	}
 
@@ -453,7 +449,6 @@ iblock_execute_write_same(struct se_cmd *cmd)
 {
 	struct target_iostate *ios = &cmd->t_iostate;
 	struct block_device *bdev = IBLOCK_DEV(cmd->se_dev)->ibd_bd;
-	struct iblock_req *ibr;
 	struct scatterlist *sg;
 	struct bio *bio;
 	struct bio_list list;
@@ -480,19 +475,14 @@ iblock_execute_write_same(struct se_cmd *cmd)
 	if (bdev_write_same(bdev))
 		return iblock_execute_write_same_direct(bdev, cmd);
 
-	ibr = kzalloc(sizeof(struct iblock_req), GFP_KERNEL);
-	if (!ibr)
-		goto fail;
-	ios->priv = ibr;
-
 	bio = iblock_get_bio(ios, block_lba, 1);
 	if (!bio)
-		goto fail_free_ibr;
+		goto fail;
 
 	bio_list_init(&list);
 	bio_list_add(&list, bio);
 
-	atomic_set(&ibr->pending, 1);
+	atomic_set(&ios->backend_pending, 1);
 
 	while (sectors) {
 		while (bio_add_page(bio, sg_page(sg), sg->length, sg->offset)
@@ -502,7 +492,7 @@ iblock_execute_write_same(struct se_cmd *cmd)
 			if (!bio)
 				goto fail_put_bios;
 
-			atomic_inc(&ibr->pending);
+			atomic_inc(&ios->backend_pending);
 			bio_list_add(&list, bio);
 		}
 
@@ -517,8 +507,6 @@ iblock_execute_write_same(struct se_cmd *cmd)
 fail_put_bios:
 	while ((bio = bio_list_pop(&list)))
 		bio_put(bio);
-fail_free_ibr:
-	kfree(ibr);
 fail:
 	return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 }
@@ -680,7 +668,6 @@ iblock_execute_rw(struct target_iostate *ios, struct scatterlist *sgl, u32 sgl_n
 {
 	struct se_device *dev = ios->se_dev;
 	sector_t block_lba = target_to_linux_sector(dev, ios->t_task_lba);
-	struct iblock_req *ibr;
 	struct bio *bio, *bio_start;
 	struct bio_list list;
 	struct scatterlist *sg;
@@ -710,26 +697,21 @@ iblock_execute_rw(struct target_iostate *ios, struct scatterlist *sgl, u32 sgl_n
 		rw = READ;
 	}
 
-	ibr = kzalloc(sizeof(struct iblock_req), GFP_KERNEL);
-	if (!ibr)
-		goto fail;
-	ios->priv = ibr;
-
 	if (!sgl_nents) {
-		atomic_set(&ibr->pending, 1);
+		atomic_set(&ios->backend_pending, 1);
 		iblock_complete_cmd(ios);
 		return 0;
 	}
 
 	bio = iblock_get_bio(ios, block_lba, sgl_nents);
 	if (!bio)
-		goto fail_free_ibr;
+		goto fail;
 
 	bio_start = bio;
 	bio_list_init(&list);
 	bio_list_add(&list, bio);
 
-	atomic_set(&ibr->pending, 2);
+	atomic_set(&ios->backend_pending, 2);
 	bio_cnt = 1;
 
 	for_each_sg(sgl, sg, sgl_nents, i) {
@@ -749,7 +731,7 @@ iblock_execute_rw(struct target_iostate *ios, struct scatterlist *sgl, u32 sgl_n
 			if (!bio)
 				goto fail_put_bios;
 
-			atomic_inc(&ibr->pending);
+			atomic_inc(&ios->backend_pending);
 			bio_list_add(&list, bio);
 			bio_cnt++;
 		}
@@ -772,8 +754,6 @@ iblock_execute_rw(struct target_iostate *ios, struct scatterlist *sgl, u32 sgl_n
 fail_put_bios:
 	while ((bio = bio_list_pop(&list)))
 		bio_put(bio);
-fail_free_ibr:
-	kfree(ibr);
 fail:
 	return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 }
diff --git a/drivers/target/target_core_iblock.h b/drivers/target/target_core_iblock.h
index 01c2afd..ef7f91c 100644
--- a/drivers/target/target_core_iblock.h
+++ b/drivers/target/target_core_iblock.h
@@ -6,11 +6,6 @@
 #define IBLOCK_MAX_CDBS		16
 #define IBLOCK_LBA_SHIFT	9
 
-struct iblock_req {
-	atomic_t pending;
-	atomic_t ib_bio_err_cnt;
-} ____cacheline_aligned;
-
 #define IBDF_HAS_UDEV_PATH		0x01
 
 struct iblock_dev {
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 9bd7559..60a180f 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -469,7 +469,10 @@ struct target_iostate {
 	struct target_iomem	*iomem;
 	struct se_device	*se_dev;
 	void			(*t_comp_func)(struct target_iostate *, u16);
-	void			*priv;
+
+	/* Used by IBLOCK for BIO submission + completion */
+	atomic_t		backend_pending;
+	atomic_t		backend_err_cnt;
 };
 
 struct se_cmd {
-- 
1.9.1
