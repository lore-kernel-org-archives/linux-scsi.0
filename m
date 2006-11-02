From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH v4]: PCI Error Recovery: Symbios SCSI device driver
Date: Wed, 1 Nov 2006 20:57:22 -0700
Message-ID: <20061102035722.GA31830@parisc-linux.org>
References: <20061020180510.GN6537@austin.ibm.com> <20061031185506.GE26964@parisc-linux.org> <20061031231334.GR6360@austin.ibm.com> <20061102000745.GX6360@austin.ibm.com> <20061102011935.GZ6360@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:1932 "EHLO
	mail.parisc-linux.org") by vger.kernel.org with ESMTP
	id S1751679AbWKBD5Y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Nov 2006 22:57:24 -0500
Content-Disposition: inline
In-Reply-To: <20061102011935.GZ6360@austin.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linas Vepstas <linas@austin.ibm.com>
Cc: linux-scsi@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org

On Wed, Nov 01, 2006 at 07:19:37PM -0600, Linas Vepstas wrote:
> @@ -657,6 +657,10 @@ static irqreturn_t sym53c8xx_intr(int ir
>  	unsigned long flags;
>  	struct sym_hcb *np = (struct sym_hcb *)dev_id;
>  
> +	/* Avoid spinloop trying to handle interrupts on frozen device */
> +	if (pci_channel_offline(np->s.device))
> +		return IRQ_HANDLED;
> +
>  	if (DEBUG_FLAGS & DEBUG_TINY) printf_debug ("[");
>  
>  	spin_lock_irqsave(np->s.host->host_lock, flags);

Just wondering ... should we really be returning HANDLED?  What if the
IRQ is shared?  Will the hardware de-assert the level interrupt when it
puts the device in reset (ie is this a transitory glitch?), or do we
have to cope with a screaming interrupt?

> +#define WAIT_FOR_PCI_RECOVERY	35
> +	if (pci_channel_offline(np->s.device))
> +	{

I prefer if () {

> +static pci_ers_result_t sym2_io_slot_reset (struct pci_dev *pdev)
> +{
> +	struct sym_hcb *np = pci_get_drvdata(pdev);
> +
> +	printk(KERN_INFO "%s: recovering from a PCI slot reset\n",
> +	          sym_name(np));
> +
> +	if (pci_enable_device(pdev)) {
> +		printk(KERN_ERR "%s: Unable to enable afer PCI reset\n",
> +		        sym_name(np));
> +		return PCI_ERS_RESULT_DISCONNECT;
> +	}
> +
> +	pci_set_master(pdev);
> +	enable_irq(pdev->irq);

Hm.  If we need to call pci_set_master, then we're also going to need to
call pci_set_mwi (if appropriate) which is currently done in
sym_set_workarounds().  Except you don't have a sym_device, or a
sym_chip around at this point.  Bother.  Need to do some refactoring to
take care of that.

> +		/* Prevent deadlock waiting on a condition that may never clear. */
> +		if (unlikely(sist == 0xffff && dstat == 0xff)) {
> +			if (unlikely(pci_channel_offline(np->s.device)))
> +				return;
> +		}

I like the first unlikely ... but I'd drop the second one.  If they are
both ffff ff, I'd say it's quite likely ;-)  Anyway, the first unlikely
is good enough a hint to GCC, IMO.

Thanks!
