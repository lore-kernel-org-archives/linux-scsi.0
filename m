From: Don Brace <don.brace@microsemi.com>
Subject: RE: [PATCH] hpsa: switch to pci_alloc_irq_vectors
Date: Wed, 9 Nov 2016 15:32:48 +0000
Message-ID: <4993A297653ECB4581FA5C3C31323D193B083C61@avsrvexchmbx1.microsemi.net>
References: <1478589145-74280-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0073.outbound.protection.outlook.com ([104.47.32.73]:41567
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753378AbcKIPeE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 9 Nov 2016 10:34:04 -0500
In-Reply-To: <1478589145-74280-1-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.com>

> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Tuesday, November 08, 2016 1:12 AM
> To: Martin K. Petersen
> Cc: Christoph Hellwig; James Bottomley; linux-scsi@vger.kernel.org; Hanne=
s
> Reinecke; Hannes Reinecke; Don Brace
> Subject: [PATCH] hpsa: switch to pci_alloc_irq_vectors
>=20
> EXTERNAL EMAIL
>=20
>=20
> Use pci_alloc_irq_vectors and drop the hand-crafted
> interrupt affinity routines.
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> Cc: Don Brace <don.brace@microsemi.com>

Do we need to add an entry for map_queues?

Are you and Christoph still working on this patch? :)

Thanks,
Don Brace

ESC - Smart Storage
Microsemi Corporation




> ---
>  drivers/scsi/hpsa.c | 72 +++++++++++++++++++----------------------------=
------
>  drivers/scsi/hpsa.h |  1 -
>  2 files changed, 26 insertions(+), 47 deletions(-)
>=20
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 4e82b69..104e699 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -5618,7 +5618,7 @@ static int hpsa_scsi_host_alloc(struct ctlr_info *h=
)
>         sh->sg_tablesize =3D h->maxsgentries;
>         sh->transportt =3D hpsa_sas_transport_template;
>         sh->hostdata[0] =3D (unsigned long) h;
> -       sh->irq =3D h->intr[h->intr_mode];
> +       sh->irq =3D pci_irq_vector(h->pdev, h->intr_mode);
>         sh->unique_id =3D sh->irq;
>=20
>         h->scsi_host =3D sh;
> @@ -7667,14 +7667,9 @@ static void hpsa_disable_interrupt_mode(struct
> ctlr_info *h)
>   */
>  static void hpsa_interrupt_mode(struct ctlr_info *h)
>  {
> +       unsigned int irq_flags =3D PCI_IRQ_LEGACY;
>  #ifdef CONFIG_PCI_MSI
> -       int err, i;
> -       struct msix_entry hpsa_msix_entries[MAX_REPLY_QUEUES];
> -
> -       for (i =3D 0; i < MAX_REPLY_QUEUES; i++) {
> -               hpsa_msix_entries[i].vector =3D 0;
> -               hpsa_msix_entries[i].entry =3D i;
> -       }
> +       int err;
>=20
>         /* Some boards advertise MSI but don't really support it */
>         if ((h->board_id =3D=3D 0x40700E11) || (h->board_id =3D=3D 0x4080=
0E11) ||
> @@ -7685,8 +7680,8 @@ static void hpsa_interrupt_mode(struct ctlr_info
> *h)
>                 h->msix_vector =3D MAX_REPLY_QUEUES;
>                 if (h->msix_vector > num_online_cpus())
>                         h->msix_vector =3D num_online_cpus();
> -               err =3D pci_enable_msix_range(h->pdev, hpsa_msix_entries,
> -                                           1, h->msix_vector);
> +               err =3D pci_alloc_irq_vectors(h->pdev, 1, h->msix_vector,
> +                                           PCI_IRQ_MSIX | PCI_IRQ_AFFINI=
TY);
>                 if (err < 0) {
>                         dev_warn(&h->pdev->dev, "MSI-X init failed %d\n",=
 err);
>                         h->msix_vector =3D 0;
> @@ -7696,22 +7691,21 @@ static void hpsa_interrupt_mode(struct ctlr_info
> *h)
>                                "available\n", err);
>                 }
>                 h->msix_vector =3D err;
> -               for (i =3D 0; i < h->msix_vector; i++)
> -                       h->intr[i] =3D hpsa_msix_entries[i].vector;
>                 return;
>         }
>  single_msi_mode:
>         if (pci_find_capability(h->pdev, PCI_CAP_ID_MSI)) {
>                 dev_info(&h->pdev->dev, "MSI capable controller\n");
> -               if (!pci_enable_msi(h->pdev))
> +               if (!pci_enable_msi(h->pdev)) {
>                         h->msi_vector =3D 1;
> -               else
> +                       irq_flags =3D PCI_IRQ_MSI;
> +               } else
>                         dev_warn(&h->pdev->dev, "MSI init failed\n");
>         }
>  default_int_mode:
>  #endif                         /* CONFIG_PCI_MSI */
>         /* if we get here we're going to use the default interrupt mode *=
/
> -       h->intr[h->intr_mode] =3D h->pdev->irq;
> +       pci_alloc_irq_vectors(h->pdev, 1, 1, irq_flags);
>  }
>=20
>  static int hpsa_lookup_board_id(struct pci_dev *pdev, u32 *board_id)
> @@ -8236,17 +8230,6 @@ static int hpsa_alloc_cmd_pool(struct ctlr_info *h=
)
>         return -ENOMEM;
>  }
>=20
> -static void hpsa_irq_affinity_hints(struct ctlr_info *h)
> -{
> -       int i, cpu;
> -
> -       cpu =3D cpumask_first(cpu_online_mask);
> -       for (i =3D 0; i < h->msix_vector; i++) {
> -               irq_set_affinity_hint(h->intr[i], get_cpu_mask(cpu));
> -               cpu =3D cpumask_next(cpu, cpu_online_mask);
> -       }
> -}
> -
>  /* clear affinity hints and free MSI-X, MSI, or legacy INTx vectors */
>  static void hpsa_free_irqs(struct ctlr_info *h)
>  {
> @@ -8255,15 +8238,13 @@ static void hpsa_free_irqs(struct ctlr_info *h)
>         if (!h->msix_vector || h->intr_mode !=3D PERF_MODE_INT) {
>                 /* Single reply queue, only one irq to free */
>                 i =3D h->intr_mode;
> -               irq_set_affinity_hint(h->intr[i], NULL);
> -               free_irq(h->intr[i], &h->q[i]);
> +               free_irq(pci_irq_vector(h->pdev, i), &h->q[i]);
>                 h->q[i] =3D 0;
>                 return;
>         }
>=20
>         for (i =3D 0; i < h->msix_vector; i++) {
> -               irq_set_affinity_hint(h->intr[i], NULL);
> -               free_irq(h->intr[i], &h->q[i]);
> +               free_irq(pci_irq_vector(h->pdev, i), &h->q[i]);
>                 h->q[i] =3D 0;
>         }
>         for (; i < MAX_REPLY_QUEUES; i++)
> @@ -8288,17 +8269,18 @@ static int hpsa_request_irqs(struct ctlr_info *h,
>                 /* If performant mode and MSI-X, use multiple reply queue=
s */
>                 for (i =3D 0; i < h->msix_vector; i++) {
>                         sprintf(h->intrname[i], "%s-msix%d", h->devname, =
i);
> -                       rc =3D request_irq(h->intr[i], msixhandler,
> -                                       0, h->intrname[i],
> -                                       &h->q[i]);
> +                       rc =3D request_irq(pci_irq_vector(h->pdev, i),
> +                                        msixhandler, 0, h->intrname[i],
> +                                        &h->q[i]);
>                         if (rc) {
>                                 int j;
>=20
>                                 dev_err(&h->pdev->dev,
>                                         "failed to get irq %d for %s\n",
> -                                      h->intr[i], h->devname);
> +                                       pci_irq_vector(h->pdev, i), h->de=
vname);
>                                 for (j =3D 0; j < i; j++) {
> -                                       free_irq(h->intr[j], &h->q[j]);
> +                                       free_irq(pci_irq_vector(h->pdev, =
i),
> +                                                &h->q[j]);
>                                         h->q[j] =3D 0;
>                                 }
>                                 for (; j < MAX_REPLY_QUEUES; j++)
> @@ -8306,7 +8288,6 @@ static int hpsa_request_irqs(struct ctlr_info *h,
>                                 return rc;
>                         }
>                 }
> -               hpsa_irq_affinity_hints(h);
>         } else {
>                 /* Use single reply pool */
>                 if (h->msix_vector > 0 || h->msi_vector) {
> @@ -8316,23 +8297,22 @@ static int hpsa_request_irqs(struct ctlr_info *h,
>                         else
>                                 sprintf(h->intrname[h->intr_mode],
>                                         "%s-msi", h->devname);
> -                       rc =3D request_irq(h->intr[h->intr_mode],
> -                               msixhandler, 0,
> -                               h->intrname[h->intr_mode],
> -                               &h->q[h->intr_mode]);
> +                       rc =3D request_irq(pci_irq_vector(h->pdev, h->int=
r_mode),
> +                                        msixhandler, 0,
> +                                        h->intrname[h->intr_mode],
> +                                        &h->q[h->intr_mode]);
>                 } else {
>                         sprintf(h->intrname[h->intr_mode],
>                                 "%s-intx", h->devname);
> -                       rc =3D request_irq(h->intr[h->intr_mode],
> -                               intxhandler, IRQF_SHARED,
> -                               h->intrname[h->intr_mode],
> -                               &h->q[h->intr_mode]);
> +                       rc =3D request_irq(pci_irq_vector(h->pdev, h->int=
r_mode),
> +                                        intxhandler, IRQF_SHARED,
> +                                        h->intrname[h->intr_mode],
> +                                        &h->q[h->intr_mode]);
>                 }
> -               irq_set_affinity_hint(h->intr[h->intr_mode], NULL);
>         }
>         if (rc) {
>                 dev_err(&h->pdev->dev, "failed to get irq %d for %s\n",
> -                      h->intr[h->intr_mode], h->devname);
> +                       pci_irq_vector(h->pdev, h->intr_mode), h->devname=
);
>                 hpsa_free_irqs(h);
>                 return -ENODEV;
>         }
> diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
> index 82cdfad..a10a24c 100644
> --- a/drivers/scsi/hpsa.h
> +++ b/drivers/scsi/hpsa.h
> @@ -175,7 +175,6 @@ struct ctlr_info {
>  #      define DOORBELL_INT     1
>  #      define SIMPLE_MODE_INT  2
>  #      define MEMQ_MODE_INT    3
> -       unsigned int intr[MAX_REPLY_QUEUES];
>         unsigned int msix_vector;
>         unsigned int msi_vector;
>         int intr_mode; /* either PERF_MODE_INT or SIMPLE_MODE_INT */
> --
> 1.8.5.6

