From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 19/19] aic79xx: convert to use the data buffer accessors
Date: Sat, 12 May 2007 19:05:45 +0900 (JST)
Message-ID: <20070512184624J.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:44886 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554AbXELKFz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 12 May 2007 06:05:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org

This converts aic79xx to use the data buffer accessors.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/aic7xxx/aic79xx_osm.c |   33 +++++++++++++--------------------
 drivers/scsi/aic7xxx/aic79xx_osm.h |    4 ++--
 2 files changed, 15 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index 1b6dbc1..bb23dca 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -376,17 +376,10 @@ static __inline void
 ahd_linux_unmap_scb(struct ahd_softc *ahd, struct scb *scb)
 {
 	struct scsi_cmnd *cmd;
-	int direction;
 
 	cmd = scb->io_ctx;
-	direction = cmd->sc_data_direction;
 	ahd_sync_sglist(ahd, scb, BUS_DMASYNC_POSTWRITE);
-
-	if (cmd->request_bufflen) {
-		struct scatterlist *sg;
-		sg = (struct scatterlist *)cmd->request_buffer;
-		pci_unmap_sg(ahd->dev_softc, sg, cmd->use_sg, direction);
-	}
+	scsi_dma_unmap(&ahd->dev_softc->dev, cmd);
 }
 
 /******************************** Macros **************************************/
@@ -1418,6 +1411,7 @@ ahd_linux_run_command(struct ahd_softc *
 	u_int	 col_idx;
 	uint16_t mask;
 	unsigned long flags;
+	int nseg;
 
 	ahd_lock(ahd, &flags);
 
@@ -1490,18 +1484,17 @@ ahd_linux_run_command(struct ahd_softc *
 	ahd_set_residual(scb, 0);
 	ahd_set_sense_residual(scb, 0);
 	scb->sg_count = 0;
-	if (cmd->request_bufflen) {
-		void	*sg;
-		struct	 scatterlist *cur_seg;
-		u_int	 nseg;
-		int	 dir;
-
-		cur_seg = (struct scatterlist *)cmd->request_buffer;
-		dir = cmd->sc_data_direction;
-		nseg = pci_map_sg(ahd->dev_softc, cur_seg,
-				  cmd->use_sg, dir);
+
+	nseg = scsi_dma_map(&ahd->dev_softc->dev, cmd);
+	BUG_ON(nseg < 0);
+	if (nseg > 0) {
+		void *sg = scb->sg_list;
+		struct scatterlist *cur_seg;
+		int i;
+
 		scb->platform_data->xfer_len = 0;
-		for (sg = scb->sg_list; nseg > 0; nseg--, cur_seg++) {
+
+		scsi_for_each_sg(cmd, cur_seg, nseg, i) {
 			dma_addr_t addr;
 			bus_size_t len;
 
@@ -1509,7 +1502,7 @@ ahd_linux_run_command(struct ahd_softc *
 			len = sg_dma_len(cur_seg);
 			scb->platform_data->xfer_len += len;
 			sg = ahd_sg_setup(ahd, scb, sg, addr, len,
-					  /*last*/nseg == 1);
+					  i == (nseg - 1));
 		}
 	}
 
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.h b/drivers/scsi/aic7xxx/aic79xx_osm.h
index ad9761b..f153986 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.h
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.h
@@ -781,7 +781,7 @@ int ahd_get_transfer_dir(struct scb *scb
 static __inline
 void ahd_set_residual(struct scb *scb, u_long resid)
 {
-	scb->io_ctx->resid = resid;
+	scsi_resid(scb->io_ctx) = resid;
 }
 
 static __inline
@@ -793,7 +793,7 @@ void ahd_set_sense_residual(struct scb *
 static __inline
 u_long ahd_get_residual(struct scb *scb)
 {
-	return (scb->io_ctx->resid);
+	return scsi_resid(scb->io_ctx);
 }
 
 static __inline
-- 
1.4.3.2

