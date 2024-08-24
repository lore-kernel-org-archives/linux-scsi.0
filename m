Received: from msa.smtpout.orange.fr (msa-218.smtpout.orange.fr [193.252.23.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F6D15098F;
	Sat, 24 Aug 2024 13:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.252.23.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724507255; cv=none; b=r3J5gHdkvQGbxq6dAobebbSOsFOdtX9bdZkHEohhmcwyuu9nbrRgRZzGEejcJCeG9gaZrXtuVjByLc0MZhUfaSWG6vBpuZEQsN8vQpNqENSZOQrlvFN0DbcURM+MRDhQODX8IcfFli8Pf+KTMoMb40/qhBlXrtk1RhLeQQTiSQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724507255; c=relaxed/simple;
	bh=rYV7YbbPPMai7nwihdtZF7TUUXb9Shf6UFzB1mgO7XM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DvrnFIeS2fdPpTd1s1OPjAseEnoCHjtM5qqEW0BmqflxNcBwgIr3yLDyXZFHeCIrKWSQbrqdS+zb4VCqcDNuJvRyreL3RMW9Bs/ctYsiyY/0sZ7sFkpXjPX3Zc1knfRdYNzbq9GFL9uphaTSA5sLESiaIdyq6Eo4Iyp2HoL3aJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=AQac5zvA; arc=none smtp.client-ip=193.252.23.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="AQac5zvA"
Received: from fedora.home ([90.11.132.44])
	by smtp.orange.fr with ESMTPA
	id hr6vsE2q1aZQfhr6vsx39B; Sat, 24 Aug 2024 15:47:23 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1724507243;
	bh=VrJTdN+d9FOn7wLbxMX7FhFh6wourAJWHL5OBIY5qyw=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=AQac5zvAUw06SiL2gDL5rQBUQzYSIbh6IknnF7+y55uxiEzIlQuapT67rrpo3oJoz
	 /ABktPMfiaDKYf5YeXRMB95hhl4ozTVAEJgIKtlT2aiOLxQeY4r3j/DsJeEv0R8W2O
	 /azzfQjdXST+2JQ+UAk5q1xur6RKcNKrO02Szr7NCAIpuwIVLpC+TEKaJ4MipWPfJx
	 iWxZN7zx+M1Y8gBMCeQrxs1yf8Iz68txBVgnUNQrz2QNTIxXsJL8H2gWgTpj9npJbB
	 6waoLYdnD9M/RHwCWNlSpkvMW39kVARdfKzsAWWXadx7NEWJLBxZfYHNUENViwNdtK
	 Qh0Ix69/XmM4A==
X-ME-Helo: fedora.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 24 Aug 2024 15:47:23 +0200
X-ME-IP: 90.11.132.44
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: Alan Stern <stern@rowland.harvard.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Oliver Neukum <oneukum@suse.com>
Cc: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	linux-usb@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net,
	linux-scsi@vger.kernel.org
Subject: [PATCH] usb-storage: Constify struct usb_device_id and us_unusual_dev
Date: Sat, 24 Aug 2024 15:47:07 +0200
Message-ID: <b1b75a2a64b1f6cfad2a611f71393f281178fd3f.1724507157.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

'struct usb_device_id' and 'struct us_unusual_dev' are not modified in
these drivers.

Constifying these structures moves some data to a read-only section, so
increase overall security, especially when the structure holds some
function pointers (which is the case for struct us_unusual_dev).

On a x86_64, with allmodconfig, as an example:
Before:
======
   text	   data	    bss	    dec	    hex	filename
  25249	   4261	    896	  30406	   76c6	drivers/usb/storage/alauda.o
   3969	    672	    360	   5001	   1389	drivers/usb/storage/cypress_atacb.o

After:
=====
   text	   data	    bss	    dec	    hex	filename
  25461	   4041	    896	  30398	   76be	drivers/usb/storage/alauda.o
   4225	    400	    360	   4985	   1379	drivers/usb/storage/cypress_atacb.o

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Compile tested-only.

I hope that a single patch for all drivers in drivers/usb/storage/ is fine.
---
 drivers/usb/storage/alauda.c        | 4 ++--
 drivers/usb/storage/cypress_atacb.c | 4 ++--
 drivers/usb/storage/datafab.c       | 4 ++--
 drivers/usb/storage/ene_ub6250.c    | 4 ++--
 drivers/usb/storage/freecom.c       | 4 ++--
 drivers/usb/storage/isd200.c        | 4 ++--
 drivers/usb/storage/jumpshot.c      | 4 ++--
 drivers/usb/storage/karma.c         | 4 ++--
 drivers/usb/storage/onetouch.c      | 4 ++--
 drivers/usb/storage/sddr09.c        | 4 ++--
 drivers/usb/storage/sddr55.c        | 4 ++--
 drivers/usb/storage/shuttle_usbat.c | 4 ++--
 drivers/usb/storage/uas.c           | 2 +-
 13 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/usb/storage/alauda.c b/drivers/usb/storage/alauda.c
index 40d34cc28344..a9d3c58ce7d9 100644
--- a/drivers/usb/storage/alauda.c
+++ b/drivers/usb/storage/alauda.c
@@ -132,7 +132,7 @@ static int init_alauda(struct us_data *us);
 { USB_DEVICE_VER(id_vendor, id_product, bcdDeviceMin, bcdDeviceMax), \
   .driver_info = (flags) }
 
-static struct usb_device_id alauda_usb_ids[] = {
+static const struct usb_device_id alauda_usb_ids[] = {
 #	include "unusual_alauda.h"
 	{ }		/* Terminating entry */
 };
@@ -154,7 +154,7 @@ MODULE_DEVICE_TABLE(usb, alauda_usb_ids);
 	.initFunction = init_function,	\
 }
 
-static struct us_unusual_dev alauda_unusual_dev_list[] = {
+static const struct us_unusual_dev alauda_unusual_dev_list[] = {
 #	include "unusual_alauda.h"
 	{ }		/* Terminating entry */
 };
diff --git a/drivers/usb/storage/cypress_atacb.c b/drivers/usb/storage/cypress_atacb.c
index 98b3ec352a13..30dfd0082474 100644
--- a/drivers/usb/storage/cypress_atacb.c
+++ b/drivers/usb/storage/cypress_atacb.c
@@ -33,7 +33,7 @@ MODULE_IMPORT_NS(USB_STORAGE);
 { USB_DEVICE_VER(id_vendor, id_product, bcdDeviceMin, bcdDeviceMax), \
   .driver_info = (flags) }
 
-static struct usb_device_id cypress_usb_ids[] = {
+static const struct usb_device_id cypress_usb_ids[] = {
 #	include "unusual_cypress.h"
 	{ }		/* Terminating entry */
 };
@@ -55,7 +55,7 @@ MODULE_DEVICE_TABLE(usb, cypress_usb_ids);
 	.initFunction = init_function,	\
 }
 
-static struct us_unusual_dev cypress_unusual_dev_list[] = {
+static const struct us_unusual_dev cypress_unusual_dev_list[] = {
 #	include "unusual_cypress.h"
 	{ }		/* Terminating entry */
 };
diff --git a/drivers/usb/storage/datafab.c b/drivers/usb/storage/datafab.c
index bcc4a2fad863..3ea5601d16b8 100644
--- a/drivers/usb/storage/datafab.c
+++ b/drivers/usb/storage/datafab.c
@@ -80,7 +80,7 @@ static int datafab_determine_lun(struct us_data *us,
 { USB_DEVICE_VER(id_vendor, id_product, bcdDeviceMin, bcdDeviceMax), \
   .driver_info = (flags) }
 
-static struct usb_device_id datafab_usb_ids[] = {
+static const struct usb_device_id datafab_usb_ids[] = {
 #	include "unusual_datafab.h"
 	{ }		/* Terminating entry */
 };
@@ -102,7 +102,7 @@ MODULE_DEVICE_TABLE(usb, datafab_usb_ids);
 	.initFunction = init_function,	\
 }
 
-static struct us_unusual_dev datafab_unusual_dev_list[] = {
+static const struct us_unusual_dev datafab_unusual_dev_list[] = {
 #	include "unusual_datafab.h"
 	{ }		/* Terminating entry */
 };
diff --git a/drivers/usb/storage/ene_ub6250.c b/drivers/usb/storage/ene_ub6250.c
index 97c66c0d91f4..73dd276ce59c 100644
--- a/drivers/usb/storage/ene_ub6250.c
+++ b/drivers/usb/storage/ene_ub6250.c
@@ -43,7 +43,7 @@ MODULE_FIRMWARE(MS_RW_FIRMWARE);
 { USB_DEVICE_VER(id_vendor, id_product, bcdDeviceMin, bcdDeviceMax), \
 	.driver_info = (flags)}
 
-static struct usb_device_id ene_ub6250_usb_ids[] = {
+static const struct usb_device_id ene_ub6250_usb_ids[] = {
 #	include "unusual_ene_ub6250.h"
 	{ }		/* Terminating entry */
 };
@@ -65,7 +65,7 @@ MODULE_DEVICE_TABLE(usb, ene_ub6250_usb_ids);
 	.initFunction = init_function,	\
 }
 
-static struct us_unusual_dev ene_ub6250_unusual_dev_list[] = {
+static const struct us_unusual_dev ene_ub6250_unusual_dev_list[] = {
 #	include "unusual_ene_ub6250.h"
 	{ }		/* Terminating entry */
 };
diff --git a/drivers/usb/storage/freecom.c b/drivers/usb/storage/freecom.c
index c3ce51c2dabd..cab27ba7a32a 100644
--- a/drivers/usb/storage/freecom.c
+++ b/drivers/usb/storage/freecom.c
@@ -119,7 +119,7 @@ static int init_freecom(struct us_data *us);
 { USB_DEVICE_VER(id_vendor, id_product, bcdDeviceMin, bcdDeviceMax), \
   .driver_info = (flags) }
 
-static struct usb_device_id freecom_usb_ids[] = {
+static const struct usb_device_id freecom_usb_ids[] = {
 #	include "unusual_freecom.h"
 	{ }		/* Terminating entry */
 };
@@ -141,7 +141,7 @@ MODULE_DEVICE_TABLE(usb, freecom_usb_ids);
 	.initFunction = init_function,	\
 }
 
-static struct us_unusual_dev freecom_unusual_dev_list[] = {
+static const struct us_unusual_dev freecom_unusual_dev_list[] = {
 #	include "unusual_freecom.h"
 	{ }		/* Terminating entry */
 };
diff --git a/drivers/usb/storage/isd200.c b/drivers/usb/storage/isd200.c
index 300aeef160e7..f2254eb3c0d7 100644
--- a/drivers/usb/storage/isd200.c
+++ b/drivers/usb/storage/isd200.c
@@ -67,7 +67,7 @@ static int isd200_Initialization(struct us_data *us);
 { USB_DEVICE_VER(id_vendor, id_product, bcdDeviceMin, bcdDeviceMax), \
   .driver_info = (flags) }
 
-static struct usb_device_id isd200_usb_ids[] = {
+static const struct usb_device_id isd200_usb_ids[] = {
 #	include "unusual_isd200.h"
 	{ }		/* Terminating entry */
 };
@@ -89,7 +89,7 @@ MODULE_DEVICE_TABLE(usb, isd200_usb_ids);
 	.initFunction = init_function,	\
 }
 
-static struct us_unusual_dev isd200_unusual_dev_list[] = {
+static const struct us_unusual_dev isd200_unusual_dev_list[] = {
 #	include "unusual_isd200.h"
 	{ }		/* Terminating entry */
 };
diff --git a/drivers/usb/storage/jumpshot.c b/drivers/usb/storage/jumpshot.c
index 229bf0c1afc9..0e71a8f33c2b 100644
--- a/drivers/usb/storage/jumpshot.c
+++ b/drivers/usb/storage/jumpshot.c
@@ -62,7 +62,7 @@ MODULE_IMPORT_NS(USB_STORAGE);
 { USB_DEVICE_VER(id_vendor, id_product, bcdDeviceMin, bcdDeviceMax), \
   .driver_info = (flags) }
 
-static struct usb_device_id jumpshot_usb_ids[] = {
+static const struct usb_device_id jumpshot_usb_ids[] = {
 #	include "unusual_jumpshot.h"
 	{ }		/* Terminating entry */
 };
@@ -84,7 +84,7 @@ MODULE_DEVICE_TABLE(usb, jumpshot_usb_ids);
 	.initFunction = init_function,	\
 }
 
-static struct us_unusual_dev jumpshot_unusual_dev_list[] = {
+static const struct us_unusual_dev jumpshot_unusual_dev_list[] = {
 #	include "unusual_jumpshot.h"
 	{ }		/* Terminating entry */
 };
diff --git a/drivers/usb/storage/karma.c b/drivers/usb/storage/karma.c
index 38ddfedef629..d6a5e54f2ca8 100644
--- a/drivers/usb/storage/karma.c
+++ b/drivers/usb/storage/karma.c
@@ -51,7 +51,7 @@ static int rio_karma_init(struct us_data *us);
 { USB_DEVICE_VER(id_vendor, id_product, bcdDeviceMin, bcdDeviceMax), \
   .driver_info = (flags) }
 
-static struct usb_device_id karma_usb_ids[] = {
+static const struct usb_device_id karma_usb_ids[] = {
 #	include "unusual_karma.h"
 	{ }		/* Terminating entry */
 };
@@ -73,7 +73,7 @@ MODULE_DEVICE_TABLE(usb, karma_usb_ids);
 	.initFunction = init_function,	\
 }
 
-static struct us_unusual_dev karma_unusual_dev_list[] = {
+static const struct us_unusual_dev karma_unusual_dev_list[] = {
 #	include "unusual_karma.h"
 	{ }		/* Terminating entry */
 };
diff --git a/drivers/usb/storage/onetouch.c b/drivers/usb/storage/onetouch.c
index 01f3c2779ccf..f97cf6cadb8e 100644
--- a/drivers/usb/storage/onetouch.c
+++ b/drivers/usb/storage/onetouch.c
@@ -55,7 +55,7 @@ struct usb_onetouch {
 { USB_DEVICE_VER(id_vendor, id_product, bcdDeviceMin, bcdDeviceMax), \
   .driver_info = (flags) }
 
-static struct usb_device_id onetouch_usb_ids[] = {
+static const struct usb_device_id onetouch_usb_ids[] = {
 #	include "unusual_onetouch.h"
 	{ }		/* Terminating entry */
 };
@@ -77,7 +77,7 @@ MODULE_DEVICE_TABLE(usb, onetouch_usb_ids);
 	.initFunction = init_function,	\
 }
 
-static struct us_unusual_dev onetouch_unusual_dev_list[] = {
+static const struct us_unusual_dev onetouch_unusual_dev_list[] = {
 #	include "unusual_onetouch.h"
 	{ }		/* Terminating entry */
 };
diff --git a/drivers/usb/storage/sddr09.c b/drivers/usb/storage/sddr09.c
index 51bcd4a43690..03d1b9c69ea1 100644
--- a/drivers/usb/storage/sddr09.c
+++ b/drivers/usb/storage/sddr09.c
@@ -63,7 +63,7 @@ static int usb_stor_sddr09_init(struct us_data *us);
 { USB_DEVICE_VER(id_vendor, id_product, bcdDeviceMin, bcdDeviceMax), \
   .driver_info = (flags) }
 
-static struct usb_device_id sddr09_usb_ids[] = {
+static const struct usb_device_id sddr09_usb_ids[] = {
 #	include "unusual_sddr09.h"
 	{ }		/* Terminating entry */
 };
@@ -85,7 +85,7 @@ MODULE_DEVICE_TABLE(usb, sddr09_usb_ids);
 	.initFunction = init_function,	\
 }
 
-static struct us_unusual_dev sddr09_unusual_dev_list[] = {
+static const struct us_unusual_dev sddr09_unusual_dev_list[] = {
 #	include "unusual_sddr09.h"
 	{ }		/* Terminating entry */
 };
diff --git a/drivers/usb/storage/sddr55.c b/drivers/usb/storage/sddr55.c
index 0aa079405d23..b8227478a7ad 100644
--- a/drivers/usb/storage/sddr55.c
+++ b/drivers/usb/storage/sddr55.c
@@ -40,7 +40,7 @@ MODULE_IMPORT_NS(USB_STORAGE);
 { USB_DEVICE_VER(id_vendor, id_product, bcdDeviceMin, bcdDeviceMax), \
   .driver_info = (flags) }
 
-static struct usb_device_id sddr55_usb_ids[] = {
+static const struct usb_device_id sddr55_usb_ids[] = {
 #	include "unusual_sddr55.h"
 	{ }		/* Terminating entry */
 };
@@ -62,7 +62,7 @@ MODULE_DEVICE_TABLE(usb, sddr55_usb_ids);
 	.initFunction = init_function,	\
 }
 
-static struct us_unusual_dev sddr55_unusual_dev_list[] = {
+static const struct us_unusual_dev sddr55_unusual_dev_list[] = {
 #	include "unusual_sddr55.h"
 	{ }		/* Terminating entry */
 };
diff --git a/drivers/usb/storage/shuttle_usbat.c b/drivers/usb/storage/shuttle_usbat.c
index f0d0ca37163d..e7c224b7c464 100644
--- a/drivers/usb/storage/shuttle_usbat.c
+++ b/drivers/usb/storage/shuttle_usbat.c
@@ -162,7 +162,7 @@ static int init_usbat_flash(struct us_data *us);
 { USB_DEVICE_VER(id_vendor, id_product, bcdDeviceMin, bcdDeviceMax), \
   .driver_info = (flags) }
 
-static struct usb_device_id usbat_usb_ids[] = {
+static const struct usb_device_id usbat_usb_ids[] = {
 #	include "unusual_usbat.h"
 	{ }		/* Terminating entry */
 };
@@ -184,7 +184,7 @@ MODULE_DEVICE_TABLE(usb, usbat_usb_ids);
 	.initFunction = init_function,	\
 }
 
-static struct us_unusual_dev usbat_unusual_dev_list[] = {
+static const struct us_unusual_dev usbat_unusual_dev_list[] = {
 #	include "unusual_usbat.h"
 	{ }		/* Terminating entry */
 };
diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index c223b4dc1b19..03043d567fa1 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -927,7 +927,7 @@ static const struct scsi_host_template uas_host_template = {
 { USB_DEVICE_VER(id_vendor, id_product, bcdDeviceMin, bcdDeviceMax), \
 	.driver_info = (flags) }
 
-static struct usb_device_id uas_usb_ids[] = {
+static const struct usb_device_id uas_usb_ids[] = {
 #	include "unusual_uas.h"
 	{ USB_INTERFACE_INFO(USB_CLASS_MASS_STORAGE, USB_SC_SCSI, USB_PR_BULK) },
 	{ USB_INTERFACE_INFO(USB_CLASS_MASS_STORAGE, USB_SC_SCSI, USB_PR_UAS) },
-- 
2.46.0

