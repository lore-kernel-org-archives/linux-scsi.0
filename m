From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v8 11/11] ata: zpodd: handle power transition of ODD
Date: Mon, 29 Oct 2012 17:01:38 +0800
Message-ID: <1351501298-3716-12-git-send-email-aaron.lu@intel.com>
References: <1351501298-3716-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1351501298-3716-1-git-send-email-aaron.lu@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@hansenpartnership.com>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>, Oliver Neukum <oliver@neukum.org>
Cc: Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, Shane Huang <shane.huang@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The implementation of ZPODD aligns with runtime pm, which means the ODD
will only be runtime powered off after it is runtime suspended.

And each time in ata port's suspend callback, a check is made to see if
the ODD is ready to be powered off:
1 zp_ready is true;
2 events is successfully blocked.

If the 2 conditions are not met, ACPI_STATE_D0 is chosen since as far
as ACPI is concerned about ODD's power management, only D0 and D3 is
meanningful. There is no definition of D1/D2/D3hot state for ODD, so
avoid setting those ACPI states.

And on resume, it will re-gain power and go through the recovery
process. When EH for the ata port is done, the ODD is considered
functional, and post processing like eject tray if the ODD is drawer
type is done there.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/ata/libata-acpi.c | 34 +++++++++++++++++++-------
 drivers/ata/libata-core.c | 20 ++++++++++++++-
 drivers/ata/sata_zpodd.c  | 62 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/ata/sata_zpodd.h  |  8 ++++++
 4 files changed, 114 insertions(+), 10 deletions(-)

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index 5a78cb3..a8c9199 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -839,6 +839,24 @@ void ata_acpi_on_resume(struct ata_port *ap)
 	}
 }
 
+static int ata_acpi_choose_state(struct ata_device *dev)
+{
+	int acpi_state;
+
+	/* Always choose D3 for PATA devices */
+	if (!(dev->link->ap->flags & ATA_FLAG_ACPI_SATA))
+		return ACPI_STATE_D3;
+
+	acpi_state = acpi_pm_device_sleep_state(&dev->sdev->sdev_gendev,
+						NULL, ACPI_STATE_D3);
+
+	if (acpi_state == ACPI_STATE_D3 && zpodd_dev_enabled(dev) &&
+			!zpodd_poweroff_ready(dev))
+		acpi_state = ACPI_STATE_D0;
+
+	return acpi_state;
+}
+
 /**
  * ata_acpi_set_state - set the port power state
  * @ap: target ATA port
@@ -865,17 +883,15 @@ void ata_acpi_set_state(struct ata_port *ap, pm_message_t state)
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
+				if (zpodd_dev_enabled(dev))
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
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 95fb7b8..d3be1b6 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -70,6 +70,7 @@
 
 #include "libata.h"
 #include "libata-transport.h"
+#include "sata_zpodd.h"
 
 /* debounce timing parameters in msecs { interval, duration, timeout } */
 const unsigned long sata_deb_timing_normal[]		= {   5,  100, 2000 };
@@ -5399,6 +5400,23 @@ static int ata_port_runtime_idle(struct device *dev)
 	return pm_runtime_suspend(dev);
 }
 
+static int ata_port_runtime_resume(struct device *dev)
+{
+	int rc;
+	struct ata_device *ata_dev;
+	struct ata_port *ap = to_ata_port(dev);
+
+	rc = ata_port_resume_common(dev);
+	if (!rc) {
+		ata_for_each_dev(ata_dev, &ap->link, ENABLED) {
+			if (zpodd_dev_enabled(ata_dev))
+				zpodd_post_resume(ata_dev);
+		}
+	}
+
+	return rc;
+}
+
 static const struct dev_pm_ops ata_port_pm_ops = {
 	.suspend = ata_port_suspend,
 	.resume = ata_port_resume,
@@ -5408,7 +5426,7 @@ static const struct dev_pm_ops ata_port_pm_ops = {
 	.restore = ata_port_resume,
 
 	.runtime_suspend = ata_port_suspend,
-	.runtime_resume = ata_port_resume_common,
+	.runtime_resume = ata_port_runtime_resume,
 	.runtime_idle = ata_port_runtime_idle,
 };
 
diff --git a/drivers/ata/sata_zpodd.c b/drivers/ata/sata_zpodd.c
index 0ec62f3..aca2553 100644
--- a/drivers/ata/sata_zpodd.c
+++ b/drivers/ata/sata_zpodd.c
@@ -6,6 +6,7 @@
 
 #include "libata.h"
 #include "libata-atapi.h"
+#include "../scsi/sr_zpodd.h"
 
 #define POWEROFF_DELAY  (30 * 1000)     /* 30 seconds for power off delay */
 
@@ -16,6 +17,7 @@ struct zpodd {
 	bool status_ready:1;	/* ready status derived from media event poll,
 				   it is not accurate, but serves as a hint */
 	bool zp_ready:1;	/* zero power ready state */
+	bool powered_off:1;	/* ODD is powered off */
 
 	unsigned long last_ready; /* last zero power ready timestamp */
 
@@ -46,6 +48,17 @@ static int zpodd_run_atapi_cmd(struct ata_device *dev, const char *cdb,
 	return ret;
 }
 
+static int zpodd_eject_tray(struct ata_device *dev)
+{
+	const char cdb[] = {  GPCMD_START_STOP_UNIT,
+			      0, 0, 0,
+			      0x02,     /* LoEj */
+			      0, 0, 0, 0, 0, 0, 0,
+	};
+
+	return zpodd_run_atapi_cmd(dev, cdb, sizeof(cdb), NULL, 0);
+}
+
 /*
  * Per the spec, only slot type and drawer type ODD can be supported
  *
@@ -201,6 +214,55 @@ void zpodd_check_zpready(struct ata_device *dev)
 		zpodd->last_ready = 0;
 }
 
+/*
+ * Test if ODD is ready to be powered off.
+ * Determined by zp_ready and if events is successfully blocked
+ */
+bool zpodd_poweroff_ready(struct ata_device *dev)
+{
+	struct zpodd *zpodd = dev->private_data;
+
+	if (zpodd->zp_ready && sr_block_events(&dev->sdev->sdev_gendev))
+		return true;
+	else
+		return false;
+}
+
+void zpodd_post_poweroff(struct ata_device *dev)
+{
+	struct zpodd *zpodd = dev->private_data;
+
+	zpodd->powered_off = true;
+	acpi_pm_device_run_wake(&dev->sdev->sdev_gendev, true);
+}
+
+void zpodd_pre_poweron(struct ata_device *dev)
+{
+	struct zpodd *zpodd = dev->private_data;
+	if (zpodd->powered_off)
+		acpi_pm_device_run_wake(&dev->sdev->sdev_gendev, false);
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
+			zpodd_eject_tray(dev);
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
diff --git a/drivers/ata/sata_zpodd.h b/drivers/ata/sata_zpodd.h
index 03d6b4d..87f6f53 100644
--- a/drivers/ata/sata_zpodd.h
+++ b/drivers/ata/sata_zpodd.h
@@ -18,12 +18,20 @@ static bool zpodd_dev_enabled(struct ata_device *dev)
 
 void zpodd_snoop_status(struct ata_device *, struct scsi_cmnd *);
 void zpodd_check_zpready(struct ata_device *);
+bool zpodd_poweroff_ready(struct ata_device *);
+void zpodd_post_poweroff(struct ata_device *);
+void zpodd_pre_poweron(struct ata_device *);
+void zpodd_post_resume(struct ata_device *);
 #else
 static inline void zpodd_init(struct ata_device *dev) {}
 static inline void zpodd_deinit(struct ata_device *dev) {}
 static inline bool zpodd_dev_enabled(struct ata_device *dev) { return false; }
 static inline void zpodd_snoop_status(struct ata_device *dev, struct scsi_cmnd *cmd) {}
 static inline void zpodd_check_zpready(struct ata_device *dev) {}
+static inline bool zpodd_poweroff_ready(struct ata_device *dev) { return false; }
+static inline void zpodd_post_poweroff(struct ata_device *dev) {}
+static inline void zpodd_pre_poweron(struct ata_device *dev) {}
+static inline void zpodd_post_resume(struct ata_device *dev) {}
 #endif
 
 #endif
-- 
1.7.12.4

