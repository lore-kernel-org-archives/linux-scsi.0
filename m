From: Jens Axboe <axboe@suse.de>
Subject: [PATCH] fix SCSI bounce limit
Date: Wed, 27 Oct 2004 14:17:25 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041027121724.GB15910@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:18083 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S262404AbUJ0MR5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Oct 2004 08:17:57 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

Hi,

Just had a case with a gdth adapter not working in a 16GB box. Seems to
me that the SCSI bounce decision is completely screwy - it returns the
device dma mask, if it is set only and the box doesn't have an iommu. So
if we can't get the mask, we allow any io. Not so good. I think the
logic should be more as follows:

	if (isa)
		return bounce_above_isa;
	if (has_iommu)
		return bounce_nothing;

	if (we_know_device_dma_mask)
		return mask;
	else
		return default_to_32bit;

Patch corrects scsi_calculate_bounce_limit() to actually work partly
sanely.

Signed-off-by: Jens Axboe <axboe@suse.de>

===== drivers/scsi/scsi_lib.c 1.137 vs edited =====
--- 1.137/drivers/scsi/scsi_lib.c	2004-10-19 08:06:58 +02:00
+++ edited/drivers/scsi/scsi_lib.c	2004-10-27 14:11:54 +02:00
@@ -1326,19 +1326,22 @@
 u64 scsi_calculate_bounce_limit(struct Scsi_Host *shost)
 {
 	struct device *host_dev;
+	u64 bounce_limit = 0xffffffff;
 
 	if (shost->unchecked_isa_dma)
 		return BLK_BOUNCE_ISA;
-
-	host_dev = scsi_get_device(shost);
-	if (PCI_DMA_BUS_IS_PHYS && host_dev && host_dev->dma_mask)
-		return *host_dev->dma_mask;
-
 	/*
 	 * Platforms with virtual-DMA translation
 	 * hardware have no practical limit.
 	 */
-	return BLK_BOUNCE_ANY;
+	if (!PCI_DMA_BUS_IS_PHYS)
+		return BLK_BOUNCE_ANY;
+
+	host_dev = scsi_get_device(shost);
+	if (host_dev && host_dev->dma_mask)
+		bounce_limit = *host_dev->dma_mask;
+
+	return bounce_limit;
 }
 
 struct request_queue *scsi_alloc_queue(struct scsi_device *sdev)

-- 
Jens Axboe

