From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] block: fix residual byte count handling
Date: Tue, 04 Mar 2008 17:53:02 +0900
Message-ID: <20080304175302T.fujita.tomonori@lab.ntt.co.jp>
References: <47CC7F3D.4010605@gmail.com>
	<20080304111056X.tomof@acm.org>
	<47CCB4D8.8090600@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama555.ecl.ntt.co.jp ([129.60.39.106]:44197 "EHLO
	tama555.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755487AbYCDJuH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Mar 2008 04:50:07 -0500
In-Reply-To: <47CCB4D8.8090600@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: htejun@gmail.com
Cc: tomof@acm.org, jens.axboe@oracle.com, fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, efault@gmx.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, jgarzik@pobox.com, bzolnier@gmail.com

On Tue, 04 Mar 2008 11:32:56 +0900
Tejun Heo <htejun@gmail.com> wrote:

> FUJITA Tomonori wrote:
> >> Yeah, libata did its own padding and needed to add draining.  Private
> >> implementation was complex as hell and James suggested moving them to
> >> block layer.  Are you suggesting moving them back to drivers?
> > 
> > No, I'm not. I've been working on the IOMMUs to remove such
> > workarounds in LLDs.
> > 
> > What drivers need to do on this is just adding a padding length, that
> > is, drivers don't need to change the structure of the sg list (like
> > splitting a sg entry), right? And it doesn't break the SAS drivers
> > that support SATAPI, does it?
> > 
> > But I agree that drivers want to get a complete sglist so I'm fine
> > with adjusting sglist entries in the block layer with your secode
> > patch (separate out padding from alignment). As we discussed, I'm fine
> > with breaking sum(sg) == rq->data_len as long as rq->data_len means
> > the true data length.
> 
> As long as the second patch is in, what value rq->data_len indicates
> doesn't matter to drivers which don't use explicit padding or draining,
> so the situation is much more controlled.  I don't care which value
> rq->data_len would indicate.  I'd prefer it equal sum(sg) as that value
> is what IDE and libata which will be the major users of padding and/or
> draining expect in rq->data_len but fixing up that shouldn't be too
> difficult.  I guess this can be determined by Jens.  If Jens likes
> rq->data_len to contain requested transfer size, I'll post updated patches.

OK, I prefer rq->data_len means the true data length though you prefer
rq->data_len means the allocated buffer length (the true data length
plus padding and drain). We agree on other things. We can live with
either way.

Jens, what's your preference?


> >>>> buffer after it, it ends up with unaligned sg entry in the middle and
> >>>> rq->data_len + rq->extra_len will overrun the sg entry after the drain
> >>>> page which is really dangerous.
> >>> The drivers know that they use drain buffer. They can take care about
> >>> themselves on this too. If we want to do explicitly, we could have
> >>> rq->pad_len and rq->drain_len instead of rq->extra_len, though I think
> >>> that we are fine without these values because these drivers already
> >>> tell the block layer what they want and know that the block layer
> >>> gives it.
> >> So, if a driver has requested aligning and draining, the driver should
> >> extend the sg entry before the last one by the alignment if draining was
> >> used for the request and extent the last sg if the draining wasn't used.
> >>  I'd rather just implement them in the drivers.
> > 
> > The block layer extends the sg entry? The drivers just adjust
> > sg->length?
> 
> Still, do you really wanna force such things into low level drivers?
> That will be one extremely fragile API and will be really difficult to
> tell when things go wrong.

No, I don't, as I explained above. As long as rq->data_len means the
true data length, I'm fine. I knew that James' drain buffer patch
breaks rq->data_len == sum(sg). I don't care about it. I can
understand that drivers wants to a perfect sglist.
