Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFEA4C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Nov 2022 03:11:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239612AbiKRDLa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Nov 2022 22:11:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbiKRDL3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Nov 2022 22:11:29 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BF0C74A91
        for <linux-scsi@vger.kernel.org>; Thu, 17 Nov 2022 19:11:28 -0800 (PST)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4ND1yJ0zQzzRpKJ;
        Fri, 18 Nov 2022 11:11:04 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 18 Nov 2022 11:11:25 +0800
Received: from [10.174.178.174] (10.174.178.174) by
 dggpemm500007.china.huawei.com (7.185.36.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 18 Nov 2022 11:11:24 +0800
Subject: Re: [PATCH v2] scsi: scsi_transport_sas: fix error handling in
 sas_rphy_add()
To:     <jejb@linux.ibm.com>, <linux-scsi@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
CC:     <martin.petersen@oracle.com>, <john.g.garry@oracle.com>,
        <yangyingliang@huawei.com>
References: <20221111144433.2421680-1-yangyingliang@huawei.com>
 <4f1992b1a90aa9e5d143ac47eadae508a20b9f9c.camel@linux.ibm.com>
From:   Yang Yingliang <yangyingliang@huawei.com>
Message-ID: <45fb08d9-ebda-4c8e-23cc-49f79e5ffde8@huawei.com>
Date:   Fri, 18 Nov 2022 11:11:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <4f1992b1a90aa9e5d143ac47eadae508a20b9f9c.camel@linux.ibm.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.174.178.174]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

+Cc: Greg

Hi Greg,

On 2022/11/11 23:51, James Bottomley wrote:
> On Fri, 2022-11-11 at 22:44 +0800, Yang Yingliang wrote:
>> In sas_rphy_add(), if transport_add_device() fails, the device
>> is not added, the return value is not checked, it won't goto
>> error path, when removing rphy in normal remove path, it causes
>> null-ptr-deref, because transport_remove_device() is called to
>> remove the device that was not added.
>>
>> Unable to handle kernel NULL pointer dereference at virtual address
>> 0000000000000108
>> pc : device_del+0x54/0x3d0
>> lr : device_del+0x37c/0x3d0
>> Call trace:
>>   device_del+0x54/0x3d0
>>   attribute_container_class_device_del+0x28/0x38
>>   transport_remove_classdev+0x6c/0x80
>>   attribute_container_device_trigger+0x108/0x110
>>   transport_remove_device+0x28/0x38
>>   sas_rphy_remove+0x50/0x78 [scsi_transport_sas]
>>   sas_port_delete+0x30/0x148 [scsi_transport_sas]
>>   do_sas_phy_delete+0x78/0x80 [scsi_transport_sas]
>>   device_for_each_child+0x68/0xb0
>>   sas_remove_children+0x30/0x50 [scsi_transport_sas]
>>   sas_rphy_remove+0x38/0x78 [scsi_transport_sas]
>>   sas_port_delete+0x30/0x148 [scsi_transport_sas]
>>   do_sas_phy_delete+0x78/0x80 [scsi_transport_sas]
>>   device_for_each_child+0x68/0xb0
>>   sas_remove_children+0x30/0x50 [scsi_transport_sas]
>>   sas_remove_host+0x20/0x38 [scsi_transport_sas]
>>   scsih_remove+0xd8/0x420 [mpt3sas]
>>
>> Fix this by checking and handling return value of
>> transport_add_device()
>> in sas_rphy_add().
>>
>> Fixes: c7ebbbce366c ("[SCSI] SAS transport class")
>> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
>> ---
>> v1 -> v2:
>>    Update commit message.
>> ---
>>   drivers/scsi/scsi_transport_sas.c | 6 +++++-
>>   1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/scsi_transport_sas.c
>> b/drivers/scsi/scsi_transport_sas.c
>> index 74b99f2b0b74..accc0afa8f77 100644
>> --- a/drivers/scsi/scsi_transport_sas.c
>> +++ b/drivers/scsi/scsi_transport_sas.c
>> @@ -1526,7 +1526,11 @@ int sas_rphy_add(struct sas_rphy *rphy)
>>          error = device_add(&rphy->dev);
>>          if (error)
>>                  return error;
>> -       transport_add_device(&rphy->dev);
>> +       error = transport_add_device(&rphy->dev);
>> +       if (error) {
>> +               device_del(&rphy->dev);
>> +               return error;
>> +       }
>>          transport_configure_device(&rphy->dev);
>>          if (sas_bsg_initialize(shost, rphy))
>>                  printk("fail to a bsg device %s\n", dev_name(&rphy-
>>> dev));
> There is a slight problem with doing this in that if
> transport_device_add() ever fails it's likely because memory pressure
> caused the allocation of the internal_container to fail. What that
> means is that the visible sysfs attributes don't get added, but
> otherwise the rphy is fully functional as far as the driver sees it, so
> this condition doesn't have to be a fatal error which kills the device.
>
> There are two ways of handling this:
>
>     1. The above to move the condition from an ignored to a fatal error.
>        It's so rare that we almost never see it in practice and if it
>        ever happened, the machine is so low on memory that something
>        else is bound to fail an allocation and kill the device anyway,
>        so treating it as non-fatal likely serves no purpose.
>     2. Simply to make the assumption that transport_remove_device() is
>        idempotent true by adding a flag in the internal_class to signify
>        removal is required. This would preserve current behaviour and
>        have the bonus that it only requires a single patch, not one
>        patch per transport class object that has this problem.
>
> I'd probably prefer 2. since it's way less work, but others might have
> different opinions.
Current some callers ignore the return value of transport_add_device(), 
if it fails,
it will cause null-ptr-deref in transport_remove_device().

James suggested that add some check in transport_remove_device(), so all can
be fix in one patch.

Do you have any suggestion for this ?

Thanks,
Yang
>
> James
>
> .
