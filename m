From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 12/14] target/sbc: Convert sbc_ops->execute_write_same to target_iostate
Date: Wed,  1 Jun 2016 21:48:45 +0000
Message-ID: <1464817727-9125-13-git-send-email-nab@linux-iscsi.org>
References: <1464817727-9125-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1464817727-9125-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, Martin Petersen <martin.petersen@oracle.com>, Sagi Grimberg <sagi@grimberg.me>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Dave B Minturn <dave.b.minturn@intel.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts IBLOCK + FILEIO for sbc_ops->execute_write_same()
to accept struct target_iostate, and pass a new get_sectors() function
pointer used to decode a command set specific number of logical blocks
(NoLB).

Cc: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_file.c    | 32 ++++++++++++------------
 drivers/target/target_core_iblock.c  | 47 ++++++++++++++++++------------------
 drivers/target/target_core_sbc.c     |  9 ++++---
 include/target/target_core_backend.h |  4 +--
 4 files changed, 48 insertions(+), 44 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 6fc1099..8ddd561 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -353,34 +353,36 @@ fd_execute_sync_cache(struct target_iostate *ios, bool immed)
 }
 
 static sense_reason_t
-fd_execute_write_same(struct se_cmd *cmd)
+fd_execute_write_same(struct target_iostate *ios,
+		      sector_t (*get_sectors)(struct target_iostate *))
 {
-	struct se_device *se_dev = cmd->se_dev;
+	struct target_iomem *iomem = ios->iomem;
+	struct se_device *se_dev = ios->se_dev;
 	struct fd_dev *fd_dev = FD_DEV(se_dev);
-	loff_t pos = cmd->t_iostate.t_task_lba * se_dev->dev_attrib.block_size;
-	sector_t nolb = sbc_get_write_same_sectors(cmd);
+	loff_t pos = ios->t_task_lba * se_dev->dev_attrib.block_size;
+	sector_t nolb = get_sectors(ios);
 	struct iov_iter iter;
 	struct bio_vec *bvec;
 	unsigned int len = 0, i;
 	ssize_t ret;
 
 	if (!nolb) {
-		target_complete_cmd(cmd, SAM_STAT_GOOD);
+		ios->t_comp_func(ios, SAM_STAT_GOOD);
 		return 0;
 	}
-	if (cmd->t_iostate.prot_op) {
+	if (ios->prot_op) {
 		pr_err("WRITE_SAME: Protection information with FILEIO"
 		       " backends not supported\n");
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
 
-	if (cmd->t_iomem.t_data_nents > 1 ||
-	    cmd->t_iomem.t_data_sg[0].length != cmd->se_dev->dev_attrib.block_size) {
+	if (iomem->t_data_nents > 1 ||
+	    iomem->t_data_sg[0].length != se_dev->dev_attrib.block_size) {
 		pr_err("WRITE_SAME: Illegal SGL t_data_nents: %u length: %u"
 			" block_size: %u\n",
-			cmd->t_iomem.t_data_nents,
-			cmd->t_iomem.t_data_sg[0].length,
-			cmd->se_dev->dev_attrib.block_size);
+			iomem->t_data_nents,
+			iomem->t_data_sg[0].length,
+			se_dev->dev_attrib.block_size);
 		return TCM_INVALID_CDB_FIELD;
 	}
 
@@ -389,9 +391,9 @@ fd_execute_write_same(struct se_cmd *cmd)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
 	for (i = 0; i < nolb; i++) {
-		bvec[i].bv_page = sg_page(&cmd->t_iomem.t_data_sg[0]);
-		bvec[i].bv_len = cmd->t_iomem.t_data_sg[0].length;
-		bvec[i].bv_offset = cmd->t_iomem.t_data_sg[0].offset;
+		bvec[i].bv_page = sg_page(&iomem->t_data_sg[0]);
+		bvec[i].bv_len = iomem->t_data_sg[0].length;
+		bvec[i].bv_offset = iomem->t_data_sg[0].offset;
 
 		len += se_dev->dev_attrib.block_size;
 	}
@@ -405,7 +407,7 @@ fd_execute_write_same(struct se_cmd *cmd)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
 
-	target_complete_cmd(cmd, SAM_STAT_GOOD);
+	ios->t_comp_func(ios, SAM_STAT_GOOD);
 	return 0;
 }
 
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 931dd7d..9623198 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -412,10 +412,11 @@ iblock_execute_unmap(struct se_cmd *cmd, sector_t lba, sector_t nolb)
 }
 
 static sense_reason_t
-iblock_execute_write_same_direct(struct block_device *bdev, struct se_cmd *cmd)
+iblock_execute_write_same_direct(struct block_device *bdev, struct target_iostate *ios,
+				 struct target_iomem *iomem, sector_t num_blocks)
 {
-	struct se_device *dev = cmd->se_dev;
-	struct scatterlist *sg = &cmd->t_iomem.t_data_sg[0];
+	struct se_device *dev = ios->se_dev;
+	struct scatterlist *sg = &iomem->t_data_sg[0];
 	struct page *page = NULL;
 	int ret;
 
@@ -423,56 +424,56 @@ iblock_execute_write_same_direct(struct block_device *bdev, struct se_cmd *cmd)
 		page = alloc_page(GFP_KERNEL);
 		if (!page)
 			return TCM_OUT_OF_RESOURCES;
-		sg_copy_to_buffer(sg, cmd->t_iomem.t_data_nents,
+		sg_copy_to_buffer(sg, iomem->t_data_nents,
 				  page_address(page),
 				  dev->dev_attrib.block_size);
 	}
 
 	ret = blkdev_issue_write_same(bdev,
-				target_to_linux_sector(dev,
-					cmd->t_iostate.t_task_lba),
-				target_to_linux_sector(dev,
-					sbc_get_write_same_sectors(cmd)),
+				target_to_linux_sector(dev, ios->t_task_lba),
+				target_to_linux_sector(dev, num_blocks),
 				GFP_KERNEL, page ? page : sg_page(sg));
 	if (page)
 		__free_page(page);
 	if (ret)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
-	target_complete_cmd(cmd, GOOD);
+	ios->t_comp_func(ios, GOOD);
 	return 0;
 }
 
 static sense_reason_t
-iblock_execute_write_same(struct se_cmd *cmd)
+iblock_execute_write_same(struct target_iostate *ios,
+			  sector_t (*get_sectors)(struct target_iostate *))
 {
-	struct target_iostate *ios = &cmd->t_iostate;
-	struct block_device *bdev = IBLOCK_DEV(cmd->se_dev)->ibd_bd;
+	struct target_iomem *iomem = ios->iomem;
+	struct block_device *bdev = IBLOCK_DEV(ios->se_dev)->ibd_bd;
 	struct scatterlist *sg;
 	struct bio *bio;
 	struct bio_list list;
-	struct se_device *dev = cmd->se_dev;
-	sector_t block_lba = target_to_linux_sector(dev, cmd->t_iostate.t_task_lba);
-	sector_t sectors = target_to_linux_sector(dev,
-					sbc_get_write_same_sectors(cmd));
+	struct se_device *dev = ios->se_dev;
+	sector_t block_lba = target_to_linux_sector(dev, ios->t_task_lba);
+	sector_t num_blocks = get_sectors(ios);
+	sector_t sectors = target_to_linux_sector(dev, num_blocks);
 
-	if (cmd->t_iostate.prot_op) {
+	if (ios->prot_op) {
 		pr_err("WRITE_SAME: Protection information with IBLOCK"
 		       " backends not supported\n");
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
-	sg = &cmd->t_iomem.t_data_sg[0];
+	sg = &iomem->t_data_sg[0];
 
-	if (cmd->t_iomem.t_data_nents > 1 ||
-	    sg->length != cmd->se_dev->dev_attrib.block_size) {
+	if (iomem->t_data_nents > 1 ||
+	    sg->length != dev->dev_attrib.block_size) {
 		pr_err("WRITE_SAME: Illegal SGL t_data_nents: %u length: %u"
-			" block_size: %u\n", cmd->t_iomem.t_data_nents, sg->length,
-			cmd->se_dev->dev_attrib.block_size);
+			" block_size: %u\n", iomem->t_data_nents, sg->length,
+			dev->dev_attrib.block_size);
 		return TCM_INVALID_CDB_FIELD;
 	}
 
 	if (bdev_write_same(bdev))
-		return iblock_execute_write_same_direct(bdev, cmd);
+		return iblock_execute_write_same_direct(bdev, ios, iomem,
+							num_blocks);
 
 	bio = iblock_get_bio(ios, block_lba, 1);
 	if (!bio)
diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index be8dd46..a92f169 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -197,8 +197,9 @@ sbc_emulate_startstop(struct target_iostate *ios)
 	return 0;
 }
 
-sector_t sbc_get_write_same_sectors(struct se_cmd *cmd)
+sector_t sbc_get_write_same_sectors(struct target_iostate *ios)
 {
+	struct se_cmd *cmd = container_of(ios, struct se_cmd, t_iostate);
 	u32 num_blocks;
 
 	if (cmd->t_task_cdb[0] == WRITE_SAME)
@@ -225,7 +226,7 @@ sbc_execute_write_same_unmap(struct target_iostate *ios)
 {
 	struct se_cmd *cmd = container_of(ios, struct se_cmd, t_iostate);
 	struct sbc_ops *ops = cmd->protocol_data;
-	sector_t nolb = sbc_get_write_same_sectors(cmd);
+	sector_t nolb = sbc_get_write_same_sectors(ios);
 	sense_reason_t ret;
 
 	if (nolb) {
@@ -329,7 +330,7 @@ static sense_reason_t sbc_execute_write_same(struct target_iostate *ios)
 	struct se_cmd *cmd = container_of(ios, struct se_cmd, t_iostate);
 	struct sbc_ops *ops = cmd->protocol_data;
 
-	return ops->execute_write_same(cmd);
+	return ops->execute_write_same(ios, &sbc_get_write_same_sectors);
 }
 
 static sense_reason_t
@@ -337,7 +338,7 @@ sbc_setup_write_same(struct se_cmd *cmd, unsigned char *flags, struct sbc_ops *o
 {
 	struct se_device *dev = cmd->se_dev;
 	sector_t end_lba = dev->transport->get_blocks(dev) + 1;
-	unsigned int sectors = sbc_get_write_same_sectors(cmd);
+	unsigned int sectors = sbc_get_write_same_sectors(&cmd->t_iostate);
 	sense_reason_t ret;
 
 	if ((flags[0] & 0x04) || (flags[0] & 0x02)) {
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index 47fd1fc..f845ff0 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -49,7 +49,8 @@ struct sbc_ops {
 				     u32, enum dma_data_direction, bool fua_write,
 				     void (*t_comp_func)(struct target_iostate *ios, u16));
 	sense_reason_t (*execute_sync_cache)(struct target_iostate *ios, bool immed);
-	sense_reason_t (*execute_write_same)(struct se_cmd *cmd);
+	sense_reason_t (*execute_write_same)(struct target_iostate *ios,
+					sector_t (*get_sectors)(struct target_iostate *));
 	sense_reason_t (*execute_unmap)(struct se_cmd *cmd,
 				sector_t lba, sector_t nolb);
 };
@@ -69,7 +70,6 @@ sense_reason_t	spc_emulate_evpd_83(struct se_cmd *, unsigned char *);
 sense_reason_t	sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops);
 u32	sbc_get_device_rev(struct se_device *dev);
 u32	sbc_get_device_type(struct se_device *dev);
-sector_t	sbc_get_write_same_sectors(struct se_cmd *cmd);
 void	sbc_dif_generate(struct se_cmd *);
 sense_reason_t	sbc_dif_verify(struct target_iostate *, sector_t, unsigned int,
 				     unsigned int, struct scatterlist *, int);
-- 
1.9.1
