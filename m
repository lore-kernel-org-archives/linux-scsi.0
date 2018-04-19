From: Paolo Valente <paolo.valente@linaro.org>
Subject: Re: usercopy whitelist woe in scsi_sense_cache
Date: Thu, 19 Apr 2018 11:32:34 +0200
Message-ID: <13DBFC76-4849-4DDA-AC44-B2C1257912E7@linaro.org>
References: <10360653.ov98egbaqx@natalenko.name>
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
 <0fbf2b13-8bae-c7c5-d930-ebaafdc72202@kernel.dk>
 <011EF7D1-B095-4B8D-AD2A-993048932C49@linaro.org>
 <c30400f9-50e6-b5cf-d06b-a5e971e98546@kernel.dk>
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c30400f9-50e6-b5cf-d06b-a5e971e98546@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Kees Cook <keescook@chromium.org>, Oleksandr Natalenko <oleksandr@natalenko.name>, Bart Van Assche <bart.vanassche@wdc.com>, David Windsor <dave@nullcore.net>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-block <linux-block@vger.kernel.org>, Ulf Hansson <ulf.hansson@linaro.org>, Mark Brown <broonie@kernel.org>, Linus Walleij <linus.walleij@linaro.org>
List-Id: linux-scsi@vger.kernel.org



> Il giorno 18 apr 2018, alle ore 16:30, Jens Axboe <axboe@kernel.dk> ha =
scritto:
>=20
> On 4/18/18 3:08 AM, Paolo Valente wrote:
>>=20
>>=20
>>> Il giorno 18 apr 2018, alle ore 00:57, Jens Axboe <axboe@kernel.dk> =
ha scritto:
>>>=20
>>> On 4/17/18 3:48 PM, Jens Axboe wrote:
>>>> On 4/17/18 3:47 PM, Kees Cook wrote:
>>>>> On Tue, Apr 17, 2018 at 2:39 PM, Jens Axboe <axboe@kernel.dk> =
wrote:
>>>>>> On 4/17/18 3:25 PM, Kees Cook wrote:
>>>>>>> On Tue, Apr 17, 2018 at 1:46 PM, Kees Cook =
<keescook@chromium.org> wrote:
>>>>>>>> I see elv.priv[1] assignments made in a few places -- is it =
possible
>>>>>>>> there is some kind of uninitialized-but-not-NULL state that can =
leak
>>>>>>>> in there?
>>>>>>>=20
>>>>>>> Got it. This fixes it for me:
>>>>>>>=20
>>>>>>> diff --git a/block/blk-mq.c b/block/blk-mq.c
>>>>>>> index 0dc9e341c2a7..859df3160303 100644
>>>>>>> --- a/block/blk-mq.c
>>>>>>> +++ b/block/blk-mq.c
>>>>>>> @@ -363,7 +363,7 @@ static struct request =
*blk_mq_get_request(struct
>>>>>>> request_queue *q,
>>>>>>>=20
>>>>>>>       rq =3D blk_mq_rq_ctx_init(data, tag, op);
>>>>>>>       if (!op_is_flush(op)) {
>>>>>>> -               rq->elv.icq =3D NULL;
>>>>>>> +               memset(&rq->elv, 0, sizeof(rq->elv));
>>>>>>>               if (e && e->type->ops.mq.prepare_request) {
>>>>>>>                       if (e->type->icq_cache && rq_ioc(bio))
>>>>>>>                               blk_mq_sched_assign_ioc(rq, bio);
>>>>>>> @@ -461,7 +461,7 @@ void blk_mq_free_request(struct request *rq)
>>>>>>>                       e->type->ops.mq.finish_request(rq);
>>>>>>>               if (rq->elv.icq) {
>>>>>>>                       put_io_context(rq->elv.icq->ioc);
>>>>>>> -                       rq->elv.icq =3D NULL;
>>>>>>> +                       memset(&rq->elv, 0, sizeof(rq->elv));
>>>>>>>               }
>>>>>>>       }
>>>>>>=20
>>>>>> This looks like a BFQ problem, this should not be necessary. =
Paolo,
>>>>>> you're calling your own prepare request handler from the insert
>>>>>> as well, and your prepare request does nothing if rq->elv.icq =3D=3D=
 NULL.
>>>>>=20
>>>>> I sent the patch anyway, since it's kind of a robustness =
improvement,
>>>>> I'd hope. If you fix BFQ also, please add:
>>>>=20
>>>> It's also a memset() in the hot path, would prefer to avoid that...
>>>> The issue here is really the convoluted bfq usage of =
insert/prepare,
>>>> I'm sure Paolo can take it from here.
>>>=20
>>=20
>> Hi,
>> I'm very sorry for tuning in very late, but, at the same time, very
>> glad to find the problem probably already solved ;) (in this respect, =
I swear,
>> my delay was not intentional)
>>=20
>>> Does this fix it?
>>>=20
>>> diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
>>> index f0ecd98509d8..d883469a1582 100644
>>> --- a/block/bfq-iosched.c
>>> +++ b/block/bfq-iosched.c
>>> @@ -4934,8 +4934,11 @@ static void bfq_prepare_request(struct =
request *rq, struct bio *bio)
>>> 	bool new_queue =3D false;
>>> 	bool bfqq_already_existing =3D false, split =3D false;
>>>=20
>>> -	if (!rq->elv.icq)
>>> +	if (!rq->elv.icq) {
>>> +		rq->elv.priv[0] =3D rq->elv.priv[1] =3D NULL;
>>> 		return;
>>> +	}
>>> +
>>=20
>> This does solve the problem at hand.  But it also arouses a question,
>> related to a possible subtle bug.
>>=20
>> For BFQ, !rq->elv.icq basically means "this request is not for me, as
>> I am an icq-based scheduler".  But, IIUC the main points in this
>> thread, then this assumption is false.  If it is actually false, then
>> I hope that all requests with !rq->elv.icq that are sent to BFQ do
>> verify the condition (at_head || blk_rq_is_passthrough(rq)).  In =
fact,
>> requests that do not verify that condition are those that BFQ must =
put
>> in a bfq_queue.  So, even if this patch makes the crash disappear, we
>> drive BFQ completely crazy (and we may expect other strange failures)
>> if we send BFQ a request with !((at_head || =
blk_rq_is_passthrough(rq))
>> and !rq->elv.icq.  BFQ has to put that rq into a bfq_queue, but =
simply
>> cannot.
>>=20
>> Jens, or any other, could you please shed a light on this, and =
explain
>> how things are exactly?
>=20

First, thanks for summing up the problem.

> Your assumption is correct, however you set ->priv[0] and ->priv[1] =
for
> requests, but only for ->elv.icq !=3D NULL. So let's assume you get a
> request and assign those two, request completes. Later on, you get
> the same request, bypass insert it. BFQ doesn't clear the bic/bfqq
> pointers in the request, since ->elv.icq =3D=3D NULL.

I'm missing something here.  When the request gets completed in the
first place, the hook bfq_finish_requeue_request gets called, and that
hook clears both ->elv.priv elements (as the request has a non-null
elv.icq).  So, when bfq gets the same request again, those elements
must be NULL.  What am I getting wrong?

I have some more concern on this point, but I'll stick to this for the
moment, to not create more confusion.

Thanks,
Paolo

> It gets inserted
> into the dispatch list.
>=20
> Then when __bfq_dispatch_request() is called, you do:
>=20
> bfqq =3D RQ_BFQQ(rq);
> if (bfqq)
> 	bfqq->dispatched++;
> [...]
>=20
> which is wrong, since you don't know if you assigned a bfqq for this
> request. The memory that bfqq points to could be long gone, if that
> queue is freed. So you could either guard any bfqq/bic retrieval
> with ->elv.icq !=3D NULL, or you could just clear the pointers for
> the case where the values aren't valid.
>=20
> --=20
> Jens Axboe
