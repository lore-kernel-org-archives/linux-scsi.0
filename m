From: Frederik Deweerdt <deweerdt@free.fr>
Subject: Re: [RFC PATCH] pci_request_irq (was [-mm patch] aic7xxx: check irq validity)
Date: Mon, 2 Oct 2006 21:09:49 +0000
Message-ID: <20061002210949.GJ3003@slug>
References: <20060929235054.GB2020@slug> <1159573404.13029.96.camel@localhost.localdomain> <20060930140946.GA1195@slug> <451F049A.1010404@garzik.org> <20061001142807.GD16272@parisc-linux.org> <1159729523.2891.408.camel@laptopd505.fenrus.org> <20061001193616.GF16272@parisc-linux.org> <1159755141.2891.434.camel@laptopd505.fenrus.org> <20061002200048.GC3003@slug> <20061002181522.GL16272@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:42288 "EHLO
	ug-out-1314.google.com") by vger.kernel.org with ESMTP
	id S965301AbWJBTLP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Oct 2006 15:11:15 -0400
Received: by ug-out-1314.google.com with SMTP id o38so544236ugd
        for <linux-scsi@vger.kernel.org>; Mon, 02 Oct 2006 12:11:14 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20061002181522.GL16272@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-scsi@vger.kernel.org, "Linux-Kernel," <linux-kernel@vger.kernel.org>, "J.A. Magall??n" <jamagallon@ono.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Andrew Morton <akpm@osdl.org>, Jeff Garzik <jeff@garzik.org>

On Mon, Oct 02, 2006 at 12:15:22PM -0600, Matthew Wilcox wrote:
> On Mon, Oct 02, 2006 at 08:00:48PM +0000, Frederik Deweerdt wrote:
> >  /**
> > + * pci_request_irq - Reserve an IRQ for a PCI device
> > + * @pdev: The PCI device whose irq is to be reserved
> > + * handler: The interrupt handler function,
> 
> > + * pci_get_drvdata(pdev) shall be passed as an argument to that function
> 
> I don't think you can (or should) do this.  Move it to the body of the
> comment below.
OK, thanks for pointing this, will do.
> 
> > + * @flags: The flags to be passed to request_irq()
> > + * @name: The name of the device to be associated with the irq
> > + *
> > + * Returns 0 on success, or a negative value on error.  A warning
> > + * message is also printed on failure.
> > + */
> > +int pci_request_irq(struct pci_dev *pdev,
> > +		    irqreturn_t (*handler)(int, void *, struct pt_regs *),
> > +		    unsigned long flags, const char *name)
> > +{
> > +	int rc;
> > +	const char *actual_name = name;
> > +
> > +	rc = is_irq_valid(pdev->irq);
> > +	if (!rc) {
> > +		dev_printk(KERN_ERR, &pdev->dev, "invalid irq #%d\n", pdev->irq);
> > +		return -EINVAL;
> > +	}
> 
> Why is that more readable than
> 
> 	if (!is_irq_valid(pdev->irq)) {
> 		dev_err(&pdev->dev, "invalid irq #%d\n", pdev->irq);
> 		return -EINVAL;
> 	}
> 
Better too.
> > +	if (!actual_name)
> > +		actual_name = pci_name(pdev);
> > +
> > +	return request_irq(pdev->irq, handler, flags | IRQF_SHARED,
> > +			   actual_name, pci_get_drvdata(pdev));
> 
> The driver name is a far more common usage than the pci_name.
> 
> 	return request_irq(pdev->irq, handler, flags | IRQF_SHARED,
> 			name ? name : pdev->driver->name,
> 			pci_get_drvdata(pdev));
OK, thanks for the feedback,
Frederik
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
