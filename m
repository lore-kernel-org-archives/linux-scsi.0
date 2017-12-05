From: Jason Yan <yanaijie@huawei.com>
Subject: Re: [PATCH] scsi: fix race condition when removing target
Date: Tue, 5 Dec 2017 20:37:10 +0800
Message-ID: <5A2692F6.9000306@huawei.com>
References: <20171129030556.47833-1-yanaijie@huawei.com>
 <1511972310.2671.7.camel@wdc.com> <20171129162050.GA32071@lst.de>
 <1511977145.2671.13.camel@wdc.com> <5A1F5C77.5050405@huawei.com>
 <1512058117.2774.1.camel@wdc.com>
 <1512086178.3020.35.camel@linux.vnet.ibm.com> <5A211596.2010707@huawei.com>
 <1512142556.3053.4.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:2209 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752126AbdLEMkY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 5 Dec 2017 07:40:24 -0500
In-Reply-To: <1512142556.3053.4.camel@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, Bart Van Assche <Bart.VanAssche@wdc.com>, "hch@lst.de" <hch@lst.de>
Cc: "zhaohongjiang@huawei.com" <zhaohongjiang@huawei.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "hare@suse.de" <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "miaoxie@huawei.com" <miaoxie@huawei.com>



On 2017/12/1 23:35, James Bottomley wrote:
> On Fri, 2017-12-01 at 16:40 +0800, Jason Yan wrote:
>> On 2017/12/1 7:56, James Bottomley wrote:
>>> b/include/scsi/scsi_device.h
>>> index 571ddb49b926..2e4d48d8cd68 100644
>>> --- a/include/scsi/scsi_device.h
>>> +++ b/include/scsi/scsi_device.h
>>> @@ -380,6 +380,23 @@ extern struct scsi_device
>>> *__scsi_iterate_devices(struct Scsi_Host *,
>>>    #define __shost_for_each_device(sdev, shost) \
>>>    	list_for_each_entry((sdev), &((shost)->__devices),
>>> siblings)
>>>
>>
>> Seems that __shost_for_each_device() is still not safe. scsi device
>> been deleted stays in the list and put_device() can be called
>> anywhere out of the host lock.
>
> Not if it's used with scsi_get_device().  As I said, I only did a
> cursory inspectiont, so if I've missed a loop, please specify.
>
> The point was more a demonstration of how we could fix the problem if
> we don't change get_device().
>
> James
>

Yes, it's OK now. __shost_for_each_device() is not used with
scsi_get_device() yet.

Another problem is that put_device() cannot be called while holding the
host lock, so we need to remove all put_device() out of the lock. Some
places like scsi_device_lookup() and scsi_device_lookup_by_target() need 
rework:

@@ -765,12 +772,22 @@ struct scsi_device *scsi_device_lookup(struct 
Scsi_Host *shost,
         unsigned long flags;

         spin_lock_irqsave(shost->host_lock, flags);
-       sdev = __scsi_device_lookup(shost, channel, id, lun);
-       if (sdev && scsi_device_get(sdev))
-               sdev = NULL;
+       __sdev_for_each_get(sdev, &shost->__devices, siblings) {
+               spin_unlock_irqrestore(shost->host_lock, flags);
+               if (sdev->sdev_state != SDEV_DEL &&
+                   sdev->channel == channel && sdev->id == id &&
+                   sdev->lun ==lun) {
+                       if (!scsi_device_get(sdev)) {
+                               put_device(&sdev->sdev_gendev);
+                               return sdev;
+                       }
+               }
+               put_device(&sdev->sdev_gendev);
+               spin_lock_irqsave(shost->host_lock, flags);
+       }
         spin_unlock_irqrestore(shost->host_lock, flags);

-       return sdev;
+       return NULL;
  }
  EXPORT_SYMBOL(scsi_device_lookup);

>
>
