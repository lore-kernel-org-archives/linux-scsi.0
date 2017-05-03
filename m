From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH V2 03/36] smartpqi: set pci completion timeout
Date: Wed, 3 May 2017 18:52:34 -0500
Message-ID: <149385555445.11043.11545980968391948598.stgit@brunhilda>
References: <149385549428.11043.8013091835763091910.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0076.outbound.protection.outlook.com ([104.47.32.76]:11168
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751961AbdECXws (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 3 May 2017 19:52:48 -0400
In-Reply-To: <149385549428.11043.8013091835763091910.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microsemi.com>

add support for setting PCIe completion timeout.

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index b5a3505..735cef5 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -5437,6 +5437,13 @@ static int pqi_ctrl_init(struct pqi_ctrl_info *ctrl_info)
 	return 0;
 }
 
+static inline int pqi_set_pcie_completion_timeout(struct pci_dev *pci_dev,
+	u16 timeout)
+{
+	return pcie_capability_clear_and_set_word(pci_dev, PCI_EXP_DEVCTL2,
+		PCI_EXP_DEVCTL2_COMP_TIMEOUT, timeout);
+}
+
 static int pqi_pci_init(struct pqi_ctrl_info *ctrl_info)
 {
 	int rc;
@@ -5480,6 +5487,17 @@ static int pqi_pci_init(struct pqi_ctrl_info *ctrl_info)
 	ctrl_info->registers = ctrl_info->iomem_base;
 	ctrl_info->pqi_registers = &ctrl_info->registers->pqi_registers;
 
+#define PCI_EXP_COMP_TIMEOUT_65_TO_210_MS		0x6
+
+	/* Increase the PCIe completion timeout. */
+	rc = pqi_set_pcie_completion_timeout(ctrl_info->pci_dev,
+		PCI_EXP_COMP_TIMEOUT_65_TO_210_MS);
+	if (rc) {
+		dev_err(&ctrl_info->pci_dev->dev,
+			"failed to set PCIe completion timeout\n");
+		goto release_regions;
+	}
+
 	/* Enable bus mastering. */
 	pci_set_master(ctrl_info->pci_dev);
 
