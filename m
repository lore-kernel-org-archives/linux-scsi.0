From: Lin Ming <ming.m.lin@intel.com>
Subject: [RFC PATCH v2 8/8] [SCSI] sr: check and enable Zero-power ODD support
Date: Thu,  1 Mar 2012 17:02:57 +0800
Message-ID: <1330592577-16546-9-git-send-email-ming.m.lin@intel.com>
References: <1330592577-16546-1-git-send-email-ming.m.lin@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1330592577-16546-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Zhang Rui <rui.zhang@intel.com>, Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>, Aaron Lu <aaron.lu@amd.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi <linux-acpi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

ZPODD(Zero Power Optical Disk Drive) is a new feature in
SATA 3.1 specification. It provides a way to power off unused ODD.

ZPODD support is checked in in sr_probe().
can_power_off flag is set during suspend if ZPODD is supported.

ATA port's runtime suspend callback will actually power off the ODD
and its runtime resume callback will actually power on the ODD.

When ODD is powered off(D3Cold state), inserting disk will trigger a
wakeup event(GPE). GPE AML handler notifies the associated device. Then
ODD is resumed in the notify handler.

Signed-off-by: Lin Ming <ming.m.lin@intel.com
---
 drivers/ata/libata-acpi.c  |    8 ++++++-
 drivers/scsi/scsi_pm.c     |    8 +++++++
 drivers/scsi/sr.c          |   46 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/sr.h          |    3 ++
 include/scsi/scsi_device.h |    2 +
 5 files changed, 66 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index ec2a5a4..66b13d4 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -859,8 +859,14 @@ void ata_acpi_set_state(struct ata_port *ap, pm_message_t state)
 		if (state.event != PM_EVENT_ON) {
 			acpi_state = acpi_pm_device_sleep_state(
 				&dev->sdev->sdev_gendev, NULL);
-			if (acpi_state > 0)
+			if (acpi_state > 0) {
+				/* Check if the device is ready for power off */
+				if (acpi_state == ACPI_STATE_D3_COLD &&
+					!scsi_device_can_power_off(dev->sdev))
+					acpi_state = ACPI_STATE_D3;
+
 				acpi_bus_set_power(handle, acpi_state);
+			}
 			if (ap->tdev.power.request == RPM_REQ_SUSPEND)
 				acpi_pm_device_run_wake(
 					&dev->sdev->sdev_gendev, true);
diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index bf8bf79..24a0724 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -209,6 +209,14 @@ void scsi_autopm_put_host(struct Scsi_Host *shost)
 	pm_runtime_put_sync(&shost->shost_gendev);
 }
 
+bool scsi_device_can_power_off(struct scsi_device *sdev)
+{
+	struct device *dev = &sdev->sdev_gendev;
+
+	return !dev->power.subsys_data ? false :
+		dev->power.subsys_data->can_power_off;
+}
+
 #else
 
 #define scsi_runtime_suspend	NULL
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 5fc97d2..7cd0489 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -45,6 +45,8 @@
 #include <linux/blkdev.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
+#include <linux/pm_runtime.h>
+#include <linux/acpi.h>
 #include <asm/uaccess.h>
 
 #include <scsi/scsi.h>
@@ -80,12 +82,38 @@ static int sr_probe(struct device *);
 static int sr_remove(struct device *);
 static int sr_done(struct scsi_cmnd *);
 
+static int sr_suspend(struct device *dev, pm_message_t mesg)
+{
+	struct scsi_cd *cd;
+
+	cd = dev_get_drvdata(dev);
+	if (cd->zpodd)
+		dev->power.subsys_data->can_power_off = true;
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
+		dev->power.subsys_data->can_power_off = false;
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
@@ -216,6 +244,10 @@ static unsigned int sr_check_events(struct cdrom_device_info *cdi,
 	unsigned int events;
 	int ret;
 
+	/* Not necessary to check events if enter ZPODD state */
+	if (cd->zpodd && pm_runtime_suspended(&cd->device->sdev_gendev))
+		return 0;
+
 	/* no changer support */
 	if (CDSL_CURRENT != slot)
 		return 0;
@@ -260,6 +292,11 @@ static unsigned int sr_check_events(struct cdrom_device_info *cdi,
 	cd->media_present = scsi_status_is_good(ret) ||
 		(scsi_sense_valid(&sshdr) && sshdr.asc != 0x3a);
 
+	if (!cd->media_present && cd->zpodd && !cd->zpodd_event) {
+		scsi_autopm_put_device(cd->device);
+		cd->zpodd_event = 1;
+	}
+
 	if (last_present != cd->media_present)
 		cd->device->changed = 1;
 
@@ -716,6 +753,12 @@ static int sr_probe(struct device *dev)
 	disk->flags |= GENHD_FL_REMOVABLE;
 	add_disk(disk);
 
+	/* TODO: add device attention bit check for ZPODD */
+	if (device_run_wake(dev)) {
+		cd->zpodd = 1;
+		dev_pm_get_subsys_data(dev);
+	}
+
 	sdev_printk(KERN_DEBUG, sdev,
 		    "Attached scsi CD-ROM %s\n", cd->cdi.name);
 	return 0;
@@ -972,6 +1015,9 @@ static int sr_remove(struct device *dev)
 	kref_put(&cd->kref, sr_kref_release);
 	mutex_unlock(&sr_ref_mutex);
 
+	if (cd->zpodd)
+		dev_pm_put_subsys_data(dev);
+
 	return 0;
 }
 
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
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 77273f2..8b6c247 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -388,9 +388,11 @@ extern int scsi_execute_req(struct scsi_device *sdev, const unsigned char *cmd,
 #ifdef CONFIG_PM_RUNTIME
 extern int scsi_autopm_get_device(struct scsi_device *);
 extern void scsi_autopm_put_device(struct scsi_device *);
+extern bool scsi_device_can_power_off(struct scsi_device *);
 #else
 static inline int scsi_autopm_get_device(struct scsi_device *d) { return 0; }
 static inline void scsi_autopm_put_device(struct scsi_device *d) {}
+static inline bool scsi_device_can_power_off(struct scsi_device *d) { return false; };
 #endif /* CONFIG_PM_RUNTIME */
 
 static inline int __must_check scsi_device_reprobe(struct scsi_device *sdev)
-- 
1.7.2.5
