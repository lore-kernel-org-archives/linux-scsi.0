From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH-v2 15/16] target/sbc: Convert ->execute_unmap to __blkdev_issue_discard
Date: Tue,  7 Jun 2016 04:12:40 +0000
Message-ID: <1465272761-26045-16-git-send-email-nab@linux-iscsi.org>
References: <1465272761-26045-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1465272761-26045-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, Martin Petersen <martin.petersen@oracle.com>, Sagi Grimberg <sagi@grimberg.me>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Dave B Minturn <dave.b.minturn@intel.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

As prep for nvme-target, this patch converts sbc_ops->execute_unmap()
usage in existing target_core_sbc.c, IBLOCK and FILEIO backend
drivers to use __blkdev_issue_discard() with async completion.

Also, propigate struct bio ** as a new sbc_ops->execute_unmap()
parameter.

Cc: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_file.c    |  8 +++---
 drivers/target/target_core_iblock.c  |  8 +++---
 drivers/target/target_core_sbc.c     | 47 ++++++++++++++++++++++++++++++------
 include/target/target_core_backend.h |  2 +-
 4 files changed, 51 insertions(+), 14 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 6f0064e..81882ef 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -462,7 +462,8 @@ fd_do_prot_unmap(struct se_device *dev, sector_t lba, sector_t nolb)
 }
 
 static sense_reason_t
-fd_execute_unmap(struct target_iostate *ios, sector_t lba, sector_t nolb)
+fd_execute_unmap(struct target_iostate *ios, sector_t lba, sector_t nolb,
+		 struct bio **bio)
 {
 	struct se_device *dev = ios->se_dev;
 	struct file *file = FD_DEV(dev)->fd_file;
@@ -479,10 +480,11 @@ fd_execute_unmap(struct target_iostate *ios, sector_t lba, sector_t nolb)
 		/* The backend is block device, use discard */
 		struct block_device *bdev = inode->i_bdev;
 
-		ret = blkdev_issue_discard(bdev,
+		ret = __blkdev_issue_discard(bdev,
 					   target_to_linux_sector(dev, lba),
 					   target_to_linux_sector(dev, nolb),
-					   GFP_KERNEL, 0);
+					   GFP_KERNEL, REQ_WRITE | REQ_DISCARD,
+					   bio);
 		if (ret < 0) {
 			pr_warn("FILEIO: blkdev_issue_discard() failed: %d\n",
 				ret);
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 29d3167..b898dd7 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -393,16 +393,18 @@ iblock_execute_sync_cache(struct target_iostate *ios, bool immed)
 }
 
 static sense_reason_t
-iblock_execute_unmap(struct target_iostate *ios, sector_t lba, sector_t nolb)
+iblock_execute_unmap(struct target_iostate *ios, sector_t lba, sector_t nolb,
+		     struct bio **bio)
 {
 	struct block_device *bdev = IBLOCK_DEV(ios->se_dev)->ibd_bd;
 	struct se_device *dev = ios->se_dev;
 	int ret;
 
-	ret = blkdev_issue_discard(bdev,
+	ret = __blkdev_issue_discard(bdev,
 				   target_to_linux_sector(dev, lba),
 				   target_to_linux_sector(dev, nolb),
-				   GFP_KERNEL, 0);
+				   GFP_KERNEL, REQ_WRITE | REQ_DISCARD,
+				   bio);
 	if (ret < 0) {
 		pr_err("blkdev_issue_discard() failed: %d\n", ret);
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 4fcbe8c..2ea656d 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -221,22 +221,54 @@ sector_t sbc_get_write_same_sectors(struct target_iostate *ios)
 }
 EXPORT_SYMBOL(sbc_get_write_same_sectors);
 
+static void sbc_discard_bio_done(struct bio *bio)
+{
+	struct se_cmd *cmd = bio->bi_private;
+	int err = bio->bi_error;
+
+	bio_put(bio);
+	target_complete_cmd(cmd, (err) ? SAM_STAT_CHECK_CONDITION :
+			    SAM_STAT_GOOD);
+}
+
+static void
+sbc_execute_discard_bio(struct se_cmd *cmd, struct bio *bio,
+		        sense_reason_t *status)
+{
+	if (bio) {
+		bio->bi_private = cmd;
+		bio->bi_end_io = sbc_discard_bio_done;
+		if (status) {
+			bio->bi_error = -EIO;
+			bio_endio(bio);
+		} else {
+			submit_bio(REQ_WRITE | REQ_DISCARD, bio);
+                }
+        } else {
+                if (!status)
+                        target_complete_cmd(cmd, GOOD);
+        }
+}
+
 static sense_reason_t
 sbc_execute_write_same_unmap(struct target_iostate *ios)
 {
 	struct se_cmd *cmd = container_of(ios, struct se_cmd, t_iostate);
 	struct sbc_ops *ops = cmd->protocol_data;
+	struct bio *bio = NULL;
 	sector_t nolb = sbc_get_write_same_sectors(ios);
-	sense_reason_t ret;
+	sense_reason_t ret = TCM_NO_SENSE;
 
 	if (nolb) {
-		ret = ops->execute_unmap(&cmd->t_iostate, cmd->t_iostate.t_task_lba, nolb);
+		ret = ops->execute_unmap(&cmd->t_iostate, cmd->t_iostate.t_task_lba,
+					 nolb, &bio);
 		if (ret)
 			return ret;
 	}
 
-	target_complete_cmd(cmd, GOOD);
-	return 0;
+
+	sbc_execute_discard_bio(cmd, bio, &ret);
+	return ret;
 }
 
 static sense_reason_t
@@ -1198,6 +1230,7 @@ sbc_execute_unmap(struct target_iostate *ios)
 	struct se_cmd *cmd = container_of(ios, struct se_cmd, t_iostate);
 	struct sbc_ops *ops = cmd->protocol_data;
 	struct se_device *dev = cmd->se_dev;
+	struct bio *bio = NULL;
 	unsigned char *buf, *ptr = NULL;
 	sector_t lba;
 	int size;
@@ -1260,7 +1293,7 @@ sbc_execute_unmap(struct target_iostate *ios)
 			goto err;
 		}
 
-		ret = ops->execute_unmap(ios, lba, range);
+		ret = ops->execute_unmap(ios, lba, range, &bio);
 		if (ret)
 			goto err;
 
@@ -1270,8 +1303,8 @@ sbc_execute_unmap(struct target_iostate *ios)
 
 err:
 	transport_kunmap_data_sg(cmd);
-	if (!ret)
-		target_complete_cmd(cmd, GOOD);
+
+	sbc_execute_discard_bio(cmd, bio, &ret);
 	return ret;
 }
 
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index 15f731f..4a9aca6 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -56,7 +56,7 @@ struct sbc_ops {
 	sense_reason_t (*execute_write_same)(struct target_iostate *ios,
 					sector_t (*get_sectors)(struct target_iostate *));
 	sense_reason_t (*execute_unmap)(struct target_iostate *ios,
-					sector_t lba, sector_t nolb);
+					sector_t lba, sector_t nolb, struct bio **bio);
 };
 
 int	transport_backend_register(const struct target_backend_ops *);
-- 
1.9.1
