From: Al Viro <viro@ftp.linux.org.uk>
Subject: deal with resource allocation bugs in arcmsr
Date: Mon, 29 Oct 2007 05:08:38 +0000
Message-ID: <E1ImMre-0003SX-PY@ZenIV.linux.org.uk>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:35937 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbXJ2FIj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Oct 2007 01:08:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: nick.cheng@areca.com.tw, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org


a) for type B we should _not_ iounmap() acb->pmu; it's not ioremapped.
b) for type B we should iounmap() two regions we _do_ ioremap.
c) if ioremap() fails, we need to bail out (and clean up).

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/scsi/arcmsr/arcmsr.h     |    9 ---------
 drivers/scsi/arcmsr/arcmsr_hba.c |   33 ++++++++++++++++++++++++++++++---
 2 files changed, 30 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
index 3c38cd8..a67e29f 100644
--- a/drivers/scsi/arcmsr/arcmsr.h
+++ b/drivers/scsi/arcmsr/arcmsr.h
@@ -348,14 +348,6 @@ struct MessageUnit_B
 	uint32_t	__iomem *ioctl_rbuffer_reg;
 };
 
-struct MessageUnit
-{
-	union
-	{
-		struct MessageUnit_A	pmu_A;
-		struct MessageUnit_B	pmu_B;
-	} u;
-};
 /*
 *******************************************************************************
 **                 Adapter Control Block
@@ -375,7 +367,6 @@ struct AdapterControlBlock
 	uint32_t			outbound_int_enable;
 
 	union {
-		struct MessageUnit *		pmu;
 		struct MessageUnit_A __iomem *	pmuA;
 		struct MessageUnit_B *		pmuB;
 	};
diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index aaee028..152af46 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -240,14 +240,18 @@ static int arcmsr_alloc_ccb_pool(struct AdapterControlBlock *acb)
 		if (!acb->pmuA) {
 			printk(KERN_NOTICE "arcmsr%d: memory mapping region fail \n",
 							acb->host->host_no);
+			return -ENOMEM;
 		}
 
 		dma_coherent = dma_alloc_coherent(&pdev->dev,
 			ARCMSR_MAX_FREECCB_NUM *
 			sizeof (struct CommandControlBlock) + 0x20,
 			&dma_coherent_handle, GFP_KERNEL);
-		if (!dma_coherent)
+
+		if (!dma_coherent) {
+			iounmap(acb->pmuA);
 			return -ENOMEM;
+		}
 
 		acb->dma_coherent = dma_coherent;
 		acb->dma_coherent_handle = dma_coherent_handle;
@@ -331,8 +335,16 @@ static int arcmsr_alloc_ccb_pool(struct AdapterControlBlock *acb)
 		acb->pmuB = reg;
 		mem_base0 = ioremap(pci_resource_start(pdev, 0),
 					pci_resource_len(pdev, 0));
+		if (!mem_base0)
+			goto out;
+
 		mem_base1 = ioremap(pci_resource_start(pdev, 2),
 					pci_resource_len(pdev, 2));
+		if (!mem_base1) {
+			iounmap(mem_base0);
+			goto out;
+		}
+
 		reg->drv2iop_doorbell_reg = mem_base0 + ARCMSR_DRV2IOP_DOORBELL;
 		reg->drv2iop_doorbell_mask_reg = mem_base0 +
 						ARCMSR_DRV2IOP_DOORBELL_MASK;
@@ -357,6 +369,12 @@ static int arcmsr_alloc_ccb_pool(struct AdapterControlBlock *acb)
 		break;
 	}
 	return 0;
+
+out:
+	dma_free_coherent(&acb->pdev->dev,
+		ARCMSR_MAX_FREECCB_NUM * sizeof(struct CommandControlBlock) + 0x20,
+		acb->dma_coherent, acb->dma_coherent_handle);
+	return -ENOMEM;
 }
 
 static int arcmsr_probe(struct pci_dev *pdev,
@@ -449,7 +467,6 @@ static int arcmsr_probe(struct pci_dev *pdev,
 	free_irq(pdev->irq, acb);
  out_free_ccb_pool:
 	arcmsr_free_ccb_pool(acb);
-	iounmap(acb->pmu);
  out_release_regions:
 	pci_release_regions(pdev);
  out_host_put:
@@ -810,7 +827,6 @@ static void arcmsr_remove(struct pci_dev *pdev)
 	}
 
 	free_irq(pdev->irq, acb);
-	iounmap(acb->pmu);
 	arcmsr_free_ccb_pool(acb);
 	pci_release_regions(pdev);
 
@@ -1018,6 +1034,17 @@ static void arcmsr_stop_adapter_bgrb(struct AdapterControlBlock *acb)
 
 static void arcmsr_free_ccb_pool(struct AdapterControlBlock *acb)
 {
+	switch (acb->adapter_type) {
+	case ACB_ADAPTER_TYPE_A: {
+		iounmap(acb->pmuA);
+		break;
+	}
+	case ACB_ADAPTER_TYPE_B: {
+		struct MessageUnit_B *reg = acb->pmuB;
+		iounmap(reg->drv2iop_doorbell_reg - ARCMSR_DRV2IOP_DOORBELL);
+		iounmap(reg->ioctl_wbuffer_reg - ARCMSR_IOCTL_WBUFFER);
+	}
+	}
 	dma_free_coherent(&acb->pdev->dev,
 		ARCMSR_MAX_FREECCB_NUM * sizeof (struct CommandControlBlock) + 0x20,
 		acb->dma_coherent,
-- 
1.5.3.GIT


