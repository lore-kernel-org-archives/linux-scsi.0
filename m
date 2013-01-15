From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v13 5/9] libata: handle power transition of ODD
Date: Tue, 15 Jan 2013 17:21:01 +0800
Message-ID: <1358241665-2156-6-git-send-email-aaron.lu@intel.com>
References: <1358241665-2156-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <1358241665-2156-1-git-send-email-aaron.lu@intel.com>
Sender: linux-pm-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>
Cc: Aaron Lu <aaron.lwe@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

When ata port is runtime suspended, it will check if the ODD attched to
it is a zero power(ZP) capable ODD and if the ZP capable ODD is in zero
power ready state. And if this is not the case, the highest acpi state
will be limited to ACPI_STATE_D3_HOT to avoid powering off the ODD. And
if the ODD can be powered off, runtime wake capability needs to be
enabled and powered_off flag will be set to let resume code knows that
the ODD was in powered off state.

And on resume, before it is powered on, if it was powered off during
suspend, runtime wake capability needs to be disabled. After it is
recovered, the ODD is considered functional, post power on processing
like eject tray if the ODD is drawer type is done, and several ZPODD
related fields will also be reset.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Acked-by: Tejun Heo <tj@kernel.org>
---
 drivers/ata/libata-acpi.c  | 35 +++++++++++++------
 drivers/ata/libata-eh.c    |  2 ++
 drivers/ata/libata-zpodd.c | 83 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/ata/libata.h       |  8 +++++
 4 files changed, 118 insertions(+), 10 deletions(-)

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index 446b4e7..6f72c64 100644
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
+				zpodd_enable_run_wake(dev);
+			acpi_bus_set_power(handle, acpi_state);
 		} else {
-			/* Ditto */
-			acpi_pm_device_run_wake(
-				&dev->sdev->sdev_gendev, false);
+			if (zpodd_dev_enabled(dev))
+				zpodd_disable_run_wake(dev);
 			acpi_bus_set_power(handle, ACPI_STATE_D0);
 		}
 	}
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index a0dddc3..50f3ef0 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -3857,6 +3857,8 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 				rc = atapi_eh_clear_ua(dev);
 				if (rc)
 					goto rest_fail;
+				if (zpodd_dev_enabled(dev))
+					zpodd_post_poweron(dev);
 			}
 		}
 
diff --git a/drivers/ata/libata-zpodd.c b/drivers/ata/libata-zpodd.c
index 71dd48c..1f5d52a 100644
--- a/drivers/ata/libata-zpodd.c
+++ b/drivers/ata/libata-zpodd.c
@@ -26,8 +26,26 @@ struct zpodd {
 	bool			zp_ready; /* ZP ready state */
 	unsigned long		last_ready; /* last ZP ready timestamp */
 	bool			zp_sampled; /* ZP ready state sampled */
+	bool			powered_off; /* ODD is powered off
+					      *	during suspend */
 };
 
+static int eject_tray(struct ata_device *dev)
+{
+	struct ata_taskfile tf = {};
+	const char cdb[] = {  GPCMD_START_STOP_UNIT,
+		0, 0, 0,
+		0x02,     /* LoEj */
+		0, 0, 0, 0, 0, 0, 0,
+	};
+
+	tf.flags = ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
+	tf.command = ATA_CMD_PACKET;
+	tf.protocol = ATAPI_PROT_NODATA;
+
+	return ata_exec_internal(dev, &tf, cdb, DMA_NONE, NULL, 0, 0);
+}
+
 /* Per the spec, only slot type and drawer type ODD can be supported */
 static enum odd_mech_type zpodd_get_mech_type(struct ata_device *dev)
 {
@@ -149,6 +167,71 @@ void zpodd_on_suspend(struct ata_device *dev)
 	zpodd->zp_ready = true;
 }
 
+bool zpodd_zpready(struct ata_device *dev)
+{
+	struct zpodd *zpodd = dev->zpodd;
+	return zpodd->zp_ready;
+}
+
+/*
+ * Enable runtime wake capability through ACPI and set the powered_off flag,
+ * this flag will be used during resume to decide what operations are needed
+ * to take.
+ */
+void zpodd_enable_run_wake(struct ata_device *dev)
+{
+	struct zpodd *zpodd = dev->zpodd;
+
+	zpodd->powered_off = true;
+	device_set_run_wake(&dev->sdev->sdev_gendev, true);
+	acpi_pm_device_run_wake(&dev->sdev->sdev_gendev, true);
+}
+
+/* Disable runtime wake capability if it is enabled */
+void zpodd_disable_run_wake(struct ata_device *dev)
+{
+	struct zpodd *zpodd = dev->zpodd;
+
+	if (zpodd->powered_off) {
+		acpi_pm_device_run_wake(&dev->sdev->sdev_gendev, false);
+		device_set_run_wake(&dev->sdev->sdev_gendev, false);
+	}
+}
+
+/*
+ * Post power on processing after the ODD has been recovered. If the
+ * ODD wasn't powered off during suspend, it doesn't do anything.
+ *
+ * For drawer type ODD, if it is powered on due to user pressed the
+ * eject button, the tray needs to be ejected. This can only be done
+ * after the ODD has been recovered, i.e. link is initialized and
+ * device is able to process NON_DATA PIO command, as eject needs to
+ * send command for the ODD to process.
+ *
+ * The from_notify flag set in wake notification handler function
+ * zpodd_wake_dev represents if power on is due to user's action.
+ *
+ * For both types of ODD, several fields need to be reset.
+ */
+void zpodd_post_poweron(struct ata_device *dev)
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
+		if (zpodd->mech_type == ODD_MECH_TYPE_DRAWER)
+			eject_tray(dev);
+	}
+
+	zpodd->zp_sampled = false;
+	zpodd->zp_ready = false;
+}
+
 static void zpodd_wake_dev(acpi_handle handle, u32 event, void *context)
 {
 	struct ata_device *ata_dev = context;
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index b9b2bb1..c949dd3 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -242,11 +242,19 @@ static inline bool zpodd_dev_enabled(struct ata_device *dev)
 	return dev->zpodd != NULL;
 }
 void zpodd_on_suspend(struct ata_device *dev);
+bool zpodd_zpready(struct ata_device *dev);
+void zpodd_enable_run_wake(struct ata_device *dev);
+void zpodd_disable_run_wake(struct ata_device *dev);
+void zpodd_post_poweron(struct ata_device *dev);
 #else /* CONFIG_SATA_ZPODD */
 static inline void zpodd_init(struct ata_device *dev) {}
 static inline void zpodd_exit(struct ata_device *dev) {}
 static inline bool zpodd_dev_enabled(struct ata_device *dev) { return false; }
 static inline void zpodd_on_suspend(struct ata_device *dev) {}
+static inline bool zpodd_zpready(struct ata_device *dev) { return false; }
+static inline void zpodd_enable_run_wake(struct ata_device *dev) {}
+static inline void zpodd_disable_run_wake(struct ata_device *dev) {}
+static inline void zpodd_post_poweron(struct ata_device *dev) {}
 #endif /* CONFIG_SATA_ZPODD */
 
 #endif /* __LIBATA_H__ */
-- 
1.7.11.7

