From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v2 3/6] lpfc: Use pci_(request|release)_mem_regions
Date: Mon, 6 Jun 2016 10:12:51 +0200
Message-ID: <20160606081251.crfzyn7tvmbk4tpb@c203.arch.suse.de>
References: <cover.1464795082.git.jthumshirn@suse.de>
 <51b9bf3879e440da6c34094dfd1ee765f94f51c3.1464795082.git.jthumshirn@suse.de>
 <CAGx+d6eHPKvOM_aYgv9qJvA1siJ89PzwHtK07U9tKs3yG7=O9w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGx+d6eHPKvOM_aYgv9qJvA1siJ89PzwHtK07U9tKs3yG7=O9w@mail.gmail.com>
Sender: linux-pci-owner@vger.kernel.org
To: Dick Kennedy <dick.kennedy@broadcom.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jun 02, 2016 at 07:57:43AM -0400, Dick Kennedy wrote:
> Thanks Johannes, it looks good.
Hi Dick,=20

Can I use this as an Acked-by in the next submission?

Thanks,
	Johannes

>=20
> On Thu, Jun 2, 2016 at 3:30 AM, Johannes Thumshirn <jthumshirn@suse.d=
e>
> wrote:
>=20
> > Now that we do have pci_request_mem_regions() and
> > pci_release_mem_regions() at
> > hand, use it in the lpfc driver.
> >
> > Suggested-by: Christoph Hellwig <hch@infradead.org>
> > Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> > Cc: James Smart <james.smart@avagotech.com>
> > Cc: Dick Kennedy <dick.kennedy@avagotech.com>
> > Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
> > Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> > Cc: linux-scsi@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > ---
> >  drivers/scsi/lpfc/lpfc_init.c | 15 ++++-----------
> >  1 file changed, 4 insertions(+), 11 deletions(-)
> >
> > diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc=
_init.c
> > index f57d02c..a8735f7 100644
> > --- a/drivers/scsi/lpfc/lpfc_init.c
> > +++ b/drivers/scsi/lpfc/lpfc_init.c
> > @@ -4775,20 +4775,17 @@ static int
> >  lpfc_enable_pci_dev(struct lpfc_hba *phba)
> >  {
> >         struct pci_dev *pdev;
> > -       int bars =3D 0;
> >
> >         /* Obtain PCI device reference */
> >         if (!phba->pcidev)
> >                 goto out_error;
> >         else
> >                 pdev =3D phba->pcidev;
> > -       /* Select PCI BARs */
> > -       bars =3D pci_select_bars(pdev, IORESOURCE_MEM);
> >         /* Enable PCI device */
> >         if (pci_enable_device_mem(pdev))
> >                 goto out_error;
> >         /* Request PCI resource for the device */
> > -       if (pci_request_selected_regions(pdev, bars, LPFC_DRIVER_NA=
ME))
> > +       if (pci_request_mem_regions(pdev, LPFC_DRIVER_NAME))
> >                 goto out_disable_device;
> >         /* Set up device as PCI master and save state for EEH */
> >         pci_set_master(pdev);
> > @@ -4805,7 +4802,7 @@ out_disable_device:
> >         pci_disable_device(pdev);
> >  out_error:
> >         lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
> > -                       "1401 Failed to enable pci device, bars:x%x=
\n",
> > bars);
> > +                       "1401 Failed to enable pci device\n");
> >         return -ENODEV;
> >  }
> >
> > @@ -4820,17 +4817,14 @@ static void
> >  lpfc_disable_pci_dev(struct lpfc_hba *phba)
> >  {
> >         struct pci_dev *pdev;
> > -       int bars;
> >
> >         /* Obtain PCI device reference */
> >         if (!phba->pcidev)
> >                 return;
> >         else
> >                 pdev =3D phba->pcidev;
> > -       /* Select PCI BARs */
> > -       bars =3D pci_select_bars(pdev, IORESOURCE_MEM);
> >         /* Release PCI resource and disable PCI device */
> > -       pci_release_selected_regions(pdev, bars);
> > +       pci_release_mem_regions(pdev);
> >         pci_disable_device(pdev);
> >
> >         return;
> > @@ -9705,7 +9699,6 @@ lpfc_pci_remove_one_s3(struct pci_dev *pdev)
> >         struct lpfc_vport **vports;
> >         struct lpfc_hba   *phba =3D vport->phba;
> >         int i;
> > -       int bars =3D pci_select_bars(pdev, IORESOURCE_MEM);
> >
> >         spin_lock_irq(&phba->hbalock);
> >         vport->load_flag |=3D FC_UNLOADING;
> > @@ -9780,7 +9773,7 @@ lpfc_pci_remove_one_s3(struct pci_dev *pdev)
> >
> >         lpfc_hba_free(phba);
> >
> > -       pci_release_selected_regions(pdev, bars);
> > +       pci_release_mem_regions(pdev);
> >         pci_disable_device(pdev);
> >  }
> >
> > --
> > 1.8.5.6
> >
> >

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
