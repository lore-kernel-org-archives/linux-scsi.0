From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 9/19] aic7xxx: convert to use the data buffer accessors
Date: Sat, 12 May 2007 19:05:43 +0900 (JST)
Message-ID: <20070512183729H.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:55480 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479AbXELKFz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 12 May 2007 06:05:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org

This converts aic7xxx to use the data buffer accessors.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/aic7xxx/aic7xxx_osm.c |   25 +++++++++----------------
 drivers/scsi/aic7xxx/aic7xxx_osm.h |    4 ++--
 2 files changed, 11 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index b053e6f..f97ae53 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -402,13 +402,8 @@ ahc_linux_unmap_scb(struct ahc_softc *ah
 
 	cmd = scb->io_ctx;
 	ahc_sync_sglist(ahc, scb, BUS_DMASYNC_POSTWRITE);
-	if (cmd->use_sg) {
-		struct scatterlist *sg;
 
-		sg = (struct scatterlist *)cmd->request_buffer;
-		pci_unmap_sg(ahc->dev_softc, sg, cmd->use_sg,
-			     cmd->sc_data_direction);
-	}
+	scsi_dma_unmap(&ahc->dev_softc->dev, cmd);
 }
 
 static __inline int
@@ -1376,6 +1371,7 @@ ahc_linux_run_command(struct ahc_softc *
 	struct	 ahc_tmode_tstate *tstate;
 	uint16_t mask;
 	struct scb_tailq *untagged_q = NULL;
+	int nseg;
 
 	/*
 	 * Schedule us to run later.  The only reason we are not
@@ -1467,23 +1463,21 @@ ahc_linux_run_command(struct ahc_softc *
 	ahc_set_residual(scb, 0);
 	ahc_set_sense_residual(scb, 0);
 	scb->sg_count = 0;
-	if (cmd->use_sg) {
+
+	nseg = scsi_dma_map(&ahc->dev_softc->dev, cmd);
+	BUG_ON(nseg < 0);
+	if (nseg > 0) {
 		struct	ahc_dma_seg *sg;
 		struct	scatterlist *cur_seg;
-		struct	scatterlist *end_seg;
-		int	nseg;
+		int i;
 
-		cur_seg = (struct scatterlist *)cmd->request_buffer;
-		nseg = pci_map_sg(ahc->dev_softc, cur_seg, cmd->use_sg,
-				  cmd->sc_data_direction);
-		end_seg = cur_seg + nseg;
 		/* Copy the segments into the SG list. */
 		sg = scb->sg_list;
 		/*
 		 * The sg_count may be larger than nseg if
 		 * a transfer crosses a 32bit page.
-		 */ 
-		while (cur_seg < end_seg) {
+		 */
+		scsi_for_each_sg(cmd, cur_seg, nseg, i) {
 			dma_addr_t addr;
 			bus_size_t len;
 			int consumed;
@@ -1494,7 +1488,6 @@ ahc_linux_run_command(struct ahc_softc *
 						     sg, addr, len);
 			sg += consumed;
 			scb->sg_count += consumed;
-			cur_seg++;
 		}
 		sg--;
 		sg->len |= ahc_htole32(AHC_DMA_LAST_SEG);
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.h b/drivers/scsi/aic7xxx/aic7xxx_osm.h
index 8fee7ed..346272b 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.h
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.h
@@ -751,7 +751,7 @@ int ahc_get_transfer_dir(struct scb *scb
 static __inline
 void ahc_set_residual(struct scb *scb, u_long resid)
 {
-	scb->io_ctx->resid = resid;
+	scsi_resid(scb->io_ctx) = resid;
 }
 
 static __inline
@@ -763,7 +763,7 @@ void ahc_set_sense_residual(struct scb *
 static __inline
 u_long ahc_get_residual(struct scb *scb)
 {
-	return (scb->io_ctx->resid);
+	return scsi_resid(scb->io_ctx);
 }
 
 static __inline
-- 
1.4.3.2

