From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 11/13] qla2xxx: Convert from pci_module_init() to pci_register_driver().
Date: Fri, 23 Jun 2006 16:11:22 -0700
Message-ID: <1151104277528-git-send-email-andrew.vasquez@qlogic.com>
References: <20060623230815.GB10758@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:58033 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S1752165AbWFWXLW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jun 2006 19:11:22 -0400
In-Reply-To: <20060623230815.GB10758@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Also remove qla2xxx_probe_one/qla2xxx_remove_one stubs previously
used with external firmware module loaders.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |   38 ++++++++------------------------------
 1 files changed, 8 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index a15b609..3516e36 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1337,7 +1337,8 @@ qla24xx_disable_intrs(scsi_qla_host_t *h
 /*
  * PCI driver interface
  */
-static int qla2x00_probe_one(struct pci_dev *pdev)
+static int __devinit
+qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	int	ret = -ENODEV;
 	device_reg_t __iomem *reg;
@@ -1650,7 +1651,8 @@ probe_out:
 	return ret;
 }
 
-static void qla2x00_remove_one(struct pci_dev *pdev)
+static void __devexit
+qla2x00_remove_one(struct pci_dev *pdev)
 {
 	scsi_qla_host_t *ha;
 
@@ -2644,40 +2646,16 @@ static struct pci_device_id qla2xxx_pci_
 };
 MODULE_DEVICE_TABLE(pci, qla2xxx_pci_tbl);
 
-static int __devinit
-qla2xxx_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
-{
-	return qla2x00_probe_one(pdev);
-}
-
-static void __devexit
-qla2xxx_remove_one(struct pci_dev *pdev)
-{
-	qla2x00_remove_one(pdev);
-}
-
 static struct pci_driver qla2xxx_pci_driver = {
 	.name		= QLA2XXX_DRIVER_NAME,
 	.driver		= {
 		.owner		= THIS_MODULE,
 	},
 	.id_table	= qla2xxx_pci_tbl,
-	.probe		= qla2xxx_probe_one,
-	.remove		= __devexit_p(qla2xxx_remove_one),
+	.probe		= qla2x00_probe_one,
+	.remove		= __devexit_p(qla2x00_remove_one),
 };
 
-static inline int
-qla2x00_pci_module_init(void)
-{
-	return pci_module_init(&qla2xxx_pci_driver);
-}
-
-static inline void
-qla2x00_pci_module_exit(void)
-{
-	pci_unregister_driver(&qla2xxx_pci_driver);
-}
-
 /**
  * qla2x00_module_init - Module initialization.
  **/
@@ -2706,7 +2684,7 @@ qla2x00_module_init(void)
 		return -ENODEV;
 
 	printk(KERN_INFO "QLogic Fibre Channel HBA Driver\n");
-	ret = qla2x00_pci_module_init();
+	ret = pci_register_driver(&qla2xxx_pci_driver);
 	if (ret) {
 		kmem_cache_destroy(srb_cachep);
 		fc_release_transport(qla2xxx_transport_template);
@@ -2720,7 +2698,7 @@ qla2x00_module_init(void)
 static void __exit
 qla2x00_module_exit(void)
 {
-	qla2x00_pci_module_exit();
+	pci_unregister_driver(&qla2xxx_pci_driver);
 	qla2x00_release_firmware();
 	kmem_cache_destroy(srb_cachep);
 	fc_release_transport(qla2xxx_transport_template);
-- 
1.4.1.rc1.gf603


