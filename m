From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 3/3] usb: storage: adjust module reference for scsi host
Date: Mon,  5 Jan 2015 23:34:39 +0900
Message-ID: <1420468479-4508-4-git-send-email-akinobu.mita@gmail.com>
References: <1420468479-4508-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:63110 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441AbbAEOfE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jan 2015 09:35:04 -0500
In-Reply-To: <1420468479-4508-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net

While accessing a unusual usb storage (ums-alauda, ums-cypress, ...),
the module reference count is not incremented.  Because these drivers
allocate scsi hosts with usb_stor_host_template defined in usb-storage
module.  So these drivers always can be unloaded.

This fixes it by adjusting module reference after scsi host allocation.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-usb@vger.kernel.org
Cc: usb-storage@lists.one-eyed-alien.net
Cc: linux-scsi@vger.kernel.org
---
 drivers/usb/storage/alauda.c        | 1 +
 drivers/usb/storage/cypress_atacb.c | 2 ++
 drivers/usb/storage/datafab.c       | 1 +
 drivers/usb/storage/ene_ub6250.c    | 1 +
 drivers/usb/storage/freecom.c       | 1 +
 drivers/usb/storage/isd200.c        | 1 +
 drivers/usb/storage/jumpshot.c      | 1 +
 drivers/usb/storage/karma.c         | 1 +
 drivers/usb/storage/onetouch.c      | 2 ++
 drivers/usb/storage/realtek_cr.c    | 2 ++
 drivers/usb/storage/sddr09.c        | 2 ++
 drivers/usb/storage/sddr55.c        | 1 +
 drivers/usb/storage/shuttle_usbat.c | 1 +
 13 files changed, 17 insertions(+)

diff --git a/drivers/usb/storage/alauda.c b/drivers/usb/storage/alauda.c
index 62c2d9d..77660d6 100644
--- a/drivers/usb/storage/alauda.c
+++ b/drivers/usb/storage/alauda.c
@@ -1242,6 +1242,7 @@ static int alauda_probe(struct usb_interface *intf,
 	us->transport = alauda_transport;
 	us->transport_reset = usb_stor_Bulk_reset;
 	us->max_lun = 1;
+	us_to_host(us)->module = THIS_MODULE;
 
 	result = usb_stor_probe2(us);
 	return result;
diff --git a/drivers/usb/storage/cypress_atacb.c b/drivers/usb/storage/cypress_atacb.c
index 8514a2d..d603d04 100644
--- a/drivers/usb/storage/cypress_atacb.c
+++ b/drivers/usb/storage/cypress_atacb.c
@@ -255,6 +255,8 @@ static int cypress_probe(struct usb_interface *intf,
 	if (result)
 		return result;
 
+	us_to_host(us)->module = THIS_MODULE;
+
 	/* Among CY7C68300 chips, the A revision does not support Cypress ATACB
 	 * Filter out this revision from EEPROM default descriptor values
 	 */
diff --git a/drivers/usb/storage/datafab.c b/drivers/usb/storage/datafab.c
index 7b17c21..4193caf 100644
--- a/drivers/usb/storage/datafab.c
+++ b/drivers/usb/storage/datafab.c
@@ -736,6 +736,7 @@ static int datafab_probe(struct usb_interface *intf,
 	us->transport = datafab_transport;
 	us->transport_reset = usb_stor_Bulk_reset;
 	us->max_lun = 1;
+	us_to_host(us)->module = THIS_MODULE;
 
 	result = usb_stor_probe2(us);
 	return result;
diff --git a/drivers/usb/storage/ene_ub6250.c b/drivers/usb/storage/ene_ub6250.c
index 56f782b..c4656bd 100644
--- a/drivers/usb/storage/ene_ub6250.c
+++ b/drivers/usb/storage/ene_ub6250.c
@@ -2331,6 +2331,7 @@ static int ene_ub6250_probe(struct usb_interface *intf,
 	us->transport_name = "ene_ub6250";
 	us->transport = ene_transport;
 	us->max_lun = 0;
+	us_to_host(us)->module = THIS_MODULE;
 
 	result = usb_stor_probe2(us);
 	if (result)
diff --git a/drivers/usb/storage/freecom.c b/drivers/usb/storage/freecom.c
index ef16068..c66ee7a 100644
--- a/drivers/usb/storage/freecom.c
+++ b/drivers/usb/storage/freecom.c
@@ -538,6 +538,7 @@ static int freecom_probe(struct usb_interface *intf,
 	us->transport = freecom_transport;
 	us->transport_reset = usb_stor_freecom_reset;
 	us->max_lun = 0;
+	us_to_host(us)->module = THIS_MODULE;
 
 	result = usb_stor_probe2(us);
 	return result;
diff --git a/drivers/usb/storage/isd200.c b/drivers/usb/storage/isd200.c
index 599d8bf..dcd2a10 100644
--- a/drivers/usb/storage/isd200.c
+++ b/drivers/usb/storage/isd200.c
@@ -1550,6 +1550,7 @@ static int isd200_probe(struct usb_interface *intf,
 
 	us->protocol_name = "ISD200 ATA/ATAPI";
 	us->proto_handler = isd200_ata_command;
+	us_to_host(us)->module = THIS_MODULE;
 
 	result = usb_stor_probe2(us);
 	return result;
diff --git a/drivers/usb/storage/jumpshot.c b/drivers/usb/storage/jumpshot.c
index 563078b..80e14be 100644
--- a/drivers/usb/storage/jumpshot.c
+++ b/drivers/usb/storage/jumpshot.c
@@ -662,6 +662,7 @@ static int jumpshot_probe(struct usb_interface *intf,
 	us->transport = jumpshot_transport;
 	us->transport_reset = usb_stor_Bulk_reset;
 	us->max_lun = 1;
+	us_to_host(us)->module = THIS_MODULE;
 
 	result = usb_stor_probe2(us);
 	return result;
diff --git a/drivers/usb/storage/karma.c b/drivers/usb/storage/karma.c
index 94d16ee..ccfae96 100644
--- a/drivers/usb/storage/karma.c
+++ b/drivers/usb/storage/karma.c
@@ -214,6 +214,7 @@ static int karma_probe(struct usb_interface *intf,
 	us->transport_name = "Rio Karma/Bulk";
 	us->transport = rio_karma_transport;
 	us->transport_reset = usb_stor_Bulk_reset;
+	us_to_host(us)->module = THIS_MODULE;
 
 	result = usb_stor_probe2(us);
 	return result;
diff --git a/drivers/usb/storage/onetouch.c b/drivers/usb/storage/onetouch.c
index 74e2aa2..c69e451 100644
--- a/drivers/usb/storage/onetouch.c
+++ b/drivers/usb/storage/onetouch.c
@@ -296,6 +296,8 @@ static int onetouch_probe(struct usb_interface *intf,
 
 	/* Use default transport and protocol */
 
+	us_to_host(us)->module = THIS_MODULE;
+
 	result = usb_stor_probe2(us);
 	return result;
 }
diff --git a/drivers/usb/storage/realtek_cr.c b/drivers/usb/storage/realtek_cr.c
index 27e4a58..d839e1e 100644
--- a/drivers/usb/storage/realtek_cr.c
+++ b/drivers/usb/storage/realtek_cr.c
@@ -1048,6 +1048,8 @@ static int realtek_cr_probe(struct usb_interface *intf,
 	if (result)
 		return result;
 
+	us_to_host(us)->module = THIS_MODULE;
+
 	result = usb_stor_probe2(us);
 
 	return result;
diff --git a/drivers/usb/storage/sddr09.c b/drivers/usb/storage/sddr09.c
index 3847053..b45d751 100644
--- a/drivers/usb/storage/sddr09.c
+++ b/drivers/usb/storage/sddr09.c
@@ -1761,6 +1761,8 @@ static int sddr09_probe(struct usb_interface *intf,
 		us->max_lun = 0;
 	}
 
+	us_to_host(us)->module = THIS_MODULE;
+
 	result = usb_stor_probe2(us);
 	return result;
 }
diff --git a/drivers/usb/storage/sddr55.c b/drivers/usb/storage/sddr55.c
index aacedef..74f9c19 100644
--- a/drivers/usb/storage/sddr55.c
+++ b/drivers/usb/storage/sddr55.c
@@ -984,6 +984,7 @@ static int sddr55_probe(struct usb_interface *intf,
 	us->transport = sddr55_transport;
 	us->transport_reset = sddr55_reset;
 	us->max_lun = 0;
+	us_to_host(us)->module = THIS_MODULE;
 
 	result = usb_stor_probe2(us);
 	return result;
diff --git a/drivers/usb/storage/shuttle_usbat.c b/drivers/usb/storage/shuttle_usbat.c
index 008d805..899efea 100644
--- a/drivers/usb/storage/shuttle_usbat.c
+++ b/drivers/usb/storage/shuttle_usbat.c
@@ -1852,6 +1852,7 @@ static int usbat_probe(struct usb_interface *intf,
 	us->transport = usbat_flash_transport;
 	us->transport_reset = usb_stor_CB_reset;
 	us->max_lun = 0;
+	us_to_host(us)->module = THIS_MODULE;
 
 	result = usb_stor_probe2(us);
 	return result;
-- 
1.9.1

