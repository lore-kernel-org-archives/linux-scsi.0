From: adam radford <aradford@gmail.com>
Subject: Re: [PATCH] scsi: 3ware: fix return 0 on the error path of probe
Date: Mon, 30 Jul 2018 11:31:13 -0700
Message-ID: <CAHtARFGDRWNBZJ=nYagWoZJg-ve1oYheJzuoY0_ehght1Ckt6g@mail.gmail.com>
References: <20180727135157.13051-1-vasilyev@ispras.ru> <CAHtARFGRBk_1yG3sfZetCOKmoKegwEK5uH1Rco5-K4ussyMVxQ@mail.gmail.com>
 <CALy29_0ZOR=3c_2nrfQEmbH8k=Oqx5x9nhhVDp2jV6ksx6XENw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALy29_0ZOR=3c_2nrfQEmbH8k=Oqx5x9nhhVDp2jV6ksx6XENw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: anton.vasilyev.87@gmail.com
Cc: vasilyev@ispras.ru, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, ldv-project@linuxtesting.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Jul 28, 2018 at 8:18 AM Anton Vasilyev
<anton.vasilyev.87@gmail.com> wrote:
>
> Adam,
>
> 3w-9xxx: twa_probe():
>
> There is check of retval:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/d=
rivers/scsi/3w-9xxx.c#n2010
>
> retval without assignement is 0 on fail of twa_initialize_device_extensio=
n():
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/d=
rivers/scsi/3w-9xxx.c#n2040
>
> And this 0 is returned from probe on the error path.
>
> Same pattern is true for all other cases from patch.
>
> -Anton
>
> 27 =D0=B8=D1=8E=D0=BB. 2018 =D0=B3. 9:42 =D0=9F=D0=9F =D0=BF=D0=BE=D0=BB=
=D1=8C=D0=B7=D0=BE=D0=B2=D0=B0=D1=82=D0=B5=D0=BB=D1=8C "adam radford" <arad=
ford@gmail.com> =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BB:
>
> On Fri, Jul 27, 2018 at 6:52 AM Anton Vasilyev <vasilyev@ispras.ru> wrote=
:
> >
> > tw_probe() returns 0 in case of fail of tw_initialize_device_extension(=
),
> > pci_resource_start() or tw_reset_sequence() and releases resources.
> > twl_probe() returns 0 in case of fail of twl_initialize_device_extensio=
n(),
> > pci_iomap() and twl_reset_sequence().
> > twa_probe() returns 0 in case of fail of tw_initialize_device_extension=
(),
> > ioremap() and twa_reset_sequence().
> >
> >
> > The patch adds retval initialization for these cases.
> >
> > Found by Linux Driver Verification project (linuxtesting.org).
> >
> > Signed-off-by: Anton Vasilyev <vasilyev@ispras.ru>
> > ---
> >  drivers/scsi/3w-9xxx.c | 6 +++++-
> >  drivers/scsi/3w-sas.c  | 3 +++
> >  drivers/scsi/3w-xxxx.c | 2 ++
> >  3 files changed, 10 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
> > index 99ba4a770406..27521fc3ef5a 100644
> > --- a/drivers/scsi/3w-9xxx.c
> > +++ b/drivers/scsi/3w-9xxx.c
> > @@ -2038,6 +2038,7 @@ static int twa_probe(struct pci_dev *pdev, const =
struct pci_device_id *dev_id)
> >
> >         if (twa_initialize_device_extension(tw_dev)) {
> >                 TW_PRINTK(tw_dev->host, TW_DRIVER, 0x25, "Failed to ini=
tialize device extension");
> > +               retval =3D -ENOMEM;
> >                 goto out_free_device_extension;
> >         }
> >
> > @@ -2060,6 +2061,7 @@ static int twa_probe(struct pci_dev *pdev, const =
struct pci_device_id *dev_id)
> >         tw_dev->base_addr =3D ioremap(mem_addr, mem_len);
> >         if (!tw_dev->base_addr) {
> >                 TW_PRINTK(tw_dev->host, TW_DRIVER, 0x35, "Failed to ior=
emap");
> > +               retval =3D -ENOMEM;
> >                 goto out_release_mem_region;
> >         }
> >
> > @@ -2067,8 +2069,10 @@ static int twa_probe(struct pci_dev *pdev, const=
 struct pci_device_id *dev_id)
> >         TW_DISABLE_INTERRUPTS(tw_dev);
> >
> >         /* Initialize the card */
> > -       if (twa_reset_sequence(tw_dev, 0))
> > +       if (twa_reset_sequence(tw_dev, 0)) {
> > +               retval =3D -ENOMEM;
> >                 goto out_iounmap;
> > +       }
> >
> >         /* Set host specific parameters */
> >         if ((pdev->device =3D=3D PCI_DEVICE_ID_3WARE_9650SE) ||
> > diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
> > index cf9f2a09b47d..40c1e6e64f58 100644
> > --- a/drivers/scsi/3w-sas.c
> > +++ b/drivers/scsi/3w-sas.c
> > @@ -1594,6 +1594,7 @@ static int twl_probe(struct pci_dev *pdev, const =
struct pci_device_id *dev_id)
> >
> >         if (twl_initialize_device_extension(tw_dev)) {
> >                 TW_PRINTK(tw_dev->host, TW_DRIVER, 0x1a, "Failed to ini=
tialize device extension");
> > +               retval =3D -ENOMEM;
> >                 goto out_free_device_extension;
> >         }
> >
> > @@ -1608,6 +1609,7 @@ static int twl_probe(struct pci_dev *pdev, const =
struct pci_device_id *dev_id)
> >         tw_dev->base_addr =3D pci_iomap(pdev, 1, 0);
> >         if (!tw_dev->base_addr) {
> >                 TW_PRINTK(tw_dev->host, TW_DRIVER, 0x1c, "Failed to ior=
emap");
> > +               retval =3D -ENOMEM;
> >                 goto out_release_mem_region;
> >         }
> >
> > @@ -1617,6 +1619,7 @@ static int twl_probe(struct pci_dev *pdev, const =
struct pci_device_id *dev_id)
> >         /* Initialize the card */
> >         if (twl_reset_sequence(tw_dev, 0)) {
> >                 TW_PRINTK(tw_dev->host, TW_DRIVER, 0x1d, "Controller re=
set failed during probe");
> > +               retval =3D -ENOMEM;
> >                 goto out_iounmap;
> >         }
> >
> > diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
> > index f6179e3d6953..961ea6f7def8 100644
> > --- a/drivers/scsi/3w-xxxx.c
> > +++ b/drivers/scsi/3w-xxxx.c
> > @@ -2280,6 +2280,7 @@ static int tw_probe(struct pci_dev *pdev, const s=
truct pci_device_id *dev_id)
> >
> >         if (tw_initialize_device_extension(tw_dev)) {
> >                 printk(KERN_WARNING "3w-xxxx: Failed to initialize devi=
ce extension.");
> > +               retval =3D -ENOMEM;
> >                 goto out_free_device_extension;
> >         }
> >
> > @@ -2294,6 +2295,7 @@ static int tw_probe(struct pci_dev *pdev, const s=
truct pci_device_id *dev_id)
> >         tw_dev->base_addr =3D pci_resource_start(pdev, 0);
> >         if (!tw_dev->base_addr) {
> >                 printk(KERN_WARNING "3w-xxxx: Failed to get io address.=
");
> > +               retval =3D -ENOMEM;
> >                 goto out_release_mem_region;
> >         }
> >
> > --
> > 2.18.0
> >
>
> Anton,
>
> 3w-9xxx: twa_probe() initializes retval at the top of the function:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/d=
rivers/scsi/3w-9xxx.c#n2007
>
> so does 3w-xxxx: tw_probe():
>
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/d=
rivers/scsi/3w-xxxx.c#n2253
>
> so does 3w-sas: twl_probe():
>
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/d=
rivers/scsi/3w-sas.c#n1562
>
> so I think your patch isn't needed...
>
>
> -Adam
>
>
>

Acked-by: Adam Radford <aradford@gmail.com>
