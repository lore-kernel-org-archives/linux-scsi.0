From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 5/12]  qla2xxx: Add support for embedded ISP24xx firmware.
Date: Thu, 13 Oct 2005 16:16:24 -0700 (PDT)
Message-ID: <20051013231624.27191.96727.sendpatchset@plap.qlogic.com>
References: <20051013231534.27191.19815.sendpatchset@plap.qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:15782 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S932529AbVJMXQY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Oct 2005 19:16:24 -0400
In-Reply-To: <20051013231534.27191.19815.sendpatchset@plap.qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

 drivers/scsi/qla2xxx/Makefile   |    3 +
 drivers/scsi/qla2xxx/ql2400.c   |  113 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_def.h  |    2 -
 drivers/scsi/qla2xxx/qla_gbl.h  |    1 
 drivers/scsi/qla2xxx/qla_init.c |   63 ++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_os.c   |   85 ++++++-----------------------
 6 files changed, 196 insertions(+), 71 deletions(-)
 create mode 100644 drivers/scsi/qla2xxx/ql2400.c

applies-to: fd35977ee7de3602087def1d4b490e31c9a383d2
84910304aeb3d5db54db9e975309e21791b9baca
diff --git a/drivers/scsi/qla2xxx/Makefile b/drivers/scsi/qla2xxx/Makefile
index b169687..f1c3dfd 100644
--- a/drivers/scsi/qla2xxx/Makefile
+++ b/drivers/scsi/qla2xxx/Makefile
@@ -8,10 +8,11 @@ qla2200-y := ql2200.o ql2200_fw.o
 qla2300-y := ql2300.o ql2300_fw.o
 qla2322-y := ql2322.o ql2322_fw.o
 qla6312-y := ql6312.o ql6312_fw.o
+qla2400-y := ql2400.o ql2400_fw.o
 
 obj-$(CONFIG_SCSI_QLA21XX) += qla2xxx.o qla2100.o
 obj-$(CONFIG_SCSI_QLA22XX) += qla2xxx.o qla2200.o
 obj-$(CONFIG_SCSI_QLA2300) += qla2xxx.o qla2300.o
 obj-$(CONFIG_SCSI_QLA2322) += qla2xxx.o qla2322.o
 obj-$(CONFIG_SCSI_QLA6312) += qla2xxx.o qla6312.o
-obj-$(CONFIG_SCSI_QLA24XX) += qla2xxx.o
+obj-$(CONFIG_SCSI_QLA24XX) += qla2xxx.o qla2400.o
diff --git a/drivers/scsi/qla2xxx/ql2400.c b/drivers/scsi/qla2xxx/ql2400.c
new file mode 100644
index 0000000..76a48ed
--- /dev/null
+++ b/drivers/scsi/qla2xxx/ql2400.c
@@ -0,0 +1,113 @@
+/*
+ * QLogic Fibre Channel HBA Driver
+ * Copyright (c)  2003-2005 QLogic Corporation
+ *
+ * See LICENSE.qla2xxx for copyright and licensing details.
+ */
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+
+#include "qla_def.h"
+
+static char qla_driver_name[] = "qla2400";
+
+extern uint32_t fw2400_version_str[];
+extern uint32_t fw2400_addr01;
+extern uint32_t fw2400_code01[];
+extern uint32_t fw2400_length01;
+extern uint32_t fw2400_addr02;
+extern uint32_t fw2400_code02[];
+extern uint32_t fw2400_length02;
+
+static struct qla_fw_info qla_fw_tbl[] = {
+	{
+		.addressing	= FW_INFO_ADDR_EXTENDED,
+		.fwcode		= (unsigned short *)&fw2400_code01[0],
+		.fwlen		= (unsigned short *)&fw2400_length01,
+		.lfwstart	= (unsigned long *)&fw2400_addr01,
+	},
+	{
+		.addressing	= FW_INFO_ADDR_EXTENDED,
+		.fwcode		= (unsigned short *)&fw2400_code02[0],
+		.fwlen		= (unsigned short *)&fw2400_length02,
+		.lfwstart	= (unsigned long *)&fw2400_addr02,
+	},
+	{ FW_INFO_ADDR_NOMORE, },
+};
+
+static struct qla_board_info qla_board_tbl[] = {
+	{
+		.drv_name	= qla_driver_name,
+		.isp_name	= "ISP2422",
+		.fw_info	= qla_fw_tbl,
+		.fw_fname	= "ql2400_fw.bin",
+		.alternate_sht	= 1,
+	},
+	{
+		.drv_name	= qla_driver_name,
+		.isp_name	= "ISP2432",
+		.fw_info	= qla_fw_tbl,
+		.fw_fname	= "ql2400_fw.bin",
+		.alternate_sht	= 1,
+	},
+};
+
+static struct pci_device_id qla24xx_pci_tbl[] = {
+	{
+		.vendor		= PCI_VENDOR_ID_QLOGIC,
+		.device		= PCI_DEVICE_ID_QLOGIC_ISP2422,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.driver_data	= (unsigned long)&qla_board_tbl[0],
+	},
+	{
+		.vendor		= PCI_VENDOR_ID_QLOGIC,
+		.device		= PCI_DEVICE_ID_QLOGIC_ISP2432,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.driver_data	= (unsigned long)&qla_board_tbl[1],
+	},
+	{0, 0},
+};
+MODULE_DEVICE_TABLE(pci, qla24xx_pci_tbl);
+
+static int __devinit
+qla24xx_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	return qla2x00_probe_one(pdev,
+	    (struct qla_board_info *)id->driver_data);
+}
+
+static void __devexit
+qla24xx_remove_one(struct pci_dev *pdev)
+{
+	qla2x00_remove_one(pdev);
+}
+
+static struct pci_driver qla24xx_pci_driver = {
+	.name		= "qla2400",
+	.id_table	= qla24xx_pci_tbl,
+	.probe		= qla24xx_probe_one,
+	.remove		= __devexit_p(qla24xx_remove_one),
+};
+
+static int __init
+qla24xx_init(void)
+{
+	return pci_module_init(&qla24xx_pci_driver);
+}
+
+static void __exit
+qla24xx_exit(void)
+{
+	pci_unregister_driver(&qla24xx_pci_driver);
+}
+
+module_init(qla24xx_init);
+module_exit(qla24xx_exit);
+
+MODULE_AUTHOR("QLogic Corporation");
+MODULE_DESCRIPTION("QLogic ISP24xx FC-SCSI Host Bus Adapter driver");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(QLA2XXX_VERSION);
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index fc3234c..73a066c 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2118,7 +2118,7 @@ struct qla_board_info {
 	char isp_name[8];
 	struct qla_fw_info *fw_info;
 	char *fw_fname;
-	struct scsi_host_template *sht;
+	int alternate_sht;
 };
 
 /* Return data from MBC_GET_ID_LIST call. */
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index ba44636..ec30ac1 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -35,6 +35,7 @@ extern void qla24xx_update_fw_options(sc
 extern int qla2x00_load_risc(struct scsi_qla_host *, uint32_t *);
 extern int qla24xx_load_risc_flash(scsi_qla_host_t *, uint32_t *);
 extern int qla24xx_load_risc_hotplug(scsi_qla_host_t *, uint32_t *);
+extern int qla24xx_load_risc(scsi_qla_host_t *, uint32_t *);
 
 extern fc_port_t *qla2x00_alloc_fcport(scsi_qla_host_t *, int);
 
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 5ab88e7..7407780 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3729,3 +3729,66 @@ fail_fw_integrity:
 	return QLA_FUNCTION_FAILED;
 
 }
+
+int
+qla24xx_load_risc(scsi_qla_host_t *ha, uint32_t *srisc_addr)
+{
+	int	rval, num, i;
+	uint32_t cnt;
+	uint32_t *risc_code;
+	uint32_t risc_address;
+	uint32_t risc_code_size;
+	uint32_t *req_ring;
+	struct qla_fw_info *fw_iter;
+
+	rval = QLA_SUCCESS;
+
+	/* Load firmware sequences */
+	fw_iter = ha->brd_info->fw_info;
+	*srisc_addr = *((uint32_t *)fw_iter->lfwstart);
+	while (fw_iter->addressing != FW_INFO_ADDR_NOMORE) {
+		risc_code = (uint32_t *)fw_iter->fwcode;
+		risc_code_size = *((uint32_t *)fw_iter->fwlen);
+		risc_address = *((uint32_t *)fw_iter->lfwstart);
+
+		num = 0;
+		rval = 0;
+		while (risc_code_size > 0 && !rval) {
+			cnt = (uint32_t)(ha->fw_transfer_size >> 2);
+			if (cnt > risc_code_size)
+				cnt = risc_code_size;
+
+			DEBUG7(printk("scsi(%ld): Loading risc segment@ "
+			    "addr %p, number of bytes 0x%x, offset 0x%lx.\n",
+			    ha->host_no, risc_code, cnt, risc_address));
+
+			req_ring = (uint32_t *)ha->request_ring;
+			for (i = 0; i < cnt; i++)
+				req_ring[i] = cpu_to_le32(risc_code[i]);
+
+			rval = qla2x00_load_ram_ext(ha, ha->request_dma,
+			    risc_address, cnt);
+			if (rval) {
+				DEBUG(printk("scsi(%ld): [ERROR] Failed to "
+				    "load segment %d of firmware\n",
+				    ha->host_no, num));
+				qla_printk(KERN_WARNING, ha,
+				    "[ERROR] Failed to load segment %d of "
+				    "firmware\n", num);
+
+				qla2x00_dump_regs(ha);
+				break;
+			}
+
+			risc_code += cnt;
+			risc_address += cnt;
+			risc_code_size -= cnt;
+			num++;
+		}
+
+		/* Next firmware sequence */
+		fw_iter++;
+	}
+
+	return rval;
+}
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 42c53ea..40b124d 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -54,10 +54,15 @@ module_param(ql2xloginretrycount, int, S
 MODULE_PARM_DESC(ql2xloginretrycount,
 		"Specify an alternate value for the NVRAM login retry count.");
 
-int ql2xfwloadbin=1;
+int ql2xfwloadbin;
 module_param(ql2xfwloadbin, int, S_IRUGO|S_IRUSR);
 MODULE_PARM_DESC(ql2xfwloadbin,
-		"Load ISP2xxx firmware image via hotplug.");
+		"Option to specify location in which to load ISP24xx firmware: "
+		" 2 -- load firmware via the request_firmware() (hotplug) "
+		"      interface.  A file, ql2400_fw.bin, (containing the "
+		"      firmware image) should be hotplug accessible."
+		" 1 -- load firmware from flash."
+		" 0 -- load firmware embedded with driver (default).");
 
 static void qla2x00_free_device(scsi_qla_host_t *);
 
@@ -1210,8 +1215,9 @@ int qla2x00_probe_one(struct pci_dev *pd
 	if (pci_enable_device(pdev))
 		goto probe_out;
 
-	host = scsi_host_alloc(brd_info->sht ? brd_info->sht:
-	    &qla2x00_driver_template, sizeof(scsi_qla_host_t));
+	host = scsi_host_alloc(brd_info->alternate_sht ?
+	    &qla24xx_driver_template: &qla2x00_driver_template,
+	    sizeof(scsi_qla_host_t));
 	if (host == NULL) {
 		printk(KERN_WARNING
 		    "qla2xxx: Couldn't allocate host from scsi layer!\n");
@@ -1311,9 +1317,12 @@ int qla2x00_probe_one(struct pci_dev *pd
 		ha->isp_ops.reset_adapter = qla24xx_reset_adapter;
 		ha->isp_ops.nvram_config = qla24xx_nvram_config;
 		ha->isp_ops.update_fw_options = qla24xx_update_fw_options;
-		ha->isp_ops.load_risc = qla24xx_load_risc_flash;
-		if (ql2xfwloadbin)
+		if (ql2xfwloadbin == 2)
 			ha->isp_ops.load_risc = qla24xx_load_risc_hotplug;
+		else if (ql2xfwloadbin == 1)
+			ha->isp_ops.load_risc = qla24xx_load_risc_flash;
+		else
+			ha->isp_ops.load_risc = qla24xx_load_risc;
 		ha->isp_ops.pci_info_str = qla24xx_pci_info_str;
 		ha->isp_ops.fw_version_str = qla24xx_fw_version_str;
 		ha->isp_ops.intr_handler = qla24xx_intr_handler;
@@ -2419,68 +2428,12 @@ qla2x00_down_timeout(struct semaphore *s
 	return -ETIMEDOUT;
 }
 
-static struct qla_board_info qla_board_tbl[] = {
-	{
-		.drv_name	= "qla2400",
-		.isp_name	= "ISP2422",
-		.fw_fname	= "ql2400_fw.bin",
-		.sht		= &qla24xx_driver_template,
-	},
-	{
-		.drv_name	= "qla2400",
-		.isp_name	= "ISP2432",
-		.fw_fname	= "ql2400_fw.bin",
-		.sht		= &qla24xx_driver_template,
-	},
-};
-
-static struct pci_device_id qla2xxx_pci_tbl[] = {
-	{
-		.vendor		= PCI_VENDOR_ID_QLOGIC,
-		.device		= PCI_DEVICE_ID_QLOGIC_ISP2422,
-		.subvendor	= PCI_ANY_ID,
-		.subdevice	= PCI_ANY_ID,
-		.driver_data	= (unsigned long)&qla_board_tbl[0],
-	},
-	{
-		.vendor		= PCI_VENDOR_ID_QLOGIC,
-		.device		= PCI_DEVICE_ID_QLOGIC_ISP2432,
-		.subvendor	= PCI_ANY_ID,
-		.subdevice	= PCI_ANY_ID,
-		.driver_data	= (unsigned long)&qla_board_tbl[1],
-	},
-	{0, 0},
-};
-MODULE_DEVICE_TABLE(pci, qla2xxx_pci_tbl);
-
-static int __devinit
-qla2xxx_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
-{
-	return qla2x00_probe_one(pdev,
-	    (struct qla_board_info *)id->driver_data);
-}
-
-static void __devexit
-qla2xxx_remove_one(struct pci_dev *pdev)
-{
-	qla2x00_remove_one(pdev);
-}
-
-static struct pci_driver qla2xxx_pci_driver = {
-	.name		= "qla2xxx",
-	.id_table	= qla2xxx_pci_tbl,
-	.probe		= qla2xxx_probe_one,
-	.remove		= __devexit_p(qla2xxx_remove_one),
-};
-
 /**
  * qla2x00_module_init - Module initialization.
  **/
 static int __init
 qla2x00_module_init(void)
 {
-	int ret = 0;
-
 	/* Allocate cache for SRBs. */
 	srb_cachep = kmem_cache_create("qla2xxx_srbs", sizeof(srb_t), 0,
 	    SLAB_HWCACHE_ALIGN, NULL, NULL);
@@ -2501,12 +2454,7 @@ qla2x00_module_init(void)
 		return -ENODEV;
 
 	printk(KERN_INFO "QLogic Fibre Channel HBA Driver\n");
-	ret = pci_module_init(&qla2xxx_pci_driver);
-	if (ret) {
-		kmem_cache_destroy(srb_cachep);
-		fc_release_transport(qla2xxx_transport_template);
-	}
-	return ret;
+	return 0;
 }
 
 /**
@@ -2515,7 +2463,6 @@ qla2x00_module_init(void)
 static void __exit
 qla2x00_module_exit(void)
 {
-	pci_unregister_driver(&qla2xxx_pci_driver);
 	kmem_cache_destroy(srb_cachep);
 	fc_release_transport(qla2xxx_transport_template);
 }
---
0.99.8.GIT

-- 
Andrew Vasquez
