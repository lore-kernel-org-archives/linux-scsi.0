From: "Andrew Vasquez" <andrew.vasquez@qlogic.com>
Subject: [BKPATCH] Updated qla2xxx driver against scsi-misc-2.6.
Date: Fri, 30 Jan 2004 08:59:43 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B179AE41C1147041AA1121F44614F0B060EDFF@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [198.70.193.2] ([198.70.193.2]:13759 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S262353AbUA3Q71 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Jan 2004 11:59:27 -0500
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

James,

I had noticed that the latest scsi-misc-2.6 tree had the initial (large)
patch I submitted to add ISP6312/ISP6322 support.  So, I've uploaded a 
fresh bksend patch against current scsi-misc-2.6.  The changes should
address most of the requests and suggestions made earlier.

The bksend patch can be downloaded from the SF.net site:

	http://prdownloads.sourceforge.net/linux-qla2xxx/qla2xxx-v2.6-20040130.bksend.bz2

I'm still trying to get the hang of using BK, so I hope sending updates
in this way will be suitable.

Here's the list of changes (1.1533 -> 1.1539) and a patch (1.1534 -> 
1.1539 -- minus the firmware file diffs [to reduce the noise]) for review.

Regards,
Andrew Vasquez

----

ChangeSet@1.1539, 2004-01-29 16:11:34-08:00, andrew.vasquez@apc.qlogic.com
  Bump version number -> 8.00.00b10.

ChangeSet@1.1538, 2004-01-29 15:41:00-08:00, andrew.vasquez@apc.qlogic.com
  Use down() not down_interruptible() while waiting for mailbox
  completions.
  
  	o down_interruptible() is the wrong thing to do here 
  	  (in case a signal hits you sooo do the wrong thing
  	  and corrupt the semaphore)
  	  (Arjan van de Ven arjanv_redhat.com)

ChangeSet@1.1537, 2004-01-29 14:39:19-08:00, andrew.vasquez@apc.qlogic.com
  Misc. ISP6312/ISP6322 changes:
  
  	o Asynchronous IOCB handling is not available on 
  	  ISP6312 and ISP6322 type boards.
  
  	o Firmware type (FLX) desgnation fix. 

ChangeSet@1.1536, 2004-01-29 14:19:08-08:00, andrew.vasquez@apc.qlogic.com
  Clean up some extraneous code:
  
  	o Remove duplicate call to qla2x00_config_os().
  	o Remove unused structure member rsvd in struct dev_id.

ChangeSet@1.1535, 2004-01-29 11:16:44-08:00, andrew.vasquez@apc.qlogic.com
  Create single module firmware loaders for each firmware image shipped with the driver (2/2).

ChangeSet@1.1534, 2004-01-29 11:07:17-08:00, andrew.vasquez@apc.qlogic.com
  Create single module firmware loaders for each firmware image shipped with the driver.

ChangeSet@1.1533, 2004-01-29 09:47:28-08:00, andrew.vasquez@apc.qlogic.com
  Resync with latest released firmware 3.02.21.


diff -Nru a/drivers/scsi/qla2xxx/Kconfig b/drivers/scsi/qla2xxx/Kconfig
--- a/drivers/scsi/qla2xxx/Kconfig	Fri Jan 30 08:17:27 2004
+++ b/drivers/scsi/qla2xxx/Kconfig	Fri Jan 30 08:17:27 2004
@@ -15,9 +15,27 @@
 	---help---
 	This driver supports the QLogic 22xx (ISP2200) host adapter family.
 
-config SCSI_QLA23XX
-	tristate "QLogic ISP23xx host adapter family support"
+config SCSI_QLA2300
+	tristate "QLogic ISP2300 host adapter family support"
 	depends on SCSI_QLA2XXX_CONFIG
 	---help---
-	This driver supports the QLogic 23xx (ISP2300, ISP2312, ISP2322, 
-	ISP6312 and ISP6322) host adapter family.
+	This driver supports the QLogic 2300 (ISP2300, and ISP2312) host
+	adapter family.
+
+config SCSI_QLA2322
+	tristate "QLogic ISP2322 host adapter family support"
+	depends on SCSI_QLA2XXX_CONFIG
+	---help---
+	This driver supports the QLogic 2322 (ISP2322) host adapter family.
+
+config SCSI_QLA6312
+	tristate "QLogic ISP6312 host adapter family support"
+	depends on SCSI_QLA2XXX_CONFIG
+	---help---
+	This driver supports the QLogic 6312 (ISP6312) host adapter family.
+
+config SCSI_QLA6322
+	tristate "QLogic ISP6322 host adapter family support"
+	depends on SCSI_QLA2XXX_CONFIG
+	---help---
+	This driver supports the QLogic 6322 (ISP6322) host adapter family.
diff -Nru a/drivers/scsi/qla2xxx/Makefile b/drivers/scsi/qla2xxx/Makefile
--- a/drivers/scsi/qla2xxx/Makefile	Fri Jan 30 08:17:27 2004
+++ b/drivers/scsi/qla2xxx/Makefile	Fri Jan 30 08:17:27 2004
@@ -5,8 +5,14 @@
 
 qla2100-y := ql2100.o ql2100_fw.o
 qla2200-y := ql2200.o ql2200_fw.o
-qla2300-y := ql2300.o ql2300_fw.o ql2322_fw.o ql6312_fw.o ql6322_fw.o
+qla2300-y := ql2300.o ql2300_fw.o
+qla2322-y := ql2322.o ql2322_fw.o
+qla6312-y := ql6312.o ql6312_fw.o
+qla6322-y := ql6322.o ql6322_fw.o
 
 obj-$(CONFIG_SCSI_QLA21XX) += qla2xxx.o qla2100.o
 obj-$(CONFIG_SCSI_QLA22XX) += qla2xxx.o qla2200.o
-obj-$(CONFIG_SCSI_QLA23XX) += qla2xxx.o qla2300.o
+obj-$(CONFIG_SCSI_QLA2300) += qla2xxx.o qla2300.o
+obj-$(CONFIG_SCSI_QLA2322) += qla2xxx.o qla2322.o
+obj-$(CONFIG_SCSI_QLA6312) += qla2xxx.o qla6312.o
+obj-$(CONFIG_SCSI_QLA6322) += qla2xxx.o qla6322.o
diff -Nru a/drivers/scsi/qla2xxx/ql2300.c b/drivers/scsi/qla2xxx/ql2300.c
--- a/drivers/scsi/qla2xxx/ql2300.c	Fri Jan 30 08:17:27 2004
+++ b/drivers/scsi/qla2xxx/ql2300.c	Fri Jan 30 08:17:27 2004
@@ -1,5 +1,5 @@
 /*
- * QLogic ISP23XX device driver for Linux 2.6.x
+ * QLogic ISP2300 device driver for Linux 2.6.x
  * Copyright (C) 2003 Christoph Hellwig.
  * Copyright (C) 2003 QLogic Corporation (www.qlogic.com)
  *
@@ -15,45 +15,13 @@
 
 static char qla_driver_name[] = "qla2300";
 
-/* 2300/2310/2312 Firmware. */
 extern unsigned char  fw2300ipx_version[];
 extern unsigned char  fw2300ipx_version_str[];
 extern unsigned short fw2300ipx_addr01;
 extern unsigned short fw2300ipx_code01[];
 extern unsigned short fw2300ipx_length01;
-/* 2322 Firmware. */
-extern unsigned char  fw2322ipx_version[];
-extern unsigned char  fw2322ipx_version_str[];
-extern unsigned short fw2322ipx_addr01;
-extern unsigned short fw2322ipx_code01[];
-extern unsigned short fw2322ipx_length01;
-extern unsigned long rseqipx_code_addr01;
-extern unsigned short rseqipx_code01[];
-extern unsigned short rseqipx_code_length01;
-extern unsigned long xseqipx_code_addr01;
-extern unsigned short xseqipx_code01[];
-extern unsigned short xseqipx_code_length01;
-/* 6312 Firmware. */
-extern unsigned char  fw2300flx_version[];
-extern unsigned char  fw2300flx_version_str[];
-extern unsigned short fw2300flx_addr01;
-extern unsigned short fw2300flx_code01[];
-extern unsigned short fw2300flx_length01;
-/* 6322 Firmware. */
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
 
 static struct qla_fw_info qla_fw_tbl[] = {
-	/* Start of 23xx firmware list */
 	{
 		.addressing	= FW_INFO_ADDR_NORMAL,
 		.fwcode		= &fw2300ipx_code01[0],
@@ -61,57 +29,6 @@
 		.fwstart	= &fw2300ipx_addr01,
 	},
 	{ FW_INFO_ADDR_NOMORE, },
-
-	/* Start of 232x firmware list */
-	{
-		.addressing	= FW_INFO_ADDR_NORMAL,
-		.fwcode		= &fw2322ipx_code01[0],
-		.fwlen		= &fw2322ipx_length01,
-		.fwstart	= &fw2322ipx_addr01,
-	},
-	{
-		.addressing	= FW_INFO_ADDR_EXTENDED,
-		.fwcode		= &rseqipx_code01[0],
-		.fwlen		= &rseqipx_code_length01,
-		.lfwstart	= &rseqipx_code_addr01,
-	},
-	{
-		.addressing	= FW_INFO_ADDR_EXTENDED,
-		.fwcode		= &xseqipx_code01[0],
-		.fwlen		= &xseqipx_code_length01,
-		.lfwstart	= &xseqipx_code_addr01,
-	},
-	{ FW_INFO_ADDR_NOMORE, },
-
-	/* Start of 631x firmware list */
-	{
-		.addressing	= FW_INFO_ADDR_NORMAL,
-		.fwcode		= &fw2300flx_code01[0],
-		.fwlen		= &fw2300flx_length01,
-		.fwstart	= &fw2300flx_addr01,
-	},
-	{ FW_INFO_ADDR_NOMORE, },
-
-	/* Start of 632x firmware list */
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
 };
 
 static struct qla_board_info qla_board_tbl[] = {
@@ -125,21 +42,6 @@
 		.isp_name	= "ISP2312",
 		.fw_info	= qla_fw_tbl,
 	},
-	{
-		.drv_name	= qla_driver_name,
-		.isp_name	= "ISP2322",
-		.fw_info	= &qla_fw_tbl[2],
-	},
-	{
-		.drv_name	= qla_driver_name,
-		.isp_name	= "ISP6312",
-		.fw_info	= &qla_fw_tbl[6],
-	},
-	{
-		.drv_name	= qla_driver_name,
-		.isp_name	= "ISP6322",
-		.fw_info	= &qla_fw_tbl[8],
-	},
 };
 
 static struct pci_device_id qla2300_pci_tbl[] = {
@@ -157,27 +59,6 @@
 		.subdevice	= PCI_ANY_ID,
 		.driver_data	= (unsigned long)&qla_board_tbl[1],
 	},
-	{
-		.vendor		= PCI_VENDOR_ID_QLOGIC,
-		.device		= PCI_DEVICE_ID_QLOGIC_ISP2322,
-		.subvendor	= PCI_ANY_ID,
-		.subdevice	= PCI_ANY_ID,
-		.driver_data	= (unsigned long)&qla_board_tbl[2],
-	},
-	{
-		.vendor		= PCI_VENDOR_ID_QLOGIC,
-		.device		= PCI_DEVICE_ID_QLOGIC_ISP6312,
-		.subvendor	= PCI_ANY_ID,
-		.subdevice	= PCI_ANY_ID,
-		.driver_data	= (unsigned long)&qla_board_tbl[3],
-	},
-	{
-		.vendor		= PCI_VENDOR_ID_QLOGIC,
-		.device		= PCI_DEVICE_ID_QLOGIC_ISP6322,
-		.subvendor	= PCI_ANY_ID,
-		.subdevice	= PCI_ANY_ID,
-		.driver_data	= (unsigned long)&qla_board_tbl[4],
-	},
 	{0, 0},
 };
 MODULE_DEVICE_TABLE(pci, qla2300_pci_tbl);
@@ -218,5 +99,5 @@
 module_exit(qla2300_exit);
 
 MODULE_AUTHOR("QLogic Corporation");
-MODULE_DESCRIPTION("QLogic ISP23xx FC-SCSI Host Bus Adapter driver");
+MODULE_DESCRIPTION("QLogic ISP2300 FC-SCSI Host Bus Adapter driver");
 MODULE_LICENSE("GPL");
diff -Nru a/drivers/scsi/qla2xxx/ql2322.c b/drivers/scsi/qla2xxx/ql2322.c
--- /dev/null	Wed Dec 31 16:00:00 1969
+++ b/drivers/scsi/qla2xxx/ql2322.c	Fri Jan 30 08:17:27 2004
@@ -0,0 +1,108 @@
+/*
+ * QLogic ISP2322 device driver for Linux 2.6.x
+ * Copyright (C) 2003 QLogic Corporation (www.qlogic.com)
+ *
+ * Released under GPL v2.
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+
+#include "qla_os.h"
+#include "qla_def.h"
+
+static char qla_driver_name[] = "qla2322";
+
+extern unsigned char  fw2322ipx_version[];
+extern unsigned char  fw2322ipx_version_str[];
+extern unsigned short fw2322ipx_addr01;
+extern unsigned short fw2322ipx_code01[];
+extern unsigned short fw2322ipx_length01;
+extern unsigned long rseqipx_code_addr01;
+extern unsigned short rseqipx_code01[];
+extern unsigned short rseqipx_code_length01;
+extern unsigned long xseqipx_code_addr01;
+extern unsigned short xseqipx_code01[];
+extern unsigned short xseqipx_code_length01;
+
+static struct qla_fw_info qla_fw_tbl[] = {
+	{
+		.addressing	= FW_INFO_ADDR_NORMAL,
+		.fwcode		= &fw2322ipx_code01[0],
+		.fwlen		= &fw2322ipx_length01,
+		.fwstart	= &fw2322ipx_addr01,
+	},
+	{
+		.addressing	= FW_INFO_ADDR_EXTENDED,
+		.fwcode		= &rseqipx_code01[0],
+		.fwlen		= &rseqipx_code_length01,
+		.lfwstart	= &rseqipx_code_addr01,
+	},
+	{
+		.addressing	= FW_INFO_ADDR_EXTENDED,
+		.fwcode		= &xseqipx_code01[0],
+		.fwlen		= &xseqipx_code_length01,
+		.lfwstart	= &xseqipx_code_addr01,
+	},
+	{ FW_INFO_ADDR_NOMORE, },
+};
+
+static struct qla_board_info qla_board_tbl[] = {
+	{
+		.drv_name	= qla_driver_name,
+		.isp_name	= "ISP2322",
+		.fw_info	= qla_fw_tbl,
+	},
+};
+
+static struct pci_device_id qla2322_pci_tbl[] = {
+	{
+		.vendor		= PCI_VENDOR_ID_QLOGIC,
+		.device		= PCI_DEVICE_ID_QLOGIC_ISP2322,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.driver_data	= (unsigned long)&qla_board_tbl[0],
+	},
+	{0, 0},
+};
+MODULE_DEVICE_TABLE(pci, qla2322_pci_tbl);
+
+static int __devinit
+qla2322_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	return qla2x00_probe_one(pdev,
+	    (struct qla_board_info *)id->driver_data);
+}
+
+static void __devexit
+qla2322_remove_one(struct pci_dev *pdev)
+{
+	qla2x00_remove_one(pdev);
+}
+
+static struct pci_driver qla2322_pci_driver = {
+	.name		= "qla2322",
+	.id_table	= qla2322_pci_tbl,
+	.probe		= qla2322_probe_one,
+	.remove		= __devexit_p(qla2322_remove_one),
+};
+
+static int __init
+qla2322_init(void)
+{
+	return pci_module_init(&qla2322_pci_driver);
+}
+
+static void __exit
+qla2322_exit(void)
+{
+	pci_unregister_driver(&qla2322_pci_driver);
+}
+
+module_init(qla2322_init);
+module_exit(qla2322_exit);
+
+MODULE_AUTHOR("QLogic Corporation");
+MODULE_DESCRIPTION("QLogic ISP2322 FC-SCSI Host Bus Adapter driver");
+MODULE_LICENSE("GPL");
diff -Nru a/drivers/scsi/qla2xxx/ql6312.c b/drivers/scsi/qla2xxx/ql6312.c
--- /dev/null	Wed Dec 31 16:00:00 1969
+++ b/drivers/scsi/qla2xxx/ql6312.c	Fri Jan 30 08:17:27 2004
@@ -0,0 +1,90 @@
+/*
+ * QLogic ISP6312 device driver for Linux 2.6.x
+ * Copyright (C) 2003 QLogic Corporation (www.qlogic.com)
+ *
+ * Released under GPL v2.
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+
+#include "qla_os.h"
+#include "qla_def.h"
+
+static char qla_driver_name[] = "qla6312";
+
+extern unsigned char  fw2300flx_version[];
+extern unsigned char  fw2300flx_version_str[];
+extern unsigned short fw2300flx_addr01;
+extern unsigned short fw2300flx_code01[];
+extern unsigned short fw2300flx_length01;
+
+static struct qla_fw_info qla_fw_tbl[] = {
+	{
+		.addressing	= FW_INFO_ADDR_NORMAL,
+		.fwcode		= &fw2300flx_code01[0],
+		.fwlen		= &fw2300flx_length01,
+		.fwstart	= &fw2300flx_addr01,
+	},
+	{ FW_INFO_ADDR_NOMORE, },
+};
+
+static struct qla_board_info qla_board_tbl[] = {
+	{
+		.drv_name	= qla_driver_name,
+		.isp_name	= "ISP6312",
+		.fw_info	= qla_fw_tbl,
+	},
+};
+
+static struct pci_device_id qla6312_pci_tbl[] = {
+	{
+		.vendor		= PCI_VENDOR_ID_QLOGIC,
+		.device		= PCI_DEVICE_ID_QLOGIC_ISP6312,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.driver_data	= (unsigned long)&qla_board_tbl[0],
+	},
+	{0, 0},
+};
+MODULE_DEVICE_TABLE(pci, qla6312_pci_tbl);
+
+static int __devinit
+qla6312_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	return qla2x00_probe_one(pdev,
+	    (struct qla_board_info *)id->driver_data);
+}
+
+static void __devexit
+qla6312_remove_one(struct pci_dev *pdev)
+{
+	qla2x00_remove_one(pdev);
+}
+
+static struct pci_driver qla6312_pci_driver = {
+	.name		= "qla6312",
+	.id_table	= qla6312_pci_tbl,
+	.probe		= qla6312_probe_one,
+	.remove		= __devexit_p(qla6312_remove_one),
+};
+
+static int __init
+qla6312_init(void)
+{
+	return pci_module_init(&qla6312_pci_driver);
+}
+
+static void __exit
+qla6312_exit(void)
+{
+	pci_unregister_driver(&qla6312_pci_driver);
+}
+
+module_init(qla6312_init);
+module_exit(qla6312_exit);
+
+MODULE_AUTHOR("QLogic Corporation");
+MODULE_DESCRIPTION("QLogic ISP6312 FC-SCSI Host Bus Adapter driver");
+MODULE_LICENSE("GPL");
diff -Nru a/drivers/scsi/qla2xxx/ql6322.c b/drivers/scsi/qla2xxx/ql6322.c
--- /dev/null	Wed Dec 31 16:00:00 1969
+++ b/drivers/scsi/qla2xxx/ql6322.c	Fri Jan 30 08:17:27 2004
@@ -0,0 +1,108 @@
+/*
+ * QLogic ISP6322 device driver for Linux 2.6.x
+ * Copyright (C) 2003 QLogic Corporation (www.qlogic.com)
+ *
+ * Released under GPL v2.
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+
+#include "qla_os.h"
+#include "qla_def.h"
+
+static char qla_driver_name[] = "qla6322";
+
+extern unsigned char  fw2322flx_version[];
+extern unsigned char  fw2322flx_version_str[];
+extern unsigned short fw2322flx_addr01;
+extern unsigned short fw2322flx_code01[];
+extern unsigned short fw2322flx_length01;
+extern unsigned long rseqflx_code_addr01;
+extern unsigned short rseqflx_code01[];
+extern unsigned short rseqflx_code_length01;
+extern unsigned long xseqflx_code_addr01;
+extern unsigned short xseqflx_code01[];
+extern unsigned short xseqflx_code_length01;
+
+static struct qla_fw_info qla_fw_tbl[] = {
+	{
+		.addressing	= FW_INFO_ADDR_NORMAL,
+		.fwcode		= &fw2322flx_code01[0],
+		.fwlen		= &fw2322flx_length01,
+		.fwstart	= &fw2322flx_addr01,
+	},
+	{
+		.addressing	= FW_INFO_ADDR_EXTENDED,
+		.fwcode		= &rseqflx_code01[0],
+		.fwlen		= &rseqflx_code_length01,
+		.lfwstart	= &rseqflx_code_addr01,
+	},
+	{
+		.addressing	= FW_INFO_ADDR_EXTENDED,
+		.fwcode		= &xseqflx_code01[0],
+		.fwlen		= &xseqflx_code_length01,
+		.lfwstart	= &xseqflx_code_addr01,
+	},
+	{ FW_INFO_ADDR_NOMORE, },
+};
+
+static struct qla_board_info qla_board_tbl[] = {
+	{
+		.drv_name	= qla_driver_name,
+		.isp_name	= "ISP6322",
+		.fw_info	= qla_fw_tbl,
+	},
+};
+
+static struct pci_device_id qla6322_pci_tbl[] = {
+	{
+		.vendor		= PCI_VENDOR_ID_QLOGIC,
+		.device		= PCI_DEVICE_ID_QLOGIC_ISP6322,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.driver_data	= (unsigned long)&qla_board_tbl[0],
+	},
+	{0, 0},
+};
+MODULE_DEVICE_TABLE(pci, qla6322_pci_tbl);
+
+static int __devinit
+qla6322_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	return qla2x00_probe_one(pdev,
+	    (struct qla_board_info *)id->driver_data);
+}
+
+static void __devexit
+qla6322_remove_one(struct pci_dev *pdev)
+{
+	qla2x00_remove_one(pdev);
+}
+
+static struct pci_driver qla6322_pci_driver = {
+	.name		= "qla6322",
+	.id_table	= qla6322_pci_tbl,
+	.probe		= qla6322_probe_one,
+	.remove		= __devexit_p(qla6322_remove_one),
+};
+
+static int __init
+qla6322_init(void)
+{
+	return pci_module_init(&qla6322_pci_driver);
+}
+
+static void __exit
+qla6322_exit(void)
+{
+	pci_unregister_driver(&qla6322_pci_driver);
+}
+
+module_init(qla6322_init);
+module_exit(qla6322_exit);
+
+MODULE_AUTHOR("QLogic Corporation");
+MODULE_DESCRIPTION("QLogic ISP6322 FC-SCSI Host Bus Adapter driver");
+MODULE_LICENSE("GPL");
diff -Nru a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
--- a/drivers/scsi/qla2xxx/qla_def.h	Fri Jan 30 08:17:27 2004
+++ b/drivers/scsi/qla2xxx/qla_def.h	Fri Jan 30 08:17:27 2004
@@ -53,22 +53,34 @@
 #define IS_QLA2200(ha)	0
 #endif
 
-#if defined(CONFIG_SCSI_QLA23XX) || defined(CONFIG_SCSI_QLA23XX_MODULE)
+#if defined(CONFIG_SCSI_QLA2300) || defined(CONFIG_SCSI_QLA2300_MODULE)
 #define IS_QLA2300(ha)	((ha)->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2300)
 #define IS_QLA2312(ha)	((ha)->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2312)
-#define IS_QLA2322(ha)	((ha)->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2322)
-#define IS_QLA6312(ha)	((ha)->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP6312)
-#define IS_QLA6322(ha)	((ha)->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP6322)
-#define IS_QLA23XX(ha)	(IS_QLA2300(ha) || IS_QLA2312(ha) || IS_QLA2322(ha) || \
-    			 IS_QLA6312(ha) || IS_QLA6322(ha))
 #else
 #define IS_QLA2300(ha)	0
 #define IS_QLA2312(ha)	0
+#endif
+
+#if defined(CONFIG_SCSI_QLA2322) || defined(CONFIG_SCSI_QLA2322_MODULE)
+#define IS_QLA2322(ha)	((ha)->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2322)
+#else
 #define IS_QLA2322(ha)	0
+#endif
+
+#if defined(CONFIG_SCSI_QLA6312) || defined(CONFIG_SCSI_QLA6312_MODULE)
+#define IS_QLA6312(ha)	((ha)->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP6312)
+#else
 #define IS_QLA6312(ha)	0
+#endif
+
+#if defined(CONFIG_SCSI_QLA6322) || defined(CONFIG_SCSI_QLA6322_MODULE)
+#define IS_QLA6322(ha)	((ha)->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP6322)
+#else
 #define IS_QLA6322(ha)	0
-#define IS_QLA23XX(ha)	0
 #endif
+
+#define IS_QLA23XX(ha)	(IS_QLA2300(ha) || IS_QLA2312(ha) || IS_QLA2322(ha) || \
+    			 IS_QLA6312(ha) || IS_QLA6322(ha))
 
 /*
  * Only non-ISP2[12]00 have extended addressing support in the firmware.
diff -Nru a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
--- a/drivers/scsi/qla2xxx/qla_init.c	Fri Jan 30 08:17:27 2004
+++ b/drivers/scsi/qla2xxx/qla_init.c	Fri Jan 30 08:17:27 2004
@@ -1572,8 +1572,6 @@
 
 		qla2x00_config_os(ha);
 
-		qla2x00_config_os(ha);
-
 		/* If we found all devices then go ready */
 		if (!(test_bit(LOGIN_RETRY_NEEDED, &ha->dpc_flags))) {
 			atomic_set(&ha->loop_state, LOOP_READY);
@@ -1632,7 +1630,6 @@
 		uint8_t	domain;		
 		uint8_t	loop_id_2100;	/* ISP2100/ISP2200 -- 4 bytes. */
 		uint16_t loop_id;	/* ISP23XX         -- 6 bytes. */
-		uint16_t rsvd;		/* ISP2XXX         -- 8 bytes. */
 	} *id_list;
 #define MAX_ID_LIST_SIZE (sizeof(struct dev_id) * MAX_FIBRE_DEVICES)
 	dma_addr_t	id_list_dma;
@@ -2805,6 +2802,7 @@
 		switch (format) {
 		case 0:
 			if (!IS_QLA2100(ha) && !IS_QLA2200(ha) &&
+			    !IS_QLA6312(ha) && !IS_QLA6322(ha) &&
 			    ha->flags.init_done) {
 				/* Handle port RSCN via asyncronous IOCBs */
 				rval2 = qla2x00_handle_port_rscn(ha, rscn_entry,
diff -Nru a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
--- a/drivers/scsi/qla2xxx/qla_isr.c	Fri Jan 30 08:17:27 2004
+++ b/drivers/scsi/qla2xxx/qla_isr.c	Fri Jan 30 08:17:27 2004
@@ -545,8 +545,8 @@
 		 * us, create a new entry in our rscn fcports list and handle
 		 * the event like an RSCN.
 		 */
-		if (!IS_QLA2100(ha) && !IS_QLA2200(ha) &&
-		    ha->flags.init_done && mb[1] != 0xffff &&
+		if (!IS_QLA2100(ha) && !IS_QLA2200(ha) && !IS_QLA6312(ha) &&
+		    !IS_QLA6322(ha) && ha->flags.init_done && mb[1] != 0xffff &&
 		    ((ha->operating_mode == P2P && mb[1] != 0) ||
 		    (ha->operating_mode != P2P && mb[1] !=
 			SNS_FIRST_LOOP_ID)) && (mb[2] == 6 || mb[2] == 7)) {
@@ -774,7 +774,8 @@
 			qla2x00_ms_entry(ha, (ms_iocb_entry_t *)pkt);
 			break;
 		case MBX_IOCB_TYPE:
-			if (!IS_QLA2100(ha) && !IS_QLA2200(ha)) {
+			if (!IS_QLA2100(ha) && !IS_QLA2200(ha) &&
+			    !IS_QLA6312(ha) && !IS_QLA6322(ha)) {
 				if (pkt->sys_define == SOURCE_ASYNC_IOCB) {
 					qla2x00_process_iodesc(ha,
 					    (struct mbx_entry *)pkt);
diff -Nru a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
--- a/drivers/scsi/qla2xxx/qla_mbx.c	Fri Jan 30 08:17:27 2004
+++ b/drivers/scsi/qla2xxx/qla_mbx.c	Fri Jan 30 08:17:27 2004
@@ -175,7 +175,7 @@
 		/* Wait for either the timer to expire
 		 * or the mbox completion interrupt
 		 */
-		down_interruptible(&ha->mbx_intr_sem);
+		down(&ha->mbx_intr_sem);
 
 		DEBUG11(printk("qla2x00_mailbox_command:"
 		    "waking up."
diff -Nru a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c	Fri Jan 30 08:17:27 2004
+++ b/drivers/scsi/qla2xxx/qla_os.c	Fri Jan 30 08:17:27 2004
@@ -643,8 +643,7 @@
 	    ha->fw_minor_version,
 	    ha->fw_subminor_version);
 
-	/* Workaround till firmware fix. */
-	if (IS_QLA6312(ha) || IS_QLA6322(ha)) {
+	if (ha->fw_attributes & BIT_9) {
 		strcat(str, "FLX");
 		return (str);
 	}
diff -Nru a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
--- a/drivers/scsi/qla2xxx/qla_version.h	Fri Jan 30 08:17:27 2004
+++ b/drivers/scsi/qla2xxx/qla_version.h	Fri Jan 30 08:17:27 2004
@@ -19,9 +19,9 @@
 /*
  * Driver version 
  */
-#define QLA2XXX_VERSION      "8.00.00b8"
+#define QLA2XXX_VERSION      "8.00.00b10"
 
 #define QLA_DRIVER_MAJOR_VER	8
 #define QLA_DRIVER_MINOR_VER	0
 #define QLA_DRIVER_PATCH_VER	0
-#define QLA_DRIVER_BETA_VER	8
+#define QLA_DRIVER_BETA_VER	10
