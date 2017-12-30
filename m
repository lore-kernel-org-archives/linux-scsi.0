From: Himanshu Jha <himanshujha199640@gmail.com>
Subject: [PATCH 4/9] scsi: mvsas: Use zeroing allocator rather than allocator/memset
Date: Sat, 30 Dec 2017 20:58:27 +0530
Message-ID: <1514647712-6332-5-git-send-email-himanshujha199640@gmail.com>
References: <1514647712-6332-1-git-send-email-himanshujha199640@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1514647712-6332-1-git-send-email-himanshujha199640@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, aacraid@adaptec.com
Cc: anil.gurumurthy@qlogic.com, sudarsana.kalluru@qlogic.com, QLogic-Storage-Upstream@qlogic.com, satishkh@cisco.com, sebaddel@cisco.com, kartilak@cisco.com, QLogic-Storage-Upstream@cavium.com, qla2xxx-upstream@qlogic.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Himanshu Jha <himanshujha199640@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Use dma_zalloc_coherent instead of dma_alloc_coherent followed by
memset 0.

Generated-by: scripts/coccinelle/api/alloc/kzalloc-simple.cocci

Suggested-by: Luis R. Rodriguez <mcgrof@kernel.org>
Signed-off-by: Himanshu Jha <himanshujha199640@gmail.com>
---
 drivers/scsi/mvsas/mv_init.c | 27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 8c91637..6748394 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -253,33 +253,28 @@ static int mvs_alloc(struct mvs_info *mvi, struct Scsi_Host *shost)
 	/*
 	 * alloc and init our DMA areas
 	 */
-	mvi->tx = dma_alloc_coherent(mvi->dev,
-				     sizeof(*mvi->tx) * MVS_CHIP_SLOT_SZ,
-				     &mvi->tx_dma, GFP_KERNEL);
+	mvi->tx = dma_zalloc_coherent(mvi->dev,
+				      sizeof(*mvi->tx) * MVS_CHIP_SLOT_SZ,
+				      &mvi->tx_dma, GFP_KERNEL);
 	if (!mvi->tx)
 		goto err_out;
-	memset(mvi->tx, 0, sizeof(*mvi->tx) * MVS_CHIP_SLOT_SZ);
-	mvi->rx_fis = dma_alloc_coherent(mvi->dev, MVS_RX_FISL_SZ,
-					 &mvi->rx_fis_dma, GFP_KERNEL);
+	mvi->rx_fis = dma_zalloc_coherent(mvi->dev, MVS_RX_FISL_SZ,
+					  &mvi->rx_fis_dma, GFP_KERNEL);
 	if (!mvi->rx_fis)
 		goto err_out;
-	memset(mvi->rx_fis, 0, MVS_RX_FISL_SZ);
-
-	mvi->rx = dma_alloc_coherent(mvi->dev,
-				     sizeof(*mvi->rx) * (MVS_RX_RING_SZ + 1),
-				     &mvi->rx_dma, GFP_KERNEL);
+	mvi->rx = dma_zalloc_coherent(mvi->dev,
+				      sizeof(*mvi->rx) * (MVS_RX_RING_SZ + 1),
+				      &mvi->rx_dma, GFP_KERNEL);
 	if (!mvi->rx)
 		goto err_out;
-	memset(mvi->rx, 0, sizeof(*mvi->rx) * (MVS_RX_RING_SZ + 1));
 	mvi->rx[0] = cpu_to_le32(0xfff);
 	mvi->rx_cons = 0xfff;
 
-	mvi->slot = dma_alloc_coherent(mvi->dev,
-				       sizeof(*mvi->slot) * slot_nr,
-				       &mvi->slot_dma, GFP_KERNEL);
+	mvi->slot = dma_zalloc_coherent(mvi->dev,
+					sizeof(*mvi->slot) * slot_nr,
+					&mvi->slot_dma, GFP_KERNEL);
 	if (!mvi->slot)
 		goto err_out;
-	memset(mvi->slot, 0, sizeof(*mvi->slot) * slot_nr);
 
 	mvi->bulk_buffer = dma_alloc_coherent(mvi->dev,
 				       TRASH_BUCKET_SIZE,
-- 
2.7.4
