From: "Moore, Eric Dean" <Emoore@lsil.com>
Subject: RE: mpt sets 64bit consistent mask yet requires mapping in same 4
	 GB chunk?!?
Date: Thu, 19 Feb 2004 12:18:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E5703EF9453@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:26831 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S267395AbUBSRSl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Feb 2004 12:18:41 -0500
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: Alex Williamson <alex.williamson@hp.com>, jbarnes@sgi.com, bjorn.helgaas@hp.com, willy@debian.org, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

My comments <EDM> are embedded below.

On Wednesday, February 18, 2004 6:10 PM,Jeremy Higdon wrote: 
> 
> On Wed, Feb 18, 2004 at 07:03:47PM -0500, Moore, Eric Dean wrote:
> > Jeremy - thanks for your reply. Just wanted to clarify
> > if this would work on your system:
> > 
> > 
> > mptbase_probe(pdev,id) {
> > 
> > u64 mask64 = 0xFFFFFFFFFFFFFFFF;
> > u32 mask32 = 0xFFFFFFFF;
> > 
> > pci_enable_device(pdev);
> > 
> > ioc->pcidev32 = pdev;
> > ioc->pcidev64 = pdev;
> > 
> > r = pci_set_dma_mask(ioc->pcidev64, mask64 );
> > r = pci_set_consistent_dma_mask(ioc->pcidev64, mask64 );
> > r = pci_set_dma_mask(ioc->pcidev32, mask32 );
> > r = pci_set_consistent_dma_mask(ioc->pcidev32, mask32 );
> > 
> > /* use 
> >  * ioc->pcidev32 
> >  * for the three fifo memory allocations for < 4gb  
> >  *
> >  * use
> >  * ioc->pcidev64 
> >  * for all other allocations
> >  */
> > 
> > }
> 
> I don't think so, for two reasons.
> 
> The first is that we require 64 bit PCI addresses for all 
> PCI-X devices.

<EDM> 
I'm not sure what you mean? 
For PCI-X devices - are you saying passing something other than
0xFFFFFFFFFFFFFFFF for the mask in pci_set_consistent_dma_mask()
fails? 

Does your system have restrictions below 4GB?

I would believe pci_alloc_consistent() call would work 
if memory allocation is restricted to below < 4GB.


> 
> The second is that if I understand your pseudo-code 
> correctly, the pcidev64
> and pcidev32 pointers are both pointing to the same struct 
> pci_dev, which
> would mean that the second pci_set_consistent_dma_mask call 
> would override
> the first.

<EDM> 
Your right. My mistake in the example. I would be allocating
seperate memory for the 32bit pcidev.

> 
> Hopefully it's not too much effort to change it to a single consistent
> allocation for all three FIFO chunks.  I don't see another way around
> this.

<EDM> 
This driver is in current code freeze as LSI as I have up-ported 
bug fixes/enhances back from the 2.4 kernel version of the mpt driver.
The 2.4 kernel version of the mpt driver is in current test cycle
for the next couple weeks.  

Adding 32bit dma handles is much less impact to the driver, and
I could go ahead and send you a test driver to see if this would work
later today.

However merging the 3 fifo allocations would need to wait till
after this release due to the nature of the change.  I need
to wait till something like the first week of March.

Eric

  





