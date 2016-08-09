From: tom.ty89@gmail.com
Subject: [PATCH 2/2] libata: do not set max_sectors for LBA48 device
Date: Tue,  9 Aug 2016 18:31:42 +0800
Message-ID: <e821f2b2223669535ae68e377c89c17c5c0237cf.1470738284.git.tom.ty89@gmail.com>
References: <1dc8fff2418744a7c4bf824f789017228ac15624.1470738284.git.tom.ty89@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:33947 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbcHIKbx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Aug 2016 06:31:53 -0400
In-Reply-To: <1dc8fff2418744a7c4bf824f789017228ac15624.1470738284.git.tom.ty89@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tj@kernel.org
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Tom Yan <tom.ty89@gmail.com>

From: Tom Yan <tom.ty89@gmail.com>

Along with commit 1dc8fff24187 ("libata-scsi: do not call
blk_queue_max_hw_sectors()"), devices with LBA48 support will have
max_sectors set to SCSI_DEFAULT_MAX_SECTORS (currently 1024), by
the scsi driver.

Note that the "max_sectors" here is actually the block layer limit
"max_hw_sectors", while the block layer limit "max_sectors" (which
is upper-bounded by "max_hw_sectors") will be set to
BLK_DEF_MAX_SECTORS (currently 2560) by the scsi disk driver, since
our SATL does not report an Optimal Transfer Length.

Therefore, it should make more sense to have the "max_sectors" here
set to SCSI_DEFAULT_MAX_SECTORS, so that both of the block layer
limits will be set to 1024, than to have "max_hw_sectors" set to
65535 and have "max_sectors" set to 2560. Not to mention that
neither of them seems to be a "safe" value (see
ATA_HORKAGE_MAX_SEC_1024).

Besides, it is in doubt that whether having max_sectors (for a
single drive, which is our case) set to a value higher than 1024
would actually improve performance anyway.

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 0749f71..2a08458 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2408,7 +2408,6 @@ int ata_dev_configure(struct ata_device *dev)
 
 	/* initialize to-be-configured parameters */
 	dev->flags &= ~ATA_DFLAG_CFG_MASK;
-	dev->max_sectors = 0;
 	dev->cdb_len = 0;
 	dev->n_sectors = 0;
 	dev->cylinders = 0;
@@ -2610,10 +2609,8 @@ int ata_dev_configure(struct ata_device *dev)
 				     dma_dir_string);
 	}
 
-	/* determine max_sectors */
-	dev->max_sectors = ATA_MAX_SECTORS;
-	if (dev->flags & ATA_DFLAG_LBA48)
-		dev->max_sectors = ATA_MAX_SECTORS_LBA48;
+	if (!(dev->flags & ATA_DFLAG_LBA48))
+		dev->max_sectors = ATA_MAX_SECTORS;
 
 	/* Limit PATA drive on SATA cable bridge transfers to udma5,
 	   200 sectors */
-- 
2.9.2

