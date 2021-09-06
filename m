Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 323D8C433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Sep 2021 08:16:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1057460F43
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Sep 2021 08:16:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240455AbhIFIRT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Sep 2021 04:17:19 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:19008 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240260AbhIFIRS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Sep 2021 04:17:18 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4H31Mw2dwgzbmBZ;
        Mon,  6 Sep 2021 16:12:12 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2308.8; Mon, 6 Sep 2021 16:16:11 +0800
Received: from [127.0.0.1] (10.40.192.131) by dggemi759-chm.china.huawei.com
 (10.1.198.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.8; Mon, 6 Sep
 2021 16:16:11 +0800
Subject: Re: rq pointer in tags->rqs[] is not cleared in time and make SCSI
 error handle can not be triggered
To:     Ming Lei <ming.lei@redhat.com>
CC:     <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <john.garry@huawei.com>
References: <fe5cf6c4-ce5e-4a0f-f4ab-5c10539492cb@huawei.com>
 <YSdCfSeEv9s9OUMX@T590> <ebda23e8-0fa2-e96c-ee09-e0b2e783c40e@huawei.com>
 <YS9Jt8wTScNBIPlj@T590>
From:   luojiaxing <luojiaxing@huawei.com>
Message-ID: <e63a05a7-d9dd-ccd3-2051-e5d8c989c640@huawei.com>
Date:   Mon, 6 Sep 2021 16:16:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <YS9Jt8wTScNBIPlj@T590>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.40.192.131]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 2021/9/1 17:36, Ming Lei wrote:
> On Tue, Aug 31, 2021 at 10:27:28AM +0800, luojiaxing wrote:
>> Hi, Ming
>>
>>
>> Sorry to reply so late, This issue occur in low probability,
>>
>> so it take some time to confirm.
>>
>>
>> On 2021/8/26 15:29, Ming Lei wrote:
>>> On Thu, Aug 26, 2021 at 11:00:34AM +0800, luojiaxing wrote:
>>>> Dear all:
>>>>
>>>>
>>>> I meet some problem when test hisi_sas driver(under SCSI) based on 5.14-rc4
>>>> kernel, it's found that error handle can not be triggered after
>>>>
>>>> abnormal IO occur in some test with a low probability. For example,
>>>> circularly run disk hardreset or disable all local phy of expander when
>>>> running fio.
>>>>
>>>>
>>>> We add some tracepoint and print to see what happen, and we got the
>>>> following information:
>>>>
>>>> (1).print rq and rq_state at bt_tags_iter() to confirm how many IOs is
>>>> running now.
>>>>
>>>> <4>[  897.431182] bt_tags_iter: rqs[2808]: 0xffff202007bd3000; rq_state: 1
>>>> <4>[  897.437514] bt_tags_iter: rqs[3185]: 0xffff0020c5261e00; rq_state: 1
>>>> <4>[  897.443841] bt_tags_iter: rqs[3612]: 0xffff00212f242a00; rq_state: 1
>>>> <4>[  897.450167] bt_tags_iter: rqs[2808]: 0xffff00211d208100; rq_state: 1
>>>> <4>[  897.456492] bt_tags_iter: rqs[2921]: 0xffff00211d208100; rq_state: 1
>>>> <4>[  897.462818] bt_tags_iter: rqs[1214]: 0xffff002151d21b00; rq_state: 1
>>>> <4>[  897.469143] bt_tags_iter: rqs[2648]: 0xffff0020c4bfa200; rq_state: 1
>>>>
>>>> The preceding information show that rq with tag[2808] is found in different
>>>> hctx by bt_tags_iter() and with different pointer saved in tags->rqs[].
>>>>
>>>> And tag[2808] own the same pointer value saved in rqs[] with tag[2921]. It's
>>>> wrong because our driver share tag between all hctx, so it's not possible
>>> What is your io scheduler? I guess it is deadline,
>>
>> yes
>>
>>
>>>    and can you observe
>>> such issue by switching to none?
>>
>> Yes, it happen when switched to none
>>
>>
>>> The tricky thing is that one request dumped may be re-allocated to other tag
>>> after returning from bt_tags_iter().
>>>
>>>> to allocate one tag to different rq.
>>>>
>>>>
>>>> (2).check tracepoints(temporarily add) in blk_mq_get_driver_tag() and
>>>> blk_mq_put_tag() to see where this tag is come from.
>>>>
>>>>       Line 1322969:            <...>-20189   [013] .... 893.427707:
>>>> blk_mq_get_driver_tag: rqs[2808]: 0xffff00211d208100
>>>>       Line 1322997:  irq/1161-hisi_s-7602    [012] d..1 893.427814:
>>>> blk_mq_put_tag_in_free_request: rqs[2808]: 0xffff00211d208100
>>>>       Line 1331257:            <...>-20189   [013] .... 893.462663:
>>>> blk_mq_get_driver_tag: rqs[2860]: 0xffff00211d208100
>>>>       Line 1331289:  irq/1161-hisi_s-7602    [012] d..1 893.462785:
>>>> blk_mq_put_tag_in_free_request: rqs[2860]: 0xffff00211d208100
>>>>       Line 1338493:            <...>-20189   [013] .... 893.493519:
>>>> blk_mq_get_driver_tag: rqs[2921]: 0xffff00211d208100
>>>>
>>>> As we can see this rq is allocated to tag[2808] once, and finially come to
>>>> tag[2921], but rqs[2808] still save the pointer.
>>> Yeah, we know this kind of handling, but not see it as issue.
>>>
>>>> There will be no problem until we encounter a rare situation.
>>>>
>>>> For example, tag[2808] is reassigned to another hctx for execution, then
>>>> some IO meet some error.
>>> I guess the race is triggered when 2808 is just assigned, meantime
>>> ->rqs[] isn't updated.
>>
>> As we shared tag between hctx, so if 2808 was assinged to other hctx.
>>
>> So previous hctx's rqs will not updated。
>>
>>
>>>> Before waking up the error handle thread, SCSI compares the values of
>>>> scsi_host_busy() and shost->host_failed.
>>>>
>>>> If the values are different, SCSI waits for the completion of some I/Os.
>>>> According to the print provided by (1), the return value of scsi_host_busy()
>>>> should be 7 for tag [2808] is calculated twice,
>>>>
>>>> and the value of shost->host_failed is 6. As a result, this two values are
>>>> never equal, and error handle cannot be triggered.
>>>>
>>>>
>>>> A temporary workaround is provided and can solve the problem as:
>>>>
>>>> diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
>>>> index 2a37731..e3dc773 100644
>>>> --- a/block/blk-mq-tag.c
>>>> +++ b/block/blk-mq-tag.c
>>>> @@ -190,6 +190,7 @@ void blk_mq_put_tag(struct blk_mq_tags *tags, struct
>>>> blk_mq_ctx *ctx,
>>>>                   BUG_ON(tag >= tags->nr_reserved_tags);
>>>>                   sbitmap_queue_clear(tags->breserved_tags, tag, ctx->cpu);
>>>>           }
>>>> +       tags->rqs[tag] = NULL;
>>>>    }
>>>>
>>>>
>>>> Since we did not encounter this problem in some previous kernel versions, we
>>>> wondered if the community already knew about the problem or could provide
>>>> some solutions.
>>> Can you try the following patch?
>>
>> I tested it. it can fix the bug.
>>
>>
>> However, if there is still a problem in the following scenario? For example,
>> driver tag 0 is assigned
>>
>> to rq0 in hctx0, and reclaimed after rq completed. Next time driver tag 0 is
>> still assigned to rq0 but
>>
>> in hctx1. So at this time,  bt_tags_iter will still got two rqs.
> Each hctx has its own rq pool so far, so no such issue you worried.
>
> John's patch works towards sharing rq pool among hctxs in case of
> shared sbitmap, not merged yet, but ->rqs[] should be shared too, still
> no such issue.
>
> Follows the revised patch for handling the stale request in ->rqs[] issue:


Following patch can fix the issue.

Tested-by: Luo Jiaxing <luojiaxing@huawei.com>


Thanks

Jiaxing


>
>
> diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
> index 86f87346232a..ff5caeb82542 100644
> --- a/block/blk-mq-tag.c
> +++ b/block/blk-mq-tag.c
> @@ -208,7 +208,7 @@ static struct request *blk_mq_find_and_get_req(struct blk_mq_tags *tags,
>   
>   	spin_lock_irqsave(&tags->lock, flags);
>   	rq = tags->rqs[bitnr];
> -	if (!rq || !refcount_inc_not_zero(&rq->ref))
> +	if (!rq || rq->tag != bitnr || !refcount_inc_not_zero(&rq->ref))
>   		rq = NULL;
>   	spin_unlock_irqrestore(&tags->lock, flags);
>   	return rq;
>
>
> Thanks,
> Ming
>
>
> .
>

