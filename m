From: "NickCheng" <nick.cheng@areca.com.tw>
Subject: [PATCH 4/5]  arcmsr: Support a New RAID Model, ARC-1214
Date: Wed, 6 Feb 2013 16:37:34 +0800
Message-ID: <81A6DEDED8A040A2B4F5FBF03EDE7908@arecaaebe11fae>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0009_01CE0488.4DC0D6F0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ia0-f170.google.com ([209.85.210.170]:44039 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300Ab3BFIid (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Feb 2013 03:38:33 -0500
Received: by mail-ia0-f170.google.com with SMTP id k20so1275594iak.1
        for <linux-scsi@vger.kernel.org>; Wed, 06 Feb 2013 00:38:32 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, jejb@kernel.org, =?big5?B?tsCyTbap?= <ching2048@areca.com.tw>

This is a multi-part message in MIME format.

------=_NextPart_000_0009_01CE0488.4DC0D6F0
Content-Type: text/plain;
	charset="big5"
Content-Transfer-Encoding: 7bit

From: Nick Cheng <nick.cheng@areca.com.tw>

Add a New RAID Model, ARC-1214, which can support 8 SATA HDs at most, so far.
Signed-off-by: Nick Cheng <nick.cheng@areca.com.tw>
---

------=_NextPart_000_0009_01CE0488.4DC0D6F0
Content-Type: application/octet-stream;
	name="patch4"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="patch4"

diff -uprN a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h=0A=
--- a/drivers/scsi/arcmsr/arcmsr.h	2013-02-06 16:28:44.388445464 +0800=0A=
+++ b/drivers/scsi/arcmsr/arcmsr.h	2013-02-06 16:28:53.393656719 +0800=0A=
@@ -62,12 +62,16 @@ struct device_attribute;=0A=
 #define ARCMSR_MAX_QBUFFER			4096=0A=
 #define ARCMSR_DEFAULT_SG_ENTRIES		38=0A=
 #define ARCMSR_MAX_HBB_POSTQUEUE		264=0A=
+#define ARCMSR_MAX_ARC1214_POSTQUEUE		256=0A=
 #define ARCMSR_MAX_XFER_LEN			0x26000=0A=
 #define ARCMSR_CDB_SG_PAGE_LENGTH		256=0A=
 #define ARCMST_NUM_MSIX_VECTORS		4=0A=
 #ifndef PCI_DEVICE_ID_ARECA_1880=0A=
 	#define PCI_DEVICE_ID_ARECA_1880	0x1880=0A=
- #endif=0A=
+#endif=0A=
+#ifndef PCI_DEVICE_ID_ARECA_1214=0A=
+	#define PCI_DEVICE_ID_ARECA_1214	0x1214=0A=
+#endif=0A=
 /*=0A=
 =
*************************************************************************=
*********=0A=
 **=0A=
@@ -341,6 +345,56 @@ struct FIRMWARE_INFO=0A=
 #define ARCMSR_HBCMU_MESSAGE_FIRMWARE_OK			0x80000000=0A=
 /*=0A=
 =
*************************************************************************=
******=0A=
+**                SPEC. for Areca Type D adapter=0A=
+************************************************************************=
*******=0A=
+*/=0A=
+#define ARCMSR_ARC1214_CHIP_ID					0x00004=0A=
+#define ARCMSR_ARC1214_CPU_MEMORY_CONFIGURATION		0x00008=0A=
+#define ARCMSR_ARC1214_I2_HOST_INTERRUPT_MASK		0x00034=0A=
+#define ARCMSR_ARC1214_SAMPLE_RESET				0x00100=0A=
+#define ARCMSR_ARC1214_RESET_REQUEST				0x00108=0A=
+#define ARCMSR_ARC1214_MAIN_INTERRUPT_STATUS			0x00200=0A=
+#define ARCMSR_ARC1214_PCIE_F0_INTERRUPT_ENABLE		0x0020C=0A=
+#define ARCMSR_ARC1214_INBOUND_MESSAGE0			0x00400=0A=
+#define ARCMSR_ARC1214_INBOUND_MESSAGE1			0x00404=0A=
+#define ARCMSR_ARC1214_OUTBOUND_MESSAGE0			0x00420=0A=
+#define ARCMSR_ARC1214_OUTBOUND_MESSAGE1			0x00424=0A=
+#define ARCMSR_ARC1214_INBOUND_DOORBELL			0x00460=0A=
+#define ARCMSR_ARC1214_OUTBOUND_DOORBELL			0x00480=0A=
+#define ARCMSR_ARC1214_OUTBOUND_DOORBELL_ENABLE		0x00484=0A=
+#define ARCMSR_ARC1214_INBOUND_LIST_BASE_LOW		0x01000=0A=
+#define ARCMSR_ARC1214_INBOUND_LIST_BASE_HIGH		0x01004=0A=
+#define ARCMSR_ARC1214_INBOUND_LIST_WRITE_POINTER		0x01018=0A=
+#define ARCMSR_ARC1214_OUTBOUND_LIST_BASE_LOW		0x01060=0A=
+#define ARCMSR_ARC1214_OUTBOUND_LIST_BASE_HIGH		0x01064=0A=
+#define ARCMSR_ARC1214_OUTBOUND_LIST_COPY_POINTER		0x0106C=0A=
+#define ARCMSR_ARC1214_OUTBOUND_LIST_READ_POINTER		0x01070=0A=
+#define ARCMSR_ARC1214_OUTBOUND_INTERRUPT_CAUSE		0x01088=0A=
+#define ARCMSR_ARC1214_OUTBOUND_INTERRUPT_ENABLE		0x0108C=0A=
+#define ARCMSR_ARC1214_MESSAGE_WBUFFER			0x02000=0A=
+#define ARCMSR_ARC1214_MESSAGE_RBUFFER			0x02100=0A=
+#define ARCMSR_ARC1214_MESSAGE_RWBUFFER			0x02200=0A=
+/* Host Interrupt Mask */=0A=
+#define ARCMSR_ARC1214_ALL_INT_ENABLE				0x00001010=0A=
+#define ARCMSR_ARC1214_ALL_INT_DISABLE			0x00000000=0A=
+/* Host Interrupt Status */=0A=
+#define ARCMSR_ARC1214_OUTBOUND_DOORBELL_ISR		0x00001000=0A=
+#define ARCMSR_ARC1214_OUTBOUND_POSTQUEUE_ISR		0x00000010=0A=
+/* DoorBell*/=0A=
+#define ARCMSR_ARC1214_DRV2IOP_DATA_IN_READY			0x00000001=0A=
+#define ARCMSR_ARC1214_DRV2IOP_DATA_OUT_READ		0x00000002=0A=
+/*inbound message 0 ready*/=0A=
+#define ARCMSR_ARC1214_IOP2DRV_DATA_WRITE_OK		0x00000001=0A=
+/*outbound DATA WRITE isr door bell clear*/=0A=
+#define ARCMSR_ARC1214_IOP2DRV_DATA_READ_OK			0x00000002=0A=
+/*outbound message 0 ready*/=0A=
+#define ARCMSR_ARC1214_IOP2DRV_MESSAGE_CMD_DONE		0x02000000=0A=
+/*outbound message cmd isr door bell clear*/=0A=
+/*ARCMSR_HBAMU_MESSAGE_FIRMWARE_OK*/=0A=
+#define ARCMSR_ARC1214_MESSAGE_FIRMWARE_OK			0x80000000=0A=
+#define ARCMSR_ARC1214_OUTBOUND_LIST_INTERRUPT_CLEAR	0x00000001=0A=
+/*=0A=
+************************************************************************=
*******=0A=
 **    ARECA SCSI COMMAND DESCRIPTOR BLOCK size 0x1F8 (504)=0A=
 =
*************************************************************************=
******=0A=
 */=0A=
@@ -361,7 +415,7 @@ struct ARCMSR_CDB=0A=
 #define ARCMSR_CDB_FLAG_ORDEREDQ	0x10=0A=
 =0A=
 	uint8_t msgPages;=0A=
-	uint32_t Context;=0A=
+	uint32_t msgContext;=0A=
 	uint32_t DataLength;=0A=
 	uint8_t Cdb[16];=0A=
 	uint8_t DeviceStatus;=0A=
@@ -496,6 +550,50 @@ struct MessageUnit_C {=0A=
 	uint32_t reserved4[32];				/*2180 21FF*/=0A=
 	uint32_t msgcode_rwbuffer[256];			/*2200 23FF*/=0A=
 };=0A=
+struct InBound_SRB {=0A=
+	uint32_t addressLow;/*pointer to SRB block*/=0A=
+	uint32_t addressHigh;=0A=
+	uint32_t length;/*in DWORDs*/=0A=
+	uint32_t reserved0;=0A=
+};=0A=
+=0A=
+struct OutBound_SRB {=0A=
+	uint32_t addressLow;/*pointer to SRB block*/=0A=
+	uint32_t addressHigh;=0A=
+};=0A=
+=0A=
+struct MessageUnit_D {=0A=
+	struct InBound_SRB post_qbuffer[ARCMSR_MAX_ARC1214_POSTQUEUE];=0A=
+	struct OutBound_SRB done_qbuffer[ARCMSR_MAX_ARC1214_POSTQUEUE];=0A=
+	u16 postq_index;=0A=
+	u16 doneq_index;=0A=
+	u32 __iomem *chip_id;			/*0x00004*/=0A=
+	u32 __iomem *cpu_mem_config;		/*0x00008*/=0A=
+	u32 __iomem *i2o_host_interrupt_mask;	/*0x00034*/=0A=
+	u32 __iomem *sample_at_reset;		/*0x00100*/=0A=
+	u32 __iomem *reset_request;		/*0x00108*/=0A=
+	u32 __iomem *host_int_status;		/*0x00200*/=0A=
+	u32 __iomem *pcief0_int_enable;		/*0x0020C*/=0A=
+	u32 __iomem *inbound_msgaddr0;		/*0x00400*/=0A=
+	u32 __iomem *inbound_msgaddr1;		/*0x00404*/=0A=
+	u32 __iomem *outbound_msgaddr0;		/*0x00420*/=0A=
+	u32 __iomem *outbound_msgaddr1;		/*0x00424*/=0A=
+	u32 __iomem *inbound_doorbell;		/*0x00460*/=0A=
+	u32 __iomem *outbound_doorbell;		/*0x00480*/=0A=
+	u32 __iomem *outbound_doorbell_enable;	/*0x00484*/=0A=
+	u32 __iomem *inboundlist_base_low;	/*0x01000*/=0A=
+	u32 __iomem *inboundlist_base_high;	/*0x01004*/=0A=
+	u32 __iomem *inboundlist_write_pointer;	/*0x01018*/=0A=
+	u32 __iomem *outboundlist_base_low;	/*0x01060*/=0A=
+	u32 __iomem *outboundlist_base_high;	/*0x01064*/=0A=
+	u32 __iomem *outboundlist_copy_pointer;	/*0x0106C*/=0A=
+	u32 __iomem *outboundlist_read_pointer;	/*0x01070 0x01072*/=0A=
+	u32 __iomem *outboundlist_interrupt_cause;	/*0x1088*/=0A=
+	u32 __iomem *outboundlist_interrupt_enable;	/*0x108C*/=0A=
+	u32 __iomem *message_wbuffer;		/*0x2000*/=0A=
+	u32 __iomem *message_rbuffer;		/*0x2100*/=0A=
+	u32 __iomem *msgcode_rwbuffer;		/*0x2200*/=0A=
+};=0A=
 /*=0A=
 =
*************************************************************************=
******=0A=
 **                 Adapter Control Block=0A=
@@ -508,6 +606,7 @@ struct AdapterControlBlock=0A=
 	#define ACB_ADAPTER_TYPE_B	0x00000002	/* hbb M IOP */=0A=
 	#define ACB_ADAPTER_TYPE_C	0x00000004	/* hbc P IOP */=0A=
 	#define ACB_ADAPTER_TYPE_D	0x00000008	/* hbd A IOP */=0A=
+	u32 roundup_ccbsize;=0A=
 	struct pci_dev *pdev;=0A=
 	struct Scsi_Host *host;=0A=
 	unsigned long vir2phy_offset;=0A=
@@ -515,13 +614,16 @@ struct AdapterControlBlock=0A=
 	/* Offset is used in making arc cdb physical to virtual calculations */=0A=
 	uint32_t outbound_int_enable;=0A=
 	uint32_t cdb_phyaddr_hi32;=0A=
-	uint32_t reg_mu_acc_handle0;=0A=
 	spinlock_t eh_lock;=0A=
 	spinlock_t ccblist_lock;=0A=
+	spinlock_t postq_lock;=0A=
+	spinlock_t rqbuffer_lock;=0A=
+	spinlock_t wqbuffer_lock;=0A=
 	union {=0A=
 		struct MessageUnit_A __iomem *pmuA;=0A=
 		struct MessageUnit_B *pmuB;=0A=
 		struct MessageUnit_C __iomem *pmuC;=0A=
+		struct MessageUnit_D __iomem *pmuD;=0A=
 	};=0A=
 	/* message unit ATU inbound base address0 */=0A=
 	void __iomem *mem_base0;=0A=
@@ -563,7 +665,8 @@ struct AdapterControlBlock=0A=
 	/* dma_coherent used for memory free */=0A=
 	dma_addr_t dma_coherent_handle;=0A=
 	/* dma_coherent_handle used for memory free */=0A=
-	dma_addr_t dma_coherent_handle_hbb_mu;=0A=
+	dma_addr_t dma_coherent_handle2;=0A=
+	void *dma_coherent2;=0A=
 	unsigned int uncache_size;=0A=
 	uint8_t rqbuffer[ARCMSR_MAX_QBUFFER];=0A=
 	/* data collection buffer for read from 80331 */=0A=
@@ -612,7 +715,7 @@ struct CommandControlBlock {=0A=
 	struct list_head list;=0A=
 	struct scsi_cmnd *pcmd;=0A=
 	struct AdapterControlBlock *acb;=0A=
-	uint32_t cdb_phyaddr_pattern;=0A=
+	uint32_t cdb_phyaddr;=0A=
 	uint32_t arc_cdb_size;=0A=
 	uint16_t ccb_flags;=0A=
 	#define CCB_FLAG_READ		0x0000=0A=
diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c =
b/drivers/scsi/arcmsr/arcmsr_hba.c=0A=
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2013-02-06 16:28:44.718455072 =
+0800=0A=
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2013-02-06 16:28:53.762664596 =
+0800=0A=
@@ -89,11 +89,8 @@ static int arcmsr_bios_param(struct scsi=0A=
 static int arcmsr_queue_command(struct Scsi_Host *h, struct scsi_cmnd =
*cmd);=0A=
 static int arcmsr_probe(struct pci_dev *pdev,=0A=
 				const struct pci_device_id *id);=0A=
-#ifdef CONFIG_PM=0A=
-	static int arcmsr_suspend(struct pci_dev *pdev,=0A=
-	pm_message_t state);=0A=
-	static int arcmsr_resume(struct pci_dev *pdev);=0A=
-#endif=0A=
+static int arcmsr_suspend(struct pci_dev *pdev, pm_message_t state);=0A=
+static int arcmsr_resume(struct pci_dev *pdev);=0A=
 static void arcmsr_remove(struct pci_dev *pdev);=0A=
 static void arcmsr_shutdown(struct pci_dev *pdev);=0A=
 static void arcmsr_iop_init(struct AdapterControlBlock *acb);=0A=
@@ -112,6 +109,7 @@ static void arcmsr_message_isr_bh_fn(str=0A=
 static bool arcmsr_get_firmware_spec(struct AdapterControlBlock *acb);=0A=
 static void arcmsr_start_adapter_bgrb(struct AdapterControlBlock *acb);=0A=
 static void arcmsr_hbaC_message_isr(struct AdapterControlBlock *pACB);=0A=
+static void arcmsr_hbaD_message_isr(struct AdapterControlBlock *acb);=0A=
 static void arcmsr_hardware_reset(struct AdapterControlBlock *acb);=0A=
 static const char *arcmsr_info(struct Scsi_Host *);=0A=
 static irqreturn_t arcmsr_interrupt(struct AdapterControlBlock *acb);=0A=
@@ -139,8 +137,6 @@ static struct scsi_host_template arcmsr_=0A=
 	.change_queue_depth	=3D arcmsr_adjust_disk_queue_depth,=0A=
 	.can_queue		=3D ARCMSR_MAX_FREECCB_NUM,=0A=
 	.this_id			=3D ARCMSR_SCSI_INITIATOR_ID,=0A=
-	.sg_tablesize	        	=3D ARCMSR_DEFAULT_SG_ENTRIES, =0A=
-	.max_sectors    	    	=3D ARCMSR_MAX_XFER_SECTORS_C, =0A=
 	.cmd_per_lun		=3D ARCMSR_MAX_CMD_PERLUN,=0A=
 	.use_clustering		=3D ENABLE_CLUSTERING,=0A=
 	.shost_attrs		=3D arcmsr_host_attrs,=0A=
@@ -155,13 +151,12 @@ static struct pci_device_id arcmsr_devic=0A=
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1201)},=0A=
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1202)},=0A=
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1210)},=0A=
+	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1214)},=0A=
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1220)},=0A=
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1230)},=0A=
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1260)},=0A=
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1270)},=0A=
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1280)},=0A=
-	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1380)},=0A=
-	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1381)},=0A=
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1680)},=0A=
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1681)},=0A=
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1880)},=0A=
@@ -173,26 +168,33 @@ static struct pci_driver arcmsr_pci_driv=0A=
 	.id_table			=3D arcmsr_device_id_table,=0A=
 	.probe			=3D arcmsr_probe,=0A=
 	.remove			=3D arcmsr_remove,=0A=
-	#ifdef CONFIG_PM=0A=
 		.suspend		=3D arcmsr_suspend,=0A=
 		.resume		=3D arcmsr_resume,=0A=
-	#endif=0A=
 	.shutdown		=3D arcmsr_shutdown,=0A=
 };=0A=
 /*=0A=
 =
*************************************************************************=
***=0A=
 =
*************************************************************************=
***=0A=
 */=0A=
-static void arcmsr_free_hbb_mu(struct AdapterControlBlock *acb)=0A=
+static void arcmsr_free_mu(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	switch (acb->adapter_type) {=0A=
 	case ACB_ADAPTER_TYPE_A:=0A=
 	case ACB_ADAPTER_TYPE_C:=0A=
 		break;=0A=
 	case ACB_ADAPTER_TYPE_B: {=0A=
+		struct MessageUnit_B *reg =3D acb->pmuB;=0A=
 		dma_free_coherent(&acb->pdev->dev,=0A=
 			sizeof(struct MessageUnit_B),=0A=
-			acb->pmuB, acb->dma_coherent_handle_hbb_mu);=0A=
+			reg, acb->dma_coherent_handle2);=0A=
+		break;=0A=
+	}=0A=
+	case ACB_ADAPTER_TYPE_D: {=0A=
+		dma_free_coherent(&acb->pdev->dev,=0A=
+			sizeof(struct MessageUnit_D),=0A=
+			acb->dma_coherent,=0A=
+			acb->dma_coherent_handle);=0A=
+		break;=0A=
 	}=0A=
 	}=0A=
 }=0A=
@@ -248,6 +250,25 @@ static bool arcmsr_remap_pciregion(struc=0A=
 		}=0A=
 		break;=0A=
 	}=0A=
+	case ACB_ADAPTER_TYPE_D: {=0A=
+		void __iomem *mem_base0;=0A=
+		unsigned long addr, range, flags;=0A=
+=0A=
+		addr =3D (unsigned long)pci_resource_start(pdev, 0);=0A=
+		range =3D pci_resource_len(pdev, 0);=0A=
+		flags =3D pci_resource_flags(pdev, 0);=0A=
+		if (flags & IORESOURCE_CACHEABLE)=0A=
+			mem_base0 =3D ioremap(addr, range);=0A=
+		else=0A=
+			mem_base0 =3D ioremap_nocache(addr, range);=0A=
+		if (!mem_base0) {=0A=
+			pr_notice("arcmsr%d: memory mapping region fail\n",=0A=
+			acb->host->host_no);=0A=
+			return false;=0A=
+		}=0A=
+		acb->mem_base0 =3D mem_base0;=0A=
+		break;=0A=
+	}=0A=
 	}=0A=
 	return true;=0A=
 }=0A=
@@ -257,16 +278,19 @@ static void arcmsr_unmap_pciregion(struc=0A=
 	switch (acb->adapter_type) {=0A=
 	case ACB_ADAPTER_TYPE_A: {=0A=
 		iounmap(acb->pmuA);=0A=
+		break;=0A=
 	}=0A=
-	break;=0A=
 	case ACB_ADAPTER_TYPE_B: {=0A=
 		iounmap(acb->mem_base0);=0A=
 		iounmap(acb->mem_base1);=0A=
+		break;=0A=
 	}=0A=
-=0A=
-	break;=0A=
 	case ACB_ADAPTER_TYPE_C: {=0A=
 		iounmap(acb->pmuC);=0A=
+		break;=0A=
+	}=0A=
+	case ACB_ADAPTER_TYPE_D: {=0A=
+		iounmap(acb->mem_base0);=0A=
 	}=0A=
 	}=0A=
 }=0A=
@@ -309,28 +333,52 @@ static int arcmsr_bios_param(struct scsi=0A=
 	return 0;=0A=
 }=0A=
 =0A=
-static void=0A=
+static bool=0A=
 arcmsr_define_adapter_type(struct AdapterControlBlock *acb)=0A=
 {=0A=
-	struct pci_dev *pdev =3D acb->pdev;=0A=
 	u16 dev_id;=0A=
+	struct pci_dev *pdev =3D acb->pdev;=0A=
+=0A=
 	pci_read_config_word(pdev, PCI_DEVICE_ID, &dev_id);=0A=
 	acb->dev_id =3D dev_id;=0A=
 	switch (dev_id) {=0A=
 	case 0x1880: {=0A=
 		acb->adapter_type =3D ACB_ADAPTER_TYPE_C;=0A=
-		}=0A=
 		break;=0A=
-	case 0x1201: {=0A=
+	}=0A=
+	case 0x1200:=0A=
+	case 0x1201:=0A=
+	case 0x1202: {=0A=
 		acb->adapter_type =3D ACB_ADAPTER_TYPE_B;=0A=
-		}=0A=
 		break;=0A=
-=0A=
-	default: acb->adapter_type =3D ACB_ADAPTER_TYPE_A;=0A=
 	}=0A=
+	case 0x1110:=0A=
+	case 0x1120:=0A=
+	case 0x1130:=0A=
+	case 0x1160:=0A=
+	case 0x1170:=0A=
+	case 0x1210:=0A=
+	case 0x1220:=0A=
+	case 0x1230:=0A=
+	case 0x1260:=0A=
+	case 0x1280:=0A=
+	case 0x1680: {=0A=
+		acb->adapter_type =3D ACB_ADAPTER_TYPE_A;=0A=
+		break;=0A=
+	}=0A=
+	case 0x1214: {=0A=
+		acb->adapter_type =3D ACB_ADAPTER_TYPE_D;=0A=
+		break;=0A=
+	}=0A=
+	default: {=0A=
+		pr_notice("Unknown device ID =3D 0x%x\n", dev_id);=0A=
+		return false;=0A=
+	}=0A=
+	}=0A=
+	return true;=0A=
 }=0A=
 =0A=
-static uint8_t=0A=
+static bool=0A=
 arcmsr_hbaA_wait_msgint_ready(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
@@ -349,7 +397,7 @@ arcmsr_hbaA_wait_msgint_ready(struct Ada=0A=
 	return false;=0A=
 }=0A=
 =0A=
-static uint8_t=0A=
+static bool=0A=
 arcmsr_hbaB_wait_msgint_ready(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	struct MessageUnit_B *reg =3D acb->pmuB;=0A=
@@ -370,7 +418,7 @@ arcmsr_hbaB_wait_msgint_ready(struct Ada=0A=
 	return false;=0A=
 }=0A=
 =0A=
-static uint8_t=0A=
+static bool=0A=
 arcmsr_hbaC_wait_msgint_ready(struct AdapterControlBlock *pACB)=0A=
 {=0A=
 	struct MessageUnit_C *phbcmu =3D (struct MessageUnit_C *)pACB->pmuC;=0A=
@@ -388,6 +436,23 @@ arcmsr_hbaC_wait_msgint_ready(struct Ada=0A=
 	return false;=0A=
 }=0A=
 =0A=
+static bool=0A=
+arcmsr_hbaD_wait_msgint_ready(struct AdapterControlBlock *pACB)=0A=
+{=0A=
+	int i;=0A=
+	struct MessageUnit_D __iomem *reg =3D (struct MessageUnit_D =
*)pACB->pmuD;=0A=
+	for (i =3D 0; i < 2000; i++) {=0A=
+		if (readl(reg->outbound_doorbell)=0A=
+			& ARCMSR_ARC1214_IOP2DRV_MESSAGE_CMD_DONE) {=0A=
+			writel(ARCMSR_ARC1214_IOP2DRV_MESSAGE_CMD_DONE,=0A=
+				reg->outbound_doorbell);=0A=
+			return true;=0A=
+		}=0A=
+		msleep(10);=0A=
+	} /* max 20 seconds */=0A=
+	return false;=0A=
+}=0A=
+=0A=
 static void=0A=
 arcmsr_hbaA_flush_cache(struct AdapterControlBlock *acb)=0A=
 {=0A=
@@ -428,11 +493,13 @@ static void=0A=
 arcmsr_hbaC_flush_cache(struct AdapterControlBlock *pACB)=0A=
 {=0A=
 	struct MessageUnit_C *reg =3D (struct MessageUnit_C *)pACB->pmuC;=0A=
-	int retry_count =3D 30;/* enlarge wait flush adapter cache time: 10 =
minute */=0A=
+	int retry_count =3D 6;/* enlarge wait flush adapter cache time: 10 =
minute */=0A=
 	writel(ARCMSR_INBOUND_MESG0_FLUSH_CACHE,=0A=
 		&reg->inbound_msgaddr0);=0A=
 	writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,=0A=
 		&reg->inbound_doorbell);=0A=
+	readl(&reg->inbound_doorbell);=0A=
+	readl(&reg->inbound_msgaddr0);=0A=
 	do {=0A=
 		if (arcmsr_hbaC_wait_msgint_ready(pACB)) {=0A=
 			break;=0A=
@@ -445,6 +512,30 @@ arcmsr_hbaC_flush_cache(struct AdapterCo=0A=
 	} while (retry_count !=3D 0);=0A=
 	return;=0A=
 }=0A=
+=0A=
+static void=0A=
+arcmsr_hbaD_flush_cache(struct AdapterControlBlock *pACB)=0A=
+{=0A=
+	int retry_count =3D 6;=0A=
+	struct MessageUnit_D __iomem *reg =3D=0A=
+		(struct MessageUnit_D *)pACB->pmuD;=0A=
+=0A=
+	writel(ARCMSR_INBOUND_MESG0_FLUSH_CACHE,=0A=
+		reg->inbound_msgaddr0);=0A=
+	do {=0A=
+		if (arcmsr_hbaD_wait_msgint_ready(pACB)) {=0A=
+			break;=0A=
+		} else {=0A=
+			retry_count--;=0A=
+			pr_notice("arcmsr%d: wait 'flush adapter"=0A=
+			"cache' timeout, retry count down =3D %d\n",=0A=
+			pACB->host->host_no,=0A=
+			retry_count);=0A=
+		}=0A=
+	} while (retry_count !=3D 0);=0A=
+	return;=0A=
+}=0A=
+=0A=
 static void=0A=
 arcmsr_flush_adapter_cache(struct AdapterControlBlock *acb)=0A=
 {=0A=
@@ -462,6 +553,10 @@ arcmsr_flush_adapter_cache(struct Adapte=0A=
 	case ACB_ADAPTER_TYPE_C: {=0A=
 		arcmsr_hbaC_flush_cache(acb);=0A=
 		}=0A=
+		break;=0A=
+	case ACB_ADAPTER_TYPE_D: {=0A=
+		arcmsr_hbaD_flush_cache(acb);=0A=
+	}=0A=
 	}=0A=
 }=0A=
 =0A=
@@ -471,59 +566,173 @@ arcmsr_alloc_ccb_pool(struct AdapterCont=0A=
 	struct pci_dev *pdev =3D acb->pdev;=0A=
 	void *dma_coherent;=0A=
 	dma_addr_t dma_coherent_handle;=0A=
-	struct CommandControlBlock *ccb_tmp;=0A=
+	struct CommandControlBlock *ccb_tmp =3D NULL;=0A=
 	int i =3D 0, j =3D 0;=0A=
 	dma_addr_t cdb_phyaddr;=0A=
-	unsigned long roundup_ccbsize;=0A=
+	unsigned long roundup_ccbsize =3D 0;=0A=
 	unsigned long max_xfer_len;=0A=
 	unsigned long max_sg_entrys;=0A=
 	uint32_t  firm_config_version;=0A=
-=0A=
-	for (i =3D 0; i < ARCMSR_MAX_TARGETID; i++)=0A=
-		for (j =3D 0; j < ARCMSR_MAX_TARGETLUN; j++)=0A=
-			acb->devstate[i][j] =3D ARECA_RAID_GONE;=0A=
-=0A=
 	max_xfer_len =3D ARCMSR_MAX_XFER_LEN;=0A=
 	max_sg_entrys =3D ARCMSR_DEFAULT_SG_ENTRIES;=0A=
 	firm_config_version =3D acb->firm_cfg_version;=0A=
 	if ((firm_config_version & 0xFF) >=3D 3) {=0A=
 		max_xfer_len =3D (ARCMSR_CDB_SG_PAGE_LENGTH <<=0A=
 			((firm_config_version >> 8) & 0xFF)) * 1024;=0A=
-		max_sg_entrys =3D (max_xfer_len/4096);=0A=
+		max_sg_entrys =3D (max_xfer_len / 4096);=0A=
 	}=0A=
-	acb->host->max_sectors =3D max_xfer_len/512;=0A=
+	acb->host->max_sectors =3D max_xfer_len / 512;=0A=
 	acb->host->sg_tablesize =3D max_sg_entrys;=0A=
-	roundup_ccbsize =3D roundup(sizeof(struct CommandControlBlock) +=0A=
-		(max_sg_entrys - 1) * sizeof(struct SG64ENTRY), 32);=0A=
-	acb->uncache_size =3D roundup_ccbsize * ARCMSR_MAX_FREECCB_NUM;=0A=
-	dma_coherent =3D dma_alloc_coherent(&pdev->dev, acb->uncache_size,=0A=
-		&dma_coherent_handle, GFP_KERNEL);=0A=
-	if (!dma_coherent) {=0A=
-		pr_notice("arcmsr%d: dma_alloc_coherent got error\n",=0A=
-			acb->host->host_no);=0A=
-		return -ENOMEM;=0A=
+	switch (acb->adapter_type) {=0A=
+	case ACB_ADAPTER_TYPE_A: {=0A=
+		roundup_ccbsize =3D=0A=
+		roundup(sizeof(struct CommandControlBlock) +=0A=
+		max_sg_entrys * sizeof(struct SG64ENTRY), 32);=0A=
+		acb->uncache_size =3D roundup_ccbsize *=0A=
+			ARCMSR_MAX_FREECCB_NUM;=0A=
+		dma_coherent =3D dma_alloc_coherent(&pdev->dev,=0A=
+			acb->uncache_size, &dma_coherent_handle,=0A=
+			GFP_KERNEL);=0A=
+		if (!dma_coherent) {=0A=
+			pr_notice("arcmsr%d: dma_alloc_coherent"=0A=
+			"got error\n", acb->host->host_no);=0A=
+			return -ENOMEM;=0A=
+		}=0A=
+		memset(dma_coherent, 0, acb->uncache_size);=0A=
+		acb->dma_coherent =3D dma_coherent;=0A=
+		acb->dma_coherent_handle =3D dma_coherent_handle;=0A=
+		ccb_tmp =3D (struct CommandControlBlock *)dma_coherent;=0A=
+		acb->vir2phy_offset =3D (unsigned long)dma_coherent -=0A=
+			(unsigned long)dma_coherent_handle;=0A=
+		for (i =3D 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {=0A=
+			cdb_phyaddr =3D dma_coherent_handle +=0A=
+				offsetof(struct CommandControlBlock,=0A=
+				arcmsr_cdb);=0A=
+			ccb_tmp->cdb_phyaddr =3D cdb_phyaddr >> 5;=0A=
+			acb->pccb_pool[i] =3D ccb_tmp;=0A=
+			ccb_tmp->acb =3D acb;=0A=
+			INIT_LIST_HEAD(&ccb_tmp->list);=0A=
+			list_add_tail(&ccb_tmp->list,=0A=
+			&acb->ccb_free_list);=0A=
+			ccb_tmp =3D (struct CommandControlBlock *)=0A=
+			((unsigned long)ccb_tmp + roundup_ccbsize);=0A=
+			dma_coherent_handle =3D dma_coherent_handle +=0A=
+				roundup_ccbsize;=0A=
+		}=0A=
+		break;=0A=
 	}=0A=
-	acb->dma_coherent =3D dma_coherent;=0A=
-	acb->dma_coherent_handle =3D dma_coherent_handle;=0A=
-	memset(dma_coherent, 0, acb->uncache_size);=0A=
-	ccb_tmp =3D dma_coherent;=0A=
-	acb->vir2phy_offset =3D (unsigned long)dma_coherent -=0A=
-		(unsigned long)dma_coherent_handle;=0A=
-	for (i =3D 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {=0A=
-		cdb_phyaddr =3D dma_coherent_handle +=0A=
+	case ACB_ADAPTER_TYPE_B: {=0A=
+		roundup_ccbsize =3D roundup(sizeof(struct CommandControlBlock) +=0A=
+			(max_sg_entrys - 1) * sizeof(struct SG64ENTRY), 32);=0A=
+		acb->uncache_size =3D roundup_ccbsize *=0A=
+			ARCMSR_MAX_FREECCB_NUM;=0A=
+		dma_coherent =3D dma_alloc_coherent(&pdev->dev,=0A=
+			acb->uncache_size, &dma_coherent_handle,=0A=
+			GFP_KERNEL);=0A=
+		if (!dma_coherent) {=0A=
+			pr_notice("DMA allocation failed....\n");=0A=
+			return -ENOMEM;=0A=
+		}=0A=
+		memset(dma_coherent, 0, acb->uncache_size);=0A=
+		acb->dma_coherent =3D dma_coherent;=0A=
+		acb->dma_coherent_handle =3D dma_coherent_handle;=0A=
+		ccb_tmp =3D (struct CommandControlBlock *)dma_coherent;=0A=
+		acb->vir2phy_offset =3D (unsigned long)dma_coherent -=0A=
+			(unsigned long)dma_coherent_handle;=0A=
+		for (i =3D 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {=0A=
+			cdb_phyaddr =3D dma_coherent_handle +=0A=
 			offsetof(struct CommandControlBlock,=0A=
 			arcmsr_cdb);=0A=
-		ccb_tmp->cdb_phyaddr_pattern =3D=0A=
-			((acb->adapter_type =3D=3D ACB_ADAPTER_TYPE_C)=0A=
-			? cdb_phyaddr : (cdb_phyaddr >> 5));=0A=
-		acb->pccb_pool[i] =3D ccb_tmp;=0A=
-		ccb_tmp->acb =3D acb;=0A=
-		INIT_LIST_HEAD(&ccb_tmp->list);=0A=
-		list_add_tail(&ccb_tmp->list, &acb->ccb_free_list);=0A=
-		ccb_tmp =3D (struct CommandControlBlock *)=0A=
+			ccb_tmp->cdb_phyaddr =3D cdb_phyaddr >> 5;=0A=
+			acb->pccb_pool[i] =3D ccb_tmp;=0A=
+			ccb_tmp->acb =3D acb;=0A=
+			INIT_LIST_HEAD(&ccb_tmp->list);=0A=
+			list_add_tail(&ccb_tmp->list,=0A=
+			&acb->ccb_free_list);=0A=
+			ccb_tmp =3D (struct CommandControlBlock *)=0A=
 			((unsigned long)ccb_tmp + roundup_ccbsize);=0A=
-		dma_coherent_handle =3D dma_coherent_handle + roundup_ccbsize;=0A=
+			dma_coherent_handle =3D dma_coherent_handle +=0A=
+			roundup_ccbsize;=0A=
+		}=0A=
+		break;=0A=
 	}=0A=
+	case ACB_ADAPTER_TYPE_C: {=0A=
+		roundup_ccbsize =3D=0A=
+		roundup(sizeof(struct CommandControlBlock) +=0A=
+		(max_sg_entrys - 1) * sizeof(struct SG64ENTRY), 32);=0A=
+		acb->uncache_size =3D roundup_ccbsize *=0A=
+		ARCMSR_MAX_FREECCB_NUM;=0A=
+		dma_coherent =3D dma_alloc_coherent(&pdev->dev,=0A=
+			acb->uncache_size,=0A=
+			&dma_coherent_handle,=0A=
+			GFP_KERNEL);=0A=
+		if (!dma_coherent) {=0A=
+			pr_notice("arcmsr%d: dma_alloc_coherent"=0A=
+			"got error\n", acb->host->host_no);=0A=
+			return -ENOMEM;=0A=
+		}=0A=
+		memset(dma_coherent, 0, acb->uncache_size);=0A=
+		acb->dma_coherent =3D dma_coherent;=0A=
+		acb->dma_coherent_handle =3D dma_coherent_handle;=0A=
+		acb->vir2phy_offset =3D (unsigned long)dma_coherent -=0A=
+		(unsigned long)dma_coherent_handle;=0A=
+		ccb_tmp =3D dma_coherent;=0A=
+		for (i =3D 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {=0A=
+			cdb_phyaddr =3D dma_coherent_handle +=0A=
+			offsetof(struct CommandControlBlock,=0A=
+			arcmsr_cdb);=0A=
+			ccb_tmp->cdb_phyaddr =3D cdb_phyaddr;=0A=
+			acb->pccb_pool[i] =3D ccb_tmp;=0A=
+			ccb_tmp->acb =3D acb;=0A=
+			INIT_LIST_HEAD(&ccb_tmp->list);=0A=
+			list_add_tail(&ccb_tmp->list,=0A=
+				&acb->ccb_free_list);=0A=
+			ccb_tmp =3D (struct CommandControlBlock *)=0A=
+				((unsigned long)ccb_tmp +=0A=
+				roundup_ccbsize);=0A=
+			dma_coherent_handle =3D dma_coherent_handle +=0A=
+				roundup_ccbsize;=0A=
+		}=0A=
+		break;=0A=
+	}=0A=
+	case ACB_ADAPTER_TYPE_D: {=0A=
+		void *dma_coherent;=0A=
+		dma_addr_t dma_coherent_handle;=0A=
+=0A=
+		roundup_ccbsize =3D roundup(sizeof(struct CommandControlBlock)=0A=
+		+ (max_sg_entrys - 1) * sizeof(struct SG64ENTRY), 32);=0A=
+		dma_coherent =3D dma_alloc_coherent(&pdev->dev,=0A=
+			roundup_ccbsize * ARCMSR_MAX_FREECCB_NUM,=0A=
+			&dma_coherent_handle, GFP_KERNEL);=0A=
+		if (!dma_coherent) {=0A=
+			pr_notice("DMA allocation failed...\n");=0A=
+			return -ENOMEM;=0A=
+		}=0A=
+		acb->roundup_ccbsize =3D roundup_ccbsize;=0A=
+		acb->dma_coherent2 =3D dma_coherent;=0A=
+		acb->dma_coherent_handle2 =3D dma_coherent_handle;=0A=
+		ccb_tmp =3D dma_coherent;=0A=
+		acb->vir2phy_offset =3D (unsigned long)dma_coherent -=0A=
+			(unsigned long)dma_coherent_handle;=0A=
+		for (i =3D 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {=0A=
+			cdb_phyaddr =3D dma_coherent_handle +=0A=
+			offsetof(struct CommandControlBlock, arcmsr_cdb);=0A=
+			ccb_tmp->cdb_phyaddr =3D=0A=
+			cdb_phyaddr;=0A=
+			acb->pccb_pool[i] =3D ccb_tmp;=0A=
+			ccb_tmp->acb =3D acb;=0A=
+			INIT_LIST_HEAD(&ccb_tmp->list);=0A=
+			list_add_tail(&ccb_tmp->list, &acb->ccb_free_list);=0A=
+			ccb_tmp =3D (struct CommandControlBlock *)=0A=
+				((unsigned long)ccb_tmp + roundup_ccbsize);=0A=
+			dma_coherent_handle =3D dma_coherent_handle=0A=
+				+ roundup_ccbsize;=0A=
+		}=0A=
+	}=0A=
+	}=0A=
+	for (i =3D 0; i < ARCMSR_MAX_TARGETID; i++)=0A=
+		for (j =3D 0; j < ARCMSR_MAX_TARGETLUN; j++)=0A=
+			acb->devstate[i][j] =3D ARECA_RAID_GONE;=0A=
 	return 0;=0A=
 }=0A=
 =0A=
@@ -559,18 +768,18 @@ arcmsr_message_isr_bh_fn(struct work_str=0A=
 						(diff & 0x01) =3D=3D 1) {=0A=
 							scsi_add_device(acb->host,=0A=
 							0, target, lun);=0A=
-						} else if ((temp & 0x01) =3D=3D 0=0A=
-						&& (diff & 0x01) =3D=3D 1) {=0A=
-							psdev =3D=0A=
-							scsi_device_lookup(acb->host,=0A=
-							0, target, lun);=0A=
-							if (psdev !=3D NULL) {=0A=
-								scsi_remove_device(psdev);=0A=
-								scsi_device_put(psdev);=0A=
-							}=0A=
+					} else if ((temp & 0x01) =3D=3D 0=0A=
+					&& (diff & 0x01) =3D=3D 1) {=0A=
+						psdev =3D=0A=
+						scsi_device_lookup(acb->host,=0A=
+						0, target, lun);=0A=
+						if (psdev !=3D NULL) {=0A=
+							scsi_remove_device(psdev);=0A=
+							scsi_device_put(psdev);=0A=
 						}=0A=
-						temp >>=3D 1;=0A=
-						diff >>=3D 1;=0A=
+					}=0A=
+					temp >>=3D 1;=0A=
+					diff >>=3D 1;=0A=
 					}=0A=
 				}=0A=
 				devicemap++;=0A=
@@ -608,16 +817,16 @@ arcmsr_message_isr_bh_fn(struct work_str=0A=
 							scsi_add_device(acb->host,=0A=
 							0, target, lun);=0A=
 						} else if ((temp & 0x01) =3D=3D 0=0A=
-						&& (diff & 0x01) =3D=3D 1) {=0A=
+							&& (diff & 0x01) =3D=3D 1) {=0A=
 							psdev =3D scsi_device_lookup(acb->host,=0A=
 							0, target, lun);=0A=
 							if (psdev !=3D NULL) {=0A=
 								scsi_remove_device(psdev);=0A=
 								scsi_device_put(psdev);=0A=
 							}=0A=
-						}=0A=
-						temp >>=3D 1;=0A=
-						diff >>=3D 1;=0A=
+					}=0A=
+					temp >>=3D 1;=0A=
+					diff >>=3D 1;=0A=
 					}=0A=
 				}=0A=
 				devicemap++;=0A=
@@ -650,7 +859,7 @@ arcmsr_message_isr_bh_fn(struct work_str=0A=
 					for (lun =3D 0; lun <=0A=
 					ARCMSR_MAX_TARGETLUN; lun++) {=0A=
 						if ((temp & 0x01) =3D=3D 1 &&=0A=
-							(diff & 0x01) =3D=3D 1) {=0A=
+						(diff & 0x01) =3D=3D 1) {=0A=
 							scsi_add_device(acb->host,=0A=
 							0, target, lun);=0A=
 						} else if ((temp & 0x01) =3D=3D 0=0A=
@@ -660,10 +869,10 @@ arcmsr_message_isr_bh_fn(struct work_str=0A=
 							if (psdev !=3D NULL) {=0A=
 								scsi_remove_device(psdev);=0A=
 								scsi_device_put(psdev);=0A=
-							}=0A=
 						}=0A=
-						temp >>=3D 1;=0A=
-						diff >>=3D 1;=0A=
+					}=0A=
+					temp >>=3D 1;=0A=
+					diff >>=3D 1;=0A=
 					}=0A=
 				}=0A=
 				devicemap++;=0A=
@@ -671,135 +880,177 @@ arcmsr_message_isr_bh_fn(struct work_str=0A=
 			}=0A=
 		}=0A=
 	}=0A=
-	}=0A=
-}=0A=
-=0A=
-#ifdef CONFIG_PM=0A=
-	static int=0A=
-	arcmsr_suspend(struct pci_dev *pdev, pm_message_t state)=0A=
-	{=0A=
-		int i;=0A=
-		uint32_t intmask_org;=0A=
-		struct Scsi_Host *host =3D pci_get_drvdata(pdev);=0A=
-		struct AdapterControlBlock *acb =3D=0A=
-			(struct AdapterControlBlock *)host->hostdata;=0A=
+	break;=0A=
+	case ACB_ADAPTER_TYPE_D: {=0A=
+		struct MessageUnit_D __iomem *reg  =3D acb->pmuD;=0A=
+		char *acb_dev_map =3D (char *)acb->device_map;=0A=
+		uint32_t __iomem *signature =3D=0A=
+			(uint32_t __iomem *)(&reg->msgcode_rwbuffer[0]);=0A=
+		char __iomem *devicemap =3D=0A=
+			(char __iomem *)(&reg->msgcode_rwbuffer[21]);=0A=
+		int target, lun;=0A=
+		struct scsi_device *psdev;=0A=
+		char diff;=0A=
 =0A=
-		intmask_org =3D arcmsr_disable_outbound_ints(acb);=0A=
-		if (acb->acb_flags & ACB_F_MSI_ENABLED) {=0A=
-			free_irq(pdev->irq, acb);=0A=
-			pci_disable_msi(pdev);=0A=
-		} else if (acb->acb_flags & ACB_F_MSIX_ENABLED) {=0A=
-			for (i =3D 0; i < ARCMST_NUM_MSIX_VECTORS; i++) {=0A=
-				free_irq(acb->entries[i].vector, acb);=0A=
+		atomic_inc(&acb->rq_map_token);=0A=
+		if (readl(signature) =3D=3D ARCMSR_SIGNATURE_GET_CONFIG) {=0A=
+			for (target =3D 0; target <=0A=
+				ARCMSR_MAX_TARGETID - 1; target++) {=0A=
+				diff =3D (*acb_dev_map) ^ readb(devicemap);=0A=
+				if (diff !=3D 0) {=0A=
+					char temp;=0A=
+					*acb_dev_map =3D=0A=
+						readb(devicemap);=0A=
+					temp =3D *acb_dev_map;=0A=
+					for (lun =3D 0; lun <=0A=
+					ARCMSR_MAX_TARGETLUN; lun++) {=0A=
+						if ((temp & 0x01) =3D=3D 1 &&=0A=
+						(diff & 0x01) =3D=3D 1) {=0A=
+							scsi_add_device(acb->host,=0A=
+							0, target, lun);=0A=
+						} else if ((temp & 0x01) =3D=3D 0=0A=
+						&& (diff & 0x01) =3D=3D 1) {=0A=
+							psdev =3D scsi_device_lookup(acb->host,=0A=
+							0, target, lun);=0A=
+							if (psdev !=3D NULL) {=0A=
+								scsi_remove_device(psdev);=0A=
+								scsi_device_put(psdev);=0A=
+						}=0A=
+					}=0A=
+					temp >>=3D 1;=0A=
+					diff >>=3D 1;=0A=
+					}=0A=
+				}=0A=
+				devicemap++;=0A=
+				acb_dev_map++;=0A=
 			}=0A=
-			pci_disable_msix(pdev);=0A=
-		} else {=0A=
-			free_irq(pdev->irq, acb);=0A=
 		}=0A=
-		del_timer_sync(&acb->eternal_timer);=0A=
-		flush_scheduled_work();=0A=
-		arcmsr_stop_adapter_bgrb(acb);=0A=
-		arcmsr_flush_adapter_cache(acb);=0A=
-		arcmsr_enable_outbound_ints(acb, intmask_org);=0A=
-		pci_set_drvdata(pdev, host);=0A=
-		pci_save_state(pdev);=0A=
-		pci_disable_device(pdev);=0A=
-		pci_set_power_state(pdev, pci_choose_state(pdev, state));=0A=
-		return 0;=0A=
+		break;=0A=
+	}=0A=
 	}=0A=
+}=0A=
 =0A=
-	static int=0A=
-	arcmsr_resume(struct pci_dev *pdev)=0A=
-	{=0A=
-		int error, i, j;=0A=
-		struct Scsi_Host *host =3D pci_get_drvdata(pdev);=0A=
-		struct AdapterControlBlock *acb =3D=0A=
-			(struct AdapterControlBlock *)host->hostdata;=0A=
-		struct msix_entry entries[ARCMST_NUM_MSIX_VECTORS];=0A=
-		pci_set_power_state(pdev, PCI_D0);=0A=
-		pci_enable_wake(pdev, PCI_D0, 0);=0A=
-		pci_restore_state(pdev);=0A=
-		if (pci_enable_device(pdev)) {=0A=
-			printk("%s: pci_enable_device error\n", __func__);=0A=
-			return -ENODEV;=0A=
-		}=0A=
-		error =3D pci_set_dma_mask(pdev, DMA_BIT_MASK(64));=0A=
+static int=0A=
+arcmsr_suspend(struct pci_dev *pdev, pm_message_t state)=0A=
+{=0A=
+	int i;=0A=
+	uint32_t intmask_org;=0A=
+	struct Scsi_Host *host =3D pci_get_drvdata(pdev);=0A=
+	struct AdapterControlBlock *acb =3D=0A=
+		(struct AdapterControlBlock *)host->hostdata;=0A=
+=0A=
+	intmask_org =3D arcmsr_disable_outbound_ints(acb);=0A=
+	if (acb->acb_flags & ACB_F_MSI_ENABLED) {=0A=
+		free_irq(pdev->irq, acb);=0A=
+		pci_disable_msi(pdev);=0A=
+	} else if (acb->acb_flags & ACB_F_MSIX_ENABLED) {=0A=
+		for (i =3D 0; i < ARCMST_NUM_MSIX_VECTORS; i++)=0A=
+			free_irq(acb->entries[i].vector, acb);=0A=
+		pci_disable_msix(pdev);=0A=
+	} else=0A=
+		free_irq(pdev->irq, acb);=0A=
+	del_timer_sync(&acb->eternal_timer);=0A=
+	flush_scheduled_work();=0A=
+	arcmsr_stop_adapter_bgrb(acb);=0A=
+	arcmsr_flush_adapter_cache(acb);=0A=
+	arcmsr_enable_outbound_ints(acb, intmask_org);=0A=
+	pci_set_drvdata(pdev, host);=0A=
+	pci_save_state(pdev);=0A=
+	pci_disable_device(pdev);=0A=
+	pci_set_power_state(pdev, pci_choose_state(pdev, state));=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+static int=0A=
+arcmsr_resume(struct pci_dev *pdev)=0A=
+{=0A=
+	int error, i, j;=0A=
+	struct Scsi_Host *host =3D pci_get_drvdata(pdev);=0A=
+	struct AdapterControlBlock *acb =3D=0A=
+		(struct AdapterControlBlock *)host->hostdata;=0A=
+	struct msix_entry entries[ARCMST_NUM_MSIX_VECTORS];=0A=
+	pci_set_power_state(pdev, PCI_D0);=0A=
+	pci_enable_wake(pdev, PCI_D0, 0);=0A=
+	pci_restore_state(pdev);=0A=
+	if (pci_enable_device(pdev)) {=0A=
+		pr_warn("%s: pci_enable_device error\n", __func__);=0A=
+		return -ENODEV;=0A=
+	}=0A=
+	error =3D pci_set_dma_mask(pdev, DMA_BIT_MASK(64));=0A=
+	if (error) {=0A=
+		error =3D pci_set_dma_mask(pdev, DMA_BIT_MASK(32));=0A=
 		if (error) {=0A=
-			error =3D pci_set_dma_mask(pdev, DMA_BIT_MASK(32));=0A=
-			if (error) {=0A=
 				pr_warn("scsi%d: No suitable DMA mask available\n",=0A=
-				       host->host_no);=0A=
+				host->host_no);=0A=
 				goto controller_unregister;=0A=
-			}=0A=
 		}=0A=
-		pci_set_master(pdev);=0A=
-		arcmsr_iop_init(acb);=0A=
-		if (pci_find_capability(pdev, PCI_CAP_ID_MSIX)) {=0A=
-			if (!pci_enable_msix(pdev, entries,=0A=
-				ARCMST_NUM_MSIX_VECTORS)) {=0A=
-				for (i =3D 0; i < ARCMST_NUM_MSIX_VECTORS;=0A=
-				i++) {=0A=
-					entries[i].entry =3D i;=0A=
-					if (request_irq(entries[i].vector,=0A=
-					arcmsr_do_interrupt, 0,=0A=
-					"arcmsr", acb)) {=0A=
-						for (j =3D 0 ; j < i ; j++)=0A=
-							free_irq(entries[i].vector,=0A=
-							acb);=0A=
-						goto controller_stop;=0A=
-					}=0A=
-					acb->entries[i] =3D entries[i];=0A=
-				}=0A=
-				acb->acb_flags |=3D ACB_F_MSIX_ENABLED;=0A=
-			} else {=0A=
-				printk("arcmsr%d: MSI-X"=0A=
-				"failed to enable\n", acb->host->host_no);=0A=
-				if (request_irq(pdev->irq,=0A=
-				arcmsr_do_interrupt, IRQF_SHARED,=0A=
+	}=0A=
+	pci_set_master(pdev);=0A=
+	if (pci_find_capability(pdev, PCI_CAP_ID_MSIX)) {=0A=
+		if (!pci_enable_msix(pdev, entries,=0A=
+			ARCMST_NUM_MSIX_VECTORS)) {=0A=
+			for (i =3D 0; i < ARCMST_NUM_MSIX_VECTORS;=0A=
+			i++) {=0A=
+				entries[i].entry =3D i;=0A=
+				if (request_irq(entries[i].vector,=0A=
+				arcmsr_do_interrupt, 0,=0A=
 				"arcmsr", acb)) {=0A=
+					for (j =3D 0 ; j < i ; j++)=0A=
+						free_irq(entries[i].vector,=0A=
+						acb);=0A=
 					goto controller_stop;=0A=
 				}=0A=
+				acb->entries[i] =3D entries[i];=0A=
 			}=0A=
-		} else if (pci_find_capability(pdev, PCI_CAP_ID_MSI)) {=0A=
-			if (!pci_enable_msi(pdev)) {=0A=
-				acb->acb_flags |=3D ACB_F_MSI_ENABLED;=0A=
-			}=0A=
-			if (request_irq(pdev->irq, arcmsr_do_interrupt,=0A=
-				IRQF_SHARED, "arcmsr", acb)) {=0A=
-				goto controller_stop;=0A=
-			}=0A=
+			acb->acb_flags |=3D ACB_F_MSIX_ENABLED;=0A=
 		} else {=0A=
-			if (request_irq(pdev->irq, arcmsr_do_interrupt,=0A=
-				IRQF_SHARED, "arcmsr", acb)) {=0A=
+			pr_warn("arcmsr%d: MSI-X"=0A=
+			"failed to enable\n", acb->host->host_no);=0A=
+			if (request_irq(pdev->irq,=0A=
+			arcmsr_do_interrupt, IRQF_SHARED,=0A=
+			"arcmsr", acb)) {=0A=
 				goto controller_stop;=0A=
 			}=0A=
 		}=0A=
-		INIT_WORK(&acb->arcmsr_do_message_isr_bh,=0A=
-		arcmsr_message_isr_bh_fn);=0A=
-		atomic_set(&acb->rq_map_token, 16);=0A=
-		atomic_set(&acb->ante_token_value, 16);=0A=
-		acb->fw_flag =3D FW_NORMAL;=0A=
-		init_timer(&acb->eternal_timer);=0A=
-		acb->eternal_timer.expires =3D jiffies +=0A=
-			msecs_to_jiffies(6 * HZ);=0A=
-		acb->eternal_timer.data =3D (unsigned long) acb;=0A=
-		acb->eternal_timer.function =3D=0A=
-			&arcmsr_request_device_map;=0A=
-		add_timer(&acb->eternal_timer);=0A=
-		return 0;=0A=
+	} else if (pci_find_capability(pdev, PCI_CAP_ID_MSI)) {=0A=
+		if (!pci_enable_msi(pdev))=0A=
+			acb->acb_flags |=3D ACB_F_MSI_ENABLED;=0A=
+		if (request_irq(pdev->irq, arcmsr_do_interrupt,=0A=
+			IRQF_SHARED, "arcmsr", acb)) {=0A=
+			goto controller_stop;=0A=
+		}=0A=
+	} else {=0A=
+		if (request_irq(pdev->irq, arcmsr_do_interrupt,=0A=
+			IRQF_SHARED, "arcmsr", acb)) {=0A=
+			goto controller_stop;=0A=
+		}=0A=
+	}=0A=
+	arcmsr_iop_init(acb);=0A=
+	INIT_WORK(&acb->arcmsr_do_message_isr_bh,=0A=
+	arcmsr_message_isr_bh_fn);=0A=
+	atomic_set(&acb->rq_map_token, 16);=0A=
+	atomic_set(&acb->ante_token_value, 16);=0A=
+	acb->fw_flag =3D FW_NORMAL;=0A=
+	init_timer(&acb->eternal_timer);=0A=
+	acb->eternal_timer.expires =3D jiffies +=0A=
+		msecs_to_jiffies(6 * HZ);=0A=
+	acb->eternal_timer.data =3D (unsigned long) acb;=0A=
+	acb->eternal_timer.function =3D=0A=
+		&arcmsr_request_device_map;=0A=
+	add_timer(&acb->eternal_timer);=0A=
+	return 0;=0A=
 controller_stop:=0A=
-			arcmsr_stop_adapter_bgrb(acb);=0A=
-			arcmsr_flush_adapter_cache(acb);=0A=
+		arcmsr_stop_adapter_bgrb(acb);=0A=
+		arcmsr_flush_adapter_cache(acb);=0A=
 controller_unregister:=0A=
-			scsi_remove_host(host);=0A=
-			arcmsr_free_ccb_pool(acb);=0A=
-			arcmsr_unmap_pciregion(acb);=0A=
-			pci_release_regions(pdev);=0A=
-			scsi_host_put(host);=0A=
-			pci_disable_device(pdev);=0A=
-		return -ENODEV;=0A=
-	}=0A=
-#endif=0A=
+		scsi_remove_host(host);=0A=
+		arcmsr_free_ccb_pool(acb);=0A=
+		arcmsr_unmap_pciregion(acb);=0A=
+		pci_release_regions(pdev);=0A=
+		scsi_host_put(host);=0A=
+		pci_disable_device(pdev);=0A=
+	return -ENODEV;=0A=
+}=0A=
 =0A=
 static int arcmsr_probe(struct pci_dev *pdev, const struct =
pci_device_id *id)=0A=
 {=0A=
@@ -845,12 +1096,17 @@ static int arcmsr_probe(struct pci_dev *=0A=
 		goto scsi_host_release;=0A=
 	spin_lock_init(&acb->eh_lock);=0A=
 	spin_lock_init(&acb->ccblist_lock);=0A=
+	spin_lock_init(&acb->postq_lock);=0A=
+	spin_lock_init(&acb->rqbuffer_lock);=0A=
+	spin_lock_init(&acb->wqbuffer_lock);=0A=
 	acb->acb_flags |=3D (ACB_F_MESSAGE_WQBUFFER_CLEARED |=0A=
 			ACB_F_MESSAGE_RQBUFFER_CLEARED |=0A=
 			ACB_F_MESSAGE_WQBUFFER_READED);=0A=
 	acb->acb_flags &=3D ~ACB_F_SCSISTOPADAPTER;=0A=
 	INIT_LIST_HEAD(&acb->ccb_free_list);=0A=
-	arcmsr_define_adapter_type(acb);=0A=
+	error =3D arcmsr_define_adapter_type(acb);=0A=
+	if (!error)=0A=
+		goto pci_release_regs;=0A=
 	error =3D arcmsr_remap_pciregion(acb);=0A=
 	if (!error)=0A=
 		goto pci_release_regs;=0A=
@@ -860,7 +1116,6 @@ static int arcmsr_probe(struct pci_dev *=0A=
 	error =3D arcmsr_alloc_ccb_pool(acb);=0A=
 	if (error)=0A=
 		goto free_hbb_mu;=0A=
-	arcmsr_iop_init(acb);=0A=
 	error =3D scsi_add_host(host, &pdev->dev);=0A=
 	if (error)=0A=
 		goto RAID_controller_stop;=0A=
@@ -905,7 +1160,8 @@ static int arcmsr_probe(struct pci_dev *=0A=
 		}=0A=
 	}=0A=
 	host->irq =3D pdev->irq;=0A=
-    	scsi_scan_host(host);=0A=
+	arcmsr_iop_init(acb);=0A=
+	scsi_scan_host(host);=0A=
 	INIT_WORK(&acb->arcmsr_do_message_isr_bh,=0A=
 		arcmsr_message_isr_bh_fn);=0A=
 	atomic_set(&acb->rq_map_token, 16);=0A=
@@ -934,7 +1190,7 @@ RAID_controller_stop:=0A=
 	arcmsr_flush_adapter_cache(acb);=0A=
 	arcmsr_free_ccb_pool(acb);=0A=
 free_hbb_mu:=0A=
-	arcmsr_free_hbb_mu(acb);=0A=
+	arcmsr_free_mu(acb);=0A=
 unmap_pci_region:=0A=
 	arcmsr_unmap_pciregion(acb);=0A=
 pci_release_regs:=0A=
@@ -954,7 +1210,7 @@ arcmsr_hbaA_abort_allcmd(struct AdapterC=0A=
 		&reg->inbound_msgaddr0);=0A=
 	if (!arcmsr_hbaA_wait_msgint_ready(acb)) {=0A=
 		pr_notice("arcmsr%d: wait 'abort all outstanding"=0A=
-			"command' timeout\n"=0A=
+		"command' timeout\n"=0A=
 		, acb->host->host_no);=0A=
 		return false;=0A=
 	}=0A=
@@ -970,7 +1226,7 @@ arcmsr_hbaB_abort_allcmd(struct AdapterC=0A=
 		reg->drv2iop_doorbell);=0A=
 	if (!arcmsr_hbaB_wait_msgint_ready(acb)) {=0A=
 		pr_notice("arcmsr%d: wait 'abort all outstanding"=0A=
-			"command' timeout\n"=0A=
+		"command' timeout\n"=0A=
 		, acb->host->host_no);=0A=
 		return false;=0A=
 	}=0A=
@@ -984,7 +1240,20 @@ arcmsr_hbaC_abort_allcmd(struct AdapterC=0A=
 	writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);=0A=
 	if (!arcmsr_hbaC_wait_msgint_ready(pACB)) {=0A=
 		pr_notice("arcmsr%d: wait 'abort all outstanding"=0A=
-			"command' timeout\n"=0A=
+		"command' timeout\n"=0A=
+		, pACB->host->host_no);=0A=
+		return false;=0A=
+	}=0A=
+	return true;=0A=
+}=0A=
+static uint8_t=0A=
+arcmsr_hbaD_abort_allcmd(struct AdapterControlBlock *pACB)=0A=
+{=0A=
+	struct MessageUnit_D __iomem *reg =3D (struct MessageUnit_D =
*)pACB->pmuD;=0A=
+	writel(ARCMSR_INBOUND_MESG0_ABORT_CMD, reg->inbound_msgaddr0);=0A=
+	if (!arcmsr_hbaD_wait_msgint_ready(pACB)) {=0A=
+		pr_notice("arcmsr%d: wait 'abort all outstanding"=0A=
+		"command' timeout\n"=0A=
 		, pACB->host->host_no);=0A=
 		return false;=0A=
 	}=0A=
@@ -1008,6 +1277,10 @@ arcmsr_abort_allcmd(struct AdapterContro=0A=
 	case ACB_ADAPTER_TYPE_C: {=0A=
 		rtnval =3D arcmsr_hbaC_abort_allcmd(acb);=0A=
 		}=0A=
+		break;=0A=
+	case ACB_ADAPTER_TYPE_D: {=0A=
+		rtnval =3D arcmsr_hbaD_abort_allcmd(acb);=0A=
+	}=0A=
 	}=0A=
 	return rtnval;=0A=
 }=0A=
@@ -1088,14 +1361,23 @@ arcmsr_disable_outbound_ints(struct Adap=0A=
 		}=0A=
 		break;=0A=
 	case ACB_ADAPTER_TYPE_C: {=0A=
-		struct MessageUnit_C *reg =3D=0A=
+		struct MessageUnit_C __iomem *reg =3D=0A=
 			(struct MessageUnit_C *)acb->pmuC;=0A=
 		/* disable all outbound interrupt */=0A=
 		orig_mask =3D readl(&reg->host_int_mask);=0A=
 		writel(orig_mask | ARCMSR_HBCMU_ALL_INTMASKENABLE,=0A=
 			&reg->host_int_mask);=0A=
+		readl(&reg->host_int_mask);=0A=
 		}=0A=
 		break;=0A=
+	case ACB_ADAPTER_TYPE_D: {=0A=
+		struct MessageUnit_D __iomem *reg =3D=0A=
+			(struct MessageUnit_D *)acb->pmuD;=0A=
+		/* disable all outbound interrupt */=0A=
+		writel(ARCMSR_ARC1214_ALL_INT_DISABLE,=0A=
+		reg->pcief0_int_enable);=0A=
+		break;=0A=
+	}=0A=
 	}=0A=
 	return orig_mask;=0A=
 }=0A=
@@ -1139,7 +1421,7 @@ arcmsr_report_ccb_state(struct AdapterCo=0A=
 =0A=
 		default:=0A=
 			pr_notice("arcmsr%d: scsi id =3D %d lun =3D %d"=0A=
-				"isr get command error done, but got unknown"=0A=
+			"isr get command error done, but got unknown"=0A=
 			"DeviceStatus =3D 0x%x\n"=0A=
 			, acb->host->host_no=0A=
 			, id=0A=
@@ -1155,34 +1437,24 @@ arcmsr_report_ccb_state(struct AdapterCo=0A=
 =0A=
 static void=0A=
 arcmsr_drain_donequeue(struct AdapterControlBlock *acb,=0A=
-struct CommandControlBlock *pCCB, bool error)=0A=
+	struct CommandControlBlock *pCCB, bool error)=0A=
 {=0A=
-	int id, lun;=0A=
 	if ((pCCB->acb !=3D acb) || (pCCB->startdone !=3D ARCMSR_CCB_START)) {=0A=
-		if (pCCB->startdone =3D=3D ARCMSR_CCB_ABORTED) {=0A=
-			struct scsi_cmnd *abortcmd =3D pCCB->pcmd;=0A=
-			if (abortcmd) {=0A=
-				id =3D abortcmd->device->id;=0A=
-				lun =3D abortcmd->device->lun;=0A=
-				abortcmd->result |=3D DID_ABORT << 16;=0A=
-				arcmsr_ccb_complete(pCCB);=0A=
-				pr_notice("arcmsr%d: pCCB =3D '0x%p' isr"=0A=
-				"got aborted command\n",=0A=
-				acb->host->host_no, pCCB);=0A=
-			}=0A=
-			return;=0A=
-		}=0A=
-		pr_notice("arcmsr%d: isr get an illegal ccb command"=0A=
-			"done acb =3D '0x%p'"=0A=
-			"ccb =3D '0x%p' ccbacb =3D '0x%p' startdone =3D 0x%x"=0A=
-			"ccboutstandingcount =3D %d\n"=0A=
-				, acb->host->host_no=0A=
-				, acb=0A=
-				, pCCB=0A=
-				, pCCB->acb=0A=
-				, pCCB->startdone=0A=
-				, atomic_read(&acb->ccboutstandingcount));=0A=
-		  return;=0A=
+		pr_notice("arcmsr%d: isr get an illegal ccb"=0A=
+		"command done acb =3D 0x%p,"=0A=
+		"ccb =3D 0x%p,"=0A=
+		"ccbacb =3D 0x%p,"=0A=
+		"startdone =3D 0x%x,"=0A=
+		"pscsi_cmd =3D 0x%p,"=0A=
+		"ccboutstandingcount =3D %d\n"=0A=
+		, acb->host->host_no=0A=
+		, acb=0A=
+		, pCCB=0A=
+		, pCCB->acb=0A=
+		, pCCB->startdone=0A=
+		, pCCB->pcmd=0A=
+		, atomic_read(&acb->ccboutstandingcount));=0A=
+		return;=0A=
 	}=0A=
 	arcmsr_report_ccb_state(acb, pCCB, error);=0A=
 }=0A=
@@ -1223,7 +1495,8 @@ arcmsr_done4abort_postqueue(struct Adapt=0A=
 		writel(ARCMSR_DOORBELL_INT_CLEAR_PATTERN,=0A=
 			reg->iop2drv_doorbell);=0A=
 		for (i =3D 0; i < ARCMSR_MAX_HBB_POSTQUEUE; i++) {=0A=
-			if ((flag_ccb =3D readl(&reg->done_qbuffer[i])) !=3D 0) {=0A=
+			flag_ccb =3D readl(&reg->done_qbuffer[i]);=0A=
+			if (flag_ccb !=3D 0) {=0A=
 				writel(0, &reg->done_qbuffer[i]);=0A=
 				pARCMSR_CDB =3D (struct ARCMSR_CDB *)=0A=
 				(acb->vir2phy_offset + (flag_ccb << 5));=0A=
@@ -1256,10 +1529,65 @@ arcmsr_done4abort_postqueue(struct Adapt=0A=
 				(acb->vir2phy_offset+ccb_cdb_phy);=0A=
 			pCCB =3D container_of(pARCMSR_CDB,=0A=
 				struct CommandControlBlock, arcmsr_cdb);=0A=
-			error =3D (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1)=0A=
+			error =3D (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1)=0A=
+				? true : false;=0A=
+			arcmsr_drain_donequeue(acb, pCCB, error);=0A=
+		}=0A=
+		}=0A=
+		break;=0A=
+	case ACB_ADAPTER_TYPE_D: {=0A=
+		struct MessageUnit_D __iomem *pmu =3D acb->pmuD;=0A=
+		uint32_t ccb_cdb_phy, outbound_write_pointer;=0A=
+		uint32_t doneq_index, index_stripped, addressLow, residual;=0A=
+		bool error;=0A=
+		struct CommandControlBlock *pCCB;=0A=
+		outbound_write_pointer =3D=0A=
+			readl(pmu->outboundlist_copy_pointer);=0A=
+		doneq_index =3D pmu->doneq_index;=0A=
+		residual =3D atomic_read(&acb->ccboutstandingcount);=0A=
+		for (i =3D 0; i < residual; i++) {=0A=
+			while ((doneq_index & 0xFF) !=3D=0A=
+				(outbound_write_pointer & 0xFF)) {=0A=
+				if (doneq_index & 0x4000) {=0A=
+					index_stripped =3D doneq_index & 0xFF;=0A=
+					index_stripped +=3D 1;=0A=
+					index_stripped %=3D=0A=
+					ARCMSR_MAX_ARC1214_POSTQUEUE;=0A=
+					pmu->doneq_index =3D index_stripped ?=0A=
+					(index_stripped | 0x4000) :=0A=
+					index_stripped;=0A=
+				} else {=0A=
+					index_stripped =3D doneq_index;=0A=
+					index_stripped +=3D 1;=0A=
+					index_stripped %=3D=0A=
+					ARCMSR_MAX_ARC1214_POSTQUEUE;=0A=
+					pmu->doneq_index =3D=0A=
+					index_stripped ? index_stripped :=0A=
+					(index_stripped | 0x4000);=0A=
+				}=0A=
+				doneq_index =3D pmu->doneq_index;=0A=
+				addressLow =3D=0A=
+				pmu->done_qbuffer[doneq_index & 0xFF].addressLow;=0A=
+				ccb_cdb_phy =3D (addressLow & 0xFFFFFFF0);=0A=
+				pARCMSR_CDB =3D (struct  ARCMSR_CDB *)=0A=
+				(acb->vir2phy_offset + ccb_cdb_phy);=0A=
+				pCCB =3D container_of(pARCMSR_CDB,=0A=
+				struct CommandControlBlock, arcmsr_cdb);=0A=
+				error =3D=0A=
+				(addressLow & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1)=0A=
 				? true : false;=0A=
-			arcmsr_drain_donequeue(acb, pCCB, error);=0A=
+				arcmsr_drain_donequeue(acb, pCCB, error);=0A=
+				writel(doneq_index,=0A=
+					pmu->outboundlist_read_pointer);=0A=
+			}=0A=
+			mdelay(10);=0A=
+			outbound_write_pointer =3D=0A=
+				readl(pmu->outboundlist_copy_pointer);=0A=
+			doneq_index =3D pmu->doneq_index;=0A=
 		}=0A=
+		pmu->postq_index =3D 0;=0A=
+		pmu->doneq_index =3D 0x40FF;=0A=
+		break;=0A=
 	}=0A=
 	}=0A=
 }=0A=
@@ -1270,7 +1598,7 @@ arcmsr_remove(struct pci_dev *pdev)=0A=
 	struct Scsi_Host *host =3D pci_get_drvdata(pdev);=0A=
 	struct AdapterControlBlock *acb =3D=0A=
 		(struct AdapterControlBlock *)host->hostdata;=0A=
-	int poll_count =3D 0;=0A=
+	int poll_count =3D 0, i;=0A=
 	arcmsr_free_sysfs_attr(acb);=0A=
 	scsi_remove_host(host);=0A=
 	flush_work_sync(&acb->arcmsr_do_message_isr_bh);=0A=
@@ -1290,7 +1618,6 @@ arcmsr_remove(struct pci_dev *pdev)=0A=
 	}=0A=
 =0A=
 	if (atomic_read(&acb->ccboutstandingcount)) {=0A=
-		int i;=0A=
 		arcmsr_abort_allcmd(acb);=0A=
 		arcmsr_done4abort_postqueue(acb);=0A=
 		for (i =3D 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {=0A=
@@ -1303,9 +1630,17 @@ arcmsr_remove(struct pci_dev *pdev)=0A=
 			}=0A=
 		}=0A=
 	}=0A=
-	free_irq(pdev->irq, acb);=0A=
 	arcmsr_free_ccb_pool(acb);=0A=
-	arcmsr_free_hbb_mu(acb);=0A=
+	arcmsr_free_mu(acb);=0A=
+	if (acb->acb_flags & ACB_F_MSI_ENABLED) {=0A=
+		free_irq(pdev->irq, acb);=0A=
+		pci_disable_msi(pdev);=0A=
+	} else if (acb->acb_flags & ACB_F_MSIX_ENABLED) {=0A=
+		for (i =3D 0; i < ARCMST_NUM_MSIX_VECTORS; i++)=0A=
+			free_irq(acb->entries[i].vector, acb);=0A=
+		pci_disable_msix(pdev);=0A=
+	} else=0A=
+		free_irq(pdev->irq, acb);=0A=
 	arcmsr_unmap_pciregion(acb);=0A=
 	pci_release_regions(pdev);=0A=
 	scsi_host_put(host);=0A=
@@ -1316,11 +1651,18 @@ arcmsr_remove(struct pci_dev *pdev)=0A=
 static void=0A=
 arcmsr_shutdown(struct pci_dev *pdev)=0A=
 {=0A=
+	int i;=0A=
 	struct Scsi_Host *host =3D pci_get_drvdata(pdev);=0A=
 	struct AdapterControlBlock *acb =3D=0A=
 		(struct AdapterControlBlock *)host->hostdata;=0A=
 	del_timer_sync(&acb->eternal_timer);=0A=
 	arcmsr_disable_outbound_ints(acb);=0A=
+	if (acb->acb_flags & ACB_F_MSIX_ENABLED) {=0A=
+		for (i =3D 0; i < ARCMST_NUM_MSIX_VECTORS; i++)=0A=
+			free_irq(acb->entries[i].vector, acb);=0A=
+		pci_disable_msix(pdev);=0A=
+	} else=0A=
+		free_irq(pdev->irq, acb);=0A=
 	flush_work_sync(&acb->arcmsr_do_message_isr_bh);=0A=
 	arcmsr_stop_adapter_bgrb(acb);=0A=
 	arcmsr_flush_adapter_cache(acb);=0A=
@@ -1371,7 +1713,7 @@ arcmsr_enable_outbound_ints(struct Adapt=0A=
 		}=0A=
 		break;=0A=
 	case ACB_ADAPTER_TYPE_C: {=0A=
-		struct MessageUnit_C *reg =3D acb->pmuC;=0A=
+		struct MessageUnit_C __iomem *reg =3D acb->pmuC;=0A=
 		mask =3D ~(ARCMSR_HBCMU_UTILITY_A_ISR_MASK |=0A=
 			ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR_MASK |=0A=
 			ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR_MASK);=0A=
@@ -1379,6 +1721,12 @@ arcmsr_enable_outbound_ints(struct Adapt=0A=
 		acb->outbound_int_enable =3D ~(intmask_org & mask) &=0A=
 			0x0000000f;=0A=
 		}=0A=
+		break;=0A=
+	case ACB_ADAPTER_TYPE_D: {=0A=
+		struct MessageUnit_D __iomem *reg =3D acb->pmuD;=0A=
+		mask =3D ARCMSR_ARC1214_ALL_INT_ENABLE;=0A=
+		writel(intmask_org | mask, reg->pcief0_int_enable);=0A=
+	}=0A=
 	}=0A=
 }=0A=
 =0A=
@@ -1400,7 +1748,6 @@ arcmsr_build_ccb(struct AdapterControlBl=0A=
 	arcmsr_cdb->TargetID =3D pcmd->device->id;=0A=
 	arcmsr_cdb->LUN =3D pcmd->device->lun;=0A=
 	arcmsr_cdb->Function =3D 1;=0A=
-	arcmsr_cdb->Context =3D 0;=0A=
 	memcpy(arcmsr_cdb->Cdb, pcmd->cmnd, pcmd->cmd_len);=0A=
 =0A=
 	nseg =3D scsi_dma_map(pcmd);=0A=
@@ -1445,9 +1792,10 @@ static void=0A=
 arcmsr_post_ccb(struct AdapterControlBlock *acb,=0A=
 	struct CommandControlBlock *ccb)=0A=
 {=0A=
-	uint32_t cdb_phyaddr_pattern =3D ccb->cdb_phyaddr_pattern;=0A=
+	uint32_t cdb_phyaddr =3D ccb->cdb_phyaddr;=0A=
 	struct ARCMSR_CDB *arcmsr_cdb =3D=0A=
 		(struct ARCMSR_CDB *)&ccb->arcmsr_cdb;=0A=
+	u32 arccdbsize =3D ccb->arc_cdb_size;=0A=
 	atomic_inc(&acb->ccboutstandingcount);=0A=
 	ccb->startdone =3D ARCMSR_CCB_START;=0A=
 	switch (acb->adapter_type) {=0A=
@@ -1455,12 +1803,11 @@ arcmsr_post_ccb(struct AdapterControlBlo=0A=
 		struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
 =0A=
 		if (arcmsr_cdb->Flags & ARCMSR_CDB_FLAG_SGL_BSIZE)=0A=
-			writel(cdb_phyaddr_pattern |=0A=
+			writel(cdb_phyaddr |=0A=
 			ARCMSR_CCBPOST_FLAG_SGL_BSIZE,=0A=
 			&reg->inbound_queueport);=0A=
 		else {=0A=
-				writel(cdb_phyaddr_pattern,=0A=
-				&reg->inbound_queueport);=0A=
+			writel(cdb_phyaddr, &reg->inbound_queueport);=0A=
 		}=0A=
 		}=0A=
 		break;=0A=
@@ -1473,11 +1820,11 @@ arcmsr_post_ccb(struct AdapterControlBlo=0A=
 			ARCMSR_MAX_HBB_POSTQUEUE);=0A=
 		writel(0, &reg->post_qbuffer[ending_index]);=0A=
 		if (arcmsr_cdb->Flags & ARCMSR_CDB_FLAG_SGL_BSIZE) {=0A=
-			writel(cdb_phyaddr_pattern |=0A=
+			writel(cdb_phyaddr |=0A=
 			ARCMSR_CCBPOST_FLAG_SGL_BSIZE,=0A=
 			 &reg->post_qbuffer[index]);=0A=
 		} else {=0A=
-			writel(cdb_phyaddr_pattern,=0A=
+			writel(cdb_phyaddr,=0A=
 				&reg->post_qbuffer[index]);=0A=
 		}=0A=
 		index++;=0A=
@@ -1494,7 +1841,7 @@ arcmsr_post_ccb(struct AdapterControlBlo=0A=
 =0A=
 		arc_cdb_size =3D (ccb->arc_cdb_size > 0x300)=0A=
 			? 0x300 : ccb->arc_cdb_size;=0A=
-		ccb_post_stamp =3D (cdb_phyaddr_pattern |=0A=
+		ccb_post_stamp =3D (cdb_phyaddr |=0A=
 			((arc_cdb_size - 1) >> 6) | 1);=0A=
 		if (acb->cdb_phyaddr_hi32) {=0A=
 			writel(acb->cdb_phyaddr_hi32,=0A=
@@ -1506,38 +1853,65 @@ arcmsr_post_ccb(struct AdapterControlBlo=0A=
 			&phbcmu->inbound_queueport_low);=0A=
 		}=0A=
 		}=0A=
+		break;=0A=
+	case ACB_ADAPTER_TYPE_D: {=0A=
+		struct MessageUnit_D *pmu =3D acb->pmuD;=0A=
+		u16 index_stripped;=0A=
+		u16 postq_index;=0A=
+		unsigned long flags;=0A=
+		struct InBound_SRB *pinbound_srb;=0A=
+		spin_lock_irqsave(&acb->postq_lock, flags);=0A=
+		postq_index =3D pmu->postq_index;=0A=
+		pinbound_srb =3D (struct InBound_SRB *)&pmu->post_qbuffer[postq_index =
& 0xFF];=0A=
+		pinbound_srb->addressHigh =3D dma_addr_hi32(cdb_phyaddr);=0A=
+		pinbound_srb->addressLow =3D dma_addr_lo32(cdb_phyaddr);=0A=
+		pinbound_srb->length =3D arccdbsize / 4;=0A=
+		arcmsr_cdb->msgContext =3D dma_addr_lo32(cdb_phyaddr);=0A=
+		if (postq_index & 0x4000) {=0A=
+			index_stripped =3D postq_index & 0xFF;=0A=
+			index_stripped +=3D 1;=0A=
+			index_stripped %=3D ARCMSR_MAX_ARC1214_POSTQUEUE;=0A=
+			pmu->postq_index =3D index_stripped ? (index_stripped | 0x4000) : =
index_stripped;=0A=
+		} else {=0A=
+			index_stripped =3D postq_index;=0A=
+			index_stripped +=3D 1;=0A=
+			index_stripped %=3D ARCMSR_MAX_ARC1214_POSTQUEUE;=0A=
+			pmu->postq_index =3D index_stripped ? index_stripped : =
(index_stripped | 0x4000);=0A=
+		}=0A=
+		writel(postq_index, pmu->inboundlist_write_pointer);=0A=
+		spin_unlock_irqrestore(&acb->postq_lock, flags);=0A=
+	}=0A=
 	}=0A=
 }=0A=
 =0A=
-static void arcmsr_stop_hba_bgrb(struct AdapterControlBlock *acb)=0A=
+static void arcmsr_hbaA_stop_bgrb(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
 	acb->acb_flags &=3D ~ACB_F_MSG_START_BGRB;=0A=
 	writel(ARCMSR_INBOUND_MESG0_STOP_BGRB, &reg->inbound_msgaddr0);=0A=
 	if (!arcmsr_hbaA_wait_msgint_ready(acb)) {=0A=
-		pr_notice("arcmsr%d: wait 'stop adapter background"=0A=
-		"rebulid' timeout\n"=0A=
+		pr_notice("arcmsr%d: wait 'stop adapter"=0A=
+		"background rebulid' timeout\n"=0A=
 		, acb->host->host_no);=0A=
 	}=0A=
 }=0A=
 =0A=
 static void=0A=
-arcmsr_stop_hbb_bgrb(struct AdapterControlBlock *acb)=0A=
+arcmsr_hbaB_stop_bgrb(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	struct MessageUnit_B *reg =3D acb->pmuB;=0A=
 	acb->acb_flags &=3D ~ACB_F_MSG_START_BGRB;=0A=
 	writel(ARCMSR_MESSAGE_STOP_BGRB, reg->drv2iop_doorbell);=0A=
 =0A=
 	if (!arcmsr_hbaB_wait_msgint_ready(acb)) {=0A=
-		pr_notice(=0A=
-		"arcmsr%d: wait 'stop adapter background"=0A=
-		"rebulid' timeout\n"=0A=
+		pr_notice("arcmsr%d: wait 'stop adapter"=0A=
+		"background rebulid' timeout\n"=0A=
 		, acb->host->host_no);=0A=
 	}=0A=
 }=0A=
 =0A=
 static void=0A=
-arcmsr_stop_hbc_bgrb(struct AdapterControlBlock *pACB)=0A=
+arcmsr_hbaC_stop_bgrb(struct AdapterControlBlock *pACB)=0A=
 {=0A=
 	struct MessageUnit_C *reg =3D (struct MessageUnit_C *)pACB->pmuC;=0A=
 	pACB->acb_flags &=3D ~ACB_F_MSG_START_BGRB;=0A=
@@ -1545,36 +1919,69 @@ arcmsr_stop_hbc_bgrb(struct AdapterContr=0A=
 	writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,=0A=
 		&reg->inbound_doorbell);=0A=
 	if (!arcmsr_hbaC_wait_msgint_ready(pACB)) {=0A=
+		pr_notice("arcmsr%d: wait 'stop adapter"=0A=
+		"background rebulid' timeout\n"=0A=
+		, pACB->host->host_no);=0A=
+	}=0A=
+	return;=0A=
+}=0A=
+=0A=
+static void=0A=
+arcmsr_hbaD_stop_bgrb(struct AdapterControlBlock *pACB)=0A=
+{=0A=
+	struct MessageUnit_D __iomem *reg =3D=0A=
+		(struct MessageUnit_D *)pACB->pmuD;=0A=
+=0A=
+	pACB->acb_flags &=3D ~ACB_F_MSG_START_BGRB;=0A=
+	writel(ARCMSR_INBOUND_MESG0_STOP_BGRB,=0A=
+		reg->inbound_msgaddr0);=0A=
+	if (!arcmsr_hbaD_wait_msgint_ready(pACB)) {=0A=
 		pr_notice("arcmsr%d: wait 'stop adapter background"=0A=
 		"rebulid' timeout\n"=0A=
 		, pACB->host->host_no);=0A=
 	}=0A=
 	return;=0A=
 }=0A=
+=0A=
 static void=0A=
 arcmsr_stop_adapter_bgrb(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	switch (acb->adapter_type) {=0A=
 	case ACB_ADAPTER_TYPE_A: {=0A=
-		arcmsr_stop_hba_bgrb(acb);=0A=
-		}=0A=
+		arcmsr_hbaA_stop_bgrb(acb);=0A=
 		break;=0A=
-=0A=
+	}=0A=
 	case ACB_ADAPTER_TYPE_B: {=0A=
-		arcmsr_stop_hbb_bgrb(acb);=0A=
-		}=0A=
+		arcmsr_hbaB_stop_bgrb(acb);=0A=
 		break;=0A=
+	}=0A=
 	case ACB_ADAPTER_TYPE_C: {=0A=
-		arcmsr_stop_hbc_bgrb(acb);=0A=
-		}=0A=
+		arcmsr_hbaC_stop_bgrb(acb);=0A=
+		break;=0A=
+	}=0A=
+	case ACB_ADAPTER_TYPE_D: {=0A=
+		arcmsr_hbaD_stop_bgrb(acb);=0A=
+		break;=0A=
+	}=0A=
 	}=0A=
 }=0A=
 =0A=
 static void=0A=
 arcmsr_free_ccb_pool(struct AdapterControlBlock *acb)=0A=
 {=0A=
-	dma_free_coherent(&acb->pdev->dev, acb->uncache_size,=0A=
-	acb->dma_coherent, acb->dma_coherent_handle);=0A=
+	switch (acb->adapter_type) {=0A=
+	case ACB_ADAPTER_TYPE_A:=0A=
+	case ACB_ADAPTER_TYPE_C:=0A=
+	case ACB_ADAPTER_TYPE_B:=0A=
+		dma_free_coherent(&acb->pdev->dev, acb->uncache_size,=0A=
+			acb->dma_coherent, acb->dma_coherent_handle);=0A=
+		break;=0A=
+	case ACB_ADAPTER_TYPE_D: {=0A=
+		dma_free_coherent(&acb->pdev->dev, acb->roundup_ccbsize,=0A=
+			acb->dma_coherent2, acb->dma_coherent_handle2);=0A=
+		break;=0A=
+	}=0A=
+	}=0A=
 }=0A=
 =0A=
 void=0A=
@@ -1596,9 +2003,15 @@ arcmsr_iop_message_read(struct AdapterCo=0A=
 		break;=0A=
 	case ACB_ADAPTER_TYPE_C: {=0A=
 		struct MessageUnit_C __iomem *reg =3D acb->pmuC;=0A=
-		writel(ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK,=0A=
-		&reg->inbound_doorbell);=0A=
+		writel(ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK, &reg->inbound_doorbell);=0A=
 		}=0A=
+		break;=0A=
+	case ACB_ADAPTER_TYPE_D: {=0A=
+		struct MessageUnit_D __iomem *reg =3D acb->pmuD;=0A=
+		writel(ARCMSR_ARC1214_DRV2IOP_DATA_OUT_READ,=0A=
+		reg->inbound_doorbell);=0A=
+		break;=0A=
+	}=0A=
 	}=0A=
 }=0A=
 =0A=
@@ -1637,6 +2050,12 @@ arcmsr_iop_message_wrote(struct AdapterC=0A=
 		&reg->inbound_doorbell);=0A=
 		}=0A=
 		break;=0A=
+	case ACB_ADAPTER_TYPE_D: {=0A=
+		struct MessageUnit_D __iomem *reg =3D acb->pmuD;=0A=
+		writel(ARCMSR_ARC1214_DRV2IOP_DATA_IN_READY,=0A=
+		reg->inbound_doorbell);=0A=
+		break;=0A=
+	}=0A=
 	}=0A=
 }=0A=
 =0A=
@@ -1662,6 +2081,13 @@ struct QBUFFER __iomem=0A=
 			(struct MessageUnit_C *)acb->pmuC;=0A=
 		qbuffer =3D (struct QBUFFER __iomem *)&phbcmu->message_rbuffer;=0A=
 		}=0A=
+		break;=0A=
+	case ACB_ADAPTER_TYPE_D: {=0A=
+		struct MessageUnit_D __iomem *reg =3D=0A=
+			(struct MessageUnit_D *)acb->pmuD;=0A=
+		qbuffer =3D (struct QBUFFER __iomem *)reg->message_rbuffer;=0A=
+		break;=0A=
+	}=0A=
 	}=0A=
 	return qbuffer;=0A=
 }=0A=
@@ -1686,6 +2112,13 @@ struct QBUFFER __iomem=0A=
 	case ACB_ADAPTER_TYPE_C: {=0A=
 		struct MessageUnit_C *reg =3D (struct MessageUnit_C *)acb->pmuC;=0A=
 		pqbuffer =3D (struct QBUFFER __iomem *)&reg->message_wbuffer;=0A=
+		}=0A=
+		break;=0A=
+	case ACB_ADAPTER_TYPE_D: {=0A=
+		struct MessageUnit_D __iomem *pmu =3D=0A=
+		(struct MessageUnit_D *)acb->pmuD;=0A=
+		pqbuffer =3D (struct QBUFFER __iomem *)pmu->message_wbuffer;=0A=
+		break;=0A=
 	}=0A=
 	}=0A=
 	return pqbuffer;=0A=
@@ -1694,10 +2127,13 @@ struct QBUFFER __iomem=0A=
 void=0A=
 arcmsr_iop2drv_data_wrote_handle(struct AdapterControlBlock *acb)=0A=
 {=0A=
+	uint8_t __iomem *iop_data;=0A=
 	struct QBUFFER __iomem *prbuffer;=0A=
 	struct QBUFFER *pQbuffer;=0A=
-	uint8_t __iomem *iop_data;=0A=
 	int32_t my_empty_len, iop_len, rqbuf_firstindex, rqbuf_lastindex;=0A=
+	unsigned long flags;=0A=
+=0A=
+	spin_lock_irqsave(&acb->rqbuffer_lock, flags);=0A=
 	rqbuf_lastindex =3D acb->rqbuf_lastindex;=0A=
 	rqbuf_firstindex =3D acb->rqbuf_firstindex;=0A=
 	prbuffer =3D arcmsr_get_iop_rqbuffer(acb);=0A=
@@ -1721,11 +2157,15 @@ arcmsr_iop2drv_data_wrote_handle(struct =0A=
 	} else {=0A=
 		acb->acb_flags |=3D ACB_F_IOPDATA_OVERFLOW;=0A=
 	}=0A=
+	spin_unlock_irqrestore(&acb->rqbuffer_lock, flags);=0A=
 }=0A=
 =0A=
 void=0A=
 arcmsr_iop2drv_data_read_handle(struct AdapterControlBlock *acb)=0A=
 {=0A=
+	unsigned long flags;=0A=
+=0A=
+	spin_lock_irqsave(&acb->wqbuffer_lock, flags);=0A=
 	acb->acb_flags |=3D ACB_F_MESSAGE_WQBUFFER_READED;=0A=
 	if (acb->wqbuf_firstindex !=3D acb->wqbuf_lastindex) {=0A=
 		uint8_t *pQbuffer;=0A=
@@ -1752,41 +2192,94 @@ arcmsr_iop2drv_data_read_handle(struct A=0A=
 	if (acb->wqbuf_firstindex =3D=3D acb->wqbuf_lastindex) {=0A=
 		acb->acb_flags |=3D ACB_F_MESSAGE_WQBUFFER_CLEARED;=0A=
 	}=0A=
+	spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);=0A=
 }=0A=
 =0A=
 static void=0A=
 arcmsr_hbaA_doorbell_isr(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	uint32_t outbound_doorbell;=0A=
-	struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
-	outbound_doorbell =3D readl(&reg->outbound_doorbell);=0A=
-	writel(outbound_doorbell, &reg->outbound_doorbell);=0A=
-	if (outbound_doorbell & ARCMSR_OUTBOUND_IOP331_DATA_WRITE_OK) {=0A=
-		arcmsr_iop2drv_data_wrote_handle(acb);=0A=
-	}=0A=
+	struct MessageUnit_A __iomem *reg  =3D acb->pmuA;=0A=
 =0A=
-	if (outbound_doorbell & ARCMSR_OUTBOUND_IOP331_DATA_READ_OK) {=0A=
-		arcmsr_iop2drv_data_read_handle(acb);=0A=
-	}=0A=
+	outbound_doorbell =3D readl(&reg->outbound_doorbell);=0A=
+	do {=0A=
+		writel(outbound_doorbell, &reg->outbound_doorbell);=0A=
+		if (outbound_doorbell &=0A=
+			ARCMSR_OUTBOUND_IOP331_DATA_WRITE_OK) {=0A=
+			arcmsr_iop2drv_data_wrote_handle(acb);=0A=
+		}=0A=
+		if (outbound_doorbell &=0A=
+			ARCMSR_OUTBOUND_IOP331_DATA_READ_OK) {=0A=
+			arcmsr_iop2drv_data_read_handle(acb);=0A=
+		}=0A=
+		outbound_doorbell =3D readl(&reg->outbound_doorbell);=0A=
+	} while (outbound_doorbell &=0A=
+	(ARCMSR_OUTBOUND_IOP331_DATA_WRITE_OK=0A=
+	| ARCMSR_OUTBOUND_IOP331_DATA_READ_OK));=0A=
 }=0A=
 static void=0A=
 arcmsr_hbaC_doorbell_isr(struct AdapterControlBlock *pACB)=0A=
 {=0A=
 	uint32_t outbound_doorbell;=0A=
-	struct MessageUnit_C *reg =3D (struct MessageUnit_C *)pACB->pmuC;=0A=
+	struct MessageUnit_C __iomem *reg =3D=0A=
+		(struct MessageUnit_C *)pACB->pmuC;=0A=
+=0A=
 	outbound_doorbell =3D readl(&reg->outbound_doorbell);=0A=
-	writel(outbound_doorbell, &reg->outbound_doorbell_clear);=0A=
-	if (outbound_doorbell & ARCMSR_HBCMU_IOP2DRV_DATA_WRITE_OK) {=0A=
+	do {=0A=
+		if (outbound_doorbell &=0A=
+			ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {=0A=
+			arcmsr_hbaC_message_isr(pACB);=0A=
+		}=0A=
+		writel(outbound_doorbell, &reg->outbound_doorbell_clear);=0A=
+		readl(&reg->outbound_doorbell_clear);=0A=
+		if (outbound_doorbell &=0A=
+			ARCMSR_HBCMU_IOP2DRV_DATA_WRITE_OK) {=0A=
+			arcmsr_iop2drv_data_wrote_handle(pACB);=0A=
+		}=0A=
+		if (outbound_doorbell &=0A=
+			ARCMSR_HBCMU_IOP2DRV_DATA_READ_OK) {=0A=
+			arcmsr_iop2drv_data_read_handle(pACB);=0A=
+		}=0A=
+		outbound_doorbell =3D readl(&reg->outbound_doorbell);=0A=
+	} while (outbound_doorbell & (ARCMSR_HBCMU_IOP2DRV_DATA_WRITE_OK=0A=
+	| ARCMSR_HBCMU_IOP2DRV_DATA_READ_OK=0A=
+	| ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE));=0A=
+	return;=0A=
+}=0A=
+=0A=
+static void=0A=
+arcmsr_hbaD_doorbell_isr(struct AdapterControlBlock *pACB)=0A=
+{=0A=
+	uint32_t outbound_doorbell;=0A=
+	struct MessageUnit_D __iomem *pmu =3D=0A=
+		(struct MessageUnit_D *)pACB->pmuD;=0A=
+=0A=
+	outbound_doorbell =3D readl(pmu->outbound_doorbell);=0A=
+	if (unlikely(!outbound_doorbell)) {=0A=
 		arcmsr_iop2drv_data_wrote_handle(pACB);=0A=
-	}=0A=
-	if (outbound_doorbell & ARCMSR_HBCMU_IOP2DRV_DATA_READ_OK) {=0A=
 		arcmsr_iop2drv_data_read_handle(pACB);=0A=
 	}=0A=
-	if (outbound_doorbell & ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {=0A=
-		arcmsr_hbaC_message_isr(pACB);=0A=
-	}=0A=
+	do {=0A=
+		writel(outbound_doorbell, pmu->outbound_doorbell);=0A=
+		if (outbound_doorbell &=0A=
+			ARCMSR_ARC1214_IOP2DRV_MESSAGE_CMD_DONE) {=0A=
+			arcmsr_hbaD_message_isr(pACB);=0A=
+		}=0A=
+		if (outbound_doorbell &=0A=
+			ARCMSR_ARC1214_IOP2DRV_DATA_WRITE_OK) {=0A=
+			arcmsr_iop2drv_data_wrote_handle(pACB);=0A=
+		}=0A=
+		if (outbound_doorbell &=0A=
+			ARCMSR_ARC1214_IOP2DRV_DATA_READ_OK) {=0A=
+			arcmsr_iop2drv_data_read_handle(pACB);=0A=
+		}=0A=
+		outbound_doorbell =3D readl(pmu->outbound_doorbell);=0A=
+	} while (outbound_doorbell & (ARCMSR_ARC1214_IOP2DRV_DATA_WRITE_OK=0A=
+	| ARCMSR_ARC1214_IOP2DRV_DATA_READ_OK=0A=
+	| ARCMSR_ARC1214_IOP2DRV_MESSAGE_CMD_DONE));=0A=
 	return;=0A=
 }=0A=
+=0A=
 static void=0A=
 arcmsr_hbaA_postqueue_isr(struct AdapterControlBlock *acb)=0A=
 {=0A=
@@ -1834,33 +2327,84 @@ arcmsr_hbaB_postqueue_isr(struct Adapter=0A=
 static void=0A=
 arcmsr_hbaC_postqueue_isr(struct AdapterControlBlock *acb)=0A=
 {=0A=
-	struct MessageUnit_C *phbcmu;=0A=
-	struct ARCMSR_CDB *arcmsr_cdb;=0A=
-	struct CommandControlBlock *ccb;=0A=
 	uint32_t flag_ccb, ccb_cdb_phy, throttling =3D 0;=0A=
 	int error;=0A=
+	struct MessageUnit_C __iomem *phbcmu;=0A=
+	struct ARCMSR_CDB *arcmsr_cdb;=0A=
+	struct CommandControlBlock *ccb;=0A=
 =0A=
 	phbcmu =3D (struct MessageUnit_C *)acb->pmuC;=0A=
 	/* areca cdb command done */=0A=
 	/* Use correct offset and size for syncing */=0A=
+	do {=0A=
+		/* check if command done with no error*/=0A=
+		flag_ccb =3D readl(&phbcmu->outbound_queueport_low);=0A=
+		ccb_cdb_phy =3D (flag_ccb & 0xFFFFFFF0);=0A=
+		arcmsr_cdb =3D (struct ARCMSR_CDB *)(acb->vir2phy_offset=0A=
+			+ ccb_cdb_phy);=0A=
+		ccb =3D container_of(arcmsr_cdb, struct CommandControlBlock,=0A=
+			arcmsr_cdb);=0A=
+		error =3D (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1)=0A=
+			? true : false;=0A=
+		/* check if command done with no error */=0A=
+		arcmsr_drain_donequeue(acb, ccb, error);=0A=
+		if (throttling =3D=3D ARCMSR_HBC_ISR_THROTTLING_LEVEL) {=0A=
+			writel(ARCMSR_HBCMU_DRV2IOP_POSTQUEUE_THROTTLING,=0A=
+				&phbcmu->inbound_doorbell);=0A=
+			continue;=0A=
+		}=0A=
+		throttling++;=0A=
+	} while (readl(&phbcmu->host_int_status) &=0A=
+	ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR);=0A=
+}=0A=
 =0A=
-	while (readl(&phbcmu->host_int_status) &=0A=
-	ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR) {=0A=
-	/* check if command done with no error*/=0A=
-	flag_ccb =3D readl(&phbcmu->outbound_queueport_low);=0A=
-	ccb_cdb_phy =3D (flag_ccb & 0xFFFFFFF0);=0A=
-	arcmsr_cdb =3D (struct ARCMSR_CDB *)(acb->vir2phy_offset + =
ccb_cdb_phy);=0A=
-	ccb =3D container_of(arcmsr_cdb, struct CommandControlBlock, =
arcmsr_cdb);=0A=
-	error =3D (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1) ? true : false;=0A=
-	/* check if command done with no error */=0A=
-	arcmsr_drain_donequeue(acb, ccb, error);=0A=
-	if (throttling =3D=3D ARCMSR_HBC_ISR_THROTTLING_LEVEL) {=0A=
-		writel(ARCMSR_HBCMU_DRV2IOP_POSTQUEUE_THROTTLING,=0A=
-		&phbcmu->inbound_doorbell);=0A=
-		break;=0A=
-	}=0A=
-	throttling++;=0A=
-	}=0A=
+static void=0A=
+arcmsr_hbaD_postqueue_isr(struct AdapterControlBlock *acb)=0A=
+{=0A=
+	u32 outbound_write_pointer, doneq_index, index_stripped;=0A=
+	uint32_t addressLow, ccb_cdb_phy;=0A=
+	int error;=0A=
+	struct MessageUnit_D __iomem *pmu;=0A=
+	struct ARCMSR_CDB *arcmsr_cdb;=0A=
+	struct CommandControlBlock *ccb;=0A=
+=0A=
+	pmu =3D (struct MessageUnit_D *)acb->pmuD;=0A=
+	outbound_write_pointer =3D readl(pmu->outboundlist_copy_pointer);=0A=
+	doneq_index =3D pmu->doneq_index;=0A=
+	if ((doneq_index & 0xFF) !=3D (outbound_write_pointer & 0xFF)) {=0A=
+		do {=0A=
+			if (doneq_index & 0x4000) {=0A=
+				index_stripped =3D doneq_index & 0xFF;=0A=
+				index_stripped +=3D 1;=0A=
+				index_stripped %=3D ARCMSR_MAX_ARC1214_POSTQUEUE;=0A=
+				pmu->doneq_index =3D index_stripped=0A=
+				? (index_stripped | 0x4000) : index_stripped;=0A=
+			} else {=0A=
+				index_stripped =3D doneq_index;=0A=
+				index_stripped +=3D 1;=0A=
+				index_stripped %=3D ARCMSR_MAX_ARC1214_POSTQUEUE;=0A=
+				pmu->doneq_index =3D index_stripped=0A=
+				? index_stripped : (index_stripped | 0x4000);=0A=
+			}=0A=
+			doneq_index =3D pmu->doneq_index;=0A=
+			addressLow =3D=0A=
+			pmu->done_qbuffer[doneq_index & 0xFF].addressLow;=0A=
+			ccb_cdb_phy =3D (addressLow & 0xFFFFFFF0);=0A=
+			arcmsr_cdb =3D (struct ARCMSR_CDB *)(acb->vir2phy_offset=0A=
+				+ ccb_cdb_phy);=0A=
+			ccb =3D container_of(arcmsr_cdb,=0A=
+				struct CommandControlBlock, arcmsr_cdb);=0A=
+			error =3D (addressLow & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1)=0A=
+				? true : false;=0A=
+			arcmsr_drain_donequeue(acb, ccb, error);=0A=
+			writel(doneq_index,=0A=
+				pmu->outboundlist_read_pointer);=0A=
+		} while ((doneq_index & 0xFF) !=3D=0A=
+		(outbound_write_pointer & 0xFF));=0A=
+	}=0A=
+	writel(ARCMSR_ARC1214_OUTBOUND_LIST_INTERRUPT_CLEAR,=0A=
+		pmu->outboundlist_interrupt_cause);=0A=
+	readl(pmu->outboundlist_interrupt_cause);=0A=
 }=0A=
 =0A=
 static void=0A=
@@ -1891,103 +2435,147 @@ arcmsr_hbaC_message_isr(struct AdapterCo=0A=
 	schedule_work(&acb->arcmsr_do_message_isr_bh);=0A=
 }=0A=
 =0A=
-static int=0A=
+static void=0A=
+arcmsr_hbaD_message_isr(struct AdapterControlBlock *acb)=0A=
+{=0A=
+	struct MessageUnit_D __iomem *reg  =3D acb->pmuD;=0A=
+	writel(ARCMSR_ARC1214_IOP2DRV_MESSAGE_CMD_DONE,=0A=
+		reg->outbound_doorbell);=0A=
+	readl(reg->outbound_doorbell);=0A=
+	schedule_work(&acb->arcmsr_do_message_isr_bh);=0A=
+}=0A=
+=0A=
+static irqreturn_t=0A=
 arcmsr_hbaA_handle_isr(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	uint32_t outbound_intstatus;=0A=
 	struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
-	outbound_intstatus =3D readl(&reg->outbound_intstatus) &=0A=
-		acb->outbound_int_enable;=0A=
+	outbound_intstatus =3D=0A=
+	readl(&reg->outbound_intstatus) & acb->outbound_int_enable;=0A=
 	if (!(outbound_intstatus & ARCMSR_MU_OUTBOUND_HANDLE_INT)) {=0A=
-		return 1;=0A=
+		return IRQ_NONE;=0A=
 	}=0A=
-	writel(outbound_intstatus, &reg->outbound_intstatus);=0A=
-	if (outbound_intstatus & ARCMSR_MU_OUTBOUND_DOORBELL_INT)=0A=
-		arcmsr_hbaA_doorbell_isr(acb);=0A=
-	if (outbound_intstatus & ARCMSR_MU_OUTBOUND_POSTQUEUE_INT)=0A=
-		arcmsr_hbaA_postqueue_isr(acb);=0A=
-	if (outbound_intstatus & ARCMSR_MU_OUTBOUND_MESSAGE0_INT)=0A=
-		arcmsr_hbaA_message_isr(acb);=0A=
-	return 0;=0A=
+	do {=0A=
+		writel(outbound_intstatus, &reg->outbound_intstatus);=0A=
+		readl(&reg->outbound_intstatus);=0A=
+		if (outbound_intstatus & ARCMSR_MU_OUTBOUND_DOORBELL_INT)=0A=
+			arcmsr_hbaA_doorbell_isr(acb);=0A=
+		if (outbound_intstatus & ARCMSR_MU_OUTBOUND_POSTQUEUE_INT)=0A=
+			arcmsr_hbaA_postqueue_isr(acb);=0A=
+		if (outbound_intstatus & ARCMSR_MU_OUTBOUND_MESSAGE0_INT)=0A=
+			arcmsr_hbaA_message_isr(acb);=0A=
+		outbound_intstatus =3D readl(&reg->outbound_intstatus) &=0A=
+			acb->outbound_int_enable;=0A=
+	} while (outbound_intstatus & (ARCMSR_MU_OUTBOUND_DOORBELL_INT=0A=
+	| ARCMSR_MU_OUTBOUND_POSTQUEUE_INT=0A=
+	| ARCMSR_MU_OUTBOUND_MESSAGE0_INT));=0A=
+	return IRQ_HANDLED;=0A=
 }=0A=
 =0A=
-static int=0A=
+static irqreturn_t=0A=
 arcmsr_hbaB_handle_isr(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	uint32_t outbound_doorbell;=0A=
 	struct MessageUnit_B *reg =3D acb->pmuB;=0A=
-	outbound_doorbell =3D readl(reg->iop2drv_doorbell) &=0A=
-	acb->outbound_int_enable;=0A=
+	outbound_doorbell =3D readl(reg->iop2drv_doorbell)=0A=
+		& acb->outbound_int_enable;=0A=
 	if (!outbound_doorbell)=0A=
-		return 1;=0A=
-=0A=
-	writel(~outbound_doorbell, reg->iop2drv_doorbell);=0A=
-	/*in case the last action of doorbell interrupt clearance is cached,=0A=
-	this action can push HW to write down the clear bit*/=0A=
-	readl(reg->iop2drv_doorbell);=0A=
-	writel(ARCMSR_DRV2IOP_END_OF_INTERRUPT,=0A=
-		reg->drv2iop_doorbell);=0A=
-	if (outbound_doorbell & ARCMSR_IOP2DRV_DATA_WRITE_OK) {=0A=
-		arcmsr_iop2drv_data_wrote_handle(acb);=0A=
-	}=0A=
-	if (outbound_doorbell & ARCMSR_IOP2DRV_DATA_READ_OK) {=0A=
-		arcmsr_iop2drv_data_read_handle(acb);=0A=
-	}=0A=
-	if (outbound_doorbell & ARCMSR_IOP2DRV_CDB_DONE) {=0A=
-		arcmsr_hbaB_postqueue_isr(acb);=0A=
-	}=0A=
-	if (outbound_doorbell &=0A=
-		ARCMSR_IOP2DRV_MESSAGE_CMD_DONE) {=0A=
-		/* messenger of "driver to iop commands" */=0A=
-		arcmsr_hbaB_message_isr(acb);=0A=
-	}=0A=
-	return 0;=0A=
+		return IRQ_NONE;=0A=
+	do {=0A=
+		writel(~outbound_doorbell, reg->iop2drv_doorbell);=0A=
+		readl(reg->iop2drv_doorbell);=0A=
+		writel(ARCMSR_DRV2IOP_END_OF_INTERRUPT,=0A=
+			reg->drv2iop_doorbell);=0A=
+		readl(reg->drv2iop_doorbell);=0A=
+		if (outbound_doorbell & ARCMSR_IOP2DRV_DATA_WRITE_OK)=0A=
+			arcmsr_iop2drv_data_wrote_handle(acb);=0A=
+		if (outbound_doorbell & ARCMSR_IOP2DRV_DATA_READ_OK)=0A=
+			arcmsr_iop2drv_data_read_handle(acb);=0A=
+		if (outbound_doorbell & ARCMSR_IOP2DRV_CDB_DONE)=0A=
+			arcmsr_hbaB_postqueue_isr(acb);=0A=
+		if (outbound_doorbell & ARCMSR_IOP2DRV_MESSAGE_CMD_DONE)=0A=
+			arcmsr_hbaB_message_isr(acb);=0A=
+		outbound_doorbell =3D readl(reg->iop2drv_doorbell) &=0A=
+			acb->outbound_int_enable;=0A=
+	} while (outbound_doorbell & (ARCMSR_IOP2DRV_DATA_WRITE_OK=0A=
+	| ARCMSR_IOP2DRV_DATA_READ_OK=0A=
+	| ARCMSR_IOP2DRV_CDB_DONE=0A=
+	| ARCMSR_IOP2DRV_MESSAGE_CMD_DONE));=0A=
+	return IRQ_HANDLED;=0A=
 }=0A=
 =0A=
-static int=0A=
+static irqreturn_t=0A=
 arcmsr_hbaC_handle_isr(struct AdapterControlBlock *pACB)=0A=
 {=0A=
 	uint32_t host_interrupt_status;=0A=
-	struct MessageUnit_C *phbcmu =3D=0A=
-	(struct MessageUnit_C *)pACB->pmuC;=0A=
-	host_interrupt_status =3D readl(&phbcmu->host_int_status);=0A=
-	if (!host_interrupt_status) {=0A=
-		/*it must be share irq*/=0A=
-		return 1;=0A=
-	}=0A=
-	/* MU ioctl transfer doorbell interrupts*/=0A=
-	if (host_interrupt_status &=0A=
-		ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR) {=0A=
-		arcmsr_hbaC_doorbell_isr(pACB);=0A=
-	}=0A=
-	/* MU post queue interrupts*/=0A=
-	if (host_interrupt_status &=0A=
-		ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR) {=0A=
-		arcmsr_hbaC_postqueue_isr(pACB);=0A=
-	}=0A=
-	return 0;=0A=
+	struct MessageUnit_C __iomem *phbcmu =3D=0A=
+		(struct MessageUnit_C *)pACB->pmuC;=0A=
+	host_interrupt_status =3D=0A=
+		readl(&phbcmu->host_int_status);=0A=
+	do {=0A=
+		if (host_interrupt_status &=0A=
+			ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR) {=0A=
+			arcmsr_hbaC_doorbell_isr(pACB);=0A=
+		}=0A=
+		/* MU post queue interrupts*/=0A=
+		if (host_interrupt_status &=0A=
+			ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR) {=0A=
+			arcmsr_hbaC_postqueue_isr(pACB);=0A=
+		}=0A=
+		host_interrupt_status =3D readl(&phbcmu->host_int_status);=0A=
+	} while (host_interrupt_status &=0A=
+	(ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR |=0A=
+	ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR));=0A=
+	return IRQ_HANDLED;=0A=
+}=0A=
+=0A=
+static irqreturn_t=0A=
+arcmsr_hbaD_handle_isr(struct AdapterControlBlock *pACB)=0A=
+{=0A=
+	u32 host_interrupt_status;=0A=
+	struct MessageUnit_D __iomem *pmu =3D=0A=
+		(struct MessageUnit_D *)pACB->pmuD;=0A=
+	host_interrupt_status =3D readl(pmu->host_int_status);=0A=
+	do {=0A=
+		/* MU post queue interrupts*/=0A=
+		if (host_interrupt_status &=0A=
+			ARCMSR_ARC1214_OUTBOUND_POSTQUEUE_ISR) {=0A=
+			arcmsr_hbaD_postqueue_isr(pACB);=0A=
+		}=0A=
+		if (host_interrupt_status &=0A=
+			ARCMSR_ARC1214_OUTBOUND_DOORBELL_ISR) {=0A=
+			arcmsr_hbaD_doorbell_isr(pACB);=0A=
+		}=0A=
+		host_interrupt_status =3D readl(pmu->host_int_status);=0A=
+	} while (host_interrupt_status &=0A=
+	(ARCMSR_ARC1214_OUTBOUND_POSTQUEUE_ISR |=0A=
+	ARCMSR_ARC1214_OUTBOUND_DOORBELL_ISR));=0A=
+	return IRQ_HANDLED;=0A=
 }=0A=
+=0A=
 static irqreturn_t=0A=
 arcmsr_interrupt(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	switch (acb->adapter_type) {=0A=
 	case ACB_ADAPTER_TYPE_A: {=0A=
-		if (arcmsr_hbaA_handle_isr(acb))=0A=
-			return IRQ_NONE;=0A=
-		}=0A=
+		return arcmsr_hbaA_handle_isr(acb);=0A=
 		break;=0A=
-=0A=
+	}=0A=
 	case ACB_ADAPTER_TYPE_B: {=0A=
-		if (arcmsr_hbaB_handle_isr(acb))=0A=
-			return IRQ_NONE;=0A=
-		}=0A=
+		return arcmsr_hbaB_handle_isr(acb);=0A=
 		break;=0A=
-	 case ACB_ADAPTER_TYPE_C: {=0A=
-		if (arcmsr_hbaC_handle_isr(acb))=0A=
-			return IRQ_NONE;=0A=
-		}=0A=
 	}=0A=
-	return IRQ_HANDLED;=0A=
+	case ACB_ADAPTER_TYPE_C: {=0A=
+		return arcmsr_hbaC_handle_isr(acb);=0A=
+		break;=0A=
+	}=0A=
+	case ACB_ADAPTER_TYPE_D: {=0A=
+		return arcmsr_hbaD_handle_isr(acb);=0A=
+		break;=0A=
+	}=0A=
+	default:=0A=
+		return IRQ_NONE;=0A=
+	}=0A=
 }=0A=
 =0A=
 static void=0A=
@@ -2009,11 +2597,11 @@ arcmsr_iop_parking(struct AdapterControl=0A=
 void=0A=
 arcmsr_post_ioctldata2iop(struct AdapterControlBlock *acb)=0A=
 {=0A=
-	int32_t wqbuf_firstindex, wqbuf_lastindex;=0A=
-	uint8_t *pQbuffer;=0A=
-	struct QBUFFER __iomem *pwbuffer;=0A=
 	uint8_t __iomem *iop_data;=0A=
+	uint8_t *pQbuffer;=0A=
+	int32_t wqbuf_firstindex, wqbuf_lastindex;=0A=
 	int32_t allxfer_len =3D 0;=0A=
+	struct QBUFFER __iomem *pwbuffer;=0A=
 	pwbuffer =3D arcmsr_get_iop_wqbuffer(acb);=0A=
 	iop_data =3D (uint8_t __iomem *)pwbuffer->data;=0A=
 	if (acb->acb_flags & ACB_F_MESSAGE_WQBUFFER_READED) {=0A=
@@ -2066,6 +2654,7 @@ arcmsr_iop_message_xfer(struct AdapterCo=0A=
 		unsigned char *ver_addr;=0A=
 		uint8_t *pQbuffer, *ptmpQbuffer;=0A=
 		int32_t allxfer_len =3D 0;=0A=
+		unsigned long flags;=0A=
 =0A=
 		ver_addr =3D kmalloc(1032, GFP_ATOMIC);=0A=
 		if (!ver_addr) {=0A=
@@ -2073,6 +2662,7 @@ arcmsr_iop_message_xfer(struct AdapterCo=0A=
 			goto message_out;=0A=
 		}=0A=
 		ptmpQbuffer =3D ver_addr;=0A=
+		spin_lock_irqsave(&acb->rqbuffer_lock, flags);=0A=
 		while ((acb->rqbuf_firstindex !=3D acb->rqbuf_lastindex)=0A=
 			&& (allxfer_len < 1031)) {=0A=
 			pQbuffer =3D &acb->rqbuffer[acb->rqbuf_firstindex];=0A=
@@ -2102,6 +2692,7 @@ arcmsr_iop_message_xfer(struct AdapterCo=0A=
 			}=0A=
 			arcmsr_iop_message_read(acb);=0A=
 		}=0A=
+		spin_unlock_irqrestore(&acb->rqbuffer_lock, flags);=0A=
 		memcpy(pcmdmessagefld->messagedatabuffer,=0A=
 		ver_addr, allxfer_len);=0A=
 		pcmdmessagefld->cmdmessage.Length =3D allxfer_len;=0A=
@@ -2121,6 +2712,7 @@ arcmsr_iop_message_xfer(struct AdapterCo=0A=
 		int32_t my_empty_len, user_len, wqbuf_firstindex,=0A=
 		wqbuf_lastindex;=0A=
 		uint8_t *pQbuffer, *ptmpuserbuffer;=0A=
+		unsigned long flags;=0A=
 =0A=
 		ver_addr =3D kmalloc(1032, GFP_ATOMIC);=0A=
 		if (!ver_addr) {=0A=
@@ -2138,6 +2730,7 @@ arcmsr_iop_message_xfer(struct AdapterCo=0A=
 		user_len =3D pcmdmessagefld->cmdmessage.Length;=0A=
 		memcpy(ptmpuserbuffer, pcmdmessagefld->messagedatabuffer,=0A=
 		user_len);=0A=
+		spin_lock_irqsave(&acb->wqbuffer_lock, flags);=0A=
 		wqbuf_lastindex =3D acb->wqbuf_lastindex;=0A=
 		wqbuf_firstindex =3D acb->wqbuf_firstindex;=0A=
 		if (wqbuf_lastindex !=3D wqbuf_firstindex) {=0A=
@@ -2183,6 +2776,7 @@ arcmsr_iop_message_xfer(struct AdapterCo=0A=
 				retvalue =3D ARCMSR_MESSAGE_FAIL;=0A=
 			}=0A=
 			}=0A=
+			spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);=0A=
 			kfree(ver_addr);=0A=
 		}=0A=
 		break;=0A=
@@ -2442,8 +3036,8 @@ arcmsr_hbaA_get_config(struct AdapterCon=0A=
 		&reg->inbound_msgaddr0);=0A=
 	if (!arcmsr_hbaA_wait_msgint_ready(acb)) {=0A=
 		pr_notice("arcmsr%d: wait 'get adapter firmware"=0A=
-			"miscellaneous data' timeout\n",=0A=
-			acb->host->host_no);=0A=
+		"miscellaneous data' timeout\n",=0A=
+		acb->host->host_no);=0A=
 		return false;=0A=
 	}=0A=
 	count =3D 8;=0A=
@@ -2508,7 +3102,7 @@ arcmsr_hbaB_get_config(struct AdapterCon=0A=
 		"got error for hbb mu\n", acb->host->host_no);=0A=
 		return false;=0A=
 	}=0A=
-	acb->dma_coherent_handle_hbb_mu =3D dma_coherent_handle;=0A=
+	acb->dma_coherent_handle2 =3D dma_coherent_handle;=0A=
 	reg =3D (struct MessageUnit_B *)dma_coherent;=0A=
 	acb->pmuB =3D reg;=0A=
 	reg->drv2iop_doorbell =3D (uint32_t __iomem *)=0A=
@@ -2604,22 +3198,147 @@ arcmsr_hbaC_get_config(struct AdapterCon=0A=
 		firmware_state =3D readl(&reg->outbound_msgaddr1);=0A=
 	} while ((firmware_state & ARCMSR_HBCMU_MESSAGE_FIRMWARE_OK) =3D=3D 0);=0A=
 	/* post "get config" instruction */=0A=
-	writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);=0A=
-	writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,=0A=
-		&reg->inbound_doorbell);=0A=
+	writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);=0A=
+	writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,=0A=
+		&reg->inbound_doorbell);=0A=
+	/* wait message ready */=0A=
+	for (Index =3D 0; Index < 2000; Index++) {=0A=
+		if (readl(&reg->outbound_doorbell) &=0A=
+		ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {=0A=
+			writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR,=0A=
+				&reg->outbound_doorbell_clear);=0A=
+			break;=0A=
+		}=0A=
+		udelay(10);=0A=
+	} /*max 1 seconds*/=0A=
+	if (Index >=3D 2000) {=0A=
+		pr_notice("arcmsr%d: wait 'get adapter firmware"=0A=
+		"miscellaneous data' timeout\n", pACB->host->host_no);=0A=
+		return false;=0A=
+	}=0A=
+	count =3D 8;=0A=
+	while (count) {=0A=
+		*acb_firm_model =3D readb(iop_firm_model);=0A=
+		acb_firm_model++;=0A=
+		iop_firm_model++;=0A=
+		count--;=0A=
+	}=0A=
+	count =3D 16;=0A=
+	while (count) {=0A=
+		*acb_firm_version =3D readb(iop_firm_version);=0A=
+		acb_firm_version++;=0A=
+		iop_firm_version++;=0A=
+		count--;=0A=
+	}=0A=
+	pr_notice("Areca RAID Controller%d: F/W %s &"=0A=
+	"Model %s\n",=0A=
+	pACB->host->host_no,=0A=
+	pACB->firm_version,=0A=
+	pACB->firm_model);=0A=
+	pACB->firm_request_len =3D readl(&reg->msgcode_rwbuffer[1]);=0A=
+	pACB->firm_numbers_queue =3D readl(&reg->msgcode_rwbuffer[2]);=0A=
+	pACB->firm_sdram_size =3D readl(&reg->msgcode_rwbuffer[3]);=0A=
+	pACB->firm_hd_channels =3D readl(&reg->msgcode_rwbuffer[4]);=0A=
+	pACB->firm_cfg_version =3D readl(&reg->msgcode_rwbuffer[25]);=0A=
+	/*all interrupt service will be enable at arcmsr_iop_init*/=0A=
+	return true;=0A=
+}=0A=
+=0A=
+static bool=0A=
+arcmsr_hbaD_get_config(struct AdapterControlBlock *acb)=0A=
+{=0A=
+	char *acb_firm_model =3D acb->firm_model;=0A=
+	char *acb_firm_version =3D acb->firm_version;=0A=
+	char *acb_device_map =3D acb->device_map;=0A=
+	char __iomem *iop_firm_model;=0A=
+	char __iomem *iop_firm_version;=0A=
+	char __iomem *iop_device_map;=0A=
+	u32 count;=0A=
+	struct MessageUnit_D *reg ;=0A=
+	void *dma_coherent;=0A=
+	dma_addr_t dma_coherent_handle;=0A=
+	struct pci_dev *pdev =3D acb->pdev;=0A=
+=0A=
+	acb->uncache_size =3D roundup(sizeof(struct MessageUnit_D), 32);=0A=
+	dma_coherent =3D dma_alloc_coherent(&pdev->dev, acb->uncache_size,=0A=
+	&dma_coherent_handle, GFP_KERNEL);=0A=
+	if (!dma_coherent) {=0A=
+		pr_notice("DMA allocation failed...\n");=0A=
+		return -ENOMEM;=0A=
+	}=0A=
+	memset(dma_coherent, 0, acb->uncache_size);=0A=
+	acb->dma_coherent =3D dma_coherent;=0A=
+	acb->dma_coherent_handle =3D dma_coherent_handle;=0A=
+	reg =3D (struct MessageUnit_D *)dma_coherent;=0A=
+	acb->pmuD =3D reg;=0A=
+	reg->chip_id =3D (u32 __iomem *)((unsigned long)=0A=
+	acb->mem_base0 + ARCMSR_ARC1214_CHIP_ID);=0A=
+	reg->cpu_mem_config =3D (u32 __iomem *)((unsigned long)=0A=
+	acb->mem_base0 + ARCMSR_ARC1214_CPU_MEMORY_CONFIGURATION);=0A=
+	reg->i2o_host_interrupt_mask =3D (u32 __iomem *)((unsigned long)=0A=
+	acb->mem_base0 + ARCMSR_ARC1214_I2_HOST_INTERRUPT_MASK);=0A=
+	reg->sample_at_reset =3D (u32 __iomem *)((unsigned long)=0A=
+	acb->mem_base0 + ARCMSR_ARC1214_SAMPLE_RESET);=0A=
+	reg->reset_request =3D (u32 __iomem *)((unsigned long)=0A=
+	acb->mem_base0 + ARCMSR_ARC1214_RESET_REQUEST);=0A=
+	reg->host_int_status =3D (u32 __iomem *)((unsigned long)=0A=
+	acb->mem_base0 + ARCMSR_ARC1214_MAIN_INTERRUPT_STATUS);=0A=
+	reg->pcief0_int_enable =3D (u32 __iomem *)((unsigned long)=0A=
+	acb->mem_base0 + ARCMSR_ARC1214_PCIE_F0_INTERRUPT_ENABLE);=0A=
+	reg->inbound_msgaddr0 =3D (u32 __iomem *)((unsigned long)=0A=
+	acb->mem_base0 + ARCMSR_ARC1214_INBOUND_MESSAGE0);=0A=
+	reg->inbound_msgaddr1 =3D (u32 __iomem *)((unsigned long)=0A=
+	acb->mem_base0 + ARCMSR_ARC1214_INBOUND_MESSAGE1);=0A=
+	reg->outbound_msgaddr0 =3D (u32 __iomem *)((unsigned long)=0A=
+	acb->mem_base0 + ARCMSR_ARC1214_OUTBOUND_MESSAGE0);=0A=
+	reg->outbound_msgaddr1 =3D (u32 __iomem *)((unsigned long)=0A=
+	acb->mem_base0 + ARCMSR_ARC1214_OUTBOUND_MESSAGE1);=0A=
+	reg->inbound_doorbell =3D (u32 __iomem *)((unsigned long)=0A=
+	acb->mem_base0 + ARCMSR_ARC1214_INBOUND_DOORBELL);=0A=
+	reg->outbound_doorbell =3D (u32 __iomem *)((unsigned long)=0A=
+	acb->mem_base0 + ARCMSR_ARC1214_OUTBOUND_DOORBELL);=0A=
+	reg->outbound_doorbell_enable =3D (u32 __iomem *)((unsigned long)=0A=
+	acb->mem_base0 + ARCMSR_ARC1214_OUTBOUND_DOORBELL_ENABLE);=0A=
+	reg->inboundlist_base_low =3D (u32 __iomem *)((unsigned long)=0A=
+	acb->mem_base0 + ARCMSR_ARC1214_INBOUND_LIST_BASE_LOW);=0A=
+	reg->inboundlist_base_high =3D (u32 __iomem *)((unsigned long)=0A=
+	acb->mem_base0 + ARCMSR_ARC1214_INBOUND_LIST_BASE_HIGH);=0A=
+	reg->inboundlist_write_pointer =3D (u32 __iomem *)((unsigned long)=0A=
+	acb->mem_base0 + ARCMSR_ARC1214_INBOUND_LIST_WRITE_POINTER);=0A=
+	reg->outboundlist_base_low =3D (u32 __iomem *)((unsigned long)=0A=
+	acb->mem_base0 + ARCMSR_ARC1214_OUTBOUND_LIST_BASE_LOW);=0A=
+	reg->outboundlist_base_high =3D (u32 __iomem *)((unsigned long)=0A=
+	acb->mem_base0 + ARCMSR_ARC1214_OUTBOUND_LIST_BASE_HIGH);=0A=
+	reg->outboundlist_copy_pointer =3D (u32 __iomem *)((unsigned long)=0A=
+	acb->mem_base0 + ARCMSR_ARC1214_OUTBOUND_LIST_COPY_POINTER);=0A=
+	reg->outboundlist_read_pointer =3D (u32 __iomem *)((unsigned long)=0A=
+	acb->mem_base0 + ARCMSR_ARC1214_OUTBOUND_LIST_READ_POINTER);=0A=
+	reg->outboundlist_interrupt_cause =3D (u32 __iomem *)((unsigned long)=0A=
+	acb->mem_base0 + ARCMSR_ARC1214_OUTBOUND_INTERRUPT_CAUSE);=0A=
+	reg->outboundlist_interrupt_enable =3D (u32 __iomem *)((unsigned long)=0A=
+	acb->mem_base0 + ARCMSR_ARC1214_OUTBOUND_INTERRUPT_ENABLE);=0A=
+	reg->message_wbuffer =3D (u32 __iomem *)((unsigned long)=0A=
+	acb->mem_base0 + ARCMSR_ARC1214_MESSAGE_WBUFFER);=0A=
+	reg->message_rbuffer =3D (u32 __iomem *)((unsigned long)=0A=
+	acb->mem_base0 + ARCMSR_ARC1214_MESSAGE_RBUFFER);=0A=
+	reg->msgcode_rwbuffer =3D (u32 __iomem *)((unsigned long)=0A=
+	acb->mem_base0 + ARCMSR_ARC1214_MESSAGE_RWBUFFER);=0A=
+	iop_firm_model =3D (char __iomem *)(&reg->msgcode_rwbuffer[15]);=0A=
+	iop_firm_version =3D (char __iomem *)(&reg->msgcode_rwbuffer[17]);=0A=
+	iop_device_map =3D (char __iomem *)(&reg->msgcode_rwbuffer[21]);=0A=
+	if (readl(acb->pmuD->outbound_doorbell) &=0A=
+	ARCMSR_ARC1214_IOP2DRV_MESSAGE_CMD_DONE) {=0A=
+		writel(ARCMSR_ARC1214_IOP2DRV_MESSAGE_CMD_DONE,=0A=
+			acb->pmuD->outbound_doorbell);/*clear interrupt*/=0A=
+	}=0A=
+	/* post "get config" instruction */=0A=
+	writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, reg->inbound_msgaddr0);=0A=
 	/* wait message ready */=0A=
-	for (Index =3D 0; Index < 2000; Index++) {=0A=
-		if (readl(&reg->outbound_doorbell) &=0A=
-		ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {=0A=
-			writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR,=0A=
-				&reg->outbound_doorbell_clear);=0A=
-			break;=0A=
-		}=0A=
-		udelay(10);=0A=
-	} /*max 1 seconds*/=0A=
-	if (Index >=3D 2000) {=0A=
-		pr_notice("arcmsr%d: wait 'get adapter firmware"=0A=
-		"miscellaneous data' timeout\n", pACB->host->host_no);=0A=
+	if (!arcmsr_hbaD_wait_msgint_ready(acb)) {=0A=
+		pr_notice("arcmsr%d: wait get adapter firmware"=0A=
+		"miscellaneous data timeout\n", acb->host->host_no);=0A=
+		dma_free_coherent(&acb->pdev->dev, acb->uncache_size,=0A=
+			acb->dma_coherent, acb->dma_coherent_handle);=0A=
 		return false;=0A=
 	}=0A=
 	count =3D 8;=0A=
@@ -2636,29 +3355,50 @@ arcmsr_hbaC_get_config(struct AdapterCon=0A=
 		iop_firm_version++;=0A=
 		count--;=0A=
 	}=0A=
-	pr_notice("Areca RAID Controller%d: F/W %s &"=0A=
-	"Model %s\n",=0A=
-	pACB->host->host_no,=0A=
-	pACB->firm_version,=0A=
-	pACB->firm_model);=0A=
-	pACB->firm_request_len =3D readl(&reg->msgcode_rwbuffer[1]);=0A=
-	pACB->firm_numbers_queue =3D readl(&reg->msgcode_rwbuffer[2]);=0A=
-	pACB->firm_sdram_size =3D readl(&reg->msgcode_rwbuffer[3]);=0A=
-	pACB->firm_hd_channels =3D readl(&reg->msgcode_rwbuffer[4]);=0A=
-	pACB->firm_cfg_version =3D readl(&reg->msgcode_rwbuffer[25]);=0A=
-	/*all interrupt service will be enable at arcmsr_iop_init*/=0A=
+	count =3D 16;=0A=
+	while (count) {=0A=
+		*acb_device_map =3D readb(iop_device_map);=0A=
+		acb_device_map++;=0A=
+		iop_device_map++;=0A=
+		count--;=0A=
+	}=0A=
+	acb->signature =3D readl(&reg->msgcode_rwbuffer[1]);=0A=
+	/*firm_signature,1,00-03*/=0A=
+	acb->firm_request_len =3D readl(&reg->msgcode_rwbuffer[2]);=0A=
+	/*firm_request_len,1,04-07*/=0A=
+	acb->firm_numbers_queue =3D readl(&reg->msgcode_rwbuffer[3]);=0A=
+	/*firm_numbers_queue,2,08-11*/=0A=
+	acb->firm_sdram_size =3D readl(&reg->msgcode_rwbuffer[4]);=0A=
+	/*firm_sdram_size,3,12-15*/=0A=
+	acb->firm_hd_channels =3D readl(&reg->msgcode_rwbuffer[5]);=0A=
+	/*firm_hd_channels,4,16-19*/=0A=
+	acb->firm_cfg_version =3D readl(&reg->msgcode_rwbuffer[25]);=0A=
+	pr_notice("Areca RAID Controller%d: F/W %s & Model %s\n",=0A=
+	acb->host->host_no, acb->firm_version, acb->firm_model);=0A=
 	return true;=0A=
 }=0A=
 =0A=
 static bool=0A=
 arcmsr_get_firmware_spec(struct AdapterControlBlock *acb)=0A=
 {=0A=
-	if (acb->adapter_type =3D=3D ACB_ADAPTER_TYPE_A)=0A=
-		return arcmsr_hbaA_get_config(acb);=0A=
-	else if (acb->adapter_type =3D=3D ACB_ADAPTER_TYPE_B)=0A=
-		return arcmsr_hbaB_get_config(acb);=0A=
-	else=0A=
-		return arcmsr_hbaC_get_config(acb);=0A=
+	bool rtn =3D false;=0A=
+	switch (acb->adapter_type) {=0A=
+	case ACB_ADAPTER_TYPE_A:=0A=
+		rtn =3D arcmsr_hbaA_get_config(acb);=0A=
+		break;=0A=
+	case ACB_ADAPTER_TYPE_B:=0A=
+		rtn =3D arcmsr_hbaB_get_config(acb);=0A=
+		break;=0A=
+	case ACB_ADAPTER_TYPE_C:=0A=
+		rtn =3D arcmsr_hbaC_get_config(acb);=0A=
+		break;=0A=
+	case ACB_ADAPTER_TYPE_D:=0A=
+		rtn =3D arcmsr_hbaD_get_config(acb);=0A=
+		break;=0A=
+	default:=0A=
+		break;=0A=
+	}=0A=
+	return rtn;=0A=
 }=0A=
 =0A=
 static int=0A=
@@ -2744,7 +3484,8 @@ arcmsr_hbaB_polling_ccbdone(struct Adapt=0A=
 	reg->iop2drv_doorbell);=0A=
 	while (1) {=0A=
 		index =3D reg->doneq_index;=0A=
-		if ((flag_ccb =3D readl(&reg->done_qbuffer[index])) =3D=3D 0) {=0A=
+		flag_ccb =3D readl(&reg->done_qbuffer[index]);=0A=
+		if (flag_ccb =3D=3D 0) {=0A=
 			if (poll_ccb_done) {=0A=
 				rtn =3D SUCCESS;=0A=
 				break;=0A=
@@ -2865,24 +3606,97 @@ polling_hbc_ccb_retry:=0A=
 }=0A=
 =0A=
 static int=0A=
+arcmsr_hbaD_polling_ccbdone(struct AdapterControlBlock *acb,=0A=
+				struct CommandControlBlock *poll_ccb)=0A=
+{=0A=
+	bool error;=0A=
+	uint32_t poll_ccb_done =3D 0, poll_count =3D 0, flag_ccb, ccb_cdb_phy;=0A=
+	int rtn, index, outbound_write_pointer;=0A=
+	struct ARCMSR_CDB *arcmsr_cdb;=0A=
+	struct CommandControlBlock *pCCB;=0A=
+	struct MessageUnit_D __iomem *reg =3D=0A=
+		(struct MessageUnit_D *)acb->pmuD;=0A=
+=0A=
+	polling_hbaD_ccb_retry:=0A=
+	poll_count++;=0A=
+	while (1) {=0A=
+		outbound_write_pointer =3D=0A=
+			readl(reg->outboundlist_copy_pointer);=0A=
+		index =3D reg->doneq_index;=0A=
+		if ((outbound_write_pointer & 0xFF) =3D=3D index) {=0A=
+			if (poll_ccb_done) {=0A=
+				rtn =3D SUCCESS;=0A=
+				break;=0A=
+			} else {=0A=
+				msleep(25);=0A=
+				if (poll_count > 100) {=0A=
+					rtn =3D FAILED;=0A=
+					break;=0A=
+				}=0A=
+				goto polling_hbaD_ccb_retry;=0A=
+			}=0A=
+		}=0A=
+		flag_ccb =3D reg->done_qbuffer[index].addressLow;=0A=
+		ccb_cdb_phy =3D (flag_ccb & 0xFFFFFFF0);=0A=
+		arcmsr_cdb =3D (struct ARCMSR_CDB *)(acb->vir2phy_offset +=0A=
+			ccb_cdb_phy);=0A=
+		pCCB =3D container_of(arcmsr_cdb,=0A=
+			struct CommandControlBlock, arcmsr_cdb);=0A=
+		poll_ccb_done =3D (pCCB =3D=3D poll_ccb) ? 1 : 0;=0A=
+		index++;=0A=
+		index %=3D ARCMSR_MAX_ARC1214_POSTQUEUE;=0A=
+		reg->doneq_index =3D index;=0A=
+		/* check if command done with no error*/=0A=
+		if ((pCCB->acb !=3D acb) ||=0A=
+		(pCCB->startdone !=3D ARCMSR_CCB_START)) {=0A=
+			if (pCCB->startdone =3D=3D ARCMSR_CCB_ABORTED) {=0A=
+				pr_notice("arcmsr%d: scsi id =3D %d"=0A=
+				"lun =3D %d ccb =3D '0x%p' poll command"=0A=
+				"abort successfully\n"=0A=
+				, acb->host->host_no=0A=
+				, pCCB->pcmd->device->id=0A=
+				, pCCB->pcmd->device->lun=0A=
+				, pCCB);=0A=
+				pCCB->pcmd->result =3D DID_ABORT << 16;=0A=
+				arcmsr_ccb_complete(pCCB);=0A=
+				continue;=0A=
+			}=0A=
+			pr_notice("arcmsr%d: polling an illegal"=0A=
+			"ccb command done ccb =3D '0x%p'"=0A=
+			"ccboutstandingcount =3D %d\n"=0A=
+			, acb->host->host_no=0A=
+			, pCCB=0A=
+			, atomic_read(&acb->ccboutstandingcount));=0A=
+			continue;=0A=
+		}=0A=
+		error =3D (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1)=0A=
+		? true : false;=0A=
+		arcmsr_report_ccb_state(acb, pCCB, error);=0A=
+	}=0A=
+	return rtn;=0A=
+}=0A=
+=0A=
+static int=0A=
 arcmsr_polling_ccbdone(struct AdapterControlBlock *acb,=0A=
-					struct CommandControlBlock *poll_ccb)=0A=
+				struct CommandControlBlock *poll_ccb)=0A=
 {=0A=
 	int rtn =3D 0;=0A=
 	switch (acb->adapter_type) {=0A=
-=0A=
-	case ACB_ADAPTER_TYPE_A: {=0A=
+	case ACB_ADAPTER_TYPE_A:{=0A=
 		rtn =3D arcmsr_hbaA_polling_ccbdone(acb, poll_ccb);=0A=
-		}=0A=
 		break;=0A=
-=0A=
-	case ACB_ADAPTER_TYPE_B: {=0A=
+	}=0A=
+	case ACB_ADAPTER_TYPE_B:{=0A=
 		rtn =3D arcmsr_hbaB_polling_ccbdone(acb, poll_ccb);=0A=
-		}=0A=
 		break;=0A=
+	}=0A=
 	case ACB_ADAPTER_TYPE_C: {=0A=
 		rtn =3D arcmsr_hbaC_polling_ccbdone(acb, poll_ccb);=0A=
-		}=0A=
+		break;=0A=
+	}=0A=
+	case ACB_ADAPTER_TYPE_D: {=0A=
+		rtn =3D arcmsr_hbaD_polling_ccbdone(acb, poll_ccb);=0A=
+	}=0A=
 	}=0A=
 	return rtn;=0A=
 }=0A=
@@ -2890,7 +3704,7 @@ arcmsr_polling_ccbdone(struct AdapterCon=0A=
 static int=0A=
 arcmsr_iop_confirm(struct AdapterControlBlock *acb)=0A=
 {=0A=
-	uint32_t cdb_phyaddr, cdb_phyaddr_hi32;=0A=
+	uint32_t cdb_phyaddr, cdb_phyaddr_hi32, cdb_phyaddr_lo32;=0A=
 	dma_addr_t dma_coherent_handle;=0A=
 	/*=0A=
 	********************************************************************=0A=
@@ -2899,7 +3713,7 @@ arcmsr_iop_confirm(struct AdapterControl=0A=
 	********************************************************************=0A=
 	*/=0A=
 	dma_coherent_handle =3D acb->dma_coherent_handle;=0A=
-	cdb_phyaddr =3D (uint32_t)(dma_coherent_handle);=0A=
+	cdb_phyaddr_lo32 =3D (uint32_t)(dma_coherent_handle & 0xffffffff);=0A=
 	cdb_phyaddr_hi32 =3D (uint32_t)((cdb_phyaddr >> 16) >> 16);=0A=
 	acb->cdb_phyaddr_hi32 =3D cdb_phyaddr_hi32;=0A=
 	/*=0A=
@@ -2912,8 +3726,6 @@ arcmsr_iop_confirm(struct AdapterControl=0A=
 	case ACB_ADAPTER_TYPE_A: {=0A=
 		if (cdb_phyaddr_hi32 !=3D 0) {=0A=
 			struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
-			uint32_t intmask_org;=0A=
-			intmask_org =3D arcmsr_disable_outbound_ints(acb);=0A=
 			writel(ARCMSR_SIGNATURE_SET_CONFIG,=0A=
 			&reg->message_rwbuffer[0]);=0A=
 			writel(cdb_phyaddr_hi32, &reg->message_rwbuffer[1]);=0A=
@@ -2925,7 +3737,6 @@ arcmsr_iop_confirm(struct AdapterControl=0A=
 				acb->host->host_no);=0A=
 				return 1;=0A=
 			}=0A=
-			arcmsr_enable_outbound_ints(acb, intmask_org);=0A=
 		}=0A=
 		}=0A=
 		break;=0A=
@@ -2935,18 +3746,16 @@ arcmsr_iop_confirm(struct AdapterControl=0A=
 		uint32_t __iomem *rwbuffer;=0A=
 =0A=
 		struct MessageUnit_B *reg =3D acb->pmuB;=0A=
-		uint32_t intmask_org;=0A=
-		intmask_org =3D arcmsr_disable_outbound_ints(acb);=0A=
 		reg->postq_index =3D 0;=0A=
 		reg->doneq_index =3D 0;=0A=
 		writel(ARCMSR_MESSAGE_SET_POST_WINDOW,=0A=
 		reg->drv2iop_doorbell);=0A=
 		if (!arcmsr_hbaB_wait_msgint_ready(acb)) {=0A=
-			pr_notice("arcmsr%d: can not set diver mode\n",=0A=
+			pr_notice("arcmsr%d:can not set diver mode\n",=0A=
 			acb->host->host_no);=0A=
 			return 1;=0A=
 		}=0A=
-		post_queue_phyaddr =3D acb->dma_coherent_handle_hbb_mu;=0A=
+		post_queue_phyaddr =3D acb->dma_coherent_handle2;=0A=
 		rwbuffer =3D reg->message_rwbuffer;=0A=
 		/* driver "set config" signature */=0A=
 		writel(ARCMSR_SIGNATURE_SET_CONFIG, rwbuffer++);=0A=
@@ -2965,7 +3774,6 @@ arcmsr_iop_confirm(struct AdapterControl=0A=
 			return 1;=0A=
 		}=0A=
 		arcmsr_hbb_enable_driver_mode(acb);=0A=
-		arcmsr_enable_outbound_ints(acb, intmask_org);=0A=
 		}=0A=
 		break;=0A=
 	case ACB_ADAPTER_TYPE_C: {=0A=
@@ -2990,6 +3798,29 @@ arcmsr_iop_confirm(struct AdapterControl=0A=
 			}=0A=
 		}=0A=
 		}=0A=
+		break;=0A=
+	case ACB_ADAPTER_TYPE_D: {=0A=
+		uint32_t __iomem *rwbuffer;=0A=
+=0A=
+		struct MessageUnit_D *reg =3D=0A=
+			(struct MessageUnit_D *)acb->pmuD;=0A=
+		reg->postq_index =3D 0;=0A=
+		reg->doneq_index =3D 0x40FF;=0A=
+		rwbuffer =3D reg->msgcode_rwbuffer;=0A=
+		writel(ARCMSR_SIGNATURE_SET_CONFIG, rwbuffer++);=0A=
+		writel(cdb_phyaddr_hi32, rwbuffer++);=0A=
+		writel(cdb_phyaddr_lo32, rwbuffer++);=0A=
+		writel(cdb_phyaddr_lo32 +=0A=
+		(ARCMSR_MAX_ARC1214_POSTQUEUE * sizeof(struct InBound_SRB)),=0A=
+		rwbuffer++);=0A=
+		writel(0x100, rwbuffer);=0A=
+		writel(ARCMSR_INBOUND_MESG0_SET_CONFIG,=0A=
+			reg->inbound_msgaddr0);=0A=
+		if (!arcmsr_hbaD_wait_msgint_ready(acb))=0A=
+			pr_notice("arcmsr%d: 'set command Q"=0A=
+			"window' timeout\n", acb->host->host_no);=0A=
+		break;=0A=
+	}=0A=
 	}=0A=
 	return 0;=0A=
 }=0A=
@@ -3024,6 +3855,16 @@ arcmsr_wait_firmware_ready(struct Adapte=0A=
 		} while ((firmware_state &=0A=
 		ARCMSR_HBCMU_MESSAGE_FIRMWARE_OK) =3D=3D 0);=0A=
 		}=0A=
+		break;=0A=
+	case ACB_ADAPTER_TYPE_D: {=0A=
+		struct MessageUnit_D __iomem *reg=0A=
+			=3D (struct MessageUnit_D *)acb->pmuD;=0A=
+		do {=0A=
+			firmware_state =3D readl(reg->outbound_msgaddr1);=0A=
+		} while ((firmware_state &=0A=
+		ARCMSR_ARC1214_MESSAGE_FIRMWARE_OK) =3D=3D 0);=0A=
+		break;=0A=
+	}=0A=
 	}=0A=
 }=0A=
 =0A=
@@ -3123,22 +3964,56 @@ arcmsr_hbaC_request_device_map(struct Ad=0A=
 }=0A=
 =0A=
 static void=0A=
+arcmsr_hbaD_request_device_map(struct AdapterControlBlock *acb)=0A=
+{=0A=
+	struct MessageUnit_D __iomem *reg =3D acb->pmuD;=0A=
+	if (unlikely(atomic_read(&acb->rq_map_token) =3D=3D 0) ||=0A=
+		((acb->acb_flags & ACB_F_BUS_RESET) !=3D 0) ||=0A=
+		((acb->acb_flags & ACB_F_ABORT) !=3D 0)) {=0A=
+		mod_timer(&acb->eternal_timer,=0A=
+			jiffies + msecs_to_jiffies(6 * HZ));=0A=
+	} else {=0A=
+		acb->fw_flag =3D FW_NORMAL;=0A=
+		if (atomic_read(&acb->ante_token_value) =3D=3D=0A=
+			atomic_read(&acb->rq_map_token)) {=0A=
+			atomic_set(&acb->rq_map_token, 16);=0A=
+		}=0A=
+		atomic_set(&acb->ante_token_value,=0A=
+			atomic_read(&acb->rq_map_token));=0A=
+		if (atomic_dec_and_test(&acb->rq_map_token)) {=0A=
+			mod_timer(&acb->eternal_timer, jiffies +=0A=
+				msecs_to_jiffies(6 * HZ));=0A=
+			return;=0A=
+		}=0A=
+		writel(ARCMSR_INBOUND_MESG0_GET_CONFIG,=0A=
+			reg->inbound_msgaddr0);=0A=
+		mod_timer(&acb->eternal_timer, jiffies +=0A=
+			msecs_to_jiffies(6 * HZ));=0A=
+	}=0A=
+	return;=0A=
+}=0A=
+=0A=
+static void=0A=
 arcmsr_request_device_map(unsigned long pacb)=0A=
 {=0A=
 	struct AdapterControlBlock *acb =3D=0A=
 		(struct AdapterControlBlock *)pacb;=0A=
 	switch (acb->adapter_type) {=0A=
-	case ACB_ADAPTER_TYPE_A: {=0A=
-		arcmsr_hbaA_request_device_map(acb);=0A=
-	}=0A=
-	break;=0A=
-	case ACB_ADAPTER_TYPE_B: {=0A=
-		arcmsr_hbaB_request_device_map(acb);=0A=
-	}=0A=
-	break;=0A=
-	case ACB_ADAPTER_TYPE_C: {=0A=
-		arcmsr_hbaC_request_device_map(acb);=0A=
-	}=0A=
+		case ACB_ADAPTER_TYPE_A: {=0A=
+			arcmsr_hbaA_request_device_map(acb);=0A=
+			break;=0A=
+		}=0A=
+		case ACB_ADAPTER_TYPE_B: {=0A=
+			arcmsr_hbaB_request_device_map(acb);=0A=
+			break;=0A=
+		}=0A=
+		case ACB_ADAPTER_TYPE_C: {=0A=
+			arcmsr_hbaC_request_device_map(acb);=0A=
+			break;=0A=
+		}=0A=
+		case ACB_ADAPTER_TYPE_D: {=0A=
+			arcmsr_hbaD_request_device_map(acb);=0A=
+		}=0A=
 	}=0A=
 }=0A=
 =0A=
@@ -3185,6 +4060,19 @@ arcmsr_hbaC_start_bgrb(struct AdapterCon=0A=
 }=0A=
 =0A=
 static void=0A=
+arcmsr_hbaD_start_bgrb(struct AdapterControlBlock *pACB)=0A=
+{=0A=
+	struct MessageUnit_D __iomem *pmu =3D (struct MessageUnit_D =
*)pACB->pmuD;=0A=
+	pACB->acb_flags |=3D ACB_F_MSG_START_BGRB;=0A=
+	writel(ARCMSR_INBOUND_MESG0_START_BGRB, pmu->inbound_msgaddr0);=0A=
+	if (!arcmsr_hbaD_wait_msgint_ready(pACB)) {=0A=
+		pr_notice("arcmsr%d: wait 'start adapter"=0A=
+		"background rebulid' timeout\n", pACB->host->host_no);=0A=
+	}=0A=
+	return;=0A=
+}=0A=
+=0A=
+static void=0A=
 arcmsr_start_adapter_bgrb(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	switch (acb->adapter_type) {=0A=
@@ -3196,6 +4084,10 @@ arcmsr_start_adapter_bgrb(struct Adapter=0A=
 		break;=0A=
 	case ACB_ADAPTER_TYPE_C:=0A=
 		arcmsr_hbaC_start_bgrb(acb);=0A=
+		break;=0A=
+	case ACB_ADAPTER_TYPE_D:=0A=
+		arcmsr_hbaD_start_bgrb(acb);=0A=
+		break;=0A=
 	}=0A=
 }=0A=
 =0A=
@@ -3235,6 +4127,18 @@ arcmsr_clear_doorbell_queue_buffer(struc=0A=
 		writel(ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK,=0A=
 			&reg->inbound_doorbell);=0A=
 		}=0A=
+		break;=0A=
+	case ACB_ADAPTER_TYPE_D: {=0A=
+		struct MessageUnit_D __iomem *reg =3D=0A=
+			(struct MessageUnit_D *)acb->pmuD;=0A=
+		uint32_t outbound_doorbell;=0A=
+		/* empty doorbell Qbuffer if door bell ringed */=0A=
+		outbound_doorbell =3D readl(reg->outbound_doorbell);=0A=
+		writel(outbound_doorbell, reg->outbound_doorbell);=0A=
+		writel(ARCMSR_ARC1214_DRV2IOP_DATA_OUT_READ,=0A=
+			reg->inbound_doorbell);=0A=
+		break;=0A=
+	}=0A=
 	}=0A=
 }=0A=
 =0A=
@@ -3243,21 +4147,20 @@ arcmsr_enable_eoi_mode(struct AdapterCon=0A=
 {=0A=
 	switch (acb->adapter_type) {=0A=
 	case ACB_ADAPTER_TYPE_A:=0A=
+	case ACB_ADAPTER_TYPE_C:=0A=
+	case ACB_ADAPTER_TYPE_D:=0A=
 		return;=0A=
-	case ACB_ADAPTER_TYPE_B:=0A=
-		{=0A=
-			struct MessageUnit_B *reg =3D acb->pmuB;=0A=
+	case ACB_ADAPTER_TYPE_B: {=0A=
+		struct MessageUnit_B *reg =3D acb->pmuB;=0A=
 			writel(ARCMSR_MESSAGE_ACTIVE_EOI_MODE,=0A=
-			reg->drv2iop_doorbell);=0A=
+				reg->drv2iop_doorbell);=0A=
 			if (!arcmsr_hbaB_wait_msgint_ready(acb)) {=0A=
 				pr_notice("ARCMSR IOP"=0A=
 				"enables EOI_MODE TIMEOUT");=0A=
 				return;=0A=
 			}=0A=
-		}=0A=
-		break;=0A=
-	case ACB_ADAPTER_TYPE_C:=0A=
-		return;=0A=
+	}=0A=
+	break;=0A=
 	}=0A=
 	return;=0A=
 }=0A=
@@ -3526,6 +4429,65 @@ sleep:=0A=
 		}=0A=
 		break;=0A=
 	}=0A=
+	case ACB_ADAPTER_TYPE_D: {=0A=
+		if (acb->acb_flags & ACB_F_BUS_RESET) {=0A=
+			long timeout;=0A=
+			pr_notice("arcmsr: there is an bus reset eh proceeding.......\n");=0A=
+			timeout =3D wait_event_timeout(wait_q, (acb->acb_flags=0A=
+				& ACB_F_BUS_RESET) =3D=3D 0, 220 * HZ);=0A=
+			if (timeout)=0A=
+				return SUCCESS;=0A=
+		}=0A=
+		acb->acb_flags |=3D ACB_F_BUS_RESET;=0A=
+		if (!arcmsr_iop_reset(acb)) {=0A=
+			struct MessageUnit_D __iomem *reg;=0A=
+			reg =3D acb->pmuD;=0A=
+			arcmsr_hardware_reset(acb);=0A=
+			acb->acb_flags &=3D ~ACB_F_IOP_INITED;=0A=
+			nap:=0A=
+			ssleep(ARCMSR_SLEEPTIME);=0A=
+			if ((readl(reg->sample_at_reset) & 0x80) !=3D 0) {=0A=
+				pr_err("arcmsr%d: waiting for"=0A=
+				"hw bus reset return, retry=3D%d\n",=0A=
+				acb->host->host_no, retry_count);=0A=
+				if (retry_count > ARCMSR_RETRYCOUNT) {=0A=
+					acb->fw_flag =3D FW_DEADLOCK;=0A=
+					pr_err("arcmsr%d:"=0A=
+					"waiting for hw bus reset return,"=0A=
+					"RETRY TERMINATED!!\n",=0A=
+					acb->host->host_no);=0A=
+					return FAILED;=0A=
+				}=0A=
+				retry_count++;=0A=
+				goto nap;=0A=
+			}=0A=
+			acb->acb_flags |=3D ACB_F_IOP_INITED;=0A=
+			/* disable all outbound interrupt */=0A=
+			intmask_org =3D arcmsr_disable_outbound_ints(acb);=0A=
+			arcmsr_get_firmware_spec(acb);=0A=
+			arcmsr_start_adapter_bgrb(acb);=0A=
+			arcmsr_clear_doorbell_queue_buffer(acb);=0A=
+			arcmsr_enable_outbound_ints(acb, intmask_org);=0A=
+			atomic_set(&acb->rq_map_token, 16);=0A=
+			atomic_set(&acb->ante_token_value, 16);=0A=
+			acb->fw_flag =3D FW_NORMAL;=0A=
+			mod_timer(&acb->eternal_timer,=0A=
+				jiffies + msecs_to_jiffies(6 * HZ));=0A=
+			acb->acb_flags &=3D ~ACB_F_BUS_RESET;=0A=
+			rtn =3D SUCCESS;=0A=
+			pr_err("arcmsr: scsi bus reset"=0A=
+			"eh returns with success\n");=0A=
+		} else {=0A=
+			acb->acb_flags &=3D ~ACB_F_BUS_RESET;=0A=
+			atomic_set(&acb->rq_map_token, 16);=0A=
+			atomic_set(&acb->ante_token_value, 16);=0A=
+			acb->fw_flag =3D FW_NORMAL;=0A=
+			mod_timer(&acb->eternal_timer,=0A=
+				jiffies + msecs_to_jiffies(6 * HZ));=0A=
+			rtn =3D SUCCESS;=0A=
+		}=0A=
+		break;=0A=
+	}=0A=
 	}=0A=
 	return rtn;=0A=
 }=0A=
@@ -3547,7 +4509,7 @@ arcmsr_abort(struct scsi_cmnd *cmd)=0A=
 	int i =3D 0;=0A=
 	int rtn =3D FAILED;=0A=
 	pr_notice("arcmsr%d: abort device command of"=0A=
-	"scsi id =3D %d lun =3D %d\n",=0A=
+		"scsi id =3D %d lun =3D %d\n",=0A=
 		acb->host->host_no,=0A=
 		cmd->device->id, cmd->device->lun);=0A=
 	acb->acb_flags |=3D ACB_F_ABORT;=0A=
@@ -3601,8 +4563,7 @@ static const char=0A=
 	case PCI_DEVICE_ID_ARECA_1280:=0A=
 		type =3D "SATA";=0A=
 		break;=0A=
-	case PCI_DEVICE_ID_ARECA_1380:=0A=
-	case PCI_DEVICE_ID_ARECA_1381:=0A=
+	case PCI_DEVICE_ID_ARECA_1214:=0A=
 	case PCI_DEVICE_ID_ARECA_1680:=0A=
 	case PCI_DEVICE_ID_ARECA_1681:=0A=
 	case PCI_DEVICE_ID_ARECA_1880:=0A=

------=_NextPart_000_0009_01CE0488.4DC0D6F0--

