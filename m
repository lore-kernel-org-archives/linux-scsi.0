From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] bsg: Remove bogus check against request_queue->max_sectors
Date: Tue, 20 Jan 2009 14:09:14 +0100
Message-ID: <20090120130914.GH30821@kernel.dk>
References: <4975CCC6.7000009@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:16125 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755280AbZATNKp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jan 2009 08:10:45 -0500
Content-Disposition: inline
In-Reply-To: <4975CCC6.7000009@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>

On Tue, Jan 20 2009, Boaz Harrosh wrote:
> 
> bsg submits REQ_TYPE_BLOCK_PC so the right check is max_hw_sectors.
> But I've removed this check because right after, bsg proceeds with
> calling blk_rq_map_user() which does all the right checks.
> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>

Definitely right.

Acked-by: Jens Axboe <jens.axboe@oracle.com>

> ---
>  block/bsg.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/block/bsg.c b/block/bsg.c
> index 0ce8806..44a2a0f 100644
> --- a/block/bsg.c
> +++ b/block/bsg.c
> @@ -218,9 +218,6 @@ bsg_validate_sgv4_hdr(struct request_queue *q, struct sg_io_v4 *hdr, int *rw)
>  
>  	if (hdr->guard != 'Q')
>  		return -EINVAL;
> -	if (hdr->dout_xfer_len > (q->max_sectors << 9) ||
> -	    hdr->din_xfer_len > (q->max_sectors << 9))
> -		return -EIO;
>  
>  	switch (hdr->protocol) {
>  	case BSG_PROTOCOL_SCSI:
> -- 
> 1.6.0.1
> 

-- 
Jens Axboe

