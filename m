From: Jens Axboe <axboe@suse.de>
Subject: Re: Bounce buffer usage
Date: Sat, 2 Nov 2002 10:12:56 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021102091256.GC31088@suse.de>
References: <20021101074843.GF807@suse.de> <20021101185510.10154.qmail@web80305.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021101185510.10154.qmail@web80305.mail.yahoo.com>
List-Id: linux-scsi@vger.kernel.org
To: Mark Lobo <ntdeveloper2002@yahoo.com>
Cc: linux-scsi@vger.kernel.org

On Fri, Nov 01 2002, Mark Lobo wrote:
> 
> > Not so true anymore in 2.4.20-pre (and hasn't been
> > true in 2.5 since
> > 2.5.1). If you set host highmem_io flag,> 
> 
> So if I do set this flag in the host template, do I
> need the bounce buffer patch also that is floating
> around? Or is it just enough to set that flag and use
> the DMA API? Im using 2.4.18.

You need the patch, otherwise that template bool is not even there. Or
you just need 2.4.20-pre, the block-highmem patch has been integrated
since -pre2/3

>  it will be
> > happy to pass you
> > pages that have no kernel virtual mapping.
> 
> Pages that have no kernel virtual mapping? Do u mean
> pages with no kernel "logical" mapping? We finally

Yes

> need a kernel mapping, dont we? say if it is data in a
> single page ( no scatter gather ), what kind of

We don't the page mapped into the kernel virtual address space. For
scatter-gather setup, it's fine to know the physical address of such a
page. We can do clustering based on that. If the hardware (the platform,
not the controller) can further do iommu tricks on the resulting sg
table fine, but that's not our worry.

> address is passed down to the driver? Is it the pure
> user address that is just passed down, and the DMA API
> then gives the kernel address? cause we do need to do
> a virt_to_page in this case before we can use the DMA
> API, so what kind of virtual address is passed down to
> the initiator?

I think this is your problem. So you want to write out a page of memory.
You basically want to do

user address -> page -> virtual address -> page = virt_to_page(va) ->
    dma map page

and this is a problem because for some pages we just don't have a
virtual kernel mapping. Instead you want to do

user address -> page -> dma map page

which doesn't require a virtual mapping at all. You want to pass down
page/length/offset tuplets to the dma mapping api, not virtual
addresses. Please read the document I pointed you at, it explains this
for you. You seem to be confused about several things in this area.

> >If the
> > buffer sent down resides at a higher address than
> > what the adapter can
> > handle, then it is bounced. This may not necessarily
> > have anything to do
> > with kernel virtual mapping or not.
> 
> But if a buffer resides in high memory, and has no
> kernel logical mapping, doesnt it mean that bounce
> buffers will be used, especially in 2.4.18, without
> the highmem_io bit set?

2.4.18 without any patches will always bounce, there's nothing you can
do about it.

-- 
Jens Axboe

