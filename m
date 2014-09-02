From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH] bnx2fc: fix incorrect DMA memory mapping in bnx2fc_unmap_sg_list()
Date: Tue, 2 Sep 2014 14:34:58 -0400
Message-ID: <1409682898-29777-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:36973 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754729AbaIBTII (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Sep 2014 15:08:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, hch@lst.de
Cc: giridhar.malavali@qlogic.com

This patch is based on a problem and solution from Maurizio Lombardi
where bnx2fc isn't consistent in which device struct we using for DMA
map and unmap operations.  Make them consistent by using dma_sg_unmap
in bnx2fc_unmap_sg_list like bnx2fc_map_sg.

Reviewed-by: Eddie Wai <eddie.wai@broadcom.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/bnx2fc/bnx2fc_io.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 4c5891e..0679782 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1654,6 +1654,10 @@ static int bnx2fc_map_sg(struct bnx2fc_cmd *io_req)
 	u64 addr;
 	int i;
 
+	/*
+	 * Use dma_map_sg directly to ensure we're using the correct
+	 * dev struct off of pcidev.
+	 */
 	sg_count = dma_map_sg(&hba->pcidev->dev, scsi_sglist(sc),
 			      scsi_sg_count(sc), sc->sc_data_direction);
 	scsi_for_each_sg(sc, sg, sg_count, i) {
@@ -1703,9 +1707,16 @@ static int bnx2fc_build_bd_list_from_sg(struct bnx2fc_cmd *io_req)
 static void bnx2fc_unmap_sg_list(struct bnx2fc_cmd *io_req)
 {
 	struct scsi_cmnd *sc = io_req->sc_cmd;
+	struct bnx2fc_interface *interface = io_req->port->priv;
+	struct bnx2fc_hba *hba = interface->hba;
 
-	if (io_req->bd_tbl->bd_valid && sc) {
-		scsi_dma_unmap(sc);
+	/*
+	 * Use dma_unmap_sg directly to ensure we're using the correct
+	 * dev struct off of pcidev.
+	 */
+	if (io_req->bd_tbl->bd_valid && sc && scsi_sg_count(sc)) {
+		dma_unmap_sg(&hba->pcidev->dev, scsi_sglist(sc),
+		    scsi_sg_count(sc), sc->sc_data_direction);
 		io_req->bd_tbl->bd_valid = 0;
 	}
 }
-- 
1.8.5.2

