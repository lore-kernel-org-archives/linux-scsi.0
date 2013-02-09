From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v7 1/9] Fix race between starved list processing and device
 removal
Date: Sat, 09 Feb 2013 16:06:39 +0100
Message-ID: <511665FF.8090408@acm.org>
References: <50C0BEEE.4040907@acm.org> <50C0BF50.4080009@acm.org> <034101cdee08$2d67f870$8837e950$@min@lge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:58941 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932309Ab3BIPGm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Feb 2013 10:06:42 -0500
In-Reply-To: <034101cdee08$2d67f870$8837e950$@min@lge.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <jbottomley@parallels.com>
Cc: Chanho Min <chanho.min@lge.com>, 'linux-scsi' <linux-scsi@vger.kernel.org>

Hello James,

Please consider this patch for inclusion in kernel 3.9.

Thanks,

Bart.

On 01/09/13 02:25, Chanho Min wrote:
> Is there any progress in this patch?
> Oops is still occurred from a torn down device due to this cause.
> We look forward to this patch is applied to mainline ASAP.
>
> Thanks
> Chanho Min
>
>> -----Original Message-----
>> From: Bart Van Assche [mailto:bvanassche@acm.org]
>> Sent: Friday, December 07, 2012 12:53 AM
>> To: undisclosed-recipients:
>> Cc: linux-scsi; James Bottomley; Mike Christie; Tejun Heo; Chanho Min; Jens Axboe
>> Subject: [PATCH v7 1/9] Fix race between starved list processing and device removal
>>
>> Avoid that the sdev reference count can drop to zero before
>> a queue is run by scsi_run_queue().
>>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> Reported-and-tested-by: Chanho Min <chanho.min@lge.com>
>> Reference: http://lkml.org/lkml/2012/8/2/96
>> Acked-by: Tejun Heo <tj@kernel.org>
>> Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
>> Cc: Jens Axboe <axboe@kernel.dk>
>> Cc: <stable@vger.kernel.org>
>> ---
>> drivers/scsi/scsi_lib.c   |   16 +++++++++++-----
>> drivers/scsi/scsi_sysfs.c |   14 +++++++++++++-
>> 2 files changed, 24 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index f1bf5af..5c67339 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -452,11 +452,17 @@ static void scsi_run_queue(struct request_queue *q)
>> 			continue;
>> 		}
>>
>> -		spin_unlock(shost->host_lock);
>> -		spin_lock(sdev->request_queue->queue_lock);
>> -		__blk_run_queue(sdev->request_queue);
>> -		spin_unlock(sdev->request_queue->queue_lock);
>> -		spin_lock(shost->host_lock);
>> +		/*
>> +		 * Obtain a reference before unlocking the host_lock such that
>> +		 * the sdev can't disappear before blk_run_queue() is invoked.
>> +		 */
>> +		get_device(&sdev->sdev_gendev);
>> +		spin_unlock_irqrestore(shost->host_lock, flags);
>> +
>> +		blk_run_queue(sdev->request_queue);
>> +		put_device(&sdev->sdev_gendev);
>> +
>> +		spin_lock_irqsave(shost->host_lock, flags);
>> 	}
>> 	/* put any unprocessed entries back */
>> 	list_splice(&starved_list, &shost->starved_list);
>> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
>> index ce5224c..2ff7ba5 100644
>> --- a/drivers/scsi/scsi_sysfs.c
>> +++ b/drivers/scsi/scsi_sysfs.c
>> @@ -348,7 +348,6 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
>> 	starget->reap_ref++;
>> 	list_del(&sdev->siblings);
>> 	list_del(&sdev->same_target_siblings);
>> -	list_del(&sdev->starved_entry);
>> 	spin_unlock_irqrestore(sdev->host->host_lock, flags);
>>
>> 	cancel_work_sync(&sdev->event_work);
>> @@ -956,6 +955,8 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
>> void __scsi_remove_device(struct scsi_device *sdev)
>> {
>> 	struct device *dev = &sdev->sdev_gendev;
>> +	struct Scsi_Host *shost = sdev->host;
>> +	unsigned long flags;
>>
>> 	if (sdev->is_visible) {
>> 		if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
>> @@ -977,6 +978,17 @@ void __scsi_remove_device(struct scsi_device *sdev)
>> 	blk_cleanup_queue(sdev->request_queue);
>> 	cancel_work_sync(&sdev->requeue_work);
>>
>> +	/*
>> +	 * Remove a SCSI device from the starved list after blk_cleanup_queue()
>> +	 * finished such that scsi_request_fn() can't add it back to that list.
>> +	 * Also remove an sdev from the starved list before invoking
>> +	 * put_device() such that get_device() is guaranteed to succeed for an
>> +	 * sdev present on the starved list.
>> +	 */
>> +	spin_lock_irqsave(shost->host_lock, flags);
>> +	list_del(&sdev->starved_entry);
>> +	spin_unlock_irqrestore(shost->host_lock, flags);
>> +
>> 	if (sdev->host->hostt->slave_destroy)
>> 		sdev->host->hostt->slave_destroy(sdev);
>> 	transport_destroy_device(dev);
>> --
>> 1.7.10.4
>
>

