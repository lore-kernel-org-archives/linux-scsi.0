From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [RFC PATCH] pci_request_irq (was [-mm patch] aic7xxx: check irq
 validity)
Date: Mon, 2 Oct 2006 20:58:17 -0700
Message-ID: <20061002205817.ddebe747.rdunlap@xenotime.net>
References: <20060929143949.GL5017@parisc-linux.org>
	<1159550143.13029.36.camel@localhost.localdomain>
	<20060929235054.GB2020@slug>
	<1159573404.13029.96.camel@localhost.localdomain>
	<20060930140946.GA1195@slug>
	<451F049A.1010404@garzik.org>
	<20061001142807.GD16272@parisc-linux.org>
	<1159729523.2891.408.camel@laptopd505.fenrus.org>
	<20061001193616.GF16272@parisc-linux.org>
	<1159755141.2891.434.camel@laptopd505.fenrus.org>
	<20061002200048.GC3003@slug>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:54161 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S932336AbWJCD4v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Oct 2006 23:56:51 -0400
Received: from midway.site ([71.117.236.95]) by xenotime.net for <linux-scsi@vger.kernel.org>; Mon, 2 Oct 2006 20:56:50 -0700
In-Reply-To: <20061002200048.GC3003@slug>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Frederik Deweerdt <deweerdt@free.fr>
Cc: Arjan van de Ven <arjan@infradead.org>, Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org, "Linux-Kernel," <linux-kernel@vger.kernel.org>, "J.A. Magall??n" <jamagallon@ono.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Andrew Morton <akpm@osdl.org>, Jeff Garzik <jeff@garzik.org>

On Mon, 2 Oct 2006 20:00:48 +0000 Frederik Deweerdt wrote:

> Hi all,
> 
> I've tried to summarize the different proposals made by Jeff Garzik,
> Matthew Wilcox and Arjan van de Ven in the "[-mm patch] aic7xxx: check
> irq validity" thread. I've also added:
> - some kerneldoc

The kernel-doc needs some repair -- see below.

> - renamed valid_irq to is_irq_valid() 
> - added pci_release_irq(). 
> 
> I'll send a follow-up patch showing the implied modifications for the
> following - semi-randomly chosen :) - drivers: aic7xxx, aic79xx, tg3
> and drm.
> 
> Regards,
> Frederik
> 
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index a544997..ae20a3a 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -15,6 +15,7 @@ #include <linux/init.h>
>  #include <linux/pci.h>
>  #include <linux/module.h>
>  #include <linux/spinlock.h>
> +#include <linux/interrupt.h>
>  #include <linux/string.h>
>  #include <asm/dma.h>	/* isa_dma_bridge_buggy */
>  #include "pci.h"
> @@ -810,6 +811,49 @@ err_out:
>  }
>  
>  /**
> + * pci_request_irq - Reserve an IRQ for a PCI device
> + * @pdev: The PCI device whose irq is to be reserved
> + * handler: The interrupt handler function,

 * @handler: ...

> + * pci_get_drvdata(pdev) shall be passed as an argument to that function
> + * @flags: The flags to be passed to request_irq()
> + * @name: The name of the device to be associated with the irq
> + *
> + * Returns 0 on success, or a negative value on error.  A warning
> + * message is also printed on failure.
> + */
> +int pci_request_irq(struct pci_dev *pdev,
> +		    irqreturn_t (*handler)(int, void *, struct pt_regs *),
> +		    unsigned long flags, const char *name)
> +{
> +	int rc;
> +	const char *actual_name = name;
> +
> +	rc = is_irq_valid(pdev->irq);
> +	if (!rc) {
> +		dev_printk(KERN_ERR, &pdev->dev, "invalid irq #%d\n", pdev->irq);
> +		return -EINVAL;
> +	}
> +
> +	if (!actual_name)
> +		actual_name = pci_name(pdev);
> +
> +	return request_irq(pdev->irq, handler, flags | IRQF_SHARED,
> +			   actual_name, pci_get_drvdata(pdev));
> +}
> +EXPORT_SYMBOL(pci_request_irq);
> +
> +/**
> + * pci_free_irq - releases the interrupt line reserved to the PCI
> + * device pointed by @pdev 

The first line is function name and <<short>> function description.
It cannot extend more than one line (combined).
If you want to use more text for function description,
you can do so after the list of parameters.  See example below.

> + * @pdev: the PCI device whose interrupt is to be freed
 *
 * This froofroo_irq function only does this on odd phases of
 * the moon.

> + */
> +void pci_free_irq(struct pci_dev *pdev)
> +{
> +	free_irq(pdev->irq, pci_get_drvdata(pdev));
> +}
> +EXPORT_SYMBOL(pci_free_irq);
> +
> +/**
>   * pci_set_master - enables bus-mastering for device dev
>   * @dev: the PCI device to enable
>   *

---
~Randy
