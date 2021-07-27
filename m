Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E81EC4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jul 2021 12:08:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53B8861A38
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jul 2021 12:08:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236493AbhG0MIp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Jul 2021 08:08:45 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:7880 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231868AbhG0MIp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Jul 2021 08:08:45 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GYwTQ3j1dz80PK;
        Tue, 27 Jul 2021 20:04:58 +0800 (CST)
Received: from dggema773-chm.china.huawei.com (10.1.198.217) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 27 Jul 2021 20:08:42 +0800
Received: from [10.174.179.2] (10.174.179.2) by dggema773-chm.china.huawei.com
 (10.1.198.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Tue, 27
 Jul 2021 20:08:41 +0800
Subject: Re: [PATCH v2] scsi: Fix the issue that the disk capacity set to zero
To:     John Garry <john.garry@huawei.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <bvanassche@acm.org>, <yanaijie@huawei.com>,
        <linfeilong@huawei.com>, <wubo40@huawei.com>
References: <20210727034455.1494960-1-lijinlin3@huawei.com>
 <21370ef0-88c0-e0b7-6099-4e3ee7af502f@huawei.com>
From:   lijinlin <lijinlin3@huawei.com>
Message-ID: <b507879a-8bfe-ed3e-dba6-328d349d2f1f@huawei.com>
Date:   Tue, 27 Jul 2021 20:08:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <21370ef0-88c0-e0b7-6099-4e3ee7af502f@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.2]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggema773-chm.china.huawei.com (10.1.198.217)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/7/27 16:48, John Garry wrote:
> On 27/07/2021 04:44, lijinlin3@huawei.com wrote:
>> From: lijinlin <lijinlin3@huawei.com>
>>
>> After add physical volumes to a volume group through vgextend, kernel
>> will rescan partitions, which will read the capacity of the device.
>> If the device status is set to offline through sysfs at this time,
>> read capacity command will return a result which the host byte is
>> DID_NO_CONNECT, the capacity of the device will be set to zero in
>> read_capacity_error(). However, the capacity of the device can't be
>> reread after reset the device status to running, is still zero.
>>
>> Fix this issue by rescan device when the device state changes to
>> SDEV_RUNNING.
>>
>> Signed-off-by: lijinlin <lijinlin3@huawei.com>
>> Signed-off-by: Wu Bo <wubo40@huawei.com>
>> ---
>>   drivers/scsi/scsi_sysfs.c | 9 ++++++---
>>   1 file changed, 6 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
>> index 32489d25158f..ae9bfc658203 100644
>> --- a/drivers/scsi/scsi_sysfs.c
>> +++ b/drivers/scsi/scsi_sysfs.c
>> @@ -807,11 +807,14 @@ store_state_field(struct device *dev, struct device_attribute *attr,
>>       mutex_lock(&sdev->state_mutex);
>>       ret = scsi_device_set_state(sdev, state);
>>       /*
>> -     * If the device state changes to SDEV_RUNNING, we need to run
>> -     * the queue to avoid I/O hang.
>> +     * If the device state changes to SDEV_RUNNING, we need to
>> +     * rescan the device to revalidate it, and run the queue to
>> +     * avoid I/O hang.
>>        */
>> -    if (ret == 0 && state == SDEV_RUNNING)
>> +    if (ret == 0 && state == SDEV_RUNNING) {
>> +        scsi_rescan_device(dev);
>>           blk_mq_run_hw_queues(sdev->request_queue, true);
> 
> I am wondering does any of this need to be done with the device state mutex held?
> 
> Thanks,
> John

To ensure that the rescan is invoked only in the running state.

Thanks.

> 
>> +    }
>>       mutex_unlock(&sdev->state_mutex);
>>         return ret == 0 ? count : -EINVAL;
>>
> 
> .
