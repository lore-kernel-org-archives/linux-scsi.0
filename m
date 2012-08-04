From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] fix NULL-pointer dereference on scsi_run_queue
Date: Sat, 04 Aug 2012 09:01:25 +0000
Message-ID: <501CE4E5.20604@acm.org>
References: <CAOAMb1D+g0zzKGKjMPPp7V-XEwKB5AYGMDvUUbXNaHaz8ieTVg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOAMb1D+g0zzKGKjMPPp7V-XEwKB5AYGMDvUUbXNaHaz8ieTVg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chanho Min <chanho0207@gmail.com>
Cc: James Bottomley <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Mike Christie <michaelc@cs.wisc.edu>
List-Id: linux-scsi@vger.kernel.org

On 08/02/12 08:41, Chanho Min wrote:
> This patch is to fix a oops from a torn down device. When
> scsi_run_queue process starved queues, scsi_request_fn can race with
> scsi_remove_device. In this case, rarely, scsi_request_fn release the
> last reference and set sdev->request_queue to NULL. It result in
> NULL-pointer dereference when spin_unlock is tried with (NULL)->
> queue_lock. We need to add an extra reference to the device on both
> sides of the __blk_run_queue to hold reference until scsi_request_fn
> is finished.

Good catch. So far I haven't been able to trigger this issue in my
tests. So it would be appreciated if you could verify whether the patch
below helps (patch is based on 3.6-rc1):

---
 drivers/scsi/scsi_sysfs.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 093d4f6..59e523c 100644
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
@@ -977,6 +978,11 @@ void __scsi_remove_device(struct scsi_device *sdev)
 	blk_cleanup_queue(sdev->request_queue);
 	cancel_work_sync(&sdev->requeue_work);
 
+	spin_lock_irqsave(shost->host_lock, flags);
+	if (!list_empty(&sdev->starved_entry))
+		list_del(&sdev->starved_entry);
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
 	if (sdev->host->hostt->slave_destroy)
 		sdev->host->hostt->slave_destroy(sdev);
 	transport_destroy_device(dev);
-- 
1.7.7
