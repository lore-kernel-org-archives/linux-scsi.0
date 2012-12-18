From: David Milburn <dmilburn@redhat.com>
Subject: Re: [PATCH] scsi: remove device when state is changed to deleted
 thru sysfs
Date: Tue, 18 Dec 2012 08:57:23 -0600
Message-ID: <50D08453.7030802@redhat.com>
References: <1355786812-17908-1-git-send-email-dmilburn@redhat.com> <50D02095.2080505@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15514 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754832Ab2LRO50 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Dec 2012 09:57:26 -0500
In-Reply-To: <50D02095.2080505@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org, JBottomley@parallels.com

Bart Van Assche wrote:
> On 12/18/12 00:26, David Milburn wrote:
>> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
>> index ce5224c..6d72abb 100644
>> --- a/drivers/scsi/scsi_sysfs.c
>> +++ b/drivers/scsi/scsi_sysfs.c
>> @@ -596,7 +596,7 @@ static ssize_t
>>   store_state_field(struct device *dev, struct device_attribute *attr,
>>             const char *buf, size_t count)
>>   {
>> -    int i;
>> +    int i, rc;
>>       struct scsi_device *sdev = to_scsi_device(dev);
>>       enum scsi_device_state state = 0;
>>
>> @@ -611,7 +611,11 @@ store_state_field(struct device *dev, struct 
>> device_attribute *attr,
>>       if (!state)
>>           return -EINVAL;
>>
>> -    if (scsi_device_set_state(sdev, state))
>> +    if (state == SDEV_DEL) {
>> +        rc = device_schedule_callback(dev, sdev_store_delete_callback);
>> +        if (rc)
>> +            count = rc;
>> +    } else if (scsi_device_set_state(sdev, state))
>>           return -EINVAL;
>>       return count;
>>   }
> 
> Hello David,
> 
> And what about the "cancel" state ? I guess this means that you have 
> missed patch http://marc.info/?l=linux-scsi&m=135480941801843 ?

Hi Bart,

Sorry, I did miss that patch.

Adding SDEV_CANCEL to the above check would result in __scsi_remove_device()
not completing since it wouldn't be able to set the device state from 
SDEV_CANCEL
to SDEV_CANCEL. Your patch to not allow this state change makes sense.

Thanks,
David



> 
> Bart.
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

