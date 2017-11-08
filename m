From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH 3/13] scsi: arcmsr: add codes for ACB_ADAPTER_TYPE_E to
 support new adapter ARC-1884
Date: Thu, 09 Nov 2017 07:52:43 +0800
Message-ID: <1510185163.4523.67.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jthumshirn@suse.de, hare@suse.de, dan.carpenter@oracle.com, hch@infradead.org
List-Id: linux-scsi@vger.kernel.org

From: Ching Huang <ching2048@areca.com.tw>

add codes for ACB_ADAPTER_TYPE_E to support new adapter ARC-1884

Signed-off-by: Ching Huang <ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
--- a/drivers/scsi/arcmsr/arcmsr.h	2017-08-03 18:54:46.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr.h	2017-08-04 11:19:22.000000000 +0800
@@ -65,6 +65,7 @@ struct device_attribute;
 #define ARCMSR_MAX_HBB_POSTQUEUE						264
 #define ARCMSR_MAX_ARC1214_POSTQUEUE	256
 #define ARCMSR_MAX_ARC1214_DONEQUEUE	257
+#define ARCMSR_MAX_HBE_DONEQUEUE	512
 #define ARCMSR_MAX_XFER_LEN							0x26000 /* 152K */
 #define ARCMSR_CDB_SG_PAGE_LENGTH						256 
 #define ARCMST_NUM_MSIX_VECTORS		4
@@ -77,6 +78,9 @@ struct device_attribute;
 #ifndef PCI_DEVICE_ID_ARECA_1203
 	#define PCI_DEVICE_ID_ARECA_1203	0x1203
 #endif
+#ifndef PCI_DEVICE_ID_ARECA_1884
+	#define PCI_DEVICE_ID_ARECA_1884	0x1884
+#endif
 /*
 **********************************************************************************
 **
@@ -405,6 +409,31 @@ struct FIRMWARE_INFO
 /*ARCMSR_HBAMU_MESSAGE_FIRMWARE_OK*/
 #define ARCMSR_ARC1214_MESSAGE_FIRMWARE_OK		0x80000000
 #define ARCMSR_ARC1214_OUTBOUND_LIST_INTERRUPT_CLEAR	0x00000001
+/* 
+*******************************************************************************
+**                SPEC. for Areca Type E adapter
+*******************************************************************************
+*/
+#define ARCMSR_SIGNATURE_1884			0x188417D3
+
+#define ARCMSR_HBEMU_DRV2IOP_DATA_WRITE_OK	0x00000002
+#define ARCMSR_HBEMU_DRV2IOP_DATA_READ_OK	0x00000004
+#define ARCMSR_HBEMU_DRV2IOP_MESSAGE_CMD_DONE	0x00000008
+
+#define ARCMSR_HBEMU_IOP2DRV_DATA_WRITE_OK	0x00000002
+#define ARCMSR_HBEMU_IOP2DRV_DATA_READ_OK	0x00000004
+#define ARCMSR_HBEMU_IOP2DRV_MESSAGE_CMD_DONE	0x00000008
+
+#define ARCMSR_HBEMU_MESSAGE_FIRMWARE_OK	0x80000000
+
+#define ARCMSR_HBEMU_OUTBOUND_DOORBELL_ISR	0x00000001
+#define ARCMSR_HBEMU_OUTBOUND_POSTQUEUE_ISR	0x00000008
+#define ARCMSR_HBEMU_ALL_INTMASKENABLE		0x00000009
+
+/* ARC-1884 doorbell sync */
+#define ARCMSR_HBEMU_DOORBELL_SYNC		0x100
+#define ARCMSR_ARC188X_RESET_ADAPTER		0x00000004
+#define ARCMSR_ARC1884_DiagWrite_ENABLE		0x00000080
 /*
 *******************************************************************************
 **    ARECA SCSI COMMAND DESCRIPTOR BLOCK size 0x1F8 (504)
@@ -614,6 +643,88 @@ struct MessageUnit_D {
 	u32 __iomem *msgcode_rwbuffer;		/* 0x2200 */
 };
 /*
+*********************************************************************
+**     Messaging Unit (MU) of Type E processor(LSI)
+*********************************************************************
+*/
+struct MessageUnit_E{
+	uint32_t	iobound_doorbell;			/*0000 0003*/
+	uint32_t	write_sequence_3xxx;			/*0004 0007*/
+	uint32_t	host_diagnostic_3xxx;			/*0008 000B*/
+	uint32_t	posted_outbound_doorbell;		/*000C 000F*/
+	uint32_t	master_error_attribute;			/*0010 0013*/
+	uint32_t	master_error_address_low;		/*0014 0017*/
+	uint32_t	master_error_address_high;		/*0018 001B*/
+	uint32_t	hcb_size;				/*001C 001F*/
+	uint32_t	inbound_doorbell;			/*0020 0023*/
+	uint32_t	diagnostic_rw_data;			/*0024 0027*/
+	uint32_t	diagnostic_rw_address_low;		/*0028 002B*/
+	uint32_t	diagnostic_rw_address_high;		/*002C 002F*/
+	uint32_t	host_int_status;			/*0030 0033*/
+	uint32_t	host_int_mask;				/*0034 0037*/
+	uint32_t	dcr_data;				/*0038 003B*/
+	uint32_t	dcr_address;				/*003C 003F*/
+	uint32_t	inbound_queueport;			/*0040 0043*/
+	uint32_t	outbound_queueport;			/*0044 0047*/
+	uint32_t	hcb_pci_address_low;			/*0048 004B*/
+	uint32_t	hcb_pci_address_high;			/*004C 004F*/
+	uint32_t	iop_int_status;				/*0050 0053*/
+	uint32_t	iop_int_mask;				/*0054 0057*/
+	uint32_t	iop_inbound_queue_port;			/*0058 005B*/
+	uint32_t	iop_outbound_queue_port;		/*005C 005F*/
+	uint32_t	inbound_free_list_index;		/*0060 0063*/
+	uint32_t	inbound_post_list_index;		/*0064 0067*/
+	uint32_t	reply_post_producer_index;		/*0068 006B*/
+	uint32_t	reply_post_consumer_index;		/*006C 006F*/
+	uint32_t	inbound_doorbell_clear;			/*0070 0073*/
+	uint32_t	i2o_message_unit_control;		/*0074 0077*/
+	uint32_t	last_used_message_source_address_low;	/*0078 007B*/
+	uint32_t	last_used_message_source_address_high;	/*007C 007F*/
+	uint32_t	pull_mode_data_byte_count[4];		/*0080 008F*/
+	uint32_t	message_dest_address_index;		/*0090 0093*/
+	uint32_t	done_queue_not_empty_int_counter_timer;	/*0094 0097*/
+	uint32_t	utility_A_int_counter_timer;		/*0098 009B*/
+	uint32_t	outbound_doorbell;			/*009C 009F*/
+	uint32_t	outbound_doorbell_clear;		/*00A0 00A3*/
+	uint32_t	message_source_address_index;		/*00A4 00A7*/
+	uint32_t	message_done_queue_index;		/*00A8 00AB*/
+	uint32_t	reserved0;				/*00AC 00AF*/
+	uint32_t	inbound_msgaddr0;			/*00B0 00B3*/
+	uint32_t	inbound_msgaddr1;			/*00B4 00B7*/
+	uint32_t	outbound_msgaddr0;			/*00B8 00BB*/
+	uint32_t	outbound_msgaddr1;			/*00BC 00BF*/
+	uint32_t	inbound_queueport_low;			/*00C0 00C3*/
+	uint32_t	inbound_queueport_high;			/*00C4 00C7*/
+	uint32_t	outbound_queueport_low;			/*00C8 00CB*/
+	uint32_t	outbound_queueport_high;		/*00CC 00CF*/
+	uint32_t	iop_inbound_queue_port_low;		/*00D0 00D3*/
+	uint32_t	iop_inbound_queue_port_high;		/*00D4 00D7*/
+	uint32_t	iop_outbound_queue_port_low;		/*00D8 00DB*/
+	uint32_t	iop_outbound_queue_port_high;		/*00DC 00DF*/
+	uint32_t	message_dest_queue_port_low;		/*00E0 00E3*/
+	uint32_t	message_dest_queue_port_high;		/*00E4 00E7*/
+	uint32_t	last_used_message_dest_address_low;	/*00E8 00EB*/
+	uint32_t	last_used_message_dest_address_high;	/*00EC 00EF*/
+	uint32_t	message_done_queue_base_address_low;	/*00F0 00F3*/
+	uint32_t	message_done_queue_base_address_high;	/*00F4 00F7*/
+	uint32_t	host_diagnostic;			/*00F8 00FB*/
+	uint32_t	write_sequence;				/*00FC 00FF*/
+	uint32_t	reserved1[34];				/*0100 0187*/
+	uint32_t	reserved2[1950];			/*0188 1FFF*/
+	uint32_t	message_wbuffer[32];			/*2000 207F*/
+	uint32_t	reserved3[32];				/*2080 20FF*/
+	uint32_t	message_rbuffer[32];			/*2100 217F*/
+	uint32_t	reserved4[32];				/*2180 21FF*/
+	uint32_t	msgcode_rwbuffer[256];			/*2200 23FF*/
+};
+
+typedef struct deliver_completeQ {
+	uint16_t	cmdFlag;
+	uint16_t	cmdSMID;
+	uint16_t	cmdLMID;        // reserved (0)
+	uint16_t	cmdFlag2;       // reserved (0)
+} DeliverQ, CompletionQ, *pDeliver_Q, *pCompletion_Q;
+/*
 *******************************************************************************
 **                 Adapter Control Block
 *******************************************************************************
@@ -625,6 +736,7 @@ struct AdapterControlBlock
 	#define ACB_ADAPTER_TYPE_B	0x00000001	/* hbb M IOP */
 	#define ACB_ADAPTER_TYPE_C	0x00000002	/* hbc L IOP */
 	#define ACB_ADAPTER_TYPE_D	0x00000003	/* hbd M IOP */
+	#define ACB_ADAPTER_TYPE_E	0x00000004	/* hba L IOP */
 	u32				roundup_ccbsize;
 	struct pci_dev *		pdev;
 	struct Scsi_Host *		host;
@@ -644,6 +756,7 @@ struct AdapterControlBlock
 		struct MessageUnit_B 	*pmuB;
 		struct MessageUnit_C __iomem *pmuC;
 		struct MessageUnit_D 	*pmuD;
+		struct MessageUnit_E __iomem *pmuE;
 	};
 	/* message unit ATU inbound base address0 */
 	void __iomem *mem_base0;
@@ -723,6 +836,12 @@ struct AdapterControlBlock
 	atomic_t			ante_token_value;
 	uint32_t	maxOutstanding;
 	int		vector_count;
+	uint32_t		doneq_index;
+	uint32_t		ccbsize;
+	uint32_t		in_doorbell;
+	uint32_t		out_doorbell;
+	uint32_t		completionQ_entry;
+	pCompletion_Q		pCompletionQ;
 };/* HW_DEVICE_EXTENSION */
 /*
 *******************************************************************************
@@ -748,12 +867,13 @@ struct CommandControlBlock{
 	#define			ARCMSR_CCB_START		0x55AA
 	#define			ARCMSR_CCB_ABORTED		0xAA55
 	#define			ARCMSR_CCB_ILLEGAL		0xFFFF
+	uint32_t			smid;
 	#if BITS_PER_LONG == 64
 	/*  ======================512+64 bytes========================  */
-		uint32_t                        	reserved[5];		/*24 byte*/
+		uint32_t		reserved[4];		/*16 byte*/
 	#else
 	/*  ======================512+32 bytes========================  */
-		uint32_t                        	reserved;		/*8  byte*/
+	//	uint32_t		reserved;		/*4  byte*/
 	#endif
 	/*  =======================================================   */
 	struct ARCMSR_CDB		arcmsr_cdb;
diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2017-11-08 18:46:40.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2017-11-08 18:48:46.000000000 +0800
@@ -110,6 +110,8 @@ static bool arcmsr_get_firmware_spec(str
 static void arcmsr_start_adapter_bgrb(struct AdapterControlBlock *acb);
 static void arcmsr_hbaC_message_isr(struct AdapterControlBlock *pACB);
 static void arcmsr_hbaD_message_isr(struct AdapterControlBlock *acb);
+static void arcmsr_hbaE_message_isr(struct AdapterControlBlock *acb);
+static void arcmsr_hbaE_postqueue_isr(struct AdapterControlBlock *acb);
 static void arcmsr_hardware_reset(struct AdapterControlBlock *acb);
 static const char *arcmsr_info(struct Scsi_Host *);
 static irqreturn_t arcmsr_interrupt(struct AdapterControlBlock *acb);
@@ -184,6 +186,8 @@ static struct pci_device_id arcmsr_devic
 		.driver_data = ACB_ADAPTER_TYPE_A},
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1880),
 		.driver_data = ACB_ADAPTER_TYPE_C},
+	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1884),
+		.driver_data = ACB_ADAPTER_TYPE_E},
 	{0, 0}, /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(pci, arcmsr_device_id_table);
@@ -206,7 +210,8 @@ static void arcmsr_free_mu(struct Adapte
 {
 	switch (acb->adapter_type) {
 	case ACB_ADAPTER_TYPE_B:
-	case ACB_ADAPTER_TYPE_D: {
+	case ACB_ADAPTER_TYPE_D:
+	case ACB_ADAPTER_TYPE_E: {
 		dma_free_coherent(&acb->pdev->dev, acb->roundup_ccbsize,
 			acb->dma_coherent2, acb->dma_coherent_handle2);
 		break;
@@ -271,6 +276,20 @@ static bool arcmsr_remap_pciregion(struc
 		acb->mem_base0 = mem_base0;
 		break;
 		}
+	case ACB_ADAPTER_TYPE_E: {
+		acb->pmuE = ioremap(pci_resource_start(pdev, 1),
+			pci_resource_len(pdev, 1));
+		if (!acb->pmuE) {
+			pr_notice("arcmsr%d: memory mapping region fail \n",
+				acb->host->host_no);
+			return false;
+		}
+		writel(0, &acb->pmuE->host_int_status); /*clear interrupt*/
+		writel(ARCMSR_HBEMU_DOORBELL_SYNC, &acb->pmuE->iobound_doorbell);	/* synchronize doorbell to 0 */
+		acb->in_doorbell = 0;
+		acb->out_doorbell = 0;
+		break;
+		}
 	}
 	return true;
 }
@@ -295,6 +314,9 @@ static void arcmsr_unmap_pciregion(struc
 	case ACB_ADAPTER_TYPE_D:
 		iounmap(acb->mem_base0);
 		break;
+	case ACB_ADAPTER_TYPE_E:
+		iounmap(acb->pmuE);
+		break;
 	}
 }
 
@@ -408,6 +430,24 @@ static bool arcmsr_hbaD_wait_msgint_read
 	return false;
 }
 
+static bool arcmsr_hbaE_wait_msgint_ready(struct AdapterControlBlock *pACB)
+{
+	int i;
+	uint32_t read_doorbell;
+	struct MessageUnit_E __iomem *phbcmu = pACB->pmuE;
+
+	for (i = 0; i < 2000; i++) {
+		read_doorbell = readl(&phbcmu->iobound_doorbell);
+		if ((read_doorbell ^ pACB->in_doorbell) & ARCMSR_HBEMU_IOP2DRV_MESSAGE_CMD_DONE) {
+			writel(0, &phbcmu->host_int_status); /*clear interrupt*/
+			pACB->in_doorbell = read_doorbell;
+			return true;
+		}
+		msleep(10);
+	} /* max 20 seconds */
+	return false;
+}
+
 static void arcmsr_hbaA_flush_cache(struct AdapterControlBlock *acb)
 {
 	struct MessageUnit_A __iomem *reg = acb->pmuA;
@@ -475,6 +515,24 @@ static void arcmsr_hbaD_flush_cache(stru
 	} while (retry_count != 0);
 }
 
+static void arcmsr_hbaE_flush_cache(struct AdapterControlBlock *pACB)
+{
+	int retry_count = 30;
+	struct MessageUnit_E __iomem *reg = pACB->pmuE;
+
+	writel(ARCMSR_INBOUND_MESG0_FLUSH_CACHE, &reg->inbound_msgaddr0);
+	pACB->out_doorbell ^= ARCMSR_HBEMU_DRV2IOP_MESSAGE_CMD_DONE;
+	writel(pACB->out_doorbell, &reg->iobound_doorbell);
+	do {
+		if (arcmsr_hbaE_wait_msgint_ready(pACB))
+			break;
+		retry_count--;
+		pr_notice("arcmsr%d: wait 'flush adapter "
+			"cache' timeout, retry count down = %d\n",
+			pACB->host->host_no, retry_count);
+	} while (retry_count != 0);
+}
+
 static void arcmsr_flush_adapter_cache(struct AdapterControlBlock *acb)
 {
 	switch (acb->adapter_type) {
@@ -495,6 +553,9 @@ static void arcmsr_flush_adapter_cache(s
 	case ACB_ADAPTER_TYPE_D:
 		arcmsr_hbaD_flush_cache(acb);
 		break;
+	case ACB_ADAPTER_TYPE_E:
+		arcmsr_hbaE_flush_cache(acb);
+		break;
 	}
 }
 
@@ -577,6 +638,23 @@ static bool arcmsr_alloc_io_queue(struct
 		reg->msgcode_rwbuffer = MEM_BASE0(ARCMSR_ARC1214_MESSAGE_RWBUFFER);
 		}
 		break;
+	case ACB_ADAPTER_TYPE_E: {
+		uint32_t completeQ_size;
+		completeQ_size = sizeof(struct deliver_completeQ) * ARCMSR_MAX_HBE_DONEQUEUE + 128;
+		acb->roundup_ccbsize = roundup(completeQ_size, 32);
+		dma_coherent = dma_zalloc_coherent(&pdev->dev, acb->roundup_ccbsize,
+			&dma_coherent_handle, GFP_KERNEL);
+		if (!dma_coherent){
+			pr_notice("arcmsr%d: DMA allocation failed\n", acb->host->host_no);
+			return false;
+		}
+		acb->dma_coherent_handle2 = dma_coherent_handle;
+		acb->dma_coherent2 = dma_coherent;
+		acb->pCompletionQ = dma_coherent;
+		acb->completionQ_entry = acb->roundup_ccbsize / sizeof(struct deliver_completeQ);
+		acb->doneq_index = 0;
+		}
+		break;
 	default:
 		break;
 	}
@@ -619,6 +697,7 @@ static int arcmsr_alloc_ccb_pool(struct 
 	acb->dma_coherent = dma_coherent;
 	acb->dma_coherent_handle = dma_coherent_handle;
 	memset(dma_coherent, 0, acb->uncache_size);
+	acb->ccbsize = roundup_ccbsize;
 	ccb_tmp = dma_coherent;
 	acb->vir2phy_offset = (unsigned long)dma_coherent - (unsigned long)dma_coherent_handle;
 	for(i = 0; i < ARCMSR_MAX_FREECCB_NUM; i++){
@@ -630,11 +709,13 @@ static int arcmsr_alloc_ccb_pool(struct 
 			break;
 		case ACB_ADAPTER_TYPE_C:
 		case ACB_ADAPTER_TYPE_D:
+		case ACB_ADAPTER_TYPE_E:
 			ccb_tmp->cdb_phyaddr = cdb_phyaddr;
 			break;
 		}
 		acb->pccb_pool[i] = ccb_tmp;
 		ccb_tmp->acb = acb;
+		ccb_tmp->smid = (u32)i << 16;
 		INIT_LIST_HEAD(&ccb_tmp->list);
 		list_add_tail(&ccb_tmp->list, &acb->ccb_free_list);
 		ccb_tmp = (struct CommandControlBlock *)((unsigned long)ccb_tmp + roundup_ccbsize);
@@ -683,6 +764,13 @@ static void arcmsr_message_isr_bh_fn(str
 		devicemap = (char __iomem *)(&reg->msgcode_rwbuffer[21]);
 		break;
 	}
+	case ACB_ADAPTER_TYPE_E: {
+		struct MessageUnit_E __iomem *reg  = acb->pmuE;
+
+		signature = (uint32_t __iomem *)(&reg->msgcode_rwbuffer[0]);
+		devicemap = (char __iomem *)(&reg->msgcode_rwbuffer[21]);
+		break;
+		}
 	}
 	atomic_inc(&acb->rq_map_token);
 	if (readl(signature) != ARCMSR_SIGNATURE_GET_CONFIG)
@@ -1002,6 +1090,21 @@ static uint8_t arcmsr_hbaD_abort_allcmd(
 	return true;
 }
 
+static uint8_t arcmsr_hbaE_abort_allcmd(struct AdapterControlBlock *pACB)
+{
+	struct MessageUnit_E __iomem *reg = pACB->pmuE;
+
+	writel(ARCMSR_INBOUND_MESG0_ABORT_CMD, &reg->inbound_msgaddr0);
+	pACB->out_doorbell ^= ARCMSR_HBEMU_DRV2IOP_MESSAGE_CMD_DONE;
+	writel(pACB->out_doorbell, &reg->iobound_doorbell);
+	if (!arcmsr_hbaE_wait_msgint_ready(pACB)) {
+		pr_notice("arcmsr%d: wait 'abort all outstanding "
+			"command' timeout\n", pACB->host->host_no);
+		return false;
+	}
+	return true;
+}
+
 static uint8_t arcmsr_abort_allcmd(struct AdapterControlBlock *acb)
 {
 	uint8_t rtnval = 0;
@@ -1024,6 +1127,9 @@ static uint8_t arcmsr_abort_allcmd(struc
 	case ACB_ADAPTER_TYPE_D:
 		rtnval = arcmsr_hbaD_abort_allcmd(acb);
 		break;
+	case ACB_ADAPTER_TYPE_E:
+		rtnval = arcmsr_hbaE_abort_allcmd(acb);
+		break;
 	}
 	return rtnval;
 }
@@ -1096,6 +1202,13 @@ static u32 arcmsr_disable_outbound_ints(
 		writel(ARCMSR_ARC1214_ALL_INT_DISABLE, reg->pcief0_int_enable);
 		}
 		break;
+	case ACB_ADAPTER_TYPE_E: {
+		struct MessageUnit_E __iomem *reg = acb->pmuE;
+		orig_mask = readl(&reg->host_int_mask);
+		writel(orig_mask | ARCMSR_HBEMU_OUTBOUND_DOORBELL_ISR | ARCMSR_HBEMU_OUTBOUND_POSTQUEUE_ISR, &reg->host_int_mask);
+		readl(&reg->host_int_mask); /* Dummy readl to force pci flush */
+		}
+		break;
 	}
 	return orig_mask;
 }
@@ -1284,6 +1397,9 @@ static void arcmsr_done4abort_postqueue(
 		pmu->doneq_index = 0x40FF;
 		}
 		break;
+	case ACB_ADAPTER_TYPE_E:
+		arcmsr_hbaE_postqueue_isr(acb);
+		break;
 	}
 }
 
@@ -1400,6 +1516,13 @@ static void arcmsr_enable_outbound_ints(
 		writel(intmask_org | mask, reg->pcief0_int_enable);
 		break;
 		}
+	case ACB_ADAPTER_TYPE_E: {
+		struct MessageUnit_E __iomem *reg = acb->pmuE;
+
+		mask = ~(ARCMSR_HBEMU_OUTBOUND_DOORBELL_ISR | ARCMSR_HBEMU_OUTBOUND_POSTQUEUE_ISR);
+		writel(intmask_org & mask, &reg->host_int_mask);
+		break;
+		}
 	}
 }
 
@@ -1531,6 +1654,16 @@ static void arcmsr_post_ccb(struct Adapt
 		spin_unlock_irqrestore(&acb->postq_lock, flags);
 		break;
 		}
+	case ACB_ADAPTER_TYPE_E: {
+		struct MessageUnit_E __iomem *pmu = acb->pmuE;
+		u32 ccb_post_stamp, arc_cdb_size;
+
+		arc_cdb_size = (ccb->arc_cdb_size > 0x300) ? 0x300 : ccb->arc_cdb_size;
+		ccb_post_stamp = (ccb->smid | ((arc_cdb_size - 1) >> 6));
+		writel(0, &pmu->inbound_queueport_high);
+		writel(ccb_post_stamp, &pmu->inbound_queueport_low);
+		break;
+		}
 	}
 }
 
@@ -1584,6 +1717,20 @@ static void arcmsr_hbaD_stop_bgrb(struct
 			"timeout\n", pACB->host->host_no);
 }
 
+static void arcmsr_hbaE_stop_bgrb(struct AdapterControlBlock *pACB)
+{
+	struct MessageUnit_E __iomem *reg = pACB->pmuE;
+
+	pACB->acb_flags &= ~ACB_F_MSG_START_BGRB;
+	writel(ARCMSR_INBOUND_MESG0_STOP_BGRB, &reg->inbound_msgaddr0);
+	pACB->out_doorbell ^= ARCMSR_HBEMU_DRV2IOP_MESSAGE_CMD_DONE;
+	writel(pACB->out_doorbell, &reg->iobound_doorbell);
+	if (!arcmsr_hbaE_wait_msgint_ready(pACB)) {
+		pr_notice("arcmsr%d: wait 'stop adapter background rebulid' "
+			"timeout\n", pACB->host->host_no);
+	}
+}
+
 static void arcmsr_stop_adapter_bgrb(struct AdapterControlBlock *acb)
 {
 	switch (acb->adapter_type) {
@@ -1603,6 +1750,9 @@ static void arcmsr_stop_adapter_bgrb(str
 	case ACB_ADAPTER_TYPE_D:
 		arcmsr_hbaD_stop_bgrb(acb);
 		break;
+	case ACB_ADAPTER_TYPE_E:
+		arcmsr_hbaE_stop_bgrb(acb);
+		break;
 	}
 }
 
@@ -1637,6 +1787,12 @@ static void arcmsr_iop_message_read(stru
 			reg->inbound_doorbell);
 		}
 		break;
+	case ACB_ADAPTER_TYPE_E: {
+		struct MessageUnit_E __iomem *reg = acb->pmuE;
+		acb->out_doorbell ^= ARCMSR_HBEMU_DRV2IOP_DATA_READ_OK;
+		writel(acb->out_doorbell, &reg->iobound_doorbell);
+		}
+		break;
 	}
 }
 
@@ -1677,6 +1833,12 @@ static void arcmsr_iop_message_wrote(str
 			reg->inbound_doorbell);
 		}
 		break;
+	case ACB_ADAPTER_TYPE_E: {
+		struct MessageUnit_E __iomem *reg = acb->pmuE;
+		acb->out_doorbell ^= ARCMSR_HBEMU_DRV2IOP_DATA_WRITE_OK;
+		writel(acb->out_doorbell, &reg->iobound_doorbell);
+		}
+		break;
 	}
 }
 
@@ -1706,6 +1868,11 @@ struct QBUFFER __iomem *arcmsr_get_iop_r
 		qbuffer = (struct QBUFFER __iomem *)reg->message_rbuffer;
 		}
 		break;
+	case ACB_ADAPTER_TYPE_E: {
+		struct MessageUnit_E __iomem *reg = acb->pmuE;
+		qbuffer = (struct QBUFFER __iomem *)&reg->message_rbuffer;
+		}
+		break;
 	}
 	return qbuffer;
 }
@@ -1736,6 +1903,11 @@ static struct QBUFFER __iomem *arcmsr_ge
 		pqbuffer = (struct QBUFFER __iomem *)reg->message_wbuffer;
 		}
 		break;
+	case ACB_ADAPTER_TYPE_E: {
+		struct MessageUnit_E __iomem *reg = acb->pmuE;
+		pqbuffer = (struct QBUFFER __iomem *)&reg->message_wbuffer;
+		}
+		break;
 	}
 	return pqbuffer;
 }
@@ -1972,6 +2144,33 @@ static void arcmsr_hbaD_doorbell_isr(str
 		| ARCMSR_ARC1214_IOP2DRV_MESSAGE_CMD_DONE));
 }
 
+static void arcmsr_hbaE_doorbell_isr(struct AdapterControlBlock *pACB)
+{
+	uint32_t outbound_doorbell, in_doorbell, tmp;
+	struct MessageUnit_E __iomem *reg = pACB->pmuE;
+
+	in_doorbell = readl(&reg->iobound_doorbell);
+	outbound_doorbell = in_doorbell ^ pACB->in_doorbell;
+	do {
+		writel(0, &reg->host_int_status); /* clear interrupt */
+		if (outbound_doorbell & ARCMSR_HBEMU_IOP2DRV_DATA_WRITE_OK) {
+			arcmsr_iop2drv_data_wrote_handle(pACB);
+		}
+		if (outbound_doorbell & ARCMSR_HBEMU_IOP2DRV_DATA_READ_OK) {
+			arcmsr_iop2drv_data_read_handle(pACB);
+		}
+		if (outbound_doorbell & ARCMSR_HBEMU_IOP2DRV_MESSAGE_CMD_DONE) {
+			arcmsr_hbaE_message_isr(pACB);
+		}
+		tmp = in_doorbell;
+		in_doorbell = readl(&reg->iobound_doorbell);
+		outbound_doorbell = tmp ^ in_doorbell;
+	} while (outbound_doorbell & (ARCMSR_HBEMU_IOP2DRV_DATA_WRITE_OK
+		| ARCMSR_HBEMU_IOP2DRV_DATA_READ_OK
+		| ARCMSR_HBEMU_IOP2DRV_MESSAGE_CMD_DONE));
+	pACB->in_doorbell = in_doorbell;
+}
+
 static void arcmsr_hbaA_postqueue_isr(struct AdapterControlBlock *acb)
 {
 	uint32_t flag_ccb;
@@ -2081,6 +2280,33 @@ static void arcmsr_hbaD_postqueue_isr(st
 	spin_unlock_irqrestore(&acb->doneq_lock, flags);
 }
 
+static void arcmsr_hbaE_postqueue_isr(struct AdapterControlBlock *acb)
+{
+	uint32_t doneq_index;
+	uint16_t cmdSMID;
+	int error;
+	struct MessageUnit_E __iomem *pmu;
+	struct CommandControlBlock *ccb;
+	unsigned long flags;
+
+	spin_lock_irqsave(&acb->doneq_lock, flags);
+	doneq_index = acb->doneq_index;
+	pmu = acb->pmuE;
+	while ((readl(&pmu->reply_post_producer_index) & 0xFFFF) != doneq_index) {
+		cmdSMID = acb->pCompletionQ[doneq_index].cmdSMID;
+		ccb = acb->pccb_pool[cmdSMID];
+		error = (acb->pCompletionQ[doneq_index].cmdFlag
+			& ARCMSR_CCBREPLY_FLAG_ERROR_MODE1) ? true : false;
+		arcmsr_drain_donequeue(acb, ccb, error);
+		doneq_index++;
+		if (doneq_index >= acb->completionQ_entry)
+			doneq_index = 0;
+	}
+	acb->doneq_index = doneq_index;
+	writel(doneq_index, &pmu->reply_post_consumer_index);
+	spin_unlock_irqrestore(&acb->doneq_lock, flags);
+}
+
 /*
 **********************************************************************************
 ** Handle a message interrupt
@@ -2130,6 +2356,14 @@ static void arcmsr_hbaD_message_isr(stru
 	schedule_work(&acb->arcmsr_do_message_isr_bh);
 }
 
+static void arcmsr_hbaE_message_isr(struct AdapterControlBlock *acb)
+{
+	struct MessageUnit_E __iomem *reg  = acb->pmuE;
+
+	writel(0, &reg->host_int_status);
+	schedule_work(&acb->arcmsr_do_message_isr_bh);
+}
+
 static int arcmsr_hbaA_handle_isr(struct AdapterControlBlock *acb)
 {
 	uint32_t outbound_intstatus;
@@ -2233,6 +2467,31 @@ static irqreturn_t arcmsr_hbaD_handle_is
 	return IRQ_HANDLED;
 }
 
+static irqreturn_t arcmsr_hbaE_handle_isr(struct AdapterControlBlock *pACB)
+{
+	uint32_t host_interrupt_status;
+	struct MessageUnit_E __iomem *pmu = pACB->pmuE;
+
+	host_interrupt_status = readl(&pmu->host_int_status) &
+		(ARCMSR_HBEMU_OUTBOUND_POSTQUEUE_ISR |
+		ARCMSR_HBEMU_OUTBOUND_DOORBELL_ISR);
+	if (!host_interrupt_status)
+		return IRQ_NONE;
+	do {
+		/* MU ioctl transfer doorbell interrupts*/
+		if (host_interrupt_status & ARCMSR_HBEMU_OUTBOUND_DOORBELL_ISR) {
+			arcmsr_hbaE_doorbell_isr(pACB);
+		}
+		/* MU post queue interrupts*/
+		if (host_interrupt_status & ARCMSR_HBEMU_OUTBOUND_POSTQUEUE_ISR) {
+			arcmsr_hbaE_postqueue_isr(pACB);
+		}
+		host_interrupt_status = readl(&pmu->host_int_status);
+	} while (host_interrupt_status & (ARCMSR_HBEMU_OUTBOUND_POSTQUEUE_ISR |
+		ARCMSR_HBEMU_OUTBOUND_DOORBELL_ISR));
+	return IRQ_HANDLED;
+}
+
 static irqreturn_t arcmsr_interrupt(struct AdapterControlBlock *acb)
 {
 	switch (acb->adapter_type) {
@@ -2246,6 +2505,8 @@ static irqreturn_t arcmsr_interrupt(stru
 		return arcmsr_hbaC_handle_isr(acb);
 	case ACB_ADAPTER_TYPE_D:
 		return arcmsr_hbaD_handle_isr(acb);
+	case ACB_ADAPTER_TYPE_E:
+		return arcmsr_hbaE_handle_isr(acb);
 	default:
 		return IRQ_NONE;
 	}
@@ -2889,6 +3150,71 @@ static bool arcmsr_hbaD_get_config(struc
 	return true;
 }
 
+static bool arcmsr_hbaE_get_config(struct AdapterControlBlock *pACB)
+{
+	char *acb_firm_model = pACB->firm_model;
+	char *acb_firm_version = pACB->firm_version;
+	struct MessageUnit_E __iomem *reg = pACB->pmuE;
+	char __iomem *iop_firm_model = (char __iomem *)(&reg->msgcode_rwbuffer[15]);
+	char __iomem *iop_firm_version = (char __iomem *)(&reg->msgcode_rwbuffer[17]);
+	uint32_t intmask_org, Index, firmware_state = 0, read_doorbell;
+	int count;
+
+	/* disable all outbound interrupt */
+	intmask_org = readl(&reg->host_int_mask); /* disable outbound message0 int */
+	writel(intmask_org | ARCMSR_HBEMU_ALL_INTMASKENABLE, &reg->host_int_mask);
+	/* wait firmware ready */
+	do {
+		firmware_state = readl(&reg->outbound_msgaddr1);
+	} while ((firmware_state & ARCMSR_HBEMU_MESSAGE_FIRMWARE_OK) == 0);
+	mdelay(20);	
+	/* post "get config" instruction */
+	writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);
+
+	pACB->out_doorbell ^= ARCMSR_HBEMU_DRV2IOP_MESSAGE_CMD_DONE;
+	writel(pACB->out_doorbell, &reg->iobound_doorbell);
+	/* wait message ready */
+	for (Index = 0; Index < 2000; Index++) {
+		read_doorbell = readl(&reg->iobound_doorbell);
+		if ((read_doorbell ^ pACB->in_doorbell) & ARCMSR_HBEMU_IOP2DRV_MESSAGE_CMD_DONE) {
+			writel(0, &reg->host_int_status);
+			pACB->in_doorbell = read_doorbell;
+			break;
+		}
+		mdelay(1);
+	} /*max 1 seconds*/
+
+	if (Index >= 2000) {
+		pr_notice("arcmsr%d: wait get adapter firmware "
+			"miscellaneous data timeout\n", pACB->host->host_no);
+		return false;
+	}
+	count = 8;
+	while (count) {
+		*acb_firm_model = readb(iop_firm_model);
+		acb_firm_model++;
+		iop_firm_model++;
+		count--;
+	}
+	count = 16;
+	while (count) {
+		*acb_firm_version = readb(iop_firm_version);
+		acb_firm_version++;
+		iop_firm_version++;
+		count--;
+	}
+	pACB->firm_request_len = readl(&reg->msgcode_rwbuffer[1]);
+	pACB->firm_numbers_queue = readl(&reg->msgcode_rwbuffer[2]);
+	pACB->firm_sdram_size = readl(&reg->msgcode_rwbuffer[3]);
+	pACB->firm_hd_channels = readl(&reg->msgcode_rwbuffer[4]);
+	pACB->firm_cfg_version = readl(&reg->msgcode_rwbuffer[25]);
+	pr_notice("Areca RAID Controller%d: Model %s, F/W %s\n",
+		pACB->host->host_no,
+		pACB->firm_model,
+		pACB->firm_version);
+	return true;
+}
+
 static bool arcmsr_get_firmware_spec(struct AdapterControlBlock *acb)
 {
 	bool rtn = false;
@@ -2906,6 +3232,9 @@ static bool arcmsr_get_firmware_spec(str
 	case ACB_ADAPTER_TYPE_D:
 		rtn = arcmsr_hbaD_get_config(acb);
 		break;
+	case ACB_ADAPTER_TYPE_E:
+		rtn = arcmsr_hbaE_get_config(acb);
+		break;
 	default:
 		break;
 	}
@@ -3170,6 +3499,75 @@ polling_hbaD_ccb_retry:
 	return rtn;
 }
 
+static int arcmsr_hbaE_polling_ccbdone(struct AdapterControlBlock *acb,
+				struct CommandControlBlock *poll_ccb)
+{
+	bool error;
+	uint32_t poll_ccb_done = 0, poll_count = 0, doneq_index;
+	uint16_t cmdSMID;
+	unsigned long flags;
+	int rtn;
+	struct CommandControlBlock *pCCB;
+	struct MessageUnit_E __iomem *reg = acb->pmuE;
+
+	polling_hbaC_ccb_retry:
+	poll_count++;
+	while (1) {
+		spin_lock_irqsave(&acb->doneq_lock, flags);
+		doneq_index = acb->doneq_index;
+		if ((readl(&reg->reply_post_producer_index) & 0xFFFF) ==
+				doneq_index) {
+			spin_unlock_irqrestore(&acb->doneq_lock, flags);
+			if (poll_ccb_done) {
+				rtn = SUCCESS;
+				break;
+			} else {
+				msleep(25);
+				if (poll_count > 40) {
+					rtn = FAILED;
+					break;
+				}
+				goto polling_hbaC_ccb_retry;
+			}
+		}
+		cmdSMID = acb->pCompletionQ[doneq_index].cmdSMID;
+		doneq_index++;
+		if (doneq_index >= acb->completionQ_entry)
+			doneq_index = 0;
+		acb->doneq_index = doneq_index;
+		spin_unlock_irqrestore(&acb->doneq_lock, flags);
+		pCCB = acb->pccb_pool[cmdSMID];
+		poll_ccb_done |= (pCCB == poll_ccb) ? 1 : 0;
+		/* check if command done with no error*/
+		if ((pCCB->acb != acb) || (pCCB->startdone != ARCMSR_CCB_START)) {
+			if (pCCB->startdone == ARCMSR_CCB_ABORTED) {
+				pr_notice("arcmsr%d: scsi id = %d "
+					"lun = %d ccb = '0x%p' poll command "
+					"abort successfully\n"
+					, acb->host->host_no
+					, pCCB->pcmd->device->id
+					, (u32)pCCB->pcmd->device->lun
+					, pCCB);
+				pCCB->pcmd->result = DID_ABORT << 16;
+				arcmsr_ccb_complete(pCCB);
+				continue;
+			}
+			pr_notice("arcmsr%d: polling an illegal "
+				"ccb command done ccb = '0x%p' "
+				"ccboutstandingcount = %d\n"
+				, acb->host->host_no
+				, pCCB
+				, atomic_read(&acb->ccboutstandingcount));
+			continue;
+		}
+		error = (acb->pCompletionQ[doneq_index].cmdFlag &
+			ARCMSR_CCBREPLY_FLAG_ERROR_MODE1) ? true : false;
+		arcmsr_report_ccb_state(acb, pCCB, error);
+	}
+	writel(doneq_index, &reg->reply_post_consumer_index);
+	return rtn;
+}
+
 static int arcmsr_polling_ccbdone(struct AdapterControlBlock *acb,
 					struct CommandControlBlock *poll_ccb)
 {
@@ -3192,6 +3590,9 @@ static int arcmsr_polling_ccbdone(struct
 	case ACB_ADAPTER_TYPE_D:
 		rtn = arcmsr_hbaD_polling_ccbdone(acb, poll_ccb);
 		break;
+	case ACB_ADAPTER_TYPE_E:
+		rtn = arcmsr_hbaE_polling_ccbdone(acb, poll_ccb);
+		break;
 	}
 	return rtn;
 }
@@ -3212,6 +3613,10 @@ static int arcmsr_iop_confirm(struct Ada
 	case ACB_ADAPTER_TYPE_D:
 		dma_coherent_handle = acb->dma_coherent_handle2;
 		break;
+	case ACB_ADAPTER_TYPE_E:
+		dma_coherent_handle = acb->dma_coherent_handle +
+			offsetof(struct CommandControlBlock, arcmsr_cdb);
+		break;
 	default:
 		dma_coherent_handle = acb->dma_coherent_handle;
 		break;
@@ -3320,6 +3725,29 @@ static int arcmsr_iop_confirm(struct Ada
 		}
 		}
 		break;
+	case ACB_ADAPTER_TYPE_E: {
+		struct MessageUnit_E __iomem *reg = acb->pmuE;
+		writel(ARCMSR_SIGNATURE_SET_CONFIG, &reg->msgcode_rwbuffer[0]);
+		writel(ARCMSR_SIGNATURE_1884, &reg->msgcode_rwbuffer[1]);
+		writel(cdb_phyaddr, &reg->msgcode_rwbuffer[2]);
+		writel(cdb_phyaddr_hi32, &reg->msgcode_rwbuffer[3]);
+		writel(acb->ccbsize, &reg->msgcode_rwbuffer[4]);
+		dma_coherent_handle = acb->dma_coherent_handle2;
+		cdb_phyaddr = (uint32_t)(dma_coherent_handle & 0xffffffff);
+		cdb_phyaddr_hi32 = (uint32_t)((dma_coherent_handle >> 16) >> 16);
+		writel(cdb_phyaddr, &reg->msgcode_rwbuffer[5]);
+		writel(cdb_phyaddr_hi32, &reg->msgcode_rwbuffer[6]);
+		writel(acb->roundup_ccbsize, &reg->msgcode_rwbuffer[7]);
+		writel(ARCMSR_INBOUND_MESG0_SET_CONFIG, &reg->inbound_msgaddr0);
+		acb->out_doorbell ^= ARCMSR_HBEMU_DRV2IOP_MESSAGE_CMD_DONE;
+		writel(acb->out_doorbell, &reg->iobound_doorbell);
+		if (!arcmsr_hbaE_wait_msgint_ready(acb)) {
+			pr_notice("arcmsr%d: 'set command Q window' timeout \n",
+				acb->host->host_no);
+			return 1;
+		}
+		}
+		break;
 	}
 	return 0;
 }
@@ -3360,6 +3788,13 @@ static void arcmsr_wait_firmware_ready(s
 			ARCMSR_ARC1214_MESSAGE_FIRMWARE_OK) == 0);
 		}
 		break;
+	case ACB_ADAPTER_TYPE_E: {
+		struct MessageUnit_E __iomem *reg = acb->pmuE;
+		do {
+			firmware_state = readl(&reg->outbound_msgaddr1);
+		} while ((firmware_state & ARCMSR_HBEMU_MESSAGE_FIRMWARE_OK) == 0);
+		}
+		break;
 	}
 }
 
@@ -3459,6 +3894,36 @@ static void arcmsr_hbaD_request_device_m
 	}
 }
 
+static void arcmsr_hbaE_request_device_map(struct AdapterControlBlock *acb)
+{
+	struct MessageUnit_E __iomem *reg = acb->pmuE;
+
+	if (unlikely(atomic_read(&acb->rq_map_token) == 0) ||
+		((acb->acb_flags & ACB_F_BUS_RESET) != 0) ||
+		((acb->acb_flags & ACB_F_ABORT) != 0)) {
+		mod_timer(&acb->eternal_timer,
+			jiffies + msecs_to_jiffies(6 * HZ));
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
+		writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);
+		acb->out_doorbell ^= ARCMSR_HBEMU_DRV2IOP_MESSAGE_CMD_DONE;
+		writel(acb->out_doorbell, &reg->iobound_doorbell);
+		mod_timer(&acb->eternal_timer, jiffies +
+			msecs_to_jiffies(6 * HZ));
+	}
+}
+
 static void arcmsr_request_device_map(unsigned long pacb)
 {
 	struct AdapterControlBlock *acb = (struct AdapterControlBlock *)pacb;
@@ -3478,6 +3943,9 @@ static void arcmsr_request_device_map(un
 		case ACB_ADAPTER_TYPE_D:
 			arcmsr_hbaD_request_device_map(acb);
 		break;
+		case ACB_ADAPTER_TYPE_E:
+			arcmsr_hbaE_request_device_map(acb);
+		break;
 	}
 }
 
@@ -3528,6 +3996,20 @@ static void arcmsr_hbaD_start_bgrb(struc
 	}
 }
 
+static void arcmsr_hbaE_start_bgrb(struct AdapterControlBlock *pACB)
+{
+	struct MessageUnit_E __iomem *pmu = pACB->pmuE;
+
+	pACB->acb_flags |= ACB_F_MSG_START_BGRB;
+	writel(ARCMSR_INBOUND_MESG0_START_BGRB, &pmu->inbound_msgaddr0);
+	pACB->out_doorbell ^= ARCMSR_HBEMU_DRV2IOP_MESSAGE_CMD_DONE;
+	writel(pACB->out_doorbell, &pmu->iobound_doorbell);
+	if (!arcmsr_hbaE_wait_msgint_ready(pACB)) {
+		pr_notice("arcmsr%d: wait 'start adapter "
+			"background rebulid' timeout \n", pACB->host->host_no);
+	}
+}
+
 static void arcmsr_start_adapter_bgrb(struct AdapterControlBlock *acb)
 {
 	switch (acb->adapter_type) {
@@ -3543,6 +4025,9 @@ static void arcmsr_start_adapter_bgrb(st
 	case ACB_ADAPTER_TYPE_D:
 		arcmsr_hbaD_start_bgrb(acb);
 		break;
+	case ACB_ADAPTER_TYPE_E:
+		arcmsr_hbaE_start_bgrb(acb);
+		break;
 	}
 }
 
@@ -3611,6 +4096,27 @@ static void arcmsr_clear_doorbell_queue_
 		}
 		}
 		break;
+	case ACB_ADAPTER_TYPE_E: {
+		struct MessageUnit_E __iomem *reg = acb->pmuE;
+		uint32_t i, tmp;
+
+		acb->in_doorbell = readl(&reg->iobound_doorbell);
+		writel(0, &reg->host_int_status); /*clear interrupt*/
+		acb->out_doorbell ^= ARCMSR_HBEMU_DRV2IOP_DATA_READ_OK;
+		writel(acb->out_doorbell, &reg->iobound_doorbell);
+		for(i=0; i < 200; i++) {
+			msleep(20);
+			tmp = acb->in_doorbell;
+			acb->in_doorbell = readl(&reg->iobound_doorbell);
+			if((tmp ^ acb->in_doorbell) & ARCMSR_HBEMU_IOP2DRV_DATA_WRITE_OK) {
+				writel(0, &reg->host_int_status); /*clear interrupt*/
+				acb->out_doorbell ^= ARCMSR_HBEMU_DRV2IOP_DATA_READ_OK;
+				writel(acb->out_doorbell, &reg->iobound_doorbell);
+			} else
+				break;
+		}
+		}
+		break;
 	}
 }
 
@@ -3662,6 +4168,19 @@ static void arcmsr_hardware_reset(struct
 			writel(0xD, &pmuC->write_sequence);
 		} while (((readl(&pmuC->host_diagnostic) & ARCMSR_ARC1880_DiagWrite_ENABLE) == 0) && (count < 5));
 		writel(ARCMSR_ARC1880_RESET_ADAPTER, &pmuC->host_diagnostic);
+	} else if (acb->dev_id == 0x1884) {
+		struct MessageUnit_E __iomem *pmuE = acb->pmuE;
+		do {
+			count++;
+			writel(0x4, &pmuE->write_sequence_3xxx);
+			writel(0xB, &pmuE->write_sequence_3xxx);
+			writel(0x2, &pmuE->write_sequence_3xxx);
+			writel(0x7, &pmuE->write_sequence_3xxx);
+			writel(0xD, &pmuE->write_sequence_3xxx);
+			mdelay(10);
+		} while (((readl(&pmuE->host_diagnostic_3xxx) &
+			ARCMSR_ARC1884_DiagWrite_ENABLE) == 0) && (count < 5));
+		writel(ARCMSR_ARC188X_RESET_ADAPTER, &pmuE->host_diagnostic_3xxx);
 	} else if ((acb->dev_id == 0x1214)) {
 		writel(0x20, pmuD->reset_request);
 	} else {
@@ -3704,6 +4223,12 @@ static bool arcmsr_reset_in_progress(str
 			true : false;
 		}
 		break;
+	case ACB_ADAPTER_TYPE_E:{
+		struct MessageUnit_E __iomem *reg = acb->pmuE;
+		rtn = (readl(&reg->host_diagnostic_3xxx) &
+			ARCMSR_ARC188X_RESET_ADAPTER) ? true : false;
+		}
+		break;
 	}
 	return rtn;
 }
@@ -3894,6 +4419,7 @@ static const char *arcmsr_info(struct Sc
 	case PCI_DEVICE_ID_ARECA_1680:
 	case PCI_DEVICE_ID_ARECA_1681:
 	case PCI_DEVICE_ID_ARECA_1880:
+	case PCI_DEVICE_ID_ARECA_1884:
 		type = "SAS/SATA";
 		break;
 	default:
