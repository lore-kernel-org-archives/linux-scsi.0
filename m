From: "Moore, Eric Dean" <Emoore@lsil.com>
Subject: RE: mpt sets 64bit consistent mask yet requires mapping in same 4
	 GB chunk?!?
Date: Wed, 18 Feb 2004 13:41:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E5703EF9372@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:63929 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S267586AbUBRSmb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Feb 2004 13:42:31 -0500
List-Id: linux-scsi@vger.kernel.org
To: Alex Williamson <alex.williamson@hp.com>, jbarnes@sgi.com, jeremy@sgi.com, bjorn.helgaas@hp.com, willy@debian.org, James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

Regarding last weeks thread
on mpt fusion driver(2.6 kernel), and PrimeIocFifos:

The problem we face in combining two pci_alloc_consistent
for reply and request fifo into one memory allocation is 
there is a third pci_alloc_consistent call from mptscsih, 
which creates a chain buffer pool. The chain buffer pool
is a pool of extra memory which links additional message
frames to the request fifo.  The original author of these
drivers thought it was best to separate this memory allocation
into a separate device driver to conserve memory in mptbase. 
It will be a lot of work/testing at this time to combine 
three alloc's to one memory allocation, as code is being 
located in two separate device drivers.

If this fix is urgent, I recommend providing a quick 
fix which is creating 32bit pci_dev mask just for these 
three pci_alloc_consistent calls. 

Eric Moore
LSI Logic



On Friday, February 13, 2004 9:12 AM, Alex Williamson wrote:
> 
> 
> Eric,
> 
>    I think I found a bug in the version 3.00.02 mpt driver that's
> currently in Linus' 2.6 tree (latest linux-2.5).  Here's the code
> snippet:
> 
> message/fusion/mptbase.c: PrimeIocFifos()
> ...
>     if (sizeof(dma_addr_t) == sizeof(u64)) {
>         /* Check: upper 32-bits of the request and reply frame
>          * physical addresses must be the same.
>          */
>         if (((u64)ioc->req_frames_dma >> 32) != 
> ((u64)ioc->reply_frames_dma >> 32)){
>             goto out_fail;
>     }
> 
> req_frames_dma and reply_frames_dma are aligned version of 
> dma addresses
> retrieved via two separate pci_alloc_consistent() calls.  The 
> mpt driver
> sets a 64bit consistent dma mask.  How is it reasonable to assume two
> separate mappings will fall within the same 4GB chunk of memory?  I
> recently added support for consistent mapping bypass in the sba_iommu
> driver for the ia64 zx1 chipset.  Randomly on bootup, the MPT driver
> fails.  Checking the mappings, I get a things like this:
> 
> mptbase: Initiating ioc0 bringup
> ioc0: 53C1030: Capabilities={Initiator}
> sba_alloc_coherent() bypassing, dma_handle: 0x1fffb8000, 
> addr: 0xe0000001fffb8000
> sba_alloc_coherent() bypassing, dma_handle: 0x40ffcd8000, 
> addr: 0xe0000040ffcd8000
> PrimeIocFifos() req_frames_dma: 0x40ffcd8000, 
> reply_frames_dma: 0x1fffb8000
> mptbase: WARNING - ioc0 did not initialize properly! (-3)
> 
> These are two perfectly valid consistent mappings as far as 
> the platform
> code is concerned.  I think mpt really needs to either set a 32bit
> consistent map of do a single allocation when it requires this type of
> thing.  Thanks,
> 
> 	Alex
> 
> -- 
> Alex Williamson                             HP Linux & Open Source Lab
> 
