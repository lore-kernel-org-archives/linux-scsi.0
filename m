Return-Path: <SRS0=/Ihf=62=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D520C54E4A
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 11:08:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 369BE206A3
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 11:08:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728085AbgELLIF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 May 2020 07:08:05 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2194 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726891AbgELLIF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 May 2020 07:08:05 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id 2775A39EC4767A3A9A55;
        Tue, 12 May 2020 12:08:03 +0100 (IST)
Received: from [127.0.0.1] (10.210.169.134) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Tue, 12 May
 2020 12:08:02 +0100
Subject: Re: [PATCH] scsi: hisi_sas: display correct proc_name in sysfs
To:     Jason Yan <yanaijie@huawei.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Xiang Chen <chenxiang66@hisilicon.com>
References: <20200512063318.13825-1-yanaijie@huawei.com>
 <66c3318d-e8fa-9ff4-c7f4-ebe23925b807@huawei.com>
 <dacd7cbe-3d84-2b35-e63a-af6179aa5221@huawei.com>
 <920c5d36-5637-1fba-034b-8ea3d41c131c@huawei.com>
 <1043f72a-7f4c-eb5c-eeb2-227f5321fed5@huawei.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <a0ff79dd-d00e-a938-39c2-0ab281c7f795@huawei.com>
Date:   Tue, 12 May 2020 12:07:10 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <1043f72a-7f4c-eb5c-eeb2-227f5321fed5@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.210.169.134]
X-ClientProxiedBy: lhreml733-chm.china.huawei.com (10.201.108.84) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/05/2020 11:30, Jason Yan wrote:
> 
> 
> 在 2020/5/12 18:00, John Garry 写道:
>> On 12/05/2020 10:35, Jason Yan wrote:
>>>
>>>
>>> 在 2020/5/12 16:23, John Garry 写道:
>>>> On 12/05/2020 07:33, Jason Yan wrote:
>>>>> The 'proc_name' entry in sysfs for hisi_sas is 'null' now becuase 
>>>>> it is
>>>>> not initialized in scsi_host_template. It looks like:
>>>>>
>>>>> [root@localhost ~]# cat /sys/class/scsi_host/host2/proc_name
>>>>> (null)
>>>>>
>>>>
>>>> hmmm.. it would be good to tell us what this buys us, apart from the 
>>>> proc_name file.
>>>>
>>>
>>> When there is more than one storage cards(or controllers) in the 
>>> system, I'm tring to find out which host is belong to which card. And 
>>> then I found this in scsi_host in sysfs but the output is '(null)' 
>>> which is odd.
>>
>> "dmesg | grep host" would give this info, like:
>>
>> root@(none)$ dmesg | grep host0
>> [    8.877245] scsi host0: hisi_sas_v2_hw
>>
> 
> NO, if long time after the system boot, dmesg cannot get this 
> infomation. It is flushed by other logs.


ok, so I don't see any other way to currently do this, even though using 
proc_name is a bit suspect, so:

Acked-by: John Garry <john.garry@huawei.com>

And the $subject is not right. It should be simply "display proc_name in 
sysfs".

Thanks,
John
