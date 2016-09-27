From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH 5/9] block: Extend blk_freeze_queue_start() to the
 non-blk-mq path
Date: Tue, 27 Sep 2016 21:22:05 +0800
Message-ID: <CACVXFVO=GFp=ArC_FT+xPSmL84m01fX6bzReBQ8DeLQ4fUD5cQ@mail.gmail.com>
References: <7948dbb8-6333-dc62-2673-4da35b4dfdbc@sandisk.com> <7c8af8d2-2ac9-2767-5e5f-8de72eba3814@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:34105 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751939AbcI0NWG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Sep 2016 09:22:06 -0400
In-Reply-To: <7c8af8d2-2ac9-2767-5e5f-8de72eba3814@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Doug Ledford <dledford@redhat.com>, Keith Busch <keith.busch@intel.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>

On Tue, Sep 27, 2016 at 2:27 AM, Bart Van Assche
<bart.vanassche@sandisk.com> wrote:
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> ---
>  block/blk-core.c | 15 ++++++---------
>  1 file changed, 6 insertions(+), 9 deletions(-)
>
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 8cc8006..5ecc7ab 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -689,7 +689,10 @@ void blk_freeze_queue_start(struct request_queue *q)
>         freeze_depth = atomic_inc_return(&q->mq_freeze_depth);
>         if (freeze_depth == 1) {
>                 percpu_ref_kill(&q->q_usage_counter);
> -               blk_mq_run_hw_queues(q, false);
> +               if (q->mq_ops)
> +                       blk_mq_run_hw_queues(q, false);
> +               else if (q->request_fn)
> +                       blk_run_queue(q);

Just wondering if you have a non-blk-mq drivers which need this change,
cause we only hold .q_usage_counter for sync bio.

>         }
>  }
>
> @@ -700,17 +703,11 @@ void blk_freeze_queue_wait(struct request_queue *q)
>
>  /*
>   * Guarantee no request is in use, so we can change any data structure of
> - * the queue afterward.
> + * the queue afterward. Increases q->mq_freeze_depth and waits until
> + * q->q_usage_counter drops to zero.
>   */
>  void blk_freeze_queue(struct request_queue *q)
>  {
> -       /*
> -        * In the !blk_mq case we are only calling this to kill the
> -        * q_usage_counter, otherwise this increases the freeze depth
> -        * and waits for it to return to zero.  For this reason there is
> -        * no blk_unfreeze_queue(), and blk_freeze_queue() is not
> -        * exported to drivers as the only user for unfreeze is blk_mq.
> -        */
>         blk_freeze_queue_start(q);
>         blk_freeze_queue_wait(q);
>  }
> --
> 2.10.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Ming Lei
