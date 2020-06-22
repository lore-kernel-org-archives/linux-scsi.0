Return-Path: <SRS0=lGnU=AD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.4 required=3.0 tests=DATE_IN_PAST_06_12,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 782A4C433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Jun 2020 14:27:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6358F2074D
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Jun 2020 14:27:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729489AbgFVO0q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Jun 2020 10:26:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:47010 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729414AbgFVO0l (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Jun 2020 10:26:41 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 789F9C1BC;
        Mon, 22 Jun 2020 14:26:38 +0000 (UTC)
Subject: Re: [PATCH RFC v7 00/12] blk-mq/scsi: Provide hostwide shared tags
 for SCSI HBAs
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Ming Lei <ming.lei@redhat.com>
Cc:     John Garry <john.garry@huawei.com>, axboe@kernel.dk,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        don.brace@microsemi.com, Sumit Saxena <sumit.saxena@broadcom.com>,
        bvanassche@acm.org, hare@suse.com, hch@lst.de,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        esc.storagedev@microsemi.com, chenxiang66@hisilicon.com,
        "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>
References: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
 <20200611030708.GB453671@T590>
 <c033f445-97fd-6dc9-c270-9890681b39d9@huawei.com>
 <bbdec3b3fbeb9907d2ec66a2afa56c29@mail.gmail.com>
 <20200615021355.GA4012@T590>
 <e49f164d867b53fd4495f1e05a85df03@mail.gmail.com>
 <20200616010055.GA27192@T590>
 <f9a05331a46a8c60c10e35df4aa08c45@mail.gmail.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <67d626a6-1b7c-fbc8-24b6-8d6b6df8a7b8@suse.de>
Date:   Mon, 22 Jun 2020 08:24:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <f9a05331a46a8c60c10e35df4aa08c45@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/17/20 1:26 PM, Kashyap Desai wrote:
>>
>> ->queued is increased only and not decreased just for debug purpose so
>> ->far, so
>> it can't be relied for this purpose.
> 
> Thanks. I overlooked that that it is only incremental counter.
> 
>>
>> One approach is to add one similar counter, and maintain it by
> scheduler's
>> insert/dispatch callback.
> 
> I tried below  and I see performance is on expected range.
> 
> diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
> index fdcc2c1..ea201d0 100644
> --- a/block/blk-mq-sched.c
> +++ b/block/blk-mq-sched.c
> @@ -485,6 +485,7 @@ void blk_mq_sched_insert_request(struct request *rq,
> bool at_head,
> 
>                  list_add(&rq->queuelist, &list);
>                  e->type->ops.insert_requests(hctx, &list, at_head);
> +               atomic_inc(&hctx->elevator_queued);
>          } else {
>                  spin_lock(&ctx->lock);
>                  __blk_mq_insert_request(hctx, rq, at_head);
> @@ -511,8 +512,10 @@ void blk_mq_sched_insert_requests(struct
> blk_mq_hw_ctx *hctx,
>          percpu_ref_get(&q->q_usage_counter);
> 
>          e = hctx->queue->elevator;
> -       if (e && e->type->ops.insert_requests)
> +       if (e && e->type->ops.insert_requests) {
>                  e->type->ops.insert_requests(hctx, list, false);
> +               atomic_inc(&hctx->elevator_queued);
> +       }
>          else {
>                  /*
>                   * try to issue requests directly if the hw queue isn't
> diff --git a/block/blk-mq-sched.h b/block/blk-mq-sched.h
> index 126021f..946b47a 100644
> --- a/block/blk-mq-sched.h
> +++ b/block/blk-mq-sched.h
> @@ -74,6 +74,13 @@ static inline bool blk_mq_sched_has_work(struct
> blk_mq_hw_ctx *hctx)
>   {
>          struct elevator_queue *e = hctx->queue->elevator;
> 
> +       /* If current hctx has not queued any request, there is no need to
> run.
> +        * blk_mq_run_hw_queue() on hctx which has queued IO will handle
> +        * running specific hctx.
> +        */
> +       if (!atomic_read(&hctx->elevator_queued))
> +               return false;
> +
>          if (e && e->type->ops.has_work)
>                  return e->type->ops.has_work(hctx);
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index f73a2f9..48f1824 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -517,8 +517,10 @@ void blk_mq_free_request(struct request *rq)
>          struct blk_mq_hw_ctx *hctx = rq->mq_hctx;
> 
>          if (rq->rq_flags & RQF_ELVPRIV) {
> -               if (e && e->type->ops.finish_request)
> +               if (e && e->type->ops.finish_request) {
>                          e->type->ops.finish_request(rq);
> +                       atomic_dec(&hctx->elevator_queued);
> +               }
>                  if (rq->elv.icq) {
>                          put_io_context(rq->elv.icq->ioc);
>                          rq->elv.icq = NULL;
> @@ -2571,6 +2573,7 @@ blk_mq_alloc_hctx(struct request_queue *q, struct
> blk_mq_tag_set *set,
>                  goto free_hctx;
> 
>          atomic_set(&hctx->nr_active, 0);
> +       atomic_set(&hctx->elevator_queued, 0);
>          if (node == NUMA_NO_NODE)
>                  node = set->numa_node;
>          hctx->numa_node = node;
> diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
> index 66711c7..ea1ddb1 100644
> --- a/include/linux/blk-mq.h
> +++ b/include/linux/blk-mq.h
> @@ -139,6 +139,10 @@ struct blk_mq_hw_ctx {
>           * shared across request queues.
>           */
>          atomic_t                nr_active;
> +       /**
> +        * @elevator_queued: Number of queued requests on hctx.
> +        */
> +       atomic_t                elevator_queued;
> 
>          /** @cpuhp_online: List to store request if CPU is going to die */
>          struct hlist_node       cpuhp_online;
> 
> 
> 
Would it make sense to move it into the elevator itself?
It's a bit odd having a value 'elevator_queued' with no direct reference 
to the elevator...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
