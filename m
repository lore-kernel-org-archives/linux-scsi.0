From: Don Brace <don.brace@microsemi.com>
Subject: RE: [PATCH] hpsa: use pci_alloc_irq_vectors and automatic irq
 affinity
Date: Wed, 9 Nov 2016 21:33:07 +0000
Message-ID: <4993A297653ECB4581FA5C3C31323D193B084034@avsrvexchmbx1.microsemi.net>
References: <1478716942-6335-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0041.outbound.protection.outlook.com ([104.47.32.41]:6912
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751157AbcKIVdf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 9 Nov 2016 16:33:35 -0500
In-Reply-To: <1478716942-6335-1-git-send-email-hch@lst.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "hare@suse.de" <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@lst.de]
> Sent: Wednesday, November 09, 2016 12:42 PM
> To: Don Brace
> Cc: hare@suse.de; linux-scsi@vger.kernel.org
> Subject: [PATCH] hpsa: use pci_alloc_irq_vectors and automatic irq affini=
ty
>=20
> EXTERNAL EMAIL
>=20
>=20
> This patch converts over hpsa to use the pci_alloc_irq_vectors including
> the PCI_IRQ_AFFINITY flag that automatically assigns spread out
> irq affinity to the I/O queues.
>=20
> It also cleans up the per-ctrl interrupt state due to the use of the
> pci_irq_vector and pci_free_irq_vectors helpers that don't need to know
> the exact irq type.  Additionally it changes a little oddity in the
> existing code that was using different array indixes into the per-vector
> arrays depending on wether a controller is using a single INTx or single
> MSI irq.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Don Brace <don.brace@microsemi.com>
Tested-by: Don Brace <don.brace@microsemi.com>

> ---
>  drivers/scsi/hpsa.c | 143 ++++++++++++++++++----------------------------=
------
>  drivers/scsi/hpsa.h |   6 +--
>  2 files changed, 52 insertions(+), 97 deletions(-)
>=20
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index d007ec1..dce8f80 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -1001,7 +1001,7 @@ static void set_performant_mode(struct ctlr_info
> *h, struct CommandList *c,
>  {
>         if (likely(h->transMethod & CFGTBL_Trans_Performant)) {
>                 c->busaddr |=3D 1 | (h->blockFetchTable[c->Header.SGList]=
 << 1);
> -               if (unlikely(!h->msix_vector))
> +               if (unlikely(!h->msix_vectors))
>                         return;
>                 if (likely(reply_queue =3D=3D DEFAULT_REPLY_QUEUE))
>                         c->Header.ReplyQueue =3D
> @@ -5618,7 +5618,7 @@ static int hpsa_scsi_host_alloc(struct ctlr_info *h=
)
>         sh->sg_tablesize =3D h->maxsgentries;
>         sh->transportt =3D hpsa_sas_transport_template;
>         sh->hostdata[0] =3D (unsigned long) h;
> -       sh->irq =3D h->intr[h->intr_mode];
> +       sh->irq =3D pci_irq_vector(h->pdev, 0);
>         sh->unique_id =3D sh->irq;
>=20
>         h->scsi_host =3D sh;
> @@ -7652,67 +7652,41 @@ static int find_PCI_BAR_index(struct pci_dev
> *pdev, unsigned long pci_bar_addr)
>=20
>  static void hpsa_disable_interrupt_mode(struct ctlr_info *h)
>  {
> -       if (h->msix_vector) {
> -               if (h->pdev->msix_enabled)
> -                       pci_disable_msix(h->pdev);
> -               h->msix_vector =3D 0;
> -       } else if (h->msi_vector) {
> -               if (h->pdev->msi_enabled)
> -                       pci_disable_msi(h->pdev);
> -               h->msi_vector =3D 0;
> -       }
> +       pci_free_irq_vectors(h->pdev);
> +       h->msix_vectors =3D 0;
>  }
>=20
>  /* If MSI/MSI-X is supported by the kernel we will try to enable it on
>   * controllers that are capable. If not, we use legacy INTx mode.
>   */
> -static void hpsa_interrupt_mode(struct ctlr_info *h)
> +static int hpsa_interrupt_mode(struct ctlr_info *h)
>  {
> -#ifdef CONFIG_PCI_MSI
> -       int err, i;
> -       struct msix_entry hpsa_msix_entries[MAX_REPLY_QUEUES];
> -
> -       for (i =3D 0; i < MAX_REPLY_QUEUES; i++) {
> -               hpsa_msix_entries[i].vector =3D 0;
> -               hpsa_msix_entries[i].entry =3D i;
> -       }
> +       unsigned int flags =3D PCI_IRQ_LEGACY;
> +       int ret;
>=20
>         /* Some boards advertise MSI but don't really support it */
> -       if ((h->board_id =3D=3D 0x40700E11) || (h->board_id =3D=3D 0x4080=
0E11) ||
> -           (h->board_id =3D=3D 0x40820E11) || (h->board_id =3D=3D 0x4083=
0E11))
> -               goto default_int_mode;
> -       if (pci_find_capability(h->pdev, PCI_CAP_ID_MSIX)) {
> -               dev_info(&h->pdev->dev, "MSI-X capable controller\n");
> -               h->msix_vector =3D MAX_REPLY_QUEUES;
> -               if (h->msix_vector > num_online_cpus())
> -                       h->msix_vector =3D num_online_cpus();
> -               err =3D pci_enable_msix_range(h->pdev, hpsa_msix_entries,
> -                                           1, h->msix_vector);
> -               if (err < 0) {
> -                       dev_warn(&h->pdev->dev, "MSI-X init failed %d\n",=
 err);
> -                       h->msix_vector =3D 0;
> -                       goto single_msi_mode;
> -               } else if (err < h->msix_vector) {
> -                       dev_warn(&h->pdev->dev, "only %d MSI-X vectors "
> -                              "available\n", err);
> +       switch (h->board_id) {
> +       case 0x40700E11:
> +       case 0x40800E11:
> +       case 0x40820E11:
> +       case 0x40830E11:
> +               break;
> +       default:
> +               ret =3D pci_alloc_irq_vectors(h->pdev, 1, MAX_REPLY_QUEUE=
S,
> +                               PCI_IRQ_MSIX | PCI_IRQ_AFFINITY);
> +               if (ret > 0) {
> +                       h->msix_vectors =3D ret;
> +                       return 0;
>                 }
> -               h->msix_vector =3D err;
> -               for (i =3D 0; i < h->msix_vector; i++)
> -                       h->intr[i] =3D hpsa_msix_entries[i].vector;
> -               return;
> -       }
> -single_msi_mode:
> -       if (pci_find_capability(h->pdev, PCI_CAP_ID_MSI)) {
> -               dev_info(&h->pdev->dev, "MSI capable controller\n");
> -               if (!pci_enable_msi(h->pdev))
> -                       h->msi_vector =3D 1;
> -               else
> -                       dev_warn(&h->pdev->dev, "MSI init failed\n");
> +
> +               flags |=3D PCI_IRQ_MSI;
> +               break;
>         }
> -default_int_mode:
> -#endif                         /* CONFIG_PCI_MSI */
> -       /* if we get here we're going to use the default interrupt mode *=
/
> -       h->intr[h->intr_mode] =3D h->pdev->irq;
> +
> +       ret =3D pci_alloc_irq_vectors(h->pdev, 1, 1, flags);
> +       if (ret < 0)
> +               return ret;
> +       return 0;
>  }
>=20
>  static int hpsa_lookup_board_id(struct pci_dev *pdev, u32 *board_id)
> @@ -8068,7 +8042,9 @@ static int hpsa_pci_init(struct ctlr_info *h)
>=20
>         pci_set_master(h->pdev);
>=20
> -       hpsa_interrupt_mode(h);
> +       err =3D hpsa_interrupt_mode(h);
> +       if (err)
> +               goto clean1;
>         err =3D hpsa_pci_find_memory_BAR(h->pdev, &h->paddr);
>         if (err)
>                 goto clean2;    /* intmode+region, pci */
> @@ -8104,6 +8080,7 @@ static int hpsa_pci_init(struct ctlr_info *h)
>         h->vaddr =3D NULL;
>  clean2:        /* intmode+region, pci */
>         hpsa_disable_interrupt_mode(h);
> +clean1:
>         /*
>          * call pci_disable_device before pci_release_regions per
>          * Documentation/PCI/pci.txt
> @@ -8237,34 +8214,20 @@ static int hpsa_alloc_cmd_pool(struct ctlr_info
> *h)
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
>         int i;
>=20
> -       if (!h->msix_vector || h->intr_mode !=3D PERF_MODE_INT) {
> +       if (!h->msix_vectors || h->intr_mode !=3D PERF_MODE_INT) {
>                 /* Single reply queue, only one irq to free */
> -               i =3D h->intr_mode;
> -               irq_set_affinity_hint(h->intr[i], NULL);
> -               free_irq(h->intr[i], &h->q[i]);
> -               h->q[i] =3D 0;
> +               free_irq(pci_irq_vector(h->pdev, 0), &h->q[i]);
> +               h->q[h->intr_mode] =3D 0;
>                 return;
>         }
>=20
> -       for (i =3D 0; i < h->msix_vector; i++) {
> -               irq_set_affinity_hint(h->intr[i], NULL);
> -               free_irq(h->intr[i], &h->q[i]);
> +       for (i =3D 0; i < h->msix_vectors; i++) {
> +               free_irq(pci_irq_vector(h->pdev, i), &h->q[i]);
>                 h->q[i] =3D 0;
>         }
>         for (; i < MAX_REPLY_QUEUES; i++)
> @@ -8285,11 +8248,11 @@ static int hpsa_request_irqs(struct ctlr_info *h,
>         for (i =3D 0; i < MAX_REPLY_QUEUES; i++)
>                 h->q[i] =3D (u8) i;
>=20
> -       if (h->intr_mode =3D=3D PERF_MODE_INT && h->msix_vector > 0) {
> +       if (h->intr_mode =3D=3D PERF_MODE_INT && h->msix_vectors > 0) {
>                 /* If performant mode and MSI-X, use multiple reply queue=
s */
> -               for (i =3D 0; i < h->msix_vector; i++) {
> +               for (i =3D 0; i < h->msix_vectors; i++) {
>                         sprintf(h->intrname[i], "%s-msix%d", h->devname, =
i);
> -                       rc =3D request_irq(h->intr[i], msixhandler,
> +                       rc =3D request_irq(pci_irq_vector(h->pdev, i), ms=
ixhandler,
>                                         0, h->intrname[i],
>                                         &h->q[i]);
>                         if (rc) {
> @@ -8297,9 +8260,9 @@ static int hpsa_request_irqs(struct ctlr_info *h,
>=20
>                                 dev_err(&h->pdev->dev,
>                                         "failed to get irq %d for %s\n",
> -                                      h->intr[i], h->devname);
> +                                      pci_irq_vector(h->pdev, i), h->dev=
name);
>                                 for (j =3D 0; j < i; j++) {
> -                                       free_irq(h->intr[j], &h->q[j]);
> +                                       free_irq(pci_irq_vector(h->pdev, =
j), &h->q[j]);
>                                         h->q[j] =3D 0;
>                                 }
>                                 for (; j < MAX_REPLY_QUEUES; j++)
> @@ -8307,33 +8270,27 @@ static int hpsa_request_irqs(struct ctlr_info *h,
>                                 return rc;
>                         }
>                 }
> -               hpsa_irq_affinity_hints(h);
>         } else {
>                 /* Use single reply pool */
> -               if (h->msix_vector > 0 || h->msi_vector) {
> -                       if (h->msix_vector)
> -                               sprintf(h->intrname[h->intr_mode],
> -                                       "%s-msix", h->devname);
> -                       else
> -                               sprintf(h->intrname[h->intr_mode],
> -                                       "%s-msi", h->devname);
> -                       rc =3D request_irq(h->intr[h->intr_mode],
> +               if (h->msix_vectors > 0 || h->pdev->msi_enabled) {
> +                       sprintf(h->intrname[0], "%s-msi%s", h->devname,
> +                               h->msix_vectors ? "x" : "");
> +                       rc =3D request_irq(pci_irq_vector(h->pdev, 0),
>                                 msixhandler, 0,
> -                               h->intrname[h->intr_mode],
> +                               h->intrname[0],
>                                 &h->q[h->intr_mode]);
>                 } else {
>                         sprintf(h->intrname[h->intr_mode],
>                                 "%s-intx", h->devname);
> -                       rc =3D request_irq(h->intr[h->intr_mode],
> +                       rc =3D request_irq(pci_irq_vector(h->pdev, 0),
>                                 intxhandler, IRQF_SHARED,
> -                               h->intrname[h->intr_mode],
> +                               h->intrname[0],
>                                 &h->q[h->intr_mode]);
>                 }
> -               irq_set_affinity_hint(h->intr[h->intr_mode], NULL);
>         }
>         if (rc) {
>                 dev_err(&h->pdev->dev, "failed to get irq %d for %s\n",
> -                      h->intr[h->intr_mode], h->devname);
> +                      pci_irq_vector(h->pdev, 0), h->devname);
>                 hpsa_free_irqs(h);
>                 return -ENODEV;
>         }
> @@ -9519,7 +9476,7 @@ static int
> hpsa_put_ctlr_into_performant_mode(struct ctlr_info *h)
>                         return rc;
>         }
>=20
> -       h->nreply_queues =3D h->msix_vector > 0 ? h->msix_vector : 1;
> +       h->nreply_queues =3D h->msix_vectors > 0 ? h->msix_vectors : 1;
>         hpsa_get_max_perf_mode_cmds(h);
>         /* Performant mode ring buffer and supporting data structures */
>         h->reply_queue_size =3D h->max_commands * sizeof(u64);
> diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
> index 82cdfad..3faf6cf 100644
> --- a/drivers/scsi/hpsa.h
> +++ b/drivers/scsi/hpsa.h
> @@ -175,9 +175,7 @@ struct ctlr_info {
>  #      define DOORBELL_INT     1
>  #      define SIMPLE_MODE_INT  2
>  #      define MEMQ_MODE_INT    3
> -       unsigned int intr[MAX_REPLY_QUEUES];
> -       unsigned int msix_vector;
> -       unsigned int msi_vector;
> +       unsigned int msix_vectors;
>         int intr_mode; /* either PERF_MODE_INT or SIMPLE_MODE_INT */
>         struct access_method access;
>=20
> @@ -464,7 +462,7 @@ static unsigned long
> SA5_performant_completed(struct ctlr_info *h, u8 q)
>         unsigned long register_value =3D FIFO_EMPTY;
>=20
>         /* msi auto clears the interrupt pending bit. */
> -       if (unlikely(!(h->msi_vector || h->msix_vector))) {
> +       if (unlikely(!(h->pdev->msi_enabled || h->msix_vectors))) {
>                 /* flush the controller write of the reply queue by readi=
ng
>                  * outbound doorbell status register.
>                  */
> --
> 2.1.4

