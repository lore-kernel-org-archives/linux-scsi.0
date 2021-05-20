Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D52ECC43460
	for <linux-scsi@archiver.kernel.org>; Thu, 20 May 2021 16:42:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3D8661019
	for <linux-scsi@archiver.kernel.org>; Thu, 20 May 2021 16:42:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234566AbhETQnu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 May 2021 12:43:50 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4704 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232565AbhETQnu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 May 2021 12:43:50 -0400
Received: from dggems704-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FmFnk0gmmz16QXk;
        Fri, 21 May 2021 00:39:38 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 dggems704-chm.china.huawei.com (10.3.19.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 21 May 2021 00:42:24 +0800
Received: from [10.47.87.246] (10.47.87.246) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Thu, 20 May
 2021 17:42:22 +0100
Subject: Re: [PATCH] scsi: core: Cap shost cmd_per_lun at can_queue
To:     Bart Van Assche <bvanassche@acm.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ming.lei@redhat.com>
References: <1621434662-173079-1-git-send-email-john.garry@huawei.com>
 <988856ad-8e89-97e4-f8fe-54c1ca1b4a93@acm.org>
From:   John Garry <john.garry@huawei.com>
Message-ID: <a838c8e2-6513-a266-f145-5bcaed0a4f96@huawei.com>
Date:   Thu, 20 May 2021 17:41:15 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <988856ad-8e89-97e4-f8fe-54c1ca1b4a93@acm.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.87.246]
X-ClientProxiedBy: lhreml745-chm.china.huawei.com (10.201.108.195) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 20/05/2021 16:57, Bart Van Assche wrote:
> On 5/19/21 7:31 AM, John Garry wrote:
>> Function sdev_store_queue_depth() enforces that the sdev queue depth cannot
>> exceed Shost.can_queue.
>>
>> The sdev initial value comes from shost cmd_per_lun.
>>
>> However, the LLDD may still set cmd_per_lun > can_queue, which leads to an
>> initial sdev queue depth greater than can_queue.
>>
>> Such an issue was reported in [0], which caused a hang. That has since
>> been fixed in commit fc09acb7de31 ("scsi: scsi_debug: Fix cmd_per_lun,
>> set to max_queue").
>>
>> Stop this possibly happening for other drivers by capping
>> shost.cmd_per_lun at shost.can_queue.
>>
>> [0] https://lore.kernel.org/linux-scsi/YHaez6iN2HHYxYOh@T590/
>>
>> Signed-off-by: John Garry <john.garry@huawei.com>
>> ---
>> Earlier patch was in https://lore.kernel.org/linux-scsi/1618848384-204144-1-git-send-email-john.garry@huawei.com/
>>
>> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
>> index ba72bd4202a2..624e2582c3df 100644
>> --- a/drivers/scsi/hosts.c
>> +++ b/drivers/scsi/hosts.c
>> @@ -220,6 +220,9 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
>>   		goto fail;
>>   	}
>>   
>> +	shost->cmd_per_lun = min_t(short, shost->cmd_per_lun,
>> +				   shost->can_queue);
>> +
>>   	error = scsi_init_sense_cache(shost);
>>   	if (error)
>>   		goto fail;
> 
> 

Hi Bart,

> In SCSI header files a mix of int, short and unsigned int is used for
> cmd_per_lun and can_queue. How about changing the types of these two
> member variables in include/scsi/*h into u16?
I don't mind doing that, but is there any requirement for can_queue to 
not be limited to 16b?

It seems intentional that can_queue is int and cmd_per_lun is short.

As an aside, if short is 16b, it does not even seem to have efficient 
packing on Scsi_host today (although we can move things around):

int can_queue;
short cmd_per_lun;
short unsigned int sg_tablesize;
short unsigned int sg_prot_tablesize;
/* 16b hole */
unsigned int max_sectors;

> 
> Anyway:
> 
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> 

thanks!

> 
> 
> .
> 

