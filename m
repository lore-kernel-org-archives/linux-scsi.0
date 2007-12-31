From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] libata: eliminate the home grown dma padding in favour
 of	that provided by the block layer
Date: Mon, 31 Dec 2007 17:56:20 -0500
Message-ID: <47797394.8020807@garzik.org>
References: <1199138168.3110.12.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1199138168.3110.12.camel@localhost.localdomain>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>, Jens Axboe <Jens.Axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
> ATA requires that all DMA transfers begin and end on word boundaries.
> Because of this, a large amount of machinery grew up in ide to adjust
> scatterlists on this basis.  However, as of 2.5, the block layer has a
> dma_alignment variable which ensures both the beginning and length of a
> DMA transfer are aligned on the dma_alignment boundary.  Although the
> block layer does adjust the beginning of the transfer to ensure this
> happens, it doesn't actually adjust the length, it merely makes sure
> that space is allocated for transfers beyond the declared length.  The
> upshot of this is that scatterlists may be padded to any size between
> the actual length and the length adjusted to the dma_alignment safely
> knowing that memory is allocated in this region.
> 
> Right at the moment, SCSI takes the default dma_aligment which is on a
> 512 byte boundary.  Note that this aligment only applies to transfers
> coming in from user space.  However, since all kernel allocations are
> automatically aligned on a minimum of 32 byte boundaries, it is safe to
> adjust them in this manner as well.
> 
> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> 
> ---
> 
> This also fixes a current panic in libsas with SATAPI devices.  I was
> trying to trace a bad interaction between the libata padding and the new
> sglist code which was the root cause, and ended up concluding that the
> whole libata padding thing was redundant.
> 
> In a future improvement, I think we can relax SCSI dma_alignemnt (it's
> causing almost every user space command to be copied instead of directly
> passed through) and allow devices and transports to build up their own
> requirements instead.

Initial read:  ACK, with thanks.  I'll queue this into libata#upstream, 
unless you have other suggestions.

This is definitely the sort of thing that low-level drivers (and their 
helper libs, e.g. libata) should not need to do.

	Jeff




