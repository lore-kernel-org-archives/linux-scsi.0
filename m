From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v7 4/9] Remove offline devices when removing a host
Date: Fri, 07 Dec 2012 16:33:19 +0100
Message-ID: <50C20C3F.6020003@acm.org>
References: <50C0BEEE.4040907@acm.org> <50C0C00E.60709@acm.org> <50C206DC.3040202@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from juliette.telenet-ops.be ([195.130.137.74]:43658 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756567Ab2LGPdX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Dec 2012 10:33:23 -0500
In-Reply-To: <50C206DC.3040202@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>

On 12/07/12 16:10, Hannes Reinecke wrote:
> On 12/06/2012 04:55 PM, Bart Van Assche wrote:
>> Currently __scsi_remove_device() skips devices that are visible and
>> offline. Make sure that these devices get removed by changing their
>> device state into SDEV_DEL at the start of __scsi_remove_device().
>> Also, avoid that __scsi_remove_device() gets called a second time
>> for devices that are in state SDEV_CANCEL when scsi_forget_host()
>> is invoked.
>>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> Cc: James Bottomley <JBottomley@Parallels.com>
>> Cc: Mike Christie <michaelc@cs.wisc.edu>
>> Cc: Hannes Reinecke <hare@suse.de>
>> Cc: Tejun Heo <tj@kernel.org>
>> ---
>>   drivers/scsi/scsi_scan.c  |    2 +-
>>   drivers/scsi/scsi_sysfs.c |    4 ++--
>>   2 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
>> index 3e58b22..0612fba 100644
>> --- a/drivers/scsi/scsi_scan.c
>> +++ b/drivers/scsi/scsi_scan.c
>> @@ -1889,7 +1889,7 @@ void scsi_forget_host(struct Scsi_Host *shost)
>>    restart:
>>       spin_lock_irqsave(shost->host_lock, flags);
>>       list_for_each_entry(sdev, &shost->__devices, siblings) {
>> -        if (sdev->sdev_state == SDEV_DEL)
>> +        if (scsi_device_being_removed(sdev))
>>               continue;
>>           spin_unlock_irqrestore(shost->host_lock, flags);
>>           __scsi_remove_device(sdev);
>> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
>> index 2ff7ba5..4348f12 100644
>> --- a/drivers/scsi/scsi_sysfs.c
>> +++ b/drivers/scsi/scsi_sysfs.c
>> @@ -959,8 +959,8 @@ void __scsi_remove_device(struct scsi_device *sdev)
>>       unsigned long flags;
>>
>>       if (sdev->is_visible) {
>> -        if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
>> -            return;
>> +        WARN_ON_ONCE(scsi_device_set_state(sdev, SDEV_CANCEL) != 0 &&
>> +                 scsi_device_set_state(sdev, SDEV_DEL) != 0);
>>
>>           bsg_unregister_queue(sdev->request_queue);
>>           device_unregister(&sdev->sdev_dev);
>>
> Hmm. Then we would be getting a warning if the device is already in
> SDEV_DEL, wouldn't we?
> And what about offlined devices?
> We should be safe to remove them, or?

Hello Hannes,

The intent of this patch is that __scsi_remove_device() gets invoked 
exactly once per device. This function shouldn't be invoked for devices 
already in state SDEV_DEL.

Offlined devices will be transitioned directly from one of the two 
offline states into state SDEV_DEL.

The above patch fixes a nasty crash by avoiding that a second 
__scsi_remove_device() call queues I/O (sd_shutdown()) after 
scsi_remove_host() has already finished.

Bart.
