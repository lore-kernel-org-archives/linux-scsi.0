From: michaelc@cs.wisc.edu
Subject: [PATCH 5/5] lio iblock: add support for REQ_CMP_AND_WRITE
Date: Thu, 16 Oct 2014 00:37:15 -0500
Message-ID: <1413437835-13778-6-git-send-email-michaelc@cs.wisc.edu>
References: <1413437835-13778-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:39645 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051AbaJPFhc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Oct 2014 01:37:32 -0400
In-Reply-To: <1413437835-13778-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, ceph-devel@vger.kernel.org, axboe@kernel.dk

From: Mike Christie <michaelc@cs.wisc.edu>

This patch has the iblock backing store use blkdev_issue_cmp_and_write
if the backing store device/queue supports it.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/target/target_core_iblock.c |   85 ++++++++++++++++++++++++++++-------
 1 files changed, 68 insertions(+), 17 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 7e6b857..cac928a 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -153,6 +153,11 @@ static int iblock_configure_device(struct se_device *dev)
 	 */
 	dev->dev_attrib.max_write_same_len = 0xFFFF;
 
+	/* convert from linux block layer 512 byte sector to our block size */
+	dev->dev_attrib.max_compare_and_write_len =
+		(q->limits.max_cmp_and_write_sectors << IBLOCK_LBA_SHIFT) /
+						dev->dev_attrib.hw_block_size;
+
 	if (blk_queue_nonrot(q))
 		dev->dev_attrib.is_nonrot = 1;
 
@@ -413,6 +418,67 @@ iblock_execute_sync_cache(struct se_cmd *cmd)
 	return 0;
 }
 
+/*
+ * Convert the blocksize advertised to the initiator to the 512 byte
+ * units unconditionally used by the Linux block layer.
+ */
+static int iblock_get_lba_shift(struct se_cmd *cmd)
+{
+	struct se_device *dev = cmd->se_dev;
+
+	if (dev->dev_attrib.block_size == 4096)
+		return 3;
+	else if (dev->dev_attrib.block_size == 2048)
+		return 2;
+	else if (dev->dev_attrib.block_size == 1024)
+		return 1;
+	else
+		return 0;
+}
+
+static sense_reason_t
+iblock_execute_compare_and_write(struct se_cmd *cmd)
+{
+	struct block_device *bdev = IBLOCK_DEV(cmd->se_dev)->ibd_bd;
+	int ret, i = 0;
+	sector_t block_lba;
+	struct scatterlist *sg;
+	struct bio *bio;
+
+	block_lba = cmd->t_task_lba << iblock_get_lba_shift(cmd);
+
+	/* assumes SGLs are PAGE_SIZE */
+	bio = blkdev_setup_cmp_and_write(bdev, block_lba, GFP_KERNEL,
+					 cmd->t_data_nents);
+	if (!bio) {
+		pr_err("blkdev_setup_cmp_and_write() failed\n");
+		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+	}
+
+	for_each_sg(cmd->t_data_sg, sg, cmd->t_data_nents, i) {
+		ret = bio_add_pc_page(bdev_get_queue(bdev), bio, sg_page(sg),
+				      sg->length, sg->offset);
+		if (ret != sg->length) {
+			bio_put(bio);
+			pr_err("bio_add_pc_page() failed\n");
+			return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+		}
+	}
+
+	ret = blkdev_issue_cmp_and_write(bio);
+	if (ret == -ECANCELED) {
+	        pr_warn("Target/%s: Send MISCOMPARE check condition and sense\n",
+        	        cmd->se_dev->transport->name);
+		return TCM_MISCOMPARE_VERIFY;
+	} else if (ret < 0) {
+		pr_err("blkdev_issue_cmp_and_write() failed: %d\n", ret);
+		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+	}
+
+	target_complete_cmd(cmd, GOOD);
+	return 0;
+}
+
 static sense_reason_t
 iblock_do_unmap(struct se_cmd *cmd, void *priv,
 		sector_t lba, sector_t nolb)
@@ -701,23 +767,7 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 		rw = READ;
 	}
 
-	/*
-	 * Convert the blocksize advertised to the initiator to the 512 byte
-	 * units unconditionally used by the Linux block layer.
-	 */
-	if (dev->dev_attrib.block_size == 4096)
-		block_lba = (cmd->t_task_lba << 3);
-	else if (dev->dev_attrib.block_size == 2048)
-		block_lba = (cmd->t_task_lba << 2);
-	else if (dev->dev_attrib.block_size == 1024)
-		block_lba = (cmd->t_task_lba << 1);
-	else if (dev->dev_attrib.block_size == 512)
-		block_lba = cmd->t_task_lba;
-	else {
-		pr_err("Unsupported SCSI -> BLOCK LBA conversion:"
-				" %u\n", dev->dev_attrib.block_size);
-		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
-	}
+	block_lba = cmd->t_task_lba << iblock_get_lba_shift(cmd);
 
 	ibr = kzalloc(sizeof(struct iblock_req), GFP_KERNEL);
 	if (!ibr)
@@ -841,6 +891,7 @@ static struct sbc_ops iblock_sbc_ops = {
 	.execute_write_same	= iblock_execute_write_same,
 	.execute_write_same_unmap = iblock_execute_write_same_unmap,
 	.execute_unmap		= iblock_execute_unmap,
+	.execute_compare_and_write = iblock_execute_compare_and_write,
 };
 
 static sense_reason_t
-- 
1.7.1

