From: Ching Huang <ching2048@areca.com.tw>
Subject: Re: [PATCH 2/2] arcmsr: adds code for support areca new adapter
 ARC1203
Date: Tue, 24 Nov 2015 19:20:07 +0800
Message-ID: <1448364007.15088.26.camel@Centos6.3-64>
References: <1448353024.12861.56.camel@Centos6.3-64>
	 <1448357586.14504.12.camel@perches.com>
	 <1448358798.14472.3.camel@Centos6.3-64>
	 <1448360674.20113.5.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1448360674.20113.5.camel@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: hch@infradead.org, thenzl@redhat.com, jbottomley@parallels.com, dan.carpenter@oracle.com, agordeev@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hch@lst.de
List-Id: linux-scsi@vger.kernel.org

On Tue, 2015-11-24 at 02:24 -0800, Joe Perches wrote:
> On Tue, 2015-11-24 at 17:53 +0800, Ching Huang wrote:
> > On Tue, 2015-11-24 at 01:33 -0800, Joe Perches wrote:
> > > On Tue, 2015-11-24 at 16:17 +0800, Ching Huang wrote:
> > > > From: Ching Huang <ching2048@areca.com.tw>
> > > > 
> > > > Support areca new PCIe to SATA RAID adapter ARC1203
> > > 
> > > Why add the dma_free_coherent to an old data path?
> > > Is that a general bug fix that should be backported?
> > 
> > That's right. It's need to release the allocated resource for failed
> > condition.
> 
> Then the dma_free_coherent addition should be a separate patch.
> 
> Style trivia:
> 
> The goto to another error path like that is odd and
> the label is unintelligible.
> 
> Ideally error condition handling would use a goto and
> a separate and obviously named label.  Use multiple
> labels for cases with more complicated unwinding.
> 
> Dan Carpenter has written about this several times.
> 
> For this use, something like:
> 
> 	writel(ARCMSR_MESSAGE_START_DRIVER_MODE, reg->drv2iop_doorbell);
> 	if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
> 		logging_message(...);
> 		goto
> err_free_resource;
> 	}
> 	writel(ARCMSR_MESSAGE_GET_CONFIG, reg->drv2iop_doorbell);
> 	if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
> 		logging_message(...);
> 		goto err_free_resource;
> 	}
> 
> 	[success path...]
> 
> 	return true;
> 
> err_free_resource:
> 	dma_free_coherent(...);
> 
> 	return false;
> }
> 
Thanks for Joe's advice.
Revised as below.

Signed-of-by: Ching Huang <ching2048@arcea.com.tw>

---
diff -uprN a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
--- a/drivers/scsi/arcmsr/arcmsr.h	2015-11-24 11:36:20.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr.h	2015-10-19 15:57:08.000000000 +0800
@@ -74,6 +74,9 @@ struct device_attribute;
 #ifndef PCI_DEVICE_ID_ARECA_1214
 	#define PCI_DEVICE_ID_ARECA_1214	0x1214
 #endif
+#ifndef PCI_DEVICE_ID_ARECA_1203
+	#define PCI_DEVICE_ID_ARECA_1203	0x1203
+#endif
 /*

**********************************************************************************
 **
@@ -245,6 +248,12 @@ struct FIRMWARE_INFO
 /* window of "instruction flags" from iop to driver */
 #define ARCMSR_IOP2DRV_DOORBELL                       0x00020408
 #define ARCMSR_IOP2DRV_DOORBELL_MASK                  0x0002040C
+/* window of "instruction flags" from iop to driver */
+#define ARCMSR_IOP2DRV_DOORBELL_1203                  0x00021870
+#define ARCMSR_IOP2DRV_DOORBELL_MASK_1203             0x00021874
+/* window of "instruction flags" from driver to iop */
+#define ARCMSR_DRV2IOP_DOORBELL_1203                  0x00021878
+#define ARCMSR_DRV2IOP_DOORBELL_MASK_1203             0x0002187C
 /* ARECA FLAG LANGUAGE */
 /* ioctl transfer */
 #define ARCMSR_IOP2DRV_DATA_WRITE_OK                  0x00000001
diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c
b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2015-11-24 11:35:26.000000000
+0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2015-11-24 18:58:40.640226000
+0800
@@ -114,6 +114,7 @@ static void arcmsr_hardware_reset(struct
 static const char *arcmsr_info(struct Scsi_Host *);
 static irqreturn_t arcmsr_interrupt(struct AdapterControlBlock *acb);
 static void arcmsr_free_irq(struct pci_dev *, struct
AdapterControlBlock *);
+static void arcmsr_wait_firmware_ready(struct AdapterControlBlock
*acb);
 static int arcmsr_adjust_disk_queue_depth(struct scsi_device *sdev, int
queue_depth)
 {
 	if (queue_depth > ARCMSR_MAX_CMD_PERLUN)
@@ -157,6 +158,8 @@ static struct pci_device_id arcmsr_devic
 		.driver_data = ACB_ADAPTER_TYPE_B},
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1202),
 		.driver_data = ACB_ADAPTER_TYPE_B},
+	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1203),
+		.driver_data = ACB_ADAPTER_TYPE_B},
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1210),
 		.driver_data = ACB_ADAPTER_TYPE_A},
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1214),
@@ -2621,7 +2624,7 @@ static bool arcmsr_hbaA_get_config(struc
 }
 static bool arcmsr_hbaB_get_config(struct AdapterControlBlock *acb)
 {
-	struct MessageUnit_B *reg = acb->pmuB;
+	struct MessageUnit_B *reg;
 	struct pci_dev *pdev = acb->pdev;
 	void *dma_coherent;
 	dma_addr_t dma_coherent_handle;
@@ -2649,10 +2652,17 @@ static bool arcmsr_hbaB_get_config(struc
 	acb->dma_coherent2 = dma_coherent;
 	reg = (struct MessageUnit_B *)dma_coherent;
 	acb->pmuB = reg;
-	reg->drv2iop_doorbell= (uint32_t __iomem *)((unsigned
long)acb->mem_base0 + ARCMSR_DRV2IOP_DOORBELL);
-	reg->drv2iop_doorbell_mask = (uint32_t __iomem *)((unsigned
long)acb->mem_base0 + ARCMSR_DRV2IOP_DOORBELL_MASK);
-	reg->iop2drv_doorbell = (uint32_t __iomem *)((unsigned
long)acb->mem_base0 + ARCMSR_IOP2DRV_DOORBELL);
-	reg->iop2drv_doorbell_mask = (uint32_t __iomem *)((unsigned
long)acb->mem_base0 + ARCMSR_IOP2DRV_DOORBELL_MASK);
+	if (acb->pdev->device == PCI_DEVICE_ID_ARECA_1203) {
+		reg->drv2iop_doorbell = (uint32_t __iomem *)((unsigned
long)acb->mem_base0 + ARCMSR_DRV2IOP_DOORBELL_1203);
+		reg->drv2iop_doorbell_mask = (uint32_t __iomem *)((unsigned
long)acb->mem_base0 + ARCMSR_DRV2IOP_DOORBELL_MASK_1203);
+		reg->iop2drv_doorbell = (uint32_t __iomem *)((unsigned
long)acb->mem_base0 + ARCMSR_IOP2DRV_DOORBELL_1203);
+		reg->iop2drv_doorbell_mask = (uint32_t __iomem *)((unsigned
long)acb->mem_base0 + ARCMSR_IOP2DRV_DOORBELL_MASK_1203);
+	} else {
+		reg->drv2iop_doorbell= (uint32_t __iomem *)((unsigned
long)acb->mem_base0 + ARCMSR_DRV2IOP_DOORBELL);
+		reg->drv2iop_doorbell_mask = (uint32_t __iomem *)((unsigned
long)acb->mem_base0 + ARCMSR_DRV2IOP_DOORBELL_MASK);
+		reg->iop2drv_doorbell = (uint32_t __iomem *)((unsigned
long)acb->mem_base0 + ARCMSR_IOP2DRV_DOORBELL);
+		reg->iop2drv_doorbell_mask = (uint32_t __iomem *)((unsigned
long)acb->mem_base0 + ARCMSR_IOP2DRV_DOORBELL_MASK);
+	}
 	reg->message_wbuffer = (uint32_t __iomem *)((unsigned
long)acb->mem_base1 + ARCMSR_MESSAGE_WBUFFER);
 	reg->message_rbuffer =  (uint32_t __iomem *)((unsigned
long)acb->mem_base1 + ARCMSR_MESSAGE_RBUFFER);
 	reg->message_rwbuffer = (uint32_t __iomem *)((unsigned
long)acb->mem_base1 + ARCMSR_MESSAGE_RWBUFFER);
@@ -2660,11 +2670,17 @@ static bool arcmsr_hbaB_get_config(struc
 	iop_firm_version = (char __iomem
*)(&reg->message_rwbuffer[17]);	/*firm_version,17,68-83*/
 	iop_device_map = (char __iomem
*)(&reg->message_rwbuffer[21]);	/*firm_version,21,84-99*/
 
+	arcmsr_wait_firmware_ready(acb);
+	writel(ARCMSR_MESSAGE_START_DRIVER_MODE, reg->drv2iop_doorbell);
+	if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
+		printk(KERN_ERR "arcmsr%d: can't set driver mode.\n",
acb->host->host_no);
+		goto err_free_dma;
+	}
 	writel(ARCMSR_MESSAGE_GET_CONFIG, reg->drv2iop_doorbell);
 	if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
 		printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware \
 			miscellaneous data' timeout \n", acb->host->host_no);
-		return false;
+		goto err_free_dma;
 	}
 	count = 8;
 	while (count){
@@ -2707,6 +2723,10 @@ static bool arcmsr_hbaB_get_config(struc
 	acb->firm_cfg_version =
readl(&reg->message_rwbuffer[25]);  /*firm_cfg_version,25,100-103*/
 	/*firm_ide_channels,4,16-19*/
 	return true;
+err_free_dma:
+	dma_free_coherent(&acb->pdev->dev, acb->roundup_ccbsize,
+			acb->dma_coherent2, acb->dma_coherent_handle2);
+	return false;
 }
 
 static bool arcmsr_hbaC_get_config(struct AdapterControlBlock *pACB)
@@ -3998,6 +4018,7 @@ static const char *arcmsr_info(struct Sc
 	case PCI_DEVICE_ID_ARECA_1160:
 	case PCI_DEVICE_ID_ARECA_1170:
 	case PCI_DEVICE_ID_ARECA_1201:
+	case PCI_DEVICE_ID_ARECA_1203:
 	case PCI_DEVICE_ID_ARECA_1220:
 	case PCI_DEVICE_ID_ARECA_1230:
 	case PCI_DEVICE_ID_ARECA_1260:
