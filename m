From: Doug Ledford <dledford@redhat.com>
Subject: Re: Aic7xxx v6.2.22 and Aic79xx v1.3.0Alpha2 Released
Date: Fri, 13 Dec 2002 18:20:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021213232013.GF10883@redhat.com>
References: <1266570000.1039619906@aslan.scsiguy.com> <20021211153935.A23704@infradead.org> <1221760000.1039627865@aslan.btc.adaptec.com> <20021211181745.A30253@infradead.org> <20021212202052.GC8842@redhat.com> <20021213210215.A15074@infradead.org> <20021213212352.GA10883@redhat.com> <20021213215113.A16528@infradead.org> <20021213225225.GB10883@redhat.com> <59730000.1039820896@aslan.btc.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <59730000.1039820896@aslan.btc.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On Fri, Dec 13, 2002 at 04:08:17PM -0700, Justin T. Gibbs wrote:
> > On Fri, Dec 13, 2002 at 09:51:13PM +0000, Christoph Hellwig wrote:
> >> On Fri, Dec 13, 2002 at 04:23:52PM -0500, Doug Ledford wrote:
> >> > Hmmm...what's the failure mode here?
> >> 
> >> It complains that it can't reserve the mem regions but still continues to
> >> setup, download sequencer code, and even register scsi3ff.
> > 
> > Hmmm...are you loading mine or Justin's driver first?  Mine should bail, 
> > not continue, when it can't reserve the requested region.
> 
> If the new driver is loaded second, you'll wind up with a config
> space COMMAND register with both IO space and MEM space disabled.
> The reason for this was to ensure that the aic7xxx controller was
> not responding to a memory or I/O port already requested for a
> *different device*.

Two PCI devices sharing the same I/O or Mem space either one is invalid.  
If the space is allocated to the card, then it *belongs* to that card and
there should never be a conflict.  So, in my driver now, I switched to
using pci_request_regions() (pretty nice helper function actually, it
grabs *all* the pci resources that are assigned to that card and fails if
it can't get all of them).  That's the only thing that really made sense
to me.  Now, I think the *only* thing I might do differently is to move
the pci_enable_device() call to after the pci_request_regions() since
right now the pci_enable_device() is the first thing my driver does (I
wasn't sure, but I thought you might have to call pci_enable_device() to
trigger some resource allocations so that pci_request_regions() would have
all the regions it needs to reserve properly allocated).  But, that should
be fairly safe from a 2 driver standpoint (I'm making the assumption that
calling pci_enabled_device() on an already enabled and live card isn't a
problem, which I think is right but probably warrants a deeper look into
the pci subsys to be sure).  It's also pretty close to identical to what I
do in the eisa/vlb case.

>  I wasn't thinking about a *different driver*
> accessing the same device.  There are other PCI api functions
> that are called prior to the region check too (set powerstate, enable
> device, set dma mask, etc.).  I just don't know how safe you can
> really make it unless the old driver uses the PCI registration API.
> The new driver will fail though if *both* its memory and port addresses
> cannot be mapped.

I had a few things in there before the region check as well.  I just moved 
the region check up to the top, right after pci_enable_device().

> In the other load order, the driver only reserves the region type it is
> using.

Which I think is technically wrong IMHO.  Whether you use the I/O space or
not, it's been allocated to you by the BIOS/PCI subsystem.  If you can't
have control over an area allocated to you then there is a bogon hiding
somewhere in the woodpile.

> The other region is simply disabled in the COMMAND register.  This is
> probably why things are failing.  One driver is using mem I/O.  The other
> is using PIO.
> 
> --
> Justin

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
