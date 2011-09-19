From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH 1/3] bnx2fc: Replace scsi_dma_map() with dma_map_sg().
Date: Mon, 19 Sep 2011 16:52:12 -0700
Message-ID: <1316476334-13232-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3223 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909Ab1ISXwV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Sep 2011 19:52:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, mchan@broadcom.com, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

scsi_dma_map doesn't work for NPIV since vport dev isn't fully initialized.

For more details: http://marc.info/?l=linux-scsi&m=118312448030633&w=2 and
commit - c59fd9ebc46da8d48b76955d4d48e3597f8c8726.

Signed-off-by: Nithin Sujir <nsujir@broadcom.com>
Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_io.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 120618d..86da301 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1568,6 +1568,8 @@ static int bnx2fc_split_bd(struct bnx2fc_cmd *io_req, u64 addr, int sg_len,
 
 static int bnx2fc_map_sg(struct bnx2fc_cmd *io_req)
 {
+	struct bnx2fc_interface *interface = io_req->port->priv;
+	struct bnx2fc_hba *hba = interface->hba;
 	struct scsi_cmnd *sc = io_req->sc_cmd;
 	struct fcoe_bd_ctx *bd = io_req->bd_tbl->bd_tbl;
 	struct scatterlist *sg;
@@ -1579,7 +1581,8 @@ static int bnx2fc_map_sg(struct bnx2fc_cmd *io_req)
 	u64 addr;
 	int i;
 
-	sg_count = scsi_dma_map(sc);
+	sg_count = dma_map_sg(&hba->pcidev->dev, scsi_sglist(sc),
+			      scsi_sg_count(sc), sc->sc_data_direction);
 	scsi_for_each_sg(sc, sg, sg_count, i) {
 		sg_len = sg_dma_len(sg);
 		addr = sg_dma_address(sg);
-- 
1.7.0.6


