From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH v6 2/2] block,scsi: convert and handle ERR_PTR from  blk_get_request
Date: Mon, 4 Nov 2013 15:41:25 +0200
Message-ID: <5277A405.706@panasas.com>
References: <1383227434-4536-3-git-send-email-joe.lawrence@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from natasha.panasas.com ([209.166.131.148]:51325 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371Ab3KDO4J (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Nov 2013 09:56:09 -0500
In-Reply-To: <1383227434-4536-3-git-send-email-joe.lawrence@stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: linux-scsi@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, "James E.J. Bottomley" <JBottomley@parallels.com>, =?UTF-8?B?S2FpIE3DpGtpc2FyYQ==?= <Kai.Makisara@kolumbus.fi>, Benny Halevy <bhalevy@tonian.com>, Doug Gilbert <dgilbert@interlog.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <axboe@kernel.dk>, Jiri Kosina <jkosina@suse.cz>, Paolo Bonzini <pbonzini@redhat.com>, Tim Waugh <tim@cyberelk.net>, Willem Riede <osst@riede.org>

On 10/31/2013 03:50 PM, Joe Lawrence wrote:
> The blk_get_request function may fail in low-memory conditions or during
> device removal (even if __GFP_WAIT is set). To distinguish between these
> errors, modify the blk_get_request call stack to return the appropriate
> ERR_PTR. Verify that all callers check the return status and consider
> IS_ERR instead of a simple NULL pointer check.
> 
> Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
> ---
<>
> diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
> index aa66361ed44b..0250efda647b 100644
> --- a/drivers/scsi/osd/osd_initiator.c
> +++ b/drivers/scsi/osd/osd_initiator.c
> @@ -1567,8 +1567,8 @@ static struct request *_make_request(struct request_queue *q, bool has_write,
>  		struct request *req;
>  
>  		req = blk_get_request(q, has_write ? WRITE : READ, flags);
> -		if (unlikely(!req))
> -			return ERR_PTR(-ENOMEM);
> +		if (unlikely(IS_ERR(req)))

Just a nit IS_ERR already has an unlikely so it can be dropped here. (No bigy)

ACK-by: Boaz Harrosh <bharrosh@panasas.com>

> +			return req;
>  
>  		return req;
>  	}
<>

Thanks
Boaz

