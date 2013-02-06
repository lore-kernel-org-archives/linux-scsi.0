From: "NickCheng" <nick.cheng@areca.com.tw>
Subject: [PATCH 3/5]  arcmsr: Support MSI and MSI-X
Date: Wed, 6 Feb 2013 16:36:20 +0800
Message-ID: <36B5BA6F44054F4BB50AD4A0405CDD3B@arecaaebe11fae>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0006_01CE0488.1C3769A0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:50229 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756984Ab3BFIgv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Feb 2013 03:36:51 -0500
Received: by mail-ie0-f177.google.com with SMTP id 16so1499291iea.8
        for <linux-scsi@vger.kernel.org>; Wed, 06 Feb 2013 00:36:50 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, jejb@kernel.org, =?big5?B?tsCyTbap?= <ching2048@areca.com.tw>

This is a multi-part message in MIME format.

------=_NextPart_000_0006_01CE0488.1C3769A0
Content-Type: text/plain;
	charset="big5"
Content-Transfer-Encoding: 7bit

From: Nick Cheng <nick.cheng@areca.com.tw>

Support MSI or MSI-X for whole series of RAID controllers. Meanwhile correct the register access as iowrite32/ioread32 
Signed-off-by: Nick Cheng <nick.cheng@areca.com.tw>
---

------=_NextPart_000_0006_01CE0488.1C3769A0
Content-Type: application/octet-stream;
	name="patch3"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="patch3"

diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c =
b/drivers/scsi/arcmsr/arcmsr_hba.c=0A=
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2013-02-06 16:28:14.038731412 =
+0800=0A=
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2013-02-06 16:28:24.508982584 =
+0800=0A=
@@ -805,8 +805,9 @@ static int arcmsr_probe(struct pci_dev *=0A=
 {=0A=
 	struct Scsi_Host *host;=0A=
 	struct AdapterControlBlock *acb;=0A=
-	uint8_t bus,dev_fun;=0A=
-	int error;=0A=
+	uint8_t bus, dev_fun;=0A=
+	struct msix_entry entries[ARCMST_NUM_MSIX_VECTORS];=0A=
+	int error, i, j;=0A=
 	error =3D pci_enable_device(pdev);=0A=
 	if (error)=0A=
 		return -ENODEV;=0A=
@@ -863,10 +864,46 @@ static int arcmsr_probe(struct pci_dev *=0A=
 	error =3D scsi_add_host(host, &pdev->dev);=0A=
 	if (error)=0A=
 		goto RAID_controller_stop;=0A=
-	error =3D request_irq(pdev->irq, arcmsr_do_interrupt,=0A=
-		IRQF_SHARED, "arcmsr", acb);=0A=
-	if (error)=0A=
-		goto scsi_host_remove;=0A=
+	if (pci_find_capability(pdev, PCI_CAP_ID_MSIX)) {=0A=
+		if (!pci_enable_msix(pdev, entries, ARCMST_NUM_MSIX_VECTORS)) {=0A=
+			for (i =3D 0; i < ARCMST_NUM_MSIX_VECTORS; i++) {=0A=
+				entries[i].entry =3D i;=0A=
+				if (request_irq(entries[i].vector,=0A=
+					arcmsr_do_interrupt, 0, "arcmsr",=0A=
+					acb)) {=0A=
+					for (j =3D 0 ; j < i ; j++)=0A=
+						free_irq(entries[i].vector,=0A=
+						acb);=0A=
+					goto scsi_host_remove;=0A=
+				}=0A=
+				acb->entries[i] =3D entries[i];=0A=
+			}=0A=
+			acb->acb_flags |=3D ACB_F_MSIX_ENABLED;=0A=
+		} else {=0A=
+			if (request_irq(pdev->irq, arcmsr_do_interrupt,=0A=
+				IRQF_SHARED, "arcmsr", acb)) {=0A=
+				printk("arcmsr%d: request_irq =3D %d failed!\n",=0A=
+					acb->host->host_no, pdev->irq);=0A=
+				goto scsi_host_remove;=0A=
+			}=0A=
+		}=0A=
+	} else if (pci_find_capability(pdev, PCI_CAP_ID_MSI)) {=0A=
+		if (!pci_enable_msi(pdev))=0A=
+			acb->acb_flags |=3D ACB_F_MSI_ENABLED;=0A=
+		if (request_irq(pdev->irq, arcmsr_do_interrupt,=0A=
+			IRQF_SHARED, "arcmsr", acb)) {=0A=
+			pr_warn("arcmsr%d: request_irq =3D%d failed!\n",=0A=
+				acb->host->host_no, pdev->irq);=0A=
+			goto scsi_host_remove;=0A=
+		}=0A=
+	} else {=0A=
+		if (request_irq(pdev->irq, arcmsr_do_interrupt,=0A=
+			IRQF_SHARED, "arcmsr", acb)) {=0A=
+			pr_warn("arcmsr%d: request_irq =3D %d failed!\n",=0A=
+				acb->host->host_no, pdev->irq);=0A=
+			goto scsi_host_remove;=0A=
+		}=0A=
+	}=0A=
 	host->irq =3D pdev->irq;=0A=
     	scsi_scan_host(host);=0A=
 	INIT_WORK(&acb->arcmsr_do_message_isr_bh,=0A=
@@ -886,6 +923,11 @@ static int arcmsr_probe(struct pci_dev *=0A=
 	return 0;=0A=
 out_free_sysfs:=0A=
 scsi_host_remove:=0A=
+	if (acb->acb_flags & ACB_F_MSI_ENABLED) {=0A=
+		pci_disable_msi(pdev);=0A=
+	} else if (acb->acb_flags & ACB_F_MSIX_ENABLED) {=0A=
+		pci_disable_msix(pdev);=0A=
+	}=0A=
 	scsi_remove_host(host);=0A=
 RAID_controller_stop:=0A=
 	arcmsr_stop_adapter_bgrb(acb);=0A=
@@ -1098,11 +1140,11 @@ arcmsr_report_ccb_state(struct AdapterCo=0A=
 		default:=0A=
 			pr_notice("arcmsr%d: scsi id =3D %d lun =3D %d"=0A=
 				"isr get command error done, but got unknown"=0A=
-				"DeviceStatus =3D 0x%x\n"=0A=
-				, acb->host->host_no=0A=
-				, id=0A=
-				, lun=0A=
-				, ccb->arcmsr_cdb.DeviceStatus);=0A=
+			"DeviceStatus =3D 0x%x\n"=0A=
+			, acb->host->host_no=0A=
+			, id=0A=
+			, lun=0A=
+			, ccb->arcmsr_cdb.DeviceStatus);=0A=
 			acb->devstate[id][lun] =3D ARECA_RAID_GONE;=0A=
 			ccb->pcmd->result =3D DID_NO_CONNECT << 16;=0A=
 			arcmsr_ccb_complete(ccb);=0A=
@@ -1124,7 +1166,7 @@ struct CommandControlBlock *pCCB, bool e=0A=
 				lun =3D abortcmd->device->lun;=0A=
 				abortcmd->result |=3D DID_ABORT << 16;=0A=
 				arcmsr_ccb_complete(pCCB);=0A=
-				pr_notice("arcmsr%d: pCCB =3D'0x%p' isr"=0A=
+				pr_notice("arcmsr%d: pCCB =3D '0x%p' isr"=0A=
 				"got aborted command\n",=0A=
 				acb->host->host_no, pCCB);=0A=
 			}=0A=
@@ -1134,12 +1176,12 @@ struct CommandControlBlock *pCCB, bool e=0A=
 			"done acb =3D '0x%p'"=0A=
 			"ccb =3D '0x%p' ccbacb =3D '0x%p' startdone =3D 0x%x"=0A=
 			"ccboutstandingcount =3D %d\n"=0A=
-			, acb->host->host_no=0A=
-			, acb=0A=
-			, pCCB=0A=
-			, pCCB->acb=0A=
-			, pCCB->startdone=0A=
-			, atomic_read(&acb->ccboutstandingcount));=0A=
+				, acb->host->host_no=0A=
+				, acb=0A=
+				, pCCB=0A=
+				, pCCB->acb=0A=
+				, pCCB->startdone=0A=
+				, atomic_read(&acb->ccboutstandingcount));=0A=
 		  return;=0A=
 	}=0A=
 	arcmsr_report_ccb_state(acb, pCCB, error);=0A=

------=_NextPart_000_0006_01CE0488.1C3769A0--

