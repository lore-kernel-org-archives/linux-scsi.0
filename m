From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v5 1/7] scsi: sr: support runtime pm for ODD
Date: Fri, 31 Aug 2012 17:42:29 +0800
Message-ID: <1346406155-4768-2-git-send-email-aaron.lu@intel.com>
References: <1346406155-4768-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1346406155-4768-1-git-send-email-aaron.lu@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Aaron Lu <aaron.lu@intel.com>
List-Id: linux-scsi@vger.kernel.org

The ODD will be placed into suspend state when:
1 For tray type ODD, no media inside and door closed;
2 For slot type ODD, no media inside;
And together with ACPI, when we suspend the ODD's parent(the port it
attached to), we will omit the power altogether to reduce power
consumption(done in libata-acpi.c).

The ODD can be resumed either by user or by software.

For user to resume the suspended ODD:
1 For tray type ODD, press the eject button;
2 For slot type ODD, insert a disc;
Once such events happened, an ACPI notification will be sent and in our
handler, we will resume the ODD(again in libata-acpi.c).
This kind of resume requires platform and device support and is
reflected by the can_power_off flag.

For software to resume the suspended ODD, we did this in ODD's
open/release and check_event function.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/ata/libata-acpi.c  |  6 ++--
 drivers/scsi/sr.c          | 72 ++++++++++++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_device.h |  1 +
 3 files changed, 77 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index 902b5a4..64ba43d 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -985,8 +985,10 @@ static void ata_acpi_wake_dev(acpi_handle handle, u32 event, void *context)
 	struct ata_device *ata_dev = context;
 
 	if (event == ACPI_NOTIFY_DEVICE_WAKE && ata_dev &&
-			pm_runtime_suspended(&ata_dev->sdev->sdev_gendev))
-		scsi_autopm_get_device(ata_dev->sdev);
+			pm_runtime_suspended(&ata_dev->sdev->sdev_gendev)) {
+		ata_dev->sdev->wakeup_by_user = 1;
+		pm_runtime_resume(&ata_dev->sdev->sdev_gendev);
+	}
 }
 
 static void ata_acpi_add_pm_notifier(struct ata_device *dev)
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 5fc97d2..04a658b 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -45,6 +45,7 @@
 #include <linux/blkdev.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
+#include <linux/pm_runtime.h>
 #include <asm/uaccess.h>
 
 #include <scsi/scsi.h>
@@ -79,6 +80,8 @@ static DEFINE_MUTEX(sr_mutex);
 static int sr_probe(struct device *);
 static int sr_remove(struct device *);
 static int sr_done(struct scsi_cmnd *);
+static int sr_suspend(struct device *, pm_message_t msg);
+static int sr_resume(struct device *);
 
 static struct scsi_driver sr_template = {
 	.owner			= THIS_MODULE,
@@ -86,6 +89,8 @@ static struct scsi_driver sr_template = {
 		.name   	= "sr",
 		.probe		= sr_probe,
 		.remove		= sr_remove,
+		.suspend	= sr_suspend,
+		.resume		= sr_resume,
 	},
 	.done			= sr_done,
 };
@@ -146,8 +151,12 @@ static inline struct scsi_cd *scsi_cd_get(struct gendisk *disk)
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
@@ -163,9 +172,61 @@ static void scsi_cd_put(struct scsi_cd *cd)
 	mutex_lock(&sr_ref_mutex);
 	kref_put(&cd->kref, sr_kref_release);
 	scsi_device_put(sdev);
+	scsi_autopm_put_device(sdev);
 	mutex_unlock(&sr_ref_mutex);
 }
 
+static int sr_suspend(struct device *dev, pm_message_t msg)
+{
+	int suspend;
+	struct scsi_sense_hdr sshdr;
+	struct scsi_cd *cd = dev_get_drvdata(dev);
+
+	/* no action for system pm */
+	if (!PMSG_IS_AUTO(msg))
+		return 0;
+
+	/*
+	 * ODD can be runtime suspended when:
+	 * tray type: no media inside and tray closed
+	 * slot type: no media inside
+	 */
+	scsi_test_unit_ready(cd->device, SR_TIMEOUT, MAX_RETRIES, &sshdr);
+
+	if (cd->cdi.mask & CDC_CLOSE_TRAY)
+		/* no media for caddy/slot type ODD */
+		suspend = scsi_sense_valid(&sshdr) && sshdr.asc == 0x3a;
+	else
+		/* no media and door closed for tray type ODD */
+		suspend = scsi_sense_valid(&sshdr) && sshdr.asc == 0x3a &&
+			sshdr.ascq == 0x01;
+
+	if (!suspend)
+		return -EBUSY;
+
+	return 0;
+}
+
+static int sr_resume(struct device *dev)
+{
+	struct scsi_cd *cd;
+	struct scsi_sense_hdr sshdr;
+
+	cd = dev_get_drvdata(dev);
+
+	/* get the disk ready */
+	scsi_test_unit_ready(cd->device, SR_TIMEOUT, MAX_RETRIES, &sshdr);
+
+	/* if user wakes up the ODD, eject the tray */
+	if (cd->device->wakeup_by_user) {
+		cd->device->wakeup_by_user = 0;
+		if (!(cd->cdi.mask & CDC_CLOSE_TRAY))
+			sr_tray_move(&cd->cdi, 1);
+	}
+
+	return 0;
+}
+
 static unsigned int sr_get_events(struct scsi_device *sdev)
 {
 	u8 buf[8];
@@ -220,7 +281,9 @@ static unsigned int sr_check_events(struct cdrom_device_info *cdi,
 	if (CDSL_CURRENT != slot)
 		return 0;
 
+	scsi_autopm_get_device(cd->device);
 	events = sr_get_events(cd->device);
+	scsi_autopm_put_device(cd->device);
 	cd->get_event_changed |= events & DISK_EVENT_MEDIA_CHANGE;
 
 	/*
@@ -250,7 +313,9 @@ static unsigned int sr_check_events(struct cdrom_device_info *cdi,
 do_tur:
 	/* let's see whether the media is there with TUR */
 	last_present = cd->media_present;
+	scsi_autopm_get_device(cd->device);
 	ret = scsi_test_unit_ready(cd->device, SR_TIMEOUT, MAX_RETRIES, &sshdr);
+	scsi_autopm_put_device(cd->device);
 
 	/*
 	 * Media is considered to be present if TUR succeeds or fails with
@@ -718,6 +783,10 @@ static int sr_probe(struct device *dev)
 
 	sdev_printk(KERN_DEBUG, sdev,
 		    "Attached scsi CD-ROM %s\n", cd->cdi.name);
+
+	/* enable runtime pm */
+	scsi_autopm_put_device(cd->device);
+
 	return 0;
 
 fail_put:
@@ -965,6 +1034,9 @@ static int sr_remove(struct device *dev)
 {
 	struct scsi_cd *cd = dev_get_drvdata(dev);
 
+	/* disable runtime pm */
+	scsi_autopm_get_device(cd->device);
+
 	blk_queue_prep_rq(cd->device->request_queue, scsi_prep_fn);
 	del_gendisk(cd->disk);
 
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 9895f69..72d946f 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -156,6 +156,7 @@ struct scsi_device {
 	unsigned is_visible:1;	/* is the device visible in sysfs */
 	unsigned can_power_off:1; /* Device supports runtime power off */
 	unsigned wce_default_on:1;	/* Cache is ON by default */
+	unsigned wakeup_by_user:1;	/* User wakes up the device */
 
 	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */
 	struct list_head event_list;	/* asserted events */
-- 
1.7.11.5

