From: =?UTF-8?q?Matias=20Bj=C3=B8rling?= <mb@lightnvm.io>
Subject: [PATCH 4/4] dm: add zone open, close and finish support
Date: Fri, 21 Jun 2019 15:07:11 +0200
Message-ID: <20190621130711.21986-5-mb@lightnvm.io>
References: <20190621130711.21986-1-mb@lightnvm.io>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190621130711.21986-1-mb@lightnvm.io>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@fb.com, hch@lst.de, damien.lemoal@wdc.com, chaitanya.kulkarni@wdc.com, dmitry.fomichev@wdc.com, ajay.joshi@wdc.com, aravind.ramesh@wdc.com, martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, agk@redhat.com, snitzer@redhat.com
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

From: Ajay Joshi <ajay.joshi@wdc.com>

Implement REQ_OP_ZONE_OPEN, REQ_OP_ZONE_CLOSE and REQ_OP_ZONE_FINISH
support to allow explicit control of zone states.

Signed-off-by: Ajay Joshi <ajay.joshi@wdc.com>
---
 drivers/md/dm-flakey.c    | 7 +++----
 drivers/md/dm-linear.c    | 2 +-
 drivers/md/dm.c           | 5 +++--
 include/linux/blk_types.h | 8 ++++++++
 4 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index a9bc518156f2..fff529c0732c 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -280,7 +280,7 @@ static void flakey_map_bio(struct dm_target *ti, struct bio *bio)
 	struct flakey_c *fc = ti->private;
 
 	bio_set_dev(bio, fc->dev->bdev);
-	if (bio_sectors(bio) || bio_op(bio) == REQ_OP_ZONE_RESET)
+	if (bio_sectors(bio) || bio_is_zone_mgmt_op(bio))
 		bio->bi_iter.bi_sector =
 			flakey_map_sector(ti, bio->bi_iter.bi_sector);
 }
@@ -322,8 +322,7 @@ static int flakey_map(struct dm_target *ti, struct bio *bio)
 	struct per_bio_data *pb = dm_per_bio_data(bio, sizeof(struct per_bio_data));
 	pb->bio_submitted = false;
 
-	/* Do not fail reset zone */
-	if (bio_op(bio) == REQ_OP_ZONE_RESET)
+	if (bio_is_zone_mgmt_op(bio))
 		goto map_bio;
 
 	/* Are we alive ? */
@@ -384,7 +383,7 @@ static int flakey_end_io(struct dm_target *ti, struct bio *bio,
 	struct flakey_c *fc = ti->private;
 	struct per_bio_data *pb = dm_per_bio_data(bio, sizeof(struct per_bio_data));
 
-	if (bio_op(bio) == REQ_OP_ZONE_RESET)
+	if (bio_is_zone_mgmt_op(bio))
 		return DM_ENDIO_DONE;
 
 	if (!*error && pb->bio_submitted && (bio_data_dir(bio) == READ)) {
diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index ad980a38fb1e..217a1dee8197 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -90,7 +90,7 @@ static void linear_map_bio(struct dm_target *ti, struct bio *bio)
 	struct linear_c *lc = ti->private;
 
 	bio_set_dev(bio, lc->dev->bdev);
-	if (bio_sectors(bio) || bio_op(bio) == REQ_OP_ZONE_RESET)
+	if (bio_sectors(bio) || bio_is_zone_mgmt_op(bio))
 		bio->bi_iter.bi_sector =
 			linear_map_sector(ti, bio->bi_iter.bi_sector);
 }
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 5475081dcbd6..f4507ec20a57 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1176,7 +1176,8 @@ static size_t dm_dax_copy_to_iter(struct dax_device *dax_dev, pgoff_t pgoff,
 
 /*
  * A target may call dm_accept_partial_bio only from the map routine.  It is
- * allowed for all bio types except REQ_PREFLUSH and REQ_OP_ZONE_RESET.
+ * allowed for all bio types except REQ_PREFLUSH, REQ_OP_ZONE_RESET,
+ * REQ_OP_ZONE_OPEN, REQ_OP_ZONE_CLOSE and REQ_OP_ZONE_FINISH.
  *
  * dm_accept_partial_bio informs the dm that the target only wants to process
  * additional n_sectors sectors of the bio and the rest of the data should be
@@ -1629,7 +1630,7 @@ static blk_qc_t __split_and_process_bio(struct mapped_device *md,
 		ci.sector_count = 0;
 		error = __send_empty_flush(&ci);
 		/* dec_pending submits any data associated with flush */
-	} else if (bio_op(bio) == REQ_OP_ZONE_RESET) {
+	} else if (bio_is_zone_mgmt_op(bio)) {
 		ci.bio = bio;
 		ci.sector_count = 0;
 		error = __split_and_process_non_flush(&ci);
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 067ef9242275..fd2458cd1a49 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -398,6 +398,14 @@ static inline bool op_is_zone_mgmt_op(enum req_opf op)
 	}
 }
 
+/*
+ * Check if the bio is zoned operation.
+ */
+static inline bool bio_is_zone_mgmt_op(struct bio *bio)
+{
+	return op_is_zone_mgmt_op(bio_op(bio));
+}
+
 static inline bool op_is_write(unsigned int op)
 {
 	return (op & 1);
-- 
2.19.1
