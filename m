Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A43C1C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Nov 2022 01:31:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbiKJBbX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Nov 2022 20:31:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232222AbiKJBbI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Nov 2022 20:31:08 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32D9E24945
        for <linux-scsi@vger.kernel.org>; Wed,  9 Nov 2022 17:31:06 -0800 (PST)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N746L4BdFzmVWB;
        Thu, 10 Nov 2022 09:30:50 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 10 Nov 2022 09:31:04 +0800
Received: from [10.174.178.174] (10.174.178.174) by
 dggpemm500007.china.huawei.com (7.185.36.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 10 Nov 2022 09:31:03 +0800
Subject: Re: [PATCH] scsi: iscsi: fix possible memory leak when
 transport_register_device() fails
To:     Mike Christie <michael.christie@oracle.com>,
        <open-iscsi@googlegroups.com>, <linux-scsi@vger.kernel.org>
CC:     <lduncan@suse.com>, <cleech@redhat.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <yangyingliang@huawei.com>
References: <20221109092421.3111613-1-yangyingliang@huawei.com>
 <41b1cacb-94cc-ad69-11a7-b13452080389@oracle.com>
From:   Yang Yingliang <yangyingliang@huawei.com>
Message-ID: <d8eb4ca4-ee8e-9355-54f8-f41f405e723e@huawei.com>
Date:   Thu, 10 Nov 2022 09:31:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <41b1cacb-94cc-ad69-11a7-b13452080389@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.178.174]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 2022/11/10 2:51, Mike Christie wrote:
> On 11/9/22 3:24 AM, Yang Yingliang wrote:
>> If transport_register_device() fails, transport_destroy_device() should
>> be called to release the memory allocated in transport_setup_device().
>>
>> Fixes: 0896b7523026 ("[SCSI] open-iscsi/linux-iscsi-5 Initiator: Transport class update for iSCSI")
>> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
>> ---
>>   drivers/scsi/scsi_transport_iscsi.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
>> index cd3db9684e52..88add31a56e3 100644
>> --- a/drivers/scsi/scsi_transport_iscsi.c
>> +++ b/drivers/scsi/scsi_transport_iscsi.c
>> @@ -2085,6 +2085,7 @@ int iscsi_add_session(struct iscsi_cls_session *session, unsigned int target_id)
>>   	return 0;
>>   
>>   release_dev:
>> +	transport_destroy_device(&session->dev);
>>   	device_del(&session->dev);
>>   release_ida:
>>   	if (session->ida_used)
>> @@ -2462,6 +2463,7 @@ int iscsi_add_conn(struct iscsi_cls_conn *conn)
>>   	if (err) {
>>   		iscsi_cls_session_printk(KERN_ERR, session,
>>   					 "could not register transport's dev\n");
>> +		transport_destroy_device(&conn->dev);
>>   		device_del(&conn->dev);
>>   		return err;
> Why doesn't transport_register_device undo what it did and call
> transport_destroy_device? The callers like iscsi don't know what
> was done, so it seems odd to call transport_destroy_device when
> we got a failure.
Yeah, it seems it's better to put the destroy() function in register(), 
I will change
it and send a v2.

Thanks,
Yang
>
>
> .
