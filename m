From: Mark Haverkamp <markh@osdl.org>
Subject: RE: [PATCH 1/3] 2.6.0 aacraid driver update
Date: Wed, 08 Oct 2003 07:23:02 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1065622982.4840.11.camel@markh1.pdx.osdl.net>
References: <0998F43EAD645A47B3F6507196DD70EA256AA6@otcexc01.otc.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:30909 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S261582AbTJHOX6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Oct 2003 10:23:58 -0400
In-Reply-To: <0998F43EAD645A47B3F6507196DD70EA256AA6@otcexc01.otc.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: Mark Salyzyn <mark_salyzyn@adaptec.com>
Cc: Matthew Wilcox <willy@debian.org>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>

On Wed, 2003-10-08 at 06:11, Salyzyn, Mark wrote:
> The scsicmd->SCp.ptr is `stealing' an unused member of the command to hold
> on to the physical address of an additional allocation that is part of the
> request so that when the command completes the memory can be `freed'.
> 
> My recommendation is to allocate an additional structure to hold on to all
> classes of `theft' like this in the driver (my guess is there is more) and
> use the SCp.ptr to point to this allocation rather than try to `steal' more
> to make up the full length.
> 
> Any wisdom of the list with regards to this?
> 
> Sincerely -- Mark Salyzyn
> 

I looked at the scsi_pointer struct yesterday and found that it already
has a dma_handle element that is the right type.  I updated the code to
use SCp.dma_handle and removed all the casting. Does that sound OK? 
This way we don't have to alloc another struct.

Mark.

> -----Original Message-----
> From: Mark Haverkamp [mailto:markh@osdl.org]
> Sent: Tuesday, October 07, 2003 5:51 PM
> To: Matthew Wilcox
> Cc: Jeff Garzik; linux-scsi; James Bottomley; Salyzyn, Mark
> Subject: Re: [PATCH 1/3] 2.6.0 aacraid driver update
> 
> 
> On Tue, 2003-10-07 at 14:39, Matthew Wilcox wrote:
> > On Tue, Oct 07, 2003 at 02:18:12PM -0700, Mark Haverkamp wrote:
> > > > > -		pci_unmap_single(dev->pdev,
> (dma_addr_t)(ulong)scsicmd->SCp.ptr,
> > > > > +		pci_unmap_single(dev->pdev, (dma_addr_t)(unsigned
> long)scsicmd->SCp.ptr,
> > > > >  				 scsicmd->request_bufflen,
> > > > >
> scsi_to_pci_dma_dir(scsicmd->sc_data_direction));
> > 
> > > I checked out this casting today.  The function takes a dma_addr_t as
> > > the argument.  You can't just pass the pointer in as is because:
> > > 
> > > drivers/scsi/aacraid/aachba.c:690: warning: passing arg 2 of
> `pci_unmap_single'
> > > makes integer from pointer without a cast
> > > 
> > > If you just cast the pointer to dma_addr_t you get:
> > > 
> > > drivers/scsi/aacraid/aachba.c:688: warning: cast from pointer to integer
> of different size
> > > 
> > > If you just cast to unsigned long, as in the code below, there aren't
> any warnings, but
> > > the wrong type is being passed to the function.  So, I think that both
> the casts are
> > > needed.
> > 
> > Oops, that's not true.  Try it out yourself.
> > 
> > int foo(short bar);
> > 
> > int baz(void)
> > {
> > 	return foo(0x12345678);
> > }
> > 
> > will truncate the argument to foo to 0x5678 before calling it by
> > implicitly casting to a short.  So we can do just fine with:
> > 
> > -		pci_unmap_single(dev->pdev,
> (dma_addr_t)(ulong)scsicmd->SCp.ptr,
> > +		pci_unmap_single(dev->pdev, (unsigned long)scsicmd->SCp.ptr,
> >  				 scsicmd->request_bufflen,
> >
> scsi_to_pci_dma_dir(scsicmd->sc_data_direction));
> > 
> > Now that all that casting is out of the way, we can see this driver isn't
> > highmem-safe as it's storing a dma_addr_t in a pointer ... yuck.
> 
> Ok, I see now.
> 
> Thanks,
> Mark.
-- 
Mark Haverkamp <markh@osdl.org>

