From: =?utf-8?B?bmlja2NoZW5nKOmEreWuiOismSk=?= <nick.cheng@areca.com.tw>
Subject: RE: [PATCH] scsi: improve areca driver stability and compatibility
Date: Wed, 6 Jun 2007 10:56:52 +0800
Message-ID: <000001c7a7e6$56efeef0$5e00a8c0@51091008491>
Reply-To: <nick.cheng@areca.com.tw>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0001_01C7A829.65132EF0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.areca.com.tw ([220.130.178.143]:3673 "EHLO areca.com.tw"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751000AbXFFC5A (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Jun 2007 22:57:00 -0400
In-Reply-To: 
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Andrew Morton' <akpm@linux-foundation.org>, James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_0001_01C7A829.65132EF0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Subject: [PATCH] scsi: improve areca driver stability and compatibility
   =20
From: Nick Cheng <nick.cheng@areca.com.tw>
   =20
Description:
    1. Implement PCI-Express error recovery function and AER capability
    2. Implement the selection of ARCMSR_MAX_XFER_SECTORS_B=3D4096 if =
firmware version is latter than 1.42
    3. Add arcmsr_done4_abort_postqueue in arcmsr_iop_reset function to =
improve the stability as hot-unplug/plug
    4. Modify the ISR, arcmsr_interrupt routine, to prevent the =
inconsistency with sg_mod driver if application directly calls the =
arcmsr driver w/o passing through scsi midlayer specially thanks to =
Yanmin Zhang's openhanded help about AER
   =20
Signed-off-by: Nick Cheng <nick.cheng@areca.com.tw>

------=_NextPart_000_0001_01C7A829.65132EF0
Content-Type: application/octet-stream;
	name="patch4_arcmsr1200014"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="patch4_arcmsr1200014"

commit 5069c89d0dc855470759db891deabb08eb9c88ec=0A=
Author: root <root@localhost.localdomain>=0A=
Date:   Tue Jun 5 16:21:35 2007 +0800=0A=
=0A=
    Subject: [PATCH] scsi: improve areca driver stability and =
compatibility=0A=
    =0A=
    From: Nick Cheng <nick.cheng@areca.com.tw>=0A=
    =0A=
    Description:=0A=
    1.implement PCI-Express error recovery function and AER capability=0A=
    2.implement the selection of ARCMSR_MAX_XFER_SECTORS_B=3D4096 if =0A=
	firmware version is latter than 1.42=0A=
    3.add arcmsr_done4_abort_postqueue in arcmsr_iop_reset function to =
improve=0A=
	the stability as hot-unplug/plug=0A=
    4.modify the ISR, arcmsr_interrupt routine,to prevent the =
inconsistency =0A=
	with sg_mod driver if application directly calls the arcmsr driver =0A=
	w/o passing through scsi mid layer =0A=
	specially thanks to Yanmin Zhang's openhanded help about AER=0A=
    =0A=
    Signed-off-by: Nick Cheng <nick.cheng@areca.com.tw>=0A=
=0A=
diff --git a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h=0A=
index aff96db..b51bbe1 100644=0A=
--- a/drivers/scsi/arcmsr/arcmsr.h=0A=
+++ b/drivers/scsi/arcmsr/arcmsr.h=0A=
@@ -48,9 +48,10 @@ struct class_device_attribute;=0A=
 =0A=
 #define ARCMSR_MAX_OUTSTANDING_CMD 						256=0A=
 #define ARCMSR_MAX_FREECCB_NUM							288=0A=
-#define ARCMSR_DRIVER_VERSION				"Driver Version 1.20.00.13"=0A=
+#define ARCMSR_DRIVER_VERSION				"Driver Version 1.20.00.14"=0A=
 #define ARCMSR_SCSI_INITIATOR_ID						255=0A=
 #define ARCMSR_MAX_XFER_SECTORS							512=0A=
+#define ARCMSR_MAX_XFER_SECTORS_B                                       =
       4096=0A=
 #define ARCMSR_MAX_TARGETID							 17=0A=
 #define ARCMSR_MAX_TARGETLUN							  8=0A=
 #define ARCMSR_MAX_CMD_PERLUN				 ARCMSR_MAX_OUTSTANDING_CMD=0A=
diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c =
b/drivers/scsi/arcmsr/arcmsr_hba.c=0A=
index 8b46158..a465c08 100644=0A=
--- a/drivers/scsi/arcmsr/arcmsr_hba.c=0A=
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c=0A=
@@ -57,6 +57,7 @@=0A=
 #include <linux/dma-mapping.h>=0A=
 #include <linux/timer.h>=0A=
 #include <linux/pci.h>=0A=
+#include <linux/aer.h>=0A=
 #include <asm/dma.h>=0A=
 #include <asm/io.h>=0A=
 #include <asm/system.h>=0A=
@@ -71,7 +72,7 @@=0A=
 #include "arcmsr.h"=0A=
 =0A=
 MODULE_AUTHOR("Erich Chen <erich@areca.com.tw>");=0A=
-MODULE_DESCRIPTION("ARECA (ARC11xx/12xx) SATA RAID HOST Adapter");=0A=
+MODULE_DESCRIPTION("ARECA (ARC11xx/12xx/13xx/16xx) SATA/SAS RAID HOST =
Adapter");=0A=
 MODULE_LICENSE("Dual BSD/GPL");=0A=
 MODULE_VERSION(ARCMSR_DRIVER_VERSION);=0A=
 =0A=
@@ -93,7 +94,9 @@ static void arcmsr_flush_adapter_cache(struct =
AdapterControlBlock *acb);=0A=
 static uint8_t arcmsr_wait_msgint_ready(struct AdapterControlBlock =
*acb);=0A=
 static const char *arcmsr_info(struct Scsi_Host *);=0A=
 static irqreturn_t arcmsr_interrupt(struct AdapterControlBlock *acb);=0A=
-=0A=
+static pci_ers_result_t arcmsr_pci_error_detected(struct pci_dev *pdev, =0A=
+						pci_channel_state_t state);=0A=
+static pci_ers_result_t arcmsr_pci_slot_reset(struct pci_dev *pdev);=0A=
 static int arcmsr_adjust_disk_queue_depth(struct scsi_device *sdev, int =
queue_depth)=0A=
 {=0A=
 	if (queue_depth > ARCMSR_MAX_CMD_PERLUN)=0A=
@@ -104,7 +107,8 @@ static int arcmsr_adjust_disk_queue_depth(struct =
scsi_device *sdev, int queue_de=0A=
 =0A=
 static struct scsi_host_template arcmsr_scsi_host_template =3D {=0A=
 	.module			=3D THIS_MODULE,=0A=
-	.name			=3D "ARCMSR ARECA SATA RAID HOST Adapter" =
ARCMSR_DRIVER_VERSION,=0A=
+	.name			=3D "ARCMSR ARECA SATA/SAS RAID HOST Adapter" =0A=
+							ARCMSR_DRIVER_VERSION,=0A=
 	.info			=3D arcmsr_info,=0A=
 	.queuecommand		=3D arcmsr_queue_command,=0A=
 	.eh_abort_handler	=3D arcmsr_abort,=0A=
@@ -119,6 +123,10 @@ static struct scsi_host_template =
arcmsr_scsi_host_template =3D {=0A=
 	.use_clustering		=3D ENABLE_CLUSTERING,=0A=
 	.shost_attrs		=3D arcmsr_host_attrs,=0A=
 };=0A=
+static struct pci_error_handlers arcmsr_pci_error_handlers=3D{=0A=
+        .error_detected         =3D arcmsr_pci_error_detected,=0A=
+        .slot_reset             =3D arcmsr_pci_slot_reset,=0A=
+};=0A=
 =0A=
 static struct pci_device_id arcmsr_device_id_table[] =3D {=0A=
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1110)},=0A=
@@ -144,7 +152,8 @@ static struct pci_driver arcmsr_pci_driver =3D {=0A=
 	.id_table		=3D arcmsr_device_id_table,=0A=
 	.probe			=3D arcmsr_probe,=0A=
 	.remove			=3D arcmsr_remove,=0A=
-	.shutdown		=3D arcmsr_shutdown=0A=
+	.shutdown		=3D arcmsr_shutdown,=0A=
+	.err_handler            =3D &arcmsr_pci_error_handlers,=0A=
 };=0A=
 =0A=
 static irqreturn_t arcmsr_do_interrupt(int irq, void *dev_id)=0A=
@@ -328,6 +337,8 @@ static int arcmsr_probe(struct pci_dev *pdev,=0A=
 =0A=
 	arcmsr_iop_init(acb);=0A=
 	pci_set_drvdata(pdev, host);=0A=
+	if (strncmp(acb->firm_version,"V1.42",5) >=3D 0)=0A=
+        	host->max_sectors=3DARCMSR_MAX_XFER_SECTORS_B;=0A=
 =0A=
 	error =3D scsi_add_host(host, &pdev->dev);=0A=
 	if (error)=0A=
@@ -338,6 +349,7 @@ static int arcmsr_probe(struct pci_dev *pdev,=0A=
 		goto out_free_sysfs;=0A=
 =0A=
 	scsi_scan_host(host);=0A=
+	pci_enable_pcie_error_reporting(pdev);=0A=
 	return 0;=0A=
  out_free_sysfs:=0A=
  out_free_irq:=0A=
@@ -369,19 +381,9 @@ static void arcmsr_abort_allcmd(struct =
AdapterControlBlock *acb)=0A=
 =0A=
 static void arcmsr_pci_unmap_dma(struct CommandControlBlock *ccb)=0A=
 {=0A=
-	struct AdapterControlBlock *acb =3D ccb->acb;=0A=
 	struct scsi_cmnd *pcmd =3D ccb->pcmd;=0A=
 =0A=
-	if (pcmd->use_sg !=3D 0) {=0A=
-		struct scatterlist *sl;=0A=
-=0A=
-		sl =3D (struct scatterlist *)pcmd->request_buffer;=0A=
-		pci_unmap_sg(acb->pdev, sl, pcmd->use_sg, pcmd->sc_data_direction);=0A=
-	}=0A=
-	else if (pcmd->request_bufflen !=3D 0)=0A=
-		pci_unmap_single(acb->pdev,=0A=
-			pcmd->SCp.dma_handle,=0A=
-			pcmd->request_bufflen, pcmd->sc_data_direction);=0A=
+	scsi_dma_unmap(pcmd);=0A=
 }=0A=
 =0A=
 static void arcmsr_ccb_complete(struct CommandControlBlock *ccb, int =
stand_flag)=0A=
@@ -551,6 +553,7 @@ static void arcmsr_build_ccb(struct =
AdapterControlBlock *acb,=0A=
 	int8_t *psge =3D (int8_t *)&arcmsr_cdb->u;=0A=
 	uint32_t address_lo, address_hi;=0A=
 	int arccdbsize =3D 0x30;=0A=
+	int nseg;=0A=
 =0A=
 	ccb->pcmd =3D pcmd;=0A=
 	memset(arcmsr_cdb, 0, sizeof (struct ARCMSR_CDB));=0A=
@@ -561,20 +564,20 @@ static void arcmsr_build_ccb(struct =
AdapterControlBlock *acb,=0A=
 	arcmsr_cdb->CdbLength =3D (uint8_t)pcmd->cmd_len;=0A=
 	arcmsr_cdb->Context =3D (unsigned long)arcmsr_cdb;=0A=
 	memcpy(arcmsr_cdb->Cdb, pcmd->cmnd, pcmd->cmd_len);=0A=
-	if (pcmd->use_sg) {=0A=
-		int length, sgcount, i, cdb_sgcount =3D 0;=0A=
-		struct scatterlist *sl;=0A=
-=0A=
-		/* Get Scatter Gather List from scsiport. */=0A=
-		sl =3D (struct scatterlist *) pcmd->request_buffer;=0A=
-		sgcount =3D pci_map_sg(acb->pdev, sl, pcmd->use_sg,=0A=
-				pcmd->sc_data_direction);=0A=
+=0A=
+	nseg =3D scsi_dma_map(pcmd);=0A=
+	BUG_ON(nseg < 0);=0A=
+=0A=
+	if (nseg) {=0A=
+		int length, i, cdb_sgcount =3D 0;=0A=
+		struct scatterlist *sg;=0A=
+=0A=
 		/* map stor port SG list to our iop SG List. */=0A=
-		for (i =3D 0; i < sgcount; i++) {=0A=
+		scsi_for_each_sg(pcmd, sg, nseg, i) {=0A=
 			/* Get the physical address of the current data pointer */=0A=
-			length =3D cpu_to_le32(sg_dma_len(sl));=0A=
-			address_lo =3D cpu_to_le32(dma_addr_lo32(sg_dma_address(sl)));=0A=
-			address_hi =3D cpu_to_le32(dma_addr_hi32(sg_dma_address(sl)));=0A=
+			length =3D cpu_to_le32(sg_dma_len(sg));=0A=
+			address_lo =3D cpu_to_le32(dma_addr_lo32(sg_dma_address(sg)));=0A=
+			address_hi =3D cpu_to_le32(dma_addr_hi32(sg_dma_address(sg)));=0A=
 			if (address_hi =3D=3D 0) {=0A=
 				struct SG32ENTRY *pdma_sg =3D (struct SG32ENTRY *)psge;=0A=
 =0A=
@@ -591,32 +594,12 @@ static void arcmsr_build_ccb(struct =
AdapterControlBlock *acb,=0A=
 				psge +=3D sizeof (struct SG64ENTRY);=0A=
 				arccdbsize +=3D sizeof (struct SG64ENTRY);=0A=
 			}=0A=
-			sl++;=0A=
 			cdb_sgcount++;=0A=
 		}=0A=
 		arcmsr_cdb->sgcount =3D (uint8_t)cdb_sgcount;=0A=
-		arcmsr_cdb->DataLength =3D pcmd->request_bufflen;=0A=
+		arcmsr_cdb->DataLength =3D scsi_bufflen(pcmd);=0A=
 		if ( arccdbsize > 256)=0A=
 			arcmsr_cdb->Flags |=3D ARCMSR_CDB_FLAG_SGL_BSIZE;=0A=
-	} else if (pcmd->request_bufflen) {=0A=
-		dma_addr_t dma_addr;=0A=
-		dma_addr =3D pci_map_single(acb->pdev, pcmd->request_buffer,=0A=
-				pcmd->request_bufflen, pcmd->sc_data_direction);=0A=
-		pcmd->SCp.dma_handle =3D dma_addr;=0A=
-		address_lo =3D cpu_to_le32(dma_addr_lo32(dma_addr));=0A=
-		address_hi =3D cpu_to_le32(dma_addr_hi32(dma_addr));=0A=
-		if (address_hi =3D=3D 0) {=0A=
-			struct  SG32ENTRY *pdma_sg =3D (struct SG32ENTRY *)psge;=0A=
-			pdma_sg->address =3D address_lo;=0A=
-			pdma_sg->length =3D pcmd->request_bufflen;=0A=
-		} else {=0A=
-			struct SG64ENTRY *pdma_sg =3D (struct SG64ENTRY *)psge;=0A=
-			pdma_sg->addresshigh =3D address_hi;=0A=
-			pdma_sg->address =3D address_lo;=0A=
-			pdma_sg->length =3D pcmd->request_bufflen|IS_SG64_ADDR;=0A=
-		}=0A=
-		arcmsr_cdb->sgcount =3D 1;=0A=
-		arcmsr_cdb->DataLength =3D pcmd->request_bufflen;=0A=
 	}=0A=
 	if (pcmd->sc_data_direction =3D=3D DMA_TO_DEVICE ) {=0A=
 		arcmsr_cdb->Flags |=3D ARCMSR_CDB_FLAG_WRITE;=0A=
@@ -791,7 +774,7 @@ static irqreturn_t arcmsr_interrupt(struct =
AdapterControlBlock *acb)=0A=
 				switch(ccb->arcmsr_cdb.DeviceStatus) {=0A=
 				case ARCMSR_DEV_SELECT_TIMEOUT: {=0A=
 						acb->devstate[id][lun] =3D ARECA_RAID_GONE;=0A=
-						ccb->pcmd->result =3D DID_TIME_OUT << 16;=0A=
+						ccb->pcmd->result =3D DID_NO_CONNECT << 16;=0A=
 						arcmsr_ccb_complete(ccb, 1);=0A=
 					}=0A=
 					break;=0A=
@@ -848,24 +831,21 @@ static int arcmsr_iop_message_xfer(struct =
AdapterControlBlock *acb, struct scsi_=0A=
 	struct CMD_MESSAGE_FIELD *pcmdmessagefld;=0A=
 	int retvalue =3D 0, transfer_len =3D 0;=0A=
 	char *buffer;=0A=
+	struct scatterlist *sg;=0A=
 	uint32_t controlcode =3D (uint32_t ) cmd->cmnd[5] << 24 |=0A=
 						(uint32_t ) cmd->cmnd[6] << 16 |=0A=
 						(uint32_t ) cmd->cmnd[7] << 8  |=0A=
 						(uint32_t ) cmd->cmnd[8];=0A=
 					/* 4 bytes: Areca io control code */=0A=
-	if (cmd->use_sg) {=0A=
-		struct scatterlist *sg =3D (struct scatterlist *)cmd->request_buffer;=0A=
 =0A=
-		buffer =3D kmap_atomic(sg->page, KM_IRQ0) + sg->offset;=0A=
-		if (cmd->use_sg > 1) {=0A=
-			retvalue =3D ARCMSR_MESSAGE_FAIL;=0A=
-			goto message_out;=0A=
-		}=0A=
-		transfer_len +=3D sg->length;=0A=
-	} else {=0A=
-		buffer =3D cmd->request_buffer;=0A=
-		transfer_len =3D cmd->request_bufflen;=0A=
+	sg =3D scsi_sglist(cmd);=0A=
+	buffer =3D kmap_atomic(sg->page, KM_IRQ0) + sg->offset;=0A=
+	if (scsi_sg_count(cmd) > 1) {=0A=
+		retvalue =3D ARCMSR_MESSAGE_FAIL;=0A=
+		goto message_out;=0A=
 	}=0A=
+	transfer_len +=3D sg->length;=0A=
+=0A=
 	if (transfer_len > sizeof(struct CMD_MESSAGE_FIELD)) {=0A=
 		retvalue =3D ARCMSR_MESSAGE_FAIL;=0A=
 		goto message_out;=0A=
@@ -1057,12 +1037,9 @@ static int arcmsr_iop_message_xfer(struct =
AdapterControlBlock *acb, struct scsi_=0A=
 		retvalue =3D ARCMSR_MESSAGE_FAIL;=0A=
 	}=0A=
  message_out:=0A=
-	if (cmd->use_sg) {=0A=
-		struct scatterlist *sg;=0A=
+	sg =3D scsi_sglist(cmd);=0A=
+	kunmap_atomic(buffer - sg->offset, KM_IRQ0);=0A=
 =0A=
-		sg =3D (struct scatterlist *) cmd->request_buffer;=0A=
-		kunmap_atomic(buffer - sg->offset, KM_IRQ0);=0A=
-	}=0A=
 	return retvalue;=0A=
 }=0A=
 =0A=
@@ -1085,6 +1062,7 @@ static void arcmsr_handle_virtual_command(struct =
AdapterControlBlock *acb,=0A=
 	case INQUIRY: {=0A=
 		unsigned char inqdata[36];=0A=
 		char *buffer;=0A=
+		struct scatterlist *sg;=0A=
 =0A=
 		if (cmd->device->lun) {=0A=
 			cmd->result =3D (DID_TIME_OUT << 16);=0A=
@@ -1104,21 +1082,14 @@ static void arcmsr_handle_virtual_command(struct =
AdapterControlBlock *acb,=0A=
 		strncpy(&inqdata[16], "RAID controller ", 16);=0A=
 		/* Product Identification */=0A=
 		strncpy(&inqdata[32], "R001", 4); /* Product Revision */=0A=
-		if (cmd->use_sg) {=0A=
-			struct scatterlist *sg;=0A=
 =0A=
-			sg =3D (struct scatterlist *) cmd->request_buffer;=0A=
-			buffer =3D kmap_atomic(sg->page, KM_IRQ0) + sg->offset;=0A=
-		} else {=0A=
-			buffer =3D cmd->request_buffer;=0A=
-		}=0A=
+		sg =3D scsi_sglist(cmd);=0A=
+		buffer =3D kmap_atomic(sg->page, KM_IRQ0) + sg->offset;=0A=
+=0A=
 		memcpy(buffer, inqdata, sizeof(inqdata));=0A=
-		if (cmd->use_sg) {=0A=
-			struct scatterlist *sg;=0A=
+		sg =3D scsi_sglist(cmd);=0A=
+		kunmap_atomic(buffer - sg->offset, KM_IRQ0);=0A=
 =0A=
-			sg =3D (struct scatterlist *) cmd->request_buffer;=0A=
-			kunmap_atomic(buffer - sg->offset, KM_IRQ0);=0A=
-		}=0A=
 		cmd->scsi_done(cmd);=0A=
 	}=0A=
 	break;=0A=
@@ -1288,7 +1259,7 @@ static void arcmsr_polling_ccbdone(struct =
AdapterControlBlock *acb,=0A=
 			switch(ccb->arcmsr_cdb.DeviceStatus) {=0A=
 			case ARCMSR_DEV_SELECT_TIMEOUT: {=0A=
 					acb->devstate[id][lun] =3D ARECA_RAID_GONE;=0A=
-					ccb->pcmd->result =3D DID_TIME_OUT << 16;=0A=
+					ccb->pcmd->result =3D DID_NO_CONNECT << 16;=0A=
 					arcmsr_ccb_complete(ccb, 1);=0A=
 				}=0A=
 				break;=0A=
@@ -1322,6 +1293,94 @@ static void arcmsr_polling_ccbdone(struct =
AdapterControlBlock *acb,=0A=
 		}=0A=
 	}=0A=
 }=0A=
+static void arcmsr_done4_abort_postqueue(struct AdapterControlBlock =
*acb)=0A=
+{=0A=
+	int i=3D0,found=3D0;=0A=
+	int id, lun;=0A=
+	uint32_t flag_ccb,outbound_intstatus;=0A=
+	struct MessageUnit __iomem *reg =3D acb->pmu;=0A=
+	struct CommandControlBlock *ccb;=0A=
+	/*clear and abort all outbound posted Q*/=0A=
+=0A=
+       while(((flag_ccb=3Dreadl(&reg->outbound_queueport)) !=3D =
0xFFFFFFFF) && =0A=
+(i++ < 256)){ =0A=
+		ccb =3D (struct CommandControlBlock *)(acb->vir2phy_offset+=0A=
+(flag_ccb << 5));=0A=
+               if(ccb){=0A=
+                       if ((ccb->acb !=3D acb)||(ccb->startdone !=3D \=0A=
+ARCMSR_CCB_START)){=0A=
+				printk(KERN_NOTICE "arcmsr%d: polling get \=0A=
+an illegal ccb" "command done ccb=3D'0x%p'""ccboutstandingcount=3D%d =
\n",=0A=
+                                        acb->host->host_no,ccb,=0A=
+                                        =
atomic_read(&acb->ccboutstandingcount));=0A=
+                                continue;=0A=
+                        }=0A=
+ =0A=
+                        id =3D ccb->pcmd->device->id;=0A=
+                        lun =3D ccb->pcmd->device->lun;=0A=
+                        if (!(flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR)){=0A=
+                                if (acb->devstate[id][lun] =3D=3D =
ARECA_RAID_GONE)=0A=
+                                       acb->devstate[id][lun] =3D =
ARECA_RAID_GOOD;=0A=
+                                ccb->pcmd->result =3D DID_OK << 16;=0A=
+                                arcmsr_ccb_complete(ccb,1);=0A=
+                        }=0A=
+                        else {=0A=
+                                switch(ccb->arcmsr_cdb.DeviceStatus) {=0A=
+                                case ARCMSR_DEV_SELECT_TIMEOUT: {=0A=
+                                                acb->devstate[id][lun] 	=
							=3D ARECA_RAID_GONE;=0A=
+                                                ccb->pcmd->result =3D 		=
						DID_NO_CONNECT << 16;=0A=
+                                                =
arcmsr_ccb_complete(ccb,1);=0A=
+                                }=0A=
+                                break;=0A=
+ =0A=
+                                case ARCMSR_DEV_ABORTED: =0A=
+ =0A=
+                                case ARCMSR_DEV_INIT_FAIL: {=0A=
+                                                acb->devstate[id][lun] =
=3D =0A=
+							ARECA_RAID_GONE;=0A=
+                                                ccb->pcmd->result =3D =0A=
+							DID_BAD_TARGET << 16;=0A=
+                                                =
arcmsr_ccb_complete(ccb, 1);=0A=
+                                }=0A=
+                                break;=0A=
+ =0A=
+                                case ARCMSR_DEV_CHECK_CONDITION: {=0A=
+                                                acb->devstate[id][lun] =
=3D =0A=
+							ARECA_RAID_GOOD;=0A=
+                                                =
arcmsr_report_sense_info(ccb);=0A=
+                                                =
arcmsr_ccb_complete(ccb, 1);=0A=
+                                }=0A=
+                                break;=0A=
+ =0A=
+                                default:=0A=
+                                                printk(KERN_NOTICE=0A=
+                                                      "arcmsr%d: scsi =
id=3D%d \=0A=
+							lun=3D%d""polling and \=0A=
+							getting command error \=0A=
+							done""but got unknown \=0A=
+							DeviceStatus =3D 0x%x \n", =0A=
+							acb->host->host_no, id ,=0A=
+					   lun , ccb->arcmsr_cdb.DeviceStatus);=0A=
+                                                acb->devstate[id][lun] =
=3D =0A=
+								ARECA_RAID_GONE;=0A=
+                                                ccb->pcmd->result =3D =0A=
+							DID_BAD_TARGET << 16;=0A=
+                                                =
arcmsr_ccb_complete(ccb, 1);=0A=
+                                break;=0A=
+                               }=0A=
+                       }=0A=
+                       found=3D1;=0A=
+               }=0A=
+       }=0A=
+	if(found){=0A=
+		outbound_intstatus =3D readl(&reg->outbound_intstatus) & \=0A=
+			acb->outbound_int_enable;=0A=
+		writel(outbound_intstatus, &reg->outbound_intstatus);=0A=
+		/*clear interrupt*/=0A=
+       	}=0A=
+       	return;=0A=
+}=0A=
+=0A=
 =0A=
 static void arcmsr_iop_init(struct AdapterControlBlock *acb)=0A=
 {=0A=
@@ -1368,21 +1427,17 @@ static void arcmsr_iop_reset(struct =
AdapterControlBlock *acb)=0A=
 		/* disable all outbound interrupt */=0A=
 		intmask_org =3D arcmsr_disable_outbound_ints(acb);=0A=
 		/* clear all outbound posted Q */=0A=
-		for (i =3D 0; i < ARCMSR_MAX_OUTSTANDING_CMD; i++)=0A=
-			readl(&reg->outbound_queueport);=0A=
-		for (i =3D 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {=0A=
-			ccb =3D acb->pccb_pool[i];=0A=
-			if ((ccb->startdone =3D=3D ARCMSR_CCB_START) ||=0A=
-				(ccb->startdone =3D=3D ARCMSR_CCB_ABORTED)) {=0A=
-				ccb->startdone =3D ARCMSR_CCB_ABORTED;=0A=
-				ccb->pcmd->result =3D DID_ABORT << 16;=0A=
-				arcmsr_ccb_complete(ccb, 1);=0A=
-			}=0A=
-		}=0A=
-		/* enable all outbound interrupt */=0A=
-		arcmsr_enable_outbound_ints(acb, intmask_org);=0A=
-	}=0A=
-	atomic_set(&acb->ccboutstandingcount, 0);=0A=
+                arcmsr_done4_abort_postqueue(acb);=0A=
+                for (i =3D 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {=0A=
+                        ccb =3D acb->pccb_pool[i];=0A=
+                        if (ccb->startdone =3D=3D ARCMSR_CCB_START) {=0A=
+                                ccb->startdone =3D ARCMSR_CCB_ABORTED;=0A=
+                        }=0A=
+                }=0A=
+                /* enable all outbound interrupt */=0A=
+                arcmsr_enable_outbound_ints(acb, intmask_org);=0A=
+        }=0A=
+=0A=
 }=0A=
 =0A=
 static int arcmsr_bus_reset(struct scsi_cmnd *cmd)=0A=
@@ -1431,7 +1486,6 @@ static int arcmsr_abort(struct scsi_cmnd *cmd)=0A=
 		"arcmsr%d: abort device command of scsi id=3D%d lun=3D%d \n",=0A=
 		acb->host->host_no, cmd->device->id, cmd->device->lun);=0A=
 	acb->num_aborts++;=0A=
-=0A=
 	/*=0A=
 	************************************************=0A=
 	** the all interrupt service routine is locked=0A=
@@ -1486,10 +1540,306 @@ static const char *arcmsr_info(struct Scsi_Host =
*host)=0A=
 		type =3D "X-TYPE";=0A=
 		break;=0A=
 	}=0A=
-	sprintf(buf, "Areca %s Host Adapter RAID Controller%s\n        %s",=0A=
+	sprintf(buf, "Areca %s Host Adapter RAID Controller%s\n %s",=0A=
 			type, raid6 ? "( RAID6 capable)" : "",=0A=
 			ARCMSR_DRIVER_VERSION);=0A=
 	return buf;=0A=
 }=0A=
 =0A=
+static pci_ers_result_t arcmsr_pci_slot_reset(struct pci_dev *pdev)=0A=
+{=0A=
+        struct Scsi_Host *host;=0A=
+	struct AdapterControlBlock *acb;=0A=
+	uint8_t bus,dev_fun;=0A=
+	int error;=0A=
+	=0A=
+	error =3D pci_enable_device(pdev);=0A=
+	if(error)=0A=
+		return PCI_ERS_RESULT_DISCONNECT;=0A=
+	pci_set_master(pdev);=0A=
+=0A=
+	host=3Dscsi_host_alloc(&arcmsr_scsi_host_template,sizeof \=0A=
+(struct AdapterControlBlock));=0A=
+	if(!host)=0A=
+            	return PCI_ERS_RESULT_DISCONNECT;=0A=
+	acb =3D (struct AdapterControlBlock *)host->hostdata;=0A=
+	memset(acb, 0, sizeof (struct AdapterControlBlock));=0A=
+=0A=
+	error =3D pci_set_dma_mask(pdev, DMA_64BIT_MASK);=0A=
+	if (error) {=0A=
+		error =3D pci_set_dma_mask(pdev, DMA_32BIT_MASK);=0A=
+		if (error) {=0A=
+			printk(KERN_WARNING=0A=
+			       "scsi%d: No suitable DMA mask available\n",=0A=
+			       host->host_no);=0A=
+			return PCI_ERS_RESULT_DISCONNECT;=0A=
+		}=0A=
+	}=0A=
+	bus =3D pdev->bus->number;=0A=
+	dev_fun =3D pdev->devfn;=0A=
+	acb=3D(struct AdapterControlBlock *) host->hostdata;=0A=
+	memset(acb,0,sizeof(struct AdapterControlBlock));=0A=
+	acb->pdev=3Dpdev;=0A=
+	acb->host=3Dhost;=0A=
+	host->max_sectors=3DARCMSR_MAX_XFER_SECTORS;=0A=
+	host->max_lun=3DARCMSR_MAX_TARGETLUN;=0A=
+	host->max_id=3DARCMSR_MAX_TARGETID;/*16:8*/=0A=
+	host->max_cmd_len=3D16;    /*this is issue of 64bit LBA ,over 2T byte*/=0A=
+	host->sg_tablesize=3DARCMSR_MAX_SG_ENTRIES;=0A=
+	host->can_queue=3DARCMSR_MAX_FREECCB_NUM; /* max simultaneous cmds */  =
           =0A=
+	host->cmd_per_lun=3DARCMSR_MAX_CMD_PERLUN;            =0A=
+	host->this_id=3DARCMSR_SCSI_INITIATOR_ID; =0A=
+	host->unique_id=3D(bus << 8) | dev_fun;=0A=
+	host->irq=3Dpdev->irq;=0A=
+	error =3D pci_request_regions(pdev, "arcmsr");=0A=
+	if (error)=0A=
+		return PCI_ERS_RESULT_DISCONNECT;=0A=
+=0A=
+	acb->pmu =3D ioremap(pci_resource_start(pdev, 0),=0A=
+			   pci_resource_len(pdev, 0));=0A=
+	if (!acb->pmu) {=0A=
+		printk(KERN_NOTICE "arcmsr%d: memory"=0A=
+			" mapping region fail \n", acb->host->host_no);=0A=
+		return PCI_ERS_RESULT_DISCONNECT;=0A=
+	}=0A=
+	acb->acb_flags |=3D (ACB_F_MESSAGE_WQBUFFER_CLEARED |=0A=
+			   ACB_F_MESSAGE_RQBUFFER_CLEARED |=0A=
+			   ACB_F_MESSAGE_WQBUFFER_READED);=0A=
+	acb->acb_flags &=3D ~ACB_F_SCSISTOPADAPTER;=0A=
+	INIT_LIST_HEAD(&acb->ccb_free_list);=0A=
+=0A=
+	error =3D arcmsr_alloc_ccb_pool(acb);=0A=
+	if (error)=0A=
+		return PCI_ERS_RESULT_DISCONNECT;=0A=
+=0A=
+	error =3D request_irq(pdev->irq, arcmsr_do_interrupt,=0A=
+			IRQF_DISABLED | IRQF_SHARED, "arcmsr", acb);=0A=
+	if (error)=0A=
+		return PCI_ERS_RESULT_DISCONNECT;=0A=
+=0A=
+	arcmsr_iop_init(acb);=0A=
+	if(strncmp(acb->firm_version,"V1.42",5) >=3D 0)=0A=
+              host->max_sectors=3D ARCMSR_MAX_XFER_SECTORS_B;=0A=
+=0A=
+	pci_set_drvdata(pdev, host);=0A=
+=0A=
+	error =3D scsi_add_host(host, &pdev->dev);=0A=
+	if (error)=0A=
+		return PCI_ERS_RESULT_DISCONNECT;=0A=
+=0A=
+	error =3D arcmsr_alloc_sysfs_attr(acb);=0A=
+	if (error)=0A=
+		return PCI_ERS_RESULT_DISCONNECT;=0A=
+=0A=
+	scsi_scan_host(host);=0A=
+	return PCI_ERS_RESULT_RECOVERED;=0A=
+}=0A=
+=0A=
+static void arcmsr_pci_ers_need_reset_forepart(struct pci_dev *pdev)=0A=
+{=0A=
+     	struct Scsi_Host *host=3Dpci_get_drvdata(pdev);=0A=
+	struct AdapterControlBlock *acb=3D(struct AdapterControlBlock *) =
host->hostdata;=0A=
+	struct MessageUnit __iomem *reg =3D acb->pmu;	=0A=
+	struct CommandControlBlock *ccb;=0A=
+	/*clear and abort all outbound posted Q*/=0A=
+	int i=3D0,found=3D0;	=0A=
+	int id, lun;	=0A=
+	uint32_t flag_ccb,outbound_intstatus;		=0A=
+		=0A=
+	while(((flag_ccb=3Dreadl(&reg->outbound_queueport)) !=3D 0xFFFFFFFF) =
&& =0A=
+								(i++ < 256)){			=0A=
+			ccb =3D (struct CommandControlBlock *)(acb->vir2phy_offset=0A=
+							 + (flag_ccb << 5));=0A=
+			if(ccb){=0A=
+				if ((ccb->acb !=3D acb)||(ccb->startdone !=3D =0A=
+							ARCMSR_CCB_START)){=0A=
+					printk(KERN_NOTICE "arcmsr%d: polling \=0A=
+					get an illegal ccb"" command done ccb=3D'0x%p'"		=0A=
+					"ccboutstandingcount=3D%d \n", 			=0A=
+					acb->host->host_no, ccb, =0A=
+					atomic_read(&acb->ccboutstandingcount));	=0A=
+					continue;=0A=
+				}=0A=
 =0A=
+				id =3D ccb->pcmd->device->id;=0A=
+				lun =3D ccb->pcmd->device->lun;	=0A=
+				if (!(flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR)) {=0A=
+					if (acb->devstate[id][lun] =3D=3D =0A=
+								ARECA_RAID_GONE)=0A=
+						acb->devstate[id][lun] =3D =0A=
+								ARECA_RAID_GOOD;=0A=
+					ccb->pcmd->result =3D DID_OK << 16;=0A=
+					arcmsr_ccb_complete(ccb, 1);=0A=
+				} =0A=
+				else {=0A=
+					switch(ccb->arcmsr_cdb.DeviceStatus) {=0A=
+					case ARCMSR_DEV_SELECT_TIMEOUT: {=0A=
+							acb->devstate[id][lun] =3D=0A=
+							ARECA_RAID_GONE;=0A=
+							ccb->pcmd->result =3D =0A=
+							DID_NO_CONNECT << 16;=0A=
+							arcmsr_ccb_complete(ccb, 1);=0A=
+					}=0A=
+					break;						=0A=
+		=0A=
+					case ARCMSR_DEV_ABORTED:						=0A=
+=0A=
+					case ARCMSR_DEV_INIT_FAIL: {=0A=
+							acb->devstate[id][lun] =3D=0A=
+							 ARECA_RAID_GONE;=0A=
+							ccb->pcmd->result =3D =0A=
+							DID_BAD_TARGET << 16;=0A=
+							arcmsr_ccb_complete(ccb, 1);	=0A=
+					}=0A=
+					break;=0A=
+=0A=
+					case ARCMSR_DEV_CHECK_CONDITION: {=0A=
+							acb->devstate[id][lun] =3D=0A=
+							 ARECA_RAID_GOOD;	=0A=
+							arcmsr_report_sense_info(ccb);=0A=
+							arcmsr_ccb_complete(ccb, 1);=0A=
+					}=0A=
+					break;=0A=
+	=0A=
+					default:=0A=
+							printk(KERN_NOTICE=0A=
+								"arcmsr%d: scsi \=0A=
+								id=3D%d lun=3D%d" =0A=
+								" polling and \=0A=
+								getting command \=0A=
+								error done" =0A=
+								"but got unknown \=0A=
+							DeviceStatus =3D 0x%x \n"	=0A=
+							, acb->host->host_no, =0A=
+								id, lun	, =0A=
+						ccb->arcmsr_cdb.DeviceStatus);=0A=
+							acb->devstate[id][lun] =3D =0A=
+								ARECA_RAID_GONE;=0A=
+							ccb->pcmd->result =3D =0A=
+							DID_BAD_TARGET << 16;=0A=
+							arcmsr_ccb_complete(ccb, 1);	=0A=
+					break;=0A=
+					}=0A=
+				}=0A=
+				found=3D1;=0A=
+			}=0A=
+		}=0A=
+	if(found){=0A=
+		outbound_intstatus =3D readl(&reg->outbound_intstatus) & =0A=
+							acb->outbound_int_enable;=0A=
+		writel(outbound_intstatus, &reg->outbound_intstatus);=0A=
+		/*clear interrupt*/=0A=
+	            }=0A=
+	return;=0A=
+}   =0A=
+=0A=
+      =0A=
+static void arcmsr_pci_ers_disconnect_forepart(struct pci_dev *pdev)=0A=
+{=0A=
+     	struct Scsi_Host *host=3Dpci_get_drvdata(pdev);=0A=
+	struct AdapterControlBlock *acb=3D(struct AdapterControlBlock *) =
host->hostdata;=0A=
+	struct MessageUnit __iomem *reg =3D acb->pmu;	=0A=
+	struct CommandControlBlock *ccb;=0A=
+	/*clear and abort all outbound posted Q*/=0A=
+	int i=3D0,found=3D0;	=0A=
+	int id, lun;	=0A=
+	uint32_t flag_ccb,outbound_intstatus;		=0A=
+		=0A=
+	while(((flag_ccb=3Dreadl(&reg->outbound_queueport)) !=3D 0xFFFFFFFF) =
&& =0A=
+								(i++ < 256)){			=0A=
+			ccb =3D (struct CommandControlBlock *)(acb->vir2phy_offset + =0A=
+							(flag_ccb << 5));=0A=
+			if(ccb){=0A=
+				if ((ccb->acb !=3D acb)||(ccb->startdone !=3D =0A=
+							ARCMSR_CCB_START)){=0A=
+					printk(KERN_NOTICE =0A=
+						"arcmsr%d: polling get an illegal ccb"=0A=
+						" command done ccb=3D'0x%p'"		=0A=
+						"ccboutstandingcount=3D%d \n", 			=0A=
+						acb->host->host_no, ccb, =0A=
+						atomic_read(&acb->ccboutstandingcount));	=0A=
+					continue;=0A=
+			}=0A=
+=0A=
+			id =3D ccb->pcmd->device->id;=0A=
+			lun =3D ccb->pcmd->device->lun;	=0A=
+			if (!(flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR))	{=0A=
+				if (acb->devstate[id][lun] =3D=3D ARECA_RAID_GONE)=0A=
+					acb->devstate[id][lun] =3D ARECA_RAID_GOOD;=0A=
+				ccb->pcmd->result =3D DID_OK << 16;=0A=
+				arcmsr_ccb_complete(ccb, 1);=0A=
+			} =0A=
+			else {=0A=
+				switch(ccb->arcmsr_cdb.DeviceStatus) {=0A=
+				case ARCMSR_DEV_SELECT_TIMEOUT: {=0A=
+						acb->devstate[id][lun] =3D =0A=
+								ARECA_RAID_GONE;=0A=
+						ccb->pcmd->result =3D =0A=
+							DID_NO_CONNECT << 16;=0A=
+						arcmsr_ccb_complete(ccb, 1);=0A=
+				}=0A=
+				break;						=0A=
+		=0A=
+				case ARCMSR_DEV_ABORTED:						=0A=
+=0A=
+				case ARCMSR_DEV_INIT_FAIL: {=0A=
+						acb->devstate[id][lun] =3D =0A=
+								ARECA_RAID_GONE;=0A=
+						ccb->pcmd->result =3D =0A=
+							DID_BAD_TARGET << 16;=0A=
+						arcmsr_ccb_complete(ccb, 1);	=0A=
+				}=0A=
+				break;=0A=
+=0A=
+				case ARCMSR_DEV_CHECK_CONDITION: {=0A=
+						acb->devstate[id][lun] =3D =0A=
+								ARECA_RAID_GOOD;	=0A=
+						arcmsr_report_sense_info(ccb);=0A=
+						arcmsr_ccb_complete(ccb, 1);=0A=
+				}=0A=
+				break;=0A=
+	=0A=
+				default:=0A=
+						printk(KERN_NOTICE "arcmsr%d: \=0A=
+							scsi id=3D%d lun=3D%d"=0A=
+								" polling and \=0A=
+						getting command error done"=0A=
+								"but got unknown \=0A=
+						 DeviceStatus =3D 0x%x \n"	=0A=
+								, acb->host->host_no, =0A=
+					id, lun, ccb->arcmsr_cdb.DeviceStatus);=0A=
+							acb->devstate[id][lun] =3D =0A=
+								ARECA_RAID_GONE;=0A=
+							ccb->pcmd->result =3D =0A=
+							DID_BAD_TARGET << 16;=0A=
+							arcmsr_ccb_complete(ccb, 1);	=0A=
+				break;=0A=
+				}=0A=
+			}=0A=
+			found=3D1;=0A=
+		}=0A=
+	}=0A=
+	if(found){=0A=
+		outbound_intstatus =3D readl(&reg->outbound_intstatus) & =0A=
+						acb->outbound_int_enable;=0A=
+		writel(outbound_intstatus, &reg->outbound_intstatus);=0A=
+		/*clear interrupt*/=0A=
+	}=0A=
+	return;=0A=
+}=0A=
+      =0A=
+static pci_ers_result_t arcmsr_pci_error_detected(struct pci_dev *pdev, =0A=
+						pci_channel_state_t state)=0A=
+{=0A=
+         switch (state) {=0A=
+         case pci_channel_io_frozen:=0A=
+	  		arcmsr_pci_ers_need_reset_forepart(pdev);=0A=
+        	       return PCI_ERS_RESULT_NEED_RESET;=0A=
+         case pci_channel_io_perm_failure:=0A=
+                	arcmsr_pci_ers_disconnect_forepart(pdev);=0A=
+                     return PCI_ERS_RESULT_DISCONNECT;=0A=
+                     break;=0A=
+         default:=0A=
+                     return PCI_ERS_RESULT_NEED_RESET;=0A=
+	  }=0A=
+}=0A=

------=_NextPart_000_0001_01C7A829.65132EF0--

