Return-Path: <SRS0=2nLx=ZH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1ECFC432C3
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Nov 2019 10:46:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4D5120748
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Nov 2019 10:46:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727399AbfKOKq6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Nov 2019 05:46:58 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2102 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726996AbfKOKq4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 15 Nov 2019 05:46:56 -0500
Received: from LHREML710-CAH.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id 62D3A1695C76DAA7E817;
        Fri, 15 Nov 2019 10:46:55 +0000 (GMT)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 LHREML710-CAH.china.huawei.com (10.201.108.33) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Fri, 15 Nov 2019 10:46:55 +0000
Received: from [127.0.0.1] (10.202.226.46) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Fri, 15 Nov
 2019 10:46:54 +0000
Subject: Re: [PATCH RFC 3/5] blk-mq: Facilitate a shared tags per tagset
To:     Hannes Reinecke <hare@suse.de>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "ming.lei@redhat.com" <ming.lei@redhat.com>,
        "hare@suse.com" <hare@suse.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "chenxiang (M)" <chenxiang66@hisilicon.com>
References: <1573652209-163505-1-git-send-email-john.garry@huawei.com>
 <1573652209-163505-4-git-send-email-john.garry@huawei.com>
 <32880159-86e8-5c48-1532-181fdea0df96@suse.de>
 <2cbf591c-8284-8499-7804-e7078cf274d2@huawei.com>
 <02056612-a958-7b05-3c54-bb2fa69bc493@suse.de>
 <ace95bc5-7b89-9ed3-be89-8139f977984b@huawei.com>
 <42b0bcd9-f147-76eb-dfce-270f77bca818@suse.de>
 <89cd1985-39c7-2965-d25b-2ee2c183d057@huawei.com>
 <e676df15-7331-abe3-d3da-3ff46cb6684f@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <ff77beff-5fd9-9f05-12b6-826922bace1f@huawei.com>
Date:   Fri, 15 Nov 2019 10:46:53 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <e676df15-7331-abe3-d3da-3ff46cb6684f@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.202.226.46]
X-ClientProxiedBy: lhreml713-chm.china.huawei.com (10.201.108.64) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 15/11/2019 07:26, Hannes Reinecke wrote:
> On 11/14/19 10:41 AM, John Garry wrote:
>> On 13/11/2019 18:38, Hannes Reinecke wrote:
>>>> Hi Hannes,
>>>>
>>>>> Oh, my. Indeed, that's correct.
>>>>
>>>> The tags could be kept in sync like this:
>>>>
>>>> shared_tag = blk_mq_get_tag(shared_tagset);
>>>> if (shared_tag != -1)
>>>>       sbitmap_set(hctx->tags, shared_tag);
>>>>
>>>> But that's obviously not ideal.
>>>>
>>> Actually, I _do_ prefer keeping both in sync.
>>> We might want to check if the 'normal' tag is set (typically it would
>>> not, but then, who knows ...)
>>> The beauty here is that both 'shared' and 'normal' tag are in sync, so
>>> if a driver would be wanting to use the tag as index into a command
>>> array it can do so without any surprises.
>>>
>>> Why do you think it's not ideal?
>>
>> A few points:
>> - Getting a bit from one tagset and then setting it in another tagset is
>> a bit clunky.
> Yes, that's true.
> But painstakingly trying to find a free bit in a bitmask when we already
> know which to pick is also a bit daft.

Yeah, but it's not all good - there would still be a certain overhead in 
the atomic set and unset bit on the hctx sbitmap. However it still 
should be faster as it excludes the search.

> 
>> - There may be an atomicity of the getting the shared tag bit and
>> setting the hctx tag bit - I don't think that there is.
> 
> That was precisely what I've alluded to in 'We might want to check if
> the normal tag is set'.
> Typically the 'normal' tag would be free (as the shared tag set out of
> necessity needs to be the combination of all hctx tag sets).

Right

> Any difference here _is_ a programming error, and should be flagged as
> such (sbitmap_test_and_set() anyone?)

Eh, I hope that we wouldn't need this.

> We might have ordering issues on release, as we really should drop the
> hctx tag before the shared tag; but when we observe that we should be fine.
> 
>> - Consider that sometimes we may want to check if there is space on a hw
>> queue - checking the hctx tags is not really proper any longer, as
>> typically there would always be space on hctx, but not always the shared
>> tags. We did delete blk_mq_can_queue() yesterday, which would be an
>> example of that. Need to check if there are others.
>>
> Clearly, this needs an audit of all functions accessing the hctx tag
> space; maybe it's worth having a pre-requisite patchset differentiating
> between hctx tags and global, shared tags. Hmm.
> 
>> Having said all that, the obvious advantage is performance gain, can
>> still use request.tag and so maybe less intrusive changes.
>>
>> I'll have a look at the implementation. The devil is mostly in the
>> detail...
>>
> True.
> And, incidentally, if we run with shared tage we can skip the scheduling
> section in blk_mq_get_tag(); if we're out of tags, we're out of tags,

Right, but don't we need to then "kick all hw queues", instead of just 
that for the current hctx in blk_mq_get_tag() when free tags are exhausted?

> and no rescheduling will help as we don't _have_ other tagsets to look at.
> 
> But overall I like this approach.
> 

Yeah, to me it seems sensible. Again, a neat implementation is the 
challenge.

I'll post an RFC v2 for this one.

I am also requesting some performance figures also internally.

Thanks,
John
