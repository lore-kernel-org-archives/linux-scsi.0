From: Prarit Bhargava <prarit@redhat.com>
Subject: [PATCH]: be2iscsi: Fix MSIX interrupt names
Date: Fri, 20 May 2011 14:12:57 -0400
Message-ID: <4DD6AF29.8090903@redhat.com>
References: <4DD6AEB7.2090900@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14175 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933693Ab1ETSNA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 May 2011 14:13:00 -0400
In-Reply-To: <4DD6AEB7.2090900@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jayamohank@serverengines.com, mchristi@redhat.com


The be2iscsi driver uses a single static array in a function for the
irq action->name field.

This results in /proc/interrupts output like

156:  0          0          0          0          0          0         =
 0=20
0          0          0          0          0          0          0    =
      0=20
        0          0          0          0          0          0       =
   0   =20
     0          0       PCI-MSI-X=20
W=EF=BF=BD9=EF=BF=BD_=DE=B2J=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=
=EF=BF=BDt=EF=BF=BD=EF=BF=BDkfbY=EF=BF=BD=EF=BF=BD~}=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD(p=EF=BF=BD=EF=BF=BD=EF=BF=BD%=EF=BF=BD=EF=BF=BD=EF=BF=BD=
'loCm=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDn`!=
=EF=BF=BDv=EF=BF=BD=EF=BF=BD%=EF=BF=BD4=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BDb\"P=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD/"=EF=BF=BDt=EF=BF=BD=
=EF=BF=BD=EF=BF=BD(b=EF=BF=BD=EF=BF=BDI=EF=BF=BD=EF=BF=BD=D4=AB=EF=BF=BD=
=EF=BF=BD1/"=EF=BF=BD=EF=BF=BDRm=EF=BF=BDu~=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD

                                                          =20
=EF=BF=BD8r=EF=BF=BD)=EF=BF=BDN=EF=BF=BD>\aj*=EF=BF=BD=EF=BF=BD+=EF=BF=BD=
=D0=B5=EF=BF=BD=EF=BF=BD=DB=BB=EF=BF=BDwB=E4=9D=9F=EF=BF=BDBl=EF=BF=BD=EF=
=BF=BD

In the line above, everything up to PCI-MSI-X is correct.  The pointer =
for
action->name is garbage and scribbles the output on the screen.

This patch fixes the problem:

156:          0          0          0          0          0          0 =
         0          0          0          0          0          0      =
    0          0          0          0          0          0          0=
          0          0          0          0          0       PCI-MSI-X=
  beiscsi_msix_0017

P.

---->8----

=46ix be2iscsi driver to use a separate pointer for each irq action->na=
me field
and avoid display corruption in /proc/interrupts.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be=
_main.c
index 24e20ba..8d71e47 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -874,16 +874,20 @@ static int beiscsi_init_irqs(struct beiscsi_hba *=
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
+			phba->msi_name[i] =3D kzalloc(BEISCSI_MSI_NAME,
+						    GFP_KERNEL);
+			if (!phba->msi_name[i])
+				goto free_msix_irqs;
+			sprintf(phba->msi_name[i], "beiscsi_msix_%04x", i);
 			msix_vec =3D phba->msix_entries[i].vector;
-			ret =3D request_irq(msix_vec, be_isr_msix, 0, desc,
+			ret =3D request_irq(msix_vec, be_isr_msix, 0,
+					  phba->msi_name[i],
 					  &phwi_context->be_eq[i]);
 			if (ret) {
 				shost_printk(KERN_ERR, phba->shost,
@@ -915,8 +919,10 @@ static int beiscsi_init_irqs(struct beiscsi_hba *p=
hba)
 	}
 	return 0;
 free_msix_irqs:
-	for (j =3D i - 1; j =3D=3D 0; j++)
+	for (j =3D i - 1; j =3D=3D 0; j++) {
 		free_irq(msix_vec, &phwi_context->be_eq[j]);
+		kfree(phba->msi_name[i]);
+	}
 	return ret;
 }
=20
@@ -4117,10 +4123,13 @@ static void beiscsi_remove(struct pci_dev *pcid=
ev)
 		for (i =3D 0; i <=3D phba->num_cpus; i++) {
 			msix_vec =3D phba->msix_entries[i].vector;
 			free_irq(msix_vec, &phwi_context->be_eq[i]);
+			kfree(phba->msi_name[i]);
 		}
 	} else
-		if (phba->pcidev->irq)
+		if (phba->pcidev->irq) {
 			free_irq(phba->pcidev->irq, phba);
+			kfree(phba->msi_name[i]);
+		}
 	pci_disable_msix(phba->pcidev);
 	destroy_workqueue(phba->wq);
 	if (blk_iopoll_enabled)
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be=
_main.h
index 90eb74f..0c97e5a 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -163,6 +163,8 @@ do {							\
 #define PAGES_REQUIRED(x) \
 	((x < PAGE_SIZE) ? 1 :  ((x + PAGE_SIZE - 1) / PAGE_SIZE))
=20
+#define BEISCSI_MSI_NAME 20 /* size of msi_name string */
+
 enum be_mem_enum {
 	HWI_MEM_ADDN_CONTEXT,
 	HWI_MEM_WRB,
@@ -288,6 +290,7 @@ struct beiscsi_hba {
 	unsigned int num_cpus;
 	unsigned int nxt_cqid;
 	struct msix_entry msix_entries[MAX_CPUS + 1];
+	char * msi_name[MAX_CPUS + 1];
 	bool msix_enabled;
 	struct be_mem_descriptor *init_mem;
=20
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
