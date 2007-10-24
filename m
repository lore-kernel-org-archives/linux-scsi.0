From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH -mm 10/11] sata_inic162x: use pci_set_dma_max_seg_size
Date: Wed, 24 Oct 2007 19:48:34 +0900
Message-ID: <20071024172847R.tomof@acm.org>
References: <67bb10d9f4e9473ddc84d9839114602c1966f19f.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:37730 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756441AbXJXKs5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Oct 2007 06:48:57 -0400
In-Reply-To: <67bb10d9f4e9473ddc84d9839114602c1966f19f.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, jeff@garzik.org, fujita.tomonori@lab.ntt.co.jp

This sets the segment size limit properly via pci_set_dma_max_seg_size
and remove blk_queue_max_segment_size because scsi-ml calls it.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/ata/sata_inic162x.c |   25 +++++++++++++------------
 1 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/ata/sata_inic162x.c b/drivers/ata/sata_inic162x.c
index 08595f3..4f3ba83 100644
--- a/drivers/ata/sata_inic162x.c
+++ b/drivers/ata/sata_inic162x.c
@@ -108,17 +108,6 @@ struct inic_port_priv {
 	u8	cached_pirq_mask;
 };
 
-static int inic_slave_config(struct scsi_device *sdev)
-{
-	/* This controller is braindamaged.  dma_boundary is 0xffff
-	 * like others but it will lock up the whole machine HARD if
-	 * 65536 byte PRD entry is fed.  Reduce maximum segment size.
-	 */
-	blk_queue_max_segment_size(sdev->request_queue, 65536 - 512);
-
-	return ata_scsi_slave_config(sdev);
-}
-
 static struct scsi_host_template inic_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
@@ -132,7 +121,7 @@ static struct scsi_host_template inic_sht = {
 	.use_clustering		= ATA_SHT_USE_CLUSTERING,
 	.proc_name		= DRV_NAME,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
-	.slave_configure	= inic_slave_config,
+	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
 };
@@ -730,6 +719,18 @@ static int inic_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		return rc;
 	}
 
+	/*
+	 * This controller is braindamaged.  dma_boundary is 0xffff
+	 * like others but it will lock up the whole machine HARD if
+	 * 65536 byte PRD entry is fed. Reduce maximum segment size.
+	 */
+	rc = pci_set_dma_max_seg_size(pdev, 65536 - 512);
+	if (rc) {
+		dev_printk(KERN_ERR, &pdev->dev,
+			   "failed to set the maximum segment size.\n");
+		return rc;
+	}
+
 	rc = init_controller(iomap[MMIO_BAR], hpriv->cached_hctl);
 	if (rc) {
 		dev_printk(KERN_ERR, &pdev->dev,
-- 
1.5.2.4

