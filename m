Return-Path: <SRS0=r6FR=ZK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A034C432C0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 10:31:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B6B920855
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 10:31:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbfKRKbn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Nov 2019 05:31:43 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2107 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726536AbfKRKbn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 18 Nov 2019 05:31:43 -0500
Received: from lhreml709-cah.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id BE6B832AB0F642FAD420;
        Mon, 18 Nov 2019 10:31:41 +0000 (GMT)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 lhreml709-cah.china.huawei.com (10.201.108.32) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 18 Nov 2019 10:31:41 +0000
Received: from [127.0.0.1] (10.202.226.46) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Mon, 18 Nov
 2019 10:31:41 +0000
Subject: Re: [PATCH RFC 3/5] blk-mq: Facilitate a shared tags per tagset
To:     Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "ming.lei@redhat.com" <ming.lei@redhat.com>,
        "hare@suse.com" <hare@suse.com>,
        "chenxiang (M)" <chenxiang66@hisilicon.com>
References: <1573652209-163505-1-git-send-email-john.garry@huawei.com>
 <1573652209-163505-4-git-send-email-john.garry@huawei.com>
 <32880159-86e8-5c48-1532-181fdea0df96@suse.de>
 <2cbf591c-8284-8499-7804-e7078cf274d2@huawei.com>
 <02056612-a958-7b05-3c54-bb2fa69bc493@suse.de>
 <ace95bc5-7b89-9ed3-be89-8139f977984b@huawei.com>
 <42b0bcd9-f147-76eb-dfce-270f77bca818@suse.de>
 <89cd1985-39c7-2965-d25b-2ee2c183d057@huawei.com>
 <c34c0ce2-40a8-e4fc-3366-1f7b906da5a3@acm.org>
 <8e7bd2cb-1035-13ba-05db-d8e12c61df1f@huawei.com>
 <6b85f172-695c-4757-3794-455b8d55e015@acm.org>
From:   John Garry <john.garry@huawei.com>
Message-ID: <1ba51afd-cce5-f7b2-704c-06e00db027bc@huawei.com>
Date:   Mon, 18 Nov 2019 10:31:40 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <6b85f172-695c-4757-3794-455b8d55e015@acm.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.202.226.46]
X-ClientProxiedBy: lhreml710-chm.china.huawei.com (10.201.108.61) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 15/11/2019 17:57, Bart Van Assche wrote:
> On 11/15/19 2:24 AM, John Garry wrote:
>> Bart Van Assche wrote:
>> > How about sharing tag sets across hardware
>> > queues, e.g. like in the (totally untested) patch below?
>>
>> So this is similar in principle what Ming Lei came up with here:
>> https://lore.kernel.org/linux-block/20190531022801.10003-1-ming.lei@redhat.com/ 
>>
>> However your implementation looks neater, which is good.
>>
>> My concern with this approach is that we can't differentiate which 
>> tags are allocated for which hctx, and sometimes we need to know that.
>>

Hi Bart,

>> An example here was blk_mq_queue_tag_busy_iter(), which iterates the 
>> bits for each hctx. This would just be broken by that change, unless 
>> we record which bits are associated with each hctx.
> 
> I disagree. In bt_iter() I added " && rq->mq_hctx == hctx" such that 
> blk_mq_queue_tag_busy_iter() only calls the callback function for 
> matching (hctx, rq) pairs.

OK, I see. I assumed that rq->mq_hctx was statically set when we 
initially allocate the static requests per hctx; but that doesn’t appear 
so - it's set in blk_mq_get_request()->blk_mq_rq_ctx_init().

> 
>> Another example was __blk_mq_tag_idle(), which looks problematic.
> 
> Please elaborate.

Again, this was for the same reason being that I thought we could not 
differentiate which rqs were associated with which hctx.

> 
>> For debugfs, when we examine 
>> /sys/kernel/debug/block/.../hctxX/tags_bitmap, wouldn't that be the 
>> tags for all hctx (hctx0)?
>>
>> For debugging reasons, I would say we want to know which tags are 
>> allocated for a specific hctx, as this is tightly related to the 
>> requests for that hctx.
> 
> That is an open issue in the patch I posted and something that needs to 
> be addressed. One way to address this is to change the 
> sbitmap_bitmap_show() calls into calls to a function that only shows 
> those bits for which rq->mq_hctx == hctx.

Yeah, understood.

> 
>>> @@ -341,8 +341,11 @@ void blk_mq_tagset_busy_iter(struct 
>>> blk_mq_tag_set *tagset,
>>>       int i;
>>>
>>>       for (i = 0; i < tagset->nr_hw_queues; i++) {
>>> -        if (tagset->tags && tagset->tags[i])
>>> +        if (tagset->tags && tagset->tags[i]) {
>>>               blk_mq_all_tag_busy_iter(tagset->tags[i], fn, priv);
>>
>> As I mentioned earlier, wouldn't this iterate over all tags for all 
>> hctx's, when we just want the tags for hctx[i]?
>>
>> Thanks,
>> John
>>
>> [Not trimming reply for future reference]
>>
>>> +            if (tagset->share_tags)
>>> +                break;
>>> +        }
>>>       }
>>>   }
>>>   EXPORT_SYMBOL(blk_mq_tagset_busy_iter);
> 
> Since blk_mq_tagset_busy_iter() loops over all hardware queues all what 
> is changed is the order in which requests are examined. I am not aware 
> of any block driver that calls blk_mq_tagset_busy_iter() and that 
> depends on the order of the requests passed to the callback function.
> 

OK, fine.

So, to me, this approach also seems viable then.

I am however not so happy with how we use blk_mq_tag_set.tags[0] for the 
shared tags; I would like to use blk_mq_tag_set.shared_tags and make 
blk_mq_tag_set.tags[] point at blk_mq_tag_set.shared_tags or maybe not 
blk_mq_tag_set.tags[] at all. However maybe that change may be more 
intrusive.

And another more real concern is that we miss a check somewhere for 
rq->mq_hctx == hctx when examining the bits on the shared tags.

Thanks,
John
