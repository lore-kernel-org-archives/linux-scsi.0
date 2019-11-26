Return-Path: <SRS0=v3DL=ZS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 107E4C43215
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 18:08:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD7FB2073F
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 18:08:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726019AbfKZSIe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Nov 2019 13:08:34 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2122 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725870AbfKZSIe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Nov 2019 13:08:34 -0500
Received: from lhreml703-cah.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id 6CD84ED712DA3F29EE6C;
        Tue, 26 Nov 2019 18:08:32 +0000 (GMT)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 lhreml703-cah.china.huawei.com (10.201.108.44) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 26 Nov 2019 18:08:32 +0000
Received: from [127.0.0.1] (10.202.226.46) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Tue, 26 Nov
 2019 18:08:31 +0000
Subject: Re: [PATCH 3/8] blk-mq: Use a pointer for sbitmap
To:     Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Ming Lei <ming.lei@redhat.com>,
        "Bart van Assche" <bvanassche@acm.org>,
        <linux-scsi@vger.kernel.org>, <linux-block@vger.kernel.org>
References: <20191126091416.20052-1-hare@suse.de>
 <20191126091416.20052-4-hare@suse.de>
 <8f0522ee-2a81-c2ae-d111-3ff89ee6f93e@kernel.dk>
 <62838bca-cd3c-fccf-767c-76d8bea12324@huawei.com>
 <00a6d920-1855-c861-caa3-e845dcbe1fd8@kernel.dk>
 <baffb360-56c0-3da5-9a52-400fb763adbf@huawei.com>
 <9290eb7f-8d0b-8012-f9a4-a49c068def1b@kernel.dk>
From:   John Garry <john.garry@huawei.com>
Message-ID: <157f3e58-1d16-cc6b-52aa-15a6e1ac828a@huawei.com>
Date:   Tue, 26 Nov 2019 18:08:30 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <9290eb7f-8d0b-8012-f9a4-a49c068def1b@kernel.dk>
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

On 26/11/2019 17:25, Jens Axboe wrote:
> On 11/26/19 10:23 AM, John Garry wrote:
>> On 26/11/2019 17:11, Jens Axboe wrote:
>>> On 11/26/19 9:54 AM, John Garry wrote:
>>>> On 26/11/2019 15:14, Jens Axboe wrote:
>>>>> On 11/26/19 2:14 AM, Hannes Reinecke wrote:
>>>>>> Instead of allocating the tag bitmap in place we should be using a
>>>>>> pointer. This is in preparation for shared host-wide bitmaps.
>>>>>
>>>>> Not a huge fan of this, it's an extra indirection in the hot path
>>>>> of both submission and completion.
>>>>
>>>> Hi Jens,
>>>>
>>>> Thanks for having a look.
>>>>
>>>> I checked the disassembly for blk_mq_get_tag() as a sample - which I
>>>> assume is one hot path function which you care about - and the cost of
>>>> the indirection is a load instruction instead of an add, denoted by ***,
>>>> below:
>>>
>>
>> Hi Jens,
>>
>>> I'm not that worried about an extra instruction, my worry is the extra
>>> load is from different memory. When it's embedded in the struct, we're
>>> on the same cache line or adjacent.
>>
>> Right, so the earlier iteration of this series kept the embedded struct
>> and we simply pointed at that, so I wouldn't expect a caching issue of
>> different memory in that case.
> 

Hi Jens,

> That would be a much better solution for the common case, my concern
> here is slowing down the fast path for device that don't need shared
> tags.
> 
> Would be interesting to check the generated code for that, ideally we'd
> get rid of the extra load for that case, even if it is in the same
> cacheline.
> 

I checked the disassembly and we still have the load instead of the add.

This is not surprising, as the compiler would not know for certain that 
we point to a field within the same struct. But at least we still should 
point to a close memory.

Note that the pointer could be dropped, which would remove the load, but 
then we have many if-elses which could be slower, not to mention that 
the blk-mq-tag code deals in bitmap pointers anyway.

Thanks,
John



