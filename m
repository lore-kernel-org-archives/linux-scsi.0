Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D528C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Nov 2022 02:03:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232429AbiKJCDY convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Nov 2022 21:03:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232406AbiKJCC4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Nov 2022 21:02:56 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8422218E01
        for <linux-scsi@vger.kernel.org>; Wed,  9 Nov 2022 18:01:55 -0800 (PST)
Received: from kwepemi500018.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4N74nh1fW8zHvcL;
        Thu, 10 Nov 2022 10:01:28 +0800 (CST)
Received: from kwepemi500016.china.huawei.com (7.221.188.220) by
 kwepemi500018.china.huawei.com (7.221.188.213) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 10 Nov 2022 10:01:53 +0800
Received: from kwepemi500016.china.huawei.com ([7.221.188.220]) by
 kwepemi500016.china.huawei.com ([7.221.188.220]) with mapi id 15.01.2375.031;
 Thu, 10 Nov 2022 10:01:53 +0800
From:   Zhouguanghui <zhouguanghui1@huawei.com>
To:     Mike Christie <michael.christie@oracle.com>,
        "lduncan@suse.com" <lduncan@suse.com>,
        "cleech@redhat.com" <cleech@redhat.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [-next] scsi: iscsi: fix possible memory leak in
 iscsi_register_transport
Thread-Topic: [-next] scsi: iscsi: fix possible memory leak in
 iscsi_register_transport
Thread-Index: AQHY9GqyoD3+swMknU2PtJGQGycang==
Date:   Thu, 10 Nov 2022 02:01:53 +0000
Message-ID: <51f33b2f00334114bbb0663a51354404@huawei.com>
References: <20221109081917.34311-1-zhouguanghui1@huawei.com>
 <c4b77a0f-c53d-42fa-8d42-a08a12f59667@oracle.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.178.109]
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022/11/10 3:36, Mike Christie wrote:
> On 11/9/22 2:19 AM, Zhou Guanghui wrote:
>> "unreferenced object 0xffff888117908420 (size 16):
>>    comm ""modprobe"", pid 18125, jiffies 4319017437 (age 73.039s)
>>    hex dump (first 16 bytes):
>>      62 65 32 69 73 63 73 69 00 84 90 17 81 88 ff ff  be2iscsi........
>>    backtrace:
>>      [<00000000f78a13b3>] __kmem_cache_alloc_node+0x157/0x220
>>      [<00000000200a51a4>] __kmalloc_node_track_caller+0x44/0x1b0
>>      [<0000000033ea4d64>] kstrdup+0x3a/0x70
>>      [<00000000ec6d2980>] kstrdup_const+0x41/0x60
>>      [<0000000055015f6f>] kvasprintf_const+0xf5/0x180
>>      [<000000009dd443d2>] kobject_set_name_vargs+0x56/0x150
>>      [<00000000f3448e98>] dev_set_name+0xab/0xe0
>>      [<0000000080ab8992>] iscsi_register_transport+0x1f8/0x610 [scsi_transport_iscsi]
>>      [<000000005e2c324d>] 0xffffffffc1260012
>>      [<00000000df6e6a36>] do_one_initcall+0xcb/0x4d0
>>      [<00000000181109df>] do_init_module+0x1ca/0x5f0
>>      [<00000000b3c4fec8>] load_module+0x6133/0x70f0
>>      [<00000000feb08394>] __do_sys_finit_module+0x12f/0x1c0
>>      [<00000000ca6af44d>] do_syscall_64+0x37/0x90
>>      [<00000000132e1a8b>] entry_SYSCALL_64_after_hwframe+0x63/0xcd"
>>
>> If device_register() returns error in iscsi_register_transport(),
>> the name allocated by the dev_set_name() need be freed.
>>
>> Fix this by calling put_device(), the name will be freed in the
>> kobject_cleanup(), and the priv will be freed in
>> iscsi_transport_release.
>>
>> Signed-off-by: Zhou Guanghui <zhouguanghui1@huawei.com>
>> ---
>>   drivers/scsi/scsi_transport_iscsi.c | 6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
>> index cd3db9684e52..51e2c0f5e2d0 100644
>> --- a/drivers/scsi/scsi_transport_iscsi.c
>> +++ b/drivers/scsi/scsi_transport_iscsi.c
>> @@ -4815,7 +4815,7 @@ iscsi_register_transport(struct iscsi_transport *tt)
>>   	dev_set_name(&priv->dev, "%s", tt->name);
>>   	err = device_register(&priv->dev);
>>   	if (err)
>> -		goto free_priv;
>> +		goto put_dev;
>>   
>>   	err = sysfs_create_group(&priv->dev.kobj, &iscsi_transport_group);
>>   	if (err)
>> @@ -4850,8 +4850,8 @@ iscsi_register_transport(struct iscsi_transport *tt)
>>   unregister_dev:
>>   	device_unregister(&priv->dev);
>>   	return NULL;
>> -free_priv:
>> -	kfree(priv);
>> +put_dev:
>> +	put_device(&priv->dev);
>>   	return NULL;
>>   }
>>   EXPORT_SYMBOL_GPL(iscsi_register_transport);
> 
> Reviewed-by: Mike Christie <michael.christie@oracle.com>
> 
> Shoot, I see the comment about using put_device in device_add.
> I'm not sure what happened, but I made the same mistake above
> in 4 other places.
> 
> Do you want to send patches for the other ones? If not, I'll do
> it.
> 

Mike，thanks.

I also found 4 other places that have the same mistake. I'll be sending 
a patch v2 soon.

