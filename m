From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH v3 4/5] arcmsr: adds code for support areca new adapter
 ARC1203
Date: Wed, 25 Nov 2015 19:49:33 +0800
Message-ID: <1448452173.4670.44.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: hch@infradead.org, thenzl@redhat.com, jbottomley@parallels.com, dan.carpenter@oracle.com, agordeev@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hare@suse.de, jthumshirn@suse.de
Cc: hch@lst.de
List-Id: linux-scsi@vger.kernel.org

From: Ching Huang <ching2048@areca.com.tw>

Support areca new PCIe to SATA RAID adapter ARC1203

Signed-of-by: Ching Huang <ching2048@areca.com.tw>

---

diff -uprN a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
--- a/drivers/scsi/arcmsr/arcmsr.h	2015-11-25 19:10:21.309960000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr.h	2015-11-25 18:25:42.926038000 +0800
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
diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2015-11-25 19:11:27.679958000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2015-11-25 18:30:52.239029000 +0800
@@ -114,6 +114,7 @@ static void arcmsr_hardware_reset(struct
 static const char *arcmsr_info(struct Scsi_Host *);
 static irqreturn_t arcmsr_interrupt(struct AdapterControlBlock *acb);
 static void arcmsr_free_irq(struct pci_dev *, struct AdapterControlBlock *);
+static void arcmsr_wait_firmware_ready(struct AdapterControlBlock *acb);
 static int arcmsr_adjust_disk_queue_depth(struct scsi_device *sdev, int queue_depth)
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
-	reg->drv2iop_doorbell= MEM_BASE0(ARCMSR_DRV2IOP_DOORBELL);
-	reg->drv2iop_doorbell_mask = MEM_BASE0(ARCMSR_DRV2IOP_DOORBELL_MASK);
-	reg->iop2drv_doorbell = MEM_BASE0(ARCMSR_IOP2DRV_DOORBELL);
-	reg->iop2drv_doorbell_mask = MEM_BASE0(ARCMSR_IOP2DRV_DOORBELL_MASK);
+	if (acb->pdev->device == PCI_DEVICE_ID_ARECA_1203) {
+		reg->drv2iop_doorbell = MEM_BASE0(ARCMSR_DRV2IOP_DOORBELL_1203);
+		reg->drv2iop_doorbell_mask = MEM_BASE0(ARCMSR_DRV2IOP_DOORBELL_MASK_1203);
+		reg->iop2drv_doorbell = MEM_BASE0(ARCMSR_IOP2DRV_DOORBELL_1203);
+		reg->iop2drv_doorbell_mask = MEM_BASE0(ARCMSR_IOP2DRV_DOORBELL_MASK_1203);
+	} else {
+		reg->drv2iop_doorbell= MEM_BASE0(ARCMSR_DRV2IOP_DOORBELL);
+		reg->drv2iop_doorbell_mask = MEM_BASE0(ARCMSR_DRV2IOP_DOORBELL_MASK);
+		reg->iop2drv_doorbell = MEM_BASE0(ARCMSR_IOP2DRV_DOORBELL);
+		reg->iop2drv_doorbell_mask = MEM_BASE0(ARCMSR_IOP2DRV_DOORBELL_MASK);
+	}
 	reg->message_wbuffer = MEM_BASE1(ARCMSR_MESSAGE_WBUFFER);
 	reg->message_rbuffer =  MEM_BASE1(ARCMSR_MESSAGE_RBUFFER);
 	reg->message_rwbuffer = MEM_BASE1(ARCMSR_MESSAGE_RWBUFFER);
@@ -2660,6 +2670,12 @@ static bool arcmsr_hbaB_get_config(struc
 	iop_firm_version = (char __iomem *)(&reg->message_rwbuffer[17]);	/*firm_version,17,68-83*/
 	iop_device_map = (char __iomem *)(&reg->message_rwbuffer[21]);	/*firm_version,21,84-99*/
 
+	arcmsr_wait_firmware_ready(acb);
+	writel(ARCMSR_MESSAGE_START_DRIVER_MODE, reg->drv2iop_doorbell);
+	if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
+		printk(KERN_ERR "arcmsr%d: can't set driver mode.\n", acb->host->host_no);
+		goto err_free_dma;
+	}
 	writel(ARCMSR_MESSAGE_GET_CONFIG, reg->drv2iop_doorbell);
 	if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
 		printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware \
@@ -4002,6 +4018,7 @@ static const char *arcmsr_info(struct Sc
 	case PCI_DEVICE_ID_ARECA_1160:
 	case PCI_DEVICE_ID_ARECA_1170:
 	case PCI_DEVICE_ID_ARECA_1201:
+	case PCI_DEVICE_ID_ARECA_1203:
 	case PCI_DEVICE_ID_ARECA_1220:
 	case PCI_DEVICE_ID_ARECA_1230:
 	case PCI_DEVICE_ID_ARECA_1260:
