From: Andi Kleen <ak@suse.de>
Subject: Re: [PATCH 2.4.30-pre3] x86_64: pci_alloc_consistent() match 2.6 implementation
Date: Sat, 19 Mar 2005 20:26:45 +0100
Message-ID: <20050319192645.GA3937@wotan.suse.de>
References: <20050318212344.GC26112@lists.us.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from mail-ex.suse.de ([195.135.220.2]:45983 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S262657AbVCST0u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Mar 2005 14:26:50 -0500
Content-Disposition: inline
In-Reply-To: <20050318212344.GC26112@lists.us.dell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: ak@suse.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, Mar 18, 2005 at 03:23:44PM -0600, Matt Domsch wrote:
> For review and comment.
> 
> On x86_64 systems with no IOMMU and with >4GB RAM (in fact, whenever
> there are any pages mapped above 4GB), pci_alloc_consistent() falls
> back to using ZONE_DMA for all allocations, even if the device's
> dma_mask could have supported using memory from other zones.  Problems
> can be seen when other ZONE_DMA users (SWIOTLB, scsi_malloc()) consume
> all of ZONE_DMA, leaving none left for pci_alloc_consistent() use.
> 
> Patch below makes pci_alloc_consistent() for the nommu case (EM64T
> processors) match the 2.6 implementation of dma_alloc_coherent(), with
> the exception that this continues to use GFP_ATOMIC.

You fixed the wrong code. The pci-nommu code is only used
when IOMMU is disabled in the Kconfig. But most kernels have
it enabled. You would need to change it in pci-gart.c too.
 
The reason it is like this that nommu was always intended as a hackish kludge
that would be only used for debugging - little did we know that
it would become standard later.

-Andi
