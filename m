Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34D74C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Nov 2022 02:44:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232633AbiKKCor (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Nov 2022 21:44:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232707AbiKKCob (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Nov 2022 21:44:31 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F18F8D7FE
        for <linux-scsi@vger.kernel.org>; Thu, 10 Nov 2022 18:39:28 -0800 (PST)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4N7jVl4TMgzJnbx;
        Fri, 11 Nov 2022 10:35:43 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 11 Nov 2022 10:38:46 +0800
Received: from [10.174.178.174] (10.174.178.174) by
 dggpemm500007.china.huawei.com (7.185.36.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 11 Nov 2022 10:38:46 +0800
Subject: Re: [PATCH] scsi: core: sysfs: fix possible null-ptr-deref
To:     Mike Christie <michael.christie@oracle.com>,
        <linux-scsi@vger.kernel.org>
CC:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <yangyingliang@huawei.com>
References: <20221110142917.373925-1-yangyingliang@huawei.com>
 <df45a2e0-ba39-b49d-27c7-91e390247dda@oracle.com>
From:   Yang Yingliang <yangyingliang@huawei.com>
Message-ID: <26745dc2-c088-b9ab-da9d-fd96bb75eed9@huawei.com>
Date:   Fri, 11 Nov 2022 10:38:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <df45a2e0-ba39-b49d-27c7-91e390247dda@oracle.com>
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

Hi Mike,

On 2022/11/11 2:03, Mike Christie wrote:
> On 11/10/22 8:29 AM, Yang Yingliang wrote:
>> In scsi_sysfs_add_host(), transport_register_device() may return
>> error, if it's not handled, it will cause a null-ptr-deref while
>> removing module, because transport_remove_device() is called to
>> delete a device that not added.
>>
>> Unable to handle kernel NULL pointer dereference at virtual address 00000000000000d0
>> CPU: 12 PID: 14570 Comm: rmmod Kdump: loaded Not tainted 6.1.0-rc3+ #25
>> pstate: 80400009 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
>> pc : device_del+0x48/0x39c
>> lr : device_del+0x44/0x39c
>>   device_del+0x48/0x39c
>>   attribute_container_class_device_del+0x28/0x40
>>   transport_remove_classdev+0x60/0x7c
>>   attribute_container_device_trigger+0x118/0x120
>>   transport_remove_device+0x20/0x30
>>   scsi_remove_host+0x150/0x26c
>>   sas_remove_host+0x54/0x70 [scsi_transport_sas]
>>   hisi_sas_v3_remove+0x5c/0xbc [hisi_sas_v3_hw]
>>
>> Fix this by checking and handling return value of transport_register_device().
>>
>> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
>> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
>> ---
>>   drivers/scsi/scsi_sysfs.c | 6 +++++-
>>   1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
>> index cac7c902cf70..41de795f1ab2 100644
>> --- a/drivers/scsi/scsi_sysfs.c
>> +++ b/drivers/scsi/scsi_sysfs.c
>> @@ -1607,7 +1607,11 @@ EXPORT_SYMBOL(scsi_register_interface);
>>    **/
>>   int scsi_sysfs_add_host(struct Scsi_Host *shost)
>>   {
>> -	transport_register_device(&shost->shost_gendev);
>> +	int ret;
>> +
>> +	ret = transport_register_device(&shost->shost_gendev);
>> +	if (ret)
>> +		return ret;
>>   	transport_configure_device(&shost->shost_gendev);
>>   	return 0;
>>   }
> Do we need to do something similar every time transport_add_device
> fails? For example, in ata_tport_add if transport_add_device
> and we later do transport_destroy_device in ata_tlink_delete?
> The SAS and FC classes do something similar and in SCSI-ml we
> have other cases for device and target additions.
Yes, we need, and I think the normal call sequence of using transport 
class is:

Add path:
transport_setup_device()   // allocate device
transport_add_device()      // add device, if it fails, need call 
transport_destroy_device()
transport_configure_device()

Remove path:
transport_remove_device()  // remove device
transport_destroy_device()  // free device

If device is not added, can not call remove function, just call destroy 
function to free the memory.

Thanks,
Yang
>
> .
