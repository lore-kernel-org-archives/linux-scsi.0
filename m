From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v11 3/9] Avoid calling __scsi_remove_device() twice
Date: Mon, 24 Jun 2013 08:29:52 +0200
Message-ID: <51C7E760.2010504@acm.org>
References: <51B86E26.6030108@acm.org> <51B86EF9.7080406@acm.org> <51C76A29.30309@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from georges.telenet-ops.be ([195.130.137.68]:46348 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab3FXG35 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jun 2013 02:29:57 -0400
In-Reply-To: <51C76A29.30309@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Joe Lawrence <jdl1291@gmail.com>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, David Milburn <dmilburn@redhat.com>, James Bottomley <jbottomley@parallels.com>, Hannes Reinecke <hare@suse.de>

On 06/23/13 23:35, Mike Christie wrote:
> On 06/12/2013 07:52 AM, Bart Van Assche wrote:
>> SCSI devices are added to the shost->__devices list from inside
>> scsi_alloc_sdev(). If something goes wrong during LUN scanning,
>> e.g. a transport layer failure occurs, then __scsi_remove_device()
>> can get invoked by the LUN scanning code for a SCSI device in
>> state SDEV_CREATED_BLOCK or SDEV_BLOCKED. If this happens then
>> the SCSI device has not yet been added to sysfs (is_visible == 0).
>> Make sure that if this happens these devices are transitioned
>> into state SDEV_DEL. This avoids that __scsi_remove_device()
>> gets invoked a second time by scsi_forget_host().
>>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> Cc: James Bottomley <JBottomley@Parallels.com>
>> Cc: Mike Christie <michaelc@cs.wisc.edu>
>> Cc: Hannes Reinecke <hare@suse.de>
>> Cc: Tejun Heo <tj@kernel.org>
>> ---
>>   drivers/scsi/scsi_lib.c   |    2 ++
>>   drivers/scsi/scsi_sysfs.c |    7 ++++---
>>   2 files changed, 6 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index 03d4165..d57b5e1 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -2175,6 +2175,8 @@ scsi_device_set_state(struct scsi_device *sdev, enum scsi_device_state state)
>>   		case SDEV_OFFLINE:
>>   		case SDEV_TRANSPORT_OFFLINE:
>>   		case SDEV_CANCEL:
>> +		case SDEV_BLOCK:
>> +		case SDEV_CREATED_BLOCK:
>>   			break;
>>   		default:
>>   			goto illegal;
>> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
>> index 34f1b39..f869ef85 100644
>> --- a/drivers/scsi/scsi_sysfs.c
>> +++ b/drivers/scsi/scsi_sysfs.c
>> @@ -956,8 +956,9 @@ void __scsi_remove_device(struct scsi_device *sdev)
>>   	unsigned long flags;
>>
>>   	if (sdev->is_visible) {
>> -		if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
>> -			return;
>> +		WARN(scsi_device_set_state(sdev, SDEV_CANCEL) != 0,
>> +		     "%s: unexpected state %d\n", dev_name(&sdev->sdev_gendev),
>> +		     sdev->sdev_state);
>>
>>   		bsg_unregister_queue(sdev->request_queue);
>>   		device_unregister(&sdev->sdev_dev);
>> @@ -971,7 +972,7 @@ void __scsi_remove_device(struct scsi_device *sdev)
>>   	 * scsi_run_queue() invocations have finished before tearing down the
>>   	 * device.
>>   	 */
>> -	scsi_device_set_state(sdev, SDEV_DEL);
>> +	WARN_ON_ONCE(scsi_device_set_state(sdev, SDEV_DEL) != 0);
>>   	blk_cleanup_queue(sdev->request_queue);
>>   	cancel_work_sync(&sdev->requeue_work);
>
> The Addition to scsi_device_set_state looks ok. I was not sure why we
> need the new WARNs though. Do we still think there are other cases?

Hello Mike,

The new WARN statements helped me while testing and debugging this code. 
These statements might also be helpful if anyone would ever add more 
SCSI device states. I can leave these out if you want.

Bart.

