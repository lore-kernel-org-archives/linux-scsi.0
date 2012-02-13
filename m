From: Lin Ming <ming.m.lin@intel.com>
Subject: [RFC PATCH 6/6] libata: add ZPODD support
Date: Mon, 13 Feb 2012 17:11:11 +0800
Message-ID: <1329124271-29464-7-git-send-email-ming.m.lin@intel.com>
References: <1329124271-29464-1-git-send-email-ming.m.lin@intel.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1329124271-29464-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Zhang Rui <rui.zhang@intel.com>, Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

ZPODD(Zero Power Optical Disk Drive) is a new feature in
SATA 3.1 specification. It provides a way to power off unused CDROM.

CDROM is powered off by executing ACPI power resource's _OFF method.

When CDROM is powered off(D3Cold state), inserting disk will trigger a
wakeup event(GPE). GPE AML handler notifies the associated device. Then
CDROM is resumed in the notify handler.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/ata/libata-acpi.c |   64 +++++++++++++++++++++++++++++++++++++-------
 drivers/scsi/sr.c         |   39 +++++++++++++++++++++++++++
 drivers/scsi/sr.h         |    3 ++
 3 files changed, 95 insertions(+), 11 deletions(-)

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index b03e468..acbb85e 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -16,6 +16,7 @@
 #include <linux/libata.h>
 #include <linux/pci.h>
 #include <linux/slab.h>
+#include <linux/pm_runtime.h>
 #include <scsi/scsi_device.h>
 #include "libata.h"
 
@@ -841,23 +842,45 @@ void ata_acpi_on_resume(struct ata_port *ap)
 void ata_acpi_set_state(struct ata_port *ap, pm_message_t state)
 {
 	struct ata_device *dev;
-
-	if (!ata_ap_acpi_handle(ap) || (ap->flags & ATA_FLAG_ACPI_SATA))
-		return;
+	acpi_handle handle;
+	int acpi_state;
 
 	/* channel first and then drives for power on and vica versa
 	   for power off */
-	if (state.event == PM_EVENT_ON)
-		acpi_bus_set_power(ata_ap_acpi_handle(ap), ACPI_STATE_D0);
+	handle = ata_ap_acpi_handle(ap);
+	if (handle && state.event == PM_EVENT_ON)
+		acpi_bus_set_power(handle, ACPI_STATE_D0);
 
 	ata_for_each_dev(dev, &ap->link, ENABLED) {
-		if (ata_dev_acpi_handle(dev))
-			acpi_bus_set_power(ata_dev_acpi_handle(dev),
-				state.event == PM_EVENT_ON ?
-					ACPI_STATE_D0 : ACPI_STATE_D3);
+		handle = ata_dev_acpi_handle(dev);
+		if (!handle)
+			continue;
+
+		if (state.event != PM_EVENT_ON) {
+			acpi_state = acpi_pm_device_sleep_state(
+				&dev->sdev->sdev_gendev, NULL);
+			if (acpi_state > 0) {
+				if (acpi_state == ACPI_STATE_D3_COLD &&
+					!pm_runtime_can_power_off(
+						&dev->sdev->sdev_gendev))
+					acpi_state = ACPI_STATE_D3;
+
+				acpi_bus_set_power(handle, acpi_state);
+			}
+			if (ap->tdev.power.request == RPM_REQ_SUSPEND);
+				acpi_pm_device_run_wake(
+					&dev->sdev->sdev_gendev, true);
+		} else {
+			if (ap->tdev.power.request == RPM_REQ_RESUME);
+				acpi_pm_device_run_wake(
+					&dev->sdev->sdev_gendev, false);
+			acpi_bus_set_power(handle, ACPI_STATE_D0);
+		}
 	}
-	if (state.event != PM_EVENT_ON)
-		acpi_bus_set_power(ata_ap_acpi_handle(ap), ACPI_STATE_D3);
+
+	handle = ata_ap_acpi_handle(ap);
+	if (handle && state.event != PM_EVENT_ON)
+		acpi_bus_set_power(handle, ACPI_STATE_D3);
 }
 
 /**
@@ -1007,6 +1030,14 @@ static int ata_acpi_bind_host(struct device *dev, int host, acpi_handle *handle)
 	return 0;
 }
 
+static void ata_acpi_wake_dev(acpi_handle handle, u32 event, void *context)
+{
+	struct ata_device *ata_dev = context;
+
+	if (event == ACPI_NOTIFY_DEVICE_WAKE && ata_dev)
+		scsi_autopm_get_device(ata_dev->sdev);
+}
+
 static int ata_acpi_bind_device(struct device *dev, int channel, int id,
 				acpi_handle *handle)
 {
@@ -1014,6 +1045,8 @@ static int ata_acpi_bind_device(struct device *dev, int channel, int id,
 	struct Scsi_Host *shost = dev_to_shost(host);
 	struct ata_port *ap = ata_shost_to_port(shost);
 	struct ata_device *ata_dev;
+	struct acpi_device *acpi_dev;
+	acpi_status status;
 
 	if (ap->flags & ATA_FLAG_ACPI_SATA)
 		ata_dev = &ap->link.device[channel];
@@ -1028,6 +1061,15 @@ static int ata_acpi_bind_device(struct device *dev, int channel, int id,
 	if (!is_registered_hotplug_dock_device(&ata_acpi_dev_dock_ops))
 		register_hotplug_dock_device(*handle, &ata_acpi_dev_dock_ops, ata_dev);
 
+	status = acpi_bus_get_device(*handle, &acpi_dev);
+	if (ACPI_SUCCESS(status) && acpi_dev->wakeup.flags.run_wake) {
+		acpi_install_notify_handler(*handle, ACPI_SYSTEM_NOTIFY,
+			ata_acpi_wake_dev, ata_dev);
+		device_set_run_wake(dev, true);
+
+		acpi_power_resource_register_device(dev, *handle);
+	}
+
 	return 0;
 }
 
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 5fc97d2..bf4eace 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -45,6 +45,7 @@
 #include <linux/blkdev.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
+#include <linux/pm_runtime.h>
 #include <asm/uaccess.h>
 
 #include <scsi/scsi.h>
@@ -80,12 +81,38 @@ static int sr_probe(struct device *);
 static int sr_remove(struct device *);
 static int sr_done(struct scsi_cmnd *);
 
+static int sr_suspend(struct device *dev)
+{
+	struct scsi_cd *cd;
+
+	cd = dev_get_drvdata(dev);
+	if (cd->zpodd)
+		pm_runtime_enable_power_off(dev);
+
+	return 0;
+}
+
+static int sr_resume(struct device *dev)
+{
+	struct scsi_cd *cd;
+
+	cd = dev_get_drvdata(dev);
+	if (cd->zpodd) {
+		pm_runtime_disable_power_off(dev);
+		cd->zpodd_event = 0;
+	}
+
+	return 0;
+}
+
 static struct scsi_driver sr_template = {
 	.owner			= THIS_MODULE,
 	.gendrv = {
 		.name   	= "sr",
 		.probe		= sr_probe,
 		.remove		= sr_remove,
+		.suspend	= sr_suspend,
+		.resume		= sr_resume,
 	},
 	.done			= sr_done,
 };
@@ -216,6 +243,10 @@ static unsigned int sr_check_events(struct cdrom_device_info *cdi,
 	unsigned int events;
 	int ret;
 
+	/* Not necessary to check events if enter ZPODD state */
+	if (cd->zpodd && pm_runtime_suspended(&cd->device->sdev_gendev))
+		return 0;
+
 	/* no changer support */
 	if (CDSL_CURRENT != slot)
 		return 0;
@@ -260,6 +291,11 @@ static unsigned int sr_check_events(struct cdrom_device_info *cdi,
 	cd->media_present = scsi_status_is_good(ret) ||
 		(scsi_sense_valid(&sshdr) && sshdr.asc != 0x3a);
 
+	if (!cd->media_present && cd->zpodd && !cd->zpodd_event) {
+		scsi_autopm_put_device(cd->device);
+		cd->zpodd_event = 1;
+	}
+
 	if (last_present != cd->media_present)
 		cd->device->changed = 1;
 
@@ -716,6 +752,9 @@ static int sr_probe(struct device *dev)
 	disk->flags |= GENHD_FL_REMOVABLE;
 	add_disk(disk);
 
+	if (device_run_wake(dev))
+		cd->zpodd = 1;
+
 	sdev_printk(KERN_DEBUG, sdev,
 		    "Attached scsi CD-ROM %s\n", cd->cdi.name);
 	return 0;
diff --git a/drivers/scsi/sr.h b/drivers/scsi/sr.h
index 37c8f6b..39b3d8c 100644
--- a/drivers/scsi/sr.h
+++ b/drivers/scsi/sr.h
@@ -42,6 +42,9 @@ typedef struct scsi_cd {
 	unsigned readcd_cdda:1;	/* reading audio data using READ_CD */
 	unsigned media_present:1;	/* media is present */
 
+	unsigned zpodd:1;	/* is ZPODD supported */
+	unsigned zpodd_event:1;
+
 	/* GET_EVENT spurious event handling, blk layer guarantees exclusion */
 	int tur_mismatch;		/* nr of get_event TUR mismatches */
 	bool tur_changed:1;		/* changed according to TUR */
-- 
1.7.2.5

