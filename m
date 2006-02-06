From: brking@us.ibm.com
Subject: [patch 05/15] libata: ata_scsi_slave_config cleanup
Date: Mon, 06 Feb 2006 09:42:24 -0600
Message-ID: <200602061542.k16FgVet002874@d03av02.boulder.ibm.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, brking@us.ibm.com
List-Id: linux-scsi@vger.kernel.org


Encapsulate some of ata_scsi_slave_config so that parts
can be reused in future SAS patches.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/libata-scsi.c |   62 +++++++++++++++------------
 1 files changed, 36 insertions(+), 26 deletions(-)

diff -puN drivers/scsi/libata-scsi.c~libata_sdev_config drivers/scsi/libata-scsi.c
--- linux-2.6/drivers/scsi/libata-scsi.c~libata_sdev_config	2006-01-09 06:32:07.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/libata-scsi.c	2006-01-09 06:48:07.000000000 -0600
@@ -662,6 +662,40 @@ void ata_gen_fixed_sense(struct ata_queu
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
+	/* TODO: 1024 is an arbitrary number, not the
+	 * hardware maximum.  This should be increased to
+	 * 65534 when Jens Axboe's patch for dynamically
+	 * determining max_sectors is merged.
+	 */
+	if ((dev->flags & ATA_DFLAG_LBA48) &&
+	    ((dev->flags & ATA_DFLAG_LOCK_SECTORS) == 0)) {
+		/*
+		 * do not overwrite sdev->host->max_sectors, since
+		 * other drives on this host may not support LBA48
+		 */
+		blk_queue_max_sectors(sdev->request_queue, 2048);
+	}
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
@@ -676,9 +710,7 @@ void ata_gen_fixed_sense(struct ata_queu
 
 int ata_scsi_slave_config(struct scsi_device *sdev)
 {
-	sdev->use_10_for_rw = 1;
-	sdev->use_10_for_ms = 1;
-
+	ata_scsi_sdev_config(sdev);
 	blk_queue_max_phys_segments(sdev->request_queue, LIBATA_MAX_PRD);
 
 	if (sdev->id < ATA_MAX_DEVICES) {
@@ -688,29 +720,7 @@ int ata_scsi_slave_config(struct scsi_de
 		ap = (struct ata_port *) &sdev->host->hostdata[0];
 		dev = &ap->device[sdev->id];
 
-		/* TODO: 1024 is an arbitrary number, not the
-		 * hardware maximum.  This should be increased to
-		 * 65534 when Jens Axboe's patch for dynamically
-		 * determining max_sectors is merged.
-		 */
-		if ((dev->flags & ATA_DFLAG_LBA48) &&
-		    ((dev->flags & ATA_DFLAG_LOCK_SECTORS) == 0)) {
-			/*
-			 * do not overwrite sdev->host->max_sectors, since
-			 * other drives on this host may not support LBA48
-			 */
-			blk_queue_max_sectors(sdev->request_queue, 2048);
-		}
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
