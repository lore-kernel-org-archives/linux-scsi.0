From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [9/11]   qla2xxx: Consolidate ISP63xx support
Date: Wed, 8 Dec 2004 23:40:39 -0800
Message-ID: <20041209074039.GA22144@plap.san.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-03-qfe0.socal.rr.com ([66.75.162.135]:59889 "EHLO
	ms-smtp-03-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S261478AbULIHkn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Dec 2004 02:40:43 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

ChangeSet
  1.2243 04/12/08 21:49:42 andrew.vasquez@qlogic.com +5 -0
  Recent ISP6312 FLX firmware can support both ISP6312 and
  ISP6322 chips.  Consolidate ISP6322 handling into the
  ISP6312 firmware loader files.
  
  Remove ql6322.c file.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

 drivers/scsi/qla2xxx/ql6322.c  |  108 -----------------------------------------
 drivers/scsi/qla2xxx/Kconfig   |   14 +----
 drivers/scsi/qla2xxx/Makefile  |    2 
 drivers/scsi/qla2xxx/ql6312.c  |   14 ++++-
 drivers/scsi/qla2xxx/qla_def.h |    6 --
 5 files changed, 18 insertions(+), 126 deletions(-)

diff -Nru a/drivers/scsi/qla2xxx/Kconfig b/drivers/scsi/qla2xxx/Kconfig
--- a/drivers/scsi/qla2xxx/Kconfig	2004-12-08 22:16:47 -08:00
+++ b/drivers/scsi/qla2xxx/Kconfig	2004-12-08 22:16:47 -08:00
@@ -22,7 +22,7 @@
 	depends on SCSI_QLA2XXX
         select SCSI_FC_ATTRS
 	---help---
-	This driver supports the QLogic 2300 (ISP2300, and ISP2312) host
+	This driver supports the QLogic 2300 (ISP2300 and ISP2312) host
 	adapter family.
 
 config SCSI_QLA2322
@@ -33,15 +33,9 @@
 	This driver supports the QLogic 2322 (ISP2322) host adapter family.
 
 config SCSI_QLA6312
-	tristate "QLogic ISP6312 host adapter family support"
+	tristate "QLogic ISP63xx host adapter family support"
 	depends on SCSI_QLA2XXX
         select SCSI_FC_ATTRS
 	---help---
-	This driver supports the QLogic 6312 (ISP6312) host adapter family.
-
-config SCSI_QLA6322
-	tristate "QLogic ISP6322 host adapter family support"
-	depends on SCSI_QLA2XXX
-        select SCSI_FC_ATTRS
-	---help---
-	This driver supports the QLogic 6322 (ISP6322) host adapter family.
+	This driver supports the QLogic 63xx (ISP6312 and ISP6322) host
+	adapter family.
diff -Nru a/drivers/scsi/qla2xxx/Makefile b/drivers/scsi/qla2xxx/Makefile
--- a/drivers/scsi/qla2xxx/Makefile	2004-12-08 22:16:47 -08:00
+++ b/drivers/scsi/qla2xxx/Makefile	2004-12-08 22:16:47 -08:00
@@ -8,11 +8,9 @@
 qla2300-y := ql2300.o ql2300_fw.o
 qla2322-y := ql2322.o ql2322_fw.o
 qla6312-y := ql6312.o ql6312_fw.o
-qla6322-y := ql6322.o ql6322_fw.o
 
 obj-$(CONFIG_SCSI_QLA21XX) += qla2xxx.o qla2100.o
 obj-$(CONFIG_SCSI_QLA22XX) += qla2xxx.o qla2200.o
 obj-$(CONFIG_SCSI_QLA2300) += qla2xxx.o qla2300.o
 obj-$(CONFIG_SCSI_QLA2322) += qla2xxx.o qla2322.o
 obj-$(CONFIG_SCSI_QLA6312) += qla2xxx.o qla6312.o
-obj-$(CONFIG_SCSI_QLA6322) += qla2xxx.o qla6322.o
diff -Nru a/drivers/scsi/qla2xxx/ql6312.c b/drivers/scsi/qla2xxx/ql6312.c
--- a/drivers/scsi/qla2xxx/ql6312.c	2004-12-08 22:16:47 -08:00
+++ b/drivers/scsi/qla2xxx/ql6312.c	2004-12-08 22:16:47 -08:00
@@ -35,6 +35,11 @@
 		.isp_name	= "ISP6312",
 		.fw_info	= qla_fw_tbl,
 	},
+	{
+		.drv_name	= qla_driver_name,
+		.isp_name	= "ISP6322",
+		.fw_info	= qla_fw_tbl,
+	},
 };
 
 static struct pci_device_id qla6312_pci_tbl[] = {
@@ -45,6 +50,13 @@
 		.subdevice	= PCI_ANY_ID,
 		.driver_data	= (unsigned long)&qla_board_tbl[0],
 	},
+	{
+		.vendor		= PCI_VENDOR_ID_QLOGIC,
+		.device		= PCI_DEVICE_ID_QLOGIC_ISP6322,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.driver_data	= (unsigned long)&qla_board_tbl[1],
+	},
 	{0, 0},
 };
 MODULE_DEVICE_TABLE(pci, qla6312_pci_tbl);
@@ -85,6 +97,6 @@
 module_exit(qla6312_exit);
 
 MODULE_AUTHOR("QLogic Corporation");
-MODULE_DESCRIPTION("QLogic ISP6312 FC-SCSI Host Bus Adapter driver");
+MODULE_DESCRIPTION("QLogic ISP63xx FC-SCSI Host Bus Adapter driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(QLA2XXX_VERSION);
diff -Nru a/drivers/scsi/qla2xxx/ql6322.c b/drivers/scsi/qla2xxx/ql6322.c
--- a/drivers/scsi/qla2xxx/ql6322.c	2004-12-08 22:16:47 -08:00
+++ /dev/null	Wed Dec 31 16:00:00 196900
@@ -1,108 +0,0 @@
-/*
- * QLogic ISP6322 device driver for Linux 2.6.x
- * Copyright (C) 2003-2004 QLogic Corporation (www.qlogic.com)
- *
- * Released under GPL v2.
- */
-
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/pci.h>
-
-#include "qla_def.h"
-
-static char qla_driver_name[] = "qla6322";
-
-extern unsigned char  fw2322flx_version[];
-extern unsigned char  fw2322flx_version_str[];
-extern unsigned short fw2322flx_addr01;
-extern unsigned short fw2322flx_code01[];
-extern unsigned short fw2322flx_length01;
-extern unsigned long rseqflx_code_addr01;
-extern unsigned short rseqflx_code01[];
-extern unsigned short rseqflx_code_length01;
-extern unsigned long xseqflx_code_addr01;
-extern unsigned short xseqflx_code01[];
-extern unsigned short xseqflx_code_length01;
-
-static struct qla_fw_info qla_fw_tbl[] = {
-	{
-		.addressing	= FW_INFO_ADDR_NORMAL,
-		.fwcode		= &fw2322flx_code01[0],
-		.fwlen		= &fw2322flx_length01,
-		.fwstart	= &fw2322flx_addr01,
-	},
-	{
-		.addressing	= FW_INFO_ADDR_EXTENDED,
-		.fwcode		= &rseqflx_code01[0],
-		.fwlen		= &rseqflx_code_length01,
-		.lfwstart	= &rseqflx_code_addr01,
-	},
-	{
-		.addressing	= FW_INFO_ADDR_EXTENDED,
-		.fwcode		= &xseqflx_code01[0],
-		.fwlen		= &xseqflx_code_length01,
-		.lfwstart	= &xseqflx_code_addr01,
-	},
-	{ FW_INFO_ADDR_NOMORE, },
-};
-
-static struct qla_board_info qla_board_tbl[] = {
-	{
-		.drv_name	= qla_driver_name,
-		.isp_name	= "ISP6322",
-		.fw_info	= qla_fw_tbl,
-	},
-};
-
-static struct pci_device_id qla6322_pci_tbl[] = {
-	{
-		.vendor		= PCI_VENDOR_ID_QLOGIC,
-		.device		= PCI_DEVICE_ID_QLOGIC_ISP6322,
-		.subvendor	= PCI_ANY_ID,
-		.subdevice	= PCI_ANY_ID,
-		.driver_data	= (unsigned long)&qla_board_tbl[0],
-	},
-	{0, 0},
-};
-MODULE_DEVICE_TABLE(pci, qla6322_pci_tbl);
-
-static int __devinit
-qla6322_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
-{
-	return qla2x00_probe_one(pdev,
-	    (struct qla_board_info *)id->driver_data);
-}
-
-static void __devexit
-qla6322_remove_one(struct pci_dev *pdev)
-{
-	qla2x00_remove_one(pdev);
-}
-
-static struct pci_driver qla6322_pci_driver = {
-	.name		= "qla6322",
-	.id_table	= qla6322_pci_tbl,
-	.probe		= qla6322_probe_one,
-	.remove		= __devexit_p(qla6322_remove_one),
-};
-
-static int __init
-qla6322_init(void)
-{
-	return pci_module_init(&qla6322_pci_driver);
-}
-
-static void __exit
-qla6322_exit(void)
-{
-	pci_unregister_driver(&qla6322_pci_driver);
-}
-
-module_init(qla6322_init);
-module_exit(qla6322_exit);
-
-MODULE_AUTHOR("QLogic Corporation");
-MODULE_DESCRIPTION("QLogic ISP6322 FC-SCSI Host Bus Adapter driver");
-MODULE_LICENSE("GPL");
-MODULE_VERSION(QLA2XXX_VERSION);
diff -Nru a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
--- a/drivers/scsi/qla2xxx/qla_def.h	2004-12-08 22:16:47 -08:00
+++ b/drivers/scsi/qla2xxx/qla_def.h	2004-12-08 22:16:47 -08:00
@@ -89,13 +89,9 @@
 
 #if defined(CONFIG_SCSI_QLA6312) || defined(CONFIG_SCSI_QLA6312_MODULE)
 #define IS_QLA6312(ha)	((ha)->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP6312)
-#else
-#define IS_QLA6312(ha)	0
-#endif
-
-#if defined(CONFIG_SCSI_QLA6322) || defined(CONFIG_SCSI_QLA6322_MODULE)
 #define IS_QLA6322(ha)	((ha)->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP6322)
 #else
+#define IS_QLA6312(ha)	0
 #define IS_QLA6322(ha)	0
 #endif
 
