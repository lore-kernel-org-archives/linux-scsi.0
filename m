Return-Path: <SRS0=Uo2m=ZV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BF3CC432C3
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Nov 2019 09:21:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD507217D9
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Nov 2019 09:21:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbfK2JVr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Nov 2019 04:21:47 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2135 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725892AbfK2JVr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 29 Nov 2019 04:21:47 -0500
Received: from lhreml709-cah.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id 44F2BD6623D54E59458F;
        Fri, 29 Nov 2019 09:21:45 +0000 (GMT)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 lhreml709-cah.china.huawei.com (10.201.108.32) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Fri, 29 Nov 2019 09:21:44 +0000
Received: from [127.0.0.1] (10.202.226.46) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Fri, 29 Nov
 2019 09:21:44 +0000
Subject: Re: [PATCH 4/8] blk-mq: Facilitate a shared sbitmap per tagset
To:     Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        "Bart van Assche" <bvanassche@acm.org>,
        <linux-scsi@vger.kernel.org>, <linux-block@vger.kernel.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>
References: <20191126091416.20052-1-hare@suse.de>
 <20191126091416.20052-5-hare@suse.de> <20191126110527.GE32135@ming.t460p>
 <8a10e2f0-bbdc-8b47-a118-0fd7837ef44e@suse.de>
 <20191126155445.GB17602@ming.t460p>
 <5561a568-a559-fee8-83aa-449befedae47@suse.de>
 <20191129002540.GA1829@ming.t460p>
From:   John Garry <john.garry@huawei.com>
Message-ID: <83689a0b-59a8-5182-d2cf-57119cba758d@huawei.com>
Date:   Fri, 29 Nov 2019 09:21:43 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20191129002540.GA1829@ming.t460p>
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

On 29/11/2019 00:25, Ming Lei wrote:
> On Wed, Nov 27, 2019 at 06:02:54PM +0100, Hannes Reinecke wrote:
>> On 11/26/19 4:54 PM, Ming Lei wrote:
>>> On Tue, Nov 26, 2019 at 12:27:50PM +0100, Hannes Reinecke wrote:
>>>> On 11/26/19 12:05 PM, Ming Lei wrote:
>> [ .. ]
>>>>>   From performance viewpoint, all hctx belonging to this request queue should
>>>>> share one scheduler tagset in case of BLK_MQ_F_TAG_HCTX_SHARED, cause
>>>>> driver tag queue depth isn't changed.
>>>>>
>>>> Hmm. Now you get me confused.
>>>> In an earlier mail you said:
>>>>
>>>>> This kind of sharing is wrong, sched tags should be request
>>>>> queue wide instead of tagset wide, and each request queue has
>>>>> its own & independent scheduler queue.
>>>>
>>>> as in v2 we _had_ shared scheduler tags, too.
>>>> Did I misread your comment above?
>>>
>>> Yes, what I meant is that we can't share sched tags in tagset wide.
>>>
>>> Now I mean we should share sched tags among all hctxs in same request
>>> queue, and I believe I have described it clearly.
>>>
>> I wonder if this makes a big difference; in the end, scheduler tags are
>> primarily there to allow the scheduler to queue more requests, and
>> potentially merge them. These tags are later converted into 'real' ones via
>> blk_mq_get_driver_tag(), and only then the resource limitation takes hold.
>> Wouldn't it be sufficient to look at the number of outstanding commands per
>> queue when getting a scheduler tag, and not having to implement yet another
>> bitmap?
> 
> Firstly too much((nr_hw_queues - 1) times) memory is wasted. Secondly IO
> latency could be increased by too deep scheduler queue depth. Finally CPU
> could be wasted in the retrying of running busy hw queue.
> 
> Wrt. driver tags, this patch may be worse, given the average limit for
> each LUN is reduced by (nr_hw_queues) times, see hctx_may_queue().
> 
> Another change is bt_wait_ptr(). Before your patches, there is single
> .wait_index, now the number of .wait_index is changed to nr_hw_queues.
> 
> Also the run queue number is increased a lot in SCSI's IO completion, see
> scsi_end_request().
> 
> Kashyap Desai has performance benchmark on fast megaraid SSD, and you can
> ask him to provide performance data for this patches.

On v2 series (which is effectively same as this one [it would be nice if 
we had per-patch versioning]), for hisi_sas_v3_hw we get about same 
performance as when we use the reply_map, about 3.0M IOPS vs 3.1M IOPS, 
respectively.

Without this, we get 700/800K IOPS. I don't know why the performance is 
so poor without. Only CPU0 serves the completion interrupts, which could 
explain it, but v2 hw can get > 800K IOPS with only 6x SSDs.

Thanks,
John
