From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH v3 11/17] arcmsr: rename function and variable
Date: Tue, 19 Aug 2014 15:10:12 +0800
Message-ID: <1408432212.4748.57.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: hch@infradead.org, jbottomley@parallels.com, dan.carpenter@oracle.com, thenzl@redhat.com, agordeev@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Ching Huang <ching2048@areca.com.tw>

Rename some variable and function name for readability and consistency.

Signed-off-by: Ching Huang <ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
--- a/drivers/scsi/arcmsr/arcmsr.h	2014-05-06 15:27:14.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr.h	2014-05-06 15:27:38.000000000 +0800
@@ -359,7 +359,7 @@ struct ARCMSR_CDB
 #define ARCMSR_CDB_FLAG_ORDEREDQ           0x10
 
 	uint8_t							msgPages;
-	uint32_t						Context;
+	uint32_t						msgContext;
 	uint32_t						DataLength;
 	uint8_t							Cdb[16];
 	uint8_t							DeviceStatus;
@@ -562,7 +562,7 @@ struct AdapterControlBlock
 	/* dma_coherent used for memory free */
 	dma_addr_t			dma_coherent_handle;
 	/* dma_coherent_handle used for memory free */
-	dma_addr_t				dma_coherent_handle_hbb_mu;
+	dma_addr_t				dma_coherent_handle2;
 	unsigned int				uncache_size;
 	uint8_t				rqbuffer[ARCMSR_MAX_QBUFFER];
 	/* data collection buffer for read from 80331 */
@@ -613,7 +613,7 @@ struct CommandControlBlock{
 	struct list_head		list;				/*x32: 8byte, x64: 16byte*/
 	struct scsi_cmnd		*pcmd;				/*8 bytes pointer of linux scsi command */
 	struct AdapterControlBlock	*acb;				/*x32: 4byte, x64: 8byte*/
-	uint32_t			cdb_phyaddr_pattern;		/*x32: 4byte, x64: 4byte*/
+	uint32_t			cdb_phyaddr;			/*x32: 4byte, x64: 4byte*/
 	uint32_t			arc_cdb_size;			/*x32:4byte,x64:4byte*/
 	uint16_t			ccb_flags;			/*x32: 2byte, x64: 2byte*/
 	#define			CCB_FLAG_READ			0x0000
diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2014-08-14 18:40:12.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2014-08-14 18:40:26.000000000 +0800
@@ -99,16 +99,16 @@ static u32 arcmsr_disable_outbound_ints(
 static void arcmsr_enable_outbound_ints(struct AdapterControlBlock *acb,
 	u32 intmask_org);
 static void arcmsr_stop_adapter_bgrb(struct AdapterControlBlock *acb);
-static void arcmsr_flush_hba_cache(struct AdapterControlBlock *acb);
-static void arcmsr_flush_hbb_cache(struct AdapterControlBlock *acb);
+static void arcmsr_hbaA_flush_cache(struct AdapterControlBlock *acb);
+static void arcmsr_hbaB_flush_cache(struct AdapterControlBlock *acb);
 static void arcmsr_request_device_map(unsigned long pacb);
-static void arcmsr_request_hba_device_map(struct AdapterControlBlock *acb);
-static void arcmsr_request_hbb_device_map(struct AdapterControlBlock *acb);
-static void arcmsr_request_hbc_device_map(struct AdapterControlBlock *acb);
+static void arcmsr_hbaA_request_device_map(struct AdapterControlBlock *acb);
+static void arcmsr_hbaB_request_device_map(struct AdapterControlBlock *acb);
+static void arcmsr_hbaC_request_device_map(struct AdapterControlBlock *acb);
 static void arcmsr_message_isr_bh_fn(struct work_struct *work);
 static bool arcmsr_get_firmware_spec(struct AdapterControlBlock *acb);
 static void arcmsr_start_adapter_bgrb(struct AdapterControlBlock *acb);
-static void arcmsr_hbc_message_isr(struct AdapterControlBlock *pACB);
+static void arcmsr_hbaC_message_isr(struct AdapterControlBlock *pACB);
 static void arcmsr_hardware_reset(struct AdapterControlBlock *acb);
 static const char *arcmsr_info(struct Scsi_Host *);
 static irqreturn_t arcmsr_interrupt(struct AdapterControlBlock *acb);
@@ -180,7 +180,7 @@ static struct pci_driver arcmsr_pci_driv
 ****************************************************************************
 */
 
-static void arcmsr_free_hbb_mu(struct AdapterControlBlock *acb)
+static void arcmsr_free_mu(struct AdapterControlBlock *acb)
 {
 	switch (acb->adapter_type) {
 	case ACB_ADAPTER_TYPE_A:
@@ -189,7 +189,7 @@ static void arcmsr_free_hbb_mu(struct Ad
 	case ACB_ADAPTER_TYPE_B:{
 		dma_free_coherent(&acb->pdev->dev,
 			sizeof(struct MessageUnit_B),
-			acb->pmuB, acb->dma_coherent_handle_hbb_mu);
+			acb->pmuB, acb->dma_coherent_handle2);
 	}
 	}
 }
@@ -295,7 +295,7 @@ static int arcmsr_bios_param(struct scsi
 	return 0;
 }
 
-static uint8_t arcmsr_hba_wait_msgint_ready(struct AdapterControlBlock *acb)
+static uint8_t arcmsr_hbaA_wait_msgint_ready(struct AdapterControlBlock *acb)
 {
 	struct MessageUnit_A __iomem *reg = acb->pmuA;
 	int i;
@@ -313,7 +313,7 @@ static uint8_t arcmsr_hba_wait_msgint_re
 	return false;
 }
 
-static uint8_t arcmsr_hbb_wait_msgint_ready(struct AdapterControlBlock *acb)
+static uint8_t arcmsr_hbaB_wait_msgint_ready(struct AdapterControlBlock *acb)
 {
 	struct MessageUnit_B *reg = acb->pmuB;
 	int i;
@@ -333,7 +333,7 @@ static uint8_t arcmsr_hbb_wait_msgint_re
 	return false;
 }
 
-static uint8_t arcmsr_hbc_wait_msgint_ready(struct AdapterControlBlock *pACB)
+static uint8_t arcmsr_hbaC_wait_msgint_ready(struct AdapterControlBlock *pACB)
 {
 	struct MessageUnit_C *phbcmu = (struct MessageUnit_C *)pACB->pmuC;
 	int i;
@@ -351,13 +351,13 @@ static uint8_t arcmsr_hbc_wait_msgint_re
 	return false;
 }
 
-static void arcmsr_flush_hba_cache(struct AdapterControlBlock *acb)
+static void arcmsr_hbaA_flush_cache(struct AdapterControlBlock *acb)
 {
 	struct MessageUnit_A __iomem *reg = acb->pmuA;
 	int retry_count = 30;
 	writel(ARCMSR_INBOUND_MESG0_FLUSH_CACHE, &reg->inbound_msgaddr0);
 	do {
-		if (arcmsr_hba_wait_msgint_ready(acb))
+		if (arcmsr_hbaA_wait_msgint_ready(acb))
 			break;
 		else {
 			retry_count--;
@@ -367,13 +367,13 @@ static void arcmsr_flush_hba_cache(struc
 	} while (retry_count != 0);
 }
 
-static void arcmsr_flush_hbb_cache(struct AdapterControlBlock *acb)
+static void arcmsr_hbaB_flush_cache(struct AdapterControlBlock *acb)
 {
 	struct MessageUnit_B *reg = acb->pmuB;
 	int retry_count = 30;
 	writel(ARCMSR_MESSAGE_FLUSH_CACHE, reg->drv2iop_doorbell);
 	do {
-		if (arcmsr_hbb_wait_msgint_ready(acb))
+		if (arcmsr_hbaB_wait_msgint_ready(acb))
 			break;
 		else {
 			retry_count--;
@@ -383,14 +383,14 @@ static void arcmsr_flush_hbb_cache(struc
 	} while (retry_count != 0);
 }
 
-static void arcmsr_flush_hbc_cache(struct AdapterControlBlock *pACB)
+static void arcmsr_hbaC_flush_cache(struct AdapterControlBlock *pACB)
 {
 	struct MessageUnit_C *reg = (struct MessageUnit_C *)pACB->pmuC;
 	int retry_count = 30;/* enlarge wait flush adapter cache time: 10 minute */
 	writel(ARCMSR_INBOUND_MESG0_FLUSH_CACHE, &reg->inbound_msgaddr0);
 	writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);
 	do {
-		if (arcmsr_hbc_wait_msgint_ready(pACB)) {
+		if (arcmsr_hbaC_wait_msgint_ready(pACB)) {
 			break;
 		} else {
 			retry_count--;
@@ -405,16 +405,16 @@ static void arcmsr_flush_adapter_cache(s
 	switch (acb->adapter_type) {
 
 	case ACB_ADAPTER_TYPE_A: {
-		arcmsr_flush_hba_cache(acb);
+		arcmsr_hbaA_flush_cache(acb);
 		}
 		break;
 
 	case ACB_ADAPTER_TYPE_B: {
-		arcmsr_flush_hbb_cache(acb);
+		arcmsr_hbaB_flush_cache(acb);
 		}
 		break;
 	case ACB_ADAPTER_TYPE_C: {
-		arcmsr_flush_hbc_cache(acb);
+		arcmsr_hbaC_flush_cache(acb);
 		}
 	}
 }
@@ -459,7 +459,7 @@ static int arcmsr_alloc_ccb_pool(struct 
 	acb->vir2phy_offset = (unsigned long)dma_coherent - (unsigned long)dma_coherent_handle;
 	for(i = 0; i < ARCMSR_MAX_FREECCB_NUM; i++){
 		cdb_phyaddr = dma_coherent_handle + offsetof(struct CommandControlBlock, arcmsr_cdb);
-		ccb_tmp->cdb_phyaddr_pattern = ((acb->adapter_type == ACB_ADAPTER_TYPE_C) ? cdb_phyaddr : (cdb_phyaddr >> 5));
+		ccb_tmp->cdb_phyaddr = ((acb->adapter_type == ACB_ADAPTER_TYPE_C) ? cdb_phyaddr : (cdb_phyaddr >> 5));
 		acb->pccb_pool[i] = ccb_tmp;
 		ccb_tmp->acb = acb;
 		INIT_LIST_HEAD(&ccb_tmp->list);
@@ -676,7 +676,7 @@ RAID_controller_stop:
 	arcmsr_flush_adapter_cache(acb);
 	arcmsr_free_ccb_pool(acb);
 free_hbb_mu:
-	arcmsr_free_hbb_mu(acb);
+	arcmsr_free_mu(acb);
 unmap_pci_region:
 	arcmsr_unmap_pciregion(acb);
 pci_release_regs:
@@ -773,11 +773,11 @@ controller_unregister:
 	return -ENODEV;
 }
 
-static uint8_t arcmsr_abort_hba_allcmd(struct AdapterControlBlock *acb)
+static uint8_t arcmsr_hbaA_abort_allcmd(struct AdapterControlBlock *acb)
 {
 	struct MessageUnit_A __iomem *reg = acb->pmuA;
 	writel(ARCMSR_INBOUND_MESG0_ABORT_CMD, &reg->inbound_msgaddr0);
-	if (!arcmsr_hba_wait_msgint_ready(acb)) {
+	if (!arcmsr_hbaA_wait_msgint_ready(acb)) {
 		printk(KERN_NOTICE
 			"arcmsr%d: wait 'abort all outstanding command' timeout \n"
 			, acb->host->host_no);
@@ -786,12 +786,12 @@ static uint8_t arcmsr_abort_hba_allcmd(s
 	return true;
 }
 
-static uint8_t arcmsr_abort_hbb_allcmd(struct AdapterControlBlock *acb)
+static uint8_t arcmsr_hbaB_abort_allcmd(struct AdapterControlBlock *acb)
 {
 	struct MessageUnit_B *reg = acb->pmuB;
 
 	writel(ARCMSR_MESSAGE_ABORT_CMD, reg->drv2iop_doorbell);
-	if (!arcmsr_hbb_wait_msgint_ready(acb)) {
+	if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
 		printk(KERN_NOTICE
 			"arcmsr%d: wait 'abort all outstanding command' timeout \n"
 			, acb->host->host_no);
@@ -799,12 +799,12 @@ static uint8_t arcmsr_abort_hbb_allcmd(s
 	}
 	return true;
 }
-static uint8_t arcmsr_abort_hbc_allcmd(struct AdapterControlBlock *pACB)
+static uint8_t arcmsr_hbaC_abort_allcmd(struct AdapterControlBlock *pACB)
 {
 	struct MessageUnit_C *reg = (struct MessageUnit_C *)pACB->pmuC;
 	writel(ARCMSR_INBOUND_MESG0_ABORT_CMD, &reg->inbound_msgaddr0);
 	writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);
-	if (!arcmsr_hbc_wait_msgint_ready(pACB)) {
+	if (!arcmsr_hbaC_wait_msgint_ready(pACB)) {
 		printk(KERN_NOTICE
 			"arcmsr%d: wait 'abort all outstanding command' timeout \n"
 			, pACB->host->host_no);
@@ -817,17 +817,17 @@ static uint8_t arcmsr_abort_allcmd(struc
 	uint8_t rtnval = 0;
 	switch (acb->adapter_type) {
 	case ACB_ADAPTER_TYPE_A: {
-		rtnval = arcmsr_abort_hba_allcmd(acb);
+		rtnval = arcmsr_hbaA_abort_allcmd(acb);
 		}
 		break;
 
 	case ACB_ADAPTER_TYPE_B: {
-		rtnval = arcmsr_abort_hbb_allcmd(acb);
+		rtnval = arcmsr_hbaB_abort_allcmd(acb);
 		}
 		break;
 
 	case ACB_ADAPTER_TYPE_C: {
-		rtnval = arcmsr_abort_hbc_allcmd(acb);
+		rtnval = arcmsr_hbaC_abort_allcmd(acb);
 		}
 	}
 	return rtnval;
@@ -1084,7 +1084,7 @@ static void arcmsr_remove(struct pci_dev
 	}
 	arcmsr_free_irq(pdev, acb);
 	arcmsr_free_ccb_pool(acb);
-	arcmsr_free_hbb_mu(acb);
+	arcmsr_free_mu(acb);
 	arcmsr_unmap_pciregion(acb);
 	pci_release_regions(pdev);
 	scsi_host_put(host);
@@ -1169,7 +1169,7 @@ static int arcmsr_build_ccb(struct Adapt
 	arcmsr_cdb->TargetID = pcmd->device->id;
 	arcmsr_cdb->LUN = pcmd->device->lun;
 	arcmsr_cdb->Function = 1;
-	arcmsr_cdb->Context = 0;
+	arcmsr_cdb->msgContext = 0;
 	memcpy(arcmsr_cdb->Cdb, pcmd->cmnd, pcmd->cmd_len);
 
 	nseg = scsi_dma_map(pcmd);
@@ -1210,7 +1210,7 @@ static int arcmsr_build_ccb(struct Adapt
 
 static void arcmsr_post_ccb(struct AdapterControlBlock *acb, struct CommandControlBlock *ccb)
 {
-	uint32_t cdb_phyaddr_pattern = ccb->cdb_phyaddr_pattern;
+	uint32_t cdb_phyaddr = ccb->cdb_phyaddr;
 	struct ARCMSR_CDB *arcmsr_cdb = (struct ARCMSR_CDB *)&ccb->arcmsr_cdb;
 	atomic_inc(&acb->ccboutstandingcount);
 	ccb->startdone = ARCMSR_CCB_START;
@@ -1219,10 +1219,10 @@ static void arcmsr_post_ccb(struct Adapt
 		struct MessageUnit_A __iomem *reg = acb->pmuA;
 
 		if (arcmsr_cdb->Flags & ARCMSR_CDB_FLAG_SGL_BSIZE)
-			writel(cdb_phyaddr_pattern | ARCMSR_CCBPOST_FLAG_SGL_BSIZE,
+			writel(cdb_phyaddr | ARCMSR_CCBPOST_FLAG_SGL_BSIZE,
 			&reg->inbound_queueport);
 		else {
-				writel(cdb_phyaddr_pattern, &reg->inbound_queueport);
+				writel(cdb_phyaddr, &reg->inbound_queueport);
 		}
 		}
 		break;
@@ -1234,10 +1234,10 @@ static void arcmsr_post_ccb(struct Adapt
 		ending_index = ((index + 1) % ARCMSR_MAX_HBB_POSTQUEUE);
 		writel(0, &reg->post_qbuffer[ending_index]);
 		if (arcmsr_cdb->Flags & ARCMSR_CDB_FLAG_SGL_BSIZE) {
-			writel(cdb_phyaddr_pattern | ARCMSR_CCBPOST_FLAG_SGL_BSIZE,\
+			writel(cdb_phyaddr | ARCMSR_CCBPOST_FLAG_SGL_BSIZE,\
 						 &reg->post_qbuffer[index]);
 		} else {
-			writel(cdb_phyaddr_pattern, &reg->post_qbuffer[index]);
+			writel(cdb_phyaddr, &reg->post_qbuffer[index]);
 		}
 		index++;
 		index %= ARCMSR_MAX_HBB_POSTQUEUE;/*if last index number set it to 0 */
@@ -1250,7 +1250,7 @@ static void arcmsr_post_ccb(struct Adapt
 		uint32_t ccb_post_stamp, arc_cdb_size;
 
 		arc_cdb_size = (ccb->arc_cdb_size > 0x300) ? 0x300 : ccb->arc_cdb_size;
-		ccb_post_stamp = (cdb_phyaddr_pattern | ((arc_cdb_size - 1) >> 6) | 1);
+		ccb_post_stamp = (cdb_phyaddr | ((arc_cdb_size - 1) >> 6) | 1);
 		if (acb->cdb_phyaddr_hi32) {
 			writel(acb->cdb_phyaddr_hi32, &phbcmu->inbound_queueport_high);
 			writel(ccb_post_stamp, &phbcmu->inbound_queueport_low);
@@ -1261,38 +1261,38 @@ static void arcmsr_post_ccb(struct Adapt
 	}
 }
 
-static void arcmsr_stop_hba_bgrb(struct AdapterControlBlock *acb)
+static void arcmsr_hbaA_stop_bgrb(struct AdapterControlBlock *acb)
 {
 	struct MessageUnit_A __iomem *reg = acb->pmuA;
 	acb->acb_flags &= ~ACB_F_MSG_START_BGRB;
 	writel(ARCMSR_INBOUND_MESG0_STOP_BGRB, &reg->inbound_msgaddr0);
-	if (!arcmsr_hba_wait_msgint_ready(acb)) {
+	if (!arcmsr_hbaA_wait_msgint_ready(acb)) {
 		printk(KERN_NOTICE
 			"arcmsr%d: wait 'stop adapter background rebulid' timeout \n"
 			, acb->host->host_no);
 	}
 }
 
-static void arcmsr_stop_hbb_bgrb(struct AdapterControlBlock *acb)
+static void arcmsr_hbaB_stop_bgrb(struct AdapterControlBlock *acb)
 {
 	struct MessageUnit_B *reg = acb->pmuB;
 	acb->acb_flags &= ~ACB_F_MSG_START_BGRB;
 	writel(ARCMSR_MESSAGE_STOP_BGRB, reg->drv2iop_doorbell);
 
-	if (!arcmsr_hbb_wait_msgint_ready(acb)) {
+	if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
 		printk(KERN_NOTICE
 			"arcmsr%d: wait 'stop adapter background rebulid' timeout \n"
 			, acb->host->host_no);
 	}
 }
 
-static void arcmsr_stop_hbc_bgrb(struct AdapterControlBlock *pACB)
+static void arcmsr_hbaC_stop_bgrb(struct AdapterControlBlock *pACB)
 {
 	struct MessageUnit_C *reg = (struct MessageUnit_C *)pACB->pmuC;
 	pACB->acb_flags &= ~ACB_F_MSG_START_BGRB;
 	writel(ARCMSR_INBOUND_MESG0_STOP_BGRB, &reg->inbound_msgaddr0);
 	writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);
-	if (!arcmsr_hbc_wait_msgint_ready(pACB)) {
+	if (!arcmsr_hbaC_wait_msgint_ready(pACB)) {
 		printk(KERN_NOTICE
 			"arcmsr%d: wait 'stop adapter background rebulid' timeout \n"
 			, pACB->host->host_no);
@@ -1303,16 +1303,16 @@ static void arcmsr_stop_adapter_bgrb(str
 {
 	switch (acb->adapter_type) {
 	case ACB_ADAPTER_TYPE_A: {
-		arcmsr_stop_hba_bgrb(acb);
+		arcmsr_hbaA_stop_bgrb(acb);
 		}
 		break;
 
 	case ACB_ADAPTER_TYPE_B: {
-		arcmsr_stop_hbb_bgrb(acb);
+		arcmsr_hbaB_stop_bgrb(acb);
 		}
 		break;
 	case ACB_ADAPTER_TYPE_C: {
-		arcmsr_stop_hbc_bgrb(acb);
+		arcmsr_hbaC_stop_bgrb(acb);
 		}
 	}
 }
@@ -1490,7 +1490,7 @@ static void arcmsr_iop2drv_data_read_han
 	}
 }
 
-static void arcmsr_hba_doorbell_isr(struct AdapterControlBlock *acb)
+static void arcmsr_hbaA_doorbell_isr(struct AdapterControlBlock *acb)
 {
 	uint32_t outbound_doorbell;
 	struct MessageUnit_A __iomem *reg = acb->pmuA;
@@ -1505,7 +1505,7 @@ static void arcmsr_hba_doorbell_isr(stru
 	} while (outbound_doorbell & (ARCMSR_OUTBOUND_IOP331_DATA_WRITE_OK
 		| ARCMSR_OUTBOUND_IOP331_DATA_READ_OK));
 }
-static void arcmsr_hbc_doorbell_isr(struct AdapterControlBlock *pACB)
+static void arcmsr_hbaC_doorbell_isr(struct AdapterControlBlock *pACB)
 {
 	uint32_t outbound_doorbell;
 	struct MessageUnit_C *reg = (struct MessageUnit_C *)pACB->pmuC;
@@ -1525,13 +1525,13 @@ static void arcmsr_hbc_doorbell_isr(stru
 		if (outbound_doorbell & ARCMSR_HBCMU_IOP2DRV_DATA_READ_OK)
 			arcmsr_iop2drv_data_read_handle(pACB);
 		if (outbound_doorbell & ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE)
-			arcmsr_hbc_message_isr(pACB);
+			arcmsr_hbaC_message_isr(pACB);
 		outbound_doorbell = readl(&reg->outbound_doorbell);
 	} while (outbound_doorbell & (ARCMSR_HBCMU_IOP2DRV_DATA_WRITE_OK
 		| ARCMSR_HBCMU_IOP2DRV_DATA_READ_OK
 		| ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE));
 }
-static void arcmsr_hba_postqueue_isr(struct AdapterControlBlock *acb)
+static void arcmsr_hbaA_postqueue_isr(struct AdapterControlBlock *acb)
 {
 	uint32_t flag_ccb;
 	struct MessageUnit_A __iomem *reg = acb->pmuA;
@@ -1545,7 +1545,7 @@ static void arcmsr_hba_postqueue_isr(str
 		arcmsr_drain_donequeue(acb, pCCB, error);
 	}
 }
-static void arcmsr_hbb_postqueue_isr(struct AdapterControlBlock *acb)
+static void arcmsr_hbaB_postqueue_isr(struct AdapterControlBlock *acb)
 {
 	uint32_t index;
 	uint32_t flag_ccb;
@@ -1566,7 +1566,7 @@ static void arcmsr_hbb_postqueue_isr(str
 	}
 }
 
-static void arcmsr_hbc_postqueue_isr(struct AdapterControlBlock *acb)
+static void arcmsr_hbaC_postqueue_isr(struct AdapterControlBlock *acb)
 {
 	struct MessageUnit_C *phbcmu;
 	struct ARCMSR_CDB *arcmsr_cdb;
@@ -1604,14 +1604,14 @@ static void arcmsr_hbc_postqueue_isr(str
 ** We want this in order to compare the drivemap so that we can detect newly-attached drives.
 **********************************************************************************
 */
-static void arcmsr_hba_message_isr(struct AdapterControlBlock *acb)
+static void arcmsr_hbaA_message_isr(struct AdapterControlBlock *acb)
 {
 	struct MessageUnit_A *reg  = acb->pmuA;
 	/*clear interrupt and message state*/
 	writel(ARCMSR_MU_OUTBOUND_MESSAGE0_INT, &reg->outbound_intstatus);
 	schedule_work(&acb->arcmsr_do_message_isr_bh);
 }
-static void arcmsr_hbb_message_isr(struct AdapterControlBlock *acb)
+static void arcmsr_hbaB_message_isr(struct AdapterControlBlock *acb)
 {
 	struct MessageUnit_B *reg  = acb->pmuB;
 
@@ -1628,7 +1628,7 @@ static void arcmsr_hbb_message_isr(struc
 ** We want this in order to compare the drivemap so that we can detect newly-attached drives.
 **********************************************************************************
 */
-static void arcmsr_hbc_message_isr(struct AdapterControlBlock *acb)
+static void arcmsr_hbaC_message_isr(struct AdapterControlBlock *acb)
 {
 	struct MessageUnit_C *reg  = acb->pmuC;
 	/*clear interrupt and message state*/
@@ -1636,7 +1636,7 @@ static void arcmsr_hbc_message_isr(struc
 	schedule_work(&acb->arcmsr_do_message_isr_bh);
 }
 
-static int arcmsr_handle_hba_isr(struct AdapterControlBlock *acb)
+static int arcmsr_hbaA_handle_isr(struct AdapterControlBlock *acb)
 {
 	uint32_t outbound_intstatus;
 	struct MessageUnit_A __iomem *reg = acb->pmuA;
@@ -1647,11 +1647,11 @@ static int arcmsr_handle_hba_isr(struct 
 	do {
 		writel(outbound_intstatus, &reg->outbound_intstatus);
 		if (outbound_intstatus & ARCMSR_MU_OUTBOUND_DOORBELL_INT)
-			arcmsr_hba_doorbell_isr(acb);
+			arcmsr_hbaA_doorbell_isr(acb);
 		if (outbound_intstatus & ARCMSR_MU_OUTBOUND_POSTQUEUE_INT)
-			arcmsr_hba_postqueue_isr(acb);
+			arcmsr_hbaA_postqueue_isr(acb);
 		if (outbound_intstatus & ARCMSR_MU_OUTBOUND_MESSAGE0_INT)
-			arcmsr_hba_message_isr(acb);
+			arcmsr_hbaA_message_isr(acb);
 		outbound_intstatus = readl(&reg->outbound_intstatus) &
 			acb->outbound_int_enable;
 	} while (outbound_intstatus & (ARCMSR_MU_OUTBOUND_DOORBELL_INT
@@ -1660,7 +1660,7 @@ static int arcmsr_handle_hba_isr(struct 
 	return IRQ_HANDLED;
 }
 
-static int arcmsr_handle_hbb_isr(struct AdapterControlBlock *acb)
+static int arcmsr_hbaB_handle_isr(struct AdapterControlBlock *acb)
 {
 	uint32_t outbound_doorbell;
 	struct MessageUnit_B *reg = acb->pmuB;
@@ -1676,9 +1676,9 @@ static int arcmsr_handle_hbb_isr(struct 
 		if (outbound_doorbell & ARCMSR_IOP2DRV_DATA_READ_OK)
 			arcmsr_iop2drv_data_read_handle(acb);
 		if (outbound_doorbell & ARCMSR_IOP2DRV_CDB_DONE)
-			arcmsr_hbb_postqueue_isr(acb);
+			arcmsr_hbaB_postqueue_isr(acb);
 		if (outbound_doorbell & ARCMSR_IOP2DRV_MESSAGE_CMD_DONE)
-			arcmsr_hbb_message_isr(acb);
+			arcmsr_hbaB_message_isr(acb);
 		outbound_doorbell = readl(reg->iop2drv_doorbell) &
 			acb->outbound_int_enable;
 	} while (outbound_doorbell & (ARCMSR_IOP2DRV_DATA_WRITE_OK
@@ -1688,7 +1688,7 @@ static int arcmsr_handle_hbb_isr(struct 
 	return IRQ_HANDLED;
 }
 
-static int arcmsr_handle_hbc_isr(struct AdapterControlBlock *pACB)
+static int arcmsr_hbaC_handle_isr(struct AdapterControlBlock *pACB)
 {
 	uint32_t host_interrupt_status;
 	struct MessageUnit_C *phbcmu = (struct MessageUnit_C *)pACB->pmuC;
@@ -1704,10 +1704,10 @@ static int arcmsr_handle_hbc_isr(struct 
 		return IRQ_NONE;
 	do {
 		if (host_interrupt_status & ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR)
-			arcmsr_hbc_doorbell_isr(pACB);
+			arcmsr_hbaC_doorbell_isr(pACB);
 		/* MU post queue interrupts*/
 		if (host_interrupt_status & ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR)
-			arcmsr_hbc_postqueue_isr(pACB);
+			arcmsr_hbaC_postqueue_isr(pACB);
 		host_interrupt_status = readl(&phbcmu->host_int_status);
 	} while (host_interrupt_status & (ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR |
 		ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR));
@@ -1717,13 +1717,13 @@ static irqreturn_t arcmsr_interrupt(stru
 {
 	switch (acb->adapter_type) {
 	case ACB_ADAPTER_TYPE_A:
-		return arcmsr_handle_hba_isr(acb);
+		return arcmsr_hbaA_handle_isr(acb);
 		break;
 	case ACB_ADAPTER_TYPE_B:
-		return arcmsr_handle_hbb_isr(acb);
+		return arcmsr_hbaB_handle_isr(acb);
 		break;
 	case ACB_ADAPTER_TYPE_C:
-		return arcmsr_handle_hbc_isr(acb);
+		return arcmsr_hbaC_handle_isr(acb);
 		break;
 	default:
 		return IRQ_NONE;
@@ -2143,7 +2143,7 @@ static int arcmsr_queue_command_lck(stru
 
 static DEF_SCSI_QCMD(arcmsr_queue_command)
 
-static bool arcmsr_get_hba_config(struct AdapterControlBlock *acb)
+static bool arcmsr_hbaA_get_config(struct AdapterControlBlock *acb)
 {
 	struct MessageUnit_A __iomem *reg = acb->pmuA;
 	char *acb_firm_model = acb->firm_model;
@@ -2154,7 +2154,7 @@ static bool arcmsr_get_hba_config(struct
 	char __iomem *iop_device_map = (char __iomem *)(&reg->message_rwbuffer[21]);
 	int count;
 	writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);
-	if (!arcmsr_hba_wait_msgint_ready(acb)) {
+	if (!arcmsr_hbaA_wait_msgint_ready(acb)) {
 		printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware \
 			miscellaneous data' timeout \n", acb->host->host_no);
 		return false;
@@ -2194,7 +2194,7 @@ static bool arcmsr_get_hba_config(struct
 	acb->firm_cfg_version = readl(&reg->message_rwbuffer[25]);  /*firm_cfg_version,25,100-103*/
 	return true;
 }
-static bool arcmsr_get_hbb_config(struct AdapterControlBlock *acb)
+static bool arcmsr_hbaB_get_config(struct AdapterControlBlock *acb)
 {
 	struct MessageUnit_B *reg = acb->pmuB;
 	struct pci_dev *pdev = acb->pdev;
@@ -2215,7 +2215,7 @@ static bool arcmsr_get_hbb_config(struct
 		printk(KERN_NOTICE "arcmsr%d: dma_alloc_coherent got error for hbb mu\n", acb->host->host_no);
 		return false;
 	}
-	acb->dma_coherent_handle_hbb_mu = dma_coherent_handle;
+	acb->dma_coherent_handle2 = dma_coherent_handle;
 	reg = (struct MessageUnit_B *)dma_coherent;
 	acb->pmuB = reg;
 	reg->drv2iop_doorbell= (uint32_t __iomem *)((unsigned long)acb->mem_base0 + ARCMSR_DRV2IOP_DOORBELL);
@@ -2230,7 +2230,7 @@ static bool arcmsr_get_hbb_config(struct
 	iop_device_map = (char __iomem *)(&reg->message_rwbuffer[21]);	/*firm_version,21,84-99*/
 
 	writel(ARCMSR_MESSAGE_GET_CONFIG, reg->drv2iop_doorbell);
-	if (!arcmsr_hbb_wait_msgint_ready(acb)) {
+	if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
 		printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware \
 			miscellaneous data' timeout \n", acb->host->host_no);
 		return false;
@@ -2278,7 +2278,7 @@ static bool arcmsr_get_hbb_config(struct
 	return true;
 }
 
-static bool arcmsr_get_hbc_config(struct AdapterControlBlock *pACB)
+static bool arcmsr_hbaC_get_config(struct AdapterControlBlock *pACB)
 {
 	uint32_t intmask_org, Index, firmware_state = 0;
 	struct MessageUnit_C *reg = pACB->pmuC;
@@ -2342,13 +2342,13 @@ static bool arcmsr_get_firmware_spec(str
 
 	switch (acb->adapter_type) {
 	case ACB_ADAPTER_TYPE_A:
-		rtn = arcmsr_get_hba_config(acb);
+		rtn = arcmsr_hbaA_get_config(acb);
 		break;
 	case ACB_ADAPTER_TYPE_B:
-		rtn = arcmsr_get_hbb_config(acb);
+		rtn = arcmsr_hbaB_get_config(acb);
 		break;
 	case ACB_ADAPTER_TYPE_C:
-		rtn = arcmsr_get_hbc_config(acb);
+		rtn = arcmsr_hbaC_get_config(acb);
 		break;
 	default:
 		break;
@@ -2361,7 +2361,7 @@ static bool arcmsr_get_firmware_spec(str
 	return rtn;
 }
 
-static int arcmsr_polling_hba_ccbdone(struct AdapterControlBlock *acb,
+static int arcmsr_hbaA_polling_ccbdone(struct AdapterControlBlock *acb,
 	struct CommandControlBlock *poll_ccb)
 {
 	struct MessageUnit_A __iomem *reg = acb->pmuA;
@@ -2417,7 +2417,7 @@ static int arcmsr_polling_hba_ccbdone(st
 	return rtn;
 }
 
-static int arcmsr_polling_hbb_ccbdone(struct AdapterControlBlock *acb,
+static int arcmsr_hbaB_polling_ccbdone(struct AdapterControlBlock *acb,
 					struct CommandControlBlock *poll_ccb)
 {
 	struct MessageUnit_B *reg = acb->pmuB;
@@ -2481,7 +2481,7 @@ static int arcmsr_polling_hbb_ccbdone(st
 	return rtn;
 }
 
-static int arcmsr_polling_hbc_ccbdone(struct AdapterControlBlock *acb, struct CommandControlBlock *poll_ccb)
+static int arcmsr_hbaC_polling_ccbdone(struct AdapterControlBlock *acb, struct CommandControlBlock *poll_ccb)
 {
 	struct MessageUnit_C *reg = (struct MessageUnit_C *)acb->pmuC;
 	uint32_t flag_ccb, ccb_cdb_phy;
@@ -2544,16 +2544,16 @@ static int arcmsr_polling_ccbdone(struct
 	switch (acb->adapter_type) {
 
 	case ACB_ADAPTER_TYPE_A: {
-		rtn = arcmsr_polling_hba_ccbdone(acb, poll_ccb);
+		rtn = arcmsr_hbaA_polling_ccbdone(acb, poll_ccb);
 		}
 		break;
 
 	case ACB_ADAPTER_TYPE_B: {
-		rtn = arcmsr_polling_hbb_ccbdone(acb, poll_ccb);
+		rtn = arcmsr_hbaB_polling_ccbdone(acb, poll_ccb);
 		}
 		break;
 	case ACB_ADAPTER_TYPE_C: {
-		rtn = arcmsr_polling_hbc_ccbdone(acb, poll_ccb);
+		rtn = arcmsr_hbaC_polling_ccbdone(acb, poll_ccb);
 		}
 	}
 	return rtn;
@@ -2587,7 +2587,7 @@ static int arcmsr_iop_confirm(struct Ada
 			writel(cdb_phyaddr_hi32, &reg->message_rwbuffer[1]);
 			writel(ARCMSR_INBOUND_MESG0_SET_CONFIG, \
 							&reg->inbound_msgaddr0);
-			if (!arcmsr_hba_wait_msgint_ready(acb)) {
+			if (!arcmsr_hbaA_wait_msgint_ready(acb)) {
 				printk(KERN_NOTICE "arcmsr%d: ""set ccb high \
 				part physical address timeout\n",
 				acb->host->host_no);
@@ -2605,12 +2605,12 @@ static int arcmsr_iop_confirm(struct Ada
 		reg->postq_index = 0;
 		reg->doneq_index = 0;
 		writel(ARCMSR_MESSAGE_SET_POST_WINDOW, reg->drv2iop_doorbell);
-		if (!arcmsr_hbb_wait_msgint_ready(acb)) {
+		if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
 			printk(KERN_NOTICE "arcmsr%d:can not set diver mode\n", \
 				acb->host->host_no);
 			return 1;
 		}
-		post_queue_phyaddr = acb->dma_coherent_handle_hbb_mu;
+		post_queue_phyaddr = acb->dma_coherent_handle2;
 		rwbuffer = reg->message_rwbuffer;
 		/* driver "set config" signature */
 		writel(ARCMSR_SIGNATURE_SET_CONFIG, rwbuffer++);
@@ -2624,13 +2624,13 @@ static int arcmsr_iop_confirm(struct Ada
 		writel(1056, rwbuffer);
 
 		writel(ARCMSR_MESSAGE_SET_CONFIG, reg->drv2iop_doorbell);
-		if (!arcmsr_hbb_wait_msgint_ready(acb)) {
+		if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
 			printk(KERN_NOTICE "arcmsr%d: 'set command Q window' \
 			timeout \n",acb->host->host_no);
 			return 1;
 		}
 		writel(ARCMSR_MESSAGE_START_DRIVER_MODE, reg->drv2iop_doorbell);
-		if (!arcmsr_hbb_wait_msgint_ready(acb)) {
+		if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
 			pr_err("arcmsr%d: can't set driver mode.\n",
 				acb->host->host_no);
 			return 1;
@@ -2647,7 +2647,7 @@ static int arcmsr_iop_confirm(struct Ada
 			writel(cdb_phyaddr_hi32, &reg->msgcode_rwbuffer[1]);
 			writel(ARCMSR_INBOUND_MESG0_SET_CONFIG, &reg->inbound_msgaddr0);
 			writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);
-			if (!arcmsr_hbc_wait_msgint_ready(acb)) {
+			if (!arcmsr_hbaC_wait_msgint_ready(acb)) {
 				printk(KERN_NOTICE "arcmsr%d: 'set command Q window' \
 				timeout \n", acb->host->host_no);
 				return 1;
@@ -2688,7 +2688,7 @@ static void arcmsr_wait_firmware_ready(s
 	}
 }
 
-static void arcmsr_request_hba_device_map(struct AdapterControlBlock *acb)
+static void arcmsr_hbaA_request_device_map(struct AdapterControlBlock *acb)
 {
 	struct MessageUnit_A __iomem *reg = acb->pmuA;
 	if (unlikely(atomic_read(&acb->rq_map_token) == 0) || ((acb->acb_flags & ACB_F_BUS_RESET) != 0 ) || ((acb->acb_flags & ACB_F_ABORT) != 0 )){
@@ -2710,7 +2710,7 @@ static void arcmsr_request_hba_device_ma
 	return;
 }
 
-static void arcmsr_request_hbb_device_map(struct AdapterControlBlock *acb)
+static void arcmsr_hbaB_request_device_map(struct AdapterControlBlock *acb)
 {
 	struct MessageUnit_B __iomem *reg = acb->pmuB;
 	if (unlikely(atomic_read(&acb->rq_map_token) == 0) || ((acb->acb_flags & ACB_F_BUS_RESET) != 0 ) || ((acb->acb_flags & ACB_F_ABORT) != 0 )){
@@ -2732,7 +2732,7 @@ static void arcmsr_request_hbb_device_ma
 	return;
 }
 
-static void arcmsr_request_hbc_device_map(struct AdapterControlBlock *acb)
+static void arcmsr_hbaC_request_device_map(struct AdapterControlBlock *acb)
 {
 	struct MessageUnit_C __iomem *reg = acb->pmuC;
 	if (unlikely(atomic_read(&acb->rq_map_token) == 0) || ((acb->acb_flags & ACB_F_BUS_RESET) != 0) || ((acb->acb_flags & ACB_F_ABORT) != 0)) {
@@ -2760,48 +2760,48 @@ static void arcmsr_request_device_map(un
 	struct AdapterControlBlock *acb = (struct AdapterControlBlock *)pacb;
 	switch (acb->adapter_type) {
 		case ACB_ADAPTER_TYPE_A: {
-			arcmsr_request_hba_device_map(acb);
+			arcmsr_hbaA_request_device_map(acb);
 		}
 		break;
 		case ACB_ADAPTER_TYPE_B: {
-			arcmsr_request_hbb_device_map(acb);
+			arcmsr_hbaB_request_device_map(acb);
 		}
 		break;
 		case ACB_ADAPTER_TYPE_C: {
-			arcmsr_request_hbc_device_map(acb);
+			arcmsr_hbaC_request_device_map(acb);
 		}
 	}
 }
 
-static void arcmsr_start_hba_bgrb(struct AdapterControlBlock *acb)
+static void arcmsr_hbaA_start_bgrb(struct AdapterControlBlock *acb)
 {
 	struct MessageUnit_A __iomem *reg = acb->pmuA;
 	acb->acb_flags |= ACB_F_MSG_START_BGRB;
 	writel(ARCMSR_INBOUND_MESG0_START_BGRB, &reg->inbound_msgaddr0);
-	if (!arcmsr_hba_wait_msgint_ready(acb)) {
+	if (!arcmsr_hbaA_wait_msgint_ready(acb)) {
 		printk(KERN_NOTICE "arcmsr%d: wait 'start adapter background \
 				rebulid' timeout \n", acb->host->host_no);
 	}
 }
 
-static void arcmsr_start_hbb_bgrb(struct AdapterControlBlock *acb)
+static void arcmsr_hbaB_start_bgrb(struct AdapterControlBlock *acb)
 {
 	struct MessageUnit_B *reg = acb->pmuB;
 	acb->acb_flags |= ACB_F_MSG_START_BGRB;
 	writel(ARCMSR_MESSAGE_START_BGRB, reg->drv2iop_doorbell);
-	if (!arcmsr_hbb_wait_msgint_ready(acb)) {
+	if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
 		printk(KERN_NOTICE "arcmsr%d: wait 'start adapter background \
 				rebulid' timeout \n",acb->host->host_no);
 	}
 }
 
-static void arcmsr_start_hbc_bgrb(struct AdapterControlBlock *pACB)
+static void arcmsr_hbaC_start_bgrb(struct AdapterControlBlock *pACB)
 {
 	struct MessageUnit_C *phbcmu = (struct MessageUnit_C *)pACB->pmuC;
 	pACB->acb_flags |= ACB_F_MSG_START_BGRB;
 	writel(ARCMSR_INBOUND_MESG0_START_BGRB, &phbcmu->inbound_msgaddr0);
 	writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &phbcmu->inbound_doorbell);
-	if (!arcmsr_hbc_wait_msgint_ready(pACB)) {
+	if (!arcmsr_hbaC_wait_msgint_ready(pACB)) {
 		printk(KERN_NOTICE "arcmsr%d: wait 'start adapter background \
 				rebulid' timeout \n", pACB->host->host_no);
 	}
@@ -2811,13 +2811,13 @@ static void arcmsr_start_adapter_bgrb(st
 {
 	switch (acb->adapter_type) {
 	case ACB_ADAPTER_TYPE_A:
-		arcmsr_start_hba_bgrb(acb);
+		arcmsr_hbaA_start_bgrb(acb);
 		break;
 	case ACB_ADAPTER_TYPE_B:
-		arcmsr_start_hbb_bgrb(acb);
+		arcmsr_hbaB_start_bgrb(acb);
 		break;
 	case ACB_ADAPTER_TYPE_C:
-		arcmsr_start_hbc_bgrb(acb);
+		arcmsr_hbaC_start_bgrb(acb);
 	}
 }
 
@@ -2875,7 +2875,7 @@ static void arcmsr_enable_eoi_mode(struc
 		{
 			struct MessageUnit_B *reg = acb->pmuB;
 			writel(ARCMSR_MESSAGE_ACTIVE_EOI_MODE, reg->drv2iop_doorbell);
-			if (!arcmsr_hbb_wait_msgint_ready(acb)) {
+			if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
 				printk(KERN_NOTICE "ARCMSR IOP enables EOI_MODE TIMEOUT");
 				return;
 			}
