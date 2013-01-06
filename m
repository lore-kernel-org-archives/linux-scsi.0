From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v11 6/9] libata: handle power transition of ODD
Date: Sun,  6 Jan 2013 10:48:26 +0800
Message-ID: <1357440509-28108-7-git-send-email-aaron.lu@intel.com>
References: <1357440509-28108-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:35590 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755870Ab3AFCsb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 5 Jan 2013 21:48:31 -0500
In-Reply-To: <1357440509-28108-1-git-send-email-aaron.lu@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>
Cc: Aaron Lu <aaron.lwe@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org, Aaron Lu <aaron.lu@intel.com>

When ata port is runtime suspended, it will check if the ODD attched to
it is a zero power(ZP) capable ODD and if the ZP capable ODD is in zero
power ready state. And if this is not the case, the highest acpi state
will be limited to ACPI_STATE_D3_HOT to avoid powering off the ODD.

And on resume, it will re-gain power and go through the recovery
process. When reset for the ata port is done, the ODD is considered
functional, and post processing like eject tray if the ODD is drawer
type is done there.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/ata/libata-acpi.c  | 35 ++++++++++++++++++++---------
 drivers/ata/libata-eh.c    |  2 ++
 drivers/ata/libata-zpodd.c | 56 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/ata/libata.h       |  8 +++++++
 4 files changed, 91 insertions(+), 10 deletions(-)

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index b4788dd..e832bf6 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -835,6 +835,22 @@ void ata_acpi_on_resume(struct ata_port *ap)
 	}
 }
 
+static int ata_acpi_choose_suspend_state(struct ata_device *dev)
+{
+	int d_max_in = ACPI_STATE_D3_COLD;
+
+	/*
+	 * For ATAPI, runtime D3 cold is only allowed
+	 * for ZPODD in zero power ready state
+	 */
+	if (dev->class == ATA_DEV_ATAPI &&
+	    !(zpodd_dev_enabled(dev) && zpodd_zpready(dev)))
+		d_max_in = ACPI_STATE_D3_HOT;
+
+	return acpi_pm_device_sleep_state(&dev->sdev->sdev_gendev,
+					  NULL, d_max_in);
+}
+
 /**
  * ata_acpi_set_state - set the port power state
  * @ap: target ATA port
@@ -861,17 +877,16 @@ void ata_acpi_set_state(struct ata_port *ap, pm_message_t state)
 			continue;
 
 		if (state.event != PM_EVENT_ON) {
-			acpi_state = acpi_pm_device_sleep_state(
-				&dev->sdev->sdev_gendev, NULL, ACPI_STATE_D3);
-			if (acpi_state > 0)
-				acpi_bus_set_power(handle, acpi_state);
-			/* TBD: need to check if it's runtime pm request */
-			acpi_pm_device_run_wake(
-				&dev->sdev->sdev_gendev, true);
+			acpi_state = ata_acpi_choose_suspend_state(dev);
+			if (acpi_state == ACPI_STATE_D0)
+				continue;
+			if (zpodd_dev_enabled(dev) &&
+			    acpi_state == ACPI_STATE_D3_COLD)
+				zpodd_pre_poweroff(dev);
+			acpi_bus_set_power(handle, acpi_state);
 		} else {
-			/* Ditto */
-			acpi_pm_device_run_wake(
-				&dev->sdev->sdev_gendev, false);
+			if (zpodd_dev_enabled(dev))
+				zpodd_pre_poweron(dev);
 			acpi_bus_set_power(handle, ACPI_STATE_D0);
 		}
 	}
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index d85934c..d772d66 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -3857,6 +3857,8 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 				rc = atapi_eh_clear_ua(dev);
 				if (rc)
 					goto rest_fail;
+				if (zpodd_dev_enabled(dev))
+					zpodd_post_resume(dev);
 			}
 		}
 
diff --git a/drivers/ata/libata-zpodd.c b/drivers/ata/libata-zpodd.c
index 7ee49bb..3c39987 100644
--- a/drivers/ata/libata-zpodd.c
+++ b/drivers/ata/libata-zpodd.c
@@ -17,6 +17,7 @@ struct zpodd {
 	/* The following bits are synchronized by PM core */
 	bool from_notify:1; /* resumed as a result of acpi notification */
 	bool zp_ready:1;	/* zero power ready state */
+	bool powered_off:1;	/* ODD is powered off */
 
 	unsigned long last_ready; /* last zero power ready timestamp */
 
@@ -42,6 +43,17 @@ static int run_atapi_cmd(struct ata_device *dev, const char *cdb,
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
@@ -155,6 +167,50 @@ void zpodd_on_suspend(struct ata_device *dev)
 	zpodd->zp_ready = true;
 }
 
+bool zpodd_zpready(struct ata_device *dev)
+{
+	struct zpodd *zpodd = dev->zpodd;
+	return zpodd->zp_ready;
+}
+
+void zpodd_pre_poweroff(struct ata_device *dev)
+{
+	struct zpodd *zpodd = dev->zpodd;
+
+	zpodd->powered_off = true;
+	device_set_run_wake(&dev->sdev->sdev_gendev, true);
+	acpi_pm_device_run_wake(&dev->sdev->sdev_gendev, true);
+}
+
+void zpodd_pre_poweron(struct ata_device *dev)
+{
+	struct zpodd *zpodd = dev->zpodd;
+
+	if (zpodd->powered_off) {
+		acpi_pm_device_run_wake(&dev->sdev->sdev_gendev, false);
+		device_set_run_wake(&dev->sdev->sdev_gendev, false);
+	}
+}
+
+void zpodd_post_resume(struct ata_device *dev)
+{
+	struct zpodd *zpodd = dev->zpodd;
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
+}
+
 static void zpodd_wake_dev(acpi_handle handle, u32 event, void *context)
 {
 	struct ata_device *ata_dev = context;
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index f9235dc..4b20e71 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -242,11 +242,19 @@ static inline bool zpodd_dev_enabled(struct ata_device *dev)
 	return dev->zpodd ? true : false;
 }
 void zpodd_on_suspend(struct ata_device *dev);
+bool zpodd_zpready(struct ata_device *dev);
+void zpodd_pre_poweroff(struct ata_device *dev);
+void zpodd_pre_poweron(struct ata_device *dev);
+void zpodd_post_resume(struct ata_device *dev);
 #else /* CONFIG_SATA_ZPODD */
 static inline void zpodd_init(struct ata_device *dev) {}
 static inline void zpodd_exit(struct ata_device *dev) {}
 static inline bool zpodd_dev_enabled(struct ata_device *dev) { return false; }
 static inline void zpodd_on_suspend(struct ata_device *dev) {}
+static inline bool zpodd_zpready(struct ata_device *dev) { return false; }
+static inline void zpodd_pre_poweroff(struct ata_device *dev) {}
+static inline void zpodd_pre_poweron(struct ata_device *dev) {}
+static inline void zpodd_post_resume(struct ata_device *dev) {}
 #endif /* CONFIG_SATA_ZPODD */
 
 #endif /* __LIBATA_H__ */
-- 
1.7.11.7

