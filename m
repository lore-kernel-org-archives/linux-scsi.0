From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH-v2 13/16] target/sbc: Convert sbc_ops->execute_unmap to target_iostate
Date: Tue,  7 Jun 2016 04:12:38 +0000
Message-ID: <1465272761-26045-14-git-send-email-nab@linux-iscsi.org>
References: <1465272761-26045-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1465272761-26045-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, Martin Petersen <martin.petersen@oracle.com>, Sagi Grimberg <sagi@grimberg.me>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Dave B Minturn <dave.b.minturn@intel.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts IBLOCK + FILEIO for sbc_ops->execute_unmap()
to accept struct target_iostate.

Cc: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_file.c    | 21 ++++++++++-----------
 drivers/target/target_core_iblock.c  |  8 ++++----
 drivers/target/target_core_sbc.c     |  4 ++--
 include/target/target_core_backend.h |  4 ++--
 4 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 8ddd561..b4956a5e 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -442,7 +442,7 @@ fd_do_prot_fill(struct se_device *se_dev, sector_t lba, sector_t nolb,
 }
 
 static int
-fd_do_prot_unmap(struct se_cmd *cmd, sector_t lba, sector_t nolb)
+fd_do_prot_unmap(struct se_device *dev, sector_t lba, sector_t nolb)
 {
 	void *buf;
 	int rc;
@@ -454,7 +454,7 @@ fd_do_prot_unmap(struct se_cmd *cmd, sector_t lba, sector_t nolb)
 	}
 	memset(buf, 0xff, PAGE_SIZE);
 
-	rc = fd_do_prot_fill(cmd->se_dev, lba, nolb, buf, PAGE_SIZE);
+	rc = fd_do_prot_fill(dev, lba, nolb, buf, PAGE_SIZE);
 
 	free_page((unsigned long)buf);
 
@@ -462,14 +462,15 @@ fd_do_prot_unmap(struct se_cmd *cmd, sector_t lba, sector_t nolb)
 }
 
 static sense_reason_t
-fd_execute_unmap(struct se_cmd *cmd, sector_t lba, sector_t nolb)
+fd_execute_unmap(struct target_iostate *ios, sector_t lba, sector_t nolb)
 {
-	struct file *file = FD_DEV(cmd->se_dev)->fd_file;
+	struct se_device *dev = ios->se_dev;
+	struct file *file = FD_DEV(dev)->fd_file;
 	struct inode *inode = file->f_mapping->host;
 	int ret;
 
-	if (cmd->se_dev->dev_attrib.pi_prot_type) {
-		ret = fd_do_prot_unmap(cmd, lba, nolb);
+	if (ios->se_dev->dev_attrib.pi_prot_type) {
+		ret = fd_do_prot_unmap(dev, lba, nolb);
 		if (ret)
 			return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
@@ -477,11 +478,10 @@ fd_execute_unmap(struct se_cmd *cmd, sector_t lba, sector_t nolb)
 	if (S_ISBLK(inode->i_mode)) {
 		/* The backend is block device, use discard */
 		struct block_device *bdev = inode->i_bdev;
-		struct se_device *dev = cmd->se_dev;
 
 		ret = blkdev_issue_discard(bdev,
 					   target_to_linux_sector(dev, lba),
-					   target_to_linux_sector(dev,  nolb),
+					   target_to_linux_sector(dev, nolb),
 					   GFP_KERNEL, 0);
 		if (ret < 0) {
 			pr_warn("FILEIO: blkdev_issue_discard() failed: %d\n",
@@ -490,9 +490,8 @@ fd_execute_unmap(struct se_cmd *cmd, sector_t lba, sector_t nolb)
 		}
 	} else {
 		/* The backend is normal file, use fallocate */
-		struct se_device *se_dev = cmd->se_dev;
-		loff_t pos = lba * se_dev->dev_attrib.block_size;
-		unsigned int len = nolb * se_dev->dev_attrib.block_size;
+		loff_t pos = lba * dev->dev_attrib.block_size;
+		unsigned int len = nolb * dev->dev_attrib.block_size;
 		int mode = FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE;
 
 		if (!file->f_op->fallocate)
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 9623198..00781c8 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -393,15 +393,15 @@ iblock_execute_sync_cache(struct target_iostate *ios, bool immed)
 }
 
 static sense_reason_t
-iblock_execute_unmap(struct se_cmd *cmd, sector_t lba, sector_t nolb)
+iblock_execute_unmap(struct target_iostate *ios, sector_t lba, sector_t nolb)
 {
-	struct block_device *bdev = IBLOCK_DEV(cmd->se_dev)->ibd_bd;
-	struct se_device *dev = cmd->se_dev;
+	struct block_device *bdev = IBLOCK_DEV(ios->se_dev)->ibd_bd;
+	struct se_device *dev = ios->se_dev;
 	int ret;
 
 	ret = blkdev_issue_discard(bdev,
 				   target_to_linux_sector(dev, lba),
-				   target_to_linux_sector(dev,  nolb),
+				   target_to_linux_sector(dev, nolb),
 				   GFP_KERNEL, 0);
 	if (ret < 0) {
 		pr_err("blkdev_issue_discard() failed: %d\n", ret);
diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index a92f169..4fcbe8c 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -230,7 +230,7 @@ sbc_execute_write_same_unmap(struct target_iostate *ios)
 	sense_reason_t ret;
 
 	if (nolb) {
-		ret = ops->execute_unmap(cmd, cmd->t_iostate.t_task_lba, nolb);
+		ret = ops->execute_unmap(&cmd->t_iostate, cmd->t_iostate.t_task_lba, nolb);
 		if (ret)
 			return ret;
 	}
@@ -1260,7 +1260,7 @@ sbc_execute_unmap(struct target_iostate *ios)
 			goto err;
 		}
 
-		ret = ops->execute_unmap(cmd, lba, range);
+		ret = ops->execute_unmap(ios, lba, range);
 		if (ret)
 			goto err;
 
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index f845ff0..9efe718 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -51,8 +51,8 @@ struct sbc_ops {
 	sense_reason_t (*execute_sync_cache)(struct target_iostate *ios, bool immed);
 	sense_reason_t (*execute_write_same)(struct target_iostate *ios,
 					sector_t (*get_sectors)(struct target_iostate *));
-	sense_reason_t (*execute_unmap)(struct se_cmd *cmd,
-				sector_t lba, sector_t nolb);
+	sense_reason_t (*execute_unmap)(struct target_iostate *ios,
+					sector_t lba, sector_t nolb);
 };
 
 int	transport_backend_register(const struct target_backend_ops *);
-- 
1.9.1
