Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7546C433FE
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Nov 2022 10:43:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231249AbiKGKni (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Nov 2022 05:43:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231207AbiKGKng (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Nov 2022 05:43:36 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4B7E21B3
        for <linux-scsi@vger.kernel.org>; Mon,  7 Nov 2022 02:43:35 -0800 (PST)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4N5SWJ1XmLz15MRj;
        Mon,  7 Nov 2022 18:43:24 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 7 Nov 2022 18:43:33 +0800
Received: from [10.174.178.174] (10.174.178.174) by
 dggpemm500007.china.huawei.com (7.185.36.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 7 Nov 2022 18:43:33 +0800
Subject: Re: [PATCH] scsi: libsas: fix error handing in
 sas_ex_discover_expander()
To:     John Garry <john.g.garry@oracle.com>, <linux-scsi@vger.kernel.org>
CC:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <yangyingliang@huawei.com>
References: <20221104092734.4110745-1-yangyingliang@huawei.com>
 <1ea3837b-cb41-b0f8-6108-d515b1c4fecf@oracle.com>
From:   Yang Yingliang <yangyingliang@huawei.com>
Message-ID: <0137b64a-9aca-2c7f-2997-c2191189c319@huawei.com>
Date:   Mon, 7 Nov 2022 18:43:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <1ea3837b-cb41-b0f8-6108-d515b1c4fecf@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.174.178.174]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 2022/11/7 17:39, John Garry wrote:
> On 04/11/2022 09:27, Yang Yingliang wrote:
>> Check return value of sas_port_alloc() and sas_port_add() and handle
>> the error. If they fail, free the device and port, then returns NULL
>> instead of using BUG_ON().
>>
>> Fixes: 2908d778ab3e ("[SCSI] aic94xx: new driver")
>> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
>
> I already sent a patch to handle all errors here:
>
> https://lore.kernel.org/linux-scsi/1666693096-180008-7-git-send-email-john.garry@huawei.com/ 
>
Your patch is better to handle all of these, this patch can be dropped.

Thanks,
Yang
>
> Do you actually have a cascaded expander setup to test this?
>
>> ---
>>   drivers/scsi/libsas/sas_expander.c | 13 +++++++++++--
>>   1 file changed, 11 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/libsas/sas_expander.c 
>> b/drivers/scsi/libsas/sas_expander.c
>> index 5ce251830104..88b8b955d533 100644
>> --- a/drivers/scsi/libsas/sas_expander.c
>> +++ b/drivers/scsi/libsas/sas_expander.c
>> @@ -935,8 +935,17 @@ static struct domain_device 
>> *sas_ex_discover_expander(
>>           return NULL;
>>         phy->port = sas_port_alloc(&parent->rphy->dev, phy_id);
>> -    /* FIXME: better error handling */
>> -    BUG_ON(sas_port_add(phy->port) != 0);
>> +    if (!phy->port) {
>> +        sas_put_device(child);
>> +        return NULL;
>> +    }
>> +
>> +    if (sas_port_add(phy->port)) {
>> +        sas_port_free(phy->port);
>> +        phy->port = NULL;
>> +        sas_put_device(child);
>> +        return NULL; > +    }
>>           switch (phy->attached_dev_type) {
>
> .
