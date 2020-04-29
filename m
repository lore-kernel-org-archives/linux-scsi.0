Return-Path: <SRS0=qgw9=6N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE38BC83006
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Apr 2020 17:55:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D81D62064C
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Apr 2020 17:55:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726524AbgD2Rzu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Apr 2020 13:55:50 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2130 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726423AbgD2Rzt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Apr 2020 13:55:49 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id D306785060E0BB1A752A;
        Wed, 29 Apr 2020 18:55:45 +0100 (IST)
Received: from [127.0.0.1] (10.47.5.201) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Wed, 29 Apr
 2020 18:55:44 +0100
Subject: Re: [PATCH RFC v6 08/10] megaraid_sas: switch fusion adapters to MQ
To:     Kashyap Desai <kashyap.desai@broadcom.com>
CC:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "ming.lei@redhat.com" <ming.lei@redhat.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "hare@suse.de" <hare@suse.de>,
        "don.brace@microsemi.com" <don.brace@microsemi.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        "hch@infradead.org" <hch@infradead.org>,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>,
        "chenxiang (M)" <chenxiang66@hisilicon.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "esc.storagedev@microsemi.com" <esc.storagedev@microsemi.com>,
        Hannes Reinecke <hare@suse.com>
References: <1583409280-158604-1-git-send-email-john.garry@huawei.com>
 <1583409280-158604-9-git-send-email-john.garry@huawei.com>
 <a1f0399e2e85b2244a9ae40e4a2f1089@mail.gmail.com>
 <f839f040-8bf4-cf83-7670-dfc208b77326@huawei.com>
 <7cac3eb9fd79b5b988e25da542305b35@mail.gmail.com>
 <40faaef8-8bfc-639f-747f-cacd4e61464f@huawei.com>
 <7b8c79b0453722023c6c7d53cd24441d@mail.gmail.com>
 <b759a8ed-09ba-bfe8-8916-c05ab9671cbf@huawei.com>
 <260c5decdb38db9f74994988ce7fcaf1@mail.gmail.com>
 <380d3bf2-67ee-a09a-3098-51b24b98f912@huawei.com>
 <e0c5a076-9fe5-4401-fd41-97f457888ad3@huawei.com>
 <d2ae343770a83466b870a33ffae5fa23@mail.gmail.com>
 <8e16d68b-4d71-58f1-ede9-92ffe5d65ba9@huawei.com>
 <f712fd935562dcff73f0f6cf15f9cce7@mail.gmail.com>
 <538dd70d-7edb-c66c-4205-d91f24a907ea@huawei.com>
 <ca799ed3-0b18-2aa5-7d75-6eac5b0e6e7b@huawei.com>
 <29f8062c1fccace73c45252073232917@mail.gmail.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <6bfc5fea-d1ce-7220-0023-af3b34e1fa38@huawei.com>
Date:   Wed, 29 Apr 2020 18:55:03 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <29f8062c1fccace73c45252073232917@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.5.201]
X-ClientProxiedBy: lhreml722-chm.china.huawei.com (10.201.108.73) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Kashyap,

> 
> I have to add additional changes on top of your below patch -
> active_queues also should be managed differently for shared tag map case. I
> added extra flags in queue_flags interface which is per request.

ok, so it's not proper to use active hctx per request queue as "users", 
but rather that the active request_queue's per host (which is what we 
effectively have for nr_hw_queues = 1). Just a small comment at the 
bottom on your change.

So I already experimented with reducing shost.can_queue significantly on 
hisi_sas (by a factor of 8, from 4096->512, and I use 12x SAS SSD), and saw:

RFC + shost.can_queue reduced: ~1.2M IOPS
With RFC + shost.can_queue unmodified: ~2M IOPS
Without RFC + shost.can_queue unmodified: ~2M IOPS

And with the change, below, I still get around 1.2M IOPS. But there may 
be some sweet spot/zone where this makes a difference, which I'm not 
visiting.

> 
> Combination of your patch and below resolves fairness issues. I see some
> better results using " --cpus_allowed_policy=split", but
> --cpus_allowed_policy=shared 

I did not try changing the cpus_allowed_policy policy, and so I would be 
using default, which I believe is shared.

is still having some issue and most likely it
> is to do with fairness. If fairness is not managed properly, there is high
> contention in wait/wakeup handling of sbitmap.

ok, I can investigate.

> 
> 
> =====Additional patch ===
> 
> diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
> index 3719e1a..95bcb47 100644
> --- a/block/blk-mq-tag.c
> +++ b/block/blk-mq-tag.c
> @@ -23,10 +23,20 @@
>    */
>   bool __blk_mq_tag_busy(struct blk_mq_hw_ctx *hctx)
>   {
> -       if (!test_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state) &&
> -           !test_and_set_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state))
> -               atomic_inc(&hctx->tags->active_queues);
> +       struct blk_mq_tags *tags = hctx->tags;
> +       struct request_queue *q = hctx->queue;
> +       struct sbitmap_queue *bt;
> 
> +       if (blk_mq_is_sbitmap_shared(q->tag_set)){
> +               bt = tags->bitmap_tags;
> +               if (!test_bit(QUEUE_FLAG_HCTX_ACTIVE, &q->queue_flags) &&
> +                       !test_and_set_bit(QUEUE_FLAG_HCTX_ACTIVE,
> &q->queue_flags))
> +                       atomic_inc(&bt->active_queues_per_host);
> +       } else {
> +               if (!test_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state) &&
> +                   !test_and_set_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state))
> +                       atomic_inc(&hctx->tags->active_queues);
> +       }
>          return true;
>   }
> 
> @@ -47,12 +57,20 @@ void blk_mq_tag_wakeup_all(struct blk_mq_tags *tags,
> bool include_reserve)
>   void __blk_mq_tag_idle(struct blk_mq_hw_ctx *hctx)
>   {
>          struct blk_mq_tags *tags = hctx->tags;
> +       struct sbitmap_queue *bt;
> +       struct request_queue *q = hctx->queue;
> 
> -       if (!test_and_clear_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state))
> -               return;
> -
> -       atomic_dec(&tags->active_queues);
> +       if (blk_mq_is_sbitmap_shared(q->tag_set)){
> +               bt = tags->bitmap_tags;
> +               if (!test_and_clear_bit(QUEUE_FLAG_HCTX_ACTIVE,
> &q->queue_flags))
> +                       return;
> +               atomic_dec(&bt->active_queues_per_host);
> +       } else {
> +               if (!test_and_clear_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state))
> +                       return;
> 
> +               atomic_dec(&tags->active_queues);
> +       }
>          blk_mq_tag_wakeup_all(tags, false);
>   }
> 
> @@ -65,12 +83,13 @@ static inline bool hctx_may_queue(struct
> blk_mq_alloc_data *data,
>   {
>          struct blk_mq_hw_ctx *hctx = data->hctx;
>          struct request_queue *q = data->q;
> +       struct blk_mq_tags *tags = hctx->tags;
>          unsigned int depth, users;
> 
>          if (!hctx || !(hctx->flags & BLK_MQ_F_TAG_QUEUE_SHARED))
>                  return true;
> -       if (!test_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state))
> -               return true;
> +       //if (!test_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state))
> +       //      return true;
> 
>          /*
>           * Don't try dividing an ant
> @@ -78,7 +97,11 @@ static inline bool hctx_may_queue(struct
> blk_mq_alloc_data *data,
>          if (bt->sb.depth == 1)
>                  return true;
> 
> -       users = atomic_read(&hctx->tags->active_queues);
> +       if (blk_mq_is_sbitmap_shared(q->tag_set)) {
> +               bt = tags->bitmap_tags;
> +               users = atomic_read(&bt->active_queues_per_host);
> +       } else
> +               users = atomic_read(&hctx->tags->active_queues);
>          if (!users)
>                  return true;
> 
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 2bc9998..7049800 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -613,6 +613,7 @@ struct request_queue {
>   #define QUEUE_FLAG_PCI_P2PDMA  25      /* device supports PCI p2p requests
> */
>   #define QUEUE_FLAG_ZONE_RESETALL 26    /* supports Zone Reset All */
>   #define QUEUE_FLAG_RQ_ALLOC_TIME 27    /* record rq->alloc_time_ns */
> +#define QUEUE_FLAG_HCTX_ACTIVE 28      /* atleast one hctx is active*/
> 
>   #define QUEUE_FLAG_MQ_DEFAULT  ((1 << QUEUE_FLAG_IO_STAT) |            \
>                                   (1 << QUEUE_FLAG_SAME_COMP))
> diff --git a/include/linux/sbitmap.h b/include/linux/sbitmap.h
> index e40d019..fb44925 100644
> --- a/include/linux/sbitmap.h
> +++ b/include/linux/sbitmap.h
> @@ -139,6 +139,8 @@ struct sbitmap_queue {
>           * sbitmap_queue_get_shallow() or __sbitmap_queue_get_shallow().
>           */
>          unsigned int min_shallow_depth;
> +
> +       atomic_t active_queues_per_host;

It's prob better to put this in blk_mq_tag_set structure.

>   };


Thanks very much,
John

