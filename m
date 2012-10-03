From: "NickCheng" <nick.cheng@areca.com.tw>
Subject: [PATCH 3/5]  arcmsr: Support MSI and MSI-X
Date: Wed, 3 Oct 2012 20:40:05 +0800
Message-ID: <352A68B5528342D2BEF944B614D0901D@arecaaebe11fae>
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

Support MSI or MSI-X for whole series of RAID controllers. Meanwhile correct
the register access as iowrite32/ioread32 
Signed-off-by: Nick Cheng <nick.cheng@areca.com.tw>
---
diff -uprN -X linux-vanilla/Documentation/dontdiff
linux-vanilla//drivers/scsi/arcmsr/arcmsr.h
linux-development//drivers/scsi/arcmsr/arcmsr.h
--- linux-vanilla//drivers/scsi/arcmsr/arcmsr.h	2012-10-03
19:16:18.114629695 +0800
+++ linux-development//drivers/scsi/arcmsr/arcmsr.h	2012-10-03
19:17:44.826628853 +0800
@@ -63,7 +63,8 @@ struct device_attribute;
 #define ARCMSR_DEFAULT_SG_ENTRIES
38
 #define ARCMSR_MAX_HBB_POSTQUEUE
264
 #define ARCMSR_MAX_XFER_LEN
0x26000 /* 152K */
-#define ARCMSR_CDB_SG_PAGE_LENGTH
256 
+#define ARCMSR_CDB_SG_PAGE_LENGTH
256
+#define ARCMST_NUM_MSIX_VECTORS		4
 #ifndef PCI_DEVICE_ID_ARECA_1880
 #define PCI_DEVICE_ID_ARECA_1880 0x1880
  #endif
@@ -508,6 +509,7 @@ struct AdapterControlBlock
 	struct pci_dev *		pdev;
 	struct Scsi_Host *		host;
 	unsigned long			vir2phy_offset;
+	struct msix_entry
entries[ARCMST_NUM_MSIX_VECTORS];
 	/* Offset is used in making arc cdb physical to virtual calculations
*/
 	uint32_t			outbound_int_enable;
 	uint32_t			cdb_phyaddr_hi32;
@@ -544,6 +546,8 @@ struct AdapterControlBlock
 	/* iop init */
 	#define ACB_F_ABORT				0x0200
 	#define ACB_F_FIRMWARE_TRAP           		0x0400
+	#define ACB_F_MSI_ENABLED           			0x1000
+	#define ACB_F_MSIX_ENABLED           		0x2000
 	struct CommandControlBlock *
pccb_pool[ARCMSR_MAX_FREECCB_NUM];
 	/* used for memory free */
 	struct list_head		ccb_free_list;
diff -uprN -X linux-vanilla/Documentation/dontdiff
linux-vanilla//drivers/scsi/arcmsr/arcmsr_hba.c
linux-development//drivers/scsi/arcmsr/arcmsr_hba.c
--- linux-vanilla//drivers/scsi/arcmsr/arcmsr_hba.c	2012-10-03
19:16:18.214629692 +0800
+++ linux-development//drivers/scsi/arcmsr/arcmsr_hba.c	2012-10-03
19:17:44.834628853 +0800
@@ -61,7 +61,6 @@
 #include <linux/aer.h>
 #include <asm/dma.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi.h>
@@ -82,7 +81,7 @@ MODULE_VERSION(ARCMSR_DRIVER_VERSION);
 wait_queue_head_t wait_q;
 static int arcmsr_iop_message_xfer(struct AdapterControlBlock *acb,
 					struct scsi_cmnd *cmd);
-static int arcmsr_iop_confirm(struct AdapterControlBlock *acb);
+static void arcmsr_iop_confirm(struct AdapterControlBlock *acb);
 static int arcmsr_abort(struct scsi_cmnd *);
 static int arcmsr_bus_reset(struct scsi_cmnd *);
 static int arcmsr_bios_param(struct scsi_device *sdev,
@@ -97,6 +96,8 @@ static void arcmsr_shutdown(struct pci_d
 static void arcmsr_iop_init(struct AdapterControlBlock *acb);
 static void arcmsr_free_ccb_pool(struct AdapterControlBlock *acb);
 static u32 arcmsr_disable_outbound_ints(struct AdapterControlBlock *acb);
+static void arcmsr_enable_outbound_ints(struct AdapterControlBlock *acb,
+						u32 intmask_org);
 static void arcmsr_stop_adapter_bgrb(struct AdapterControlBlock *acb);
 static void arcmsr_hbaA_flush_cache(struct AdapterControlBlock *acb);
 static void arcmsr_hbaB_flush_cache(struct AdapterControlBlock *acb);
@@ -227,8 +228,8 @@ static bool arcmsr_remap_pciregion(struc
 			printk(KERN_NOTICE "arcmsr%d: memory mapping region
fail \n", acb->host->host_no);
 			return false;
 		}
-		if (readl(&acb->pmuC->outbound_doorbell) &
ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {
-
writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR,
&acb->pmuC->outbound_doorbell_clear);/*clear interrupt*/
+		if (ioread32(&acb->pmuC->outbound_doorbell) &
ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {
+
iowrite32(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR,
&acb->pmuC->outbound_doorbell_clear);/*clear interrupt*/
 			return true;
 		}
 		break;
@@ -357,9 +358,9 @@ static uint8_t arcmsr_hbaC_wait_msgint_r
 	int i;
 
 	for (i = 0; i < 2000; i++) {
-		if (readl(&phbcmu->outbound_doorbell)
+		if (ioread32(&phbcmu->outbound_doorbell)
 				& ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {
-
writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR,
+
iowrite32(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR,
 				&phbcmu->outbound_doorbell_clear); /*clear
interrupt*/
 			return true;
 		}
@@ -404,9 +405,11 @@ static void arcmsr_hbaB_flush_cache(stru
 static void arcmsr_hbaC_flush_cache(struct AdapterControlBlock *pACB)
 {
 	struct MessageUnit_C *reg = (struct MessageUnit_C *)pACB->pmuC;
-	int retry_count = 30;/* enlarge wait flush adapter cache time: 10
minute */
-	writel(ARCMSR_INBOUND_MESG0_FLUSH_CACHE, &reg->inbound_msgaddr0);
-	writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,
&reg->inbound_doorbell);
+	int retry_count = 6;/* enlarge wait flush adapter cache time: 10
minute */
+	iowrite32(ARCMSR_INBOUND_MESG0_FLUSH_CACHE, &reg->inbound_msgaddr0);
+	iowrite32(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,
&reg->inbound_doorbell);
+	ioread32(&reg->inbound_doorbell);/* Dummy ioread32 to force pci
flush */
+	ioread32(&reg->inbound_msgaddr0);/* Dummy ioread32 to force pci
flush */
 	do {
 		if (arcmsr_hbaC_wait_msgint_ready(pACB)) {
 			break;
@@ -578,12 +581,12 @@ static void arcmsr_message_isr_bh_fn(str
 			char diff;
 
 			atomic_inc(&acb->rq_map_token);
-			if (readl(signature) == ARCMSR_SIGNATURE_GET_CONFIG)
{
+			if (ioread32(signature) ==
ARCMSR_SIGNATURE_GET_CONFIG) {
 				for (target = 0; target <
ARCMSR_MAX_TARGETID - 1; target++) {
-					diff =
(*acb_dev_map)^readb(devicemap);
+					diff =
(*acb_dev_map)^ioread8(devicemap);
 					if (diff != 0) {
 						char temp;
-						*acb_dev_map =
readb(devicemap);
+						*acb_dev_map =
ioread8(devicemap);
 						temp = *acb_dev_map;
 						for (lun = 0; lun <
ARCMSR_MAX_TARGETLUN; lun++) {
 							if ((temp & 0x01) ==
1 && (diff & 0x01) == 1) {
@@ -615,6 +618,17 @@ static int arcmsr_suspend(struct pci_dev
 	struct AdapterControlBlock *acb = (struct AdapterControlBlock
*)host->hostdata;
 
 	intmask_org = arcmsr_disable_outbound_ints(acb);
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
 	del_timer_sync(&acb->eternal_timer);
 	flush_scheduled_work();
 	arcmsr_stop_adapter_bgrb(acb);
@@ -632,6 +646,7 @@ static int arcmsr_resume(struct pci_dev
 	int error, i, j;
 	struct Scsi_Host *host = pci_get_drvdata(pdev);
 	struct AdapterControlBlock *acb = (struct AdapterControlBlock
*)host->hostdata;
+	struct msix_entry entries[ARCMST_NUM_MSIX_VECTORS];
 
 	pci_set_power_state(pdev, PCI_D0);
 	pci_enable_wake(pdev, PCI_D0, 0);
@@ -652,21 +667,50 @@ static int arcmsr_resume(struct pci_dev
 	}
 	pci_set_master(pdev);
 	arcmsr_iop_init(acb);
-	if (request_irq(pdev->irq, arcmsr_do_interrupt, IRQF_SHARED,
"arcmsr", acb)) {
-		printk("arcmsr%d: request_irq =%d failed!\n",
acb->host->host_no, pdev->irq);
-		goto controller_stop;
-	}
-	timer_init:
-		INIT_WORK(&acb->arcmsr_do_message_isr_bh,
-			arcmsr_message_isr_bh_fn);
-		atomic_set(&acb->rq_map_token, 16);
-		atomic_set(&acb->ante_token_value, 16);
-		acb->fw_flag = FW_NORMAL;
-		init_timer(&acb->eternal_timer);
-		acb->eternal_timer.expires = jiffies + msecs_to_jiffies(6 *
HZ);
-		acb->eternal_timer.data = (unsigned long) acb;
-		acb->eternal_timer.function = &arcmsr_request_device_map;
-		add_timer(&acb->eternal_timer);
+	if (pci_find_capability(pdev, PCI_CAP_ID_MSIX)) {
+		if (!pci_enable_msix(pdev, entries,
ARCMST_NUM_MSIX_VECTORS)) {
+			for (i = 0; i < ARCMST_NUM_MSIX_VECTORS; i++) {
+				entries[i].entry = i;
+				if (request_irq(entries[i].vector,
+					arcmsr_do_interrupt, 0, "arcmsr",
acb)) {
+					for (j = 0 ; j < i ; j++)
+						free_irq(entries[i].vector,
acb);
+					goto controller_stop;
+				}
+				acb->entries[i] = entries[i];
+			}
+			acb->acb_flags |= ACB_F_MSIX_ENABLED;
+		} else {
+			printk("arcmsr%d: MSI-X failed to enable\n",
acb->host->host_no);
+			if (request_irq(pdev->irq, arcmsr_do_interrupt,
+				IRQF_SHARED, "arcmsr", acb)) {
+				goto controller_stop;
+			}
+		}
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
+	}
+	INIT_WORK(&acb->arcmsr_do_message_isr_bh,
+		arcmsr_message_isr_bh_fn);
+	atomic_set(&acb->rq_map_token, 16);
+	atomic_set(&acb->ante_token_value, 16);
+	acb->fw_flag = FW_NORMAL;
+	init_timer(&acb->eternal_timer);
+	acb->eternal_timer.expires = jiffies + msecs_to_jiffies(6 * HZ);
+	acb->eternal_timer.data = (unsigned long) acb;
+	acb->eternal_timer.function = &arcmsr_request_device_map;
+	add_timer(&acb->eternal_timer);
 	return 0;
 	controller_stop:
 		arcmsr_stop_adapter_bgrb(acb);
@@ -686,7 +730,9 @@ static int arcmsr_probe(struct pci_dev *
 	struct Scsi_Host *host;
 	struct AdapterControlBlock *acb;
 	uint8_t bus,dev_fun;
-	int error;
+	int error, i, j;
+	struct msix_entry entries[ARCMST_NUM_MSIX_VECTORS];
+
 	error = pci_enable_device(pdev);
 	if(error){
 		return -ENODEV;
@@ -745,17 +791,45 @@ static int arcmsr_probe(struct pci_dev *
 	if(error){
 		goto free_hbb_mu;
 	}
-	arcmsr_iop_init(acb);
 	error = scsi_add_host(host, &pdev->dev);
 	if(error){
 		goto RAID_controller_stop;
 	}
-	error = request_irq(pdev->irq, arcmsr_do_interrupt, IRQF_SHARED,
"arcmsr", acb);
-	if(error){
-		goto scsi_host_remove;
+	if (pci_find_capability(pdev, PCI_CAP_ID_MSIX)) {
+		if (!pci_enable_msix(pdev, entries,
ARCMST_NUM_MSIX_VECTORS)) {
+			for (i = 0; i < ARCMST_NUM_MSIX_VECTORS; i++) {
+				entries[i].entry = i;
+				if (request_irq(entries[i].vector,
+					arcmsr_do_interrupt, 0, "arcmsr",
acb)) {
+					for (j = 0 ; j < i ; j++)
+						free_irq(entries[i].vector,
acb);
+					goto scsi_host_remove;
+				}
+				acb->entries[i] = entries[i];
+			}
+			acb->acb_flags |= ACB_F_MSIX_ENABLED;
+		} else {
+			if (request_irq(pdev->irq, arcmsr_do_interrupt,
+				IRQF_SHARED, "arcmsr", acb)) {
+				goto scsi_host_remove;
+			}
+		}
+	} else if (pci_find_capability(pdev, PCI_CAP_ID_MSI)) {
+		if (!pci_enable_msi(pdev)) {
+			acb->acb_flags |= ACB_F_MSI_ENABLED;
+		}
+		if (request_irq(pdev->irq, arcmsr_do_interrupt,
+			IRQF_SHARED, "arcmsr", acb)) {
+			goto scsi_host_remove;
+		}
+	} else {
+		if (request_irq(pdev->irq, arcmsr_do_interrupt,
+			IRQF_SHARED, "arcmsr", acb)) {
+			goto scsi_host_remove;
+		}
 	}
-	host->irq = pdev->irq;
-    	scsi_scan_host(host);
+	arcmsr_iop_init(acb);
+	scsi_scan_host(host);
 	INIT_WORK(&acb->arcmsr_do_message_isr_bh, arcmsr_message_isr_bh_fn);
 	atomic_set(&acb->rq_map_token, 16);
 	atomic_set(&acb->ante_token_value, 16);
@@ -770,6 +844,11 @@ static int arcmsr_probe(struct pci_dev *
 	return 0;
 out_free_sysfs:
 scsi_host_remove:
+	if (acb->acb_flags & ACB_F_MSI_ENABLED) {
+		pci_disable_msi(pdev);
+	} else if (acb->acb_flags & ACB_F_MSIX_ENABLED) {
+		pci_disable_msix(pdev);
+	}
 	scsi_remove_host(host);
 RAID_controller_stop:
 	arcmsr_stop_adapter_bgrb(acb);
@@ -817,8 +896,8 @@ static uint8_t arcmsr_hbaB_abort_allcmd(
 static uint8_t arcmsr_hbaC_abort_allcmd(struct AdapterControlBlock *pACB)
 {
 	struct MessageUnit_C *reg = (struct MessageUnit_C *)pACB->pmuC;
-	writel(ARCMSR_INBOUND_MESG0_ABORT_CMD, &reg->inbound_msgaddr0);
-	writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,
&reg->inbound_doorbell);
+	iowrite32(ARCMSR_INBOUND_MESG0_ABORT_CMD, &reg->inbound_msgaddr0);
+	iowrite32(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,
&reg->inbound_doorbell);
 	if (!arcmsr_hbaC_wait_msgint_ready(pACB)) {
 		printk(KERN_NOTICE
 			"arcmsr%d: wait 'abort all outstanding command'
timeout \n"
@@ -917,8 +996,9 @@ static u32 arcmsr_disable_outbound_ints(
 	case ACB_ADAPTER_TYPE_C:{
 		struct MessageUnit_C *reg = (struct MessageUnit_C
*)acb->pmuC;
 		/* disable all outbound interrupt */
-		orig_mask = readl(&reg->host_int_mask); /* disable outbound
message0 int */
-		writel(orig_mask|ARCMSR_HBCMU_ALL_INTMASKENABLE,
&reg->host_int_mask);
+		orig_mask = ioread32(&reg->host_int_mask); /* disable
outbound message0 int */
+		iowrite32(orig_mask|ARCMSR_HBCMU_ALL_INTMASKENABLE,
&reg->host_int_mask);
+		ioread32(&reg->host_int_mask);/* Dummy ioread32 to force pci
flush */
 		}
 		break;
 	}
@@ -1058,9 +1138,9 @@ static void arcmsr_done4abort_postqueue(
 		uint32_t flag_ccb, ccb_cdb_phy;
 		bool error;
 		struct CommandControlBlock *pCCB;
-		while ((readl(&reg->host_int_status) &
ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR) && (i++ < ARCMSR_MAX_OUTSTANDING_CMD))
{
+		while ((ioread32(&reg->host_int_status) &
ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR) && (i++ < ARCMSR_MAX_OUTSTANDING_CMD))
{
 			/*need to do*/
-			flag_ccb = readl(&reg->outbound_queueport_low);
+			flag_ccb = ioread32(&reg->outbound_queueport_low);
 			ccb_cdb_phy = (flag_ccb & 0xFFFFFFF0);
 			pARCMSR_CDB = (struct  ARCMSR_CDB
*)(acb->vir2phy_offset+ccb_cdb_phy);/*frame must be 32 bytes aligned*/
 			pCCB = container_of(pARCMSR_CDB, struct
CommandControlBlock, arcmsr_cdb);
@@ -1075,7 +1155,7 @@ static void arcmsr_remove(struct pci_dev
 	struct Scsi_Host *host = pci_get_drvdata(pdev);
 	struct AdapterControlBlock *acb =
 		(struct AdapterControlBlock *) host->hostdata;
-	int poll_count = 0;
+	int poll_count = 0, i;
 	arcmsr_free_sysfs_attr(acb);
 	scsi_remove_host(host);
 	flush_work_sync(&acb->arcmsr_do_message_isr_bh);
@@ -1085,17 +1165,13 @@ static void arcmsr_remove(struct pci_dev
 	arcmsr_flush_adapter_cache(acb);	
 	acb->acb_flags |= ACB_F_SCSISTOPADAPTER;
 	acb->acb_flags &= ~ACB_F_IOP_INITED;
-
 	for (poll_count = 0; poll_count < ARCMSR_MAX_OUTSTANDING_CMD;
poll_count++){
 		if (!atomic_read(&acb->ccboutstandingcount))
 			break;
 		arcmsr_interrupt(acb);/* FIXME: need spinlock */
 		msleep(25);
 	}
-
 	if (atomic_read(&acb->ccboutstandingcount)) {
-		int i;
-
 		arcmsr_abort_allcmd(acb);
 		arcmsr_done4abort_postqueue(acb);
 		for (i = 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {
@@ -1107,9 +1183,19 @@ static void arcmsr_remove(struct pci_dev
 			}
 		}
 	}
-	free_irq(pdev->irq, acb);
 	arcmsr_free_ccb_pool(acb);
 	arcmsr_free_hbb_mu(acb);
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
@@ -1119,11 +1205,20 @@ static void arcmsr_remove(struct pci_dev
 
 static void arcmsr_shutdown(struct pci_dev *pdev)
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
@@ -1172,7 +1267,8 @@ static void arcmsr_enable_outbound_ints(
 	case ACB_ADAPTER_TYPE_C: {
 		struct MessageUnit_C *reg = acb->pmuC;
 		mask = ~(ARCMSR_HBCMU_UTILITY_A_ISR_MASK |
ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR_MASK|ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR_
MASK);
-		writel(intmask_org & mask, &reg->host_int_mask);
+		iowrite32(intmask_org & mask, &reg->host_int_mask);
+		ioread32(&reg->host_int_mask);
 		acb->outbound_int_enable = ~(intmask_org & mask) &
0x0000000f;
 		}
 	}
@@ -1277,10 +1373,10 @@ static void arcmsr_post_ccb(struct Adapt
 		arc_cdb_size = (ccb->arc_cdb_size > 0x300) ? 0x300 :
ccb->arc_cdb_size;
 		ccb_post_stamp = (cdb_phyaddr_pattern | ((arc_cdb_size - 1)
>> 6) | 1);
 		if (acb->cdb_phyaddr_hi32) {
-			writel(acb->cdb_phyaddr_hi32,
&phbcmu->inbound_queueport_high);
-			writel(ccb_post_stamp,
&phbcmu->inbound_queueport_low);
+			iowrite32(acb->cdb_phyaddr_hi32,
&phbcmu->inbound_queueport_high);
+			iowrite32(ccb_post_stamp,
&phbcmu->inbound_queueport_low);
 		} else {
-			writel(ccb_post_stamp,
&phbcmu->inbound_queueport_low);
+			iowrite32(ccb_post_stamp,
&phbcmu->inbound_queueport_low);
 		}
 		}
 	}
@@ -1315,8 +1411,10 @@ static void arcmsr_stop_hbc_bgrb(struct
 {
 	struct MessageUnit_C *reg = (struct MessageUnit_C *)pACB->pmuC;
 	pACB->acb_flags &= ~ACB_F_MSG_START_BGRB;
-	writel(ARCMSR_INBOUND_MESG0_STOP_BGRB, &reg->inbound_msgaddr0);
-	writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,
&reg->inbound_doorbell);
+	iowrite32(ARCMSR_INBOUND_MESG0_STOP_BGRB, &reg->inbound_msgaddr0);
+	iowrite32(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,
&reg->inbound_doorbell);
+	ioread32(&reg->inbound_doorbell);/* Dummy ioread32 to force pci
flush */
+	ioread32(&reg->inbound_msgaddr0);/* Dummy ioread32 to force pci
flush */
 	if (!arcmsr_hbaC_wait_msgint_ready(pACB)) {
 		printk(KERN_NOTICE
 			"arcmsr%d: wait 'stop adapter background rebulid'
timeout \n"
@@ -1363,7 +1461,8 @@ void arcmsr_iop_message_read(struct Adap
 		break;
 	case ACB_ADAPTER_TYPE_C: {
 		struct MessageUnit_C __iomem *reg = acb->pmuC;
-		writel(ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK,
&reg->inbound_doorbell);
+		iowrite32(ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK,
&reg->inbound_doorbell);
+		ioread32(&reg->inbound_doorbell);
 		}
 	}
 }
@@ -1396,7 +1495,8 @@ static void arcmsr_iop_message_wrote(str
 		** push inbound doorbell tell iop, driver data write ok
 		** and wait reply on next hwinterrupt for next Qbuffer post
 		*/
-		writel(ARCMSR_HBCMU_DRV2IOP_DATA_WRITE_OK,
&reg->inbound_doorbell);
+		iowrite32(ARCMSR_HBCMU_DRV2IOP_DATA_WRITE_OK,
&reg->inbound_doorbell);
+		ioread32(&reg->inbound_doorbell);
 		}
 		break;
 	}
@@ -1464,8 +1564,7 @@ static void arcmsr_iop2drv_data_wrote_ha
 	iop_len = prbuffer->data_len;
 	my_empty_len = (rqbuf_firstindex - rqbuf_lastindex - 1) &
(ARCMSR_MAX_QBUFFER - 1);
 
-	if (my_empty_len >= iop_len)
-	{
+	if (my_empty_len >= iop_len) {
 		while (iop_len > 0) {
 			pQbuffer = (struct QBUFFER
*)&acb->rqbuffer[rqbuf_lastindex];
 			memcpy(pQbuffer, iop_data, 1);
@@ -1476,9 +1575,7 @@ static void arcmsr_iop2drv_data_wrote_ha
 		}
 		acb->rqbuf_lastindex = rqbuf_lastindex;
 		arcmsr_iop_message_read(acb);
-	}
-
-	else {
+	} else {
 		acb->acb_flags |= ACB_F_IOPDATA_OVERFLOW;
 	}
 }
@@ -1517,42 +1614,53 @@ static void arcmsr_iop2drv_data_read_han
 
 static void arcmsr_hbaA_doorbell_isr(struct AdapterControlBlock *acb)
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
ARCMSR_OUTBOUND_IOP331_DATA_WRITE_OK) {
+			arcmsr_iop2drv_data_wrote_handle(acb);
+		}
+		if (outbound_doorbell & ARCMSR_OUTBOUND_IOP331_DATA_READ_OK)
{
+			arcmsr_iop2drv_data_read_handle(acb);
+		}
+		outbound_doorbell = ioread32(&reg->outbound_doorbell);
+	} while (outbound_doorbell & (ARCMSR_OUTBOUND_IOP331_DATA_WRITE_OK
+				| ARCMSR_OUTBOUND_IOP331_DATA_READ_OK));
 }
+
 static void arcmsr_hbaC_doorbell_isr(struct AdapterControlBlock *pACB)
 {
 	uint32_t outbound_doorbell;
-	struct MessageUnit_C *reg = (struct MessageUnit_C *)pACB->pmuC;
-	/*
-	*******************************************************************
-	**  Maybe here we need to check wrqbuffer_lock is lock or not
-	**  DOORBELL: din! don!
-	**  check if there are any mail need to pack from firmware
-	*******************************************************************
-	*/
-	outbound_doorbell = readl(&reg->outbound_doorbell);
-	writel(outbound_doorbell, &reg->outbound_doorbell_clear);/*clear
interrupt*/
-	if (outbound_doorbell & ARCMSR_HBCMU_IOP2DRV_DATA_WRITE_OK) {
+	struct MessageUnit_C __iomem *reg = (struct MessageUnit_C
*)pACB->pmuC;
+
+	outbound_doorbell = ioread32(&reg->outbound_doorbell);
+	if (unlikely(!outbound_doorbell)) {
+		WARN(1, "%s: outbound_doorbell null\n", __func__);
 		arcmsr_iop2drv_data_wrote_handle(pACB);
-	}
-	if (outbound_doorbell & ARCMSR_HBCMU_IOP2DRV_DATA_READ_OK) {
 		arcmsr_iop2drv_data_read_handle(pACB);
 	}
-	if (outbound_doorbell & ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {
-		arcmsr_hbaC_message_isr(pACB);    /* messenger of "driver to
iop commands" */
-	}
+	do {
+		if (outbound_doorbell &
ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {
+			arcmsr_hbaC_message_isr(pACB);
+		}
+		iowrite32(outbound_doorbell, &reg->outbound_doorbell_clear);
+		ioread32(&reg->outbound_doorbell_clear);
+		if (outbound_doorbell & ARCMSR_HBCMU_IOP2DRV_DATA_WRITE_OK)
{
+			arcmsr_iop2drv_data_wrote_handle(pACB);
+		}
+		if (outbound_doorbell & ARCMSR_HBCMU_IOP2DRV_DATA_READ_OK) {
+			arcmsr_iop2drv_data_read_handle(pACB);
+		}
+		outbound_doorbell = ioread32(&reg->outbound_doorbell);
+	} while (outbound_doorbell & (ARCMSR_HBCMU_IOP2DRV_DATA_WRITE_OK
+				| ARCMSR_HBCMU_IOP2DRV_DATA_READ_OK
+				| ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE));
 	return;
 }
+
 static void arcmsr_hbaA_postqueue_isr(struct AdapterControlBlock *acb)
 {
 	uint32_t flag_ccb;
@@ -1590,32 +1698,30 @@ static void arcmsr_hbaB_postqueue_isr(st
 
 static void arcmsr_hbaC_postqueue_isr(struct AdapterControlBlock *acb)
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
-
-	while (readl(&phbcmu->host_int_status) &
-	ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR){
-	/* check if command done with no error*/
-	flag_ccb = readl(&phbcmu->outbound_queueport_low);
-	ccb_cdb_phy = (flag_ccb & 0xFFFFFFF0);/*frame must be 32 bytes
aligned*/
-	arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset +
ccb_cdb_phy);
-	ccb = container_of(arcmsr_cdb, struct CommandControlBlock,
arcmsr_cdb);
-	error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1) ? true :
false;
-	/* check if command done with no error */
-	arcmsr_drain_donequeue(acb, ccb, error);
-	if (throttling == ARCMSR_HBC_ISR_THROTTLING_LEVEL) {
-		writel(ARCMSR_HBCMU_DRV2IOP_POSTQUEUE_THROTTLING,
&phbcmu->inbound_doorbell);
-		break;
-	}
-	throttling++;
-	}
+	do {
+		flag_ccb = ioread32(&phbcmu->outbound_queueport_low);
+		ccb_cdb_phy = (flag_ccb & 0xFFFFFFF0);
+		arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset +
ccb_cdb_phy);
+		ccb = container_of(arcmsr_cdb, struct CommandControlBlock,
arcmsr_cdb);
+		error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1) ? true
: false;
+		arcmsr_drain_donequeue(acb, ccb, error);
+		if (throttling == ARCMSR_HBC_ISR_THROTTLING_LEVEL) {
+			iowrite32(ARCMSR_HBCMU_DRV2IOP_POSTQUEUE_THROTTLING,
+				&phbcmu->inbound_doorbell);
+			continue;
+		}
+		throttling++;
+	} while (ioread32(&phbcmu->host_int_status) &
+	ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR);
 }
 
 static void arcmsr_hbaA_message_isr(struct AdapterControlBlock *acb)
@@ -1642,60 +1748,68 @@ static void arcmsr_hbaC_message_isr(stru
 	schedule_work(&acb->arcmsr_do_message_isr_bh);
 }
 
-static int arcmsr_hbaA_handle_isr(struct AdapterControlBlock *acb)
+static irqreturn_t arcmsr_hbaA_handle_isr(struct AdapterControlBlock *acb)
 {
 	uint32_t outbound_intstatus;
 	struct MessageUnit_A __iomem *reg = acb->pmuA;
-	outbound_intstatus = readl(&reg->outbound_intstatus) &
-		acb->outbound_int_enable;
-	if (!(outbound_intstatus & ARCMSR_MU_OUTBOUND_HANDLE_INT))	{
-		return 1;
-	}
-	writel(outbound_intstatus, &reg->outbound_intstatus);
-	if (outbound_intstatus & ARCMSR_MU_OUTBOUND_DOORBELL_INT)	{
-		arcmsr_hbaA_doorbell_isr(acb);
-	}
-	if (outbound_intstatus & ARCMSR_MU_OUTBOUND_POSTQUEUE_INT) {
-		arcmsr_hbaA_postqueue_isr(acb);
-	}
-	if(outbound_intstatus & ARCMSR_MU_OUTBOUND_MESSAGE0_INT) 	{
-		/* messenger of "driver to iop commands" */
-		arcmsr_hbaA_message_isr(acb);
+
+	outbound_intstatus = ioread32(&reg->outbound_intstatus) &
acb->outbound_int_enable;
+	if (!(outbound_intstatus & ARCMSR_MU_OUTBOUND_HANDLE_INT)) {
+        		return IRQ_NONE;
 	}
-	return 0;
+	do {
+		iowrite32(outbound_intstatus, &reg->outbound_intstatus);
+		ioread32(&reg->outbound_intstatus);/* Dummy ioread32 */
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
acb->outbound_int_enable;
+	} while (outbound_intstatus & (ARCMSR_MU_OUTBOUND_DOORBELL_INT
+				| ARCMSR_MU_OUTBOUND_POSTQUEUE_INT
+				| ARCMSR_MU_OUTBOUND_MESSAGE0_INT));
+	return IRQ_HANDLED;	
 }
 
-static int arcmsr_hbaB_handle_isr(struct AdapterControlBlock *acb)
+static irqreturn_t arcmsr_hbaB_handle_isr(struct AdapterControlBlock *acb)
 {
 	uint32_t outbound_doorbell;
 	struct MessageUnit_B *reg = acb->pmuB;
-	outbound_doorbell = readl(reg->iop2drv_doorbell) &
-				acb->outbound_int_enable;
-	if (!outbound_doorbell)
-		return 1;
 
-	writel(~outbound_doorbell, reg->iop2drv_doorbell);
-	/*in case the last action of doorbell interrupt clearance is cached,
-	this action can push HW to write down the clear bit*/
-	readl(reg->iop2drv_doorbell);
-	writel(ARCMSR_DRV2IOP_END_OF_INTERRUPT, reg->drv2iop_doorbell);
-	if (outbound_doorbell & ARCMSR_IOP2DRV_DATA_WRITE_OK) {
-		arcmsr_iop2drv_data_wrote_handle(acb);
-	}
-	if (outbound_doorbell & ARCMSR_IOP2DRV_DATA_READ_OK) {
-		arcmsr_iop2drv_data_read_handle(acb);
-	}
-	if (outbound_doorbell & ARCMSR_IOP2DRV_CDB_DONE) {
-		arcmsr_hbaB_postqueue_isr(acb);
-	}
-	if(outbound_doorbell & ARCMSR_IOP2DRV_MESSAGE_CMD_DONE) {
-		/* messenger of "driver to iop commands" */
-		arcmsr_hbaB_message_isr(acb);
-	}
-	return 0;
+	outbound_doorbell = ioread32(reg->iop2drv_doorbell) &
acb->outbound_int_enable;
+	if (!outbound_doorbell)
+		return IRQ_NONE;
+	do {
+		iowrite32(~outbound_doorbell, reg->iop2drv_doorbell);
+		ioread32(reg->iop2drv_doorbell);/* Dummy ioread32 */
+		iowrite32(ARCMSR_DRV2IOP_END_OF_INTERRUPT,
reg->drv2iop_doorbell);
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
acb->outbound_int_enable;
+	} while (outbound_doorbell & (ARCMSR_IOP2DRV_DATA_WRITE_OK
+				| ARCMSR_IOP2DRV_DATA_READ_OK
+				| ARCMSR_IOP2DRV_CDB_DONE
+				| ARCMSR_IOP2DRV_MESSAGE_CMD_DONE));
+	return IRQ_HANDLED;
 }
 
-static int arcmsr_hbaC_handle_isr(struct AdapterControlBlock *pACB)
+static irqreturn_t arcmsr_hbaC_handle_isr(struct AdapterControlBlock *pACB)
 {
 	uint32_t host_interrupt_status;
 	struct MessageUnit_C *phbcmu = (struct MessageUnit_C *)pACB->pmuC;
@@ -1704,44 +1818,40 @@ static int arcmsr_hbaC_handle_isr(struct
 	**   check outbound intstatus
 	*********************************************
 	*/
-	host_interrupt_status = readl(&phbcmu->host_int_status);
-	if (!host_interrupt_status) {
-		/*it must be share irq*/
-		return 1;
-	}
-	/* MU ioctl transfer doorbell interrupts*/
-	if (host_interrupt_status & ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR) {
-		arcmsr_hbaC_doorbell_isr(pACB);   /* messenger of "ioctl
message read write" */
-	}
-	/* MU post queue interrupts*/
-	if (host_interrupt_status & ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR) {
-		arcmsr_hbaC_postqueue_isr(pACB);  /* messenger of "scsi
commands" */
-	}
-	return 0;
+	host_interrupt_status = ioread32(&phbcmu->host_int_status);
+	do {
+		/* MU ioctl transfer doorbell interrupts*/
+		if (host_interrupt_status &
ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR) {
+			arcmsr_hbaC_doorbell_isr(pACB);
+		}
+		/* MU post queue interrupts*/
+		if (host_interrupt_status &
ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR) {
+			arcmsr_hbaC_postqueue_isr(pACB);
+		}
+		host_interrupt_status = ioread32(&phbcmu->host_int_status);
+	} while (host_interrupt_status &
(ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR
+				| ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR));
+	return IRQ_HANDLED;
 }
+
 static irqreturn_t arcmsr_interrupt(struct AdapterControlBlock *acb)
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
-		}
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
 
 static void arcmsr_iop_parking(struct AdapterControlBlock *acb)
@@ -1761,27 +1871,29 @@ static void arcmsr_iop_parking(struct Ad
 
 void arcmsr_post_ioctldata2iop(struct AdapterControlBlock *acb)
 {
-	int32_t wqbuf_firstindex, wqbuf_lastindex;
-	uint8_t *pQbuffer;
-	struct QBUFFER __iomem *pwbuffer;
 	uint8_t __iomem *iop_data;
+	uint8_t *pQbuffer;
+	int32_t wqbuf_firstindex, wqbuf_lastindex;
 	int32_t allxfer_len = 0;
+	struct QBUFFER __iomem *pwbuffer;
+
 	pwbuffer = arcmsr_get_iop_wqbuffer(acb);
 	iop_data = (uint8_t __iomem *)pwbuffer->data;
-	if (acb->acb_flags & ACB_F_MESSAGE_WQBUFFER_READED) {
+    	if (acb->acb_flags & ACB_F_MESSAGE_WQBUFFER_READED) {
 		acb->acb_flags &= (~ACB_F_MESSAGE_WQBUFFER_READED);
 		wqbuf_firstindex = acb->wqbuf_firstindex;
 		wqbuf_lastindex = acb->wqbuf_lastindex;
-		while ((wqbuf_firstindex != wqbuf_lastindex) && (allxfer_len
< 124)) {
+		while ((wqbuf_firstindex != wqbuf_lastindex)
+			&& (allxfer_len < 124)) {
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
@@ -1843,9 +1955,9 @@ static int arcmsr_iop_message_xfer(struc
 			acb->acb_flags &= ~ACB_F_IOPDATA_OVERFLOW;
 			prbuffer = arcmsr_get_iop_rqbuffer(acb);
 			iop_data = prbuffer->data;
-			iop_len = readl(&prbuffer->data_len);
+			iop_len = ioread32(&prbuffer->data_len);
 			while (iop_len > 0) {
-				acb->rqbuffer[acb->rqbuf_lastindex] =
readb(iop_data);
+				acb->rqbuffer[acb->rqbuf_lastindex] =
ioread8(iop_data);
 				acb->rqbuf_lastindex++;
 				acb->rqbuf_lastindex %= ARCMSR_MAX_QBUFFER;
 				iop_data++;
@@ -2305,19 +2417,19 @@ static bool arcmsr_hbaC_get_config(struc
 	char *iop_firm_version = (char *)(&reg->msgcode_rwbuffer[17]);
/*firm_version,17,68-83*/
 	int count;
 	/* disable all outbound interrupt */
-	intmask_org = readl(&reg->host_int_mask); /* disable outbound
message0 int */
-	writel(intmask_org|ARCMSR_HBCMU_ALL_INTMASKENABLE,
&reg->host_int_mask);
+	intmask_org = ioread32(&reg->host_int_mask); /* disable outbound
message0 int */
+	iowrite32(intmask_org|ARCMSR_HBCMU_ALL_INTMASKENABLE,
&reg->host_int_mask);
 	/* wait firmware ready */
 	do {
-		firmware_state = readl(&reg->outbound_msgaddr1);
+		firmware_state = ioread32(&reg->outbound_msgaddr1);
 	} while ((firmware_state & ARCMSR_HBCMU_MESSAGE_FIRMWARE_OK) == 0);
 	/* post "get config" instruction */
-	writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);
-	writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,
&reg->inbound_doorbell);
+	iowrite32(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);
+	iowrite32(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,
&reg->inbound_doorbell);
 	/* wait message ready */
 	for (Index = 0; Index < 2000; Index++) {
-		if (readl(&reg->outbound_doorbell) &
ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {
-
writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR,
&reg->outbound_doorbell_clear);/*clear interrupt*/
+		if (ioread32(&reg->outbound_doorbell) &
ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {
+
iowrite32(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR,
&reg->outbound_doorbell_clear);/*clear interrupt*/
 			break;
 		}
 		udelay(10);
@@ -2329,14 +2441,14 @@ static bool arcmsr_hbaC_get_config(struc
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
@@ -2345,11 +2457,11 @@ static bool arcmsr_hbaC_get_config(struc
 		pACB->host->host_no,
 		pACB->firm_version,
 		pACB->firm_model);
-	pACB->firm_request_len = readl(&reg->msgcode_rwbuffer[1]);
/*firm_request_len,1,04-07*/
-	pACB->firm_numbers_queue = readl(&reg->msgcode_rwbuffer[2]);
/*firm_numbers_queue,2,08-11*/
-	pACB->firm_sdram_size = readl(&reg->msgcode_rwbuffer[3]);
/*firm_sdram_size,3,12-15*/
-	pACB->firm_hd_channels = readl(&reg->msgcode_rwbuffer[4]);
/*firm_ide_channels,4,16-19*/
-	pACB->firm_cfg_version = readl(&reg->msgcode_rwbuffer[25]);
/*firm_cfg_version,25,100-103*/
+	pACB->firm_request_len = ioread32(&reg->msgcode_rwbuffer[1]);
/*firm_request_len,1,04-07*/
+	pACB->firm_numbers_queue = ioread32(&reg->msgcode_rwbuffer[2]);
/*firm_numbers_queue,2,08-11*/
+	pACB->firm_sdram_size = ioread32(&reg->msgcode_rwbuffer[3]);
/*firm_sdram_size,3,12-15*/
+	pACB->firm_hd_channels = ioread32(&reg->msgcode_rwbuffer[4]);
/*firm_ide_channels,4,16-19*/
+	pACB->firm_cfg_version = ioread32(&reg->msgcode_rwbuffer[25]);
/*firm_cfg_version,25,100-103*/
 	/*all interrupt service will be enable at arcmsr_iop_init*/
 	return true;
 }
@@ -2495,7 +2607,7 @@ static int arcmsr_hbaC_polling_ccbdone(s
 polling_hbc_ccb_retry:
 	poll_count++;
 	while (1) {
-		if ((readl(&reg->host_int_status) &
ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR) == 0) {
+		if ((ioread32(&reg->host_int_status) &
ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR) == 0) {
 			if (poll_ccb_done) {
 				rtn = SUCCESS;
 				break;
@@ -2508,7 +2620,7 @@ polling_hbc_ccb_retry:
 				goto polling_hbc_ccb_retry;
 			}
 		}
-		flag_ccb = readl(&reg->outbound_queueport_low);
+		flag_ccb = ioread32(&reg->outbound_queueport_low);
 		ccb_cdb_phy = (flag_ccb & 0xFFFFFFF0);
 		arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset +
ccb_cdb_phy);/*frame must be 32 bytes aligned*/
 		pCCB = container_of(arcmsr_cdb, struct CommandControlBlock,
arcmsr_cdb);
@@ -2561,7 +2673,7 @@ static int arcmsr_polling_ccbdone(struct
 	return rtn;
 }
 
-static int arcmsr_iop_confirm(struct AdapterControlBlock *acb)
+static void arcmsr_iop_confirm(struct AdapterControlBlock *acb)
 {
 	uint32_t cdb_phyaddr, cdb_phyaddr_hi32;
 	dma_addr_t dma_coherent_handle;
@@ -2596,7 +2708,6 @@ static int arcmsr_iop_confirm(struct Ada
 				printk(KERN_NOTICE "arcmsr%d: ""set ccb high
\
 				part physical address timeout\n",
 				acb->host->host_no);
-				return 1;
 			}
 			arcmsr_enable_outbound_ints(acb, intmask_org);
 		}
@@ -2616,7 +2727,6 @@ static int arcmsr_iop_confirm(struct Ada
 		if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
 			printk(KERN_NOTICE "arcmsr%d:can not set diver
mode\n", \
 				acb->host->host_no);
-			return 1;
 		}
 		post_queue_phyaddr = acb->dma_coherent_handle_hbb_mu;
 		rwbuffer = reg->message_rwbuffer;
@@ -2635,7 +2745,6 @@ static int arcmsr_iop_confirm(struct Ada
 		if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
 			printk(KERN_NOTICE "arcmsr%d: 'set command Q window'
\
 			timeout \n",acb->host->host_no);
-			return 1;
 		}
 		arcmsr_hbb_enable_driver_mode(acb);
 		arcmsr_enable_outbound_ints(acb, intmask_org);
@@ -2647,19 +2756,17 @@ static int arcmsr_iop_confirm(struct Ada
 
 			printk(KERN_NOTICE "arcmsr%d:
cdb_phyaddr_hi32=0x%x\n",
 					acb->adapter_index,
cdb_phyaddr_hi32);
-			writel(ARCMSR_SIGNATURE_SET_CONFIG,
&reg->msgcode_rwbuffer[0]);
-			writel(cdb_phyaddr_hi32, &reg->msgcode_rwbuffer[1]);
-			writel(ARCMSR_INBOUND_MESG0_SET_CONFIG,
&reg->inbound_msgaddr0);
-			writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,
&reg->inbound_doorbell);
+			iowrite32(ARCMSR_SIGNATURE_SET_CONFIG,
&reg->msgcode_rwbuffer[0]);
+			iowrite32(cdb_phyaddr_hi32,
&reg->msgcode_rwbuffer[1]);
+			iowrite32(ARCMSR_INBOUND_MESG0_SET_CONFIG,
&reg->inbound_msgaddr0);
+			iowrite32(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,
&reg->inbound_doorbell);
 			if (!arcmsr_hbaC_wait_msgint_ready(acb)) {
 				printk(KERN_NOTICE "arcmsr%d: 'set command Q
window' \
 				timeout \n", acb->host->host_no);
-				return 1;
 			}
 		}
 		}
 	}
-	return 0;
 }
 
 static void arcmsr_wait_firmware_ready(struct AdapterControlBlock *acb)
@@ -2686,7 +2793,7 @@ static void arcmsr_wait_firmware_ready(s
 	case ACB_ADAPTER_TYPE_C: {
 		struct MessageUnit_C *reg = (struct MessageUnit_C
*)acb->pmuC;
 		do {
-			firmware_state = readl(&reg->outbound_msgaddr1);
+			firmware_state = ioread32(&reg->outbound_msgaddr1);
 		} while ((firmware_state & ARCMSR_HBCMU_MESSAGE_FIRMWARE_OK)
== 0);
 		}
 	}
@@ -2752,8 +2859,8 @@ static void arcmsr_hbaC_request_device_m
 			mod_timer(&acb->eternal_timer, jiffies +
msecs_to_jiffies(6 * HZ));
 			return;
 		}
-		writel(ARCMSR_INBOUND_MESG0_GET_CONFIG,
&reg->inbound_msgaddr0);
-		writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,
&reg->inbound_doorbell);
+		iowrite32(ARCMSR_INBOUND_MESG0_GET_CONFIG,
&reg->inbound_msgaddr0);
+		iowrite32(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,
&reg->inbound_doorbell);
 		mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6
* HZ));
 	}
 	return;
@@ -2803,8 +2910,8 @@ static void arcmsr_hbaC_start_bgrb(struc
 {
 	struct MessageUnit_C *phbcmu = (struct MessageUnit_C *)pACB->pmuC;
 	pACB->acb_flags |= ACB_F_MSG_START_BGRB;
-	writel(ARCMSR_INBOUND_MESG0_START_BGRB, &phbcmu->inbound_msgaddr0);
-	writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,
&phbcmu->inbound_doorbell);
+	iowrite32(ARCMSR_INBOUND_MESG0_START_BGRB,
&phbcmu->inbound_msgaddr0);
+	iowrite32(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,
&phbcmu->inbound_doorbell);
 	if (!arcmsr_hbaC_wait_msgint_ready(pACB)) {
 		printk(KERN_NOTICE "arcmsr%d: wait 'start adapter background
\
 				rebulid' timeout \n", pACB->host->host_no);
@@ -2851,9 +2958,11 @@ static void arcmsr_clear_doorbell_queue_
 		struct MessageUnit_C *reg = (struct MessageUnit_C
*)acb->pmuC;
 		uint32_t outbound_doorbell;
 		/* empty doorbell Qbuffer if door bell ringed */
-		outbound_doorbell = readl(&reg->outbound_doorbell);
-		writel(outbound_doorbell, &reg->outbound_doorbell_clear);
-		writel(ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK,
&reg->inbound_doorbell);
+		outbound_doorbell = ioread32(&reg->outbound_doorbell);
+		iowrite32(outbound_doorbell, &reg->outbound_doorbell_clear);
+		iowrite32(ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK,
&reg->inbound_doorbell);
+		ioread32(&reg->outbound_doorbell_clear);
+		ioread32(&reg->inbound_doorbell);
 		}
 	}
 }
@@ -2897,14 +3006,14 @@ static void arcmsr_hardware_reset(struct
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
ARCMSR_ARC1880_DiagWrite_ENABLE) == 0) && (count < 5));
-		writel(ARCMSR_ARC1880_RESET_ADAPTER,
&pmuC->host_diagnostic);
+			iowrite32(0xF, &pmuC->write_sequence);
+			iowrite32(0x4, &pmuC->write_sequence);
+			iowrite32(0xB, &pmuC->write_sequence);
+			iowrite32(0x2, &pmuC->write_sequence);
+			iowrite32(0x7, &pmuC->write_sequence);
+			iowrite32(0xD, &pmuC->write_sequence);
+		} while ((((temp = ioread32(&pmuC->host_diagnostic)) |
ARCMSR_ARC1880_DiagWrite_ENABLE) == 0) && (count < 5));
+		iowrite32(ARCMSR_ARC1880_RESET_ADAPTER,
&pmuC->host_diagnostic);
 	} else {
 		pci_write_config_byte(acb->pdev, 0x84, 0x20);
 	}
@@ -3065,7 +3174,7 @@ sleep_again:
 				acb->acb_flags &= ~ACB_F_IOP_INITED;
 sleep:
 				ssleep(ARCMSR_SLEEPTIME);
-				if ((readl(&reg->host_diagnostic) & 0x04) !=
0) {
+				if ((ioread32(&reg->host_diagnostic) & 0x04)
!= 0) {
 					printk(KERN_ERR "arcmsr%d: waiting
for hw bus reset return, retry=%d\n", acb->host->host_no, retry_count);
 					if (retry_count > ARCMSR_RETRYCOUNT)
{
 						acb->fw_flag = FW_DEADLOCK;
@@ -3081,9 +3190,9 @@ sleep:
 				arcmsr_get_firmware_spec(acb);
 				arcmsr_start_adapter_bgrb(acb);
 				/* clear Qbuffer if door bell ringed */
-				outbound_doorbell =
readl(&reg->outbound_doorbell);
-				writel(outbound_doorbell,
&reg->outbound_doorbell_clear); /*clear interrupt */
-				writel(ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK,
&reg->inbound_doorbell);
+				outbound_doorbell =
ioread32(&reg->outbound_doorbell);
+				iowrite32(outbound_doorbell,
&reg->outbound_doorbell_clear); /*clear interrupt */
+				iowrite32(ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK,
&reg->inbound_doorbell);
 				/* enable outbound Post Queue,outbound
doorbell Interrupt */
 				arcmsr_enable_outbound_ints(acb,
intmask_org);
 				atomic_set(&acb->rq_map_token, 16);
@@ -3150,7 +3259,7 @@ static int arcmsr_abort(struct scsi_cmnd
 static const char *arcmsr_info(struct Scsi_Host *host)
 {
 	struct AdapterControlBlock *acb =
-		(struct AdapterControlBlock *) host->hostdata;
+		(struct AdapterControlBlock *)host->hostdata;
 	static char buf[256];
 	char *type;
 	int raid6 = 1;
