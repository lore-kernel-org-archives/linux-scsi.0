From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] bsg: Remove bogus check against
 request_queue->max_sectors
Date: Wed, 21 Jan 2009 08:10:21 +0900
Message-ID: <20090121080334N.fujita.tomonori@lab.ntt.co.jp>
References: <4975CCC6.7000009@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:37732 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756581AbZATXKm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jan 2009 18:10:42 -0500
In-Reply-To: <4975CCC6.7000009@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, osd-dev@open-osd.org

On Tue, 20 Jan 2009 15:08:22 +0200
Boaz Harrosh <bharrosh@panasas.com> wrote:

> 
> bsg submits REQ_TYPE_BLOCK_PC so the right check is max_hw_sectors.
> But I've removed this check because right after, bsg proceeds with
> calling blk_rq_map_user() which does all the right checks.
> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
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

Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Thanks,
