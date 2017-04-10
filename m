From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/8] target: remove iblock WRITE_SAME passthrough support
Date: Mon, 10 Apr 2017 18:08:01 +0200
Message-ID: <20170410160807.23674-3-hch@lst.de>
References: <20170410160807.23674-1-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:57044 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751602AbdDJQI2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Apr 2017 12:08:28 -0400
In-Reply-To: <20170410160807.23674-1-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk, martin.petersen@oracle.com, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, target-devel@vger.kernel.org
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com, dm-devel@redhat.com

Use the pscsi driver to support arbitrary command passthrough
instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/target/target_core_iblock.c | 34 ----------------------------------
 1 file changed, 34 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index d316ed537d59..9da31970a004 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -415,39 +415,8 @@ iblock_execute_unmap(struct se_cmd *cmd, sector_t lba, sector_t nolb)
 }
 
 static sense_reason_t
-iblock_execute_write_same_direct(struct block_device *bdev, struct se_cmd *cmd)
-{
-	struct se_device *dev = cmd->se_dev;
-	struct scatterlist *sg = &cmd->t_data_sg[0];
-	struct page *page = NULL;
-	int ret;
-
-	if (sg->offset) {
-		page = alloc_page(GFP_KERNEL);
-		if (!page)
-			return TCM_OUT_OF_RESOURCES;
-		sg_copy_to_buffer(sg, cmd->t_data_nents, page_address(page),
-				  dev->dev_attrib.block_size);
-	}
-
-	ret = blkdev_issue_write_same(bdev,
-				target_to_linux_sector(dev, cmd->t_task_lba),
-				target_to_linux_sector(dev,
-					sbc_get_write_same_sectors(cmd)),
-				GFP_KERNEL, page ? page : sg_page(sg));
-	if (page)
-		__free_page(page);
-	if (ret)
-		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
-
-	target_complete_cmd(cmd, GOOD);
-	return 0;
-}
-
-static sense_reason_t
 iblock_execute_write_same(struct se_cmd *cmd)
 {
-	struct block_device *bdev = IBLOCK_DEV(cmd->se_dev)->ibd_bd;
 	struct iblock_req *ibr;
 	struct scatterlist *sg;
 	struct bio *bio;
@@ -472,9 +441,6 @@ iblock_execute_write_same(struct se_cmd *cmd)
 		return TCM_INVALID_CDB_FIELD;
 	}
 
-	if (bdev_write_same(bdev))
-		return iblock_execute_write_same_direct(bdev, cmd);
-
 	ibr = kzalloc(sizeof(struct iblock_req), GFP_KERNEL);
 	if (!ibr)
 		goto fail;
-- 
2.11.0
