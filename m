From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] block: Make blk_drain_queue() work for stopped queues
Date: Sun, 18 Mar 2012 08:57:03 -0700
Message-ID: <20120318155703.GB8045@dhcp-172-17-108-109.mtv.corp.google.com>
References: <4F65E09D.6010600@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37935 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658Ab2CRP5I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 18 Mar 2012 11:57:08 -0400
Received: by pbcun15 with SMTP id un15so712850pbc.19
        for <linux-scsi@vger.kernel.org>; Sun, 18 Mar 2012 08:57:08 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <4F65E09D.6010600@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Jens Axboe <axboe@kernel.dk>, Stanislaw Gruszka <sgruszka@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Sun, Mar 18, 2012 at 01:18:21PM +0000, Bart Van Assche wrote:
> All queued requests must be processed eventually. Hence make sure
> that blk_drain_queue() drains the queue even if the queue is in the
> stopped state. This patch makes it safe to invoke blk_cleanup_queue()
> on a stopped queue.
...
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 3a78b00..bdcec86 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -300,10 +300,8 @@ EXPORT_SYMBOL(blk_sync_queue);
>   */
>  void __blk_run_queue(struct request_queue *q)
>  {
> -	if (unlikely(blk_queue_stopped(q)))
> -		return;
> -
> -	q->request_fn(q);
> +	if (!blk_queue_stopped(q) || blk_queue_dead(q))
> +		q->request_fn(q);

So, this allows calling request_fn for dead && stopped queue.  Have
you seen something which requires this?

Thanks.

-- 
tejun
