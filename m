From: =?utf-8?B?bmlja2NoZW5nKOmEreWuiOismSk=?= <nick.cheng@areca.com.tw>
Subject: [PATCH01] scsi: improve areca driver stability and compatibility
Date: Fri, 15 Jun 2007 11:43:32 +0800
Message-ID: <000001c7aeff$599503a0$4f00a8c0@51091008491>
Reply-To: <nick.cheng@areca.com.tw>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0001_01C7AF42.67B843A0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 60-248-88-209.HINET-IP.hinet.net ([60.248.88.209]:57136 "EHLO
	areca.com.tw" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751749AbXFODnr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Jun 2007 23:43:47 -0400
In-Reply-To: 
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Andrew Morton' <akpm@linux-foundation.org>, James.Bottomley@SteelEye.com, 'Randy Dunlap' <randy.dunlap@oracle.com>
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_0001_01C7AF42.67B843A0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Subject: [PATCH01] scsi: improve areca driver stability and =
compatibility

From: Nick Cheng <nick.cheng@areca.com.tw>

Description:
    1. Implement PCI-Express error recovery function and AER capability, =
especially 	thanks to Yanmin Zhang's openhanded help about AER
    2. Implement the selection of ARCMSR_MAX_XFER_SECTORS_B=3D4096 if =
firmware 	version is latter than 1.42
    3. Add arcmsr_done4_abort_postqueue in arcmsr_iop_reset function to =
improve 	the stability as hot-unplug/plug
    4. Modify the ISR, arcmsr_interrupt routine, to prevent the =
inconsistency with 	sg_mod driver if application directly calls the =
arcmsr driver w/o passing through 	scsi midlayer=20

Signed-off-by: Nick Cheng <nick.cheng@areca.com.tw>

PS.=20
	1. In order to highlight the changes of the functionality, this =
submission does not 	use the 80-column rule. If the submission is =
adopted successfully, I will make 	another patch under the 80-column =
rule.

	2. I attach the Linux Kernel patch submittal checklist that we have =
checked and 	I retain the original line number for your double check. =
Hopefully this will not 	disturb your review.=20

------=_NextPart_000_0001_01C7AF42.67B843A0
Content-Type: application/octet-stream;
	name="patch01-arcmsr.1.20.00.14 to KernelOrg"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="patch01-arcmsr.1.20.00.14 to KernelOrg"

diff --git a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h=0A=
index aff96db..f0b8bf4 100644=0A=
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
@@ -469,4 +470,3 @@ extern void arcmsr_post_Qbuffer(struct =
AdapterControlBlock *acb);=0A=
 extern struct class_device_attribute *arcmsr_host_attrs[];=0A=
 extern int arcmsr_alloc_sysfs_attr(struct AdapterControlBlock *acb);=0A=
 void arcmsr_free_sysfs_attr(struct AdapterControlBlock *acb);=0A=
-=0A=
diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c =
b/drivers/scsi/arcmsr/arcmsr_hba.c=0A=
index 672df79..5d57f4d 100644=0A=
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
+static pci_ers_result_t arcmsr_pci_error_detected(struct pci_dev *pdev,=0A=
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
+	.name			=3D "ARCMSR ARECA SATA/SAS RAID HOST Adapter"=0A=
+							ARCMSR_DRIVER_VERSION,=0A=
 	.info			=3D arcmsr_info,=0A=
 	.queuecommand		=3D arcmsr_queue_command,=0A=
 	.eh_abort_handler	=3D arcmsr_abort,=0A=
@@ -119,6 +123,10 @@ static struct scsi_host_template =
arcmsr_scsi_host_template =3D {=0A=
 	.use_clustering		=3D ENABLE_CLUSTERING,=0A=
 	.shost_attrs		=3D arcmsr_host_attrs,=0A=
 };=0A=
+static struct pci_error_handlers arcmsr_pci_error_handlers =3D {=0A=
+	.error_detected		=3D arcmsr_pci_error_detected,=0A=
+	.slot_reset		=3D arcmsr_pci_slot_reset,=0A=
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
+	.err_handler		=3D &arcmsr_pci_error_handlers,=0A=
 };=0A=
 =0A=
 static irqreturn_t arcmsr_do_interrupt(int irq, void *dev_id)=0A=
@@ -328,6 +337,8 @@ static int arcmsr_probe(struct pci_dev *pdev,=0A=
 =0A=
 	arcmsr_iop_init(acb);=0A=
 	pci_set_drvdata(pdev, host);=0A=
+	if (strncmp(acb->firm_version, "V1.42", 5) >=3D 0)=0A=
+		host->max_sectors=3D ARCMSR_MAX_XFER_SECTORS_B;=0A=
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
@@ -488,7 +500,7 @@ static void arcmsr_enable_outbound_ints(struct =
AdapterControlBlock *acb,=0A=
 =0A=
 static void arcmsr_flush_adapter_cache(struct AdapterControlBlock *acb)=0A=
 {=0A=
-	struct MessageUnit __iomem *reg=3Dacb->pmu;=0A=
+	struct MessageUnit __iomem *reg =3D acb->pmu;=0A=
 =0A=
 	writel(ARCMSR_INBOUND_MESG0_FLUSH_CACHE, &reg->inbound_msgaddr0);=0A=
 	if (arcmsr_wait_msgint_ready(acb))=0A=
@@ -718,7 +730,7 @@ static irqreturn_t arcmsr_interrupt(struct =
AdapterControlBlock *acb)=0A=
 		int id, lun;=0A=
 		/*=0A=
 		****************************************************************=0A=
-		**               areca cdb command done=0A=
+		**	      areca cdb command done=0A=
 		****************************************************************=0A=
 		*/=0A=
 		while (1) {=0A=
@@ -729,20 +741,20 @@ static irqreturn_t arcmsr_interrupt(struct =
AdapterControlBlock *acb)=0A=
 				(flag_ccb << 5));=0A=
 			if ((ccb->acb !=3D acb) || (ccb->startdone !=3D ARCMSR_CCB_START)) {=0A=
 				if (ccb->startdone =3D=3D ARCMSR_CCB_ABORTED) {=0A=
-					struct scsi_cmnd *abortcmd=3Dccb->pcmd;=0A=
+					struct scsi_cmnd *abortcmd =3D ccb->pcmd;=0A=
 					if (abortcmd) {=0A=
 					abortcmd->result |=3D DID_ABORT >> 16;=0A=
 					arcmsr_ccb_complete(ccb, 1);=0A=
 					printk(KERN_NOTICE=0A=
-						"arcmsr%d: ccb=3D'0x%p' isr got aborted command \n"=0A=
+						"arcmsr%d: ccb =3D'0x%p' isr got aborted command \n"=0A=
 						, acb->host->host_no, ccb);=0A=
 					}=0A=
 					continue;=0A=
 				}=0A=
 				printk(KERN_NOTICE=0A=
-					"arcmsr%d: isr get an illegal ccb command done acb=3D'0x%p'"=0A=
-					"ccb=3D'0x%p' ccbacb=3D'0x%p' startdone =3D 0x%x"=0A=
-					" ccboutstandingcount=3D%d \n"=0A=
+					"arcmsr%d: isr get an illegal ccb command done acb =3D '0x%p'"=0A=
+					"ccb =3D '0x%p' ccbacb =3D '0x%p' startdone =3D 0x%x"=0A=
+					" ccboutstandingcount =3D %d \n"=0A=
 					, acb->host->host_no=0A=
 					, acb=0A=
 					, ccb=0A=
@@ -762,7 +774,7 @@ static irqreturn_t arcmsr_interrupt(struct =
AdapterControlBlock *acb)=0A=
 				switch(ccb->arcmsr_cdb.DeviceStatus) {=0A=
 				case ARCMSR_DEV_SELECT_TIMEOUT: {=0A=
 						acb->devstate[id][lun] =3D ARECA_RAID_GONE;=0A=
-						ccb->pcmd->result =3D DID_TIME_OUT << 16;=0A=
+						ccb->pcmd->result =3D DID_NO_CONNECT << 16;=0A=
 						arcmsr_ccb_complete(ccb, 1);=0A=
 					}=0A=
 					break;=0A=
@@ -781,8 +793,8 @@ static irqreturn_t arcmsr_interrupt(struct =
AdapterControlBlock *acb)=0A=
 					break;=0A=
 				default:=0A=
 					printk(KERN_NOTICE=0A=
-						"arcmsr%d: scsi id=3D%d lun=3D%d"=0A=
-						" isr get command error done,"=0A=
+						"arcmsr%d: scsi id =3D %d lun =3D %d"=0A=
+						" isr get command error done, "=0A=
 						"but got unknown DeviceStatus =3D 0x%x \n"=0A=
 						, acb->host->host_no=0A=
 						, id=0A=
@@ -1062,7 +1074,7 @@ static void arcmsr_handle_virtual_command(struct =
AdapterControlBlock *acb,=0A=
 		inqdata[1] =3D 0;=0A=
 		/* rem media bit & Dev Type Modifier */=0A=
 		inqdata[2] =3D 0;=0A=
-		/* ISO,ECMA,& ANSI versions */=0A=
+		/* ISO, ECMA, & ANSI versions */=0A=
 		inqdata[4] =3D 31;=0A=
 		/* length of additional data */=0A=
 		strncpy(&inqdata[8], "Areca   ", 8);=0A=
@@ -1112,7 +1124,7 @@ static int arcmsr_queue_command(struct scsi_cmnd =
*cmd,=0A=
 			, acb->host->host_no);=0A=
 		return SCSI_MLQUEUE_HOST_BUSY;=0A=
 	}=0A=
-	if(target =3D=3D 16) {=0A=
+	if (target =3D=3D 16) {=0A=
 		/* virtual device for iop message transfer */=0A=
 		arcmsr_handle_virtual_command(acb, cmd);=0A=
 		return 0;=0A=
@@ -1125,7 +1137,7 @@ static int arcmsr_queue_command(struct scsi_cmnd =
*cmd,=0A=
 			printk(KERN_NOTICE=0A=
 				"arcmsr%d: block 'read/write'"=0A=
 				"command with gone raid volume"=0A=
-				" Cmd=3D%2x, TargetId=3D%d, Lun=3D%d \n"=0A=
+				" Cmd =3D %2x, TargetId =3D %d, Lun =3D %d \n"=0A=
 				, acb->host->host_no=0A=
 				, cmd->cmnd[0]=0A=
 				, target, lun);=0A=
@@ -1216,7 +1228,7 @@ static void arcmsr_polling_ccbdone(struct =
AdapterControlBlock *acb,=0A=
 			if ((ccb->startdone =3D=3D ARCMSR_CCB_ABORTED) ||=0A=
 				(ccb =3D=3D poll_ccb)) {=0A=
 				printk(KERN_NOTICE=0A=
-					"arcmsr%d: scsi id=3D%d lun=3D%d ccb=3D'0x%p'"=0A=
+					"arcmsr%d: scsi id =3D %d lun =3D %d ccb =3D '0x%p'"=0A=
 					" poll command abort successfully \n"=0A=
 					, acb->host->host_no=0A=
 					, ccb->pcmd->device->id=0A=
@@ -1229,8 +1241,8 @@ static void arcmsr_polling_ccbdone(struct =
AdapterControlBlock *acb,=0A=
 			}=0A=
 			printk(KERN_NOTICE=0A=
 				"arcmsr%d: polling get an illegal ccb"=0A=
-				" command done ccb=3D'0x%p'"=0A=
-				"ccboutstandingcount=3D%d \n"=0A=
+				" command done ccb =3D'0x%p'"=0A=
+				"ccboutstandingcount =3D %d \n"=0A=
 				, acb->host->host_no=0A=
 				, ccb=0A=
 				, atomic_read(&acb->ccboutstandingcount));=0A=
@@ -1247,7 +1259,7 @@ static void arcmsr_polling_ccbdone(struct =
AdapterControlBlock *acb,=0A=
 			switch(ccb->arcmsr_cdb.DeviceStatus) {=0A=
 			case ARCMSR_DEV_SELECT_TIMEOUT: {=0A=
 					acb->devstate[id][lun] =3D ARECA_RAID_GONE;=0A=
-					ccb->pcmd->result =3D DID_TIME_OUT << 16;=0A=
+					ccb->pcmd->result =3D DID_NO_CONNECT << 16;=0A=
 					arcmsr_ccb_complete(ccb, 1);=0A=
 				}=0A=
 				break;=0A=
@@ -1266,7 +1278,7 @@ static void arcmsr_polling_ccbdone(struct =
AdapterControlBlock *acb,=0A=
 				break;=0A=
 			default:=0A=
 				printk(KERN_NOTICE=0A=
-					"arcmsr%d: scsi id=3D%d lun=3D%d"=0A=
+					"arcmsr%d: scsi id =3D %d lun =3D %d"=0A=
 					" polling and getting command error done"=0A=
 					"but got unknown DeviceStatus =3D 0x%x \n"=0A=
 					, acb->host->host_no=0A=
@@ -1281,6 +1293,94 @@ static void arcmsr_polling_ccbdone(struct =
AdapterControlBlock *acb,=0A=
 		}=0A=
 	}=0A=
 }=0A=
+static void arcmsr_done4_abort_postqueue(struct AdapterControlBlock =
*acb)=0A=
+{=0A=
+	int i =3D 0, found =3D 0;=0A=
+	int id, lun;=0A=
+	uint32_t flag_ccb, outbound_intstatus;=0A=
+	struct MessageUnit __iomem *reg =3D acb->pmu;=0A=
+	struct CommandControlBlock *ccb;=0A=
+	/*clear and abort all outbound posted Q*/=0A=
+=0A=
+       while (((flag_ccb =3D readl(&reg->outbound_queueport)) !=3D =
0xFFFFFFFF) &&=0A=
+(i++ < 256)){=0A=
+		ccb =3D (struct CommandControlBlock *)(acb->vir2phy_offset +=0A=
+(flag_ccb << 5));=0A=
+	if (ccb){=0A=
+		if ((ccb->acb !=3D acb)||(ccb->startdone !=3D \=0A=
+ARCMSR_CCB_START)){=0A=
+				printk(KERN_NOTICE "arcmsr%d: polling get \=0A=
+an illegal ccb" "command done ccb =3D '0x%p'""ccboutstandingcount =3D =
%d \n",=0A=
+					acb->host->host_no, ccb,=0A=
+					atomic_read(&acb->ccboutstandingcount));=0A=
+				continue;=0A=
+			}=0A=
+=0A=
+			id =3D ccb->pcmd->device->id;=0A=
+			lun =3D ccb->pcmd->device->lun;=0A=
+			if (!(flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR)){=0A=
+				if (acb->devstate[id][lun] =3D=3D ARECA_RAID_GONE)=0A=
+					acb->devstate[id][lun] =3D ARECA_RAID_GOOD;=0A=
+				ccb->pcmd->result =3D DID_OK << 16;=0A=
+				arcmsr_ccb_complete(ccb, 1);=0A=
+			}=0A=
+			else {=0A=
+				switch(ccb->arcmsr_cdb.DeviceStatus) {=0A=
+				case ARCMSR_DEV_SELECT_TIMEOUT: {=0A=
+						acb->devstate[id][lun] =3D ARECA_RAID_GONE;=0A=
+						ccb->pcmd->result =3D DID_NO_CONNECT << 16;=0A=
+						arcmsr_ccb_complete(ccb, 1);=0A=
+				}=0A=
+				break;=0A=
+=0A=
+				case ARCMSR_DEV_ABORTED:=0A=
+=0A=
+				case ARCMSR_DEV_INIT_FAIL: {=0A=
+						acb->devstate[id][lun] =3D=0A=
+							ARECA_RAID_GONE;=0A=
+						ccb->pcmd->result =3D=0A=
+							DID_BAD_TARGET << 16;=0A=
+				arcmsr_ccb_complete(ccb, 1);=0A=
+				}=0A=
+				break;=0A=
+=0A=
+				case ARCMSR_DEV_CHECK_CONDITION: {=0A=
+						acb->devstate[id][lun] =3D=0A=
+							ARECA_RAID_GOOD;=0A=
+						arcmsr_report_sense_info(ccb);=0A=
+						arcmsr_ccb_complete(ccb, 1);=0A=
+				}=0A=
+				break;=0A=
+=0A=
+				default:=0A=
+						printk(KERN_NOTICE=0A=
+						      "arcmsr%d: scsi id =3D %d \=0A=
+							lun =3D %d""polling and \=0A=
+							getting command error \=0A=
+							done""but got unknown \=0A=
+							DeviceStatus =3D 0x%x \n",=0A=
+							acb->host->host_no, id,=0A=
+					   lun, ccb->arcmsr_cdb.DeviceStatus);=0A=
+						acb->devstate[id][lun] =3D=0A=
+								ARECA_RAID_GONE;=0A=
+						ccb->pcmd->result =3D=0A=
+							DID_BAD_TARGET << 16;=0A=
+						arcmsr_ccb_complete(ccb, 1);=0A=
+				break;=0A=
+			       }=0A=
+       }=0A=
+		       found =3D 1;=0A=
+	       }=0A=
+       }=0A=
+	if (found){=0A=
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
@@ -1327,21 +1427,17 @@ static void arcmsr_iop_reset(struct =
AdapterControlBlock *acb)=0A=
 		/* disable all outbound interrupt */=0A=
 		intmask_org =3D arcmsr_disable_outbound_ints(acb);=0A=
 		/* clear all outbound posted Q */=0A=
-		for (i =3D 0; i < ARCMSR_MAX_OUTSTANDING_CMD; i++)=0A=
-			readl(&reg->outbound_queueport);=0A=
+		arcmsr_done4_abort_postqueue(acb);=0A=
 		for (i =3D 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {=0A=
 			ccb =3D acb->pccb_pool[i];=0A=
-			if ((ccb->startdone =3D=3D ARCMSR_CCB_START) ||=0A=
-				(ccb->startdone =3D=3D ARCMSR_CCB_ABORTED)) {=0A=
+			if (ccb->startdone =3D=3D ARCMSR_CCB_START) {=0A=
 				ccb->startdone =3D ARCMSR_CCB_ABORTED;=0A=
-				ccb->pcmd->result =3D DID_ABORT << 16;=0A=
-				arcmsr_ccb_complete(ccb, 1);=0A=
 			}=0A=
 		}=0A=
 		/* enable all outbound interrupt */=0A=
 		arcmsr_enable_outbound_ints(acb, intmask_org);=0A=
 	}=0A=
-	atomic_set(&acb->ccboutstandingcount, 0);=0A=
+=0A=
 }=0A=
 =0A=
 static int arcmsr_bus_reset(struct scsi_cmnd *cmd)=0A=
@@ -1387,10 +1483,9 @@ static int arcmsr_abort(struct scsi_cmnd *cmd)=0A=
 	int i =3D 0;=0A=
 =0A=
 	printk(KERN_NOTICE=0A=
-		"arcmsr%d: abort device command of scsi id=3D%d lun=3D%d \n",=0A=
+		"arcmsr%d: abort device command of scsi id =3D %d lun =3D %d \n",=0A=
 		acb->host->host_no, cmd->device->id, cmd->device->lun);=0A=
 	acb->num_aborts++;=0A=
-=0A=
 	/*=0A=
 	************************************************=0A=
 	** the all interrupt service routine is locked=0A=
@@ -1445,10 +1540,306 @@ static const char *arcmsr_info(struct Scsi_Host =
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
+	struct Scsi_Host *host;=0A=
+	struct AdapterControlBlock *acb;=0A=
+	uint8_t bus, dev_fun;=0A=
+	int error;=0A=
+=0A=
+	error =3D pci_enable_device(pdev);=0A=
+	if (error)=0A=
+		return PCI_ERS_RESULT_DISCONNECT;=0A=
+	pci_set_master(pdev);=0A=
+=0A=
+	host =3D scsi_host_alloc(&arcmsr_scsi_host_template, sizeof \=0A=
+(struct AdapterControlBlock));=0A=
+	if (!host)=0A=
+	    	return PCI_ERS_RESULT_DISCONNECT;=0A=
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
+	acb =3D (struct AdapterControlBlock *) host->hostdata;=0A=
+	memset(acb, 0, sizeof(struct AdapterControlBlock));=0A=
+	acb->pdev =3D pdev;=0A=
+	acb->host =3D host;=0A=
+	host->max_sectors =3D ARCMSR_MAX_XFER_SECTORS;=0A=
+	host->max_lun =3D ARCMSR_MAX_TARGETLUN;=0A=
+	host->max_id =3D ARCMSR_MAX_TARGETID;/*16:8*/=0A=
+	host->max_cmd_len =3D 16;    /*this is issue of 64bit LBA, over 2T =
byte*/=0A=
+	host->sg_tablesize =3D ARCMSR_MAX_SG_ENTRIES;=0A=
+	host->can_queue =3D ARCMSR_MAX_FREECCB_NUM; /* max simultaneous cmds */=0A=
+	host->cmd_per_lun =3D ARCMSR_MAX_CMD_PERLUN;=0A=
+	host->this_id =3D ARCMSR_SCSI_INITIATOR_ID;=0A=
+	host->unique_id =3D (bus << 8) | dev_fun;=0A=
+	host->irq =3D pdev->irq;=0A=
+	error =3D pci_request_regions(pdev, "arcmsr");=0A=
+	if (error)=0A=
+		return PCI_ERS_RESULT_DISCONNECT;=0A=
 =0A=
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
+	if (strncmp(acb->firm_version, "V1.42", 5) >=3D 0)=0A=
+	      host->max_sectors =3D ARCMSR_MAX_XFER_SECTORS_B;=0A=
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
+     	struct Scsi_Host *host =3D pci_get_drvdata(pdev);=0A=
+	struct AdapterControlBlock *acb =3D (struct AdapterControlBlock *) =
host->hostdata;=0A=
+	struct MessageUnit __iomem *reg =3D acb->pmu;=0A=
+	struct CommandControlBlock *ccb;=0A=
+	/*clear and abort all outbound posted Q*/=0A=
+	int i =3D 0, found =3D 0;=0A=
+	int id, lun;=0A=
+	uint32_t flag_ccb, outbound_intstatus;=0A=
+=0A=
+	while (((flag_ccb =3D readl(&reg->outbound_queueport)) !=3D =
0xFFFFFFFF) &&=0A=
+								(i++ < 256)){=0A=
+			ccb =3D (struct CommandControlBlock *)(acb->vir2phy_offset=0A=
+							 + (flag_ccb << 5));=0A=
+			if (ccb){=0A=
+				if ((ccb->acb !=3D acb)||(ccb->startdone !=3D=0A=
+							ARCMSR_CCB_START)){=0A=
+					printk(KERN_NOTICE "arcmsr%d: polling \=0A=
+					get an illegal ccb"" command done ccb =3D '0x%p'"=0A=
+					"ccboutstandingcount =3D %d \n",=0A=
+					acb->host->host_no, ccb,=0A=
+					atomic_read(&acb->ccboutstandingcount));=0A=
+					continue;=0A=
+				}=0A=
+=0A=
+				id =3D ccb->pcmd->device->id;=0A=
+				lun =3D ccb->pcmd->device->lun;=0A=
+				if (!(flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR)) {=0A=
+					if (acb->devstate[id][lun] =3D=3D=0A=
+								ARECA_RAID_GONE)=0A=
+						acb->devstate[id][lun] =3D=0A=
+								ARECA_RAID_GOOD;=0A=
+					ccb->pcmd->result =3D DID_OK << 16;=0A=
+					arcmsr_ccb_complete(ccb, 1);=0A=
+				}=0A=
+				else {=0A=
+					switch(ccb->arcmsr_cdb.DeviceStatus) {=0A=
+					case ARCMSR_DEV_SELECT_TIMEOUT: {=0A=
+							acb->devstate[id][lun] =3D=0A=
+							ARECA_RAID_GONE;=0A=
+							ccb->pcmd->result =3D=0A=
+							DID_NO_CONNECT << 16;=0A=
+							arcmsr_ccb_complete(ccb, 1);=0A=
+					}=0A=
+					break;=0A=
+=0A=
+					case ARCMSR_DEV_ABORTED:=0A=
+=0A=
+					case ARCMSR_DEV_INIT_FAIL: {=0A=
+							acb->devstate[id][lun] =3D=0A=
+							 ARECA_RAID_GONE;=0A=
+							ccb->pcmd->result =3D=0A=
+							DID_BAD_TARGET << 16;=0A=
+							arcmsr_ccb_complete(ccb, 1);=0A=
+					}=0A=
+					break;=0A=
+=0A=
+					case ARCMSR_DEV_CHECK_CONDITION: {=0A=
+							acb->devstate[id][lun] =3D=0A=
+							 ARECA_RAID_GOOD;=0A=
+							arcmsr_report_sense_info(ccb);=0A=
+							arcmsr_ccb_complete(ccb, 1);=0A=
+					}=0A=
+					break;=0A=
+=0A=
+					default:=0A=
+							printk(KERN_NOTICE=0A=
+								"arcmsr%d: scsi \=0A=
+								id =3D %d lun =3D %d"=0A=
+								" polling and \=0A=
+								getting command \=0A=
+								error done"=0A=
+								"but got unknown \=0A=
+							DeviceStatus =3D 0x%x \n"=0A=
+							, acb->host->host_no,=0A=
+								id, lun,=0A=
+						ccb->arcmsr_cdb.DeviceStatus);=0A=
+							acb->devstate[id][lun] =3D=0A=
+								ARECA_RAID_GONE;=0A=
+							ccb->pcmd->result =3D=0A=
+							DID_BAD_TARGET << 16;=0A=
+							arcmsr_ccb_complete(ccb, 1);=0A=
+					break;=0A=
+					}=0A=
+				}=0A=
+				found =3D 1;=0A=
+			}=0A=
+		}=0A=
+	if (found){=0A=
+		outbound_intstatus =3D readl(&reg->outbound_intstatus) &=0A=
+							acb->outbound_int_enable;=0A=
+		writel(outbound_intstatus, &reg->outbound_intstatus);=0A=
+		/*clear interrupt*/=0A=
+		    }=0A=
+	return;=0A=
+}=0A=
+=0A=
+=0A=
+static void arcmsr_pci_ers_disconnect_forepart(struct pci_dev *pdev)=0A=
+{=0A=
+     	struct Scsi_Host *host =3D pci_get_drvdata(pdev);=0A=
+	struct AdapterControlBlock *acb =3D (struct AdapterControlBlock *) =
host->hostdata;=0A=
+	struct MessageUnit __iomem *reg =3D acb->pmu;=0A=
+	struct CommandControlBlock *ccb;=0A=
+	/*clear and abort all outbound posted Q*/=0A=
+	int i =3D 0, found =3D 0;=0A=
+	int id, lun;=0A=
+	uint32_t flag_ccb, outbound_intstatus;=0A=
+=0A=
+	while (((flag_ccb =3D readl(&reg->outbound_queueport)) !=3D =
0xFFFFFFFF) &&=0A=
+								(i++ < 256)){=0A=
+			ccb =3D (struct CommandControlBlock *)(acb->vir2phy_offset +=0A=
+							(flag_ccb << 5));=0A=
+			if (ccb){=0A=
+				if ((ccb->acb !=3D acb)||(ccb->startdone !=3D=0A=
+							ARCMSR_CCB_START)){=0A=
+					printk(KERN_NOTICE=0A=
+						"arcmsr%d: polling get an illegal ccb"=0A=
+						" command done ccb =3D '0x%p'"=0A=
+						"ccboutstandingcount =3D %d \n",=0A=
+						acb->host->host_no, ccb,=0A=
+						atomic_read(&acb->ccboutstandingcount));=0A=
+					continue;=0A=
+			}=0A=
+=0A=
+			id =3D ccb->pcmd->device->id;=0A=
+			lun =3D ccb->pcmd->device->lun;=0A=
+			if (!(flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR))	{=0A=
+				if (acb->devstate[id][lun] =3D=3D ARECA_RAID_GONE)=0A=
+					acb->devstate[id][lun] =3D ARECA_RAID_GOOD;=0A=
+				ccb->pcmd->result =3D DID_OK << 16;=0A=
+				arcmsr_ccb_complete(ccb, 1);=0A=
+			}=0A=
+			else {=0A=
+				switch(ccb->arcmsr_cdb.DeviceStatus) {=0A=
+				case ARCMSR_DEV_SELECT_TIMEOUT: {=0A=
+						acb->devstate[id][lun] =3D=0A=
+								ARECA_RAID_GONE;=0A=
+						ccb->pcmd->result =3D=0A=
+							DID_NO_CONNECT << 16;=0A=
+						arcmsr_ccb_complete(ccb, 1);=0A=
+				}=0A=
+				break;=0A=
+=0A=
+				case ARCMSR_DEV_ABORTED:=0A=
+=0A=
+				case ARCMSR_DEV_INIT_FAIL: {=0A=
+						acb->devstate[id][lun] =3D=0A=
+								ARECA_RAID_GONE;=0A=
+						ccb->pcmd->result =3D=0A=
+							DID_BAD_TARGET << 16;=0A=
+						arcmsr_ccb_complete(ccb, 1);=0A=
+				}=0A=
+				break;=0A=
+=0A=
+				case ARCMSR_DEV_CHECK_CONDITION: {=0A=
+						acb->devstate[id][lun] =3D=0A=
+								ARECA_RAID_GOOD;=0A=
+						arcmsr_report_sense_info(ccb);=0A=
+						arcmsr_ccb_complete(ccb, 1);=0A=
+				}=0A=
+				break;=0A=
+=0A=
+				default:=0A=
+						printk(KERN_NOTICE "arcmsr%d: \=0A=
+							scsi id =3D %d lun =3D %d"=0A=
+								" polling and \=0A=
+						getting command error done"=0A=
+								"but got unknown \=0A=
+						 DeviceStatus =3D 0x%x \n"=0A=
+								, acb->host->host_no,=0A=
+					id, lun, ccb->arcmsr_cdb.DeviceStatus);=0A=
+							acb->devstate[id][lun] =3D=0A=
+								ARECA_RAID_GONE;=0A=
+							ccb->pcmd->result =3D=0A=
+							DID_BAD_TARGET << 16;=0A=
+							arcmsr_ccb_complete(ccb, 1);=0A=
+				break;=0A=
+				}=0A=
+			}=0A=
+			found =3D 1;=0A=
+		}=0A=
+	}=0A=
+	if (found){=0A=
+		outbound_intstatus =3D readl(&reg->outbound_intstatus) &=0A=
+						acb->outbound_int_enable;=0A=
+		writel(outbound_intstatus, &reg->outbound_intstatus);=0A=
+		/*clear interrupt*/=0A=
+	}=0A=
+	return;=0A=
+}=0A=
+=0A=
+static pci_ers_result_t arcmsr_pci_error_detected(struct pci_dev *pdev,=0A=
+						pci_channel_state_t state)=0A=
+{=0A=
+	switch (state) {=0A=
+	case pci_channel_io_frozen:=0A=
+	  		arcmsr_pci_ers_need_reset_forepart(pdev);=0A=
+			return PCI_ERS_RESULT_NEED_RESET;=0A=
+	case pci_channel_io_perm_failure:=0A=
+			arcmsr_pci_ers_disconnect_forepart(pdev);=0A=
+			return PCI_ERS_RESULT_DISCONNECT;=0A=
+			break;=0A=
+	default:=0A=
+			return PCI_ERS_RESULT_NEED_RESET;=0A=
+	  }=0A=
+}=0A=

------=_NextPart_000_0001_01C7AF42.67B843A0
Content-Type: text/plain;
	name="Linux Kernel patch submittal checklist.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="Linux Kernel patch submittal checklist.txt"

Linux Kernel patch submittal checklist

=A1=BD 1: Builds cleanly with applicable or modified CONFIG options =
=3Dy, =3Dm, and =3Dn. No gcc warnings/errors, no linker warnings/errors.

=A1=BD 2: Passes allnoconfig, allmodconfig

=A1=BD 5: Matches kernel coding style (except for the 80-column rule)

=A1=BD 6: Any new or modified CONFIG options don't muck up the config =
menu

=A1=BD 7: All new Kconfig options have help text

=A1=BD 8: Has been carefully reviewed with respect to relevant Kconfig =
combinations
=20
=A1=BD 9: Check cleanly with sparse

=A1=BD 10: Use=A1=A5make checkstack=A1=A6and 'make namespacecheck' and =
fix any problems that they find. Note: checkstack does not point out =
problems explicitly, but any one function that uses more than 512 bytes =
on the stack is a candidate for change

=A1=BD 11: Include kernel-doc to document global kernel APIs (Not =
required for static functions, but OK there also.) Use 'make htmldocs' =
or 'make mandocs' to check the kernel-doc and fix any issues

=A1=BD 12: Has been tested with CONFIG_PREEMPT, CONFIG_DEBUG_SLAB, =
CONFIG_DEBUG_MUTEXES, CONFIG_DEBUG_SPINLOCK, CONFIG_DEBUG_SPINLOCK_SLEEP =
all simultaneously enabled

=A1=BD 13: Has been build- and runtime tested with and without =
CONFIG_SMP and CONFIG_PREEMPT.

=A1=BD 15: All codepaths have been exercised with all lockdep features =
enabled

=A1=BD 16: All new /proc entries are documented under Documentation/

=A1=BD 17: All new kernel boot parameters are documented in =
Documentation/kernel-parameters.txt.

=A1=BD 19: All new userspace interfaces are documented in =
Documentation/ABI/.=20

=A1=BD 20: Check that it all passes `make headers_check'

=A1=BD 21: Has been checked with injection of at least slab and =
page-allocation failures with Documentation/fault-injection/failcmd.sh

------=_NextPart_000_0001_01C7AF42.67B843A0--

