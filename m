From: Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH v2 6/6] scsi/qla2xxx: use pcie_is_pcie() to simplify code
Date: Thu, 5 Sep 2013 15:55:30 +0800
Message-ID: <1378367730-25996-6-git-send-email-wangyijing@huawei.com>
References: <1378367730-25996-1-git-send-email-wangyijing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:28874 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757361Ab3IEH7R (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Sep 2013 03:59:17 -0400
In-Reply-To: <1378367730-25996-1-git-send-email-wangyijing@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Gavin Shan <shangw@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, Yijing Wang <wangyijing@huawei.com>, Hanjun Guo <guohanjun@huawei.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-driver@qlogic.com, linux-scsi@vger.kernel.org

Use pci_is_pcie() instead of pci_find_capability
to simplify code.

Acked-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-driver@qlogic.com
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/scsi/qla2xxx/qla_mr.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 2482975..5494d27 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -507,7 +507,7 @@ qlafx00_pci_config(scsi_qla_host_t *vha)
 	pci_write_config_word(ha->pdev, PCI_COMMAND, w);
 
 	/* PCIe -- adjust Maximum Read Request Size (2048). */
-	if (pci_find_capability(ha->pdev, PCI_CAP_ID_EXP))
+	if (pci_is_pcie(ha->pdev))
 		pcie_set_readrq(ha->pdev, 2048);
 
 	ha->chip_revision = ha->pdev->revision;
@@ -660,10 +660,8 @@ char *
 qlafx00_pci_info_str(struct scsi_qla_host *vha, char *str)
 {
 	struct qla_hw_data *ha = vha->hw;
-	int pcie_reg;
 
-	pcie_reg = pci_find_capability(ha->pdev, PCI_CAP_ID_EXP);
-	if (pcie_reg) {
+	if (pci_is_pcie(ha->pdev)) {
 		strcpy(str, "PCIe iSA");
 		return str;
 	}
-- 
1.7.1


