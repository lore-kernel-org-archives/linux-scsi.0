From: James Bottomley <James.Bottomley@suse.de>
Subject: [GIT PULL] SCSI fixes for 2.6.39-rc5
Date: Fri, 29 Apr 2011 13:13:51 -0500
Message-ID: <1304100831.2559.32.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is a set of assorted fixes including a couple of user induceable
oopses using card interfaces.  The main one is closing a race between
the last put of a device and the queues starting up, which has been
there for ages, but only just started to show.

The patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The short changelog is:

Dan Rosenberg (2):
      pmcraid: reject negative request size
      mpt2sas: prevent heap overflows and unchecked reads

James Bottomley (1):
      put stricter guards on queue dead checks

Mike Snitzer (1):
      scsi_dh: fix reference counting in scsi_dh_activate error path

The diffstat is:

 drivers/scsi/device_handler/scsi_dh.c |    9 ++++++---
 drivers/scsi/mpt2sas/mpt2sas_ctl.c    |   23 +++++++++++++++++++++--
 drivers/scsi/pmcraid.c                |    3 +++
 drivers/scsi/scsi_sysfs.c             |   16 ++++++++--------
 4 files changed, 38 insertions(+), 13 deletions(-)

and the full patch is appended.

James

---

diff --git a/drivers/scsi/device_handler/scsi_dh.c b/drivers/scsi/device_handler/scsi_dh.c
index 564e6ec..0119b81 100644
--- a/drivers/scsi/device_handler/scsi_dh.c
+++ b/drivers/scsi/device_handler/scsi_dh.c
@@ -394,12 +394,14 @@ int scsi_dh_activate(struct request_queue *q, activate_complete fn, void *data)
 	unsigned long flags;
 	struct scsi_device *sdev;
 	struct scsi_device_handler *scsi_dh = NULL;
+	struct device *dev = NULL;
 
 	spin_lock_irqsave(q->queue_lock, flags);
 	sdev = q->queuedata;
 	if (sdev && sdev->scsi_dh_data)
 		scsi_dh = sdev->scsi_dh_data->scsi_dh;
-	if (!scsi_dh || !get_device(&sdev->sdev_gendev) ||
+	dev = get_device(&sdev->sdev_gendev);
+	if (!scsi_dh || !dev ||
 	    sdev->sdev_state == SDEV_CANCEL ||
 	    sdev->sdev_state == SDEV_DEL)
 		err = SCSI_DH_NOSYS;
@@ -410,12 +412,13 @@ int scsi_dh_activate(struct request_queue *q, activate_complete fn, void *data)
 	if (err) {
 		if (fn)
 			fn(data, err);
-		return err;
+		goto out;
 	}
 
 	if (scsi_dh->activate)
 		err = scsi_dh->activate(sdev, fn, data);
-	put_device(&sdev->sdev_gendev);
+out:
+	put_device(dev);
 	return err;
 }
 EXPORT_SYMBOL_GPL(scsi_dh_activate);
diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.c b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
index 1c6d2b4..d72f1f2 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_ctl.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
@@ -688,6 +688,13 @@ _ctl_do_mpt_command(struct MPT2SAS_ADAPTER *ioc,
 		goto out;
 	}
 
+	/* Check for overflow and wraparound */
+	if (karg.data_sge_offset * 4 > ioc->request_sz ||
+	    karg.data_sge_offset > (UINT_MAX / 4)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	/* copy in request message frame from user */
 	if (copy_from_user(mpi_request, mf, karg.data_sge_offset*4)) {
 		printk(KERN_ERR "failure at %s:%d/%s()!\n", __FILE__, __LINE__,
@@ -1963,7 +1970,7 @@ _ctl_diag_read_buffer(void __user *arg, enum block_state state)
 	Mpi2DiagBufferPostReply_t *mpi_reply;
 	int rc, i;
 	u8 buffer_type;
-	unsigned long timeleft;
+	unsigned long timeleft, request_size, copy_size;
 	u16 smid;
 	u16 ioc_status;
 	u8 issue_reset = 0;
@@ -1999,6 +2006,8 @@ _ctl_diag_read_buffer(void __user *arg, enum block_state state)
 		return -ENOMEM;
 	}
 
+	request_size = ioc->diag_buffer_sz[buffer_type];
+
 	if ((karg.starting_offset % 4) || (karg.bytes_to_read % 4)) {
 		printk(MPT2SAS_ERR_FMT "%s: either the starting_offset "
 		    "or bytes_to_read are not 4 byte aligned\n", ioc->name,
@@ -2006,13 +2015,23 @@ _ctl_diag_read_buffer(void __user *arg, enum block_state state)
 		return -EINVAL;
 	}
 
+	if (karg.starting_offset > request_size)
+		return -EINVAL;
+
 	diag_data = (void *)(request_data + karg.starting_offset);
 	dctlprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: diag_buffer(%p), "
 	    "offset(%d), sz(%d)\n", ioc->name, __func__,
 	    diag_data, karg.starting_offset, karg.bytes_to_read));
 
+	/* Truncate data on requests that are too large */
+	if ((diag_data + karg.bytes_to_read < diag_data) ||
+	    (diag_data + karg.bytes_to_read > request_data + request_size))
+		copy_size = request_size - karg.starting_offset;
+	else
+		copy_size = karg.bytes_to_read;
+
 	if (copy_to_user((void __user *)uarg->diagnostic_data,
-	    diag_data, karg.bytes_to_read)) {
+	    diag_data, copy_size)) {
 		printk(MPT2SAS_ERR_FMT "%s: Unable to write "
 		    "mpt_diag_read_buffer_t data @ %p\n", ioc->name,
 		    __func__, diag_data);
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 96d5ad0..7f636b1 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -3814,6 +3814,9 @@ static long pmcraid_ioctl_passthrough(
 			rc = -EFAULT;
 			goto out_free_buffer;
 		}
+	} else if (request_size < 0) {
+		rc = -EINVAL;
+		goto out_free_buffer;
 	}
 
 	/* check if we have any additional command parameters */
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index e44ff64..e639125 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -322,14 +322,8 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 		kfree(evt);
 	}
 
-	if (sdev->request_queue) {
-		sdev->request_queue->queuedata = NULL;
-		/* user context needed to free queue */
-		scsi_free_queue(sdev->request_queue);
-		/* temporary expedient, try to catch use of queue lock
-		 * after free of sdev */
-		sdev->request_queue = NULL;
-	}
+	/* NULL queue means the device can't be used */
+	sdev->request_queue = NULL;
 
 	scsi_target_reap(scsi_target(sdev));
 
@@ -937,6 +931,12 @@ void __scsi_remove_device(struct scsi_device *sdev)
 	if (sdev->host->hostt->slave_destroy)
 		sdev->host->hostt->slave_destroy(sdev);
 	transport_destroy_device(dev);
+
+	/* cause the request function to reject all I/O requests */
+	sdev->request_queue->queuedata = NULL;
+
+	/* Freeing the queue signals to block that we're done */
+	scsi_free_queue(sdev->request_queue);
 	put_device(dev);
 }
 
