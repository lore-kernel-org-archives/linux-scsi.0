From: Aaron Lu <aaron.lu@intel.com>
Subject: [RFC PATCH] scsi: sr: support runtime pm
Date: Mon, 21 Jan 2013 17:37:07 +0800
Message-ID: <20130121093707.GB11010@aaronlu.sh.intel.com>
References: <50FA5F67.4080102@intel.com>
 <Pine.LNX.4.44L0.1301191312050.13032-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1301191312050.13032-100000@netrider.rowland.org>
Sender: linux-acpi-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oneukum@suse.de>, Julian Calaby <julian.calaby@gmail.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>, Aaron Lu <aaron.lwe@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Jan 19, 2013 at 01:46:15PM -0500, Alan Stern wrote:
> On Sat, 19 Jan 2013, Aaron Lu wrote:
> > I don't think we should drop such support.
> > And the safest way to avoid such break is we refine the suspend
> > condition for ODD, and using what ZPODD defined condition isn't that
> > bad to me:
> > - for tray type, no media inside and tray close;
> > - for slot type, no media inside.
> > While whether tray is closed or not may not be that important, but at
> > least we should make sure there is no media inside.
> > 
> > Thoughts?
> 
> That sounds reasonable to me, at least as a first step.  If people want 
> their CD drive to suspend, they can eject the disc.

Here is an updated patch to address the problem, please review, thanks.

Changes to v13:
- Add PM get/put pair functions to all the block device operation
  functions; Move the existing PM get/put pair functions in
  sr_check_events to sr_block_check_events;
- Add sr_runtime_suspend, it will check if there is media inside and if
  yes, avoid suspend.

>From 378bf55810a1118ede481f45132b5c39af891d23 Mon Sep 17 00:00:00 2001
From: Aaron Lu <aaron.lu@intel.com>
Date: Wed, 26 Sep 2012 15:14:56 +0800
Subject: [RFC PATCH] scsi: sr: support runtime pm

This patch adds runtime pm support for sr.

It did this by increasing the runtime usage_count of the device when
its block device is accessed. And decreasing the runtime usage_count
of the device when the access is done.

The idea is discussed here:
http://thread.gmane.org/gmane.linux.acpi.devel/55243/focus=52703
and here:
http://thread.gmane.org/gmane.linux.ide/53665/focus=58836

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
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

Thanks,
Aaron

