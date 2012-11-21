From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 6/7] Fix race between starved list processing and device
 removal
Date: Wed, 21 Nov 2012 13:10:36 +0100
Message-ID: <50ACC4BC.2050406@acm.org>
References: <508A7B63.60608@acm.org> <508A7C6D.8070002@acm.org> <267107B7B5D6404FB174AB273F79D8BD1A4C39@SHSMSX101.ccr.corp.intel.com> <508E936F.7050004@acm.org> <267107B7B5D6404FB174AB273F79D8BD1A5BC4@SHSMSX101.ccr.corp.intel.com> <026701cdb8c3$d2e3cb50$78ab61f0$@min@lge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:35885 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688Ab2KUMKm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Nov 2012 07:10:42 -0500
In-Reply-To: <026701cdb8c3$d2e3cb50$78ab61f0$@min@lge.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chanho Min <chanho.min@lge.com>
Cc: "'Zhuang, Jin Can'" <jin.can.zhuang@intel.com>, 'linux-scsi' <linux-scsi@vger.kernel.org>, 'James Bottomley' <jbottomley@parallels.com>, 'Mike Christie' <michaelc@cs.wisc.edu>, 'Jens Axboe' <axboe@kernel.dk>, 'Tejun Heo' <tj@kernel.org>

On 11/02/12 07:32, Chanho Min wrote:
>> Yes. Here's the warning.
>> For the trace below, I used scsi_device_get/scsi_device_put() in scsi_run_queue(). (A little different
>>from your patch). But I think it's the same.
> 
> I think it's correct. cancel_work_sync can sleep. It is caught under CONFIG_DEBUG_ATOMIC_SLEEP.
> What if we only enable irq at cancel_work_sync as the patch bellows?
> 
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index bb7c482..6e17db9 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -350,7 +350,9 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
>          list_del(&sdev->starved_entry);
>          spin_unlock_irqrestore(sdev->host->host_lock, flags);
>   
> +       local_irq_enable();
>          cancel_work_sync(&sdev->event_work);
> +       local_irq_restore(flags);
>   
>          list_for_each_safe(this, tmp, &sdev->event_list) {
>                  struct scsi_event *evt;
> 

As far as I can see this should work but unfortunately this change
creates a nontrivial dependency between scsi_run_queue() and
scsi_device_dev_release_usercontext(). Personally I would prefer
something like this follow-up patch:

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 71bddec..20ea2e9 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -453,15 +453,12 @@ static void scsi_run_queue(struct request_queue *q)
                }
 
                get_device(&sdev->sdev_gendev);
-               spin_unlock(shost->host_lock);
-
-               spin_lock(sdev->request_queue->queue_lock);
-               __blk_run_queue(sdev->request_queue);
-               spin_unlock(sdev->request_queue->queue_lock);
+               spin_unlock_irqrestore(shost->host_lock, flags);
 
+               blk_run_queue(sdev->request_queue);
                put_device(&sdev->sdev_gendev);
 
-               spin_lock(shost->host_lock);
+               spin_lock_irqsave(shost->host_lock, flags);
        }
        /* put any unprocessed entries back */
        list_splice(&starved_list, &shost->starved_list);

Bart.
