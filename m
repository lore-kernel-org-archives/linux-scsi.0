From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Concerns about "mpt2sas: Added Reply Descriptor Post Queue
 (RDPQ) Array support"
Date: Thu, 02 Apr 2015 08:59:44 +0300
Message-ID: <1427954384.3559.89.camel@HansenPartnership.com>
References: <1424408500.27448.25.camel@kernel.crashing.org>
	 <1424408769.27448.28.camel@kernel.crashing.org>
	 <1424409761.27448.32.camel@kernel.crashing.org>
	 <1424411110.16222.5.camel@HansenPartnership.com>
	 <1427953181.20500.230.camel@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1427953181.20500.230.camel@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2015-04-02 at 16:39 +1100, Benjamin Herrenschmidt wrote:
> On Thu, 2015-02-19 at 21:45 -0800, James Bottomley wrote:
> 
> > Ben, this is legal by design.  It was specifically designed for the
> > aic79xx SCSI card, but can be used for a variety of other reasons.  The
> > aic79xx hardware problem was that the DMA engine could address the whole
> > of memory (it had two address modes, a 39 bit one and a 64 bit one) but
> > the script engine that runs the mailboxes only had a 32 bit activation
> > register (the activating write points at the physical address of the
> > script to begin executing).  This meant that the scripts that run in
> > memory had to be in the first 4GB of physical memory, hence the split
> > mask.  The DMA mask specifies that the card can transfer from anywhere
> > in physical memory, but the consistent_dma_mask says that the consistent
> > allocation used to get scripts memory must come from the lower 4GB.
> 
> So looking at that again...
> 
> This is interesting ... basically any driver using a different mask has
> been broken on powerpc for basically ever. The whole concept was poorly
> designed, for example,  the set_consistent_mask isn't a dma_map_ops
> unlike everything else.
> 
> In some cases, what we want is convey a base+offset information to
> drivers but we can't do that.
> 
> This stuff cannot work with setups like a lot of our iommus where we
> have a remapped region at the bottom of the DMA address space and a
> bypass (direct map) region high up.
> 
> Basically, we can fix it, at least for most platforms, but it will be
> hard, invasive, *and* will need to go to stable. Grmbl.

Well, it was originally a hack for altix, because they had no regions
below 4GB and had to specifically manufacture them.  As you know, in
Linux, if Intel doesn't need it, no-one cares and the implementation
bitrots.

> We'll have to replace our "direct" DMA ops (which just apply an offset)
> which we use for devices that set a 64-bit mask on platform that support
> a bypass window, with some smart-ass hybrid variant that selectively
> shoot stuff up to the bypass window or down via the iommu remapped based
> on the applicable mask for a given operation.
> 
> It would be nice if we could come up with a way to inform the driver
> that we support that sort of "bypass" region with an offset. That would
> allow drivers that have that 64-bit base + 32-bit offset scheme to work
> much more efficiently for us. The driver could configure the base to be
> our "bypass window offset", and we could use ZONE_DMA32 for consistent
> DMAs.
> 
> It would also help us with things like some GPUs that can only do 40-bit
> DMA (which won't allow them to reach our bypass region normally) but do
> have a way to configure the generated top bits of all DMA addresses in
> some fixed register.
> 
> Any idea what such an interface might look like ?

Why doesn't the API we have today work (modulo a better implementation)?
A consistent mask specifies a wide range of possible locations for your
bypass region.  You just have to select one and attach it somehow and
remember to use it for consistent allocations.  As long as
set_consistent_mask becomes a dma op, it should all work, right?

James
