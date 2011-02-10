From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 2/3] libsrp: fix dma_unmap_sg
Date: Thu, 10 Feb 2011 21:21:34 +0900
Message-ID: <1297340495-13347-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1297340495-13347-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:49648 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754978Ab1BJM1H (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Feb 2011 07:27:07 -0500
In-Reply-To: <1297340495-13347-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: nab@linux-iscsi.org, fujita.tomonori@lab.ntt.co.jp

Needs to pass the number of scatterlist entries that passed in to
dma_map_sg.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/libsrp.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libsrp.c b/drivers/scsi/libsrp.c
index 01c4010..938e5e0 100644
--- a/drivers/scsi/libsrp.c
+++ b/drivers/scsi/libsrp.c
@@ -206,7 +206,8 @@ static int srp_direct_data(struct scsi_cmnd *sc, struct srp_direct_buf *md,
 	err = rdma_io(sc, sg, nsg, md, 1, dir, len);
 
 	if (dma_map)
-		dma_unmap_sg(iue->target->dev, sg, nsg, DMA_BIDIRECTIONAL);
+		dma_unmap_sg(iue->target->dev, sg, scsi_sg_count(sc),
+			     DMA_BIDIRECTIONAL);
 
 	return err;
 }
@@ -278,7 +279,8 @@ rdma:
 	err = rdma_io(sc, sg, nsg, md, nmd, dir, len);
 
 	if (dma_map)
-		dma_unmap_sg(iue->target->dev, sg, nsg, DMA_BIDIRECTIONAL);
+		dma_unmap_sg(iue->target->dev, sg, scsi_sg_count(sc),
+			     DMA_BIDIRECTIONAL);
 
 free_mem:
 	if (token && dma_map)
-- 
1.7.2.3

