From: Jason Yan <yanaijie@huawei.com>
Subject: Re: [PATCH] driver core: Make it safe to use get_device() if the
 reference count is zero
Date: Thu, 14 Dec 2017 15:56:46 +0800
Message-ID: <5A322EBE.9040108@huawei.com>
References: <20171214033936.6534-1-yanaijie@huawei.com>
 <20171214074227.GA30120@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171214074227.GA30120@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, "Ewan D . Milne" <emilne@redhat.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org


On 2017/12/14 15:42, Greg KH wrote:
> On Thu, Dec 14, 2017 at 11:39:36AM +0800, Jason Yan wrote:
>> Some driviers may have the chance to increase a reference count that
>> has dropped to zero when using get_device() because of their design.
> Then those drivers are broken :)
>
>> We have met such a issue with scsi:
>> https://www.spinics.net/lists/linux-scsi/msg115295.html
>>
>> The scsi core will keep the scsi device object in the host list after
>> it has been deleted and the iterator can still find it. All of the
>> places where need iterating have to check the state of the scsi device
>> and this makes a lot of code redundancy and complexity.
>>
>> Provide a safe mechanism in get_device() by using
>> kobject_get_unless_zero().
>>
>> Suggested-by: Bart Van Assche <bart.vanassche@wdc.com>
>> Signed-off-by: Jason Yan <yanaijie@huawei.com>
>> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> CC: Bart Van Assche <bart.vanassche@wdc.com>
>> CC: Ewan D. Milne <emilne@redhat.com>
>> CC: James E.J. Bottomley <jejb@linux.vnet.ibm.com>
>> CC: Christoph Hellwig <hch@lst.de>
>> ---
>>   drivers/base/core.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/base/core.c b/drivers/base/core.c
>> index 12ebd05..cc74810 100644
>> --- a/drivers/base/core.c
>> +++ b/drivers/base/core.c
>> @@ -1916,7 +1916,7 @@ EXPORT_SYMBOL_GPL(device_register);
>>    */
>>   struct device *get_device(struct device *dev)
>>   {
>> -	return dev ? kobj_to_dev(kobject_get(&dev->kobj)) : NULL;
>> +	return dev && kobject_get_unless_zero(&dev->kobj) ? dev : NULL;
> I really don't want to do this, the bus the device is on should prevent
> this from happening.
>
> Also, once that reference count drops to zero, the memory should be
> freed, so you really have a stale pointer here, and this code would fail
> if you had slab debugging enabled anyway.

Actually I don't want this either. But the design of scsi core will 
leave the scsi device on the
host list after it is deleted, and it can  be found later and the 
refcount have a very big chance
to increase from zero again. And after a lot of discussion it seems that 
the scsi layer is difficult
to change the situation in the near future.

> So I don't even think this fixes the issue you think it fixes :)

This issue is very easy to reproduce on my machine and I have tested the 
patch and it really
fixes the issue.

> thanks,
>
> greg k-h
>
> .
>
