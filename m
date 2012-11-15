From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH-v2 3/3] target/iblock: Add WRITE_SAME w/ UNMAP=0 emulation support
Date: Thu, 15 Nov 2012 20:13:59 +0000
Message-ID: <1353010439-4600-4-git-send-email-nab@linux-iscsi.org>
References: <1353010439-4600-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:60480 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768930Ab2KOUUx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Nov 2012 15:20:53 -0500
In-Reply-To: <1353010439-4600-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds support for emulation of WRITE_SAME w/ UNMAP=0 within
iblock_execute_write_same() backend code.

The emulation uses a bio_add_page() call for each sector, and by default
enforces a limit of max_write_same_len=0xFFFF (65536) sectors following
what scsi_debug reports per default for MAXIMUM WRITE SAME LENGTH.

It also sets max_write_same_len to the operational default at setup ->
iblock_configure_device() time.

(hch: Move unmap logic into iblock_execute_write_same_unmap + add
      check for single sector SGLs in iblock_execute_write_same)
(mkp: Update comment for 0xFFFF magic constant)

Cc: Christoph Hellwig <hch@lst.de>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_iblock.c |   91 ++++++++++++++++++++++++++++++++---
 1 files changed, 84 insertions(+), 7 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 53f4501..5abbd55 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -151,6 +151,11 @@ static int iblock_configure_device(struct se_device *dev)
 		pr_debug("IBLOCK: BLOCK Discard support available,"
 				" disabled by default\n");
 	}
+	/*
+	 * Enable write same emulation for IBLOCK and use 0xFFFF as
+	 * the samller WRITE_SAME(10) only has a two-byte block count.
+	 */
+	dev->dev_attrib.max_write_same_len = 0xFFFF;
 
 	if (blk_queue_nonrot(q))
 		dev->dev_attrib.is_nonrot = 1;
@@ -375,17 +380,20 @@ err:
 	return ret;
 }
 
+static struct bio *iblock_get_bio(struct se_cmd *, sector_t, u32);
+static void iblock_submit_bios(struct bio_list *, int);
+static void iblock_complete_cmd(struct se_cmd *);
+
 static sense_reason_t
-iblock_execute_write_same(struct se_cmd *cmd)
+iblock_execute_write_same_unmap(struct se_cmd *cmd)
 {
 	struct iblock_dev *ib_dev = IBLOCK_DEV(cmd->se_dev);
-	int ret;
+	int rc;
 
-	ret = blkdev_issue_discard(ib_dev->ibd_bd, cmd->t_task_lba,
-				   spc_get_write_same_sectors(cmd), GFP_KERNEL,
-				   0);
-	if (ret < 0) {
-		pr_debug("blkdev_issue_discard() failed for WRITE_SAME\n");
+	rc = blkdev_issue_discard(ib_dev->ibd_bd, cmd->t_task_lba,
+			spc_get_write_same_sectors(cmd), GFP_KERNEL, 0);
+	if (rc < 0) {
+		pr_warn("blkdev_issue_discard() failed: %d\n", rc);
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
 
@@ -393,6 +401,74 @@ iblock_execute_write_same(struct se_cmd *cmd)
 	return 0;
 }
 
+static sense_reason_t
+iblock_execute_write_same(struct se_cmd *cmd)
+{
+	struct iblock_req *ibr;
+	struct scatterlist *sg;
+	struct bio *bio;
+	struct bio_list list;
+	sector_t block_lba = cmd->t_task_lba;
+	unsigned int sectors = spc_get_write_same_sectors(cmd);
+
+	if (sectors > cmd->se_dev->dev_attrib.max_write_same_len) {
+		pr_warn("WRITE_SAME sectors: %u exceeds max_write_same_len: %u\n",
+			sectors, cmd->se_dev->dev_attrib.max_write_same_len);
+		return TCM_INVALID_CDB_FIELD;
+	}
+	sg = &cmd->t_data_sg[0];
+
+	if (cmd->t_data_nents > 1 ||
+	    sg->length != cmd->se_dev->dev_attrib.block_size) {
+		pr_err("WRITE_SAME: Illegal SGL t_data_nents: %u length: %u"
+			" block_size: %u\n", cmd->t_data_nents, sg->length,
+			cmd->se_dev->dev_attrib.block_size);
+		return TCM_INVALID_CDB_FIELD;
+	}
+
+	ibr = kzalloc(sizeof(struct iblock_req), GFP_KERNEL);
+	if (!ibr)
+		goto fail;
+	cmd->priv = ibr;
+
+	bio = iblock_get_bio(cmd, block_lba, 1);
+	if (!bio)
+		goto fail_free_ibr;
+
+	bio_list_init(&list);
+	bio_list_add(&list, bio);
+
+	atomic_set(&ibr->pending, 1);
+
+	while (sectors) {
+		while (bio_add_page(bio, sg_page(sg), sg->length, sg->offset)
+				!= sg->length) {
+
+			bio = iblock_get_bio(cmd, block_lba, 1);
+			if (!bio)
+				goto fail_put_bios;
+
+			atomic_inc(&ibr->pending);
+			bio_list_add(&list, bio);
+		}
+
+		/* Always in 512 byte units for Linux/Block */
+		block_lba += sg->length >> IBLOCK_LBA_SHIFT;
+		sectors -= 1;
+	}
+
+	iblock_submit_bios(&list, WRITE);
+	return 0;
+
+fail_put_bios:
+	while ((bio = bio_list_pop(&list)))
+		bio_put(bio);
+fail_free_ibr:
+	kfree(ibr);
+fail:
+	return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+}
+
 enum {
 	Opt_udev_path, Opt_readonly, Opt_force, Opt_err
 };
@@ -701,6 +777,7 @@ static struct sbc_ops iblock_sbc_ops = {
 	.execute_rw		= iblock_execute_rw,
 	.execute_sync_cache	= iblock_execute_sync_cache,
 	.execute_write_same	= iblock_execute_write_same,
+	.execute_write_same_unmap = iblock_execute_write_same_unmap,
 	.execute_unmap		= iblock_execute_unmap,
 };
 
-- 
1.7.2.5

