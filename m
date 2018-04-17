From: Jens Axboe <axboe@kernel.dk>
Subject: Re: usercopy whitelist woe in scsi_sense_cache
Date: Tue, 17 Apr 2018 16:57:08 -0600
Message-ID: <0fbf2b13-8bae-c7c5-d930-ebaafdc72202@kernel.dk>
References: <10360653.ov98egbaqx@natalenko.name>
 <2864697.7uzmEJovl2@natalenko.name>
 <CAGXu5jLSmJv9AstzsgSscrv-wA7FwfrxAKRxj-FVBmihQvnj1g@mail.gmail.com>
 <CAGXu5j+dh1zm32iBjRVh0s+3gLJYgjwt+z1aBJmrK2Cr8XPWnA@mail.gmail.com>
 <CAGXu5jLhnWnUiscP9B=kTEFNyRw9jgFn7Zr5FxhZrO20553+1Q@mail.gmail.com>
 <CAGXu5jKuZwicyyXH2gB3vp-OjtS+MkG+hqxV1cq1jaG9vAAO=g@mail.gmail.com>
 <CAGXu5jLQuzpjFcfjpT=MvgOxBizFNMjnfmY+E7eCHkDAV5swHg@mail.gmail.com>
 <CAGXu5jJTMqbXia7TmN2yEW11SM+XC3pkMt=bb+xBrY7-OOf=tw@mail.gmail.com>
 <CAGXu5j+xX3kDDS_sPY44hPVb=8isMX-evYzPx3ur=rge1rL5JQ@mail.gmail.com>
 <CAGXu5jJmvKcANUSsCz3fjGSv-tv1hceNd3rOpT4WTfYRb65RRA@mail.gmail.com>
 <8473f909-2123-0cfc-43b1-beba0b1aef9b@kernel.dk>
 <CAGXu5jL9miO3OXpjAxm9t8v=f_f5StB=Tk=aV8BVRdEj-Y-PDA@mail.gmail.com>
 <CAGXu5jKVPQi0cdTbe5Y1DNHdiJ6-kEFRBTNv7znuqT9w5eifGg@mail.gmail.com>
 <07f263ff-cea6-ac3c-944b-0f36fee8ba25@kernel.dk>
 <CAGXu5j+kHipvoyFWjGp8M6+83zbd6yHOzwxQ-2LNBQbD5-jS9w@mail.gmail.com>
 <8b32e079-d4e6-3fea-a89d-ff856e4e13b1@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8b32e079-d4e6-3fea-a89d-ff856e4e13b1@kernel.dk>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Paolo Valente <paolo.valente@linaro.org>, Oleksandr Natalenko <oleksandr@natalenko.name>, Bart Van Assche <bart.vanassche@wdc.com>, David Windsor <dave@nullcore.net>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 4/17/18 3:48 PM, Jens Axboe wrote:
> On 4/17/18 3:47 PM, Kees Cook wrote:
>> On Tue, Apr 17, 2018 at 2:39 PM, Jens Axboe <axboe@kernel.dk> wrote:
>>> On 4/17/18 3:25 PM, Kees Cook wrote:
>>>> On Tue, Apr 17, 2018 at 1:46 PM, Kees Cook <keescook@chromium.org> wrote:
>>>>> I see elv.priv[1] assignments made in a few places -- is it possible
>>>>> there is some kind of uninitialized-but-not-NULL state that can leak
>>>>> in there?
>>>>
>>>> Got it. This fixes it for me:
>>>>
>>>> diff --git a/block/blk-mq.c b/block/blk-mq.c
>>>> index 0dc9e341c2a7..859df3160303 100644
>>>> --- a/block/blk-mq.c
>>>> +++ b/block/blk-mq.c
>>>> @@ -363,7 +363,7 @@ static struct request *blk_mq_get_request(struct
>>>> request_queue *q,
>>>>
>>>>         rq = blk_mq_rq_ctx_init(data, tag, op);
>>>>         if (!op_is_flush(op)) {
>>>> -               rq->elv.icq = NULL;
>>>> +               memset(&rq->elv, 0, sizeof(rq->elv));
>>>>                 if (e && e->type->ops.mq.prepare_request) {
>>>>                         if (e->type->icq_cache && rq_ioc(bio))
>>>>                                 blk_mq_sched_assign_ioc(rq, bio);
>>>> @@ -461,7 +461,7 @@ void blk_mq_free_request(struct request *rq)
>>>>                         e->type->ops.mq.finish_request(rq);
>>>>                 if (rq->elv.icq) {
>>>>                         put_io_context(rq->elv.icq->ioc);
>>>> -                       rq->elv.icq = NULL;
>>>> +                       memset(&rq->elv, 0, sizeof(rq->elv));
>>>>                 }
>>>>         }
>>>
>>> This looks like a BFQ problem, this should not be necessary. Paolo,
>>> you're calling your own prepare request handler from the insert
>>> as well, and your prepare request does nothing if rq->elv.icq == NULL.
>>
>> I sent the patch anyway, since it's kind of a robustness improvement,
>> I'd hope. If you fix BFQ also, please add:
> 
> It's also a memset() in the hot path, would prefer to avoid that...
> The issue here is really the convoluted bfq usage of insert/prepare,
> I'm sure Paolo can take it from here.

Does this fix it?

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index f0ecd98509d8..d883469a1582 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -4934,8 +4934,11 @@ static void bfq_prepare_request(struct request *rq, struct bio *bio)
 	bool new_queue = false;
 	bool bfqq_already_existing = false, split = false;
 
-	if (!rq->elv.icq)
+	if (!rq->elv.icq) {
+		rq->elv.priv[0] = rq->elv.priv[1] = NULL;
 		return;
+	}
+
 	bic = icq_to_bic(rq->elv.icq);
 
 	spin_lock_irq(&bfqd->lock);

-- 
Jens Axboe
