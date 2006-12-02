From: "Ed Lin" <ed.lin@promise.com>
Subject: [PATCH 5/8] stex: update device id info
Date: Fri, 1 Dec 2006 20:44:09 -0800
Message-ID: <NONAMEBzg7KazMfhgmu0000149b@nonameb.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 67.111.72.3.ptr.us.xo.net ([67.111.72.3]:8745 "EHLO
	nonameb.ptu.promise.com") by vger.kernel.org with ESMTP
	id S1162790AbWLBEno (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Dec 2006 23:43:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: "James.Bottomley" <James.Bottomley@SteelEye.com>, jeff <jeff@garzik.org>, promise_linux <promise_linux@promise.com>


Update pci device id and Kconfig help information.

Signed-off-by: Ed Lin <ed.lin@promise.com>
---
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 1301d52..fb55373 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -968,8 +968,16 @@ config SCSI_STEX
 	tristate "Promise SuperTrak EX Series support"
 	depends on PCI && SCSI
 	---help---
-	  This driver supports Promise SuperTrak EX8350/8300/16350/16300
-	  Storage controllers.
+	  This driver supports Promise SuperTrak EX series storage controllers.
+	  These include SuperTrak EX8350, EX8300, EX16350, EX16300, EX12350,
+	  EX4350, EX24350; SuperTrak EX4650, EX4650o, EX8650EL, EX8650, EX8654;
+	  and VSC7250 series.
+
+	  Promise provides Linux RAID configuration utility for these
+	  controllers. Please visit <http://www.promise.com> to download.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called stex.
 
 config SCSI_SYM53C8XX_2
 	tristate "SYM53C8XX Version 2 SCSI support"
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index a20cbd9..c4ee038 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -120,8 +120,9 @@ enum {
 	ST_MAX_LUN_PER_TARGET			= 16,
 
 	st_shasta				= 0,
-	st_vsc					= 1,
-	st_yosemite				= 2,
+	st_vsc0					= 1,
+	st_vsc1					= 2,
+	st_yosemite				= 3,
 
 	PASSTHRU_REQ_TYPE			= 0x00000001,
 	PASSTHRU_REQ_NO_WAKEUP			= 0x00000100,
@@ -1356,15 +1357,41 @@ static void stex_shutdown(struct pci_dev
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
+	{ 0x105a, 0x7250, 0x105a, 0x1000, 0, 0, st_vsc0 },
+	{ 0x105a, 0x7250, 0x105a, 0x2500, 0, 0, st_vsc0 },
+	{ 0x105a, 0x7250, 0x105a, 0x2510, 0, 0, st_vsc0 },
+	{ 0x105a, 0x7250, 0x105a, 0x2520, 0, 0, st_vsc0 },
+	{ 0x105a, 0x7250, 0x105a, 0x2530, 0, 0, st_vsc0 },
+	{ 0x105a, 0x7250, 0x105a, 0x1001, 0, 0, st_vsc1 },
+	{ 0x105a, 0x7250, 0x105a, 0x2501, 0, 0, st_vsc1 },
+	{ 0x105a, 0x7250, 0x105a, 0x2511, 0, 0, st_vsc1 },
+	{ 0x105a, 0x7250, 0x105a, 0x2521, 0, 0, st_vsc1 },
+	{ 0x105a, 0x7250, 0x105a, 0x2531, 0, 0, st_vsc1 },
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


