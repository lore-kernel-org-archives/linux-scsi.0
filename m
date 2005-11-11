From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 2/4]  qla2xxx: Add full firmware(-request) hotplug support for all ISPs.
Date: 11 Nov 2005 00:08:07 -0800
Message-ID: <20051111080802.12822.99874.sendpatchset@andrew-vasquezs-powerbook-g4-15.local>
References: <20051111080733.12822.9617.sendpatchset@andrew-vasquezs-powerbook-g4-15.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:18576 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S1751248AbVKKIII (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Nov 2005 03:08:08 -0500
In-Reply-To: <20051111080733.12822.9617.sendpatchset@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@SteelEye.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>


Transition driver to exclusively use the request_firmware()
interfaces to retrieve firmware-blobs from user-space.  This
will be the default behaviour going forward until the
embedded firmware-binary images are removed from the
upstream kernel.

Upon request, the driver caches the firmware image until the
driver is unloaded.

NOTE: The option is present to allow the user to continue to
use the firmware-loader modules, but, should be considered
deprecated.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

 drivers/scsi/qla2xxx/Kconfig    |   84 +++++++++---------
 drivers/scsi/qla2xxx/Makefile   |    2 
 drivers/scsi/qla2xxx/qla_attr.c |    2 
 drivers/scsi/qla2xxx/qla_def.h  |   46 +---------
 drivers/scsi/qla2xxx/qla_gbl.h  |    4 +
 drivers/scsi/qla2xxx/qla_init.c |  184 +++++++++++++++++++++++++++++----------
 drivers/scsi/qla2xxx/qla_os.c   |  154 +++++++++++++++++++++++++++++----
 7 files changed, 330 insertions(+), 146 deletions(-)

applies-to: 42d32335de8149963d6031041fb67aee79a69159
a1a29fa44985b916b6cc56d7e9bd0a18f28a947c
diff --git a/drivers/scsi/qla2xxx/Kconfig b/drivers/scsi/qla2xxx/Kconfig
index c1c1c68..f2c2db4 100644
--- a/drivers/scsi/qla2xxx/Kconfig
+++ b/drivers/scsi/qla2xxx/Kconfig
@@ -1,55 +1,55 @@
 config SCSI_QLA2XXX
-	tristate
-	default (SCSI && PCI)
-	depends on SCSI && PCI
-
-config SCSI_QLA21XX
-	tristate "QLogic ISP2100 host adapter family support"
-	depends on SCSI_QLA2XXX
-        select SCSI_FC_ATTRS
+	tristate "QLogic QLA2XXX Fibre Channel Support"
+	depends on PCI && SCSI
+	select SCSI_FC_ATTRS
 	select FW_LOADER
 	---help---
-	This driver supports the QLogic 21xx (ISP2100) host adapter family.
+	This qla2xxx driver supports all QLogic Fibre Channel
+	PCI and PCIe host adapters.
 
-config SCSI_QLA22XX
-	tristate "QLogic ISP2200 host adapter family support"
+	By default, firmware for the ISP parts will be loaded
+	via the Firmware Loader interface.
+
+	ISP             Firmware Filename
+	----------      -----------------
+	21xx            ql2100_fw.bin
+	22xx            ql2200_fw.bin
+	2300, 2312      ql2300_fw.bin
+	2322            ql2322_fw.bin
+	6312, 6322      ql6312_fw.bin
+	24xx            ql2400_fw.bin
+
+	Upon request, the driver caches the firmware image until
+	the driver is unloaded.
+
+	NOTE: The original method of building firmware-loader
+	modules has been deprecated as the firmware-images will
+	be removed from the kernel sources.
+
+config SCSI_QLA2XXX_EMBEDDED_FIRMWARE
+	bool "  Use firmware-loader modules (DEPRECATED)"
 	depends on SCSI_QLA2XXX
-        select SCSI_FC_ATTRS
-	select FW_LOADER
-	---help---
-	This driver supports the QLogic 22xx (ISP2200) host adapter family.
+
+config SCSI_QLA21XX
+	tristate "  Build QLogic ISP2100 firmware-module"
+	depends on SCSI_QLA2XXX_EMBEDDED_FIRMWARE
+
+config SCSI_QLA22XX
+	tristate "  Build QLogic ISP2200 firmware-module"
+	depends on SCSI_QLA2XXX_EMBEDDED_FIRMWARE
 
 config SCSI_QLA2300
-	tristate "QLogic ISP2300 host adapter family support"
-	depends on SCSI_QLA2XXX
-        select SCSI_FC_ATTRS
-	select FW_LOADER
-	---help---
-	This driver supports the QLogic 2300 (ISP2300 and ISP2312) host
-	adapter family.
+	tristate "  Build QLogic ISP2300 firmware-module"
+	depends on SCSI_QLA2XXX_EMBEDDED_FIRMWARE
 
 config SCSI_QLA2322
-	tristate "QLogic ISP2322 host adapter family support"
-	depends on SCSI_QLA2XXX
-        select SCSI_FC_ATTRS
-	select FW_LOADER
-	---help---
-	This driver supports the QLogic 2322 (ISP2322) host adapter family.
+	tristate "  Build QLogic ISP2322 firmware-module"
+	depends on SCSI_QLA2XXX_EMBEDDED_FIRMWARE
 
 config SCSI_QLA6312
-	tristate "QLogic ISP63xx host adapter family support"
-	depends on SCSI_QLA2XXX
-        select SCSI_FC_ATTRS
-	select FW_LOADER
-	---help---
-	This driver supports the QLogic 63xx (ISP6312 and ISP6322) host
-	adapter family.
+	tristate "  Build QLogic ISP63xx firmware-module"
+	depends on SCSI_QLA2XXX_EMBEDDED_FIRMWARE
 
 config SCSI_QLA24XX
-	tristate "QLogic ISP24xx host adapter family support"
-	depends on SCSI_QLA2XXX
-	select SCSI_FC_ATTRS
-	select FW_LOADER
-	---help---
-	This driver supports the QLogic 24xx (ISP2422 and ISP2432) host
-	adapter family.
+	tristate "  Build QLogic ISP24xx firmware-module"
+	depends on SCSI_QLA2XXX_EMBEDDED_FIRMWARE
diff --git a/drivers/scsi/qla2xxx/Makefile b/drivers/scsi/qla2xxx/Makefile
index b169687..549dfe4 100644
--- a/drivers/scsi/qla2xxx/Makefile
+++ b/drivers/scsi/qla2xxx/Makefile
@@ -3,6 +3,8 @@ EXTRA_CFLAGS += -DUNIQUE_FW_NAME
 qla2xxx-y := qla_os.o qla_init.o qla_mbx.o qla_iocb.o qla_isr.o qla_gs.o \
 		qla_dbg.o qla_sup.o qla_rscn.o qla_attr.o
 
+obj-$(CONFIG_SCSI_QLA2XXX) += qla2xxx.o
+
 qla2100-y := ql2100.o ql2100_fw.o
 qla2200-y := ql2200.o ql2200_fw.o
 qla2300-y := ql2300.o ql2300_fw.o
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 48e460e..2efca52 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -232,7 +232,7 @@ static ssize_t
 qla2x00_isp_name_show(struct class_device *cdev, char *buf)
 {
 	scsi_qla_host_t *ha = to_qla_host(class_to_shost(cdev));
-	return snprintf(buf, PAGE_SIZE, "%s\n", ha->brd_info->isp_name);
+	return snprintf(buf, PAGE_SIZE, "ISP%04X\n", ha->pdev->device);
 }
 
 static ssize_t
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 7096945..4775337 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -22,6 +22,7 @@
 #include <linux/completion.h>
 #include <linux/interrupt.h>
 #include <linux/workqueue.h>
+#include <linux/firmware.h>
 #include <asm/semaphore.h>
 
 #include <scsi/scsi.h>
@@ -29,59 +30,20 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_cmnd.h>
 
-#if defined(CONFIG_SCSI_QLA21XX) || defined(CONFIG_SCSI_QLA21XX_MODULE)
 #define IS_QLA2100(ha)	((ha)->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2100)
-#else
-#define IS_QLA2100(ha)	0
-#endif
-
-#if defined(CONFIG_SCSI_QLA22XX) || defined(CONFIG_SCSI_QLA22XX_MODULE)
 #define IS_QLA2200(ha)	((ha)->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2200)
-#else
-#define IS_QLA2200(ha)	0
-#endif
-
-#if defined(CONFIG_SCSI_QLA2300) || defined(CONFIG_SCSI_QLA2300_MODULE)
 #define IS_QLA2300(ha)	((ha)->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2300)
 #define IS_QLA2312(ha)	((ha)->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2312)
-#else
-#define IS_QLA2300(ha)	0
-#define IS_QLA2312(ha)	0
-#endif
-
-#if defined(CONFIG_SCSI_QLA2322) || defined(CONFIG_SCSI_QLA2322_MODULE)
 #define IS_QLA2322(ha)	((ha)->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2322)
-#else
-#define IS_QLA2322(ha)	0
-#endif
-
-#if defined(CONFIG_SCSI_QLA6312) || defined(CONFIG_SCSI_QLA6312_MODULE)
 #define IS_QLA6312(ha)	((ha)->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP6312)
 #define IS_QLA6322(ha)	((ha)->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP6322)
-#else
-#define IS_QLA6312(ha)	0
-#define IS_QLA6322(ha)	0
-#endif
-
-#if defined(CONFIG_SCSI_QLA24XX) || defined(CONFIG_SCSI_QLA24XX_MODULE)
 #define IS_QLA2422(ha)	((ha)->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2422)
 #define IS_QLA2432(ha)	((ha)->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2432)
-#else
-#define IS_QLA2422(ha)	0
-#define IS_QLA2432(ha)	0
-#endif
-
-#if defined(CONFIG_SCSI_QLA25XX) || defined(CONFIG_SCSI_QLA25XX_MODULE)
 #define IS_QLA2512(ha)	((ha)->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2512)
 #define IS_QLA2522(ha)	((ha)->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2522)
-#else
-#define IS_QLA2512(ha)	0
-#define IS_QLA2522(ha)	0
-#endif
 
 #define IS_QLA23XX(ha)	(IS_QLA2300(ha) || IS_QLA2312(ha) || IS_QLA2322(ha) || \
     			 IS_QLA6312(ha) || IS_QLA6322(ha))
-
 #define IS_QLA24XX(ha)	(IS_QLA2422(ha) || IS_QLA2432(ha))
 #define IS_QLA25XX(ha)	(IS_QLA2512(ha) || IS_QLA2522(ha))
 
@@ -2124,6 +2086,12 @@ struct qla_board_info {
 	struct scsi_host_template *sht;
 };
 
+struct fw_blob {
+	char *name;
+	uint32_t segs[4];
+	const struct firmware *fw;
+};
+
 /* Return data from MBC_GET_ID_LIST call. */
 struct gid_list_info {
 	uint8_t	al_pa;
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 5d5e833..7872c11 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -33,8 +33,8 @@ extern int qla24xx_nvram_config(struct s
 extern void qla2x00_update_fw_options(struct scsi_qla_host *);
 extern void qla24xx_update_fw_options(scsi_qla_host_t *);
 extern int qla2x00_load_risc(struct scsi_qla_host *, uint32_t *);
+extern int qla24xx_load_risc(scsi_qla_host_t *, uint32_t *);
 extern int qla24xx_load_risc_flash(scsi_qla_host_t *, uint32_t *);
-extern int qla24xx_load_risc_hotplug(scsi_qla_host_t *, uint32_t *);
 
 extern fc_port_t *qla2x00_alloc_fcport(scsi_qla_host_t *, gfp_t);
 
@@ -76,6 +76,8 @@ extern void qla2x00_blink_led(scsi_qla_h
 
 extern int qla2x00_down_timeout(struct semaphore *, unsigned long);
 
+extern struct fw_blob *qla2x00_request_firmware(scsi_qla_host_t *);
+
 /*
  * Global Function Prototypes in qla_iocb.c source file.
  */
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index ca4284c..2425289 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -8,7 +8,6 @@
 
 #include <linux/delay.h>
 #include <linux/vmalloc.h>
-#include <linux/firmware.h>
 #include <scsi/scsi_transport_fc.h>
 
 #include "qla_devtbl.h"
@@ -3484,17 +3483,16 @@ qla24xx_nvram_config(scsi_qla_host_t *ha
 	return (rval);
 }
 
+#if defined(CONFIG_SCSI_QLA2XXX_EMBEDDED_FIRMWARE)
+
 int
 qla2x00_load_risc(scsi_qla_host_t *ha, uint32_t *srisc_addr)
 {
-	int		rval;
-	uint16_t	cnt;
-	uint16_t	*risc_code;
-	unsigned long	risc_address;
-	unsigned long	risc_code_size;
-	int		num;
-	int		i;
-	uint16_t	*req_ring;
+	int	rval, num, i;
+	uint32_t cnt;
+	uint16_t *risc_code;
+	uint32_t risc_addr, risc_size;
+	uint16_t *req_ring;
 	struct qla_fw_info *fw_iter;
 
 	rval = QLA_SUCCESS;
@@ -3504,32 +3502,29 @@ qla2x00_load_risc(scsi_qla_host_t *ha, u
 	*srisc_addr = *ha->brd_info->fw_info->fwstart;
 	while (fw_iter->addressing != FW_INFO_ADDR_NOMORE) {
 		risc_code = fw_iter->fwcode;
-		risc_code_size = *fw_iter->fwlen;
-
-		if (fw_iter->addressing == FW_INFO_ADDR_NORMAL) {
-			risc_address = *fw_iter->fwstart;
-		} else {
-			/* Extended address */
-			risc_address = *fw_iter->lfwstart;
-		}
+		risc_size = *fw_iter->fwlen;
+		if (fw_iter->addressing == FW_INFO_ADDR_NORMAL)
+			risc_addr = *fw_iter->fwstart;
+		else
+			risc_addr = *fw_iter->lfwstart;
 
 		num = 0;
 		rval = 0;
-		while (risc_code_size > 0 && !rval) {
+		while (risc_size > 0 && !rval) {
 			cnt = (uint16_t)(ha->fw_transfer_size >> 1);
-			if (cnt > risc_code_size)
-				cnt = risc_code_size;
+			if (cnt > risc_size)
+				cnt = risc_size;
 
 			DEBUG7(printk("scsi(%ld): Loading risc segment@ "
 			    "addr %p, number of bytes 0x%x, offset 0x%lx.\n",
-			    ha->host_no, risc_code, cnt, risc_address));
+			    ha->host_no, risc_code, cnt, risc_addr));
 
 			req_ring = (uint16_t *)ha->request_ring;
 			for (i = 0; i < cnt; i++)
 				req_ring[i] = cpu_to_le16(risc_code[i]);
 
-			rval = qla2x00_load_ram(ha, ha->request_dma,
-			    risc_address, cnt);
+			rval = qla2x00_load_ram(ha, ha->request_dma, risc_addr,
+			    cnt);
 			if (rval) {
 				DEBUG(printk("scsi(%ld): [ERROR] Failed to "
 				    "load segment %d of firmware\n",
@@ -3543,16 +3538,15 @@ qla2x00_load_risc(scsi_qla_host_t *ha, u
 			}
 
 			risc_code += cnt;
-			risc_address += cnt;
-			risc_code_size -= cnt;
+			risc_addr += cnt;
+			risc_size -= cnt;
 			num++;
 		}
 
 		/* Next firmware sequence */
 		fw_iter++;
 	}
-
-	return (rval);
+	return rval;
 }
 
 int
@@ -3637,8 +3631,108 @@ qla24xx_load_risc_flash(scsi_qla_host_t 
 	return rval;
 }
 
+#else	/* !defined(CONFIG_SCSI_QLA2XXX_EMBEDDED_FIRMWARE) */
+
 int
-qla24xx_load_risc_hotplug(scsi_qla_host_t *ha, uint32_t *srisc_addr)
+qla2x00_load_risc(scsi_qla_host_t *ha, uint32_t *srisc_addr)
+{
+	int	rval;
+	int	i, fragment;
+	uint16_t *wcode, *fwcode;
+	uint32_t risc_addr, risc_size, fwclen, wlen, *seg;
+	struct fw_blob *blob;
+
+	/* Load firmware blob. */
+	blob = qla2x00_request_firmware(ha);
+	if (!blob) {
+		qla_printk(KERN_ERR, ha, "Firmware image unavailable.\n");
+		return QLA_FUNCTION_FAILED;
+	}
+
+	rval = QLA_SUCCESS;
+
+	wcode = (uint16_t *)ha->request_ring;
+	*srisc_addr = 0;
+	fwcode = (uint16_t *)blob->fw->data;
+	fwclen = 0;
+
+	/* Validate firmware image by checking version. */
+	if (blob->fw->size < 8 * sizeof(uint16_t)) {
+		qla_printk(KERN_WARNING, ha,
+		    "Unable to verify integrity of firmware image (%Zd)!\n",
+		    blob->fw->size);
+		goto fail_fw_integrity;
+	}
+	for (i = 0; i < 4; i++)
+		wcode[i] = be16_to_cpu(fwcode[i + 4]);
+	if ((wcode[0] == 0xffff && wcode[1] == 0xffff && wcode[2] == 0xffff &&
+	    wcode[3] == 0xffff) || (wcode[0] == 0 && wcode[1] == 0 &&
+		wcode[2] == 0 && wcode[3] == 0)) {
+		qla_printk(KERN_WARNING, ha,
+		    "Unable to verify integrity of firmware image!\n");
+		qla_printk(KERN_WARNING, ha,
+		    "Firmware data: %04x %04x %04x %04x!\n", wcode[0],
+		    wcode[1], wcode[2], wcode[3]);
+		goto fail_fw_integrity;
+	}
+
+	seg = blob->segs;
+	while (*seg && rval == QLA_SUCCESS) {
+		risc_addr = *seg;
+		*srisc_addr = *srisc_addr == 0 ? *seg : *srisc_addr;
+		risc_size = be16_to_cpu(fwcode[3]);
+
+		/* Validate firmware image size. */
+		fwclen += risc_size * sizeof(uint16_t);
+		if (blob->fw->size < fwclen) {
+			qla_printk(KERN_WARNING, ha,
+			    "Unable to verify integrity of firmware image "
+			    "(%Zd)!\n", blob->fw->size);
+			goto fail_fw_integrity;
+		}
+
+		fragment = 0;
+		while (risc_size > 0 && rval == QLA_SUCCESS) {
+			wlen = (uint16_t)(ha->fw_transfer_size >> 1);
+			if (wlen > risc_size)
+				wlen = risc_size;
+
+			DEBUG7(printk("scsi(%ld): Loading risc segment@ risc "
+			    "addr %x, number of words 0x%x.\n", ha->host_no,
+			    risc_addr, wlen));
+
+			for (i = 0; i < wlen; i++)
+				wcode[i] = swab16(fwcode[i]);
+
+			rval = qla2x00_load_ram(ha, ha->request_dma, risc_addr,
+			    wlen);
+			if (rval) {
+				DEBUG(printk("scsi(%ld):[ERROR] Failed to load "
+				    "segment %d of firmware\n", ha->host_no,
+				    fragment));
+				qla_printk(KERN_WARNING, ha,
+				    "[ERROR] Failed to load segment %d of "
+				    "firmware\n", fragment);
+				break;
+			}
+
+			fwcode += wlen;
+			risc_addr += wlen;
+			risc_size -= wlen;
+			fragment++;
+		}
+
+		/* Next segment. */
+		seg++;
+	}
+	return rval;
+
+fail_fw_integrity:
+	return QLA_FUNCTION_FAILED;
+}
+
+int
+qla24xx_load_risc(scsi_qla_host_t *ha, uint32_t *srisc_addr)
 {
 	int	rval;
 	int	segments, fragment;
@@ -3646,14 +3740,13 @@ qla24xx_load_risc_hotplug(scsi_qla_host_
 	uint32_t risc_addr;
 	uint32_t risc_size;
 	uint32_t i;
-	const struct firmware *fw_entry;
+	struct fw_blob *blob;
 	uint32_t *fwcode, fwclen;
 
-	if (request_firmware(&fw_entry, ha->brd_info->fw_fname,
-	    &ha->pdev->dev)) {
-		qla_printk(KERN_ERR, ha,
-		    "Firmware image file not available: '%s'\n",
-		    ha->brd_info->fw_fname);
+	/* Load firmware blob. */
+	blob = qla2x00_request_firmware(ha);
+	if (!blob) {
+		qla_printk(KERN_ERR, ha, "Firmware image unavailable.\n");
 		return QLA_FUNCTION_FAILED;
 	}
 
@@ -3662,14 +3755,14 @@ qla24xx_load_risc_hotplug(scsi_qla_host_
 	segments = FA_RISC_CODE_SEGMENTS;
 	dcode = (uint32_t *)ha->request_ring;
 	*srisc_addr = 0;
-	fwcode = (uint32_t *)fw_entry->data;
+	fwcode = (uint32_t *)blob->fw->data;
 	fwclen = 0;
 
 	/* Validate firmware image by checking version. */
-	if (fw_entry->size < 8 * sizeof(uint32_t)) {
+	if (blob->fw->size < 8 * sizeof(uint32_t)) {
 		qla_printk(KERN_WARNING, ha,
-		    "Unable to verify integrity of flash firmware image "
-		    "(%Zd)!\n", fw_entry->size);
+		    "Unable to verify integrity of firmware image (%Zd)!\n",
+		    blob->fw->size);
 		goto fail_fw_integrity;
 	}
 	for (i = 0; i < 4; i++)
@@ -3679,7 +3772,7 @@ qla24xx_load_risc_hotplug(scsi_qla_host_
 	    (dcode[0] == 0 && dcode[1] == 0 && dcode[2] == 0 &&
 		dcode[3] == 0)) {
 		qla_printk(KERN_WARNING, ha,
-		    "Unable to verify integrity of flash firmware image!\n");
+		    "Unable to verify integrity of firmware image!\n");
 		qla_printk(KERN_WARNING, ha,
 		    "Firmware data: %08x %08x %08x %08x!\n", dcode[0],
 		    dcode[1], dcode[2], dcode[3]);
@@ -3693,10 +3786,11 @@ qla24xx_load_risc_hotplug(scsi_qla_host_
 
 		/* Validate firmware image size. */
 		fwclen += risc_size * sizeof(uint32_t);
-		if (fw_entry->size < fwclen) {
+		if (blob->fw->size < fwclen) {
 			qla_printk(KERN_WARNING, ha,
-			    "Unable to verify integrity of flash firmware "
-			    "image (%Zd)!\n", fw_entry->size);
+			    "Unable to verify integrity of firmware image "
+			    "(%Zd)!\n", blob->fw->size);
+
 			goto fail_fw_integrity;
 		}
 
@@ -3734,13 +3828,9 @@ qla24xx_load_risc_hotplug(scsi_qla_host_
 		/* Next segment. */
 		segments--;
 	}
-
-	release_firmware(fw_entry);
 	return rval;
 
 fail_fw_integrity:
-
-	release_firmware(fw_entry);
 	return QLA_FUNCTION_FAILED;
-
 }
+#endif
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index c58c9d9..b98ad53 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -54,11 +54,6 @@ module_param(ql2xloginretrycount, int, S
 MODULE_PARM_DESC(ql2xloginretrycount,
 		"Specify an alternate value for the NVRAM login retry count.");
 
-int ql2xfwloadbin=1;
-module_param(ql2xfwloadbin, int, S_IRUGO|S_IRUSR);
-MODULE_PARM_DESC(ql2xfwloadbin,
-		"Load ISP2xxx firmware image via hotplug.");
-
 static void qla2x00_free_device(scsi_qla_host_t *);
 
 static void qla2x00_config_dma_addressing(scsi_qla_host_t *ha);
@@ -1261,12 +1256,16 @@ int qla2x00_probe_one(struct pci_dev *pd
 	char pci_info[20];
 	char fw_str[30];
 	fc_port_t *fcport;
+	struct scsi_host_template *sht;
 
 	if (pci_enable_device(pdev))
 		goto probe_out;
 
-	host = scsi_host_alloc(brd_info->sht ? brd_info->sht:
-	    &qla2x00_driver_template, sizeof(scsi_qla_host_t));
+	sht = &qla2x00_driver_template;
+	if (pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2422 ||
+	    pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2432)
+		sht = &qla24xx_driver_template;
+	host = scsi_host_alloc(sht, sizeof(scsi_qla_host_t));
 	if (host == NULL) {
 		printk(KERN_WARNING
 		    "qla2xxx: Couldn't allocate host from scsi layer!\n");
@@ -1291,8 +1290,8 @@ int qla2x00_probe_one(struct pci_dev *pd
 		goto probe_failed;
 
 	qla_printk(KERN_INFO, ha,
-	    "Found an %s, irq %d, iobase 0x%p\n", ha->brd_info->isp_name,
-	    pdev->irq, ha->iobase);
+	    "Found an ISP%04X, irq %d, iobase 0x%p\n", pdev->device, pdev->irq,
+	    ha->iobase);
 
 	spin_lock_init(&ha->hardware_lock);
 
@@ -1368,9 +1367,11 @@ int qla2x00_probe_one(struct pci_dev *pd
 		ha->isp_ops.reset_adapter = qla24xx_reset_adapter;
 		ha->isp_ops.nvram_config = qla24xx_nvram_config;
 		ha->isp_ops.update_fw_options = qla24xx_update_fw_options;
+#if defined(CONFIG_SCSI_QLA2XXX_EMBEDDED_FIRMWARE)
 		ha->isp_ops.load_risc = qla24xx_load_risc_flash;
-		if (ql2xfwloadbin)
-			ha->isp_ops.load_risc = qla24xx_load_risc_hotplug;
+#else
+		ha->isp_ops.load_risc = qla24xx_load_risc;
+#endif
 		ha->isp_ops.pci_info_str = qla24xx_pci_info_str;
 		ha->isp_ops.fw_version_str = qla24xx_fw_version_str;
 		ha->isp_ops.intr_handler = qla24xx_intr_handler;
@@ -1531,11 +1532,12 @@ int qla2x00_probe_one(struct pci_dev *pd
 	qla_printk(KERN_INFO, ha, "\n"
 	    " QLogic Fibre Channel HBA Driver: %s\n"
 	    "  QLogic %s - %s\n"
-	    "  %s: %s @ %s hdma%c, host#=%ld, fw=%s\n", qla2x00_version_str,
-	    ha->model_number, ha->model_desc ? ha->model_desc: "",
-	    ha->brd_info->isp_name, ha->isp_ops.pci_info_str(ha, pci_info),
-	    pci_name(pdev), ha->flags.enable_64bit_addressing ? '+': '-',
-	    ha->host_no, ha->isp_ops.fw_version_str(ha, fw_str));
+	    "  ISP%04X: %s @ %s hdma%c, host#=%ld, fw=%s\n",
+	    qla2x00_version_str, ha->model_number,
+	    ha->model_desc ? ha->model_desc: "", pdev->device,
+	    ha->isp_ops.pci_info_str(ha, pci_info), pci_name(pdev),
+	    ha->flags.enable_64bit_addressing ? '+': '-', ha->host_no,
+	    ha->isp_ops.fw_version_str(ha, fw_str));
 
 	/* Go with fc_rport registration. */
 	list_for_each_entry(fcport, &ha->fcports, list)
@@ -2483,6 +2485,10 @@ qla2x00_down_timeout(struct semaphore *s
 	return -ETIMEDOUT;
 }
 
+#if defined(CONFIG_SCSI_QLA2XXX_EMBEDDED_FIRMWARE)
+
+#define qla2x00_release_firmware()	do { } while (0)
+
 static struct qla_board_info qla_board_tbl[] = {
 	{
 		.drv_name	= "qla2400",
@@ -2530,8 +2536,120 @@ qla2xxx_remove_one(struct pci_dev *pdev)
 	qla2x00_remove_one(pdev);
 }
 
+#else	/* !defined(CONFIG_SCSI_QLA2XXX_EMBEDDED_FIRMWARE) */
+
+/* Firmware interface routines. */
+
+#define FW_BLOBS	6
+#define FW_ISP21XX	0
+#define FW_ISP22XX	1
+#define FW_ISP2300	2
+#define FW_ISP2322	3
+#define FW_ISP63XX	4
+#define FW_ISP24XX	5
+
+static DECLARE_MUTEX(qla_fw_lock);
+
+static struct fw_blob qla_fw_blobs[FW_BLOBS] = {
+	{ .name = "ql2100_fw.bin", .segs = { 0x1000, 0 }, },
+	{ .name = "ql2200_fw.bin", .segs = { 0x1000, 0 }, },
+	{ .name = "ql2300_fw.bin", .segs = { 0x800, 0 }, },
+	{ .name = "ql2322_fw.bin", .segs = { 0x800, 0x1c000, 0x1e000, 0 }, },
+	{ .name = "ql6312_fw.bin", .segs = { 0x800, 0 }, },
+	{ .name = "ql2400_fw.bin", },
+};
+
+struct fw_blob *
+qla2x00_request_firmware(scsi_qla_host_t *ha)
+{
+	struct fw_blob *blob;
+
+	blob = NULL;
+	if (IS_QLA2100(ha))
+		blob = &qla_fw_blobs[FW_ISP21XX];
+	else if (IS_QLA2200(ha))
+		blob = &qla_fw_blobs[FW_ISP22XX];
+	else if (IS_QLA2300(ha) || IS_QLA2312(ha))
+		blob = &qla_fw_blobs[FW_ISP2300];
+	else if (IS_QLA2322(ha))
+		blob = &qla_fw_blobs[FW_ISP2322];
+	else if (IS_QLA6312(ha) || IS_QLA6322(ha))
+		blob = &qla_fw_blobs[FW_ISP63XX];
+	else if (IS_QLA24XX(ha))
+		blob = &qla_fw_blobs[FW_ISP24XX];
+
+	down(&qla_fw_lock);
+	if (blob->fw)
+		goto out;
+
+	if (request_firmware(&blob->fw, blob->name, &ha->pdev->dev)) {
+		DEBUG2(printk("scsi(%ld): Failed to load firmware image "
+		    "(%s).\n", ha->host_no, blob->name));
+		blob->fw = NULL;
+		blob = NULL;
+	}
+
+out:
+	up(&qla_fw_lock);
+	return blob;
+}
+
+static void
+qla2x00_release_firmware(void)
+{
+	int idx;
+
+	down(&qla_fw_lock);
+	for (idx = 0; idx < FW_BLOBS; idx++)
+		if (qla_fw_blobs[idx].fw)
+			release_firmware(qla_fw_blobs[idx].fw);
+	up(&qla_fw_lock);
+}
+
+static struct qla_board_info qla_board_tbl = {
+	.drv_name       = "qla2xxx",
+};
+
+static struct pci_device_id qla2xxx_pci_tbl[] = {
+	{ PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP2100,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{ PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP2200,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{ PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP2300,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{ PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP2312,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{ PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP2322,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{ PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP6312,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{ PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP6322,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{ PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP2422,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{ PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP2432,
+		PCI_ANY_ID, PCI_ANY_ID, },
+	{ 0 },
+};
+MODULE_DEVICE_TABLE(pci, qla2xxx_pci_tbl);
+
+static int __devinit
+qla2xxx_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	return qla2x00_probe_one(pdev, &qla_board_tbl);
+}
+
+static void __devexit
+qla2xxx_remove_one(struct pci_dev *pdev)
+{
+	qla2x00_remove_one(pdev);
+}
+
+#endif
+
 static struct pci_driver qla2xxx_pci_driver = {
 	.name		= "qla2xxx",
+	.owner		= THIS_MODULE,
 	.id_table	= qla2xxx_pci_tbl,
 	.probe		= qla2xxx_probe_one,
 	.remove		= __devexit_p(qla2xxx_remove_one),
@@ -2556,6 +2674,9 @@ qla2x00_module_init(void)
 
 	/* Derive version string. */
 	strcpy(qla2x00_version_str, QLA2XXX_VERSION);
+#if defined(CONFIG_SCSI_QLA2XXX_EMBEDDED_FIRMWARE)
+	strcat(qla2x00_version_str, "-fw");
+#endif
 #if DEBUG_QLA2100
 	strcat(qla2x00_version_str, "-debug");
 #endif
@@ -2580,6 +2701,7 @@ static void __exit
 qla2x00_module_exit(void)
 {
 	pci_unregister_driver(&qla2xxx_pci_driver);
+	qla2x00_release_firmware();
 	kmem_cache_destroy(srb_cachep);
 	fc_release_transport(qla2xxx_transport_template);
 }
---
0.99.9.GIT


-- 
Andrew Vasquez
