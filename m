From: Mark Lobo <ntdeveloper2002@yahoo.com>
Subject: Re: Bounce buffer usage
Date: Sun, 3 Nov 2002 14:10:29 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021103221029.7908.qmail@web80304.mail.yahoo.com>
References: <20021102091256.GC31088@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021102091256.GC31088@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: linux-scsi@vger.kernel.org


> I think this is your problem. So you want to write
> out a page of memory.
> You basically want to do
> 
> user address -> page -> virtual address -> page =
> virt_to_page(va) ->
>     dma map page
> 
> and this is a problem because for some pages we just
> don't have a
> virtual kernel mapping. Instead you want to do
> 
> user address -> page -> dma map page
> 
> which doesn't require a virtual mapping at all. You
> want to pass down
> page/length/offset tuplets to the dma mapping api,
> not virtual
> addresses. Please read the document I pointed you
> at, it explains this
> for you. You seem to be confused about several
> things in this area.
>
Ok! So now I guess I understand how this DMA API
works. I did read this document along with the bounce
buffer patch doc. If I get a buffer in the SCSI
initiator driver for a single page, ( which means no
scatter gather), all I get in the SCSI initiator is
the address of the request buffer. To get the page
associated with the buffer, I need to call
virt_to_page ( as mentioned in the bounce buffer patch
docs ). And the DMA mapping doc says the following
about transferring a simgle page
"
        struct pci_dev *pdev = mydev->pdev;
        dma_addr_t dma_handle;
        struct page *page = buffer->page;
        unsigned long offset = buffer->offset;
        size_t size = buffer->len;

        dma_handle = pci_map_page(dev, page, offset,
size, direction);

        ...

        pci_unmap_page(dev, dma_handle, size,
direction);
"
Now in the initiator driver, all what I get is a
request buffer address. To actually use the above API,
I need the page address, and that I get from
virt_to_page ( as described in the bounce buffer patch
doc) So I dont need a virt_to_page call to get the
page address? I dont understand how I can use 
this --> "struct page *page = buffer->page;"? In that
case, what gets passed down to the initiator in the
"no scatter gather" case is some kind of structure?
Dont I need to do "struct page *page =
virt_to_page(buffer);"?


Youve been a great help Jens. I really appreciate all
your help! 

Thanks,
Mark

__________________________________________________
Do you Yahoo!?
New DSL Internet Access from SBC & Yahoo!
http://sbc.yahoo.com
