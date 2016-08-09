From: tom.ty89@gmail.com
Subject: [PATCH 1/2] libata-scsi: do not call blk_queue_max_hw_sectors()
Date: Tue,  9 Aug 2016 18:31:41 +0800
Message-ID: <1dc8fff2418744a7c4bf824f789017228ac15624.1470738284.git.tom.ty89@gmail.com>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: tj@kernel.org
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Tom Yan <tom.ty89@gmail.com>
List-Id: linux-scsi@vger.kernel.org

From: Tom Yan <tom.ty89@gmail.com>

We should just let the scsi driver (hosts.c) call the function. It
has better heuristic anyway (i.e. use SCSI_DEFAULT_MAX_SECTORS as
fallback when max_sectors is not set).

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 2bdb5da..495d916 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1204,9 +1204,6 @@ static int ata_scsi_dev_config(struct scsi_device *sdev,
 	if (!ata_id_has_unload(dev->id))
 		dev->flags |= ATA_DFLAG_NO_UNLOAD;
 
-	/* configure max sectors */
-	blk_queue_max_hw_sectors(q, dev->max_sectors);
-
 	if (dev->class == ATA_DEV_ATAPI) {
 		void *buf;
 
-- 
2.9.2

