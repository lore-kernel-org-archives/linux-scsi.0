From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 20/42] qla2xxx: Wrong PCIe(2.5Gb/s x8) speed in the kerenel message for ISP82xx.
Date: Wed, 22 Aug 2012 14:21:14 -0400
Message-ID: <1345659696-3670-21-git-send-email-chad.dupuis@qlogic.com>
References: <1345659696-3670-1-git-send-email-chad.dupuis@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:58992 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S964799Ab2HVSiS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Aug 2012 14:38:18 -0400
In-Reply-To: <1345659696-3670-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Atul Deshmukh <atul.deshmukh@qlogic.com>

qla2xxx show wrong PCIe(2.5Gb/s x8) speed in the kerenel message. It should be
5.0Gb/s.

Signed-off-by: Atul Deshmukh <atul.deshmukh@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_gbl.h |    1 -
 drivers/scsi/qla2xxx/qla_nx.c  |   19 -------------------
 drivers/scsi/qla2xxx/qla_os.c  |    2 +-
 3 files changed, 1 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 5afd72e..6acb397 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -558,7 +558,6 @@ extern void qla24xx_wrt_rsp_reg(struct qla_hw_data *, uint16_t, uint16_t);
 /* PCI related functions */
 extern int qla82xx_pci_config(struct scsi_qla_host *);
 extern int qla82xx_pci_mem_read_2M(struct qla_hw_data *, u64, void *, int);
-extern char *qla82xx_pci_info_str(struct scsi_qla_host *, char *);
 extern int qla82xx_pci_region_offset(struct pci_dev *, int);
 extern int qla82xx_iospace_config(struct qla_hw_data *);
 
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 3653c8f..9fc08b8 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -1612,25 +1612,6 @@ qla82xx_get_fw_offs(struct qla_hw_data *ha)
 }
 
 /* PCI related functions */
-char *
-qla82xx_pci_info_str(struct scsi_qla_host *vha, char *str)
-{
-	int pcie_reg;
-	struct qla_hw_data *ha = vha->hw;
-	char lwstr[6];
-	uint16_t lnk;
-
-	pcie_reg = pci_pcie_cap(ha->pdev);
-	pci_read_config_word(ha->pdev, pcie_reg + PCI_EXP_LNKSTA, &lnk);
-	ha->link_width = (lnk >> 4) & 0x3f;
-
-	strcpy(str, "PCIe (");
-	strcat(str, "2.5Gb/s ");
-	snprintf(lwstr, sizeof(lwstr), "x%d)", ha->link_width);
-	strcat(str, lwstr);
-	return str;
-}
-
 int qla82xx_pci_region_offset(struct pci_dev *pdev, int region)
 {
 	unsigned long val = 0;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 22db1f6e..5439d48 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1919,7 +1919,7 @@ static struct isp_operations qla82xx_isp_ops = {
 	.nvram_config		= qla81xx_nvram_config,
 	.update_fw_options	= qla24xx_update_fw_options,
 	.load_risc		= qla82xx_load_risc,
-	.pci_info_str		= qla82xx_pci_info_str,
+	.pci_info_str		= qla24xx_pci_info_str,
 	.fw_version_str		= qla24xx_fw_version_str,
 	.intr_handler		= qla82xx_intr_handler,
 	.enable_intrs		= qla82xx_enable_intrs,
-- 
1.7.7

