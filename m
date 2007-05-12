From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 8/19] aic7xxx: remove the non-use-sg case
Date: Sat, 12 May 2007 19:05:43 +0900 (JST)
Message-ID: <20070512183728O.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:55469 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755327AbXELKFx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 12 May 2007 06:05:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org

This removes the non-use-sg case.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/aic7xxx/aic7xxx_osm.c |   36 ++----------------------------------
 1 files changed, 2 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index 660f26e..b053e6f 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -402,17 +402,12 @@ ahc_linux_unmap_scb(struct ahc_softc *ah
 
 	cmd = scb->io_ctx;
 	ahc_sync_sglist(ahc, scb, BUS_DMASYNC_POSTWRITE);
-	if (cmd->use_sg != 0) {
+	if (cmd->use_sg) {
 		struct scatterlist *sg;
 
 		sg = (struct scatterlist *)cmd->request_buffer;
 		pci_unmap_sg(ahc->dev_softc, sg, cmd->use_sg,
 			     cmd->sc_data_direction);
-	} else if (cmd->request_bufflen != 0) {
-		pci_unmap_single(ahc->dev_softc,
-				 scb->platform_data->buf_busaddr,
-				 cmd->request_bufflen,
-				 cmd->sc_data_direction);
 	}
 }
 
@@ -1472,7 +1467,7 @@ ahc_linux_run_command(struct ahc_softc *
 	ahc_set_residual(scb, 0);
 	ahc_set_sense_residual(scb, 0);
 	scb->sg_count = 0;
-	if (cmd->use_sg != 0) {
+	if (cmd->use_sg) {
 		struct	ahc_dma_seg *sg;
 		struct	scatterlist *cur_seg;
 		struct	scatterlist *end_seg;
@@ -1516,33 +1511,6 @@ ahc_linux_run_command(struct ahc_softc *
 		 */
 		scb->hscb->dataptr = scb->sg_list->addr;
 		scb->hscb->datacnt = scb->sg_list->len;
-	} else if (cmd->request_bufflen != 0) {
-		struct	 ahc_dma_seg *sg;
-		dma_addr_t addr;
-
-		sg = scb->sg_list;
-		addr = pci_map_single(ahc->dev_softc,
-				      cmd->request_buffer,
-				      cmd->request_bufflen,
-				      cmd->sc_data_direction);
-		scb->platform_data->buf_busaddr = addr;
-		scb->sg_count = ahc_linux_map_seg(ahc, scb,
-						  sg, addr,
-						  cmd->request_bufflen);
-		sg->len |= ahc_htole32(AHC_DMA_LAST_SEG);
-
-		/*
-		 * Reset the sg list pointer.
-		 */
-		scb->hscb->sgptr =
-			ahc_htole32(scb->sg_list_phys | SG_FULL_RESID);
-
-		/*
-		 * Copy the first SG into the "current"
-		 * data pointer area.
-		 */
-		scb->hscb->dataptr = sg->addr;
-		scb->hscb->datacnt = sg->len;
 	} else {
 		scb->hscb->sgptr = ahc_htole32(SG_LIST_NULL);
 		scb->hscb->dataptr = 0;
-- 
1.4.3.2

