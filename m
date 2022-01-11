Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0096DC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Jan 2022 13:23:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240450AbiAKNXx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Jan 2022 08:23:53 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4387 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231453AbiAKNXx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Jan 2022 08:23:53 -0500
Received: from fraeml739-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JYBBp1bG2z67xYL;
        Tue, 11 Jan 2022 21:20:18 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml739-chm.china.huawei.com (10.206.15.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 11 Jan 2022 14:23:50 +0100
Received: from [10.47.24.251] (10.47.24.251) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Tue, 11 Jan
 2022 13:23:49 +0000
Subject: Re: [issue report] pm8001 issues (was driver crashes with IOMMU
 enabled)
To:     <Ajish.Koshy@microchip.com>, <jinpu.wang@ionos.com>,
        <Viswas.G@microchip.com>
CC:     <linux-scsi@vger.kernel.org>, <vishakhavc@google.com>,
        <ipylypiv@google.com>, <Ruksar.devadi@microchip.com>,
        <damien.lemoal@opensource.wdc.com>,
        <Vasanthalakshmi.Tharmarajan@microchip.com>
References: <894f766f-74b7-62b1-f6d2-82ac85b6478f@huawei.com>
 <CAMGffEkvrAxhrsL=azkVzQHHyDczZwJ3uiNWydSA6o2K+Xh_Jw@mail.gmail.com>
 <00505633-c8c0-8213-8909-482bf43661cd@huawei.com>
 <1cc92b2d-3670-7843-d68a-06fe68521d24@huawei.com>
 <fd0eafc6-9443-fe5e-2c2f-91d6bbe8b174@huawei.com>
 <PH0PR11MB5112EBE80F9A4AD199866CA7EC429@PH0PR11MB5112.namprd11.prod.outlook.com>
 <0cc0c435-b4f2-9c76-258d-865ba50a29dd@huawei.com>
 <PH0PR11MB5112F2D4A506B0FE6DC5B01BEC4D9@PH0PR11MB5112.namprd11.prod.outlook.com>
 <34319d65-104d-55a0-175d-96cf3f0aea89@huawei.com>
 <PH0PR11MB511238B8FF7B44C375DDDFADEC519@PH0PR11MB5112.namprd11.prod.outlook.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <75d042c1-cee5-ce91-e1cb-9e2b7bb1ce72@huawei.com>
Date:   Tue, 11 Jan 2022 13:23:31 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <PH0PR11MB511238B8FF7B44C375DDDFADEC519@PH0PR11MB5112.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.47.24.251]
X-ClientProxiedBy: lhreml743-chm.china.huawei.com (10.201.108.193) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Ajish,

>>
>> Have you made any progress on the hang which I see on my arm64 system?
> Not planned for ARM server.
> 
>> I think that you said that you can also see it on an arm64 system - would that
>> be with a similar card to mine? I think mine is 8008/9
> That was similar card i.e. 8076.
> 
>> I have tested some older kernels and v4.11 seems much better.
>>
>> Thanks,
>> John
> Just to get more clarification, in the same thread
> following issues were mentioned. Right now
> I am on x86 server. Don't have 8008/8009 controller
> with me here.
> Issues:
> 1. Driver crashes when IOMMU is enabled. Patch already
> submitted.
>     - Issue was seen on x86 server too.
> 2. Observed triggering of scsi error handler on
>     ARM server.
>     - Issue not observed on x86 server

Your position on this is not clear on this one.

 From an earlier mail [0] I got the impression that you tested on an arm 
platform – did you?

I just don't know for certain that this is a card issue or an issue with 
the driver issue or both. I have a strong feeling that it is a driver 
issue. As I mentioned, v4.11 seems to work much better than v5.16 - on 
v4.11 I can mount the filesystem and copy files, which is not possible 
on a new kernel.

IIRC I did use this same card on an x86 platform some time and it worked 
ok, but I can't be certain. And it's really painful for me to swap the 
card to an x86 machine to test.

> 3. maxcpus=1 on commandline crashes during bootup.
>     Issue with 8008/8009 controller. Patch created.
>     - Issue impacts x86 too based on the code.
> 4. "I have found another issue. There is a potential
>     use-after-free in pm8001_task_exec():", where we
>     modify task state post task dispatch to hardware
>     - Generic code. Impact on all platform x86 and ARM.
>     
> Let us know if any other issue missed out to
> mention here or issues that impacts x86 too.

Your list looks ok. However I did also mention these logs which I saw on 
my arm machine:

[   12.160631] sas: target proto 0x0 at 500e004aaaaaaa1f:0x10 not handled
[   12.167183] sas: ex 500e004aaaaaaa1f phy16 failed to discover

They are red flags, and may be related to 2, above.

Thanks,
John

[0] 
https://lore.kernel.org/linux-scsi/PH0PR11MB51122D76F40E164C31AFEE54EC719@PH0PR11MB5112.namprd11.prod.outlook.com/

