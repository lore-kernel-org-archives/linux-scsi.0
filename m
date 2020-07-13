Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5686C433E3
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 09:43:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BD0D2075B
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 09:43:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729291AbgGMJns (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 05:43:48 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2454 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726523AbgGMJns (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Jul 2020 05:43:48 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id AFEAACD331EB8885E103;
        Mon, 13 Jul 2020 10:43:45 +0100 (IST)
Received: from [127.0.0.1] (10.47.2.10) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Mon, 13 Jul
 2020 10:43:44 +0100
Subject: Re: [PATCH RFC v7 07/12] blk-mq: Add support in
 hctx_tags_bitmap_show() for a shared sbitmap
To:     Hannes Reinecke <hare@suse.de>, <axboe@kernel.dk>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <don.brace@microsemi.com>, <kashyap.desai@broadcom.com>,
        <sumit.saxena@broadcom.com>, <ming.lei@redhat.com>,
        <bvanassche@acm.org>, <hare@suse.com>, <hch@lst.de>,
        <shivasharan.srikanteshwara@broadcom.com>
CC:     <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <esc.storagedev@microsemi.com>, <chenxiang66@hisilicon.com>,
        <megaraidlinux.pdl@broadcom.com>
References: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
 <1591810159-240929-8-git-send-email-john.garry@huawei.com>
 <9f4741c5-d117-d764-cf3a-a57192a788c3@suse.de>
 <aad6efa3-2d7f-ca68-d239-44ea187c8017@huawei.com>
 <7ed6ccf1-6ad9-1df7-f55d-4ed6cac1e08d@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <2de767d0-d472-9101-f805-68194687279a@huawei.com>
Date:   Mon, 13 Jul 2020 10:41:58 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <7ed6ccf1-6ad9-1df7-f55d-4ed6cac1e08d@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.47.2.10]
X-ClientProxiedBy: lhreml739-chm.china.huawei.com (10.201.108.189) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/06/2020 07:06, Hannes Reinecke wrote:
>>>>
>>>> +out:
>>>> +    sbitmap_free(&shared_sb);
>>>> +    return res;
>>>> +}
>>>> +
>>>>   static int hctx_tags_bitmap_show(void *data, struct seq_file *m)
>>>>   {
>>>>       struct blk_mq_hw_ctx *hctx = data;
>>>> @@ -823,6 +884,7 @@ static const struct blk_mq_debugfs_attr 
>>>> blk_mq_debugfs_hctx_shared_sbitmap_attrs
>>>>       {"busy", 0400, hctx_busy_show},
>>>>       {"ctx_map", 0400, hctx_ctx_map_show},
>>>>       {"tags", 0400, hctx_tags_show},
>>>> +    {"tags_bitmap", 0400, hctx_tags_shared_sbitmap_bitmap_show},
>>>>       {"sched_tags", 0400, hctx_sched_tags_show},
>>>>       {"sched_tags_bitmap", 0400, hctx_sched_tags_bitmap_show},
>>>>       {"io_poll", 0600, hctx_io_poll_show, hctx_io_poll_write},
>>>>
>>> Ah, right. Here it is.
>>>
>>> But I don't get it; why do we have to allocate a temporary bitmap and 
>>> can't walk the existing shared sbitmap?
>>

Just coming back to this now...

>> For the bitmap dump - sbitmap_bitmap_show() - it is passed a struct 
>> sbitmap *. So we have to filter into a temp per-hctx struct sbitmap. 
>> We could change sbitmap_bitmap_show() to accept a filter iterator - 
>> which I think you're getting at - but I am not sure it's worth the 
>> change. Or else use the allocated sbitmap for the hctx, as above*, but 
>> I may be remove that (see 4/12 response).
>>
> Yes, I do think I would prefer updating sbitmap_bitmap_show() to accept 
> a filter. Especially as Ming Lei has now updated the tag iterators to 
> accept a filter, too, so it should be an easy change.

Can you please explain how you would use an iterator here?

In fact, I am half thinking of dropping this patch entirely.

So I feel that current behavior is a little strange, as some may expect 
/sys/kernel/debug/block/sdX/hctxY/tags_bitmap would only show tags for 
hctxY for sdX, while it is for hctxY for all queues. Same for 
/sys/kernel/debug/block/sdX/hctxY/tags

And then, for what we have in this patch:

static void hctx_filter_sb(struct sbitmap *sb, struct blk_mq_hw_ctx *hctx)
{
struct hctx_sb_data hctx_sb_data = { .sb = sb, .hctx = hctx };

blk_mq_queue_tag_busy_iter(hctx->queue, hctx_filter_fn, &hctx_sb_data);
}

This will give tags only for this queue. So not the same. So I feel it's 
better to change current behavior (so consistent) or change neither. And 
changing current behavior would also mean we need to change what we show 
in /sys/kernel/debug/block/sdX/hctxY/tags, and that looks troublesome also.

Opinion?

Thanks,
John
