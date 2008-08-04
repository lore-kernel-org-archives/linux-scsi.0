From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/2] pci: add misrouted interrupt error handling
Date: Sun, 03 Aug 2008 22:46:53 -0500
Message-ID: <1217821613.4179.77.camel@localhost.localdomain>
References: <1217786532.4179.24.camel@localhost.localdomain>
	 <20080804025137.GI26461@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <20080804025137.GI26461@parisc-linux.org>
Sender: linux-pci-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, 2008-08-03 at 20:51 -0600, Matthew Wilcox wrote:
> On Sun, Aug 03, 2008 at 01:02:12PM -0500, James Bottomley wrote:
> > +static void pci_note_irq_problem(struct pci_dev *pdev, const char *reason)
> > +{
> > +	struct pci_dev *parent = to_pci_dev(pdev->dev.parent);
> > +
> > +	dev_printk(KERN_ERR, &pdev->dev,
> > +		   "Potentially misrouted IRQ (Bridge %s %04x:%04x)\n",
> > +		   parent->dev.bus_id, parent->vendor, parent->device);
> > +	dev_printk(KERN_ERR, &pdev->dev, "%s\n", reason);
> > +	dev_printk(KERN_ERR, &pdev->dev, "Please report to linux-kernel@vger.kernel.org\n");
> > +	WARN_ON(1);
> > +}
> 
> Will the dev_printk() strings be included in the kerneloops report?  And
> what if there is no parent of the device?  Consider device 00:02.0 on my
> laptop:

No, but some of them take the prior strings (depending on the
implementation).

> 00:02.0 VGA compatible controller: Intel Corporation Mobile GM965/GL960 Integrated Graphics Controller (rev 03)
>         Subsystem: Fujitsu Limited. Device 13fe
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0
>         Interrupt: pin A routed to IRQ 16

There is always a parent device ... it might be the PCI root device, in
which case the information will be blank, but there is always one.

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
> 
> Couldn't this be written more concisely as:
> 
> 	if (pdev->msix_enabled) {
> 		pci_note_irq_problem(pdev, "MSIX routing failure");
> 		return PCI_LOST_IRQ_DISABLE_MSIX;
> 	}
> 	if (pdev->msi_enabled) {
> 		pci_note_irq_problem(pdev, "MSI routing failure");
> 		return PCI_LOST_IRQ_DISABLE_MSI;
> 	}

The idea was to separate the cases in case something extra needs be
done.  I think it's pretty much identical as far as the compiler
optimises, and therefore probably not worth worrying about much.

James
