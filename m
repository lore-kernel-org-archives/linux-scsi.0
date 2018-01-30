From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH V4] blk-mq: introduce BLK_STS_DEV_RESOURCE
Date: Tue, 30 Jan 2018 11:16:33 +0800
Message-ID: <CACVXFVNZVSfqAW23oM3Y0XLm_WRdQ1WWpLhXJ8LVPN=i2OBvig@mail.gmail.com>
References: <20180129203300.50595-1-snitzer@redhat.com> <1517260932.2687.42.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wr0-f174.google.com ([209.85.128.174]:40216 "EHLO
        mail-wr0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752186AbeA3DQf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jan 2018 22:16:35 -0500
In-Reply-To: <1517260932.2687.42.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "snitzer@redhat.com" <snitzer@redhat.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>

On Tue, Jan 30, 2018 at 5:22 AM, Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
> On Mon, 2018-01-29 at 15:33 -0500, Mike Snitzer wrote:
>> +              * If driver returns BLK_STS_RESOURCE and SCHED_RESTART
>> +              * bit is set, run queue after 10ms to avoid IO stalls
>> +              * that could otherwise occur if the queue is idle.
>>                */
>> -             if (!blk_mq_sched_needs_restart(hctx) ||
>> +             needs_restart = blk_mq_sched_needs_restart(hctx);
>> +             if (!needs_restart ||
>>                   (no_tag && list_empty_careful(&hctx->dispatch_wait.entry)))
>>                       blk_mq_run_hw_queue(hctx, true);
>> +             else if (needs_restart && (ret == BLK_STS_RESOURCE))
>> +                     blk_mq_delay_run_hw_queue(hctx, BLK_MQ_QUEUE_DELAY);
>>       }
>
> The above code only calls blk_mq_delay_run_hw_queue() if the following condition
> is met: !(!needs_restart || (no_tag && list_empty_careful(&hctx->dispatch_wait.entry)))
> && (needs_restart && (ret == BLK_STS_RESOURCE)). That boolean expression can be
> simplified into the following: needs_restart && ret == BLK_STS_RESOURCE &&
> !(no_tag && list_empty_careful(&hctx->dispatch_wait.entry)). From blk-mq-sched.h:

No, the expression of  (needs_restart && (ret == BLK_STS_RESOURCE)) clearly
expresses what we want to do.

When RESTART is working, and meantime BLK_STS_RESOURCE is returned
from driver, we need to avoid IO hang by blk_mq_delay_run_hw_queue().

>
> static inline bool blk_mq_sched_needs_restart(struct blk_mq_hw_ctx *hctx)
> {
>         return test_bit(BLK_MQ_S_SCHED_RESTART, &hctx->state);
> }
>
> In other words, the above code will not call blk_mq_delay_run_hw_queue() if
> BLK_MQ_S_SCHED_RESTART is cleared after it got set and before the above code is
> reached. The BLK_MQ_S_SCHED_RESTART bit gets cleared if a request completes
> concurrently with the above code. From blk-mq-sched.c:

That won't be an issue, given any time the SCHED_RESTART is cleared, the queue
will be run again, so we needn't to worry about that.

>
> static bool blk_mq_sched_restart_hctx(struct blk_mq_hw_ctx *hctx)
> {
>         if (!test_bit(BLK_MQ_S_SCHED_RESTART, &hctx->state))
>                 return false;
>
>         if (hctx->flags & BLK_MQ_F_TAG_SHARED) {
>                 struct request_queue *q = hctx->queue;
>
>                 if (test_and_clear_bit(BLK_MQ_S_SCHED_RESTART, &hctx->state))
>                         atomic_dec(&q->shared_hctx_restart);
>         } else
>                 clear_bit(BLK_MQ_S_SCHED_RESTART, &hctx->state);
>
>         return blk_mq_run_hw_queue(hctx, true);
> }
>
> The above blk_mq_run_hw_queue() call may finish either before or after

If the above blk_mq_run_hw_queue() finishes before blk_mq_dispatch_rq_list()
examines the flag, blk_mq_dispatch_rq_list() will see the flag cleared, and run
queue again by the following code branch:

                if (!blk_mq_sched_needs_restart(hctx) ||
                    (no_tag && list_empty_careful(&hctx->dispatch_wait.entry)))
                        blk_mq_run_hw_queue(hctx, true);

If blk_mq_run_hw_queue() finishes after blk_mq_dispatch_rq_list() examines
the flag, this blk_mq_run_hw_queue() will see the new added request, and
still everything is fine. Even blk_mq_delay_run_hw_queue() can be started
too.

> blk_mq_dispatch_rq_list() examines the BLK_MQ_S_SCHED_RESTART flag.
>
> That's why I wrote in previous e-mails that this patch and also the previous
> versions of this patch change a systematic call of blk_mq_delay_run_hw_queue()
> into a call that may or may not happen, depending on whether or not a request
> completes concurrently with request queueing. Sorry but I think that means
> that the above change combined with changing BLK_STS_RESOURCE into
> BLK_STS_DEV_RESOURCE is wrong and why I expect that this will result in
> sporadic queue stalls. As you know sporadic queue stalls are annoying and hard
> to debug.

Now there is debugfs, it isn't difficult to deal with that if
reporter'd like to cowork.

>
> Plenty of e-mails have already been exchanged about versions one to four of this
> patch but so far nobody has even tried to contradict the above.

No, I don't see the issue, let's revisit the main change again:

+       needs_restart = blk_mq_sched_needs_restart(hctx);
+       if (!needs_restart ||
            (no_tag && list_empty_careful(&hctx->dispatch_wait.entry)))
            blk_mq_run_hw_queue(hctx, true);
+       else if (needs_restart && (ret == BLK_STS_RESOURCE))
+           blk_mq_delay_run_hw_queue(hctx, 10);

If SCHED_RESTART isn't set, queue is run immediately, otherwise when
BLK_STS_RESOURCE is returned, we avoid IO hang by
blk_mq_delay_run_hw_queue(hctx, XXX).

And we don't cover  BLK_STS_DEV_RESOURCE above because it is documented
clearly that  BLK_STS_DEV_RESOURCE is only returned by driver iff queue will be
rerun in future if resource is available.

Is there  any hole in above code?

Thanks,
Ming Lei
