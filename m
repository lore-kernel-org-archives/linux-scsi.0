From: Joe Perches <joe@perches.com>
Subject: [PATCH 14/19] drivers/scsi: Use PCI_VDEVICE
Date: Wed, 24 Jun 2009 22:13:30 -0700
Message-ID: <079fbc10b41dd4b7f0d381b7e969134184652c95.1245906152.git.joe@perches.com>
References: <cover.1245906151.git.joe@perches.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1469 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046AbZFYFOJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Jun 2009 01:14:09 -0400
In-Reply-To: <cover.1245906151.git.joe@perches.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Adam Radford <linuxraid@amcc.com>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, Adaptec OEM Raid Solutions <aacraid@adaptec.com>, Rik Faith <faith@cs.unc.edu>, Neela Syam Kolli <megaraidlinux@lsi.com>, Willem Riede <osst@riede.org>, =?utf-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>, Matthew Wilcox <matthew@wil.cx>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, Kurt Garloff <garloff@suse.de>, linux-scsi@vger.kernel.org, osst-users@lists.sourceforge.net

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/3w-9xxx.c              |   12 +++------
 drivers/scsi/3w-xxxx.c              |    6 +---
 drivers/scsi/BusLogic.c             |    9 ++----
 drivers/scsi/a100u2w.c              |    2 +-
 drivers/scsi/aacraid/linit.c        |    6 ++--
 drivers/scsi/dmx3191d.c             |    3 +-
 drivers/scsi/fdomain.c              |    3 +-
 drivers/scsi/initio.c               |   20 +++++++-------
 drivers/scsi/megaraid.c             |    9 ++----
 drivers/scsi/qla1280.c              |   18 ++++---------
 drivers/scsi/stex.c                 |   18 +++++--------
 drivers/scsi/sym53c8xx_2/sym_glue.c |   45 +++++++++++-----------------------
 drivers/scsi/tmscsim.c              |    3 +-
 13 files changed, 57 insertions(+), 97 deletions(-)

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index 36c21b1..eff7307 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -2278,14 +2278,10 @@ out_disable_device:
 
 /* PCI Devices supported by this driver */
 static struct pci_device_id twa_pci_tbl[] __devinitdata = {
-	{ PCI_VENDOR_ID_3WARE, PCI_DEVICE_ID_3WARE_9000,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{ PCI_VENDOR_ID_3WARE, PCI_DEVICE_ID_3WARE_9550SX,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{ PCI_VENDOR_ID_3WARE, PCI_DEVICE_ID_3WARE_9650SE,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{ PCI_VENDOR_ID_3WARE, PCI_DEVICE_ID_3WARE_9690SA,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{ PCI_VDEVICE(3WARE, PCI_DEVICE_ID_3WARE_9000), 0},
+	{ PCI_VDEVICE(3WARE, PCI_DEVICE_ID_3WARE_9550SX), 0},
+	{ PCI_VDEVICE(3WARE, PCI_DEVICE_ID_3WARE_9650SE), 0},
+	{ PCI_VDEVICE(3WARE, PCI_DEVICE_ID_3WARE_9690SA), 0},
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, twa_pci_tbl);
diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index faa0fcf..bb6f53d 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -2400,10 +2400,8 @@ static void tw_remove(struct pci_dev *pdev)
 
 /* PCI Devices supported by this driver */
 static struct pci_device_id tw_pci_tbl[] __devinitdata = {
-	{ PCI_VENDOR_ID_3WARE, PCI_DEVICE_ID_3WARE_1000,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{ PCI_VENDOR_ID_3WARE, PCI_DEVICE_ID_3WARE_7000,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{ PCI_VDEVICE(3WARE, PCI_DEVICE_ID_3WARE_1000), 0},
+	{ PCI_VDEVICE(3WARE, PCI_DEVICE_ID_3WARE_7000), 0},
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, tw_pci_tbl);
diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index 1ddcf40..fad02a1 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -3615,12 +3615,9 @@ __setup("BusLogic=", BusLogic_Setup);
 
 #ifdef MODULE
 static struct pci_device_id BusLogic_pci_tbl[] __devinitdata = {
-	{ PCI_VENDOR_ID_BUSLOGIC, PCI_DEVICE_ID_BUSLOGIC_MULTIMASTER,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{ PCI_VENDOR_ID_BUSLOGIC, PCI_DEVICE_ID_BUSLOGIC_MULTIMASTER_NC,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{ PCI_VENDOR_ID_BUSLOGIC, PCI_DEVICE_ID_BUSLOGIC_FLASHPOINT,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{ PCI_VDEVICE(BUSLOGIC, PCI_DEVICE_ID_BUSLOGIC_MULTIMASTER), 0},
+	{ PCI_VDEVICE(BUSLOGIC, PCI_DEVICE_ID_BUSLOGIC_MULTIMASTER_NC), 0},
+	{ PCI_VDEVICE(BUSLOGIC, PCI_DEVICE_ID_BUSLOGIC_FLASHPOINT), 0},
 	{ }
 };
 #endif
diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
index 208d6df..d05ecd5 100644
--- a/drivers/scsi/a100u2w.c
+++ b/drivers/scsi/a100u2w.c
@@ -1214,7 +1214,7 @@ static void __devexit inia100_remove_one(struct pci_dev *pdev)
 } 
 
 static struct pci_device_id inia100_pci_tbl[] = {
-	{PCI_VENDOR_ID_INIT, 0x1060, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_VDEVICE(INIT, 0x1060), 0},
 	{0,}
 };
 MODULE_DEVICE_TABLE(pci, inia100_pci_tbl);
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 9b97c3e..d0461ab 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -157,9 +157,9 @@ static const struct pci_device_id aac_pci_tbl[] __devinitdata = {
 
 	{ 0x9005, 0x0285, 0x1028, PCI_ANY_ID, 0, 0, 57 }, /* Dell Catchall */
 	{ 0x9005, 0x0285, 0x17aa, PCI_ANY_ID, 0, 0, 58 }, /* Legend Catchall */
-	{ 0x9005, 0x0285, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 59 }, /* Adaptec Catch All */
-	{ 0x9005, 0x0286, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 60 }, /* Adaptec Rocket Catch All */
-	{ 0x9005, 0x0288, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 61 }, /* Adaptec NEMER/ARK Catch All */
+	{ PCI_VDEVICE(ADAPTEC2, 0x0285), 59 }, /* Adaptec Catch All */
+	{ PCI_VDEVICE(ADAPTEC2, 0x0286), 60 }, /* Adaptec Rocket Catch All */
+	{ PCI_VDEVICE(ADAPTEC2, 0x0288), 61 }, /* Adaptec NEMER/ARK Catch All */
 	{ 0,}
 };
 MODULE_DEVICE_TABLE(pci, aac_pci_tbl);
diff --git a/drivers/scsi/dmx3191d.c b/drivers/scsi/dmx3191d.c
index fa738ec..c7bac47 100644
--- a/drivers/scsi/dmx3191d.c
+++ b/drivers/scsi/dmx3191d.c
@@ -140,8 +140,7 @@ static void __devexit dmx3191d_remove_one(struct pci_dev *pdev)
 }
 
 static struct pci_device_id dmx3191d_pci_tbl[] = {
-	{PCI_VENDOR_ID_DOMEX, PCI_DEVICE_ID_DOMEX_DMX3191D,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 4},
+	{PCI_VDEVICE(DOMEX, PCI_DEVICE_ID_DOMEX_DMX3191D), 4},
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, dmx3191d_pci_tbl);
diff --git a/drivers/scsi/fdomain.c b/drivers/scsi/fdomain.c
index 32eef66..d31104a 100644
--- a/drivers/scsi/fdomain.c
+++ b/drivers/scsi/fdomain.c
@@ -1770,8 +1770,7 @@ struct scsi_host_template fdomain_driver_template = {
 #ifdef CONFIG_PCI
 
 static struct pci_device_id fdomain_pci_tbl[] __devinitdata = {
-	{ PCI_VENDOR_ID_FD, PCI_DEVICE_ID_FD_36C70,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
+	{ PCI_VDEVICE(FD, PCI_DEVICE_ID_FD_36C70), 0UL },
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, fdomain_pci_tbl);
diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index 89a5948..069ecb1 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -129,11 +129,11 @@ static void i91uSCBPost(u8 * pHcb, u8 * pScb);
 
 /* PCI Devices supported by this driver */
 static struct pci_device_id i91u_pci_devices[] = {
-	{ PCI_VENDOR_ID_INIT,  I950_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{ PCI_VENDOR_ID_INIT,  I940_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{ PCI_VENDOR_ID_INIT,  I935_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{ PCI_VENDOR_ID_INIT,  I920_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{ PCI_VENDOR_ID_DOMEX, I920_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{ PCI_VDEVICE(INIT, I950_DEVICE_ID), 0},
+	{ PCI_VDEVICE(INIT, I940_DEVICE_ID), 0},
+	{ PCI_VDEVICE(INIT, I935_DEVICE_ID), 0},
+	{ PCI_VDEVICE(INIT, I920_DEVICE_ID), 0},
+	{ PCI_VDEVICE(DOMEX, I920_DEVICE_ID), 0},
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, i91u_pci_devices);
@@ -2978,11 +2978,11 @@ static void initio_remove_one(struct pci_dev *pdev)
 MODULE_LICENSE("GPL");
 
 static struct pci_device_id initio_pci_tbl[] = {
-	{PCI_VENDOR_ID_INIT, 0x9500, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{PCI_VENDOR_ID_INIT, 0x9400, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{PCI_VENDOR_ID_INIT, 0x9401, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{PCI_VENDOR_ID_INIT, 0x0002, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{PCI_VENDOR_ID_DOMEX, 0x0002, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_VDEVICE(INIT, 0x9500), 0},
+	{PCI_VDEVICE(INIT, 0x9400), 0},
+	{PCI_VDEVICE(INIT, 0x9401), 0},
+	{PCI_VDEVICE(INIT, 0x0002), 0},
+	{PCI_VDEVICE(DOMEX, 0x0002), 0},
 	{0,}
 };
 MODULE_DEVICE_TABLE(pci, initio_pci_tbl);
diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 49eb061..956b991 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -4974,12 +4974,9 @@ megaraid_shutdown(struct pci_dev *pdev)
 }
 
 static struct pci_device_id megaraid_pci_tbl[] = {
-	{PCI_VENDOR_ID_AMI, PCI_DEVICE_ID_AMI_MEGARAID,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{PCI_VENDOR_ID_AMI, PCI_DEVICE_ID_AMI_MEGARAID2,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_AMI_MEGARAID3,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_VDEVICE(AMI, PCI_DEVICE_ID_AMI_MEGARAID), 0},
+	{PCI_VDEVICE(AMI, PCI_DEVICE_ID_AMI_MEGARAID2), 0},
+	{PCI_VDEVICE(INTEL, PCI_DEVICE_ID_AMI_MEGARAID3), 0},
 	{0,}
 };
 MODULE_DEVICE_TABLE(pci, megaraid_pci_tbl);
diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 8371d91..e6332b4 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -545,18 +545,12 @@ struct qla_boards {
 
 /* NOTE: the last argument in each entry is used to index ql1280_board_tbl */
 static struct pci_device_id qla1280_pci_tbl[] = {
-	{PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP12160,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP1020,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 1},
-	{PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP1080,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 2},
-	{PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP1240,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 3},
-	{PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP1280,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 4},
-	{PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP10160,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 5},
+	{PCI_VDEVICE(QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP12160), 0},
+	{PCI_VDEVICE(QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP1020), 1},
+	{PCI_VDEVICE(QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP1080), 2},
+	{PCI_VDEVICE(QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP1240), 3},
+	{PCI_VDEVICE(QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP1280), 4},
+	{PCI_VDEVICE(QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP10160), 5},
 	{0,}
 };
 MODULE_DEVICE_TABLE(pci, qla1280_pci_tbl);
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 8d2a95c..31b383a 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -1300,27 +1300,23 @@ static struct scsi_host_template driver_template = {
 
 static struct pci_device_id stex_pci_tbl[] = {
 	/* st_shasta */
-	{ 0x105a, 0x8350, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		st_shasta }, /* SuperTrak EX8350/8300/16350/16300 */
-	{ 0x105a, 0xc350, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		st_shasta }, /* SuperTrak EX12350 */
-	{ 0x105a, 0x4302, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		st_shasta }, /* SuperTrak EX4350 */
-	{ 0x105a, 0xe350, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		st_shasta }, /* SuperTrak EX24350 */
+	{ PCI_VDEVICE(PROMISE, 0x8350), st_shasta }, /* SuperTrak EX8350/8300/16350/16300 */
+	{ PCI_VDEVICE(PROMISE, 0xc350), st_shasta }, /* SuperTrak EX12350 */
+	{ PCI_VDEVICE(PROMISE, 0x4302), st_shasta }, /* SuperTrak EX4350 */
+	{ PCI_VDEVICE(PROMISE, 0xe350), st_shasta }, /* SuperTrak EX24350 */
 
 	/* st_vsc */
-	{ 0x105a, 0x7250, PCI_ANY_ID, PCI_ANY_ID, 0, 0, st_vsc },
+	{ PCI_VDEVICE(PROMISE, 0x7250), st_vsc },
 
 	/* st_yosemite */
 	{ 0x105a, 0x8650, 0x105a, PCI_ANY_ID, 0, 0, st_yosemite },
 
 	/* st_seq */
-	{ 0x105a, 0x3360, PCI_ANY_ID, PCI_ANY_ID, 0, 0, st_seq },
+	{ PCI_VDEVICE(PROMISE, 0x3360), st_seq },
 
 	/* st_yel */
 	{ 0x105a, 0x8650, 0x1033, PCI_ANY_ID, 0, 0, st_yel },
-	{ 0x105a, 0x8760, PCI_ANY_ID, PCI_ANY_ID, 0, 0, st_yel },
+	{ PCI_VDEVICE(PROMISE, 0x8760), st_yel },
 	{ }	/* terminate list */
 };
 
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 45374d6..3d6f83c 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -2072,40 +2072,25 @@ static struct spi_function_template sym2_transport_functions = {
 };
 
 static struct pci_device_id sym2_id_table[] __devinitdata = {
-	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_NCR_53C810,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
-	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_NCR_53C820,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL }, /* new */
-	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_NCR_53C825,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
-	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_NCR_53C815,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
-	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_53C810AP,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL }, /* new */
-	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_NCR_53C860,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
+	{ PCI_VDEVICE(LSI_LOGIC, PCI_DEVICE_ID_NCR_53C810), 0UL },
+	{ PCI_VDEVICE(LSI_LOGIC, PCI_DEVICE_ID_NCR_53C820), 0UL }, /* new */
+	{ PCI_VDEVICE(LSI_LOGIC, PCI_DEVICE_ID_NCR_53C825), 0UL },
+	{ PCI_VDEVICE(LSI_LOGIC, PCI_DEVICE_ID_NCR_53C815), 0UL },
+	{ PCI_VDEVICE(LSI_LOGIC, PCI_DEVICE_ID_LSI_53C810AP), 0UL }, /* new */
+	{ PCI_VDEVICE(LSI_LOGIC, PCI_DEVICE_ID_NCR_53C860), 0UL },
 	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_53C1510,
 	  PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_STORAGE_SCSI<<8,  0xffff00, 0UL },
-	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_NCR_53C896,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
-	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_NCR_53C895,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
-	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_NCR_53C885,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
-	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_NCR_53C875,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
+	{ PCI_VDEVICE(LSI_LOGIC, PCI_DEVICE_ID_NCR_53C896), 0UL },
+	{ PCI_VDEVICE(LSI_LOGIC, PCI_DEVICE_ID_NCR_53C895), 0UL },
+	{ PCI_VDEVICE(LSI_LOGIC, PCI_DEVICE_ID_NCR_53C885), 0UL },
+	{ PCI_VDEVICE(LSI_LOGIC, PCI_DEVICE_ID_NCR_53C875), 0UL },
 	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_NCR_53C1510,
 	  PCI_ANY_ID, PCI_ANY_ID,  PCI_CLASS_STORAGE_SCSI<<8,  0xffff00, 0UL }, /* new */
-	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_53C895A,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
-	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_53C875A,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
-	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_53C1010_33,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
-	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_53C1010_66,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
-	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_NCR_53C875J,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
+	{ PCI_VDEVICE(LSI_LOGIC, PCI_DEVICE_ID_LSI_53C895A), 0UL },
+	{ PCI_VDEVICE(LSI_LOGIC, PCI_DEVICE_ID_LSI_53C875A), 0UL },
+	{ PCI_VDEVICE(LSI_LOGIC, PCI_DEVICE_ID_LSI_53C1010_33), 0UL },
+	{ PCI_VDEVICE(LSI_LOGIC, PCI_DEVICE_ID_LSI_53C1010_66), 0UL },
+	{ PCI_VDEVICE(LSI_LOGIC, PCI_DEVICE_ID_NCR_53C875J), 0UL },
 	{ 0, }
 };
 
diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
index 9a42734..034a87d 100644
--- a/drivers/scsi/tmscsim.c
+++ b/drivers/scsi/tmscsim.c
@@ -2557,8 +2557,7 @@ static void __devexit dc390_remove_one(struct pci_dev *dev)
 }
 
 static struct pci_device_id tmscsim_pci_tbl[] = {
-	{ PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD53C974,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD53C974), 0 },
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, tmscsim_pci_tbl);
-- 
1.6.3.1.10.g659a0.dirty

