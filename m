From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v8 01/11] scsi: sr: support runtime pm
Date: Mon, 29 Oct 2012 17:01:28 +0800
Message-ID: <1351501298-3716-2-git-send-email-aaron.lu@intel.com>
References: <1351501298-3716-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <1351501298-3716-1-git-send-email-aaron.lu@intel.com>
Sender: linux-pm-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@hansenpartnership.com>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>, Oliver Neukum <oliver@neukum.org>
Cc: Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, Shane Huang <shane.huang@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch adds runtime pm support for sr.

It did this by increasing the runtime usage_count of the device when:
- its block device is opened;
- the events checking is to run.

And decreasing the runtime usage_count of the device when:
- its block device is closed;
- After the events checking is done.

The idea is discussed in this mail thread:
http://thread.gmane.org/gmane.linux.acpi.devel/55243/focus=52703

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/scsi/sr.c | 30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 5fc97d2..4d1a610 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -45,6 +45,7 @@
 #include <linux/blkdev.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
+#include <linux/pm_runtime.h>
 #include <asm/uaccess.h>
 
 #include <scsi/scsi.h>
@@ -146,7 +147,8 @@ static inline struct scsi_cd *scsi_cd_get(struct gendisk *disk)
 	kref_get(&cd->kref);
 	if (scsi_device_get(cd->device))
 		goto out_put;
-	goto out;
+	if (!scsi_autopm_get_device(cd->device))
+		goto out;
 
  out_put:
 	kref_put(&cd->kref, sr_kref_release);
@@ -162,6 +164,7 @@ static void scsi_cd_put(struct scsi_cd *cd)
 
 	mutex_lock(&sr_ref_mutex);
 	kref_put(&cd->kref, sr_kref_release);
+	scsi_autopm_put_device(sdev);
 	scsi_device_put(sdev);
 	mutex_unlock(&sr_ref_mutex);
 }
@@ -211,7 +214,7 @@ static unsigned int sr_check_events(struct cdrom_device_info *cdi,
 				    unsigned int clearing, int slot)
 {
 	struct scsi_cd *cd = cdi->handle;
-	bool last_present;
+	bool last_present = cd->media_present;
 	struct scsi_sense_hdr sshdr;
 	unsigned int events;
 	int ret;
@@ -220,6 +223,8 @@ static unsigned int sr_check_events(struct cdrom_device_info *cdi,
 	if (CDSL_CURRENT != slot)
 		return 0;
 
+	scsi_autopm_get_device(cd->device);
+
 	events = sr_get_events(cd->device);
 	cd->get_event_changed |= events & DISK_EVENT_MEDIA_CHANGE;
 
@@ -246,10 +251,9 @@ static unsigned int sr_check_events(struct cdrom_device_info *cdi,
 	}
 
 	if (!(clearing & DISK_EVENT_MEDIA_CHANGE))
-		return events;
+		goto out;
 do_tur:
 	/* let's see whether the media is there with TUR */
-	last_present = cd->media_present;
 	ret = scsi_test_unit_ready(cd->device, SR_TIMEOUT, MAX_RETRIES, &sshdr);
 
 	/*
@@ -270,7 +274,7 @@ do_tur:
 	}
 
 	if (cd->ignore_get_event)
-		return events;
+		goto out;
 
 	/* check whether GET_EVENT is reporting spurious MEDIA_CHANGE */
 	if (!cd->tur_changed) {
@@ -287,6 +291,18 @@ do_tur:
 	cd->tur_changed = false;
 	cd->get_event_changed = false;
 
+out:
+	/*
+	 * If there is no medium detected or the medium has been there
+	 * since last poll, try to suspend the device. Otherwise, keep
+	 * it active for one more poll interval so that if user space
+	 * application opens the block device, we can avoid a runtime
+	 * status change.
+	 */
+	pm_runtime_put_noidle(&cd->device->sdev_gendev);
+	if (!cd->media_present || last_present)
+		pm_runtime_suspend(&cd->device->sdev_gendev);
+
 	return events;
 }
 
@@ -718,6 +734,8 @@ static int sr_probe(struct device *dev)
 
 	sdev_printk(KERN_DEBUG, sdev,
 		    "Attached scsi CD-ROM %s\n", cd->cdi.name);
+	scsi_autopm_put_device(cd->device);
+
 	return 0;
 
 fail_put:
@@ -965,6 +983,8 @@ static int sr_remove(struct device *dev)
 {
 	struct scsi_cd *cd = dev_get_drvdata(dev);
 
+	scsi_autopm_get_device(cd->device);
+
 	blk_queue_prep_rq(cd->device->request_queue, scsi_prep_fn);
 	del_gendisk(cd->disk);
 
-- 
1.7.12.4

