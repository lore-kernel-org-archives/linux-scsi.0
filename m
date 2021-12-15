Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 757C7C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Dec 2021 07:59:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240655AbhLOH7Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Dec 2021 02:59:24 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:15742 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235592AbhLOH7X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Dec 2021 02:59:23 -0500
Received: from dggeme756-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4JDSHV16bDzZdcL;
        Wed, 15 Dec 2021 15:56:22 +0800 (CST)
Received: from [127.0.0.1] (10.40.193.166) by dggeme756-chm.china.huawei.com
 (10.3.19.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.20; Wed, 15
 Dec 2021 15:59:21 +0800
Subject: Re: [PATCH 11/15] scsi: libsas: Refactor out
 sas_queue_deferred_work()
To:     John Garry <john.garry@huawei.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
References: <1637117108-230103-1-git-send-email-chenxiang66@hisilicon.com>
 <1637117108-230103-12-git-send-email-chenxiang66@hisilicon.com>
 <29a7ccb2-9b25-5da7-2a3e-609718593ecd@huawei.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>
From:   "chenxiang (M)" <chenxiang66@hisilicon.com>
Message-ID: <148b57c3-6c24-aae7-e5c9-b4aee7509cdf@hisilicon.com>
Date:   Wed, 15 Dec 2021 15:59:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <29a7ccb2-9b25-5da7-2a3e-609718593ecd@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.40.193.166]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggeme756-chm.china.huawei.com (10.3.19.102)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



在 2021/12/13 19:20, John Garry 写道:
> Please consider these:
>
> On 17/11/2021 02:45, chenxiang wrote:
>
> I'd have "scsi: libsas: Refactor sas_queue_deferred_work()"

Ok, i will change it.

>
>> From: Xiang Chen <chenxiang66@hisilicon.com>
>>
>> In the 2rd part of function __sas_drain_work, it queues defer work. 
>> And it
>> will be used in other places, so refactor out sas_queue_deferred_work().
>
> The second part of the function __sas_drain_work() queues the deferred 
> work. This functionality would be duplicated in other places, so 
> factor out into sas_queue_deferred_work().

I will rewrite them in next verison.

>
> Thanks,
> John
>
>>
>> Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
>> Reviewed-by: John Garry <john.garry@huawei.com>
>> ---
>>   drivers/scsi/libsas/sas_event.c    | 25 ++++++++++++++-----------
>>   drivers/scsi/libsas/sas_internal.h |  1 +
>>   2 files changed, 15 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/scsi/libsas/sas_event.c 
>> b/drivers/scsi/libsas/sas_event.c
>> index af605620ea13..01e544ca518a 100644
>> --- a/drivers/scsi/libsas/sas_event.c
>> +++ b/drivers/scsi/libsas/sas_event.c
>> @@ -41,12 +41,23 @@ static int sas_queue_event(int event, struct 
>> sas_work *work,
>>       return rc;
>>   }
>>   -
>> -void __sas_drain_work(struct sas_ha_struct *ha)
>> +void sas_queue_deferred_work(struct sas_ha_struct *ha)
>>   {
>>       struct sas_work *sw, *_sw;
>>       int ret;
>>   +    spin_lock_irq(&ha->lock);
>> +    list_for_each_entry_safe(sw, _sw, &ha->defer_q, drain_node) {
>> +        list_del_init(&sw->drain_node);
>> +        ret = sas_queue_work(ha, sw);
>> +        if (ret != 1)
>> +            sas_free_event(to_asd_sas_event(&sw->work));
>> +    }
>> +    spin_unlock_irq(&ha->lock);
>> +}
>> +
>> +void __sas_drain_work(struct sas_ha_struct *ha)
>> +{
>>       set_bit(SAS_HA_DRAINING, &ha->state);
>>       /* flush submitters */
>>       spin_lock_irq(&ha->lock);
>> @@ -55,16 +66,8 @@ void __sas_drain_work(struct sas_ha_struct *ha)
>>       drain_workqueue(ha->event_q);
>>       drain_workqueue(ha->disco_q);
>>   -    spin_lock_irq(&ha->lock);
>>       clear_bit(SAS_HA_DRAINING, &ha->state);
>> -    list_for_each_entry_safe(sw, _sw, &ha->defer_q, drain_node) {
>> -        list_del_init(&sw->drain_node);
>> -        ret = sas_queue_work(ha, sw);
>> -        if (ret != 1)
>> -            sas_free_event(to_asd_sas_event(&sw->work));
>> -
>> -    }
>> -    spin_unlock_irq(&ha->lock);
>> +    sas_queue_deferred_work(ha);
>>   }
>>     int sas_drain_work(struct sas_ha_struct *ha)
>> diff --git a/drivers/scsi/libsas/sas_internal.h 
>> b/drivers/scsi/libsas/sas_internal.h
>> index ad9764a976c3..acd515c01861 100644
>> --- a/drivers/scsi/libsas/sas_internal.h
>> +++ b/drivers/scsi/libsas/sas_internal.h
>> @@ -57,6 +57,7 @@ void sas_unregister_ports(struct sas_ha_struct 
>> *sas_ha);
>>     void sas_disable_revalidation(struct sas_ha_struct *ha);
>>   void sas_enable_revalidation(struct sas_ha_struct *ha);
>> +void sas_queue_deferred_work(struct sas_ha_struct *ha);
>>   void __sas_drain_work(struct sas_ha_struct *ha);
>>     void sas_deform_port(struct asd_sas_phy *phy, int gone);
>>
>
>
> .
>


