From: "Moore, Eric Dean" <Emoore@lsil.com>
Subject: RE: mpt sets 64bit consistent mask yet requires mapping in same 4
	 GB chunk?!?
Date: Wed, 18 Feb 2004 19:03:47 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E5703EF93EA@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:48045 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S267150AbUBSAEM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Feb 2004 19:04:12 -0500
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>, Alex Williamson <alex.williamson@hp.com>
Cc: jbarnes@sgi.com, bjorn.helgaas@hp.com, willy@debian.org, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

Jeremy - thanks for your reply. Just wanted to clarify
if this would work on your system:


mptbase_probe(pdev,id) {

u64 mask64 = 0xFFFFFFFFFFFFFFFF;
u32 mask32 = 0xFFFFFFFF;

pci_enable_device(pdev);

ioc->pcidev32 = pdev;
ioc->pcidev64 = pdev;

r = pci_set_dma_mask(ioc->pcidev64, mask64 );
r = pci_set_consistent_dma_mask(ioc->pcidev64, mask64 );
r = pci_set_dma_mask(ioc->pcidev32, mask32 );
r = pci_set_consistent_dma_mask(ioc->pcidev32, mask32 );

/* use 
 * ioc->pcidev32 
 * for the three fifo memory allocations for < 4gb  
 *
 * use
 * ioc->pcidev64 
 * for all other allocations
 */

}


On Wednesday, February 18, 2004 4:21 PM, Jeremy Higdon wrote:
> 
> On Wed, Feb 18, 2004 at 11:52:57AM -0700, Alex Williamson wrote:
> > On Wed, 2004-02-18 at 11:41, Moore, Eric Dean wrote:
> > > Regarding last weeks thread
> > > on mpt fusion driver(2.6 kernel), and PrimeIocFifos:
> > > 
> > [snip... a third allocation dependency]
> > 
> > > If this fix is urgent, I recommend providing a quick 
> > > fix which is creating 32bit pci_dev mask just for these 
> > > three pci_alloc_consistent calls. 
> > > 
> > 
> >    The current failure mode is pretty ugly and appears 
> fairly random.  I
> > would consider getting something that works reliably to be 
> urgent.  It
> > sounds easy and safe to twiddle the consistent device mask 
> in the short
> > term and combine these allocations in a future rev.  Thanks,
> > 
> > 	Alex
> 
> 
> Unfortunately, the SGI platform needs 64 bit addresses for consistent
> allocations.  However, since that's not reliable, I guess we'll just
> need to wait for a fix that combines the allocations.
> 
> Eric, do you have any idea how long this will take?
> 
> thanks
> 
> jeremy
> 
