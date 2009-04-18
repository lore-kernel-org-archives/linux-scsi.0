From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
Subject: [PATCH 2/2] sd: Stop disks on reboot for laptop which cuts power
Date: Sat, 18 Apr 2009 12:47:43 +0200
Message-ID: <20090418124743.408cb37c@neptune.home>
References: <20090418124415.1dc82273@neptune.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20090418124415.1dc82273@neptune.home>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>, Linux SCSI <linux-scsi@vger.kernel.org>
Cc: Linux IDE <linux-ide@vger.kernel.org>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Linux Kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

My laptop (Acer Travelmate 660) always cuts the power when rebooting
which causes the disk to emergency-park it's head.

Add a dmi check to stop disk as for shutdown on this laptop.

Signed-off-by: Bruno Pr=C3=A9mont <bonbons@linux-vserver.org>
---
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 3fcb64b..fdad8bc 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -50,6 +50,7 @@
 #include <linux/string_helpers.h>
 #include <linux/async.h>
 #include <asm/uaccess.h>
+#include <linux/dmi.h>
=20
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -2127,6 +2128,20 @@ static int sd_start_stop_device(struct scsi_disk=
 *sdkp, int start)
 	return res;
 }
=20
+static const struct dmi_system_id sd_coldreboot_table[] =3D {
+	{
+		/* Acer TravelMate 66x cuts power during reboot */
+		.ident   =3D "Acer TravelMate 660",
+		.matches =3D {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 660"),
+		},
+	},
+
+	{ }	/* terminate list */
+};
+
+
 /*
  * Send a SYNCHRONIZE CACHE instruction down to the device through
  * the normal SCSI command structure.  Wait for the command to
@@ -2144,7 +2159,9 @@ static void sd_shutdown(struct device *dev)
 		sd_sync_cache(sdkp);
 	}
=20
-	if (system_state !=3D SYSTEM_RESTART && sdkp->device->manage_start_st=
op) {
+	if (sdkp->device->manage_start_stop &&
+	    (system_state !=3D SYSTEM_RESTART ||
+	    dmi_check_system(sd_coldreboot_table))) {
 		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
 		sd_start_stop_device(sdkp, 0);
 	}
