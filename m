From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v11 1/9] Fix race between starved list and device removal
Date: Mon, 24 Jun 2013 08:38:40 -0700
Message-ID: <1372088320.2013.33.camel@dabdike.int.hansenpartnership.com>
References: <51B86E26.6030108@acm.org> <51B86E74.60909@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34338 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750872Ab3FXPin (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Jun 2013 11:38:43 -0400
In-Reply-To: <51B86E74.60909@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Joe Lawrence <jdl1291@gmail.com>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, David Milburn <dmilburn@redhat.com>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>

On Wed, 2013-06-12 at 14:49 +0200, Bart Van Assche wrote:
> scsi_run_queue() examines all SCSI devices that are present on
> the starved list. Since scsi_run_queue() unlocks the SCSI host
> lock before running a queue a SCSI device can get removed after
> it has been removed from the starved list and before its queue
> is run. Protect against that race condition by increasing the
> sdev refcount before running the sdev queue. Also, remove a
> SCSI device from the starved list before __scsi_remove_device()
> decreases the sdev refcount such that the get_device() call
> added in scsi_run_queue() is guaranteed to succeed.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Reported-and-tested-by: Chanho Min <chanho.min@lge.com>
> Reference: http://lkml.org/lkml/2012/8/2/96
> Acked-by: Tejun Heo <tj@kernel.org>
> Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: <stable@vger.kernel.org>
> ---
>  drivers/scsi/scsi_lib.c   |   16 +++++++++++-----
>  drivers/scsi/scsi_sysfs.c |   14 +++++++++++++-
>  2 files changed, 24 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 86d5220..d6ca072 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -456,11 +456,17 @@ static void scsi_run_queue(struct request_queue *q)
>  			continue;
>  		}
>  
> -		spin_unlock(shost->host_lock);
> -		spin_lock(sdev->request_queue->queue_lock);
> -		__blk_run_queue(sdev->request_queue);
> -		spin_unlock(sdev->request_queue->queue_lock);
> -		spin_lock(shost->host_lock);
> +		/*
> +		 * Obtain a reference before unlocking the host_lock such that
> +		 * the sdev can't disappear before blk_run_queue() is invoked.
> +		 */
> +		get_device(&sdev->sdev_gendev);
> +		spin_unlock_irqrestore(shost->host_lock, flags);
> +
> +		blk_run_queue(sdev->request_queue);
> +		put_device(&sdev->sdev_gendev);
> +
> +		spin_lock_irqsave(shost->host_lock, flags);
>  	}
>  	/* put any unprocessed entries back */
>  	list_splice(&starved_list, &shost->starved_list);
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 931a7d9..34f1b39 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -345,7 +345,6 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
>  	starget->reap_ref++;
>  	list_del(&sdev->siblings);
>  	list_del(&sdev->same_target_siblings);
> -	list_del(&sdev->starved_entry);
>  	spin_unlock_irqrestore(sdev->host->host_lock, flags);
>  
>  	cancel_work_sync(&sdev->event_work);
> @@ -953,6 +952,8 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
>  void __scsi_remove_device(struct scsi_device *sdev)
>  {
>  	struct device *dev = &sdev->sdev_gendev;
> +	struct Scsi_Host *shost = sdev->host;
> +	unsigned long flags;
>  
>  	if (sdev->is_visible) {
>  		if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
> @@ -974,6 +975,17 @@ void __scsi_remove_device(struct scsi_device *sdev)
>  	blk_cleanup_queue(sdev->request_queue);
>  	cancel_work_sync(&sdev->requeue_work);
>  
> +	/*
> +	 * Remove a SCSI device from the starved list after blk_cleanup_queue()
> +	 * finished such that scsi_request_fn() can't add it back to that list.
> +	 * Also remove an sdev from the starved list before invoking
> +	 * put_device() such that get_device() is guaranteed to succeed for an
> +	 * sdev present on the starved list.
> +	 */
> +	spin_lock_irqsave(shost->host_lock, flags);
> +	list_del(&sdev->starved_entry);
> +	spin_unlock_irqrestore(shost->host_lock, flags);
> +
>  	if (sdev->host->hostt->slave_destroy)
>  		sdev->host->hostt->slave_destroy(sdev);
>  	transport_destroy_device(dev);

I really don't like this because it's shuffling potentially fragile
lifetime rules since you now have to have the sdev deleted from the
starved list before final put.  That becomes an unstated assumption
within the code.

The theory is that the starved list processing may be racing with a
scsi_remove_device, so when we unlock the host lock, the device (and the
queue) may be destroyed.  OK, so I agree with this, remote a possibility
though it may be.  The easy way of fixing it without making assumptions
is this, isn't it?  All it requires is that the queue be destroyed after
the starved list entry is deleted in the sdev release code.

James

---

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 86d5220..f294cc6 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -434,6 +434,7 @@ static void scsi_run_queue(struct request_queue *q)
 	list_splice_init(&shost->starved_list, &starved_list);
 
 	while (!list_empty(&starved_list)) {
+		struct request_queue *slq;
 		/*
 		 * As long as shost is accepting commands and we have
 		 * starved queues, call blk_run_queue. scsi_request_fn
@@ -456,10 +457,21 @@ static void scsi_run_queue(struct request_queue *q)
 			continue;
 		}
 
+		/*
+		 * once we drop the host lock, a racing scsi_remove_device may
+		 * remove the sdev from the starved list and destroy it and
+		 * the queue.  Mitigate by taking a reference to the queue and
+		 * never touching the sdev again after we drop the host lock.
+		 */
+		slq = sdev->request_queue;
+		if (!blk_get_queue(slq))
+			continue;
+
 		spin_unlock(shost->host_lock);
-		spin_lock(sdev->request_queue->queue_lock);
-		__blk_run_queue(sdev->request_queue);
-		spin_unlock(sdev->request_queue->queue_lock);
+
+		blk_run_queue(slq);
+		blk_put_queue(slq);
+
 		spin_lock(shost->host_lock);
 	}
 	/* put any unprocessed entries back */


