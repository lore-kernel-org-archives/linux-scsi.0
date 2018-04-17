From: Jens Axboe <axboe@kernel.dk>
Subject: Re: usercopy whitelist woe in scsi_sense_cache
Date: Tue, 17 Apr 2018 15:39:44 -0600
Message-ID: <07f263ff-cea6-ac3c-944b-0f36fee8ba25@kernel.dk>
References: <10360653.ov98egbaqx@natalenko.name>
 <CAGXu5j+-PNYxSc3v+QtQLK0S3wdtFthFSxNM_69kFDnPQX0Gaw@mail.gmail.com>
 <CAGXu5j+_UH0h9qeYCKKjhC7jw-mi_=fg4ASHi2=pCF9xGTpA4Q@mail.gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jKVPQi0cdTbe5Y1DNHdiJ6-kEFRBTNv7znuqT9w5eifGg@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>, Paolo Valente <paolo.valente@linaro.org>
Cc: Oleksandr Natalenko <oleksandr@natalenko.name>, Bart Van Assche <bart.vanassche@wdc.com>, David Windsor <dave@nullcore.net>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 4/17/18 3:25 PM, Kees Cook wrote:
> On Tue, Apr 17, 2018 at 1:46 PM, Kees Cook <keescook@chromium.org> wrote:
>> I see elv.priv[1] assignments made in a few places -- is it possible
>> there is some kind of uninitialized-but-not-NULL state that can leak
>> in there?
> 
> Got it. This fixes it for me:
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 0dc9e341c2a7..859df3160303 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -363,7 +363,7 @@ static struct request *blk_mq_get_request(struct
> request_queue *q,
> 
>         rq = blk_mq_rq_ctx_init(data, tag, op);
>         if (!op_is_flush(op)) {
> -               rq->elv.icq = NULL;
> +               memset(&rq->elv, 0, sizeof(rq->elv));
>                 if (e && e->type->ops.mq.prepare_request) {
>                         if (e->type->icq_cache && rq_ioc(bio))
>                                 blk_mq_sched_assign_ioc(rq, bio);
> @@ -461,7 +461,7 @@ void blk_mq_free_request(struct request *rq)
>                         e->type->ops.mq.finish_request(rq);
>                 if (rq->elv.icq) {
>                         put_io_context(rq->elv.icq->ioc);
> -                       rq->elv.icq = NULL;
> +                       memset(&rq->elv, 0, sizeof(rq->elv));
>                 }
>         }

This looks like a BFQ problem, this should not be necessary. Paolo,
you're calling your own prepare request handler from the insert
as well, and your prepare request does nothing if rq->elv.icq == NULL.

-- 
Jens Axboe
