From: Jason Yan <yanaijie@huawei.com>
Subject: Re: [PATCH] scsi: fix race condition when removing target
Date: Fri, 1 Dec 2017 16:40:54 +0800
Message-ID: <5A211596.2010707@huawei.com>
References: <20171129030556.47833-1-yanaijie@huawei.com>
 <1511972310.2671.7.camel@wdc.com> <20171129162050.GA32071@lst.de>
 <1511977145.2671.13.camel@wdc.com> <5A1F5C77.5050405@huawei.com>
 <1512058117.2774.1.camel@wdc.com>
 <1512086178.3020.35.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:11465 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751413AbdLAIla (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Dec 2017 03:41:30 -0500
In-Reply-To: <1512086178.3020.35.camel@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, Bart Van Assche <Bart.VanAssche@wdc.com>, "hch@lst.de" <hch@lst.de>
Cc: "zhaohongjiang@huawei.com" <zhaohongjiang@huawei.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "hare@suse.de" <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "miaoxie@huawei.com" <miaoxie@huawei.com>


On 2017/12/1 7:56, James Bottomley wrote:
> On Thu, 2017-11-30 at 16:08 +0000, Bart Van Assche wrote:
>> On Thu, 2017-11-30 at 09:18 +0800, Jason Yan wrote:
>>>
>>> Hi Bart, I chose the approach in my patch because it has been used
>>> in scsi_device_get() for years and been proved safe. I think using
>>> kobject_get_unless_zero() is safe here and can fix this issue too.
>>> And this approach is beneficial to all users.
>>
>> Hello Jason,
>>
>> A possible approach is that we start with your patch and defer any
>> get_device() changes until after your patch has been applied.
>
> It's possible, but not quite good enough: the same race can be produced
> with any of our sdev lists that are deleted in the release callback,
> because there could be a released device on any one of them.  The only
> way to mediate it properly is to get a reference in the iterator using
> kobject_get_unless_zero().
>
> It's a bit like a huge can of worms, there's another problem every time
> I look.  However, this is something like the mechanism that could work
> (and if get_device() ever gets fixed, we can put it in place of
> kobject_get_unless_zero()).
>
> James
>
> ---
>
> diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
> index 6be77b3aa8a5..c3246f26c02c 100644
> --- a/drivers/scsi/53c700.c
> +++ b/drivers/scsi/53c700.c
> @@ -1169,6 +1169,7 @@ process_script_interrupt(__u32 dsps, __u32 dsp, struct scsi_cmnd *SCp,
>
>   			
>   		}
> +		put_device(&SDp->sdev_gendev);
>   	} else if(dsps == A_RESELECTED_DURING_SELECTION) {
>
>   		/* This section is full of debugging code because I've
> diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
> index c3fc34b9964d..7736f3fb2501 100644
> --- a/drivers/scsi/esp_scsi.c
> +++ b/drivers/scsi/esp_scsi.c
> @@ -1198,6 +1198,7 @@ static int esp_reconnect(struct esp *esp)
>   		goto do_reset;
>   	}
>   	lp = dev->hostdata;
> +	put_device(&dev->sdev_gendev);
>
>   	ent = lp->non_tagged_cmd;
>   	if (!ent) {
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index a7e4fba724b7..c96c11716152 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -677,11 +677,10 @@ struct scsi_device *__scsi_device_lookup_by_target(struct scsi_target *starget,
>   {
>   	struct scsi_device *sdev;
>
> -	list_for_each_entry(sdev, &starget->devices, same_target_siblings) {
> -		if (sdev->sdev_state == SDEV_DEL)
> -			continue;
> -		if (sdev->lun ==lun)
> +	__sdev_for_each_get(sdev, &starget->devices, same_target_siblings) {
> +		if (sdev->sdev_state != SDEV_DEL && sdev->lun ==lun)
>   			return sdev;
> +		put_device(&sdev->sdev_gendev);
>   	}
>
>   	return NULL;
> @@ -700,15 +699,16 @@ EXPORT_SYMBOL(__scsi_device_lookup_by_target);
>   struct scsi_device *scsi_device_lookup_by_target(struct scsi_target *starget,
>   						 u64 lun)
>   {
> -	struct scsi_device *sdev;
> +  struct scsi_device *sdev, *sdev_copy;
>   	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
>   	unsigned long flags;
>
>   	spin_lock_irqsave(shost->host_lock, flags);
> -	sdev = __scsi_device_lookup_by_target(starget, lun);
> +	sdev_copy = sdev = __scsi_device_lookup_by_target(starget, lun);
> +	spin_unlock_irqrestore(shost->host_lock, flags);
>   	if (sdev && scsi_device_get(sdev))
>   		sdev = NULL;
> -	spin_unlock_irqrestore(shost->host_lock, flags);
> +	put_device(&sdev_copy->sdev_gendev);
>
>   	return sdev;
>   }
> @@ -735,12 +735,12 @@ struct scsi_device *__scsi_device_lookup(struct Scsi_Host *shost,
>   {
>   	struct scsi_device *sdev;
>
> -	list_for_each_entry(sdev, &shost->__devices, siblings) {
> -		if (sdev->sdev_state == SDEV_DEL)
> -			continue;
> -		if (sdev->channel == channel && sdev->id == id &&
> -				sdev->lun ==lun)
> +	__sdev_for_each_get(sdev, &shost->__devices, siblings) {
> +		if (sdev->sdev_state != SDEV_DEL &&
> +		    sdev->channel == channel && sdev->id == id &&
> +		    sdev->lun ==lun)
>   			return sdev;
> +		put_device(&sdev->sdev_gendev);
>   	}
>
>   	return NULL;
> @@ -761,14 +761,15 @@ EXPORT_SYMBOL(__scsi_device_lookup);
>   struct scsi_device *scsi_device_lookup(struct Scsi_Host *shost,
>   		uint channel, uint id, u64 lun)
>   {
> -	struct scsi_device *sdev;
> +  struct scsi_device *sdev, *sdev_copy;
>   	unsigned long flags;
>
>   	spin_lock_irqsave(shost->host_lock, flags);
> -	sdev = __scsi_device_lookup(shost, channel, id, lun);
> +	sdev_copy = sdev = __scsi_device_lookup(shost, channel, id, lun);
> +	spin_unlock_irqrestore(shost->host_lock, flags);
>   	if (sdev && scsi_device_get(sdev))
>   		sdev = NULL;
> -	spin_unlock_irqrestore(shost->host_lock, flags);
> +	put_device(&sdev_copy->sdev_gendev);
>
>   	return sdev;
>   }
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 40124648a07b..cddd5a93e962 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -1870,11 +1870,14 @@ void scsi_forget_host(struct Scsi_Host *shost)
>
>    restart:
>   	spin_lock_irqsave(shost->host_lock, flags);
> -	list_for_each_entry(sdev, &shost->__devices, siblings) {
> -		if (sdev->sdev_state == SDEV_DEL)
> +	__sdev_for_each_get(sdev, &shost->__devices, siblings) {
> +		if (sdev->sdev_state == SDEV_DEL) {
> +			put_device(&sdev->sdev_gendev);
>   			continue;
> +		}
>   		spin_unlock_irqrestore(shost->host_lock, flags);
>   		__scsi_remove_device(sdev);
> +		put_device(&sdev->sdev_gendev);
>   		goto restart;
>   	}
>   	spin_unlock_irqrestore(shost->host_lock, flags);
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index f796bd61f3f0..380404ec49cd 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -1375,17 +1375,7 @@ static void __scsi_remove_target(struct scsi_target *starget)
>
>   	spin_lock_irqsave(shost->host_lock, flags);
>    restart:
> -	list_for_each_entry(sdev, &shost->__devices, siblings) {
> -		/*
> -		 * We cannot call scsi_device_get() here, as
> -		 * we might've been called from rmmod() causing
> -		 * scsi_device_get() to fail the module_is_live()
> -		 * check.
> -		 */
> -		if (sdev->channel != starget->channel ||
> -		    sdev->id != starget->id ||
> -		    !get_device(&sdev->sdev_gendev))
> -			continue;
> +	__sdev_for_each_get(sdev, &starget->devices, same_target_siblings) {
>   		spin_unlock_irqrestore(shost->host_lock, flags);
>   		scsi_remove_device(sdev);
>   		put_device(&sdev->sdev_gendev);
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 571ddb49b926..2e4d48d8cd68 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -380,6 +380,23 @@ extern struct scsi_device *__scsi_iterate_devices(struct Scsi_Host *,
>   #define __shost_for_each_device(sdev, shost) \
>   	list_for_each_entry((sdev), &((shost)->__devices), siblings)
>

Seems that __shost_for_each_device() is still not safe. scsi device been 
deleted stays in the list and put_device() can be called anywhere out of 
the host lock.

> +/**
> + * __sdev_list_for_each_get - get a reference to each element
> + * @sdev: the scsi device to use in the body
> + * @head: the head of the list
> + * @list: the element (sdev->list) containing list members
> + *
> + * Iterator that only executes the body if it can obtain a reference
> + * to the element.  This closes a race where the device release can
> + * have been called, but the element is still on the lists.
> + *
> + * The lock protecting the list (the host lock) must be held before
> + * calling this iterator
> + */
> +#define __sdev_for_each_get(sdev, head, list)				\
> +	list_for_each_entry(sdev, head, list)				\
> +		if (kobject_get_unless_zero(&sdev->sdev_gendev.kobj))
> +
>   extern int scsi_change_queue_depth(struct scsi_device *, int);
>   extern int scsi_track_queue_full(struct scsi_device *, int);
>
>
>
> .
>
