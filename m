From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: RE: [PATCH] aacraid: switch to pci_alloc_irq_vectors
Date: Wed, 16 Nov 2016 17:14:36 +0000
Message-ID: <4D8E82A446BF54499747901DBDEB737A573F6391@avsrvexchmbx2.microsemi.net>
References: <1478589090-74217-1-git-send-email-hare@suse.de>
 <4D8E82A446BF54499747901DBDEB737A573F569D@avsrvexchmbx2.microsemi.net>
 <92bffeba-90cd-513e-6a01-8d7b5e8ec328@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0054.outbound.protection.outlook.com ([104.47.36.54]:64336
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S934289AbcKPRqt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 16 Nov 2016 12:46:49 -0500
In-Reply-To: <92bffeba-90cd-513e-6a01-8d7b5e8ec328@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.com>, dl-esc-Aacraid Linux Driver <aacraid@microsemi.com>



> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Tuesday, November 15, 2016 11:37 PM
> To: Raghava Aditya Renukunta; Martin K. Petersen
> Cc: Christoph Hellwig; James Bottomley; linux-scsi@vger.kernel.org; Hanne=
s
> Reinecke; dl-esc-Aacraid Linux Driver
> Subject: Re: [PATCH] aacraid: switch to pci_alloc_irq_vectors
>=20
> EXTERNAL EMAIL
>=20
>=20
> On 11/15/2016 08:33 PM, Raghava Aditya Renukunta wrote:
> > Hi Hannes,
> > Thank you for the patch
> >
> >> -----Original Message-----
> >> From: Hannes Reinecke [mailto:hare@suse.de]
> >> Sent: Monday, November 7, 2016 11:12 PM
> >> To: Martin K. Petersen
> >> Cc: Christoph Hellwig; James Bottomley; linux-scsi@vger.kernel.org;
> Hannes
> >> Reinecke; Hannes Reinecke; dl-esc-Aacraid Linux Driver
> >> Subject: [PATCH] aacraid: switch to pci_alloc_irq_vectors
> >>
> >> EXTERNAL EMAIL
> >>
> >>
> >> Use pci_alloc_irq_vectors and drop the hand-crafted
> >> interrupt affinity routines.
> >>
> >> Signed-off-by: Hannes Reinecke <hare@suse.com>
> >> Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
> >> ---
> >>  drivers/scsi/aacraid/aacraid.h  |  1 -
> >>  drivers/scsi/aacraid/comminit.c | 10 +++-------
> >>  drivers/scsi/aacraid/commsup.c  | 25 +++++--------------------
> >>  drivers/scsi/aacraid/linit.c    | 20 ++++----------------
> >>  4 files changed, 12 insertions(+), 44 deletions(-)
> >>
> >> diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aac=
raid.h
> >> index 969c312..f059c14 100644
> >> --- a/drivers/scsi/aacraid/aacraid.h
> >> +++ b/drivers/scsi/aacraid/aacraid.h
> >> @@ -1246,7 +1246,6 @@ struct aac_dev
> >>         u32                     max_msix;       /* max. MSI-X vectors =
*/
> >>         u32                     vector_cap;     /* MSI-X vector capab.=
*/
> >>         int                     msi_enabled;    /* MSI/MSI-X enabled *=
/
> >> -       struct msix_entry       msixentry[AAC_MAX_MSIX];
> >>         struct aac_msix_ctx     aac_msix[AAC_MAX_MSIX]; /* context */
> >>         u8                      adapter_shutdown;
> >>         u32                     handle_pci_error;
> >> diff --git a/drivers/scsi/aacraid/comminit.c
> b/drivers/scsi/aacraid/comminit.c
> >> index 341ea32..4f56b10 100644
> >> --- a/drivers/scsi/aacraid/comminit.c
> >> +++ b/drivers/scsi/aacraid/comminit.c
> >> @@ -378,16 +378,12 @@ void aac_define_int_mode(struct aac_dev
> *dev)
> >>         if (msi_count > AAC_MAX_MSIX)
> >>                 msi_count =3D AAC_MAX_MSIX;
> >>
> >> -       for (i =3D 0; i < msi_count; i++)
> >> -               dev->msixentry[i].entry =3D i;
> >> -
> >>         if (msi_count > 1 &&
> >>             pci_find_capability(dev->pdev, PCI_CAP_ID_MSIX)) {
> >>                 min_msix =3D 2;
> >> -               i =3D pci_enable_msix_range(dev->pdev,
> >> -                                   dev->msixentry,
> >> -                                   min_msix,
> >> -                                   msi_count);
> >> +               i =3D pci_alloc_irq_vectors(dev->pdev,
> >> +                                         min_msix, msi_count,
> >> +                                         PCI_IRQ_MSIX | PCI_IRQ_AFFIN=
ITY);
> >>                 if (i > 0) {
> >>                         dev->msi_enabled =3D 1;
> >>                         msi_count =3D i;
> >> diff --git a/drivers/scsi/aacraid/commsup.c
> b/drivers/scsi/aacraid/commsup.c
> >> index 0aeecec..9e7551f 100644
> >> --- a/drivers/scsi/aacraid/commsup.c
> >> +++ b/drivers/scsi/aacraid/commsup.c
> >> @@ -2043,30 +2043,22 @@ int aac_acquire_irq(struct aac_dev *dev)
> >>         int i;
> >>         int j;
> >>         int ret =3D 0;
> >> -       int cpu;
> >>
> >> -       cpu =3D cpumask_first(cpu_online_mask);
> >>         if (!dev->sync_mode && dev->msi_enabled && dev->max_msix > 1) =
{
> >>                 for (i =3D 0; i < dev->max_msix; i++) {
> >>                         dev->aac_msix[i].vector_no =3D i;
> >>                         dev->aac_msix[i].dev =3D dev;
> >> -                       if (request_irq(dev->msixentry[i].vector,
> >> +                       if (request_irq(pci_irq_vector(dev->pdev, i),
> >>                                         dev->a_ops.adapter_intr,
> >>                                         0, "aacraid", &(dev->aac_msix[=
i]))) {
> >>                                 printk(KERN_ERR "%s%d: Failed to regis=
ter IRQ for vector
> >> %d.\n",
> >>                                                 dev->name, dev->id, i)=
;
> >>                                 for (j =3D 0 ; j < i ; j++)
> >> -                                       free_irq(dev->msixentry[j].vec=
tor,
> >> +                                       free_irq(pci_irq_vector(dev->p=
dev, j),
> >>                                                  &(dev->aac_msix[j]));
> >>                                 pci_disable_msix(dev->pdev);
> >>                                 ret =3D -1;
> >>                         }
> >> -                       if (irq_set_affinity_hint(dev->msixentry[i].ve=
ctor,
> >> -                                                       get_cpu_mask(c=
pu))) {
> >> -                               printk(KERN_ERR "%s%d: Failed to set I=
RQ affinity for cpu
> >> %d\n",
> >> -                                           dev->name, dev->id, cpu);
> >> -                       }
> >> -                       cpu =3D cpumask_next(cpu, cpu_online_mask);
> >
> > Is there a reason why the irq_set_affinity_hint was removed? Will the
> PCI_IRQ_AFFINITY flag enable hints?
> >
> Precisely.
> Setting the PCI_IRQ_AFFINITY flag will instruct the PCI subsystem to set
> the interrupt affinity.
> It will take the physical layout of CPU cores into account, so the
> results will be far better matched to the actual system.
>=20
> Cheers,
>=20
> Hannes
Yes I looked at the code and It looks good.=20
Thank you

Reviewed-by: Raghava Aditya Renukunta <raghavaaditya.renukunta@microsemi.co=
m>

> --
> Dr. Hannes Reinecke                Teamlead Storage & Networking
> hare@suse.de                                   +49 911 74053 688
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
> HRB 21284 (AG N=FCrnberg)
