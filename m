From: Mark Haverkamp <markh@osdl.org>
Subject: Re: [PATCH 1/3] 2.6.0 aacraid driver update
Date: Tue, 07 Oct 2003 14:18:12 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1065561492.29117.46.camel@markh1.pdx.osdl.net>
References: <1065475266.17021.75.camel@markh1.pdx.osdl.net>
	 <3F81E4D8.20904@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:50878 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S262881AbTJGVSU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Oct 2003 17:18:20 -0400
In-Reply-To: <3F81E4D8.20904@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>, Mark Salyzyn <mark_salyzyn@adaptec.com>

On Mon, 2003-10-06 at 14:55, Jeff Garzik wrote:
> Mark Haverkamp wrote:

....

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

I checked out this casting today.  The function takes a dma_addr_t as
the argument.  You can't just pass the pointer in as is because:

drivers/scsi/aacraid/aachba.c:690: warning: passing arg 2 of `pci_unmap_single'
makes integer from pointer without a cast

If you just cast the pointer to dma_addr_t you get:

drivers/scsi/aacraid/aachba.c:688: warning: cast from pointer to integer of different size

If you just cast to unsigned long, as in the code below, there aren't any warnings, but
the wrong type is being passed to the function.  So, I think that both the casts are
needed.


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
> 
-- 
Mark Haverkamp <markh@osdl.org>

