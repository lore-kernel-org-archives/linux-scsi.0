From: Jim Gill <jgill@vmware.com>
Subject: Re: [PATCH] vmw_pvscsi: switch to pci_alloc_irq_vectors
Date: Wed, 11 Jan 2017 23:55:01 +0000
Message-ID: <DM2PR0501MB15360DA877AA44D545F6EE70CB660@DM2PR0501MB1536.namprd05.prod.outlook.com>
References: <1479448958-6653-1-git-send-email-hch@lst.de>
 <yq17f7mp7gc.fsf@sermon.lab.mkp.net>,<20170108150751.GA10308@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0066.outbound.protection.outlook.com ([104.47.37.66]:25600
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932692AbdAKXzE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Jan 2017 18:55:04 -0500
In-Reply-To: <20170108150751.GA10308@infradead.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: pv-drivers <pv-drivers@vmware.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

acked by Jim Gill (jgill@vmware.com)

looks good to me.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/vmw_pvscsi.c | 104 +++++++++++++++++-------------------------=
----
 drivers/scsi/vmw_pvscsi.h |=A0=A0 5 ---
 2 files changed, 38 insertions(+), 71 deletions(-)

diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index 4a0d3cd..642dd4e 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -68,10 +68,7 @@ struct pvscsi_ctx {
=20
 struct pvscsi_adapter {
=A0=A0=A0=A0=A0=A0=A0=A0 char=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 *mmioBase;
-=A0=A0=A0=A0=A0=A0 unsigned int=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 irq;
=A0=A0=A0=A0=A0=A0=A0=A0 u8=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rev;
-=A0=A0=A0=A0=A0=A0 bool=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 use_msi;
-=A0=A0=A0=A0=A0=A0 bool=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 use_msix;
=A0=A0=A0=A0=A0=A0=A0=A0 bool=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 use_msg;
=A0=A0=A0=A0=A0=A0=A0=A0 bool=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 use_req_threshold;
=20
@@ -1160,30 +1157,26 @@ static bool pvscsi_setup_req_threshold(struct pvscs=
i_adapter *adapter,
 static irqreturn_t pvscsi_isr(int irq, void *devp)
 {
=A0=A0=A0=A0=A0=A0=A0=A0 struct pvscsi_adapter *adapter =3D devp;
-=A0=A0=A0=A0=A0=A0 int handled;
-
-=A0=A0=A0=A0=A0=A0 if (adapter->use_msi || adapter->use_msix)
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 handled =3D true;
-=A0=A0=A0=A0=A0=A0 else {
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 u32 val =3D pvscsi_read_intr_st=
atus(adapter);
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 handled =3D (val & PVSCSI_INTR_=
ALL_SUPPORTED) !=3D 0;
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (handled)
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pvscsi_=
write_intr_status(devp, val);
-=A0=A0=A0=A0=A0=A0 }
-
-=A0=A0=A0=A0=A0=A0 if (handled) {
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 unsigned long flags;
+=A0=A0=A0=A0=A0=A0 unsigned long flags;
=20
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 spin_lock_irqsave(&adapter->hw_=
lock, flags);
+=A0=A0=A0=A0=A0=A0 spin_lock_irqsave(&adapter->hw_lock, flags);
+=A0=A0=A0=A0=A0=A0 pvscsi_process_completion_ring(adapter);
+=A0=A0=A0=A0=A0=A0 if (adapter->use_msg && pvscsi_msg_pending(adapter))
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 queue_work(adapter->workqueue, =
&adapter->work);
+=A0=A0=A0=A0=A0=A0 spin_unlock_irqrestore(&adapter->hw_lock, flags);
=20
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pvscsi_process_completion_ring(=
adapter);
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (adapter->use_msg && pvscsi_=
msg_pending(adapter))
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 queue_w=
ork(adapter->workqueue, &adapter->work);
+=A0=A0=A0=A0=A0=A0 return IRQ_HANDLED;
+}
=20
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 spin_unlock_irqrestore(&adapter=
->hw_lock, flags);
-=A0=A0=A0=A0=A0=A0 }
+static irqreturn_t pvscsi_shared_isr(int irq, void *devp)
+{
+=A0=A0=A0=A0=A0=A0 struct pvscsi_adapter *adapter =3D devp;
+=A0=A0=A0=A0=A0=A0 u32 val =3D pvscsi_read_intr_status(adapter);
=20
-=A0=A0=A0=A0=A0=A0 return IRQ_RETVAL(handled);
+=A0=A0=A0=A0=A0=A0 if (!(val & PVSCSI_INTR_ALL_SUPPORTED))
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return IRQ_NONE;
+=A0=A0=A0=A0=A0=A0 pvscsi_write_intr_status(devp, val);
+=A0=A0=A0=A0=A0=A0 return pvscsi_isr(irq, devp);
 }
=20
 static void pvscsi_free_sgls(const struct pvscsi_adapter *adapter)
@@ -1195,34 +1188,10 @@ static void pvscsi_free_sgls(const struct pvscsi_ad=
apter *adapter)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 free_pages((unsigned long)=
ctx->sgl, get_order(SGL_SIZE));
 }
=20
-static int pvscsi_setup_msix(const struct pvscsi_adapter *adapter,
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 unsigned int *irq)
-{
-=A0=A0=A0=A0=A0=A0 struct msix_entry entry =3D { 0, PVSCSI_VECTOR_COMPLETI=
ON };
-=A0=A0=A0=A0=A0=A0 int ret;
-
-=A0=A0=A0=A0=A0=A0 ret =3D pci_enable_msix_exact(adapter->dev, &entry, 1);
-=A0=A0=A0=A0=A0=A0 if (ret)
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return ret;
-
-=A0=A0=A0=A0=A0=A0 *irq =3D entry.vector;
-
-=A0=A0=A0=A0=A0=A0 return 0;
-}
-
 static void pvscsi_shutdown_intr(struct pvscsi_adapter *adapter)
 {
-=A0=A0=A0=A0=A0=A0 if (adapter->irq) {
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 free_irq(adapter->irq, adapter)=
;
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 adapter->irq =3D 0;
-=A0=A0=A0=A0=A0=A0 }
-=A0=A0=A0=A0=A0=A0 if (adapter->use_msi) {
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pci_disable_msi(adapter->dev);
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 adapter->use_msi =3D 0;
-=A0=A0=A0=A0=A0=A0 } else if (adapter->use_msix) {
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pci_disable_msix(adapter->dev);
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 adapter->use_msix =3D 0;
-=A0=A0=A0=A0=A0=A0 }
+=A0=A0=A0=A0=A0=A0 free_irq(pci_irq_vector(adapter->dev, 0), adapter);
+=A0=A0=A0=A0=A0=A0 pci_free_irq_vectors(adapter->dev);
 }
=20
 static void pvscsi_release_resources(struct pvscsi_adapter *adapter)
@@ -1358,11 +1327,11 @@ static u32 pvscsi_get_max_targets(struct pvscsi_ada=
pter *adapter)
=20
 static int pvscsi_probe(struct pci_dev *pdev, const struct pci_device_id *=
id)
 {
+=A0=A0=A0=A0=A0=A0 unsigned int irq_flag =3D PCI_IRQ_MSIX | PCI_IRQ_MSI | =
PCI_IRQ_LEGACY;
=A0=A0=A0=A0=A0=A0=A0=A0 struct pvscsi_adapter *adapter;
=A0=A0=A0=A0=A0=A0=A0=A0 struct pvscsi_adapter adapter_temp;
=A0=A0=A0=A0=A0=A0=A0=A0 struct Scsi_Host *host =3D NULL;
=A0=A0=A0=A0=A0=A0=A0=A0 unsigned int i;
-=A0=A0=A0=A0=A0=A0 unsigned long flags =3D 0;
=A0=A0=A0=A0=A0=A0=A0=A0 int error;
=A0=A0=A0=A0=A0=A0=A0=A0 u32 max_id;
=20
@@ -1511,30 +1480,33 @@ static int pvscsi_probe(struct pci_dev *pdev, const=
 struct pci_device_id *id)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 goto out_reset_adapter;
=A0=A0=A0=A0=A0=A0=A0=A0 }
=20
-=A0=A0=A0=A0=A0=A0 if (!pvscsi_disable_msix &&
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pvscsi_setup_msix(adapter, &adapter->irq) =
=3D=3D 0) {
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 printk(KERN_INFO "vmw_pvscsi: u=
sing MSI-X\n");
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 adapter->use_msix =3D 1;
-=A0=A0=A0=A0=A0=A0 } else if (!pvscsi_disable_msi && pci_enable_msi(pdev) =
=3D=3D 0) {
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 printk(KERN_INFO "vmw_pvscsi: u=
sing MSI\n");
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 adapter->use_msi =3D 1;
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 adapter->irq =3D pdev->irq;
-=A0=A0=A0=A0=A0=A0 } else {
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 printk(KERN_INFO "vmw_pvscsi: u=
sing INTx\n");
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 adapter->irq =3D pdev->irq;
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 flags =3D IRQF_SHARED;
-=A0=A0=A0=A0=A0=A0 }
+=A0=A0=A0=A0=A0=A0 if (pvscsi_disable_msix)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 irq_flag &=3D ~PCI_IRQ_MSIX;
+=A0=A0=A0=A0=A0=A0 if (pvscsi_disable_msi)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 irq_flag &=3D ~PCI_IRQ_MSI;
+
+=A0=A0=A0=A0=A0=A0 error =3D pci_alloc_irq_vectors(adapter->dev, 1, 1, irq=
_flag);
+=A0=A0=A0=A0=A0=A0 if (error)
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 goto out_reset_adapter;
=20
=A0=A0=A0=A0=A0=A0=A0=A0 adapter->use_req_threshold =3D pvscsi_setup_req_th=
reshold(adapter, true);
=A0=A0=A0=A0=A0=A0=A0=A0 printk(KERN_DEBUG "vmw_pvscsi: driver-based reques=
t coalescing %sabled\n",
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 adapter->use_req_threshold ? =
"en" : "dis");
=20
-=A0=A0=A0=A0=A0=A0 error =3D request_irq(adapter->irq, pvscsi_isr, flags,
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 "vmw_pvscsi", adapter);
+=A0=A0=A0=A0=A0=A0 if (adapter->dev->msix_enabled || adapter->dev->msi_ena=
bled) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 printk(KERN_INFO "vmw_pvscsi: u=
sing MSI%s\n",
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 adapter=
->dev->msix_enabled ? "-X" : "");
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 error =3D request_irq(pci_irq_v=
ector(pdev, 0), pvscsi_isr,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 0, "vmw_pvscsi", adapter);
+=A0=A0=A0=A0=A0=A0 } else {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 printk(KERN_INFO "vmw_pvscsi: u=
sing INTx\n");
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 error =3D request_irq(pci_irq_v=
ector(pdev, 0), pvscsi_shared_isr,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 IRQF_SHARED, "vmw_pvscsi", adapter);
+=A0=A0=A0=A0=A0=A0 }
+
=A0=A0=A0=A0=A0=A0=A0=A0 if (error) {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 printk(KERN_ERR
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "vmw_=
pvscsi: unable to request IRQ: %d\n", error);
-=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 adapter->irq =3D 0;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 goto out_reset_adapter;
=A0=A0=A0=A0=A0=A0=A0=A0 }
=20
diff --git a/drivers/scsi/vmw_pvscsi.h b/drivers/scsi/vmw_pvscsi.h
index c097d2c..b3060fe 100644
--- a/drivers/scsi/vmw_pvscsi.h
+++ b/drivers/scsi/vmw_pvscsi.h
@@ -423,11 +423,6 @@ struct PVSCSIConfigPageController {
 #define PVSCSI_MAX_INTRS=A0=A0=A0=A0=A0=A0=A0 24
=20
 /*
- * Enumeration of supported MSI-X vectors
- */
-#define PVSCSI_VECTOR_COMPLETION=A0=A0 0
-
-/*
=A0 * Misc constants for the rings.
=A0 */
=20
--=20





From: Christoph Hellwig <hch@infradead.org>
Sent: Sunday, January 8, 2017 7:07 AM
To: Martin K. Petersen
Cc: Jim Gill; Christoph Hellwig; pv-drivers; linux-scsi@vger.kernel.org
Subject: Re: [PATCH] vmw_pvscsi: switch to pci_alloc_irq_vectors
=A0=A0=A0=20
On Tue, Nov 29, 2016 at 11:38:27AM -0500, Martin K. Petersen wrote:
> >>>>> "Christoph" =3D=3D Christoph Hellwig <hch@lst.de> writes:
>=20
> Christoph> And simply the interrupt handler by splitting the INTx case
> Christoph> that needs to deal with shared interrupts into a separate
> Christoph> helper.
>=20
> Jim: Please review!

ping!
=A0=A0=A0 =
