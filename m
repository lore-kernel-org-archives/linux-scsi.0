From: Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH v2 2/6] scsi/csiostor: use pcie_capability_xxx to simplify code
Date: Thu, 5 Sep 2013 15:55:26 +0800
Message-ID: <1378367730-25996-2-git-send-email-wangyijing@huawei.com>
References: <1378367730-25996-1-git-send-email-wangyijing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <1378367730-25996-1-git-send-email-wangyijing@huawei.com>
Sender: linux-pci-owner@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Gavin Shan <shangw@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, Yijing Wang <wangyijing@huawei.com>, Hanjun Guo <guohanjun@huawei.com>, Jiang Liu <jiang.liu@huawei.com>, Naresh Kumar Inna <naresh@chelsio.com>, "David S. Miller" <davem@davemloft.net>, Jesper Juhl <jj@chaosbits.net>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

v1->v2: add #define for Completion Timeout Value, and use
        pcie_capability_clear_and_set_word() instead suggested by Bjorn.

Pcie_capability_xxx() interfaces were introduced to
simplify code to access PCIe Cap config space. And
because PCI core saves the PCIe Cap offset in
set_pcie_port_type() when device is enumerated.
So we can use pci_is_pcie() instead.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Naresh Kumar Inna <naresh@chelsio.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jesper Juhl <jj@chaosbits.net>
Cc: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/scsi/csiostor/csio_hw.c |   14 +++-----------
 include/uapi/linux/pci_regs.h   |    1 +
 2 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/csiostor/csio_hw.c b/drivers/scsi/csiostor/csio_hw.c
index 0eb35b9..07f493a 100644
--- a/drivers/scsi/csiostor/csio_hw.c
+++ b/drivers/scsi/csiostor/csio_hw.c
@@ -855,17 +855,9 @@ csio_hw_get_flash_params(struct csio_hw *hw)
 static void
 csio_set_pcie_completion_timeout(struct csio_hw *hw, u8 range)
 {
-	uint16_t val;
-	int pcie_cap;
-
-	if (!csio_pci_capability(hw->pdev, PCI_CAP_ID_EXP, &pcie_cap)) {
-		pci_read_config_word(hw->pdev,
-				     pcie_cap + PCI_EXP_DEVCTL2, &val);
-		val &= 0xfff0;
-		val |= range ;
-		pci_write_config_word(hw->pdev,
-				      pcie_cap + PCI_EXP_DEVCTL2, val);
-	}
+	if (pci_is_pcie(hw->pdev))
+		pcie_capability_clear_and_set_word(hw->pdev, PCI_EXP_DEVCTL2,
+				PCI_EXP_DEVCTL2_COMP_TIME, range);
 }
 
 /*****************************************************************************/
diff --git a/include/uapi/linux/pci_regs.h b/include/uapi/linux/pci_regs.h
index baa7852..cd74182 100644
--- a/include/uapi/linux/pci_regs.h
+++ b/include/uapi/linux/pci_regs.h
@@ -558,6 +558,7 @@
 #define  PCI_EXP_DEVCAP2_OBFF_MSG	0x00040000 /* New message signaling */
 #define  PCI_EXP_DEVCAP2_OBFF_WAKE	0x00080000 /* Re-use WAKE# for OBFF */
 #define PCI_EXP_DEVCTL2		40	/* Device Control 2 */
+#define  PCI_EXP_DEVCTL2_COMP_TIME	0x0f	/* Completion Timeout Value */
 #define  PCI_EXP_DEVCTL2_ARI		0x20	/* Alternative Routing-ID */
 #define  PCI_EXP_DEVCTL2_IDO_REQ_EN	0x0100	/* Allow IDO for requests */
 #define  PCI_EXP_DEVCTL2_IDO_CMP_EN	0x0200	/* Allow IDO for completions */
-- 
1.7.1
