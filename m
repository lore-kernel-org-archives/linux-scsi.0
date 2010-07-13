From: su henry <henry.su.ati@gmail.com>
Subject: [PATCH RFC v2] support SATA ODD zero power
Date: Tue, 13 Jul 2010 11:19:10 +0800
Message-ID: <AANLkTinMHgk_4rwWkLoPntMyWYVLUKl_NyVn6Bllg6o3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:53949 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab0GMDTM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jul 2010 23:19:12 -0400
Received: by qyk35 with SMTP id 35so1805998qyk.19
        for <linux-scsi@vger.kernel.org>; Mon, 12 Jul 2010 20:19:11 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-scsi@vger.kernel.org, htejun <htejun@gmail.com>

>From 53f3108a156e69da4bae4c2f2b9a189e2456cdbb Mon Sep 17 00:00:00 2001
From: henry su <henry.su.ati@gmail.com>
Date: Fri, 9 Jul 2010 19:39:46 +0800
Subject: [PATCH RFC v2] support sata odd zero power

In order to extend the battery life of Mobile PC system, the host
should remove the power supply to the Optical Disc Drive (logical
unit) when it detects the logical unit with no media and tray closed,
and the host starts the power supply to the logical unit when it
detects user action to the logical unit that the power supply is
omitted.

The patch evaluates the _PS3 method to remove the power supply to the
ODD if the host detects MEDIUM NOT PRESENT - TRAY CLOSED is reported
by REQUEST SENSE command for a Drawer, Tray or Pop-up type drive, or
MEDIUM NOT PRESENT - TRAY CLOSED for a slot/caddy type drive; on the
other hand, the patch evaluates the _PS0 method to restart the power
supply to the ODD when the user presses the button on a tray type
drive or inserts a CD to a slot/caddy type drive.

PLDS DS-8A5S, pansonic UJ892 and UJ897 are the ODD samples used to
test the patch on AMD SB800 platforms.

Signed-off-by: Henry Su <henry.su.ati@gmail.com>
---
 drivers/scsi/Kconfig   |   17 ++++
 drivers/scsi/Makefile  |    2 +-
 drivers/scsi/sr.c      |    4 +
 drivers/scsi/sr.h      |   12 +++
 drivers/scsi/sr_acpi.c |  215 ++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 249 insertions(+), 1 deletions(-)
 create mode 100644 drivers/scsi/sr_acpi.c

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 75f2336..5634424 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -146,6 +146,23 @@ config BLK_DEV_SR_VENDOR
 	  drives (and HP Writers). If you have such a drive and get the first
 	  session only, try saying Y here; everybody else says N.

+config BLK_DEV_SR_ZERO_POWER
+	bool "Enable SATA Zero Power ODD support (for SCSI CDROM)"
+	depends on BLK_DEV_SR && ACPI
+	help
+	  When the host detects the SCSI CDROM with no media and tray closed in
+	  case of tray/drawer loading mechanism, the host remove the power
+	  supply to the CDROM. When host detect the user action to the CDROM
+	  that the power supply is ommited, the host will start the power
+	  supply to the CDROM. Host can achive Zero Power consumption on such
+	  empty CDROM.
+
+	  See more information in appendix K in Mt. Fuji commands for
+	  Multimedia devices version7.
+ 	
+	  If you want to support sata odd zero power, and the drive can do zero
+	  power, try saying Y here; else says N.
+
 config CHR_DEV_SG
 	tristate "SCSI generic support"
 	depends on SCSI
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 1c7ac49..cc9ec84 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -169,7 +169,7 @@ scsi_tgt-y			+= scsi_tgt_lib.o scsi_tgt_if.o
 sd_mod-objs	:= sd.o
 sd_mod-$(CONFIG_BLK_DEV_INTEGRITY) += sd_dif.o

-sr_mod-objs	:= sr.o sr_ioctl.o sr_vendor.o
+sr_mod-objs	:= sr.o sr_ioctl.o sr_vendor.o sr_acpi.o
 ncr53c8xx-flags-$(CONFIG_SCSI_ZALON) \
 		:= -DCONFIG_NCR53C8XX_PREFETCH -DSCSI_NCR_BIG_ENDIAN \
 			-DCONFIG_SCSI_NCR53C8XX_NO_WORD_TRANSFERS
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 0a90abc..7755658 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -631,6 +631,7 @@ static int sr_probe(struct device *dev)
 	get_capabilities(cd);
 	blk_queue_prep_rq(sdev->request_queue, sr_prep_fn);
 	sr_vendor_init(cd);
+	sr_acpi_init(cd);

 	disk->driverfs_dev = &sdev->sdev_gendev;
 	set_capacity(disk, cd->capacity);
@@ -789,6 +790,7 @@ static void get_capabilities(struct scsi_cd *cd)
 	cd->cdi.speed = ((buffer[n + 8] << 8) + buffer[n + 9]) / 176;
 	cd->readcd_known = 1;
 	cd->readcd_cdda = buffer[n + 5] & 0x01;
+	cd->type = buffer[n + 6] >> 5;
 	/* print some capability bits */
 	printk("%s: scsi3-mmc drive: %dx/%dx %s%s%s%s%s%s\n", cd->cdi.name,
 	       ((buffer[n + 14] << 8) + buffer[n + 15]) / 176,
@@ -894,6 +896,7 @@ static int sr_remove(struct device *dev)
 	mutex_lock(&sr_ref_mutex);
 	kref_put(&cd->kref, sr_kref_release);
 	mutex_unlock(&sr_ref_mutex);
+	sr_acpi_remove(dev);

 	return 0;
 }
@@ -916,6 +919,7 @@ static void __exit exit_sr(void)
 {
 	scsi_unregister_driver(&sr_template.gendrv);
 	unregister_blkdev(SCSI_CDROM_MAJOR, "sr");
+	sr_acpi_unregister();
 }

 module_init(init_sr);
diff --git a/drivers/scsi/sr.h b/drivers/scsi/sr.h
index 1e144df..96d85e0 100644
--- a/drivers/scsi/sr.h
+++ b/drivers/scsi/sr.h
@@ -46,6 +46,13 @@ typedef struct scsi_cd {
 	 * the refs on this kref to decide when to release them */
 	struct kref kref;
 	struct gendisk *disk;
+
+#ifdef CONFIG_BLK_DEV_SR_ZERO_POWER
+	mechtype_t type;
+	unsigned int no_media_retry;
+	struct timer_list zero_power_timer;
+	struct work_struct sr_set_power;
+#endif
 } Scsi_CD;

 int sr_do_ioctl(Scsi_CD *, struct packet_command *);
@@ -68,4 +75,9 @@ void sr_vendor_init(Scsi_CD *);
 int sr_cd_check(struct cdrom_device_info *);
 int sr_set_blocklength(Scsi_CD *, int blocklength);

+/* sr_acpi.c */
+void sr_acpi_init(Scsi_CD *);
+int sr_acpi_remove(struct device *dev);
+void sr_acpi_unregister(void);
+
 #endif
diff --git a/drivers/scsi/sr_acpi.c b/drivers/scsi/sr_acpi.c
new file mode 100644
index 0000000..b5a5c66
--- /dev/null
+++ b/drivers/scsi/sr_acpi.c
@@ -0,0 +1,215 @@
+
+#include <linux/cdrom.h>
+#include <linux/errno.h>
+#include <linux/string.h>
+#include <linux/bcd.h>
+#include <linux/blkdev.h>
+#include <linux/slab.h>
+
+#include <scsi/scsi.h>
+#include <scsi/scsi_dbg.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_driver.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_eh.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_ioctl.h>	/* For the door lock/unlock commands */
+
+#include <acpi/acpi_bus.h>
+#include "sr.h"
+
+#ifdef CONFIG_BLK_DEV_SR_ZERO_POWER
+#define SR_CHECK_STATE_TIMEOUT	(10*HZ)
+#define SR_NO_MEDIA_RETRY	10	
+#define SR_ZPODD_REGISTERED	0x01
+#define SR_ZPODD_NEED_EJECT	0x02
+
+static struct sr_zero_power {
+	struct workqueue_struct *wq;
+	u32 flags;
+	acpi_handle handle;
+	spinlock_t lock;
+	struct scsi_cd *cd;
+	struct work_struct set_power;
+} sr_zpodd;
+
+/* Remove the power supply to the drive if detecting no media */
+void sr_acpi_remove_power(struct work_struct *work)
+{
+	struct scsi_cd *cd = sr_zpodd.cd;
+	struct scsi_sense_hdr *sshdr;
+	int isvalid;
+
+	sshdr =  kzalloc(sizeof(*sshdr), GFP_KERNEL);
+	sr_test_unit_ready(sr_zpodd.cd->device, sshdr);
+	isvalid = scsi_sense_valid(sshdr);
+
+	/* 0x3a is media not present */
+	if ((isvalid && (sshdr->asc  == 0x3a &&
+		/* tray opened for caddy/slot type drive*/
+		((cd->type == mechtype_caddy && sshdr->ascq == 0x02) ||
+		/*tray closed for tray/drawer/pop-up for type drive*/
+		sshdr->ascq == 0x01)))) {
+			if (cd->no_media_retry < SR_NO_MEDIA_RETRY) {
+				cd->no_media_retry += 1;
+			} else {
+				del_timer_sync(&cd->zero_power_timer);
+				acpi_bus_set_power(sr_zpodd.handle,
+							ACPI_STATE_D3);
+			}
+	} else
+		cd->no_media_retry = 1;
+
+	kfree(sshdr);
+
+}
+
+void sr_acpi_queue_work(unsigned long data)
+{
+	int isvalid;
+	unsigned long flags;
+	struct scsi_cd *cd = sr_zpodd.cd;
+
+	spin_lock_irqsave(&sr_zpodd.lock, flags);
+	isvalid = queue_work(sr_zpodd.wq, &sr_zpodd.set_power);
+	BUG_ON(!isvalid);
+
+	mod_timer(&cd->zero_power_timer, jiffies+SR_CHECK_STATE_TIMEOUT);
+	spin_unlock_irqrestore(&sr_zpodd.lock, flags);
+}
+
+/*
+ * Handle ACPI event notification when pressing the button on a
+ * tray type drive or inserting a CD to a caddy/slot type drive
+ */
+static void sr_acpi_handle_events(acpi_handle handle, u32 event, void *context)
+{
+	unsigned int state;
+
+	switch (event) {
+	/* FIXME: handle both wake and 0x80 notifications? */
+	case 0x02:
+	case 0x80:
+		acpi_bus_get_power(sr_zpodd.handle, &state);
+		if (state == ACPI_STATE_D3) {
+			acpi_bus_set_power(sr_zpodd.handle,
+						ACPI_STATE_D0);
+			udelay(100);
+
+			/* Eject the tray after starting
+			 * the power supply to tray type ODD
+			 */
+			if (sr_zpodd.cd->type == mechtype_tray)
+				sr_zpodd.flags |= SR_ZPODD_NEED_EJECT;
+		}
+	}
+	return;
+}
+
+/*
+ * find the zero power odd device in ACPI namespace
+ * and install the notification handler for the device
+ */
+static acpi_status __init sr_acpi_find_zpodd(acpi_handle handle,
+		u32 lvl, void *context, void **rv)
+{
+	acpi_status status;
+	char name[ACPI_PATH_SEGMENT_LENGTH];
+	struct acpi_buffer buffer = { sizeof(name), &name };
+	acpi_handle *phandle = (acpi_handle *)context;
+
+	/* FIXME: search the device by object name or _HID? */
+	status = acpi_get_name(handle, ACPI_SINGLE_NAME, &buffer);
+
+	if (ACPI_SUCCESS(status) && !strncmp("ODDZ", name, sizeof(name) - 1)) {
+		*phandle = handle;
+
+		/* returning non-zero causes the search to stop
+		 * and returns this value to the caller of
+		 * acpi_walk_namespace.
+		 */
+		return 1;
+
+	} else
+		return 0;
+}
+#endif
+
+void sr_acpi_init(Scsi_CD *cd)
+{
+#ifdef CONFIG_BLK_DEV_SR_ZERO_POWER
+	acpi_status status;
+
+	/* Walk the namespace only once*/
+	if (!(sr_zpodd.flags & SR_ZPODD_REGISTERED)) {
+		if (acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
+				ACPI_UINT32_MAX, sr_acpi_find_zpodd, NULL,
+				&sr_zpodd.handle, NULL) != 1) {
+			printk(KERN_WARNING
+				 "The SCSI CD doesn't support zero power\n");
+			goto init_return;
+		}
+
+		status = acpi_install_notify_handler(sr_zpodd.handle,
+				ACPI_DEVICE_NOTIFY, sr_acpi_handle_events,
+				NULL);
+		if (ACPI_FAILURE(status)) {
+			printk(KERN_WARNING
+				 "failed to register notification handler\n");
+			goto init_return;
+		} else
+			sr_zpodd.flags |= SR_ZPODD_REGISTERED;
+
+		sr_zpodd.wq = create_singlethread_workqueue("sr_zpodd.wq");
+		if (!sr_zpodd.wq) {
+			acpi_remove_notify_handler(
+				sr_zpodd.handle,
+				ACPI_DEVICE_NOTIFY,
+				sr_acpi_handle_events);
+			goto init_return;
+		}
+	}
+
+	INIT_WORK(&sr_zpodd.set_power, sr_acpi_remove_power);
+
+	spin_lock_init(&sr_zpodd.lock);
+	init_timer(&cd->zero_power_timer);
+	cd->zero_power_timer.data = (unsigned long) cd;
+	cd->zero_power_timer.function = sr_acpi_queue_work;
+	cd->zero_power_timer.expires = jiffies + SR_CHECK_STATE_TIMEOUT;
+	add_timer(&cd->zero_power_timer);
+
+	cd->no_media_retry = 1;
+	sr_zpodd.cd = cd;
+
+	if (sr_zpodd.flags & SR_ZPODD_NEED_EJECT) {
+		sr_zpodd.flags &= ~SR_ZPODD_NEED_EJECT;
+		sr_tray_move(&cd->cdi, 1);
+	}
+
+init_return:
+#endif
+	return;
+}
+
+void sr_acpi_unregister(void)
+{
+#ifdef CONFIG_BLK_DEV_SR_ZERO_POWER
+	if (sr_zpodd.flags & SR_ZPODD_REGISTERED) {
+		destroy_workqueue(sr_zpodd.wq);
+		acpi_remove_notify_handler(sr_zpodd.handle,
+					ACPI_DEVICE_NOTIFY,
+					sr_acpi_handle_events);
+	}
+#endif
+}
+
+int sr_acpi_remove(struct device *dev)
+{
+#ifdef CONFIG_BLK_DEV_SR_ZERO_POWER
+	struct scsi_cd *cd = dev_get_drvdata(dev);
+	if (sr_zpodd.flags & SR_ZPODD_REGISTERED)
+		del_timer_sync(&cd->zero_power_timer);
+#endif
+	return 0;
+}
-- 
1.5.6.3
