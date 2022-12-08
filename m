Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4692C3A5A7
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Dec 2022 06:56:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbiLHG4b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Dec 2022 01:56:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiLHG43 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Dec 2022 01:56:29 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 336A1716C2
        for <linux-scsi@vger.kernel.org>; Wed,  7 Dec 2022 22:56:28 -0800 (PST)
Received: from canpemm500004.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NSPwH4gYdzqSyB;
        Thu,  8 Dec 2022 14:52:15 +0800 (CST)
Received: from [10.174.179.14] (10.174.179.14) by
 canpemm500004.china.huawei.com (7.192.104.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 8 Dec 2022 14:56:26 +0800
Subject: Re: [PATCH 2/6] scsi: libsas: delete wrapper function
 sas_discover_end_dev()
To:     John Garry <john.g.garry@oracle.com>, <martin.petersen@oracle.com>,
        <jejb@linux.ibm.com>
CC:     <linux-scsi@vger.kernel.org>, <hare@suse.com>, <hch@lst.de>,
        <bvanassche@acm.org>, <jinpu.wang@cloud.ionos.com>,
        <damien.lemoal@opensource.wdc.com>
References: <20221204081643.3835966-1-yanaijie@huawei.com>
 <20221204081643.3835966-3-yanaijie@huawei.com>
 <8729c1c5-c306-1fdc-ff30-174740be97c4@oracle.com>
From:   Jason Yan <yanaijie@huawei.com>
Message-ID: <7d7baa08-903d-7f04-a7d9-56a473cfa220@huawei.com>
Date:   Thu, 8 Dec 2022 14:56:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <8729c1c5-c306-1fdc-ff30-174740be97c4@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.14]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500004.china.huawei.com (7.192.104.92)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022/12/5 16:57, John Garry wrote:
> On 04/12/2022 08:16, Jason Yan wrote:
>> After commit 0558f33c06bb ("scsi: libsas: direct call probe and 
>> destruct")
>> this function is only a wrapper of sas_notify_lldd_dev_found(). And the
>> function name does not reflect the real purpose of this function now.
> 
> Why is this? Maybe add "dev_found" to the name could help.
> 
>> Remove it and call sas_notify_lldd_dev_found() directly. The log is also
>> changed accordingly.
>>
>> Cc: John Garry <john.g.garry@oracle.com>
>> Signed-off-by: Jason Yan <yanaijie@huawei.com>
>> ---
>>   drivers/scsi/libsas/sas_discover.c | 13 +------------
>>   drivers/scsi/libsas/sas_expander.c |  4 ++--
>>   include/scsi/libsas.h              |  1 -
>>   3 files changed, 3 insertions(+), 15 deletions(-)
>>
>> diff --git a/drivers/scsi/libsas/sas_discover.c 
>> b/drivers/scsi/libsas/sas_discover.c
>> index d5bc1314c341..efc6bf95bb67 100644
>> --- a/drivers/scsi/libsas/sas_discover.c
>> +++ b/drivers/scsi/libsas/sas_discover.c
>> @@ -269,17 +269,6 @@ static void sas_resume_devices(struct work_struct 
>> *work)
>>       sas_resume_sata(port);
>>   }
>> -/**
>> - * sas_discover_end_dev - discover an end device (SSP, etc)
>> - * @dev: pointer to domain device of interest
>> - *
>> - * See comment in sas_discover_sata().
>> - */
>> -int sas_discover_end_dev(struct domain_device *dev)
>> -{
>> -    return sas_notify_lldd_dev_found(dev);
>> -}
>> -
>>   /* ---------- Device registration and unregistration ---------- */
>>   void sas_free_device(struct kref *kref)
>> @@ -447,7 +436,7 @@ static void sas_discover_domain(struct work_struct 
>> *work)
>>       switch (dev->dev_type) {
>>       case SAS_END_DEVICE:
>> -        error = sas_discover_end_dev(dev);
>> +        error = sas_notify_lldd_dev_found(dev);
> 
> For me, personally, I prefer consistent API name, like 
> sas_discover_end_dev() and sas_discover_sata(), even if 
> sas_discover_end_dev() is just a wrapper.

Fair enough. I was just thinking that this API name is not proper now
because it is only notifying the lldd.

I will drop this patch if you insist.

Thanks,
Jason
