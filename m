From: Mark Haverkamp <markh@osdl.org>
Subject: Re: [PATCH 1/3] 2.6.0 aacraid driver update
Date: Mon, 06 Oct 2003 15:09:45 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1065478184.17021.85.camel@markh1.pdx.osdl.net>
References: <1065475266.17021.75.camel@markh1.pdx.osdl.net>
	 <3F81E4D8.20904@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:50892 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S261754AbTJFWKE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Oct 2003 18:10:04 -0400
In-Reply-To: <3F81E4D8.20904@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>, Mark Salyzyn <mark_salyzyn@adaptec.com>

On Mon, 2003-10-06 at 14:55, Jeff Garzik wrote:
> Mark Haverkamp wrote:

> > @@ -523,9 +632,27 @@
> >  		dev->pae_support = (paemode!=0);
> >  	}
> >  	if(dev->pae_support != 0) {
> > -		printk(KERN_INFO"%s%d: 64 Bit PAE enabled\n", dev->name, dev->id);
> > -		pci_set_dma_mask(dev->pdev, (dma_addr_t)0xFFFFFFFFFFFFFFFFULL);
> > +		if (pci_set_dma_mask(dev->pdev, 
> > +					(dma_addr_t)0xFFFFFFFFFFFFFFFFULL)) {
> 
> you may (and should) remove the cast.
> 

> 
> 
> > +	} else {
> > +		/* 
> > +		 * Reset if Quirk 31 was used, since data 
> > +		 * transfers are ok.
> > +		 */
> > +		if (pci_set_dma_mask(dev->pdev, (dma_addr_t)0xFFFFFFFFULL)) {
> > +			printk(KERN_INFO"aacraid: Can't reset DMA mask.\n");
> 
> remove the cast
> 
> 
> 
> > @@ -559,7 +686,7 @@
> >  			scsicmd->use_sg,
> >  			scsi_to_pci_dma_dir(scsicmd->sc_data_direction));
> >  	else if(scsicmd->request_bufflen)
> > -		pci_unmap_single(dev->pdev, (dma_addr_t)(ulong)scsicmd->SCp.ptr,
> > +		pci_unmap_single(dev->pdev, (dma_addr_t)(unsigned long)scsicmd->SCp.ptr,
> >  				 scsicmd->request_bufflen,
> >  				 scsi_to_pci_dma_dir(scsicmd->sc_data_direction));
> >  	readreply = (struct aac_read_reply *)fib_data(fibptr);
> 
> do you really need all that casting?  :)
> 
> 
> 
> > @@ -603,7 +734,7 @@
> >  			scsicmd->use_sg,
> >  			scsi_to_pci_dma_dir(scsicmd->sc_data_direction));
> >  	else if(scsicmd->request_bufflen)
> > -		pci_unmap_single(dev->pdev, (dma_addr_t)(ulong)scsicmd->SCp.ptr,
> > +		pci_unmap_single(dev->pdev, (dma_addr_t)(unsigned long)scsicmd->SCp.ptr,
> >  				 scsicmd->request_bufflen,
> >  				 scsi_to_pci_dma_dir(scsicmd->sc_data_direction));
> >  
> 
> likewise
> 
> 
> 
> 
> > @@ -1235,7 +1511,7 @@
> >  			scsicmd->use_sg,
> >  			scsi_to_pci_dma_dir(scsicmd->sc_data_direction));
> >  	else if(scsicmd->request_bufflen)
> > -		pci_unmap_single(dev->pdev, (ulong)scsicmd->SCp.ptr, scsicmd->request_bufflen,
> > +		pci_unmap_single(dev->pdev, (unsigned long)scsicmd->SCp.ptr, scsicmd->request_bufflen,
> >  			scsi_to_pci_dma_dir(scsicmd->sc_data_direction));
> >  
> 
> ah-hah, you choose another casting style, differing from the above 
> examples I pointed out...

I'll go back over everything and fix and make the casting more
consistent, as well as check over the code for all you other comments.

Thanks for looking this over.
Mark.
> 
-- 
Mark Haverkamp <markh@osdl.org>

