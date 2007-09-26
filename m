From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH 2/5] sata_inic162x: use dma_max_segment_size in
 scsi_host_template
Date: Wed, 26 Sep 2007 17:58:00 +0900
Message-ID: <20070925142146P.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:50116 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752865AbXIZI6d (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Sep 2007 04:58:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com, jens.axboe@oracle.com, hch@infradead.org, jeff@garzik.org, gregkh@suse.de, hare@suse.de, linux-scsi@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp

This removes blk_queue_max_segment_size and uses dma_max_segment_size
in scsi_host_template.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/ata/sata_inic162x.c |   19 +++++++------------
 1 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/ata/sata_inic162x.c b/drivers/ata/sata_inic162x.c
index fdbed8e..ae3590f 100644
--- a/drivers/ata/sata_inic162x.c
+++ b/drivers/ata/sata_inic162x.c
@@ -108,17 +108,11 @@ struct inic_port_priv {
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
+/*
+ * This controller is braindamaged.  dma_boundary is 0xffff
+ * like others but it will lock up the whole machine HARD if
+ * 65536 byte PRD entry is fed. Reduce maximum segment size.
+ */
 static struct scsi_host_template inic_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
@@ -132,7 +126,8 @@ static struct scsi_host_template inic_sht = {
 	.use_clustering		= ATA_SHT_USE_CLUSTERING,
 	.proc_name		= DRV_NAME,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
-	.slave_configure	= inic_slave_config,
+	.dma_max_segment_size	= 65536 - 512,
+	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
 };
-- 
1.5.2.4

