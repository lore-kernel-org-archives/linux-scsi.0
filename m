From: Dan Williams <djbw@fb.com>
Subject: Re: [PATCH 3/3] Make blk_cleanup_queue() wait until request_fn finished
Date: Mon, 1 Oct 2012 10:41:41 -0700
Message-ID: <CAA9_cmcJC+xFZigKWBjXPvKY39diN0iTMTWXMSep7++YRt1Dfw@mail.gmail.com>
References: <50648014.7080308@acm.org>
	<50648130.4060902@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46291 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab2JARlm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Oct 2012 13:41:42 -0400
Received: by obbuo13 with SMTP id uo13so5234371obb.19
        for <linux-scsi@vger.kernel.org>; Mon, 01 Oct 2012 10:41:41 -0700 (PDT)
In-Reply-To: <50648130.4060902@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>

On Thu, Sep 27, 2012 at 9:39 AM, Bart Van Assche <bvanassche@acm.org> wrote:
> Some request_fn implementations, e.g. scsi_request_fn(), unlock
> the queue lock. Make sure that blk_cleanup_queue() waits until all
> active request_fn invocations have finished. This fixes a potential
> use-after-free at the end of scsi_request_fn().
>
> Reported-by: Chanho Min <chanho.min@lge.com>
> Cc: James Bottomley <JBottomley@Parallels.com>
> Cc: Mike Christie <michaelc@cs.wisc.edu>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Tejun Heo <tj@kernel.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  block/blk-core.c        |    7 +++++--
>  drivers/scsi/scsi_lib.c |   10 +---------
>  include/linux/blkdev.h  |    5 +++++
>  3 files changed, 11 insertions(+), 11 deletions(-)
>
> diff --git a/block/blk-core.c b/block/blk-core.c
> index b5436b6..e41b291 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -308,7 +308,9 @@ void __blk_run_queue_uncond(struct request_queue *q)
>         if (unlikely(blk_queue_dead(q)))
>                 return;
>
> +       q->request_fn_active++;
>         q->request_fn(q);
> +       q->request_fn_active--;
>  }
>
>  /**
> @@ -407,6 +409,7 @@ void blk_drain_queue(struct request_queue *q, bool drain_all)
>                         __blk_run_queue(q);
>
>                 drain |= q->nr_rqs_elvpriv;
> +               drain |= q->request_fn_active;
>
>                 /*
>                  * Unfortunately, requests are queued at and tracked from
> @@ -494,8 +497,8 @@ EXPORT_SYMBOL_GPL(blk_queue_bypass_end);
>   * blk_cleanup_queue - shutdown a request queue
>   * @q: request queue to shutdown
>   *
> - * Mark @q DEAD, drain all pending requests, destroy and put it.  All
> - * future requests will be failed immediately with -ENODEV.
> + * Mark @q as dying, drain all pending requests, mark @q as dead, destroy and
> + * put it.  All future requests will be failed immediately with -ENODEV.
>   */
>  void blk_cleanup_queue(struct request_queue *q)
>  {
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 593fc71..03571a3 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1517,10 +1517,6 @@ static void scsi_request_fn(struct request_queue *q)
>         struct scsi_cmnd *cmd;
>         struct request *req;
>
> -       if(!get_device(&sdev->sdev_gendev))
> -               /* We must be tearing the block queue down already */
> -               return;
> -
>         /*
>          * To start with, we keep looping until the queue is empty, or until
>          * the host is no longer able to accept any more requests.
> @@ -1629,11 +1625,7 @@ out_delay:
>         if (sdev->device_busy == 0)
>                 blk_delay_queue(q, SCSI_QUEUE_DELAY);
>  out:
> -       /* must be careful here...if we trigger the ->remove() function
> -        * we cannot be holding the q lock */
> -       spin_unlock_irq(q->queue_lock);
> -       put_device(&sdev->sdev_gendev);
> -       spin_lock_irq(q->queue_lock);
> +       ;

Any reason to keep this "out:" label now that it has no effect?

--
Dan
