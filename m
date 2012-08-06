From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] fix NULL-pointer dereference on scsi_run_queue
Date: Mon, 06 Aug 2012 17:56:49 +0000
Message-ID: <50200561.4020100@acm.org>
References: <CAOAMb1D+g0zzKGKjMPPp7V-XEwKB5AYGMDvUUbXNaHaz8ieTVg@mail.gmail.com> <501CE4E5.20604@acm.org> <501D51D1.2010806@cs.wisc.edu> <501D83A1.7040900@acm.org> <501DA3F0.4090009@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <501DA3F0.4090009@cs.wisc.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Chanho Min <chanho0207@gmail.com>, James Bottomley <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 08/04/12 22:36, Mike Christie wrote:
> On 08/04/2012 03:18 PM, Bart Van Assche wrote:
>> On 08/04/12 16:46, Mike Christie wrote:
>>> I think we have to have scsi-ml do a get_device when a sdev is added to
>>> the starved entry and then do a put_device when it is removed (must do
>>> these under the host lock for the starved entry case too). I am not sure
>>> if that is just a hack/papering-over of the problem and there are more
>>> issues like this.
>>
>> That would result in a more complex patch than the patch at the start of
>> this thread, isn't it ?
> 
> Yaah, but the original patch in this thread is still racey isn't it?

Indeed. How about the patch below ? Scsi devices are removed from
starved_list after blk_cleanup_queue() and before put_device(). That
guarantees that inside scsi_run_queue() get_device() under host lock
will succeed.

---
 drivers/scsi/scsi_lib.c   |    5 +++++
 drivers/scsi/scsi_sysfs.c |    7 ++++++-
 2 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ffd7773..bd7daec 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -452,10 +452,15 @@ static void scsi_run_queue(struct request_queue *q)
 			continue;
 		}
 
+		get_device(&sdev->sdev_gendev);
 		spin_unlock(shost->host_lock);
+
 		spin_lock(sdev->request_queue->queue_lock);
 		__blk_run_queue(sdev->request_queue);
 		spin_unlock(sdev->request_queue->queue_lock);
+
+		put_device(&sdev->sdev_gendev);
+
 		spin_lock(shost->host_lock);
 	}
 	/* put any unprocessed entries back */
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 093d4f6..44f232e 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -348,7 +348,6 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 	starget->reap_ref++;
 	list_del(&sdev->siblings);
 	list_del(&sdev->same_target_siblings);
-	list_del(&sdev->starved_entry);
 	spin_unlock_irqrestore(sdev->host->host_lock, flags);
 
 	cancel_work_sync(&sdev->event_work);
@@ -956,6 +955,8 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 void __scsi_remove_device(struct scsi_device *sdev)
 {
 	struct device *dev = &sdev->sdev_gendev;
+	struct Scsi_Host *shost = sdev->host;
+	unsigned long flags;
 
 	if (sdev->is_visible) {
 		if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
@@ -977,6 +978,10 @@ void __scsi_remove_device(struct scsi_device *sdev)
 	blk_cleanup_queue(sdev->request_queue);
 	cancel_work_sync(&sdev->requeue_work);
 
+	spin_lock_irqsave(shost->host_lock, flags);
+	list_del(&sdev->starved_entry);
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
 	if (sdev->host->hostt->slave_destroy)
 		sdev->host->hostt->slave_destroy(sdev);
 	transport_destroy_device(dev);
-- 
1.7.7
