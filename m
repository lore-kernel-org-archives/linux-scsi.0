From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 18/19] aic79xx: remove the non-use-sg case
Date: Sat, 12 May 2007 19:05:45 +0900 (JST)
Message-ID: <20070512184621W.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:44892 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755623AbXELKF4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 12 May 2007 06:05:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org

This removes the non-use-sg case.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/aic7xxx/aic79xx_osm.c |   24 +++---------------------
 1 files changed, 3 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index 6054881..1b6dbc1 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -381,15 +381,11 @@ ahd_linux_unmap_scb(struct ahd_softc *ah
 	cmd = scb->io_ctx;
 	direction = cmd->sc_data_direction;
 	ahd_sync_sglist(ahd, scb, BUS_DMASYNC_POSTWRITE);
-	if (cmd->use_sg != 0) {
-		struct scatterlist *sg;
 
+	if (cmd->request_bufflen) {
+		struct scatterlist *sg;
 		sg = (struct scatterlist *)cmd->request_buffer;
 		pci_unmap_sg(ahd->dev_softc, sg, cmd->use_sg, direction);
-	} else if (cmd->request_bufflen != 0) {
-		pci_unmap_single(ahd->dev_softc,
-				 scb->platform_data->buf_busaddr,
-				 cmd->request_bufflen, direction);
 	}
 }
 
@@ -1494,7 +1490,7 @@ ahd_linux_run_command(struct ahd_softc *
 	ahd_set_residual(scb, 0);
 	ahd_set_sense_residual(scb, 0);
 	scb->sg_count = 0;
-	if (cmd->use_sg != 0) {
+	if (cmd->request_bufflen) {
 		void	*sg;
 		struct	 scatterlist *cur_seg;
 		u_int	 nseg;
@@ -1515,20 +1511,6 @@ ahd_linux_run_command(struct ahd_softc *
 			sg = ahd_sg_setup(ahd, scb, sg, addr, len,
 					  /*last*/nseg == 1);
 		}
-	} else if (cmd->request_bufflen != 0) {
-		void *sg;
-		dma_addr_t addr;
-		int dir;
-
-		sg = scb->sg_list;
-		dir = cmd->sc_data_direction;
-		addr = pci_map_single(ahd->dev_softc,
-				      cmd->request_buffer,
-				      cmd->request_bufflen, dir);
-		scb->platform_data->xfer_len = cmd->request_bufflen;
-		scb->platform_data->buf_busaddr = addr;
-		sg = ahd_sg_setup(ahd, scb, sg, addr,
-				  cmd->request_bufflen, /*last*/TRUE);
 	}
 
 	LIST_INSERT_HEAD(&ahd->pending_scbs, scb, pending_links);
-- 
1.4.3.2

