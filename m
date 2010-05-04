From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 1/9] blk: Do not abort requests if queue is stopped
Date: Tue, 4 May 2010 12:45:37 +0200
Message-ID: <20100504104537.GN27497@kernel.dk>
References: <1272944228-30511-1-git-send-email-andmike@linux.vnet.ibm.com> <1272944228-30511-2-git-send-email-andmike@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:57836 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432Ab0EDKpj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 May 2010 06:45:39 -0400
Content-Disposition: inline
In-Reply-To: <1272944228-30511-2-git-send-email-andmike@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@suse.de>, dm-devel@redhat.com

On Mon, May 03 2010, Mike Anderson wrote:
> If the queue is stopped it could be an indication that other recovery is
> happening in this case skip the blk_abort_request.
> 
> Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
> Cc: Jens Axobe <jens.axboe@oracle.com>
> ---
>  block/blk-timeout.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/block/blk-timeout.c b/block/blk-timeout.c
> index 1ba7e0a..89fbe0a 100644
> --- a/block/blk-timeout.c
> +++ b/block/blk-timeout.c
> @@ -224,7 +224,8 @@ void blk_abort_queue(struct request_queue *q)
>  	list_splice_init(&q->timeout_list, &list);
>  
>  	list_for_each_entry_safe(rq, tmp, &list, timeout_list)
> -		blk_abort_request(rq);
> +		if (!blk_queue_stopped(q))
> +			blk_abort_request(rq);
>  
>  	/*
>  	 * Occasionally, blk_abort_request() will return without

That seems like a bit of a mixup, what ties a stopped queue to recovery?
To take one example, the cciss driver stops the queue when it can't
queue more at the hw level and starts it on completion to queue more. If
recovery triggers when the hw queue has been filled, then timeouts will
fail?

It would be better to mark the queue as already doing abort. That state
could be in the queue, or it could be at the driver level.

-- 
Jens Axboe

