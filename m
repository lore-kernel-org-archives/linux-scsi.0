From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH 1/5] bfa: Brocade BFA FC SCSI driver (bfad)
Date: Tue, 24 Mar 2009 12:05:41 +0100
Message-ID: <200903241205.55028.eike-kernel@sf-tec.de>
References: <200903240010.n2O0Ap68013744@blc-10-2.brocade.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart10234548.fJnlCyaSZD";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:47912 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753201AbZCXLGI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Mar 2009 07:06:08 -0400
In-Reply-To: <200903240010.n2O0Ap68013744@blc-10-2.brocade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Krishna Gudipati <kgudipat@brocade.com>
Cc: James.Bottomley@hansenpartnership.com, huangj@brocade.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rvadivel@brocade.com, vravindr@brocade.com

--nextPart10234548.fJnlCyaSZD
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Krishna Gudipati wrote:
> From: Krishna Chaitanya Gudipati <kgudipat@brocade.com>
>
> This patch contains Brocade linux driver specific code that interfaces to
> upper layer linux kernel for PCI, SCSI mid-layer, sysfs related stuff. The
> code handles things such as module load/unload, PCI probe/release, handli=
ng
> interrupts, interfacing with sysfs etc. It interacts with the
> firmware/hardware via the code under files with prefix bfa_*.
>
> Signed-off-by: Krishna Chaitanya Gudipati <kgudipat@brocade.com>

> +int
> +bfad_pci_init(struct pci_dev *pdev, struct bfad_s *bfad)
> +{
> +       unsigned long   bar0_len;
> +       int             rc =3D -ENODEV;
> +
> +       if (pci_enable_device(pdev)) {
> +               BFA_PRINTF(BFA_ERR, "pci_enable_device fail %p\n", pdev);
> +               goto out;
> +       }
> +
> +       if (pci_request_regions(pdev, BFAD_DRIVER_NAME))
> +               goto out_disable_device;
> +
> +       pci_set_master(pdev);
> +
> +
> +       if (pci_set_dma_mask(pdev, DMA_64BIT_MASK) !=3D 0)
> +               if (pci_set_dma_mask(pdev, DMA_32BIT_MASK) !=3D 0) {
> +                       BFA_PRINTF(BFA_ERR, "pci_set_dma_mask fail %p\n",
> pdev); +                       goto out_release_region;
> +               }

Save the return value of pci_set_dma_mask() to rc and use this as error cod=
e.

> +#ifdef SUPPORT_PCI_AER
> +       /*
> +        * Enable PCIE Advanced Error Recovery (AER) if the kernel version
> +        * supports.
> +        */
> +       BFAD_ENABLE_PCIE_AER(pdev);
> +#endif
> +
> +       bfad->pci_bar0_map =3D pci_resource_start(pdev, 0);
> +       bar0_len =3D pci_resource_len(pdev, 0);
> +       bfad->pci_bar0_kva =3D ioremap(bfad->pci_bar0_map, bar0_len);

bfad->pci_bar0_kva =3D pci_iomap(pdev, 0, 0);

> +       if (bfad->pci_bar0_kva =3D=3D NULL) {
> +               BFA_PRINTF(BFA_ERR, "Fail to map bar0\n");
> +               goto out_release_region;
> +       }
> +
> +       bfad->hal_pcidev.pci_slot =3D PCI_SLOT(pdev->devfn);
> +       bfad->hal_pcidev.pci_func =3D PCI_FUNC(pdev->devfn);
> +       bfad->hal_pcidev.pci_bar_kva =3D bfad->pci_bar0_kva;
> +       bfad->hal_pcidev.device_id =3D pdev->device;
> +       bfad->pci_name =3D pci_name(pdev);
> +
> +       bfad->pci_attr.vendor_id =3D pdev->vendor;
> +       bfad->pci_attr.device_id =3D pdev->device;
> +       bfad->pci_attr.ssid =3D pdev->subsystem_device;
> +       bfad->pci_attr.ssvid =3D pdev->subsystem_vendor;
> +       bfad->pci_attr.pcifn =3D PCI_FUNC(pdev->devfn);
> +
> +       bfad->pcidev =3D pdev;
> +       return 0;
> +
> +out_release_region:
> +       pci_release_regions(pdev);
> +out_disable_device:
> +       pci_disable_device(pdev);
> +out:
> +       return rc;
> +}

What about using devres for your driver? (See=20
Documentation/driver-model/devres.txt) This would take care of the=20
release_regions and disable device in the error paths here and also in the=
=20
remove handler.

> +/**
> + *  bfa_isr BFA driver interrupt functions
> + */
> +irqreturn_t bfad_intx(int irq, void *dev_id);

This declaration isn't needed at all as the function follows directly after=
=20
that.

> +/**
> + * Line based interrupt handler.
> + */
> +irqreturn_t
> +bfad_intx(int irq, void *dev_id)
> +{

[...]

> +static int
> +bfad_install_msix_handler(struct bfad_s *bfad)
> +{
> +	int             i, error =3D 0;
           ^^^^^^^^^^^^^

One space.

> +	for (i =3D 0; i < bfad->nvec; i++) {
> +		error =3D request_irq(bfad->msix_tab[i].msix.vector,
> +				    bfad->msix_tab[i].handler, 0,
> +				    BFAD_DRIVER_NAME, bfad);
> +		printk(KERN_WARNING "%s: bfad%d irq %d\n", __FUNCTION__,
> +			 bfad->inst_no, bfad->msix_tab[i].msix.vector);
> +
> +		if (error) {
> +			int             j;
> +
> +			for (j =3D 0; j < i; j++)
> +				free_irq(bfad->msix_tab[j].msix.vector, bfad);
> +
> +			return 1;

"return error" would allow doint something useful with this value later (e.=
g.=20
printing them in your warning) so one can actually see what went wrong.

> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * Setup MSIX based interrupt.
> + */
> +int
> +bfad_setup_intr(struct bfad_s *bfad)
> +{
> +	int             error =3D 0;
> +
> +	if (!msix_disable) {
> +		u32 mask =3D 0, i, num_bit =3D 0, max_bit =3D 0;
> +		struct msix_entry msix_entries[MAX_MSIX_ENTRY];
> +
> +		/* Call BFA to get the msix map for this PCI function.  */
> +		bfa_msix_getvecs(&bfad->bfa, &mask, &num_bit, &max_bit);
> +
> +		/* Set up the msix entry table */
> +		bfad_init_msix_entry(bfad, msix_entries, mask, max_bit);
> +
> +		error =3D pci_enable_msix(bfad->pcidev, msix_entries, bfad->nvec);
> +		if (error) {
> +			/*
> +			 * Only error number of vector is available.

"of vectors are"

> +			 * We don't have a mechanism to map multiple
> +			 * interrupts into one vector, so even if we
> +			 * can try to request less vectors, we don't
> +			 * know how to associate interrupt events to
> +			 *  vectors. Linux doesn't dupicate vectors
> +			 * in the MSIX table for this case.
> +			 */
> +
> +			printk(KERN_WARNING
> +				"%s: enable_msix failed, %d bfad%d\n",
> +			       __FUNCTION__, error, bfad->inst_no);

Also the message should really be more descriptive, like "enable_msix for %=
i=20
vectors failed, only %i vectors available". And if you use dev_warn() that=
=20
function will add the correct device description for you (You should use it=
=20
whereever possible).

__FUNCTION__ should not be used anymore, use __func__. Or remove it=20
completely, it's rather obvious where this message actually comes from.

> +
> +			goto line_based;
> +		}
> +
> +		/* Save the vectors */
> +		for (i =3D 0; i < bfad->nvec; i++)
> +			bfad->msix_tab[i].msix.vector =3D msix_entries[i].vector;
> +
> +		/* Set up interrupt handler for each vectors */
> +		if (bfad_install_msix_handler(bfad)) {
> +			printk(KERN_WARNING "%s: install_msix failed, bfad%d\n",
> +			       __FUNCTION__, bfad->inst_no);
> +			goto line_based;
> +		}

This is just your choice, but when MSI was requested and the number of=20
interrupts were reserved successfully and now installing the IRQ handler=20
fails this should IMHO be an error and not a situation to fallback to line=
=20
based. YMMV.

> +		bfad->bfad_flags |=3D BFAD_MSIX_ON;
> +
> +		goto success;
> +	}
> +
> +line_based:
> +	error =3D 0;
> +	if (request_irq
> +	    (bfad->pcidev->irq, (irq_handler_t) bfad_intx, BFAD_IRQ_FLAGS,

Cast not needed, bfad_intx() should be of the correct signature.

> +	     BFAD_DRIVER_NAME, bfad) !=3D 0) {
> +		/* Enable interrupt handler failed */
> +		return 1;
> +	}
> +success:
> +	return error;
> +}
> +
> +void
> +bfad_remove_intr(struct bfad_s *bfad)
> +{
> +	int             i;
> +
> +	if (bfad->bfad_flags & BFAD_MSIX_ON) {
> +		for (i =3D 0; i < bfad->nvec; i++)
> +			free_irq(bfad->msix_tab[i].msix.vector, bfad);
> +
> +		pci_disable_msix(bfad->pcidev);
> +		bfad->bfad_flags &=3D ~BFAD_MSIX_ON;
> +	} else {
> +		free_irq(bfad->pcidev->irq, bfad);
> +	}
> +}
> +
> +#else /* CONFIG_PCI_MSI */
> +/**
> + * Setup line-based interrupt.
> + */
> +int
> +bfad_setup_intr(struct bfad_s *bfad)
> +{
> +	if (request_irq
> +	    (bfad->pcidev->irq, (irq_handler_t) bfad_intx, SA_SHIRQ,

Same here.

> +	     BFAD_DRIVER_NAME, bfad) !=3D 0) {
> +		/* Enable interrupt handler failed */
> +		return 1;
> +	}
> +
> +	return 0;
> +}
> +
> +void
> +bfad_remove_intr(struct bfad_s *bfad)
> +{
> +	bfa_trc(bfad, bfad->pcidev->irq);
> +	free_irq(bfad->pcidev->irq, bfad);
> +}
> +
> +#endif /* CONFIG_PCI_MSI */
> +
> +

Remove trailing empty lines.

Greetings,

Eike

--nextPart10234548.fJnlCyaSZD
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAknIvpIACgkQXKSJPmm5/E7IpgCeMWepkzUKlB1ZuS7Mdyp0T208
rV8An1xCWduIqS+Y5YmwP0I5cHIyWCAv
=bgJj
-----END PGP SIGNATURE-----

--nextPart10234548.fJnlCyaSZD--
