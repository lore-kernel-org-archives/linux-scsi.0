From: Aaron Lu <aaron.lu@amd.com>
Subject: [PATCH v3 3/7] scsi: sr: support zero power ODD(ZPODD)
Date: Thu, 26 Jul 2012 18:05:25 +0800
Message-ID: <1343297129-28174-4-git-send-email-aaron.lu@amd.com>
References: <1343297129-28174-1-git-send-email-aaron.lu@amd.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1343297129-28174-1-git-send-email-aaron.lu@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Alan Stern <stern@rowland.harvard.edu>
Cc: Jeff Garzik <jgarzik@pobox.com>, Lin Ming <minggr@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Aaron Lu <aaron.lu@amd.com>
List-Id: linux-scsi@vger.kernel.org

The ODD will be placed into suspend state when:
1 For tray type ODD, no media inside and door closed;
2 For slot type ODD, no media inside;
And together with ACPI, when we suspend the ODD, we will omit the power
altogether to reduce power consumption(done in libata-acpi.c).

The ODD can be resumed either by user or by software.

For user to resume the suspended ODD:
1 For tray type ODD, press the eject button;
2 For slot type ODD, insert a disc;
Once such events happened, an ACPI notification will be sent and in our
handler, we will power up the ODD and set its status back to
active(again in libata-acpi.c).

For software to resume the suspended ODD, we did this in ODD's
open/release function: we scsi_autopm_get/put_device in scsi_cd_get/put.

On old distros, the udisk daemon will poll the ODD and thus ODD will be
open/closed every 2 seconds. To make use of ZPODD, udisks' poll has to
be inhibited:
$ udisks --inhibit-polling /dev/sr0

Signed-off-by: Aaron Lu <aaron.lu@amd.com>
---
 drivers/scsi/sr.c          | 130 ++++++++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/sr.h          |   2 +
 include/scsi/scsi_device.h |   2 +
 3 files changed, 133 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index abfefab..2573a42 100644
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
+static int sr_suspend(struct device *dev, pm_message_t msg);
+static int sr_resume(struct device *dev);
 
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
@@ -147,8 +152,12 @@ static inline struct scsi_cd *scsi_cd_get(struct gendisk *disk)
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
@@ -164,9 +173,61 @@ static void scsi_cd_put(struct scsi_cd *cd)
 	mutex_lock(&sr_ref_mutex);
 	kref_put(&cd->kref, sr_kref_release);
 	scsi_device_put(sdev);
+	scsi_autopm_put_device(sdev);
 	mutex_unlock(&sr_ref_mutex);
 }
 
+static int sr_suspend(struct device *dev, pm_message_t msg)
+{
+	int poweroff;
+	struct scsi_sense_hdr sshdr;
+	struct scsi_cd *cd = dev_get_drvdata(dev);
+
+	/* no action for system pm */
+	if (!PMSG_IS_AUTO(msg))
+		return 0;
+
+	/* do another TUR to see if the ODD is still ready to be powered off */
+	scsi_test_unit_ready(cd->device, SR_TIMEOUT, MAX_RETRIES, &sshdr);
+
+	if (cd->cdi.mask & CDC_CLOSE_TRAY)
+		/* no media for caddy/slot type ODD */
+		poweroff = scsi_sense_valid(&sshdr) && sshdr.asc == 0x3a;
+	else
+		/* no media and door closed for tray type ODD */
+		poweroff = scsi_sense_valid(&sshdr) && sshdr.asc == 0x3a &&
+			sshdr.ascq == 0x01;
+
+	if (!poweroff) {
+		pm_runtime_get_noresume(dev);
+		atomic_set(&cd->suspend_count, 1);
+		return -EBUSY;
+	}
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
+		atomic_set(&cd->suspend_count, 1);
+	}
+
+	return 0;
+}
+
 static unsigned int sr_get_events(struct scsi_device *sdev)
 {
 	u8 buf[8];
@@ -201,6 +262,38 @@ static unsigned int sr_get_events(struct scsi_device *sdev)
 	return 0;
 }
 
+static int sr_unit_load_done(struct scsi_cd *cd)
+{
+	u8 buf[8];
+	u8 cmd[] = { GET_EVENT_STATUS_NOTIFICATION,
+		1,                 /* polled */
+		0, 0,              /* reserved */
+		1 << 6,            /* notification class: Device Busy */
+		0, 0,              /* reserved */
+		0, sizeof(buf),    /* allocation length */
+		0,                 /* control */
+	};
+	struct event_header *eh = (void *)buf;
+	struct device_busy_event_desc *desc = (void *)(buf + 4);
+	struct scsi_sense_hdr sshdr;
+	int result;
+
+	result = scsi_execute_req(cd->device, cmd, DMA_FROM_DEVICE, buf,
+			sizeof(buf), &sshdr, SR_TIMEOUT, MAX_RETRIES, NULL);
+
+	if (result || be16_to_cpu(eh->data_len) < sizeof(*desc))
+		return 0;
+
+	if (eh->nea || eh->notification_class != 0x6)
+		return 0;
+
+	if (desc->device_busy_event == 2 && desc->device_busy_status == 0)
+		return 1;
+	else
+		return 0;
+}
+
+
 /*
  * This function checks to see if the media has been changed or eject
  * button has been pressed.  It is possible that we have already
@@ -215,12 +308,21 @@ static unsigned int sr_check_events(struct cdrom_device_info *cdi,
 	bool last_present;
 	struct scsi_sense_hdr sshdr;
 	unsigned int events;
-	int ret;
+	int ret, poweroff;
 
 	/* no changer support */
 	if (CDSL_CURRENT != slot)
 		return 0;
 
+	if (pm_runtime_suspended(&cd->device->sdev_gendev))
+		return 0;
+
+	/* if the logical unit just finished loading/unloading, do a TUR */
+	if (cd->device->can_power_off && cd->dbml && sr_unit_load_done(cd)) {
+		events = 0;
+		goto do_tur;
+	}
+
 	events = sr_get_events(cd->device);
 	cd->get_event_changed |= events & DISK_EVENT_MEDIA_CHANGE;
 
@@ -270,6 +372,20 @@ do_tur:
 		cd->tur_changed = true;
 	}
 
+	if (cd->device->can_power_off && !cd->media_present) {
+		if (cd->cdi.mask & CDC_CLOSE_TRAY)
+			poweroff = 1;
+		else
+			poweroff = sshdr.ascq == 0x01;
+		/*
+		 * This function might be called concurrently by a kernel
+		 * thread (in-kernel polling) and old versions of udisks,
+		 * to avoid put the device twice, an atomic operation is used.
+		 */
+		if (poweroff && atomic_add_unless(&cd->suspend_count, -1, 0))
+			scsi_autopm_put_device(cd->device);
+	}
+
 	if (cd->ignore_get_event)
 		return events;
 
@@ -703,6 +819,14 @@ static int sr_probe(struct device *dev)
 	get_capabilities(cd);
 	blk_queue_prep_rq(sdev->request_queue, sr_prep_fn);
 	sr_vendor_init(cd);
+	/* zero power support */
+	if (sdev->can_power_off) {
+		check_dbml(cd);
+		/* default delay time is 3 minutes */
+		pm_runtime_set_autosuspend_delay(dev, 180 * 1000);
+		pm_runtime_use_autosuspend(dev);
+		atomic_set(&cd->suspend_count, 1);
+	}
 
 	disk->driverfs_dev = &sdev->sdev_gendev;
 	set_capacity(disk, cd->capacity);
@@ -988,6 +1112,10 @@ static int sr_remove(struct device *dev)
 {
 	struct scsi_cd *cd = dev_get_drvdata(dev);
 
+	/* disable runtime pm and possibly resume the device */
+	if (!atomic_dec_and_test(&cd->suspend_count))
+		scsi_autopm_get_device(cd->device);
+
 	blk_queue_prep_rq(cd->device->request_queue, scsi_prep_fn);
 	del_gendisk(cd->disk);
 
diff --git a/drivers/scsi/sr.h b/drivers/scsi/sr.h
index 7cc40ad..649fe76 100644
--- a/drivers/scsi/sr.h
+++ b/drivers/scsi/sr.h
@@ -49,6 +49,8 @@ typedef struct scsi_cd {
 	bool get_event_changed:1;	/* changed according to GET_EVENT */
 	bool ignore_get_event:1;	/* GET_EVENT is unreliable, use TUR */
 
+	atomic_t suspend_count;
+
 	struct cdrom_device_info cdi;
 	/* We hold gendisk and scsi_device references on probe and use
 	 * the refs on this kref to decide when to release them */
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 7539f52..9d11981 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -155,6 +155,8 @@ struct scsi_device {
 	unsigned try_rc_10_first:1;	/* Try READ_CAPACACITY_10 first */
 	unsigned is_visible:1;	/* is the device visible in sysfs */
 	unsigned wce_default_on:1;	/* Cache is ON by default */
+	unsigned can_power_off:1;	/* Device supports runtime power off */
+	unsigned wakeup_by_user:1;	/* user wakes up the ODD */
 
 	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */
 	struct list_head event_list;	/* asserted events */
-- 
1.7.11.3
