From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 1/3] 2.6.0 aacraid driver update
Date: Mon, 06 Oct 2003 17:55:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F81E4D8.20904@pobox.com>
References: <1065475266.17021.75.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:23194 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261749AbTJFVzt
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Oct 2003 17:55:49 -0400
In-Reply-To: <1065475266.17021.75.camel@markh1.pdx.osdl.net>
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>, Mark Salyzyn <mark_salyzyn@adaptec.com>

Mark Haverkamp wrote:

> +static void aac_io_done(Scsi_Cmnd * scsicmd)
> +{
> +	unsigned long cpu_flags;
> +	struct Scsi_Host *host = scsicmd->device->host;
> +	spin_lock_irqsave(host->host_lock, cpu_flags);
> +	scsicmd->scsi_done(scsicmd);
> +	spin_unlock_irqrestore(host->host_lock, cpu_flags);
> +}

Do you really need the host lock to end an IO?


> +static void __aac_io_done(Scsi_Cmnd * scsicmd)
> +{
> +	scsicmd->scsi_done(scsicmd);
> +}

This stuff should be in scsi_lib.c or a header in include/scsi, don't 
you think?


> @@ -523,9 +632,27 @@
>  		dev->pae_support = (paemode!=0);
>  	}
>  	if(dev->pae_support != 0) {
> -		printk(KERN_INFO"%s%d: 64 Bit PAE enabled\n", dev->name, dev->id);
> -		pci_set_dma_mask(dev->pdev, (dma_addr_t)0xFFFFFFFFFFFFFFFFULL);
> +		if (pci_set_dma_mask(dev->pdev, 
> +					(dma_addr_t)0xFFFFFFFFFFFFFFFFULL)) {

you may (and should) remove the cast.


> +			printk(KERN_INFO"%s%d: DMA mask set failed, 64 Bit PAE disabled\n", 
> +				dev->name, dev->id);
> +			dev->pae_support = 0;
> +		} else {
> +			printk(KERN_INFO"%s%d: 64 Bit PAE enabled\n", 
> +				dev->name, dev->id);

"64-bit DAC mode" may be a little bit more precise.

PAE is processor, and x86-specific at that.  DAC is PCI bus.


> +	} else {
> +		/* 
> +		 * Reset if Quirk 31 was used, since data 
> +		 * transfers are ok.
> +		 */
> +		if (pci_set_dma_mask(dev->pdev, (dma_addr_t)0xFFFFFFFFULL)) {
> +			printk(KERN_INFO"aacraid: Can't reset DMA mask.\n");

remove the cast



> @@ -559,7 +686,7 @@
>  			scsicmd->use_sg,
>  			scsi_to_pci_dma_dir(scsicmd->sc_data_direction));
>  	else if(scsicmd->request_bufflen)
> -		pci_unmap_single(dev->pdev, (dma_addr_t)(ulong)scsicmd->SCp.ptr,
> +		pci_unmap_single(dev->pdev, (dma_addr_t)(unsigned long)scsicmd->SCp.ptr,
>  				 scsicmd->request_bufflen,
>  				 scsi_to_pci_dma_dir(scsicmd->sc_data_direction));
>  	readreply = (struct aac_read_reply *)fib_data(fibptr);

do you really need all that casting?  :)



> @@ -603,7 +734,7 @@
>  			scsicmd->use_sg,
>  			scsi_to_pci_dma_dir(scsicmd->sc_data_direction));
>  	else if(scsicmd->request_bufflen)
> -		pci_unmap_single(dev->pdev, (dma_addr_t)(ulong)scsicmd->SCp.ptr,
> +		pci_unmap_single(dev->pdev, (dma_addr_t)(unsigned long)scsicmd->SCp.ptr,
>  				 scsicmd->request_bufflen,
>  				 scsi_to_pci_dma_dir(scsicmd->sc_data_direction));
>  

likewise




> @@ -1235,7 +1511,7 @@
>  			scsicmd->use_sg,
>  			scsi_to_pci_dma_dir(scsicmd->sc_data_direction));
>  	else if(scsicmd->request_bufflen)
> -		pci_unmap_single(dev->pdev, (ulong)scsicmd->SCp.ptr, scsicmd->request_bufflen,
> +		pci_unmap_single(dev->pdev, (unsigned long)scsicmd->SCp.ptr, scsicmd->request_bufflen,
>  			scsi_to_pci_dma_dir(scsicmd->sc_data_direction));
>  

ah-hah, you choose another casting style, differing from the above 
examples I pointed out...




