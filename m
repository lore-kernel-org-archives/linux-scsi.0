From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: linux-next: Tree for Aug 1
Date: Fri, 3 Aug 2018 00:50:53 +0800
Message-ID: <CACVXFVNi_R3Xecwm7weqEv5Lqy+F-Nxmbq4-i3089Ge2qHFD_g@mail.gmail.com>
References: <20180801175852.36549130@canb.auug.org.au> <20180801224813.GA13074@roeck-us.net>
 <1533163965.3158.1.camel@HansenPartnership.com> <20180801234727.GA3762@roeck-us.net>
 <CACVXFVMrzLRP5Q=cwZGnqeUeyODL3Pq9jMkT7czZouK9510fUA@mail.gmail.com>
 <1533168205.3158.12.camel@HansenPartnership.com> <171b2cdc-2e74-2b3c-e5f5-c656a196601a@roeck-us.net>
 <CACVXFVMT7UwWHPQ6K-eNWZJOoZ77==Ki7zmX5UtDz4ZQFFB0Jw@mail.gmail.com>
 <a10a509a-7e5c-1706-52ee-79849cad4224@roeck-us.net> <20180802162654.GA8928@ming.t460p>
 <9329f50c734eec5fa994ea652890f017a88625c2.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <9329f50c734eec5fa994ea652890f017a88625c2.camel@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux@roeck-us.net" <linux@roeck-us.net>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, "josef@toxicpanda.com" <josef@toxicpanda.com>, "tj@kernel.org" <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Aug 3, 2018 at 12:40 AM, Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
> On Fri, 2018-08-03 at 00:27 +0800, Ming Lei wrote:
>> This issue can be fixed by reverting d250bf4e776ff09d5 ("blk-mq: only iterate over
>> inflight requests in blk_mq_tagset_busy_iter").
>>
>> This patch looks wrong, because 'blk_mq_rq_state(rq) == MQ_RQ_IN_FLIGHT'
>> isn't completely same with 'blk_mq_request_started(req)'.
>
> Please test the following change instead of reverting the commit mentioned
> above:
>
> diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
> index 09b2ee6694fb..25a0583d8b4c 100644
> --- a/block/blk-mq-tag.c
> +++ b/block/blk-mq-tag.c
> @@ -271,7 +271,7 @@ static bool bt_tags_iter(struct sbitmap *bitmap, unsigned int bitnr, void *data)
>          * test and set the bit before assining ->rqs[].
>          */
>         rq = tags->rqs[bitnr];
> -       if (rq && blk_mq_rq_state(rq) == MQ_RQ_IN_FLIGHT)
> +       if (rq && blk_mq_rq_state(rq) != MQ_RQ_IDLE)
>                 iter_data->fn(rq, iter_data->data, reserved);
>
>         return true;
>

I just sent out a similar patch on list, but use blk_mq_request_started()
instead.

https://marc.info/?l=linux-scsi&m=153322823307754&w=2

Thanks,
Ming Lei
