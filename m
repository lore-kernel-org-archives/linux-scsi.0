From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 2/2] relax scsi dma alignment
Date: Mon, 31 Dec 2007 16:43:25 -0600
Message-ID: <1199141005.3110.27.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:42304 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751042AbXLaWne (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Dec 2007 17:43:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Kristian Hoegsberg <krh@bitplanet.net>

This patch relaxes the default SCSI DMA alignment from 512 bytes to 4
bytes.  I remember from previous discussions that usb and firewire have
sector size alignment requirements, so I upped their alignments in the
respective slave allocs.

The reason for doing this is so that we don't get such a huge amount of
copy overhead in bio_copy_user() for udev.  (basically all inquiries it
issues can now be directly mapped).

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

---

This patch depends on the prior patch:

block: Introduce new blk_queue_update_dma_alignment interface


diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 571fba5..db627a4 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -824,6 +824,9 @@ static void ata_scsi_sdev_config(struct scsi_device *sdev)
 	 * requests.
 	 */
 	sdev->max_device_blocked = 1;
+
+	/* set the min alignment */
+	blk_queue_update_dma_alignment(sdev->request_queue, ATA_DMA_PAD_MASK);
 }
 
 static void ata_scsi_dev_config(struct scsi_device *sdev,
@@ -868,7 +871,7 @@ int ata_scsi_slave_config(struct scsi_device *sdev)
 	if (dev)
 		ata_scsi_dev_config(sdev, dev);
 
-	return 0;	/* scsi layer doesn't check return value, sigh */
+	return 0;
 }
 
 /**
diff --git a/drivers/firewire/fw-sbp2.c b/drivers/firewire/fw-sbp2.c
index 624ff3e..c2169d2 100644
--- a/drivers/firewire/fw-sbp2.c
+++ b/drivers/firewire/fw-sbp2.c
@@ -1238,6 +1238,12 @@ static int sbp2_scsi_slave_alloc(struct scsi_device *sdev)
 
 	sdev->allow_restart = 1;
 
+	/*
+	 * Update the dma alignment (minimum alignment requirements for
+	 * start and end of DMA transfers) to be a sector
+	 */
+	blk_queue_update_dma_alignment(sdev->request_queue, 511);
+
 	if (lu->tgt->workarounds & SBP2_WORKAROUND_INQUIRY_36)
 		sdev->inquiry_len = 36;
 
diff --git a/drivers/ieee1394/sbp2.c b/drivers/ieee1394/sbp2.c
index b83d254..1eda11a 100644
--- a/drivers/ieee1394/sbp2.c
+++ b/drivers/ieee1394/sbp2.c
@@ -1963,6 +1963,12 @@ static int sbp2scsi_slave_alloc(struct scsi_device *sdev)
 	lu->sdev = sdev;
 	sdev->allow_restart = 1;
 
+	/*
+	 * Update the dma alignment (minimum alignment requirements for
+	 * start and end of DMA transfers) to be a sector
+	 */
+	blk_queue_update_dma_alignment(sdev->request_queue, 511);
+
 	if (lu->workarounds & SBP2_WORKAROUND_INQUIRY_36)
 		sdev->inquiry_len = 36;
 	return 0;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index d1a4671..0aa5296 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1667,6 +1667,14 @@ struct request_queue *__scsi_alloc_queue(struct Scsi_Host *shost,
 
 	if (!shost->use_clustering)
 		clear_bit(QUEUE_FLAG_CLUSTER, &q->queue_flags);
+
+	/*
+	 * set a reasonable default alignment on word boundaries: the
+	 * host and device may alter it using
+	 * blk_queue_update_dma_alignment() later.
+	 */
+	blk_queue_dma_alignment(q, 0x03);
+
 	return q;
 }
 EXPORT_SYMBOL(__scsi_alloc_queue);
diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index 7c9593b..39c03f9 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -82,6 +82,12 @@ static int slave_alloc (struct scsi_device *sdev)
 	sdev->inquiry_len = 36;
 
 	/*
+	 * Update the dma alignment (minimum alignment requirements for
+	 * start and end of DMA transfers) to be a sector
+	 */
+	blk_queue_update_dma_alignment(sdev->request_queue, 511);
+
+	/*
 	 * The UFI spec treates the Peripheral Qualifier bits in an
 	 * INQUIRY result as reserved and requires devices to set them
 	 * to 0.  However the SCSI spec requires these bits to be set


