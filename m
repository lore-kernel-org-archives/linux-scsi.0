From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: sata_sil24 0000:04:00.0: DMA-API: device driver frees DMA sg
	list  with different entry count [map count=13] [unmap count=10]
Date: Thu, 4 Jun 2009 09:53:09 +0200
Message-ID: <20090604075309.GU11363@kernel.dk>
References: <64bb37e0906032312i5f6906dehc0f8dd4e748254a2@mail.gmail.com> <20090604153253B.fujita.tomonori@lab.ntt.co.jp> <4A277482.5070909@panasas.com> <20090604164418F.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:57894 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652AbZFDHxH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Jun 2009 03:53:07 -0400
Content-Disposition: inline
In-Reply-To: <20090604164418F.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: bharrosh@panasas.com, just.for.lkml@googlemail.com, hancockrwd@gmail.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, Jun 04 2009, FUJITA Tomonori wrote:
> On Thu, 04 Jun 2009 10:15:14 +0300
> Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
> > On 06/04/2009 09:33 AM, FUJITA Tomonori wrote:
> > > On Thu, 4 Jun 2009 08:12:34 +0200
> > > Torsten Kaiser <just.for.lkml@googlemail.com> wrote:
> > > 
> > >> On Thu, Jun 4, 2009 at 2:02 AM, FUJITA Tomonori
> > >> <fujita.tomonori@lab.ntt.co.jp> wrote:
> > >>> On Wed, 3 Jun 2009 21:30:32 +0200
> > >>> Torsten Kaiser <just.for.lkml@googlemail.com> wrote:
> > >>>> Still happens with 2.6.30-rc8 (see trace at the end of the email)
> > >>>>
> > >>>> As orig_n_elem is only used two times in libata-core.c I suspected a
> > >>>> corruption of the qc->sg, but adding checks for this did not trigger.
> > >>>> So I looked into lib/dma-debug.c.
> > >>>> It seems add_dma_entry() does not protect against adding the same
> > >>>> entry twice.
> > >>> Do you mean that add_dma_entry() doesn't protect against adding a new
> > >>> entry identical to the existing entry, right?
> > >> Yes, as I read the hash bucket code in lib/dma-debug.c a second entry
> > >> from the same device and the same address will just be added to the
> > >> list and on unmap it will always return the first entry.
> > > 
> > > It means that two different DMA operations will be performed against
> > > the same dma addresss on the same device at the same time. It doesn't
> > > happen unless there is a bug in a driver, an IOMMU or somewhere, as I
> > > wrote in the previous mail.
> > > 
> > 
> > What about the draining buffers used by libata. Are they not the same buffer
> > for all devices for all requests?
> 
> I'm not sure if the drain buffer is used like that. But is there
> easier ways to see the same buffer; e.g. sending the same buffer twice
> with DIO?

I'm pretty sure we discussed this some months ago, the intel iommu
driver had a similar bug iirc. Lets say you want to write the same 4kb
block to two spots on the disk. You prepare and submit that with
O_DIRECT and using aio. On a device with NCQ, that could easily map the
same page twice. Or, perhaps more likely, doing 512b writes and not
getting all of them merged.

> As I wrote, I assume that he uses GART IOMMU; it allocates an unique
> dma address per dma mapping operation.
> 
> However, dma-debug is broken wrt this, I guess.

Seems so.

-- 
Jens Axboe

