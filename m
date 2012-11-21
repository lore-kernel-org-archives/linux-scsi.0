From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 6/7] Fix race between starved list processing and device
 removal
Date: Wed, 21 Nov 2012 12:06:35 +0100
Message-ID: <50ACB5BB.6060409@acm.org>
References: <508A7B63.60608@acm.org> <508A7C6D.8070002@acm.org> <267107B7B5D6404FB174AB273F79D8BD1A4C39@SHSMSX101.ccr.corp.intel.com> <508E936F.7050004@acm.org> <267107B7B5D6404FB174AB273F79D8BD1A5BC4@SHSMSX101.ccr.corp.intel.com> <5093A4E5.20207@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:32914 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067Ab2KULGj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Nov 2012 06:06:39 -0500
In-Reply-To: <5093A4E5.20207@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Zhuang, Jin Can" <jin.can.zhuang@intel.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>

On 11/02/12 11:48, Bart Van Assche wrote:
> [PATCH] Fix race between starved list processing and device removal
> [ ... ]
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index ce5224c..2f0f31e 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -348,7 +348,6 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
>   	starget->reap_ref++;
>   	list_del(&sdev->siblings);
>   	list_del(&sdev->same_target_siblings);
> -	list_del(&sdev->starved_entry);
>   	spin_unlock_irqrestore(sdev->host->host_lock, flags);
>
>   	cancel_work_sync(&sdev->event_work);
> @@ -956,6 +955,8 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
>   void __scsi_remove_device(struct scsi_device *sdev)
>   {
>   	struct device *dev = &sdev->sdev_gendev;
> +	struct Scsi_Host *shost = sdev->host;
> +	unsigned long flags;
>
>   	if (sdev->is_visible) {
>   		if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
> @@ -973,7 +974,13 @@ void __scsi_remove_device(struct scsi_device *sdev)
>   	 * scsi_run_queue() invocations have finished before tearing down the
>   	 * device.
>   	 */
> +
>   	scsi_device_set_state(sdev, SDEV_DEL);
> +
> +	spin_lock_irqsave(shost->host_lock, flags);
> +	list_del(&sdev->starved_entry);
> +	spin_unlock_irqrestore(shost->host_lock, flags);
> +
>   	blk_cleanup_queue(sdev->request_queue);
>   	cancel_work_sync(&sdev->requeue_work);
>

Please ignore this patch. Even with this patch applied there is still a 
race condition present, namely that the __blk_run_queue() call in 
scsi_run_queue() can get invoked after __scsi_remove_device() invoked 
put_device().

Bart.

