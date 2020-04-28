Return-Path: <SRS0=LQeo=6M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AEDDC83008
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 15:56:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA4FA20661
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 15:56:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728028AbgD1P4H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Apr 2020 11:56:07 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2122 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727865AbgD1P4G (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Apr 2020 11:56:06 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id 689E37CCE431A6F85A86;
        Tue, 28 Apr 2020 16:56:04 +0100 (IST)
Received: from [127.0.0.1] (10.47.4.245) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1913.5; Tue, 28 Apr
 2020 16:56:02 +0100
Subject: Re: [PATCH RFC v6 08/10] megaraid_sas: switch fusion adapters to MQ
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "ming.lei@redhat.com" <ming.lei@redhat.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "hare@suse.de" <hare@suse.de>,
        "don.brace@microsemi.com" <don.brace@microsemi.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        "hch@infradead.org" <hch@infradead.org>,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>
CC:     "chenxiang (M)" <chenxiang66@hisilicon.com>,
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
From:   John Garry <john.garry@huawei.com>
Message-ID: <538dd70d-7edb-c66c-4205-d91f24a907ea@huawei.com>
Date:   Tue, 28 Apr 2020 16:55:22 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <f712fd935562dcff73f0f6cf15f9cce7@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.4.245]
X-ClientProxiedBy: lhreml706-chm.china.huawei.com (10.201.108.55) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Kashyap,

> I am using <mq-deadline> which is MQ version of SQ deadline.
> For now we can just consider case without scheduler.
> 
> I have some more findings. May be someone from upstream community can
> connect the dots.
> 
> #1. hctx_may_queue() throttle the IO at hctx level. This is eventually per
> sdev throttling for megaraid_sas driver because It creates only one
> context - hctx0 for each scsi device.
> 
> If driver is using only one h/w queue,  active_queues will be always steady.
> In my test it was 64 thread, so active_queues=64.

So I figure that 64 threads comes from 64 having disks.

> Even though <fio> thread is shared among allowed cpumask
> (cpus_allowed_policy=shared option in fio),  active_queues will be always 64
> because we have only one h/w queue.
> All the logical cpus are mapped to one h/w queue. It means, thread moving
> from one cpu to another cpu will not change active_queues per hctx.
> 
> In case of this RFC, active_queues are now per hctx and there are multiple
> hctx, but tags are shared. 

Right, so we need a policy to divide up the shared tags across request 
queues, based on principle of fairness.

This can create unwanted throttling and
> eventually more lock contention in sbitmap.
> I added below patch and things improved a bit, but not a full proof.
> 
> diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
> index 586c9d6..c708fbc 100644
> --- a/block/blk-mq-tag.c
> +++ b/block/blk-mq-tag.c
> @@ -60,10 +60,12 @@ void __blk_mq_tag_idle(struct blk_mq_hw_ctx *hctx)
>    * For shared tag users, we track the number of currently active users
>    * and attempt to provide a fair share of the tag depth for each of them.
>    */
> -static inline bool hctx_may_queue(struct blk_mq_hw_ctx *hctx,
> +static inline bool hctx_may_queue(struct request_queue *q,
> +                                 struct blk_mq_hw_ctx *hctx,
>                                    struct sbitmap_queue *bt)
>   {
> -       unsigned int depth, users;
> +       unsigned int depth, users, i, outstanding = 0;
> +       struct blk_mq_hw_ctx *hctx_iter;
> 
>          if (!hctx || !(hctx->flags & BLK_MQ_F_TAG_SHARED))
>                  return true;
> @@ -84,14 +86,18 @@ static inline bool hctx_may_queue(struct blk_mq_hw_ctx
> *hctx,
>           * Allow at least some tags
>           */
>          depth = max((bt->sb.depth + users - 1) / users, 4U);
> -       return atomic_read(&hctx->nr_active) < depth;
> +
> +       queue_for_each_hw_ctx(q, hctx_iter, i)
> +               outstanding += atomic_read(&hctx_iter->nr_active);
> +

OK,  I think that we need to find a cleaner way to do this.

> +       return outstanding < depth;
>   }
> 
>   static int __blk_mq_get_tag(struct blk_mq_alloc_data *data,
>                              struct sbitmap_queue *bt)
>   {
>          if (!(data->flags & BLK_MQ_REQ_INTERNAL) &&
> -           !hctx_may_queue(data->hctx, bt))
> 
> 
> #2 - In completion path, scsi module call blk_mq_run_hw_queues() upon IO
> completion.  I am not sure if it is good to run all the h/w queue or just
> h/w queue of current reference is good enough.
> Below patch helped to reduce contention in hcxt_lock().
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 610ee41..f72de2a 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -572,6 +572,7 @@ static bool scsi_end_request(struct request *req,
> blk_status_t error,
>          struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
>          struct scsi_device *sdev = cmd->device;
>          struct request_queue *q = sdev->request_queue;
> +       struct blk_mq_hw_ctx *mq_hctx = req->mq_hctx;
> 
>          if (blk_update_request(req, error, bytes))
>                  return true;
> @@ -613,7 +614,7 @@ static bool scsi_end_request(struct request *req,
> blk_status_t error,
>              !list_empty(&sdev->host->starved_list))
>                  kblockd_schedule_work(&sdev->requeue_work);
>          else
> -               blk_mq_run_hw_queues(q, true);
> +               blk_mq_run_hw_queue(mq_hctx, true);

Not sure on this. But, indeed, I found running all queues did add lots 
of extra load for when enabling the deadline scheduler.

> 
>          percpu_ref_put(&q->q_usage_counter);
>          return false;
> 
> #3 -  __blk_mq_tag_idle() calls blk_mq_tag_wakeup_all which may not be
> optimal for shared queue.
> There is a penalty if we are calling __sbq_wake_up() frequently. In case of
> nr_hw_queue = 1, things are better because one hctx and hctx->state will
> avoid multiple calls.
> If blk_mq_tag_wakeup_all is called from hctx0 context, there is no need to
> call from hctx1, hctx2 etc.
> 
> I have added below patch in my testing.
> 
> diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
> index 586c9d6..5b331e5 100644
> --- a/block/blk-mq-tag.c
> +++ b/block/blk-mq-tag.c
> @@ -53,7 +53,9 @@ void __blk_mq_tag_idle(struct blk_mq_hw_ctx *hctx)
> 
>          atomic_dec(&tags->active_queues);
> 
> -       blk_mq_tag_wakeup_all(tags, false);
> +       /* TBD - Do this only for hctx->flags & BLK_MQ_F_TAG_HCTX_SHARED */
> +       if (hctx->queue_num == 0)
> +               blk_mq_tag_wakeup_all(tags, false);

ok, I see. But, again, I think we need to find a cleaner way to do this.

>   }
> 
>   /*
> 
> 
> With all above mentioned changes, I see performance improved from 2.2M IOPS
> to 2.7M on same workload and profile.

But still short of nr_hw_queue = 1, which got 3.1M IOPS, as below, right?

Thanks,
John

> 
>>
>>>
>>> Old Driver which has nr_hw_queue = 1 and I issue IOs from <fio>  queue
>>> depth = 128. We get 3.1M IOPS in this config. This eventually exhaust
>>> host can_queue.
>>
>> So I think I need to find a point where we start to get throttled.
>>
>>> Note - Very low contention in sbitmap_get()
>>>
>>> -   23.58%     0.25%  fio              [kernel.vmlinux]            [k]
>>> blk_mq_make_request
>>>      - 23.33% blk_mq_make_request
>>>         - 21.68% blk_mq_get_request
>>>            - 20.19% blk_mq_get_tag
>>>               + 10.08% prepare_to_wait_exclusive
>>>               + 4.51% io_schedule
>>>               - 3.59% __sbitmap_queue_get
>>>                  - 2.82% sbitmap_get
>>>                       0.86% __sbitmap_get_word
>>>                       0.75% _raw_spin_lock_irqsave
>>>                       0.55% _raw_spin_unlock_irqrestore
>>>
>>> Driver with RFC which has nr_hw_queue = N and I issue IOs from <fio>
>>> queue depth = 128. We get 2.3 M IOPS in this config. This eventually
>>> exhaust host can_queue.
>>> Note - Very high contention in sbitmap_get()
>>>
>>> -   42.39%     0.12%  fio              [kernel.vmlinux]            [k]
>>> generic_make_request
>>>      - 42.27% generic_make_request
>>>         - 41.00% blk_mq_make_request
>>>            - 38.28% blk_mq_get_request
>>>               - 33.76% blk_mq_get_tag
>>>                  - 30.25% __sbitmap_queue_get
>>>                     - 29.90% sbitmap_get
>>>                        + 9.06% _raw_spin_lock_irqsave
>>>                        + 7.94% _raw_spin_unlock_irqrestore
>>>                        + 3.86% __sbitmap_get_word
>>>                        + 1.78% call_function_single_interrupt
>>>                        + 0.67% ret_from_intr
>>>                  + 1.69% io_schedule
>>>                    0.59% prepare_to_wait_exclusive
>>>                    0.55% __blk_mq_get_tag
>>>
>>> In this particular case, I observed alloc_hint = zeros which means,
>>> sbitmap_get is not able to find free tags from hint. That may lead to
>>> contention.
>>> This condition is not happening with nr_hw_queue=1 (without RFC) driver.
>>>
>>> alloc_hint=
>>> {663, 2425, 3060, 54, 3149, 4319, 4175, 4867, 543, 2481, 0, 4779, 377,
>>> ***0***, 2010, 0, 909, 3350, 1546, 2179, 2875, 659, 3902, 2224, 3212,
>>> 836, 1892, 1669, 2420, 3415, 1904, 512, 3027, 4810, 2845, 4690, 712,
>>> 3105, 0, 0, 0, 3268, 4915, 3897, 1349, 547, 4, 733, 1765, 2068, 979,
>>> 51, 880, 0, 370, 3520, 2877, 4097, 418, 4501, 3717, 2893, 604, 508,
>>> 759, 3329, 4038, 4829, 715, 842, 1443, 556}
>>>
>>> Driver with RFC which has nr_hw_queue = N and I issue IOs from <fio>
>>> queue depth = 32. We get 3.1M IOPS in this config. This workload does
>>> *not* exhaust host can_queue.
>>
>> Please ensure .host_tagset is set for whenever nr_hw_queue = N. This is as
>> per
>> RFC, and I don't think you modified from the RFC for your test.
>> But I just wanted to mention that to be crystal clear.
> 
> Yes I have two separate driver copy. One with RFC change and another without
> RFC.
>>
>>>
>>> -    5.07%     0.14%  fio              [kernel.vmlinux]  [k]
>>> generic_make_request
>>>      - 4.93% generic_make_request
>>>         - 3.61% blk_mq_make_request
>>>            - 2.04% blk_mq_get_request
>>>               - 1.08% blk_mq_get_tag
>>>                  - 0.70% __sbitmap_queue_get
>>>                       0.67% sbitmap_get
>>>
>>> In summary, RFC has some performance bottleneck in sbitmap_get () if
>>> outstanding per shost is about to exhaust.  Without this RFC also
>>> driver works in nr_hw_queue = 1, but that case is managed very well.
>>> I am not sure why it happens only with shared host tag ? Theoretically
>>> all the hctx is sharing the same bitmaptag which is same as
>>> nr_hw_queue=1, so why contention is only visible in shared host tag
>>> case.
>>
>> Let me check this.
>>
>>>
>>> If you want to reproduce this issue, may be you have to reduce the
>>> can_queue in hisi_sas driver.
>>>
>>
>> Thanks,
>> John

