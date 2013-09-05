From: Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH v2 1/6] scsi/bfa: use pcie_set/get_readrq to simplify code
Date: Thu, 5 Sep 2013 15:55:25 +0800
Message-ID: <1378367730-25996-1-git-send-email-wangyijing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Gavin Shan <shangw@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, Yijing Wang <wangyijing@huawei.com>, Hanjun Guo <guohanjun@huawei.com>, Jiang Liu <jiang.liu@huawei.com>, Anil Gurumurthy <agurumur@brocade.com>, Vijaya Mohan Guvva <vmohan@brocade.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

v1->v2: use pcie_get/set_readrq to simplify code
a lot suggestd by Bjorn.

Use pcie_get_readrq()/pcie_set_readrq() to simplify
code.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Anil Gurumurthy <agurumur@brocade.com>
Cc: Vijaya Mohan Guvva <vmohan@brocade.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/scsi/bfa/bfad.c |   48 +++++-----------------------------------------
 1 files changed, 6 insertions(+), 42 deletions(-)

diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index f8ca7be..0a458db 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -766,50 +766,14 @@ bfad_pci_init(struct pci_dev *pdev, struct bfad_s *bfad)
 	bfad->pcidev = pdev;
 
 	/* Adjust PCIe Maximum Read Request Size */
-	if (pcie_max_read_reqsz > 0) {
-		int pcie_cap_reg;
-		u16 pcie_dev_ctl;
-		u16 mask = 0xffff;
-
-		switch (pcie_max_read_reqsz) {
-		case 128:
-			mask = 0x0;
-			break;
-		case 256:
-			mask = 0x1000;
-			break;
-		case 512:
-			mask = 0x2000;
-			break;
-		case 1024:
-			mask = 0x3000;
-			break;
-		case 2048:
-			mask = 0x4000;
-			break;
-		case 4096:
-			mask = 0x5000;
-			break;
-		default:
-			break;
-		}
-
-		pcie_cap_reg = pci_find_capability(pdev, PCI_CAP_ID_EXP);
-		if (mask != 0xffff && pcie_cap_reg) {
-			pcie_cap_reg += 0x08;
-			pci_read_config_word(pdev, pcie_cap_reg, &pcie_dev_ctl);
-			if ((pcie_dev_ctl & 0x7000) != mask) {
-				printk(KERN_WARNING "BFA[%s]: "
+	if (pcie_max_read_reqsz > 0 && pci_is_pcie(pdev)) {
+		int max_rq = pcie_get_readrq(pdev);
+		if (max_rq > 128 && max_rq < 4096 && is_power_of_2(max_rq))
+			printk(KERN_WARNING "BFA[%s]: "
 				"pcie_max_read_request_size is %d, "
-				"reset to %d\n", bfad->pci_name,
-				(1 << ((pcie_dev_ctl & 0x7000) >> 12)) << 7,
+				"reset to %d\n", bfad->pci_name, max_rq,
 				pcie_max_read_reqsz);
-
-				pcie_dev_ctl &= ~0x7000;
-				pci_write_config_word(pdev, pcie_cap_reg,
-						pcie_dev_ctl | mask);
-			}
-		}
+		pcie_set_readrq(pdev, pcie_max_read_reqsz);
 	}
 
 	pci_save_state(pdev);
-- 
1.7.1
