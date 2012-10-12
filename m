From: "NickCheng" <nick.cheng@areca.com.tw>
Subject: [PATCH 4/5]  arcmsr: Support a New RAID Model, ARC-1214
Date: Fri, 12 Oct 2012 17:09:15 +0800
Message-ID: <6D1B4DF8848D47018A13D93D84AE0E35@arecaaebe11fae>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, jejb@kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Nick Cheng <nick.cheng@areca.com.tw>

Add a New RAID Model, ARC-1214, which can support 8 SATA HDs at most, so far.
Signed-off-by: Nick Cheng <nick.cheng@areca.com.tw>
---
diff -uprN a//drivers/scsi/arcmsr/arcmsr_attr.c b//drivers/scsi/arcmsr/arcmsr_attr.c
--- a//drivers/scsi/arcmsr/arcmsr_attr.c	2012-10-12 16:41:04.611951688 +0800
+++ b//drivers/scsi/arcmsr/arcmsr_attr.c	2012-10-12 16:41:23.007951509 +0800
@@ -95,10 +95,10 @@ arcmsr_sysfs_iop_message_read(struct fil
 		acb->acb_flags &= ~ACB_F_IOPDATA_OVERFLOW;
 		prbuffer = arcmsr_get_iop_rqbuffer(acb);
 		iop_data = prbuffer->data;
-		iop_len = readl(&prbuffer->data_len);
+		iop_len = ioread32(&prbuffer->data_len);
 		while (iop_len > 0) {
 			acb->rqbuffer[acb->rqbuf_lastindex] =
-				readb(iop_data);
+				ioread8(iop_data);
 			acb->rqbuf_lastindex++;
 			acb->rqbuf_lastindex %= ARCMSR_MAX_QBUFFER;
 			iop_data++;
diff -uprN a//drivers/scsi/arcmsr/arcmsr.h b//drivers/scsi/arcmsr/arcmsr.h
--- a//drivers/scsi/arcmsr/arcmsr.h	2012-10-12 16:41:04.619951689 +0800
+++ b//drivers/scsi/arcmsr/arcmsr.h	2012-10-12 16:41:23.007951509 +0800
@@ -62,12 +62,16 @@ struct device_attribute;
 #define ARCMSR_MAX_QBUFFER			4096
 #define ARCMSR_DEFAULT_SG_ENTRIES		38
 #define ARCMSR_MAX_HBB_POSTQUEUE		264
+#define ARCMSR_MAX_ARC1214_POSTQUEUE		256
 #define ARCMSR_MAX_XFER_LEN			0x26000
 #define ARCMSR_CDB_SG_PAGE_LENGTH		256
 #define ARCMST_NUM_MSIX_VECTORS		4
 #ifndef PCI_DEVICE_ID_ARECA_1880
 	#define PCI_DEVICE_ID_ARECA_1880	0x1880
  #endif
+ #ifndef PCI_DEVICE_ID_ARECA_1214
+	#define PCI_DEVICE_ID_ARECA_1214	0x1214
+#endif
 /*
 **********************************************************************************
 **
@@ -339,6 +343,56 @@ struct FIRMWARE_INFO
 #define ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR	0x00000008
 	/*ARCMSR_HBAMU_MESSAGE_FIRMWARE_OK*/
 #define ARCMSR_HBCMU_MESSAGE_FIRMWARE_OK			0x80000000
+/* 
+*******************************************************************************
+**                SPEC. for Areca Type D adapter
+*******************************************************************************
+*/
+#define ARCMSR_ARC1214_CHIP_ID					0x00004
+#define ARCMSR_ARC1214_CPU_MEMORY_CONFIGURATION		0x00008
+#define ARCMSR_ARC1214_I2_HOST_INTERRUPT_MASK		0x00034
+#define ARCMSR_ARC1214_SAMPLE_RESET				0x00100
+#define ARCMSR_ARC1214_RESET_REQUEST				0x00108
+#define ARCMSR_ARC1214_MAIN_INTERRUPT_STATUS			0x00200
+#define ARCMSR_ARC1214_PCIE_F0_INTERRUPT_ENABLE		0x0020C
+#define ARCMSR_ARC1214_INBOUND_MESSAGE0			0x00400
+#define ARCMSR_ARC1214_INBOUND_MESSAGE1			0x00404
+#define ARCMSR_ARC1214_OUTBOUND_MESSAGE0			0x00420
+#define ARCMSR_ARC1214_OUTBOUND_MESSAGE1			0x00424
+#define ARCMSR_ARC1214_INBOUND_DOORBELL			0x00460
+#define ARCMSR_ARC1214_OUTBOUND_DOORBELL			0x00480
+#define ARCMSR_ARC1214_OUTBOUND_DOORBELL_ENABLE		0x00484
+#define ARCMSR_ARC1214_INBOUND_LIST_BASE_LOW		0x01000
+#define ARCMSR_ARC1214_INBOUND_LIST_BASE_HIGH		0x01004
+#define ARCMSR_ARC1214_INBOUND_LIST_WRITE_POINTER		0x01018
+#define ARCMSR_ARC1214_OUTBOUND_LIST_BASE_LOW		0x01060
+#define ARCMSR_ARC1214_OUTBOUND_LIST_BASE_HIGH		0x01064
+#define ARCMSR_ARC1214_OUTBOUND_LIST_COPY_POINTER		0x0106C
+#define ARCMSR_ARC1214_OUTBOUND_LIST_READ_POINTER		0x01070
+#define ARCMSR_ARC1214_OUTBOUND_INTERRUPT_CAUSE		0x01088
+#define ARCMSR_ARC1214_OUTBOUND_INTERRUPT_ENABLE		0x0108C
+#define ARCMSR_ARC1214_MESSAGE_WBUFFER			0x02000
+#define ARCMSR_ARC1214_MESSAGE_RBUFFER			0x02100
+#define ARCMSR_ARC1214_MESSAGE_RWBUFFER			0x02200
+/* Host Interrupt Mask */
+#define ARCMSR_ARC1214_ALL_INT_ENABLE				0x00001010
+#define ARCMSR_ARC1214_ALL_INT_DISABLE			0x00000000
+/* Host Interrupt Status */
+#define ARCMSR_ARC1214_OUTBOUND_DOORBELL_ISR		0x00001000
+#define ARCMSR_ARC1214_OUTBOUND_POSTQUEUE_ISR		0x00000010
+/* DoorBell*/
+#define ARCMSR_ARC1214_DRV2IOP_DATA_IN_READY			0x00000001
+#define ARCMSR_ARC1214_DRV2IOP_DATA_OUT_READ		0x00000002
+/*inbound message 0 ready*/
+#define ARCMSR_ARC1214_IOP2DRV_DATA_WRITE_OK		0x00000001
+/*outbound DATA WRITE isr door bell clear*/
+#define ARCMSR_ARC1214_IOP2DRV_DATA_READ_OK			0x00000002
+/*outbound message 0 ready*/
+#define ARCMSR_ARC1214_IOP2DRV_MESSAGE_CMD_DONE		0x02000000
+/*outbound message cmd isr door bell clear*/
+/*ARCMSR_HBAMU_MESSAGE_FIRMWARE_OK*/
+#define ARCMSR_ARC1214_MESSAGE_FIRMWARE_OK			0x80000000
+#define ARCMSR_ARC1214_OUTBOUND_LIST_INTERRUPT_CLEAR	0x00000001
 /*
 *******************************************************************************
 **    ARECA SCSI COMMAND DESCRIPTOR BLOCK size 0x1F8 (504)
@@ -361,7 +415,7 @@ struct ARCMSR_CDB
 #define ARCMSR_CDB_FLAG_ORDEREDQ	0x10
 
 	uint8_t msgPages;
-	uint32_t Context;
+	uint32_t msgContext;
 	uint32_t DataLength;
 	uint8_t Cdb[16];
 	uint8_t DeviceStatus;
@@ -497,6 +551,50 @@ struct MessageUnit_C
 	uint32_t reserved4[32];				/*2180 21FF*/
 	uint32_t msgcode_rwbuffer[256];			/*2200 23FF*/
 };
+struct InBound_SRB {
+	uint32_t addressLow;//pointer to SRB block
+	uint32_t addressHigh;
+	uint32_t length;// in DWORDs
+	uint32_t reserved0;
+};
+
+struct OutBound_SRB {
+	uint32_t addressLow;//pointer to SRB block
+	uint32_t addressHigh;
+};
+
+struct MessageUnit_D {
+ 	struct InBound_SRB post_qbuffer[ARCMSR_MAX_ARC1214_POSTQUEUE];
+   	struct OutBound_SRB done_qbuffer[ARCMSR_MAX_ARC1214_POSTQUEUE];
+	u16 postq_index;
+	u16 doneq_index;
+	u32 __iomem *chip_id;			//0x00004
+	u32 __iomem *cpu_mem_config;		//0x00008
+	u32 __iomem *i2o_host_interrupt_mask;	//0x00034
+	u32 __iomem *sample_at_reset;		//0x00100
+	u32 __iomem *reset_request;		//0x00108
+	u32 __iomem *host_int_status;		//0x00200
+	u32 __iomem *pcief0_int_enable;		//0x0020C
+	u32 __iomem *inbound_msgaddr0;		//0x00400
+	u32 __iomem *inbound_msgaddr1;		//0x00404
+	u32 __iomem *outbound_msgaddr0;		//0x00420
+	u32 __iomem *outbound_msgaddr1;		//0x00424
+	u32 __iomem *inbound_doorbell;		//0x00460
+	u32 __iomem *outbound_doorbell;		//0x00480
+	u32 __iomem *outbound_doorbell_enable;	//0x00484
+	u32 __iomem *inboundlist_base_low;	//0x01000
+	u32 __iomem *inboundlist_base_high;	//0x01004
+	u32 __iomem *inboundlist_write_pointer;	//0x01018
+	u32 __iomem *outboundlist_base_low;	//0x01060
+	u32 __iomem *outboundlist_base_high;	//0x01064
+	u32 __iomem *outboundlist_copy_pointer;	//0x0106C
+	u32 __iomem *outboundlist_read_pointer;	//0x01070 0x01072
+	u32 __iomem *outboundlist_interrupt_cause;	//0x1088
+	u32 __iomem *outboundlist_interrupt_enable;	//0x108C
+	u32 __iomem *message_wbuffer;		//0x2000
+	u32 __iomem *message_rbuffer;		//0x2100
+	u32 __iomem *msgcode_rwbuffer;		//0x2200
+};
 /*
 *******************************************************************************
 **                 Adapter Control Block
@@ -509,6 +607,7 @@ struct AdapterControlBlock
 	#define ACB_ADAPTER_TYPE_B	0x00000002	/* hbb M IOP */
 	#define ACB_ADAPTER_TYPE_C	0x00000004	/* hbc P IOP */
 	#define ACB_ADAPTER_TYPE_D	0x00000008	/* hbd A IOP */
+	u32 roundup_ccbsize;
 	struct pci_dev *pdev;
 	struct Scsi_Host *host;
 	unsigned long vir2phy_offset;
@@ -516,13 +615,16 @@ struct AdapterControlBlock
 	/* Offset is used in making arc cdb physical to virtual calculations */
 	uint32_t outbound_int_enable;
 	uint32_t cdb_phyaddr_hi32;
-	uint32_t reg_mu_acc_handle0;
 	spinlock_t eh_lock;
 	spinlock_t ccblist_lock;
+	spinlock_t postq_lock;
+	spinlock_t rqbuffer_lock;
+	spinlock_t wqbuffer_lock;
 	union {
 		struct MessageUnit_A __iomem *pmuA;
 		struct MessageUnit_B *pmuB;
 		struct MessageUnit_C __iomem *pmuC;
+		struct MessageUnit_D __iomem *pmuD;
 	};
 	/* message unit ATU inbound base address0 */
 	void __iomem *mem_base0;
@@ -564,7 +666,8 @@ struct AdapterControlBlock
 	/* dma_coherent used for memory free */
 	dma_addr_t dma_coherent_handle;
 	/* dma_coherent_handle used for memory free */
-	dma_addr_t dma_coherent_handle_hbb_mu;
+	dma_addr_t dma_coherent_handle2;
+	void *dma_coherent2;
 	unsigned int uncache_size;
 	uint8_t rqbuffer[ARCMSR_MAX_QBUFFER];
 	/* data collection buffer for read from 80331 */
@@ -614,7 +717,7 @@ struct CommandControlBlock
 	struct list_head list;
 	struct scsi_cmnd *pcmd;
 	struct AdapterControlBlock *acb;
-	uint32_t cdb_phyaddr_pattern;
+	uint32_t cdb_phyaddr;
 	uint32_t arc_cdb_size;
 	uint16_t ccb_flags;
 	#define CCB_FLAG_READ		0x0000
diff -uprN a//drivers/scsi/arcmsr/arcmsr_hba.c b//drivers/scsi/arcmsr/arcmsr_hba.c
--- a//drivers/scsi/arcmsr/arcmsr_hba.c	2012-10-12 16:41:04.619951689 +0800
+++ b//drivers/scsi/arcmsr/arcmsr_hba.c	2012-10-12 16:41:23.011951509 +0800
@@ -89,11 +89,8 @@ static int arcmsr_bios_param(struct scsi
 static int arcmsr_queue_command(struct Scsi_Host *h, struct scsi_cmnd *cmd);
 static int arcmsr_probe(struct pci_dev *pdev,
 				const struct pci_device_id *id);
-#ifdef CONFIG_PM
-	static int arcmsr_suspend(struct pci_dev *pdev,
-	pm_message_t state);
-	static int arcmsr_resume(struct pci_dev *pdev);
-#endif
+static int arcmsr_suspend(struct pci_dev *pdev, pm_message_t state);
+static int arcmsr_resume(struct pci_dev *pdev);
 static void arcmsr_remove(struct pci_dev *pdev);
 static void arcmsr_shutdown(struct pci_dev *pdev);
 static void arcmsr_iop_init(struct AdapterControlBlock *acb);
@@ -112,6 +109,7 @@ static void arcmsr_message_isr_bh_fn(str
 static bool arcmsr_get_firmware_spec(struct AdapterControlBlock *acb);
 static void arcmsr_start_adapter_bgrb(struct AdapterControlBlock *acb);
 static void arcmsr_hbaC_message_isr(struct AdapterControlBlock *pACB);
+static void arcmsr_hbaD_message_isr(struct AdapterControlBlock *acb);
 static void arcmsr_hardware_reset(struct AdapterControlBlock *acb);
 static const char *arcmsr_info(struct Scsi_Host *);
 static irqreturn_t arcmsr_interrupt(struct AdapterControlBlock *acb);
@@ -139,8 +137,6 @@ static struct scsi_host_template arcmsr_
 	.change_queue_depth	= arcmsr_adjust_disk_queue_depth,
 	.can_queue		= ARCMSR_MAX_FREECCB_NUM,
 	.this_id			= ARCMSR_SCSI_INITIATOR_ID,
-	.sg_tablesize	        	= ARCMSR_DEFAULT_SG_ENTRIES, 
-	.max_sectors    	    	= ARCMSR_MAX_XFER_SECTORS_C, 
 	.cmd_per_lun		= ARCMSR_MAX_CMD_PERLUN,
 	.use_clustering		= ENABLE_CLUSTERING,
 	.shost_attrs		= arcmsr_host_attrs,
@@ -155,13 +151,12 @@ static struct pci_device_id arcmsr_devic
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1201)},
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1202)},
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1210)},
+	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1214)},
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1220)},
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1230)},
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1260)},
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1270)},
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1280)},
-	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1380)},
-	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1381)},
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1680)},
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1681)},
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1880)},
@@ -173,26 +168,33 @@ static struct pci_driver arcmsr_pci_driv
 	.id_table			= arcmsr_device_id_table,
 	.probe			= arcmsr_probe,
 	.remove			= arcmsr_remove,
-	#ifdef CONFIG_PM
 		.suspend		= arcmsr_suspend,
 		.resume		= arcmsr_resume,
-	#endif
 	.shutdown		= arcmsr_shutdown,
 };
 /*
 ****************************************************************************
 ****************************************************************************
 */
-static void arcmsr_free_hbb_mu(struct AdapterControlBlock *acb)
+static void arcmsr_free_mu(struct AdapterControlBlock *acb)
 {
 	switch (acb->adapter_type) {
 	case ACB_ADAPTER_TYPE_A:
 	case ACB_ADAPTER_TYPE_C:
 		break;
 	case ACB_ADAPTER_TYPE_B: {
+		struct MessageUnit_B *reg = acb->pmuB;
 		dma_free_coherent(&acb->pdev->dev,
 			sizeof(struct MessageUnit_B),
-			acb->pmuB, acb->dma_coherent_handle_hbb_mu);
+			reg, acb->dma_coherent_handle2);
+		break;
+	}
+	case ACB_ADAPTER_TYPE_D: {
+		dma_free_coherent(&acb->pdev->dev,
+			sizeof(struct MessageUnit_D),
+			acb->dma_coherent,
+			acb->dma_coherent_handle);
+		break;
 	}
 	}
 }
@@ -240,14 +242,35 @@ static bool arcmsr_remap_pciregion(struc
 				"region fail\n", acb->host->host_no);
 			return false;
 		}
-		if (readl(&acb->pmuC->outbound_doorbell) &
+		if (ioread32(&acb->pmuC->outbound_doorbell) &
 			ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {
-		writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR,
+		iowrite32(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR,
 				&acb->pmuC->outbound_doorbell_clear);
 			return true;
 		}
 		break;
 	}
+	case ACB_ADAPTER_TYPE_D: {
+		void __iomem *mem_base0;
+		unsigned long addr, range, flags;
+		
+		addr = (unsigned long)pci_resource_start(pdev, 0);
+		range = pci_resource_len(pdev, 0);
+		flags = pci_resource_flags(pdev, 0);
+		if (flags & IORESOURCE_CACHEABLE) {
+			mem_base0 = ioremap(addr, range);
+		} else {
+			mem_base0 = ioremap_nocache(addr, range);
+		}
+		if (!mem_base0) {
+			printk(KERN_NOTICE
+			"arcmsr%d: memory mapping region fail\n",
+			acb->host->host_no);
+			return false;
+		}
+		acb->mem_base0 = mem_base0;
+		break;
+	}
 	}
 	return true;
 }
@@ -257,16 +280,19 @@ static void arcmsr_unmap_pciregion(struc
 	switch (acb->adapter_type) {
 	case ACB_ADAPTER_TYPE_A: {
 		iounmap(acb->pmuA);
+		break;
 	}
-	break;
 	case ACB_ADAPTER_TYPE_B: {
 		iounmap(acb->mem_base0);
 		iounmap(acb->mem_base1);
+		break;
 	}
-
-	break;
 	case ACB_ADAPTER_TYPE_C: {
 		iounmap(acb->pmuC);
+		break;
+	}
+	case ACB_ADAPTER_TYPE_D: {
+		iounmap(acb->mem_base0);
 	}
 	}
 }
@@ -309,37 +335,61 @@ static int arcmsr_bios_param(struct scsi
 	return 0;
 }
 
-static void
+static bool
 arcmsr_define_adapter_type(struct AdapterControlBlock *acb)
 {
-	struct pci_dev *pdev = acb->pdev;
 	u16 dev_id;
+	struct pci_dev *pdev = acb->pdev;
+
 	pci_read_config_word(pdev, PCI_DEVICE_ID, &dev_id);
 	acb->dev_id = dev_id;
-	switch (dev_id) {
-	case 0x1880: {
-		acb->adapter_type = ACB_ADAPTER_TYPE_C;
+	switch(dev_id) {
+		case 0x1880: {
+			acb->adapter_type = ACB_ADAPTER_TYPE_C;
+			break;
 		}
-		break;
-	case 0x1201: {
-		acb->adapter_type = ACB_ADAPTER_TYPE_B;
+		case 0x1200:
+		case 0x1201:
+		case 0x1202: {
+			acb->adapter_type = ACB_ADAPTER_TYPE_B;
+			break;
+		}
+		case 0x1110:
+		case 0x1120:
+		case 0x1130:
+		case 0x1160:
+		case 0x1170:
+		case 0x1210:
+		case 0x1220:
+		case 0x1230:
+		case 0x1260:
+		case 0x1280:
+		case 0x1680: {
+			acb->adapter_type = ACB_ADAPTER_TYPE_A;
+			break;
+		}
+		case 0x1214: {
+			acb->adapter_type = ACB_ADAPTER_TYPE_D;
+			break;
+		}
+		default: {
+			printk("Unknown device ID = 0x%x\n", dev_id);
+			return false;
 		}
-		break;
-
-	default: acb->adapter_type = ACB_ADAPTER_TYPE_A;
 	}
+	return true;
 }
 
-static uint8_t
+static bool
 arcmsr_hbaA_wait_msgint_ready(struct AdapterControlBlock *acb)
 {
 	struct MessageUnit_A __iomem *reg = acb->pmuA;
 	int i;
 
 	for (i = 0; i < 2000; i++) {
-		if (readl(&reg->outbound_intstatus) &
+		if (ioread32(&reg->outbound_intstatus) &
 				ARCMSR_MU_OUTBOUND_MESSAGE0_INT) {
-			writel(ARCMSR_MU_OUTBOUND_MESSAGE0_INT,
+			iowrite32(ARCMSR_MU_OUTBOUND_MESSAGE0_INT,
 				&reg->outbound_intstatus);
 			return true;
 		}
@@ -349,18 +399,18 @@ arcmsr_hbaA_wait_msgint_ready(struct Ada
 	return false;
 }
 
-static uint8_t
+static bool
 arcmsr_hbaB_wait_msgint_ready(struct AdapterControlBlock *acb)
 {
 	struct MessageUnit_B *reg = acb->pmuB;
 	int i;
 
 	for (i = 0; i < 2000; i++) {
-		if (readl(reg->iop2drv_doorbell)
+		if (ioread32(reg->iop2drv_doorbell)
 			& ARCMSR_IOP2DRV_MESSAGE_CMD_DONE) {
-			writel(ARCMSR_MESSAGE_INT_CLEAR_PATTERN,
+			iowrite32(ARCMSR_MESSAGE_INT_CLEAR_PATTERN,
 					reg->iop2drv_doorbell);
-			writel(ARCMSR_DRV2IOP_END_OF_INTERRUPT,
+			iowrite32(ARCMSR_DRV2IOP_END_OF_INTERRUPT,
 					reg->drv2iop_doorbell);
 			return true;
 		}
@@ -370,16 +420,16 @@ arcmsr_hbaB_wait_msgint_ready(struct Ada
 	return false;
 }
 
-static uint8_t
+static bool
 arcmsr_hbaC_wait_msgint_ready(struct AdapterControlBlock *pACB)
 {
 	struct MessageUnit_C *phbcmu = (struct MessageUnit_C *)pACB->pmuC;
 	int i;
 
 	for (i = 0; i < 2000; i++) {
-		if (readl(&phbcmu->outbound_doorbell)
+		if (ioread32(&phbcmu->outbound_doorbell)
 			& ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {
-		writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR,
+		iowrite32(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR,
 			&phbcmu->outbound_doorbell_clear);
 			return true;
 		}
@@ -388,12 +438,29 @@ arcmsr_hbaC_wait_msgint_ready(struct Ada
 	return false;
 }
 
+static bool
+arcmsr_hbaD_wait_msgint_ready(struct AdapterControlBlock *pACB)
+{
+	int i;
+	struct MessageUnit_D __iomem *reg = (struct MessageUnit_D *)pACB->pmuD;
+	for (i = 0; i < 2000; i++) {
+		if (ioread32(reg->outbound_doorbell)
+			& ARCMSR_ARC1214_IOP2DRV_MESSAGE_CMD_DONE) {
+		iowrite32(ARCMSR_ARC1214_IOP2DRV_MESSAGE_CMD_DONE,
+				reg->outbound_doorbell);
+			return true;
+		}
+		msleep(10);
+	} /* max 20 seconds */
+	return false;
+}
+
 static void
 arcmsr_hbaA_flush_cache(struct AdapterControlBlock *acb)
 {
 	struct MessageUnit_A __iomem *reg = acb->pmuA;
 	int retry_count = 30;
-	writel(ARCMSR_INBOUND_MESG0_FLUSH_CACHE, &reg->inbound_msgaddr0);
+	iowrite32(ARCMSR_INBOUND_MESG0_FLUSH_CACHE, &reg->inbound_msgaddr0);
 	do {
 		if (arcmsr_hbaA_wait_msgint_ready(acb))
 			break;
@@ -411,7 +478,7 @@ arcmsr_hbaB_flush_cache(struct AdapterCo
 {
 	struct MessageUnit_B *reg = acb->pmuB;
 	int retry_count = 30;
-	writel(ARCMSR_MESSAGE_FLUSH_CACHE, reg->drv2iop_doorbell);
+	iowrite32(ARCMSR_MESSAGE_FLUSH_CACHE, reg->drv2iop_doorbell);
 	do {
 		if (arcmsr_hbaB_wait_msgint_ready(acb))
 			break;
@@ -428,11 +495,13 @@ static void
 arcmsr_hbaC_flush_cache(struct AdapterControlBlock *pACB)
 {
 	struct MessageUnit_C *reg = (struct MessageUnit_C *)pACB->pmuC;
-	int retry_count = 30;/* enlarge wait flush adapter cache time: 10 minute */
-	writel(ARCMSR_INBOUND_MESG0_FLUSH_CACHE,
+	int retry_count = 6;/* enlarge wait flush adapter cache time: 10 minute */
+	iowrite32(ARCMSR_INBOUND_MESG0_FLUSH_CACHE,
 		&reg->inbound_msgaddr0);
-	writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,
+	iowrite32(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,
 		&reg->inbound_doorbell);
+	ioread32(&reg->inbound_doorbell);
+	ioread32(&reg->inbound_msgaddr0);
 	do {
 		if (arcmsr_hbaC_wait_msgint_ready(pACB)) {
 			break;
@@ -445,6 +514,30 @@ arcmsr_hbaC_flush_cache(struct AdapterCo
 	} while (retry_count != 0);
 	return;
 }
+
+static void
+arcmsr_hbaD_flush_cache(struct AdapterControlBlock *pACB)
+{
+	int retry_count = 6;
+	struct MessageUnit_D __iomem *reg =
+		(struct MessageUnit_D *)pACB->pmuD;
+
+	iowrite32(ARCMSR_INBOUND_MESG0_FLUSH_CACHE,
+		reg->inbound_msgaddr0);
+	do {
+		if (arcmsr_hbaD_wait_msgint_ready(pACB)) {
+			break;
+		} else {
+			retry_count--;
+			printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter"
+			"cache' timeout, retry count down = %d \n",
+			pACB->host->host_no,
+			retry_count);
+		}
+	} while (retry_count != 0);
+	return;
+}
+
 static void
 arcmsr_flush_adapter_cache(struct AdapterControlBlock *acb)
 {
@@ -462,6 +555,10 @@ arcmsr_flush_adapter_cache(struct Adapte
 	case ACB_ADAPTER_TYPE_C: {
 		arcmsr_hbaC_flush_cache(acb);
 		}
+		break;
+	case ACB_ADAPTER_TYPE_D: {
+		arcmsr_hbaD_flush_cache(acb);
+	}
 	}
 }
 
@@ -471,59 +568,173 @@ arcmsr_alloc_ccb_pool(struct AdapterCont
 	struct pci_dev *pdev = acb->pdev;
 	void *dma_coherent;
 	dma_addr_t dma_coherent_handle;
-	struct CommandControlBlock *ccb_tmp;
+	struct CommandControlBlock *ccb_tmp = NULL;
 	int i = 0, j = 0;
 	dma_addr_t cdb_phyaddr;
-	unsigned long roundup_ccbsize;
+	unsigned long roundup_ccbsize = 0;
 	unsigned long max_xfer_len;
 	unsigned long max_sg_entrys;
 	uint32_t  firm_config_version;
-
-	for (i = 0; i < ARCMSR_MAX_TARGETID; i++)
-		for (j = 0; j < ARCMSR_MAX_TARGETLUN; j++)
-			acb->devstate[i][j] = ARECA_RAID_GONE;
-
 	max_xfer_len = ARCMSR_MAX_XFER_LEN;
 	max_sg_entrys = ARCMSR_DEFAULT_SG_ENTRIES;
 	firm_config_version = acb->firm_cfg_version;
 	if ((firm_config_version & 0xFF) >= 3) {
 		max_xfer_len = (ARCMSR_CDB_SG_PAGE_LENGTH <<
 			((firm_config_version >> 8) & 0xFF)) * 1024;
-		max_sg_entrys = (max_xfer_len/4096);
+		max_sg_entrys = (max_xfer_len / 4096);
 	}
-	acb->host->max_sectors = max_xfer_len/512;
+	acb->host->max_sectors = max_xfer_len / 512;
 	acb->host->sg_tablesize = max_sg_entrys;
-	roundup_ccbsize = roundup(sizeof(struct CommandControlBlock) +
-		(max_sg_entrys - 1) * sizeof(struct SG64ENTRY), 32);
-	acb->uncache_size = roundup_ccbsize * ARCMSR_MAX_FREECCB_NUM;
-	dma_coherent = dma_alloc_coherent(&pdev->dev, acb->uncache_size,
-		&dma_coherent_handle, GFP_KERNEL);
-	if (!dma_coherent) {
-		printk(KERN_NOTICE "arcmsr%d: dma_alloc_coherent got error\n",
-			acb->host->host_no);
-		return -ENOMEM;
+	switch (acb->adapter_type) {
+	case ACB_ADAPTER_TYPE_A: {
+		roundup_ccbsize =
+		roundup(sizeof(struct CommandControlBlock) +
+		max_sg_entrys * sizeof(struct SG64ENTRY), 32);
+		acb->uncache_size = roundup_ccbsize *
+			ARCMSR_MAX_FREECCB_NUM;
+		dma_coherent = dma_alloc_coherent(&pdev->dev,
+			acb->uncache_size, &dma_coherent_handle,
+			GFP_KERNEL);
+		if (!dma_coherent) {
+			printk("arcmsr%d: dma_alloc_coherent"
+			"got error\n", acb->host->host_no);
+			return -ENOMEM;
+		}
+		memset(dma_coherent, 0, acb->uncache_size);
+		acb->dma_coherent = dma_coherent;
+		acb->dma_coherent_handle = dma_coherent_handle;
+		ccb_tmp = (struct CommandControlBlock *)dma_coherent;
+		acb->vir2phy_offset = (unsigned long)dma_coherent -
+			(unsigned long)dma_coherent_handle;
+		for (i = 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {
+			cdb_phyaddr = dma_coherent_handle +
+				offsetof(struct CommandControlBlock,
+				arcmsr_cdb);
+			ccb_tmp->cdb_phyaddr = cdb_phyaddr >> 5;
+			acb->pccb_pool[i] = ccb_tmp;
+			ccb_tmp->acb = acb;
+			INIT_LIST_HEAD(&ccb_tmp->list);
+			list_add_tail(&ccb_tmp->list,
+			&acb->ccb_free_list);
+			ccb_tmp = (struct CommandControlBlock *)
+			((unsigned long)ccb_tmp + roundup_ccbsize);
+			dma_coherent_handle = dma_coherent_handle +
+				roundup_ccbsize;
+		}
+		break;
 	}
-	acb->dma_coherent = dma_coherent;
-	acb->dma_coherent_handle = dma_coherent_handle;
-	memset(dma_coherent, 0, acb->uncache_size);
-	ccb_tmp = dma_coherent;
-	acb->vir2phy_offset = (unsigned long)dma_coherent -
-		(unsigned long)dma_coherent_handle;
-	for (i = 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {
-		cdb_phyaddr = dma_coherent_handle +
+	case ACB_ADAPTER_TYPE_B: {
+		roundup_ccbsize = roundup(sizeof(struct CommandControlBlock) +
+			(max_sg_entrys - 1) * sizeof(struct SG64ENTRY), 32);
+		acb->uncache_size = roundup_ccbsize *
+			ARCMSR_MAX_FREECCB_NUM;
+		dma_coherent = dma_alloc_coherent(&pdev->dev,
+			acb->uncache_size, &dma_coherent_handle,
+			GFP_KERNEL);
+		if (!dma_coherent) {
+			printk(KERN_NOTICE "DMA allocation failed....\n");
+			return -ENOMEM;
+		}
+		memset(dma_coherent, 0, acb->uncache_size);
+		acb->dma_coherent = dma_coherent;
+		acb->dma_coherent_handle = dma_coherent_handle;
+		ccb_tmp = (struct CommandControlBlock *)dma_coherent;
+		acb->vir2phy_offset = (unsigned long)dma_coherent -
+			(unsigned long)dma_coherent_handle;
+		for (i = 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {
+			cdb_phyaddr = dma_coherent_handle +
 			offsetof(struct CommandControlBlock,
 			arcmsr_cdb);
-		ccb_tmp->cdb_phyaddr_pattern =
-			((acb->adapter_type == ACB_ADAPTER_TYPE_C)
-			? cdb_phyaddr : (cdb_phyaddr >> 5));
-		acb->pccb_pool[i] = ccb_tmp;
-		ccb_tmp->acb = acb;
-		INIT_LIST_HEAD(&ccb_tmp->list);
-		list_add_tail(&ccb_tmp->list, &acb->ccb_free_list);
-		ccb_tmp = (struct CommandControlBlock *)
+			ccb_tmp->cdb_phyaddr = cdb_phyaddr >> 5;
+			acb->pccb_pool[i] = ccb_tmp;
+			ccb_tmp->acb = acb;
+			INIT_LIST_HEAD(&ccb_tmp->list);
+			list_add_tail(&ccb_tmp->list,
+			&acb->ccb_free_list);
+			ccb_tmp = (struct CommandControlBlock *)
 			((unsigned long)ccb_tmp + roundup_ccbsize);
-		dma_coherent_handle = dma_coherent_handle + roundup_ccbsize;
+			dma_coherent_handle = dma_coherent_handle +
+			roundup_ccbsize;
+		}
+		break;
+	}
+	case ACB_ADAPTER_TYPE_C: {
+		roundup_ccbsize =
+		roundup(sizeof(struct CommandControlBlock) +
+		(max_sg_entrys - 1) * sizeof(struct SG64ENTRY), 32);
+		acb->uncache_size = roundup_ccbsize *
+		ARCMSR_MAX_FREECCB_NUM;
+		dma_coherent = dma_alloc_coherent(&pdev->dev,
+			acb->uncache_size,
+			&dma_coherent_handle,
+			GFP_KERNEL);
+		if (!dma_coherent) {
+			printk("arcmsr%d: dma_alloc_coherent"
+			"got error \n", acb->host->host_no);
+			return -ENOMEM;
+		}
+		memset(dma_coherent, 0, acb->uncache_size);
+		acb->dma_coherent = dma_coherent;
+		acb->dma_coherent_handle = dma_coherent_handle;
+		acb->vir2phy_offset = (unsigned long)dma_coherent -
+		(unsigned long)dma_coherent_handle;
+		ccb_tmp = dma_coherent;
+		for (i = 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {
+			cdb_phyaddr = dma_coherent_handle +
+			offsetof(struct CommandControlBlock,
+			arcmsr_cdb);
+			ccb_tmp->cdb_phyaddr = cdb_phyaddr;
+			acb->pccb_pool[i] = ccb_tmp;
+			ccb_tmp->acb = acb;
+			INIT_LIST_HEAD(&ccb_tmp->list);
+			list_add_tail(&ccb_tmp->list,
+				&acb->ccb_free_list);
+			ccb_tmp = (struct CommandControlBlock *)
+				((unsigned long)ccb_tmp +
+				roundup_ccbsize);
+			dma_coherent_handle = dma_coherent_handle +
+				roundup_ccbsize;
+		}
+		break;
+	}
+	case ACB_ADAPTER_TYPE_D: {
+		void *dma_coherent;
+		dma_addr_t dma_coherent_handle;
+
+		roundup_ccbsize = roundup(sizeof(struct CommandControlBlock)
+		+ (max_sg_entrys - 1) * sizeof(struct SG64ENTRY), 32);
+		dma_coherent = dma_alloc_coherent(&pdev->dev,
+			roundup_ccbsize * ARCMSR_MAX_FREECCB_NUM,
+			&dma_coherent_handle, GFP_KERNEL);
+		if (!dma_coherent) {
+			printk(KERN_NOTICE "DMA allocation failed...\n");
+			return -ENOMEM;
+		}
+		acb->roundup_ccbsize = roundup_ccbsize;
+		acb->dma_coherent2 = dma_coherent;
+		acb->dma_coherent_handle2 = dma_coherent_handle;
+		ccb_tmp = dma_coherent;
+		acb->vir2phy_offset = (unsigned long)dma_coherent -
+			(unsigned long)dma_coherent_handle;
+		for (i = 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {
+			cdb_phyaddr = dma_coherent_handle +
+			offsetof(struct CommandControlBlock, arcmsr_cdb);
+			ccb_tmp->cdb_phyaddr =
+			cdb_phyaddr;
+			acb->pccb_pool[i] = ccb_tmp;
+			ccb_tmp->acb = acb;
+			INIT_LIST_HEAD(&ccb_tmp->list);
+			list_add_tail(&ccb_tmp->list, &acb->ccb_free_list);
+			ccb_tmp = (struct CommandControlBlock *)
+				((unsigned long)ccb_tmp + roundup_ccbsize);
+			dma_coherent_handle = dma_coherent_handle
+				+ roundup_ccbsize;
+		}
+	}
 	}
+	for (i = 0; i < ARCMSR_MAX_TARGETID; i++)
+		for (j = 0; j < ARCMSR_MAX_TARGETLUN; j++)
+			acb->devstate[i][j] = ARECA_RAID_GONE;
 	return 0;
 }
 
@@ -545,32 +756,32 @@ arcmsr_message_isr_bh_fn(struct work_str
 		char diff;
 
 		atomic_inc(&acb->rq_map_token);
-		if (readl(signature) == ARCMSR_SIGNATURE_GET_CONFIG) {
+		if (ioread32(signature) == ARCMSR_SIGNATURE_GET_CONFIG) {
 			for (target = 0; target < ARCMSR_MAX_TARGETID -1;
 			target++) {
-				diff = (*acb_dev_map) ^ readb(devicemap);
+				diff = (*acb_dev_map) ^ ioread8(devicemap);
 				if (diff != 0) {
 					char temp;
-					*acb_dev_map = readb(devicemap);
+					*acb_dev_map = ioread8(devicemap);
 					temp =*acb_dev_map;
 					for (lun = 0; lun <
 					ARCMSR_MAX_TARGETLUN; lun++) {
-						if ((temp & 0x01) == 1 &&
-						(diff & 0x01) == 1) {
-						scsi_add_device(acb->host,
-							0, target, lun);
-						} else if ((temp & 0x01) == 0
-						&& (diff & 0x01) == 1) {
-							psdev =
-						scsi_device_lookup(acb->host,
-							0, target, lun);
-							if (psdev != NULL ) {
-							scsi_remove_device(psdev);
-							scsi_device_put(psdev);
-							}
+					if ((temp & 0x01) == 1 &&
+					(diff & 0x01) == 1) {
+					scsi_add_device(acb->host,
+						0, target, lun);
+					} else if ((temp & 0x01) == 0
+					&& (diff & 0x01) == 1) {
+						psdev =
+					scsi_device_lookup(acb->host,
+						0, target, lun);
+						if (psdev != NULL ) {
+						scsi_remove_device(psdev);
+						scsi_device_put(psdev);
 						}
-						temp >>= 1;
-						diff >>= 1;
+					}
+					temp >>= 1;
+					diff >>= 1;
 					}
 				}
 				devicemap++;
@@ -592,31 +803,31 @@ arcmsr_message_isr_bh_fn(struct work_str
 		char diff;
 
 		atomic_inc(&acb->rq_map_token);
-		if (readl(signature) == ARCMSR_SIGNATURE_GET_CONFIG) {
+		if (ioread32(signature) == ARCMSR_SIGNATURE_GET_CONFIG) {
 			for(target = 0; target <
 			ARCMSR_MAX_TARGETID -1; target++) {
-				diff = (*acb_dev_map) ^ readb(devicemap);
+				diff = (*acb_dev_map) ^ ioread8(devicemap);
 				if (diff != 0) {
 					char temp;
-					*acb_dev_map = readb(devicemap);
+					*acb_dev_map = ioread8(devicemap);
 					temp = *acb_dev_map;
 					for (lun = 0; lun < ARCMSR_MAX_TARGETLUN;
 					lun++) {
-						if ((temp & 0x01)==1 &&
-							(diff & 0x01) == 1) {
-						scsi_add_device(acb->host,
-							0, target, lun);
-						} else if ((temp & 0x01) == 0
-						&& (diff & 0x01) == 1) {
-						psdev = scsi_device_lookup(acb->host,
-							0, target, lun);
-							if (psdev != NULL) {
-							scsi_remove_device(psdev);
-							scsi_device_put(psdev);
-							}
+					if ((temp & 0x01)==1 &&
+						(diff & 0x01) == 1) {
+					scsi_add_device(acb->host,
+						0, target, lun);
+					} else if ((temp & 0x01) == 0
+					&& (diff & 0x01) == 1) {
+					psdev = scsi_device_lookup(acb->host,
+						0, target, lun);
+						if (psdev != NULL) {
+						scsi_remove_device(psdev);
+						scsi_device_put(psdev);
 						}
-						temp >>= 1;
-						diff >>= 1;
+					}
+					temp >>= 1;
+					diff >>= 1;
 					}
 				}
 				devicemap++;
@@ -637,32 +848,32 @@ arcmsr_message_isr_bh_fn(struct work_str
 		char diff;
 
 		atomic_inc(&acb->rq_map_token);
-		if (readl(signature) == ARCMSR_SIGNATURE_GET_CONFIG) {
+		if (ioread32(signature) == ARCMSR_SIGNATURE_GET_CONFIG) {
 			for (target = 0; target <
 				ARCMSR_MAX_TARGETID - 1; target++) {
-				diff = (*acb_dev_map) ^ readb(devicemap);
+				diff = (*acb_dev_map) ^ ioread8(devicemap);
 				if (diff != 0) {
 					char temp;
 					*acb_dev_map =
-						readb(devicemap);
+						ioread8(devicemap);
 					temp = *acb_dev_map;
 					for (lun = 0; lun <
 					ARCMSR_MAX_TARGETLUN; lun++) {
-						if ((temp & 0x01) == 1 &&
-							(diff & 0x01) == 1) {
-						scsi_add_device(acb->host,
-							0, target, lun);
-						} else if ((temp & 0x01) == 0
-						&& (diff & 0x01) == 1) {
-						psdev = scsi_device_lookup(acb->host,
-							0, target, lun);
-							if (psdev != NULL) {
-							scsi_remove_device(psdev);
-							scsi_device_put(psdev);
-							}
+					if ((temp & 0x01) == 1 &&
+						(diff & 0x01) == 1) {
+					scsi_add_device(acb->host,
+						0, target, lun);
+					} else if ((temp & 0x01) == 0
+					&& (diff & 0x01) == 1) {
+					psdev = scsi_device_lookup(acb->host,
+						0, target, lun);
+						if (psdev != NULL) {
+						scsi_remove_device(psdev);
+						scsi_device_put(psdev);
 						}
-						temp >>= 1;
-						diff >>= 1;
+					}
+					temp >>= 1;
+					diff >>= 1;
 					}
 				}
 				devicemap++;
@@ -670,136 +881,181 @@ arcmsr_message_isr_bh_fn(struct work_str
 			}
 		}
 	}
+	break;
+	case ACB_ADAPTER_TYPE_D: {
+		struct MessageUnit_D __iomem *reg  = acb->pmuD;
+		char *acb_dev_map = (char *)acb->device_map;
+		uint32_t __iomem *signature =
+			(uint32_t __iomem *)(&reg->msgcode_rwbuffer[0]);
+		char __iomem *devicemap =
+			(char __iomem *)(&reg->msgcode_rwbuffer[21]);
+		int target, lun;
+		struct scsi_device *psdev;
+		char diff;
+
+		atomic_inc(&acb->rq_map_token);
+		if (ioread32(signature) == ARCMSR_SIGNATURE_GET_CONFIG) {
+			for (target = 0; target <
+				ARCMSR_MAX_TARGETID - 1; target++) {
+				diff = (*acb_dev_map) ^ ioread8(devicemap);
+				if (diff != 0) {
+					char temp;
+					*acb_dev_map =
+						ioread8(devicemap);
+					temp = *acb_dev_map;
+					for (lun = 0; lun <
+					ARCMSR_MAX_TARGETLUN; lun++) {
+					if ((temp & 0x01) == 1 &&
+						(diff & 0x01) == 1) {
+					scsi_add_device(acb->host,
+						0, target, lun);
+					} else if ((temp & 0x01) == 0
+					&& (diff & 0x01) == 1) {
+					psdev = scsi_device_lookup(acb->host,
+						0, target, lun);
+						if (psdev != NULL) {
+						scsi_remove_device(psdev);
+						scsi_device_put(psdev);
+						}
+					}
+					temp >>= 1;
+					diff >>= 1;
+					}
+				}
+				devicemap++;
+				acb_dev_map++;
+			}
+		}
+		break;
+	}
 	}
 }
 
-#ifdef CONFIG_PM
-	static int
-	arcmsr_suspend(struct pci_dev *pdev, pm_message_t state)
-	{
-		int i;
-		uint32_t intmask_org;
-		struct Scsi_Host *host = pci_get_drvdata(pdev);
-		struct AdapterControlBlock *acb =
-			(struct AdapterControlBlock *)host->hostdata;
+static int
+arcmsr_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	int i;
+	uint32_t intmask_org;
+	struct Scsi_Host *host = pci_get_drvdata(pdev);
+	struct AdapterControlBlock *acb =
+		(struct AdapterControlBlock *)host->hostdata;
 
-		intmask_org = arcmsr_disable_outbound_ints(acb);
-		if (acb->acb_flags & ACB_F_MSI_ENABLED) {
-			free_irq(pdev->irq, acb);
-			pci_disable_msi(pdev);
-		} else if (acb->acb_flags & ACB_F_MSIX_ENABLED) {
-			for (i = 0; i < ARCMST_NUM_MSIX_VECTORS; i++) {
-				free_irq(acb->entries[i].vector, acb);
-			}
-			pci_disable_msix(pdev);
-		} else {
-			free_irq(pdev->irq, acb);
+	intmask_org = arcmsr_disable_outbound_ints(acb);
+	if (acb->acb_flags & ACB_F_MSI_ENABLED) {
+		free_irq(pdev->irq, acb);
+		pci_disable_msi(pdev);
+	} else if (acb->acb_flags & ACB_F_MSIX_ENABLED) {
+		for (i = 0; i < ARCMST_NUM_MSIX_VECTORS; i++) {
+			free_irq(acb->entries[i].vector, acb);
 		}
-		del_timer_sync(&acb->eternal_timer);
-		flush_scheduled_work();
-		arcmsr_stop_adapter_bgrb(acb);
-		arcmsr_flush_adapter_cache(acb);
-		arcmsr_enable_outbound_ints(acb, intmask_org);
-		pci_set_drvdata(pdev, host);
-		pci_save_state(pdev);
-		pci_disable_device(pdev);
-		pci_set_power_state(pdev, pci_choose_state(pdev, state));
-		return 0;
+		pci_disable_msix(pdev);
+	} else {
+		free_irq(pdev->irq, acb);
 	}
-	
-	static int
-	arcmsr_resume(struct pci_dev *pdev)
-	{
-		int error, i, j;
-		struct Scsi_Host *host = pci_get_drvdata(pdev);
-		struct AdapterControlBlock *acb =
-			(struct AdapterControlBlock *)host->hostdata;
-		struct msix_entry entries[ARCMST_NUM_MSIX_VECTORS];
-		pci_set_power_state(pdev, PCI_D0);
-		pci_enable_wake(pdev, PCI_D0, 0);
-		pci_restore_state(pdev);
-		if (pci_enable_device(pdev)) {
-			printk("%s: pci_enable_device error \n", __func__);
-			return -ENODEV;
-		}
-		error = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
+	del_timer_sync(&acb->eternal_timer);
+	flush_scheduled_work();
+	arcmsr_stop_adapter_bgrb(acb);
+	arcmsr_flush_adapter_cache(acb);
+	arcmsr_enable_outbound_ints(acb, intmask_org);
+	pci_set_drvdata(pdev, host);
+	pci_save_state(pdev);
+	pci_disable_device(pdev);
+	pci_set_power_state(pdev, pci_choose_state(pdev, state));
+	return 0;
+}
+
+static int
+arcmsr_resume(struct pci_dev *pdev)
+{
+	int error, i, j;
+	struct Scsi_Host *host = pci_get_drvdata(pdev);
+	struct AdapterControlBlock *acb =
+		(struct AdapterControlBlock *)host->hostdata;
+	struct msix_entry entries[ARCMST_NUM_MSIX_VECTORS];
+	pci_set_power_state(pdev, PCI_D0);
+	pci_enable_wake(pdev, PCI_D0, 0);
+	pci_restore_state(pdev);
+	if (pci_enable_device(pdev)) {
+		printk("%s: pci_enable_device error \n", __func__);
+		return -ENODEV;
+	}
+	error = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
+	if (error) {
+		error = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (error) {
-			error = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
-			if (error) {
-				printk(KERN_WARNING
-				       "scsi%d: No suitable DMA mask available\n",
-				       host->host_no);
-				goto controller_unregister;
-			}
-		}
-		pci_set_master(pdev);
-		arcmsr_iop_init(acb);
-		if (pci_find_capability(pdev, PCI_CAP_ID_MSIX)) {
-			if (!pci_enable_msix(pdev, entries,
-				ARCMST_NUM_MSIX_VECTORS)) {
-				for (i = 0; i < ARCMST_NUM_MSIX_VECTORS;
-				i++) {
-					entries[i].entry = i;
-					if (request_irq(entries[i].vector,
-					arcmsr_do_interrupt, 0,
-					"arcmsr", acb)) {
-					for (j = 0 ; j < i ; j++)
-						free_irq(entries[i].vector,
-						acb);
-					goto controller_stop;
-					}
-					acb->entries[i] = entries[i];
-				}
-				acb->acb_flags |= ACB_F_MSIX_ENABLED;
-			} else {
-				printk("arcmsr%d: MSI-X"
-				"failed to enable\n", acb->host->host_no);
-				if (request_irq(pdev->irq,
-				arcmsr_do_interrupt, IRQF_SHARED,
+			printk(KERN_WARNING
+			       "scsi%d: No suitable DMA mask available\n",
+			       host->host_no);
+			goto controller_unregister;
+		}
+	}
+	pci_set_master(pdev);
+	if (pci_find_capability(pdev, PCI_CAP_ID_MSIX)) {
+		if (!pci_enable_msix(pdev, entries,
+			ARCMST_NUM_MSIX_VECTORS)) {
+			for (i = 0; i < ARCMST_NUM_MSIX_VECTORS;
+			i++) {
+				entries[i].entry = i;
+				if (request_irq(entries[i].vector,
+				arcmsr_do_interrupt, 0,
 				"arcmsr", acb)) {
-					goto controller_stop;
-				}
-			}
-		} else if (pci_find_capability(pdev, PCI_CAP_ID_MSI)) {
-			if (!pci_enable_msi(pdev)) {
-				acb->acb_flags |= ACB_F_MSI_ENABLED;
-			}
-			if (request_irq(pdev->irq, arcmsr_do_interrupt,
-				IRQF_SHARED, "arcmsr", acb)) {
+				for (j = 0 ; j < i ; j++)
+					free_irq(entries[i].vector,
+					acb);
 				goto controller_stop;
+				}
+				acb->entries[i] = entries[i];
 			}
+			acb->acb_flags |= ACB_F_MSIX_ENABLED;
 		} else {
-			if (request_irq(pdev->irq, arcmsr_do_interrupt,
-				IRQF_SHARED, "arcmsr", acb)) {
+			printk("arcmsr%d: MSI-X"
+			"failed to enable\n", acb->host->host_no);
+			if (request_irq(pdev->irq,
+			arcmsr_do_interrupt, IRQF_SHARED,
+			"arcmsr", acb)) {
 				goto controller_stop;
 			}
 		}
-		INIT_WORK(&acb->arcmsr_do_message_isr_bh,
-		arcmsr_message_isr_bh_fn);
-		atomic_set(&acb->rq_map_token, 16);
-		atomic_set(&acb->ante_token_value, 16);
-		acb->fw_flag = FW_NORMAL;
-		init_timer(&acb->eternal_timer);
-		acb->eternal_timer.expires = jiffies +
-			msecs_to_jiffies(6 * HZ);
-		acb->eternal_timer.data = (unsigned long) acb;
-		acb->eternal_timer.function =
-			&arcmsr_request_device_map;
-		add_timer(&acb->eternal_timer);
-		return 0;
-		controller_stop:
-			arcmsr_stop_adapter_bgrb(acb);
-			arcmsr_flush_adapter_cache(acb);
-		controller_unregister:
-			scsi_remove_host(host);
-			arcmsr_free_ccb_pool(acb);
-			arcmsr_unmap_pciregion(acb);
-			pci_release_regions(pdev);
-			scsi_host_put(host);	
-			pci_disable_device(pdev);
-		return -ENODEV;
+	} else if (pci_find_capability(pdev, PCI_CAP_ID_MSI)) {
+		if (!pci_enable_msi(pdev)) {
+			acb->acb_flags |= ACB_F_MSI_ENABLED;
+		}
+		if (request_irq(pdev->irq, arcmsr_do_interrupt,
+			IRQF_SHARED, "arcmsr", acb)) {
+			goto controller_stop;
+		}
+	} else {
+		if (request_irq(pdev->irq, arcmsr_do_interrupt,
+			IRQF_SHARED, "arcmsr", acb)) {
+			goto controller_stop;
+		}
 	}
-#endif
+	arcmsr_iop_init(acb);
+	INIT_WORK(&acb->arcmsr_do_message_isr_bh,
+	arcmsr_message_isr_bh_fn);
+	atomic_set(&acb->rq_map_token, 16);
+	atomic_set(&acb->ante_token_value, 16);
+	acb->fw_flag = FW_NORMAL;
+	init_timer(&acb->eternal_timer);
+	acb->eternal_timer.expires = jiffies +
+		msecs_to_jiffies(6 * HZ);
+	acb->eternal_timer.data = (unsigned long) acb;
+	acb->eternal_timer.function =
+		&arcmsr_request_device_map;
+	add_timer(&acb->eternal_timer);
+	return 0;
+	controller_stop:
+		arcmsr_stop_adapter_bgrb(acb);
+		arcmsr_flush_adapter_cache(acb);
+	controller_unregister:
+		scsi_remove_host(host);
+		arcmsr_free_ccb_pool(acb);
+		arcmsr_unmap_pciregion(acb);
+		pci_release_regions(pdev);
+		scsi_host_put(host);	
+		pci_disable_device(pdev);
+	return -ENODEV;
+}
 
 static int arcmsr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
@@ -849,12 +1105,18 @@ static int arcmsr_probe(struct pci_dev *
 	}
 	spin_lock_init(&acb->eh_lock);
 	spin_lock_init(&acb->ccblist_lock);
+	spin_lock_init(&acb->postq_lock);
+	spin_lock_init(&acb->rqbuffer_lock);
+	spin_lock_init(&acb->wqbuffer_lock);
 	acb->acb_flags |= (ACB_F_MESSAGE_WQBUFFER_CLEARED |
 			ACB_F_MESSAGE_RQBUFFER_CLEARED |
 			ACB_F_MESSAGE_WQBUFFER_READED);
 	acb->acb_flags &= ~ACB_F_SCSISTOPADAPTER;
 	INIT_LIST_HEAD(&acb->ccb_free_list);
-	arcmsr_define_adapter_type(acb);
+	error = arcmsr_define_adapter_type(acb);
+	if (!error) {
+		goto pci_release_regs;
+	}
 	error = arcmsr_remap_pciregion(acb);
 	if (!error) {
 		goto pci_release_regs;
@@ -867,7 +1129,6 @@ static int arcmsr_probe(struct pci_dev *
 	if (error) {
 		goto free_hbb_mu;
 	}
-	arcmsr_iop_init(acb);
 	error = scsi_add_host(host, &pdev->dev);
 	if (error) {
 		goto RAID_controller_stop;
@@ -914,7 +1175,8 @@ static int arcmsr_probe(struct pci_dev *
 		}
 	}
 	host->irq = pdev->irq;
-    	scsi_scan_host(host);
+	arcmsr_iop_init(acb);
+	scsi_scan_host(host);
 	INIT_WORK(&acb->arcmsr_do_message_isr_bh,
 		arcmsr_message_isr_bh_fn);
 	atomic_set(&acb->rq_map_token, 16);
@@ -943,7 +1205,7 @@ RAID_controller_stop:
 	arcmsr_flush_adapter_cache(acb);
 	arcmsr_free_ccb_pool(acb);
 free_hbb_mu:
-	arcmsr_free_hbb_mu(acb);
+	arcmsr_free_mu(acb);
 unmap_pci_region:
 	arcmsr_unmap_pciregion(acb);
 pci_release_regs:
@@ -959,7 +1221,7 @@ static uint8_t
 arcmsr_hbaA_abort_allcmd(struct AdapterControlBlock *acb)
 {
 	struct MessageUnit_A __iomem *reg = acb->pmuA;
-	writel(ARCMSR_INBOUND_MESG0_ABORT_CMD,
+	iowrite32(ARCMSR_INBOUND_MESG0_ABORT_CMD,
 		&reg->inbound_msgaddr0);
 	if (!arcmsr_hbaA_wait_msgint_ready(acb)) {
 		printk(KERN_NOTICE
@@ -975,7 +1237,7 @@ arcmsr_hbaB_abort_allcmd(struct AdapterC
 {
 	struct MessageUnit_B *reg = acb->pmuB;
 
-	writel(ARCMSR_MESSAGE_ABORT_CMD,
+	iowrite32(ARCMSR_MESSAGE_ABORT_CMD,
 		reg->drv2iop_doorbell);
 	if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
 		printk(KERN_NOTICE
@@ -989,8 +1251,8 @@ static uint8_t
 arcmsr_hbaC_abort_allcmd(struct AdapterControlBlock *pACB)
 {
 	struct MessageUnit_C *reg = (struct MessageUnit_C *)pACB->pmuC;
-	writel(ARCMSR_INBOUND_MESG0_ABORT_CMD, &reg->inbound_msgaddr0);
-	writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);
+	iowrite32(ARCMSR_INBOUND_MESG0_ABORT_CMD, &reg->inbound_msgaddr0);
+	iowrite32(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);
 	if (!arcmsr_hbaC_wait_msgint_ready(pACB)) {
 		printk(KERN_NOTICE
 		"arcmsr%d: wait 'abort all outstanding command' timeout \n"
@@ -1000,6 +1262,19 @@ arcmsr_hbaC_abort_allcmd(struct AdapterC
 	return true;
 }
 static uint8_t
+arcmsr_hbaD_abort_allcmd(struct AdapterControlBlock *pACB)
+{
+	struct MessageUnit_D __iomem *reg = (struct MessageUnit_D *)pACB->pmuD;
+	iowrite32(ARCMSR_INBOUND_MESG0_ABORT_CMD, reg->inbound_msgaddr0);
+	if (!arcmsr_hbaD_wait_msgint_ready(pACB)) {
+		printk(KERN_NOTICE
+		"arcmsr%d: wait 'abort all outstanding command' timeout \n"
+		, pACB->host->host_no);
+		return false;
+	}
+	return true;
+}
+static uint8_t
 arcmsr_abort_allcmd(struct AdapterControlBlock *acb)
 {
 	uint8_t rtnval = 0;
@@ -1017,6 +1292,10 @@ arcmsr_abort_allcmd(struct AdapterContro
 	case ACB_ADAPTER_TYPE_C: {
 		rtnval = arcmsr_hbaC_abort_allcmd(acb);
 		}
+		break;
+	case ACB_ADAPTER_TYPE_D: {
+		rtnval = arcmsr_hbaD_abort_allcmd(acb);
+	}
 	}
 	return rtnval;
 }
@@ -1025,7 +1304,7 @@ static bool
 arcmsr_hbb_enable_driver_mode(struct AdapterControlBlock *pacb)
 {
 	struct MessageUnit_B *reg = pacb->pmuB;
-	writel(ARCMSR_MESSAGE_START_DRIVER_MODE,
+	iowrite32(ARCMSR_MESSAGE_START_DRIVER_MODE,
 		reg->drv2iop_doorbell);
 	if (!arcmsr_hbaB_wait_msgint_ready(pacb)) {
 		printk(KERN_ERR "arcmsr%d: can't set driver mode.\n",
@@ -1084,27 +1363,36 @@ arcmsr_disable_outbound_ints(struct Adap
 	switch (acb->adapter_type) {	
 	case ACB_ADAPTER_TYPE_A : {
 		struct MessageUnit_A __iomem *reg = acb->pmuA;
-		orig_mask = readl(&reg->outbound_intmask);
-		writel(orig_mask |
+		orig_mask = ioread32(&reg->outbound_intmask);
+		iowrite32(orig_mask |
 			ARCMSR_MU_OUTBOUND_ALL_INTMASKENABLE,
 			&reg->outbound_intmask);
 		}
 		break;
 	case ACB_ADAPTER_TYPE_B : {
 		struct MessageUnit_B *reg = acb->pmuB;
-		orig_mask = readl(reg->iop2drv_doorbell_mask);
-		writel(0, reg->iop2drv_doorbell_mask);
+		orig_mask = ioread32(reg->iop2drv_doorbell_mask);
+		iowrite32(0, reg->iop2drv_doorbell_mask);
 		}
 		break;
 	case ACB_ADAPTER_TYPE_C: {
-		struct MessageUnit_C *reg =
+		struct MessageUnit_C __iomem *reg =
 			(struct MessageUnit_C *)acb->pmuC;
 		/* disable all outbound interrupt */
-		orig_mask = readl(&reg->host_int_mask);
-		writel(orig_mask | ARCMSR_HBCMU_ALL_INTMASKENABLE,
+		orig_mask = ioread32(&reg->host_int_mask);
+		iowrite32(orig_mask | ARCMSR_HBCMU_ALL_INTMASKENABLE,
 			&reg->host_int_mask);
+		ioread32(&reg->host_int_mask);
 		}
 		break;
+	case ACB_ADAPTER_TYPE_D: {
+		struct MessageUnit_D __iomem *reg =
+			(struct MessageUnit_D *)acb->pmuD;
+		/* disable all outbound interrupt */
+		iowrite32(ARCMSR_ARC1214_ALL_INT_DISABLE,
+		reg->pcief0_int_enable);
+		break;
+	}
 	}
 	return orig_mask;
 }
@@ -1165,32 +1453,22 @@ arcmsr_report_ccb_state(struct AdapterCo
 static void
 arcmsr_drain_donequeue(struct AdapterControlBlock *acb, struct CommandControlBlock *pCCB, bool error)
 {
-	int id, lun;
 	if ((pCCB->acb != acb) || (pCCB->startdone != ARCMSR_CCB_START)) {
-		if (pCCB->startdone == ARCMSR_CCB_ABORTED) {
-			struct scsi_cmnd *abortcmd = pCCB->pcmd;
-			if (abortcmd) {
-				id = abortcmd->device->id;
-				lun = abortcmd->device->lun;
-				abortcmd->result |= DID_ABORT << 16;
-				arcmsr_ccb_complete(pCCB);
-				printk(KERN_NOTICE "arcmsr%d: pCCB ='0x%p' isr"
-				"got aborted command \n",
-				acb->host->host_no, pCCB);
-			}
-			return;
-		}
-		printk(KERN_NOTICE "arcmsr%d: isr get an illegal ccb command"
-				"done acb = '0x%p'"
-				"ccb = '0x%p' ccbacb = '0x%p' startdone = 0x%x"
-				" ccboutstandingcount = %d \n"
-				, acb->host->host_no
-				, acb
-				, pCCB
-				, pCCB->acb
-				, pCCB->startdone
-				, atomic_read(&acb->ccboutstandingcount));
-		  return;
+		printk(KERN_NOTICE "arcmsr%d: isr get an illegal ccb"
+		"command done acb = 0x%p, "
+		"ccb = 0x%p, "
+		"ccbacb = 0x%p, "
+		"startdone = 0x%x, "
+		"pscsi_cmd = 0x%p, "
+		"ccboutstandingcount = %d\n"
+		, acb->host->host_no
+		, acb
+		, pCCB
+		, pCCB->acb
+		, pCCB->startdone
+		, pCCB->pcmd
+		, atomic_read(&acb->ccboutstandingcount));
+		return;
 	}
 	arcmsr_report_ccb_state(acb, pCCB, error);
 }
@@ -1208,11 +1486,11 @@ arcmsr_done4abort_postqueue(struct Adapt
 	case ACB_ADAPTER_TYPE_A: {
 		struct MessageUnit_A __iomem *reg = acb->pmuA;
 		uint32_t outbound_intstatus;
-		outbound_intstatus = readl(&reg->outbound_intstatus) &
+		outbound_intstatus = ioread32(&reg->outbound_intstatus) &
 					acb->outbound_int_enable;
 		/*clear and abort all outbound posted Q*/
-		writel(outbound_intstatus, &reg->outbound_intstatus);
-		while(((flag_ccb = readl(&reg->outbound_queueport))
+		iowrite32(outbound_intstatus, &reg->outbound_intstatus);
+		while(((flag_ccb = ioread32(&reg->outbound_queueport))
 			!= 0xFFFFFFFF)
 			&& (i++ < ARCMSR_MAX_OUTSTANDING_CMD)) {
 			pARCMSR_CDB = (struct ARCMSR_CDB *)
@@ -1228,11 +1506,11 @@ arcmsr_done4abort_postqueue(struct Adapt
 
 	case ACB_ADAPTER_TYPE_B: {
 		struct MessageUnit_B *reg = acb->pmuB;
-		writel(ARCMSR_DOORBELL_INT_CLEAR_PATTERN,
+		iowrite32(ARCMSR_DOORBELL_INT_CLEAR_PATTERN,
 			reg->iop2drv_doorbell);
 		for (i = 0; i < ARCMSR_MAX_HBB_POSTQUEUE; i++) {
-			if ((flag_ccb = readl(&reg->done_qbuffer[i])) != 0) {
-				writel(0, &reg->done_qbuffer[i]);
+			if ((flag_ccb = ioread32(&reg->done_qbuffer[i])) != 0) {
+				iowrite32(0, &reg->done_qbuffer[i]);
 				pARCMSR_CDB = (struct ARCMSR_CDB *)
 				(acb->vir2phy_offset + (flag_ccb << 5));
 				pCCB = container_of(pARCMSR_CDB,
@@ -1254,11 +1532,11 @@ arcmsr_done4abort_postqueue(struct Adapt
 		uint32_t flag_ccb, ccb_cdb_phy;
 		bool error;
 		struct CommandControlBlock *pCCB;
-		while ((readl(&reg->host_int_status) &
+		while ((ioread32(&reg->host_int_status) &
 			ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR)
 			&& (i++ < ARCMSR_MAX_OUTSTANDING_CMD)) {
 			/*need to do*/
-			flag_ccb = readl(&reg->outbound_queueport_low);
+			flag_ccb = ioread32(&reg->outbound_queueport_low);
 			ccb_cdb_phy = (flag_ccb & 0xFFFFFFF0);
 			pARCMSR_CDB = (struct  ARCMSR_CDB *)
 				(acb->vir2phy_offset+ccb_cdb_phy);
@@ -1268,6 +1546,57 @@ arcmsr_done4abort_postqueue(struct Adapt
 				? true : false;
 			arcmsr_drain_donequeue(acb, pCCB, error);
 		}
+		}
+		break;
+	case ACB_ADAPTER_TYPE_D: {
+		struct MessageUnit_D __iomem *pmu = acb->pmuD;
+		uint32_t ccb_cdb_phy, outbound_write_pointer;
+		uint32_t doneq_index, index_stripped, addressLow, residual;
+		bool error;
+		struct CommandControlBlock *pCCB;
+		outbound_write_pointer = ioread32(pmu->outboundlist_copy_pointer);
+		doneq_index = pmu->doneq_index;
+		residual = atomic_read(&acb->ccboutstandingcount);
+		for (i = 0; i < residual; i++) {
+			while ((doneq_index & 0xFF) != (outbound_write_pointer & 0xFF)) {
+				if (doneq_index & 0x4000) {
+					index_stripped = doneq_index & 0xFF;
+					index_stripped += 1;
+					index_stripped %=
+					ARCMSR_MAX_ARC1214_POSTQUEUE;
+					pmu->doneq_index = index_stripped ?
+					(index_stripped | 0x4000) : index_stripped;
+				} else {
+					index_stripped = doneq_index;
+					index_stripped += 1;
+					index_stripped %=
+					ARCMSR_MAX_ARC1214_POSTQUEUE;
+					pmu->doneq_index =
+					index_stripped ? index_stripped : (index_stripped | 0x4000);
+				}
+				doneq_index = pmu->doneq_index;
+				addressLow =
+				pmu->done_qbuffer[doneq_index & 0xFF].addressLow;
+				ccb_cdb_phy = (addressLow & 0xFFFFFFF0);
+				pARCMSR_CDB = (struct  ARCMSR_CDB *)
+				(acb->vir2phy_offset + ccb_cdb_phy);
+				pCCB = container_of(pARCMSR_CDB,
+				struct CommandControlBlock, arcmsr_cdb);
+				error =
+				(addressLow & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1)
+				? true : false;
+				arcmsr_drain_donequeue(acb, pCCB, error);
+				iowrite32(doneq_index,
+					pmu->outboundlist_read_pointer);
+			}
+			mdelay(10);
+			outbound_write_pointer =
+				ioread32(pmu->outboundlist_copy_pointer);
+			doneq_index = pmu->doneq_index;
+		}
+		pmu->postq_index = 0;
+		pmu->doneq_index = 0x40FF;
+		break;
 	}
 	}
 }
@@ -1278,7 +1607,7 @@ arcmsr_remove(struct pci_dev *pdev)
 	struct Scsi_Host *host = pci_get_drvdata(pdev);
 	struct AdapterControlBlock *acb =
 		(struct AdapterControlBlock *)host->hostdata;
-	int poll_count = 0;
+	int poll_count = 0, i;
 	arcmsr_free_sysfs_attr(acb);
 	scsi_remove_host(host);
 	flush_work_sync(&acb->arcmsr_do_message_isr_bh);
@@ -1298,7 +1627,6 @@ arcmsr_remove(struct pci_dev *pdev)
 	}
 
 	if (atomic_read(&acb->ccboutstandingcount)) {
-		int i;
 		arcmsr_abort_allcmd(acb);
 		arcmsr_done4abort_postqueue(acb);
 		for (i = 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {
@@ -1311,9 +1639,19 @@ arcmsr_remove(struct pci_dev *pdev)
 			}
 		}
 	}
-	free_irq(pdev->irq, acb);
 	arcmsr_free_ccb_pool(acb);
-	arcmsr_free_hbb_mu(acb);
+	arcmsr_free_mu(acb);
+	if (acb->acb_flags & ACB_F_MSI_ENABLED) {
+		free_irq(pdev->irq, acb);
+		pci_disable_msi(pdev);
+	} else if (acb->acb_flags & ACB_F_MSIX_ENABLED) {
+		for (i = 0; i < ARCMST_NUM_MSIX_VECTORS; i++) {
+			free_irq(acb->entries[i].vector, acb);
+		}
+		pci_disable_msix(pdev);
+	} else {
+		free_irq(pdev->irq, acb);
+	}
 	arcmsr_unmap_pciregion(acb);
 	pci_release_regions(pdev);
 	scsi_host_put(host);
@@ -1324,11 +1662,20 @@ arcmsr_remove(struct pci_dev *pdev)
 static void
 arcmsr_shutdown(struct pci_dev *pdev)
 {
+	int i;
 	struct Scsi_Host *host = pci_get_drvdata(pdev);
 	struct AdapterControlBlock *acb =
 		(struct AdapterControlBlock *)host->hostdata;
 	del_timer_sync(&acb->eternal_timer);
 	arcmsr_disable_outbound_ints(acb);
+	if (acb->acb_flags & ACB_F_MSIX_ENABLED) {
+		for (i = 0; i < ARCMST_NUM_MSIX_VECTORS; i++) {
+			free_irq(acb->entries[i].vector, acb);
+		}
+		pci_disable_msix(pdev);
+	} else {
+		free_irq(pdev->irq, acb);
+	}
 	flush_work_sync(&acb->arcmsr_do_message_isr_bh);
 	arcmsr_stop_adapter_bgrb(acb);
 	arcmsr_flush_adapter_cache(acb);
@@ -1361,7 +1708,7 @@ arcmsr_enable_outbound_ints(struct Adapt
 		~(ARCMSR_MU_OUTBOUND_POSTQUEUE_INTMASKENABLE |
 		     ARCMSR_MU_OUTBOUND_DOORBELL_INTMASKENABLE |
 		     ARCMSR_MU_OUTBOUND_MESSAGE0_INTMASKENABLE);
-		writel(mask, &reg->outbound_intmask);
+		iowrite32(mask, &reg->outbound_intmask);
 		acb->outbound_int_enable = ~(intmask_org & mask) &
 			0x000000ff;
 		}
@@ -1373,20 +1720,28 @@ arcmsr_enable_outbound_ints(struct Adapt
 			ARCMSR_IOP2DRV_DATA_READ_OK |
 			ARCMSR_IOP2DRV_CDB_DONE |
 			ARCMSR_IOP2DRV_MESSAGE_CMD_DONE);
-		writel(mask, reg->iop2drv_doorbell_mask);
+		iowrite32(mask, reg->iop2drv_doorbell_mask);
 		acb->outbound_int_enable = (intmask_org | mask) &
 			0x0000000f;
 		}
 		break;
 	case ACB_ADAPTER_TYPE_C: {
-		struct MessageUnit_C *reg = acb->pmuC;
+		struct MessageUnit_C __iomem *reg = acb->pmuC;
 		mask = ~(ARCMSR_HBCMU_UTILITY_A_ISR_MASK |
 			ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR_MASK |
 			ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR_MASK);
-		writel(intmask_org & mask, &reg->host_int_mask);
+		iowrite32(intmask_org & mask, &reg->host_int_mask);
+		ioread32(&reg->host_int_mask);
 		acb->outbound_int_enable = ~(intmask_org & mask) &
 			0x0000000f;
 		}
+		break;
+	case ACB_ADAPTER_TYPE_D: {
+		struct MessageUnit_D __iomem *reg = acb->pmuD;
+		mask = ARCMSR_ARC1214_ALL_INT_ENABLE;
+		iowrite32(intmask_org | mask, reg->pcief0_int_enable);
+		ioread32(reg->pcief0_int_enable);
+	}
 	}
 }
 
@@ -1408,7 +1763,6 @@ arcmsr_build_ccb(struct AdapterControlBl
 	arcmsr_cdb->TargetID = pcmd->device->id;
 	arcmsr_cdb->LUN = pcmd->device->lun;
 	arcmsr_cdb->Function = 1;
-	arcmsr_cdb->Context = 0;
 	memcpy(arcmsr_cdb->Cdb, pcmd->cmnd, pcmd->cmd_len);
 
 	nseg = scsi_dma_map(pcmd);
@@ -1453,9 +1807,10 @@ static void
 arcmsr_post_ccb(struct AdapterControlBlock *acb,
 	struct CommandControlBlock *ccb)
 {
-	uint32_t cdb_phyaddr_pattern = ccb->cdb_phyaddr_pattern;
+	uint32_t cdb_phyaddr = ccb->cdb_phyaddr;
 	struct ARCMSR_CDB *arcmsr_cdb =
 		(struct ARCMSR_CDB *)&ccb->arcmsr_cdb;
+	u32 arccdbsize = ccb->arc_cdb_size;
 	atomic_inc(&acb->ccboutstandingcount);
 	ccb->startdone = ARCMSR_CCB_START;
 	switch (acb->adapter_type) {
@@ -1463,12 +1818,11 @@ arcmsr_post_ccb(struct AdapterControlBlo
 		struct MessageUnit_A __iomem *reg = acb->pmuA;
 
 		if (arcmsr_cdb->Flags & ARCMSR_CDB_FLAG_SGL_BSIZE)
-			writel(cdb_phyaddr_pattern |
+			iowrite32(cdb_phyaddr |
 			ARCMSR_CCBPOST_FLAG_SGL_BSIZE,
 			&reg->inbound_queueport);
 		else {
-				writel(cdb_phyaddr_pattern,
-				&reg->inbound_queueport);
+			iowrite32(cdb_phyaddr, &reg->inbound_queueport);
 		}
 		}
 		break;
@@ -1479,19 +1833,19 @@ arcmsr_post_ccb(struct AdapterControlBlo
 
 		ending_index = ((index + 1) %
 			ARCMSR_MAX_HBB_POSTQUEUE);
-		writel(0, &reg->post_qbuffer[ending_index]);
+		iowrite32(0, &reg->post_qbuffer[ending_index]);
 		if (arcmsr_cdb->Flags & ARCMSR_CDB_FLAG_SGL_BSIZE) {
-			writel(cdb_phyaddr_pattern |
+			iowrite32(cdb_phyaddr |
 			ARCMSR_CCBPOST_FLAG_SGL_BSIZE,
 			 &reg->post_qbuffer[index]);
 		} else {
-			writel(cdb_phyaddr_pattern,
+			iowrite32(cdb_phyaddr,
 				&reg->post_qbuffer[index]);
 		}
 		index++;
 		index %= ARCMSR_MAX_HBB_POSTQUEUE;
 		reg->postq_index = index;
-		writel(ARCMSR_DRV2IOP_CDB_POSTED,
+		iowrite32(ARCMSR_DRV2IOP_CDB_POSTED,
 			reg->drv2iop_doorbell);
 		}
 		break;
@@ -1502,26 +1856,54 @@ arcmsr_post_ccb(struct AdapterControlBlo
 
 		arc_cdb_size = (ccb->arc_cdb_size > 0x300)
 			? 0x300 : ccb->arc_cdb_size;
-		ccb_post_stamp = (cdb_phyaddr_pattern |
+		ccb_post_stamp = (cdb_phyaddr |
 			((arc_cdb_size - 1) >> 6) | 1);
 		if (acb->cdb_phyaddr_hi32) {
-			writel(acb->cdb_phyaddr_hi32,
+			iowrite32(acb->cdb_phyaddr_hi32,
 			&phbcmu->inbound_queueport_high);
-			writel(ccb_post_stamp,
+			iowrite32(ccb_post_stamp,
 			&phbcmu->inbound_queueport_low);
 		} else {
-			writel(ccb_post_stamp,
+			iowrite32(ccb_post_stamp,
 			&phbcmu->inbound_queueport_low);
 		}
 		}
+		break;
+	case ACB_ADAPTER_TYPE_D: {
+		struct MessageUnit_D *pmu = acb->pmuD;
+		u16 index_stripped;
+		u16 postq_index;
+		unsigned long flags;
+		struct InBound_SRB *pinbound_srb;
+		spin_lock_irqsave(&acb->postq_lock, flags);
+		postq_index = pmu->postq_index;
+		pinbound_srb = (struct InBound_SRB *)&pmu->post_qbuffer[postq_index & 0xFF];
+		pinbound_srb->addressHigh = dma_addr_hi32(cdb_phyaddr);
+		pinbound_srb->addressLow= dma_addr_lo32(cdb_phyaddr);
+		pinbound_srb->length= arccdbsize / 4;
+		arcmsr_cdb->msgContext = dma_addr_lo32(cdb_phyaddr);
+		if (postq_index & 0x4000) {
+			index_stripped = postq_index & 0xFF;
+			index_stripped += 1;
+			index_stripped %= ARCMSR_MAX_ARC1214_POSTQUEUE;
+			pmu->postq_index = index_stripped ? (index_stripped | 0x4000) : index_stripped;
+		} else {
+			index_stripped = postq_index;
+			index_stripped += 1;
+			index_stripped %= ARCMSR_MAX_ARC1214_POSTQUEUE;
+			pmu->postq_index = index_stripped ? index_stripped : (index_stripped | 0x4000);
+		}
+		iowrite32(postq_index, pmu->inboundlist_write_pointer);
+		spin_unlock_irqrestore(&acb->postq_lock, flags);
+	}
 	}
 }
 
-static void arcmsr_stop_hba_bgrb(struct AdapterControlBlock *acb)
+static void arcmsr_hbaA_stop_bgrb(struct AdapterControlBlock *acb)
 {
 	struct MessageUnit_A __iomem *reg = acb->pmuA;
 	acb->acb_flags &= ~ACB_F_MSG_START_BGRB;
-	writel(ARCMSR_INBOUND_MESG0_STOP_BGRB, &reg->inbound_msgaddr0);
+	iowrite32(ARCMSR_INBOUND_MESG0_STOP_BGRB, &reg->inbound_msgaddr0);
 	if (!arcmsr_hbaA_wait_msgint_ready(acb)) {
 		printk(KERN_NOTICE
 		"arcmsr%d: wait 'stop adapter background rebulid' timeout \n"
@@ -1530,11 +1912,11 @@ static void arcmsr_stop_hba_bgrb(struct
 }
 
 static void
-arcmsr_stop_hbb_bgrb(struct AdapterControlBlock *acb)
+arcmsr_hbaB_stop_bgrb(struct AdapterControlBlock *acb)
 {
 	struct MessageUnit_B *reg = acb->pmuB;
 	acb->acb_flags &= ~ACB_F_MSG_START_BGRB;
-	writel(ARCMSR_MESSAGE_STOP_BGRB, reg->drv2iop_doorbell);
+	iowrite32(ARCMSR_MESSAGE_STOP_BGRB, reg->drv2iop_doorbell);
 
 	if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
 		printk(KERN_NOTICE
@@ -1544,13 +1926,15 @@ arcmsr_stop_hbb_bgrb(struct AdapterContr
 }
 
 static void
-arcmsr_stop_hbc_bgrb(struct AdapterControlBlock *pACB)
+arcmsr_hbaC_stop_bgrb(struct AdapterControlBlock *pACB)
 {
 	struct MessageUnit_C *reg = (struct MessageUnit_C *)pACB->pmuC;
 	pACB->acb_flags &= ~ACB_F_MSG_START_BGRB;
-	writel(ARCMSR_INBOUND_MESG0_STOP_BGRB, &reg->inbound_msgaddr0);
-	writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,
+	iowrite32(ARCMSR_INBOUND_MESG0_STOP_BGRB, &reg->inbound_msgaddr0);
+	iowrite32(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,
 		&reg->inbound_doorbell);
+	ioread32(&reg->inbound_doorbell);
+	ioread32(&reg->inbound_msgaddr0);
 	if (!arcmsr_hbaC_wait_msgint_ready(pACB)) {
 		printk(KERN_NOTICE
 		"arcmsr%d: wait 'stop adapter background rebulid' timeout\n"
@@ -1558,30 +1942,63 @@ arcmsr_stop_hbc_bgrb(struct AdapterContr
 	}
 	return;
 }
+
+static void
+arcmsr_hbaD_stop_bgrb(struct AdapterControlBlock *pACB)
+{
+	struct MessageUnit_D __iomem *reg =
+		(struct MessageUnit_D *)pACB->pmuD;
+
+	pACB->acb_flags &= ~ACB_F_MSG_START_BGRB;
+	iowrite32(ARCMSR_INBOUND_MESG0_STOP_BGRB,
+		reg->inbound_msgaddr0);
+	if (!arcmsr_hbaD_wait_msgint_ready(pACB)) {
+		printk(KERN_NOTICE
+		"arcmsr%d: wait 'stop adapter background rebulid' timeout \n"
+		, pACB->host->host_no);
+	}
+	return;
+}
+
 static void
 arcmsr_stop_adapter_bgrb(struct AdapterControlBlock *acb)
 {
 	switch (acb->adapter_type) {
 	case ACB_ADAPTER_TYPE_A: {
-		arcmsr_stop_hba_bgrb(acb);
-		}
+		arcmsr_hbaA_stop_bgrb(acb);
 		break;
-
+	}
 	case ACB_ADAPTER_TYPE_B: {
-		arcmsr_stop_hbb_bgrb(acb);
-		}
+		arcmsr_hbaB_stop_bgrb(acb);
 		break;
+	}
 	case ACB_ADAPTER_TYPE_C: {
-		arcmsr_stop_hbc_bgrb(acb);
-		}
+		arcmsr_hbaC_stop_bgrb(acb);
+		break;
+	}
+	case ACB_ADAPTER_TYPE_D: {
+		arcmsr_hbaD_stop_bgrb(acb);
+		break;
+	}
 	}
 }
 
 static void
 arcmsr_free_ccb_pool(struct AdapterControlBlock *acb)
 {
-	dma_free_coherent(&acb->pdev->dev, acb->uncache_size,
-	acb->dma_coherent, acb->dma_coherent_handle);
+	switch (acb->adapter_type) {
+	case ACB_ADAPTER_TYPE_A:
+	case ACB_ADAPTER_TYPE_C:
+	case ACB_ADAPTER_TYPE_B:
+		dma_free_coherent(&acb->pdev->dev, acb->uncache_size,
+			acb->dma_coherent, acb->dma_coherent_handle);
+		break;
+	case ACB_ADAPTER_TYPE_D: {
+		dma_free_coherent(&acb->pdev->dev, acb->roundup_ccbsize,
+			acb->dma_coherent2, acb->dma_coherent_handle2);
+		break;
+	}
+	}
 }
 
 void
@@ -1590,22 +2007,30 @@ arcmsr_iop_message_read(struct AdapterCo
 	switch (acb->adapter_type) {
 	case ACB_ADAPTER_TYPE_A: {
 		struct MessageUnit_A __iomem *reg = acb->pmuA;
-		writel(ARCMSR_INBOUND_DRIVER_DATA_READ_OK,
+		iowrite32(ARCMSR_INBOUND_DRIVER_DATA_READ_OK,
 		&reg->inbound_doorbell);
 		}
 		break;
 
 	case ACB_ADAPTER_TYPE_B: {
 		struct MessageUnit_B *reg = acb->pmuB;
-		writel(ARCMSR_DRV2IOP_DATA_READ_OK,
+		iowrite32(ARCMSR_DRV2IOP_DATA_READ_OK,
 		reg->drv2iop_doorbell);
 		}
 		break;
 	case ACB_ADAPTER_TYPE_C: {
 		struct MessageUnit_C __iomem *reg = acb->pmuC;
-		writel(ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK,
-		&reg->inbound_doorbell);
+		iowrite32(ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK, &reg->inbound_doorbell);
+		ioread32(&reg->inbound_doorbell);
 		}
+		break;
+	case ACB_ADAPTER_TYPE_D: {
+		struct MessageUnit_D __iomem *reg = acb->pmuD;
+		iowrite32(ARCMSR_ARC1214_DRV2IOP_DATA_OUT_READ,
+		reg->inbound_doorbell);
+		ioread32(reg->inbound_doorbell);
+		break;
+	}
 	}
 }
 
@@ -1619,7 +2044,7 @@ arcmsr_iop_message_wrote(struct AdapterC
 		** push inbound doorbell tell iop, driver data write ok
 		** and wait reply on next hwinterrupt for next Qbuffer post
 		*/
-		writel(ARCMSR_INBOUND_DRIVER_DATA_WRITE_OK,
+		iowrite32(ARCMSR_INBOUND_DRIVER_DATA_WRITE_OK,
 		&reg->inbound_doorbell);
 		}
 		break;
@@ -1630,7 +2055,7 @@ arcmsr_iop_message_wrote(struct AdapterC
 		** push inbound doorbell tell iop, driver data write ok
 		** and wait reply on next hwinterrupt for next Qbuffer post
 		*/
-		writel(ARCMSR_DRV2IOP_DATA_WRITE_OK,
+		iowrite32(ARCMSR_DRV2IOP_DATA_WRITE_OK,
 		reg->drv2iop_doorbell);
 		}
 		break;
@@ -1640,10 +2065,18 @@ arcmsr_iop_message_wrote(struct AdapterC
 		** push inbound doorbell tell iop, driver data write ok
 		** and wait reply on next hwinterrupt for next Qbuffer post
 		*/
-		writel(ARCMSR_HBCMU_DRV2IOP_DATA_WRITE_OK,
+		iowrite32(ARCMSR_HBCMU_DRV2IOP_DATA_WRITE_OK,
 		&reg->inbound_doorbell);
+		ioread32(&reg->inbound_doorbell);
 		}
 		break;
+	case ACB_ADAPTER_TYPE_D: {
+		struct MessageUnit_D __iomem *reg = acb->pmuD;
+		iowrite32(ARCMSR_ARC1214_DRV2IOP_DATA_IN_READY,
+		reg->inbound_doorbell);
+		ioread32(reg->inbound_doorbell);
+		break;
+	}
 	}
 }
 
@@ -1669,6 +2102,13 @@ struct QBUFFER __iomem
 			(struct MessageUnit_C *)acb->pmuC;
 		qbuffer = (struct QBUFFER __iomem *)&phbcmu->message_rbuffer;
 		}
+		break;
+	case ACB_ADAPTER_TYPE_D: {
+		struct MessageUnit_D __iomem *reg =
+			(struct MessageUnit_D *)acb->pmuD;
+		qbuffer = (struct QBUFFER __iomem *)reg->message_rbuffer;
+		break;
+	}
 	}
 	return qbuffer;
 }
@@ -1693,6 +2133,13 @@ struct QBUFFER __iomem
 	case ACB_ADAPTER_TYPE_C: {
 		struct MessageUnit_C *reg = (struct MessageUnit_C *)acb->pmuC;
 		pqbuffer = (struct QBUFFER __iomem *)&reg->message_wbuffer;
+		}
+		break;
+	case ACB_ADAPTER_TYPE_D: {
+		struct MessageUnit_D __iomem *pmu =
+		(struct MessageUnit_D *)acb->pmuD;
+		pqbuffer = (struct QBUFFER __iomem *)pmu->message_wbuffer;
+		break;
 	}
 	}
 	return pqbuffer;
@@ -1701,10 +2148,13 @@ struct QBUFFER __iomem
 void
 arcmsr_iop2drv_data_wrote_handle(struct AdapterControlBlock *acb)
 {
+	uint8_t __iomem *iop_data;
 	struct QBUFFER __iomem *prbuffer;
 	struct QBUFFER *pQbuffer;
-	uint8_t __iomem *iop_data;
 	int32_t my_empty_len, iop_len, rqbuf_firstindex, rqbuf_lastindex;
+	unsigned long flags;
+
+	spin_lock_irqsave(&acb->rqbuffer_lock, flags);
 	rqbuf_lastindex = acb->rqbuf_lastindex;
 	rqbuf_firstindex = acb->rqbuf_firstindex;
 	prbuffer = arcmsr_get_iop_rqbuffer(acb);
@@ -1728,11 +2178,15 @@ arcmsr_iop2drv_data_wrote_handle(struct
 	} else {
 		acb->acb_flags |= ACB_F_IOPDATA_OVERFLOW;
 	}
+	spin_unlock_irqrestore(&acb->rqbuffer_lock, flags);
 }
 
 void
 arcmsr_iop2drv_data_read_handle(struct AdapterControlBlock *acb)
 {
+	unsigned long flags;
+
+	spin_lock_irqsave(&acb->wqbuffer_lock, flags);
 	acb->acb_flags |= ACB_F_MESSAGE_WQBUFFER_READED;
 	if (acb->wqbuf_firstindex != acb->wqbuf_lastindex) {
 		uint8_t *pQbuffer;
@@ -1759,41 +2213,98 @@ arcmsr_iop2drv_data_read_handle(struct A
 	if (acb->wqbuf_firstindex == acb->wqbuf_lastindex) {
 		acb->acb_flags |= ACB_F_MESSAGE_WQBUFFER_CLEARED;
 	}
+	spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);
 }
 
 static void
 arcmsr_hbaA_doorbell_isr(struct AdapterControlBlock *acb)
 {
-	uint32_t outbound_doorbell;
-	struct MessageUnit_A __iomem *reg = acb->pmuA;
-	outbound_doorbell = readl(&reg->outbound_doorbell);
-	writel(outbound_doorbell, &reg->outbound_doorbell);
-	if (outbound_doorbell & ARCMSR_OUTBOUND_IOP331_DATA_WRITE_OK) {
-		arcmsr_iop2drv_data_wrote_handle(acb);
-	}
+    	uint32_t outbound_doorbell;
+	struct MessageUnit_A __iomem *reg  = acb->pmuA;
 
-	if (outbound_doorbell & ARCMSR_OUTBOUND_IOP331_DATA_READ_OK) {
-		arcmsr_iop2drv_data_read_handle(acb);
-	}
+	outbound_doorbell = ioread32(&reg->outbound_doorbell);
+	do {
+		iowrite32(outbound_doorbell, &reg->outbound_doorbell);
+		if (outbound_doorbell &
+			ARCMSR_OUTBOUND_IOP331_DATA_WRITE_OK) {
+			arcmsr_iop2drv_data_wrote_handle(acb);
+		}
+		if (outbound_doorbell &
+			ARCMSR_OUTBOUND_IOP331_DATA_READ_OK) {
+			arcmsr_iop2drv_data_read_handle(acb);
+		}
+		outbound_doorbell = ioread32(&reg->outbound_doorbell);
+	} while (outbound_doorbell &
+	(ARCMSR_OUTBOUND_IOP331_DATA_WRITE_OK
+	| ARCMSR_OUTBOUND_IOP331_DATA_READ_OK));
 }
 static void
 arcmsr_hbaC_doorbell_isr(struct AdapterControlBlock *pACB)
 {
 	uint32_t outbound_doorbell;
-	struct MessageUnit_C *reg = (struct MessageUnit_C *)pACB->pmuC;
-	outbound_doorbell = readl(&reg->outbound_doorbell);
-	writel(outbound_doorbell, &reg->outbound_doorbell_clear);
-	if (outbound_doorbell & ARCMSR_HBCMU_IOP2DRV_DATA_WRITE_OK) {
+	struct MessageUnit_C __iomem *reg =
+		(struct MessageUnit_C *)pACB->pmuC;
+
+	outbound_doorbell = ioread32(&reg->outbound_doorbell);
+	if (unlikely(!outbound_doorbell)) {
 		arcmsr_iop2drv_data_wrote_handle(pACB);
-	}
-	if (outbound_doorbell & ARCMSR_HBCMU_IOP2DRV_DATA_READ_OK) {
 		arcmsr_iop2drv_data_read_handle(pACB);
 	}
-	if (outbound_doorbell & ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {
-		arcmsr_hbaC_message_isr(pACB);
+	do {
+		if (outbound_doorbell &
+			ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {
+			arcmsr_hbaC_message_isr(pACB);
+		}
+		iowrite32(outbound_doorbell, &reg->outbound_doorbell_clear);
+		ioread32(&reg->outbound_doorbell_clear);
+		if (outbound_doorbell &
+			ARCMSR_HBCMU_IOP2DRV_DATA_WRITE_OK) {
+			arcmsr_iop2drv_data_wrote_handle(pACB);
+		}
+		if (outbound_doorbell &
+			ARCMSR_HBCMU_IOP2DRV_DATA_READ_OK) {
+			arcmsr_iop2drv_data_read_handle(pACB);
+		}
+		outbound_doorbell = ioread32(&reg->outbound_doorbell);
+	} while (outbound_doorbell & (ARCMSR_HBCMU_IOP2DRV_DATA_WRITE_OK
+	| ARCMSR_HBCMU_IOP2DRV_DATA_READ_OK
+	| ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE));
+	return;
+}
+
+static void
+arcmsr_hbaD_doorbell_isr(struct AdapterControlBlock *pACB)
+{
+	uint32_t outbound_doorbell;
+	struct MessageUnit_D __iomem *pmu =
+		(struct MessageUnit_D *)pACB->pmuD;
+
+	outbound_doorbell = ioread32(pmu->outbound_doorbell);
+	if (unlikely(!outbound_doorbell)) {
+		arcmsr_iop2drv_data_wrote_handle(pACB);
+		arcmsr_iop2drv_data_read_handle(pACB);
 	}
+	do {
+		iowrite32(outbound_doorbell, pmu->outbound_doorbell);
+		if (outbound_doorbell &
+			ARCMSR_ARC1214_IOP2DRV_MESSAGE_CMD_DONE) {
+			arcmsr_hbaD_message_isr(pACB);
+		}
+		if (outbound_doorbell &
+			ARCMSR_ARC1214_IOP2DRV_DATA_WRITE_OK) {
+			arcmsr_iop2drv_data_wrote_handle(pACB);
+		}
+		if (outbound_doorbell &
+			ARCMSR_ARC1214_IOP2DRV_DATA_READ_OK) {
+			arcmsr_iop2drv_data_read_handle(pACB);
+		}
+		outbound_doorbell = ioread32(pmu->outbound_doorbell);
+	} while (outbound_doorbell & (ARCMSR_ARC1214_IOP2DRV_DATA_WRITE_OK
+	| ARCMSR_ARC1214_IOP2DRV_DATA_READ_OK
+	| ARCMSR_ARC1214_IOP2DRV_MESSAGE_CMD_DONE));
 	return;
 }
+
 static void
 arcmsr_hbaA_postqueue_isr(struct AdapterControlBlock *acb)
 {
@@ -1802,7 +2313,7 @@ arcmsr_hbaA_postqueue_isr(struct Adapter
 	struct ARCMSR_CDB *pARCMSR_CDB;
 	struct CommandControlBlock *pCCB;
 	bool error;
-	while ((flag_ccb = readl(&reg->outbound_queueport)) != 0xFFFFFFFF) {
+	while ((flag_ccb = ioread32(&reg->outbound_queueport)) != 0xFFFFFFFF) {
 		pARCMSR_CDB = (struct ARCMSR_CDB *)
 			(acb->vir2phy_offset + (flag_ccb << 5));
 		pCCB = container_of(pARCMSR_CDB,
@@ -1822,8 +2333,8 @@ arcmsr_hbaB_postqueue_isr(struct Adapter
 	struct CommandControlBlock *pCCB;
 	bool error;
 	index = reg->doneq_index;
-	while ((flag_ccb = readl(&reg->done_qbuffer[index])) != 0) {
-		writel(0, &reg->done_qbuffer[index]);
+	while ((flag_ccb = ioread32(&reg->done_qbuffer[index])) != 0) {
+		iowrite32(0, &reg->done_qbuffer[index]);
 		pARCMSR_CDB = (struct ARCMSR_CDB *)
 		(acb->vir2phy_offset + (flag_ccb << 5));
 		pCCB = container_of(pARCMSR_CDB,
@@ -1841,33 +2352,84 @@ arcmsr_hbaB_postqueue_isr(struct Adapter
 static void
 arcmsr_hbaC_postqueue_isr(struct AdapterControlBlock *acb)
 {
-	struct MessageUnit_C *phbcmu;
-	struct ARCMSR_CDB *arcmsr_cdb;
-	struct CommandControlBlock *ccb;
 	uint32_t flag_ccb, ccb_cdb_phy, throttling = 0;
 	int error;
+	struct MessageUnit_C __iomem *phbcmu;
+	struct ARCMSR_CDB *arcmsr_cdb;
+	struct CommandControlBlock *ccb;
 
 	phbcmu = (struct MessageUnit_C *)acb->pmuC;
 	/* areca cdb command done */
 	/* Use correct offset and size for syncing */
+	do {
+		/* check if command done with no error*/
+		flag_ccb = ioread32(&phbcmu->outbound_queueport_low);
+		ccb_cdb_phy = (flag_ccb & 0xFFFFFFF0);
+		arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset
+			+ ccb_cdb_phy);
+		ccb = container_of(arcmsr_cdb, struct CommandControlBlock,
+			arcmsr_cdb);
+		error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1)
+			? true : false;
+		/* check if command done with no error */
+		arcmsr_drain_donequeue(acb, ccb, error);
+		if (throttling == ARCMSR_HBC_ISR_THROTTLING_LEVEL) {
+			iowrite32(ARCMSR_HBCMU_DRV2IOP_POSTQUEUE_THROTTLING,
+				&phbcmu->inbound_doorbell);
+			continue;
+		}
+		throttling++;
+	} while (ioread32(&phbcmu->host_int_status) &
+	ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR);
+}
 
-	while (readl(&phbcmu->host_int_status) &
-	ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR) {
-	/* check if command done with no error*/
-	flag_ccb = readl(&phbcmu->outbound_queueport_low);
-	ccb_cdb_phy = (flag_ccb & 0xFFFFFFF0);
-	arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset + ccb_cdb_phy);
-	ccb = container_of(arcmsr_cdb, struct CommandControlBlock, arcmsr_cdb);
-	error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1) ? true : false;
-	/* check if command done with no error */
-	arcmsr_drain_donequeue(acb, ccb, error);
-	if (throttling == ARCMSR_HBC_ISR_THROTTLING_LEVEL) {
-		writel(ARCMSR_HBCMU_DRV2IOP_POSTQUEUE_THROTTLING,
-		&phbcmu->inbound_doorbell);
-		break;
-	}
-	throttling++;
-	}
+static void
+arcmsr_hbaD_postqueue_isr(struct AdapterControlBlock *acb)
+{
+	u32 outbound_write_pointer, doneq_index, index_stripped;
+	uint32_t addressLow, ccb_cdb_phy;
+	int error;
+	struct MessageUnit_D __iomem *pmu;
+	struct ARCMSR_CDB *arcmsr_cdb;
+	struct CommandControlBlock *ccb;
+
+	pmu = (struct MessageUnit_D *)acb->pmuD;
+	outbound_write_pointer = ioread32(pmu->outboundlist_copy_pointer);
+	doneq_index = pmu->doneq_index;
+	if ((doneq_index & 0xFF) != (outbound_write_pointer & 0xFF)) {
+		do {
+			if (doneq_index & 0x4000) {
+				index_stripped = doneq_index & 0xFF;
+				index_stripped += 1;
+				index_stripped %= ARCMSR_MAX_ARC1214_POSTQUEUE;
+				pmu->doneq_index = index_stripped
+				? (index_stripped | 0x4000) : index_stripped;
+			} else {
+				index_stripped = doneq_index;
+				index_stripped += 1;
+				index_stripped %= ARCMSR_MAX_ARC1214_POSTQUEUE;
+				pmu->doneq_index = index_stripped
+				? index_stripped : (index_stripped | 0x4000);
+			}
+			doneq_index = pmu->doneq_index;
+			addressLow =
+			pmu->done_qbuffer[doneq_index & 0xFF].addressLow;
+			ccb_cdb_phy = (addressLow & 0xFFFFFFF0);
+			arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset
+				+ ccb_cdb_phy);
+			ccb = container_of(arcmsr_cdb,
+				struct CommandControlBlock, arcmsr_cdb);
+			error = (addressLow & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1)
+				? true : false;
+			arcmsr_drain_donequeue(acb, ccb, error);
+			iowrite32(doneq_index,
+				pmu->outboundlist_read_pointer);
+		} while ((doneq_index & 0xFF) !=
+		(outbound_write_pointer & 0xFF));
+	}
+	iowrite32(ARCMSR_ARC1214_OUTBOUND_LIST_INTERRUPT_CLEAR,
+		pmu->outboundlist_interrupt_cause);
+	ioread32(pmu->outboundlist_interrupt_cause);
 }
 
 static void
@@ -1875,7 +2437,7 @@ arcmsr_hbaA_message_isr(struct AdapterCo
 {
 	struct MessageUnit_A *reg  = acb->pmuA;
 	/*clear interrupt and message state*/
-	writel(ARCMSR_MU_OUTBOUND_MESSAGE0_INT, &reg->outbound_intstatus);
+	iowrite32(ARCMSR_MU_OUTBOUND_MESSAGE0_INT, &reg->outbound_intstatus);
 	schedule_work(&acb->arcmsr_do_message_isr_bh);
 }
 static void
@@ -1884,7 +2446,7 @@ arcmsr_hbaB_message_isr(struct AdapterCo
 	struct MessageUnit_B *reg  = acb->pmuB;
 
 	/*clear interrupt and message state*/
-	writel(ARCMSR_MESSAGE_INT_CLEAR_PATTERN, reg->iop2drv_doorbell);
+	iowrite32(ARCMSR_MESSAGE_INT_CLEAR_PATTERN, reg->iop2drv_doorbell);
 	schedule_work(&acb->arcmsr_do_message_isr_bh);
 }
 
@@ -1893,115 +2455,158 @@ arcmsr_hbaC_message_isr(struct AdapterCo
 {
 	struct MessageUnit_C *reg  = acb->pmuC;
 	/*clear interrupt and message state*/
-	writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR,
+	iowrite32(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR,
 	&reg->outbound_doorbell_clear);
 	schedule_work(&acb->arcmsr_do_message_isr_bh);
 }
 
-static int
+static void
+arcmsr_hbaD_message_isr(struct AdapterControlBlock *acb)
+{
+	struct MessageUnit_D __iomem *reg  = acb->pmuD;
+	iowrite32(ARCMSR_ARC1214_IOP2DRV_MESSAGE_CMD_DONE,
+		reg->outbound_doorbell);
+	ioread32(reg->outbound_doorbell);
+	schedule_work(&acb->arcmsr_do_message_isr_bh);
+}
+
+static irqreturn_t
 arcmsr_hbaA_handle_isr(struct AdapterControlBlock *acb)
 {
 	uint32_t outbound_intstatus;
 	struct MessageUnit_A __iomem *reg = acb->pmuA;
-	outbound_intstatus = readl(&reg->outbound_intstatus) &
-		acb->outbound_int_enable;
+	outbound_intstatus =
+		ioread32(&reg->outbound_intstatus) & acb->outbound_int_enable;
 	if (!(outbound_intstatus & ARCMSR_MU_OUTBOUND_HANDLE_INT)) {
-		return 1;
+        		return IRQ_NONE;
 	}
-	writel(outbound_intstatus, &reg->outbound_intstatus);
-	if (outbound_intstatus & ARCMSR_MU_OUTBOUND_DOORBELL_INT) {
-		arcmsr_hbaA_doorbell_isr(acb);
-	}
-	if (outbound_intstatus & ARCMSR_MU_OUTBOUND_POSTQUEUE_INT) {
-		arcmsr_hbaA_postqueue_isr(acb);
-	}
-	if (outbound_intstatus & ARCMSR_MU_OUTBOUND_MESSAGE0_INT) {
-		/* messenger of "driver to iop commands" */
-		arcmsr_hbaA_message_isr(acb);
-	}
-	return 0;
+	do {
+		iowrite32(outbound_intstatus, &reg->outbound_intstatus);
+		ioread32(&reg->outbound_intstatus);
+		if (outbound_intstatus & ARCMSR_MU_OUTBOUND_DOORBELL_INT) {
+			arcmsr_hbaA_doorbell_isr(acb);
+		}
+		if (outbound_intstatus & ARCMSR_MU_OUTBOUND_POSTQUEUE_INT) {
+			arcmsr_hbaA_postqueue_isr(acb);
+		}
+		if (outbound_intstatus & ARCMSR_MU_OUTBOUND_MESSAGE0_INT) {
+			arcmsr_hbaA_message_isr(acb);
+		}
+		outbound_intstatus = ioread32(&reg->outbound_intstatus) &
+			acb->outbound_int_enable;
+	} while (outbound_intstatus & (ARCMSR_MU_OUTBOUND_DOORBELL_INT
+	| ARCMSR_MU_OUTBOUND_POSTQUEUE_INT
+	| ARCMSR_MU_OUTBOUND_MESSAGE0_INT));
+	return IRQ_HANDLED;	
 }
 
-static int
+static irqreturn_t
 arcmsr_hbaB_handle_isr(struct AdapterControlBlock *acb)
 {
 	uint32_t outbound_doorbell;
 	struct MessageUnit_B *reg = acb->pmuB;
-	outbound_doorbell = readl(reg->iop2drv_doorbell) &
-	acb->outbound_int_enable;
+	outbound_doorbell = ioread32(reg->iop2drv_doorbell) & acb->outbound_int_enable;
 	if (!outbound_doorbell)
-		return 1;
-
-	writel(~outbound_doorbell, reg->iop2drv_doorbell);
-	/*in case the last action of doorbell interrupt clearance is cached,
-	this action can push HW to write down the clear bit*/
-	readl(reg->iop2drv_doorbell);
-	writel(ARCMSR_DRV2IOP_END_OF_INTERRUPT,
-		reg->drv2iop_doorbell);
-	if (outbound_doorbell & ARCMSR_IOP2DRV_DATA_WRITE_OK) {
-		arcmsr_iop2drv_data_wrote_handle(acb);
-	}
-	if (outbound_doorbell & ARCMSR_IOP2DRV_DATA_READ_OK) {
-		arcmsr_iop2drv_data_read_handle(acb);
-	}
-	if (outbound_doorbell & ARCMSR_IOP2DRV_CDB_DONE) {
-		arcmsr_hbaB_postqueue_isr(acb);
-	}
-	if (outbound_doorbell &
-		ARCMSR_IOP2DRV_MESSAGE_CMD_DONE) {
-		/* messenger of "driver to iop commands" */
-		arcmsr_hbaB_message_isr(acb);
-	}
-	return 0;
+		return IRQ_NONE;
+	do {
+		iowrite32(~outbound_doorbell, reg->iop2drv_doorbell);
+		ioread32(reg->iop2drv_doorbell);
+		iowrite32(ARCMSR_DRV2IOP_END_OF_INTERRUPT,
+			reg->drv2iop_doorbell);
+		ioread32(reg->drv2iop_doorbell);
+		if (outbound_doorbell & ARCMSR_IOP2DRV_DATA_WRITE_OK) {
+			arcmsr_iop2drv_data_wrote_handle(acb);
+		}
+		if (outbound_doorbell & ARCMSR_IOP2DRV_DATA_READ_OK) {
+			arcmsr_iop2drv_data_read_handle(acb);
+		}
+		if (outbound_doorbell & ARCMSR_IOP2DRV_CDB_DONE) {
+			arcmsr_hbaB_postqueue_isr(acb);
+		}
+		if (outbound_doorbell & ARCMSR_IOP2DRV_MESSAGE_CMD_DONE) {
+			arcmsr_hbaB_message_isr(acb);
+		}
+		outbound_doorbell = ioread32(reg->iop2drv_doorbell) &
+			acb->outbound_int_enable;
+	} while (outbound_doorbell & (ARCMSR_IOP2DRV_DATA_WRITE_OK
+	| ARCMSR_IOP2DRV_DATA_READ_OK
+	| ARCMSR_IOP2DRV_CDB_DONE
+	| ARCMSR_IOP2DRV_MESSAGE_CMD_DONE));
+	return IRQ_HANDLED;
 }
 
-static int
+static irqreturn_t
 arcmsr_hbaC_handle_isr(struct AdapterControlBlock *pACB)
 {
 	uint32_t host_interrupt_status;
-	struct MessageUnit_C *phbcmu =
-	(struct MessageUnit_C *)pACB->pmuC;
-	host_interrupt_status = readl(&phbcmu->host_int_status);
-	if (!host_interrupt_status) {
-		/*it must be share irq*/
-		return 1;
-	}
-	/* MU ioctl transfer doorbell interrupts*/
-	if (host_interrupt_status &
-		ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR) {
-		arcmsr_hbaC_doorbell_isr(pACB);
-	}
-	/* MU post queue interrupts*/
-	if (host_interrupt_status &
-		ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR) {
-		arcmsr_hbaC_postqueue_isr(pACB);
-	}
-	return 0;
+	struct MessageUnit_C __iomem *phbcmu =
+		(struct MessageUnit_C *)pACB->pmuC;
+	host_interrupt_status =
+		ioread32(&phbcmu->host_int_status);
+	do {
+		if (host_interrupt_status &
+			ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR) {
+			arcmsr_hbaC_doorbell_isr(pACB);
+		}
+		/* MU post queue interrupts*/
+		if (host_interrupt_status &
+			ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR) {
+			arcmsr_hbaC_postqueue_isr(pACB);
+		}
+		host_interrupt_status = ioread32(&phbcmu->host_int_status);
+	} while (host_interrupt_status &
+	(ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR |
+	ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR));
+	return IRQ_HANDLED;
 }
+
+static irqreturn_t
+arcmsr_hbaD_handle_isr(struct AdapterControlBlock *pACB)
+{
+	u32 host_interrupt_status;
+	struct MessageUnit_D __iomem *pmu =
+		(struct MessageUnit_D *)pACB->pmuD;
+	host_interrupt_status = ioread32(pmu->host_int_status);
+	do {
+		/* MU post queue interrupts*/
+		if (host_interrupt_status &
+			ARCMSR_ARC1214_OUTBOUND_POSTQUEUE_ISR) {
+			arcmsr_hbaD_postqueue_isr(pACB);
+		}
+		if (host_interrupt_status &
+			ARCMSR_ARC1214_OUTBOUND_DOORBELL_ISR) {
+			arcmsr_hbaD_doorbell_isr(pACB);
+		}
+		host_interrupt_status = ioread32(pmu->host_int_status);
+	} while (host_interrupt_status &
+	(ARCMSR_ARC1214_OUTBOUND_POSTQUEUE_ISR |
+	ARCMSR_ARC1214_OUTBOUND_DOORBELL_ISR));
+	return IRQ_HANDLED;
+}
+
 static irqreturn_t
 arcmsr_interrupt(struct AdapterControlBlock *acb)
 {
 	switch (acb->adapter_type) {
-	case ACB_ADAPTER_TYPE_A: {
-		if (arcmsr_hbaA_handle_isr(acb)) {
-			return IRQ_NONE;
-		}
-		}
-		break;
-
-	case ACB_ADAPTER_TYPE_B: {
-		if (arcmsr_hbaB_handle_isr(acb)) {
-			return IRQ_NONE;
+		case ACB_ADAPTER_TYPE_A: {
+			return arcmsr_hbaA_handle_isr(acb);
+			break;
+		} 
+		case ACB_ADAPTER_TYPE_B: {
+			return arcmsr_hbaB_handle_isr(acb);
+			break;
+		} 
+		case ACB_ADAPTER_TYPE_C: {
+			return arcmsr_hbaC_handle_isr(acb);
+			break;
 		}
+		case ACB_ADAPTER_TYPE_D: {
+			return arcmsr_hbaD_handle_isr(acb);
+			break;
 		}
-		break;
-	 case ACB_ADAPTER_TYPE_C: {
-		if (arcmsr_hbaC_handle_isr(acb)) {
+		default:
 			return IRQ_NONE;
-		}
-		}
 	}
-	return IRQ_HANDLED;
 }
 
 static void
@@ -2023,11 +2628,11 @@ arcmsr_iop_parking(struct AdapterControl
 void
 arcmsr_post_ioctldata2iop(struct AdapterControlBlock *acb)
 {
-	int32_t wqbuf_firstindex, wqbuf_lastindex;
-	uint8_t *pQbuffer;
-	struct QBUFFER __iomem *pwbuffer;
 	uint8_t __iomem *iop_data;
+	uint8_t *pQbuffer;
+	int32_t wqbuf_firstindex, wqbuf_lastindex;
 	int32_t allxfer_len = 0;
+	struct QBUFFER __iomem *pwbuffer;
 	pwbuffer = arcmsr_get_iop_wqbuffer(acb);
 	iop_data = (uint8_t __iomem *)pwbuffer->data;
 	if (acb->acb_flags & ACB_F_MESSAGE_WQBUFFER_READED) {
@@ -2037,14 +2642,14 @@ arcmsr_post_ioctldata2iop(struct Adapter
 		while ((wqbuf_firstindex != wqbuf_lastindex)
 			&& (allxfer_len < 124)) {
 			pQbuffer = &acb->wqbuffer[wqbuf_firstindex];
-			memcpy(iop_data, pQbuffer, 1);
+			iowrite8(*pQbuffer, iop_data);
 			wqbuf_firstindex++;
 			wqbuf_firstindex %= ARCMSR_MAX_QBUFFER;
 			iop_data++;
 			allxfer_len++;
 		}
 		acb->wqbuf_firstindex = wqbuf_firstindex;
-		pwbuffer->data_len = allxfer_len;
+		iowrite8(allxfer_len, &pwbuffer->data_len);
 		arcmsr_iop_message_wrote(acb);
 	}
 }
@@ -2080,6 +2685,7 @@ arcmsr_iop_message_xfer(struct AdapterCo
 		unsigned char *ver_addr;
 		uint8_t *pQbuffer, *ptmpQbuffer;
 		int32_t allxfer_len = 0;
+		unsigned long flags;
 
 		ver_addr = kmalloc(1032, GFP_ATOMIC);
 		if (!ver_addr) {
@@ -2087,6 +2693,7 @@ arcmsr_iop_message_xfer(struct AdapterCo
 			goto message_out;
 		}
 		ptmpQbuffer = ver_addr;
+		spin_lock_irqsave(&acb->rqbuffer_lock, flags);
 		while ((acb->rqbuf_firstindex != acb->rqbuf_lastindex)
 			&& (allxfer_len < 1031)) {
 			pQbuffer = &acb->rqbuffer[acb->rqbuf_firstindex];
@@ -2105,10 +2712,10 @@ arcmsr_iop_message_xfer(struct AdapterCo
 			acb->acb_flags &= ~ACB_F_IOPDATA_OVERFLOW;
 			prbuffer = arcmsr_get_iop_rqbuffer(acb);
 			iop_data = prbuffer->data;
-			iop_len = readl(&prbuffer->data_len);
+			iop_len = ioread32(&prbuffer->data_len);
 			while (iop_len > 0) {
 				acb->rqbuffer[acb->rqbuf_lastindex] =
-				readb(iop_data);
+				ioread8(iop_data);
 				acb->rqbuf_lastindex++;
 				acb->rqbuf_lastindex %= ARCMSR_MAX_QBUFFER;
 				iop_data++;
@@ -2116,6 +2723,7 @@ arcmsr_iop_message_xfer(struct AdapterCo
 			}
 			arcmsr_iop_message_read(acb);
 		}
+		spin_unlock_irqrestore(&acb->rqbuffer_lock, flags);
 		memcpy(pcmdmessagefld->messagedatabuffer,
 		ver_addr, allxfer_len);
 		pcmdmessagefld->cmdmessage.Length = allxfer_len;
@@ -2135,6 +2743,7 @@ arcmsr_iop_message_xfer(struct AdapterCo
 		int32_t my_empty_len, user_len, wqbuf_firstindex,
 		wqbuf_lastindex;
 		uint8_t *pQbuffer, *ptmpuserbuffer;
+		unsigned long flags;
 
 		ver_addr = kmalloc(1032, GFP_ATOMIC);
 		if (!ver_addr) {
@@ -2152,6 +2761,7 @@ arcmsr_iop_message_xfer(struct AdapterCo
 		user_len = pcmdmessagefld->cmdmessage.Length;
 		memcpy(ptmpuserbuffer, pcmdmessagefld->messagedatabuffer,
 		user_len);
+		spin_lock_irqsave(&acb->wqbuffer_lock, flags);
 		wqbuf_lastindex = acb->wqbuf_lastindex;
 		wqbuf_firstindex = acb->wqbuf_firstindex;
 		if (wqbuf_lastindex != wqbuf_firstindex) {
@@ -2197,6 +2807,7 @@ arcmsr_iop_message_xfer(struct AdapterCo
 				retvalue = ARCMSR_MESSAGE_FAIL;
 			}
 			}
+			spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);
 			kfree(ver_addr);
 		}
 		break;
@@ -2452,17 +3063,17 @@ arcmsr_hbaA_get_config(struct AdapterCon
 	char __iomem *iop_device_map =
 		(char __iomem *)(&reg->message_rwbuffer[21]);
 	int count;
-	writel(ARCMSR_INBOUND_MESG0_GET_CONFIG,
+	iowrite32(ARCMSR_INBOUND_MESG0_GET_CONFIG,
 		&reg->inbound_msgaddr0);
 	if (!arcmsr_hbaA_wait_msgint_ready(acb)) {
 		printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware"
-			"miscellaneous data' timeout\n",
-			acb->host->host_no);
+		"miscellaneous data' timeout\n",
+		acb->host->host_no);
 		return false;
 	}
 	count = 8;
 	while (count) {
-		*acb_firm_model = readb(iop_firm_model);
+		*acb_firm_model = ioread8(iop_firm_model);
 		acb_firm_model++;
 		iop_firm_model++;
 		count--;
@@ -2470,7 +3081,7 @@ arcmsr_hbaA_get_config(struct AdapterCon
 
 	count = 16;
 	while (count) {
-		*acb_firm_version = readb(iop_firm_version);
+		*acb_firm_version = ioread8(iop_firm_version);
 		acb_firm_version++;
 		iop_firm_version++;
 		count--;
@@ -2478,7 +3089,7 @@ arcmsr_hbaA_get_config(struct AdapterCon
 
 	count=16;
 	while (count) {
-		*acb_device_map = readb(iop_device_map);
+		*acb_device_map = ioread8(iop_device_map);
 		acb_device_map++;
 		iop_device_map++;
 		count--;
@@ -2488,12 +3099,12 @@ arcmsr_hbaA_get_config(struct AdapterCon
 		acb->host->host_no,
 		acb->firm_version,
 		acb->firm_model);
-	acb->signature = readl(&reg->message_rwbuffer[0]);
-	acb->firm_request_len = readl(&reg->message_rwbuffer[1]);
-	acb->firm_numbers_queue = readl(&reg->message_rwbuffer[2]);
-	acb->firm_sdram_size = readl(&reg->message_rwbuffer[3]);
-	acb->firm_hd_channels = readl(&reg->message_rwbuffer[4]);
-	acb->firm_cfg_version = readl(&reg->message_rwbuffer[25]);
+	acb->signature = ioread32(&reg->message_rwbuffer[0]);
+	acb->firm_request_len = ioread32(&reg->message_rwbuffer[1]);
+	acb->firm_numbers_queue = ioread32(&reg->message_rwbuffer[2]);
+	acb->firm_sdram_size = ioread32(&reg->message_rwbuffer[3]);
+	acb->firm_hd_channels = ioread32(&reg->message_rwbuffer[4]);
+	acb->firm_cfg_version = ioread32(&reg->message_rwbuffer[25]);
 	return true;
 }
 
@@ -2522,7 +3133,7 @@ arcmsr_hbaB_get_config(struct AdapterCon
 		" got error for hbb mu\n", acb->host->host_no);
 		return false;
 	}
-	acb->dma_coherent_handle_hbb_mu = dma_coherent_handle;
+	acb->dma_coherent_handle2 = dma_coherent_handle;
 	reg = (struct MessageUnit_B *)dma_coherent;
 	acb->pmuB = reg;
 	reg->drv2iop_doorbell = (uint32_t __iomem *)
@@ -2550,7 +3161,7 @@ arcmsr_hbaB_get_config(struct AdapterCon
 	iop_firm_version = (char __iomem *)(&reg->message_rwbuffer[17]);
 	iop_device_map = (char __iomem *)(&reg->message_rwbuffer[21]);
 
-	writel(ARCMSR_MESSAGE_GET_CONFIG, reg->drv2iop_doorbell);
+	iowrite32(ARCMSR_MESSAGE_GET_CONFIG, reg->drv2iop_doorbell);
 	if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
 		printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware"
 		"miscellaneous data' timeout \n", acb->host->host_no);
@@ -2558,14 +3169,14 @@ arcmsr_hbaB_get_config(struct AdapterCon
 	}
 	count = 8;
 	while (count) {
-		*acb_firm_model = readb(iop_firm_model);
+		*acb_firm_model = ioread8(iop_firm_model);
 		acb_firm_model++;
 		iop_firm_model++;
 		count--;
 	}
 	count = 16;
 	while (count) {
-		*acb_firm_version = readb(iop_firm_version);
+		*acb_firm_version = ioread8(iop_firm_version);
 		acb_firm_version++;
 		iop_firm_version++;
 		count--;
@@ -2573,7 +3184,7 @@ arcmsr_hbaB_get_config(struct AdapterCon
 
 	count = 16;
 	while (count) {
-		*acb_device_map = readb(iop_device_map);
+		*acb_device_map = ioread8(iop_device_map);
 		acb_device_map++;
 		iop_device_map++;
 		count--;
@@ -2585,17 +3196,17 @@ arcmsr_hbaB_get_config(struct AdapterCon
 		acb->firm_version,
 		acb->firm_model);
 
-	acb->signature = readl(&reg->message_rwbuffer[1]);
+	acb->signature = ioread32(&reg->message_rwbuffer[1]);
 	/*firm_signature,1,00-03*/
-	acb->firm_request_len = readl(&reg->message_rwbuffer[2]);
+	acb->firm_request_len = ioread32(&reg->message_rwbuffer[2]);
 	/*firm_request_len,1,04-07*/
-	acb->firm_numbers_queue = readl(&reg->message_rwbuffer[3]);
+	acb->firm_numbers_queue = ioread32(&reg->message_rwbuffer[3]);
 	/*firm_numbers_queue,2,08-11*/
-	acb->firm_sdram_size = readl(&reg->message_rwbuffer[4]);
+	acb->firm_sdram_size = ioread32(&reg->message_rwbuffer[4]);
 	/*firm_sdram_size,3,12-15*/
-	acb->firm_hd_channels = readl(&reg->message_rwbuffer[5]);
+	acb->firm_hd_channels = ioread32(&reg->message_rwbuffer[5]);
 	/*firm_ide_channels,4,16-19*/
-	acb->firm_cfg_version = readl(&reg->message_rwbuffer[25]);
+	acb->firm_cfg_version = ioread32(&reg->message_rwbuffer[25]);
 	/*firm_ide_channels,4,16-19*/
 	return true;
 }
@@ -2611,21 +3222,21 @@ arcmsr_hbaC_get_config(struct AdapterCon
 	char *iop_firm_version = (char *)(&reg->msgcode_rwbuffer[17]);
 	int count;
 	/* disable all outbound interrupt */
-	intmask_org = readl(&reg->host_int_mask);
-	writel(intmask_org | ARCMSR_HBCMU_ALL_INTMASKENABLE,
+	intmask_org = ioread32(&reg->host_int_mask);
+	iowrite32(intmask_org | ARCMSR_HBCMU_ALL_INTMASKENABLE,
 		&reg->host_int_mask);
 	do {
-		firmware_state = readl(&reg->outbound_msgaddr1);
+		firmware_state = ioread32(&reg->outbound_msgaddr1);
 	} while ((firmware_state & ARCMSR_HBCMU_MESSAGE_FIRMWARE_OK) == 0);
 	/* post "get config" instruction */
-	writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);
-	writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,
+	iowrite32(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);
+	iowrite32(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,
 		&reg->inbound_doorbell);
 	/* wait message ready */
 	for (Index = 0; Index < 2000; Index++) {
-		if (readl(&reg->outbound_doorbell) &
+		if (ioread32(&reg->outbound_doorbell) &
 		ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {
-		writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR,
+		iowrite32(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR,
 				&reg->outbound_doorbell_clear);
 			break;
 		}
@@ -2638,14 +3249,14 @@ arcmsr_hbaC_get_config(struct AdapterCon
 	}
 	count = 8;
 	while (count) {
-		*acb_firm_model = readb(iop_firm_model);
+		*acb_firm_model = ioread8(iop_firm_model);
 		acb_firm_model++;
 		iop_firm_model++;
 		count--;
 	}
 	count = 16;
 	while (count) {
-		*acb_firm_version = readb(iop_firm_version);
+		*acb_firm_version = ioread8(iop_firm_version);
 		acb_firm_version++;
 		iop_firm_version++;
 		count--;
@@ -2655,24 +3266,170 @@ arcmsr_hbaC_get_config(struct AdapterCon
 	pACB->host->host_no,
 	pACB->firm_version,
 	pACB->firm_model);
-	pACB->firm_request_len = readl(&reg->msgcode_rwbuffer[1]);
-	pACB->firm_numbers_queue = readl(&reg->msgcode_rwbuffer[2]);
-	pACB->firm_sdram_size = readl(&reg->msgcode_rwbuffer[3]);
-	pACB->firm_hd_channels = readl(&reg->msgcode_rwbuffer[4]);
-	pACB->firm_cfg_version = readl(&reg->msgcode_rwbuffer[25]);
+	pACB->firm_request_len = ioread32(&reg->msgcode_rwbuffer[1]);
+	pACB->firm_numbers_queue = ioread32(&reg->msgcode_rwbuffer[2]);
+	pACB->firm_sdram_size = ioread32(&reg->msgcode_rwbuffer[3]);
+	pACB->firm_hd_channels = ioread32(&reg->msgcode_rwbuffer[4]);
+	pACB->firm_cfg_version = ioread32(&reg->msgcode_rwbuffer[25]);
 	/*all interrupt service will be enable at arcmsr_iop_init*/
 	return true;
 }
 
 static bool
+arcmsr_hbaD_get_config(struct AdapterControlBlock *acb)
+{
+	char *acb_firm_model = acb->firm_model;
+	char *acb_firm_version = acb->firm_version;
+	char *acb_device_map = acb->device_map;
+	char __iomem *iop_firm_model;
+	char __iomem *iop_firm_version;
+	char __iomem *iop_device_map;
+ 	u32 count;
+	struct MessageUnit_D *reg ;
+	void *dma_coherent;
+	dma_addr_t dma_coherent_handle;
+	struct pci_dev *pdev = acb->pdev;
+
+	acb->uncache_size = roundup(sizeof(struct MessageUnit_D), 32);
+	dma_coherent = dma_alloc_coherent(&pdev->dev, acb->uncache_size,
+	&dma_coherent_handle, GFP_KERNEL);
+	if (!dma_coherent) {
+		printk(KERN_NOTICE "DMA allocation failed...\n");
+		return -ENOMEM;
+	}
+	memset(dma_coherent, 0, acb->uncache_size);
+	acb->dma_coherent = dma_coherent;
+	acb->dma_coherent_handle = dma_coherent_handle;
+	reg = (struct MessageUnit_D *)dma_coherent;
+	acb->pmuD = reg;
+	reg->chip_id = (u32 __iomem *)((unsigned long)
+	acb->mem_base0 + ARCMSR_ARC1214_CHIP_ID);
+	reg->cpu_mem_config = (u32 __iomem *)((unsigned long)
+	acb->mem_base0 + ARCMSR_ARC1214_CPU_MEMORY_CONFIGURATION);
+	reg->i2o_host_interrupt_mask = (u32 __iomem *)((unsigned long)
+	acb->mem_base0 + ARCMSR_ARC1214_I2_HOST_INTERRUPT_MASK);
+	reg->sample_at_reset = (u32 __iomem *)((unsigned long)
+	acb->mem_base0 + ARCMSR_ARC1214_SAMPLE_RESET);
+	reg->reset_request = (u32 __iomem *)((unsigned long)
+	acb->mem_base0 + ARCMSR_ARC1214_RESET_REQUEST);
+	reg->host_int_status = (u32 __iomem *)((unsigned long)
+	acb->mem_base0 + ARCMSR_ARC1214_MAIN_INTERRUPT_STATUS);
+	reg->pcief0_int_enable = (u32 __iomem *)((unsigned long)
+	acb->mem_base0 + ARCMSR_ARC1214_PCIE_F0_INTERRUPT_ENABLE);
+	reg->inbound_msgaddr0 = (u32 __iomem *)((unsigned long)
+	acb->mem_base0 + ARCMSR_ARC1214_INBOUND_MESSAGE0);
+	reg->inbound_msgaddr1 = (u32 __iomem *)((unsigned long)
+	acb->mem_base0 + ARCMSR_ARC1214_INBOUND_MESSAGE1);
+	reg->outbound_msgaddr0 = (u32 __iomem *)((unsigned long)
+	acb->mem_base0 + ARCMSR_ARC1214_OUTBOUND_MESSAGE0);
+	reg->outbound_msgaddr1 = (u32 __iomem *)((unsigned long)
+	acb->mem_base0 + ARCMSR_ARC1214_OUTBOUND_MESSAGE1);
+	reg->inbound_doorbell = (u32 __iomem *)((unsigned long)
+	acb->mem_base0 + ARCMSR_ARC1214_INBOUND_DOORBELL);
+	reg->outbound_doorbell = (u32 __iomem *)((unsigned long)
+	acb->mem_base0 + ARCMSR_ARC1214_OUTBOUND_DOORBELL);
+	reg->outbound_doorbell_enable = (u32 __iomem *)((unsigned long)
+	acb->mem_base0 + ARCMSR_ARC1214_OUTBOUND_DOORBELL_ENABLE);
+	reg->inboundlist_base_low = (u32 __iomem *)((unsigned long)
+	acb->mem_base0 + ARCMSR_ARC1214_INBOUND_LIST_BASE_LOW);
+	reg->inboundlist_base_high = (u32 __iomem *)((unsigned long)
+	acb->mem_base0 + ARCMSR_ARC1214_INBOUND_LIST_BASE_HIGH);
+	reg->inboundlist_write_pointer = (u32 __iomem *)((unsigned long)
+	acb->mem_base0 + ARCMSR_ARC1214_INBOUND_LIST_WRITE_POINTER);
+	reg->outboundlist_base_low = (u32 __iomem *)((unsigned long)
+	acb->mem_base0 + ARCMSR_ARC1214_OUTBOUND_LIST_BASE_LOW);
+	reg->outboundlist_base_high = (u32 __iomem *)((unsigned long)
+	acb->mem_base0 + ARCMSR_ARC1214_OUTBOUND_LIST_BASE_HIGH);
+	reg->outboundlist_copy_pointer = (u32 __iomem *)((unsigned long)
+	acb->mem_base0 + ARCMSR_ARC1214_OUTBOUND_LIST_COPY_POINTER);
+	reg->outboundlist_read_pointer = (u32 __iomem *)((unsigned long)
+	acb->mem_base0 + ARCMSR_ARC1214_OUTBOUND_LIST_READ_POINTER);
+	reg->outboundlist_interrupt_cause = (u32 __iomem *)((unsigned long)
+	acb->mem_base0 + ARCMSR_ARC1214_OUTBOUND_INTERRUPT_CAUSE);
+	reg->outboundlist_interrupt_enable = (u32 __iomem *)((unsigned long)
+	acb->mem_base0 + ARCMSR_ARC1214_OUTBOUND_INTERRUPT_ENABLE);
+	reg->message_wbuffer = (u32 __iomem *)((unsigned long)
+	acb->mem_base0 + ARCMSR_ARC1214_MESSAGE_WBUFFER);
+	reg->message_rbuffer = (u32 __iomem *)((unsigned long)
+	acb->mem_base0 + ARCMSR_ARC1214_MESSAGE_RBUFFER);
+	reg->msgcode_rwbuffer = (u32 __iomem *)((unsigned long)
+	acb->mem_base0 + ARCMSR_ARC1214_MESSAGE_RWBUFFER);
+	iop_firm_model = (char __iomem *)(&reg->msgcode_rwbuffer[15]);
+	iop_firm_version = (char __iomem *)(&reg->msgcode_rwbuffer[17]);
+	iop_device_map = (char __iomem *)(&reg->msgcode_rwbuffer[21]);
+	if (ioread32(acb->pmuD->outbound_doorbell) &
+	ARCMSR_ARC1214_IOP2DRV_MESSAGE_CMD_DONE) {
+		iowrite32(ARCMSR_ARC1214_IOP2DRV_MESSAGE_CMD_DONE,
+			acb->pmuD->outbound_doorbell);/*clear interrupt*/
+	}
+	/* post "get config" instruction */
+	iowrite32(ARCMSR_INBOUND_MESG0_GET_CONFIG, reg->inbound_msgaddr0);
+	/* wait message ready */
+	if (!arcmsr_hbaD_wait_msgint_ready(acb)) {
+		printk(KERN_NOTICE "arcmsr%d: wait get adapter firmware"
+		"miscellaneous data timeout\n", acb->host->host_no);
+		dma_free_coherent(&acb->pdev->dev, acb->uncache_size,
+			acb->dma_coherent, acb->dma_coherent_handle);
+		return false;
+	}
+	count = 8;
+	while (count) {
+		*acb_firm_model = ioread8(iop_firm_model);
+		acb_firm_model++;
+		iop_firm_model++;
+		count--;
+	}
+	count = 16;
+	while (count) {
+		*acb_firm_version = ioread8(iop_firm_version);
+		acb_firm_version++;
+		iop_firm_version++;
+		count--;
+	}
+	count = 16;
+	while (count) {
+		*acb_device_map = ioread8(iop_device_map);
+		acb_device_map++;
+		iop_device_map++;
+		count--;
+	}
+	acb->signature = ioread32(&reg->msgcode_rwbuffer[1]);
+	/*firm_signature,1,00-03*/
+	acb->firm_request_len = ioread32(&reg->msgcode_rwbuffer[2]);
+	/*firm_request_len,1,04-07*/
+	acb->firm_numbers_queue = ioread32(&reg->msgcode_rwbuffer[3]);
+	/*firm_numbers_queue,2,08-11*/
+	acb->firm_sdram_size = ioread32(&reg->msgcode_rwbuffer[4]);
+	/*firm_sdram_size,3,12-15*/
+	acb->firm_hd_channels = ioread32(&reg->msgcode_rwbuffer[5]);
+	/*firm_hd_channels,4,16-19*/
+	acb->firm_cfg_version = ioread32(&reg->msgcode_rwbuffer[25]);
+	printk("Areca RAID Controller%d: F/W %s & Model %s\n",
+	acb->host->host_no, acb->firm_version, acb->firm_model);
+	return true;
+}
+
+static bool
 arcmsr_get_firmware_spec(struct AdapterControlBlock *acb)
 {
-	if (acb->adapter_type == ACB_ADAPTER_TYPE_A)
-		return arcmsr_hbaA_get_config(acb);
-	else if (acb->adapter_type == ACB_ADAPTER_TYPE_B)
-		return arcmsr_hbaB_get_config(acb);
-	else
-		return arcmsr_hbaC_get_config(acb);
+	bool rtn = false;
+	switch (acb->adapter_type) {
+		case ACB_ADAPTER_TYPE_A:
+			rtn = arcmsr_hbaA_get_config(acb);
+			break;
+		case ACB_ADAPTER_TYPE_B:
+			rtn = arcmsr_hbaB_get_config(acb);
+			break;
+		case ACB_ADAPTER_TYPE_C:
+			rtn = arcmsr_hbaC_get_config(acb);
+			break;
+		case ACB_ADAPTER_TYPE_D:
+			rtn = arcmsr_hbaD_get_config(acb);
+			break;
+		default:
+			break;
+	}
+	return rtn;
 }
 
 static int
@@ -2688,11 +3445,11 @@ arcmsr_hbaA_polling_ccbdone(struct Adapt
 	bool error;
 	polling_hba_ccb_retry:
 	poll_count++;
-	outbound_intstatus = readl(&reg->outbound_intstatus) &
+	outbound_intstatus = ioread32(&reg->outbound_intstatus) &
 		acb->outbound_int_enable;
-	writel(outbound_intstatus, &reg->outbound_intstatus);
+	iowrite32(outbound_intstatus, &reg->outbound_intstatus);
 	while (1) {
-		if ((flag_ccb = readl(&reg->outbound_queueport)) ==
+		if ((flag_ccb = ioread32(&reg->outbound_queueport)) ==
 		0xFFFFFFFF) {
 			if (poll_ccb_done) {
 				rtn = SUCCESS;
@@ -2754,11 +3511,11 @@ arcmsr_hbaB_polling_ccbdone(struct Adapt
 
 	poll_count++;
 	/* clear doorbell interrupt */
-	writel(ARCMSR_DOORBELL_INT_CLEAR_PATTERN,
+	iowrite32(ARCMSR_DOORBELL_INT_CLEAR_PATTERN,
 	reg->iop2drv_doorbell);
 	while (1) {
 		index = reg->doneq_index;
-		if ((flag_ccb = readl(&reg->done_qbuffer[index])) == 0) {
+		if ((flag_ccb = ioread32(&reg->done_qbuffer[index])) == 0) {
 			if (poll_ccb_done) {
 				rtn = SUCCESS;
 				break;
@@ -2771,7 +3528,7 @@ arcmsr_hbaB_polling_ccbdone(struct Adapt
 				goto polling_hbb_ccb_retry;
 			}
 		}
-		writel(0, &reg->done_qbuffer[index]);
+		iowrite32(0, &reg->done_qbuffer[index]);
 		index++;
 		/*if last index number set it to 0 */
 		index %= ARCMSR_MAX_HBB_POSTQUEUE;
@@ -2827,7 +3584,7 @@ arcmsr_hbaC_polling_ccbdone(struct Adapt
 polling_hbc_ccb_retry:
 	poll_count++;
 	while (1) {
-		if ((readl(&reg->host_int_status) &
+		if ((ioread32(&reg->host_int_status) &
 			ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR) == 0) {
 			if (poll_ccb_done) {
 				rtn = SUCCESS;
@@ -2841,7 +3598,7 @@ polling_hbc_ccb_retry:
 				goto polling_hbc_ccb_retry;
 			}
 		}
-		flag_ccb = readl(&reg->outbound_queueport_low);
+		flag_ccb = ioread32(&reg->outbound_queueport_low);
 		ccb_cdb_phy = (flag_ccb & 0xFFFFFFF0);
 		arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset
 			+ ccb_cdb_phy);
@@ -2879,24 +3636,97 @@ polling_hbc_ccb_retry:
 }
 
 static int
+arcmsr_hbaD_polling_ccbdone(struct AdapterControlBlock *acb,
+				struct CommandControlBlock *poll_ccb)
+{
+	bool error;
+	uint32_t poll_ccb_done = 0, poll_count = 0, flag_ccb, ccb_cdb_phy;
+	int rtn, index, outbound_write_pointer;
+	struct ARCMSR_CDB *arcmsr_cdb;
+	struct CommandControlBlock *pCCB;
+	struct MessageUnit_D __iomem *reg =
+		(struct MessageUnit_D *)acb->pmuD;
+
+	polling_hbaD_ccb_retry:
+	poll_count++;
+	while (1) {
+		outbound_write_pointer =
+			ioread32(reg->outboundlist_copy_pointer);
+		index = reg->doneq_index;
+		if ((outbound_write_pointer & 0xFF) == index) {
+			if (poll_ccb_done) {
+				rtn = SUCCESS;
+				break;
+			} else {
+				msleep(25);
+				if (poll_count > 100) {
+					rtn = FAILED;
+					break;
+				}
+				goto polling_hbaD_ccb_retry;
+			}
+		}
+		flag_ccb = reg->done_qbuffer[index].addressLow;
+		ccb_cdb_phy = (flag_ccb & 0xFFFFFFF0);
+		arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset +
+			ccb_cdb_phy);
+		pCCB = container_of(arcmsr_cdb,
+			struct CommandControlBlock, arcmsr_cdb);
+		poll_ccb_done = (pCCB == poll_ccb) ? 1 : 0;
+		index++;
+		index %= ARCMSR_MAX_ARC1214_POSTQUEUE;
+		reg->doneq_index = index;
+		/* check if command done with no error*/
+		if ((pCCB->acb != acb) ||
+		(pCCB->startdone != ARCMSR_CCB_START)) {
+			if (pCCB->startdone == ARCMSR_CCB_ABORTED) {
+				printk(KERN_NOTICE "arcmsr%d: scsi id = %d"
+				" lun = %d ccb = '0x%p' poll command"
+				"abort successfully \n"
+				, acb->host->host_no
+				, pCCB->pcmd->device->id
+				, pCCB->pcmd->device->lun
+				, pCCB);
+				pCCB->pcmd->result = DID_ABORT << 16;
+				arcmsr_ccb_complete(pCCB);
+				continue;
+			}
+			printk(KERN_NOTICE "arcmsr%d: polling an illegal"
+			"ccb command done ccb = '0x%p'"
+			"ccboutstandingcount = %d \n"
+			, acb->host->host_no
+			, pCCB
+			, atomic_read(&acb->ccboutstandingcount));
+			continue;
+		}
+		error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1)
+		? true : false;
+		arcmsr_report_ccb_state(acb, pCCB, error);
+	}
+	return rtn;
+}
+
+static int
 arcmsr_polling_ccbdone(struct AdapterControlBlock *acb,
-					struct CommandControlBlock *poll_ccb)
+				struct CommandControlBlock *poll_ccb)
 {
 	int rtn = 0;
 	switch (acb->adapter_type) {
-
-	case ACB_ADAPTER_TYPE_A: {
+	case ACB_ADAPTER_TYPE_A:{
 		rtn = arcmsr_hbaA_polling_ccbdone(acb, poll_ccb);
-		}
 		break;
-
-	case ACB_ADAPTER_TYPE_B: {
+	}
+	case ACB_ADAPTER_TYPE_B:{
 		rtn = arcmsr_hbaB_polling_ccbdone(acb, poll_ccb);
-		}
 		break;
+	}
 	case ACB_ADAPTER_TYPE_C: {
 		rtn = arcmsr_hbaC_polling_ccbdone(acb, poll_ccb);
-		}
+		break;
+	}
+	case ACB_ADAPTER_TYPE_D: {
+		rtn = arcmsr_hbaD_polling_ccbdone(acb, poll_ccb);
+	}
 	}
 	return rtn;
 }
@@ -2904,7 +3734,7 @@ arcmsr_polling_ccbdone(struct AdapterCon
 static int
 arcmsr_iop_confirm(struct AdapterControlBlock *acb)
 {
-	uint32_t cdb_phyaddr, cdb_phyaddr_hi32;
+	uint32_t cdb_phyaddr, cdb_phyaddr_hi32, cdb_phyaddr_lo32;
 	dma_addr_t dma_coherent_handle;
 	/*
 	********************************************************************
@@ -2913,7 +3743,7 @@ arcmsr_iop_confirm(struct AdapterControl
 	********************************************************************
 	*/
 	dma_coherent_handle = acb->dma_coherent_handle;
-	cdb_phyaddr = (uint32_t)(dma_coherent_handle);
+	cdb_phyaddr_lo32 = (uint32_t)(dma_coherent_handle & 0xffffffff);
 	cdb_phyaddr_hi32 = (uint32_t)((cdb_phyaddr >> 16) >> 16);
 	acb->cdb_phyaddr_hi32 = cdb_phyaddr_hi32;
 	/*
@@ -2926,12 +3756,10 @@ arcmsr_iop_confirm(struct AdapterControl
 	case ACB_ADAPTER_TYPE_A: {
 		if (cdb_phyaddr_hi32 != 0) {
 			struct MessageUnit_A __iomem *reg = acb->pmuA;
-			uint32_t intmask_org;
-			intmask_org = arcmsr_disable_outbound_ints(acb);
-			writel(ARCMSR_SIGNATURE_SET_CONFIG,
+			iowrite32(ARCMSR_SIGNATURE_SET_CONFIG,
 			&reg->message_rwbuffer[0]);
-			writel(cdb_phyaddr_hi32, &reg->message_rwbuffer[1]);
-			writel(ARCMSR_INBOUND_MESG0_SET_CONFIG,
+			iowrite32(cdb_phyaddr_hi32, &reg->message_rwbuffer[1]);
+			iowrite32(ARCMSR_INBOUND_MESG0_SET_CONFIG,
 			&reg->inbound_msgaddr0);
 			if (!arcmsr_hbaA_wait_msgint_ready(acb)) {
 				printk(KERN_NOTICE "arcmsr%d: set ccb"
@@ -2939,7 +3767,6 @@ arcmsr_iop_confirm(struct AdapterControl
 				acb->host->host_no);
 				return 1;
 			}
-			arcmsr_enable_outbound_ints(acb, intmask_org);
 		}
 		}
 		break;
@@ -2949,11 +3776,9 @@ arcmsr_iop_confirm(struct AdapterControl
 		uint32_t __iomem *rwbuffer;
 
 		struct MessageUnit_B *reg = acb->pmuB;
-		uint32_t intmask_org;
-		intmask_org = arcmsr_disable_outbound_ints(acb);
 		reg->postq_index = 0;
 		reg->doneq_index = 0;
-		writel(ARCMSR_MESSAGE_SET_POST_WINDOW,
+		iowrite32(ARCMSR_MESSAGE_SET_POST_WINDOW,
 		reg->drv2iop_doorbell);
 		if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
 			printk(KERN_NOTICE
@@ -2961,19 +3786,19 @@ arcmsr_iop_confirm(struct AdapterControl
 			acb->host->host_no);
 			return 1;
 		}
-		post_queue_phyaddr = acb->dma_coherent_handle_hbb_mu;
+		post_queue_phyaddr = acb->dma_coherent_handle2;
 		rwbuffer = reg->message_rwbuffer;
 		/* driver "set config" signature */
-		writel(ARCMSR_SIGNATURE_SET_CONFIG, rwbuffer++);
+		iowrite32(ARCMSR_SIGNATURE_SET_CONFIG, rwbuffer++);
 		/* normal should be zero */
-		writel(cdb_phyaddr_hi32, rwbuffer++);
+		iowrite32(cdb_phyaddr_hi32, rwbuffer++);
 		/* postQ size (256 + 8)*4	 */
-		writel(post_queue_phyaddr, rwbuffer++);
+		iowrite32(post_queue_phyaddr, rwbuffer++);
 		/* doneQ size (256 + 8)*4	 */
-		writel(post_queue_phyaddr + 1056, rwbuffer++);
+		iowrite32(post_queue_phyaddr + 1056, rwbuffer++);
 		/* ccb maxQ size must be --> [(256 + 8)*4]*/
-		writel(1056, rwbuffer);
-		writel(ARCMSR_MESSAGE_SET_CONFIG, reg->drv2iop_doorbell);
+		iowrite32(1056, rwbuffer);
+		iowrite32(ARCMSR_MESSAGE_SET_CONFIG, reg->drv2iop_doorbell);
 		if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
 			printk(KERN_NOTICE
 			"arcmsr%d: 'set command Q window'"
@@ -2981,7 +3806,6 @@ arcmsr_iop_confirm(struct AdapterControl
 			return 1;
 		}
 		arcmsr_hbb_enable_driver_mode(acb);
-		arcmsr_enable_outbound_ints(acb, intmask_org);
 		}
 		break;
 	case ACB_ADAPTER_TYPE_C: {
@@ -2991,13 +3815,13 @@ arcmsr_iop_confirm(struct AdapterControl
 			printk(KERN_NOTICE
 			"arcmsr%d: cdb_phyaddr_hi32 = 0x%x\n",
 			acb->adapter_index, cdb_phyaddr_hi32);
-			writel(ARCMSR_SIGNATURE_SET_CONFIG,
+			iowrite32(ARCMSR_SIGNATURE_SET_CONFIG,
 				&reg->msgcode_rwbuffer[0]);
-			writel(cdb_phyaddr_hi32,
+			iowrite32(cdb_phyaddr_hi32,
 				&reg->msgcode_rwbuffer[1]);
-			writel(ARCMSR_INBOUND_MESG0_SET_CONFIG,
+			iowrite32(ARCMSR_INBOUND_MESG0_SET_CONFIG,
 				&reg->inbound_msgaddr0);
-			writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,
+			iowrite32(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,
 				&reg->inbound_doorbell);
 			if (!arcmsr_hbaC_wait_msgint_ready(acb)) {
 				printk(KERN_NOTICE "arcmsr%d: 'set"
@@ -3007,6 +3831,29 @@ arcmsr_iop_confirm(struct AdapterControl
 			}
 		}
 		}
+		break;
+	case ACB_ADAPTER_TYPE_D: {
+		uint32_t __iomem *rwbuffer;
+
+		struct MessageUnit_D *reg =
+			(struct MessageUnit_D *)acb->pmuD;
+		reg->postq_index = 0;
+		reg->doneq_index = 0x40FF;
+		rwbuffer = reg->msgcode_rwbuffer;
+		iowrite32(ARCMSR_SIGNATURE_SET_CONFIG, rwbuffer++);
+		iowrite32(cdb_phyaddr_hi32, rwbuffer++);
+		iowrite32(cdb_phyaddr_lo32, rwbuffer++);
+		iowrite32(cdb_phyaddr_lo32 +
+		(ARCMSR_MAX_ARC1214_POSTQUEUE * sizeof(struct InBound_SRB)),
+		rwbuffer++);
+		iowrite32(0x100, rwbuffer);
+		iowrite32(ARCMSR_INBOUND_MESG0_SET_CONFIG,
+			reg->inbound_msgaddr0);
+		if (!arcmsr_hbaD_wait_msgint_ready(acb))
+			printk(KERN_NOTICE "arcmsr%d: 'set command Q"
+			"window' timeout \n", acb->host->host_no);
+		break;
+	}
 	}
 	return 0;
 }
@@ -3020,7 +3867,7 @@ arcmsr_wait_firmware_ready(struct Adapte
 	case ACB_ADAPTER_TYPE_A: {
 		struct MessageUnit_A __iomem *reg = acb->pmuA;
 		do {
-			firmware_state = readl(&reg->outbound_msgaddr1);
+			firmware_state = ioread32(&reg->outbound_msgaddr1);
 		} while ((firmware_state &
 		ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK) == 0);
 		}
@@ -3028,19 +3875,30 @@ arcmsr_wait_firmware_ready(struct Adapte
 	case ACB_ADAPTER_TYPE_B: {
 		struct MessageUnit_B *reg = acb->pmuB;
 		do {
-			firmware_state = readl(reg->iop2drv_doorbell);
+			firmware_state = ioread32(reg->iop2drv_doorbell);
 		} while ((firmware_state & ARCMSR_MESSAGE_FIRMWARE_OK) == 0);
-		writel(ARCMSR_DRV2IOP_END_OF_INTERRUPT,
+		iowrite32(ARCMSR_DRV2IOP_END_OF_INTERRUPT,
 		reg->drv2iop_doorbell);
 		}
 		break;
 	case ACB_ADAPTER_TYPE_C: {
-		struct MessageUnit_C *reg = (struct MessageUnit_C *)acb->pmuC;
+		struct MessageUnit_C *reg =
+			(struct MessageUnit_C *)acb->pmuC;
 		do {
-			firmware_state = readl(&reg->outbound_msgaddr1);
+			firmware_state = ioread32(&reg->outbound_msgaddr1);
 		} while ((firmware_state &
 		ARCMSR_HBCMU_MESSAGE_FIRMWARE_OK) == 0);
 		}
+		break;
+	case ACB_ADAPTER_TYPE_D: {
+		struct MessageUnit_D __iomem *reg
+			= (struct MessageUnit_D *)acb->pmuD;
+		do {
+			firmware_state = ioread32(reg->outbound_msgaddr1);
+		} while ((firmware_state &
+		ARCMSR_ARC1214_MESSAGE_FIRMWARE_OK) == 0);
+		break;
+	}
 	}
 }
 
@@ -3067,7 +3925,7 @@ arcmsr_hbaA_request_device_map(struct Ad
 				jiffies + msecs_to_jiffies(6 * HZ));
 			return;
 		}
-		writel(ARCMSR_INBOUND_MESG0_GET_CONFIG,
+		iowrite32(ARCMSR_INBOUND_MESG0_GET_CONFIG,
 			&reg->inbound_msgaddr0);
 		mod_timer(&acb->eternal_timer, jiffies +
 			msecs_to_jiffies(6 * HZ));
@@ -3098,7 +3956,7 @@ arcmsr_hbaB_request_device_map(struct Ad
 				jiffies + msecs_to_jiffies(6 * HZ));
 			return;
 		}
-		writel(ARCMSR_MESSAGE_GET_CONFIG,
+		iowrite32(ARCMSR_MESSAGE_GET_CONFIG,
 			reg->drv2iop_doorbell);
 		mod_timer(&acb->eternal_timer, jiffies +
 			msecs_to_jiffies(6 * HZ));
@@ -3129,9 +3987,9 @@ arcmsr_hbaC_request_device_map(struct Ad
 				jiffies + msecs_to_jiffies(6 * HZ));
 			return;
 		}
-		writel(ARCMSR_INBOUND_MESG0_GET_CONFIG,
+		iowrite32(ARCMSR_INBOUND_MESG0_GET_CONFIG,
 			&reg->inbound_msgaddr0);
-		writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,
+		iowrite32(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,
 			&reg->inbound_doorbell);
 		mod_timer(&acb->eternal_timer, jiffies +
 			msecs_to_jiffies(6 * HZ));
@@ -3140,22 +3998,55 @@ arcmsr_hbaC_request_device_map(struct Ad
 }
 
 static void
+arcmsr_hbaD_request_device_map(struct AdapterControlBlock *acb)
+{
+	struct MessageUnit_D __iomem *reg = acb->pmuD;
+	if (unlikely(atomic_read(&acb->rq_map_token) == 0) ||
+		((acb->acb_flags & ACB_F_BUS_RESET) != 0) ||
+		((acb->acb_flags & ACB_F_ABORT) != 0)) {
+		mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));
+	} else {
+		acb->fw_flag = FW_NORMAL;
+		if (atomic_read(&acb->ante_token_value) ==
+			atomic_read(&acb->rq_map_token)) {
+			atomic_set(&acb->rq_map_token, 16);
+		}
+		atomic_set(&acb->ante_token_value,
+			atomic_read(&acb->rq_map_token));
+		if (atomic_dec_and_test(&acb->rq_map_token)) {
+			mod_timer(&acb->eternal_timer, jiffies +
+				msecs_to_jiffies(6 * HZ));
+			return;
+		}
+		iowrite32(ARCMSR_INBOUND_MESG0_GET_CONFIG,
+			reg->inbound_msgaddr0);
+		mod_timer(&acb->eternal_timer, jiffies +
+			msecs_to_jiffies(6 * HZ));
+	}
+	return;
+}
+
+static void
 arcmsr_request_device_map(unsigned long pacb)
 {
 	struct AdapterControlBlock *acb =
 		(struct AdapterControlBlock *)pacb;
 	switch (acb->adapter_type) {
-	case ACB_ADAPTER_TYPE_A: {
-		arcmsr_hbaA_request_device_map(acb);
-	}
-	break;
-	case ACB_ADAPTER_TYPE_B: {
-		arcmsr_hbaB_request_device_map(acb);
-	}
-	break;
-	case ACB_ADAPTER_TYPE_C: {
-		arcmsr_hbaC_request_device_map(acb);
-	}
+		case ACB_ADAPTER_TYPE_A: {
+			arcmsr_hbaA_request_device_map(acb);
+			break;
+		}
+		case ACB_ADAPTER_TYPE_B: {
+			arcmsr_hbaB_request_device_map(acb);
+			break;
+		}
+		case ACB_ADAPTER_TYPE_C: {
+			arcmsr_hbaC_request_device_map(acb);
+			break;
+		}
+		case ACB_ADAPTER_TYPE_D: {
+			arcmsr_hbaD_request_device_map(acb);
+		}
 	}
 }
 
@@ -3164,7 +4055,7 @@ arcmsr_hbaA_start_bgrb(struct AdapterCon
 {
 	struct MessageUnit_A __iomem *reg = acb->pmuA;
 	acb->acb_flags |= ACB_F_MSG_START_BGRB;
-	writel(ARCMSR_INBOUND_MESG0_START_BGRB,
+	iowrite32(ARCMSR_INBOUND_MESG0_START_BGRB,
 		&reg->inbound_msgaddr0);
 	if (!arcmsr_hbaA_wait_msgint_ready(acb)) {
 		printk(KERN_NOTICE "arcmsr%d: wait 'start adapter"
@@ -3177,7 +4068,7 @@ arcmsr_hbaB_start_bgrb(struct AdapterCon
 {
 	struct MessageUnit_B *reg = acb->pmuB;
 	acb->acb_flags |= ACB_F_MSG_START_BGRB;
-	writel(ARCMSR_MESSAGE_START_BGRB, reg->drv2iop_doorbell);
+	iowrite32(ARCMSR_MESSAGE_START_BGRB, reg->drv2iop_doorbell);
 	if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
 		printk(KERN_NOTICE "arcmsr%d: wait 'start adapter"
 		"backgroundrebulid' timeout \n", acb->host->host_no);
@@ -3190,9 +4081,9 @@ arcmsr_hbaC_start_bgrb(struct AdapterCon
 	struct MessageUnit_C *phbcmu =
 		(struct MessageUnit_C *)pACB->pmuC;
 	pACB->acb_flags |= ACB_F_MSG_START_BGRB;
-	writel(ARCMSR_INBOUND_MESG0_START_BGRB,
+	iowrite32(ARCMSR_INBOUND_MESG0_START_BGRB,
 		&phbcmu->inbound_msgaddr0);
-	writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,
+	iowrite32(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,
 		&phbcmu->inbound_doorbell);
 	if (!arcmsr_hbaC_wait_msgint_ready(pACB)) {
 		printk(KERN_NOTICE "arcmsr%d: wait 'start adapter"
@@ -3202,6 +4093,19 @@ arcmsr_hbaC_start_bgrb(struct AdapterCon
 }
 
 static void
+arcmsr_hbaD_start_bgrb(struct AdapterControlBlock *pACB)
+{
+	struct MessageUnit_D __iomem *pmu = (struct MessageUnit_D *)pACB->pmuD;
+	pACB->acb_flags |= ACB_F_MSG_START_BGRB;
+	iowrite32(ARCMSR_INBOUND_MESG0_START_BGRB, pmu->inbound_msgaddr0);
+	if (!arcmsr_hbaD_wait_msgint_ready(pACB)) {
+		printk(KERN_NOTICE "arcmsr%d: wait 'start adapter"
+		" background rebulid' timeout \n", pACB->host->host_no);
+	}
+	return;
+}
+
+static void
 arcmsr_start_adapter_bgrb(struct AdapterControlBlock *acb)
 {
 	switch (acb->adapter_type) {
@@ -3213,6 +4117,10 @@ arcmsr_start_adapter_bgrb(struct Adapter
 		break;
 	case ACB_ADAPTER_TYPE_C:
 		arcmsr_hbaC_start_bgrb(acb);
+		break;
+	case ACB_ADAPTER_TYPE_D:
+		arcmsr_hbaD_start_bgrb(acb);
+		break;
 	}
 }
 
@@ -3224,10 +4132,10 @@ arcmsr_clear_doorbell_queue_buffer(struc
 		struct MessageUnit_A __iomem *reg = acb->pmuA;
 		uint32_t outbound_doorbell;
 		/* empty doorbell Qbuffer if door bell ringed */
-		outbound_doorbell = readl(&reg->outbound_doorbell);
+		outbound_doorbell = ioread32(&reg->outbound_doorbell);
 		/*clear doorbell interrupt */
-		writel(outbound_doorbell, &reg->outbound_doorbell);
-		writel(ARCMSR_INBOUND_DRIVER_DATA_READ_OK,
+		iowrite32(outbound_doorbell, &reg->outbound_doorbell);
+		iowrite32(ARCMSR_INBOUND_DRIVER_DATA_READ_OK,
 			&reg->inbound_doorbell);
 		}
 		break;
@@ -3235,9 +4143,9 @@ arcmsr_clear_doorbell_queue_buffer(struc
 	case ACB_ADAPTER_TYPE_B: {
 		struct MessageUnit_B *reg = acb->pmuB;
 		/*clear interrupt and message state*/
-		writel(ARCMSR_MESSAGE_INT_CLEAR_PATTERN,
+		iowrite32(ARCMSR_MESSAGE_INT_CLEAR_PATTERN,
 		reg->iop2drv_doorbell);
-		writel(ARCMSR_DRV2IOP_DATA_READ_OK,
+		iowrite32(ARCMSR_DRV2IOP_DATA_READ_OK,
 			reg->drv2iop_doorbell);
 		/* let IOP know data has been read */
 		}
@@ -3247,11 +4155,25 @@ arcmsr_clear_doorbell_queue_buffer(struc
 			(struct MessageUnit_C *)acb->pmuC;
 		uint32_t outbound_doorbell;
 		/* empty doorbell Qbuffer if door bell ringed */
-		outbound_doorbell = readl(&reg->outbound_doorbell);
-		writel(outbound_doorbell, &reg->outbound_doorbell_clear);
-		writel(ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK,
+		outbound_doorbell = ioread32(&reg->outbound_doorbell);
+		iowrite32(outbound_doorbell, &reg->outbound_doorbell_clear);
+		iowrite32(ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK,
 			&reg->inbound_doorbell);
+		ioread32(&reg->outbound_doorbell_clear);
+		ioread32(&reg->inbound_doorbell);
 		}
+		break;
+	case ACB_ADAPTER_TYPE_D: {
+		struct MessageUnit_D __iomem *reg =
+			(struct MessageUnit_D *)acb->pmuD;
+		uint32_t outbound_doorbell;
+		/* empty doorbell Qbuffer if door bell ringed */
+		outbound_doorbell = ioread32(reg->outbound_doorbell);
+		iowrite32(outbound_doorbell, reg->outbound_doorbell);
+		iowrite32(ARCMSR_ARC1214_DRV2IOP_DATA_OUT_READ,
+			reg->inbound_doorbell);
+		break;
+	}
 	}
 }
 
@@ -3260,21 +4182,20 @@ arcmsr_enable_eoi_mode(struct AdapterCon
 {
 	switch (acb->adapter_type) {
 	case ACB_ADAPTER_TYPE_A:
+	case ACB_ADAPTER_TYPE_C:	
+	case ACB_ADAPTER_TYPE_D:
 		return;
-	case ACB_ADAPTER_TYPE_B:
-		{
-			struct MessageUnit_B *reg = acb->pmuB;
-			writel(ARCMSR_MESSAGE_ACTIVE_EOI_MODE,
-			reg->drv2iop_doorbell);
+	case ACB_ADAPTER_TYPE_B: {
+	        	struct MessageUnit_B *reg = acb->pmuB;
+			iowrite32(ARCMSR_MESSAGE_ACTIVE_EOI_MODE,
+				reg->drv2iop_doorbell);
 			if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
 				printk(KERN_NOTICE "ARCMSR IOP"
-				" enables EOI_MODE TIMEOUT");
+				"enables EOI_MODE TIMEOUT");
 				return;
 			}
-		}
-		break;
-	case ACB_ADAPTER_TYPE_C:
-		return;
+	}
+	break;
 	}
 	return;
 }
@@ -3295,21 +4216,21 @@ arcmsr_hardware_reset(struct AdapterCont
 	}
 	/* hardware reset signal */
 	if ((acb->dev_id == 0x1680)) {
-		writel(ARCMSR_ARC1680_BUS_RESET,
+		iowrite32(ARCMSR_ARC1680_BUS_RESET,
 			&pmuA->reserved1[0]);
 	} else if ((acb->dev_id == 0x1880)) {
 		do {
 			count++;
-			writel(0xF, &pmuC->write_sequence);
-			writel(0x4, &pmuC->write_sequence);
-			writel(0xB, &pmuC->write_sequence);
-			writel(0x2, &pmuC->write_sequence);
-			writel(0x7, &pmuC->write_sequence);
-			writel(0xD, &pmuC->write_sequence);
-		} while ((((temp = readl(&pmuC->host_diagnostic)) |
+			iowrite32(0xF, &pmuC->write_sequence);
+			iowrite32(0x4, &pmuC->write_sequence);
+			iowrite32(0xB, &pmuC->write_sequence);
+			iowrite32(0x2, &pmuC->write_sequence);
+			iowrite32(0x7, &pmuC->write_sequence);
+			iowrite32(0xD, &pmuC->write_sequence);
+		} while ((((temp = ioread32(&pmuC->host_diagnostic)) |
 		ARCMSR_ARC1880_DiagWrite_ENABLE) == 0) &&
 		(count < 5));
-		writel(ARCMSR_ARC1880_RESET_ADAPTER,
+		iowrite32(ARCMSR_ARC1880_RESET_ADAPTER,
 			&pmuC->host_diagnostic);
 	} else {
 		pci_write_config_byte(acb->pdev, 0x84, 0x20);
@@ -3410,7 +4331,7 @@ arcmsr_bus_reset(struct scsi_cmnd *cmd)
 			acb->acb_flags &= ~ACB_F_IOP_INITED;
 sleep_again:
 			ssleep(ARCMSR_SLEEPTIME);
-			if ((readl(&reg->outbound_msgaddr1) &
+			if ((ioread32(&reg->outbound_msgaddr1) &
 			ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK) == 0) {
 				printk(KERN_ERR "arcmsr%d: waiting for"
 				" hw bus reset return, retry=%d\n",
@@ -3432,9 +4353,9 @@ sleep_again:
 			arcmsr_get_firmware_spec(acb);
 			arcmsr_start_adapter_bgrb(acb);
 			/* clear Qbuffer if door bell ringed */
-			outbound_doorbell = readl(&reg->outbound_doorbell);
-			writel(outbound_doorbell, &reg->outbound_doorbell);
-			writel(ARCMSR_INBOUND_DRIVER_DATA_READ_OK,
+			outbound_doorbell = ioread32(&reg->outbound_doorbell);
+			iowrite32(outbound_doorbell, &reg->outbound_doorbell);
+			iowrite32(ARCMSR_INBOUND_DRIVER_DATA_READ_OK,
 				&reg->inbound_doorbell);
 			arcmsr_enable_outbound_ints(acb, intmask_org);
 			atomic_set(&acb->rq_map_token, 16);
@@ -3493,7 +4414,7 @@ sleep_again:
 			acb->acb_flags &= ~ACB_F_IOP_INITED;
 sleep:
 			ssleep(ARCMSR_SLEEPTIME);
-			if ((readl(&reg->host_diagnostic) & 0x04) != 0) {
+			if ((ioread32(&reg->host_diagnostic) & 0x04) != 0) {
 				printk(KERN_ERR "arcmsr%d: waiting"
 				" for hw bus reset return, retry = %d\n",
 				acb->host->host_no, retry_count);
@@ -3516,10 +4437,10 @@ sleep:
 			arcmsr_start_adapter_bgrb(acb);
 			/* clear Qbuffer if door bell ringed */
 			outbound_doorbell =
-			readl(&reg->outbound_doorbell);
-			writel(outbound_doorbell,
+			ioread32(&reg->outbound_doorbell);
+			iowrite32(outbound_doorbell,
 				&reg->outbound_doorbell_clear);
-			writel(ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK,
+			iowrite32(ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK,
 				&reg->inbound_doorbell);
 			arcmsr_enable_outbound_ints(acb,
 				intmask_org);
@@ -3543,6 +4464,65 @@ sleep:
 		}
 		break;
 	}
+	case ACB_ADAPTER_TYPE_D: {
+		if (acb->acb_flags & ACB_F_BUS_RESET) {
+			long timeout;
+			printk(KERN_NOTICE "arcmsr: there is an bus reset eh proceeding.......\n");
+			timeout = wait_event_timeout(wait_q, (acb->acb_flags & ACB_F_BUS_RESET) == 0, 220 * HZ);
+			if (timeout) {
+				return SUCCESS;
+			}
+		}
+		acb->acb_flags |= ACB_F_BUS_RESET;
+		if (!arcmsr_iop_reset(acb)) {
+			struct MessageUnit_D __iomem *reg;
+			reg = acb->pmuD;
+			arcmsr_hardware_reset(acb);
+			acb->acb_flags &= ~ACB_F_IOP_INITED;
+			nap:
+			ssleep(ARCMSR_SLEEPTIME);
+			if ((ioread32(reg->sample_at_reset) & 0x80) != 0) {
+					printk(KERN_ERR "arcmsr%d: waiting for"
+					" hw bus reset return, retry=%d\n",
+					acb->host->host_no, retry_count);
+					if (retry_count > ARCMSR_RETRYCOUNT) {
+					acb->fw_flag = FW_DEADLOCK;
+					printk(KERN_ERR "arcmsr%d:"
+					"waiting for hw bus reset return,"
+					"RETRY TERMINATED!!\n",
+					acb->host->host_no);
+					return FAILED;
+				}
+				retry_count++;
+				goto nap;
+			}
+			acb->acb_flags |= ACB_F_IOP_INITED;
+			/* disable all outbound interrupt */
+			intmask_org = arcmsr_disable_outbound_ints(acb);
+			arcmsr_get_firmware_spec(acb);
+			arcmsr_start_adapter_bgrb(acb);
+			arcmsr_clear_doorbell_queue_buffer(acb);
+			arcmsr_enable_outbound_ints(acb, intmask_org);
+			atomic_set(&acb->rq_map_token, 16);
+			atomic_set(&acb->ante_token_value, 16);					
+			acb->fw_flag = FW_NORMAL;
+			mod_timer(&acb->eternal_timer,
+				jiffies + msecs_to_jiffies(6 * HZ));
+			acb->acb_flags &= ~ACB_F_BUS_RESET;
+			rtn = SUCCESS;					
+			printk(KERN_ERR "arcmsr: scsi bus reset"
+			"eh returns with success\n");
+		} else {
+			acb->acb_flags &= ~ACB_F_BUS_RESET;
+			atomic_set(&acb->rq_map_token, 16);
+			atomic_set(&acb->ante_token_value, 16);
+			acb->fw_flag = FW_NORMAL;
+			mod_timer(&acb->eternal_timer,
+				jiffies + msecs_to_jiffies(6 * HZ));
+			rtn = SUCCESS;
+		}
+		break;
+	}
 	}
 	return rtn;
 }
@@ -3619,8 +4599,7 @@ static const char
 	case PCI_DEVICE_ID_ARECA_1280:
 		type = "SATA";
 		break;
-	case PCI_DEVICE_ID_ARECA_1380:
-	case PCI_DEVICE_ID_ARECA_1381:
+	case PCI_DEVICE_ID_ARECA_1214:
 	case PCI_DEVICE_ID_ARECA_1680:
 	case PCI_DEVICE_ID_ARECA_1681:
 	case PCI_DEVICE_ID_ARECA_1880:
