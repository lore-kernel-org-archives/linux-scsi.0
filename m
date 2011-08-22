From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
Subject: [PATCH 1/3] be2iscsi: Fixing the /proc/interrupts problem V3
Date: Mon, 22 Aug 2011 10:08:27 -0700
Message-ID: <f9809cab-6759-4b13-b095-d2d799fd7ca1@exht1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:17366 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751592Ab1HVRJG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Aug 2011 13:09:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

Problem description, debugging and original patch from Prarit Bhargava:

=46ix be2iscsi driver to use a separate pointer for each irq action->na=
me
field and avoid display corruption in /proc/interrupts. The be2iscsi dr=
iver
was using a single static array in a function for the irq action->name =
field.
This results in /proc/interrupts output like:

156:  0          0          0          0          0          0
0
0          0          0          0          0          0          0
0
        0          0          0          0          0          0
0
     0          0       PCI-MSI-X
W=EF=BF=BD9=EF=BF=BD_=DE=B2J=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=
=EF=BF=BDt=EF=BF=BD=EF=BF=BDkfbY=EF=BF=BD=EF=BF=BD~}=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD(p=EF=BF=BD=EF=BF=BD=EF=BF=BD%=EF=BF=BD=EF=BF=BD=EF=BF=BD=
'loCm=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDn`!=
=EF=BF=BDv=EF=BF=BD=EF=BF=BD%=EF=BF=BD4=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BDb\"P=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD/"=EF=BF=BDt=EF=BF=BD=
=EF=BF=BD=EF=BF=BD(b=EF=BF=BD=EF=BF=BDI=EF=BF=BD=EF=BF=BD=D4=AB=EF=BF=BD=
=EF=BF=BD1/"=EF=BF=BD=EF=BF=BDRm=EF=BF=BDu~=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD

=EF=BF=BD8r=EF=BF=BD)=EF=BF=BDN=EF=BF=BD>\aj*=EF=BF=BD=EF=BF=BD+=EF=BF=BD=
=D0=B5=EF=BF=BD=EF=BF=BD=DB=BB=EF=BF=BDwB=E4=9D=9F=EF=BF=BDBl=EF=BF=BD=EF=
=BF=BD

In the line above, everything up to PCI-MSI-X is correct.  The pointer
for
action->name is garbage and scribbles the output on the screen.

This patch fixes the problem:

156:          0          0          0          0          0          0
0          0          0          0          0          0          0
0          0          0          0          0          0          0
0          0          0          0       PCI-MSI-X  beiscsi_msix_0017


This patch is based on Prarit's patch here:
http://www.spinics.net/lists/linux-scsi/msg52325.html
but I have fixed up the failure paths and removed
redundant check for !i suggested by Eike.

Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/be2iscsi/be_main.c |   33 +++++++++++++++++++++++++------=
--
 drivers/scsi/be2iscsi/be_main.h |    3 +++
 2 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be=
_main.c
index 0a9bdfa..92b9a10 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -822,33 +822,46 @@ static int beiscsi_init_irqs(struct beiscsi_hba *=
phba)
 	struct hwi_controller *phwi_ctrlr;
 	struct hwi_context_memory *phwi_context;
 	int ret, msix_vec, i, j;
-	char desc[32];
=20
 	phwi_ctrlr =3D phba->phwi_ctrlr;
 	phwi_context =3D phwi_ctrlr->phwi_ctxt;
=20
 	if (phba->msix_enabled) {
 		for (i =3D 0; i < phba->num_cpus; i++) {
-			sprintf(desc, "beiscsi_msix_%04x", i);
+			phba->msi_name[i] =3D kzalloc(BEISCSI_MSI_NAME, GFP_KERNEL);
+			if (!phba->msi_name[i]) {
+				ret =3D -ENOMEM;
+				goto free_msix_irqs;
+			}
+
+			sprintf(phba->msi_name[i], "beiscsi_%02x_%02x",
+				phba->shost->host_no, i);
 			msix_vec =3D phba->msix_entries[i].vector;
-			ret =3D request_irq(msix_vec, be_isr_msix, 0, desc,
+			ret =3D request_irq(msix_vec, be_isr_msix, 0,
+					  phba->msi_name[i],
 					  &phwi_context->be_eq[i]);
 			if (ret) {
 				shost_printk(KERN_ERR, phba->shost,
 					     "beiscsi_init_irqs-Failed to"
 					     "register msix for i =3D %d\n", i);
-				if (!i)
-					return ret;
+				kfree(phba->msi_name[i]);
 				goto free_msix_irqs;
 			}
 		}
+		phba->msi_name[i] =3D kzalloc(BEISCSI_MSI_NAME, GFP_KERNEL);
+		if (!phba->msi_name[i]) {
+			ret =3D -ENOMEM;
+			goto free_msix_irqs;
+		}
+		sprintf(phba->msi_name[i], "beiscsi_mcc_%02x",
+			phba->shost->host_no);
 		msix_vec =3D phba->msix_entries[i].vector;
-		ret =3D request_irq(msix_vec, be_isr_mcc, 0, "beiscsi_msix_mcc",
+		ret =3D request_irq(msix_vec, be_isr_mcc, 0, phba->msi_name[i],
 				  &phwi_context->be_eq[i]);
 		if (ret) {
 			shost_printk(KERN_ERR, phba->shost, "beiscsi_init_irqs-"
 				     "Failed to register beiscsi_msix_mcc\n");
-			i++;
+			kfree(phba->msi_name[i]);
 			goto free_msix_irqs;
 		}
=20
@@ -863,8 +876,11 @@ static int beiscsi_init_irqs(struct beiscsi_hba *p=
hba)
 	}
 	return 0;
 free_msix_irqs:
-	for (j =3D i - 1; j =3D=3D 0; j++)
+	for (j =3D i - 1; j >=3D 0; j--) {
+		kfree(phba->msi_name[j]);
+		msix_vec =3D phba->msix_entries[j].vector;
 		free_irq(msix_vec, &phwi_context->be_eq[j]);
+	}
 	return ret;
 }
=20
@@ -4125,6 +4141,7 @@ static void beiscsi_remove(struct pci_dev *pcidev=
)
 		for (i =3D 0; i <=3D phba->num_cpus; i++) {
 			msix_vec =3D phba->msix_entries[i].vector;
 			free_irq(msix_vec, &phwi_context->be_eq[i]);
+			kfree(phba->msi_name[i]);
 		}
 	} else
 		if (phba->pcidev->irq)
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be=
_main.h
index 081c171..1a55aee 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -162,6 +162,8 @@ do {							\
 #define PAGES_REQUIRED(x) \
 	((x < PAGE_SIZE) ? 1 :  ((x + PAGE_SIZE - 1) / PAGE_SIZE))
=20
+#define BEISCSI_MSI_NAME 20 /* size of msi_name string */
+
 enum be_mem_enum {
 	HWI_MEM_ADDN_CONTEXT,
 	HWI_MEM_WRB,
@@ -287,6 +289,7 @@ struct beiscsi_hba {
 	unsigned int num_cpus;
 	unsigned int nxt_cqid;
 	struct msix_entry msix_entries[MAX_CPUS + 1];
+	char *msi_name[MAX_CPUS + 1];
 	bool msix_enabled;
 	struct be_mem_descriptor *init_mem;
=20
--=20
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
