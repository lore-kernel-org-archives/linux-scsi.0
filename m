From: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH] scsi: fnic: use kernel's '%pM' format option to print
 MAC
Date: Thu, 19 Mar 2015 21:50:53 -0500
Message-ID: <550B8B0D.6010901@opengridcomputing.com>
References: <1398782723-13433-1-git-send-email-andriy.shevchenko@linux.intel.com> <1426787642.14897.375.camel@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1426787642.14897.375.camel-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Hiral Patel <hiralpat-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hi Andy,

On 3/19/15 12:54 PM, Andy Shevchenko wrote:
> On Tue, 2014-04-29 at 17:45 +0300, Andy Shevchenko wrote:
>> Instead of supplying each byte through stack let's use %pM specifier.
> Anyone to comment or apply this patch?
>
>> Signed-off-by: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>> Cc: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
>> Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
>> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> ---
>>   drivers/scsi/fnic/vnic_dev.c | 10 ++--------
>>   1 file changed, 2 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/scsi/fnic/vnic_dev.c b/drivers/scsi/fnic/vnic_dev.c
>> index 9795d6f..ba69d61 100644
>> --- a/drivers/scsi/fnic/vnic_dev.c
>> +++ b/drivers/scsi/fnic/vnic_dev.c
>> @@ -499,10 +499,7 @@ void vnic_dev_add_addr(struct vnic_dev *vdev, u8 *addr)
>>   
>>   	err = vnic_dev_cmd(vdev, CMD_ADDR_ADD, &a0, &a1, wait);
>>   	if (err)
>> -		printk(KERN_ERR
>> -			"Can't add addr [%02x:%02x:%02x:%02x:%02x:%02x], %d\n",
>> -			addr[0], addr[1], addr[2], addr[3], addr[4], addr[5],
>> -			err);
>> +		pr_err("Can't add addr [%pM], %d\n", addr, err);

This looks completely reasonable to me.

Tom
>>   }
>>   
>>   void vnic_dev_del_addr(struct vnic_dev *vdev, u8 *addr)
>> @@ -517,10 +514,7 @@ void vnic_dev_del_addr(struct vnic_dev *vdev, u8 *addr)
>>   
>>   	err = vnic_dev_cmd(vdev, CMD_ADDR_DEL, &a0, &a1, wait);
>>   	if (err)
>> -		printk(KERN_ERR
>> -			"Can't del addr [%02x:%02x:%02x:%02x:%02x:%02x], %d\n",
>> -			addr[0], addr[1], addr[2], addr[3], addr[4], addr[5],
>> -			err);
>> +		pr_err("Can't del addr [%pM], %d\n", addr, err);
>>   }
>>   
>>   int vnic_dev_notify_set(struct vnic_dev *vdev, u16 intr)
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
