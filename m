From: "NickCheng" <nick.cheng@areca.com.tw>
Subject: [PATCH 3/5]  arcmsr: Support MSI and MSI-X
Date: Fri, 8 Feb 2013 14:04:17 +0800
Message-ID: <1530618F8ABA47F185481DBEF80BBAF4@arecaaebe11fae>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0012_01CE0605.318F4880"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, jejb@kernel.org, ??? <ching2048@areca.com.tw>
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_0012_01CE0605.318F4880
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Nick Cheng <nick.cheng@areca.com.tw>

Support MSI or MSI-X for whole series of RAID controllers. Meanwhile correct the register access as iowrite32/ioread32 
Signed-off-by: Nick Cheng <nick.cheng@areca.com.tw>
---

------=_NextPart_000_0012_01CE0605.318F4880
Content-Type: application/octet-stream;
	name="patch3"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="patch3"

diff -uprN a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h=0A=
--- a/drivers/scsi/arcmsr/arcmsr.h	2013-02-08 13:55:55.221492667 +0800=0A=
+++ b/drivers/scsi/arcmsr/arcmsr.h	2013-02-08 13:56:07.892748621 +0800=0A=
@@ -64,6 +64,7 @@ struct device_attribute;=0A=
 #define ARCMSR_MAX_HBB_POSTQUEUE		264=0A=
 #define ARCMSR_MAX_XFER_LEN			0x26000=0A=
 #define ARCMSR_CDB_SG_PAGE_LENGTH		256=0A=
+#define ARCMST_NUM_MSIX_VECTORS		4=0A=
 #ifndef PCI_DEVICE_ID_ARECA_1880=0A=
 	#define PCI_DEVICE_ID_ARECA_1880	0x1880=0A=
  #endif=0A=
@@ -510,6 +511,7 @@ struct AdapterControlBlock=0A=
 	struct pci_dev *pdev;=0A=
 	struct Scsi_Host *host;=0A=
 	unsigned long vir2phy_offset;=0A=
+	struct msix_entry entries[ARCMST_NUM_MSIX_VECTORS];=0A=
 	/* Offset is used in making arc cdb physical to virtual calculations */=0A=
 	uint32_t outbound_int_enable;=0A=
 	uint32_t cdb_phyaddr_hi32;=0A=
@@ -546,6 +548,8 @@ struct AdapterControlBlock=0A=
 	/* iop init */=0A=
 	#define ACB_F_ABORT				0x0200=0A=
 	#define ACB_F_FIRMWARE_TRAP			0x0400=0A=
+	#define ACB_F_MSI_ENABLED			0x1000=0A=
+	#define ACB_F_MSIX_ENABLED			0x2000=0A=
 	struct CommandControlBlock *pccb_pool[ARCMSR_MAX_FREECCB_NUM];=0A=
 	/* used for memory free */=0A=
 	struct list_head ccb_free_list;=0A=
diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c =
b/drivers/scsi/arcmsr/arcmsr_hba.c=0A=
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2013-02-08 13:55:55.583499141 =
+0800=0A=
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2013-02-08 13:56:08.261754647 =
+0800=0A=
@@ -678,13 +678,24 @@ arcmsr_message_isr_bh_fn(struct work_str=0A=
 	static int=0A=
 	arcmsr_suspend(struct pci_dev *pdev, pm_message_t state)=0A=
 	{=0A=
+		int i;=0A=
 		uint32_t intmask_org;=0A=
 		struct Scsi_Host *host =3D pci_get_drvdata(pdev);=0A=
 		struct AdapterControlBlock *acb =3D=0A=
 			(struct AdapterControlBlock *)host->hostdata;=0A=
 =0A=
 		intmask_org =3D arcmsr_disable_outbound_ints(acb);=0A=
-		free_irq(pdev->irq, acb);=0A=
+		if (acb->acb_flags & ACB_F_MSI_ENABLED) {=0A=
+			free_irq(pdev->irq, acb);=0A=
+			pci_disable_msi(pdev);=0A=
+		} else if (acb->acb_flags & ACB_F_MSIX_ENABLED) {=0A=
+			for (i =3D 0; i < ARCMST_NUM_MSIX_VECTORS; i++) {=0A=
+				free_irq(acb->entries[i].vector, acb);=0A=
+			}=0A=
+			pci_disable_msix(pdev);=0A=
+		} else {=0A=
+			free_irq(pdev->irq, acb);=0A=
+		}=0A=
 		del_timer_sync(&acb->eternal_timer);=0A=
 		flush_scheduled_work();=0A=
 		arcmsr_stop_adapter_bgrb(acb);=0A=
@@ -700,10 +711,11 @@ arcmsr_message_isr_bh_fn(struct work_str=0A=
 	static int=0A=
 	arcmsr_resume(struct pci_dev *pdev)=0A=
 	{=0A=
-		int error;=0A=
+		int error, i, j;=0A=
 		struct Scsi_Host *host =3D pci_get_drvdata(pdev);=0A=
 		struct AdapterControlBlock *acb =3D=0A=
 			(struct AdapterControlBlock *)host->hostdata;=0A=
+		struct msix_entry entries[ARCMST_NUM_MSIX_VECTORS];=0A=
 		pci_set_power_state(pdev, PCI_D0);=0A=
 		pci_enable_wake(pdev, PCI_D0, 0);=0A=
 		pci_restore_state(pdev);=0A=
@@ -722,9 +734,45 @@ arcmsr_message_isr_bh_fn(struct work_str=0A=
 		}=0A=
 		pci_set_master(pdev);=0A=
 		arcmsr_iop_init(acb);=0A=
-		if (request_irq(pdev->irq, arcmsr_do_interrupt,=0A=
-			IRQF_SHARED, "arcmsr", acb)) {=0A=
-			goto controller_stop;=0A=
+		if (pci_find_capability(pdev, PCI_CAP_ID_MSIX)) {=0A=
+			if (!pci_enable_msix(pdev, entries,=0A=
+				ARCMST_NUM_MSIX_VECTORS)) {=0A=
+				for (i =3D 0; i < ARCMST_NUM_MSIX_VECTORS;=0A=
+				i++) {=0A=
+					entries[i].entry =3D i;=0A=
+					if (request_irq(entries[i].vector,=0A=
+					arcmsr_do_interrupt, 0,=0A=
+					"arcmsr", acb)) {=0A=
+						for (j =3D 0 ; j < i ; j++)=0A=
+							free_irq(entries[i].vector,=0A=
+							acb);=0A=
+						goto controller_stop;=0A=
+					}=0A=
+					acb->entries[i] =3D entries[i];=0A=
+				}=0A=
+				acb->acb_flags |=3D ACB_F_MSIX_ENABLED;=0A=
+			} else {=0A=
+				printk("arcmsr%d: MSI-X"=0A=
+				"failed to enable\n", acb->host->host_no);=0A=
+				if (request_irq(pdev->irq,=0A=
+				arcmsr_do_interrupt, IRQF_SHARED,=0A=
+				"arcmsr", acb)) {=0A=
+					goto controller_stop;=0A=
+				}=0A=
+			}=0A=
+		} else if (pci_find_capability(pdev, PCI_CAP_ID_MSI)) {=0A=
+			if (!pci_enable_msi(pdev)) {=0A=
+				acb->acb_flags |=3D ACB_F_MSI_ENABLED;=0A=
+			}=0A=
+			if (request_irq(pdev->irq, arcmsr_do_interrupt,=0A=
+				IRQF_SHARED, "arcmsr", acb)) {=0A=
+				goto controller_stop;=0A=
+			}=0A=
+		} else {=0A=
+			if (request_irq(pdev->irq, arcmsr_do_interrupt,=0A=
+				IRQF_SHARED, "arcmsr", acb)) {=0A=
+				goto controller_stop;=0A=
+			}=0A=
 		}=0A=
 		INIT_WORK(&acb->arcmsr_do_message_isr_bh,=0A=
 		arcmsr_message_isr_bh_fn);=0A=
@@ -757,8 +805,9 @@ static int arcmsr_probe(struct pci_dev *=0A=
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
@@ -815,10 +864,46 @@ static int arcmsr_probe(struct pci_dev *=0A=
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
@@ -838,6 +923,11 @@ static int arcmsr_probe(struct pci_dev *=0A=
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
@@ -1050,11 +1140,11 @@ arcmsr_report_ccb_state(struct AdapterCo=0A=
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
@@ -1076,7 +1166,7 @@ struct CommandControlBlock *pCCB, bool e=0A=
 				lun =3D abortcmd->device->lun;=0A=
 				abortcmd->result |=3D DID_ABORT << 16;=0A=
 				arcmsr_ccb_complete(pCCB);=0A=
-				pr_notice("arcmsr%d: pCCB =3D'0x%p' isr"=0A=
+				pr_notice("arcmsr%d: pCCB =3D '0x%p' isr"=0A=
 				"got aborted command\n",=0A=
 				acb->host->host_no, pCCB);=0A=
 			}=0A=
@@ -1086,12 +1176,12 @@ struct CommandControlBlock *pCCB, bool e=0A=
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

------=_NextPart_000_0012_01CE0605.318F4880--
