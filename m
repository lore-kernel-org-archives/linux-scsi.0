From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v7 2/6] scsi: sr: support runtime pm
Date: Wed, 12 Sep 2012 16:29:53 +0800
Message-ID: <1347438597-5903-3-git-send-email-aaron.lu@intel.com>
References: <1347438597-5903-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <1347438597-5903-1-git-send-email-aaron.lu@intel.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oliver@neukum.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Aaron Lu <aaron.lu@intel.com>
List-Id: linux-scsi@vger.kernel.org

Place the ODD into runtime suspend state as soon as there is nobody
using it. The only exception is, if we just find that a new medium is
inserted, we wait for the next events checking to idle it.

Based on ideas of Alan Stern and Oliver Neukum.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/scsi/sr.c | 29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 5fc97d2..7a8222f 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -45,6 +45,7 @@
 #include <linux/blkdev.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
+#include <linux/pm_runtime.h>
 #include <asm/uaccess.h>
 
 #include <scsi/scsi.h>
@@ -146,8 +147,12 @@ static inline struct scsi_cd *scsi_cd_get(struct gendisk *disk)
 	kref_get(&cd->kref);
 	if (scsi_device_get(cd->device))
 		goto out_put;
+	if (scsi_autopm_get_device(cd->device))
+		goto out_pm;
 	goto out;
 
+ out_pm:
+	scsi_device_put(cd->device);
  out_put:
 	kref_put(&cd->kref, sr_kref_release);
 	cd = NULL;
@@ -163,6 +168,7 @@ static void scsi_cd_put(struct scsi_cd *cd)
 	mutex_lock(&sr_ref_mutex);
 	kref_put(&cd->kref, sr_kref_release);
 	scsi_device_put(sdev);
+	scsi_autopm_put_device(sdev);
 	mutex_unlock(&sr_ref_mutex);
 }
 
@@ -211,7 +217,7 @@ static unsigned int sr_check_events(struct cdrom_device_info *cdi,
 				    unsigned int clearing, int slot)
 {
 	struct scsi_cd *cd = cdi->handle;
-	bool last_present;
+	bool last_present = cd->media_present;
 	struct scsi_sense_hdr sshdr;
 	unsigned int events;
 	int ret;
@@ -220,6 +226,8 @@ static unsigned int sr_check_events(struct cdrom_device_info *cdi,
 	if (CDSL_CURRENT != slot)
 		return 0;
 
+	scsi_autopm_get_device(cd->device);
+
 	events = sr_get_events(cd->device);
 	cd->get_event_changed |= events & DISK_EVENT_MEDIA_CHANGE;
 
@@ -246,10 +254,9 @@ static unsigned int sr_check_events(struct cdrom_device_info *cdi,
 	}
 
 	if (!(clearing & DISK_EVENT_MEDIA_CHANGE))
-		return events;
+		goto out;
 do_tur:
 	/* let's see whether the media is there with TUR */
-	last_present = cd->media_present;
 	ret = scsi_test_unit_ready(cd->device, SR_TIMEOUT, MAX_RETRIES, &sshdr);
 
 	/*
@@ -270,7 +277,7 @@ do_tur:
 	}
 
 	if (cd->ignore_get_event)
-		return events;
+		goto out;
 
 	/* check whether GET_EVENT is reporting spurious MEDIA_CHANGE */
 	if (!cd->tur_changed) {
@@ -287,6 +294,12 @@ do_tur:
 	cd->tur_changed = false;
 	cd->get_event_changed = false;
 
+out:
+	if (cd->media_present && !last_present)
+		pm_runtime_put_noidle(&cd->device->sdev_gendev);
+	else
+		scsi_autopm_put_device(cd->device);
+
 	return events;
 }
 
@@ -715,9 +728,14 @@ static int sr_probe(struct device *dev)
 	dev_set_drvdata(dev, cd);
 	disk->flags |= GENHD_FL_REMOVABLE;
 	add_disk(disk);
+	disk_events_set_poll_msecs(disk, 5000);
 
 	sdev_printk(KERN_DEBUG, sdev,
 		    "Attached scsi CD-ROM %s\n", cd->cdi.name);
+
+	/* enable runtime pm */
+	scsi_autopm_put_device(cd->device);
+
 	return 0;
 
 fail_put:
@@ -965,6 +983,9 @@ static int sr_remove(struct device *dev)
 {
 	struct scsi_cd *cd = dev_get_drvdata(dev);
 
+	/* disable runtime pm */
+	scsi_autopm_get_device(cd->device);
+
 	blk_queue_prep_rq(cd->device->request_queue, scsi_prep_fn);
 	del_gendisk(cd->disk);
 
-- 
1.7.12.21.g871e293

