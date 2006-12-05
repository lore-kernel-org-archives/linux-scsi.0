From: "Ed Lin" <ed.lin@promise.com>
Subject: [repost][PATCH 5/8] stex: update device id info
Date: Mon, 4 Dec 2006 17:49:36 -0800
Message-ID: <NONAMEB2ROONwIidWZe00001572@nonameb.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 67.111.72.3.ptr.us.xo.net ([67.111.72.3]:18934 "EHLO
	nonameb.ptu.promise.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S968012AbWLEBtM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Dec 2006 20:49:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: "james.Bottomley" <james.Bottomley@SteelEye.com>, jeff <jeff@garzik.org>, promise_linux <promise_linux@promise.com>


- add comments for various devices
- remove unused device ids(0xf350, 0x4301, 0x8301, 0x8302)
- add new device id(0xe350)
- fix vendor id of st_vsc
- modify Kconfig help info

Signed-off-by: Ed Lin <ed.lin@promise.com>
---
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 1b4bfaa..6956909 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -982,8 +982,13 @@ config SCSI_STEX
 	tristate "Promise SuperTrak EX Series support"
 	depends on PCI && SCSI
 	---help---
-	  This driver supports Promise SuperTrak EX8350/8300/16350/16300
-	  Storage controllers.
+	  This driver supports Promise SuperTrak EX series storage controllers.
+
+	  Promise provides Linux RAID configuration utility for these
+	  controllers. Please visit <http://www.promise.com> to download.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called stex.
 
 config SCSI_SYM53C8XX_2
 	tristate "SYM53C8XX Version 2 SCSI support"
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index a20cbd9..0fd115c 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -1356,15 +1356,32 @@ static void stex_shutdown(struct pci_dev
 }
 
 static struct pci_device_id stex_pci_tbl[] = {
-	{ 0x105a, 0x8350, PCI_ANY_ID, PCI_ANY_ID, 0, 0, st_shasta },
-	{ 0x105a, 0xc350, PCI_ANY_ID, PCI_ANY_ID, 0, 0, st_shasta },
-	{ 0x105a, 0xf350, PCI_ANY_ID, PCI_ANY_ID, 0, 0, st_shasta },
-	{ 0x105a, 0x4301, PCI_ANY_ID, PCI_ANY_ID, 0, 0, st_shasta },
-	{ 0x105a, 0x4302, PCI_ANY_ID, PCI_ANY_ID, 0, 0, st_shasta },
-	{ 0x105a, 0x8301, PCI_ANY_ID, PCI_ANY_ID, 0, 0, st_shasta },
-	{ 0x105a, 0x8302, PCI_ANY_ID, PCI_ANY_ID, 0, 0, st_shasta },
-	{ 0x1725, 0x7250, PCI_ANY_ID, PCI_ANY_ID, 0, 0, st_vsc },
-	{ 0x105a, 0x8650, PCI_ANY_ID, PCI_ANY_ID, 0, 0, st_yosemite },
+	/* st_shasta */
+	{ 0x105a, 0x8350, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+		st_shasta }, /* SuperTrak EX8350/8300/16350/16300 */
+	{ 0x105a, 0xc350, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+		st_shasta }, /* SuperTrak EX12350 */
+	{ 0x105a, 0x4302, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+		st_shasta }, /* SuperTrak EX4350 */
+	{ 0x105a, 0xe350, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+		st_shasta }, /* SuperTrak EX24350 */
+
+	/* st_vsc */
+	{ 0x105a, 0x7250, PCI_ANY_ID, PCI_ANY_ID, 0, 0, st_vsc },
+
+	/* st_yosemite */
+	{ 0x105a, 0x8650, PCI_ANY_ID, 0x4600, 0, 0,
+		st_yosemite }, /* SuperTrak EX4650 */
+	{ 0x105a, 0x8650, PCI_ANY_ID, 0x4610, 0, 0,
+		st_yosemite }, /* SuperTrak EX4650o */
+	{ 0x105a, 0x8650, PCI_ANY_ID, 0x8600, 0, 0,
+		st_yosemite }, /* SuperTrak EX8650EL */
+	{ 0x105a, 0x8650, PCI_ANY_ID, 0x8601, 0, 0,
+		st_yosemite }, /* SuperTrak EX8650 */
+	{ 0x105a, 0x8650, PCI_ANY_ID, 0x8602, 0, 0,
+		st_yosemite }, /* SuperTrak EX8654 */
+	{ 0x105a, 0x8650, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+		st_yosemite }, /* generic st_yosemite */
 	{ }	/* terminate list */
 };
 MODULE_DEVICE_TABLE(pci, stex_pci_tbl);


