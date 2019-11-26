Return-Path: <SRS0=v3DL=ZS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC25FC43215
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 11:50:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F9B9207DD
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 11:50:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727315AbfKZLuV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Nov 2019 06:50:21 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2117 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725884AbfKZLuV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Nov 2019 06:50:21 -0500
Received: from lhreml708-cah.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id 73679D845BC11D06D187;
        Tue, 26 Nov 2019 11:50:19 +0000 (GMT)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 lhreml708-cah.china.huawei.com (10.201.108.49) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 26 Nov 2019 11:50:18 +0000
Received: from [127.0.0.1] (10.202.226.46) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Tue, 26 Nov
 2019 11:50:19 +0000
Subject: Re: [PATCH 4/8] blk-mq: Facilitate a shared sbitmap per tagset
To:     Hannes Reinecke <hare@suse.de>, Ming Lei <ming.lei@redhat.com>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        "Bart van Assche" <bvanassche@acm.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
References: <20191126091416.20052-1-hare@suse.de>
 <20191126091416.20052-5-hare@suse.de> <20191126110527.GE32135@ming.t460p>
 <8a10e2f0-bbdc-8b47-a118-0fd7837ef44e@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <0ca7450d-5fd1-8d23-796d-3e5ed1d7f060@huawei.com>
Date:   Tue, 26 Nov 2019 11:50:17 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <8a10e2f0-bbdc-8b47-a118-0fd7837ef44e@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.46]
X-ClientProxiedBy: lhreml720-chm.china.huawei.com (10.201.108.71) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 26/11/2019 11:27, Hannes Reinecke wrote:
> On 11/26/19 12:05 PM, Ming Lei wrote:
>> On Tue, Nov 26, 2019 at 10:14:12AM +0100, Hannes Reinecke wrote:
> [ .. ]
>>> diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
>>> index ca22afd47b3d..f3589f42b96d 100644
>>> --- a/block/blk-mq-sched.c
>>> +++ b/block/blk-mq-sched.c
>>> @@ -452,7 +452,7 @@ static void blk_mq_sched_free_tags(struct blk_mq_tag_set *set,
>>>   {
>>>   	if (hctx->sched_tags) {
>>>   		blk_mq_free_rqs(set, hctx->sched_tags, hctx_idx);
>>> -		blk_mq_free_rq_map(hctx->sched_tags);
>>> +		blk_mq_free_rq_map(hctx->sched_tags, false);
>>>   		hctx->sched_tags = NULL;
>>>   	}
>>>   }
>>> @@ -462,10 +462,14 @@ static int blk_mq_sched_alloc_tags(struct request_queue *q,
>>>   				   unsigned int hctx_idx)
>>>   {
>>>   	struct blk_mq_tag_set *set = q->tag_set;
>>> +	int flags = set->flags;
>>>   	int ret;
>>>   
>>> +	/* Scheduler tags are never shared */
>>> +	set->flags &= ~BLK_MQ_F_TAG_HCTX_SHARED;
>>>   	hctx->sched_tags = blk_mq_alloc_rq_map(set, hctx_idx, q->nr_requests,
>>>   					       set->reserved_tags);
>>> +	set->flags = flags;
>>
>> This way is very fragile, race is made against other uses of
>> blk_mq_is_sbitmap_shared().
>>
> We are allocating tags, I don't think we're even able to modify it at
> this point.
> 
>>  From performance viewpoint, all hctx belonging to this request queue should
>> share one scheduler tagset in case of BLK_MQ_F_TAG_HCTX_SHARED, cause
>> driver tag queue depth isn't changed.
>>
> Hmm. Now you get me confused.
> In an earlier mail you said:
> 
>> This kind of sharing is wrong, sched tags should be request
>> queue wide instead of tagset wide, and each request queue has
>> its own & independent scheduler queue.
> 
> as in v2 we _had_ shared scheduler tags, too.
> Did I misread your comment above?

As I understand, we just don't require shared scheduler tags. It's only 
blk_mq_tag_set.tags which need to use the shared sbitmap.

> 
>>>   	if (!hctx->sched_tags)
>>>   		return -ENOMEM;
>>>   
> [ .. ]
>>> @@ -2456,7 +2459,8 @@ static void blk_mq_free_map_and_requests(struct blk_mq_tag_set *set,
>>>   {
>>>   	if (set->tags && set->tags[hctx_idx]) {
>>>   		blk_mq_free_rqs(set, set->tags[hctx_idx], hctx_idx);
>>> -		blk_mq_free_rq_map(set->tags[hctx_idx]);
>>> +		blk_mq_free_rq_map(set->tags[hctx_idx],
>>> +				   blk_mq_is_sbitmap_shared(set));
>>>   		set->tags[hctx_idx] = NULL;
>>>   	}
>>
>> Who will free the shared tags finally in case of blk_mq_is_sbitmap_shared()?
>>
> Hmm. Indeed, that bit is missing; will be adding it.
> 
>>>   }
> [ .. ]
>>> @@ -3168,8 +3186,17 @@ int blk_mq_update_nr_requests(struct request_queue *q, unsigned int nr)
>>>   			q->elevator->type->ops.depth_updated(hctx);
>>>   	}
>>>   
>>> -	if (!ret)
>>> +	if (!ret) {
>>> +		if (blk_mq_is_sbitmap_shared(set)) {
>>> +			sbitmap_queue_resize(&set->shared_bitmap_tags, nr);
>>> +			sbitmap_queue_resize(&set->shared_breserved_tags, nr);
>>> +		}
>>
>> The above change is wrong in case of hctx->sched_tags.
>>
> Yes, we need to add a marker here if these are 'normal' or 'scheduler'
> tags. This will also help when allocating as then we won't need this
> flag twiddling you've complained about.

nit: To be proper, since this is tag management, we should move it to 
blk-mq-tags.c

> 
>>>   		q->nr_requests = nr;
>>> +	}
>>> +	/*
>>> +	 * if ret != 0, q->nr_requests would not be updated, yet the depth
>>> +	 * for some hctx may have changed - is that right?
>>> +	 */
>>>   
>>>   	blk_mq_unquiesce_queue(q);
>>>   	blk_mq_unfreeze_queue(q);
> [ .. ]
>>> diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
>>> index 147185394a25..670e9a949d32 100644
>>> --- a/include/linux/blk-mq.h
>>> +++ b/include/linux/blk-mq.h
>>> @@ -109,6 +109,12 @@ struct blk_mq_tag_set {
>>>   	unsigned int		flags;		/* BLK_MQ_F_* */
>>>   	void			*driver_data;
>>>   
>>> +	struct sbitmap_queue shared_bitmap_tags;
>>> +	struct sbitmap_queue shared_breserved_tags;
>>> +
>>> +	struct sbitmap_queue sched_shared_bitmap_tags;
>>> +	struct sbitmap_queue sched_shared_breserved_tags;
>>> +
>>
>> The above two fields aren't used in this patch.
>>
> Left-overs from merging. Will be removed.
> 
> Cheers,
> 
> Hannes
> 

