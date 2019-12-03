Return-Path: <SRS0=KpyL=ZZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7956C432C0
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Dec 2019 15:02:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F769206EC
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Dec 2019 15:02:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbfLCPCX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Dec 2019 10:02:23 -0500
Received: from mx2.suse.de ([195.135.220.15]:51012 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726057AbfLCPCW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 3 Dec 2019 10:02:22 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B7508BAD0;
        Tue,  3 Dec 2019 15:02:19 +0000 (UTC)
Subject: Re: [PATCH 04/11] blk-mq: Facilitate a shared sbitmap per tagset
To:     John Garry <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20191202153914.84722-1-hare@suse.de>
 <20191202153914.84722-5-hare@suse.de>
 <ab7555b2-2e95-6fb1-2e44-fe3a323a24e4@huawei.com>
From:   Hannes Reinecke <hare@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=hare@suse.de; prefer-encrypt=mutual; keydata=
 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
 azzYF4VRJsdl+d0MCaSy8mUh
Message-ID: <5beb7d51-500e-5bda-4e46-8414fd8b64ff@suse.de>
Date:   Tue, 3 Dec 2019 16:02:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <ab7555b2-2e95-6fb1-2e44-fe3a323a24e4@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/3/19 3:54 PM, John Garry wrote:
>>   @@ -483,8 +483,8 @@ static int hctx_tags_bitmap_show(void *data,
>> struct seq_file *m)
>>       res = mutex_lock_interruptible(&q->sysfs_lock);
>>       if (res)
>>           goto out;
>> -    if (hctx->tags)
>> -        sbitmap_bitmap_show(&hctx->tags->bitmap_tags.sb, m);
>> +    if (hctx->tags) /* We should just iterate the relevant bits for
>> this hctx FIXME */
> 
> Bart's solution to this problem seemed ok, if he doesn't mind us
> borrowing his idea:
> 
> https://lore.kernel.org/linux-block/5183ab13-0c81-95f0-95ba-40318569c6c6@huawei.com/T/#m24394fe70b1ea79a154dfd9620f5e553c3e7e7da
> 
> 
> See hctx_tags_bitmap_show().
> 
> It might be also reasonable to put that in another follow on patch, as
> there would be no enablers of the "shared" bitmap until later patches.
> 
Yeah, that was my plan, too.
But then I'd rather wait for feedback on the general approach here;
no point is wasting perfectly good bits if no-one's wanting them ...

[ .. ]
>> @@ -121,10 +121,10 @@ unsigned int blk_mq_get_tag(struct
>> blk_mq_alloc_data *data)
>>               WARN_ON_ONCE(1);
>>               return BLK_MQ_TAG_FAIL;
>>           }
>> -        bt = &tags->breserved_tags;
>> +        bt = tags->breserved_tags;
> 
> We could put all of this in an earlier patch (as you had in v4, modulo
> dynamic memory part), which would be easier to review and get accepted.
> 
Yeah, but I felt it a bit odd, just having pointers to an existing
structure element.
But yes, will be doing for the next round.

>>           tag_offset = 0;
>>       } else {
>> -        bt = &tags->bitmap_tags;
>> +        bt = tags->bitmap_tags;
>>           tag_offset = tags->nr_reserved_tags;
>>       }
> 
> 
> [...]
> 
>>       if (!set)
>> @@ -3160,6 +3179,7 @@ int blk_mq_update_nr_requests(struct
>> request_queue *q, unsigned int nr)
>>               ret = blk_mq_tag_update_depth(hctx, &hctx->tags, nr,
>>                               false);
>>           } else {
>> +            sched_tags = true;
>>               ret = blk_mq_tag_update_depth(hctx, &hctx->sched_tags,
>>                               nr, true);
>>           }
>> @@ -3169,8 +3189,43 @@ int blk_mq_update_nr_requests(struct
>> request_queue *q, unsigned int nr)
>>               q->elevator->type->ops.depth_updated(hctx);
>>       }
>>   -    if (!ret)
>> +    /*
>> +     * if ret is 0, all queues should have been updated to the same
>> depth
>> +     * if not, then maybe some have been updated - yuk, need to
>> handle this for shared sbitmap...
>> +     * if some are updated, we should probably roll back the change
>> altogether. FIXME
>> +     */
> 
> If you don't have a shared sched bitmap - which I didn't think we needed
> - then all we need is a simple sbitmap_queue_resize(&tagset->__bitmap_tags)
> 
> Otherwise it's horrible to resize shared sched bitmaps...
> 
Resizing shared sched bitmaps is done in patch 6/11.
General idea is to move the scheduler bitmap into the request queue
(well, actually the elevator), as this gives us a per-request_queue
bitmap. Which is actually what we want here, as the scheduler will need
to look at all requests, hence needing to access to the same bitmap.
And it also gives us an easy way of resizing the sched tag bitmap, as
then we can resize the bitmap on a per-queue basis, and leave the
underlying tagset bitmap untouched.

[ .. ]
>> diff --git a/block/blk-mq.h b/block/blk-mq.h
>> index 78d38b5f2793..4c1ea206d3f4 100644
>> --- a/block/blk-mq.h
>> +++ b/block/blk-mq.h
>> @@ -166,6 +166,11 @@ struct blk_mq_alloc_data {
>>       struct blk_mq_hw_ctx *hctx;
>>   };
>>   +static inline bool blk_mq_is_sbitmap_shared(struct blk_mq_tag_set
>> *tag_set)
>> +{
>> +    return !!(tag_set->flags & BLK_MQ_F_TAG_HCTX_SHARED);
> 
> Bart already gave some comments on this
> 
Ah. Missed that one. Will be including in the next round.

Thanks for the review!

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      Teamlead Storage & Networking
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
