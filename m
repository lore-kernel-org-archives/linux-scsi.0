From: Prarit Bhargava <prarit@redhat.com>
Subject: Re: [PATCH]: be2iscsi: Fix MSIX interrupt names
Date: Tue, 24 May 2011 10:48:09 -0400
Message-ID: <4DDBC529.9020008@redhat.com>
References: <4DD6AEB7.2090900@redhat.com> <50725EF61B96174EB1803401F1A2E37335099FC989@EXMAIL.ad.emulex.com> <4DD6B83B.5000703@redhat.com> <2030549.qtzsKLDxZd@donald.sf-tec.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662Ab1EXOsT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 May 2011 10:48:19 -0400
In-Reply-To: <2030549.qtzsKLDxZd@donald.sf-tec.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Rolf Eike Beer <eike@sf-mail.de>, Jayamohan.Kallickal@emulex.com, mchristi@redhat.com

On 05/20/2011 04:17 PM, Rolf Eike Beer wrote:
>=20
> This could be simpler if you would use devres and devm_kzalloc() and=20
> devm_request_irq(). You simply need to return with error then and the=
 driver=20
> core would free everything you already allocated.
>=20
> Eike

Thanks for the suggestion Eike.

I've never used devres before.  This seems to work -- please review as =
[v3].

Thanks,

P.

---8<----

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
	     W=EF=BF=BD9=EF=BF=BD_=DE=B2J=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BDt=EF=BF=BD=EF=BF=BDkfbY=EF=BF=BD=EF=BF=BD~}=EF=BF=BD=EF=BF=
=BD=EF=BF=BD=EF=BF=BD(p=EF=BF=BD=EF=BF=BD=EF=BF=BD%=EF=BF=BD=EF=BF=BD=EF=
=BF=BD'loCm=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BDn`!=EF=BF=BDv=EF=BF=BD=EF=BF=BD%=EF=BF=BD4=EF=BF=BD=EF=BF=BD=EF=BF=BD=
=EF=BF=BDb\"P=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD/"=EF=BF=BDt=EF=
=BF=BD=EF=BF=BD=EF=BF=BD(b=EF=BF=BD=EF=BF=BDI=EF=BF=BD=EF=BF=BD=D4=AB=EF=
=BF=BD=EF=BF=BD1/"=EF=BF=BD=EF=BF=BDRm=EF=BF=BDu~=EF=BF=BD=EF=BF=BD=EF=BF=
=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD

			                                                               =20
			     =EF=BF=BD8r=EF=BF=BD)=EF=BF=BDN=EF=BF=BD>\aj*=EF=BF=BD=EF=BF=BD=
+=EF=BF=BD=D0=B5=EF=BF=BD=EF=BF=BD=DB=BB=EF=BF=BDwB=E4=9D=9F=EF=BF=BDBl=
=EF=BF=BD=EF=BF=BD

In the line above, everything up to PCI-MSI-X is correct.  The pointer =
for
action->name is garbage and scribbles the output on the screen.

This patch fixes the problem and eliminates the need for memory cleanup=
 by
using devres.

156:          0          0          0          0          0          0 =
         0          0          0          0          0          0      =
    0          0          0          0          0          0          0=
          0          0          0          0          0       PCI-MSI-X=
  beiscsi_msix_0017


Signed-off-by: Prarit Bhargava <prarit@redhat.com>

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be=
_main.c
index 94b9a07..16a83ee 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -874,40 +874,44 @@ static int beiscsi_init_irqs(struct beiscsi_hba *=
phba)
 	struct pci_dev *pcidev =3D phba->pcidev;
 	struct hwi_controller *phwi_ctrlr;
 	struct hwi_context_memory *phwi_context;
-	int ret, msix_vec, i, j;
-	char desc[32];
+	int ret, msix_vec, i;
=20
 	phwi_ctrlr =3D phba->phwi_ctrlr;
 	phwi_context =3D phwi_ctrlr->phwi_ctxt;
=20
 	if (phba->msix_enabled) {
 		for (i =3D 0; i < phba->num_cpus; i++) {
-			sprintf(desc, "beiscsi_msix_%04x", i);
+			phba->msi_name[i] =3D devm_kzalloc(&pcidev->dev, 20,
+							 GFP_KERNEL);
+			if (!phba->msi_name[i])
+				return -ENOMEM;
+			sprintf(phba->msi_name[i], "beiscsi_msix_%04x", i);
 			msix_vec =3D phba->msix_entries[i].vector;
-			ret =3D request_irq(msix_vec, be_isr_msix, 0, desc,
-					  &phwi_context->be_eq[i]);
+			ret =3D devm_request_irq(&pcidev->dev,
+					       msix_vec, be_isr_msix, 0,
+					       phba->msi_name[i],
+					       &phwi_context->be_eq[i]);
 			if (ret) {
 				shost_printk(KERN_ERR, phba->shost,
 					     "beiscsi_init_irqs-Failed to"
 					     "register msix for i =3D %d\n", i);
-				if (!i)
-					return ret;
-				goto free_msix_irqs;
+				return ret;
 			}
 		}
 		msix_vec =3D phba->msix_entries[i].vector;
-		ret =3D request_irq(msix_vec, be_isr_mcc, 0, "beiscsi_msix_mcc",
-				  &phwi_context->be_eq[i]);
+		ret =3D devm_request_irq(&pcidev->dev,
+				       msix_vec, be_isr_mcc, 0,
+				       "beiscsi_msix_mcc",
+				       &phwi_context->be_eq[i]);
 		if (ret) {
 			shost_printk(KERN_ERR, phba->shost, "beiscsi_init_irqs-"
 				     "Failed to register beiscsi_msix_mcc\n");
-			i++;
-			goto free_msix_irqs;
+			return ret;
 		}
=20
 	} else {
-		ret =3D request_irq(pcidev->irq, be_isr, IRQF_SHARED,
-				  "beiscsi", phba);
+		ret =3D devm_request_irq(&pcidev->dev, pcidev->irq, be_isr,
+				       IRQF_SHARED, "beiscsi", phba);
 		if (ret) {
 			shost_printk(KERN_ERR, phba->shost, "beiscsi_init_irqs-"
 				     "Failed to register irq\\n");
@@ -915,10 +919,6 @@ static int beiscsi_init_irqs(struct beiscsi_hba *p=
hba)
 		}
 	}
 	return 0;
-free_msix_irqs:
-	for (j =3D i - 1; j =3D=3D 0; j++)
-		free_irq(msix_vec, &phwi_context->be_eq[j]);
-	return ret;
 }
=20
 static void hwi_ring_cq_db(struct beiscsi_hba *phba,
@@ -4122,11 +4122,12 @@ static void beiscsi_remove(struct pci_dev *pcid=
ev)
 	if (phba->msix_enabled) {
 		for (i =3D 0; i <=3D phba->num_cpus; i++) {
 			msix_vec =3D phba->msix_entries[i].vector;
-			free_irq(msix_vec, &phwi_context->be_eq[i]);
+			devm_free_irq(&pcidev->dev, msix_vec,
+				      &phwi_context->be_eq[i]);
 		}
 	} else
 		if (phba->pcidev->irq)
-			free_irq(phba->pcidev->irq, phba);
+			devm_free_irq(&pcidev->dev, phba->pcidev->irq, phba);
 	pci_disable_msix(phba->pcidev);
 	destroy_workqueue(phba->wq);
 	if (blk_iopoll_enabled)
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be=
_main.h
index 081c171..1c03174 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -287,6 +287,7 @@ struct beiscsi_hba {
 	unsigned int num_cpus;
 	unsigned int nxt_cqid;
 	struct msix_entry msix_entries[MAX_CPUS + 1];
+	char *msi_name[MAX_CPUS + 1];
 	bool msix_enabled;
 	struct be_mem_descriptor *init_mem;
=20
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
