Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C812FC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 13:33:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE7606142A
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 13:33:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344216AbhI2Ne5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 09:34:57 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3889 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344184AbhI2Nez (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 09:34:55 -0400
Received: from fraeml734-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HKHL31CWlz67mcQ;
        Wed, 29 Sep 2021 21:30:03 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml734-chm.china.huawei.com (10.206.15.215) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 15:33:11 +0200
Received: from [10.47.26.77] (10.47.26.77) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Wed, 29 Sep
 2021 14:33:10 +0100
Subject: Re: [PATCH v4 12/13] blk-mq: Use shared tags for shared sbitmap
 support
From:   John Garry <john.garry@huawei.com>
To:     Hannes Reinecke <hare@suse.de>, <axboe@kernel.dk>
CC:     <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <ming.lei@redhat.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>
References: <1632472110-244938-1-git-send-email-john.garry@huawei.com>
 <1632472110-244938-13-git-send-email-john.garry@huawei.com>
 <9dd771bb-9e45-ecd2-d8e4-93c6e9cb9b59@suse.de>
 <49947654-591f-c686-5908-7938ab653e6d@huawei.com>
Message-ID: <202668f9-8cf8-1ad7-414f-463353115eda@huawei.com>
Date:   Wed, 29 Sep 2021 14:36:07 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <49947654-591f-c686-5908-7938ab653e6d@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.47.26.77]
X-ClientProxiedBy: lhreml714-chm.china.huawei.com (10.201.108.65) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 24/09/2021 11:39, John Garry wrote:
> + Kashyap
> 
> On 24/09/2021 11:23, Hannes Reinecke wrote:
>> On 9/24/21 10:28 AM, John Garry wrote:
>>> Currently we use separate sbitmap pairs and active_queues atomic_t for
>>> shared sbitmap support.
>>>
>>> However a full sets of static requests are used per HW queue, which is
>>> quite wasteful, considering that the total number of requests usable at
>>> any given time across all HW queues is limited by the shared sbitmap 
>>> depth.
>>>
>>> As such, it is considerably more memory efficient in the case of shared
>>> sbitmap to allocate a set of static rqs per tag set or request queue, 
>>> and
>>> not per HW queue.
>>>
>>> So replace the sbitmap pairs and active_queues atomic_t with a shared
>>> tags per tagset and request queue, which will hold a set of shared 
>>> static
>>> rqs.
>>>
>>> Since there is now no valid HW queue index to be passed to the 
>>> blk_mq_ops
>>> .init and .exit_request callbacks, pass an invalid index token. This
>>> changes the semantics of the APIs, such that the callback would need to
>>> validate the HW queue index before using it. Currently no user of shared
>>> sbitmap actually uses the HW queue index (as would be expected).
>>>
>>> Continue to use term "shared sbitmap" for now, as the meaning is known.
>>>
>>> Signed-off-by: John Garry <john.garry@huawei.com>
>>> ---
>>>   block/blk-mq-sched.c   | 82 ++++++++++++++++++-------------------
>>>   block/blk-mq-tag.c     | 61 ++++++++++------------------
>>>   block/blk-mq-tag.h     |  6 +--
>>>   block/blk-mq.c         | 91 +++++++++++++++++++++++-------------------
>>>   block/blk-mq.h         |  5 ++-
>>>   include/linux/blk-mq.h | 15 ++++---
>>>   include/linux/blkdev.h |  3 +-
>>>   7 files changed, 125 insertions(+), 138 deletions(-)
>>>
>> The overall idea to keep the full request allocation per queue was to 
>> ensure memory locality for the requests themselves.
>> When moving to a shared request structure we obviously loose that 
>> feature.
>>
>> But I'm not sure if that matters here; the performance impact might be 
>> too small to be measurable, seeing that we'll be most likely bound by 
>> hardware latencies anyway.
>>
>> Nevertheless: have you tested for performance regressions with this 
>> patchset?
> 
> I have tested relatively lower rates, like ~450K IOPS, without any 
> noticeable regression.
> 
>> I'm especially thinking of Kashyaps high-IOPS megaraid setup; if there 
>> is a performance impact that'll be likely scenario where we can 
>> measure it.
>>
> 
> I can test higher rates, like 2M IOPS, when I get access to the HW.
> 
> @Kashyap, Any chance you can help test performance here?
> 
>> But even if there is a performance impact this patchset might be 
>> worthwhile, seeing that it'll reduce the memory footprint massively.
> 
> Sure, I don't think that minor performance improvements can justify the 
> excessive memory.
> 

JFYI, with 6x SAS SSDs on my arm64 board, I see:

Before (5.15-rc2 baseline):
none: 445K IOPs, mq-deadline: 418K IOPs (fio read)

After:
none: 442K IOPs, mq-deadline: 407K IOPs (fio read)

So only a marginal drop there for mq-deadline.

I'll try my 12x SAS SSD setup when I get a chance. Kashyap is kindly 
also testing.

Thanks
