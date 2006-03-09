From: andrew.vasquez@qlogic.com
Subject: [PATCH 03/10] qla2xxx: Consolidate ISP63xx handling.
Date: Thu, 9 Mar 2006 14:27:18 -0800
Message-ID: <11419432334180-git-send-email-andrew.vasquez@qlogic.com>
References: <20060309222436.GC10181@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:50756 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S1751954AbWCIW1T (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2006 17:27:19 -0500
In-Reply-To: <20060309222436.GC10181@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: andrew.vasquez@qlogic.com

As new 23xx firmware will accomidate ISP63xx types.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

 drivers/scsi/qla2xxx/Kconfig    |   31 ++++++++++++-------------------
 drivers/scsi/qla2xxx/Makefile   |    2 --
 drivers/scsi/qla2xxx/ql2300.c   |   12 ++++++++++++
 drivers/scsi/qla2xxx/ql2322.c   |   12 ++++++++++++
 drivers/scsi/qla2xxx/qla_init.c |    4 ++++
 drivers/scsi/qla2xxx/qla_os.c   |   12 ++++--------
 6 files changed, 44 insertions(+), 29 deletions(-)

d4c70234d800f318b0d2e026182613a998aa7466
diff --git a/drivers/scsi/qla2xxx/Kconfig b/drivers/scsi/qla2xxx/Kconfig
index 5758b25..ff40906 100644
--- a/drivers/scsi/qla2xxx/Kconfig
+++ b/drivers/scsi/qla2xxx/Kconfig
@@ -10,14 +10,13 @@ config SCSI_QLA_FC
 	By default, firmware for the ISP parts will be loaded
 	via the Firmware Loader interface.
 
-	ISP             Firmware Filename
-	----------      -----------------
-	21xx            ql2100_fw.bin
-	22xx            ql2200_fw.bin
-	2300, 2312      ql2300_fw.bin
-	2322            ql2322_fw.bin
-	6312, 6322      ql6312_fw.bin
-	24xx            ql2400_fw.bin
+	ISP               Firmware Filename
+	----------        -----------------
+	21xx              ql2100_fw.bin
+	22xx              ql2200_fw.bin
+	2300, 2312, 6312  ql2300_fw.bin
+	2322, 6322        ql2322_fw.bin
+	24xx              ql2400_fw.bin
 
 	Upon request, the driver caches the firmware image until
 	the driver is unloaded.
@@ -51,23 +50,17 @@ config SCSI_QLA22XX
 	This driver supports the QLogic 22xx (ISP2200) host adapter family.
 
 config SCSI_QLA2300
-	tristate "  Build QLogic ISP2300 firmware-module"
+	tristate "  Build QLogic ISP2300/ISP6312 firmware-module"
 	depends on SCSI_QLA_FC && SCSI_QLA2XXX_EMBEDDED_FIRMWARE
 	---help---
-	This driver supports the QLogic 2300 (ISP2300 and ISP2312) host
-	adapter family.
+	This driver supports the QLogic 2300 (ISP2300, ISP2312 and
+	ISP6312) host adapter family.
 
 config SCSI_QLA2322
-	tristate "  Build QLogic ISP2322 firmware-module"
-	depends on SCSI_QLA_FC && SCSI_QLA2XXX_EMBEDDED_FIRMWARE
-	---help---
-	This driver supports the QLogic 2322 (ISP2322) host adapter family.
-
-config SCSI_QLA6312
-	tristate "  Build QLogic ISP63xx firmware-module"
+	tristate "  Build QLogic ISP2322/ISP6322 firmware-module"
 	depends on SCSI_QLA_FC && SCSI_QLA2XXX_EMBEDDED_FIRMWARE
 	---help---
-	This driver supports the QLogic 63xx (ISP6312 and ISP6322) host
+	This driver supports the QLogic 2322 (ISP2322 and ISP6322) host
 	adapter family.
 
 config SCSI_QLA24XX
diff --git a/drivers/scsi/qla2xxx/Makefile b/drivers/scsi/qla2xxx/Makefile
index d028bc5..c8f670e 100644
--- a/drivers/scsi/qla2xxx/Makefile
+++ b/drivers/scsi/qla2xxx/Makefile
@@ -9,12 +9,10 @@ qla2100-y := ql2100.o ql2100_fw.o
 qla2200-y := ql2200.o ql2200_fw.o
 qla2300-y := ql2300.o ql2300_fw.o
 qla2322-y := ql2322.o ql2322_fw.o
-qla6312-y := ql6312.o ql6312_fw.o
 qla2400-y := ql2400.o ql2400_fw.o
 
 obj-$(CONFIG_SCSI_QLA21XX) += qla2xxx.o qla2100.o
 obj-$(CONFIG_SCSI_QLA22XX) += qla2xxx.o qla2200.o
 obj-$(CONFIG_SCSI_QLA2300) += qla2xxx.o qla2300.o
 obj-$(CONFIG_SCSI_QLA2322) += qla2xxx.o qla2322.o
-obj-$(CONFIG_SCSI_QLA6312) += qla2xxx.o qla6312.o
 obj-$(CONFIG_SCSI_QLA24XX) += qla2xxx.o qla2400.o
diff --git a/drivers/scsi/qla2xxx/ql2300.c b/drivers/scsi/qla2xxx/ql2300.c
index fd2f4b7..e7a93dd 100644
--- a/drivers/scsi/qla2xxx/ql2300.c
+++ b/drivers/scsi/qla2xxx/ql2300.c
@@ -40,6 +40,11 @@ static struct qla_board_info qla_board_t
 		.isp_name	= "ISP2312",
 		.fw_info	= qla_fw_tbl,
 	},
+	{
+		.drv_name	= qla_driver_name,
+		.isp_name	= "ISP6312",
+		.fw_info	= qla_fw_tbl,
+	},
 };
 
 static struct pci_device_id qla2300_pci_tbl[] = {
@@ -57,6 +62,13 @@ static struct pci_device_id qla2300_pci_
 		.subdevice	= PCI_ANY_ID,
 		.driver_data	= (unsigned long)&qla_board_tbl[1],
 	},
+	{
+		.vendor		= PCI_VENDOR_ID_QLOGIC,
+		.device		= PCI_DEVICE_ID_QLOGIC_ISP6312,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.driver_data	= (unsigned long)&qla_board_tbl[2],
+	},
 	{0, 0},
 };
 MODULE_DEVICE_TABLE(pci, qla2300_pci_tbl);
diff --git a/drivers/scsi/qla2xxx/ql2322.c b/drivers/scsi/qla2xxx/ql2322.c
index c88a22c..3c8cafc 100644
--- a/drivers/scsi/qla2xxx/ql2322.c
+++ b/drivers/scsi/qla2xxx/ql2322.c
@@ -52,6 +52,11 @@ static struct qla_board_info qla_board_t
 		.isp_name	= "ISP2322",
 		.fw_info	= qla_fw_tbl,
 	},
+	{
+		.drv_name	= qla_driver_name,
+		.isp_name	= "ISP6322",
+		.fw_info	= qla_fw_tbl,
+	},
 };
 
 static struct pci_device_id qla2322_pci_tbl[] = {
@@ -62,6 +67,13 @@ static struct pci_device_id qla2322_pci_
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
 MODULE_DEVICE_TABLE(pci, qla2322_pci_tbl);
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index e6a2292..d438909 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1003,6 +1003,10 @@ qla2x00_update_fw_options(scsi_qla_host_
 	if (ha->flags.enable_led_scheme)
 		ha->fw_options[2] |= BIT_12;
 
+	/* Detect ISP6312. */
+	if (IS_QLA6312(ha))
+		ha->fw_options[2] |= BIT_13;
+
 	/* Update firmware options. */
 	qla2x00_set_fw_options(ha, ha->fw_options);
 }
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 1316147..4dc08d9 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2596,13 +2596,12 @@ qla2x00_down_timeout(struct semaphore *s
 
 /* Firmware interface routines. */
 
-#define FW_BLOBS	6
+#define FW_BLOBS	5
 #define FW_ISP21XX	0
 #define FW_ISP22XX	1
 #define FW_ISP2300	2
 #define FW_ISP2322	3
-#define FW_ISP63XX	4
-#define FW_ISP24XX	5
+#define FW_ISP24XX	4
 
 static DECLARE_MUTEX(qla_fw_lock);
 
@@ -2611,7 +2610,6 @@ static struct fw_blob qla_fw_blobs[FW_BL
 	{ .name = "ql2200_fw.bin", .segs = { 0x1000, 0 }, },
 	{ .name = "ql2300_fw.bin", .segs = { 0x800, 0 }, },
 	{ .name = "ql2322_fw.bin", .segs = { 0x800, 0x1c000, 0x1e000, 0 }, },
-	{ .name = "ql6312_fw.bin", .segs = { 0x800, 0 }, },
 	{ .name = "ql2400_fw.bin", },
 };
 
@@ -2625,12 +2623,10 @@ qla2x00_request_firmware(scsi_qla_host_t
 		blob = &qla_fw_blobs[FW_ISP21XX];
 	} else if (IS_QLA2200(ha)) {
 		blob = &qla_fw_blobs[FW_ISP22XX];
-	} else if (IS_QLA2300(ha) || IS_QLA2312(ha)) {
+	} else if (IS_QLA2300(ha) || IS_QLA2312(ha) || IS_QLA6312(ha)) {
 		blob = &qla_fw_blobs[FW_ISP2300];
-	} else if (IS_QLA2322(ha)) {
+	} else if (IS_QLA2322(ha) || IS_QLA6322(ha)) {
 		blob = &qla_fw_blobs[FW_ISP2322];
-	} else if (IS_QLA6312(ha) || IS_QLA6322(ha)) {
-		blob = &qla_fw_blobs[FW_ISP63XX];
 	} else if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
 		blob = &qla_fw_blobs[FW_ISP24XX];
 	}
-- 
1.2.4.gf067


