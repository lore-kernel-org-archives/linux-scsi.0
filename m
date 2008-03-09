From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] aic79xx: fix IOMMU mapping failure handling
Date: Sun,  9 Mar 2008 22:50:40 +0900
Message-ID: <1205070641-450-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:37214 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278AbYCINvZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 9 Mar 2008 09:51:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: tomof@acm.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@HansenPartnership.com>

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/aic7xxx/aic79xx_osm.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index 72fccd9..0081aa3 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -1413,6 +1413,10 @@ ahd_linux_run_command(struct ahd_softc *ahd, struct ahd_linux_device *dev,
 	unsigned long flags;
 	int nseg;
 
+	nseg = scsi_dma_map(cmd);
+	if (nseg < 0)
+		return SCSI_MLQUEUE_HOST_BUSY;
+
 	ahd_lock(ahd, &flags);
 
 	/*
@@ -1430,6 +1434,7 @@ ahd_linux_run_command(struct ahd_softc *ahd, struct ahd_linux_device *dev,
 	if ((scb = ahd_get_scb(ahd, col_idx)) == NULL) {
 		ahd->flags |= AHD_RESOURCE_SHORTAGE;
 		ahd_unlock(ahd, &flags);
+		scsi_dma_unmap(cmd);
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
@@ -1485,8 +1490,6 @@ ahd_linux_run_command(struct ahd_softc *ahd, struct ahd_linux_device *dev,
 	ahd_set_sense_residual(scb, 0);
 	scb->sg_count = 0;
 
-	nseg = scsi_dma_map(cmd);
-	BUG_ON(nseg < 0);
 	if (nseg > 0) {
 		void *sg = scb->sg_list;
 		struct scatterlist *cur_seg;
-- 
1.5.3.4

