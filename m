Return-Path: <SRS0=v3DL=ZS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2FD1C432C0
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 11:27:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9890E2080F
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 11:27:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727635AbfKZL1y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Nov 2019 06:27:54 -0500
Received: from mx2.suse.de ([195.135.220.15]:36678 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727218AbfKZL1x (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Nov 2019 06:27:53 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 02A69ACA5;
        Tue, 26 Nov 2019 11:27:50 +0000 (UTC)
Subject: Re: [PATCH 4/8] blk-mq: Facilitate a shared sbitmap per tagset
To:     Ming Lei <ming.lei@redhat.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Bart van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20191126091416.20052-1-hare@suse.de>
 <20191126091416.20052-5-hare@suse.de> <20191126110527.GE32135@ming.t460p>
From:   Hannes Reinecke <hare@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=hare@suse.de; prefer-encrypt=mutual; keydata=
 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
 azzYF4VRJsdl+d0MCaSy8mUh
Message-ID: <8a10e2f0-bbdc-8b47-a118-0fd7837ef44e@suse.de>
Date:   Tue, 26 Nov 2019 12:27:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191126110527.GE32135@ming.t460p>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/26/19 12:05 PM, Ming Lei wrote:
> On Tue, Nov 26, 2019 at 10:14:12AM +0100, Hannes Reinecke wrote:
[ .. ]
>> diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
>> index ca22afd47b3d..f3589f42b96d 100644
>> --- a/block/blk-mq-sched.c
>> +++ b/block/blk-mq-sched.c
>> @@ -452,7 +452,7 @@ static void blk_mq_sched_free_tags(struct blk_mq_tag_set *set,
>>  {
>>  	if (hctx->sched_tags) {
>>  		blk_mq_free_rqs(set, hctx->sched_tags, hctx_idx);
>> -		blk_mq_free_rq_map(hctx->sched_tags);
>> +		blk_mq_free_rq_map(hctx->sched_tags, false);
>>  		hctx->sched_tags = NULL;
>>  	}
>>  }
>> @@ -462,10 +462,14 @@ static int blk_mq_sched_alloc_tags(struct request_queue *q,
>>  				   unsigned int hctx_idx)
>>  {
>>  	struct blk_mq_tag_set *set = q->tag_set;
>> +	int flags = set->flags;
>>  	int ret;
>>  
>> +	/* Scheduler tags are never shared */
>> +	set->flags &= ~BLK_MQ_F_TAG_HCTX_SHARED;
>>  	hctx->sched_tags = blk_mq_alloc_rq_map(set, hctx_idx, q->nr_requests,
>>  					       set->reserved_tags);
>> +	set->flags = flags;
> 
> This way is very fragile, race is made against other uses of
> blk_mq_is_sbitmap_shared().
> 
We are allocating tags, I don't think we're even able to modify it at
this point.

> From performance viewpoint, all hctx belonging to this request queue should
> share one scheduler tagset in case of BLK_MQ_F_TAG_HCTX_SHARED, cause
> driver tag queue depth isn't changed.
> 
Hmm. Now you get me confused.
In an earlier mail you said:

> This kind of sharing is wrong, sched tags should be request
> queue wide instead of tagset wide, and each request queue has
> its own & independent scheduler queue.

as in v2 we _had_ shared scheduler tags, too.
Did I misread your comment above?

>>  	if (!hctx->sched_tags)
>>  		return -ENOMEM;
>>  
[ .. ]
>> @@ -2456,7 +2459,8 @@ static void blk_mq_free_map_and_requests(struct blk_mq_tag_set *set,
>>  {
>>  	if (set->tags && set->tags[hctx_idx]) {
>>  		blk_mq_free_rqs(set, set->tags[hctx_idx], hctx_idx);
>> -		blk_mq_free_rq_map(set->tags[hctx_idx]);
>> +		blk_mq_free_rq_map(set->tags[hctx_idx],
>> +				   blk_mq_is_sbitmap_shared(set));
>>  		set->tags[hctx_idx] = NULL;
>>  	}
> 
> Who will free the shared tags finally in case of blk_mq_is_sbitmap_shared()?
> 
Hmm. Indeed, that bit is missing; will be adding it.

>>  }
[ .. ]
>> @@ -3168,8 +3186,17 @@ int blk_mq_update_nr_requests(struct request_queue *q, unsigned int nr)
>>  			q->elevator->type->ops.depth_updated(hctx);
>>  	}
>>  
>> -	if (!ret)
>> +	if (!ret) {
>> +		if (blk_mq_is_sbitmap_shared(set)) {
>> +			sbitmap_queue_resize(&set->shared_bitmap_tags, nr);
>> +			sbitmap_queue_resize(&set->shared_breserved_tags, nr);
>> +		}
> 
> The above change is wrong in case of hctx->sched_tags.
> 
Yes, we need to add a marker here if these are 'normal' or 'scheduler'
tags. This will also help when allocating as then we won't need this
flag twiddling you've complained about.

>>  		q->nr_requests = nr;
>> +	}
>> +	/*
>> +	 * if ret != 0, q->nr_requests would not be updated, yet the depth
>> +	 * for some hctx may have changed - is that right?
>> +	 */
>>  
>>  	blk_mq_unquiesce_queue(q);
>>  	blk_mq_unfreeze_queue(q);
[ .. ]
>> diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
>> index 147185394a25..670e9a949d32 100644
>> --- a/include/linux/blk-mq.h
>> +++ b/include/linux/blk-mq.h
>> @@ -109,6 +109,12 @@ struct blk_mq_tag_set {
>>  	unsigned int		flags;		/* BLK_MQ_F_* */
>>  	void			*driver_data;
>>  
>> +	struct sbitmap_queue shared_bitmap_tags;
>> +	struct sbitmap_queue shared_breserved_tags;
>> +
>> +	struct sbitmap_queue sched_shared_bitmap_tags;
>> +	struct sbitmap_queue sched_shared_breserved_tags;
>> +
> 
> The above two fields aren't used in this patch.
> 
Left-overs from merging. Will be removed.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      Teamlead Storage & Networking
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
