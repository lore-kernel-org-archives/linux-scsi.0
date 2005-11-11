From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 3/4]  qla2xxx: Add support for embedded ISP24xx firmware.
Date: 11 Nov 2005 00:08:21 -0800
Message-ID: <20051111080817.12822.53293.sendpatchset@andrew-vasquezs-powerbook-g4-15.local>
References: <20051111080733.12822.9617.sendpatchset@andrew-vasquezs-powerbook-g4-15.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:32656 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S1751251AbVKKIIW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Nov 2005 03:08:22 -0500
In-Reply-To: <20051111080733.12822.9617.sendpatchset@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@SteelEye.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>


Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

 drivers/scsi/qla2xxx/Makefile   |    3 +
 drivers/scsi/qla2xxx/qla_init.c |   61 +++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_os.c   |   82 +++++++++++++--------------------------
 3 files changed, 91 insertions(+), 55 deletions(-)

applies-to: b089655ba9fe518bb958b9bafc29daa54b3822e5
a94d6192c236c57e52dd5b05320a553b3c9932d6
diff --git a/drivers/scsi/qla2xxx/Makefile b/drivers/scsi/qla2xxx/Makefile
index 549dfe4..40c0de1 100644
--- a/drivers/scsi/qla2xxx/Makefile
+++ b/drivers/scsi/qla2xxx/Makefile
@@ -10,10 +10,11 @@ qla2200-y := ql2200.o ql2200_fw.o
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
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 2425289..88bd78e 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3550,6 +3550,67 @@ qla2x00_load_risc(scsi_qla_host_t *ha, u
 }
 
 int
+qla24xx_load_risc(scsi_qla_host_t *ha, uint32_t *srisc_addr)
+{
+	int	rval, num, i;
+	uint32_t cnt;
+	uint32_t *risc_code;
+	uint32_t risc_addr, risc_size;
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
+		risc_size = *((uint32_t *)fw_iter->fwlen);
+		risc_addr = *((uint32_t *)fw_iter->lfwstart);
+
+		num = 0;
+		rval = 0;
+		while (risc_size > 0 && !rval) {
+			cnt = (uint32_t)(ha->fw_transfer_size >> 2);
+			if (cnt > risc_size)
+				cnt = risc_size;
+
+			DEBUG7(printk("scsi(%ld): Loading risc segment@ "
+			    "addr %p, number of bytes 0x%x, offset 0x%lx.\n",
+			    ha->host_no, risc_code, cnt, risc_addr));
+
+			req_ring = (uint32_t *)ha->request_ring;
+			for (i = 0; i < cnt; i++)
+				req_ring[i] = cpu_to_le32(risc_code[i]);
+
+			rval = qla2x00_load_ram(ha, ha->request_dma, risc_addr,
+			    cnt);
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
+			risc_addr += cnt;
+			risc_size -= cnt;
+			num++;
+		}
+
+		/* Next firmware sequence */
+		fw_iter++;
+	}
+	return rval;
+}
+
+int
 qla24xx_load_risc_flash(scsi_qla_host_t *ha, uint32_t *srisc_addr)
 {
 	int	rval;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index b98ad53..71dfeba 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -54,6 +54,13 @@ module_param(ql2xloginretrycount, int, S
 MODULE_PARM_DESC(ql2xloginretrycount,
 		"Specify an alternate value for the NVRAM login retry count.");
 
+#if defined(CONFIG_SCSI_QLA2XXX_EMBEDDED_FIRMWARE)
+int ql2xfwloadflash;
+module_param(ql2xfwloadflash, int, S_IRUGO|S_IRUSR);
+MODULE_PARM_DESC(ql2xfwloadflash,
+		"Load ISP24xx firmware image from FLASH (onboard memory).");
+#endif
+
 static void qla2x00_free_device(scsi_qla_host_t *);
 
 static void qla2x00_config_dma_addressing(scsi_qla_host_t *ha);
@@ -1367,10 +1374,10 @@ int qla2x00_probe_one(struct pci_dev *pd
 		ha->isp_ops.reset_adapter = qla24xx_reset_adapter;
 		ha->isp_ops.nvram_config = qla24xx_nvram_config;
 		ha->isp_ops.update_fw_options = qla24xx_update_fw_options;
-#if defined(CONFIG_SCSI_QLA2XXX_EMBEDDED_FIRMWARE)
-		ha->isp_ops.load_risc = qla24xx_load_risc_flash;
-#else
 		ha->isp_ops.load_risc = qla24xx_load_risc;
+#if defined(CONFIG_SCSI_QLA2XXX_EMBEDDED_FIRMWARE)
+		if (ql2xfwloadflash)
+			ha->isp_ops.load_risc = qla24xx_load_risc_flash;
 #endif
 		ha->isp_ops.pci_info_str = qla24xx_pci_info_str;
 		ha->isp_ops.fw_version_str = qla24xx_fw_version_str;
@@ -2488,53 +2495,8 @@ qla2x00_down_timeout(struct semaphore *s
 #if defined(CONFIG_SCSI_QLA2XXX_EMBEDDED_FIRMWARE)
 
 #define qla2x00_release_firmware()	do { } while (0)
-
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
+#define qla2x00_pci_module_init()	(0)
+#define qla2x00_pci_module_exit()	do { } while (0)
 
 #else	/* !defined(CONFIG_SCSI_QLA2XXX_EMBEDDED_FIRMWARE) */
 
@@ -2645,8 +2607,6 @@ qla2xxx_remove_one(struct pci_dev *pdev)
 	qla2x00_remove_one(pdev);
 }
 
-#endif
-
 static struct pci_driver qla2xxx_pci_driver = {
 	.name		= "qla2xxx",
 	.owner		= THIS_MODULE,
@@ -2655,6 +2615,20 @@ static struct pci_driver qla2xxx_pci_dri
 	.remove		= __devexit_p(qla2xxx_remove_one),
 };
 
+static inline int
+qla2x00_pci_module_init(void)
+{
+	return pci_module_init(&qla2xxx_pci_driver);
+}
+
+static inline void
+qla2x00_pci_module_exit(void)
+{
+	pci_unregister_driver(&qla2xxx_pci_driver);
+}
+
+#endif
+
 /**
  * qla2x00_module_init - Module initialization.
  **/
@@ -2686,7 +2660,7 @@ qla2x00_module_init(void)
 		return -ENODEV;
 
 	printk(KERN_INFO "QLogic Fibre Channel HBA Driver\n");
-	ret = pci_module_init(&qla2xxx_pci_driver);
+	ret = qla2x00_pci_module_init();
 	if (ret) {
 		kmem_cache_destroy(srb_cachep);
 		fc_release_transport(qla2xxx_transport_template);
@@ -2700,7 +2674,7 @@ qla2x00_module_init(void)
 static void __exit
 qla2x00_module_exit(void)
 {
-	pci_unregister_driver(&qla2xxx_pci_driver);
+	qla2x00_pci_module_exit();
 	qla2x00_release_firmware();
 	kmem_cache_destroy(srb_cachep);
 	fc_release_transport(qla2xxx_transport_template);
---
0.99.9.GIT


-- 
Andrew Vasquez
