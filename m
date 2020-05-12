Return-Path: <SRS0=/Ihf=62=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAFF5C54E8B
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 09:35:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF6D7206A3
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 09:35:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbgELJfh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 May 2020 05:35:37 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4778 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725889AbgELJfh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 May 2020 05:35:37 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 5A47A4F51B544F654850;
        Tue, 12 May 2020 17:35:33 +0800 (CST)
Received: from [127.0.0.1] (10.166.213.7) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.487.0; Tue, 12 May 2020
 17:35:24 +0800
Subject: Re: [PATCH] scsi: hisi_sas: display correct proc_name in sysfs
To:     John Garry <john.garry@huawei.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Xiang Chen <chenxiang66@hisilicon.com>
References: <20200512063318.13825-1-yanaijie@huawei.com>
 <66c3318d-e8fa-9ff4-c7f4-ebe23925b807@huawei.com>
From:   Jason Yan <yanaijie@huawei.com>
Message-ID: <dacd7cbe-3d84-2b35-e63a-af6179aa5221@huawei.com>
Date:   Tue, 12 May 2020 17:35:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <66c3318d-e8fa-9ff4-c7f4-ebe23925b807@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.166.213.7]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



在 2020/5/12 16:23, John Garry 写道:
> On 12/05/2020 07:33, Jason Yan wrote:
>> The 'proc_name' entry in sysfs for hisi_sas is 'null' now becuase it is
>> not initialized in scsi_host_template. It looks like:
>>
>> [root@localhost ~]# cat /sys/class/scsi_host/host2/proc_name
>> (null)
>>
> 
> hmmm.. it would be good to tell us what this buys us, apart from the 
> proc_name file.
> 

When there is more than one storage cards(or controllers) in the system, 
I'm tring to find out which host is belong to which card. And then I 
found this in scsi_host in sysfs but the output is '(null)' which is odd.

> I mean, if we had the sht show_info method implemented, then it could be 
> useful (which is even marked as obsolete now).
> 

I found this is interesting while in the sysfs filesystem we have a 
procfs stuff in it. I was planned to rename this entry to 'name' and use 
the struct member 'name' directly in struct scsi_host_template. But this 
may break userspace applications.

> Thanks,
> John
> 
>> While the other driver's entry looks like:
>>
>> linux-vnMQMU:~ # cat /sys/class/scsi_host/host0/proc_name
>> megaraid_sas
>>
>> Cc: John Garry <john.garry@huawei.com>
>> Cc: Xiang Chen <chenxiang66@hisilicon.com>
>> Signed-off-by: Jason Yan <yanaijie@huawei.com>
>> ---
>>   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 1 +
>>   drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 1 +
>>   drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 1 +
>>   3 files changed, 3 insertions(+)
>>
>> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c 
>> b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
>> index fa25766502a2..c205bff20943 100644
>> --- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
>> +++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
>> @@ -1757,6 +1757,7 @@ static struct device_attribute 
>> *host_attrs_v1_hw[] = {
>>   static struct scsi_host_template sht_v1_hw = {
>>       .name            = DRV_NAME,
>> +    .proc_name        = DRV_NAME,
>>       .module            = THIS_MODULE,
>>       .queuecommand        = sas_queuecommand,
>>       .target_alloc        = sas_target_alloc,
>> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c 
>> b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
>> index e05faf315dcd..c725cffe141e 100644
>> --- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
>> +++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
>> @@ -3533,6 +3533,7 @@ static struct device_attribute 
>> *host_attrs_v2_hw[] = {
>>   static struct scsi_host_template sht_v2_hw = {
>>       .name            = DRV_NAME,
>> +    .proc_name        = DRV_NAME,
>>       .module            = THIS_MODULE,
>>       .queuecommand        = sas_queuecommand,
>>       .target_alloc        = sas_target_alloc,
>> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c 
>> b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
>> index 374885aa8d77..59b1421607dd 100644
>> --- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
>> +++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
>> @@ -3071,6 +3071,7 @@ static int debugfs_set_bist_v3_hw(struct 
>> hisi_hba *hisi_hba, bool enable)
>>   static struct scsi_host_template sht_v3_hw = {
>>       .name            = DRV_NAME,
>> +    .proc_name        = DRV_NAME,
>>       .module            = THIS_MODULE,
>>       .queuecommand        = sas_queuecommand,
>>       .target_alloc        = sas_target_alloc,
>>
> 
> 
> .

