From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH] scsi: libsas: Remove pcidev reference
Date: Mon, 12 Nov 2018 17:55:19 +0000
Message-ID: <3b62b0ad-53ba-37c2-817c-591d94eed838@huawei.com>
References: <1542043689-214071-1-git-send-email-john.garry@huawei.com>
 <584e7b4fcd6f95fe0c581f6f9472852685c754d1.camel@perches.com>
 <310504a2-f33c-183b-d00a-fa067b273dfd@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <310504a2-f33c-183b-d00a-fa067b273dfd@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxarm@huawei.com
List-Id: linux-scsi@vger.kernel.org

On 12/11/2018 17:49, John Garry wrote:
> On 12/11/2018 17:32, Joe Perches wrote:
>> On Tue, 2018-11-13 at 01:28 +0800, John Garry wrote:
>>> Not all host drivers are PCI drivers - like hisi_sas, which supports a
>>> platform driver - so remove reference to "pcidev".
>>>
>>> The debug level is also downgraded to KERN_ERR for the same message.
>> []
>>> diff --git a/drivers/scsi/libsas/sas_discover.c
>>> b/drivers/scsi/libsas/sas_discover.c
>> []
>>> @@ -186,7 +186,7 @@ int sas_notify_lldd_dev_found(struct
>>> domain_device *dev)
>>>
>>>      res = i->dft->lldd_dev_found(dev);
>>>      if (res) {
>>> -        printk("sas: driver on pcidev %s cannot handle "
>>> +        pr_err("sas: driver on host %s cannot handle "
>>>                 "device %llx, error:%d\n",
>>
>> As a printk without a KERN_<LEVEL> is printed at whatever
>> CONFIG_MESSAGE_LOGLEVEL_DEFAULT is set to (default: 4 and
>> rarely unchanged), this is effectively upgraded from a
>> KERN_WARNING to KERN_ERR.
>
> ah, I thought that it was printed always.
>
> So maybe I'll just leave as-is.

I forgot to mention that checkpatch complains about using printk() - 
that's why I changed it.

Thanks,
John

>
>>
>>
>>
>> .
>>
>
>
>
> .
>
