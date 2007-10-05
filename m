From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 14/17] sym53c8xx: Get rid of IRQ_FMT and IRQ_PRM
Date: Fri, 05 Oct 2007 16:59:47 -0400
Message-ID: <4706A5C3.6000005@garzik.org>
References: <11916141143747-git-send-email-matthew@wil.cx> <11916141153666-git-send-email-matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:42475 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762212AbXJEU7u (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Oct 2007 16:59:50 -0400
In-Reply-To: <11916141153666-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>

Matthew Wilcox wrote:
> @@ -1196,8 +1193,8 @@ static int sym_host_info(struct sym_hcb *np, char *ptr, off_t offset, int len)
>  	copy_info(&info, "Chip " NAME53C "%s, device id 0x%x, "
>  			 "revision id 0x%x\n", np->s.chip_name,
>  			 np->s.device->device, np->s.device->revision);
> -	copy_info(&info, "At PCI address %s, IRQ " IRQ_FMT "\n",
> -		pci_name(np->s.device), IRQ_PRM(np->s.device->irq));
> +	copy_info(&info, "At PCI address %s, IRQ %d\n",
> +			 pci_name(np->s.device), np->s.device->irq);
>  	copy_info(&info, "Min. period factor %d, %s SCSI BUS%s\n",
>  			 (int) (np->minsync_dt ? np->minsync_dt : np->minsync),
>  			 np->maxwide ? "Wide" : "Narrow",
> @@ -1283,9 +1280,9 @@ static struct Scsi_Host * __devinit sym_attach(struct scsi_host_template *tpnt,
>  	unsigned long flags;
>  	struct sym_fw *fw;
>  
> -	printk(KERN_INFO "sym%d: <%s> rev 0x%x at pci %s irq " IRQ_FMT "\n",
> +	printk(KERN_INFO "sym%d: <%s> rev 0x%x at pci %s irq %d\n",
>  		unit, dev->chip.name, pdev->revision, pci_name(pdev),
> -		IRQ_PRM(pdev->irq));
> +		pdev->irq);
>  
>  	/*
>  	 *  Get the firmware for this chip.

NAK

The proper format string is '%u' because irq is unsigned

