From: Huang Ying <ying.huang@intel.com>
Subject: [RFC 5/5] scsi, sd, pm, request based runtime PM support
Date: Mon,  6 Feb 2012 15:32:28 +0800
Message-ID: <1328513548-19786-6-git-send-email-ying.huang@intel.com>
References: <1328513548-19786-1-git-send-email-ying.huang@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1328513548-19786-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: ming.m.lin@intel.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <JBottomley@parallels.com>, Huang Ying <ying.huang@intel.com>
List-Id: linux-scsi@vger.kernel.org

Can reduce power consumption when disk is mounted but no read/write
request.

TODO: Request based runtime PM may be harmful for rotating HD, should
enable that only for SSD and fallback to open/close based runtime PM
otherwise.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 drivers/scsi/scsi_lib.c  |    3 ++-
 drivers/scsi/scsi_priv.h |    1 +
 drivers/scsi/sd.c        |   43 +++++++++++++++++++++++++++++++++++++++++--
 drivers/scsi/sd.h        |    2 ++
 4 files changed, 46 insertions(+), 3 deletions(-)

--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -401,7 +401,7 @@ static inline int scsi_host_is_busy(stru
  * Notes:	The previous command was completely finished, start
  *		a new one if possible.
  */
-static void scsi_run_queue(struct request_queue *q)
+void scsi_run_queue(struct request_queue *q)
 {
 	struct scsi_device *sdev = q->queuedata;
 	struct Scsi_Host *shost;
@@ -454,6 +454,7 @@ static void scsi_run_queue(struct reques
 
 	blk_run_queue(q);
 }
+EXPORT_SYMBOL_GPL(scsi_run_queue);
 
 void scsi_requeue_run_queue(struct work_struct *work)
 {
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -87,6 +87,7 @@ extern struct request_queue *scsi_alloc_
 extern void scsi_free_queue(struct request_queue *q);
 extern int scsi_init_queue(void);
 extern void scsi_exit_queue(void);
+extern void scsi_run_queue(struct request_queue *q);
 struct request_queue;
 struct request;
 extern struct kmem_cache *scsi_sdb_cache;
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -66,6 +66,7 @@
 
 #include "sd.h"
 #include "scsi_logging.h"
+#include "scsi_priv.h"
 
 MODULE_AUTHOR("Eric Youngdale");
 MODULE_DESCRIPTION("SCSI disk (sd) driver");
@@ -981,6 +982,8 @@ static int sd_open(struct block_device *
 			scsi_set_medium_removal(sdev, SCSI_REMOVAL_PREVENT);
 	}
 
+	scsi_autopm_put_device_sync(sdev);
+
 	return 0;
 
 error_out:
@@ -1020,7 +1023,6 @@ static int sd_release(struct gendisk *di
 	 * XXX is followed by a "rmmod sd_mod"?
 	 */
 
-	scsi_autopm_put_device_sync(sdev);
 	scsi_disk_put(sdkp);
 	return 0;
 }
@@ -1071,7 +1073,7 @@ static int sd_ioctl(struct block_device
 	struct scsi_device *sdp = sdkp->device;
 	void __user *p = (void __user *)arg;
 	int error;
-    
+
 	SCSI_LOG_IOCTL(1, sd_printk(KERN_INFO, sdkp, "sd_ioctl: disk=%s, "
 				    "cmd=0x%x\n", disk->disk_name, cmd));
 
@@ -1079,6 +1081,10 @@ static int sd_ioctl(struct block_device
 	if (error < 0)
 		return error;
 
+	error = scsi_autopm_get_device_sync(sdp);
+	if (error)
+		return error;
+
 	/*
 	 * If we are in the middle of error recovery, don't let anyone
 	 * else try and use this device.  Also, if error recovery fails, it
@@ -1108,6 +1114,7 @@ static int sd_ioctl(struct block_device
 			break;
 	}
 out:
+	scsi_autopm_put_device_sync(sdp);
 	return error;
 }
 
@@ -2365,10 +2372,15 @@ static int sd_revalidate_disk(struct gen
 	struct scsi_device *sdp = sdkp->device;
 	unsigned char *buffer;
 	unsigned flush = 0;
+	int error;
 
 	SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp,
 				      "sd_revalidate_disk\n"));
 
+	error = scsi_autopm_get_device_sync(sdp);
+	if (error)
+		return 0;
+
 	/*
 	 * If the device is offline, don't try and read capacity or any
 	 * of the other niceties.
@@ -2421,6 +2433,7 @@ static int sd_revalidate_disk(struct gen
 	kfree(buffer);
 
  out:
+	scsi_autopm_put_device_sync(sdp);
 	return 0;
 }
 
@@ -2490,6 +2503,29 @@ static int sd_format_disk_name(char *pre
 	return 0;
 }
 
+static void sd_on_resume_work(struct work_struct *work)
+{
+	struct scsi_disk *sdkp = container_of(work, struct scsi_disk, work);
+	struct scsi_device *sdev = sdkp->device;
+
+	scsi_run_queue(sdev->request_queue);
+}
+
+/*
+ * Called with dev->power.lock held, scsi_run_queue will acquire the
+ * lock too, so delay to a work item to do that.
+ */
+static int sd_on_resume(struct notifier_block *nb, unsigned long event,
+			void *ptr)
+{
+	struct scsi_disk *sdkp = container_of(nb, struct scsi_disk, nb);
+
+	if (event == RPM_REQ_RESUME)
+		schedule_work(&sdkp->work);
+
+	return NOTIFY_DONE;
+}
+
 /*
  * The asynchronous part of sd_probe
  */
@@ -2543,6 +2579,9 @@ static void sd_probe_async(void *data, a
 
 	sd_printk(KERN_NOTICE, sdkp, "Attached SCSI %sdisk\n",
 		  sdp->removable ? "removable " : "");
+	INIT_WORK(&sdkp->work, sd_on_resume_work);
+	sdkp->nb.notifier_call = sd_on_resume;
+	atomic_notifier_chain_register(&dev->power.notifier, &sdkp->nb);
 	scsi_autopm_put_device_sync(sdp);
 	put_device(&sdkp->dev);
 }
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -50,6 +50,8 @@ struct scsi_disk {
 	struct scsi_driver *driver;	/* always &sd_template */
 	struct scsi_device *device;
 	struct device	dev;
+	struct notifier_block nb;
+	struct work_struct work;
 	struct gendisk	*disk;
 	atomic_t	openers;
 	sector_t	capacity;	/* size in 512-byte sectors */
