From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v12 4/9] libata: check zero power ready status for ZPODD
Date: Thu, 10 Jan 2013 17:24:25 +0800
Message-ID: <1357809870-18816-5-git-send-email-aaron.lu@intel.com>
References: <1357809870-18816-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <1357809870-18816-1-git-send-email-aaron.lu@intel.com>
Sender: linux-pm-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>
Cc: Aaron Lu <aaron.lwe@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org, Aaron Lu <aaron.lu@intel.com>
List-Id: linux-scsi@vger.kernel.org

Per the Mount Fuji spec, the ODD is considered zero power ready when:
  - For slot type ODD, no media inside;
  - For tray type ODD, no media inside and tray closed.

The information can be retrieved by either the returned information of
command GET_EVENT_STATUS_NOTIFICATION(the command is used to poll for
media event) or sense code.

The information provided by the media status byte is not accurate, it
is possible that after a new disc is just inserted, the status byte
still returns media not present. So this information can not be used as
the deciding factor, we use sense code to decide if zpready status is
true.

When we first sensed the ODD in the zero power ready state, the
zp_sampled will be set and timestamp will be recoreded. And after ODD
stayed in this state for some pre-defined period, the ODD is considered
as power off ready and the zp_ready flag will be set. The zp_ready flag
serves as the deciding factor other code will use to see if power off is
OK for the ODD.

The Mount Fuji spec suggests a delay should be used here, to avoid the
case user ejects the ODD and then instantly inserts a new one again, so
that we can avoid a power transition. And some ODDs may be slow to place
its head to the home position after disc is ejected, so a delay here is
generally a good idea. And the delay time can be changed via the module
param zpodd_poweroff_delay.

The zero power ready status check is performed in the ata port's runtime
suspend code path, when port is not frozen yet, as we need to issue some
IOs to the ODD.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/ata/libata-eh.c    | 14 +++++++--
 drivers/ata/libata-zpodd.c | 75 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/ata/libata.h       |  5 ++++
 3 files changed, 92 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index bf039b0..180ae6a 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1591,7 +1591,7 @@ static int ata_eh_read_log_10h(struct ata_device *dev,
  *	RETURNS:
  *	0 on success, AC_ERR_* mask on failure.
  */
-static unsigned int atapi_eh_tur(struct ata_device *dev, u8 *r_sense_key)
+unsigned int atapi_eh_tur(struct ata_device *dev, u8 *r_sense_key)
 {
 	u8 cdb[ATAPI_CDB_LEN] = { TEST_UNIT_READY, 0, 0, 0, 0, 0 };
 	struct ata_taskfile tf;
@@ -1624,7 +1624,7 @@ static unsigned int atapi_eh_tur(struct ata_device *dev, u8 *r_sense_key)
  *	RETURNS:
  *	0 on success, AC_ERR_* mask on failure
  */
-static unsigned int atapi_eh_request_sense(struct ata_device *dev,
+unsigned int atapi_eh_request_sense(struct ata_device *dev,
 					   u8 *sense_buf, u8 dfl_sense_key)
 {
 	u8 cdb[ATAPI_CDB_LEN] =
@@ -4022,6 +4022,7 @@ static void ata_eh_handle_port_suspend(struct ata_port *ap)
 {
 	unsigned long flags;
 	int rc = 0;
+	struct ata_device *dev;
 
 	/* are we suspending? */
 	spin_lock_irqsave(ap->lock, flags);
@@ -4034,6 +4035,15 @@ static void ata_eh_handle_port_suspend(struct ata_port *ap)
 
 	WARN_ON(ap->pflags & ATA_PFLAG_SUSPENDED);
 
+	/*
+	 * If we have a ZPODD attached, check its zero
+	 * power ready status before the port is frozen.
+	 */
+	ata_for_each_dev(dev, &ap->link, ENABLED) {
+		if (zpodd_dev_enabled(dev))
+			zpodd_on_suspend(dev);
+	}
+
 	/* tell ACPI we're suspending */
 	rc = ata_acpi_on_suspend(ap);
 	if (rc)
diff --git a/drivers/ata/libata-zpodd.c b/drivers/ata/libata-zpodd.c
index 9a0d90d..71dd48c 100644
--- a/drivers/ata/libata-zpodd.c
+++ b/drivers/ata/libata-zpodd.c
@@ -1,10 +1,15 @@
 #include <linux/libata.h>
 #include <linux/cdrom.h>
 #include <linux/pm_runtime.h>
+#include <linux/module.h>
 #include <scsi/scsi_device.h>
 
 #include "libata.h"
 
+static int zpodd_poweroff_delay = 30; /* 30 seconds for power off delay */
+module_param(zpodd_poweroff_delay, int, 0644);
+MODULE_PARM_DESC(zpodd_poweroff_delay, "Poweroff delay for ZPODD in seconds");
+
 enum odd_mech_type {
 	ODD_MECH_TYPE_SLOT,
 	ODD_MECH_TYPE_DRAWER,
@@ -18,6 +23,9 @@ struct zpodd {
 	/* The following fields are synchronized by PM core. */
 	bool			from_notify; /* resumed as a result of
 					      * acpi wake notification */
+	bool			zp_ready; /* ZP ready state */
+	unsigned long		last_ready; /* last ZP ready timestamp */
+	bool			zp_sampled; /* ZP ready state sampled */
 };
 
 /* Per the spec, only slot type and drawer type ODD can be supported */
@@ -74,6 +82,73 @@ static bool odd_can_poweroff(struct ata_device *ata_dev)
 	return acpi_device_can_poweroff(acpi_dev);
 }
 
+/* Test if ODD is zero power ready by sense code */
+static bool zpready(struct ata_device *dev)
+{
+	u8 sense_key, *sense_buf;
+	unsigned int ret, asc, ascq, add_len;
+	struct zpodd *zpodd = dev->zpodd;
+
+	ret = atapi_eh_tur(dev, &sense_key);
+
+	if (!ret || sense_key != NOT_READY)
+		return false;
+
+	sense_buf = dev->link->ap->sector_buf;
+	ret = atapi_eh_request_sense(dev, sense_buf, sense_key);
+	if (ret)
+		return false;
+
+	/* sense valid */
+	if ((sense_buf[0] & 0x7f) != 0x70)
+		return false;
+
+	add_len = sense_buf[7];
+	/* has asc and ascq */
+	if (add_len < 6)
+		return false;
+
+	asc = sense_buf[12];
+	ascq = sense_buf[13];
+
+	if (zpodd->mech_type == ODD_MECH_TYPE_SLOT)
+		/* no media inside */
+		return asc == 0x3a;
+	else
+		/* no media inside and door closed */
+		return asc == 0x3a && ascq == 0x01;
+}
+
+/*
+ * Update the zpodd->zp_ready field. This field will only be set
+ * if the ODD has stayed in ZP ready state for zpodd_poweroff_delay
+ * time, and will be used to decide if power off is allowed. If it
+ * is set, it will be cleared during resume from powered off state.
+ */
+void zpodd_on_suspend(struct ata_device *dev)
+{
+	struct zpodd *zpodd = dev->zpodd;
+	unsigned long expires;
+
+	if (!zpready(dev)) {
+		zpodd->zp_sampled = false;
+		return;
+	}
+
+	if (!zpodd->zp_sampled) {
+		zpodd->zp_sampled = true;
+		zpodd->last_ready = jiffies;
+		return;
+	}
+
+	expires = zpodd->last_ready +
+		  msecs_to_jiffies(zpodd_poweroff_delay * 1000);
+	if (time_before(jiffies, expires))
+		return;
+
+	zpodd->zp_ready = true;
+}
+
 static void zpodd_wake_dev(acpi_handle handle, u32 event, void *context)
 {
 	struct ata_device *ata_dev = context;
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index a21740b..b9b2bb1 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -182,6 +182,9 @@ extern void ata_eh_finish(struct ata_port *ap);
 extern int ata_ering_map(struct ata_ering *ering,
 			 int (*map_fn)(struct ata_ering_entry *, void *),
 		  	 void *arg);
+extern unsigned int atapi_eh_tur(struct ata_device *dev, u8 *r_sense_key);
+extern unsigned int atapi_eh_request_sense(struct ata_device *dev,
+					   u8 *sense_buf, u8 dfl_sense_key);
 
 /* libata-pmp.c */
 #ifdef CONFIG_SATA_PMP
@@ -238,10 +241,12 @@ static inline bool zpodd_dev_enabled(struct ata_device *dev)
 {
 	return dev->zpodd != NULL;
 }
+void zpodd_on_suspend(struct ata_device *dev);
 #else /* CONFIG_SATA_ZPODD */
 static inline void zpodd_init(struct ata_device *dev) {}
 static inline void zpodd_exit(struct ata_device *dev) {}
 static inline bool zpodd_dev_enabled(struct ata_device *dev) { return false; }
+static inline void zpodd_on_suspend(struct ata_device *dev) {}
 #endif /* CONFIG_SATA_ZPODD */
 
 #endif /* __LIBATA_H__ */
-- 
1.7.11.7

