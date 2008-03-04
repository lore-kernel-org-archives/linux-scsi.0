From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH] block: fix residual byte count handling
Date: Tue, 4 Mar 2008 11:11:15 +0900
Message-ID: <20080304111056X.tomof@acm.org>
References: <47CC09B6.6090709@gmail.com>
	<20080303235207S.tomof@acm.org>
	<47CC7F3D.4010605@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <47CC7F3D.4010605@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: htejun@gmail.com
Cc: tomof@acm.org, jens.axboe@oracle.com, fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, efault@gmx.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, jgarzik@pobox.com
List-Id: linux-scsi@vger.kernel.org

On Tue, 04 Mar 2008 07:44:13 +0900
Tejun Heo <htejun@gmail.com> wrote:

> FUJITA Tomonori wrote:
> > On Mon, 03 Mar 2008 23:22:46 +0900
> > Tejun Heo <htejun@gmail.com> wrote:
> > 
> >> FUJITA Tomonori wrote:
> >>>> At the end of blk_rq_map_user() together with data_len / extra_len
> >>>> mangling or were you talking about James' original patch?
> >>> With my patch, at the end of blk_rq_map_user, we have:
> >>>
> >>> 	if (len & queue_dma_alignment(q)) {
> >>> 		unsigned int pad_len = (queue_dma_alignment(q) & ~len) + 1;
> >>>
> >>> 		rq->extra_len += pad_len;
> >>> 	}
> >>>
> >>>
> >>> So no change as compared with 2.6.24?
> >> Oh.. you killed sg list manipulation.  Many controllers do allow odd
> >> bytes as the last sg entry but not all.  Also, if you append drain
> > 
> > Until 2.6.24, these drivers have taken care about the issue by
> > themselves. There is no change as compared with 2.6.24.
> 
> Yeah, libata did its own padding and needed to add draining.  Private
> implementation was complex as hell and James suggested moving them to
> block layer.  Are you suggesting moving them back to drivers?

No, I'm not. I've been working on the IOMMUs to remove such
workarounds in LLDs.

What drivers need to do on this is just adding a padding length, that
is, drivers don't need to change the structure of the sg list (like
splitting a sg entry), right? And it doesn't break the SAS drivers
that support SATAPI, does it?

But I agree that drivers want to get a complete sglist so I'm fine
with adjusting sglist entries in the block layer with your secode
patch (separate out padding from alignment). As we discussed, I'm fine
with breaking sum(sg) == rq->data_len as long as rq->data_len means
the true data length.


> >> buffer after it, it ends up with unaligned sg entry in the middle and
> >> rq->data_len + rq->extra_len will overrun the sg entry after the drain
> >> page which is really dangerous.
> > 
> > The drivers know that they use drain buffer. They can take care about
> > themselves on this too. If we want to do explicitly, we could have
> > rq->pad_len and rq->drain_len instead of rq->extra_len, though I think
> > that we are fine without these values because these drivers already
> > tell the block layer what they want and know that the block layer
> > gives it.
> 
> So, if a driver has requested aligning and draining, the driver should
> extend the sg entry before the last one by the alignment if draining was
> used for the request and extent the last sg if the draining wasn't used.
>  I'd rather just implement them in the drivers.

The block layer extends the sg entry? The drivers just adjust
sg->length?
