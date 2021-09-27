Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2789FC433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Sep 2021 08:59:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E1D06115C
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Sep 2021 08:59:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233601AbhI0JBS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Sep 2021 05:01:18 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3876 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233593AbhI0JBR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Sep 2021 05:01:17 -0400
Received: from fraeml710-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HHxMn2wh8z67gvx;
        Mon, 27 Sep 2021 16:56:53 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml710-chm.china.huawei.com (10.206.15.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Mon, 27 Sep 2021 10:59:38 +0200
Received: from [10.47.85.67] (10.47.85.67) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Mon, 27 Sep
 2021 09:59:37 +0100
Subject: Re: [PATCH v4 11/13] blk-mq: Refactor and rename
 blk_mq_free_map_and_{requests->rqs}()
To:     Ming Lei <ming.lei@redhat.com>
CC:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "hare@suse.de" <hare@suse.de>
References: <1632472110-244938-1-git-send-email-john.garry@huawei.com>
 <1632472110-244938-12-git-send-email-john.garry@huawei.com>
 <YU/Va9T+zcRNExUF@T590>
From:   John Garry <john.garry@huawei.com>
Message-ID: <45c0c587-59a2-1761-e175-3920669d0bfb@huawei.com>
Date:   Mon, 27 Sep 2021 10:02:40 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <YU/Va9T+zcRNExUF@T590>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.85.67]
X-ClientProxiedBy: lhreml717-chm.china.huawei.com (10.201.108.68) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 26/09/2021 03:05, Ming Lei wrote:
> On Fri, Sep 24, 2021 at 04:28:28PM +0800, John Garry wrote:
>> Refactor blk_mq_free_map_and_requests() such that it can be used at many
>> sites at which the tag map and rqs are freed.
>>
>> Also rename to blk_mq_free_map_and_rqs(), which is shorter and matches the
>> alloc equivalent.
>>
>> Suggested-by: Ming Lei<ming.lei@redhat.com>
>> Signed-off-by: John Garry<john.garry@huawei.com>
>> Reviewed-by: Hannes Reinecke<hare@suse.de>
>> ---
>>   block/blk-mq-tag.c |  3 +--
>>   block/blk-mq.c     | 40 ++++++++++++++++++++++++----------------
>>   block/blk-mq.h     |  4 +++-
>>   3 files changed, 28 insertions(+), 19 deletions(-)
>>
>> diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
>> index db99f1246795..a0ecc6d88f84 100644
>> --- a/block/blk-mq-tag.c
>> +++ b/block/blk-mq-tag.c
>> @@ -607,8 +607,7 @@ int blk_mq_tag_update_depth(struct blk_mq_hw_ctx *hctx,
>>   		if (!new)
>>   			return -ENOMEM;
>>   
>> -		blk_mq_free_rqs(set, *tagsptr, hctx->queue_num);
>> -		blk_mq_free_rq_map(*tagsptr, set->flags);
>> +		blk_mq_free_map_and_rqs(set, *tagsptr, hctx->queue_num);
>>   		*tagsptr = new;
>>   	} else {
>>   		/*
>> diff --git a/block/blk-mq.c b/block/blk-mq.c
>> index 46772773b9c4..464ea20b9bcb 100644
>> --- a/block/blk-mq.c
>> +++ b/block/blk-mq.c
>> @@ -2878,15 +2878,15 @@ static bool __blk_mq_alloc_map_and_rqs(struct blk_mq_tag_set *set,
>>   	return set->tags[hctx_idx];
>>   }
>>   
>> -static void blk_mq_free_map_and_requests(struct blk_mq_tag_set *set,
>> -					 unsigned int hctx_idx)
>> +void blk_mq_free_map_and_rqs(struct blk_mq_tag_set *set,
>> +			     struct blk_mq_tags *tags,
>> +			     unsigned int hctx_idx)
>>   {
>>   	unsigned int flags = set->flags;
>>   
>> -	if (set->tags && set->tags[hctx_idx]) {
>> -		blk_mq_free_rqs(set, set->tags[hctx_idx], hctx_idx);
>> -		blk_mq_free_rq_map(set->tags[hctx_idx], flags);
>> -		set->tags[hctx_idx] = NULL;
>> +	if (tags) {
>> +		blk_mq_free_rqs(set, tags, hctx_idx);
>> +		blk_mq_free_rq_map(tags, flags);
>>   	}
>>   }
>>   
>> @@ -2967,8 +2967,10 @@ static void blk_mq_map_swqueue(struct request_queue *q)
>>   			 * fallback in case of a new remap fails
>>   			 * allocation
>>   			 */
>> -			if (i && set->tags[i])
>> -				blk_mq_free_map_and_requests(set, i);
>> +			if (i && set->tags[i]) {
>> +				blk_mq_free_map_and_rqs(set, set->tags[i], i);
>> +				set->tags[i] = NULL;
>> +			}
>>   
>>   			hctx->tags = NULL;
>>   			continue;
>> @@ -3264,8 +3266,8 @@ static void blk_mq_realloc_hw_ctxs(struct blk_mq_tag_set *set,
>>   		struct blk_mq_hw_ctx *hctx = hctxs[j];
>>   
>>   		if (hctx) {
>> -			if (hctx->tags)
>> -				blk_mq_free_map_and_requests(set, j);
>> +			blk_mq_free_map_and_rqs(set, set->tags[j], j);
>> +			set->tags[j] = NULL;
>>   			blk_mq_exit_hctx(q, set, hctx, j);
>>   			hctxs[j] = NULL;
>>   		}
>> @@ -3361,8 +3363,10 @@ static int __blk_mq_alloc_rq_maps(struct blk_mq_tag_set *set)
>>   	return 0;
>>   
>>   out_unwind:
>> -	while (--i >= 0)
>> -		blk_mq_free_map_and_requests(set, i);
>> +	while (--i >= 0) {
>> +		blk_mq_free_map_and_rqs(set, set->tags[i], i);
>> +		set->tags[i] = NULL;
>> +	}
>>   
>>   	return -ENOMEM;
>>   }
>> @@ -3557,8 +3561,10 @@ int blk_mq_alloc_tag_set(struct blk_mq_tag_set *set)
>>   	return 0;
>>   
>>   out_free_mq_rq_maps:
>> -	for (i = 0; i < set->nr_hw_queues; i++)
>> -		blk_mq_free_map_and_requests(set, i);
>> +	for (i = 0; i < set->nr_hw_queues; i++) {
>> +		blk_mq_free_map_and_rqs(set, set->tags[i], i);
>> +		set->tags[i] = NULL;
>> +	}
>>   out_free_mq_map:
>>   	for (i = 0; i < set->nr_maps; i++) {
>>   		kfree(set->map[i].mq_map);
>> @@ -3590,8 +3596,10 @@ void blk_mq_free_tag_set(struct blk_mq_tag_set *set)
>>   {
>>   	int i, j;
>>   
>> -	for (i = 0; i < set->nr_hw_queues; i++)
>> -		blk_mq_free_map_and_requests(set, i);
>> +	for (i = 0; i < set->nr_hw_queues; i++) {
>> +		blk_mq_free_map_and_rqs(set, set->tags[i], i);
>> +		set->tags[i] = NULL;
>> +	}
> There are 5 callers in which 'set->tags[i]' is cleared, so just
> wondering why you don't clear set->tags[i] at default in
> blk_mq_free_map_and_rqs(). And just call __blk_mq_free_map_and_rqs()
> for the only other user?

blk_mq_free_map_and_rqs() is not always passed set->tags[i]:

- blk_mq_tag_update_depth() calls blk_mq_free_map_and_rqs() for sched tags

- __blk_mq_alloc_rq_maps() calls blk_mq_free_map_and_rqs() for 
shared_sbitmap_tags

Function __blk_mq_free_map_and_rqs() is not public and really only 
intended for set->tags[i]

So I did consider passing the address of the tags pointer to
blk_mq_free_map_and_rqs(), like:

void blk_mq_free_map_and_rqs(struct blk_mq_tag_set *set,
			struct blk_mq_tag **tags,
			unsigned int hctx_idx)

{
	...
	*tags = NULL;
}

But then the API becomes a bit asymmetric, as we deal with tags pointer 
normally:

struct blk_mq_tags *blk_mq_alloc_map_and_rqs(struct blk_mq_tag_set *set,
					     unsigned int hctx_idx,
					     unsigned int depth);


However, apart from this, I can change __blk_mq_free_map_and_rqs() to 
NULLify set->tags[i], as it is always passed set->tags[i].

Do you have a preference?

Thanks,
John


