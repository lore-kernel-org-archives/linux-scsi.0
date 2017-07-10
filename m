From: Douglas Miller <dougmill@linux.vnet.ibm.com>
Subject: Re: [PATCH] ses: do not add a device to an enclosure if
 enclosure_add_links() fails.
Date: Mon, 10 Jul 2017 08:27:28 -0500
Message-ID: <7d12dd37-74b9-5593-bfcc-3a375baacf65@linux.vnet.ibm.com>
References: <1498557207-12364-1-git-send-email-mlombard@redhat.com>
 <bdbe2093-8abc-b48d-7a23-0734fadf33ac@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57496 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753943AbdGJN1d (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 10 Jul 2017 09:27:33 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v6ADOPO7014148
        for <linux-scsi@vger.kernel.org>; Mon, 10 Jul 2017 09:27:32 -0400
Received: from e14.ny.us.ibm.com (e14.ny.us.ibm.com [129.33.205.204])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2bjvs2wt52-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 10 Jul 2017 09:27:32 -0400
Received: from localhost
        by e14.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <dougmill@linux.vnet.ibm.com>;
        Mon, 10 Jul 2017 09:27:32 -0400
In-Reply-To: <bdbe2093-8abc-b48d-7a23-0734fadf33ac@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maurizio Lombardi <mlombard@redhat.com>, linux-scsi@vger.kernel.org
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com

On 06/27/2017 07:50 AM, Douglas Miller wrote:
> On 06/27/2017 04:53 AM, Maurizio Lombardi wrote:
>> The enclosure_add_device() function should fail if it can't
>> create the relevant sysfs links.
>>
>> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
>> ---
>>   drivers/misc/enclosure.c | 14 ++++++++++----
>>   1 file changed, 10 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
>> index d3fe3ea..eb29113 100644
>> --- a/drivers/misc/enclosure.c
>> +++ b/drivers/misc/enclosure.c
>> @@ -375,6 +375,7 @@ int enclosure_add_device(struct enclosure_device 
>> *edev, int component,
>>                struct device *dev)
>>   {
>>       struct enclosure_component *cdev;
>> +    int err;
>>
>>       if (!edev || component >= edev->components)
>>           return -EINVAL;
>> @@ -384,12 +385,17 @@ int enclosure_add_device(struct 
>> enclosure_device *edev, int component,
>>       if (cdev->dev == dev)
>>           return -EEXIST;
>>
>> -    if (cdev->dev)
>> +    if (cdev->dev) {
>>           enclosure_remove_links(cdev);
>> -
>> -    put_device(cdev->dev);
>> +        put_device(cdev->dev);
>> +    }
>>       cdev->dev = get_device(dev);
>> -    return enclosure_add_links(cdev);
>> +    err = enclosure_add_links(cdev);
>> +    if (err) {
>> +        put_device(cdev->dev);
>> +        cdev->dev = NULL;
>> +    }
>> +    return err;
>>   }
>>   EXPORT_SYMBOL_GPL(enclosure_add_device);
>>
> Tested-by: Douglas Miller <dougmill@linux.vnet.ibm.com>
>
> This fixes a problem where udevd (insmod ses) races with/overtakes 
> do_scan_async(), which creates the directory target of the symlink, 
> resulting in missing enclosure symlinks. This patch relaxes the 
> symlink creation allowing for delayed addition to enclosure and 
> creation of symlinks after do_scan_async() has created the target 
> directory.
>
Has there been any progress with getting this patch accepted?
