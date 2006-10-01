From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [-mm patch] aic7xxx: check irq validity (was Re: 2.6.18-mm2)
Date: Sun, 1 Oct 2006 08:28:07 -0600
Message-ID: <20061001142807.GD16272@parisc-linux.org>
References: <20060928014623.ccc9b885.akpm@osdl.org> <20060929155738.7076f0c8@werewolf> <20060929143949.GL5017@parisc-linux.org> <1159550143.13029.36.camel@localhost.localdomain> <20060929235054.GB2020@slug> <1159573404.13029.96.camel@localhost.localdomain> <20060930140946.GA1195@slug> <451F049A.1010404@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:713 "EHLO
	mail.parisc-linux.org") by vger.kernel.org with ESMTP
	id S932194AbWJAO2J (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 1 Oct 2006 10:28:09 -0400
Content-Disposition: inline
In-Reply-To: <451F049A.1010404@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Frederik Deweerdt <deweerdt@free.fr>, Andrew Morton <akpm@osdl.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, "J.A. Magall??n" <jamagallon@ono.com>, "Linux-Kernel," <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On Sat, Sep 30, 2006 at 07:58:18PM -0400, Jeff Garzik wrote:
> Actually, rather than adding this check to every driver, I would rather 
> do something like the attached patch:  create a pci_request_irq(), and 
> pass a struct pci_device to it.  Then the driver author doesn't have to 
> worry about such details.

I like pci_request_irq(), but pci_valid_irq is bad.

> +#ifndef ARCH_VALIDATE_PCI_IRQ
> +int pci_valid_irq(struct pci_dev *pdev)
> +{
> +	if (pdev->irq == 0)
> +		return -EINVAL;
> +	
> +	return 0;
> +}
> +EXPORT_SYMBOL(pci_valid_irq);
> +#endif /* ARCH_VALIDATE_PCI_IRQ */

Better would be:

#ifndef ARCH_VALIDATE_IRQ
static inline int valid_irq(unsigned int irq)
{
	return irq ? 1 : 0;
}
#endif

in linux/interrupt.h (around request_irq).

And it doesn't need to be a __must_check.  There's no point -- it has
no side-effects.  The only reason to call it is if you want the answer
to the question.  You had the sense of the return code wrong too; you
want to use it as:

int pci_request_irq(struct pci_dev *pdev, irq_handler_t handler,
			unsigned long flags, const char *name, void *data)
{
	if (!valid_irq(pdev->irq)) {
		dev_printk(KERN_ERR, &pdev->dev, "invalid irq\n");
		return -EINVAL;
	}

	return request_irq(pdev->irq, handler, flags | IRQF_SHARED, name, data);
}

