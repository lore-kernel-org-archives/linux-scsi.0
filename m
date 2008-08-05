From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/2] pci: add misrouted interrupt error handling
Date: Tue, 05 Aug 2008 13:44:01 -0700
Message-ID: <1217969041.9923.64.camel@localhost.localdomain>
References: <1217786532.4179.24.camel@localhost.localdomain>
	 <200808051003.10400.jbarnes@virtuousgeek.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <200808051003.10400.jbarnes@virtuousgeek.org>
Sender: linux-pci-owner@vger.kernel.org
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2008-08-05 at 10:03 -0700, Jesse Barnes wrote:
> On Sunday, August 03, 2008 11:02 am James Bottomley wrote:
> > +/**
> > + * pci_lost_interrupt - reports a lost PCI interrupt
> > + * @pdev:	device whose interrupt is lost
> > + *
> > + * The primary function of this routine is to report a lost interrupt
> > + * in a standard way which users can recognise (instead of blaming the
> > + * driver).
> > + *
> > + * Returns:
> > + *  a suggestion for fixing it (although the driver is not required to
> > + * act on this).
> > + */
> > +enum pci_lost_interrupt_reason pci_lost_interrupt(struct pci_dev *pdev)
> > +{
> > +	if (pdev->msi_enabled || pdev->msix_enabled) {
> > +		enum pci_lost_interrupt_reason ret;
> > +
> > +		if (pdev->msix_enabled) {
> > +			pci_note_irq_problem(pdev, "MSIX routing failure");
> > +			ret = PCI_LOST_IRQ_DISABLE_MSIX;
> > +		} else {
> > +			pci_note_irq_problem(pdev, "MSI routing failure");
> > +			ret = PCI_LOST_IRQ_DISABLE_MSI;
> > +		}
> > +		return ret;
> > +	}
> > +#ifdef CONFIG_ACPI
> > +	if (!(acpi_disabled || acpi_noirq)) {
> > +		pci_note_irq_problem(pdev, "Potential ACPI misrouting please reboot with
> > acpi=noirq"); +		/* currently no way to fix acpi on the fly */
> > +		return PCI_LOST_IRQ_DISABLE_ACPI;
> > +	}
> > +#endif
> > +	pci_note_irq_problem(pdev, "unknown cause (not MSI or ACPI)");
> > +	return PCI_LOST_IRQ_NO_INFORMATION;
> > +}
> 
> This seems to be a function that just returns what type of IRQ you're using or 
> how it's routed and it isn't necessarily "lost interrupt" specific.

So perhaps this routine should only note but not advise?  The drivers
can then just call pci_interrupt_type to see if they can do anything.

> This information is clearly useful to drivers both for informational purposes 
> and for debugging problems, so on that front it looks good.  However, I think 
> it should probably be called pci_interrupt_type(struct pci_dev *dev) or 
> something instead, and just return an enum of either MSIX, MSI, or LINE 
> (though I'm open to better names).  From that, the driver can infer what 
> might be going wrong, though in the case of a LINE interrupt, all you can 
> really do is report that there's probably a platform IRQ routing problem.

The only thing that this can't do is ACPI ... but on the other hand once
the IRQ routing is set by ACPI I'm not sure the driver can do anything
to fix it.

So ... depending on how the feedback goes, I'll plan to reroll this as a
note but not advise function.

James
