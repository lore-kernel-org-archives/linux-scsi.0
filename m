From: Joe Perches <joe@perches.com>
Subject: [PATCH -next 17/26] bnx2i: Use dma_zalloc_coherent
Date: Sun, 15 Jun 2014 13:37:46 -0700
Message-ID: <0a345660032e6312bb4cd1bd4abefd0b9836e9e4.1402863905.git.joe@perches.com>
References: <cover.1402863904.git.joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1402863904.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Eddie Wai <eddie.wai@broadcom.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Use the zeroing function instead of dma_alloc_coherent & memset(,0,)

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/bnx2i/bnx2i_hwi.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index d6d491c..12d38e8 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -1080,16 +1080,15 @@ int bnx2i_alloc_qp_resc(struct bnx2i_hba *hba, struct bnx2i_endpoint *ep)
 	}
 
 	/* Allocate memory area for actual SQ element */
-	ep->qp.sq_virt =
-		dma_alloc_coherent(&hba->pcidev->dev, ep->qp.sq_mem_size,
-				   &ep->qp.sq_phys, GFP_KERNEL);
+	ep->qp.sq_virt = dma_zalloc_coherent(&hba->pcidev->dev,
+					     ep->qp.sq_mem_size,
+					     &ep->qp.sq_phys, GFP_KERNEL);
 	if (!ep->qp.sq_virt) {
 		printk(KERN_ALERT "bnx2i: unable to alloc SQ BD memory %d\n",
 				  ep->qp.sq_mem_size);
 		goto mem_alloc_err;
 	}
 
-	memset(ep->qp.sq_virt, 0x00, ep->qp.sq_mem_size);
 	ep->qp.sq_first_qe = ep->qp.sq_virt;
 	ep->qp.sq_prod_qe = ep->qp.sq_first_qe;
 	ep->qp.sq_cons_qe = ep->qp.sq_first_qe;
@@ -1117,15 +1116,14 @@ int bnx2i_alloc_qp_resc(struct bnx2i_hba *hba, struct bnx2i_endpoint *ep)
 	}
 
 	/* Allocate memory area for actual CQ element */
-	ep->qp.cq_virt =
-		dma_alloc_coherent(&hba->pcidev->dev, ep->qp.cq_mem_size,
-				   &ep->qp.cq_phys, GFP_KERNEL);
+	ep->qp.cq_virt = dma_zalloc_coherent(&hba->pcidev->dev,
+					     ep->qp.cq_mem_size,
+					     &ep->qp.cq_phys, GFP_KERNEL);
 	if (!ep->qp.cq_virt) {
 		printk(KERN_ALERT "bnx2i: unable to alloc CQ BD memory %d\n",
 				  ep->qp.cq_mem_size);
 		goto mem_alloc_err;
 	}
-	memset(ep->qp.cq_virt, 0x00, ep->qp.cq_mem_size);
 
 	ep->qp.cq_first_qe = ep->qp.cq_virt;
 	ep->qp.cq_prod_qe = ep->qp.cq_first_qe;
-- 
1.8.1.2.459.gbcd45b4.dirty
