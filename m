From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 1/2] block: move the padding adjustment to blk_rq_map_sg
Date: Thu, 03 Apr 2008 12:34:13 +0900
Message-ID: <47F45035.8060003@gmail.com>
References: <1207155180-8069-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1207155180-8069-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.236]:63802 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759422AbYDCDeV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Apr 2008 23:34:21 -0400
Received: by wx-out-0506.google.com with SMTP id h31so3206352wxd.4
        for <linux-scsi@vger.kernel.org>; Wed, 02 Apr 2008 20:34:19 -0700 (PDT)
In-Reply-To: <1207155180-8069-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, tomof@acm.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <jens.axboe@oracle.com>

Hello,

FUJITA Tomonori wrote:
> -	/*
> -	 * __blk_rq_map_user() copies the buffers if starting address
> -	 * or length isn't aligned to dma_pad_mask.  As the copied
> -	 * buffer is always page aligned, we know that there's enough
> -	 * room for padding.  Extend the last bio and update
> -	 * rq->data_len accordingly.
> -	 *
> -	 * On unmap, bio_uncopy_user() will use unmodified
> -	 * bio_map_data pointed to by bio->bi_private.
> -	 */
> -	if (len & q->dma_pad_mask) {
> -		unsigned int pad_len = (q->dma_pad_mask & ~len) + 1;
> -		struct bio *tail = rq->biotail;
> -
> -		tail->bi_io_vec[tail->bi_vcnt - 1].bv_len += pad_len;
> -		tail->bi_size += pad_len;
> -
> -		rq->extra_len += pad_len;
> -	}
> -
>  	rq->buffer = rq->data = NULL;
>  	return 0;
>  unmap_rq:
> diff --git a/block/blk-merge.c b/block/blk-merge.c
> index 0f58616..2a81c87 100644
> --- a/block/blk-merge.c
> +++ b/block/blk-merge.c
> @@ -220,6 +220,13 @@ new_segment:
>  		bvprv = bvec;
>  	} /* segments in rq */
>  
> +	if (sg && (q->dma_pad_mask & rq->data_len)) {
> +		unsigned int pad_len = (q->dma_pad_mask & ~rq->data_len) + 1;
> +
> +		sg->length += pad_len;
> +		rq->extra_len += pad_len;
> +	}
> +

We're not sure it will always have the extra room.  For example, 
map_user_iov doesn't do it and there can be in-kernel issuers.  Maybe we 
need yet another flag indicating padding space availability?

-- 
tejun
