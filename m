From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 2.4.30-pre3] x86_64: pci_alloc_consistent() match 2.6
	implementation
Date: Sat, 19 Mar 2005 17:27:39 +0100
Message-ID: <1111249660.8446.19.camel@laptopd505.fenrus.org>
References: <20050318212344.GC26112@lists.us.dell.com>
	 <1111212585.6291.41.camel@laptopd505.fenrus.org>
	 <20050319141634.GA17045@lists.us.dell.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from pentafluge.infradead.org ([213.146.154.40]:13223 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262633AbVCSQ1s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Mar 2005 11:27:48 -0500
In-Reply-To: <20050319141634.GA17045@lists.us.dell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: ak@suse.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Sat, 2005-03-19 at 08:16 -0600, Matt Domsch wrote:
> On Sat, Mar 19, 2005 at 07:09:45AM +0100, Arjan van de Ven wrote:
> > On Fri, 2005-03-18 at 15:23 -0600, Matt Domsch wrote:
> > > For review and comment.
> > > 
> > > On x86_64 systems with no IOMMU and with >4GB RAM (in fact, whenever
> > > there are any pages mapped above 4GB), pci_alloc_consistent() falls
> > > back to using ZONE_DMA for all allocations, even if the device's
> > > dma_mask could have supported using memory from other zones.  Problems
> > > can be seen when other ZONE_DMA users (SWIOTLB, scsi_malloc()) consume
> > > all of ZONE_DMA, leaving none left for pci_alloc_consistent() use.
> > 
> > scsi_malloc no longer uses ZONE_DMA nowadays....
> 
> In 2.4.x it does.  scsi_resize_dma_pool() has:
>       __get_free_pages(GFP_ATOMIC | GFP_DMA, 0);
> scsi_init_minimal_dma_pool() has similar.
> 

oh you want to do major changes to the 2.4 tree... sounds like a bad
idea to change such vm behavior..


