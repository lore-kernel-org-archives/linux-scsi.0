From: "J.E.J. Bottomley" <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] get rid of ->detect for upper layer drivers
Date: Thu, 07 Nov 2002 13:08:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200211071808.gA7I8jf04237@localhost.localdomain>
References: <adam@yggdrasil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id KAA23804
	for <linux-scsi@vger.kernel.org>; Thu, 7 Nov 2002 10:08:50 -0800
In-Reply-To: Message from "Adam J. Richter" <adam@yggdrasil.com>
   of "Thu, 07 Nov 2002 09:47:45 PST." <200211071747.JAA29988@adam.yggdrasil.com>
List-Id: linux-scsi@vger.kernel.org
To: "Adam J. Richter" <adam@yggdrasil.com>
Cc: andmike@us.ibm.com, hch@lst.de, linux-scsi@vger.kernel.org

adam@yggdrasil.com said:
> 	I would prefer bus_type.match because it slightly reduces the
> overhead of another patch that I posted to the generic device code:
> two fields in struct device_driver for having the generic device layer
> do the initial kmalloc and dma_alloc_consistent for the device (and do
> the failure if these allocations fail).  This can greatly reduce the
> number of rarely tested error branches (e.g., alloc_disk failure in
> st.c does not free buffer) because of the number of drivers that can
> be cleaned up a bit by it: hundreds of drivers, thousands of lines of
> code. 

This worries me: dma_alloc_consistent will always fail on fully incoherent 
architectures (like some PA-RISC ones), then you have to fall back to doing 
the writeback, invalidates in the driver (which we can't abstract out because 
the only the driver knows the sync points).  You can't really treat 
dma_alloc_consistent failure as anything other than an indication that you 
have to use a different dma access method.

Since dma_alloc_consistent cannot properly fail on an x86 (unless 
__get_free_pages does), do we really want to clutter up the main line with 
lots of fallbacks that would be useless on the predominant architecture?

James


