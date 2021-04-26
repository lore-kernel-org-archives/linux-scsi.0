Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD230C433B4
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 10:56:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D51E601FD
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 10:56:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233006AbhDZK51 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Apr 2021 06:57:27 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:2915 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232266AbhDZK50 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Apr 2021 06:57:26 -0400
Received: from fraeml736-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4FTM516nkrz73dSS;
        Mon, 26 Apr 2021 18:46:13 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml736-chm.china.huawei.com (10.206.15.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 26 Apr 2021 12:56:42 +0200
Received: from [10.47.89.145] (10.47.89.145) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Mon, 26 Apr
 2021 11:56:41 +0100
Subject: Re: [bug report] shared tags causes IO hang and performance drop
From:   John Garry <john.garry@huawei.com>
To:     Ming Lei <ming.lei@redhat.com>
CC:     Kashyap Desai <kashyap.desai@broadcom.com>,
        <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Hannes Reinecke <hare@suse.com>
References: <YHaez6iN2HHYxYOh@T590>
 <9a6145a5-e6ac-3d33-b52a-0823bfc3b864@huawei.com>
 <cb326d404c6e0785d03a7dfadc42832c@mail.gmail.com> <YHbOOfGNHwO4SMS7@T590>
 <87ceccf2-287b-9bd1-899a-f15026c9e65b@huawei.com> <YHe3M62agQET6o6O@T590>
 <0c85fe52-ebc7-68b3-2dbe-dfad5d604346@huawei.com>
Message-ID: <c1d5abaa-c460-55f8-5351-16f09d6aa81f@huawei.com>
Date:   Mon, 26 Apr 2021 11:53:45 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <0c85fe52-ebc7-68b3-2dbe-dfad5d604346@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.47.89.145]
X-ClientProxiedBy: lhreml702-chm.china.huawei.com (10.201.108.51) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 23/04/2021 09:43, John Garry wrote:
>> 1) randread test on ibm-x3850x6[*] with deadline
>>
>>                |IOPS    | FIO CPU util
>> ------------------------------------------------
>> hosttags      | 94k    | usr=1.13%, sys=14.75%
>> ------------------------------------------------
>> non hosttags  | 124k   | usr=1.12%, sys=10.65%,
>>
> 
> Getting these results for mq-deadline:
> 
> hosttags
> 100K cpu 1.52 4.47
> 
> non-hosttags
> 109K cpu 1.74 5.49
> 
> So I still don't see the same CPU usage increase for hosttags.
> 
> But throughput is down, so at least I can check on that...
> 
>>
>> 2) randread test on ibm-x3850x6[*] with none
>>                |IOPS    | FIO CPU util
>> ------------------------------------------------
>> hosttags      | 120k   | usr=0.89%, sys=6.55%
>> ------------------------------------------------
>> non hosttags  | 121k   | usr=1.07%, sys=7.35%
>> ------------------------------------------------
>>
> 
> Here I get:
> hosttags
> 113K cpu 2.04 5.83
> 
> non-hosttags
> 108K cpu 1.71 5.05

Hi Ming,

One thing I noticed is that for the non-hosttags scenario is that I am 
hitting the IO scheduler tag exhaustion path in blk_mq_get_tag() often; 
here's some perf output:

|--15.88%--blk_mq_submit_bio
|     |
|     |--11.27%--__blk_mq_alloc_request
|     |      |
|     |       --11.19%--blk_mq_get_tag
|     |      |
|     |      |--6.00%--__blk_mq_delay_run_hw_queue
|     |      |     |

...

|     |      |
|     |      |--3.29%--io_schedule
|     |      |     |

....

|     |      |     |
|     |      |     --1.32%--io_schedule_prepare
|     |      |

...

|     |      |
|     |      |--0.60%--sbitmap_finish_wait
|     |      |
      --0.56%--sbitmap_get

I don't see this for hostwide tags - this may be because we have 
multiple hctx, and the IO sched tags are per hctx, so less chance of 
exhaustion. But this is not from hostwide tags specifically, but for 
multiple HW queues in general. As I understood, sched tags were meant to 
be per request queue, right? I am reading this correctly?

I can barely remember some debate on this, but could not find the 
thread. Hannes did have a patch related to topic, but was dropped:
https://lore.kernel.org/linux-scsi/20191202153914.84722-7-hare@suse.de/#t

Thanks,
John



