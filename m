From: tom.ty89@gmail.com
Subject: [PATCH 1/2] libata-scsi: use dev->max_sectors from libata-core appropriately
Date: Fri, 12 Aug 2016 19:56:06 +0800
Message-ID: <911c68378b91bf275a4bbed5717b4639641d7029.1471002480.git.tom.ty89@gmail.com>
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

For cdrom devices, since they are not supposed to have any VPD, and
neither will the SCSI cdrom (sr) driver touch any of the max sectors
limits, we are hence setting the limit directly in libata-scsi.

Note that when max_dev_sectors is larger than max_hw_sectors, it
does not have any effect. Therefore, setting dev->max_sectors to
ATA_MAX_SECTORS_LBA48 will only have some effect when the host
driver has set max_hw_sectors to a value that is as large as that.

This should not matter for typical devices, since according to our
past experience, 1024 (the current SCSI_DEFAULT_MAX_SECTORS) is a
decent and safe value for max_sectors. ATA_MAX_SECTORS_LBA48 has
actually appeared to be too large for some devices.

Also note that ATA_HORKAGE_MAX_SEC_LBA48 is not supposed to work
automatically anyway, even when max_hw_sectors is as high as 65535,
since the effective max_sectors will be set by the SCSI disk driver.

Signed-off-by: Tom Yan <tom.ty89@gmail.com>

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index be9c76c..4e2d8e7 100644
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
+		 * We are setting the limit here merely because CD/DVD device does not
+		 * have Block Limits VPD.
+		 *
+		 * Supposedly dev->max_sectors should be left shifted by
+		 * (ilog2(sdev->sector_size) - 9). But since ATAPI class device has a
+		 * static logical sector size of 512 (ATA_SECT_SIZE), the shift became
+		 * unnecessary.
+		 */
+		q->limits.max_dev_sectors = dev->max_sectors;
+		/* Make max_dev_sectors effective by adjusting max_sectors accordingly,
+		   while leave max_hw_sectors, which is supposed to be host controller
+		   limit, untouched. */
+		blk_queue_max_hw_sectors(q, queue_max_hw_sectors(q));
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

