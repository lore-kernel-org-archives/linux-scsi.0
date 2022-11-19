Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E495C4332F
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Nov 2022 08:59:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbiKSI7A (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Nov 2022 03:59:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232177AbiKSI6y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Nov 2022 03:58:54 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13E002CDFB
        for <linux-scsi@vger.kernel.org>; Sat, 19 Nov 2022 00:58:47 -0800 (PST)
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NDnXZ72LSzqSPv;
        Sat, 19 Nov 2022 16:54:54 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 19 Nov 2022 16:58:45 +0800
Received: from [10.174.178.174] (10.174.178.174) by
 dggpemm500007.china.huawei.com (7.185.36.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 19 Nov 2022 16:58:45 +0800
Subject: Re: [PATCH v2] scsi: scsi_transport_sas: fix error handling in
 sas_rphy_add()
To:     John Garry <john.g.garry@oracle.com>, <jejb@linux.ibm.com>,
        <linux-scsi@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>
CC:     <martin.petersen@oracle.com>, <yangyingliang@huawei.com>
References: <20221111144433.2421680-1-yangyingliang@huawei.com>
 <4f1992b1a90aa9e5d143ac47eadae508a20b9f9c.camel@linux.ibm.com>
 <45fb08d9-ebda-4c8e-23cc-49f79e5ffde8@huawei.com>
 <9ff2a73c-bd45-c19e-3624-8816c5bac9ab@oracle.com>
From:   Yang Yingliang <yangyingliang@huawei.com>
Message-ID: <d6640c5d-c08c-407a-3e32-8a5bd37bd01b@huawei.com>
Date:   Sat, 19 Nov 2022 16:58:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <9ff2a73c-bd45-c19e-3624-8816c5bac9ab@oracle.com>
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


On 2022/11/18 17:18, John Garry wrote:
> On 18/11/2022 03:11, Yang Yingliang wrote:
>>>>> );
>>> There is a slight problem with doing this in that if
>>> transport_device_add() ever fails it's likely because memory pressure
>>> caused the allocation of the internal_container to fail. What that
>>> means is that the visible sysfs attributes don't get added, but
>>> otherwise the rphy is fully functional as far as the driver sees it, so
>>> this condition doesn't have to be a fatal error which kills the device.
>>>
>>> There are two ways of handling this:
>>>
>>>     1. The above to move the condition from an ignored to a fatal 
>>> error.
>>>        It's so rare that we almost never see it in practice and if it
>>>        ever happened, the machine is so low on memory that something
>>>        else is bound to fail an allocation and kill the device anyway,
>>>        so treating it as non-fatal likely serves no purpose.
>>>     2. Simply to make the assumption that transport_remove_device() is
>>>        idempotent true by adding a flag in the internal_class to 
>>> signify
>>>        removal is required. This would preserve current behaviour and
>>>        have the bonus that it only requires a single patch, not one
>>>        patch per transport class object that has this problem.
>>>
>>> I'd probably prefer 2. since it's way less work, but others might have
>>> different opinions.
>> Current some callers ignore the return value of 
>> transport_add_device(), if it fails,
>> it will cause null-ptr-deref in transport_remove_device().
>>
>> James suggested that add some check in transport_remove_device(), so 
>> all can
>> be fix in one patch.
>>
>> Do you have any suggestion for this ?
>
> Personally I prefer 1. However did you develop a prototype patch for 
> how 2. would look? And how many changes are still required for 1.?
For 1, in total, there are 8 places need be checked
in drivers/scsi/scsi_transport_sas.c, 2 places
in drivers/scsi/scsi_sysfs.c, 3 places
in drivers/scsi/scsi_transport_fc.c, 2 places
in drivers/scsi/scsi_transport_srp.c, 1 place

For 2, I think we can use device_is_registered() to check if add 
operation is successful, may be like this (not test yet):

diff --git a/drivers/base/transport_class.c b/drivers/base/transport_class.c
index ccc86206e508..ac41be7b724e 100644
--- a/drivers/base/transport_class.c
+++ b/drivers/base/transport_class.c
@@ -227,9 +227,11 @@ static int transport_remove_classdev(struct 
attribute_container *cont,
          tclass->remove(tcont, dev, classdev);

      if (tclass->remove != anon_transport_dummy_function) {
-        if (tcont->statistics)
-            sysfs_remove_group(&classdev->kobj, tcont->statistics);
-        attribute_container_class_device_del(classdev);
+        if (device_is_registered(classdev)) {
+            if (tcont->statistics)
+                sysfs_remove_group(&classdev->kobj, tcont->statistics);
+            attribute_container_class_device_del(classdev);
+        }
      }

      return 0;

Thanks,
Yang
>
> Thanks,
> John
> .
