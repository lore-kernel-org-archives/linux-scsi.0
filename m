From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] aic7xxx: fix IOMMU mapping failure handling
Date: Sun,  9 Mar 2008 22:50:41 +0900
Message-ID: <1205070641-450-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:34243 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361AbYCINv0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 9 Mar 2008 09:51:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: tomof@acm.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@HansenPartnership.com>

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/aic7xxx/aic7xxx_osm.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index 282aff6..42ad48e 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -1398,12 +1398,18 @@ ahc_linux_run_command(struct ahc_softc *ahc, struct ahc_linux_device *dev,
 			return SCSI_MLQUEUE_DEVICE_BUSY;
 	}
 
+	nseg = scsi_dma_map(cmd);
+	if (nseg < 0)
+		return SCSI_MLQUEUE_HOST_BUSY;
+
 	/*
 	 * Get an scb to use.
 	 */
 	scb = ahc_get_scb(ahc);
-	if (!scb)
+	if (!scb) {
+		scsi_dma_unmap(cmd);
 		return SCSI_MLQUEUE_HOST_BUSY;
+	}
 
 	scb->io_ctx = cmd;
 	scb->platform_data->dev = dev;
@@ -1464,8 +1470,6 @@ ahc_linux_run_command(struct ahc_softc *ahc, struct ahc_linux_device *dev,
 	ahc_set_sense_residual(scb, 0);
 	scb->sg_count = 0;
 
-	nseg = scsi_dma_map(cmd);
-	BUG_ON(nseg < 0);
 	if (nseg > 0) {
 		struct	ahc_dma_seg *sg;
 		struct	scatterlist *cur_seg;
-- 
1.5.3.4

