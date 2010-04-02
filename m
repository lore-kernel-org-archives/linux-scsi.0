From: "Nick Cheng" <nick.cheng@areca.com.tw>
Subject: [PATCH 1/3 ] SCSI: Support several features in arcmsr driver
Date: Fri, 2 Apr 2010 12:01:52 +0800
Message-ID: <1C89D804FCDA41259DEBE60429B71A63@areca4e4f859d4>
Reply-To: <nick.cheng@areca.com.tw>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yx0-f195.google.com ([209.85.210.195]:65137 "EHLO
	mail-yx0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279Ab0DBEHk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Apr 2010 00:07:40 -0400
References: 
In-Reply-To: 
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org

1. To support instantaneous report for SCSU device change by periodic
polling
2. In arcmsr_iop_xfer(), inform AP of F/W's deadlock state to prevent
endless waiting
3. To block the coming SCSI command while the driver is handling bus reset
4. To support HW reset in bus reset error handler
Signed-off-by: Nick Cheng< nick.cheng@areca.com.tw >
---
diff -Naurp --ignore-blank-lines --ignore-all-space --ignore-space-change
arcmsr/arcmsr_attr.c arcmsr.1.20.00.15-81103/arcmsr_attr.c
--- arcmsr/arcmsr_attr.c	2010-02-25 02:52:17.000000000 +0800
+++ arcmsr.1.20.00.15-81103/arcmsr_attr.c	2008-06-13
11:02:58.000000000 +0800
@@ -189,6 +189,7 @@ static struct bin_attribute arcmsr_sysfs
 	.attr = {
 		.name = "mu_read",
 		.mode = S_IRUSR ,
+		.owner = THIS_MODULE,
 	},
 	.size = 1032,
 	.read = arcmsr_sysfs_iop_message_read,
@@ -198,6 +199,7 @@ static struct bin_attribute arcmsr_sysfs
 	.attr = {
 		.name = "mu_write",
 		.mode = S_IWUSR,
+		.owner = THIS_MODULE,
 	},
 	.size = 1032,
 	.write = arcmsr_sysfs_iop_message_write,
@@ -207,6 +209,7 @@ static struct bin_attribute arcmsr_sysfs
 	.attr = {
 		.name = "mu_clear",
 		.mode = S_IWUSR,
+		.owner = THIS_MODULE,
 	},
 	.size = 1,
 	.write = arcmsr_sysfs_iop_message_clear,
diff -Naurp --ignore-blank-lines --ignore-all-space --ignore-space-change
arcmsr/arcmsr.h arcmsr.1.20.00.15-81103/arcmsr.h
--- arcmsr/arcmsr.h	2010-02-25 02:52:17.000000000 +0800
+++ arcmsr.1.20.00.15-81103/arcmsr.h	2008-11-05 17:12:40.000000000 +0800
@@ -48,7 +48,7 @@ struct device_attribute;
 /*The limit of outstanding scsi command that firmware can handle*/
 #define ARCMSR_MAX_OUTSTANDING_CMD
256
 #define ARCMSR_MAX_FREECCB_NUM
320
-#define ARCMSR_DRIVER_VERSION		     "Driver Version 1.20.00.15
2008/02/27"
+#define ARCMSR_DRIVER_VERSION		     "Driver Version 1.20.00.15
2008/11/03"
 #define ARCMSR_SCSI_INITIATOR_ID
255
 #define ARCMSR_MAX_XFER_SECTORS
512
 #define ARCMSR_MAX_XFER_SECTORS_B
4096
@@ -66,6 +66,17 @@ struct device_attribute;
 #define ARC_SUCCESS                                                       0
 #define ARC_FAILURE                                                       1
 /*
+***************************************************************************
*******
+**
+***************************************************************************
*******
+*/
+#ifndef TRUE
+#define TRUE 1
+#endif
+#ifndef FALSE
+#define FALSE 0
+#endif
+/*
 
****************************************************************************
***
 **        split 64bits dma addressing
 
****************************************************************************
***
@@ -110,6 +121,8 @@ struct CMD_MESSAGE_FIELD
 #define FUNCTION_SAY_HELLO			0x0807
 #define FUNCTION_SAY_GOODBYE			0x0808
 #define FUNCTION_FLUSH_ADAPTER_CACHE		0x0809
+#define FUNCTION_GET_FIRMWARE_STATUS			0x080A
+#define FUNCTION_HARDWARE_RESET			0x080B
 /* ARECA IO CONTROL CODE*/
 #define ARCMSR_MESSAGE_READ_RQBUFFER       \
 	ARECA_SATA_RAID | FUNCTION_READ_RQBUFFER
@@ -133,6 +146,7 @@ struct CMD_MESSAGE_FIELD
 #define ARCMSR_MESSAGE_RETURNCODE_OK              0x00000001
 #define ARCMSR_MESSAGE_RETURNCODE_ERROR           0x00000006
 #define ARCMSR_MESSAGE_RETURNCODE_3F              0x0000003F
+#define ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON	0x00000088
 /*
 *************************************************************
 **   structure for holding DMA address data
@@ -341,13 +355,13 @@ struct MessageUnit_B
 	uint32_t	done_qbuffer[ARCMSR_MAX_HBB_POSTQUEUE];
 	uint32_t	postq_index;
 	uint32_t	doneq_index;
-	void		__iomem *drv2iop_doorbell_reg;
-	void		__iomem *drv2iop_doorbell_mask_reg;
-	void		__iomem *iop2drv_doorbell_reg;
-	void		__iomem *iop2drv_doorbell_mask_reg;
-	void		__iomem *msgcode_rwbuffer_reg;
-	void		__iomem *ioctl_wbuffer_reg;
-	void		__iomem *ioctl_rbuffer_reg;
+	uint32_t		__iomem *drv2iop_doorbell_reg;
+	uint32_t		__iomem *drv2iop_doorbell_mask_reg;
+	uint32_t		__iomem *iop2drv_doorbell_reg;
+	uint32_t		__iomem *iop2drv_doorbell_mask_reg;
+	uint32_t		__iomem *msgcode_rwbuffer_reg;
+	uint32_t		__iomem *ioctl_wbuffer_reg;
+	uint32_t		__iomem *ioctl_rbuffer_reg;
 };
 
 /*
@@ -375,6 +389,7 @@ struct AdapterControlBlock
 	/* message unit ATU inbound base address0 */
 
 	uint32_t			acb_flags;
+	uint8_t                   		adapter_index;
 	#define ACB_F_SCSISTOPADAPTER         	0x0001
 	#define ACB_F_MSG_STOP_BGRB     	0x0002
 	/* stop RAID background rebuild */
@@ -390,7 +405,7 @@ struct AdapterControlBlock
 	#define ACB_F_BUS_RESET               	0x0080
 	#define ACB_F_IOP_INITED              	0x0100
 	/* iop init */
-
+	#define ACB_F_FIRMWARE_TRAP           		0x0400
 	struct CommandControlBlock *
pccb_pool[ARCMSR_MAX_FREECCB_NUM];
 	/* used for memory free */
 	struct list_head		ccb_free_list;
@@ -423,12 +438,19 @@ struct AdapterControlBlock
 #define ARECA_RAID_GOOD               0xaa
 	uint32_t			num_resets;
 	uint32_t			num_aborts;
+	uint32_t			signature;
 	uint32_t			firm_request_len;
 	uint32_t			firm_numbers_queue;
 	uint32_t			firm_sdram_size;
 	uint32_t			firm_hd_channels;
 	char				firm_model[12];
 	char				firm_version[20];
+	char			device_map[20];			/*21,84-99*/
+	struct work_struct 		arcmsr_do_message_isr_bh;
+	struct timer_list		eternal_timer;
+	unsigned short		fw_state;
+	atomic_t 			rq_map_token;
+	int			ante_token_value;
 };/* HW_DEVICE_EXTENSION */
 /*
 
****************************************************************************
***
diff -Naurp --ignore-blank-lines --ignore-all-space --ignore-space-change
arcmsr/arcmsr_hba.c arcmsr.1.20.00.15-81103/arcmsr_hba.c
--- arcmsr/arcmsr_hba.c	2010-02-25 02:52:17.000000000 +0800
+++ arcmsr.1.20.00.15-81103/arcmsr_hba.c	2008-11-11
12:03:04.000000000 +0800
@@ -71,8 +71,16 @@
 #include <scsi/scsicam.h>
 #include "arcmsr.h"
 
+#ifdef CONFIG_SCSI_ARCMSR_RESET
+	static int sleeptime = 20;
+	static int retrycount = 12;
+	module_param(sleeptime, int, S_IRUGO|S_IWUSR);
+	MODULE_PARM_DESC(sleeptime,"The waiting period for FW ready while
bus reset");
+	module_param(retrycount, int, S_IRUGO|S_IWUSR);
+	MODULE_PARM_DESC(retrycount,"The retry count for FW ready while bus
reset");
+#endif
 MODULE_AUTHOR("Erich Chen <support@areca.com.tw>");
-MODULE_DESCRIPTION("ARECA (ARC11xx/12xx/13xx/16xx) SATA/SAS RAID HOST
Adapter");
+MODULE_DESCRIPTION("ARECA (ARC11xx/12xx/13xx/16xx) SATA/SAS RAID Host Bus
Adapter");
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_VERSION(ARCMSR_DRIVER_VERSION);
 
@@ -95,14 +103,18 @@ static u32 arcmsr_disable_outbound_ints(
 static void arcmsr_stop_adapter_bgrb(struct AdapterControlBlock *acb);
 static void arcmsr_flush_hba_cache(struct AdapterControlBlock *acb);
 static void arcmsr_flush_hbb_cache(struct AdapterControlBlock *acb);
+static void arcmsr_request_device_map(unsigned long pacb);
+static void arcmsr_request_hba_device_map(struct AdapterControlBlock *acb);
+static void arcmsr_request_hbb_device_map(struct AdapterControlBlock *acb);
+static void arcmsr_message_isr_bh_fn(struct work_struct *work);
+static void *arcmsr_get_firmware_spec(struct AdapterControlBlock *acb, int
mode);
+static void arcmsr_start_adapter_bgrb(struct AdapterControlBlock *acb);
+
 static const char *arcmsr_info(struct Scsi_Host *);
 static irqreturn_t arcmsr_interrupt(struct AdapterControlBlock *acb);
 static int arcmsr_adjust_disk_queue_depth(struct scsi_device *sdev,
-					  int queue_depth, int reason)
+								int
queue_depth)
 {
-	if (reason != SCSI_QDEPTH_DEFAULT)
-		return -EOPNOTSUPP;
-
 	if (queue_depth > ARCMSR_MAX_CMD_PERLUN)
 		queue_depth = ARCMSR_MAX_CMD_PERLUN;
 	scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, queue_depth);
@@ -111,7 +123,7 @@ static int arcmsr_adjust_disk_queue_dept
 
 static struct scsi_host_template arcmsr_scsi_host_template = {
 	.module			= THIS_MODULE,
-	.name			= "ARCMSR ARECA SATA/SAS RAID HOST Adapter"
+	.name			= "ARCMSR ARECA SATA/SAS RAID Host Bus
Adapter"
 
ARCMSR_DRIVER_VERSION,
 	.info			= arcmsr_info,
 	.queuecommand		= arcmsr_queue_command,
@@ -235,10 +247,9 @@ static int arcmsr_alloc_ccb_pool(struct 
 		void *dma_coherent;
 		dma_addr_t dma_coherent_handle, dma_addr;
 		struct CommandControlBlock *ccb_tmp;
-		uint32_t intmask_org;
 		int i, j;
 
-		acb->pmuA = pci_ioremap_bar(pdev, 0);
+		acb->pmuA = ioremap(pci_resource_start(pdev, 0),
pci_resource_len(pdev, 0));
 		if (!acb->pmuA) {
 			printk(KERN_NOTICE "arcmsr%d: memory mapping region
fail \n",
 							acb->host->host_no);
@@ -280,12 +291,6 @@ static int arcmsr_alloc_ccb_pool(struct 
 		for (i = 0; i < ARCMSR_MAX_TARGETID; i++)
 			for (j = 0; j < ARCMSR_MAX_TARGETLUN; j++)
 				acb->devstate[i][j] = ARECA_RAID_GONE;
-
-		/*
-		** here we need to tell iop 331 our ccb_tmp.HighPart
-		** if ccb_tmp.HighPart is not zero
-		*/
-		intmask_org = arcmsr_disable_outbound_ints(acb);
 		}
 		break;
 
@@ -296,7 +301,6 @@ static int arcmsr_alloc_ccb_pool(struct 
 		void __iomem *mem_base0, *mem_base1;
 		void *dma_coherent;
 		dma_addr_t dma_coherent_handle, dma_addr;
-		uint32_t intmask_org;
 		struct CommandControlBlock *ccb_tmp;
 		int i, j;
 
@@ -332,11 +336,13 @@ static int arcmsr_alloc_ccb_pool(struct 
 		reg = (struct MessageUnit_B *)(dma_coherent +
 		ARCMSR_MAX_FREECCB_NUM * sizeof(struct
CommandControlBlock));
 		acb->pmuB = reg;
-		mem_base0 = pci_ioremap_bar(pdev, 0);
+		mem_base0 = ioremap(pci_resource_start(pdev, 0),
+					pci_resource_len(pdev, 0));
 		if (!mem_base0)
 			goto out;
 
-		mem_base1 = pci_ioremap_bar(pdev, 2);
+		mem_base1 = ioremap(pci_resource_start(pdev, 2),
+					pci_resource_len(pdev, 2));
 		if (!mem_base1) {
 			iounmap(mem_base0);
 			goto out;
@@ -356,12 +362,6 @@ static int arcmsr_alloc_ccb_pool(struct 
 		for (i = 0; i < ARCMSR_MAX_TARGETID; i++)
 			for (j = 0; j < ARCMSR_MAX_TARGETLUN; j++)
 				acb->devstate[i][j] = ARECA_RAID_GOOD;
-
-		/*
-		** here we need to tell iop 331 our ccb_tmp.HighPart
-		** if ccb_tmp.HighPart is not zero
-		*/
-		intmask_org = arcmsr_disable_outbound_ints(acb);
 		}
 		break;
 	}
@@ -373,6 +373,88 @@ out:
 		sizeof(struct MessageUnit_B)), acb->dma_coherent,
acb->dma_coherent_handle);
 	return -ENOMEM;
 }
+static void arcmsr_message_isr_bh_fn(struct work_struct *work) 
+{
+	struct AdapterControlBlock *acb = container_of(work,struct
AdapterControlBlock, arcmsr_do_message_isr_bh);
+
+	switch (acb->adapter_type) {
+		case ACB_ADAPTER_TYPE_A: {
+
+			struct MessageUnit_A __iomem *reg  = acb->pmuA;
+			char *acb_dev_map = (char *)acb->device_map;
+			uint32_t __iomem *signature = (uint32_t __iomem*)
(&reg->message_rwbuffer[0]);
+			char __iomem *devicemap = (char __iomem*)
(&reg->message_rwbuffer[21]);
+			int target, lun;
+			struct scsi_device *psdev;
+			char diff;
+
+			atomic_inc(&acb->rq_map_token);
+			if (readl(signature) == ARCMSR_SIGNATURE_GET_CONFIG)
{
+				for(target = 0; target < ARCMSR_MAX_TARGETID
-1; target++) {
+					diff =
(*acb_dev_map)^readb(devicemap);
+					if (diff != 0) {
+						char temp;
+						*acb_dev_map =
readb(devicemap);
+						temp =*acb_dev_map;
+						for(lun = 0; lun <
ARCMSR_MAX_TARGETLUN; lun++) {
+							if((temp & 0x01)==1
&& (diff & 0x01) == 1) {	
+
scsi_add_device(acb->host, 0, target, lun);
+							}else if((temp &
0x01) == 0 && (diff & 0x01) == 1) {
+								psdev =
scsi_device_lookup(acb->host, 0, target, lun);
+								if (psdev !=
NULL ) {
+
scsi_remove_device(psdev);
+
scsi_device_put(psdev);
+								}
+							}
+							temp >>= 1;
+							diff >>= 1;
+						}
+					}
+					devicemap++;
+					acb_dev_map++;
+				}
+			}
+			break;
+		}
+
+		case ACB_ADAPTER_TYPE_B: {
+			struct MessageUnit_B *reg  = acb->pmuB;
+			char *acb_dev_map = (char *)acb->device_map;
+			uint32_t __iomem *signature = (uint32_t
__iomem*)(&reg->msgcode_rwbuffer_reg[0]);
+			char __iomem *devicemap = (char
__iomem*)(&reg->msgcode_rwbuffer_reg[21]);
+			int target, lun;
+			struct scsi_device *psdev;
+			char diff;
+
+			atomic_inc(&acb->rq_map_token);
+			if (readl(signature) == ARCMSR_SIGNATURE_GET_CONFIG)
{
+				for(target = 0; target < ARCMSR_MAX_TARGETID
-1; target++) {
+					diff =
(*acb_dev_map)^readb(devicemap);
+					if (diff != 0) {
+						char temp;
+						*acb_dev_map =
readb(devicemap);
+						temp =*acb_dev_map;
+						for(lun = 0; lun <
ARCMSR_MAX_TARGETLUN; lun++) {
+							if((temp & 0x01)==1
&& (diff & 0x01) == 1) {	
+
scsi_add_device(acb->host, 0, target, lun);
+							}else if((temp &
0x01) == 0 && (diff & 0x01) == 1) {
+								psdev =
scsi_device_lookup(acb->host, 0, target, lun);
+								if (psdev !=
NULL ) {
+
scsi_remove_device(psdev);
+
scsi_device_put(psdev);
+								}
+							}
+							temp >>= 1;
+							diff >>= 1;
+						}
+					}
+					devicemap++;
+					acb_dev_map++;
+				}
+			}
+		}
+	}
+}
 
 static int arcmsr_probe(struct pci_dev *pdev,
 	const struct pci_device_id *id)
@@ -396,9 +478,9 @@ static int arcmsr_probe(struct pci_dev *
 	acb = (struct AdapterControlBlock *)host->hostdata;
 	memset(acb, 0, sizeof (struct AdapterControlBlock));
 
-	error = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
+	error = pci_set_dma_mask(pdev, DMA_64BIT_MASK);
 	if (error) {
-		error = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+		error = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
 		if (error) {
 			printk(KERN_WARNING
 			       "scsi%d: No suitable DMA mask available\n",
@@ -431,17 +513,17 @@ static int arcmsr_probe(struct pci_dev *
 			   ACB_F_MESSAGE_WQBUFFER_READED);
 	acb->acb_flags &= ~ACB_F_SCSISTOPADAPTER;
 	INIT_LIST_HEAD(&acb->ccb_free_list);
-
+	INIT_WORK (&acb->arcmsr_do_message_isr_bh,
arcmsr_message_isr_bh_fn);
 	error = arcmsr_alloc_ccb_pool(acb);
 	if (error)
 		goto out_release_regions;
 
+	arcmsr_iop_init(acb);
 	error = request_irq(pdev->irq, arcmsr_do_interrupt,
 			    IRQF_SHARED, "arcmsr", acb);
 	if (error)
 		goto out_free_ccb_pool;
 
-	arcmsr_iop_init(acb);
 	pci_set_drvdata(pdev, host);
 	if (strncmp(acb->firm_version, "V1.42", 5) >= 0)
 		host->max_sectors= ARCMSR_MAX_XFER_SECTORS_B;
@@ -458,6 +540,14 @@ static int arcmsr_probe(struct pci_dev *
 	#ifdef CONFIG_SCSI_ARCMSR_AER
 	pci_enable_pcie_error_reporting(pdev);
 	#endif
+	atomic_set(&acb->rq_map_token, 16);
+	acb->fw_state = TRUE;
+	init_timer(&acb->eternal_timer);
+	acb->eternal_timer.expires = jiffies + msecs_to_jiffies(10*HZ);
+	acb->eternal_timer.data = (unsigned long) acb;
+	acb->eternal_timer.function = &arcmsr_request_device_map;
+	add_timer(&acb->eternal_timer);
+
 	return 0;
  out_free_sysfs:
  out_free_irq:
@@ -517,40 +607,48 @@ static uint8_t arcmsr_hbb_wait_msgint_re
 	return 0xff;
 }
 
-static void arcmsr_abort_hba_allcmd(struct AdapterControlBlock *acb)
+static uint8_t arcmsr_abort_hba_allcmd(struct AdapterControlBlock *acb)
 {
 	struct MessageUnit_A __iomem *reg = acb->pmuA;
 
 	writel(ARCMSR_INBOUND_MESG0_ABORT_CMD, &reg->inbound_msgaddr0);
-	if (arcmsr_hba_wait_msgint_ready(acb))
+	if (arcmsr_hba_wait_msgint_ready(acb)){
 		printk(KERN_NOTICE
 			"arcmsr%d: wait 'abort all outstanding command'
timeout \n"
 			, acb->host->host_no);
+		return 0xff;
+	}
+	return 0x00;
 }
 
-static void arcmsr_abort_hbb_allcmd(struct AdapterControlBlock *acb)
+static uint8_t arcmsr_abort_hbb_allcmd(struct AdapterControlBlock *acb)
 {
 	struct MessageUnit_B *reg = acb->pmuB;
 
 	writel(ARCMSR_MESSAGE_ABORT_CMD, reg->drv2iop_doorbell_reg);
-	if (arcmsr_hbb_wait_msgint_ready(acb))
+	if (arcmsr_hbb_wait_msgint_ready(acb)) {
 		printk(KERN_NOTICE
 			"arcmsr%d: wait 'abort all outstanding command'
timeout \n"
 			, acb->host->host_no);
+		return 0xff;
+	}
+	return 0x00;
 }
 
-static void arcmsr_abort_allcmd(struct AdapterControlBlock *acb)
+static uint8_t arcmsr_abort_allcmd(struct AdapterControlBlock *acb)
 {
+	uint8_t rtnval = 0;
 	switch (acb->adapter_type) {
 	case ACB_ADAPTER_TYPE_A: {
-		arcmsr_abort_hba_allcmd(acb);
+		rtnval = arcmsr_abort_hba_allcmd(acb);
 		}
 		break;
 
 	case ACB_ADAPTER_TYPE_B: {
-		arcmsr_abort_hbb_allcmd(acb);
+		rtnval = arcmsr_abort_hbb_allcmd(acb);
 		}
 	}
+	return rtnval;
 }
 
 static void arcmsr_pci_unmap_dma(struct CommandControlBlock *ccb)
@@ -648,8 +746,7 @@ static u32 arcmsr_disable_outbound_ints(
 
 	case ACB_ADAPTER_TYPE_A : {
 		struct MessageUnit_A __iomem *reg = acb->pmuA;
-		orig_mask = readl(&reg->outbound_intmask)|\
-				ARCMSR_MU_OUTBOUND_MESSAGE0_INTMASKENABLE;
+		orig_mask = readl(&reg->outbound_intmask);
 		writel(orig_mask|ARCMSR_MU_OUTBOUND_ALL_INTMASKENABLE, \
 						&reg->outbound_intmask);
 		}
@@ -657,8 +754,7 @@ static u32 arcmsr_disable_outbound_ints(
 
 	case ACB_ADAPTER_TYPE_B : {
 		struct MessageUnit_B *reg = acb->pmuB;
-		orig_mask = readl(reg->iop2drv_doorbell_mask_reg) & \
-					(~ARCMSR_IOP2DRV_MESSAGE_CMD_DONE);
+		orig_mask = readl(reg->iop2drv_doorbell_mask_reg);
 		writel(0, reg->iop2drv_doorbell_mask_reg);
 		}
 		break;
@@ -794,12 +890,13 @@ static void arcmsr_remove(struct pci_dev
 	struct AdapterControlBlock *acb =
 		(struct AdapterControlBlock *) host->hostdata;
 	int poll_count = 0;
-
 	arcmsr_free_sysfs_attr(acb);
 	scsi_remove_host(host);
+	flush_scheduled_work();
+	del_timer_sync(&acb->eternal_timer);
+	arcmsr_disable_outbound_ints(acb);
 	arcmsr_stop_adapter_bgrb(acb);
 	arcmsr_flush_adapter_cache(acb);
-	arcmsr_disable_outbound_ints(acb);
 	acb->acb_flags |= ACB_F_SCSISTOPADAPTER;
 	acb->acb_flags &= ~ACB_F_IOP_INITED;
 
@@ -840,7 +937,9 @@ static void arcmsr_shutdown(struct pci_d
 	struct Scsi_Host *host = pci_get_drvdata(pdev);
 	struct AdapterControlBlock *acb =
 		(struct AdapterControlBlock *)host->hostdata;
-
+	del_timer_sync(&acb->eternal_timer);
+	arcmsr_disable_outbound_ints(acb);
+	flush_scheduled_work();
 	arcmsr_stop_adapter_bgrb(acb);
 	arcmsr_flush_adapter_cache(acb);
 }
@@ -860,7 +959,7 @@ static void arcmsr_module_exit(void)
 module_init(arcmsr_module_init);
 module_exit(arcmsr_module_exit);
 
-static void arcmsr_enable_outbound_ints(struct AdapterControlBlock *acb, \
+static void arcmsr_enable_outbound_ints(struct AdapterControlBlock *acb,
 						u32 intmask_org)
 {
 	u32 mask;
@@ -870,7 +969,8 @@ static void arcmsr_enable_outbound_ints(
 	case ACB_ADAPTER_TYPE_A : {
 		struct MessageUnit_A __iomem *reg = acb->pmuA;
 		mask = intmask_org &
~(ARCMSR_MU_OUTBOUND_POSTQUEUE_INTMASKENABLE |
-			     ARCMSR_MU_OUTBOUND_DOORBELL_INTMASKENABLE);
+			     ARCMSR_MU_OUTBOUND_DOORBELL_INTMASKENABLE|
+			     ARCMSR_MU_OUTBOUND_MESSAGE0_INTMASKENABLE);
 		writel(mask, &reg->outbound_intmask);
 		acb->outbound_int_enable = ~(intmask_org & mask) &
0x000000ff;
 		}
@@ -878,8 +978,10 @@ static void arcmsr_enable_outbound_ints(
 
 	case ACB_ADAPTER_TYPE_B : {
 		struct MessageUnit_B *reg = acb->pmuB;
-		mask = intmask_org | (ARCMSR_IOP2DRV_DATA_WRITE_OK | \
-			ARCMSR_IOP2DRV_DATA_READ_OK |
ARCMSR_IOP2DRV_CDB_DONE);
+		mask = intmask_org | (ARCMSR_IOP2DRV_DATA_WRITE_OK |
+			ARCMSR_IOP2DRV_DATA_READ_OK |
+			ARCMSR_IOP2DRV_CDB_DONE |
+			ARCMSR_IOP2DRV_MESSAGE_CMD_DONE);
 		writel(mask, reg->iop2drv_doorbell_mask_reg);
 		acb->outbound_int_enable = (intmask_org | mask) &
0x0000000f;
 		}
@@ -1047,8 +1149,8 @@ static void arcmsr_free_ccb_pool(struct 
 	}
 	case ACB_ADAPTER_TYPE_B: {
 		struct MessageUnit_B *reg = acb->pmuB;
-		iounmap(reg->drv2iop_doorbell_reg -
ARCMSR_DRV2IOP_DOORBELL);
-		iounmap(reg->ioctl_wbuffer_reg - ARCMSR_IOCTL_WBUFFER);
+		iounmap((u8 *)reg->drv2iop_doorbell_reg -
ARCMSR_DRV2IOP_DOORBELL);
+		iounmap((u8 *)reg->ioctl_wbuffer_reg -
ARCMSR_IOCTL_WBUFFER);
 		dma_free_coherent(&acb->pdev->dev,
 		(ARCMSR_MAX_FREECCB_NUM * sizeof(struct CommandControlBlock)
+ 0x20 +
 		sizeof(struct MessageUnit_B)), acb->dma_coherent,
acb->dma_coherent_handle);
@@ -1248,13 +1350,36 @@ static void arcmsr_hbb_postqueue_isr(str
 		reg->doneq_index = index;
 	}
 }
+/*
+***************************************************************************
*******
+** Handle a message interrupt
+**
+** The only message interrupt we expect is in response to a query for the
current adapter config.  
+** We want this in order to compare the drivemap so that we can detect
newly-attached drives.
+***************************************************************************
*******
+*/
+static void arcmsr_hba_message_isr(struct AdapterControlBlock *acb)
+{
+	struct MessageUnit_A *reg  = acb->pmuA;
+
+	/*clear interrupt and message state*/
+	writel(ARCMSR_MU_OUTBOUND_MESSAGE0_INT, &reg->outbound_intstatus);
+	schedule_work(&acb->arcmsr_do_message_isr_bh);
+}
+static void arcmsr_hbb_message_isr(struct AdapterControlBlock *acb)
+{
+	struct MessageUnit_B *reg  = acb->pmuB;
 
+	/*clear interrupt and message state*/
+	writel(ARCMSR_MESSAGE_INT_CLEAR_PATTERN, reg->iop2drv_doorbell_reg);
+	schedule_work(&acb->arcmsr_do_message_isr_bh);
+}
 static int arcmsr_handle_hba_isr(struct AdapterControlBlock *acb)
 {
 	uint32_t outbound_intstatus;
 	struct MessageUnit_A __iomem *reg = acb->pmuA;
 
-	outbound_intstatus = readl(&reg->outbound_intstatus) & \
+	outbound_intstatus = readl(&reg->outbound_intstatus) &
 
acb->outbound_int_enable;
 	if (!(outbound_intstatus & ARCMSR_MU_OUTBOUND_HANDLE_INT))	{
 		return 1;
@@ -1266,6 +1391,10 @@ static int arcmsr_handle_hba_isr(struct 
 	if (outbound_intstatus & ARCMSR_MU_OUTBOUND_POSTQUEUE_INT) {
 		arcmsr_hba_postqueue_isr(acb);
 	}
+	if(outbound_intstatus & ARCMSR_MU_OUTBOUND_MESSAGE0_INT) 	{
+		/* messenger of "driver to iop commands" */
+		arcmsr_hba_message_isr(acb);
+	}
 	return 0;
 }
 
@@ -1274,13 +1403,14 @@ static int arcmsr_handle_hbb_isr(struct 
 	uint32_t outbound_doorbell;
 	struct MessageUnit_B *reg = acb->pmuB;
 
-	outbound_doorbell = readl(reg->iop2drv_doorbell_reg) & \
+	outbound_doorbell = readl(reg->iop2drv_doorbell_reg) &
 
acb->outbound_int_enable;
 	if (!outbound_doorbell)
 		return 1;
 
 	writel(~outbound_doorbell, reg->iop2drv_doorbell_reg);
-	/*in case the last action of doorbell interrupt clearance is cached,
this action can push HW to write down the clear bit*/
+	/*in case the last action of doorbell interrupt clearance is cached,
+	this action can push HW to write down the clear bit*/
 	readl(reg->iop2drv_doorbell_reg);
 	writel(ARCMSR_DRV2IOP_END_OF_INTERRUPT, reg->drv2iop_doorbell_reg);
 	if (outbound_doorbell & ARCMSR_IOP2DRV_DATA_WRITE_OK) 	{
@@ -1292,6 +1422,10 @@ static int arcmsr_handle_hbb_isr(struct 
 	if (outbound_doorbell & ARCMSR_IOP2DRV_CDB_DONE) {
 		arcmsr_hbb_postqueue_isr(acb);
 	}
+	if(outbound_doorbell & ARCMSR_IOP2DRV_MESSAGE_CMD_DONE) {
+		/* messenger of "driver to iop commands" */
+		arcmsr_hbb_message_isr(acb);
+	}
 
 	return 0;
 }
@@ -1359,7 +1492,7 @@ void arcmsr_post_ioctldata2iop(struct Ad
 	}
 }
 
-static int arcmsr_iop_message_xfer(struct AdapterControlBlock *acb, \
+static int arcmsr_iop_message_xfer(struct AdapterControlBlock *acb,
 					struct scsi_cmnd *cmd)
 {
 	struct CMD_MESSAGE_FIELD *pcmdmessagefld;
@@ -1397,6 +1530,13 @@ static int arcmsr_iop_message_xfer(struc
 			retvalue = ARCMSR_MESSAGE_FAIL;
 			goto message_out;
 		}
+				
+		if(acb->fw_state == FALSE) {
+			pcmdmessagefld->cmdmessage.ReturnCode =
+			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
+			goto message_out;
+		}
+
 		ptmpQbuffer = ver_addr;
 		while ((acb->rqbuf_firstindex != acb->rqbuf_lastindex)
 			&& (allxfer_len < 1031)) {
@@ -1443,6 +1583,12 @@ static int arcmsr_iop_message_xfer(struc
 			retvalue = ARCMSR_MESSAGE_FAIL;
 			goto message_out;
 		}
+		if(acb->fw_state == FALSE) {
+			pcmdmessagefld->cmdmessage.ReturnCode =
+			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
+			goto message_out;
+		}
+
 		ptmpuserbuffer = ver_addr;
 		user_len = pcmdmessagefld->cmdmessage.Length;
 		memcpy(ptmpuserbuffer, pcmdmessagefld->messagedatabuffer,
user_len);
@@ -1495,6 +1641,11 @@ static int arcmsr_iop_message_xfer(struc
 
 	case ARCMSR_MESSAGE_CLEAR_RQBUFFER: {
 		uint8_t *pQbuffer = acb->rqbuffer;
+		if(acb->fw_state == FALSE) {
+			pcmdmessagefld->cmdmessage.ReturnCode =
+			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
+			goto message_out;
+		}
 
 		if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {
 			acb->acb_flags &= ~ACB_F_IOPDATA_OVERFLOW;
@@ -1510,6 +1661,11 @@ static int arcmsr_iop_message_xfer(struc
 
 	case ARCMSR_MESSAGE_CLEAR_WQBUFFER: {
 		uint8_t *pQbuffer = acb->wqbuffer;
+		if(acb->fw_state == FALSE) {
+			pcmdmessagefld->cmdmessage.ReturnCode =
+			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
+			goto message_out;
+		}
 
 		if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {
 			acb->acb_flags &= ~ACB_F_IOPDATA_OVERFLOW;
@@ -1528,6 +1684,11 @@ static int arcmsr_iop_message_xfer(struc
 
 	case ARCMSR_MESSAGE_CLEAR_ALLQBUFFER: {
 		uint8_t *pQbuffer;
+		if(acb->fw_state == FALSE) {
+			pcmdmessagefld->cmdmessage.ReturnCode =
+			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
+			goto message_out;
+		}
 
 		if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {
 			acb->acb_flags &= ~ACB_F_IOPDATA_OVERFLOW;
@@ -1550,13 +1711,22 @@ static int arcmsr_iop_message_xfer(struc
 		break;
 
 	case ARCMSR_MESSAGE_RETURN_CODE_3F: {
+		if(acb->fw_state == FALSE) {
+			pcmdmessagefld->cmdmessage.ReturnCode =
+			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
+			goto message_out;
+		}
 		pcmdmessagefld->cmdmessage.ReturnCode =
ARCMSR_MESSAGE_RETURNCODE_3F;
 		}
 		break;
 
 	case ARCMSR_MESSAGE_SAY_HELLO: {
 		int8_t *hello_string = "Hello! I am ARCMSR";
-
+		if(acb->fw_state == FALSE) {
+			pcmdmessagefld->cmdmessage.ReturnCode =
+			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
+			goto message_out;
+		}
 		memcpy(pcmdmessagefld->messagedatabuffer, hello_string
 			, (int16_t)strlen(hello_string));
 		pcmdmessagefld->cmdmessage.ReturnCode =
ARCMSR_MESSAGE_RETURNCODE_OK;
@@ -1564,10 +1734,20 @@ static int arcmsr_iop_message_xfer(struc
 		break;
 
 	case ARCMSR_MESSAGE_SAY_GOODBYE:
+		if(acb->fw_state == FALSE) {
+			pcmdmessagefld->cmdmessage.ReturnCode =
+			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
+			goto message_out;
+		}
 		arcmsr_iop_parking(acb);
 		break;
 
 	case ARCMSR_MESSAGE_FLUSH_ADAPTER_CACHE:
+		if(acb->fw_state == FALSE) {
+			pcmdmessagefld->cmdmessage.ReturnCode =
+			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
+			goto message_out;
+		}
 		arcmsr_flush_adapter_cache(acb);
 		break;
 
@@ -1650,16 +1830,57 @@ static int arcmsr_queue_command(struct s
 	struct CommandControlBlock *ccb;
 	int target = cmd->device->id;
 	int lun = cmd->device->lun;
-
+	uint8_t scsicmd = cmd->cmnd[0];
 	cmd->scsi_done = done;
 	cmd->host_scribble = NULL;
 	cmd->result = 0;
+
+	if((scsicmd == SYNCHRONIZE_CACHE) ||(scsicmd == SEND_DIAGNOSTIC)) {
+		if(acb->devstate[target][lun] == ARECA_RAID_GONE) {
+    			cmd->result = (DID_NO_CONNECT << 16);
+		}
+		cmd->scsi_done(cmd);
+		return 0;
+	}
+
 	if (acb->acb_flags & ACB_F_BUS_RESET) {
-		printk(KERN_NOTICE "arcmsr%d: bus reset"
-			" and return busy \n"
-			, acb->host->host_no);
+		switch (acb->adapter_type) {
+			case ACB_ADAPTER_TYPE_A: {
+				struct MessageUnit_A __iomem *reg =
acb->pmuA;
+				uint32_t intmask_org,outbound_doorbell;
+
+				if((readl(&reg->outbound_msgaddr1) &
+					ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK)
== 0 ) {
+					printk(KERN_NOTICE "arcmsr%d: bus
reset and return busy \n",
+						acb->host->host_no);
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
+
+				acb->acb_flags &= ~ACB_F_FIRMWARE_TRAP;
+				printk(KERN_NOTICE "arcmsr%d: hardware bus
reset and reset ok \n",
+					acb->host->host_no);
+				/* disable all outbound interrupt */
+				intmask_org =
arcmsr_disable_outbound_ints(acb);
+ 				arcmsr_get_firmware_spec(acb,1);
+				/*start background rebuild*/
+				arcmsr_start_adapter_bgrb(acb);
+				/* clear Qbuffer if door bell ringed */
+				outbound_doorbell =
readl(&reg->outbound_doorbell);
+				/*clear interrupt */
+				writel(outbound_doorbell,
&reg->outbound_doorbell);
+   				writel(ARCMSR_INBOUND_DRIVER_DATA_READ_OK,
+					&reg->inbound_doorbell);
+				/* enable outbound Post Queue,outbound
doorbell Interrupt */
+				arcmsr_enable_outbound_ints(acb,
intmask_org);
+				acb->acb_flags |= ACB_F_IOP_INITED;
+				acb->acb_flags &= ~ACB_F_BUS_RESET;
+			}
+			break;
+			case ACB_ADAPTER_TYPE_B: {
+			}
+		}
+	}
+
 	if (target == 16) {
 		/* virtual device for iop message transfer */
 		arcmsr_handle_virtual_command(acb, cmd);
@@ -1698,21 +1919,24 @@ static int arcmsr_queue_command(struct s
 	return 0;
 }
 
-static void arcmsr_get_hba_config(struct AdapterControlBlock *acb)
-{
+static void *arcmsr_get_hba_config(struct AdapterControlBlock *acb, int
mode){
 	struct MessageUnit_A __iomem *reg = acb->pmuA;
 	char *acb_firm_model = acb->firm_model;
 	char *acb_firm_version = acb->firm_version;
+	char *acb_device_map = acb->device_map;
 	char __iomem *iop_firm_model = (char __iomem
*)(&reg->message_rwbuffer[15]);
 	char __iomem *iop_firm_version = (char __iomem
*)(&reg->message_rwbuffer[17]);
+	char __iomem *iop_device_map = (char __iomem *)
(&reg->message_rwbuffer[21]);
 	int count;
 
 	writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);
 	if (arcmsr_hba_wait_msgint_ready(acb)) {
 		printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware \
 			miscellaneous data' timeout \n",
acb->host->host_no);
+		return NULL;
 	}
 
+	if(mode == 1) {
 	count = 8;
 	while (count) {
 		*acb_firm_model = readb(iop_firm_model);
@@ -1729,34 +1953,48 @@ static void arcmsr_get_hba_config(struct
 		count--;
 	}
 
+		count=16;
+		while(count) {
+        			*acb_device_map=readb(iop_device_map);
+        			acb_device_map++;
+			iop_device_map++;
+			count--;
+ 		}
+		
 	printk(KERN_INFO 	"ARECA RAID ADAPTER%d: FIRMWARE VERSION %s
\n"
 		, acb->host->host_no
 		, acb->firm_version);
-
+		acb->signature = readl(&reg->message_rwbuffer[0]);
 	acb->firm_request_len = readl(&reg->message_rwbuffer[1]);
 	acb->firm_numbers_queue = readl(&reg->message_rwbuffer[2]);
 	acb->firm_sdram_size = readl(&reg->message_rwbuffer[3]);
 	acb->firm_hd_channels = readl(&reg->message_rwbuffer[4]);
 }
-
-static void arcmsr_get_hbb_config(struct AdapterControlBlock *acb)
+	return (reg->message_rwbuffer);
+}
+static void __iomem *arcmsr_get_hbb_config(struct AdapterControlBlock *acb,
int mode)
 {
 	struct MessageUnit_B *reg = acb->pmuB;
 	uint32_t __iomem *lrwbuffer = reg->msgcode_rwbuffer_reg;
 	char *acb_firm_model = acb->firm_model;
 	char *acb_firm_version = acb->firm_version;
+	char *acb_device_map = acb->device_map;
 	char __iomem *iop_firm_model = (char __iomem *)(&lrwbuffer[15]);
 	/*firm_model,15,60-67*/
 	char __iomem *iop_firm_version = (char __iomem *)(&lrwbuffer[17]);
 	/*firm_version,17,68-83*/
+	char __iomem *iop_device_map = (char __iomem *) (&lrwbuffer[21]);
+	/*firm_version,21,84-99*/
 	int count;
 
 	writel(ARCMSR_MESSAGE_GET_CONFIG, reg->drv2iop_doorbell_reg);
 	if (arcmsr_hbb_wait_msgint_ready(acb)) {
 		printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware \
 			miscellaneous data' timeout \n",
acb->host->host_no);
+		return NULL;
 	}
 
+	if(mode == 1) {
 	count = 8;
 	while (count)
 	{
@@ -1775,11 +2013,20 @@ static void arcmsr_get_hbb_config(struct
 		count--;
 	}
 
+		count=16;
+		while(count) {
+        			*acb_device_map=readb(iop_device_map);
+        			acb_device_map++;
+			iop_device_map++;
+			count--;
+ 		}
+		
 	printk(KERN_INFO "ARECA RAID ADAPTER%d: FIRMWARE VERSION %s \n",
 			acb->host->host_no,
 			acb->firm_version);
 
-	lrwbuffer++;
+		acb->signature = readl(lrwbuffer++);
+		/*firm_signature,1,00-03*/
 	acb->firm_request_len = readl(lrwbuffer++);
 	/*firm_request_len,1,04-07*/
 	acb->firm_numbers_queue = readl(lrwbuffer++);
@@ -1789,20 +2036,23 @@ static void arcmsr_get_hbb_config(struct
 	acb->firm_hd_channels = readl(lrwbuffer);
 	/*firm_ide_channels,4,16-19*/
 }
-
-static void arcmsr_get_firmware_spec(struct AdapterControlBlock *acb)
+	return (reg->msgcode_rwbuffer_reg);
+}
+static void *arcmsr_get_firmware_spec(struct AdapterControlBlock *acb, int
mode)
 {
+	void *rtnval = 0;
 	switch (acb->adapter_type) {
 	case ACB_ADAPTER_TYPE_A: {
-		arcmsr_get_hba_config(acb);
+		rtnval = arcmsr_get_hba_config(acb, mode);
 		}
 		break;
 
 	case ACB_ADAPTER_TYPE_B: {
-		arcmsr_get_hbb_config(acb);
+		rtnval = arcmsr_get_hbb_config(acb, mode);
 		}
 		break;
 	}
+	return rtnval;
 }
 
 static void arcmsr_polling_hba_ccbdone(struct AdapterControlBlock *acb,
@@ -2042,6 +2292,67 @@ static void arcmsr_wait_firmware_ready(s
 	}
 }
 
+static void arcmsr_request_hba_device_map(struct AdapterControlBlock *acb)
+{
+	struct MessageUnit_A __iomem *reg = acb->pmuA;
+
+	if(unlikely(atomic_read(&acb->rq_map_token) == 0)) {
+		acb->fw_state = FALSE;
+	} else {
+	/*to prevent rq_map_token from changing by other interrupt, then
+	avoid the dead-lock*/
+		acb->fw_state = TRUE;
+		atomic_dec(&acb->rq_map_token);
+		if((acb->fw_state == FALSE)||
+
(acb->ante_token_value==atomic_read(&acb->rq_map_token))){
+
+			atomic_set(&acb->rq_map_token,16);
+		}
+		acb->ante_token_value=atomic_read(&acb->rq_map_token);
+		writel(ARCMSR_INBOUND_MESG0_GET_CONFIG,
&reg->inbound_msgaddr0);
+	}
+	mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6000));
+	return;
+}
+
+static void arcmsr_request_hbb_device_map(struct AdapterControlBlock *acb)
+{
+	struct MessageUnit_B __iomem *reg = acb->pmuB;
+
+	if(unlikely(atomic_read(&acb->rq_map_token) == 0)) {
+		acb->fw_state = FALSE;
+	} else {
+	/*to prevent rq_map_token from changing by other interrupt, then
+	avoid the dead-lock*/
+		acb->fw_state = TRUE;
+		atomic_dec(&acb->rq_map_token);
+		if((acb->fw_state == FALSE)||
+
(acb->ante_token_value==atomic_read(&acb->rq_map_token))){
+			atomic_set(&acb->rq_map_token,16);
+		}
+		acb->ante_token_value=atomic_read(&acb->rq_map_token);
+		writel(ARCMSR_MESSAGE_GET_CONFIG,
reg->drv2iop_doorbell_reg);
+	}
+	mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6000));
+	return;
+}
+
+static void arcmsr_request_device_map(unsigned long pacb)
+{
+	struct AdapterControlBlock *acb = (struct AdapterControlBlock
*)pacb;
+
+	switch (acb->adapter_type) {
+		case ACB_ADAPTER_TYPE_A: {
+			arcmsr_request_hba_device_map(acb);
+		}
+		break;
+		case ACB_ADAPTER_TYPE_B: {
+			arcmsr_request_hbb_device_map(acb);
+		}
+		break;
+	}
+}
+
 static void arcmsr_start_hba_bgrb(struct AdapterControlBlock *acb)
 {
 	struct MessageUnit_A __iomem *reg = acb->pmuA;
@@ -2120,6 +2431,60 @@ static void arcmsr_enable_eoi_mode(struc
 	return;
 }
 
+static void arcmsr_hardware_reset(struct AdapterControlBlock *acb)
+{
+	uint8_t value[64];
+	int i;
+
+	/* backup pci config data */
+	for (i=0; i<64; i++) {
+		pci_read_config_byte(acb->pdev, i, &value[i]);
+	}
+	/* hardware reset signal */
+	pci_write_config_byte(acb->pdev, 0x84, 0x20);
+	msleep(1000);
+	/* write back pci config data */
+	for (i=0;i<64;i++) {
+		pci_write_config_byte(acb->pdev, i, value[i]);
+	}
+	msleep(1000);
+	return;
+}
+/*
+***************************************************************************
*
+***************************************************************************
*
+*/
+#ifdef CONFIG_SCSI_ARCMSR_RESET
+	int arcmsr_sleep_for_bus_reset(struct scsi_cmnd *cmd)
+	{
+			struct Scsi_Host *shost = NULL;
+			spinlock_t *host_lock = NULL;
+			int i, isleep;
+
+			shost = cmd->device->host;
+			host_lock = shost->host_lock;
+
+			printk("Host %d bus reset over, sleep %d seconds
(busy %d, can queue %d) ...........\n", 
+					shost->host_no, sleeptime,
shost->host_busy, shost->can_queue);
+			isleep = sleeptime / 10;
+			spin_unlock_irq(host_lock);
+			if (isleep > 0) {
+				for (i = 0; i < isleep; i ++) {
+					msleep(10000);
+					printk("^%d^\n", i);
+				}
+			}
+
+			isleep = sleeptime % 10;
+			if (isleep > 0) {
+				msleep(isleep*1000);
+				printk("^v^\n");
+			}
+			spin_lock_irq(host_lock);	        
+			printk("***** wake up *****\n");
+			return 0;
+	}
+#endif
 static void arcmsr_iop_init(struct AdapterControlBlock *acb)
 {
 	uint32_t intmask_org;
@@ -2128,7 +2493,7 @@ static void arcmsr_iop_init(struct Adapt
        intmask_org = arcmsr_disable_outbound_ints(acb);
 	arcmsr_wait_firmware_ready(acb);
 	arcmsr_iop_confirm(acb);
-	arcmsr_get_firmware_spec(acb);
+	arcmsr_get_firmware_spec(acb, 1);
 	/*start background rebuild*/
 	arcmsr_start_adapter_bgrb(acb);
 	/* empty doorbell Qbuffer if door bell ringed */
@@ -2139,51 +2504,114 @@ static void arcmsr_iop_init(struct Adapt
 	acb->acb_flags |= ACB_F_IOP_INITED;
 }
 
-static void arcmsr_iop_reset(struct AdapterControlBlock *acb)
+static uint8_t arcmsr_iop_reset(struct AdapterControlBlock *acb)
 {
 	struct CommandControlBlock *ccb;
 	uint32_t intmask_org;
+	uint8_t rtnval = 0x00;
 	int i = 0;
 
 	if (atomic_read(&acb->ccboutstandingcount) != 0) {
+		/* disable all outbound interrupt */
+		intmask_org = arcmsr_disable_outbound_ints(acb);
 		/* talk to iop 331 outstanding command aborted */
-		arcmsr_abort_allcmd(acb);
-
+		rtnval = arcmsr_abort_allcmd(acb);
 		/* wait for 3 sec for all command aborted*/
 		ssleep(3);
-
-		/* disable all outbound interrupt */
-		intmask_org = arcmsr_disable_outbound_ints(acb);
 		/* clear all outbound posted Q */
 		arcmsr_done4abort_postqueue(acb);
 		for (i = 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {
 			ccb = acb->pccb_pool[i];
 			if (ccb->startdone == ARCMSR_CCB_START) {
-				ccb->startdone = ARCMSR_CCB_ABORTED;
 				arcmsr_ccb_complete(ccb, 1);
 			}
 		}
+		atomic_set(&acb->ccboutstandingcount, 0);
 		/* enable all outbound interrupt */
 		arcmsr_enable_outbound_ints(acb, intmask_org);
+		return rtnval;
 	}
+	return rtnval;
 }
 
 static int arcmsr_bus_reset(struct scsi_cmnd *cmd)
 {
 	struct AdapterControlBlock *acb =
 		(struct AdapterControlBlock *)cmd->device->host->hostdata;
-	int i;
+	int retry = 0;
 
-	acb->num_resets++;
+	if(acb->acb_flags & ACB_F_BUS_RESET)
+		return SUCCESS;
+
+	printk("arcmsr%d: bus reset ..... \n", acb->adapter_index);
 	acb->acb_flags |= ACB_F_BUS_RESET;
-	for (i = 0; i < 400; i++) {
-		if (!atomic_read(&acb->ccboutstandingcount))
+	acb->num_resets++;
+	while(atomic_read(&acb->ccboutstandingcount) != 0 && retry < 4) {
+		arcmsr_interrupt(acb);
+		retry++;
+	}
+
+	if(arcmsr_iop_reset(acb)) {
+		switch (acb->adapter_type) {
+		case ACB_ADAPTER_TYPE_A: {
+			printk("arcmsr%d: do hardware bus reset, num_resets
= %d num_aborts = %d \n",
+				acb->adapter_index, acb->num_resets,
acb->num_aborts);
+			arcmsr_hardware_reset(acb);
+			acb->acb_flags |= ACB_F_FIRMWARE_TRAP;
+			acb->acb_flags &= ~ACB_F_IOP_INITED;
+			#ifdef CONFIG_SCSI_ARCMSR_RESET
+			struct MessageUnit_A __iomem *reg = acb->pmuA;
+			uint32_t intmask_org, outbound_doorbell;
+			int retry_count = 0;
+			sleep_again:
+			arcmsr_sleep_for_bus_reset(cmd);
+			if(( readl(&reg->outbound_msgaddr1) &
+			ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK) == 0 ) {
+			printk(KERN_NOTICE "arcmsr%d: hardware bus reset and
return busy, retry=%d \n",
+			acb->host->host_no, retry_count);
+			if(retry_count > retrycount) {
+				printk(KERN_NOTICE "arcmsr%d: hardware bus
reset and return busy, retry aborted \n",
+				acb->host->host_no);
+			return SUCCESS;
+			}
+			retry_count++;
+			goto sleep_again;
+			}
+			acb->acb_flags &= ~ACB_F_FIRMWARE_TRAP;
+			acb->acb_flags |= ACB_F_IOP_INITED;
+			acb->acb_flags &= ~ACB_F_BUS_RESET;
+			printk(KERN_NOTICE "arcmsr%d: hardware bus reset and
reset ok \n",
+				acb->host->host_no);
+			/* disable all outbound interrupt */
+			intmask_org=arcmsr_disable_outbound_ints(acb);
+				arcmsr_get_firmware_spec(acb,1);
+			/*start	background rebuild*/
+			arcmsr_start_adapter_bgrb(acb);
+			/* clear Qbuffer if door bell ringed */
+			outbound_doorbell=readl(&reg->outbound_doorbell);
+			writel(outbound_doorbell, &reg->outbound_doorbell);
/*clear interrupt */
+			writel(ARCMSR_INBOUND_DRIVER_DATA_READ_OK,
&reg->inbound_doorbell);
+			/* enable outbound Post Queue,outbound doorbell
Interrupt */
+			arcmsr_enable_outbound_ints(acb, intmask_org);
+			atomic_set(&acb->rq_map_token, 16);
+			init_timer(&acb->eternal_timer);
+			acb->eternal_timer.expires = jiffies +
msecs_to_jiffies(20*HZ);
+			acb->eternal_timer.data = (unsigned long) acb;
+			acb->eternal_timer.function =
&arcmsr_request_device_map;
+			add_timer(&acb->eternal_timer);
+			#endif
+		}
 			break;
-		arcmsr_interrupt(acb);/* FIXME: need spinlock */
-		msleep(25);
+		case ACB_ADAPTER_TYPE_B: {
+		}
+		}
 	}
-	arcmsr_iop_reset(acb);
+	else {
 	acb->acb_flags &= ~ACB_F_BUS_RESET;
+	}	
+
+//	arcmsr_iop_reset(acb);
+//	acb->acb_flags &= ~ACB_F_BUS_RESET;
 	return SUCCESS;
 }


