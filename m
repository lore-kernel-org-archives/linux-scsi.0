From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] qla1280: ISP1020/1040 support, bump version
Date: Tue, 28 Sep 2004 22:01:50 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040928200150.GA14042@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:27583 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S267765AbUI1UB4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Sep 2004 16:01:56 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: jes@trained-monkey.org, jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

This patch adds support for the older ISP1020/1040 chips to the qla1280
driver.  In fact it does not add much support but enables the work
merged earlier.  In addition to the patch below you'll have to grab the
latest firmware Andrew Vasquez kindly provided from
http://verein.lst.de/~hch/ql1040_fw.h.bz2 and uncrompress it to
drivers/scsi/.

It's been tested to work nicely on x86 and alpha machines by multiple
people, it unfortunately doesn't work on SGI mips systems yet, but I'm
pretty sure that's due to bugginess in the pci code for those
plattforms.


--- 1.85/drivers/scsi/Kconfig	2004-09-25 15:45:43 +02:00
+++ edited/drivers/scsi/Kconfig	2004-09-28 21:55:29 +02:00
@@ -1222,7 +1222,7 @@
 	  module will be called qlogicfas.
 
 config SCSI_QLOGIC_ISP
-	tristate "Qlogic ISP SCSI support"
+	tristate "Qlogic ISP SCSI support (old driver)"
 	depends on PCI && SCSI
 	---help---
 	  This driver works for all QLogic PCI SCSI host adapters (IQ-PCI,
@@ -1239,6 +1239,9 @@
 	  To compile this driver as a module, choose M here: the
 	  module will be called qlogicisp.
 
+	  These days the hardware is also supported by the more modern qla1280
+	  driver.  In doubt use that one instead of qlogicisp.
+
 config SCSI_QLOGIC_FC
 	tristate "Qlogic ISP FC SCSI support"
 	depends on PCI && SCSI
@@ -1257,13 +1260,20 @@
 	  qlogicfc driver. This is required on some platforms.
 
 config SCSI_QLOGIC_1280
-	tristate "Qlogic QLA 1280 SCSI support"
+	tristate "Qlogic QLA 1240/1x80/1x160 SCSI support"
 	depends on PCI && SCSI
 	help
-	  Say Y if you have a QLogic ISP1x80/1x160 SCSI host adapter.
+	  Say Y if you have a QLogic ISP1240/1x80/1x160 SCSI host adapter.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called qla1280.
+
+config SCSI_QLOGIC_1280_1040
+	bool "Qlogic QLA 1020/1040 SCSI support"
+	help
+	  Say Y here if you have a QLogic ISP1020/1040 SCSI host adapter and
+	  do not want to use the old driver.  This option enables support in
+	  the qla1280 driver for those host adapters.
 
 config SCSI_QLOGICPTI
 	tristate "PTI Qlogic, ISP Driver"
--- 1.66/drivers/scsi/qla1280.c	2004-09-21 23:25:39 +02:00
+++ edited/drivers/scsi/qla1280.c	2004-09-28 21:59:01 +02:00
@@ -17,9 +17,12 @@
 * General Public License for more details.
 *
 ******************************************************************************/
-#define QLA1280_VERSION      "3.24.4"
+#define QLA1280_VERSION      "3.25"
 /*****************************************************************************
     Revision History:
+    Rev  3.25, September 28, 2004, Christoph Hellwig
+	- add support for ISP1020/1040
+	- don't include "scsi.h" anymore for 2.6.x
     Rev  3.24.4 June 7, 2004 Christoph Hellwig
 	- restructure firmware loading, cleanup initialization code
 	- prepare support for ISP1020/1040 chips
@@ -356,7 +359,6 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
-#include "scsi.h"
 #else
 #include <linux/blk.h>
 #include "scsi.h"
@@ -390,6 +392,7 @@
 #include "qla1280.h"
 #include "ql12160_fw.h"		/* ISP RISC codes */
 #include "ql1280_fw.h"
+#include "ql1040_fw.h"
 
 
 /*
@@ -632,18 +635,22 @@
 	unsigned char *fwver;	/* Ptr to F/W version array    */
 };
 
-/* NOTE: qla1280_pci_tbl and ql1280_board_tbl must be in the same order */
+/* NOTE: the last argument in each entry is used to index ql1280_board_tbl */
 static struct pci_device_id qla1280_pci_tbl[] = {
 	{PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP12160,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP1080,
+#ifdef CONFIG_SCSI_QLOGIC_1280_1040
+	{PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP1020,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 1},
-	{PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP1240,
+#endif
+	{PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP1080,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 2},
-	{PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP1280,
+	{PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP1240,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 3},
-	{PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP10160,
+	{PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP1280,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 4},
+	{PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP10160,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 5},
 	{0,}
 };
 MODULE_DEVICE_TABLE(pci, qla1280_pci_tbl);
@@ -652,6 +659,8 @@
 	/* Name ,  Number of ports, FW details */
 	{"QLA12160", 2, &fw12160i_code01[0], &fw12160i_length01,
 	 &fw12160i_addr01, &fw12160i_version_str[0]},
+	{"QLA1040", 1, &risc_code01[0], &risc_code_length01,
+	 &risc_code_addr01, &firmware_version[0]},
 	{"QLA1080", 1, &fw1280ei_code01[0], &fw1280ei_length01,
 	 &fw1280ei_addr01, &fw1280ei_version_str[0]},
 	{"QLA1240", 2, &fw1280ei_code01[0], &fw1280ei_length01,
@@ -1779,6 +1788,10 @@
 	}
 #endif
 
+	/* TODO: implement support for the 1040 nvram format */
+	if (IS_ISP1040(ha))
+		driver_setup.no_nvram = 1;
+
 	dprintk(1, "Configure PCI space for adapter...\n");
 
 	reg = ha->iobase;
@@ -2339,9 +2352,7 @@
 #if 1	/* Some SCSI Processors do not seem to like this */
 	nv->bus[bus].target[target].parameter.f.enable_wide = 1;
 #endif
-	if (!IS_ISP1040(ha))
-		nv->bus[bus].target[target].parameter.f.parity_checking = 1;
-
+	nv->bus[bus].target[target].parameter.f.parity_checking = 1;
 	nv->bus[bus].target[target].parameter.f.disconnect_allowed = 1;
 	nv->bus[bus].target[target].execution_throttle =
 		nv->bus[bus].max_queue_depth - 1;
