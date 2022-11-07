Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAE14C433FE
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Nov 2022 10:38:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbiKGKiP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Nov 2022 05:38:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231420AbiKGKiL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Nov 2022 05:38:11 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DCFB19025
        for <linux-scsi@vger.kernel.org>; Mon,  7 Nov 2022 02:38:10 -0800 (PST)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N5SK22nd0zpW6L;
        Mon,  7 Nov 2022 18:34:30 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 7 Nov 2022 18:38:08 +0800
Received: from [10.174.178.174] (10.174.178.174) by
 dggpemm500007.china.huawei.com (7.185.36.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 7 Nov 2022 18:38:08 +0800
Subject: Re: [PATCH] scsi: libsas: fix error handling in sas_phy_add()
To:     John Garry <john.g.garry@oracle.com>, <linux-scsi@vger.kernel.org>
CC:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <yangyingliang@huawei.com>
References: <20221105071725.2313316-1-yangyingliang@huawei.com>
 <5ebc23f6-0043-4214-5b2b-43357f106fc7@oracle.com>
From:   Yang Yingliang <yangyingliang@huawei.com>
Message-ID: <1390c9b8-5e24-16de-2915-7e167eedfe7b@huawei.com>
Date:   Mon, 7 Nov 2022 18:38:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <5ebc23f6-0043-4214-5b2b-43357f106fc7@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.174.178.174]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

On 2022/11/7 17:35, John Garry wrote:
> On 05/11/2022 07:17, Yang Yingliang wrote:
>
> This is not libsas.
>
> BTW, before I go further, note this:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst#n312 
>
Thanks for replying.

Yes, it should be "scsi: scsi_transport_sas: XXX"
>
>> If transport_add_device() fails in sas_phy_add(), but it's not handled,
>> it will lead kernel crash because of trying to delete not added device
>> in transport_remove_device() called from sas_remove_host().
>>
>> Unable to handle kernel NULL pointer dereference at virtual address 
>> 0000000000000108
>> CPU: 61 PID: 42829 Comm: rmmod Kdump: loaded Tainted: G W          
>> 6.1.0-rc1+ #173
>> pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
>> pc : device_del+0x54/0x3d0
>> lr : device_del+0x37c/0x3d0
>> Call trace:
>>   device_del+0x54/0x3d0
>>   attribute_container_class_device_del+0x28/0x38
>>   transport_remove_classdev+0x6c/0x80
>>   attribute_container_device_trigger+0x108/0x110
>>   transport_remove_device+0x28/0x38
>>   sas_phy_delete+0x30/0x60 [scsi_transport_sas]
>>   do_sas_phy_delete+0x6c/0x80 [scsi_transport_sas]
>>   device_for_each_child+0x68/0xb0
>>   sas_remove_children+0x40/0x50 [scsi_transport_sas]
>>   sas_remove_host+0x20/0x38 [scsi_transport_sas]
>>   hisi_sas_remove+0x40/0x68 [hisi_sas_main]
>>   hisi_sas_v2_remove+0x20/0x30 [hisi_sas_v2_hw]
>>   platform_remove+0x2c/0x60
>>
>> Fix this by checking and handling return value of transport_add_device()
>> in sas_phy_add(). transport_destroy_device() has been called in 
>> sas_phy_free()
>> in the error path, so it's no need to call it here.
>
> "there's no need", rather than "it's no need". And I don't know why 
> you bother even mentioning about transport_destroy_device().

Because the device set up by transport_setup_device(), it should be 
destroyed by transport_destroy_device(), so I mention this.

>
>>
>> Fixes: c7ebbbce366c ("[SCSI] SAS transport class")
>> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
>> ---
>>   drivers/scsi/scsi_transport_sas.c | 7 +++++--
>>   1 file changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_transport_sas.c 
>> b/drivers/scsi/scsi_transport_sas.c
>> index 2f88c61216ee..cb364a7c6097 100644
>> --- a/drivers/scsi/scsi_transport_sas.c
>> +++ b/drivers/scsi/scsi_transport_sas.c
>> @@ -723,8 +723,11 @@ int sas_phy_add(struct sas_phy *phy)
>>         error = device_add(&phy->dev);
>>       if (!error) {
>
> personally I think that the following looks better:
>
> int sas_phy_add(struct sas_phy *phy)
> {
>     int error;
>
>     error = device_add(&phy->dev);
>     if (error)
>         return error;
>
>     error = transport_add_device(&phy->dev);
>     if (error) {
>         device_del(&phy->dev);
>         return error;
>     }
>     transport_configure_device(&phy->dev);
>
>     return 0;
> }
> EXPORT_SYMBOL(sas_phy_add);
Yes, it's looks better, but I was trying to change least this code to 
fix this problem.
I can send a v2 later to change these.

Thanks,
Yang
>
>> - transport_add_device(&phy->dev);
>> -        transport_configure_device(&phy->dev);
>> +        error = transport_add_device(&phy->dev);
>> +        if (!error)
>> +            transport_configure_device(&phy->dev);
>> +        else
>> +            device_del(&phy->dev);
>>       }
>>         return error;
>
>
> .
