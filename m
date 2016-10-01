From: Ming Lei <tom.leiming-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 4/7] blk-mq: Introduce blk_quiesce_queue() and blk_resume_queue()
Date: Sun, 2 Oct 2016 06:56:19 +0800
Message-ID: <CACVXFVMY19vuDjsECg2uX0_y_K7DUaaGqXPX9PYiBy5sfXmAEw@mail.gmail.com>
References: <f153ee47-e599-c333-92b0-d5da475012f3@sandisk.com>
 <a9eb4e95-6d77-e527-c42a-fd2e6f104bed@sandisk.com> <CACVXFVOO4P3RsnWci8XHdFoYBhNPq0KqjWJddsie-92+31bpEg@mail.gmail.com>
 <9fb67745-954c-a70f-a89a-d184c99ae9aa@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9fb67745-954c-a70f-a89a-d184c99ae9aa-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, James Bottomley <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Sep 30, 2016 at 11:55 PM, Bart Van Assche
<bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org> wrote:
> On 09/29/16 14:51, Ming Lei wrote:
>>
>> On Thu, Sep 29, 2016 at 7:59 AM, Bart Van Assche
>> <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org> wrote:
>>>
>>> blk_quiesce_queue() prevents that new queue_rq() invocations
>>
>>
>> blk_mq_quiesce_queue()
>
>
> Thanks, I will update the patch title and patch description.
>
>>> +void blk_mq_quiesce_queue(struct request_queue *q)
>>> +{
>>> +       struct blk_mq_hw_ctx *hctx;
>>> +       unsigned int i;
>>> +       bool res, rcu = false;
>>> +
>>> +       spin_lock_irq(q->queue_lock);
>>> +       WARN_ON_ONCE(blk_queue_quiescing(q));
>>> +       queue_flag_set(QUEUE_FLAG_QUIESCING, q);
>>> +       spin_unlock_irq(q->queue_lock);
>>> +
>>> +       res = __blk_mq_freeze_queue_start(q, false);
>>
>>
>> Looks the implementation is a bit tricky and complicated, if the percpu
>> usage counter isn't killed, it isn't necessary to touch .mq_freeze_depth
>> since you use QUEUE_FLAG_QUIESCING to set/get this status of
>> the queue.
>
>>
>> Then using synchronize_rcu() and rcu_read_lock()/rcu_read_unlock()
>> with the flag of QUIESCING may be enough to wait for completing
>> of ongoing invocations of .queue_rq() and avoid to run new .queue_rq,
>> right?
>
> That's an interesting thought. Can you have a look at the attached patch in
> which blk_mq_quiesce_queue() no longer manipulates the mq_freeze_depth
> counter?

About this part of manipulating 'mq_freeze_depth', your new patch looks
better and cleaner.

>
>>> +       WARN_ON_ONCE(!res);
>>> +       queue_for_each_hw_ctx(q, hctx, i) {
>>> +               if (hctx->flags & BLK_MQ_F_BLOCKING) {
>>> +                       mutex_lock(&hctx->queue_rq_mutex);
>>> +                       mutex_unlock(&hctx->queue_rq_mutex);
>>
>>
>> Could you explain a bit why all BLOCKING is treated so special? And
>> that flag just means the hw queue always need to schedule asynchronously,
>> and of course even though the flag isn't set, it still may be run
>> asynchronously too. So looks it should be enough to just use RCU.
>
>
> The mutex manipulations introduce atomic stores in the hot path. Hence the
> use of synchronize_rcu() and rcu_read_lock()/rcu_read_unlock() when
> possible. Since BLK_MQ_F_BLOCKING indicates that .queue_rq() may sleep and
> since sleeping is not allowed while holding the RCU read lock,
> queue_rq_mutex has been introduced for the BLK_MQ_F_BLOCKING case.

OK, got it.

But this part looks still not good enough:

> +static void __blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx)
> +{
> +       if (unlikely(test_bit(BLK_MQ_S_STOPPED, &hctx->state)))
> +               return;
> +
> +       if (hctx->flags & BLK_MQ_F_BLOCKING) {
> +               mutex_lock(&hctx->queue_rq_mutex);
> +               blk_mq_process_rq_list(hctx);
> +               mutex_unlock(&hctx->queue_rq_mutex);

With the new mutex, .queue_rq can't be run concurrently any more, even
though the hw queue can be mapped to more than one CPUs. So maybe
srcu for BLK_MQ_F_BLOCKING?

> +       } else {
> +               rcu_read_lock();
> +               blk_mq_process_rq_list(hctx);
> +               rcu_read_unlock();
>         }

...

> -               if (!blk_mq_direct_issue_request(old_rq, &cookie))
> -                       goto done;
> -               blk_mq_insert_request(old_rq, false, true, true);
> +
> +               if (data.hctx->flags & BLK_MQ_F_BLOCKING) {
> +                       mutex_lock(&data.hctx->queue_rq_mutex);
> +                       if (blk_queue_quiescing(q) ||
> +                           blk_mq_direct_issue_request(old_rq, &cookie) != 0)
> +                               blk_mq_insert_request(old_rq, false, true,
> +                                                     true);
> +                       mutex_unlock(&data.hctx->queue_rq_mutex);
> +               } else {
> +                       rcu_read_lock();
> +                       if (blk_queue_quiescing(q) ||
> +                           blk_mq_direct_issue_request(old_rq, &cookie) != 0)
> +                               blk_mq_insert_request(old_rq, false, true,
> +                                                     true);
> +                       rcu_read_unlock();
> +               }
> +

If we just call the rcu/srcu read lock(or the mutex) around .queue_rq(), the
above code needn't to be duplicated any more.

Thanks,
Ming Lei
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
