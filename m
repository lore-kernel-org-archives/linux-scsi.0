From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 18/19] qla2xxx: Dont clear drv active on iospace config failure.
Date: Wed, 21 Nov 2012 02:40:43 -0500
Message-ID: <1353483644-17262-19-git-send-email-saurav.kashyap@qlogic.com>
References: <1353483644-17262-1-git-send-email-saurav.kashyap@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:13988 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753551Ab2KUH64 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Nov 2012 02:58:56 -0500
In-Reply-To: <1353483644-17262-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_nx.c |    2 --
 drivers/scsi/qla2xxx/qla_os.c |    8 ++++++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 45f6191..3e3f593 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -1655,7 +1655,6 @@ qla82xx_iospace_config(struct qla_hw_data *ha)
 	if (!ha->nx_pcibase) {
 		ql_log_pci(ql_log_fatal, ha->pdev, 0x000e,
 		    "Cannot remap pcibase MMIO, aborting.\n");
-		pci_release_regions(ha->pdev);
 		goto iospace_error_exit;
 	}
 
@@ -1670,7 +1669,6 @@ qla82xx_iospace_config(struct qla_hw_data *ha)
 		if (!ha->nxdb_wr_ptr) {
 			ql_log_pci(ql_log_fatal, ha->pdev, 0x000f,
 			    "Cannot remap MMIO, aborting.\n");
-			pci_release_regions(ha->pdev);
 			goto iospace_error_exit;
 		}
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 6af369b..3a1661c 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2367,7 +2367,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	/* Configure PCI I/O space */
 	ret = ha->isp_ops->iospace_config(ha);
 	if (ret)
-		goto probe_hw_failed;
+		goto iospace_config_failed;
 
 	ql_log_pci(ql_log_info, pdev, 0x001d,
 	    "Found an ISP%04X irq %d iobase 0x%p.\n",
@@ -2678,7 +2678,11 @@ probe_hw_failed:
 		qla82xx_idc_lock(ha);
 		qla82xx_clear_drv_active(ha);
 		qla82xx_idc_unlock(ha);
-		iounmap((device_reg_t __iomem *)ha->nx_pcibase);
+	}
+iospace_config_failed:
+	if (IS_QLA82XX(ha)) {
+		if (!ha->nx_pcibase)
+			iounmap((device_reg_t __iomem *)ha->nx_pcibase);
 		if (!ql2xdbwr)
 			iounmap((device_reg_t __iomem *)ha->nxdb_wr_ptr);
 	} else {
-- 
1.7.7

