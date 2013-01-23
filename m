From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v14 1/3] scsi: sr: support runtime pm
Date: Wed, 23 Jan 2013 15:09:31 +0800
Message-ID: <1358924973-18269-2-git-send-email-aaron.lu@intel.com>
References: <1358924973-18269-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1358924973-18269-1-git-send-email-aaron.lu@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>
Cc: Aaron Lu <aaron.lwe@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch adds runtime pm support for sr.

It did this by increasing the runtime usage_count of the device when
its block device is accessed. And decreasing the runtime usage_count
of the device when the access is done.

If there is media inside, runtime suspend is not allowed as we don't
always know if the ODD is being used or not.

The idea is discussed here:
http://thread.gmane.org/gmane.linux.acpi.devel/55243/focus=52703
and the restriction to check media inside is discussed here:
http://thread.gmane.org/gmane.linux.ide/53665/focus=58836

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Acked-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/sr.c | 42 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 39 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 5fc97d2..2e8ddd7 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -45,6 +45,7 @@
 #include <linux/blkdev.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
+#include <linux/pm_runtime.h>
 #include <asm/uaccess.h>
 
 #include <scsi/scsi.h>
@@ -79,6 +80,11 @@ static DEFINE_MUTEX(sr_mutex);
 static int sr_probe(struct device *);
 static int sr_remove(struct device *);
 static int sr_done(struct scsi_cmnd *);
+static int sr_runtime_suspend(struct device *dev);
+
+static struct dev_pm_ops sr_pm_ops = {
+	.runtime_suspend	= sr_runtime_suspend,
+};
 
 static struct scsi_driver sr_template = {
 	.owner			= THIS_MODULE,
@@ -86,6 +92,7 @@ static struct scsi_driver sr_template = {
 		.name   	= "sr",
 		.probe		= sr_probe,
 		.remove		= sr_remove,
+		.pm		= &sr_pm_ops,
 	},
 	.done			= sr_done,
 };
@@ -131,6 +138,16 @@ static inline struct scsi_cd *scsi_cd(struct gendisk *disk)
 	return container_of(disk->private_data, struct scsi_cd, driver);
 }
 
+static int sr_runtime_suspend(struct device *dev)
+{
+	struct scsi_cd *cd = dev_get_drvdata(dev);
+
+	if (cd->media_present)
+		return -EBUSY;
+	else
+		return 0;
+}
+
 /*
  * The get and put routines for the struct scsi_cd.  Note this entity
  * has a scsi_device pointer and owns a reference to this.
@@ -146,7 +163,8 @@ static inline struct scsi_cd *scsi_cd_get(struct gendisk *disk)
 	kref_get(&cd->kref);
 	if (scsi_device_get(cd->device))
 		goto out_put;
-	goto out;
+	if (!scsi_autopm_get_device(cd->device))
+		goto out;
 
  out_put:
 	kref_put(&cd->kref, sr_kref_release);
@@ -162,6 +180,7 @@ static void scsi_cd_put(struct scsi_cd *cd)
 
 	mutex_lock(&sr_ref_mutex);
 	kref_put(&cd->kref, sr_kref_release);
+	scsi_autopm_put_device(sdev);
 	scsi_device_put(sdev);
 	mutex_unlock(&sr_ref_mutex);
 }
@@ -540,6 +559,8 @@ static int sr_block_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 	void __user *argp = (void __user *)arg;
 	int ret;
 
+	scsi_autopm_get_device(cd->device);
+
 	mutex_lock(&sr_mutex);
 
 	/*
@@ -571,6 +592,7 @@ static int sr_block_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 
 out:
 	mutex_unlock(&sr_mutex);
+	scsi_autopm_put_device(cd->device);
 	return ret;
 }
 
@@ -578,7 +600,13 @@ static unsigned int sr_block_check_events(struct gendisk *disk,
 					  unsigned int clearing)
 {
 	struct scsi_cd *cd = scsi_cd(disk);
-	return cdrom_check_events(&cd->cdi, clearing);
+	unsigned int ret;
+
+	scsi_autopm_get_device(cd->device);
+	ret = cdrom_check_events(&cd->cdi, clearing);
+	scsi_autopm_put_device(cd->device);
+
+	return ret;
 }
 
 static int sr_block_revalidate_disk(struct gendisk *disk)
@@ -586,12 +614,16 @@ static int sr_block_revalidate_disk(struct gendisk *disk)
 	struct scsi_cd *cd = scsi_cd(disk);
 	struct scsi_sense_hdr sshdr;
 
+	scsi_autopm_get_device(cd->device);
+
 	/* if the unit is not ready, nothing more to do */
 	if (scsi_test_unit_ready(cd->device, SR_TIMEOUT, MAX_RETRIES, &sshdr))
-		return 0;
+		goto out;
 
 	sr_cd_check(&cd->cdi);
 	get_sectorsize(cd);
+out:
+	scsi_autopm_put_device(cd->device);
 	return 0;
 }
 
@@ -718,6 +750,8 @@ static int sr_probe(struct device *dev)
 
 	sdev_printk(KERN_DEBUG, sdev,
 		    "Attached scsi CD-ROM %s\n", cd->cdi.name);
+	scsi_autopm_put_device(cd->device);
+
 	return 0;
 
 fail_put:
@@ -965,6 +999,8 @@ static int sr_remove(struct device *dev)
 {
 	struct scsi_cd *cd = dev_get_drvdata(dev);
 
+	scsi_autopm_get_device(cd->device);
+
 	blk_queue_prep_rq(cd->device->request_queue, scsi_prep_fn);
 	del_gendisk(cd->disk);
 
-- 
1.8.1

