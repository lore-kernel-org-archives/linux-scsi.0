From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: DMA mapping on SCSI device?
Date: Tue, 29 Jan 2008 10:33:50 -0500
Message-ID: <1201620830.3069.5.camel@localhost.localdomain>
References: <479E6E8C.2090501@shaw.ca>  <200801290528.00934.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <200801290528.00934.ak@suse.de>
Sender: linux-ide-owner@vger.kernel.org
To: Andi Kleen <ak@suse.de>
Cc: Robert Hancock <hancockr@shaw.ca>, linux-arch@vger.kernel.org, ide <linux-ide@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Tue, 2008-01-29 at 05:28 +0100, Andi Kleen wrote:
> > The ideal solution would be to do mapping against a different struct
> > device for each port, so that we could maintain the proper DMA mask for
> > each of them at all times. However I'm not sure if that's possible.
> 
> I cannot imagine why it should be that difficult. The PCI subsystem
> could over a pci_clone_device() or similar function.   For all complicated
> purposes (sysfs etc)  the original device could be used, so it would
> be hopefully not that difficult.

I know it works for parisc ... all we care about for DMA mapping is the
mask in the actual device and the location of the iommu.  For the
latter, we just go up device->parent until we find it, so as long as
manufactured devices are properly parented we have no problems with
mapping them.

The concern matthew has is this code in asm-generic/dma-mapping.h:

static inline void *
dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t
*dma_handle,
                   gfp_t flag)
{
        BUG_ON(dev->bus != &pci_bus_type);

        return pci_alloc_consistent(to_pci_dev(dev), size, dma_handle);
}

The manufactured devices wouldn't be PCI devices (otherwise they'd show
up in PCI and cause all sorts of confusion), so any architectures which
haven't converted to using the dma_ functions internally will BUG here.

However, a quick audit shows that to be just m68k, v850 and sparc (not
sparc64), so they're probably none the driver cares about.

> The alternative would be to add a new family of PCI mapping
> functions that take an explicit mask. Disadvantage would be changing 
> all architectures, but on the other hand the interface could be phase
> in one by one (and nF4 primarily only works on x86 anyways) 

I suppose it would allow us to clean dma_mask and dma_coherent_mask out
of the device structures ... on the other hand, the mask isn't simply
what the device wants, it's also what the platform allows you to set, so
it would have to be stored somewhere anyway.

> I suspect the later would be a little cleaner, although they don't
> make much difference.

James


