From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH 20/22] scsi: hisi_sas: Add v3 code to support ECC and AXI
 bus fatal error
Date: Tue, 13 Jun 2017 15:05:30 +0100
Message-ID: <cc74b7c2-4946-af6a-b761-cdfba2162a4d@huawei.com>
References: <1495018197-120535-1-git-send-email-john.garry@huawei.com>
 <1495018197-120535-21-git-send-email-john.garry@huawei.com>
 <CAK8P3a3jh8QqcHgdAkpA9SADZ0RfD2i63A-RHkN9+gJ31sL74g@mail.gmail.com>
 <438a97a7-b424-a599-0c65-1e79dcdf8e86@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([45.249.212.188]:7817 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752109AbdFMOJ2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jun 2017 10:09:28 -0400
In-Reply-To: <438a97a7-b424-a599-0c65-1e79dcdf8e86@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, John Garry <john.garry2@mail.dcu.ie>, linuxarm@huawei.com, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Xiang Chen <chenxiang66@hisilicon.com>

On 17/05/2017 13:38, John Garry wrote:
> On 17/05/2017 13:27, Arnd Bergmann wrote:
>> On Wed, May 17, 2017 at 12:49 PM, John Garry <john.garry@huawei.com>
>> wrote:
>>> > From: Xiang Chen <chenxiang66@hisilicon.com>
>>> >
>>> > For ECC 1bit error, logic can recover it, so we only print a warning.
>>> > For ECC multi-bit and AXI bus fatal error, we panic.
>>> >
>>> > Signed-off-by: John Garry <john.garry@huawei.com>
>>> > Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
>> This one is tricky as there are conflicting requirements:
>>
>> - For debugging purposes, you want to continue running the system
>>   to figure out what exactly went wrong. Often enough, having the
>>   kernel panic means you don't get to see the panic message because
>>   console access is unavailable and you cannot log in any more
>>
>> - For data consistency purposes you want to stop the system as
>>   soon as there is any uncorrectable data error
>>
>> I see that most scsi drivers don't ever call panic or BUG(), though
>> you already do so for v1 and v2 hw.
>>
>> Maybe the SCSI maintainers can provide some more guidance here.
>>
>>       Arnd
>>
>> .
>>
>
> Hi Arnd,
>
> Actually latest code for v2 has been updated to do a controller reset,
> and not panic, for unrecoverable error:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c?h=v4.12-rc1#n2926
>
>
> We never got around to implementing controller reset for v1 as this
> platform (hip05) is not used much anymore.
>
> As for v3, we will change to to do same once controller reset is
> implemented. I should have added this to the commit log.
>
> Thanks,
> John

It has come to light that hip08 RAS architecture requires handling 
certain errors with firmware first model. I am not sure on the flow of 
controller reset for fatal errors - I'm currently checking the details.

But it is not worth adding this non-critical patch and reverting it 
later, so I'll omit this patch when sending the v6 patchset which 
includes the fix for sloppy spinlock usage.

Thanks,
John
