From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] block: fix residual byte count handling
Date: Sat, 01 Mar 2008 09:19:53 -0600
Message-ID: <1204384793.4003.102.camel@localhost.localdomain>
References: <20080226150845.2196bc1a.akpm@linux-foundation.org>
	 <1204079075.26640.8.camel@homer.simson.net>
	 <1204092010.9934.31.camel@homer.simson.net>
	 <1204096025.1623.9.camel@homer.simson.net> <47C6661E.9010504@gmail.com>
	 <1204186800.7362.7.camel@homer.simson.net> <47C675C6.8000904@gmail.com>
	 <20080228153542.GZ6704@kernel.dk> <47C6D73E.4030302@gmail.com>
	 <1204303656.4003.19.camel@localhost.localdomain>
	 <20080229201123.GK6704@kernel.dk>  <47C8F4FC.1040505@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:36366 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754403AbYCAPT6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Mar 2008 10:19:58 -0500
In-Reply-To: <47C8F4FC.1040505@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Mike Galbraith <efault@gmx.de>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>


On Sat, 2008-03-01 at 15:17 +0900, Tejun Heo wrote:
> Hello, Jens, James.
> 
> Jens Axboe wrote:
> >> With the original patch, I have to run through the whole of libsas and
> >> scsi_transport_sas doing
> >>
> >> s/data_len/raw_data_len/
> >>
> >> With your update it looks like I have to run through them all doing
> >>
> >> s/data_len/data_len - extra_len/
> 
> blk_rq_raw_data_len() should do.

I know we *could* sweep through all the block drivers altering them; my
point is that I don't think we *should*.  Fundamentally, every driver
that cares is assuming req->data_len is the length of the request that
came down.  The fact that it got padded is irrelevant (and actually
detrimental) to most of them as the SMP driver illustrates.

We use a high dma_alignment not because we care about padding, but
because we want to avoid scatter gather.  So we care about alignment of
the start of the buffer (to avoid sg), but fundamentally, we need to
know what its true length (not its padded length) is.  The true length
feeds into the smp frame size and is checked by the interfaces, which is
why the changes caused an SMP failure.

Just for the principle of least surprise, can we not keep req->data_len
what it has always been, namely the true data length of the request and
express the fact that we've padded it by req->extra_len or something, so
we don't have to do all of these driver changes.

> >> which is even worse.  Can't we put things back to a point where data_len
> >> means exactly that and extra_len means how much we have spare on the
> >> end, so you know you can DMA up to data_len + extra_len if need be?
> >>
> >> That way we don't have to sweep through every block driver altering the
> >> way it uses data_len.
> 
> If SMP is broken because it needs start address alignment but not
> padding to align the size, what should be done is to make that exact
> requirement visible to the block layer.  Say,
> blk_queue_dma_start_alignment() or maybe change
> blk_queue_dma_alignment() such that it only indicates start address
> alignment and add blk_queue_dma_size_alignment() for drivers which
> require size to be aligned too.  I think those are few.

But this is true of *every* current user of the block layer apart from
IDE ... we all care about alignment not padding.  Any current user that
actually cares about padding will be doing their own adjustments, so
they need changing anyway.

We can frame that with a different API, but blk_queue_dma_alignment()
better be the common case (start but not pad alignment).

> I think the decision which value rq->data_len represents comes down to
> which size is used more in low level drivers because no matter which way
> we choose we'll have to update some of the drivers which expects the
> other thing from rq->data_len.

Right, and currently, apart from IDE, they all want it to mean the true
data length.

> blk_rq_raw_data_len() is needed iff a driver needs dummy buffers
> attached at the end and still needs to know the original request size
> which isn't the common case.

I think it *is* the common case.

> > Fully agree. The reason why I think it's so ugly is that you have to
> > keep these two seperate variables in sync. The burning was just one bug,
> > there will be others...
> 
> The posted modification isn't too bad as the maintenance of the two
> variables is at places where the nasty things happen.  I think what
> rq->data_len should represent when seen from LLDs is more important and
> please note that if SMP is broken because it simply doesn't require
> 512byte size alignment, it's a different issue.

But we still have to find all the bugs this causes in all the block
drivers ... that's my biggest concern right now.

> As long as both raw_data_len and data_len are accessible, I'm okay
> either way.  My biggest reluctance is against breaking sum(sg) ==
> rq->data_len.  I think this can lead to much more subtle problems such
> as programming the controller w/ wrong bytes count and wrapped-around
> resid calculation.

OK, so can we go back to data_len being the true value and add an
extra_len for drivers who want to know where the padding lies?

James


