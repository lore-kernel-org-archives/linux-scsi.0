From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v7 3/6] scsi: sr: support zero power ODD(ZPODD)
Date: Wed, 12 Sep 2012 16:29:54 +0800
Message-ID: <1347438597-5903-4-git-send-email-aaron.lu@intel.com>
References: <1347438597-5903-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:48620 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753690Ab2ILIaN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Sep 2012 04:30:13 -0400
In-Reply-To: <1347438597-5903-1-git-send-email-aaron.lu@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oliver@neukum.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Aaron Lu <aaron.lu@intel.com>

When ODD is runtime suspended, we will check if it is OK to remove
its power:
1 For tray type, no medium inside and tray closed;
2 For slot type, no medium inside.
And if yes, we will set the ready_to_power_off flag as an indication to
ATA layer that it is safe to place this device into ACPI D3 cold power
state.

And when it is powered off, we will set the powered_off flag so that the
periodically running check_events will not bother this device by simply
return.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/ata/libata-acpi.c  | 27 +++++++++++++++--------
 drivers/scsi/sr.c          | 53 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/sr.h          |  1 +
 drivers/scsi/sr_ioctl.c    |  7 +++++-
 include/scsi/scsi_device.h |  3 +++
 5 files changed, 81 insertions(+), 10 deletions(-)

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index 902b5a4..9aca057 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -854,7 +854,7 @@ void ata_acpi_set_state(struct ata_port *ap, pm_message_t state)
 {
 	struct ata_device *dev;
 	acpi_handle handle;
-	int acpi_state;
+	int acpi_state, ret;
 
 	/* channel first and then drives for power on and vica versa
 	   for power off */
@@ -869,17 +869,24 @@ void ata_acpi_set_state(struct ata_port *ap, pm_message_t state)
 
 		if (state.event != PM_EVENT_ON) {
 			acpi_state = acpi_pm_device_sleep_state(
-				&dev->sdev->sdev_gendev, NULL, ACPI_STATE_D3);
-			if (acpi_state > 0)
-				acpi_bus_set_power(handle, acpi_state);
-			/* TBD: need to check if it's runtime pm request */
-			acpi_pm_device_run_wake(
-				&dev->sdev->sdev_gendev, true);
+					&dev->sdev->sdev_gendev, NULL,
+					dev->sdev->ready_to_power_off ?
+					ACPI_STATE_D3 : ACPI_STATE_D3_HOT);
+			if (acpi_state > 0) {
+				ret = acpi_bus_set_power(handle, acpi_state);
+				if (!ret && acpi_state == ACPI_STATE_D3)
+					dev->sdev->powered_off = 1;
+
+				/* TODO: check if it's runtime pm request */
+				acpi_pm_device_run_wake(
+						&dev->sdev->sdev_gendev, true);
+			}
 		} else {
 			/* Ditto */
 			acpi_pm_device_run_wake(
 				&dev->sdev->sdev_gendev, false);
 			acpi_bus_set_power(handle, ACPI_STATE_D0);
+			dev->sdev->powered_off = 0;
 		}
 	}
 
@@ -985,8 +992,10 @@ static void ata_acpi_wake_dev(acpi_handle handle, u32 event, void *context)
 	struct ata_device *ata_dev = context;
 
 	if (event == ACPI_NOTIFY_DEVICE_WAKE && ata_dev &&
-			pm_runtime_suspended(&ata_dev->sdev->sdev_gendev))
-		scsi_autopm_get_device(ata_dev->sdev);
+			ata_dev->sdev->powered_off) {
+		ata_dev->sdev->need_eject = 1;
+		pm_runtime_resume(&ata_dev->sdev->sdev_gendev);
+	}
 }
 
 static void ata_acpi_add_pm_notifier(struct ata_device *dev)
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 7a8222f..ef72682 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -80,6 +80,8 @@ static DEFINE_MUTEX(sr_mutex);
 static int sr_probe(struct device *);
 static int sr_remove(struct device *);
 static int sr_done(struct scsi_cmnd *);
+static int sr_suspend(struct device *, pm_message_t msg);
+static int sr_resume(struct device *);
 
 static struct scsi_driver sr_template = {
 	.owner			= THIS_MODULE,
@@ -87,6 +89,8 @@ static struct scsi_driver sr_template = {
 		.name   	= "sr",
 		.probe		= sr_probe,
 		.remove		= sr_remove,
+		.suspend        = sr_suspend,
+		.resume         = sr_resume,
 	},
 	.done			= sr_done,
 };
@@ -172,6 +176,52 @@ static void scsi_cd_put(struct scsi_cd *cd)
 	mutex_unlock(&sr_ref_mutex);
 }
 
+static int sr_suspend(struct device *dev, pm_message_t msg)
+{
+	struct scsi_sense_hdr sshdr;
+	struct scsi_cd *cd = dev_get_drvdata(dev);
+
+	if (!cd->device->can_power_off)
+		return 0;
+
+	/* See if we can power off this ZPODD device */
+	scsi_test_unit_ready(cd->device, SR_TIMEOUT, MAX_RETRIES, &sshdr);
+	if (cd->cdi.mask & CDC_CLOSE_TRAY)
+		/* no media for caddy/slot type ODD */
+		cd->device->ready_to_power_off = scsi_sense_valid(&sshdr) &&
+							sshdr.asc == 0x3a;
+	else
+		/* no media and door closed for tray type ODD */
+		cd->device->ready_to_power_off = scsi_sense_valid(&sshdr) &&
+					sshdr.asc == 0x3a && sshdr.ascq == 0x01;
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
+	if (!cd->device->powered_off)
+		return 0;
+
+	/* get the disk ready */
+	scsi_test_unit_ready(cd->device, SR_TIMEOUT, MAX_RETRIES, &sshdr);
+
+	/* If user wakes up the ODD, eject the tray */
+	if (cd->device->need_eject) {
+		cd->device->need_eject = 0;
+		/* But only for tray type ODD when door is not locked */
+		if (!(cd->cdi.mask & CDC_CLOSE_TRAY) && !cd->door_locked)
+			sr_tray_move(&cd->cdi, 1);
+	}
+
+	return 0;
+}
+
 static unsigned int sr_get_events(struct scsi_device *sdev)
 {
 	u8 buf[8];
@@ -226,6 +276,9 @@ static unsigned int sr_check_events(struct cdrom_device_info *cdi,
 	if (CDSL_CURRENT != slot)
 		return 0;
 
+	if (cd->device->powered_off)
+		return 0;
+
 	scsi_autopm_get_device(cd->device);
 
 	events = sr_get_events(cd->device);
diff --git a/drivers/scsi/sr.h b/drivers/scsi/sr.h
index 37c8f6b..1c84537 100644
--- a/drivers/scsi/sr.h
+++ b/drivers/scsi/sr.h
@@ -41,6 +41,7 @@ typedef struct scsi_cd {
 	unsigned readcd_known:1;	/* drive supports READ_CD (0xbe) */
 	unsigned readcd_cdda:1;	/* reading audio data using READ_CD */
 	unsigned media_present:1;	/* media is present */
+	unsigned door_locked:1; /* door is locked */
 
 	/* GET_EVENT spurious event handling, blk layer guarantees exclusion */
 	int tur_mismatch;		/* nr of get_event TUR mismatches */
diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
index a3911c3..c1275f6 100644
--- a/drivers/scsi/sr_ioctl.c
+++ b/drivers/scsi/sr_ioctl.c
@@ -292,10 +292,15 @@ int sr_tray_move(struct cdrom_device_info *cdi, int pos)
 
 int sr_lock_door(struct cdrom_device_info *cdi, int lock)
 {
+	int ret;
 	Scsi_CD *cd = cdi->handle;
 
-	return scsi_set_medium_removal(cd->device, lock ?
+	ret = scsi_set_medium_removal(cd->device, lock ?
 		       SCSI_REMOVAL_PREVENT : SCSI_REMOVAL_ALLOW);
+	if (!ret)
+		cd->door_locked = lock;
+
+	return ret;
 }
 
 int sr_drive_status(struct cdrom_device_info *cdi, int slot)
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 9895f69..da5c86f 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -156,6 +156,9 @@ struct scsi_device {
 	unsigned is_visible:1;	/* is the device visible in sysfs */
 	unsigned can_power_off:1; /* Device supports runtime power off */
 	unsigned wce_default_on:1;	/* Cache is ON by default */
+	unsigned need_eject:1;	/* Need eject the tray when wakes up */
+	unsigned ready_to_power_off:1;	/* Device is ready to be powered off */
+	unsigned powered_off:1;	/* Device is powered off */
 
 	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */
 	struct list_head event_list;	/* asserted events */
-- 
1.7.12.21.g871e293

