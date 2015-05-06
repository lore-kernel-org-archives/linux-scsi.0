From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH] usb: storage: fix module reference for scsi host
Date: Wed,  6 May 2015 18:24:21 +0900
Message-ID: <1430904261-5049-1-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:33223 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbbEFJYi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 May 2015 05:24:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Dolev Raviv <draviv@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <JBottomley@parallels.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alan Stern <stern@rowland.harvard.edu>, "David S. Miller" <davem@davemloft.net>, Hannes Reinecke <hare@suse.de>, linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net

While accessing a unusual usb storage (ums-alauda, ums-cypress, ...),
the module reference count is not incremented.  Because these drivers
allocate scsi hosts with usb_stor_host_template defined in usb-storage
module.  So these drivers always can be unloaded.

This fixes it by preparing scsi host template which is initialized
at module_init() for each ums-* driver.  In order to minimize the
difference in ums-* drivers, introduce module_usb_stor_driver() helper
macro which is same as module_usb_driver() except that it also
initializes scsi host template.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: Dolev Raviv <draviv@codeaurora.org>
Cc: Sujit Reddy Thumma <sthumma@codeaurora.org>
Cc: Subhash Jadavani <subhashj@codeaurora.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Hannes Reinecke <hare@suse.de>
Cc: linux-usb@vger.kernel.org
Cc: usb-storage@lists.one-eyed-alien.net
Cc: linux-scsi@vger.kernel.org
---
 drivers/usb/storage/alauda.c        | 12 +++++++++---
 drivers/usb/storage/cypress_atacb.c | 10 +++++++---
 drivers/usb/storage/datafab.c       | 12 +++++++++---
 drivers/usb/storage/ene_ub6250.c    | 11 ++++++++---
 drivers/usb/storage/freecom.c       | 12 +++++++++---
 drivers/usb/storage/isd200.c        | 11 ++++++++---
 drivers/usb/storage/jumpshot.c      | 11 ++++++++---
 drivers/usb/storage/karma.c         | 12 +++++++++---
 drivers/usb/storage/onetouch.c      | 12 +++++++++---
 drivers/usb/storage/realtek_cr.c    | 12 +++++++++---
 drivers/usb/storage/scsiglue.c      | 12 +++++++++++-
 drivers/usb/storage/scsiglue.h      |  3 ++-
 drivers/usb/storage/sddr09.c        | 12 +++++++++---
 drivers/usb/storage/sddr55.c        | 11 ++++++++---
 drivers/usb/storage/shuttle_usbat.c | 12 +++++++++---
 drivers/usb/storage/usb.c           | 16 +++++++++++-----
 drivers/usb/storage/usb.h           | 16 +++++++++++++++-
 17 files changed, 150 insertions(+), 47 deletions(-)

diff --git a/drivers/usb/storage/alauda.c b/drivers/usb/storage/alauda.=
c
index 4b55ab6..171fa7d 100644
--- a/drivers/usb/storage/alauda.c
+++ b/drivers/usb/storage/alauda.c
@@ -42,6 +42,9 @@
 #include "transport.h"
 #include "protocol.h"
 #include "debug.h"
+#include "scsiglue.h"
+
+#define DRV_NAME "ums-alauda"
=20
 MODULE_DESCRIPTION("Driver for Alauda-based card readers");
 MODULE_AUTHOR("Daniel Drake <dsd@gentoo.org>");
@@ -1232,6 +1235,8 @@ static int alauda_transport(struct scsi_cmnd *srb=
, struct us_data *us)
 	return USB_STOR_TRANSPORT_FAILED;
 }
=20
+static struct scsi_host_template alauda_host_template;
+
 static int alauda_probe(struct usb_interface *intf,
 			 const struct usb_device_id *id)
 {
@@ -1239,7 +1244,8 @@ static int alauda_probe(struct usb_interface *int=
f,
 	int result;
=20
 	result =3D usb_stor_probe1(&us, intf, id,
-			(id - alauda_usb_ids) + alauda_unusual_dev_list);
+			(id - alauda_usb_ids) + alauda_unusual_dev_list,
+			&alauda_host_template);
 	if (result)
 		return result;
=20
@@ -1253,7 +1259,7 @@ static int alauda_probe(struct usb_interface *int=
f,
 }
=20
 static struct usb_driver alauda_driver =3D {
-	.name =3D		"ums-alauda",
+	.name =3D		DRV_NAME,
 	.probe =3D	alauda_probe,
 	.disconnect =3D	usb_stor_disconnect,
 	.suspend =3D	usb_stor_suspend,
@@ -1266,4 +1272,4 @@ static struct usb_driver alauda_driver =3D {
 	.no_dynamic_id =3D 1,
 };
=20
-module_usb_driver(alauda_driver);
+module_usb_stor_driver(alauda_driver, alauda_host_template, DRV_NAME);
diff --git a/drivers/usb/storage/cypress_atacb.c b/drivers/usb/storage/=
cypress_atacb.c
index b3466d1..c80d3de 100644
--- a/drivers/usb/storage/cypress_atacb.c
+++ b/drivers/usb/storage/cypress_atacb.c
@@ -30,6 +30,8 @@
 #include "scsiglue.h"
 #include "debug.h"
=20
+#define DRV_NAME "ums-cypress"
+
 MODULE_DESCRIPTION("SAT support for Cypress USB/ATA bridges with ATACB=
");
 MODULE_AUTHOR("Matthieu Castet <castet.matthieu@free.fr>");
 MODULE_LICENSE("GPL");
@@ -241,6 +243,7 @@ end:
 		srb->cmd_len =3D 12;
 }
=20
+static struct scsi_host_template cypress_host_template;
=20
 static int cypress_probe(struct usb_interface *intf,
 			 const struct usb_device_id *id)
@@ -250,7 +253,8 @@ static int cypress_probe(struct usb_interface *intf=
,
 	struct usb_device *device;
=20
 	result =3D usb_stor_probe1(&us, intf, id,
-			(id - cypress_usb_ids) + cypress_unusual_dev_list);
+			(id - cypress_usb_ids) + cypress_unusual_dev_list,
+			&cypress_host_template);
 	if (result)
 		return result;
=20
@@ -273,7 +277,7 @@ static int cypress_probe(struct usb_interface *intf=
,
 }
=20
 static struct usb_driver cypress_driver =3D {
-	.name =3D		"ums-cypress",
+	.name =3D		DRV_NAME,
 	.probe =3D	cypress_probe,
 	.disconnect =3D	usb_stor_disconnect,
 	.suspend =3D	usb_stor_suspend,
@@ -286,4 +290,4 @@ static struct usb_driver cypress_driver =3D {
 	.no_dynamic_id =3D 1,
 };
=20
-module_usb_driver(cypress_driver);
+module_usb_stor_driver(cypress_driver, cypress_host_template, DRV_NAME=
);
diff --git a/drivers/usb/storage/datafab.c b/drivers/usb/storage/datafa=
b.c
index 7b17c21..aa4f519 100644
--- a/drivers/usb/storage/datafab.c
+++ b/drivers/usb/storage/datafab.c
@@ -59,6 +59,9 @@
 #include "transport.h"
 #include "protocol.h"
 #include "debug.h"
+#include "scsiglue.h"
+
+#define DRV_NAME "ums-datafab"
=20
 MODULE_DESCRIPTION("Driver for Datafab USB Compact Flash reader");
 MODULE_AUTHOR("Jimmie Mayfield <mayfield+datafab@sackheads.org>");
@@ -721,6 +724,8 @@ static int datafab_transport(struct scsi_cmnd *srb,=
 struct us_data *us)
 	return USB_STOR_TRANSPORT_FAILED;
 }
=20
+static struct scsi_host_template datafab_host_template;
+
 static int datafab_probe(struct usb_interface *intf,
 			 const struct usb_device_id *id)
 {
@@ -728,7 +733,8 @@ static int datafab_probe(struct usb_interface *intf=
,
 	int result;
=20
 	result =3D usb_stor_probe1(&us, intf, id,
-			(id - datafab_usb_ids) + datafab_unusual_dev_list);
+			(id - datafab_usb_ids) + datafab_unusual_dev_list,
+			&datafab_host_template);
 	if (result)
 		return result;
=20
@@ -742,7 +748,7 @@ static int datafab_probe(struct usb_interface *intf=
,
 }
=20
 static struct usb_driver datafab_driver =3D {
-	.name =3D		"ums-datafab",
+	.name =3D		DRV_NAME,
 	.probe =3D	datafab_probe,
 	.disconnect =3D	usb_stor_disconnect,
 	.suspend =3D	usb_stor_suspend,
@@ -755,4 +761,4 @@ static struct usb_driver datafab_driver =3D {
 	.no_dynamic_id =3D 1,
 };
=20
-module_usb_driver(datafab_driver);
+module_usb_stor_driver(datafab_driver, datafab_host_template, DRV_NAME=
);
diff --git a/drivers/usb/storage/ene_ub6250.c b/drivers/usb/storage/ene=
_ub6250.c
index 56f782b..f3cf4ce 100644
--- a/drivers/usb/storage/ene_ub6250.c
+++ b/drivers/usb/storage/ene_ub6250.c
@@ -28,6 +28,7 @@
 #include "transport.h"
 #include "protocol.h"
 #include "debug.h"
+#include "scsiglue.h"
=20
 #define SD_INIT1_FIRMWARE "ene-ub6250/sd_init1.bin"
 #define SD_INIT2_FIRMWARE "ene-ub6250/sd_init2.bin"
@@ -36,6 +37,8 @@
 #define MSP_RW_FIRMWARE "ene-ub6250/msp_rdwr.bin"
 #define MS_RW_FIRMWARE "ene-ub6250/ms_rdwr.bin"
=20
+#define DRV_NAME "ums_eneub6250"
+
 MODULE_DESCRIPTION("Driver for ENE UB6250 reader");
 MODULE_LICENSE("GPL");
 MODULE_FIRMWARE(SD_INIT1_FIRMWARE);
@@ -2307,6 +2310,7 @@ static int ene_transport(struct scsi_cmnd *srb, s=
truct us_data *us)
 	return 0;
 }
=20
+static struct scsi_host_template ene_ub6250_host_template;
=20
 static int ene_ub6250_probe(struct usb_interface *intf,
 			 const struct usb_device_id *id)
@@ -2316,7 +2320,8 @@ static int ene_ub6250_probe(struct usb_interface =
*intf,
 	struct us_data *us;
=20
 	result =3D usb_stor_probe1(&us, intf, id,
-		   (id - ene_ub6250_usb_ids) + ene_ub6250_unusual_dev_list);
+		   (id - ene_ub6250_usb_ids) + ene_ub6250_unusual_dev_list,
+		   &ene_ub6250_host_template);
 	if (result)
 		return result;
=20
@@ -2404,7 +2409,7 @@ static int ene_ub6250_reset_resume(struct usb_int=
erface *iface)
 #endif
=20
 static struct usb_driver ene_ub6250_driver =3D {
-	.name =3D		"ums_eneub6250",
+	.name =3D		DRV_NAME,
 	.probe =3D	ene_ub6250_probe,
 	.disconnect =3D	usb_stor_disconnect,
 	.suspend =3D	usb_stor_suspend,
@@ -2417,4 +2422,4 @@ static struct usb_driver ene_ub6250_driver =3D {
 	.no_dynamic_id =3D 1,
 };
=20
-module_usb_driver(ene_ub6250_driver);
+module_usb_stor_driver(ene_ub6250_driver, ene_ub6250_host_template, DR=
V_NAME);
diff --git a/drivers/usb/storage/freecom.c b/drivers/usb/storage/freeco=
m.c
index ef16068..3f2b089 100644
--- a/drivers/usb/storage/freecom.c
+++ b/drivers/usb/storage/freecom.c
@@ -34,6 +34,9 @@
 #include "transport.h"
 #include "protocol.h"
 #include "debug.h"
+#include "scsiglue.h"
+
+#define DRV_NAME "ums-freecom"
=20
 MODULE_DESCRIPTION("Driver for Freecom USB/IDE adaptor");
 MODULE_AUTHOR("David Brown <usb-storage@davidb.org>");
@@ -523,6 +526,8 @@ static void pdump(struct us_data *us, void *ibuffer=
, int length)
 }
 #endif
=20
+static struct scsi_host_template freecom_host_template;
+
 static int freecom_probe(struct usb_interface *intf,
 			 const struct usb_device_id *id)
 {
@@ -530,7 +535,8 @@ static int freecom_probe(struct usb_interface *intf=
,
 	int result;
=20
 	result =3D usb_stor_probe1(&us, intf, id,
-			(id - freecom_usb_ids) + freecom_unusual_dev_list);
+			(id - freecom_usb_ids) + freecom_unusual_dev_list,
+			&freecom_host_template);
 	if (result)
 		return result;
=20
@@ -544,7 +550,7 @@ static int freecom_probe(struct usb_interface *intf=
,
 }
=20
 static struct usb_driver freecom_driver =3D {
-	.name =3D		"ums-freecom",
+	.name =3D		DRV_NAME,
 	.probe =3D	freecom_probe,
 	.disconnect =3D	usb_stor_disconnect,
 	.suspend =3D	usb_stor_suspend,
@@ -557,4 +563,4 @@ static struct usb_driver freecom_driver =3D {
 	.no_dynamic_id =3D 1,
 };
=20
-module_usb_driver(freecom_driver);
+module_usb_stor_driver(freecom_driver, freecom_host_template, DRV_NAME=
);
diff --git a/drivers/usb/storage/isd200.c b/drivers/usb/storage/isd200.=
c
index 0761786..1bac215 100644
--- a/drivers/usb/storage/isd200.c
+++ b/drivers/usb/storage/isd200.c
@@ -60,6 +60,8 @@
 #include "debug.h"
 #include "scsiglue.h"
=20
+#define DRV_NAME "ums-isd200"
+
 MODULE_DESCRIPTION("Driver for In-System Design, Inc. ISD200 ASIC");
 MODULE_AUTHOR("Bj=C3=B6rn Stenberg <bjorn@haxx.se>");
 MODULE_LICENSE("GPL");
@@ -1537,6 +1539,8 @@ static void isd200_ata_command(struct scsi_cmnd *=
srb, struct us_data *us)
 	isd200_srb_set_bufflen(srb, orig_bufflen);
 }
=20
+static struct scsi_host_template isd200_host_template;
+
 static int isd200_probe(struct usb_interface *intf,
 			 const struct usb_device_id *id)
 {
@@ -1544,7 +1548,8 @@ static int isd200_probe(struct usb_interface *int=
f,
 	int result;
=20
 	result =3D usb_stor_probe1(&us, intf, id,
-			(id - isd200_usb_ids) + isd200_unusual_dev_list);
+			(id - isd200_usb_ids) + isd200_unusual_dev_list,
+			&isd200_host_template);
 	if (result)
 		return result;
=20
@@ -1556,7 +1561,7 @@ static int isd200_probe(struct usb_interface *int=
f,
 }
=20
 static struct usb_driver isd200_driver =3D {
-	.name =3D		"ums-isd200",
+	.name =3D		DRV_NAME,
 	.probe =3D	isd200_probe,
 	.disconnect =3D	usb_stor_disconnect,
 	.suspend =3D	usb_stor_suspend,
@@ -1569,4 +1574,4 @@ static struct usb_driver isd200_driver =3D {
 	.no_dynamic_id =3D 1,
 };
=20
-module_usb_driver(isd200_driver);
+module_usb_stor_driver(isd200_driver, isd200_host_template, DRV_NAME);
diff --git a/drivers/usb/storage/jumpshot.c b/drivers/usb/storage/jumps=
hot.c
index 563078b..ee613e2 100644
--- a/drivers/usb/storage/jumpshot.c
+++ b/drivers/usb/storage/jumpshot.c
@@ -56,7 +56,9 @@
 #include "transport.h"
 #include "protocol.h"
 #include "debug.h"
+#include "scsiglue.h"
=20
+#define DRV_NAME "ums-jumpshot"
=20
 MODULE_DESCRIPTION("Driver for Lexar \"Jumpshot\" Compact Flash reader=
");
 MODULE_AUTHOR("Jimmie Mayfield <mayfield+usb@sackheads.org>");
@@ -647,6 +649,8 @@ static int jumpshot_transport(struct scsi_cmnd *srb=
, struct us_data *us)
 	return USB_STOR_TRANSPORT_FAILED;
 }
=20
+static struct scsi_host_template jumpshot_host_template;
+
 static int jumpshot_probe(struct usb_interface *intf,
 			 const struct usb_device_id *id)
 {
@@ -654,7 +658,8 @@ static int jumpshot_probe(struct usb_interface *int=
f,
 	int result;
=20
 	result =3D usb_stor_probe1(&us, intf, id,
-			(id - jumpshot_usb_ids) + jumpshot_unusual_dev_list);
+			(id - jumpshot_usb_ids) + jumpshot_unusual_dev_list,
+			&jumpshot_host_template);
 	if (result)
 		return result;
=20
@@ -668,7 +673,7 @@ static int jumpshot_probe(struct usb_interface *int=
f,
 }
=20
 static struct usb_driver jumpshot_driver =3D {
-	.name =3D		"ums-jumpshot",
+	.name =3D		DRV_NAME,
 	.probe =3D	jumpshot_probe,
 	.disconnect =3D	usb_stor_disconnect,
 	.suspend =3D	usb_stor_suspend,
@@ -681,4 +686,4 @@ static struct usb_driver jumpshot_driver =3D {
 	.no_dynamic_id =3D 1,
 };
=20
-module_usb_driver(jumpshot_driver);
+module_usb_stor_driver(jumpshot_driver, jumpshot_host_template, DRV_NA=
ME);
diff --git a/drivers/usb/storage/karma.c b/drivers/usb/storage/karma.c
index 94d16ee..ae201e6 100644
--- a/drivers/usb/storage/karma.c
+++ b/drivers/usb/storage/karma.c
@@ -28,6 +28,9 @@
 #include "usb.h"
 #include "transport.h"
 #include "debug.h"
+#include "scsiglue.h"
+
+#define DRV_NAME "ums-karma"
=20
 MODULE_DESCRIPTION("Driver for Rio Karma");
 MODULE_AUTHOR("Bob Copeland <me@bobcopeland.com>, Keith Bennett <keith=
@mcs.st-and.ac.uk>");
@@ -200,6 +203,8 @@ out:
 	return ret;
 }
=20
+static struct scsi_host_template karma_host_template;
+
 static int karma_probe(struct usb_interface *intf,
 			 const struct usb_device_id *id)
 {
@@ -207,7 +212,8 @@ static int karma_probe(struct usb_interface *intf,
 	int result;
=20
 	result =3D usb_stor_probe1(&us, intf, id,
-			(id - karma_usb_ids) + karma_unusual_dev_list);
+			(id - karma_usb_ids) + karma_unusual_dev_list,
+			&karma_host_template);
 	if (result)
 		return result;
=20
@@ -220,7 +226,7 @@ static int karma_probe(struct usb_interface *intf,
 }
=20
 static struct usb_driver karma_driver =3D {
-	.name =3D		"ums-karma",
+	.name =3D		DRV_NAME,
 	.probe =3D	karma_probe,
 	.disconnect =3D	usb_stor_disconnect,
 	.suspend =3D	usb_stor_suspend,
@@ -233,4 +239,4 @@ static struct usb_driver karma_driver =3D {
 	.no_dynamic_id =3D 1,
 };
=20
-module_usb_driver(karma_driver);
+module_usb_stor_driver(karma_driver, karma_host_template, DRV_NAME);
diff --git a/drivers/usb/storage/onetouch.c b/drivers/usb/storage/oneto=
uch.c
index 74e2aa2..acc3d03 100644
--- a/drivers/usb/storage/onetouch.c
+++ b/drivers/usb/storage/onetouch.c
@@ -35,6 +35,9 @@
 #include <linux/usb/input.h>
 #include "usb.h"
 #include "debug.h"
+#include "scsiglue.h"
+
+#define DRV_NAME "ums-onetouch"
=20
 MODULE_DESCRIPTION("Maxtor USB OneTouch hard drive button driver");
 MODULE_AUTHOR("Nick Sillik <n.sillik@temple.edu>");
@@ -283,6 +286,8 @@ static void onetouch_release_input(void *onetouch_)
 	}
 }
=20
+static struct scsi_host_template onetouch_host_template;
+
 static int onetouch_probe(struct usb_interface *intf,
 			 const struct usb_device_id *id)
 {
@@ -290,7 +295,8 @@ static int onetouch_probe(struct usb_interface *int=
f,
 	int result;
=20
 	result =3D usb_stor_probe1(&us, intf, id,
-			(id - onetouch_usb_ids) + onetouch_unusual_dev_list);
+			(id - onetouch_usb_ids) + onetouch_unusual_dev_list,
+			&onetouch_host_template);
 	if (result)
 		return result;
=20
@@ -301,7 +307,7 @@ static int onetouch_probe(struct usb_interface *int=
f,
 }
=20
 static struct usb_driver onetouch_driver =3D {
-	.name =3D		"ums-onetouch",
+	.name =3D		DRV_NAME,
 	.probe =3D	onetouch_probe,
 	.disconnect =3D	usb_stor_disconnect,
 	.suspend =3D	usb_stor_suspend,
@@ -314,4 +320,4 @@ static struct usb_driver onetouch_driver =3D {
 	.no_dynamic_id =3D 1,
 };
=20
-module_usb_driver(onetouch_driver);
+module_usb_stor_driver(onetouch_driver, onetouch_host_template, DRV_NA=
ME);
diff --git a/drivers/usb/storage/realtek_cr.c b/drivers/usb/storage/rea=
ltek_cr.c
index 27e4a58..2043356 100644
--- a/drivers/usb/storage/realtek_cr.c
+++ b/drivers/usb/storage/realtek_cr.c
@@ -39,6 +39,9 @@
 #include "transport.h"
 #include "protocol.h"
 #include "debug.h"
+#include "scsiglue.h"
+
+#define DRV_NAME "ums-realtek"
=20
 MODULE_DESCRIPTION("Driver for Realtek USB Card Reader");
 MODULE_AUTHOR("wwang <wei_wang@realsil.com.cn>");
@@ -1034,6 +1037,8 @@ INIT_FAIL:
 	return -EIO;
 }
=20
+static struct scsi_host_template realtek_cr_host_template;
+
 static int realtek_cr_probe(struct usb_interface *intf,
 			    const struct usb_device_id *id)
 {
@@ -1044,7 +1049,8 @@ static int realtek_cr_probe(struct usb_interface =
*intf,
=20
 	result =3D usb_stor_probe1(&us, intf, id,
 				 (id - realtek_cr_ids) +
-				 realtek_cr_unusual_dev_list);
+				 realtek_cr_unusual_dev_list,
+				 &realtek_cr_host_template);
 	if (result)
 		return result;
=20
@@ -1054,7 +1060,7 @@ static int realtek_cr_probe(struct usb_interface =
*intf,
 }
=20
 static struct usb_driver realtek_cr_driver =3D {
-	.name =3D "ums-realtek",
+	.name =3D DRV_NAME,
 	.probe =3D realtek_cr_probe,
 	.disconnect =3D usb_stor_disconnect,
 	/* .suspend =3D      usb_stor_suspend, */
@@ -1070,4 +1076,4 @@ static struct usb_driver realtek_cr_driver =3D {
 	.no_dynamic_id =3D 1,
 };
=20
-module_usb_driver(realtek_cr_driver);
+module_usb_stor_driver(realtek_cr_driver, realtek_cr_host_template, DR=
V_NAME);
diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsig=
lue.c
index 0e400f3..5c0bfd5 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -540,7 +540,7 @@ static struct device_attribute *sysfs_device_attr_l=
ist[] =3D {
  * this defines our host template, with which we'll allocate hosts
  */
=20
-struct scsi_host_template usb_stor_host_template =3D {
+static const struct scsi_host_template usb_stor_host_template =3D {
 	/* basic userland interface stuff */
 	.name =3D				"usb-storage",
 	.proc_name =3D			"usb-storage",
@@ -592,6 +592,16 @@ struct scsi_host_template usb_stor_host_template =3D=
 {
 	.module =3D			THIS_MODULE
 };
=20
+void usb_stor_host_template_init(struct scsi_host_template *sht,
+				 const char *name, struct module *owner)
+{
+	*sht =3D usb_stor_host_template;
+	sht->name =3D name;
+	sht->proc_name =3D name;
+	sht->module =3D owner;
+}
+EXPORT_SYMBOL_GPL(usb_stor_host_template_init);
+
 /* To Report "Illegal Request: Invalid Field in CDB */
 unsigned char usb_stor_sense_invalidCDB[18] =3D {
 	[0]	=3D 0x70,			    /* current error */
diff --git a/drivers/usb/storage/scsiglue.h b/drivers/usb/storage/scsig=
lue.h
index ffa1cca..5494d87 100644
--- a/drivers/usb/storage/scsiglue.h
+++ b/drivers/usb/storage/scsiglue.h
@@ -41,8 +41,9 @@
=20
 extern void usb_stor_report_device_reset(struct us_data *us);
 extern void usb_stor_report_bus_reset(struct us_data *us);
+extern void usb_stor_host_template_init(struct scsi_host_template *sht=
,
+					const char *name, struct module *owner);
=20
 extern unsigned char usb_stor_sense_invalidCDB[18];
-extern struct scsi_host_template usb_stor_host_template;
=20
 #endif
diff --git a/drivers/usb/storage/sddr09.c b/drivers/usb/storage/sddr09.=
c
index 3847053..b746036 100644
--- a/drivers/usb/storage/sddr09.c
+++ b/drivers/usb/storage/sddr09.c
@@ -52,6 +52,9 @@
 #include "transport.h"
 #include "protocol.h"
 #include "debug.h"
+#include "scsiglue.h"
+
+#define DRV_NAME "ums-sddr09"
=20
 MODULE_DESCRIPTION("Driver for SanDisk SDDR-09 SmartMedia reader");
 MODULE_AUTHOR("Andries Brouwer <aeb@cwi.nl>, Robert Baruch <autophile@=
starband.net>");
@@ -1738,6 +1741,8 @@ usb_stor_sddr09_init(struct us_data *us) {
 	return sddr09_common_init(us);
 }
=20
+static struct scsi_host_template sddr09_host_template;
+
 static int sddr09_probe(struct usb_interface *intf,
 			 const struct usb_device_id *id)
 {
@@ -1745,7 +1750,8 @@ static int sddr09_probe(struct usb_interface *int=
f,
 	int result;
=20
 	result =3D usb_stor_probe1(&us, intf, id,
-			(id - sddr09_usb_ids) + sddr09_unusual_dev_list);
+			(id - sddr09_usb_ids) + sddr09_unusual_dev_list,
+			&sddr09_host_template);
 	if (result)
 		return result;
=20
@@ -1766,7 +1772,7 @@ static int sddr09_probe(struct usb_interface *int=
f,
 }
=20
 static struct usb_driver sddr09_driver =3D {
-	.name =3D		"ums-sddr09",
+	.name =3D		DRV_NAME,
 	.probe =3D	sddr09_probe,
 	.disconnect =3D	usb_stor_disconnect,
 	.suspend =3D	usb_stor_suspend,
@@ -1779,4 +1785,4 @@ static struct usb_driver sddr09_driver =3D {
 	.no_dynamic_id =3D 1,
 };
=20
-module_usb_driver(sddr09_driver);
+module_usb_stor_driver(sddr09_driver, sddr09_host_template, DRV_NAME);
diff --git a/drivers/usb/storage/sddr55.c b/drivers/usb/storage/sddr55.=
c
index aacedef..e5e0a25 100644
--- a/drivers/usb/storage/sddr55.c
+++ b/drivers/usb/storage/sddr55.c
@@ -34,6 +34,9 @@
 #include "transport.h"
 #include "protocol.h"
 #include "debug.h"
+#include "scsiglue.h"
+
+#define DRV_NAME "ums-sddr55"
=20
 MODULE_DESCRIPTION("Driver for SanDisk SDDR-55 SmartMedia reader");
 MODULE_AUTHOR("Simon Munton");
@@ -968,6 +971,7 @@ static int sddr55_transport(struct scsi_cmnd *srb, =
struct us_data *us)
 	return USB_STOR_TRANSPORT_FAILED; // FIXME: sense buffer?
 }
=20
+static struct scsi_host_template sddr55_host_template;
=20
 static int sddr55_probe(struct usb_interface *intf,
 			 const struct usb_device_id *id)
@@ -976,7 +980,8 @@ static int sddr55_probe(struct usb_interface *intf,
 	int result;
=20
 	result =3D usb_stor_probe1(&us, intf, id,
-			(id - sddr55_usb_ids) + sddr55_unusual_dev_list);
+			(id - sddr55_usb_ids) + sddr55_unusual_dev_list,
+			&sddr55_host_template);
 	if (result)
 		return result;
=20
@@ -990,7 +995,7 @@ static int sddr55_probe(struct usb_interface *intf,
 }
=20
 static struct usb_driver sddr55_driver =3D {
-	.name =3D		"ums-sddr55",
+	.name =3D		DRV_NAME,
 	.probe =3D	sddr55_probe,
 	.disconnect =3D	usb_stor_disconnect,
 	.suspend =3D	usb_stor_suspend,
@@ -1003,4 +1008,4 @@ static struct usb_driver sddr55_driver =3D {
 	.no_dynamic_id =3D 1,
 };
=20
-module_usb_driver(sddr55_driver);
+module_usb_stor_driver(sddr55_driver, sddr55_host_template, DRV_NAME);
diff --git a/drivers/usb/storage/shuttle_usbat.c b/drivers/usb/storage/=
shuttle_usbat.c
index 008d805..a3ec86b 100644
--- a/drivers/usb/storage/shuttle_usbat.c
+++ b/drivers/usb/storage/shuttle_usbat.c
@@ -53,6 +53,9 @@
 #include "transport.h"
 #include "protocol.h"
 #include "debug.h"
+#include "scsiglue.h"
+
+#define DRV_NAME "ums-usbat"
=20
 MODULE_DESCRIPTION("Driver for SCM Microsystems (a.k.a. Shuttle) USB-A=
TAPI cable");
 MODULE_AUTHOR("Daniel Drake <dsd@gentoo.org>, Robert Baruch <autophile=
@starband.net>");
@@ -1834,6 +1837,8 @@ static int init_usbat_flash(struct us_data *us)
 	return init_usbat(us, USBAT_DEV_FLASH);
 }
=20
+static struct scsi_host_template usbat_host_template;
+
 static int usbat_probe(struct usb_interface *intf,
 			 const struct usb_device_id *id)
 {
@@ -1841,7 +1846,8 @@ static int usbat_probe(struct usb_interface *intf=
,
 	int result;
=20
 	result =3D usb_stor_probe1(&us, intf, id,
-			(id - usbat_usb_ids) + usbat_unusual_dev_list);
+			(id - usbat_usb_ids) + usbat_unusual_dev_list,
+			&usbat_host_template);
 	if (result)
 		return result;
=20
@@ -1858,7 +1864,7 @@ static int usbat_probe(struct usb_interface *intf=
,
 }
=20
 static struct usb_driver usbat_driver =3D {
-	.name =3D		"ums-usbat",
+	.name =3D		DRV_NAME,
 	.probe =3D	usbat_probe,
 	.disconnect =3D	usb_stor_disconnect,
 	.suspend =3D	usb_stor_suspend,
@@ -1871,4 +1877,4 @@ static struct usb_driver usbat_driver =3D {
 	.no_dynamic_id =3D 1,
 };
=20
-module_usb_driver(usbat_driver);
+module_usb_stor_driver(usbat_driver, usbat_host_template, DRV_NAME);
diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index 6c10c88..43576ed 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -76,6 +76,8 @@
 #include "uas-detect.h"
 #endif
=20
+#define DRV_NAME "usb-storage"
+
 /* Some informational data */
 MODULE_AUTHOR("Matthew Dharm <mdharm-usb@one-eyed-alien.net>");
 MODULE_DESCRIPTION("USB Mass Storage driver for Linux");
@@ -924,7 +926,8 @@ static unsigned int usb_stor_sg_tablesize(struct us=
b_interface *intf)
 int usb_stor_probe1(struct us_data **pus,
 		struct usb_interface *intf,
 		const struct usb_device_id *id,
-		struct us_unusual_dev *unusual_dev)
+		struct us_unusual_dev *unusual_dev,
+		struct scsi_host_template *sht)
 {
 	struct Scsi_Host *host;
 	struct us_data *us;
@@ -936,7 +939,7 @@ int usb_stor_probe1(struct us_data **pus,
 	 * Ask the SCSI layer to allocate a host structure, with extra
 	 * space at the end for our private us_data structure.
 	 */
-	host =3D scsi_host_alloc(&usb_stor_host_template, sizeof(*us));
+	host =3D scsi_host_alloc(sht, sizeof(*us));
 	if (!host) {
 		dev_warn(&intf->dev, "Unable to allocate the scsi host\n");
 		return -ENOMEM;
@@ -1073,6 +1076,8 @@ void usb_stor_disconnect(struct usb_interface *in=
tf)
 }
 EXPORT_SYMBOL_GPL(usb_stor_disconnect);
=20
+static struct scsi_host_template usb_stor_host_template;
+
 /* The main probe routine for standard devices */
 static int storage_probe(struct usb_interface *intf,
 			 const struct usb_device_id *id)
@@ -1113,7 +1118,8 @@ static int storage_probe(struct usb_interface *in=
tf,
 			id->idVendor, id->idProduct);
 	}
=20
-	result =3D usb_stor_probe1(&us, intf, id, unusual_dev);
+	result =3D usb_stor_probe1(&us, intf, id, unusual_dev,
+				 &usb_stor_host_template);
 	if (result)
 		return result;
=20
@@ -1124,7 +1130,7 @@ static int storage_probe(struct usb_interface *in=
tf,
 }
=20
 static struct usb_driver usb_storage_driver =3D {
-	.name =3D		"usb-storage",
+	.name =3D		DRV_NAME,
 	.probe =3D	storage_probe,
 	.disconnect =3D	usb_stor_disconnect,
 	.suspend =3D	usb_stor_suspend,
@@ -1137,4 +1143,4 @@ static struct usb_driver usb_storage_driver =3D {
 	.soft_unbind =3D	1,
 };
=20
-module_usb_driver(usb_storage_driver);
+module_usb_stor_driver(usb_storage_driver, usb_stor_host_template, DRV=
_NAME);
diff --git a/drivers/usb/storage/usb.h b/drivers/usb/storage/usb.h
index 307e339..da0ad32 100644
--- a/drivers/usb/storage/usb.h
+++ b/drivers/usb/storage/usb.h
@@ -197,11 +197,25 @@ extern int usb_stor_post_reset(struct usb_interfa=
ce *iface);
 extern int usb_stor_probe1(struct us_data **pus,
 		struct usb_interface *intf,
 		const struct usb_device_id *id,
-		struct us_unusual_dev *unusual_dev);
+		struct us_unusual_dev *unusual_dev,
+		struct scsi_host_template *sht);
 extern int usb_stor_probe2(struct us_data *us);
 extern void usb_stor_disconnect(struct usb_interface *intf);
=20
 extern void usb_stor_adjust_quirks(struct usb_device *dev,
 		unsigned long *fflags);
=20
+#define module_usb_stor_driver(__driver, __sht, __name) \
+static int __init __driver##_init(void) \
+{ \
+	usb_stor_host_template_init(&(__sht), __name, THIS_MODULE); \
+	return usb_register(&(__driver)); \
+} \
+module_init(__driver##_init); \
+static void __exit __driver##_exit(void) \
+{ \
+	usb_deregister(&(__driver)); \
+} \
+module_exit(__driver##_exit)
+
 #endif
--=20
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
