From: Himanshu Jha <himanshujha199640@gmail.com>
Subject: [PATCH 9/9] scsi: bnx2i: Use zeroing allocator rather than allocator/memset
Date: Sat, 30 Dec 2017 20:58:32 +0530
Message-ID: <1514647712-6332-10-git-send-email-himanshujha199640@gmail.com>
References: <1514647712-6332-1-git-send-email-himanshujha199640@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:41014 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751380AbdL3Pad (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 30 Dec 2017 10:30:33 -0500
In-Reply-To: <1514647712-6332-1-git-send-email-himanshujha199640@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, aacraid@adaptec.com
Cc: anil.gurumurthy@qlogic.com, sudarsana.kalluru@qlogic.com, QLogic-Storage-Upstream@qlogic.com, satishkh@cisco.com, sebaddel@cisco.com, kartilak@cisco.com, QLogic-Storage-Upstream@cavium.com, qla2xxx-upstream@qlogic.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Himanshu Jha <himanshujha199640@gmail.com>

Use dma_zalloc_coherent instead of dma_alloc_coherent followed by
memset 0.

Generated-by: scripts/coccinelle/api/alloc/kzalloc-simple.cocci

Suggested-by: Luis R. Rodriguez <mcgrof@kernel.org>
Signed-off-by: Himanshu Jha <himanshujha199640@gmail.com>
---
 drivers/scsi/bnx2i/bnx2i_hwi.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index 9e3bf53..c6a0bd6 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -1069,16 +1069,15 @@ int bnx2i_alloc_qp_resc(struct bnx2i_hba *hba, struct bnx2i_endpoint *ep)
 	}
 
 	/* Allocate memory area for actual SQ element */
-	ep->qp.sq_virt =
-		dma_alloc_coherent(&hba->pcidev->dev, ep->qp.sq_mem_size,
-				   &ep->qp.sq_phys, GFP_KERNEL);
+	ep->qp.sq_virt =
+		dma_zalloc_coherent(&hba->pcidev->dev, ep->qp.sq_mem_size,
+					&ep->qp.sq_phys, GFP_KERNEL);
 	if (!ep->qp.sq_virt) {
 		printk(KERN_ALERT "bnx2i: unable to alloc SQ BD memory %d\n",
 				  ep->qp.sq_mem_size);
 		goto mem_alloc_err;
 	}
 
-	memset(ep->qp.sq_virt, 0x00, ep->qp.sq_mem_size);
 	ep->qp.sq_first_qe = ep->qp.sq_virt;
 	ep->qp.sq_prod_qe = ep->qp.sq_first_qe;
 	ep->qp.sq_cons_qe = ep->qp.sq_first_qe;
@@ -1106,15 +1105,14 @@ int bnx2i_alloc_qp_resc(struct bnx2i_hba *hba, struct bnx2i_endpoint *ep)
 	}
 
 	/* Allocate memory area for actual CQ element */
-	ep->qp.cq_virt =
-		dma_alloc_coherent(&hba->pcidev->dev, ep->qp.cq_mem_size,
-				   &ep->qp.cq_phys, GFP_KERNEL);
+	ep->qp.cq_virt =
+		dma_zalloc_coherent(&hba->pcidev->dev, ep->qp.cq_mem_size,
+					&ep->qp.cq_phys, GFP_KERNEL);
 	if (!ep->qp.cq_virt) {
 		printk(KERN_ALERT "bnx2i: unable to alloc CQ BD memory %d\n",
 				  ep->qp.cq_mem_size);
 		goto mem_alloc_err;
 	}
-	memset(ep->qp.cq_virt, 0x00, ep->qp.cq_mem_size);
 
 	ep->qp.cq_first_qe = ep->qp.cq_virt;
 	ep->qp.cq_prod_qe = ep->qp.cq_first_qe;
-- 
2.7.4
