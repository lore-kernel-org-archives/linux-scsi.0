From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 5/7] block: Make blk_cleanup_queue() wait until
 request_fn finished
Date: Sun, 28 Oct 2012 19:00:16 -0700
Message-ID: <20121029020016.GG5171@htj.dyndns.org>
References: <508A7B63.60608@acm.org>
 <508A7C4B.2060904@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34118 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504Ab2J2CAU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Oct 2012 22:00:20 -0400
Received: by mail-pa0-f46.google.com with SMTP id hz1so3064291pad.19
        for <linux-scsi@vger.kernel.org>; Sun, 28 Oct 2012 19:00:20 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <508A7C4B.2060904@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Chanho Min <chanho.min@lge.com>

On Fri, Oct 26, 2012 at 02:04:27PM +0200, Bart Van Assche wrote:
> Some request_fn implementations, e.g. scsi_request_fn(), unlock
> the queue lock. Make sure that blk_cleanup_queue() waits until all
> active request_fn invocations have finished. A block driver may
> start cleaning up resources needed by its request_fn as soon as
> blk_cleanup_queue() finished, so blk_cleanup_queue() must wait
> for all outstanding request_fn invocations to finish.

Ditto.  More verbose explanation *please*.

> Reported-by: Chanho Min <chanho.min@lge.com>
> Cc: James Bottomley <JBottomley@Parallels.com>
> Cc: Mike Christie <michaelc@cs.wisc.edu>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Tejun Heo <tj@kernel.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  block/blk-core.c       |    3 +++
>  include/linux/blkdev.h |    6 ++++++
>  2 files changed, 9 insertions(+)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 2f1be7a..7662d83 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -308,7 +308,9 @@ void inline __blk_run_queue_uncond(struct request_queue *q)
>  	if (unlikely(blk_queue_dead(q)))
>  		return;
>  
> +	q->request_fn_active++;
>  	q->request_fn(q);
> +	q->request_fn_active--;
>  }

Here too.

Thanks.

-- 
tejun
