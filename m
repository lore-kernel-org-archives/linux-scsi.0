From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH v4] block: handle pointer error from blk_get_request
Date: Thu, 23 May 2013 23:24:47 +0300
Message-ID: <519E7B0F.9050604@panasas.com>
References: <alpine.DEB.2.02.1303171328250.1736@jlaw-desktop.mno.stratus.com> <alpine.DEB.2.02.1303261438130.26171@jlaw-desktop.mno.stratus.com> <alpine.DEB.2.02.1303261826270.26171@jlaw-desktop.mno.stratus.com> <20130523160940.23dc4aee@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from natasha.panasas.com ([67.152.220.90]:37488 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758943Ab3EWUZM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 May 2013 16:25:12 -0400
In-Reply-To: <20130523160940.23dc4aee@jlaw-desktop.mno.stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <JBottomley@parallels.com>, Bart Van Assche <bvanassche@acm.org>

On 23/05/13 23:09, Joe Lawrence wrote:
> Hi Jens,
> 
> Subject: [PATCH v4] block: handle pointer error from blk_get_request
> 
> The blk_get_request function may fail in low-memory conditions or during
> device removal (even if __GFP_WAIT is set). To distinguish between these
> errors, modify the blk_get_request call stack to return the appropriate
> error pointer. Verify that all callers check the return status and
> consider IS_ERR instead of a simple NULL pointer check.
> 
> Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: linux-scsi@vger.kernel.org

ACK-by: Boaz Harrosh <bharrosh@panasas.com>

> ---
<>
>  drivers/scsi/osd/osd_initiator.c            |  4 ++--
<>
> diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
> index d8293f2..b4cd56b 100644
> --- a/drivers/scsi/osd/osd_initiator.c
> +++ b/drivers/scsi/osd/osd_initiator.c
> @@ -1567,8 +1567,8 @@ static struct request *_make_request(struct request_queue *q, bool has_write,
>  		struct request *req;
>  
>  		req = blk_get_request(q, has_write ? WRITE : READ, flags);
> -		if (unlikely(!req))
> -			return ERR_PTR(-ENOMEM);
> +		if (unlikely(IS_ERR(req)))
> +			return req;
>  
>  		return req;
>  	}


