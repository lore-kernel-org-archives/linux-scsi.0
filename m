From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 3/3] 2.6.0 aacraid driver update
Date: Mon, 06 Oct 2003 17:48:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F81E34A.1040201@pobox.com>
References: <1065475285.17021.79.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:11930 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261664AbTJFVtL
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Oct 2003 17:49:11 -0400
In-Reply-To: <1065475285.17021.79.camel@markh1.pdx.osdl.net>
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>, Mark Salyzyn <mark_salyzyn@adaptec.com>

Mark Haverkamp wrote:
> @@ -194,8 +208,17 @@
>  			if (pci_enable_device(dev))
>  				continue;
>  			pci_set_master(dev);
> -			pci_set_dma_mask(dev, 0xFFFFFFFFULL);
>  
> +			if (aac_drivers[index].quirks & AAC_QUIRK_31BIT)
> +				ret = pci_set_dma_mask(dev, 0x7FFFFFFFULL);
> +			else
> +				ret = pci_set_dma_mask(dev, 0xFFFFFFFFULL);
> +
> +			if (ret) {
> +				printk(KERN_WARNING "aacraid: Can't set DMA mask.\n");
> +				continue;
> +			}
> +				
>  			if((dev->subsystem_vendor != aac_drivers[index].subsystem_vendor) || 
>  			   (dev->subsystem_device != aac_drivers[index].subsystem_device))
>  					continue;

This probe loop is fairly yucky, and this last 'if' test shows it's 
unnecessary.

Use the last field in struct pci_device_id to provide an index into a 
pci-id-specific info table.

And overall, let the PCI API do this sort of looping for you.



> +static irqreturn_t aac_rkt_intr(int irq, void *dev_id, struct pt_regs *regs)
> +{
> +	struct aac_dev *dev = dev_id;
> +	unsigned long bellbits;
> +	u8 intstat, mask;
> +	intstat = rkt_readb(dev, MUnit.OISR);
> +	/*
> +	 *	Read mask and invert because drawbridge is reversed.
> +	 *	This allows us to only service interrupts that have 
> +	 *	been enabled.
> +	 */
> +	mask = ~(rkt_readb(dev, MUnit.OIMR));

Don't keep reading this infrequently-changing interrupt mask from 
hardware...  Save an IO and cache that.  Is that possible?



> +	/*
> +	 *	Wait up to 30 seconds
> +	 */
> +	while (time_before(jiffies, start+30*HZ)) 
> +	{
> +		udelay(5);	/* Delay 5 microseconds to let Mon960 get info. */
> +		/*
> +		 *	Mon960 will set doorbell0 bit when it has completed the command.
> +		 */
> +		if (rkt_readl(dev, OutboundDoorbellReg) & OUTBOUNDDOORBELL_0) {
> +			/*
> +			 *	Clear the doorbell.
> +			 */
> +			rkt_writel(dev, OutboundDoorbellReg, OUTBOUNDDOORBELL_0);
> +			ok = 1;
> +			break;
> +		}
> +		/*
> +		 *	Yield the processor in case we are slow 
> +		 */
> +		set_current_state(TASK_UNINTERRUPTIBLE);
> +		schedule_timeout(1);

hmmm... why not simply call yield() here instead?  I think yield() is 
closer to the intent you wish to achieve...

Also note that you udelay() _before_ your first readb().  This could be 
a PCI posting bug.



> +	/*
> +	 *	Map in the registers from the adapter.
> +	 */
> +	if((dev->regs.rkt = (struct rkt_registers *)ioremap((unsigned long)dev->scsi_host_ptr->base, 8192))==NULL)
> +	{	
> +		printk(KERN_WARNING "aacraid: unable to map i960.\n" );
> +		return -1;
> +	}

Make the line length of this 'if' test shorter, and in the process make 
the code more readable, by splitting this operation into two lines:  the 
ioremap(), and the 'if' test for NULL.

The above is an excellent example of why people should _not_ combine 
assignment and 'if' tests... it just obfuscates the code.

	Jeff



