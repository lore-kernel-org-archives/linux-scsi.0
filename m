From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 1/2] block: move the padding adjustment to blk_rq_map_sg
Date: Mon, 07 Apr 2008 20:07:56 +0900
Message-ID: <20080407200756G.fujita.tomonori@lab.ntt.co.jp>
References: <1207155180-8069-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1207155180-8069-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<47F45035.8060003@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:45956 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbYDGLIm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Apr 2008 07:08:42 -0400
In-Reply-To: <47F45035.8060003@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: htejun@gmail.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, tomof@acm.org, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com

Hi,

On Thu, 03 Apr 2008 12:34:13 +0900
Tejun Heo <htejun@gmail.com> wrote:

> Hello,
> 
> FUJITA Tomonori wrote:
> > -	/*
> > -	 * __blk_rq_map_user() copies the buffers if starting address
> > -	 * or length isn't aligned to dma_pad_mask.  As the copied
> > -	 * buffer is always page aligned, we know that there's enough
> > -	 * room for padding.  Extend the last bio and update
> > -	 * rq->data_len accordingly.
> > -	 *
> > -	 * On unmap, bio_uncopy_user() will use unmodified
> > -	 * bio_map_data pointed to by bio->bi_private.
> > -	 */
> > -	if (len & q->dma_pad_mask) {
> > -		unsigned int pad_len = (q->dma_pad_mask & ~len) + 1;
> > -		struct bio *tail = rq->biotail;
> > -
> > -		tail->bi_io_vec[tail->bi_vcnt - 1].bv_len += pad_len;
> > -		tail->bi_size += pad_len;
> > -
> > -		rq->extra_len += pad_len;
> > -	}
> > -
> >  	rq->buffer = rq->data = NULL;
> >  	return 0;
> >  unmap_rq:
> > diff --git a/block/blk-merge.c b/block/blk-merge.c
> > index 0f58616..2a81c87 100644
> > --- a/block/blk-merge.c
> > +++ b/block/blk-merge.c
> > @@ -220,6 +220,13 @@ new_segment:
> >  		bvprv = bvec;
> >  	} /* segments in rq */
> >  
> > +	if (sg && (q->dma_pad_mask & rq->data_len)) {
> > +		unsigned int pad_len = (q->dma_pad_mask & ~rq->data_len) + 1;
> > +
> > +		sg->length += pad_len;
> > +		rq->extra_len += pad_len;
> > +	}
> > +
> 
> We're not sure it will always have the extra room.  For example, 
> map_user_iov doesn't do it and there can be in-kernel issuers.

Yeah, I see.


> Maybe we need yet another flag indicating padding space
> availability?

How about doing the exact same thing that the drain buffer does? We
can put pre-allocated buffer to a queue and save one sg entry for it.
