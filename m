From: "nickcheng" <nick.cheng@areca.com.tw>
Subject: [PATCH] scsi: upstream arcmsr-1.20.00.15
Date: Thu, 10 Jan 2008 21:20:07 +0800
Message-ID: <000001c8538b$84f88c20$8800a8c0@Nick>
Reply-To: <nick.cheng@areca.com.tw>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0001_01C853CE.931BCC20"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 60-248-88-209.HINET-IP.hinet.net ([60.248.88.209]:22176 "EHLO
	areca.com.tw" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755573AbYAJNdk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Jan 2008 08:33:40 -0500
In-Reply-To: 
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Andrew Morton' <akpm@linux-foundation.org>, James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, randy.dunlap@oracle.com

This is a multi-part message in MIME format.

------=_NextPart_000_0001_01C853CE.931BCC20
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Subject: [PATCH] scsi: upstream arcmsr-1.20.00.15-71224
From: Nick Cheng <nick.cheng@areca.com.tw>
Description:
*** add arcmsr_enable_eoi_mode()and readl(reg->iop2drv_doorbell_reg) in
arcmsr_handle_hbb_isr() on adapter Type B in case of the doorbell interrupt
clearance is cached
*** add conditional declaration for arcmsr_pci_error_detected() and
arcmsr_pci_slot_reset
*** check if the sg list member number exceeds arcmsr default limit in
arcmsr_build_ccb() 
*** change the returned value type of arcmsr_build_ccb()from "void" to "int"
returns 	FAILED in arcmsr_queue_command()
*** modify arcmsr_drain_donequeue() to ignore unknown command and let kernel
process command timeout. This could handle IO request violating maximum
segments, i.e. Linux XFS over DM-CRYPT. Thanks to Milan Broz's comments
<mbroz@redhat.com>
*** fix the release of dma memory for type B in arcmsr_free_ccb_pool()
*** fix the arcmsr_polling_hbb_ccbdone() 
Signed-off-by: Nick Cheng <nick.cheng@areca.com.tw>

------=_NextPart_000_0001_01C853CE.931BCC20
Content-Type: application/octet-stream;
	name="patch4arcmsr"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="patch4arcmsr"

diff --git a/Documentation/scsi/ChangeLog.arcmsr =
b/Documentation/scsi/ChangeLog.arcmsr=0A=
index cd8403a..357b112 100644=0A=
--- a/Documentation/scsi/ChangeLog.arcmsr=0A=
+++ b/Documentation/scsi/ChangeLog.arcmsr=0A=
@@ -53,19 +53,60 @@=0A=
 **						for linux standard list=0A=
 **						enable usage of pci message signal interrupt=0A=
 **						follow Randy.Danlup kindness suggestion cleanup this code=0A=
-** 1.20.00.14   05/02/2007	 Erich Chen & Nick Cheng=0A=
+** 1.20.00.14   05/02/2007	 Erich Chen & Nick Cheng   	=0A=
 **						1.implement PCI-Express error recovery function and AER =
capability=0A=
-**						2.implement the selection of ARCMSR_MAX_XFER_SECTORS_B=3D4096=0A=
-**				 		if firmware version is newer than 1.42=0A=
-**						3.modify arcmsr_iop_reset to improve the ability=0A=
-**						4.modify the ISR, arcmsr_interrupt routine,to prevent the=0A=
-**						inconsistency with sg_mod driver if application	directly calls=0A=
-**						the arcmsr driver w/o passing through scsi mid layer=0A=
+**						2.implement the selection of ARCMSR_MAX_XFER_SECTORS_B=3D4096	=0A=
+**				 		if firmware version is newer than 1.42   			 =0A=
+**						3.modify arcmsr_iop_reset to improve the ability =0A=
+**						4.modify the ISR, arcmsr_interrupt routine,to prevent the       =
         =0A=
+**						inconsistency with sg_mod driver if application	directly calls		=0A=
+**						the arcmsr driver w/o passing through scsi mid layer	=0A=
 **						specially thanks to Yanmin Zhang's openhanded help about AER=0A=
 ** 1.20.00.15   08/30/2007	 Erich Chen & Nick Cheng=0A=
 **						1. support ARC1200/1201/1202 SATA RAID adapter, which is named=0A=
-**						ACB_ADAPTER_TYPE_B=0A=
+**						ACB_ADAPTER_TYPE_B =0A=
 **						2. modify the arcmsr_pci_slot_reset function=0A=
 **						3. modify the arcmsr_pci_ers_disconnect_forepart function=0A=
 **						4. modify the arcmsr_pci_ers_need_reset_forepart function=0A=
+** 1.20.00.15   09/27/2007	 Erich Chen & Nick Cheng=0A=
+**						1. add arcmsr_enable_eoi_mode() on adapter Type B=0A=
+** 						2. add readl(reg->iop2drv_doorbell_reg) in =
arcmsr_handle_hbb_isr()=0A=
+**						in case of the doorbell interrupt clearance is cached=0A=
+** 1.20.00.15   10/01/2007	 Erich Chen & Nick Cheng=0A=
+**						1. modify acb->devstate[i][j]=0A=
+**						as ARECA_RAID_GOOD instead of =0A=
+**						ARECA_RAID_GONE in arcmsr_alloc_ccb_pool=0A=
+** 1.20.00.15   11/06/2007       Erich Chen & Nick Cheng=0A=
+**						1. add conditional declaration for =0A=
+** 						arcmsr_pci_error_detected() and =0A=
+**						arcmsr_pci_slot_reset=0A=
+** 1.20.00.15	11/23/2007       Erich Chen & Nick Cheng=0A=
+**						1.check if the sg list member number =0A=
+**						exceeds arcmsr default limit in arcmsr_build_ccb()=0A=
+**						2.change the returned value type of arcmsr_build_ccb()=0A=
+**						from "void" to "int"=0A=
+**						3.add the conditional check if arcmsr_build_ccb()=0A=
+**						returns FAILED=0A=
+** 1.20.00.15	12/04/2007	 Erich Chen & Nick Cheng=0A=
+**						1. modify arcmsr_drain_donequeue() to ignore unknown =0A=
+**						command and let kernel process command timeout. =0A=
+**						This could handle IO request violating max. segments =0A=
+**						while Linux XFS over DM-CRYPT. =0A=
+**						Thanks to Milan Broz's comments <mbroz@redhat.com>=0A=
+** 1.20.00.15	12/24/2007	 Erich Chen & Nick Cheng=0A=
+**						1.fix the portability problems=0A=
+**						2.fix type B where we should _not_ iounmap() acb->pmu;=0A=
+**						it's not ioremapped.=0A=
+**						3.add return -ENOMEM if ioremap() fails=0A=
+**						4.transfer IS_SG64_ADDR w/ cpu_to_le32()=0A=
+**						in arcmsr_build_ccb=0A=
+**						5. modify acb->devstate[i][j] as ARECA_RAID_GONE instead of =0A=
+**						ARECA_RAID_GOOD in arcmsr_alloc_ccb_pool()=0A=
+**						6.fix arcmsr_cdb->Context as (unsigned long)arcmsr_cdb=0A=
+**						7.add the checking state of=0A=
+**						(outbound_intstatus & ARCMSR_MU_OUTBOUND_HANDLE_INT) =3D=3D 0=0A=
+**						in arcmsr_handle_hba_isr=0A=
+**						8.replace pci_alloc_consistent()/pci_free_consistent() with =
kmalloc()/kfree() in arcmsr_iop_message_xfer()=0A=
+**						9. fix the release of dma memory for type B in =
arcmsr_free_ccb_pool()=0A=
+**						10.fix the arcmsr_polling_hbb_ccbdone()=0A=
 =
*************************************************************************=
*=0A=
diff --git a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h=0A=
index a67e29f..5778650 100644=0A=
--- a/drivers/scsi/arcmsr/arcmsr.h=0A=
+++ b/drivers/scsi/arcmsr/arcmsr.h=0A=
@@ -48,7 +48,7 @@ struct class_device_attribute;=0A=
 /*The limit of outstanding scsi command that firmware can handle*/=0A=
 #define ARCMSR_MAX_OUTSTANDING_CMD						256=0A=
 #define ARCMSR_MAX_FREECCB_NUM							320=0A=
-#define ARCMSR_DRIVER_VERSION		     "Driver Version 1.20.00.15 =
2007/08/30"=0A=
+#define ARCMSR_DRIVER_VERSION		     "Driver Version 1.20.00.15 =
2007/12/24"=0A=
 #define ARCMSR_SCSI_INITIATOR_ID						255=0A=
 #define ARCMSR_MAX_XFER_SECTORS							512=0A=
 #define ARCMSR_MAX_XFER_SECTORS_B						4096=0A=
@@ -248,6 +248,7 @@ struct FIRMWARE_INFO=0A=
 #define ARCMSR_MESSAGE_START_BGRB		      0x00060008=0A=
 #define ARCMSR_MESSAGE_START_DRIVER_MODE	      0x000E0008=0A=
 #define ARCMSR_MESSAGE_SET_POST_WINDOW		      0x000F0008=0A=
+#define ARCMSR_MESSAGE_ACTIVE_EOI_MODE		    0x00100008=0A=
 /* ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK */=0A=
 #define ARCMSR_MESSAGE_FIRMWARE_OK		      0x80000000=0A=
 /* ioctl transfer */=0A=
@@ -256,6 +257,7 @@ struct FIRMWARE_INFO=0A=
 #define ARCMSR_DRV2IOP_DATA_READ_OK                   0x00000002=0A=
 #define ARCMSR_DRV2IOP_CDB_POSTED                     0x00000004=0A=
 #define ARCMSR_DRV2IOP_MESSAGE_CMD_POSTED             0x00000008=0A=
+#define ARCMSR_DRV2IOP_END_OF_INTERRUPT		0x00000010=0A=
 =0A=
 /* data tunnel buffer between user space program and its firmware */=0A=
 /* user space data to iop 128bytes */=0A=
diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c =
b/drivers/scsi/arcmsr/arcmsr_hba.c=0A=
index d466a2d..3ca1fe7 100644=0A=
--- a/drivers/scsi/arcmsr/arcmsr_hba.c=0A=
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c=0A=
@@ -316,9 +316,6 @@ static int arcmsr_alloc_ccb_pool(struct =
AdapterControlBlock *acb)=0A=
 				(0x20 - ((unsigned long)dma_coherent_handle & 0x1F));=0A=
 		}=0A=
 =0A=
-		reg =3D (struct MessageUnit_B *)(dma_coherent +=0A=
-		ARCMSR_MAX_FREECCB_NUM * sizeof(struct CommandControlBlock));=0A=
-=0A=
 		dma_addr =3D dma_coherent_handle;=0A=
 		ccb_tmp =3D (struct CommandControlBlock *)dma_coherent;=0A=
 		for (i =3D 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {=0A=
@@ -372,8 +369,8 @@ static int arcmsr_alloc_ccb_pool(struct =
AdapterControlBlock *acb)=0A=
 =0A=
 out:=0A=
 	dma_free_coherent(&acb->pdev->dev,=0A=
-		ARCMSR_MAX_FREECCB_NUM * sizeof(struct CommandControlBlock) + 0x20,=0A=
-		acb->dma_coherent, acb->dma_coherent_handle);=0A=
+		(ARCMSR_MAX_FREECCB_NUM * sizeof(struct CommandControlBlock) + 0x20 +=0A=
+		sizeof(struct MessageUnit_B)), acb->dma_coherent, =
acb->dma_coherent_handle);=0A=
 	return -ENOMEM;=0A=
 }=0A=
 =0A=
@@ -510,6 +507,7 @@ static uint8_t arcmsr_hbb_wait_msgint_ready(struct =
AdapterControlBlock *acb)=0A=
 				& ARCMSR_IOP2DRV_MESSAGE_CMD_DONE) {=0A=
 				writel(ARCMSR_MESSAGE_INT_CLEAR_PATTERN=0A=
 					, reg->iop2drv_doorbell_reg);=0A=
+				writel(ARCMSR_DRV2IOP_END_OF_INTERRUPT, reg->drv2iop_doorbell_reg);=0A=
 				return 0x00;=0A=
 			}=0A=
 			msleep(10);=0A=
@@ -749,6 +747,7 @@ static void arcmsr_drain_donequeue(struct =
AdapterControlBlock *acb, uint32_t fla=0A=
 				, ccb->startdone=0A=
 				, atomic_read(&acb->ccboutstandingcount));=0A=
 		}=0A=
+	else=0A=
 	arcmsr_report_ccb_state(acb, ccb, flag_ccb);=0A=
 }=0A=
 =0A=
@@ -887,7 +886,7 @@ static void arcmsr_enable_outbound_ints(struct =
AdapterControlBlock *acb, \=0A=
 	}=0A=
 }=0A=
 =0A=
-static void arcmsr_build_ccb(struct AdapterControlBlock *acb,=0A=
+static int arcmsr_build_ccb(struct AdapterControlBlock *acb,=0A=
 	struct CommandControlBlock *ccb, struct scsi_cmnd *pcmd)=0A=
 {=0A=
 	struct ARCMSR_CDB *arcmsr_cdb =3D (struct ARCMSR_CDB =
*)&ccb->arcmsr_cdb;=0A=
@@ -907,6 +906,8 @@ static void arcmsr_build_ccb(struct =
AdapterControlBlock *acb,=0A=
 	memcpy(arcmsr_cdb->Cdb, pcmd->cmnd, pcmd->cmd_len);=0A=
 =0A=
 	nseg =3D scsi_dma_map(pcmd);=0A=
+	if (nseg > ARCMSR_MAX_SG_ENTRIES)=0A=
+		return FAILED;=0A=
 	BUG_ON(nseg < 0);=0A=
 =0A=
 	if (nseg) {=0A=
@@ -947,6 +948,7 @@ static void arcmsr_build_ccb(struct =
AdapterControlBlock *acb,=0A=
 		arcmsr_cdb->Flags |=3D ARCMSR_CDB_FLAG_WRITE;=0A=
 		ccb->ccb_flags |=3D CCB_FLAG_WRITE;=0A=
 	}=0A=
+	return SUCCESS;=0A=
 }=0A=
 =0A=
 static void arcmsr_post_ccb(struct AdapterControlBlock *acb, struct =
CommandControlBlock *ccb)=0A=
@@ -1037,18 +1039,22 @@ static void arcmsr_free_ccb_pool(struct =
AdapterControlBlock *acb)=0A=
 	switch (acb->adapter_type) {=0A=
 	case ACB_ADAPTER_TYPE_A: {=0A=
 		iounmap(acb->pmuA);=0A=
+		dma_free_coherent(&acb->pdev->dev,=0A=
+		ARCMSR_MAX_FREECCB_NUM * sizeof (struct CommandControlBlock) + 0x20,=0A=
+		acb->dma_coherent,=0A=
+		acb->dma_coherent_handle);=0A=
 		break;=0A=
 	}=0A=
 	case ACB_ADAPTER_TYPE_B: {=0A=
 		struct MessageUnit_B *reg =3D acb->pmuB;=0A=
 		iounmap(reg->drv2iop_doorbell_reg - ARCMSR_DRV2IOP_DOORBELL);=0A=
 		iounmap(reg->ioctl_wbuffer_reg - ARCMSR_IOCTL_WBUFFER);=0A=
+		dma_free_coherent(&acb->pdev->dev,=0A=
+		(ARCMSR_MAX_FREECCB_NUM * sizeof(struct CommandControlBlock) + 0x20 +=0A=
+		sizeof(struct MessageUnit_B)), acb->dma_coherent, =
acb->dma_coherent_handle);=0A=
 	}=0A=
 	}=0A=
-	dma_free_coherent(&acb->pdev->dev,=0A=
-		ARCMSR_MAX_FREECCB_NUM * sizeof (struct CommandControlBlock) + 0x20,=0A=
-		acb->dma_coherent,=0A=
-		acb->dma_coherent_handle);=0A=
+=0A=
 }=0A=
 =0A=
 void arcmsr_iop_message_read(struct AdapterControlBlock *acb)=0A=
@@ -1274,7 +1280,9 @@ static int arcmsr_handle_hbb_isr(struct =
AdapterControlBlock *acb)=0A=
 		return 1;=0A=
 =0A=
 	writel(~outbound_doorbell, reg->iop2drv_doorbell_reg);=0A=
-=0A=
+	/*in case the last action of doorbell interrupt clearance is cached, =
this action can push HW to write down the clear bit*/=0A=
+	readl(reg->iop2drv_doorbell_reg);=0A=
+	writel(ARCMSR_DRV2IOP_END_OF_INTERRUPT, reg->drv2iop_doorbell_reg);=0A=
 	if (outbound_doorbell & ARCMSR_IOP2DRV_DATA_WRITE_OK) 	{=0A=
 		arcmsr_iop2drv_data_wrote_handle(acb);=0A=
 	}=0A=
@@ -1381,12 +1389,13 @@ static int arcmsr_iop_message_xfer(struct =
AdapterControlBlock *acb, \=0A=
 =0A=
 	case ARCMSR_MESSAGE_READ_RQBUFFER: {=0A=
 		unsigned long *ver_addr;=0A=
-		dma_addr_t buf_handle;=0A=
 		uint8_t *pQbuffer, *ptmpQbuffer;=0A=
 		int32_t allxfer_len =3D 0;=0A=
+		void *tmp;=0A=
 =0A=
-		ver_addr =3D pci_alloc_consistent(acb->pdev, 1032, &buf_handle);=0A=
-		if (!ver_addr) {=0A=
+		tmp =3D kmalloc(1032, GFP_KERNEL|GFP_DMA);=0A=
+		ver_addr =3D (unsigned long *)tmp;=0A=
+		if (!tmp) {=0A=
 			retvalue =3D ARCMSR_MESSAGE_FAIL;=0A=
 			goto message_out;=0A=
 		}=0A=
@@ -1422,18 +1431,19 @@ static int arcmsr_iop_message_xfer(struct =
AdapterControlBlock *acb, \=0A=
 		memcpy(pcmdmessagefld->messagedatabuffer, (uint8_t *)ver_addr, =
allxfer_len);=0A=
 		pcmdmessagefld->cmdmessage.Length =3D allxfer_len;=0A=
 		pcmdmessagefld->cmdmessage.ReturnCode =3D =
ARCMSR_MESSAGE_RETURNCODE_OK;=0A=
-		pci_free_consistent(acb->pdev, 1032, ver_addr, buf_handle);=0A=
+		kfree(tmp);=0A=
 		}=0A=
 		break;=0A=
 =0A=
 	case ARCMSR_MESSAGE_WRITE_WQBUFFER: {=0A=
 		unsigned long *ver_addr;=0A=
-		dma_addr_t buf_handle;=0A=
 		int32_t my_empty_len, user_len, wqbuf_firstindex, wqbuf_lastindex;=0A=
 		uint8_t *pQbuffer, *ptmpuserbuffer;=0A=
-=0A=
-		ver_addr =3D pci_alloc_consistent(acb->pdev, 1032, &buf_handle);=0A=
-		if (!ver_addr) {=0A=
+		void *tmp;=0A=
+		=0A=
+		tmp =3D kmalloc(1032, GFP_KERNEL|GFP_DMA);=0A=
+		ver_addr =3D (unsigned long *)tmp;=0A=
+		if (!tmp) {=0A=
 			retvalue =3D ARCMSR_MESSAGE_FAIL;=0A=
 			goto message_out;=0A=
 		}=0A=
@@ -1483,7 +1493,7 @@ static int arcmsr_iop_message_xfer(struct =
AdapterControlBlock *acb, \=0A=
 				retvalue =3D ARCMSR_MESSAGE_FAIL;=0A=
 			}=0A=
 			}=0A=
-			pci_free_consistent(acb->pdev, 1032, ver_addr, buf_handle);=0A=
+			kfree(tmp);=0A=
 		}=0A=
 		break;=0A=
 =0A=
@@ -1683,8 +1693,11 @@ static int arcmsr_queue_command(struct scsi_cmnd =
*cmd,=0A=
 	ccb =3D arcmsr_get_freeccb(acb);=0A=
 	if (!ccb)=0A=
 		return SCSI_MLQUEUE_HOST_BUSY;=0A=
-=0A=
-	arcmsr_build_ccb(acb, ccb, cmd);=0A=
+	if ( arcmsr_build_ccb( acb, ccb, cmd ) =3D=3D FAILED ) {=0A=
+		cmd->result =3D (DID_ERROR << 16) | (RESERVATION_CONFLICT << 1);=0A=
+		cmd->scsi_done(cmd);=0A=
+		return 0;=0A=
+	}=0A=
 	arcmsr_post_ccb(acb, ccb);=0A=
 	return 0;=0A=
 }=0A=
@@ -1845,7 +1858,7 @@ static void arcmsr_polling_hba_ccbdone(struct =
AdapterControlBlock *acb,=0A=
 	}=0A=
 }=0A=
 =0A=
-static void arcmsr_polling_hbb_ccbdone(struct AdapterControlBlock *acb, =
\=0A=
+static void arcmsr_polling_hbb_ccbdone(struct AdapterControlBlock *acb,=0A=
 					struct CommandControlBlock *poll_ccb)=0A=
 {=0A=
 		struct MessageUnit_B *reg =3D acb->pmuB;=0A=
@@ -1879,7 +1892,7 @@ static void arcmsr_polling_hbb_ccbdone(struct =
AdapterControlBlock *acb, \=0A=
       (acb->vir2phy_offset + (flag_ccb << 5));/*frame must be 32 bytes =
aligned*/=0A=
 			poll_ccb_done =3D (ccb =3D=3D poll_ccb) ? 1:0;=0A=
 			if ((ccb->acb !=3D acb) || (ccb->startdone !=3D ARCMSR_CCB_START)) {=0A=
-				if (ccb->startdone =3D=3D ARCMSR_CCB_ABORTED) {=0A=
+				if ((ccb->startdone =3D=3D ARCMSR_CCB_ABORTED) || (ccb =3D=3D =
poll_ccb)) {=0A=
 					printk(KERN_NOTICE "arcmsr%d: \=0A=
 		scsi id =3D %d lun =3D %d ccb =3D '0x%p' poll command abort =
successfully \n"=0A=
 						,acb->host->host_no=0A=
@@ -1902,7 +1915,7 @@ static void arcmsr_polling_hbb_ccbdone(struct =
AdapterControlBlock *acb, \=0A=
 		}	/*drain reply FIFO*/=0A=
 }=0A=
 =0A=
-static void arcmsr_polling_ccbdone(struct AdapterControlBlock *acb, \=0A=
+static void arcmsr_polling_ccbdone(struct AdapterControlBlock *acb,=0A=
 					struct CommandControlBlock *poll_ccb)=0A=
 {=0A=
 	switch (acb->adapter_type) {=0A=
@@ -2027,6 +2040,7 @@ static void arcmsr_wait_firmware_ready(struct =
AdapterControlBlock *acb)=0A=
 		do {=0A=
 			firmware_state =3D readl(reg->iop2drv_doorbell_reg);=0A=
 		} while ((firmware_state & ARCMSR_MESSAGE_FIRMWARE_OK) =3D=3D 0);=0A=
+		writel(ARCMSR_DRV2IOP_END_OF_INTERRUPT, reg->drv2iop_doorbell_reg);=0A=
 		}=0A=
 		break;=0A=
 	}=0A=
@@ -2091,19 +2105,39 @@ static void =
arcmsr_clear_doorbell_queue_buffer(struct AdapterControlBlock *acb)=0A=
 	}=0A=
 }=0A=
 =0A=
+static void arcmsr_enable_eoi_mode(struct AdapterControlBlock *acb)=0A=
+{=0A=
+	switch (acb->adapter_type) {=0A=
+	case ACB_ADAPTER_TYPE_A:=0A=
+		return;=0A=
+	case ACB_ADAPTER_TYPE_B:=0A=
+		{=0A=
+			struct MessageUnit_B *reg =3D acb->pmuB;=0A=
+			writel(ARCMSR_MESSAGE_ACTIVE_EOI_MODE, reg->drv2iop_doorbell_reg);=0A=
+			if(arcmsr_hbb_wait_msgint_ready(acb)) {=0A=
+				printk(KERN_NOTICE "ARCMSR IOP enables EOI_MODE TIMEOUT");=0A=
+				return;=0A=
+			}=0A=
+		}=0A=
+		break;=0A=
+	}=0A=
+	return;=0A=
+}=0A=
+=0A=
 static void arcmsr_iop_init(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	uint32_t intmask_org;=0A=
 =0A=
-	arcmsr_wait_firmware_ready(acb);=0A=
-	arcmsr_iop_confirm(acb);=0A=
        /* disable all outbound interrupt */=0A=
        intmask_org =3D arcmsr_disable_outbound_ints(acb);=0A=
+	arcmsr_wait_firmware_ready(acb);=0A=
+	arcmsr_iop_confirm(acb);=0A=
 	arcmsr_get_firmware_spec(acb);=0A=
 	/*start background rebuild*/=0A=
 	arcmsr_start_adapter_bgrb(acb);=0A=
 	/* empty doorbell Qbuffer if door bell ringed */=0A=
 	arcmsr_clear_doorbell_queue_buffer(acb);=0A=
+	arcmsr_enable_eoi_mode(acb);=0A=
 	/* enable outbound Post Queue,outbound doorbell Interrupt */=0A=
 	arcmsr_enable_outbound_ints(acb, intmask_org);=0A=
 	acb->acb_flags |=3D ACB_F_IOP_INITED;=0A=
@@ -2276,6 +2310,7 @@ static pci_ers_result_t =
arcmsr_pci_slot_reset(struct pci_dev *pdev)=0A=
 	arcmsr_start_adapter_bgrb(acb);=0A=
 	/* empty doorbell Qbuffer if door bell ringed */=0A=
 	arcmsr_clear_doorbell_queue_buffer(acb);=0A=
+	arcmsr_enable_eoi_mode(acb);=0A=
 	/* enable outbound Post Queue,outbound doorbell Interrupt */=0A=
 	arcmsr_enable_outbound_ints(acb, intmask_org);=0A=
 	acb->acb_flags |=3D ACB_F_IOP_INITED;=0A=

------=_NextPart_000_0001_01C853CE.931BCC20--

