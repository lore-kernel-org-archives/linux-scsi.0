From: Brian King <brking@us.ibm.com>
Subject: [PATCH 03/15] libata: ata_scsi_slave_config cleanup
Date: Fri, 17 Mar 2006 17:04:15 -0600
Message-ID: <200603172304.k2HN4Fpi019095@d01av01.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:14044 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S932831AbWCQXEg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Mar 2006 18:04:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, brking@us.ibm.com


Encapsulate some of ata_scsi_slave_config so that parts
can be reused in future SAS patches.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 libata-dev-bjking1/drivers/scsi/libata-scsi.c |   62 +++++++++++++++-----------
 1 files changed, 37 insertions(+), 25 deletions(-)

diff -puN drivers/scsi/libata-scsi.c~libata_sdev_config drivers/scsi/libata-scsi.c
--- libata-dev/drivers/scsi/libata-scsi.c~libata_sdev_config	2006-02-14 09:34:12.000000000 -0600
+++ libata-dev-bjking1/drivers/scsi/libata-scsi.c	2006-02-14 09:38:47.000000000 -0600
@@ -662,6 +662,41 @@ void ata_gen_fixed_sense(struct ata_queu
 	}
 }
 
+static void ata_scsi_sdev_config(struct scsi_device *sdev)
+{
+	sdev->use_10_for_rw = 1;
+	sdev->use_10_for_ms = 1;
+}
+
+static void ata_scsi_dev_config(struct scsi_device *sdev,
+				struct ata_device *dev)
+{
+	unsigned int max_sectors;
+
+	/* TODO: 2048 is an arbitrary number, not the
+	 * hardware maximum.  This should be increased to
+	 * 65534 when Jens Axboe's patch for dynamically
+	 * determining max_sectors is merged.
+	 */
+	max_sectors = ATA_MAX_SECTORS;
+	if (dev->flags & ATA_DFLAG_LBA48)
+		max_sectors = 2048;
+	if (dev->max_sectors)
+		max_sectors = dev->max_sectors;
+
+	blk_queue_max_sectors(sdev->request_queue, max_sectors);
+
+	/*
+	 * SATA DMA transfers must be multiples of 4 byte, so
+	 * we need to pad ATAPI transfers using an extra sg.
+	 * Decrement max hw segments accordingly.
+	 */
+	if (dev->class == ATA_DEV_ATAPI) {
+		request_queue_t *q = sdev->request_queue;
+		blk_queue_max_hw_segments(q, q->max_hw_segments - 1);
+	}
+}
+
 /**
  *	ata_scsi_slave_config - Set SCSI device attributes
  *	@sdev: SCSI device to examine
@@ -676,41 +711,18 @@ void ata_gen_fixed_sense(struct ata_queu
 
 int ata_scsi_slave_config(struct scsi_device *sdev)
 {
-	sdev->use_10_for_rw = 1;
-	sdev->use_10_for_ms = 1;
+	ata_scsi_sdev_config(sdev);
 
 	blk_queue_max_phys_segments(sdev->request_queue, LIBATA_MAX_PRD);
 
 	if (sdev->id < ATA_MAX_DEVICES) {
 		struct ata_port *ap;
 		struct ata_device *dev;
-		unsigned int max_sectors;
 
 		ap = (struct ata_port *) &sdev->host->hostdata[0];
 		dev = &ap->device[sdev->id];
 
-		/* TODO: 2048 is an arbitrary number, not the
-		 * hardware maximum.  This should be increased to
-		 * 65534 when Jens Axboe's patch for dynamically
-		 * determining max_sectors is merged.
-		 */
-		max_sectors = ATA_MAX_SECTORS;
-		if (dev->flags & ATA_DFLAG_LBA48)
-			max_sectors = 2048;
-		if (dev->max_sectors)
-			max_sectors = dev->max_sectors;
-
-		blk_queue_max_sectors(sdev->request_queue, max_sectors);
-
-		/*
-		 * SATA DMA transfers must be multiples of 4 byte, so
-		 * we need to pad ATAPI transfers using an extra sg.
-		 * Decrement max hw segments accordingly.
-		 */
-		if (dev->class == ATA_DEV_ATAPI) {
-			request_queue_t *q = sdev->request_queue;
-			blk_queue_max_hw_segments(q, q->max_hw_segments - 1);
-		}
+		ata_scsi_dev_config(sdev, dev);
 	}
 
 	return 0;	/* scsi layer doesn't check return value, sigh */
_
