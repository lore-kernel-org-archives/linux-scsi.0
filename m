From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH 1/12] scsi: arcmsr: Rename acb structure member
 roundup_ccbsize to ioqueue_size
Date: Wed, 19 Dec 2018 16:24:03 +0800
Message-ID: <1545207843.4457.15.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dan.carpenter@oracle.com, hch@infradead.org, colin.king@canonical.com
List-Id: linux-scsi@vger.kernel.org

>From Ching Huang <ching2048@areca.com.tw>

Rename acb structure member roundup_ccbsize to ioqueue_size

Signed-off-by: Ching Huang <ching2048@areca.com.tw>
---

diff --git a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
index 9c397a2..256fe9a 100755
--- a/drivers/scsi/arcmsr/arcmsr.h
+++ b/drivers/scsi/arcmsr/arcmsr.h
@@ -739,7 +739,7 @@ struct AdapterControlBlock
 #define ACB_ADAPTER_TYPE_C		0x00000002	/* hbc L IOP */
 #define ACB_ADAPTER_TYPE_D		0x00000003	/* hbd M IOP */
 #define ACB_ADAPTER_TYPE_E		0x00000004	/* hba L IOP */
-	u32			roundup_ccbsize;
+	u32			ioqueue_size;
 	struct pci_dev *	pdev;
 	struct Scsi_Host *	host;
 	unsigned long		vir2phy_offset;
diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 0f6751b..f3a7855 100755
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -229,7 +229,7 @@ static void arcmsr_free_mu(struct AdapterControlBlock *acb)
 	case ACB_ADAPTER_TYPE_B:
 	case ACB_ADAPTER_TYPE_D:
 	case ACB_ADAPTER_TYPE_E: {
-		dma_free_coherent(&acb->pdev->dev, acb->roundup_ccbsize,
+		dma_free_coherent(&acb->pdev->dev, acb->ioqueue_size,
 			acb->dma_coherent2, acb->dma_coherent_handle2);
 		break;
 	}
@@ -586,8 +586,8 @@ static bool arcmsr_alloc_io_queue(struct AdapterControlBlock *acb)
 	switch (acb->adapter_type) {
 	case ACB_ADAPTER_TYPE_B: {
 		struct MessageUnit_B *reg;
-		acb->roundup_ccbsize = roundup(sizeof(struct MessageUnit_B), 32);
-		dma_coherent = dma_zalloc_coherent(&pdev->dev, acb->roundup_ccbsize,
+		acb->ioqueue_size = roundup(sizeof(struct MessageUnit_B), 32);
+		dma_coherent = dma_zalloc_coherent(&pdev->dev, acb->ioqueue_size,
 			&dma_coherent_handle, GFP_KERNEL);
 		if (!dma_coherent) {
 			pr_notice("arcmsr%d: DMA allocation failed\n", acb->host->host_no);
@@ -616,8 +616,8 @@ static bool arcmsr_alloc_io_queue(struct AdapterControlBlock *acb)
 	case ACB_ADAPTER_TYPE_D: {
 		struct MessageUnit_D *reg;
 
-		acb->roundup_ccbsize = roundup(sizeof(struct MessageUnit_D), 32);
-		dma_coherent = dma_zalloc_coherent(&pdev->dev, acb->roundup_ccbsize,
+		acb->ioqueue_size = roundup(sizeof(struct MessageUnit_D), 32);
+		dma_coherent = dma_zalloc_coherent(&pdev->dev, acb->ioqueue_size,
 			&dma_coherent_handle, GFP_KERNEL);
 		if (!dma_coherent) {
 			pr_notice("arcmsr%d: DMA allocation failed\n", acb->host->host_no);
@@ -658,8 +658,8 @@ static bool arcmsr_alloc_io_queue(struct AdapterControlBlock *acb)
 	case ACB_ADAPTER_TYPE_E: {
 		uint32_t completeQ_size;
 		completeQ_size = sizeof(struct deliver_completeQ) * ARCMSR_MAX_HBE_DONEQUEUE + 128;
-		acb->roundup_ccbsize = roundup(completeQ_size, 32);
-		dma_coherent = dma_zalloc_coherent(&pdev->dev, acb->roundup_ccbsize,
+		acb->ioqueue_size = roundup(completeQ_size, 32);
+		dma_coherent = dma_zalloc_coherent(&pdev->dev, acb->ioqueue_size,
 			&dma_coherent_handle, GFP_KERNEL);
 		if (!dma_coherent){
 			pr_notice("arcmsr%d: DMA allocation failed\n", acb->host->host_no);
@@ -668,7 +668,7 @@ static bool arcmsr_alloc_io_queue(struct AdapterControlBlock *acb)
 		acb->dma_coherent_handle2 = dma_coherent_handle;
 		acb->dma_coherent2 = dma_coherent;
 		acb->pCompletionQ = dma_coherent;
-		acb->completionQ_entry = acb->roundup_ccbsize / sizeof(struct deliver_completeQ);
+		acb->completionQ_entry = acb->ioqueue_size / sizeof(struct deliver_completeQ);
 		acb->doneq_index = 0;
 		}
 		break;
@@ -3787,7 +3787,7 @@ static int arcmsr_iop_confirm(struct AdapterControlBlock *acb)
 		cdb_phyaddr_hi32 = (uint32_t)((dma_coherent_handle >> 16) >> 16);
 		writel(cdb_phyaddr, &reg->msgcode_rwbuffer[5]);
 		writel(cdb_phyaddr_hi32, &reg->msgcode_rwbuffer[6]);
-		writel(acb->roundup_ccbsize, &reg->msgcode_rwbuffer[7]);
+		writel(acb->ioqueue_size, &reg->msgcode_rwbuffer[7]);
 		writel(ARCMSR_INBOUND_MESG0_SET_CONFIG, &reg->inbound_msgaddr0);
 		acb->out_doorbell ^= ARCMSR_HBEMU_DRV2IOP_MESSAGE_CMD_DONE;
 		writel(acb->out_doorbell, &reg->iobound_doorbell);
