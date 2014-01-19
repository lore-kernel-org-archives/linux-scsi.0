From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 11/17] target/iblock: Add blk_integrity + BIP passthrough support
Date: Sun, 19 Jan 2014 02:44:34 +0000
Message-ID: <1390099480-29013-12-git-send-email-nab@daterainc.com>
References: <1390099480-29013-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:44579 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980AbaASDF2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Jan 2014 22:05:28 -0500
In-Reply-To: <1390099480-29013-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Roland Dreier <roland@kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds blk_integrity passthrough support for block_device
backends using IBLOCK.

This includes iblock_alloc_bip() + setup of bio_integrity_payload
information that attaches to the leading struct bio once bio_list
is populated during fast-path iblock_execute_rw() I/O dispatch.

It also updates setup in iblock_configure_device() to detect modes
of protection + se dev->dev_attrib.pi_prot_type accordingly, along
with creating required bio_set integrity mempools.

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/Kconfig              |    1 +
 drivers/target/target_core_iblock.c |   91 ++++++++++++++++++++++++++++++++++-
 2 files changed, 90 insertions(+), 2 deletions(-)

diff --git a/drivers/target/Kconfig b/drivers/target/Kconfig
index 50aad2e..dc2d84a 100644
--- a/drivers/target/Kconfig
+++ b/drivers/target/Kconfig
@@ -14,6 +14,7 @@ if TARGET_CORE
 
 config TCM_IBLOCK
 	tristate "TCM/IBLOCK Subsystem Plugin for Linux/BLOCK"
+	select BLK_DEV_INTEGRITY
 	help
 	Say Y here to enable the TCM/IBLOCK subsystem plugin for non-buffered
 	access to Linux/Block devices using BIO
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 15d9121..293d9b0 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -91,6 +91,7 @@ static int iblock_configure_device(struct se_device *dev)
 	struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
 	struct request_queue *q;
 	struct block_device *bd = NULL;
+	struct blk_integrity *bi;
 	fmode_t mode;
 	int ret = -ENOMEM;
 
@@ -155,8 +156,40 @@ static int iblock_configure_device(struct se_device *dev)
 	if (blk_queue_nonrot(q))
 		dev->dev_attrib.is_nonrot = 1;
 
+	bi = bdev_get_integrity(bd);
+	if (bi) {
+		struct bio_set *bs = ib_dev->ibd_bio_set;
+
+		if (!strcmp(bi->name, "T10-DIF-TYPE3-IP") ||
+		    !strcmp(bi->name, "T10-DIF-TYPE1-IP")) {
+			pr_err("IBLOCK export of blk_integrity: %s not"
+			       " supported\n", bi->name);
+			ret = -ENOSYS;
+			goto out_blkdev_put;
+		}
+
+		if (!strcmp(bi->name, "T10-DIF-TYPE3-CRC")) {
+			dev->dev_attrib.pi_prot_type = TARGET_DIF_TYPE3_PROT;
+		} else if (!strcmp(bi->name, "T10-DIF-TYPE1-CRC")) {
+			dev->dev_attrib.pi_prot_type = TARGET_DIF_TYPE1_PROT;
+		}
+
+		if (dev->dev_attrib.pi_prot_type) {
+			if (bioset_integrity_create(bs, IBLOCK_BIO_POOL_SIZE) < 0) {
+				pr_err("Unable to allocate bioset for PI\n");
+				ret = -ENOMEM;
+				goto out_blkdev_put;
+			}
+			pr_debug("IBLOCK setup BIP bs->bio_integrity_pool: %p\n",
+				 bs->bio_integrity_pool);
+		}
+		dev->dev_attrib.hw_pi_prot_type = dev->dev_attrib.pi_prot_type;
+	}
+
 	return 0;
 
+out_blkdev_put:
+	blkdev_put(ib_dev->ibd_bd, FMODE_WRITE|FMODE_READ|FMODE_EXCL);
 out_free_bioset:
 	bioset_free(ib_dev->ibd_bio_set);
 	ib_dev->ibd_bio_set = NULL;
@@ -170,8 +203,10 @@ static void iblock_free_device(struct se_device *dev)
 
 	if (ib_dev->ibd_bd != NULL)
 		blkdev_put(ib_dev->ibd_bd, FMODE_WRITE|FMODE_READ|FMODE_EXCL);
-	if (ib_dev->ibd_bio_set != NULL)
+	if (ib_dev->ibd_bio_set != NULL) {
+		bioset_integrity_free(ib_dev->ibd_bio_set);
 		bioset_free(ib_dev->ibd_bio_set);
+	}
 	kfree(ib_dev);
 }
 
@@ -586,13 +621,58 @@ static ssize_t iblock_show_configfs_dev_params(struct se_device *dev, char *b)
 	return bl;
 }
 
+static int
+iblock_alloc_bip(struct se_cmd *cmd, struct bio *bio)
+{
+	struct se_device *dev = cmd->se_dev;
+	struct blk_integrity *bi;
+	struct bio_integrity_payload *bip;
+	struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
+	struct scatterlist *sg;
+	int i, rc;
+
+	bi = bdev_get_integrity(ib_dev->ibd_bd);
+	if (!bi) {
+		pr_err("Unable to locate bio_integrity\n");
+		return -ENODEV;
+	}
+
+	bip = bio_integrity_alloc(bio, GFP_NOIO, cmd->t_prot_nents);
+	if (!bip) {
+		pr_err("Unable to allocate bio_integrity_payload\n");
+		return -ENOMEM;
+	}
+
+	bip->bip_size = (cmd->data_length / dev->dev_attrib.block_size) *
+			 dev->prot_length;
+	bip->bip_sector = bio->bi_sector;
+
+	pr_debug("IBLOCK BIP Size: %u Sector: %llu\n", bip->bip_size,
+		 (unsigned long long)bip->bip_sector);
+
+	for_each_sg(cmd->t_prot_sg, sg, cmd->t_prot_nents, i) {
+
+		rc = bio_integrity_add_page(bio, sg_page(sg), sg->length,
+					    sg->offset);
+		if (rc != sg->length) {
+			pr_err("bio_integrity_add_page() failed; %d\n", rc);
+			return -ENOMEM;
+		}
+
+		pr_debug("Added bio integrity page: %p length: %d offset; %d\n",
+			 sg_page(sg), sg->length, sg->offset);
+	}
+
+	return 0;
+}
+
 static sense_reason_t
 iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 		  enum dma_data_direction data_direction)
 {
 	struct se_device *dev = cmd->se_dev;
 	struct iblock_req *ibr;
-	struct bio *bio;
+	struct bio *bio, *bio_start;
 	struct bio_list list;
 	struct scatterlist *sg;
 	u32 sg_num = sgl_nents;
@@ -655,6 +735,7 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	if (!bio)
 		goto fail_free_ibr;
 
+	bio_start = bio;
 	bio_list_init(&list);
 	bio_list_add(&list, bio);
 
@@ -688,6 +769,12 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 		sg_num--;
 	}
 
+	if (cmd->prot_type) {
+		int rc = iblock_alloc_bip(cmd, bio_start);
+		if (rc)
+			goto fail_put_bios;
+	}
+
 	iblock_submit_bios(&list, rw);
 	iblock_complete_cmd(cmd);
 	return 0;
-- 
1.7.10.4

