Return-Path: <SRS0=HsAm=ZT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91807C432C3
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Nov 2019 16:53:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73FA62075C
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Nov 2019 16:53:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727010AbfK0QxA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Nov 2019 11:53:00 -0500
Received: from mx2.suse.de ([195.135.220.15]:55780 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726729AbfK0QxA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 Nov 2019 11:53:00 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B47C2B1F2;
        Wed, 27 Nov 2019 16:52:57 +0000 (UTC)
Subject: Re: [PATCH 3/8] blk-mq: Use a pointer for sbitmap
To:     John Garry <john.garry@huawei.com>, Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
References: <20191126091416.20052-1-hare@suse.de>
 <20191126091416.20052-4-hare@suse.de>
 <8f0522ee-2a81-c2ae-d111-3ff89ee6f93e@kernel.dk>
 <62838bca-cd3c-fccf-767c-76d8bea12324@huawei.com>
 <00a6d920-1855-c861-caa3-e845dcbe1fd8@kernel.dk>
 <baffb360-56c0-3da5-9a52-400fb763adbf@huawei.com>
 <9290eb7f-8d0b-8012-f9a4-a49c068def1b@kernel.dk>
 <157f3e58-1d16-cc6b-52aa-15a6e1ac828a@huawei.com>
 <1add0896-4867-12c5-4507-76526c27fb56@kernel.dk>
 <4a780199-7997-b677-b184-411afdeabba5@huawei.com>
 <5bc7b976-845c-92ec-6ccc-8e43237313bc@kernel.dk>
 <dbd917cc-f8a2-a410-5c2b-79670ede440d@huawei.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <58875c2b-5141-b8be-a086-4fa29137d1e6@suse.de>
Date:   Wed, 27 Nov 2019 17:52:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <dbd917cc-f8a2-a410-5c2b-79670ede440d@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/27/19 3:44 PM, John Garry wrote:
> On 27/11/2019 14:21, Jens Axboe wrote:
>> On 11/27/19 6:05 AM, John Garry wrote:
>>> On 27/11/2019 01:46, Jens Axboe wrote:
>>>>>> Would be interesting to check the generated code for that, ideally 
>>>>>> we'd
>>>>>> get rid of the extra load for that case, even if it is in the same
>>>>>> cacheline.
>>>>>>
>>>>> I checked the disassembly and we still have the load instead of the 
>>>>> add.
>>>>>
>>>>> This is not surprising, as the compiler would not know for certain 
>>>>> that
>>>>> we point to a field within the same struct. But at least we still 
>>>>> should
>>>>> point to a close memory.
>>>>>
>>>>> Note that the pointer could be dropped, which would remove the 
>>>>> load, but
>>>>> then we have many if-elses which could be slower, not to mention that
>>>>> the blk-mq-tag code deals in bitmap pointers anyway.
>>>
>>> Hi Jens,
>>>
>>>> It might still be worthwhile to do:
>>>>
>>>> if (tags->ptr == &tags->__default)
>>>>     foo(&tags->__default);
>>>>
>>>> to make it clear, as that branch will predict easily.
>>>
>>> Not sure. So this code does produce the same assembly, as we still need
>>> to do the tags->ptr load for the comparison.
>>
> 
> Hi Jens,
> 
>> How can it be the same? The approach in the patchset needs to load
>> *tags->ptr, this one needs tags->ptr. That's the big difference.
>>
> 
> In the patch for this thread, we have:
> 
> @@ -121,10 +121,10 @@ unsigned int blk_mq_get_tag(struct 
> blk_mq_alloc_data *data)
>               WARN_ON_ONCE(1);
>               return BLK_MQ_TAG_FAIL;
>           }
> -        bt = &tags->breserved_tags;
> +        bt = tags->breserved_tags;
>           tag_offset = 0;
>       } else {
> -        bt = &tags->bitmap_tags;
> +        bt = tags->bitmap_tags;
>           tag_offset = tags->nr_reserved_tags;
>       }
> 
> 
> So current code gets bt pointer by simply offsetting a certain distance 
> from tags pointer - that is the add I mention.
> 
> With the change in this patch, we need to load memory at address 
> &tags->bitmap_tags to get bt - this is the load I mention.
> 
> So for this:
> 
> if (tags->ptr == &tags->__default)
> 
> We load &tags->ptr to get the pointer value for comparison vs 
> &tags->__default.
> 
> There must be something I'm missing...
> 
The point here was that the load might refer to _other_ memory locations 
(as it's being allocated separately), thus incurring a cache miss.
With embedded tag bitmaps we'll load from the same cache line 
(hopefully), and won't get a performance hit.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                              +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
