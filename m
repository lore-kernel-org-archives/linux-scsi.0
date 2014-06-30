From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] usb-storage/SCSI: Add broken_fua blacklist flag
Date: Mon, 30 Jun 2014 11:04:21 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1406301100300.1550-100000@iolanthe.rowland.org>
References: <20140627215235.4be63476@wiggum>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:40748 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752811AbaF3PEW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jun 2014 11:04:22 -0400
In-Reply-To: <20140627215235.4be63476@wiggum>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "Bryn M. Reeves" <bmr@redhat.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>

Some buggy JMicron USB-ATA bridges don't know how to translate the FUA
bit in READs or WRITEs.  This patch adds an entry in unusual_devs.h
and a blacklist flag to tell the sd driver not to use FUA.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: Michael B=C3=BCsch <m@bues.ch>
Tested-by: Michael B=C3=BCsch <m@bues.ch>
Acked-by: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
CC: <stable@vger.kernel.org>

---


[as1751]


 drivers/scsi/sd.c                  |    5 ++++-
 drivers/usb/storage/scsiglue.c     |    4 ++++
 drivers/usb/storage/unusual_devs.h |    7 +++++++
 include/linux/usb_usual.h          |    4 +++-
 include/scsi/scsi_device.h         |    1 +
 5 files changed, 19 insertions(+), 2 deletions(-)

Index: usb-3.16/include/linux/usb_usual.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- usb-3.16.orig/include/linux/usb_usual.h
+++ usb-3.16/include/linux/usb_usual.h
@@ -70,7 +70,9 @@
 	US_FLAG(NEEDS_CAP16,	0x00400000)			\
 		/* cannot handle READ_CAPACITY_10 */		\
 	US_FLAG(IGNORE_UAS,	0x00800000)			\
-		/* Device advertises UAS but it is broken */
+		/* Device advertises UAS but it is broken */	\
+	US_FLAG(BROKEN_FUA,	0x01000000)			\
+		/* Cannot handle FUA in WRITE or READ CDBs */	\
=20
 #define US_FLAG(name, value)	US_FL_##name =3D value ,
 enum { US_DO_ALL_FLAGS };
Index: usb-3.16/include/scsi/scsi_device.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- usb-3.16.orig/include/scsi/scsi_device.h
+++ usb-3.16/include/scsi/scsi_device.h
@@ -173,6 +173,7 @@ struct scsi_device {
 	unsigned is_visible:1;	/* is the device visible in sysfs */
 	unsigned wce_default_on:1;	/* Cache is ON by default */
 	unsigned no_dif:1;	/* T10 PI (DIF) should be disabled */
+	unsigned broken_fua:1;		/* Don't set FUA bit */
=20
 	atomic_t disk_events_disable_depth; /* disable depth for disk events =
*/
=20
Index: usb-3.16/drivers/usb/storage/unusual_devs.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- usb-3.16.orig/drivers/usb/storage/unusual_devs.h
+++ usb-3.16/drivers/usb/storage/unusual_devs.h
@@ -1936,6 +1936,13 @@ UNUSUAL_DEV(  0x14cd, 0x6600, 0x0201, 0x
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_IGNORE_RESIDUE ),
=20
+/* Reported by Michael B=C3=BCsch <m@bues.ch> */
+UNUSUAL_DEV(  0x152d, 0x0567, 0x0114, 0x0114,
+		"JMicron",
+		"USB to ATA/ATAPI Bridge",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_BROKEN_FUA ),
+
 /* Reported by Alexandre Oliva <oliva@lsd.ic.unicamp.br>
  * JMicron responds to USN and several other SCSI ioctls with a
  * residue that causes subsequent I/O requests to fail.  */
Index: usb-3.16/drivers/usb/storage/scsiglue.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- usb-3.16.orig/drivers/usb/storage/scsiglue.c
+++ usb-3.16/drivers/usb/storage/scsiglue.c
@@ -256,6 +256,10 @@ static int slave_configure(struct scsi_d
 		if (us->fflags & US_FL_WRITE_CACHE)
 			sdev->wce_default_on =3D 1;
=20
+		/* A few buggy USB-ATA bridges don't understand FUA */
+		if (us->fflags & US_FL_BROKEN_FUA)
+			sdev->broken_fua =3D 1;
+
 	} else {
=20
 		/* Non-disk-type devices don't need to blacklist any pages
Index: usb-3.16/drivers/scsi/sd.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- usb-3.16.orig/drivers/scsi/sd.c
+++ usb-3.16/drivers/scsi/sd.c
@@ -2441,7 +2441,10 @@ sd_read_cache_type(struct scsi_disk *sdk
 		}
=20
 		sdkp->DPOFUA =3D (data.device_specific & 0x10) !=3D 0;
-		if (sdkp->DPOFUA && !sdkp->device->use_10_for_rw) {
+		if (sdp->broken_fua) {
+			sd_first_printk(KERN_NOTICE, sdkp, "Disabling FUA\n");
+			sdkp->DPOFUA =3D 0;
+		} else if (sdkp->DPOFUA && !sdkp->device->use_10_for_rw) {
 			sd_first_printk(KERN_NOTICE, sdkp,
 				  "Uses READ/WRITE(6), disabling FUA\n");
 			sdkp->DPOFUA =3D 0;


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
