Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17B5AC433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 10:19:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0518611ED
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 10:19:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235520AbhD0KUb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 06:20:31 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:2924 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238178AbhD0KSy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Apr 2021 06:18:54 -0400
Received: from fraeml743-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4FTyB14YMhz73dSD;
        Tue, 27 Apr 2021 18:07:37 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml743-chm.china.huawei.com (10.206.15.224) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 27 Apr 2021 12:18:09 +0200
Received: from [10.47.94.234] (10.47.94.234) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 27 Apr
 2021 11:18:08 +0100
Subject: Re: [bug report] shared tags causes IO hang and performance drop
To:     Ming Lei <ming.lei@redhat.com>
CC:     Kashyap Desai <kashyap.desai@broadcom.com>,
        <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Hannes Reinecke <hare@suse.com>
References: <0c85fe52-ebc7-68b3-2dbe-dfad5d604346@huawei.com>
 <c1d5abaa-c460-55f8-5351-16f09d6aa81f@huawei.com> <YIbS1dgSYrsAeGvZ@T590>
 <55743a51-4d6f-f481-cebf-e2af9c657911@huawei.com> <YIbkX2G0+dp3PV+u@T590>
 <9ad15067-ba7b-a335-ae71-8c4328856b91@huawei.com> <YIdTyyVE5azlYwtO@T590>
 <ab83eec4-20f1-ad74-7f43-52a4a87a8aa9@huawei.com> <YIfVVRheF9ZWjzbh@T590>
 <cb81d990-e5a6-49b1-5d96-8079a80c73f5@huawei.com> <YIfe+mpcV17XsHuL@T590>
From:   John Garry <john.garry@huawei.com>
Message-ID: <440dfcfc-1a2c-bd98-1161-cec4d78c6dfc@huawei.com>
Date:   Tue, 27 Apr 2021 11:15:09 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <YIfe+mpcV17XsHuL@T590>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.94.234]
X-ClientProxiedBy: lhreml745-chm.china.huawei.com (10.201.108.195) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 27/04/2021 10:52, Ming Lei wrote:
>> BTW, for the performance issue which Yanhui witnessed with megaraid sas, do
>> you think it may because of the IO sched tags issue of total sched tag depth
>> growing vs driver tags?
> I think it is highly possible. Will you work a patch to convert to
> per-request-queue sched tag?
> 

Sure, I'm just hacking now to see what difference it can make to 
performance. Early results look promising...

>> Are there lots of LUNs? I can imagine that megaraid
>> sas has much larger can_queue than scsi_debug:)
> No, there are just two LUNs, the 1st LUN is one commodity SSD(queue
> depth is 32) and the performance issue is reported on this LUN, another is one
> HDD(queue depth is 256) which is root disk, but the megaraid host tag depth is
> 228, another weird setting. But the issue still can be reproduced after we set
> 2nd LUN's depth as 64 for avoiding driver tag contention.
> 
> 

BTW, one more thing which Kashyap and I looked at when initially 
developing the hostwide tag support was the wait struct usage in tag 
exhaustion scenario:

https://lore.kernel.org/linux-block/ecaeccf029c6fe377ebd4f30f04df9f1@mail.gmail.com/

IIRC, we looked at a "hostwide" wait_index - it didn't seem to make a 
difference then, and we didn't end up make any changes here, but still 
worth remembering.

Thanks,
John
