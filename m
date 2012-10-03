From: "NickCheng" <nick.cheng@areca.com.tw>
Subject: [PATCH 4/5]  arcmsr: Support a New RAID Model, ARC-1214
Date: Wed, 3 Oct 2012 20:39:15 +0800
Message-ID: <32DBE8152B0E461B8B06F89887D6D888@arecaaebe11fae>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:53579 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754711Ab2JCMi4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Oct 2012 08:38:56 -0400
Received: by dakn41 with SMTP id n41so1222773dak.19
        for <linux-scsi@vger.kernel.org>; Wed, 03 Oct 2012 05:38:55 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, jejb@kernel.org

From: Nick Cheng <nick.cheng@areca.com.tw>

Add a New RAID Model, ARC-1214, which can support 8 SATA HDs at most, so
far.
Signed-off-by: Nick Cheng <nick.cheng@areca.com.tw>
---
diff -uprN -X linux-vanilla/Documentation/dontdiff
linux-vanilla//drivers/scsi/arcmsr/arcmsr.h
linux-development//drivers/scsi/arcmsr/arcmsr.h
--- linux-vanilla//drivers/scsi/arcmsr/arcmsr.h	2012-10-03
19:25:56.930624072 +0800
+++ linux-development//drivers/scsi/arcmsr/arcmsr.h	2012-10-03
19:25:19.914624431 +0800
@@ -51,7 +51,7 @@ struct device_attribute;
 #else
 	#define ARCMSR_MAX_FREECCB_NUM	320
 #endif
-#define ARCMSR_DRIVER_VERSION		     "Driver Version 1.20.00.15
2012/09/30"
+#define ARCMSR_DRIVER_VERSION			"Driver Version 1.20.00.15
2012/09/30"
 #define ARCMSR_SCSI_INITIATOR_ID
255
 #define ARCMSR_MAX_XFER_SECTORS
512
 #define ARCMSR_MAX_XFER_SECTORS_B
4096
@@ -65,8 +65,12 @@ struct device_attribute;
 #define ARCMSR_MAX_XFER_LEN
0x26000 /* 152K */
 #define ARCMSR_CDB_SG_PAGE_LENGTH
256
 #define ARCMST_NUM_MSIX_VECTORS		4
+#define ARCMSR_MAX_ARC1214_POSTQUEUE		256
 #ifndef PCI_DEVICE_ID_ARECA_1880
-#define PCI_DEVICE_ID_ARECA_1880 0x1880
+	#define PCI_DEVICE_ID_ARECA_1880 0x1880
+ #endif
+ #ifndef PCI_DEVICE_ID_ARECA_1214
+	#define PCI_DEVICE_ID_ARECA_1214 0x1214
  #endif
 /*
 
****************************************************************************
******
@@ -336,6 +340,57 @@ struct FIRMWARE_INFO
 #define ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR	0x00000008
 	/*ARCMSR_HBAMU_MESSAGE_FIRMWARE_OK*/
 #define ARCMSR_HBCMU_MESSAGE_FIRMWARE_OK			0x80000000
+/* 
+***************************************************************************
****
+**                SPEC. for Areca Type D adapter
+***************************************************************************
****
+*/
+#define ARCMSR_ARC1214_CHIP_ID
0x00004
+#define ARCMSR_ARC1214_CPU_MEMORY_CONFIGURATION
0x00008
+#define ARCMSR_ARC1214_I2_HOST_INTERRUPT_MASK			0x00034
+#define ARCMSR_ARC1214_SAMPLE_RESET
0x00100
+#define ARCMSR_ARC1214_RESET_REQUEST
0x00108
+#define ARCMSR_ARC1214_MAIN_INTERRUPT_STATUS
0x00200
+#define ARCMSR_ARC1214_PCIE_F0_INTERRUPT_ENABLE
0x0020C
+#define ARCMSR_ARC1214_INBOUND_MESSAGE0
0x00400
+#define ARCMSR_ARC1214_INBOUND_MESSAGE1
0x00404
+#define ARCMSR_ARC1214_OUTBOUND_MESSAGE0
0x00420
+#define ARCMSR_ARC1214_OUTBOUND_MESSAGE1
0x00424
+#define ARCMSR_ARC1214_INBOUND_DOORBELL
0x00460
+#define ARCMSR_ARC1214_OUTBOUND_DOORBELL
0x00480
+#define ARCMSR_ARC1214_OUTBOUND_DOORBELL_ENABLE
0x00484
+#define ARCMSR_ARC1214_INBOUND_LIST_BASE_LOW			0x01000
+#define ARCMSR_ARC1214_INBOUND_LIST_BASE_HIGH			0x01004
+#define ARCMSR_ARC1214_INBOUND_LIST_WRITE_POINTER
0x01018
+#define ARCMSR_ARC1214_OUTBOUND_LIST_BASE_LOW			0x01060
+#define ARCMSR_ARC1214_OUTBOUND_LIST_BASE_HIGH			0x01064
+#define ARCMSR_ARC1214_OUTBOUND_LIST_COPY_POINTER
0x0106C
+#define ARCMSR_ARC1214_OUTBOUND_LIST_READ_POINTER
0x01070
+#define ARCMSR_ARC1214_OUTBOUND_INTERRUPT_CAUSE
0x01088
+#define ARCMSR_ARC1214_OUTBOUND_INTERRUPT_ENABLE
0x0108C
+#define ARCMSR_ARC1214_MESSAGE_WBUFFER				0x02000
+#define ARCMSR_ARC1214_MESSAGE_RBUFFER				0x02100
+#define ARCMSR_ARC1214_MESSAGE_RWBUFFER
0x02200
+/* Host Interrupt Mask */
+#define ARCMSR_ARC1214_ALL_INT_ENABLE
0x00001010
+#define ARCMSR_ARC1214_ALL_INT_DISABLE				0x00000000
+/* Host Interrupt Status */
+#define ARCMSR_ARC1214_OUTBOUND_DOORBELL_ISR			0x00001000
+#define ARCMSR_ARC1214_OUTBOUND_POSTQUEUE_ISR			0x00000010
+/* DoorBell*/
+#define ARCMSR_ARC1214_DRV2IOP_DATA_IN_READY
0x00000001
+#define ARCMSR_ARC1214_DRV2IOP_DATA_OUT_READ			0x00000002
+/*inbound message 0 ready*/
+#define ARCMSR_ARC1214_IOP2DRV_DATA_WRITE_OK			0x00000001
+/*outbound DATA WRITE isr door bell clear*/
+#define ARCMSR_ARC1214_IOP2DRV_DATA_READ_OK
0x00000002
+/*outbound message 0 ready*/
+#define ARCMSR_ARC1214_IOP2DRV_MESSAGE_CMD_DONE
0x02000000
+/*outbound message cmd isr door bell clear*/
+#define ARCMSR_ARC1214_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR	0x02000000
+/*ARCMSR_HBAMU_MESSAGE_FIRMWARE_OK*/
+#define ARCMSR_ARC1214_MESSAGE_FIRMWARE_OK
0x80000000
+#define ARCMSR_ARC1214_OUTBOUND_LIST_INTERRUPT_CLEAR		0x00000001
 /*
 
****************************************************************************
***
 **    ARECA SCSI COMMAND DESCRIPTOR BLOCK size 0x1F8 (504)
@@ -358,7 +413,7 @@ struct ARCMSR_CDB
 #define ARCMSR_CDB_FLAG_ORDEREDQ           0x10
 
 	uint8_t							msgPages;
-	uint32_t						Context;
+	uint32_t						msgContext;
 	uint32_t						DataLength;
 	uint8_t							Cdb[16];
 	uint8_t
DeviceStatus;
@@ -494,6 +549,51 @@ struct MessageUnit_C{
 	uint32_t	reserved4[32];				/*2180
21FF*/
 	uint32_t	msgcode_rwbuffer[256];			/*2200
23FF*/
 };
+
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
 
****************************************************************************
***
 **                 Adapter Control Block
@@ -513,13 +613,15 @@ struct AdapterControlBlock
 	/* Offset is used in making arc cdb physical to virtual calculations
*/
 	uint32_t			outbound_int_enable;
 	uint32_t			cdb_phyaddr_hi32;
-	uint32_t			reg_mu_acc_handle0;
+	uint32_t			roundup_ccbsize;
 	spinlock_t                      			eh_lock;
 	spinlock_t
ccblist_lock;
+	spinlock_t				postq_lock;
 	union {
 		struct MessageUnit_A __iomem *pmuA;
 		struct MessageUnit_B 	*pmuB;
 		struct MessageUnit_C __iomem *pmuC;
+		struct MessageUnit_D __iomem *pmuD;
 	};
 	/* message unit ATU inbound base address0 */
 	void __iomem *mem_base0;
@@ -561,7 +663,8 @@ struct AdapterControlBlock
 	/* dma_coherent used for memory free */
 	dma_addr_t			dma_coherent_handle;
 	/* dma_coherent_handle used for memory free */
-	dma_addr_t				dma_coherent_handle_hbb_mu;
+	dma_addr_t				dma_coherent_handle2;
+	void *
dma_coherent2;
 	unsigned int				uncache_size;
 	uint8_t				rqbuffer[ARCMSR_MAX_QBUFFER];
 	/* data collection buffer for read from 80331 */
@@ -610,7 +713,7 @@ struct CommandControlBlock{
 	struct list_head		list;
/*x32: 8byte, x64: 16byte*/
 	struct scsi_cmnd		*pcmd;				/*8
bytes pointer of linux scsi command */
 	struct AdapterControlBlock	*acb;
/*x32: 4byte, x64: 8byte*/
-	uint32_t			cdb_phyaddr_pattern;
/*x32: 4byte, x64: 4byte*/
+	uint32_t			cdb_phyaddr;		/*x32:
4byte, x64: 4byte*/
 	uint32_t			arc_cdb_size;
/*x32:4byte,x64:4byte*/
 	uint16_t			ccb_flags;
/*x32: 2byte, x64: 2byte*/
 	#define			CCB_FLAG_READ			0x0000
diff -uprN -X linux-vanilla/Documentation/dontdiff
linux-vanilla//drivers/scsi/arcmsr/arcmsr_hba.c
linux-development//drivers/scsi/arcmsr/arcmsr_hba.c
--- linux-vanilla//drivers/scsi/arcmsr/arcmsr_hba.c	2012-10-03
19:25:56.930624072 +0800
+++ linux-development//drivers/scsi/arcmsr/arcmsr_hba.c	2012-10-03
19:25:19.918624431 +0800
@@ -101,14 +101,17 @@ static void arcmsr_enable_outbound_ints(
 static void arcmsr_stop_adapter_bgrb(struct AdapterControlBlock *acb);
 static void arcmsr_hbaA_flush_cache(struct AdapterControlBlock *acb);
 static void arcmsr_hbaB_flush_cache(struct AdapterControlBlock *acb);
+static void arcmsr_hbaD_flush_cache(struct AdapterControlBlock *acb);
 static void arcmsr_request_device_map(unsigned long pacb);
 static void arcmsr_hbaA_request_device_map(struct AdapterControlBlock
*acb);
 static void arcmsr_hbaB_request_device_map(struct AdapterControlBlock
*acb);
 static void arcmsr_hbaC_request_device_map(struct AdapterControlBlock
*acb);
+static void arcmsr_hbaD_request_device_map(struct AdapterControlBlock
*acb);
 static void arcmsr_message_isr_bh_fn(struct work_struct *work);
 static bool arcmsr_get_firmware_spec(struct AdapterControlBlock *acb);
 static void arcmsr_start_adapter_bgrb(struct AdapterControlBlock *acb);
 static void arcmsr_hbaC_message_isr(struct AdapterControlBlock *pACB);
+static void arcmsr_hbaD_message_isr(struct AdapterControlBlock *pACB);
 static void arcmsr_hardware_reset(struct AdapterControlBlock *acb);
 static const char *arcmsr_info(struct Scsi_Host *);
 static irqreturn_t arcmsr_interrupt(struct AdapterControlBlock *acb);
@@ -136,8 +139,6 @@ static struct scsi_host_template arcmsr_
 	.change_queue_depth	= arcmsr_adjust_disk_queue_depth,
 	.can_queue		= ARCMSR_MAX_FREECCB_NUM,
 	.this_id			= ARCMSR_SCSI_INITIATOR_ID,
-	.sg_tablesize	        	= ARCMSR_DEFAULT_SG_ENTRIES, 
-	.max_sectors    	    	= ARCMSR_MAX_XFER_SECTORS_C, 
 	.cmd_per_lun		= ARCMSR_MAX_CMD_PERLUN,
 	.use_clustering		= ENABLE_CLUSTERING,
 	.shost_attrs		= arcmsr_host_attrs,
@@ -157,11 +158,10 @@ static struct pci_device_id arcmsr_devic
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1260)},
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1270)},
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1280)},
-	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1380)},
-	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1381)},
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1680)},
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1681)},
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1880)},
+	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1214)},
 	{0, 0}, /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(pci, arcmsr_device_id_table);
@@ -179,17 +179,23 @@ static struct pci_driver arcmsr_pci_driv
 
****************************************************************************
 */
 
-static void arcmsr_free_hbb_mu(struct AdapterControlBlock *acb)
+static void arcmsr_free_mu(struct AdapterControlBlock *acb)
 {
 	switch (acb->adapter_type) {
-	case ACB_ADAPTER_TYPE_A:
-	case ACB_ADAPTER_TYPE_C:
-		break;
-	case ACB_ADAPTER_TYPE_B:{
-		dma_free_coherent(&acb->pdev->dev,
-			sizeof(struct MessageUnit_B),
-			acb->pmuB, acb->dma_coherent_handle_hbb_mu);
-	}
+		case ACB_ADAPTER_TYPE_A:
+		case ACB_ADAPTER_TYPE_C:
+			break;
+		case ACB_ADAPTER_TYPE_B: {
+			struct MessageUnit_B *reg = acb->pmuB;
+			dma_free_coherent(&acb->pdev->dev, sizeof(struct
MessageUnit_B), reg,
+				acb->dma_coherent_handle2);
+			break;
+		}
+		case ACB_ADAPTER_TYPE_D: {
+			dma_free_coherent(&acb->pdev->dev, sizeof(struct
MessageUnit_D), acb->dma_coherent,
+				acb->dma_coherent_handle);
+			break;
+		}
 	}
 }
 
@@ -234,6 +240,25 @@ static bool arcmsr_remap_pciregion(struc
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
+			printk(KERN_NOTICE "arcmsr%d: memory mapping region
fail \n", acb->host->host_no);
+			return false;
+		}
+		acb->mem_base0 = mem_base0;
+		break;
+	}
 	}
 	return true;
 }
@@ -253,6 +278,10 @@ static void arcmsr_unmap_pciregion(struc
 	break;
 	case ACB_ADAPTER_TYPE_C:{
 		iounmap(acb->pmuC);
+		break;
+	}
+	case ACB_ADAPTER_TYPE_D: {
+		iounmap(acb->mem_base0);
 	}
 	}
 }
@@ -309,12 +338,15 @@ static void arcmsr_define_adapter_type(s
 		acb->adapter_type = ACB_ADAPTER_TYPE_B;
 		}
 		break;
-
+	case 0x1214: {
+		acb->adapter_type = ACB_ADAPTER_TYPE_D;
+		break;
+		}
 	default: acb->adapter_type = ACB_ADAPTER_TYPE_A;
 	}
 }
 
-static uint8_t arcmsr_hbaA_wait_msgint_ready(struct AdapterControlBlock
*acb)
+static bool arcmsr_hbaA_wait_msgint_ready(struct AdapterControlBlock *acb)
 {
 	struct MessageUnit_A __iomem *reg = acb->pmuA;
 	int i;
@@ -328,11 +360,10 @@ static uint8_t arcmsr_hbaA_wait_msgint_r
 		}
 		msleep(10);
 	} /* max 20 seconds */
-
 	return false;
 }
 
-static uint8_t arcmsr_hbaB_wait_msgint_ready(struct AdapterControlBlock
*acb)
+static bool arcmsr_hbaB_wait_msgint_ready(struct AdapterControlBlock *acb)
 {
 	struct MessageUnit_B *reg = acb->pmuB;
 	int i;
@@ -348,11 +379,10 @@ static uint8_t arcmsr_hbaB_wait_msgint_r
 		}
 		msleep(10);
 	} /* max 20 seconds */
-
 	return false;
 }
 
-static uint8_t arcmsr_hbaC_wait_msgint_ready(struct AdapterControlBlock
*pACB)
+static bool arcmsr_hbaC_wait_msgint_ready(struct AdapterControlBlock *pACB)
 {
 	struct MessageUnit_C *phbcmu = (struct MessageUnit_C *)pACB->pmuC;
 	int i;
@@ -366,7 +396,22 @@ static uint8_t arcmsr_hbaC_wait_msgint_r
 		}
 		msleep(10);
 	} /* max 20 seconds */
+	return false;
+}
 
+static bool arcmsr_hbaD_wait_msgint_ready(struct AdapterControlBlock *pACB)
+{
+	int i;
+	struct MessageUnit_D __iomem *reg = (struct MessageUnit_D
*)pACB->pmuD;
+	for (i = 0; i < 2000; i++) {
+		if (ioread32(reg->outbound_doorbell)
+			& ARCMSR_ARC1214_IOP2DRV_MESSAGE_CMD_DONE) {
+
iowrite32(ARCMSR_ARC1214_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR,
+				reg->outbound_doorbell);
+			return true;
+		}
+		msleep(10);
+	} /* max 20 seconds */
 	return false;
 }
 
@@ -380,8 +425,8 @@ static void arcmsr_hbaA_flush_cache(stru
 			break;
 		else {
 			retry_count--;
-			printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter
cache' \
-			timeout, retry count down = %d \n",
acb->host->host_no, retry_count);
+			printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter
cache' "
+			"timeout, retry count down = %d \n",
acb->host->host_no, retry_count);
 		}
 	} while (retry_count != 0);
 }
@@ -396,8 +441,8 @@ static void arcmsr_hbaB_flush_cache(stru
 			break;
 		else {
 			retry_count--;
-			printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter
cache' \
-			timeout,retry count down = %d \n",
acb->host->host_no, retry_count);
+			printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter
cache' "
+			"timeout,retry count down = %d \n",
acb->host->host_no, retry_count);
 		}
 	} while (retry_count != 0);
 }
@@ -415,79 +460,203 @@ static void arcmsr_hbaC_flush_cache(stru
 			break;
 		} else {
 			retry_count--;
-			printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter
cache' \
-			timeout,retry count down = %d \n",
pACB->host->host_no, retry_count);
+			printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter
cache' "
+			"timeout,retry count down = %d \n",
pACB->host->host_no, retry_count);
 		}
 	} while (retry_count != 0);
 	return;
 }
-static void arcmsr_flush_adapter_cache(struct AdapterControlBlock *acb)
+
+static void arcmsr_hbaD_flush_cache(struct AdapterControlBlock *pACB)
 {
-	switch (acb->adapter_type) {
+	int retry_count = 6;
+	struct MessageUnit_D __iomem *reg = (struct MessageUnit_D
*)pACB->pmuD;
 
-	case ACB_ADAPTER_TYPE_A: {
-		arcmsr_hbaA_flush_cache(acb);
+	iowrite32(ARCMSR_INBOUND_MESG0_FLUSH_CACHE, reg->inbound_msgaddr0);
+	do {
+		if (arcmsr_hbaD_wait_msgint_ready(pACB)) {
+			break;
+		} else {
+			retry_count--;
+			printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter
cache' timeout,"
+				"retry count down = %d \n",
pACB->host->host_no, retry_count);
 		}
-		break;
+	} while (retry_count != 0);
+	return;
+}
 
-	case ACB_ADAPTER_TYPE_B: {
-		arcmsr_hbaB_flush_cache(acb);
-		}
-		break;
-	case ACB_ADAPTER_TYPE_C: {
-		arcmsr_hbaC_flush_cache(acb);
+static void arcmsr_flush_adapter_cache(struct AdapterControlBlock *acb)
+{
+	switch (acb->adapter_type) {
+		case ACB_ADAPTER_TYPE_A: {
+			arcmsr_hbaA_flush_cache(acb);
+			}
+			break;
+		case ACB_ADAPTER_TYPE_B: {
+			arcmsr_hbaB_flush_cache(acb);
+			}
+			break;
+		case ACB_ADAPTER_TYPE_C: {
+			arcmsr_hbaC_flush_cache(acb);
+			}
+			break;
+		case ACB_ADAPTER_TYPE_D: {
+			arcmsr_hbaD_flush_cache(acb);
 		}
 	}
 }
-
 static int arcmsr_alloc_ccb_pool(struct AdapterControlBlock *acb)
 {
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
-	if((firm_config_version & 0xFF) >= 3){
-		max_xfer_len = (ARCMSR_CDB_SG_PAGE_LENGTH <<
((firm_config_version >> 8) & 0xFF)) * 1024;/* max 4M byte */
-		max_sg_entrys = (max_xfer_len/4096);
+	if ((firm_config_version & 0xFF) >= 3) {
+		max_xfer_len = (ARCMSR_CDB_SG_PAGE_LENGTH
+			<< ((firm_config_version >> 8) & 0xFF)) * 1024;
+		max_sg_entrys = (max_xfer_len / 4096);/* max 4096 sg entry*/
 	}
-	acb->host->max_sectors = max_xfer_len/512;
+	acb->host->max_sectors = max_xfer_len / 512;
 	acb->host->sg_tablesize = max_sg_entrys;
-	roundup_ccbsize = roundup(sizeof(struct CommandControlBlock) +
(max_sg_entrys - 1) * sizeof(struct SG64ENTRY), 32);
-	acb->uncache_size = roundup_ccbsize * ARCMSR_MAX_FREECCB_NUM;
-	dma_coherent = dma_alloc_coherent(&pdev->dev, acb->uncache_size,
&dma_coherent_handle, GFP_KERNEL);
-	if(!dma_coherent){
-		printk(KERN_NOTICE "arcmsr%d: dma_alloc_coherent got
error\n", acb->host->host_no);
-		return -ENOMEM;
-	}
-	acb->dma_coherent = dma_coherent;
-	acb->dma_coherent_handle = dma_coherent_handle;
-	memset(dma_coherent, 0, acb->uncache_size);
-	ccb_tmp = dma_coherent;
-	acb->vir2phy_offset = (unsigned long)dma_coherent - (unsigned
long)dma_coherent_handle;
-	for(i = 0; i < ARCMSR_MAX_FREECCB_NUM; i++){
-		cdb_phyaddr = dma_coherent_handle + offsetof(struct
CommandControlBlock, arcmsr_cdb);
-		ccb_tmp->cdb_phyaddr_pattern = ((acb->adapter_type ==
ACB_ADAPTER_TYPE_C) ? cdb_phyaddr : (cdb_phyaddr >> 5));
-		acb->pccb_pool[i] = ccb_tmp;
-		ccb_tmp->acb = acb;
-		INIT_LIST_HEAD(&ccb_tmp->list);
-		list_add_tail(&ccb_tmp->list, &acb->ccb_free_list);
-		ccb_tmp = (struct CommandControlBlock *)((unsigned
long)ccb_tmp + roundup_ccbsize);
-		dma_coherent_handle = dma_coherent_handle + roundup_ccbsize;
+	switch (acb->adapter_type) {
+		case ACB_ADAPTER_TYPE_A: {
+			roundup_ccbsize = roundup(sizeof(struct
CommandControlBlock)
+				+ max_sg_entrys * sizeof(struct SG64ENTRY),
32);
+			acb->uncache_size = roundup_ccbsize *
ARCMSR_MAX_FREECCB_NUM;
+			dma_coherent = dma_alloc_coherent(&pdev->dev,
acb->uncache_size,
+				&dma_coherent_handle, GFP_KERNEL);
+			if (!dma_coherent) {
+				printk("arcmsr%d: dma_alloc_coherent got
error\n",
+					acb->host->host_no);
+				return -ENOMEM;
+			}
+			memset(dma_coherent, 0, acb->uncache_size);
+			acb->dma_coherent = dma_coherent;
+			acb->dma_coherent_handle = dma_coherent_handle;
+			ccb_tmp = (struct CommandControlBlock
*)dma_coherent;
+			acb->vir2phy_offset = (unsigned long)dma_coherent -
+				(unsigned long)dma_coherent_handle;
+			for (i = 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {
+				cdb_phyaddr = dma_coherent_handle
+					+ offsetof(struct
CommandControlBlock, arcmsr_cdb);
+				ccb_tmp->cdb_phyaddr = cdb_phyaddr >> 5;
+				acb->pccb_pool[i] = ccb_tmp;
+				ccb_tmp->acb = acb;
+				INIT_LIST_HEAD(&ccb_tmp->list);
+				list_add_tail(&ccb_tmp->list,
&acb->ccb_free_list);
+				ccb_tmp = (struct CommandControlBlock
*)((unsigned long)ccb_tmp +
+					roundup_ccbsize);
+				dma_coherent_handle = dma_coherent_handle +
+					roundup_ccbsize;
+			}
+			break;
+		}
+		case ACB_ADAPTER_TYPE_B: {
+			roundup_ccbsize = roundup(sizeof(struct
CommandControlBlock)
+				+ (max_sg_entrys - 1) * sizeof(struct
SG64ENTRY), 32);
+			acb->uncache_size = roundup_ccbsize *
ARCMSR_MAX_FREECCB_NUM;
+			dma_coherent =
dma_alloc_coherent(&pdev->dev,acb->uncache_size,
+				&dma_coherent_handle, GFP_KERNEL);
+			if (!dma_coherent) {
+				printk(KERN_NOTICE "DMA allocation
failed\n");
+				return -ENOMEM;
+			}
+			memset(dma_coherent, 0, acb->uncache_size);
+			acb->dma_coherent = dma_coherent;
+			acb->dma_coherent_handle = dma_coherent_handle;
+			ccb_tmp = (struct CommandControlBlock
*)dma_coherent;
+			acb->vir2phy_offset = (unsigned long)dma_coherent -
+				(unsigned long)dma_coherent_handle;
+			for (i = 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {
+				cdb_phyaddr = dma_coherent_handle +
+					offsetof(struct CommandControlBlock,
arcmsr_cdb);
+				ccb_tmp->cdb_phyaddr = cdb_phyaddr >> 5;
+				acb->pccb_pool[i] = ccb_tmp;
+				ccb_tmp->acb = acb;
+				INIT_LIST_HEAD(&ccb_tmp->list);
+				list_add_tail(&ccb_tmp->list,
&acb->ccb_free_list);
+				ccb_tmp = (struct CommandControlBlock
*)((unsigned long)ccb_tmp
+					+ roundup_ccbsize);
+				dma_coherent_handle = dma_coherent_handle +
roundup_ccbsize;
+			}
+			break;
+		}
+		case ACB_ADAPTER_TYPE_C: {
+			roundup_ccbsize = roundup(sizeof(struct
CommandControlBlock)
+				+ (max_sg_entrys - 1) * sizeof(struct
SG64ENTRY), 32);
+			acb->uncache_size = roundup_ccbsize *
ARCMSR_MAX_FREECCB_NUM;
+			dma_coherent = dma_alloc_coherent(&pdev->dev,
acb->uncache_size
+				, &dma_coherent_handle, GFP_KERNEL);
+			if (!dma_coherent) {
+				printk(KERN_NOTICE "DMA allocation
failed\n");
+				return -ENOMEM;
+			}
+			memset(dma_coherent, 0, acb->uncache_size);
+			acb->dma_coherent = dma_coherent;
+			acb->dma_coherent_handle = dma_coherent_handle;
+			acb->vir2phy_offset = (unsigned long)dma_coherent
+				- (unsigned long)dma_coherent_handle;
+			ccb_tmp = dma_coherent;
+			for (i = 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {
+				cdb_phyaddr = dma_coherent_handle
+					+ offsetof(struct
CommandControlBlock, arcmsr_cdb);
+				ccb_tmp->cdb_phyaddr = cdb_phyaddr;
+				acb->pccb_pool[i] = ccb_tmp;
+				ccb_tmp->acb = acb;
+				INIT_LIST_HEAD(&ccb_tmp->list);
+				list_add_tail(&ccb_tmp->list,
&acb->ccb_free_list);
+				ccb_tmp = (struct CommandControlBlock *)
+					((unsigned long)ccb_tmp +
roundup_ccbsize);
+				dma_coherent_handle = dma_coherent_handle
+					+ roundup_ccbsize;
+			}
+			break;
+		}
+		case ACB_ADAPTER_TYPE_D: {
+			void *dma_coherent;
+			dma_addr_t dma_coherent_handle;
+
+			roundup_ccbsize = roundup(sizeof(struct
CommandControlBlock)
+				+ (max_sg_entrys - 1) * sizeof(struct
SG64ENTRY), 32);
+			dma_coherent = dma_alloc_coherent(&pdev->dev,
roundup_ccbsize
+				* ARCMSR_MAX_FREECCB_NUM,
+				&dma_coherent_handle, GFP_KERNEL);
+			if (!dma_coherent) {
+				printk(KERN_NOTICE "DMA allocation
failed\n");
+				return -ENOMEM;
+			}
+			acb->roundup_ccbsize = roundup_ccbsize;
+			acb->dma_coherent2 = dma_coherent;
+			acb->dma_coherent_handle2 = dma_coherent_handle;
+			ccb_tmp = dma_coherent;
+			acb->vir2phy_offset = (unsigned long)dma_coherent -
(unsigned long)dma_coherent_handle;
+			for (i = 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {
+				cdb_phyaddr =
+					dma_coherent_handle
+					+ offsetof(struct
CommandControlBlock, arcmsr_cdb);
+				ccb_tmp->cdb_phyaddr = cdb_phyaddr;
+				acb->pccb_pool[i] = ccb_tmp;
+				ccb_tmp->acb = acb;
+				INIT_LIST_HEAD(&ccb_tmp->list);
+				list_add_tail(&ccb_tmp->list,
&acb->ccb_free_list);
+				ccb_tmp = (struct CommandControlBlock
*)((unsigned long)ccb_tmp
+					+ roundup_ccbsize);
+				dma_coherent_handle = dma_coherent_handle +
roundup_ccbsize;
+			}
+		}
 	}
+	for (i = 0; i < ARCMSR_MAX_TARGETID; i++)
+		for (j = 0; j < ARCMSR_MAX_TARGETLUN; j++)
+			acb->devstate[i][j] = ARECA_RAID_GONE;
 	return 0;
 }
 
@@ -533,7 +702,6 @@ static void arcmsr_message_isr_bh_fn(str
 			}
 			break;
 		}
-
 		case ACB_ADAPTER_TYPE_B: {
 			struct MessageUnit_B *reg  = acb->pmuB;
 			char *acb_dev_map = (char *)acb->device_map;
@@ -606,7 +774,52 @@ static void arcmsr_message_isr_bh_fn(str
 					acb_dev_map++;
 				}
 			}
+			break;
 		}
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
+			for (target = 0; target < ARCMSR_MAX_TARGETID - 1;
target++) {
+				diff = (*acb_dev_map) ^ ioread8(devicemap);
+				if (diff != 0) {
+					char temp;
+					*acb_dev_map = ioread8(devicemap);
+					temp = *acb_dev_map;
+					for (lun = 0; lun <
ARCMSR_MAX_TARGETLUN;
+					lun++) {
+						if ((temp & 0x01) == 1 &&
+							(diff & 0x01) == 1)
{
+
scsi_add_device(acb->host,
+								0, target,
lun);
+						} else if ((temp & 0x01) ==
0
+						&& (diff & 0x01) == 1) {
+							psdev =
scsi_device_lookup(acb->host,
+								0, target,
lun);
+							if (psdev != NULL) {
+
scsi_remove_device(psdev);
+
scsi_device_put(psdev);
+							}
+						}
+						temp >>= 1;
+						diff >>= 1;
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
 
@@ -773,6 +986,7 @@ static int arcmsr_probe(struct pci_dev *
 	}
 	spin_lock_init(&acb->eh_lock);
 	spin_lock_init(&acb->ccblist_lock);
+	spin_lock_init(&acb->postq_lock);
 	acb->acb_flags |= (ACB_F_MESSAGE_WQBUFFER_CLEARED |
 			ACB_F_MESSAGE_RQBUFFER_CLEARED |
 			ACB_F_MESSAGE_WQBUFFER_READED);
@@ -789,7 +1003,7 @@ static int arcmsr_probe(struct pci_dev *
 	}
 	error = arcmsr_alloc_ccb_pool(acb);
 	if(error){
-		goto free_hbb_mu;
+		goto free_mu;
 	}
 	error = scsi_add_host(host, &pdev->dev);
 	if(error){
@@ -854,8 +1068,8 @@ RAID_controller_stop:
 	arcmsr_stop_adapter_bgrb(acb);
 	arcmsr_flush_adapter_cache(acb);
 	arcmsr_free_ccb_pool(acb);
-free_hbb_mu:
-	arcmsr_free_hbb_mu(acb);
+free_mu:
+	arcmsr_free_mu(acb);
 unmap_pci_region:
 	arcmsr_unmap_pciregion(acb);
 pci_release_regs:
@@ -906,6 +1120,19 @@ static uint8_t arcmsr_hbaC_abort_allcmd(
 	}
 	return true;
 }
+static uint8_t arcmsr_hbaD_abort_allcmd(struct AdapterControlBlock *pACB)
+{
+	struct MessageUnit_D __iomem *reg = (struct MessageUnit_D
*)pACB->pmuD;
+
+	iowrite32(ARCMSR_INBOUND_MESG0_ABORT_CMD, reg->inbound_msgaddr0);
+	if (!arcmsr_hbaD_wait_msgint_ready(pACB)) {
+		printk(KERN_NOTICE
+			"arcmsr%d: wait 'abort all outstanding command'
timeout \n"
+			, pACB->host->host_no);
+		return false;
+	}
+	return true;
+}
 static uint8_t arcmsr_abort_allcmd(struct AdapterControlBlock *acb)
 {
 	uint8_t rtnval = 0;
@@ -923,6 +1150,10 @@ static uint8_t arcmsr_abort_allcmd(struc
 	case ACB_ADAPTER_TYPE_C: {
 		rtnval = arcmsr_hbaC_abort_allcmd(acb);
 		}
+		break;
+	case ACB_ADAPTER_TYPE_D: {
+		rtnval = arcmsr_hbaD_abort_allcmd(acb);
+		}
 	}
 	return rtnval;
 }
@@ -993,14 +1224,20 @@ static u32 arcmsr_disable_outbound_ints(
 		writel(0, reg->iop2drv_doorbell_mask);
 		}
 		break;
-	case ACB_ADAPTER_TYPE_C:{
+	case ACB_ADAPTER_TYPE_C: {
 		struct MessageUnit_C *reg = (struct MessageUnit_C
*)acb->pmuC;
 		/* disable all outbound interrupt */
 		orig_mask = ioread32(&reg->host_int_mask); /* disable
outbound message0 int */
-		iowrite32(orig_mask|ARCMSR_HBCMU_ALL_INTMASKENABLE,
&reg->host_int_mask);
+		iowrite32(orig_mask | ARCMSR_HBCMU_ALL_INTMASKENABLE,
&reg->host_int_mask);
 		ioread32(&reg->host_int_mask);/* Dummy ioread32 to force pci
flush */
 		}
 		break;
+	case ACB_ADAPTER_TYPE_D: {
+		struct MessageUnit_D __iomem *reg = (struct MessageUnit_D
*)acb->pmuD;
+		/* disable all outbound interrupt */
+		iowrite32(ARCMSR_ARC1214_ALL_INT_DISABLE,
reg->pcief0_int_enable);
+		break;
+	}
 	}
 	return orig_mask;
 }
@@ -1043,8 +1280,8 @@ static void arcmsr_report_ccb_state(stru
 
 		default:
 			printk(KERN_NOTICE
-				"arcmsr%d: scsi id = %d lun = %d isr get
command error done, \
-				but got unknown DeviceStatus = 0x%x \n"
+				"arcmsr%d: scsi id = %d lun = %d isr get
command error done, "
+				"but got unknown DeviceStatus = 0x%x \n"
 				, acb->host->host_no
 				, id
 				, lun
@@ -1073,8 +1310,8 @@ static void arcmsr_drain_donequeue(struc
 			}
 			return;
 		}
-		printk(KERN_NOTICE "arcmsr%d: isr get an illegal ccb command
\
-				done acb = '0x%p'"
+		printk(KERN_NOTICE "arcmsr%d: isr get an illegal ccb command
"
+				"done acb = '0x%p'"
 				"ccb = '0x%p' ccbacb = '0x%p' startdone =
0x%x"
 				" ccboutstandingcount = %d \n"
 				, acb->host->host_no
@@ -1147,7 +1384,52 @@ static void arcmsr_done4abort_postqueue(
 			error = (flag_ccb &
ARCMSR_CCBREPLY_FLAG_ERROR_MODE1) ? true : false;
 			arcmsr_drain_donequeue(acb, pCCB, error);
 		}
+		break;
 	}
+	case ACB_ADAPTER_TYPE_D: {
+		struct MessageUnit_D __iomem *pmu = acb->pmuD;
+		uint32_t ccb_cdb_phy, outbound_write_pointer;
+		uint32_t doneq_index, index_stripped, addressLow, residual;
+		struct CommandControlBlock *pCCB;
+		bool error;
+		outbound_write_pointer =
ioread32(pmu->outboundlist_copy_pointer);
+		doneq_index = pmu->doneq_index;
+		residual = atomic_read(&acb->ccboutstandingcount);
+		for (i = 0; i < residual; i++) {
+			while ((doneq_index & 0xFF) !=
(outbound_write_pointer & 0xFF)) {
+				if (doneq_index & 0x4000) {
+					index_stripped = doneq_index & 0xFF;
+					index_stripped += 1;
+					index_stripped %=
ARCMSR_MAX_ARC1214_POSTQUEUE;
+					pmu->doneq_index = index_stripped ?
+						(index_stripped | 0x4000) :
index_stripped;
+				} else {
+					index_stripped = doneq_index;
+					index_stripped += 1;
+					index_stripped %=
ARCMSR_MAX_ARC1214_POSTQUEUE;
+					pmu->doneq_index = index_stripped ?
+						index_stripped :
(index_stripped | 0x4000);
+				}
+				doneq_index = pmu->doneq_index;
+				addressLow = pmu->done_qbuffer[doneq_index &
0xFF].addressLow;
+				ccb_cdb_phy = (addressLow & 0xFFFFFFF0);
+				pARCMSR_CDB = (struct  ARCMSR_CDB
*)(acb->vir2phy_offset
+					+ ccb_cdb_phy);
+				pCCB = container_of(pARCMSR_CDB, struct
CommandControlBlock,
+					arcmsr_cdb);
+				error = (addressLow &
ARCMSR_CCBREPLY_FLAG_ERROR_MODE1)
+					? true : false;
+				arcmsr_drain_donequeue(acb, pCCB, error);
+				iowrite32(doneq_index,
pmu->outboundlist_read_pointer);
+			}
+			mdelay(10);
+			outbound_write_pointer =
ioread32(pmu->outboundlist_copy_pointer);
+			doneq_index = pmu->doneq_index;
+		}
+		pmu->postq_index = 0;
+		pmu->doneq_index = 0x40FF;
+		break;
+		}
 	}
 }
 static void arcmsr_remove(struct pci_dev *pdev)
@@ -1168,7 +1450,7 @@ static void arcmsr_remove(struct pci_dev
 	for (poll_count = 0; poll_count < ARCMSR_MAX_OUTSTANDING_CMD;
poll_count++){
 		if (!atomic_read(&acb->ccboutstandingcount))
 			break;
-		arcmsr_interrupt(acb);/* FIXME: need spinlock */
+		arcmsr_interrupt(acb);
 		msleep(25);
 	}
 	if (atomic_read(&acb->ccboutstandingcount)) {
@@ -1184,7 +1466,7 @@ static void arcmsr_remove(struct pci_dev
 		}
 	}
 	arcmsr_free_ccb_pool(acb);
-	arcmsr_free_hbb_mu(acb);
+	arcmsr_free_mu(acb);
 	if (acb->acb_flags & ACB_F_MSI_ENABLED) {
 		free_irq(pdev->irq, acb);
 		pci_disable_msi(pdev);
@@ -1266,11 +1548,18 @@ static void arcmsr_enable_outbound_ints(
 		break;
 	case ACB_ADAPTER_TYPE_C: {
 		struct MessageUnit_C *reg = acb->pmuC;
-		mask = ~(ARCMSR_HBCMU_UTILITY_A_ISR_MASK |
ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR_MASK|ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR_
MASK);
+		mask = ~(ARCMSR_HBCMU_ALL_INTMASKENABLE);
 		iowrite32(intmask_org & mask, &reg->host_int_mask);
 		ioread32(&reg->host_int_mask);
 		acb->outbound_int_enable = ~(intmask_org & mask) &
0x0000000f;
+		break;
 		}
+	case ACB_ADAPTER_TYPE_D: {
+		struct MessageUnit_D __iomem *reg = acb->pmuD;
+		mask = ARCMSR_ARC1214_ALL_INT_ENABLE;
+		iowrite32(intmask_org | mask, reg->pcief0_int_enable);
+		ioread32(reg->pcief0_int_enable);/* Dummy ioread32 to force
pci flush */
+	}
 	}
 }
 
@@ -1290,7 +1579,6 @@ static int arcmsr_build_ccb(struct Adapt
 	arcmsr_cdb->TargetID = pcmd->device->id;
 	arcmsr_cdb->LUN = pcmd->device->lun;
 	arcmsr_cdb->Function = 1;
-	arcmsr_cdb->Context = 0;
 	memcpy(arcmsr_cdb->Cdb, pcmd->cmnd, pcmd->cmd_len);
 
 	nseg = scsi_dma_map(pcmd);
@@ -1331,8 +1619,9 @@ static int arcmsr_build_ccb(struct Adapt
 
 static void arcmsr_post_ccb(struct AdapterControlBlock *acb, struct
CommandControlBlock *ccb)
 {
-	uint32_t cdb_phyaddr_pattern = ccb->cdb_phyaddr_pattern;
+	uint32_t cdb_phyaddr = ccb->cdb_phyaddr;
 	struct ARCMSR_CDB *arcmsr_cdb = (struct ARCMSR_CDB
*)&ccb->arcmsr_cdb;
+	u32 arccdbsize = ccb->arc_cdb_size;
 	atomic_inc(&acb->ccboutstandingcount);
 	ccb->startdone = ARCMSR_CCB_START;
 	switch (acb->adapter_type) {
@@ -1340,10 +1629,10 @@ static void arcmsr_post_ccb(struct Adapt
 		struct MessageUnit_A __iomem *reg = acb->pmuA;
 
 		if (arcmsr_cdb->Flags & ARCMSR_CDB_FLAG_SGL_BSIZE)
-			writel(cdb_phyaddr_pattern |
ARCMSR_CCBPOST_FLAG_SGL_BSIZE,
+			writel(cdb_phyaddr | ARCMSR_CCBPOST_FLAG_SGL_BSIZE,
 			&reg->inbound_queueport);
 		else {
-				writel(cdb_phyaddr_pattern,
&reg->inbound_queueport);
+				writel(cdb_phyaddr,
&reg->inbound_queueport);
 		}
 		}
 		break;
@@ -1355,10 +1644,10 @@ static void arcmsr_post_ccb(struct Adapt
 		ending_index = ((index + 1) % ARCMSR_MAX_HBB_POSTQUEUE);
 		writel(0, &reg->post_qbuffer[ending_index]);
 		if (arcmsr_cdb->Flags & ARCMSR_CDB_FLAG_SGL_BSIZE) {
-			writel(cdb_phyaddr_pattern |
ARCMSR_CCBPOST_FLAG_SGL_BSIZE,\
+			writel(cdb_phyaddr | ARCMSR_CCBPOST_FLAG_SGL_BSIZE,\
 						 &reg->post_qbuffer[index]);
 		} else {
-			writel(cdb_phyaddr_pattern,
&reg->post_qbuffer[index]);
+			writel(cdb_phyaddr, &reg->post_qbuffer[index]);
 		}
 		index++;
 		index %= ARCMSR_MAX_HBB_POSTQUEUE;/*if last index number set
it to 0 */
@@ -1371,7 +1660,7 @@ static void arcmsr_post_ccb(struct Adapt
 		uint32_t ccb_post_stamp, arc_cdb_size;
 
 		arc_cdb_size = (ccb->arc_cdb_size > 0x300) ? 0x300 :
ccb->arc_cdb_size;
-		ccb_post_stamp = (cdb_phyaddr_pattern | ((arc_cdb_size - 1)
>> 6) | 1);
+		ccb_post_stamp = (cdb_phyaddr | ((arc_cdb_size - 1) >> 6) |
1);
 		if (acb->cdb_phyaddr_hi32) {
 			iowrite32(acb->cdb_phyaddr_hi32,
&phbcmu->inbound_queueport_high);
 			iowrite32(ccb_post_stamp,
&phbcmu->inbound_queueport_low);
@@ -1379,10 +1668,39 @@ static void arcmsr_post_ccb(struct Adapt
 			iowrite32(ccb_post_stamp,
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
+		pinbound_srb = (struct InBound_SRB
*)&pmu->post_qbuffer[postq_index & 0xFF];
+		pinbound_srb->addressHigh = dma_addr_hi32(cdb_phyaddr);
+		pinbound_srb->addressLow= dma_addr_lo32(cdb_phyaddr);
+		pinbound_srb->length= arccdbsize / 4;
+		arcmsr_cdb->msgContext = dma_addr_lo32(cdb_phyaddr);
+		if (postq_index & 0x4000) {
+			index_stripped = postq_index & 0xFF;
+			index_stripped += 1;
+			index_stripped %= ARCMSR_MAX_ARC1214_POSTQUEUE;
+			pmu->postq_index = index_stripped ? (index_stripped
| 0x4000) : index_stripped;
+		} else {
+			index_stripped = postq_index;
+			index_stripped += 1;
+			index_stripped %= ARCMSR_MAX_ARC1214_POSTQUEUE;
+			pmu->postq_index = index_stripped ? index_stripped :
(index_stripped | 0x4000);
+		}
+		iowrite32(postq_index, pmu->inboundlist_write_pointer);
+		spin_unlock_irqrestore(&acb->postq_lock, flags);
+		//ioread32(pmu->inboundlist_write_pointer);//Dummy in case
of regiser's cache effect
+	}
 	}
 }
 
-static void arcmsr_stop_hba_bgrb(struct AdapterControlBlock *acb)
+static void arcmsr_hbaA_stop_bgrb(struct AdapterControlBlock *acb)
 {
 	struct MessageUnit_A __iomem *reg = acb->pmuA;
 	acb->acb_flags &= ~ACB_F_MSG_START_BGRB;
@@ -1394,7 +1712,7 @@ static void arcmsr_stop_hba_bgrb(struct
 	}
 }
 
-static void arcmsr_stop_hbb_bgrb(struct AdapterControlBlock *acb)
+static void arcmsr_hbaB_stop_bgrb(struct AdapterControlBlock *acb)
 {
 	struct MessageUnit_B *reg = acb->pmuB;
 	acb->acb_flags &= ~ACB_F_MSG_START_BGRB;
@@ -1406,8 +1724,7 @@ static void arcmsr_stop_hbb_bgrb(struct
 			, acb->host->host_no);
 	}
 }
-
-static void arcmsr_stop_hbc_bgrb(struct AdapterControlBlock *pACB)
+static void arcmsr_hbaC_stop_bgrb(struct AdapterControlBlock *pACB)
 {
 	struct MessageUnit_C *reg = (struct MessageUnit_C *)pACB->pmuC;
 	pACB->acb_flags &= ~ACB_F_MSG_START_BGRB;
@@ -1422,27 +1739,56 @@ static void arcmsr_stop_hbc_bgrb(struct
 	}
 	return;
 }
+static void arcmsr_hbaD_stop_bgrb(struct AdapterControlBlock *pACB)
+{
+	struct MessageUnit_D __iomem *reg = (struct MessageUnit_D
*)pACB->pmuD;
+
+	pACB->acb_flags &= ~ACB_F_MSG_START_BGRB;
+	iowrite32(ARCMSR_INBOUND_MESG0_STOP_BGRB, reg->inbound_msgaddr0);
+	if (!arcmsr_hbaD_wait_msgint_ready(pACB)) {
+		printk(KERN_NOTICE
+			"arcmsr%d: wait 'stop adapter background rebulid'
timeout \n"
+			, pACB->host->host_no);
+	}
+	return;
+}
 static void arcmsr_stop_adapter_bgrb(struct AdapterControlBlock *acb)
 {
 	switch (acb->adapter_type) {
 	case ACB_ADAPTER_TYPE_A: {
-		arcmsr_stop_hba_bgrb(acb);
+		arcmsr_hbaA_stop_bgrb(acb);
 		}
 		break;
-
 	case ACB_ADAPTER_TYPE_B: {
-		arcmsr_stop_hbb_bgrb(acb);
+		arcmsr_hbaB_stop_bgrb(acb);
 		}
 		break;
 	case ACB_ADAPTER_TYPE_C: {
-		arcmsr_stop_hbc_bgrb(acb);
+		arcmsr_hbaC_stop_bgrb(acb);
 		}
+		break;
+	case ACB_ADAPTER_TYPE_D: {
+		arcmsr_hbaD_stop_bgrb(acb);
+		break;
+	}
 	}
 }
 
 static void arcmsr_free_ccb_pool(struct AdapterControlBlock *acb)
 {
-	dma_free_coherent(&acb->pdev->dev, acb->uncache_size,
acb->dma_coherent, acb->dma_coherent_handle);
+	switch (acb->adapter_type) {
+		case ACB_ADAPTER_TYPE_A:
+		case ACB_ADAPTER_TYPE_C:
+		case ACB_ADAPTER_TYPE_B:
+			dma_free_coherent(&acb->pdev->dev,
acb->uncache_size,
+				acb->dma_coherent,
acb->dma_coherent_handle);
+			break;
+		case ACB_ADAPTER_TYPE_D: {
+			dma_free_coherent(&acb->pdev->dev,
acb->roundup_ccbsize,
+				acb->dma_coherent2,
acb->dma_coherent_handle2);
+			break;
+		}
+	}
 }
 
 void arcmsr_iop_message_read(struct AdapterControlBlock *acb)
@@ -1464,6 +1810,13 @@ void arcmsr_iop_message_read(struct Adap
 		iowrite32(ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK,
&reg->inbound_doorbell);
 		ioread32(&reg->inbound_doorbell);
 		}
+		break;
+	case ACB_ADAPTER_TYPE_D: {
+		struct MessageUnit_D __iomem *reg = acb->pmuD;
+		iowrite32(ARCMSR_ARC1214_DRV2IOP_DATA_OUT_READ,
reg->inbound_doorbell);
+		ioread32(reg->inbound_doorbell);
+		break;
+	}
 	}
 }
 
@@ -1499,6 +1852,16 @@ static void arcmsr_iop_message_wrote(str
 		ioread32(&reg->inbound_doorbell);
 		}
 		break;
+	case ACB_ADAPTER_TYPE_D: {
+		struct MessageUnit_D __iomem *reg = acb->pmuD;
+		/*
+		** push inbound doorbell tell iop, driver data write ok
+		** and wait reply on next hwinterrupt for next Qbuffer post
+		*/
+		iowrite32(ARCMSR_ARC1214_DRV2IOP_DATA_IN_READY,
reg->inbound_doorbell);
+		ioread32(reg->inbound_doorbell);/* Dummy ioread32 to force
pci flush */
+		break;
+	}
 	}
 }
 
@@ -1521,7 +1884,13 @@ struct QBUFFER __iomem *arcmsr_get_iop_r
 	case ACB_ADAPTER_TYPE_C: {
 		struct MessageUnit_C *phbcmu = (struct MessageUnit_C
*)acb->pmuC;
 		qbuffer = (struct QBUFFER __iomem
*)&phbcmu->message_rbuffer;
+		break;
 		}
+	case ACB_ADAPTER_TYPE_D: {
+		struct MessageUnit_D __iomem *reg = (struct MessageUnit_D
*)acb->pmuD;
+		qbuffer = (struct QBUFFER __iomem *)reg->message_rbuffer;
+		break;
+	}
 	}
 	return qbuffer;
 }
@@ -1545,8 +1914,13 @@ static struct QBUFFER __iomem *arcmsr_ge
 	case ACB_ADAPTER_TYPE_C: {
 		struct MessageUnit_C *reg = (struct MessageUnit_C
*)acb->pmuC;
 		pqbuffer = (struct QBUFFER __iomem *)&reg->message_wbuffer;
+		break;
+		}
+	case ACB_ADAPTER_TYPE_D: {
+		struct MessageUnit_D __iomem *pmu = (struct MessageUnit_D
*)acb->pmuD;
+		pqbuffer = (struct QBUFFER __iomem *)pmu->message_wbuffer;
+		break;
 	}
-
 	}
 	return pqbuffer;
 }
@@ -1661,6 +2035,34 @@ static void arcmsr_hbaC_doorbell_isr(str
 	return;
 }
 
+static void arcmsr_hbaD_doorbell_isr(struct AdapterControlBlock *pACB)
+{
+	uint32_t outbound_doorbell;
+	struct MessageUnit_D __iomem *pmu = (struct MessageUnit_D
*)pACB->pmuD;
+
+	outbound_doorbell = ioread32(pmu->outbound_doorbell);
+	if (unlikely(!outbound_doorbell)) {
+		WARN(1, "%s: outbound_doorbell null\n", __func__);
+		arcmsr_iop2drv_data_wrote_handle(pACB);
+		arcmsr_iop2drv_data_read_handle(pACB);
+	}
+	do {
+		iowrite32(outbound_doorbell, pmu->outbound_doorbell);/*clear
interrupt*/
+		if (outbound_doorbell &
ARCMSR_ARC1214_IOP2DRV_MESSAGE_CMD_DONE) {
+			arcmsr_hbaD_message_isr(pACB);
+		}
+		if (outbound_doorbell &
ARCMSR_ARC1214_IOP2DRV_DATA_WRITE_OK) {
+			arcmsr_iop2drv_data_wrote_handle(pACB);
+		}
+		if (outbound_doorbell & ARCMSR_ARC1214_IOP2DRV_DATA_READ_OK)
{
+			arcmsr_iop2drv_data_read_handle(pACB);
+		}
+		outbound_doorbell = ioread32(pmu->outbound_doorbell);
+	} while (outbound_doorbell & (ARCMSR_ARC1214_IOP2DRV_DATA_WRITE_OK |
+		ARCMSR_ARC1214_IOP2DRV_DATA_READ_OK |
+		ARCMSR_ARC1214_IOP2DRV_MESSAGE_CMD_DONE));
+	return;
+}
 static void arcmsr_hbaA_postqueue_isr(struct AdapterControlBlock *acb)
 {
 	uint32_t flag_ccb;
@@ -1724,6 +2126,45 @@ static void arcmsr_hbaC_postqueue_isr(st
 	ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR);
 }
 
+static void arcmsr_hbaD_postqueue_isr(struct AdapterControlBlock *acb)
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
+				index_stripped %=
ARCMSR_MAX_ARC1214_POSTQUEUE;
+				pmu->doneq_index = index_stripped ?
(index_stripped | 0x4000) : index_stripped;
+			} else {
+				index_stripped = doneq_index;
+				index_stripped += 1;
+				index_stripped %=
ARCMSR_MAX_ARC1214_POSTQUEUE;
+				pmu->doneq_index = index_stripped ?
index_stripped : (index_stripped | 0x4000);
+			}
+			doneq_index = pmu->doneq_index;
+			addressLow = pmu->done_qbuffer[doneq_index &
0xFF].addressLow;
+			ccb_cdb_phy = (addressLow & 0xFFFFFFF0);/*frame must
be 32 bytes aligned*/
+			arcmsr_cdb = (struct ARCMSR_CDB
*)(acb->vir2phy_offset + ccb_cdb_phy);
+			ccb = container_of(arcmsr_cdb, struct
CommandControlBlock, arcmsr_cdb);
+			error = (addressLow &
ARCMSR_CCBREPLY_FLAG_ERROR_MODE1) ? true : false;
+			arcmsr_drain_donequeue(acb, ccb, error);
+			iowrite32(doneq_index,
pmu->outboundlist_read_pointer);
+		} while ((doneq_index & 0xFF) != (outbound_write_pointer &
0xFF));
+	}
+	iowrite32(ARCMSR_ARC1214_OUTBOUND_LIST_INTERRUPT_CLEAR,
pmu->outboundlist_interrupt_cause);
+	ioread32(pmu->outboundlist_interrupt_cause);/*Dummy ioread32 to
force pci flush */
+}
+
 static void arcmsr_hbaA_message_isr(struct AdapterControlBlock *acb)
 {
 	struct MessageUnit_A *reg  = acb->pmuA;
@@ -1748,6 +2189,15 @@ static void arcmsr_hbaC_message_isr(stru
 	schedule_work(&acb->arcmsr_do_message_isr_bh);
 }
 
+static void arcmsr_hbaD_message_isr(struct AdapterControlBlock *acb)
+{
+	struct MessageUnit_D __iomem *reg  = acb->pmuD;
+	iowrite32(ARCMSR_ARC1214_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR,
+		reg->outbound_doorbell);
+	ioread32(reg->outbound_doorbell);/* Dummy ioread32 to force pci
flush */
+	schedule_work(&acb->arcmsr_do_message_isr_bh);
+}
+
 static irqreturn_t arcmsr_hbaA_handle_isr(struct AdapterControlBlock *acb)
 {
 	uint32_t outbound_intstatus;
@@ -1834,6 +2284,26 @@ static irqreturn_t arcmsr_hbaC_handle_is
 	return IRQ_HANDLED;
 }
 
+static irqreturn_t arcmsr_hbaD_handle_isr(struct AdapterControlBlock *pACB)
+{
+	u32 host_interrupt_status;
+	struct MessageUnit_D __iomem *pmu = (struct MessageUnit_D
*)pACB->pmuD;
+
+	host_interrupt_status = ioread32(pmu->host_int_status);
+	do {
+		/* MU post queue interrupts*/
+		if (host_interrupt_status &
ARCMSR_ARC1214_OUTBOUND_POSTQUEUE_ISR) {
+			arcmsr_hbaD_postqueue_isr(pACB);
+		}
+		if (host_interrupt_status &
ARCMSR_ARC1214_OUTBOUND_DOORBELL_ISR) {
+			arcmsr_hbaD_doorbell_isr(pACB);
+		}
+		host_interrupt_status = ioread32(pmu->host_int_status);
+	} while (host_interrupt_status &
(ARCMSR_ARC1214_OUTBOUND_POSTQUEUE_ISR |
+		ARCMSR_ARC1214_OUTBOUND_DOORBELL_ISR));
+	return IRQ_HANDLED;
+}
+
 static irqreturn_t arcmsr_interrupt(struct AdapterControlBlock *acb)
 {
 	switch (acb->adapter_type) {
@@ -1849,6 +2319,10 @@ static irqreturn_t arcmsr_interrupt(stru
 			return arcmsr_hbaC_handle_isr(acb);
 			break;
 		}
+		case ACB_ADAPTER_TYPE_D: {
+			return arcmsr_hbaD_handle_isr(acb);
+			break;
+		}
 		default:
 			return IRQ_NONE;
 	}
@@ -2344,7 +2818,7 @@ static bool arcmsr_hbaB_get_config(struc
 		printk(KERN_NOTICE "arcmsr%d: dma_alloc_coherent got error
for hbb mu\n", acb->host->host_no);
 		return false;
 	}
-	acb->dma_coherent_handle_hbb_mu = dma_coherent_handle;
+	acb->dma_coherent_handle2 = dma_coherent_handle;
 	reg = (struct MessageUnit_B *)dma_coherent;
 	acb->pmuB = reg;
 	reg->drv2iop_doorbell= (uint32_t __iomem *)((unsigned
long)acb->mem_base0 + ARCMSR_DRV2IOP_DOORBELL);
@@ -2360,8 +2834,8 @@ static bool arcmsr_hbaB_get_config(struc
 
 	writel(ARCMSR_MESSAGE_GET_CONFIG, reg->drv2iop_doorbell);
 	if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
-		printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware \
-			miscellaneous data' timeout \n",
acb->host->host_no);
+		printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware "
+			"miscellaneous data' timeout \n",
acb->host->host_no);
 		return false;
 	}
 	count = 8;
@@ -2428,15 +2902,17 @@ static bool arcmsr_hbaC_get_config(struc
 	iowrite32(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,
&reg->inbound_doorbell);
 	/* wait message ready */
 	for (Index = 0; Index < 2000; Index++) {
-		if (ioread32(&reg->outbound_doorbell) &
ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {
-
iowrite32(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR,
&reg->outbound_doorbell_clear);/*clear interrupt*/
+		if (ioread32(&reg->outbound_doorbell)
+			& ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {
+
iowrite32(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR
+				, &reg->outbound_doorbell_clear);
 			break;
 		}
 		udelay(10);
 	} /*max 1 seconds*/
 	if (Index >= 2000) {
-		printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware \
-			miscellaneous data' timeout \n",
pACB->host->host_no);
+		printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware "
+			"miscellaneous data' timeout \n",
pACB->host->host_no);
 		return false;
 	}
 	count = 8;
@@ -2465,14 +2941,161 @@ static bool arcmsr_hbaC_get_config(struc
 	/*all interrupt service will be enable at arcmsr_iop_init*/
 	return true;
 }
+
+ bool arcmsr_hbaD_get_config(struct AdapterControlBlock *acb)
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
+		&dma_coherent_handle, GFP_KERNEL);
+	if (!dma_coherent) {
+		printk(KERN_NOTICE "DMA allocation
failed...........................\n");
+		return -ENOMEM;
+	}
+	memset(dma_coherent, 0, acb->uncache_size);
+	acb->dma_coherent = dma_coherent;
+	acb->dma_coherent_handle = dma_coherent_handle;
+	reg = (struct MessageUnit_D *)dma_coherent;
+	acb->pmuD = reg;
+	reg->chip_id = (u32 __iomem *)((unsigned long)acb->mem_base0
+		+ ARCMSR_ARC1214_CHIP_ID);
+	reg->cpu_mem_config = (u32 __iomem *)((unsigned long)acb->mem_base0
+		+ ARCMSR_ARC1214_CPU_MEMORY_CONFIGURATION);
+	reg->i2o_host_interrupt_mask = (u32 __iomem *)((unsigned
long)acb->mem_base0
+		+ ARCMSR_ARC1214_I2_HOST_INTERRUPT_MASK);
+	reg->sample_at_reset = (u32 __iomem *)((unsigned long)acb->mem_base0
+		+ ARCMSR_ARC1214_SAMPLE_RESET);
+	reg->reset_request = (u32 __iomem *)((unsigned long)acb->mem_base0
+		+ ARCMSR_ARC1214_RESET_REQUEST);
+	reg->host_int_status = (u32 __iomem *)((unsigned long)acb->mem_base0
+		+ ARCMSR_ARC1214_MAIN_INTERRUPT_STATUS);
+	reg->pcief0_int_enable = (u32 __iomem *)((unsigned
long)acb->mem_base0
+		+ ARCMSR_ARC1214_PCIE_F0_INTERRUPT_ENABLE);
+	reg->inbound_msgaddr0 = (u32 __iomem *)((unsigned
long)acb->mem_base0
+		+ ARCMSR_ARC1214_INBOUND_MESSAGE0);
+	reg->inbound_msgaddr1 = (u32 __iomem *)((unsigned
long)acb->mem_base0
+		+ ARCMSR_ARC1214_INBOUND_MESSAGE1);
+	reg->outbound_msgaddr0 = (u32 __iomem *)((unsigned
long)acb->mem_base0
+		+ ARCMSR_ARC1214_OUTBOUND_MESSAGE0);
+	reg->outbound_msgaddr1 = (u32 __iomem *)((unsigned
long)acb->mem_base0
+		+ ARCMSR_ARC1214_OUTBOUND_MESSAGE1);
+	reg->inbound_doorbell = (u32 __iomem *)((unsigned
long)acb->mem_base0
+		+ ARCMSR_ARC1214_INBOUND_DOORBELL);
+	reg->outbound_doorbell = (u32 __iomem *)((unsigned
long)acb->mem_base0
+		+ ARCMSR_ARC1214_OUTBOUND_DOORBELL);
+	reg->outbound_doorbell_enable = (u32 __iomem *)((unsigned
long)acb->mem_base0
+		+ ARCMSR_ARC1214_OUTBOUND_DOORBELL_ENABLE);
+	reg->inboundlist_base_low = (u32 __iomem *)((unsigned
long)acb->mem_base0
+		+ ARCMSR_ARC1214_INBOUND_LIST_BASE_LOW);
+	reg->inboundlist_base_high = (u32 __iomem *)((unsigned
long)acb->mem_base0
+		+ ARCMSR_ARC1214_INBOUND_LIST_BASE_HIGH);
+	reg->inboundlist_write_pointer = (u32 __iomem *)((unsigned
long)acb->mem_base0
+		+ ARCMSR_ARC1214_INBOUND_LIST_WRITE_POINTER);
+	reg->outboundlist_base_low = (u32 __iomem *)((unsigned
long)acb->mem_base0
+		+ ARCMSR_ARC1214_OUTBOUND_LIST_BASE_LOW);
+	reg->outboundlist_base_high = (u32 __iomem *)((unsigned
long)acb->mem_base0
+		+ ARCMSR_ARC1214_OUTBOUND_LIST_BASE_HIGH);
+	reg->outboundlist_copy_pointer = (u32 __iomem *)((unsigned
long)acb->mem_base0
+		+ ARCMSR_ARC1214_OUTBOUND_LIST_COPY_POINTER);
+	reg->outboundlist_read_pointer = (u32 __iomem *)((unsigned
long)acb->mem_base0
+		+ ARCMSR_ARC1214_OUTBOUND_LIST_READ_POINTER);
+	reg->outboundlist_interrupt_cause = (u32 __iomem *)((unsigned
long)acb->mem_base0
+		+ ARCMSR_ARC1214_OUTBOUND_INTERRUPT_CAUSE);
+	reg->outboundlist_interrupt_enable = (u32 __iomem *)((unsigned
long)acb->mem_base0
+		+ ARCMSR_ARC1214_OUTBOUND_INTERRUPT_ENABLE);
+	reg->message_wbuffer = (u32 __iomem *)((unsigned long)acb->mem_base0
+		+ ARCMSR_ARC1214_MESSAGE_WBUFFER);
+	reg->message_rbuffer = (u32 __iomem *)((unsigned long)acb->mem_base0
+		+ ARCMSR_ARC1214_MESSAGE_RBUFFER);
+	reg->msgcode_rwbuffer = (u32 __iomem *)((unsigned
long)acb->mem_base0
+		+ ARCMSR_ARC1214_MESSAGE_RWBUFFER);
+	iop_firm_model = (char __iomem
*)(&reg->msgcode_rwbuffer[15]);/*firm_model,15,60-67*/
+	iop_firm_version = (char __iomem
*)(&reg->msgcode_rwbuffer[17]);/*firm_version,17,68-83*/
+	iop_device_map = (char __iomem
*)(&reg->msgcode_rwbuffer[21]);/*firm_version,21,84-99*/
+	/* disable all outbound interrupt */
+	if (ioread32(acb->pmuD->outbound_doorbell)
+		& ARCMSR_ARC1214_IOP2DRV_MESSAGE_CMD_DONE) {
+
iowrite32(ARCMSR_ARC1214_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR,
+			acb->pmuD->outbound_doorbell);/*clear interrupt*/
+	}
+	/* post "get config" instruction */
+	iowrite32(ARCMSR_INBOUND_MESG0_GET_CONFIG, reg->inbound_msgaddr0);
+	/* wait message ready */
+	if (!arcmsr_hbaD_wait_msgint_ready(acb)) {
+		printk(KERN_NOTICE "arcmsr%d: wait get adapter firmware "
+			"miscellaneous data timeout\n", acb->host->host_no);
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
+		acb->host->host_no, acb->firm_version, acb->firm_model);
+	return true;
+}
+
 static bool arcmsr_get_firmware_spec(struct AdapterControlBlock *acb)
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
 
 static int arcmsr_hbaA_polling_ccbdone(struct AdapterControlBlock *acb,
@@ -2651,6 +3274,70 @@ polling_hbc_ccb_retry:
 	}
 	return rtn;
 }
+
+static int arcmsr_hbaD_polling_ccbdone(struct AdapterControlBlock *acb,
+	struct CommandControlBlock *poll_ccb)
+{
+	bool error;
+	uint32_t poll_ccb_done = 0, poll_count = 0, flag_ccb, ccb_cdb_phy;
+	int rtn, index, outbound_write_pointer;
+	struct ARCMSR_CDB *arcmsr_cdb;
+	struct CommandControlBlock *pCCB;
+	struct MessageUnit_D __iomem *reg = (struct MessageUnit_D
*)acb->pmuD;
+
+	polling_hbaD_ccb_retry:
+	poll_count++;
+	while (1) {
+		outbound_write_pointer =
ioread32(reg->outboundlist_copy_pointer);
+		index = reg->doneq_index;
+		if ((outbound_write_pointer & 0xFF) == index) {
+			if (poll_ccb_done) {
+				rtn = SUCCESS;
+				break;
+			} else {
+				mdelay(25);
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
ccb_cdb_phy);
+		pCCB = container_of(arcmsr_cdb, struct CommandControlBlock,
arcmsr_cdb);
+		poll_ccb_done = (pCCB == poll_ccb) ? 1 : 0;
+		index++;
+		index %= ARCMSR_MAX_ARC1214_POSTQUEUE;
+		reg->doneq_index = index;
+		/* check if command done with no error*/
+		if ((pCCB->acb != acb) || (pCCB->startdone !=
ARCMSR_CCB_START)) {
+			if (pCCB->startdone == ARCMSR_CCB_ABORTED) {
+				printk(KERN_NOTICE "arcmsr%d: scsi id = %d
lun = %d ccb = '0x%p'"
+					" poll command abort successfully
\n"
+					, acb->host->host_no
+					, pCCB->pcmd->device->id
+					, pCCB->pcmd->device->lun
+					, pCCB);
+					pCCB->pcmd->result = DID_ABORT <<
16;
+					arcmsr_ccb_complete(pCCB);
+				continue;
+			}
+			printk(KERN_NOTICE "arcmsr%d: polling an illegal
ccb"
+				" command done ccb = '0x%p'"
+				"ccboutstandingcount = %d \n"
+				, acb->host->host_no
+				, pCCB
+				, atomic_read(&acb->ccboutstandingcount));
+			continue;
+		}
+		error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1) ? true
: false;
+		arcmsr_report_ccb_state(acb, pCCB, error);
+	}
+	return rtn;
+}
+
 static int arcmsr_polling_ccbdone(struct AdapterControlBlock *acb,
 					struct CommandControlBlock
*poll_ccb)
 {
@@ -2669,6 +3356,10 @@ static int arcmsr_polling_ccbdone(struct
 	case ACB_ADAPTER_TYPE_C: {
 		rtn = arcmsr_hbaC_polling_ccbdone(acb, poll_ccb);
 		}
+		break;
+	case ACB_ADAPTER_TYPE_D: {
+		rtn = arcmsr_hbaD_polling_ccbdone(acb, poll_ccb);
+		}
 	}
 	return rtn;
 }
@@ -2705,8 +3396,8 @@ static void arcmsr_iop_confirm(struct Ad
 			writel(ARCMSR_INBOUND_MESG0_SET_CONFIG, \
 
&reg->inbound_msgaddr0);
 			if (!arcmsr_hbaA_wait_msgint_ready(acb)) {
-				printk(KERN_NOTICE "arcmsr%d: ""set ccb high
\
-				part physical address timeout\n",
+				printk(KERN_NOTICE "arcmsr%d: ""set ccb high
"
+				"part physical address timeout\n",
 				acb->host->host_no);
 			}
 			arcmsr_enable_outbound_ints(acb, intmask_org);
@@ -2725,10 +3416,10 @@ static void arcmsr_iop_confirm(struct Ad
 		reg->doneq_index = 0;
 		writel(ARCMSR_MESSAGE_SET_POST_WINDOW,
reg->drv2iop_doorbell);
 		if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
-			printk(KERN_NOTICE "arcmsr%d:can not set diver
mode\n", \
+			printk(KERN_NOTICE "arcmsr%d:can not set diver
mode\n",
 				acb->host->host_no);
 		}
-		post_queue_phyaddr = acb->dma_coherent_handle_hbb_mu;
+		post_queue_phyaddr = acb->dma_coherent_handle2;
 		rwbuffer = reg->message_rwbuffer;
 		/* driver "set config" signature */
 		writel(ARCMSR_SIGNATURE_SET_CONFIG, rwbuffer++);
@@ -2743,8 +3434,8 @@ static void arcmsr_iop_confirm(struct Ad
 
 		writel(ARCMSR_MESSAGE_SET_CONFIG, reg->drv2iop_doorbell);
 		if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
-			printk(KERN_NOTICE "arcmsr%d: 'set command Q window'
\
-			timeout \n",acb->host->host_no);
+			printk(KERN_NOTICE "arcmsr%d: 'set command Q window'
"
+			"timeout \n",acb->host->host_no);
 		}
 		arcmsr_hbb_enable_driver_mode(acb);
 		arcmsr_enable_outbound_ints(acb, intmask_org);
@@ -2761,11 +3452,32 @@ static void arcmsr_iop_confirm(struct Ad
 			iowrite32(ARCMSR_INBOUND_MESG0_SET_CONFIG,
&reg->inbound_msgaddr0);
 			iowrite32(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,
&reg->inbound_doorbell);
 			if (!arcmsr_hbaC_wait_msgint_ready(acb)) {
-				printk(KERN_NOTICE "arcmsr%d: 'set command Q
window' \
-				timeout \n", acb->host->host_no);
+				printk(KERN_NOTICE "arcmsr%d: 'set command Q
window' "
+				"timeout \n", acb->host->host_no);
 			}
 		}
 		}
+		break;
+	case ACB_ADAPTER_TYPE_D: {
+		uint32_t __iomem *rwbuffer;
+
+		struct MessageUnit_D *reg = (struct MessageUnit_D
*)acb->pmuD;
+		reg->postq_index = 0;
+		reg->doneq_index = 0x40FF;
+		rwbuffer = reg->msgcode_rwbuffer;
+		iowrite32(ARCMSR_SIGNATURE_SET_CONFIG, rwbuffer++);
+		iowrite32(cdb_phyaddr_hi32, rwbuffer++);
+		iowrite32(cdb_phyaddr, rwbuffer++);
+		iowrite32(cdb_phyaddr +
+			(ARCMSR_MAX_ARC1214_POSTQUEUE * sizeof(struct
InBound_SRB)),
+			rwbuffer++);
+		iowrite32(0x100, rwbuffer);
+		iowrite32(ARCMSR_INBOUND_MESG0_SET_CONFIG,
reg->inbound_msgaddr0);
+		if (!arcmsr_hbaD_wait_msgint_ready(acb))
+			printk(KERN_NOTICE "arcmsr%d: 'set command Q
window'"
+			" timeout\n", acb->host->host_no);
+		break;
+	}
 	}
 }
 
@@ -2791,11 +3503,19 @@ static void arcmsr_wait_firmware_ready(s
 		}
 		break;
 	case ACB_ADAPTER_TYPE_C: {
-		struct MessageUnit_C *reg = (struct MessageUnit_C
*)acb->pmuC;
+		struct MessageUnit_C __iomem *reg = (struct MessageUnit_C
*)acb->pmuC;
 		do {
 			firmware_state = ioread32(&reg->outbound_msgaddr1);
 		} while ((firmware_state & ARCMSR_HBCMU_MESSAGE_FIRMWARE_OK)
== 0);
+		break;
 		}
+	case ACB_ADAPTER_TYPE_D: {
+		struct MessageUnit_D __iomem *reg = (struct MessageUnit_D
*)acb->pmuD;
+		do {
+			firmware_state = ioread32(reg->outbound_msgaddr1);
+		} while ((firmware_state &
ARCMSR_ARC1214_MESSAGE_FIRMWARE_OK) == 0);
+		break;
+	}
 	}
 }
 
@@ -2866,6 +3586,30 @@ static void arcmsr_hbaC_request_device_m
 	return;
 }
 
+static void arcmsr_hbaD_request_device_map(struct AdapterControlBlock *acb)
+{
+	struct MessageUnit_D __iomem *reg = acb->pmuD;
+
+	if (unlikely(atomic_read(&acb->rq_map_token) == 0) ||
+		((acb->acb_flags & ACB_F_BUS_RESET) != 0) ||
+		((acb->acb_flags & ACB_F_ABORT) != 0)) {
+		mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6
* HZ));
+	} else {
+		acb->fw_flag = FW_NORMAL;
+		if (atomic_read(&acb->ante_token_value) ==
atomic_read(&acb->rq_map_token)) {
+			atomic_set(&acb->rq_map_token, 16);
+		}
+		atomic_set(&acb->ante_token_value,
atomic_read(&acb->rq_map_token));
+		if (atomic_dec_and_test(&acb->rq_map_token)) {
+			mod_timer(&acb->eternal_timer, jiffies +
msecs_to_jiffies(6 * HZ));
+			return;
+		}
+		iowrite32(ARCMSR_INBOUND_MESG0_GET_CONFIG,
reg->inbound_msgaddr0);
+		mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6
* HZ));
+	}
+	return;
+}
+
 static void arcmsr_request_device_map(unsigned long pacb)
 {
 	struct AdapterControlBlock *acb = (struct AdapterControlBlock
*)pacb;
@@ -2881,6 +3625,10 @@ static void arcmsr_request_device_map(un
 		case ACB_ADAPTER_TYPE_C: {
 			arcmsr_hbaC_request_device_map(acb);
 		}
+		break;
+		case ACB_ADAPTER_TYPE_D: {
+			arcmsr_hbaD_request_device_map(acb);
+		}
 	}
 }
 
@@ -2890,8 +3638,8 @@ static void arcmsr_hbaA_start_bgrb(struc
 	acb->acb_flags |= ACB_F_MSG_START_BGRB;
 	writel(ARCMSR_INBOUND_MESG0_START_BGRB, &reg->inbound_msgaddr0);
 	if (!arcmsr_hbaA_wait_msgint_ready(acb)) {
-		printk(KERN_NOTICE "arcmsr%d: wait 'start adapter background
\
-				rebulid' timeout \n", acb->host->host_no);
+		printk(KERN_NOTICE "arcmsr%d: wait 'start adapter background
"
+				"rebulid' timeout \n", acb->host->host_no);
 	}
 }
 
@@ -2901,8 +3649,8 @@ static void arcmsr_hbaB_start_bgrb(struc
 	acb->acb_flags |= ACB_F_MSG_START_BGRB;
 	writel(ARCMSR_MESSAGE_START_BGRB, reg->drv2iop_doorbell);
 	if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
-		printk(KERN_NOTICE "arcmsr%d: wait 'start adapter background
\
-				rebulid' timeout \n",acb->host->host_no);
+		printk(KERN_NOTICE "arcmsr%d: wait 'start adapter background
"
+				"rebulid' timeout \n",acb->host->host_no);
 	}
 }
 
@@ -2913,11 +3661,25 @@ static void arcmsr_hbaC_start_bgrb(struc
 	iowrite32(ARCMSR_INBOUND_MESG0_START_BGRB,
&phbcmu->inbound_msgaddr0);
 	iowrite32(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,
&phbcmu->inbound_doorbell);
 	if (!arcmsr_hbaC_wait_msgint_ready(pACB)) {
-		printk(KERN_NOTICE "arcmsr%d: wait 'start adapter background
\
-				rebulid' timeout \n", pACB->host->host_no);
+		printk(KERN_NOTICE "arcmsr%d: wait 'start adapter background
"
+				"rebulid' timeout \n", pACB->host->host_no);
 	}
 	return;
 }
+
+static void arcmsr_hbaD_start_bgrb(struct AdapterControlBlock *pACB)
+{
+	struct MessageUnit_D __iomem *pmu = (struct MessageUnit_D
*)pACB->pmuD;
+
+	pACB->acb_flags |= ACB_F_MSG_START_BGRB;
+	iowrite32(ARCMSR_INBOUND_MESG0_START_BGRB, pmu->inbound_msgaddr0);
+	if (!arcmsr_hbaD_wait_msgint_ready(pACB)) {
+		printk(KERN_NOTICE "arcmsr%d: wait 'start adapter
background"
+			" rebulid' timeout \n", pACB->host->host_no);
+	}
+	return;
+}
+
 static void arcmsr_start_adapter_bgrb(struct AdapterControlBlock *acb)
 {
 	switch (acb->adapter_type) {
@@ -2929,6 +3691,10 @@ static void arcmsr_start_adapter_bgrb(st
 		break;
 	case ACB_ADAPTER_TYPE_C:
 		arcmsr_hbaC_start_bgrb(acb);
+		break;
+	case ACB_ADAPTER_TYPE_D:
+		arcmsr_hbaD_start_bgrb(acb);
+		break;
 	}
 }
 
@@ -2964,6 +3730,16 @@ static void arcmsr_clear_doorbell_queue_
 		ioread32(&reg->outbound_doorbell_clear);
 		ioread32(&reg->inbound_doorbell);
 		}
+		break;
+	case ACB_ADAPTER_TYPE_D: {
+		struct MessageUnit_D __iomem *reg = (struct MessageUnit_D
*)acb->pmuD;
+		uint32_t outbound_doorbell;
+		/* empty doorbell Qbuffer if door bell ringed */
+		outbound_doorbell = ioread32(reg->outbound_doorbell);
+		iowrite32(outbound_doorbell, reg->outbound_doorbell);
+		iowrite32(ARCMSR_ARC1214_DRV2IOP_DATA_OUT_READ,
reg->inbound_doorbell);
+		break;
+	}
 	}
 }
 
@@ -2971,19 +3747,18 @@ static void arcmsr_enable_eoi_mode(struc
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
reg->drv2iop_doorbell);
-			if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
-				printk(KERN_NOTICE "ARCMSR IOP enables
EOI_MODE TIMEOUT");
-				return;
-			}
+	case ACB_ADAPTER_TYPE_B: {
+		struct MessageUnit_B *reg = acb->pmuB;
+		writel(ARCMSR_MESSAGE_ACTIVE_EOI_MODE,
reg->drv2iop_doorbell);
+		if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
+			printk(KERN_NOTICE "ARCMSR IOP enables EOI_MODE
TIMEOUT");
+			return;
 		}
 		break;
-	case ACB_ADAPTER_TYPE_C:
-		return;
+		}
 	}
 	return;
 }
@@ -3157,7 +3932,7 @@ sleep_again:
 			}
 			break;
 		}
-		case ACB_ADAPTER_TYPE_C:{
+		case ACB_ADAPTER_TYPE_C: {
 			if (acb->acb_flags & ACB_F_BUS_RESET) {
 				long timeout;
 				printk(KERN_ERR "arcmsr: there is an bus
reset eh proceeding.......\n");
@@ -3175,10 +3950,13 @@ sleep_again:
 sleep:
 				ssleep(ARCMSR_SLEEPTIME);
 				if ((ioread32(&reg->host_diagnostic) & 0x04)
!= 0) {
-					printk(KERN_ERR "arcmsr%d: waiting
for hw bus reset return, retry=%d\n", acb->host->host_no, retry_count);
+					printk(KERN_ERR "arcmsr%d: waiting
for hw bus reset"
+					"return, retry=%d\n",
acb->host->host_no, retry_count);
 					if (retry_count > ARCMSR_RETRYCOUNT)
{
 						acb->fw_flag = FW_DEADLOCK;
-						printk(KERN_ERR "arcmsr%d:
waiting for hw bus reset return, RETRY TERMINATED!!\n", acb->host->host_no);
+						printk("arcmsr%d: waiting
for hw"
+						"bus reset return, RETRY
TERMINATED\n",
+						acb->host->host_no);
 						return FAILED;
 					}
 					retry_count++;
@@ -3207,11 +3985,72 @@ sleep:
 				atomic_set(&acb->rq_map_token, 16);
 				atomic_set(&acb->ante_token_value, 16);
 				acb->fw_flag = FW_NORMAL;
-				mod_timer(&acb->eternal_timer, jiffies +
msecs_to_jiffies(6*HZ));
+				mod_timer(&acb->eternal_timer, jiffies +
msecs_to_jiffies(6 * HZ));
 				rtn = SUCCESS;
 			}
 			break;
 		}
+		case ACB_ADAPTER_TYPE_D: {
+			if (acb->acb_flags & ACB_F_BUS_RESET) {
+				long timeout;
+				printk(KERN_NOTICE "arcmsr: there is an"
+					"bus reset eh proceeding.......\n");
+				timeout = wait_event_timeout(wait_q,
(acb->acb_flags &
+					ACB_F_BUS_RESET) == 0, 220 * HZ);
+				if (timeout) {
+					return SUCCESS;
+				}
+			}
+			acb->acb_flags |= ACB_F_BUS_RESET;
+			if (!arcmsr_iop_reset(acb)) {
+				struct MessageUnit_D __iomem *reg;
+				reg = acb->pmuD;
+				arcmsr_hardware_reset(acb);
+				acb->acb_flags &= ~ACB_F_IOP_INITED;
+				nap:
+				ssleep(ARCMSR_SLEEPTIME);
+				if ((ioread32(reg->sample_at_reset) & 0x80)
!= 0) {
+						printk(KERN_ERR "arcmsr%d:
waiting for hw"
+						" bus reset return,
retry=%d\n",
+						acb->host->host_no,
retry_count);
+						if (retry_count >
ARCMSR_RETRYCOUNT) {
+							acb->fw_flag =
FW_DEADLOCK;
+						printk(KERN_NOTICE
"arcmsr%d: waiting for"
+						" hw bus reset return, RETRY
TERMINATED!!\n",
+						acb->host->host_no);
+						return FAILED;
+					}
+					retry_count++;
+					goto nap;
+				}
+				acb->acb_flags |= ACB_F_IOP_INITED;
+				/* disable all outbound interrupt */
+				intmask_org =
arcmsr_disable_outbound_ints(acb);
+				arcmsr_get_firmware_spec(acb);
+				arcmsr_start_adapter_bgrb(acb);
+				arcmsr_clear_doorbell_queue_buffer(acb);
+				arcmsr_enable_outbound_ints(acb,
intmask_org);
+				atomic_set(&acb->rq_map_token, 16);
+				atomic_set(&acb->ante_token_value, 16);

+				acb->fw_flag = FW_NORMAL;
+				mod_timer(&acb->eternal_timer, jiffies +
+					msecs_to_jiffies(6 * HZ));
+				acb->acb_flags &= ~ACB_F_BUS_RESET;
+				rtn = SUCCESS;

+				printk(KERN_NOTICE "arcmsr: scsi bus reset"
+					"eh returns with success\n");
+			} else {
+				acb->acb_flags &= ~ACB_F_BUS_RESET;
+				atomic_set(&acb->rq_map_token, 16);
+				atomic_set(&acb->ante_token_value, 16);
+				acb->fw_flag = FW_NORMAL;
+				mod_timer(&acb->eternal_timer, jiffies
+					+ msecs_to_jiffies(6 * HZ));
+				rtn = SUCCESS;
+			}
+			break;
+		}
+			break;
 	}
 	return rtn;
 }
@@ -3282,8 +4121,7 @@ static const char *arcmsr_info(struct Sc
 	case PCI_DEVICE_ID_ARECA_1280:
 		type = "SATA";
 		break;
-	case PCI_DEVICE_ID_ARECA_1380:
-	case PCI_DEVICE_ID_ARECA_1381:
+	case PCI_DEVICE_ID_ARECA_1214:
 	case PCI_DEVICE_ID_ARECA_1680:
 	case PCI_DEVICE_ID_ARECA_1681:
 	case PCI_DEVICE_ID_ARECA_1880:

