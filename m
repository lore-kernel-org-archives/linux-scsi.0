From: =?UTF-8?B?6YSt5a6I6KyZ?= <nick.cheng@areca.com.tw>
Subject: [PATCH 1/5] arcmsr: Re-name the HBA Type
Date: Tue, 9 Oct 2012 21:36:27 +0800
Message-ID: <CAGUPPa7aQPaLGvJmc_nG2oJza-0JdRn+vjvt0CXB535e0eMUeA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:38585 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755524Ab2JINg3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Oct 2012 09:36:29 -0400
Received: by mail-lb0-f174.google.com with SMTP id n3so3729810lbo.19
        for <linux-scsi@vger.kernel.org>; Tue, 09 Oct 2012 06:36:27 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, jejb@kernel.org

From: Nick Cheng <nick.cheng@areca.com.tw>

Replace the nameing, hba, hbb and hbc, with hbaA, hbaB abd hbaC respectively
Signed-off-by: Nick Cheng <nick.cheng@areca.com.tw>
---
diff -uprN -X linux-vanilla/Documentation/dontdiff
linux-vanilla//drivers/scsi/arcmsr/arcmsr.h
linux-development//drivers/scsi/arcmsr/arcmsr.h
--- linux-vanilla//drivers/scsi/arcmsr/arcmsr.h	2012-10-03
18:29:18.030657090 +0800
+++ linux-development//drivers/scsi/arcmsr/arcmsr.h	2012-10-03
18:43:58.542648536 +0800
@@ -51,7 +51,7 @@ struct device_attribute;
 #else
 	#define ARCMSR_MAX_FREECCB_NUM	320
 #endif
-#define ARCMSR_DRIVER_VERSION		     "Driver Version 1.20.00.15 2010/08/05"
+#define ARCMSR_DRIVER_VERSION		     "Driver Version 1.20.00.15 2012/09/30"
 #define ARCMSR_SCSI_INITIATOR_ID						255
 #define ARCMSR_MAX_XFER_SECTORS							512
 #define ARCMSR_MAX_XFER_SECTORS_B						4096
diff -uprN -X linux-vanilla/Documentation/dontdiff
linux-vanilla//drivers/scsi/arcmsr/arcmsr_hba.c
linux-development//drivers/scsi/arcmsr/arcmsr_hba.c
--- linux-vanilla//drivers/scsi/arcmsr/arcmsr_hba.c	2012-10-03
18:29:18.030657090 +0800
+++ linux-development//drivers/scsi/arcmsr/arcmsr_hba.c	2012-10-03
18:43:58.542648536 +0800
@@ -61,6 +61,7 @@
 #include <linux/aer.h>
 #include <asm/dma.h>
 #include <asm/io.h>
+#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi.h>
@@ -95,16 +96,16 @@ static void arcmsr_iop_init(struct Adapt
 static void arcmsr_free_ccb_pool(struct AdapterControlBlock *acb);
 static u32 arcmsr_disable_outbound_ints(struct AdapterControlBlock *acb);
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
@@ -308,7 +309,7 @@ static void arcmsr_define_adapter_type(s
 	}
 }

-static uint8_t arcmsr_hba_wait_msgint_ready(struct AdapterControlBlock *acb)
+static uint8_t arcmsr_hbaA_wait_msgint_ready(struct AdapterControlBlock *acb)
 {
 	struct MessageUnit_A __iomem *reg = acb->pmuA;
 	int i;
@@ -326,7 +327,7 @@ static uint8_t arcmsr_hba_wait_msgint_re
 	return false;
 }

-static uint8_t arcmsr_hbb_wait_msgint_ready(struct AdapterControlBlock *acb)
+static uint8_t arcmsr_hbaB_wait_msgint_ready(struct AdapterControlBlock *acb)
 {
 	struct MessageUnit_B *reg = acb->pmuB;
 	int i;
@@ -346,7 +347,7 @@ static uint8_t arcmsr_hbb_wait_msgint_re
 	return false;
 }

-static uint8_t arcmsr_hbc_wait_msgint_ready(struct AdapterControlBlock *pACB)
+static uint8_t arcmsr_hbaC_wait_msgint_ready(struct AdapterControlBlock *pACB)
 {
 	struct MessageUnit_C *phbcmu = (struct MessageUnit_C *)pACB->pmuC;
 	int i;
@@ -364,13 +365,13 @@ static uint8_t arcmsr_hbc_wait_msgint_re
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
@@ -380,13 +381,13 @@ static void arcmsr_flush_hba_cache(struc
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
@@ -396,14 +397,14 @@ static void arcmsr_flush_hbb_cache(struc
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
@@ -418,16 +419,16 @@ static void arcmsr_flush_adapter_cache(s
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
@@ -709,11 +710,11 @@ pci_disable_dev:
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
@@ -722,12 +723,12 @@ static uint8_t arcmsr_abort_hba_allcmd(s
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
@@ -735,12 +736,12 @@ static uint8_t arcmsr_abort_hbb_allcmd(s
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
@@ -753,17 +754,17 @@ static uint8_t arcmsr_abort_allcmd(struc
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
@@ -773,7 +774,7 @@ static bool arcmsr_hbb_enable_driver_mod
 {
 	struct MessageUnit_B *reg = pacb->pmuB;
 	writel(ARCMSR_MESSAGE_START_DRIVER_MODE, reg->drv2iop_doorbell);
-	if (!arcmsr_hbb_wait_msgint_ready(pacb)) {
+	if (!arcmsr_hbaB_wait_msgint_ready(pacb)) {
 		printk(KERN_ERR "arcmsr%d: can't set driver mode. \n", pacb->host->host_no);
 		return false;
 	}
@@ -999,7 +1000,7 @@ static void arcmsr_remove(struct pci_dev
 	int poll_count = 0;
 	arcmsr_free_sysfs_attr(acb);
 	scsi_remove_host(host);
-	flush_work(&acb->arcmsr_do_message_isr_bh);
+	flush_work_sync(&acb->arcmsr_do_message_isr_bh);
 	del_timer_sync(&acb->eternal_timer);
 	arcmsr_disable_outbound_ints(acb);
 	arcmsr_stop_adapter_bgrb(acb);
@@ -1045,7 +1046,7 @@ static void arcmsr_shutdown(struct pci_d
 		(struct AdapterControlBlock *)host->hostdata;
 	del_timer_sync(&acb->eternal_timer);
 	arcmsr_disable_outbound_ints(acb);
-	flush_work(&acb->arcmsr_do_message_isr_bh);
+	flush_work_sync(&acb->arcmsr_do_message_isr_bh);
 	arcmsr_stop_adapter_bgrb(acb);
 	arcmsr_flush_adapter_cache(acb);
 }
@@ -1212,7 +1213,7 @@ static void arcmsr_stop_hba_bgrb(struct
 	struct MessageUnit_A __iomem *reg = acb->pmuA;
 	acb->acb_flags &= ~ACB_F_MSG_START_BGRB;
 	writel(ARCMSR_INBOUND_MESG0_STOP_BGRB, &reg->inbound_msgaddr0);
-	if (!arcmsr_hba_wait_msgint_ready(acb)) {
+	if (!arcmsr_hbaA_wait_msgint_ready(acb)) {
 		printk(KERN_NOTICE
 			"arcmsr%d: wait 'stop adapter background rebulid' timeout \n"
 			, acb->host->host_no);
@@ -1225,7 +1226,7 @@ static void arcmsr_stop_hbb_bgrb(struct
 	acb->acb_flags &= ~ACB_F_MSG_START_BGRB;
 	writel(ARCMSR_MESSAGE_STOP_BGRB, reg->drv2iop_doorbell);

-	if (!arcmsr_hbb_wait_msgint_ready(acb)) {
+	if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
 		printk(KERN_NOTICE
 			"arcmsr%d: wait 'stop adapter background rebulid' timeout \n"
 			, acb->host->host_no);
@@ -1238,7 +1239,7 @@ static void arcmsr_stop_hbc_bgrb(struct
 	pACB->acb_flags &= ~ACB_F_MSG_START_BGRB;
 	writel(ARCMSR_INBOUND_MESG0_STOP_BGRB, &reg->inbound_msgaddr0);
 	writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);
-	if (!arcmsr_hbc_wait_msgint_ready(pACB)) {
+	if (!arcmsr_hbaC_wait_msgint_ready(pACB)) {
 		printk(KERN_NOTICE
 			"arcmsr%d: wait 'stop adapter background rebulid' timeout \n"
 			, pACB->host->host_no);
@@ -1436,7 +1437,7 @@ static void arcmsr_iop2drv_data_read_han
 	}
 }

-static void arcmsr_hba_doorbell_isr(struct AdapterControlBlock *acb)
+static void arcmsr_hbaA_doorbell_isr(struct AdapterControlBlock *acb)
 {
 	uint32_t outbound_doorbell;
 	struct MessageUnit_A __iomem *reg = acb->pmuA;
@@ -1450,7 +1451,7 @@ static void arcmsr_hba_doorbell_isr(stru
 		arcmsr_iop2drv_data_read_handle(acb);
 	}
 }
-static void arcmsr_hbc_doorbell_isr(struct AdapterControlBlock *pACB)
+static void arcmsr_hbaC_doorbell_isr(struct AdapterControlBlock *pACB)
 {
 	uint32_t outbound_doorbell;
 	struct MessageUnit_C *reg = (struct MessageUnit_C *)pACB->pmuC;
@@ -1470,11 +1471,11 @@ static void arcmsr_hbc_doorbell_isr(stru
 		arcmsr_iop2drv_data_read_handle(pACB);
 	}
 	if (outbound_doorbell & ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {
-		arcmsr_hbc_message_isr(pACB);    /* messenger of "driver to iop commands" */
+		arcmsr_hbaC_message_isr(pACB);    /* messenger of "driver to iop commands" */
 	}
 	return;
 }
-static void arcmsr_hba_postqueue_isr(struct AdapterControlBlock *acb)
+static void arcmsr_hbaA_postqueue_isr(struct AdapterControlBlock *acb)
 {
 	uint32_t flag_ccb;
 	struct MessageUnit_A __iomem *reg = acb->pmuA;
@@ -1488,7 +1489,7 @@ static void arcmsr_hba_postqueue_isr(str
 		arcmsr_drain_donequeue(acb, pCCB, error);
 	}
 }
-static void arcmsr_hbb_postqueue_isr(struct AdapterControlBlock *acb)
+static void arcmsr_hbaB_postqueue_isr(struct AdapterControlBlock *acb)
 {
 	uint32_t index;
 	uint32_t flag_ccb;
@@ -1509,7 +1510,7 @@ static void arcmsr_hbb_postqueue_isr(str
 	}
 }

-static void arcmsr_hbc_postqueue_isr(struct AdapterControlBlock *acb)
+static void arcmsr_hbaC_postqueue_isr(struct AdapterControlBlock *acb)
 {
 	struct MessageUnit_C *phbcmu;
 	struct ARCMSR_CDB *arcmsr_cdb;
@@ -1546,14 +1547,14 @@ static void arcmsr_hbc_postqueue_isr(str
 ** We want this in order to compare the drivemap so that we can
detect newly-attached drives.
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

@@ -1570,7 +1571,7 @@ static void arcmsr_hbb_message_isr(struc
 ** We want this in order to compare the drivemap so that we can
detect newly-attached drives.
 **********************************************************************************
 */
-static void arcmsr_hbc_message_isr(struct AdapterControlBlock *acb)
+static void arcmsr_hbaC_message_isr(struct AdapterControlBlock *acb)
 {
 	struct MessageUnit_C *reg  = acb->pmuC;
 	/*clear interrupt and message state*/
@@ -1578,7 +1579,7 @@ static void arcmsr_hbc_message_isr(struc
 	schedule_work(&acb->arcmsr_do_message_isr_bh);
 }

-static int arcmsr_handle_hba_isr(struct AdapterControlBlock *acb)
+static int arcmsr_hbaA_handle_isr(struct AdapterControlBlock *acb)
 {
 	uint32_t outbound_intstatus;
 	struct MessageUnit_A __iomem *reg = acb->pmuA;
@@ -1589,19 +1590,19 @@ static int arcmsr_handle_hba_isr(struct
 	}
 	writel(outbound_intstatus, &reg->outbound_intstatus);
 	if (outbound_intstatus & ARCMSR_MU_OUTBOUND_DOORBELL_INT)	{
-		arcmsr_hba_doorbell_isr(acb);
+		arcmsr_hbaA_doorbell_isr(acb);
 	}
 	if (outbound_intstatus & ARCMSR_MU_OUTBOUND_POSTQUEUE_INT) {
-		arcmsr_hba_postqueue_isr(acb);
+		arcmsr_hbaA_postqueue_isr(acb);
 	}
 	if(outbound_intstatus & ARCMSR_MU_OUTBOUND_MESSAGE0_INT) 	{
 		/* messenger of "driver to iop commands" */
-		arcmsr_hba_message_isr(acb);
+		arcmsr_hbaA_message_isr(acb);
 	}
 	return 0;
 }

-static int arcmsr_handle_hbb_isr(struct AdapterControlBlock *acb)
+static int arcmsr_hbaB_handle_isr(struct AdapterControlBlock *acb)
 {
 	uint32_t outbound_doorbell;
 	struct MessageUnit_B *reg = acb->pmuB;
@@ -1622,16 +1623,16 @@ static int arcmsr_handle_hbb_isr(struct
 		arcmsr_iop2drv_data_read_handle(acb);
 	}
 	if (outbound_doorbell & ARCMSR_IOP2DRV_CDB_DONE) {
-		arcmsr_hbb_postqueue_isr(acb);
+		arcmsr_hbaB_postqueue_isr(acb);
 	}
 	if(outbound_doorbell & ARCMSR_IOP2DRV_MESSAGE_CMD_DONE) {
 		/* messenger of "driver to iop commands" */
-		arcmsr_hbb_message_isr(acb);
+		arcmsr_hbaB_message_isr(acb);
 	}
 	return 0;
 }

-static int arcmsr_handle_hbc_isr(struct AdapterControlBlock *pACB)
+static int arcmsr_hbaC_handle_isr(struct AdapterControlBlock *pACB)
 {
 	uint32_t host_interrupt_status;
 	struct MessageUnit_C *phbcmu = (struct MessageUnit_C *)pACB->pmuC;
@@ -1647,11 +1648,11 @@ static int arcmsr_handle_hbc_isr(struct
 	}
 	/* MU ioctl transfer doorbell interrupts*/
 	if (host_interrupt_status & ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR) {
-		arcmsr_hbc_doorbell_isr(pACB);   /* messenger of "ioctl message
read write" */
+		arcmsr_hbaC_doorbell_isr(pACB);   /* messenger of "ioctl message
read write" */
 	}
 	/* MU post queue interrupts*/
 	if (host_interrupt_status & ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR) {
-		arcmsr_hbc_postqueue_isr(pACB);  /* messenger of "scsi commands" */
+		arcmsr_hbaC_postqueue_isr(pACB);  /* messenger of "scsi commands" */
 	}
 	return 0;
 }
@@ -1659,20 +1660,20 @@ static irqreturn_t arcmsr_interrupt(stru
 {
 	switch (acb->adapter_type) {
 	case ACB_ADAPTER_TYPE_A: {
-		if (arcmsr_handle_hba_isr(acb)) {
+		if (arcmsr_hbaA_handle_isr(acb)) {
 			return IRQ_NONE;
 		}
 		}
 		break;

 	case ACB_ADAPTER_TYPE_B: {
-		if (arcmsr_handle_hbb_isr(acb)) {
+		if (arcmsr_hbaB_handle_isr(acb)) {
 			return IRQ_NONE;
 		}
 		}
 		break;
 	 case ACB_ADAPTER_TYPE_C: {
-		if (arcmsr_handle_hbc_isr(acb)) {
+		if (arcmsr_hbaC_handle_isr(acb)) {
 			return IRQ_NONE;
 		}
 		}
@@ -1735,7 +1736,7 @@ static int arcmsr_iop_message_xfer(struc
 						(uint32_t ) cmd->cmnd[8];
 						/* 4 bytes: Areca io control code */
 	sg = scsi_sglist(cmd);
-	buffer = kmap_atomic(sg_page(sg)) + sg->offset;
+	buffer = kmap_atomic(sg_page(sg), KM_IRQ0) + sg->offset;
 	if (scsi_sg_count(cmd) > 1) {
 		retvalue = ARCMSR_MESSAGE_FAIL;
 		goto message_out;
@@ -1984,7 +1985,7 @@ static int arcmsr_iop_message_xfer(struc
 	}
 	message_out:
 	sg = scsi_sglist(cmd);
-	kunmap_atomic(buffer - sg->offset);
+	kunmap_atomic(buffer - sg->offset, KM_IRQ0);
 	return retvalue;
 }

@@ -2034,11 +2035,11 @@ static void arcmsr_handle_virtual_comman
 		strncpy(&inqdata[32], "R001", 4); /* Product Revision */

 		sg = scsi_sglist(cmd);
-		buffer = kmap_atomic(sg_page(sg)) + sg->offset;
+		buffer = kmap_atomic(sg_page(sg), KM_IRQ0) + sg->offset;

 		memcpy(buffer, inqdata, sizeof(inqdata));
 		sg = scsi_sglist(cmd);
-		kunmap_atomic(buffer - sg->offset);
+		kunmap_atomic(buffer - sg->offset, KM_IRQ0);

 		cmd->scsi_done(cmd);
 	}
@@ -2096,7 +2097,7 @@ static int arcmsr_queue_command_lck(stru

 static DEF_SCSI_QCMD(arcmsr_queue_command)

-static bool arcmsr_get_hba_config(struct AdapterControlBlock *acb)
+static bool arcmsr_hbaA_get_config(struct AdapterControlBlock *acb)
 {
 	struct MessageUnit_A __iomem *reg = acb->pmuA;
 	char *acb_firm_model = acb->firm_model;
@@ -2107,7 +2108,7 @@ static bool arcmsr_get_hba_config(struct
 	char __iomem *iop_device_map = (char __iomem *)(&reg->message_rwbuffer[21]);
 	int count;
 	writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);
-	if (!arcmsr_hba_wait_msgint_ready(acb)) {
+	if (!arcmsr_hbaA_wait_msgint_ready(acb)) {
 		printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware \
 			miscellaneous data' timeout \n", acb->host->host_no);
 		return false;
@@ -2147,7 +2148,7 @@ static bool arcmsr_get_hba_config(struct
 	acb->firm_cfg_version = readl(&reg->message_rwbuffer[25]);
/*firm_cfg_version,25,100-103*/
 	return true;
 }
-static bool arcmsr_get_hbb_config(struct AdapterControlBlock *acb)
+static bool arcmsr_hbaB_get_config(struct AdapterControlBlock *acb)
 {
 	struct MessageUnit_B *reg = acb->pmuB;
 	struct pci_dev *pdev = acb->pdev;
@@ -2183,7 +2184,7 @@ static bool arcmsr_get_hbb_config(struct
 	iop_device_map = (char __iomem
*)(&reg->message_rwbuffer[21]);	/*firm_version,21,84-99*/

 	writel(ARCMSR_MESSAGE_GET_CONFIG, reg->drv2iop_doorbell);
-	if (!arcmsr_hbb_wait_msgint_ready(acb)) {
+	if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
 		printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware \
 			miscellaneous data' timeout \n", acb->host->host_no);
 		return false;
@@ -2231,7 +2232,7 @@ static bool arcmsr_get_hbb_config(struct
 	return true;
 }

-static bool arcmsr_get_hbc_config(struct AdapterControlBlock *pACB)
+static bool arcmsr_hbaC_get_config(struct AdapterControlBlock *pACB)
 {
 	uint32_t intmask_org, Index, firmware_state = 0;
 	struct MessageUnit_C *reg = pACB->pmuC;
@@ -2292,14 +2293,14 @@ static bool arcmsr_get_hbc_config(struct
 static bool arcmsr_get_firmware_spec(struct AdapterControlBlock *acb)
 {
 	if (acb->adapter_type == ACB_ADAPTER_TYPE_A)
-		return arcmsr_get_hba_config(acb);
+		return arcmsr_hbaA_get_config(acb);
 	else if (acb->adapter_type == ACB_ADAPTER_TYPE_B)
-		return arcmsr_get_hbb_config(acb);
+		return arcmsr_hbaB_get_config(acb);
 	else
-		return arcmsr_get_hbc_config(acb);
+		return arcmsr_hbaC_get_config(acb);
 }

-static int arcmsr_polling_hba_ccbdone(struct AdapterControlBlock *acb,
+static int arcmsr_hbaA_polling_ccbdone(struct AdapterControlBlock *acb,
 	struct CommandControlBlock *poll_ccb)
 {
 	struct MessageUnit_A __iomem *reg = acb->pmuA;
@@ -2355,7 +2356,7 @@ static int arcmsr_polling_hba_ccbdone(st
 	return rtn;
 }

-static int arcmsr_polling_hbb_ccbdone(struct AdapterControlBlock *acb,
+static int arcmsr_hbaB_polling_ccbdone(struct AdapterControlBlock *acb,
 					struct CommandControlBlock *poll_ccb)
 {
 	struct MessageUnit_B *reg = acb->pmuB;
@@ -2419,7 +2420,7 @@ static int arcmsr_polling_hbb_ccbdone(st
 	return rtn;
 }

-static int arcmsr_polling_hbc_ccbdone(struct AdapterControlBlock
*acb, struct CommandControlBlock *poll_ccb)
+static int arcmsr_hbaC_polling_ccbdone(struct AdapterControlBlock
*acb, struct CommandControlBlock *poll_ccb)
 {
 	struct MessageUnit_C *reg = (struct MessageUnit_C *)acb->pmuC;
 	uint32_t flag_ccb, ccb_cdb_phy;
@@ -2482,16 +2483,16 @@ static int arcmsr_polling_ccbdone(struct
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
@@ -2528,7 +2529,7 @@ static int arcmsr_iop_confirm(struct Ada
 			writel(cdb_phyaddr_hi32, &reg->message_rwbuffer[1]);
 			writel(ARCMSR_INBOUND_MESG0_SET_CONFIG, \
 							&reg->inbound_msgaddr0);
-			if (!arcmsr_hba_wait_msgint_ready(acb)) {
+			if (!arcmsr_hbaA_wait_msgint_ready(acb)) {
 				printk(KERN_NOTICE "arcmsr%d: ""set ccb high \
 				part physical address timeout\n",
 				acb->host->host_no);
@@ -2549,7 +2550,7 @@ static int arcmsr_iop_confirm(struct Ada
 		reg->postq_index = 0;
 		reg->doneq_index = 0;
 		writel(ARCMSR_MESSAGE_SET_POST_WINDOW, reg->drv2iop_doorbell);
-		if (!arcmsr_hbb_wait_msgint_ready(acb)) {
+		if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
 			printk(KERN_NOTICE "arcmsr%d:can not set diver mode\n", \
 				acb->host->host_no);
 			return 1;
@@ -2568,7 +2569,7 @@ static int arcmsr_iop_confirm(struct Ada
 		writel(1056, rwbuffer);

 		writel(ARCMSR_MESSAGE_SET_CONFIG, reg->drv2iop_doorbell);
-		if (!arcmsr_hbb_wait_msgint_ready(acb)) {
+		if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
 			printk(KERN_NOTICE "arcmsr%d: 'set command Q window' \
 			timeout \n",acb->host->host_no);
 			return 1;
@@ -2587,7 +2588,7 @@ static int arcmsr_iop_confirm(struct Ada
 			writel(cdb_phyaddr_hi32, &reg->msgcode_rwbuffer[1]);
 			writel(ARCMSR_INBOUND_MESG0_SET_CONFIG, &reg->inbound_msgaddr0);
 			writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);
-			if (!arcmsr_hbc_wait_msgint_ready(acb)) {
+			if (!arcmsr_hbaC_wait_msgint_ready(acb)) {
 				printk(KERN_NOTICE "arcmsr%d: 'set command Q window' \
 				timeout \n", acb->host->host_no);
 				return 1;
@@ -2628,7 +2629,7 @@ static void arcmsr_wait_firmware_ready(s
 	}
 }

-static void arcmsr_request_hba_device_map(struct AdapterControlBlock *acb)
+static void arcmsr_hbaA_request_device_map(struct AdapterControlBlock *acb)
 {
 	struct MessageUnit_A __iomem *reg = acb->pmuA;
 	if (unlikely(atomic_read(&acb->rq_map_token) == 0) ||
((acb->acb_flags & ACB_F_BUS_RESET) != 0 ) || ((acb->acb_flags &
ACB_F_ABORT) != 0 )){
@@ -2650,7 +2651,7 @@ static void arcmsr_request_hba_device_ma
 	return;
 }

-static void arcmsr_request_hbb_device_map(struct AdapterControlBlock *acb)
+static void arcmsr_hbaB_request_device_map(struct AdapterControlBlock *acb)
 {
 	struct MessageUnit_B __iomem *reg = acb->pmuB;
 	if (unlikely(atomic_read(&acb->rq_map_token) == 0) ||
((acb->acb_flags & ACB_F_BUS_RESET) != 0 ) || ((acb->acb_flags &
ACB_F_ABORT) != 0 )){
@@ -2672,7 +2673,7 @@ static void arcmsr_request_hbb_device_ma
 	return;
 }

-static void arcmsr_request_hbc_device_map(struct AdapterControlBlock *acb)
+static void arcmsr_hbaC_request_device_map(struct AdapterControlBlock *acb)
 {
 	struct MessageUnit_C __iomem *reg = acb->pmuC;
 	if (unlikely(atomic_read(&acb->rq_map_token) == 0) ||
((acb->acb_flags & ACB_F_BUS_RESET) != 0) || ((acb->acb_flags &
ACB_F_ABORT) != 0)) {
@@ -2700,48 +2701,48 @@ static void arcmsr_request_device_map(un
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
@@ -2751,13 +2752,13 @@ static void arcmsr_start_adapter_bgrb(st
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

@@ -2803,7 +2804,7 @@ static void arcmsr_enable_eoi_mode(struc
 		{
 			struct MessageUnit_B *reg = acb->pmuB;
 			writel(ARCMSR_MESSAGE_ACTIVE_EOI_MODE, reg->drv2iop_doorbell);
-			if (!arcmsr_hbb_wait_msgint_ready(acb)) {
+			if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
 				printk(KERN_NOTICE "ARCMSR IOP enables EOI_MODE TIMEOUT");
 				return;
 			}
@@ -2821,7 +2822,7 @@ static void arcmsr_hardware_reset(struct
 	int i, count = 0;
 	struct MessageUnit_A __iomem *pmuA = acb->pmuA;
 	struct MessageUnit_C __iomem *pmuC = acb->pmuC;
-
+	u32 temp = 0;
 	/* backup pci config data */
 	printk(KERN_NOTICE "arcmsr%d: executing hw bus reset .....\n",
acb->host->host_no);
 	for (i = 0; i < 64; i++) {
@@ -2839,7 +2840,7 @@ static void arcmsr_hardware_reset(struct
 			writel(0x2, &pmuC->write_sequence);
 			writel(0x7, &pmuC->write_sequence);
 			writel(0xD, &pmuC->write_sequence);
-		} while (((readl(&pmuC->host_diagnostic) &
ARCMSR_ARC1880_DiagWrite_ENABLE) == 0) && (count < 5));
+		} while ((((temp = readl(&pmuC->host_diagnostic)) |
ARCMSR_ARC1880_DiagWrite_ENABLE) == 0) && (count < 5));
 		writel(ARCMSR_ARC1880_RESET_ADAPTER, &pmuC->host_diagnostic);
 	} else {
 		pci_write_config_byte(acb->pdev, 0x84, 0x20);
