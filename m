From: Lin Ming <ming.m.lin@intel.com>
Subject: [PATCH v4 12/13] [SCSI] sr: support zero power ODD
Date: Mon, 28 May 2012 13:08:39 +0800
Message-ID: <1338181720-4149-13-git-send-email-ming.m.lin@intel.com>
References: <1338181720-4149-1-git-send-email-ming.m.lin@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1338181720-4149-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, David Woodhouse <David.Woodhouse@intel.com>, Aaron Lu <aaron.lu@amd.com>, Holger Macht <holger@homac.de>, Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Aaron Lu <aaron.lu@amd.com>

If there is no media inside the ODD and the ODD's tray is closed, it's
safe to omit power. When user ejects the tray by pressing the button or
inserts a disc into the slot, the ODD will gets resumed from acpi
notifier handler.

Signed-off-by: Aaron Lu <aaron.lu@amd.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/ata/libata-acpi.c  |    4 +-
 drivers/scsi/sr.c          |  128 +++++++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/sr.h          |    2 +
 include/scsi/scsi_device.h |    1 +
 4 files changed, 133 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index f0fa115..6de8f32 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -974,8 +974,10 @@ static void ata_acpi_wake_dev(acpi_handle handle, u32 event, void *context)
 	struct ata_device *ata_dev = context;
 
 	if (event == ACPI_NOTIFY_DEVICE_WAKE && ata_dev &&
-			pm_runtime_suspended(&ata_dev->sdev->sdev_gendev))
+			pm_runtime_suspended(&ata_dev->sdev->sdev_gendev)) {
+		ata_dev->sdev->wakeup_by_user = 1;
 		scsi_autopm_get_device(ata_dev->sdev);
+	}
 }
 
 static void ata_acpi_add_pm_notifier(struct ata_device *dev)
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index abfefab..72488c2 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -46,6 +46,7 @@
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include <asm/uaccess.h>
+#include <linux/pm_runtime.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_dbg.h>
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
@@ -167,6 +172,58 @@ static void scsi_cd_put(struct scsi_cd *cd)
 	mutex_unlock(&sr_ref_mutex);
 }
 
+static int sr_suspend(struct device *dev, pm_message_t msg)
+{
+	int poweroff;
+	struct scsi_sense_hdr sshdr;
+	struct scsi_cd *cd = dev_get_drvdata(dev);
+
+	/* no action for system suspend */
+	if (msg.event == PM_EVENT_SUSPEND)
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
+				sshdr.ascq == 0x01;
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
+	}
+
+	atomic_set(&cd->suspend_count, 1);
+
+	return 0;
+}
+
 static unsigned int sr_get_events(struct scsi_device *sdev)
 {
 	u8 buf[8];
@@ -201,6 +258,37 @@ static unsigned int sr_get_events(struct scsi_device *sdev)
 	return 0;
 }
 
+static int sr_unit_load_done(struct scsi_cd *cd)
+{
+	u8 buf[8];
+	u8 cmd[] = { GET_EVENT_STATUS_NOTIFICATION,
+		     1,			/* polled */
+		     0, 0,		/* reserved */
+		     1 << 6,		/* notification class: Device Busy */
+		     0, 0,		/* reserved */
+		     0, sizeof(buf),	/* allocation length */
+		     0,			/* control */
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
 /*
  * This function checks to see if the media has been changed or eject
  * button has been pressed.  It is possible that we have already
@@ -215,12 +303,21 @@ static unsigned int sr_check_events(struct cdrom_device_info *cdi,
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
 
@@ -270,6 +367,22 @@ static unsigned int sr_check_events(struct cdrom_device_info *cdi,
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
+		if (poweroff && atomic_add_unless(&cd->suspend_count, -1, 0)) {
+			pm_runtime_mark_last_busy(&cd->device->sdev_gendev);
+			pm_runtime_put_autosuspend(&cd->device->sdev_gendev);
+		}
+	}
+
 	if (cd->ignore_get_event)
 		return events;
 
@@ -704,6 +817,15 @@ static int sr_probe(struct device *dev)
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
+
 	disk->driverfs_dev = &sdev->sdev_gendev;
 	set_capacity(disk, cd->capacity);
 	disk->private_data = &cd->driver;
@@ -988,6 +1110,10 @@ static int sr_remove(struct device *dev)
 {
 	struct scsi_cd *cd = dev_get_drvdata(dev);
 
+	/* disable runtime pm and possibly resume the device */
+	if (!atomic_dec_and_test(&cd->suspend_count))
+		pm_runtime_get_sync(dev);
+
 	blk_queue_prep_rq(cd->device->request_queue, scsi_prep_fn);
 	del_gendisk(cd->disk);
 
diff --git a/drivers/scsi/sr.h b/drivers/scsi/sr.h
index 7cc40ad..fd5c550 100644
--- a/drivers/scsi/sr.h
+++ b/drivers/scsi/sr.h
@@ -49,6 +49,8 @@ typedef struct scsi_cd {
 	bool get_event_changed:1;	/* changed according to GET_EVENT */
 	bool ignore_get_event:1;	/* GET_EVENT is unreliable, use TUR */
 
+	atomic_t suspend_count;	/* we should request autosuspend only once */
+
 	struct cdrom_device_info cdi;
 	/* We hold gendisk and scsi_device references on probe and use
 	 * the refs on this kref to decide when to release them */
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 1237fac..65b9732 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -153,6 +153,7 @@ struct scsi_device {
 	unsigned no_read_capacity_16:1; /* Avoid READ_CAPACITY_16 cmds */
 	unsigned is_visible:1;	/* is the device visible in sysfs */
 	unsigned can_power_off:1; /* Device supports runtime power off */
+	unsigned wakeup_by_user:1;	/* user wakes up the ODD */
 
 	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */
 	struct list_head event_list;	/* asserted events */
-- 
1.7.2.5
