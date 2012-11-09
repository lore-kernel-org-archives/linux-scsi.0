From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v9 09/10] ata: zpodd: handle power transition of ODD
Date: Fri,  9 Nov 2012 14:52:01 +0800
Message-ID: <1352443922-13734-10-git-send-email-aaron.lu@intel.com>
References: <1352443922-13734-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1352443922-13734-1-git-send-email-aaron.lu@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>
Cc: Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org, Aaron Lu <aaron.lu@intel.com>
List-Id: linux-scsi@vger.kernel.org

When ata port is runtime suspended, it will check if the ODD attched to
it is in zero power ready state by checking the zp_ready field. And if
this field indicates it is not ready to be powered off, NO_POWEROFF qos
flag will be set to avoid choosing ACPI_STATE_D3_COLD for it.

Once powered off, disk events will be blocked to avoid waking it up
every two seconds.

And on resume, it will re-gain power and go through the recovery
process. When reset for the ata port is done, the ODD is considered
functional, and post processing like eject tray if the ODD is drawer
type is done there. And disk events is unblocked here.

For normal ODDs that do not support zero power state, NO_POWEROFF qos
flag will always be set.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/ata/libata-acpi.c  | 40 ++++++++++++++++++++++-------
 drivers/ata/libata-eh.c    |  2 ++
 drivers/ata/libata-zpodd.c | 63 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/ata/libata.h       |  8 ++++++
 include/linux/libata.h     |  2 ++
 5 files changed, 106 insertions(+), 9 deletions(-)

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index 13ee178..91f3405 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -838,6 +838,24 @@ void ata_acpi_on_resume(struct ata_port *ap)
 	}
 }
 
+static int ata_acpi_choose_state(struct ata_device *dev)
+{
+	/* Always choose D3 for PATA devices */
+	if (!(dev->link->ap->flags & ATA_FLAG_ACPI_SATA))
+		return ACPI_STATE_D3;
+
+	if (zpodd_dev_enabled(dev)) {
+		if (zpodd_poweroff_ready(dev))
+			dev_pm_qos_update_request(&dev->poweroff_req, 0);
+		else
+			dev_pm_qos_update_request(&dev->poweroff_req,
+						  PM_QOS_FLAG_NO_POWER_OFF);
+	}
+
+	return acpi_pm_device_sleep_state(&dev->sdev->sdev_gendev,
+					  NULL, ACPI_STATE_D3_COLD);
+}
+
 /**
  * ata_acpi_set_state - set the port power state
  * @ap: target ATA port
@@ -864,17 +882,16 @@ void ata_acpi_set_state(struct ata_port *ap, pm_message_t state)
 			continue;
 
 		if (state.event != PM_EVENT_ON) {
-			acpi_state = acpi_pm_device_sleep_state(
-				&dev->sdev->sdev_gendev, NULL, ACPI_STATE_D3);
-			if (acpi_state > 0)
+			acpi_state = ata_acpi_choose_state(dev);
+			if (acpi_state > 0) {
 				acpi_bus_set_power(handle, acpi_state);
-			/* TBD: need to check if it's runtime pm request */
-			acpi_pm_device_run_wake(
-				&dev->sdev->sdev_gendev, true);
+				if (zpodd_dev_enabled(dev) &&
+				    acpi_state == ACPI_STATE_D3_COLD)
+					zpodd_post_poweroff(dev);
+			}
 		} else {
-			/* Ditto */
-			acpi_pm_device_run_wake(
-				&dev->sdev->sdev_gendev, false);
+			if (zpodd_dev_enabled(dev))
+				zpodd_pre_poweron(dev);
 			acpi_bus_set_power(handle, ACPI_STATE_D0);
 		}
 	}
@@ -1008,7 +1025,12 @@ static void ata_acpi_unregister_power_resource(struct ata_device *dev)
 
 void ata_acpi_bind(struct ata_device *dev)
 {
+	/* ODD can't be put to D3 cold state, unless it is zero power capable */
+	s32 value = dev->class == ATA_DEV_ATAPI ? PM_QOS_FLAG_NO_POWER_OFF : 0;
+
 	ata_acpi_register_power_resource(dev);
+	dev_pm_qos_add_request(&dev->sdev->sdev_gendev, &dev->poweroff_req,
+				DEV_PM_QOS_FLAGS, value);
 }
 
 void ata_acpi_unbind(struct ata_device *dev)
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 6487b88..1348e7c 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -3771,6 +3771,8 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 				rc = atapi_eh_clear_ua(dev);
 				if (rc)
 					goto rest_fail;
+				if (zpodd_dev_enabled(dev))
+					zpodd_post_resume(dev);
 			}
 		}
 
diff --git a/drivers/ata/libata-zpodd.c b/drivers/ata/libata-zpodd.c
index 533a39e..777f9c7 100644
--- a/drivers/ata/libata-zpodd.c
+++ b/drivers/ata/libata-zpodd.c
@@ -5,6 +5,7 @@
 #include <scsi/scsi_cmnd.h>
 
 #include "libata.h"
+#include "../scsi/sr_zpodd.h"
 
 #define POWEROFF_DELAY  (30 * 1000)     /* 30 seconds for power off delay */
 
@@ -15,6 +16,7 @@ struct zpodd {
 	bool status_ready:1;	/* ready status derived from media event poll,
 				   it is not accurate, but serves as a hint */
 	bool zp_ready:1;	/* zero power ready state */
+	bool powered_off:1;	/* ODD is powered off */
 
 	unsigned long last_ready; /* last zero power ready timestamp */
 
@@ -40,6 +42,17 @@ static int run_atapi_cmd(struct ata_device *dev, const char *cdb,
 			buf ? DMA_FROM_DEVICE : DMA_NONE, buf, buf_len, 0);
 }
 
+static int eject_tray(struct ata_device *dev)
+{
+	const char cdb[] = {  GPCMD_START_STOP_UNIT,
+			      0, 0, 0,
+			      0x02,     /* LoEj */
+			      0, 0, 0, 0, 0, 0, 0,
+	};
+
+	return run_atapi_cmd(dev, cdb, sizeof(cdb), NULL, 0);
+}
+
 /*
  * Per the spec, only slot type and drawer type ODD can be supported
  *
@@ -209,6 +222,56 @@ void zpodd_check_zpready(struct ata_device *dev)
 		zpodd->last_ready = 0;
 }
 
+/*
+ * Test if ODD is ready to be powered off.
+ * Determined by zp_ready and if events is successfully blocked
+ */
+bool zpodd_poweroff_ready(struct ata_device *dev)
+{
+	struct zpodd *zpodd = dev->private_data;
+	return zpodd->zp_ready;
+}
+
+void zpodd_post_poweroff(struct ata_device *dev)
+{
+	struct zpodd *zpodd = dev->private_data;
+
+	sr_block_events(&dev->sdev->sdev_gendev);
+
+	zpodd->powered_off = true;
+	device_set_run_wake(&dev->sdev->sdev_gendev, true);
+	acpi_pm_device_run_wake(&dev->sdev->sdev_gendev, true);
+}
+
+void zpodd_pre_poweron(struct ata_device *dev)
+{
+	struct zpodd *zpodd = dev->private_data;
+	if (zpodd->powered_off) {
+		acpi_pm_device_run_wake(&dev->sdev->sdev_gendev, false);
+		device_set_run_wake(&dev->sdev->sdev_gendev, false);
+	}
+}
+
+void zpodd_post_resume(struct ata_device *dev)
+{
+	struct zpodd *zpodd = dev->private_data;
+
+	if (!zpodd->powered_off)
+		return;
+
+	zpodd->powered_off = false;
+
+	if (zpodd->from_notify) {
+		zpodd->from_notify = false;
+		if (zpodd->drawer)
+			eject_tray(dev);
+	}
+
+	zpodd->last_ready = 0;
+	zpodd->zp_ready = false;
+	sr_unblock_events(&dev->sdev->sdev_gendev);
+}
+
 static void zpodd_wake_dev(acpi_handle handle, u32 event, void *context)
 {
 	struct ata_device *ata_dev = context;
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 2b46703..5e4baf9 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -243,12 +243,20 @@ static inline bool zpodd_dev_enabled(struct ata_device *dev)
 }
 void zpodd_snoop_status(struct ata_device *dev, struct scsi_cmnd *scmd);
 void zpodd_check_zpready(struct ata_device *dev);
+bool zpodd_poweroff_ready(struct ata_device *dev);
+void zpodd_post_poweroff(struct ata_device *dev);
+void zpodd_pre_poweron(struct ata_device *dev);
+void zpodd_post_resume(struct ata_device *dev);
 #else /* CONFIG_SATA_ZPODD */
 static inline void zpodd_init(struct ata_device *dev) {}
 static inline void zpodd_deinit(struct ata_device *dev) {}
 static inline bool zpodd_dev_enabled(struct ata_device *dev) { return false; }
 static inline void zpodd_snoop_status(struct ata_device *dev, struct scsi_cmnd *scmd) {}
 static inline void zpodd_check_zpready(struct ata_device *dev) {}
+static inline bool zpodd_poweroff_ready(struct ata_device *dev) { return false; }
+static inline void zpodd_post_poweroff(struct ata_device *dev) {}
+static inline void zpodd_pre_poweron(struct ata_device *dev) {}
+static inline void zpodd_post_resume(struct ata_device *dev) {}
 #endif /* CONFIG_SATA_ZPODD */
 
 /* libata-atapi.c */
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 77eeeda..dc98912 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -38,6 +38,7 @@
 #include <linux/acpi.h>
 #include <linux/cdrom.h>
 #include <linux/sched.h>
+#include <linux/pm_qos.h>
 
 /*
  * Define if arch has non-standard setup.  This is a _PCI_ standard
@@ -618,6 +619,7 @@ struct ata_device {
 #ifdef CONFIG_ATA_ACPI
 	union acpi_object	*gtf_cache;
 	unsigned int		gtf_filter;
+	struct dev_pm_qos_request poweroff_req;
 #endif
 	struct device		tdev;
 	/* n_sector is CLEAR_BEGIN, read comment above CLEAR_BEGIN */
-- 
1.7.12.4

