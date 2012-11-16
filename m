From: "NickCheng" <nick.cheng@areca.com.tw>
Subject: [PATCH 3/5]  arcmsr: Support MSI and MSI-X
Date: Fri, 16 Nov 2012 19:55:45 +0800
Message-ID: <27FE1EF5FEE2443DAEF2CC2E0A059AD0@arecaaebe11fae>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_000F_01CDC434.6087ABE0"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, jejb@kernel.org
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_000F_01CDC434.6087ABE0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Nick Cheng <nick.cheng@areca.com.tw>

Support MSI or MSI-X for whole series of RAID controllers. Meanwhile correct the register access as iowrite32/ioread32 
Signed-off-by: Nick Cheng <nick.cheng@areca.com.tw>
---

------=_NextPart_000_000F_01CDC434.6087ABE0
Content-Type: application/octet-stream;
	name="patch3"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="patch3"

diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c =
b/drivers/scsi/arcmsr/arcmsr_hba.c=0A=
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2012-11-16 14:18:55.914643861 =
+0800=0A=
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2012-11-16 14:32:46.742641103 =
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
+				printk("arcmsr%d: request_irq =3D%d failed!\n",=0A=
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
+			pr_warn("arcmsr%d: request_irq =3D%d failed!\n",=0A=
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

------=_NextPart_000_000F_01CDC434.6087ABE0--
