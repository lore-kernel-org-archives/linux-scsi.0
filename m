From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH 10/12] scsi: arcmsr: Separate 'set dma mask' as a function
Date: Wed, 19 Dec 2018 16:56:34 +0800
Message-ID: <1545209794.4457.44.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dan.carpenter@oracle.com, hch@infradead.org, colin.king@canonical.com
List-Id: linux-scsi@vger.kernel.org

>From Ching Huang <ching2048@areca.com.tw>

Separate 'set dma mask' as a function

Signed-off-by: Ching Huang <ching2048@areca.com.tw>
---

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 45f1374..30dff6c 100755
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -927,6 +927,31 @@ static void arcmsr_init_set_datetime_timer(struct AdapterControlBlock *pacb)
 	add_timer(&pacb->refresh_timer);
 }
 
+static int arcmsr_set_dma_mask(struct AdapterControlBlock *acb)
+{
+	struct pci_dev *pcidev = acb->pdev;
+
+	if (IS_DMA64) {
+		if (((acb->adapter_type == ACB_ADAPTER_TYPE_A) && !dma_mask_64) ||
+		    dma_set_mask(&pcidev->dev, DMA_BIT_MASK(64)))
+			goto	dma32;
+		if (dma_set_coherent_mask(&pcidev->dev, DMA_BIT_MASK(64)) ||
+		    dma_set_mask_and_coherent(&pcidev->dev, DMA_BIT_MASK(64))) {
+			printk("arcmsr: set DMA 64 mask failed\n");
+			return -ENXIO;
+		}
+	} else {
+dma32:
+		if (dma_set_mask(&pcidev->dev, DMA_BIT_MASK(32)) ||
+		    dma_set_coherent_mask(&pcidev->dev, DMA_BIT_MASK(32)) ||
+		    dma_set_mask_and_coherent(&pcidev->dev, DMA_BIT_MASK(32))) {
+			printk("arcmsr: set DMA 32-bit mask failed\n");
+			return -ENXIO;
+		}
+	}
+	return 0;
+}
+
 static int arcmsr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct Scsi_Host *host;
@@ -941,22 +966,15 @@ static int arcmsr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if(!host){
     		goto pci_disable_dev;
 	}
-	error = dma_set_mask(&pdev->dev, DMA_BIT_MASK(64));
-	if(error){
-		error = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
-		if(error){
-			printk(KERN_WARNING
-			       "scsi%d: No suitable DMA mask available\n",
-			       host->host_no);
-			goto scsi_host_release;
-		}
-	}
 	init_waitqueue_head(&wait_q);
 	bus = pdev->bus->number;
 	dev_fun = pdev->devfn;
 	acb = (struct AdapterControlBlock *) host->hostdata;
 	memset(acb,0,sizeof(struct AdapterControlBlock));
 	acb->pdev = pdev;
+	acb->adapter_type = id->driver_data;
+	if (arcmsr_set_dma_mask(acb))
+		goto scsi_host_release;
 	acb->host = host;
 	host->max_lun = ARCMSR_MAX_TARGETLUN;
 	host->max_id = ARCMSR_MAX_TARGETID;		/*16:8*/
@@ -986,7 +1004,6 @@ static int arcmsr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 			ACB_F_MESSAGE_WQBUFFER_READED);
 	acb->acb_flags &= ~ACB_F_SCSISTOPADAPTER;
 	INIT_LIST_HEAD(&acb->ccb_free_list);
-	acb->adapter_type = id->driver_data;
 	error = arcmsr_remap_pciregion(acb);
 	if(!error){
 		goto pci_release_regs;
@@ -1077,7 +1094,6 @@ static int arcmsr_suspend(struct pci_dev *pdev, pm_message_t state)
 
 static int arcmsr_resume(struct pci_dev *pdev)
 {
-	int error;
 	struct Scsi_Host *host = pci_get_drvdata(pdev);
 	struct AdapterControlBlock *acb =
 		(struct AdapterControlBlock *)host->hostdata;
@@ -1089,15 +1105,8 @@ static int arcmsr_resume(struct pci_dev *pdev)
 		pr_warn("%s: pci_enable_device error\n", __func__);
 		return -ENODEV;
 	}
-	error = dma_set_mask(&pdev->dev, DMA_BIT_MASK(64));
-	if (error) {
-		error = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
-		if (error) {
-			pr_warn("scsi%d: No suitable DMA mask available\n",
-			       host->host_no);
-			goto controller_unregister;
-		}
-	}
+	if (arcmsr_set_dma_mask(acb))
+		goto controller_unregister;
 	pci_set_master(pdev);
 	if (arcmsr_request_irq(pdev, acb) == FAILED)
 		goto controller_stop;
