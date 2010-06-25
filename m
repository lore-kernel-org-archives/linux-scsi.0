From: su henry <henry.su.ati@gmail.com>
Subject: [PATCH RFC] support sata odd zero power
Date: Fri, 25 Jun 2010 18:15:40 +0800
Message-ID: <AANLkTimajvNh3frP9LcytXUhFAGk1gB52wa0LlGe0ZS0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:49260 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977Ab0FYKPl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Jun 2010 06:15:41 -0400
Received: by vws9 with SMTP id 9so3701011vws.19
        for <linux-scsi@vger.kernel.org>; Fri, 25 Jun 2010 03:15:41 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-scsi@vger.kernel.org, htejun <htejun@gmail.com>

>From b221e73b802ccfe5338b575dc0ff3b687acdd6fa Mon Sep 17 00:00:00 2001
From: henry su <henry.su.ati@gmail.com>
Date: Fri, 25 Jun 2010 00:08:42 +0800
Subject: [PATCH RFC] support sata odd zero power

In order to extend the battery life of Mobile PC system, the host should remove
the power supply to the Optical Disc Drive (logical unit) when it detects the
logical unit with no media and tray closed, and the host starts the power
supply to the logical unit when it detects user action to the logical unit that
the power supply is omitted.

The patch evaluates the _PS3 method to remove the power supply to the ODD if
the host detects MEDIUM NOT PRESENT - TRAY CLOSED is reported by REQUEST SENSE
command for a Drawer, Tray or Pop-up type drive, or MEDIUM NOT PRESENT -
TRAY CLOSED for a slot/caddy type drive; on the other hand, the patch evaluates
the _PS0 method to restart the power supply to the ODD when the user
presses the
button on a tray type drive or inserts a CD to a slot/caddy type drive.

PLDS DS-8A5S, pansonic UJ892 and UJ897 are the ODD samples used to test
the patch on AMD SB800 platforms.

Signed-off-by: Henry Su <henry.su.ati@gmail.com>
---
 drivers/scsi/sr.c |  147 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 146 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 0a90abc..9b7389f 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -55,6 +55,7 @@
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_ioctl.h>	/* For the door lock/unlock commands */
+#include <acpi/acpi_bus.h>

 #include "scsi_logging.h"
 #include "sr.h"
@@ -89,6 +90,19 @@ static struct scsi_driver sr_template = {
 	.done			= sr_done,
 };

+static struct sr_zpodd_device_info {
+	acpi_handle handle;
+	mechtype_t mechtype;
+
+#define SR_NO_MEDIA_TIMEOUT	(120*HZ)
+#define SR_IS_ZPODD		0x01
+#define SR_ZPODD_NO_DISK	0x02
+#define SR_ZPODD_NEED_EJECT	0x04
+
+	u32 flags;
+	unsigned long last_jiffies;
+} sr_zpodd_device;
+
 static unsigned long sr_index_bits[SR_DISKS / BITS_PER_LONG];
 static DEFINE_SPINLOCK(sr_index_lock);

@@ -205,6 +219,7 @@ static int sr_media_change(struct
cdrom_device_info *cdi, int slot)
 	struct scsi_cd *cd = cdi->handle;
 	int retval;
 	struct scsi_sense_hdr *sshdr;
+	int isvalid;

 	if (CDSL_CURRENT != slot) {
 		/* no changer support */
@@ -213,7 +228,59 @@ static int sr_media_change(struct
cdrom_device_info *cdi, int slot)

 	sshdr =  kzalloc(sizeof(*sshdr), GFP_KERNEL);
 	retval = sr_test_unit_ready(cd->device, sshdr);
-	if (retval || (scsi_sense_valid(sshdr) &&
+	isvalid = scsi_sense_valid(sshdr);
+
+	if (!(sr_zpodd_device.flags & SR_IS_ZPODD))
+		goto out_not_zpodd_device;
+
+	/* Remove the power supply to the drive with no media and
+	 * tray closed for tray/drawer/pop-up type drive,
+	 * or no media and tray open for caddy/slot type drive.
+	 */
+	switch (sr_zpodd_device.mechtype) {
+	case mechtype_caddy:
+		/* 3a/02(asc/ascq) means MEDIUM NOT PRESENT - TRAY OPEN */
+		if (isvalid && (sshdr->asc  == 0x3a &&
+				sshdr->ascq == 0x02)) {
+			if (!(sr_zpodd_device.flags & SR_ZPODD_NO_DISK)) {
+				sr_zpodd_device.flags |= SR_ZPODD_NO_DISK;
+				sr_zpodd_device.last_jiffies = jiffies;
+			} else if (time_after(jiffies,
+					sr_zpodd_device.last_jiffies +
+					SR_NO_MEDIA_TIMEOUT)) {
+				acpi_bus_set_power(sr_zpodd_device.handle,
+							ACPI_STATE_D3);
+			}
+		} else
+			sr_zpodd_device.flags &= ~SR_ZPODD_NO_DISK;
+		break;
+	default:
+		/*tray/drawer/pop-up type*/
+		/* 3a/01(asc/ascq) means MEDIUM NOT PRESENT - TRAY CLOSED */
+		if (isvalid && (sshdr->asc  == 0x3a &&
+				sshdr->ascq == 0x01)) {
+
+			/* Eject the tray for a tray type drive*/
+			if (sr_zpodd_device.flags & SR_ZPODD_NEED_EJECT) {
+				sr_tray_move(cdi, 1);
+				sr_zpodd_device.flags &= ~SR_ZPODD_NEED_EJECT;
+			} else if (!(sr_zpodd_device.flags &
+					SR_ZPODD_NO_DISK)) {
+				sr_zpodd_device.flags |= SR_ZPODD_NO_DISK;
+				sr_zpodd_device.last_jiffies = jiffies;
+			} else if (time_after(jiffies,
+					sr_zpodd_device.last_jiffies
+					+ SR_NO_MEDIA_TIMEOUT)) {
+				acpi_bus_set_power(sr_zpodd_device.handle,
+							ACPI_STATE_D3);
+			}
+		} else
+			sr_zpodd_device.flags &= ~SR_ZPODD_NO_DISK;
+		break;
+	}
+
+out_not_zpodd_device:
+	if (retval || (isvalid &&
 		       /* 0x3a is medium not present */
 		       sshdr->asc == 0x3a)) {
 		/* Media not present or unable to test, unit probably not
@@ -786,6 +853,7 @@ static void get_capabilities(struct scsi_cd *cd)
 	}

 	n = data.header_length + data.block_descriptor_length;
+	sr_zpodd_device.mechtype = buffer[n + 6] >> 5;
 	cd->cdi.speed = ((buffer[n + 8] << 8) + buffer[n + 9]) / 176;
 	cd->readcd_known = 1;
 	cd->readcd_cdda = buffer[n + 5] & 0x01;
@@ -898,6 +966,73 @@ static int sr_remove(struct device *dev)
 	return 0;
 }

+/*
+ * Handle ACPI event notification when pressing the button on a
+ * tray type drive or inserting a CD to a caddy/slot type drive
+ */
+static void sr_handle_events(acpi_handle handle, u32 event, void *context)
+{
+	unsigned int state;
+
+	switch (event) {
+	/* FIXME: handle both wake and 0x80 notifications? */
+	case 0x02:
+	case 0x80:
+		acpi_bus_get_power(sr_zpodd_device.handle, &state);
+		if (state == ACPI_STATE_D3) {
+			sr_zpodd_device.flags &= ~SR_ZPODD_NO_DISK;
+
+			acpi_bus_set_power(sr_zpodd_device.handle,
+						ACPI_STATE_D0);
+			udelay(100);
+
+			/* Need to eject the tray after starting
+			 * the power supply to tray type ODD
+			 */
+			if (sr_zpodd_device.mechtype == mechtype_tray)
+				sr_zpodd_device.flags |= SR_ZPODD_NEED_EJECT;
+		}
+	}
+	return;
+}
+
+/*
+ * find the zero power odd device in ACPI namespace
+ * and install the notification handler for the device
+ */
+static acpi_status __init sr_find_zpodd_device(acpi_handle handle,
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
+		status = acpi_install_notify_handler(handle,
+				ACPI_DEVICE_NOTIFY, sr_handle_events,
+				NULL);
+		if (ACPI_FAILURE(status))
+			printk("sr: failed to register notification handler\n");
+		else
+			sr_zpodd_device.flags |= SR_IS_ZPODD;
+
+		*phandle = handle;
+
+		/* returning non-zero causes the search to stop
+		 * and returns this value to the caller of
+		 * acpi_walk_namespace.
+		 */
+		
+		return 1;
+
+	} else
+		return 0;
+}
+
 static int __init init_sr(void)
 {
 	int rc;
@@ -909,11 +1044,21 @@ static int __init init_sr(void)
 	if (rc)
 		unregister_blkdev(SCSI_CDROM_MAJOR, "sr");

+	acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
+				ACPI_UINT32_MAX, sr_find_zpodd_device, NULL,
+				&sr_zpodd_device.handle, NULL);
+
 	return rc;
 }

 static void __exit exit_sr(void)
 {
+	if (sr_zpodd_device.flags & SR_IS_ZPODD)
+		acpi_remove_notify_handler(
+			   sr_zpodd_device.handle,
+			   ACPI_DEVICE_NOTIFY,
+			   sr_handle_events);
+
 	scsi_unregister_driver(&sr_template.gendrv);
 	unregister_blkdev(SCSI_CDROM_MAJOR, "sr");
 }
-- 
1.5.6.3
