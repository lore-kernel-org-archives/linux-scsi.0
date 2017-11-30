From: Jason Yan <yanaijie@huawei.com>
Subject: Re: [PATCH] scsi: fix race condition when removing target
Date: Thu, 30 Nov 2017 09:18:47 +0800
Message-ID: <5A1F5C77.5050405@huawei.com>
References: <20171129030556.47833-1-yanaijie@huawei.com>
 <1511972310.2671.7.camel@wdc.com> <20171129162050.GA32071@lst.de>
 <1511977145.2671.13.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:11481 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752426AbdK3BY6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Nov 2017 20:24:58 -0500
In-Reply-To: <1511977145.2671.13.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "hch@lst.de" <hch@lst.de>
Cc: "zhaohongjiang@huawei.com" <zhaohongjiang@huawei.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "hare@suse.de" <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "miaoxie@huawei.com" <miaoxie@huawei.com>



On 2017/11/30 1:39, Bart Van Assche wrote:
> On Wed, 2017-11-29 at 17:20 +0100, hch@lst.de wrote:
>> On Wed, Nov 29, 2017 at 04:18:30PM +0000, Bart Van Assche wrote:
>>> As the above patch description shows it can happen that the SCSI core calls
>>> get_device() after the device reference count has reached zero and before
>>> the memory for struct device is freed. Although the above patch looks fine
>>> to me, would you consider it acceptable to modify get_device() such that it
>>> uses kobject_get_unless_zero() instead of kobject_get()? I'm asking this
>>> because that change would help to reduce the complexity of the already too
>>> complicated SCSI core.
>>
>> I don't think we can just modify get_device, but we can add a new
>> get_device_unless_zero.  In fact I have an open coded variant of that
>> in nvme, and was planning to submit one for the current merge window..
>
> Sorry but I don't see why we can't modify get_device()? Can you explain why
> you think that something like the patch below is wrong?
>
> Thanks,
>
> Bart.
>

Hi Bart, I chose the approach in my patch because it has been used in
scsi_device_get() for years and been proved safe. I think using
kobject_get_unless_zero() is safe here and can fix this issue too. And
this approach is beneficial to all users.

>
> [PATCH] Make it safe to use get_device() if the reference count is zero
>
> ---
>   drivers/base/core.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 110230d86527..049a5d9dba8a 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -1916,7 +1916,7 @@ EXPORT_SYMBOL_GPL(device_register);
>    */
>   struct device *get_device(struct device *dev)
>   {
> -	return dev ? kobj_to_dev(kobject_get(&dev->kobj)) : NULL;
> +	return dev && kobject_get_unless_zero(&dev->kobj) ? dev : NULL;
>   }
>   EXPORT_SYMBOL_GPL(get_device);
>
