From: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 1/2] pci: add misrouted interrupt error handling
Date: Tue, 5 Aug 2008 10:03:10 -0700
Message-ID: <200808051003.10400.jbarnes@virtuousgeek.org>
References: <1217786532.4179.24.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <1217786532.4179.24.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-pci-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sunday, August 03, 2008 11:02 am James Bottomley wrote:
> +/**
> + * pci_lost_interrupt - reports a lost PCI interrupt
> + * @pdev:	device whose interrupt is lost
> + *
> + * The primary function of this routine is to report a lost interrupt
> + * in a standard way which users can recognise (instead of blaming the
> + * driver).
> + *
> + * Returns:
> + *  a suggestion for fixing it (although the driver is not required to
> + * act on this).
> + */
> +enum pci_lost_interrupt_reason pci_lost_interrupt(struct pci_dev *pdev)
> +{
> +	if (pdev->msi_enabled || pdev->msix_enabled) {
> +		enum pci_lost_interrupt_reason ret;
> +
> +		if (pdev->msix_enabled) {
> +			pci_note_irq_problem(pdev, "MSIX routing failure");
> +			ret = PCI_LOST_IRQ_DISABLE_MSIX;
> +		} else {
> +			pci_note_irq_problem(pdev, "MSI routing failure");
> +			ret = PCI_LOST_IRQ_DISABLE_MSI;
> +		}
> +		return ret;
> +	}
> +#ifdef CONFIG_ACPI
> +	if (!(acpi_disabled || acpi_noirq)) {
> +		pci_note_irq_problem(pdev, "Potential ACPI misrouting please reboot with
> acpi=noirq"); +		/* currently no way to fix acpi on the fly */
> +		return PCI_LOST_IRQ_DISABLE_ACPI;
> +	}
> +#endif
> +	pci_note_irq_problem(pdev, "unknown cause (not MSI or ACPI)");
> +	return PCI_LOST_IRQ_NO_INFORMATION;
> +}

This seems to be a function that just returns what type of IRQ you're using or 
how it's routed and it isn't necessarily "lost interrupt" specific.

This information is clearly useful to drivers both for informational purposes 
and for debugging problems, so on that front it looks good.  However, I think 
it should probably be called pci_interrupt_type(struct pci_dev *dev) or 
something instead, and just return an enum of either MSIX, MSI, or LINE 
(though I'm open to better names).  From that, the driver can infer what 
might be going wrong, though in the case of a LINE interrupt, all you can 
really do is report that there's probably a platform IRQ routing problem.

Jesse
