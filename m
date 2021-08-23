Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41CE0C4338F
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Aug 2021 13:17:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BAF461373
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Aug 2021 13:17:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237254AbhHWNSd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Aug 2021 09:18:33 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:15205 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235966AbhHWNSc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Aug 2021 09:18:32 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4GtXpP3PTkz1CZrc;
        Mon, 23 Aug 2021 21:17:17 +0800 (CST)
Received: from dggema773-chm.china.huawei.com (10.1.198.217) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 23 Aug 2021 21:17:48 +0800
Received: from [10.174.179.2] (10.174.179.2) by dggema773-chm.china.huawei.com
 (10.1.198.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Mon, 23
 Aug 2021 21:17:47 +0800
From:   Li Jinlin <lijinlin3@huawei.com>
Subject: Re: [PATCH v2] scsi: core: Fix hang of freezing queue between
 blocking and running device
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <john.garry@huawei.com>, <bvanassche@acm.org>,
        <qiulaibin@huawei.com>, <linfeilong@huawei.com>,
        <wubo40@huawei.com>
References: <20210809141308.3700854-1-lijinlin3@huawei.com>
 <8d0583de-f818-1be7-ac08-c84cfd5988f6@huawei.com>
Message-ID: <30fef732-a719-8c41-b8bf-951d6cfdf243@huawei.com>
Date:   Mon, 23 Aug 2021 21:17:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <8d0583de-f818-1be7-ac08-c84cfd5988f6@huawei.com>
Content-Type: text/plain; charset="gbk"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.2]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggema773-chm.china.huawei.com (10.1.198.217)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 2021/8/17 16:46, Li Jinlin wrote:
> On 2021/8/9 22:13, Li Jinlin wrote:
>> From: Li Jinlin <lijinlin3@huawei.com>
>>
>> We found a hang issue, the test steps are as follows:
>>   1. blocking device via scsi_device_set_state()
>>   2. dd if=/dev/sda of=/mnt/t.log bs=1M count=10
>>   3. echo none > /sys/block/sda/queue/scheduler
>>   4. echo "running" >/sys/block/sda/device/state
>>
>> Step 3 and 4 should finish this work after step 4, but they hangs.
>>
>>   CPU#0               CPU#1                CPU#2
>>   ---------------     ----------------     ----------------
>>                                            Step 1: blocking device
>>
>>                                            Step 2: dd xxxx
>>                                                   ^^^^^^ get request
>>                                                          q_usage_counter++
>>
>>                       Step 3: switching scheculer
>>                       elv_iosched_store
>>                         elevator_switch
>>                           blk_mq_freeze_queue
>>                             blk_freeze_queue
>>                               > blk_freeze_queue_start
>>                                 ^^^^^^ mq_freeze_depth++
>>
>>                               > blk_mq_run_hw_queues
>>                                 ^^^^^^ can't run queue when dev blocked
>>
>>                               > blk_mq_freeze_queue_wait
>>                                 ^^^^^^ Hang here!!!
>>                                        wait q_usage_counter==0
>>
>>   Step 4: running device
>>   store_state_field
>>     scsi_rescan_device
>>       scsi_attach_vpd
>>         scsi_vpd_inquiry
>>           __scsi_execute
>>             blk_get_request
>>               blk_mq_alloc_request
>>                 blk_queue_enter
>>                 ^^^^^^ Hang here!!!
>>                        wait mq_freeze_depth==0
>>
>>     blk_mq_run_hw_queues
>>     ^^^^^^ dispatch IO, q_usage_counter will reduce to zero
>>
>>                             blk_mq_unfreeze_queue
>>                             ^^^^^ mq_freeze_depth--
>>
>> Step 3 and 4 wait for each other.
>>
>> To fix this, we need to run queue before rescanning device when the device
>> state changes to SDEV_RUNNING.
>>
>> Fixes: f0f82e2476f6 ("scsi: core: Fix capacity set to zero after offlinining device")
>> Signed-off-by: Li Jinlin <lijinlin3@huawei.com>
>> Signed-off-by: Qiu Laibin <qiulaibin@huawei.com>
>> ---
>> changes since v1 send with Message-ID:
>> 20210805143231.1713299-1-lijinlin3@huawei.com
>>
>>  - Modify the subject to make it distinct
>>  - Modify the message to fix typo and make it distinct
>>  - Reduce the number of SOB
>>
>>  drivers/scsi/scsi_sysfs.c | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
>> index c3a710bceba0..aa701582c950 100644
>> --- a/drivers/scsi/scsi_sysfs.c
>> +++ b/drivers/scsi/scsi_sysfs.c
>> @@ -809,12 +809,12 @@ store_state_field(struct device *dev, struct device_attribute *attr,
>>  	ret = scsi_device_set_state(sdev, state);
>>  	/*
>>  	 * If the device state changes to SDEV_RUNNING, we need to
>> -	 * rescan the device to revalidate it, and run the queue to
>> -	 * avoid I/O hang.
>> +	 * run the queue to avoid I/O hang, and rescan the device
>> +	 * to revalidate it.
>>  	 */
>>  	if (ret == 0 && state == SDEV_RUNNING) {
>> -		scsi_rescan_device(dev);
>>  		blk_mq_run_hw_queues(sdev->request_queue, true);
>> +		scsi_rescan_device(dev);
>>  	}
>>  	mutex_unlock(&sdev->state_mutex);
>>  
>>
> 
> Ping.
> 
> Thanks,
> Li Jinlin
> 
Hello Guys,

Ping again.

Otherwise, I think that rescan device is not necessary when the device
state changes from blocked to running. Run queue is not necessary either
when the device state changes from offline to running.

I want to add judgment of the old device state before rescanning device
or running queue.

I'd like to know your opinions.

Thanks,
Li Jinlin





