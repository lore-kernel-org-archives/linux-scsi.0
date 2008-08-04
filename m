From: Grant Grundler <grundler@parisc-linux.org>
Subject: Re: [PATCH 1/2] pci: add misrouted interrupt error handling
Date: Sun, 3 Aug 2008 22:30:53 -0600
Message-ID: <20080804043053.GB10519@colo.lackof.org>
References: <1217786532.4179.24.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1217786532.4179.24.camel@localhost.localdomain>
Sender: linux-pci-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, Aug 03, 2008 at 01:02:12PM -0500, James Bottomley wrote:
> We're getting a lot of storage drivers blamed for interrupt misrouting
> issues.  This patch provides a standard way of reporting the problem
> ... and, if possible, correcting it.

James,
Can you add a paragraph to Documentation/pci.txt about the usage
of the new API?

thanks,
grant

> 
> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> ---
>  drivers/pci/Makefile |    3 +-
>  drivers/pci/irq.c    |   60 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/pci.h  |    7 +++++
>  3 files changed, 69 insertions(+), 1 deletions(-)
>  create mode 100644 drivers/pci/irq.c
> 
> diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
> index 7d63f8c..19dacb8 100644
> --- a/drivers/pci/Makefile
> +++ b/drivers/pci/Makefile
> @@ -3,7 +3,8 @@
>  #
>  
>  obj-y		+= access.o bus.o probe.o remove.o pci.o quirks.o slot.o \
> -			pci-driver.o search.o pci-sysfs.o rom.o setup-res.o
> +			pci-driver.o search.o pci-sysfs.o rom.o setup-res.o \
> +			irq.o
>  obj-$(CONFIG_PROC_FS) += proc.o
>  
>  # Build PCI Express stuff if needed
> diff --git a/drivers/pci/irq.c b/drivers/pci/irq.c
> new file mode 100644
> index 0000000..6441dfa
> --- /dev/null
> +++ b/drivers/pci/irq.c
> @@ -0,0 +1,60 @@
> +/*
> + * PCI IRQ failure handing code
> + *
> + * Copyright (c) 2008 James Bottomley <James.Bottomley@HansenPartnership.com>
> + */
> +
> +#include <linux/acpi.h>
> +#include <linux/device.h>
> +#include <linux/kernel.h>
> +#include <linux/pci.h>
> +
> +static void pci_note_irq_problem(struct pci_dev *pdev, const char *reason)
> +{
> +	struct pci_dev *parent = to_pci_dev(pdev->dev.parent);
> +
> +	dev_printk(KERN_ERR, &pdev->dev,
> +		   "Potentially misrouted IRQ (Bridge %s %04x:%04x)\n",
> +		   parent->dev.bus_id, parent->vendor, parent->device);
> +	dev_printk(KERN_ERR, &pdev->dev, "%s\n", reason);
> +	dev_printk(KERN_ERR, &pdev->dev, "Please report to linux-kernel@vger.kernel.org\n");
> +	WARN_ON(1);
> +}
> +
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
> +		pci_note_irq_problem(pdev, "Potential ACPI misrouting please reboot with acpi=noirq");
> +		/* currently no way to fix acpi on the fly */
> +		return PCI_LOST_IRQ_DISABLE_ACPI;
> +	}
> +#endif
> +	pci_note_irq_problem(pdev, "unknown cause (not MSI or ACPI)");
> +	return PCI_LOST_IRQ_NO_INFORMATION;
> +}
> +EXPORT_SYMBOL(pci_lost_interrupt);
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 825be38..121698a 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -539,6 +539,13 @@ struct pci_dev __deprecated *pci_find_slot(unsigned int bus,
>  					   unsigned int devfn);
>  #endif /* CONFIG_PCI_LEGACY */
>  
> +enum pci_lost_interrupt_reason {
> +	PCI_LOST_IRQ_NO_INFORMATION = 0,
> +	PCI_LOST_IRQ_DISABLE_MSI,
> +	PCI_LOST_IRQ_DISABLE_MSIX,
> +	PCI_LOST_IRQ_DISABLE_ACPI,
> +};
> +enum pci_lost_interrupt_reason pci_lost_interrupt(struct pci_dev *dev);
>  int pci_find_capability(struct pci_dev *dev, int cap);
>  int pci_find_next_capability(struct pci_dev *dev, u8 pos, int cap);
>  int pci_find_ext_capability(struct pci_dev *dev, int cap);
> -- 
> 1.5.6.3
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
