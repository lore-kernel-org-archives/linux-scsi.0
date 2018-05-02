From: John Garry <john.garry@huawei.com>
Subject: [PATCH 10/11] scsi: hisi_sas: add readl poll timeout helper wrappers
Date: Wed, 2 May 2018 23:56:33 +0800
Message-ID: <1525276594-92173-11-git-send-email-john.garry@huawei.com>
References: <1525276594-92173-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1525276594-92173-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxarm@huawei.com, linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

It is common to use readl poll timeout helpers in the
driver, so create custom wrappers.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index d6e705f..28bb71e 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -394,6 +394,20 @@ static u32 hisi_sas_phy_read32(struct hisi_hba *hisi_hba,
 	return readl(regs);
 }
 
+#define hisi_sas_read32_poll_timeout(off, val, cond, delay_us,		\
+				     timeout_us)			\
+({									\
+	void __iomem *regs = hisi_hba->regs + off;			\
+	readl_poll_timeout(regs, val, cond, delay_us, timeout_us);	\
+})
+
+#define hisi_sas_read32_poll_timeout_atomic(off, val, cond, delay_us,	\
+					    timeout_us)			\
+({									\
+	void __iomem *regs = hisi_hba->regs + off;			\
+	readl_poll_timeout_atomic(regs, val, cond, delay_us, timeout_us);\
+})
+
 static void init_reg_v3_hw(struct hisi_hba *hisi_hba)
 {
 	struct pci_dev *pdev = hisi_hba->pci_dev;
@@ -684,8 +698,8 @@ static int reset_hw_v3_hw(struct hisi_hba *hisi_hba)
 	udelay(50);
 
 	/* Ensure axi bus idle */
-	ret = readl_poll_timeout(hisi_hba->regs + AXI_CFG, val, !val,
-			20000, 1000000);
+	ret = hisi_sas_read32_poll_timeout(AXI_CFG, val, !val,
+					   20000, 1000000);
 	if (ret) {
 		dev_err(dev, "axi bus is not idle, ret = %d!\n", ret);
 		return -EIO;
@@ -1977,8 +1991,9 @@ static int soft_reset_v3_hw(struct hisi_hba *hisi_hba)
 	hisi_sas_write32(hisi_hba, AXI_MASTER_CFG_BASE + AM_CTRL_GLOBAL, 0x1);
 
 	/* wait until bus idle */
-	rc = readl_poll_timeout(hisi_hba->regs + AXI_MASTER_CFG_BASE +
-		AM_CURR_TRANS_RETURN, status, status == 0x3, 10, 100);
+	rc = hisi_sas_read32_poll_timeout(AXI_MASTER_CFG_BASE +
+					  AM_CURR_TRANS_RETURN, status,
+					  status == 0x3, 10, 100);
 	if (rc) {
 		dev_err(dev, "axi bus is not idle, rc = %d\n", rc);
 		return rc;
@@ -2396,8 +2411,9 @@ static int hisi_sas_v3_suspend(struct pci_dev *pdev, pm_message_t state)
 		AM_CTRL_GLOBAL, reg_val);
 
 	/* wait until bus idle */
-	rc = readl_poll_timeout(hisi_hba->regs + AXI_MASTER_CFG_BASE +
-		AM_CURR_TRANS_RETURN, status, status == 0x3, 10, 100);
+	rc = hisi_sas_read32_poll_timeout(AXI_MASTER_CFG_BASE +
+					  AM_CURR_TRANS_RETURN, status,
+					  status == 0x3, 10, 100);
 	if (rc) {
 		dev_err(dev, "axi bus is not idle, rc = %d\n", rc);
 		clear_bit(HISI_SAS_REJECT_CMD_BIT, &hisi_hba->flags);
-- 
1.9.1
