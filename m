From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH] scsi: hisi_sas: select CONFIG_RAS
Date: Fri, 3 Nov 2017 12:02:16 +0000
Message-ID: <50ad8f0e-9b21-4277-4be9-dfd6b82e5554@huawei.com>
References: <20171102165059.213216-1-arnd@arndb.de>
 <bdb263f7-7e1f-47ab-881b-2feeeeccfbf5@huawei.com>
 <CAK8P3a3fvRQ+oUg=EUuWxdyyyMGHiL7sQMLhCY53sfCRyinOAA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a3fvRQ+oUg=EUuWxdyyyMGHiL7sQMLhCY53sfCRyinOAA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Xiang Chen <chenxiang66@hisilicon.com>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linuxarm <linuxarm@huawei.com>, Shiju Jose <shiju.jose@huawei.com>
List-Id: linux-scsi@vger.kernel.org

On 03/11/2017 10:19, Arnd Bergmann wrote:
> On Fri, Nov 3, 2017 at 11:14 AM, John Garry <john.garry@huawei.com> wrote:
>> + Shiju, who authored the original patch
>>
>
>>> index d42f29a5eb65..6ad8a6251d21 100644
>>> --- a/drivers/scsi/hisi_sas/Kconfig
>>> +++ b/drivers/scsi/hisi_sas/Kconfig
>>> @@ -4,6 +4,7 @@ config SCSI_HISI_SAS
>>>         depends on ARM64 || COMPILE_TEST
>>>         select SCSI_SAS_LIBSAS
>>>         select BLK_DEV_INTEGRITY
>>> +       select RAS
>>
>>
>> My impression is that we don't want this. Correction: shouldn't want this.
>>
>> Do you have the .config for the broken build? I couldn't recreate this by
>> turning off CONFIG_RAS.
>
> Uploaded to https://pastebin.com/A1rJYhDr
> Maybe you were missing support for tracing in your configuration?
>

Thanks Arnd, I can see it now.

However, as you said, it looks like this interface is not being used 
correctly, and I tend to agree.

Actually this interface is intended for logging UEFI CPER non-standard 
records from kernel RAS/APEI framework to userspace. It is not intended 
for kernel peripheral driver logging (like this case). Until we get a 
community concensus on whether this is acceptable, I would rather revert 
the original patch.

Thanks,
John

>       Arnd
>
> .
>
