From: tom.ty89@gmail.com
Subject: [PATCH v2 1/2] libata-scsi: use dev->max_sectors from libata-core appropriately
Date: Fri, 12 Aug 2016 22:27:03 +0800
Message-ID: <60518e90d462d4cbb1c528914eac64e2fe124717.1471011949.git.tom.ty89@gmail.com>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: tj@kernel.org, martin.petersen@oracle.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Tom Yan <tom.ty89@gmail.com>
List-Id: linux-scsi@vger.kernel.org

From: Tom Yan <tom.ty89@gmail.com>

Currently we use dev->max_sectors to set max_hw_sectors, which
is actually supposed to be a host controller limit (that get set
by the host controller driver like ahci, and if not it would be
the fallback SCSI_DEFAULT_MAX_SECTORS).

That means we have been doing the wrong thing. Therefore, use it
to set the correct request queue limit that is used to report
device limit: max_dev_sectors.

For disk devices, it is reported through the Maximum Transfer Length
field on the Block Limits VPD to the SCSI disk driver, which will
then set and make use of max_dev_sectors.

Note that when max_dev_sectors is larger than max_hw_sectors, it
does not have any effect. Therefore, setting dev->max_sectors to
ATA_MAX_SECTORS_LBA48 will only have some effect when the host
driver has set max_hw_sectors to a value that is as large as that.

This should not matter for typical devices, since according to our
past experience, 1024 (the current SCSI_DEFAULT_MAX_SECTORS) is a
decent and safe value for max_sectors. ATA_MAX_SECTORS_LBA48 has
actually appeared to be too large for some devices.

For cdrom devices, there is a different story. Since a few ATAPI
devices needed ATA_HORKAGE_MAX_SEC_LBA48 to work. Therefore,
max_hw_sectors must be set to match with that, so that the
effective max_sectors can be set to ATA_MAX_SECTORS_LBA48.

Signed-off-by: Tom Yan <tom.ty89@gmail.com>

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 223a770..39374236 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2639,6 +2639,11 @@ int ata_dev_configure(struct ata_device *dev)
 		dev->max_sectors = min_t(unsigned int, ATA_MAX_SECTORS_1024,
 					 dev->max_sectors);
 
+	/* For disk devices, max sectors set here will only be used as
+	 * max_dev_sectors. We should never expect max sectors horkage
+	 * that sets the value larger than BLK_DEF_MAX_SECTORS to work
+	 * for non-ATAPI devices. */
+
 	if (dev->horkage & ATA_HORKAGE_MAX_SEC_LBA48)
 		dev->max_sectors = ATA_MAX_SECTORS_LBA48;
 
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index be9c76c..13f518b 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1204,14 +1204,26 @@ static int ata_scsi_dev_config(struct scsi_device *sdev,
 	if (!ata_id_has_unload(dev->id))
 		dev->flags |= ATA_DFLAG_NO_UNLOAD;
 
-	/* configure max sectors */
-	blk_queue_max_hw_sectors(q, dev->max_sectors);
-
 	if (dev->class == ATA_DEV_ATAPI) {
 		void *buf;
 
 		sdev->sector_size = ATA_SECT_SIZE;
 
+		/*
+		 * max_hw_sectors is supposed to be host controller limit, it is
+		 * changed here only to make sure ATA_HORKAGE_MAX_SEC_LBA48 that
+		 * is needed by a few ATAPI devices works.
+		 *
+		 * Unlike the SCSI disk driver, the SCSI cdrom (sr) driver will
+		 * not further change max_sectors. Therefore, the value that is
+		 * also set here is guaranteed to be the effective one.
+		 *
+		 * For disk devices, we should only report dev->max_sectors in
+		 * the Maximum Transfer Length field on the Block Limits VPD
+		 * (which CD/DVD devices are not supposed to have).
+		 */
+		blk_queue_max_hw_sectors(q, dev->max_sectors);
+
 		/* set DMA padding */
 		blk_queue_update_dma_pad(q, ATA_DMA_PAD_SZ - 1);
 
@@ -2310,6 +2322,13 @@ static unsigned int ata_scsiop_inq_b0(struct ata_scsi_args *args, u8 *rbuf)
 	put_unaligned_be16(min_io_sectors, &rbuf[6]);
 
 	/*
+	 * Maximum transfer length.
+	 *
+	 * This will be used by the SCSI disk driver to set max_dev_sectors.
+	 */
+	put_unaligned_be32(args->dev->max_sectors, &rbuf[8]);
+
+	/*
 	 * Optimal unmap granularity.
 	 *
 	 * The ATA spec doesn't even know about a granularity or alignment
-- 
2.9.2

