From: Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH 6/9] hpsa: rework pci pm related code for simplification
Date: Tue, 18 Jun 2013 16:21:13 +0800
Message-ID: <1371543673-9692-1-git-send-email-wangyijing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: linux-kernel@vger.kernel.org, Hanjun Guo <guohanjun@huawei.com>, jiang.liu@huawei.com, Yijing Wang <wangyijing@huawei.com>, iss_storagedev@hp.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Use pci core pm interface to simplify code.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Cc: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: iss_storagedev@hp.com
Cc: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/scsi/hpsa.c |   16 +++-------------
 1 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 7f4f790..f5ba6d4 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3753,9 +3753,6 @@ static int hpsa_message(struct pci_dev *pdev, unsigned char opcode,
 static int hpsa_controller_hard_reset(struct pci_dev *pdev,
 	void * __iomem vaddr, u32 use_doorbell)
 {
-	u16 pmcsr;
-	int pos;
-
 	if (use_doorbell) {
 		/* For everything after the P600, the PCI power state method
 		 * of resetting the controller doesn't work, so we have this
@@ -3773,8 +3770,7 @@ static int hpsa_controller_hard_reset(struct pci_dev *pdev,
 		 * this causes a secondary PCI reset which will reset the
 		 * controller." */
 
-		pos = pci_find_capability(pdev, PCI_CAP_ID_PM);
-		if (pos == 0) {
+		if (!pdev->pm_cap) {
 			dev_err(&pdev->dev,
 				"hpsa_reset_controller: "
 				"PCI PM not supported\n");
@@ -3782,18 +3778,12 @@ static int hpsa_controller_hard_reset(struct pci_dev *pdev,
 		}
 		dev_info(&pdev->dev, "using PCI PM to reset controller\n");
 		/* enter the D3hot power management state */
-		pci_read_config_word(pdev, pos + PCI_PM_CTRL, &pmcsr);
-		pmcsr &= ~PCI_PM_CTRL_STATE_MASK;
-		pmcsr |= PCI_D3hot;
-		pci_write_config_word(pdev, pos + PCI_PM_CTRL, pmcsr);
+		pci_set_power_state(pdev, PCI_D3hot);
 
 		msleep(500);
 
 		/* enter the D0 power management state */
-		pmcsr &= ~PCI_PM_CTRL_STATE_MASK;
-		pmcsr |= PCI_D0;
-		pci_write_config_word(pdev, pos + PCI_PM_CTRL, pmcsr);
-
+		pci_set_power_state(pdev, PCI_D0);
 		/*
 		 * The P600 requires a small delay when changing states.
 		 * Otherwise we may think the board did not reset and we bail.
-- 
1.7.1
