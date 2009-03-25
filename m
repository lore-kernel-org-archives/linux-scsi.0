From: "Krishna Gudipati" <kgudipat@Brocade.com>
Subject: RE: [PATCH 1/5] bfa: Brocade BFA FC SCSI driver (bfad)
Date: Wed, 25 Mar 2009 12:36:55 -0700
Message-ID: <4C94DE2070B172459E4F1EE14BD2364E02BD1DB0@HQ-EXCH-5.corp.brocade.com>
References: <200903240010.n2O0Ap68013744@blc-10-2.brocade.com> <200903241205.55028.eike-kernel@sf-tec.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brm-mailgate-2.brocade.com ([144.49.197.3]:14612 "EHLO
	brm-mailgate-2.brocade.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753711AbZCYTwv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Mar 2009 15:52:51 -0400
Content-class: urn:content-classes:message
In-Reply-To: <200903241205.55028.eike-kernel@sf-tec.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: James.Bottomley@hansenpartnership.com, Jing Huang <huangj@Brocade.COM>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Ramkumar Vadivelu <rvadivel@Brocade.COM>, Vinodh Ravindran <vravindr@Brocade.COM>, Nadeem Kattangere <nkattang@Brocade.COM>

Thanks Eike for reviewing our code. We are considering all the changes
suggested by you for our driver and we are going to incorporate most of
the changes suggested in our next submission.

Thanks,
Krishna Chaitanya Gudipati.

-----Original Message-----
From: Rolf Eike Beer [mailto:eike-kernel@sf-tec.de] 
Sent: Tuesday, March 24, 2009 4:06 AM
To: Krishna Gudipati
Cc: James.Bottomley@hansenpartnership.com; Jing Huang;
linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org; Ramkumar
Vadivelu; Vinodh Ravindran
Subject: Re: [PATCH 1/5] bfa: Brocade BFA FC SCSI driver (bfad)

Krishna Gudipati wrote:
> From: Krishna Chaitanya Gudipati <kgudipat@brocade.com>
>
> This patch contains Brocade linux driver specific code that interfaces
to
> upper layer linux kernel for PCI, SCSI mid-layer, sysfs related stuff.
The
> code handles things such as module load/unload, PCI probe/release,
handling
> interrupts, interfacing with sysfs etc. It interacts with the
> firmware/hardware via the code under files with prefix bfa_*.
>
> Signed-off-by: Krishna Chaitanya Gudipati <kgudipat@brocade.com>

> +int
> +bfad_pci_init(struct pci_dev *pdev, struct bfad_s *bfad)
> +{
> +       unsigned long   bar0_len;
> +       int             rc = -ENODEV;
> +
> +       if (pci_enable_device(pdev)) {
> +               BFA_PRINTF(BFA_ERR, "pci_enable_device fail %p\n",
pdev);
> +               goto out;
> +       }
> +
> +       if (pci_request_regions(pdev, BFAD_DRIVER_NAME))
> +               goto out_disable_device;
> +
> +       pci_set_master(pdev);
> +
> +
> +       if (pci_set_dma_mask(pdev, DMA_64BIT_MASK) != 0)
> +               if (pci_set_dma_mask(pdev, DMA_32BIT_MASK) != 0) {
> +                       BFA_PRINTF(BFA_ERR, "pci_set_dma_mask fail
%p\n",
> pdev); +                       goto out_release_region;
> +               }

Save the return value of pci_set_dma_mask() to rc and use this as error
code.

> +#ifdef SUPPORT_PCI_AER
> +       /*
> +        * Enable PCIE Advanced Error Recovery (AER) if the kernel
version
> +        * supports.
> +        */
> +       BFAD_ENABLE_PCIE_AER(pdev);
> +#endif
> +
> +       bfad->pci_bar0_map = pci_resource_start(pdev, 0);
> +       bar0_len = pci_resource_len(pdev, 0);
> +       bfad->pci_bar0_kva = ioremap(bfad->pci_bar0_map, bar0_len);

bfad->pci_bar0_kva = pci_iomap(pdev, 0, 0);

> +       if (bfad->pci_bar0_kva == NULL) {
> +               BFA_PRINTF(BFA_ERR, "Fail to map bar0\n");
> +               goto out_release_region;
> +       }
> +
> +       bfad->hal_pcidev.pci_slot = PCI_SLOT(pdev->devfn);
> +       bfad->hal_pcidev.pci_func = PCI_FUNC(pdev->devfn);
> +       bfad->hal_pcidev.pci_bar_kva = bfad->pci_bar0_kva;
> +       bfad->hal_pcidev.device_id = pdev->device;
> +       bfad->pci_name = pci_name(pdev);
> +
> +       bfad->pci_attr.vendor_id = pdev->vendor;
> +       bfad->pci_attr.device_id = pdev->device;
> +       bfad->pci_attr.ssid = pdev->subsystem_device;
> +       bfad->pci_attr.ssvid = pdev->subsystem_vendor;
> +       bfad->pci_attr.pcifn = PCI_FUNC(pdev->devfn);
> +
> +       bfad->pcidev = pdev;
> +       return 0;
> +
> +out_release_region:
> +       pci_release_regions(pdev);
> +out_disable_device:
> +       pci_disable_device(pdev);
> +out:
> +       return rc;
> +}

What about using devres for your driver? (See 
Documentation/driver-model/devres.txt) This would take care of the 
release_regions and disable device in the error paths here and also in
the 
remove handler.

> +/**
> + *  bfa_isr BFA driver interrupt functions
> + */
> +irqreturn_t bfad_intx(int irq, void *dev_id);

This declaration isn't needed at all as the function follows directly
after 
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
> +	int             i, error = 0;
           ^^^^^^^^^^^^^

One space.

> +	for (i = 0; i < bfad->nvec; i++) {
> +		error = request_irq(bfad->msix_tab[i].msix.vector,
> +				    bfad->msix_tab[i].handler, 0,
> +				    BFAD_DRIVER_NAME, bfad);
> +		printk(KERN_WARNING "%s: bfad%d irq %d\n", __FUNCTION__,
> +			 bfad->inst_no, bfad->msix_tab[i].msix.vector);
> +
> +		if (error) {
> +			int             j;
> +
> +			for (j = 0; j < i; j++)
> +				free_irq(bfad->msix_tab[j].msix.vector,
bfad);
> +
> +			return 1;

"return error" would allow doint something useful with this value later
(e.g. 
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
> +	int             error = 0;
> +
> +	if (!msix_disable) {
> +		u32 mask = 0, i, num_bit = 0, max_bit = 0;
> +		struct msix_entry msix_entries[MAX_MSIX_ENTRY];
> +
> +		/* Call BFA to get the msix map for this PCI function.
*/
> +		bfa_msix_getvecs(&bfad->bfa, &mask, &num_bit, &max_bit);
> +
> +		/* Set up the msix entry table */
> +		bfad_init_msix_entry(bfad, msix_entries, mask, max_bit);
> +
> +		error = pci_enable_msix(bfad->pcidev, msix_entries,
bfad->nvec);
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

Also the message should really be more descriptive, like "enable_msix
for %i 
vectors failed, only %i vectors available". And if you use dev_warn()
that 
function will add the correct device description for you (You should use
it 
whereever possible).

__FUNCTION__ should not be used anymore, use __func__. Or remove it 
completely, it's rather obvious where this message actually comes from.

> +
> +			goto line_based;
> +		}
> +
> +		/* Save the vectors */
> +		for (i = 0; i < bfad->nvec; i++)
> +			bfad->msix_tab[i].msix.vector =
msix_entries[i].vector;
> +
> +		/* Set up interrupt handler for each vectors */
> +		if (bfad_install_msix_handler(bfad)) {
> +			printk(KERN_WARNING "%s: install_msix failed,
bfad%d\n",
> +			       __FUNCTION__, bfad->inst_no);
> +			goto line_based;
> +		}

This is just your choice, but when MSI was requested and the number of 
interrupts were reserved successfully and now installing the IRQ handler

fails this should IMHO be an error and not a situation to fallback to
line 
based. YMMV.

> +		bfad->bfad_flags |= BFAD_MSIX_ON;
> +
> +		goto success;
> +	}
> +
> +line_based:
> +	error = 0;
> +	if (request_irq
> +	    (bfad->pcidev->irq, (irq_handler_t) bfad_intx,
BFAD_IRQ_FLAGS,

Cast not needed, bfad_intx() should be of the correct signature.

> +	     BFAD_DRIVER_NAME, bfad) != 0) {
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
> +		for (i = 0; i < bfad->nvec; i++)
> +			free_irq(bfad->msix_tab[i].msix.vector, bfad);
> +
> +		pci_disable_msix(bfad->pcidev);
> +		bfad->bfad_flags &= ~BFAD_MSIX_ON;
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

> +	     BFAD_DRIVER_NAME, bfad) != 0) {
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
