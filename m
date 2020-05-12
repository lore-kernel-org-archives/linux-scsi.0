Return-Path: <SRS0=/Ihf=62=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FEA2C54E4A
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 10:30:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2ACA2206DD
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 10:30:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729426AbgELKaY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 May 2020 06:30:24 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4396 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729349AbgELKaY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 May 2020 06:30:24 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id D25D48F8059F1425D55C;
        Tue, 12 May 2020 18:30:21 +0800 (CST)
Received: from [127.0.0.1] (10.166.213.7) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Tue, 12 May 2020
 18:30:14 +0800
Subject: Re: [PATCH] scsi: hisi_sas: display correct proc_name in sysfs
To:     John Garry <john.garry@huawei.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Xiang Chen <chenxiang66@hisilicon.com>
References: <20200512063318.13825-1-yanaijie@huawei.com>
 <66c3318d-e8fa-9ff4-c7f4-ebe23925b807@huawei.com>
 <dacd7cbe-3d84-2b35-e63a-af6179aa5221@huawei.com>
 <920c5d36-5637-1fba-034b-8ea3d41c131c@huawei.com>
From:   Jason Yan <yanaijie@huawei.com>
Message-ID: <1043f72a-7f4c-eb5c-eeb2-227f5321fed5@huawei.com>
Date:   Tue, 12 May 2020 18:30:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <920c5d36-5637-1fba-034b-8ea3d41c131c@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.166.213.7]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



在 2020/5/12 18:00, John Garry 写道:
> On 12/05/2020 10:35, Jason Yan wrote:
>>
>>
>> 在 2020/5/12 16:23, John Garry 写道:
>>> On 12/05/2020 07:33, Jason Yan wrote:
>>>> The 'proc_name' entry in sysfs for hisi_sas is 'null' now becuase it is
>>>> not initialized in scsi_host_template. It looks like:
>>>>
>>>> [root@localhost ~]# cat /sys/class/scsi_host/host2/proc_name
>>>> (null)
>>>>
>>>
>>> hmmm.. it would be good to tell us what this buys us, apart from the 
>>> proc_name file.
>>>
>>
>> When there is more than one storage cards(or controllers) in the 
>> system, I'm tring to find out which host is belong to which card. And 
>> then I found this in scsi_host in sysfs but the output is '(null)' 
>> which is odd.
> 
> "dmesg | grep host" would give this info, like:
> 
> root@(none)$ dmesg | grep host0
> [    8.877245] scsi host0: hisi_sas_v2_hw
> 

NO, if long time after the system boot, dmesg cannot get this 
infomation. It is flushed by other logs.

>>
>>> I mean, if we had the sht show_info method implemented, then it could 
>>> be useful (which is even marked as obsolete now).
>>>
>>
>> I found this is interesting while in the sysfs filesystem we have a 
>> procfs stuff in it.
> 
> It's only the name of the procfs entry, if it exists.
> 
> And, since .show_info is obsolete, I don't see why .proc_name is not 
> also obsolete.
> 
>> I was planned to rename this entry to 'name' and use the struct member 
>> 'name' directly in struct scsi_host_template. But this may break 
>> userspace applications.
>>
> 
> Thanks,
> John
> 
> .

