From: Joe Perches <joe@perches.com>
Subject: [PATCH -next 21/26] mvsas: Use dma_zalloc_coherent
Date: Sun, 15 Jun 2014 13:37:50 -0700
Message-ID: <14794c36cbcb12d3ceac3f99773d4c8921d13734.1402863905.git.joe@perches.com>
References: <cover.1402863904.git.joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1402863904.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Use the zeroing function instead of dma_alloc_coherent & memset(,0,)

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/mvsas/mv_init.c | 26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index eacee48..9aedbd5 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -263,33 +263,29 @@ static int mvs_alloc(struct mvs_info *mvi, struct Scsi_Host *shost)
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
+
+	mvi->rx_fis = dma_zalloc_coherent(mvi->dev, MVS_RX_FISL_SZ,
+					  &mvi->rx_fis_dma, GFP_KERNEL);
 	if (!mvi->rx_fis)
 		goto err_out;
-	memset(mvi->rx_fis, 0, MVS_RX_FISL_SZ);
 
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
+	mvi->slot = dma_zalloc_coherent(mvi->dev, sizeof(*mvi->slot) * slot_nr,
+					&mvi->slot_dma, GFP_KERNEL);
 	if (!mvi->slot)
 		goto err_out;
-	memset(mvi->slot, 0, sizeof(*mvi->slot) * slot_nr);
 
 	mvi->bulk_buffer = dma_alloc_coherent(mvi->dev,
 				       TRASH_BUCKET_SIZE,
-- 
1.8.1.2.459.gbcd45b4.dirty
