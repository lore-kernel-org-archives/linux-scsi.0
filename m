From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH v2 1/3] scsi: arcmsr: Use dma_alloc_coherent to replace
 dma_zalloc_coherent
Date: Fri, 18 Jan 2019 10:53:41 +0800
Message-ID: <1547780021.4532.14.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dan.carpenter@oracle.com, hch@infradead.org, colin.king@canonical.com
List-Id: linux-scsi@vger.kernel.org

>From Ching Huang <ching2048@areca.com.tw>

Due to dma_zalloc_coherent will be phase out, so use dma_alloc_coherent
 instead.

Signed-off-by: Ching Huang <ching2048@areca.com.tw>
---

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 9f85d5a..5736434 100755
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -642,7 +642,7 @@ static bool arcmsr_alloc_io_queue(struct AdapterControlBlock *acb)
 	switch (acb->adapter_type) {
 	case ACB_ADAPTER_TYPE_B: {
 		acb->ioqueue_size = roundup(sizeof(struct MessageUnit_B), 32);
-		dma_coherent = dma_zalloc_coherent(&pdev->dev, acb->ioqueue_size,
+		dma_coherent = dma_alloc_coherent(&pdev->dev, acb->ioqueue_size,
 			&dma_coherent_handle, GFP_KERNEL);
 		if (!dma_coherent) {
 			pr_notice("arcmsr%d: DMA allocation failed\n", acb->host->host_no);
@@ -656,7 +656,7 @@ static bool arcmsr_alloc_io_queue(struct AdapterControlBlock *acb)
 		break;
 	case ACB_ADAPTER_TYPE_D: {
 		acb->ioqueue_size = roundup(sizeof(struct MessageUnit_D), 32);
-		dma_coherent = dma_zalloc_coherent(&pdev->dev, acb->ioqueue_size,
+		dma_coherent = dma_alloc_coherent(&pdev->dev, acb->ioqueue_size,
 			&dma_coherent_handle, GFP_KERNEL);
 		if (!dma_coherent) {
 			pr_notice("arcmsr%d: DMA allocation failed\n", acb->host->host_no);
@@ -672,7 +672,7 @@ static bool arcmsr_alloc_io_queue(struct AdapterControlBlock *acb)
 		uint32_t completeQ_size;
 		completeQ_size = sizeof(struct deliver_completeQ) * ARCMSR_MAX_HBE_DONEQUEUE + 128;
 		acb->ioqueue_size = roundup(completeQ_size, 32);
-		dma_coherent = dma_zalloc_coherent(&pdev->dev, acb->ioqueue_size,
+		dma_coherent = dma_alloc_coherent(&pdev->dev, acb->ioqueue_size,
 			&dma_coherent_handle, GFP_KERNEL);
 		if (!dma_coherent){
 			pr_notice("arcmsr%d: DMA allocation failed\n", acb->host->host_no);
