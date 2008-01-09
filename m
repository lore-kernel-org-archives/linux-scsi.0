From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] libata: eliminate the home grown dma padding in favour
	of	that provided by the block layer
Date: Tue, 08 Jan 2008 22:24:32 -0600
Message-ID: <1199852673.3534.76.camel@localhost.localdomain>
References: <1199138168.3110.12.camel@localhost.localdomain>
	 <47842D29.8020509@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <47842D29.8020509@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>, Jens Axboe <Jens.Axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jeff Garzik <jeff@garzik.org>
List-Id: linux-scsi@vger.kernel.org


On Wed, 2008-01-09 at 11:10 +0900, Tejun Heo wrote:
> James Bottomley wrote:
> > ATA requires that all DMA transfers begin and end on word boundaries.
> > Because of this, a large amount of machinery grew up in ide to adjust
> > scatterlists on this basis.  However, as of 2.5, the block layer has a
> > dma_alignment variable which ensures both the beginning and length of a
> > DMA transfer are aligned on the dma_alignment boundary.  Although the
> > block layer does adjust the beginning of the transfer to ensure this
> > happens, it doesn't actually adjust the length, it merely makes sure
> > that space is allocated for transfers beyond the declared length.  The
> > upshot of this is that scatterlists may be padded to any size between
> > the actual length and the length adjusted to the dma_alignment safely
> > knowing that memory is allocated in this region.
> > 
> > Right at the moment, SCSI takes the default dma_aligment which is on a
> > 512 byte boundary.  Note that this aligment only applies to transfers
> > coming in from user space.  However, since all kernel allocations are
> > automatically aligned on a minimum of 32 byte boundaries, it is safe to
> > adjust them in this manner as well.
> > 
> > Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> > 
> > ---
> > 
> > This also fixes a current panic in libsas with SATAPI devices.  I was
> > trying to trace a bad interaction between the libata padding and the new
> > sglist code which was the root cause, and ended up concluding that the
> > whole libata padding thing was redundant.
> > 
> > In a future improvement, I think we can relax SCSI dma_alignemnt (it's
> > causing almost every user space command to be copied instead of directly
> > passed through) and allow devices and transports to build up their own
> > requirements instead.
> 
> Great but this intersects with currently queued and pending changes for
> libata-dev#upstream and needs to be merged. 

That's OK, I can do the merge .. that's what git is for.

>  Also, DMA alignment at
> block layer isn't enough for ATA.  ATA needs drain buffers for ATAPI
> commands with variable length response.  :-(

OK, where is this in the libata code?  The dma_pad size is only 4 bytes,
so this drain, I assume is only a word long?  Given the word alignment
requirements of ATA doesn't this still mean it's only draining up to the
word boundary anyway (so the code is still correct)?

James


