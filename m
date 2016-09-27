From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 5/9] block: Extend blk_freeze_queue_start() to the
 non-blk-mq path
Date: Tue, 27 Sep 2016 07:42:57 -0700
Message-ID: <a8e8796e-7266-4c8a-a4eb-31cedf73ec8a@sandisk.com>
References: <7948dbb8-6333-dc62-2673-4da35b4dfdbc@sandisk.com>
 <7c8af8d2-2ac9-2767-5e5f-8de72eba3814@sandisk.com>
 <CACVXFVO=GFp=ArC_FT+xPSmL84m01fX6bzReBQ8DeLQ4fUD5cQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACVXFVO=GFp=ArC_FT+xPSmL84m01fX6bzReBQ8DeLQ4fUD5cQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ming Lei <tom.leiming-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, James Bottomley <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 09/27/16 06:22, Ming Lei wrote:
> On Tue, Sep 27, 2016 at 2:27 AM, Bart Van Assche
> <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org> wrote:
>> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
>> ---
>>  block/blk-core.c | 15 ++++++---------
>>  1 file changed, 6 insertions(+), 9 deletions(-)
>>
>> diff --git a/block/blk-core.c b/block/blk-core.c
>> index 8cc8006..5ecc7ab 100644
>> --- a/block/blk-core.c
>> +++ b/block/blk-core.c
>> @@ -689,7 +689,10 @@ void blk_freeze_queue_start(struct request_queue *q)
>>         freeze_depth = atomic_inc_return(&q->mq_freeze_depth);
>>         if (freeze_depth == 1) {
>>                 percpu_ref_kill(&q->q_usage_counter);
>> -               blk_mq_run_hw_queues(q, false);
>> +               if (q->mq_ops)
>> +                       blk_mq_run_hw_queues(q, false);
>> +               else if (q->request_fn)
>> +                       blk_run_queue(q);
>
> Just wondering if you have a non-blk-mq drivers which need this change,
> cause we only hold .q_usage_counter for sync bio.

Hello Ming Lei,

Patch 8/9 calls blk_quiesce_queue() and blk_resume_queue() from a code 
path that is used in both blk-mq and non-blk-mq mode. Although it 
wouldn't be hard to modify that patch such that it only uses these two 
functions in blk-mq mode, that wouldn't be very elegant.

Jens, regarding non-blk-mq mode and q_usage_counter: do you prefer that 
I rework patch 8/9 such that blk_quiesce_queue() and blk_resume_queue() 
are only used in blk-mq mode or are you OK with adding a 
blk_queue_enter() call in get_request() and a blk_queue_exit() call to 
__blk_put_request()?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
