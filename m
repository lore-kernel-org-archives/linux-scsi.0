From: akpm@linux-foundation.org
Subject: [patch 12/13] scsi: arcmsr updates (1.20.00.15)
Date: Mon, 04 Feb 2008 23:53:24 -0800
Message-ID: <200802050753.m157r6AN010727@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37264 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754044AbYBEHx5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Feb 2008 02:53:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, nick.cheng@areca.com.tw, James.Bottomley@steeleye.com, mbroz@redhat.com, thenzl@redhat.com

From: Nick Cheng <nick.cheng@areca.com.tw>

- add arcmsr_enable_eoi_mode()and readl(reg->iop2drv_doorbell_reg) in
  arcmsr_handle_hbb_isr() on adapter Type B in case of the doorbell
  interrupt clearance is cached

- add conditional declaration for arcmsr_pci_error_detected() and
  arcmsr_pci_slot_reset

- check if the sg list member number exceeds arcmsr default limit in
  arcmsr_build_ccb()

- change the returned value type of arcmsr_build_ccb()from "void" to
  "int" returns FAILED in arcmsr_queue_command()

- modify arcmsr_drain_donequeue() to ignore unknown command and let
  kernel process command timeout.  This could handle IO request violating
  maximum segments, i.e.  Linux XFS over DM-CRYPT.  Thanks to Milan Broz's
  comments <mbroz@redhat.com>

- fix the release of dma memory for type B in arcmsr_free_ccb_pool()

- fix the arcmsr_polling_hbb_ccbdone()

Signed-off-by: Nick Cheng <nick.cheng@areca.com.tw>
Cc: Milan Broz <mbroz@redhat.com>
Cc: <thenzl@redhat.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/scsi/ChangeLog.arcmsr |   41 ++++++++++++
 drivers/scsi/arcmsr/arcmsr.h        |    4 -
 drivers/scsi/arcmsr/arcmsr_hba.c    |   87 ++++++++++++++++++--------
 3 files changed, 105 insertions(+), 27 deletions(-)

diff -puN Documentation/scsi/ChangeLog.arcmsr~scsi-arcmsr-updates-1200015 Documentation/scsi/ChangeLog.arcmsr
--- a/Documentation/scsi/ChangeLog.arcmsr~scsi-arcmsr-updates-1200015
+++ a/Documentation/scsi/ChangeLog.arcmsr
@@ -68,4 +68,45 @@
 **						2. modify the arcmsr_pci_slot_reset function
 **						3. modify the arcmsr_pci_ers_disconnect_forepart function
 **						4. modify the arcmsr_pci_ers_need_reset_forepart function
+** 1.20.00.15   09/27/2007	 Erich Chen & Nick Cheng
+**						1. add arcmsr_enable_eoi_mode() on adapter Type B
+** 						2. add readl(reg->iop2drv_doorbell_reg) in arcmsr_handle_hbb_isr()
+**						in case of the doorbell interrupt clearance is cached
+** 1.20.00.15   10/01/2007	 Erich Chen & Nick Cheng
+**						1. modify acb->devstate[i][j]
+**						as ARECA_RAID_GOOD instead of
+**						ARECA_RAID_GONE in arcmsr_alloc_ccb_pool
+** 1.20.00.15   11/06/2007       Erich Chen & Nick Cheng
+**						1. add conditional declaration for
+** 						arcmsr_pci_error_detected() and
+**						arcmsr_pci_slot_reset
+** 1.20.00.15	11/23/2007       Erich Chen & Nick Cheng
+**						1.check if the sg list member number
+**						exceeds arcmsr default limit in arcmsr_build_ccb()
+**						2.change the returned value type of arcmsr_build_ccb()
+**						from "void" to "int"
+**						3.add the conditional check if arcmsr_build_ccb()
+**						returns FAILED
+** 1.20.00.15	12/04/2007	 Erich Chen & Nick Cheng
+**						1. modify arcmsr_drain_donequeue() to ignore unknown
+**						command and let kernel process command timeout.
+**						This could handle IO request violating max. segments
+**						while Linux XFS over DM-CRYPT.
+**						Thanks to Milan Broz's comments <mbroz@redhat.com>
+** 1.20.00.15	12/24/2007	 Erich Chen & Nick Cheng
+**						1.fix the portability problems
+**						2.fix type B where we should _not_ iounmap() acb->pmu;
+**						it's not ioremapped.
+**						3.add return -ENOMEM if ioremap() fails
+**						4.transfer IS_SG64_ADDR w/ cpu_to_le32()
+**						in arcmsr_build_ccb
+**						5. modify acb->devstate[i][j] as ARECA_RAID_GONE instead of
+**						ARECA_RAID_GOOD in arcmsr_alloc_ccb_pool()
+**						6.fix arcmsr_cdb->Context as (unsigned long)arcmsr_cdb
+**						7.add the checking state of
+**						(outbound_intstatus & ARCMSR_MU_OUTBOUND_HANDLE_INT) == 0
+**						in arcmsr_handle_hba_isr
+**						8.replace pci_alloc_consistent()/pci_free_consistent() with kmalloc()/kfree() in arcmsr_iop_message_xfer()
+**						9. fix the release of dma memory for type B in arcmsr_free_ccb_pool()
+**						10.fix the arcmsr_polling_hbb_ccbdone()
 **************************************************************************
diff -puN drivers/scsi/arcmsr/arcmsr.h~scsi-arcmsr-updates-1200015 drivers/scsi/arcmsr/arcmsr.h
--- a/drivers/scsi/arcmsr/arcmsr.h~scsi-arcmsr-updates-1200015
+++ a/drivers/scsi/arcmsr/arcmsr.h
@@ -48,7 +48,7 @@ struct class_device_attribute;
 /*The limit of outstanding scsi command that firmware can handle*/
 #define ARCMSR_MAX_OUTSTANDING_CMD						256
 #define ARCMSR_MAX_FREECCB_NUM							320
-#define ARCMSR_DRIVER_VERSION		     "Driver Version 1.20.00.15 2007/08/30"
+#define ARCMSR_DRIVER_VERSION		     "Driver Version 1.20.00.15 2007/12/24"
 #define ARCMSR_SCSI_INITIATOR_ID						255
 #define ARCMSR_MAX_XFER_SECTORS							512
 #define ARCMSR_MAX_XFER_SECTORS_B						4096
@@ -248,6 +248,7 @@ struct FIRMWARE_INFO
 #define ARCMSR_MESSAGE_START_BGRB		      0x00060008
 #define ARCMSR_MESSAGE_START_DRIVER_MODE	      0x000E0008
 #define ARCMSR_MESSAGE_SET_POST_WINDOW		      0x000F0008
+#define ARCMSR_MESSAGE_ACTIVE_EOI_MODE		    0x00100008
 /* ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK */
 #define ARCMSR_MESSAGE_FIRMWARE_OK		      0x80000000
 /* ioctl transfer */
@@ -256,6 +257,7 @@ struct FIRMWARE_INFO
 #define ARCMSR_DRV2IOP_DATA_READ_OK                   0x00000002
 #define ARCMSR_DRV2IOP_CDB_POSTED                     0x00000004
 #define ARCMSR_DRV2IOP_MESSAGE_CMD_POSTED             0x00000008
+#define ARCMSR_DRV2IOP_END_OF_INTERRUPT		0x00000010
 
 /* data tunnel buffer between user space program and its firmware */
 /* user space data to iop 128bytes */
diff -puN drivers/scsi/arcmsr/arcmsr_hba.c~scsi-arcmsr-updates-1200015 drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c~scsi-arcmsr-updates-1200015
+++ a/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -315,9 +315,6 @@ static int arcmsr_alloc_ccb_pool(struct 
 				(0x20 - ((unsigned long)dma_coherent_handle & 0x1F));
 		}
 
-		reg = (struct MessageUnit_B *)(dma_coherent +
-		ARCMSR_MAX_FREECCB_NUM * sizeof(struct CommandControlBlock));
-
 		dma_addr = dma_coherent_handle;
 		ccb_tmp = (struct CommandControlBlock *)dma_coherent;
 		for (i = 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {
@@ -371,8 +368,8 @@ static int arcmsr_alloc_ccb_pool(struct 
 
 out:
 	dma_free_coherent(&acb->pdev->dev,
-		ARCMSR_MAX_FREECCB_NUM * sizeof(struct CommandControlBlock) + 0x20,
-		acb->dma_coherent, acb->dma_coherent_handle);
+		(ARCMSR_MAX_FREECCB_NUM * sizeof(struct CommandControlBlock) + 0x20 +
+		sizeof(struct MessageUnit_B)), acb->dma_coherent, acb->dma_coherent_handle);
 	return -ENOMEM;
 }
 
@@ -509,6 +506,7 @@ static uint8_t arcmsr_hbb_wait_msgint_re
 				& ARCMSR_IOP2DRV_MESSAGE_CMD_DONE) {
 				writel(ARCMSR_MESSAGE_INT_CLEAR_PATTERN
 					, reg->iop2drv_doorbell_reg);
+				writel(ARCMSR_DRV2IOP_END_OF_INTERRUPT, reg->drv2iop_doorbell_reg);
 				return 0x00;
 			}
 			msleep(10);
@@ -748,6 +746,7 @@ static void arcmsr_drain_donequeue(struc
 				, ccb->startdone
 				, atomic_read(&acb->ccboutstandingcount));
 		}
+	else
 	arcmsr_report_ccb_state(acb, ccb, flag_ccb);
 }
 
@@ -886,7 +885,7 @@ static void arcmsr_enable_outbound_ints(
 	}
 }
 
-static void arcmsr_build_ccb(struct AdapterControlBlock *acb,
+static int arcmsr_build_ccb(struct AdapterControlBlock *acb,
 	struct CommandControlBlock *ccb, struct scsi_cmnd *pcmd)
 {
 	struct ARCMSR_CDB *arcmsr_cdb = (struct ARCMSR_CDB *)&ccb->arcmsr_cdb;
@@ -906,6 +905,8 @@ static void arcmsr_build_ccb(struct Adap
 	memcpy(arcmsr_cdb->Cdb, pcmd->cmnd, pcmd->cmd_len);
 
 	nseg = scsi_dma_map(pcmd);
+	if (nseg > ARCMSR_MAX_SG_ENTRIES)
+		return FAILED;
 	BUG_ON(nseg < 0);
 
 	if (nseg) {
@@ -946,6 +947,7 @@ static void arcmsr_build_ccb(struct Adap
 		arcmsr_cdb->Flags |= ARCMSR_CDB_FLAG_WRITE;
 		ccb->ccb_flags |= CCB_FLAG_WRITE;
 	}
+	return SUCCESS;
 }
 
 static void arcmsr_post_ccb(struct AdapterControlBlock *acb, struct CommandControlBlock *ccb)
@@ -1036,18 +1038,22 @@ static void arcmsr_free_ccb_pool(struct 
 	switch (acb->adapter_type) {
 	case ACB_ADAPTER_TYPE_A: {
 		iounmap(acb->pmuA);
+		dma_free_coherent(&acb->pdev->dev,
+		ARCMSR_MAX_FREECCB_NUM * sizeof (struct CommandControlBlock) + 0x20,
+		acb->dma_coherent,
+		acb->dma_coherent_handle);
 		break;
 	}
 	case ACB_ADAPTER_TYPE_B: {
 		struct MessageUnit_B *reg = acb->pmuB;
 		iounmap(reg->drv2iop_doorbell_reg - ARCMSR_DRV2IOP_DOORBELL);
 		iounmap(reg->ioctl_wbuffer_reg - ARCMSR_IOCTL_WBUFFER);
+		dma_free_coherent(&acb->pdev->dev,
+		(ARCMSR_MAX_FREECCB_NUM * sizeof(struct CommandControlBlock) + 0x20 +
+		sizeof(struct MessageUnit_B)), acb->dma_coherent, acb->dma_coherent_handle);
 	}
 	}
-	dma_free_coherent(&acb->pdev->dev,
-		ARCMSR_MAX_FREECCB_NUM * sizeof (struct CommandControlBlock) + 0x20,
-		acb->dma_coherent,
-		acb->dma_coherent_handle);
+
 }
 
 void arcmsr_iop_message_read(struct AdapterControlBlock *acb)
@@ -1273,7 +1279,9 @@ static int arcmsr_handle_hbb_isr(struct 
 		return 1;
 
 	writel(~outbound_doorbell, reg->iop2drv_doorbell_reg);
-
+	/*in case the last action of doorbell interrupt clearance is cached, this action can push HW to write down the clear bit*/
+	readl(reg->iop2drv_doorbell_reg);
+	writel(ARCMSR_DRV2IOP_END_OF_INTERRUPT, reg->drv2iop_doorbell_reg);
 	if (outbound_doorbell & ARCMSR_IOP2DRV_DATA_WRITE_OK) 	{
 		arcmsr_iop2drv_data_wrote_handle(acb);
 	}
@@ -1380,12 +1388,13 @@ static int arcmsr_iop_message_xfer(struc
 
 	case ARCMSR_MESSAGE_READ_RQBUFFER: {
 		unsigned long *ver_addr;
-		dma_addr_t buf_handle;
 		uint8_t *pQbuffer, *ptmpQbuffer;
 		int32_t allxfer_len = 0;
+		void *tmp;
 
-		ver_addr = pci_alloc_consistent(acb->pdev, 1032, &buf_handle);
-		if (!ver_addr) {
+		tmp = kmalloc(1032, GFP_KERNEL|GFP_DMA);
+		ver_addr = (unsigned long *)tmp;
+		if (!tmp) {
 			retvalue = ARCMSR_MESSAGE_FAIL;
 			goto message_out;
 		}
@@ -1421,18 +1430,19 @@ static int arcmsr_iop_message_xfer(struc
 		memcpy(pcmdmessagefld->messagedatabuffer, (uint8_t *)ver_addr, allxfer_len);
 		pcmdmessagefld->cmdmessage.Length = allxfer_len;
 		pcmdmessagefld->cmdmessage.ReturnCode = ARCMSR_MESSAGE_RETURNCODE_OK;
-		pci_free_consistent(acb->pdev, 1032, ver_addr, buf_handle);
+		kfree(tmp);
 		}
 		break;
 
 	case ARCMSR_MESSAGE_WRITE_WQBUFFER: {
 		unsigned long *ver_addr;
-		dma_addr_t buf_handle;
 		int32_t my_empty_len, user_len, wqbuf_firstindex, wqbuf_lastindex;
 		uint8_t *pQbuffer, *ptmpuserbuffer;
+		void *tmp;
 
-		ver_addr = pci_alloc_consistent(acb->pdev, 1032, &buf_handle);
-		if (!ver_addr) {
+		tmp = kmalloc(1032, GFP_KERNEL|GFP_DMA);
+		ver_addr = (unsigned long *)tmp;
+		if (!tmp) {
 			retvalue = ARCMSR_MESSAGE_FAIL;
 			goto message_out;
 		}
@@ -1482,7 +1492,7 @@ static int arcmsr_iop_message_xfer(struc
 				retvalue = ARCMSR_MESSAGE_FAIL;
 			}
 			}
-			pci_free_consistent(acb->pdev, 1032, ver_addr, buf_handle);
+			kfree(tmp);
 		}
 		break;
 
@@ -1682,8 +1692,11 @@ static int arcmsr_queue_command(struct s
 	ccb = arcmsr_get_freeccb(acb);
 	if (!ccb)
 		return SCSI_MLQUEUE_HOST_BUSY;
-
-	arcmsr_build_ccb(acb, ccb, cmd);
+	if ( arcmsr_build_ccb( acb, ccb, cmd ) == FAILED ) {
+		cmd->result = (DID_ERROR << 16) | (RESERVATION_CONFLICT << 1);
+		cmd->scsi_done(cmd);
+		return 0;
+	}
 	arcmsr_post_ccb(acb, ccb);
 	return 0;
 }
@@ -1844,7 +1857,7 @@ static void arcmsr_polling_hba_ccbdone(s
 	}
 }
 
-static void arcmsr_polling_hbb_ccbdone(struct AdapterControlBlock *acb, \
+static void arcmsr_polling_hbb_ccbdone(struct AdapterControlBlock *acb,
 					struct CommandControlBlock *poll_ccb)
 {
 		struct MessageUnit_B *reg = acb->pmuB;
@@ -1878,7 +1891,7 @@ static void arcmsr_polling_hbb_ccbdone(s
       (acb->vir2phy_offset + (flag_ccb << 5));/*frame must be 32 bytes aligned*/
 			poll_ccb_done = (ccb == poll_ccb) ? 1:0;
 			if ((ccb->acb != acb) || (ccb->startdone != ARCMSR_CCB_START)) {
-				if (ccb->startdone == ARCMSR_CCB_ABORTED) {
+				if ((ccb->startdone == ARCMSR_CCB_ABORTED) || (ccb == poll_ccb)) {
 					printk(KERN_NOTICE "arcmsr%d: \
 		scsi id = %d lun = %d ccb = '0x%p' poll command abort successfully \n"
 						,acb->host->host_no
@@ -1901,7 +1914,7 @@ static void arcmsr_polling_hbb_ccbdone(s
 		}	/*drain reply FIFO*/
 }
 
-static void arcmsr_polling_ccbdone(struct AdapterControlBlock *acb, \
+static void arcmsr_polling_ccbdone(struct AdapterControlBlock *acb,
 					struct CommandControlBlock *poll_ccb)
 {
 	switch (acb->adapter_type) {
@@ -2026,6 +2039,7 @@ static void arcmsr_wait_firmware_ready(s
 		do {
 			firmware_state = readl(reg->iop2drv_doorbell_reg);
 		} while ((firmware_state & ARCMSR_MESSAGE_FIRMWARE_OK) == 0);
+		writel(ARCMSR_DRV2IOP_END_OF_INTERRUPT, reg->drv2iop_doorbell_reg);
 		}
 		break;
 	}
@@ -2090,19 +2104,39 @@ static void arcmsr_clear_doorbell_queue_
 	}
 }
 
+static void arcmsr_enable_eoi_mode(struct AdapterControlBlock *acb)
+{
+	switch (acb->adapter_type) {
+	case ACB_ADAPTER_TYPE_A:
+		return;
+	case ACB_ADAPTER_TYPE_B:
+		{
+			struct MessageUnit_B *reg = acb->pmuB;
+			writel(ARCMSR_MESSAGE_ACTIVE_EOI_MODE, reg->drv2iop_doorbell_reg);
+			if(arcmsr_hbb_wait_msgint_ready(acb)) {
+				printk(KERN_NOTICE "ARCMSR IOP enables EOI_MODE TIMEOUT");
+				return;
+			}
+		}
+		break;
+	}
+	return;
+}
+
 static void arcmsr_iop_init(struct AdapterControlBlock *acb)
 {
 	uint32_t intmask_org;
 
-	arcmsr_wait_firmware_ready(acb);
-	arcmsr_iop_confirm(acb);
        /* disable all outbound interrupt */
        intmask_org = arcmsr_disable_outbound_ints(acb);
+	arcmsr_wait_firmware_ready(acb);
+	arcmsr_iop_confirm(acb);
 	arcmsr_get_firmware_spec(acb);
 	/*start background rebuild*/
 	arcmsr_start_adapter_bgrb(acb);
 	/* empty doorbell Qbuffer if door bell ringed */
 	arcmsr_clear_doorbell_queue_buffer(acb);
+	arcmsr_enable_eoi_mode(acb);
 	/* enable outbound Post Queue,outbound doorbell Interrupt */
 	arcmsr_enable_outbound_ints(acb, intmask_org);
 	acb->acb_flags |= ACB_F_IOP_INITED;
@@ -2275,6 +2309,7 @@ static pci_ers_result_t arcmsr_pci_slot_
 	arcmsr_start_adapter_bgrb(acb);
 	/* empty doorbell Qbuffer if door bell ringed */
 	arcmsr_clear_doorbell_queue_buffer(acb);
+	arcmsr_enable_eoi_mode(acb);
 	/* enable outbound Post Queue,outbound doorbell Interrupt */
 	arcmsr_enable_outbound_ints(acb, intmask_org);
 	acb->acb_flags |= ACB_F_IOP_INITED;
_
