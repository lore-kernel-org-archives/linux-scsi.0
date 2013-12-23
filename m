From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 1/6] block: support blk-mq on
 blk_run_queue/blk_run_queue_async.
Date: Sun, 22 Dec 2013 22:27:31 -0800
Message-ID: <1387780051.5567.126.camel@haakon3.risingtidesystems.com>
References: <201311291641305594235@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:49078 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730Ab3LWG0Z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Dec 2013 01:26:25 -0500
In-Reply-To: <201311291641305594235@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>

Hi Jianpeng,

Apologies for the long delayed response on this series. 

Comments are inline.

On Fri, 2013-11-29 at 16:41 +0800, majianpeng wrote:
> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> ---
>  block/blk-core.c |   21 ++++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index bf44ca0..549d83e 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -304,8 +304,12 @@ EXPORT_SYMBOL(__blk_run_queue);
>   */
>  void blk_run_queue_async(struct request_queue *q)
>  {
> -	if (likely(!blk_queue_stopped(q) && !blk_queue_dead(q)))
> -		mod_delayed_work(kblockd_workqueue, &q->delay_work, 0);
> +	if (likely(!blk_queue_stopped(q) && !blk_queue_dead(q))) {
> +		if (q->mq_ops)
> +			blk_mq_run_queues(q, 1);
> +		else
> +			mod_delayed_work(kblockd_workqueue, &q->delay_work, 0);
> +	}
>  }
>  EXPORT_SYMBOL(blk_run_queue_async);
>  
> @@ -319,11 +323,14 @@ EXPORT_SYMBOL(blk_run_queue_async);
>   */
>  void blk_run_queue(struct request_queue *q)
>  {
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(q->queue_lock, flags);
> -	__blk_run_queue(q);
> -	spin_unlock_irqrestore(q->queue_lock, flags);
> +	if (q->mq_ops)
> +		blk_mq_run_queues(q, 0);
> +	else {
> +		unsigned long flags;
> +		spin_lock_irqsave(q->queue_lock, flags);
> +		__blk_run_queue(q);
> +		spin_unlock_irqrestore(q->queue_lock, flags);
> +	}
>  }
>  EXPORT_SYMBOL(blk_run_queue);
>  

OK, after playing with QEMU AHCI + TYPE_ROM emulation recently to test
your series I can now RO mount an ISO image with a subset of the
patches.  That, plus some minor QEMU atapi.c hacks make cdrom.c do it's
thing.

Btw, I've encountered a QEMU ahci emulation CHECK_CONDITION exception
hangswith scsi-mq, which are due to the current lack of scsi-eh support
which libata depends upon to complete these failed commands.  (Currently
avoiding this bug with QEMU atapi hacks..)

AFAICT this particular patch doesn't seem to be required to make basic
QEMU AHCI emulation work with GOOD or CHECK_CONDITION status.  Just
curious, do you have a particular case with hw AHCI + TYPE_ROM where
this is strictly required..?

Thank you,

--nab

