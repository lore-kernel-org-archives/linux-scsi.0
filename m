Return-Path: <SRS0=+W3W=3D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED636C33CB3
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jan 2020 13:57:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C881824679
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jan 2020 13:57:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728739AbgANN5M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jan 2020 08:57:12 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2267 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726115AbgANN5M (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Jan 2020 08:57:12 -0500
Received: from lhreml707-cah.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id DD3B4B0CEBEA626A9554;
        Tue, 14 Jan 2020 13:57:09 +0000 (GMT)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 lhreml707-cah.china.huawei.com (10.201.108.48) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 14 Jan 2020 13:57:09 +0000
Received: from [127.0.0.1] (10.202.226.43) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Tue, 14 Jan
 2020 13:57:09 +0000
Subject: Re: [PATCH 09/11] megaraid_sas: switch fusion adapters to MQ
From:   John Garry <john.garry@huawei.com>
To:     Ming Lei <ming.lei@redhat.com>
CC:     Sumit Saxena <sumit.saxena@broadcom.com>,
        Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        <linux-block@vger.kernel.org>, Hannes Reinecke <hare@suse.com>
References: <20191202153914.84722-1-hare@suse.de>
 <20191202153914.84722-10-hare@suse.de>
 <CAL2rwxqjiRTuZ0ntfaHHzG7z-VmxRQCXYyxZeX9eDMrmX+dbGg@mail.gmail.com>
 <339f089f-26aa-1cbe-416b-67809ea6791f@huawei.com>
 <20200110020038.GB4501@ming.t460p>
 <1383a868-76d8-5c26-556d-7374e189b7ce@huawei.com>
Message-ID: <71cf0932-ab93-675c-4d7c-37889c003468@huawei.com>
Date:   Tue, 14 Jan 2020 13:57:08 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <1383a868-76d8-5c26-556d-7374e189b7ce@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.43]
X-ClientProxiedBy: lhreml729-chm.china.huawei.com (10.201.108.80) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/01/2020 12:09, John Garry wrote:
>>>>>
>>>>> Fusion adapters can steer completions to individual queues, and
>>>>> we now have support for shared host-wide tags.
>>>>> So we can enable multiqueue support for fusion adapters and
>>>>> drop the hand-crafted interrupt affinity settings.
>>>>
>>>> Hi Hannes,
>>>>
>>>> Ming Lei also proposed similar changes in megaraid_sas driver some
>>>> time back and it had resulted in performance drop-
>>>> https://patchwork.kernel.org/patch/10969511/
>>>>
>>>> So, we will do some performance tests with this patch and update you.
>>>>
>>>
>>> Hi Sumit,
>>>
>>> I was wondering if you had a chance to do this test yet?
>>>
>>> It would be good to know, so we can try to progress this work.
>>
>> Looks most of the comment in the following link isn't addressed:
>>
>> https://lore.kernel.org/linux-block/20191129002540.GA1829@ming.t460p/
> 
> OK, but I was waiting for results first, which I hoped would not take 
> too long. They weren't forgotten, for sure. Let me check them now.

Hi Ming,

I think that your questions here were related to the shared scheduler 
tags, which was Hannes' proposal (I initially had it in v2 series, but 
dropped it for v3).

I was just content to maintain the concept of shared driver tags.

Thanks,
John

> 
>>
>>> Firstly too much((nr_hw_queues - 1) times) memory is wasted. Secondly IO
>>> latency could be increased by too deep scheduler queue depth. Finally 
>>> CPU
>>> could be wasted in the retrying of running busy hw queue.
>>>
>>> Wrt. driver tags, this patch may be worse, given the average limit for
>>> each LUN is reduced by (nr_hw_queues) times, see hctx_may_queue().
>>>
>>> Another change is bt_wait_ptr(). Before your patches, there is single
>>> .wait_index, now the number of .wait_index is changed to nr_hw_queues.
>>>
>>> Also the run queue number is increased a lot in SCSI's IO completion, 
>>> see
>>> scsi_end_request().
>>
>> I guess memory waste won't be a blocker.
> 
> Yeah, that's a trade-off. And, as I remember, memory waste does not seem 
> extreme.
> 
>>
>> But it may not be one accepted behavior to reduce average active queue
>> depth for each LUN by nr_hw_queues times, meantime scheduler queue depth
>> is increased by nr_hw_queues times, compared with single queue.
>>
> 
> Thanks,
> John

