From: Frederick Lawler <fred@fredlawl.com>
Subject: [PATCH] scsi: csiostor: Prefer pcie_capability_read_word()
Date: Wed, 17 Jul 2019 21:07:43 -0500
Message-ID: <20190718020745.8867-8-fred@fredlawl.com>
References: <20190718020745.8867-1-fred@fredlawl.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190718020745.8867-1-fred@fredlawl.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.ibm.com, martin.petersen@oracle.com
Cc: Frederick Lawler <fred@fredlawl.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, bhelgaas@google.com
List-Id: linux-scsi@vger.kernel.org

Commit 8c0d3a02c130 ("PCI: Add accessors for PCI Express Capability")
added accessors for the PCI Express Capability so that drivers didn't
need to be aware of differences between v1 and v2 of the PCI
Express Capability.

Replace pci_read_config_word() and pci_write_config_word() calls with
pcie_capability_read_word() and pcie_capability_write_word().

Signed-off-by: Frederick Lawler <fred@fredlawl.com>
---
 drivers/scsi/csiostor/csio_wr.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/csiostor/csio_wr.c b/drivers/scsi/csiostor/csio_wr.c
index 03bd896cdbb9..0ca695110f54 100644
--- a/drivers/scsi/csiostor/csio_wr.c
+++ b/drivers/scsi/csiostor/csio_wr.c
@@ -1316,7 +1316,6 @@ csio_wr_fixup_host_params(struct csio_hw *hw)
 	u32 fl_align = clsz < 32 ? 32 : clsz;
 	u32 pack_align;
 	u32 ingpad, ingpack;
-	int pcie_cap;
 
 	csio_wr_reg32(hw, HOSTPAGESIZEPF0_V(s_hps) | HOSTPAGESIZEPF1_V(s_hps) |
 		      HOSTPAGESIZEPF2_V(s_hps) | HOSTPAGESIZEPF3_V(s_hps) |
@@ -1347,8 +1346,7 @@ csio_wr_fixup_host_params(struct csio_hw *hw)
 	 * multiple of the Maximum Payload Size.
 	 */
 	pack_align = fl_align;
-	pcie_cap = pci_find_capability(hw->pdev, PCI_CAP_ID_EXP);
-	if (pcie_cap) {
+	if (pci_is_pcie(hw->pdev)) {
 		u32 mps, mps_log;
 		u16 devctl;
 
@@ -1356,9 +1354,7 @@ csio_wr_fixup_host_params(struct csio_hw *hw)
 		 * [bits 7:5] encodes sizes as powers of 2 starting at
 		 * 128 bytes.
 		 */
-		pci_read_config_word(hw->pdev,
-				     pcie_cap + PCI_EXP_DEVCTL,
-				     &devctl);
+		pcie_capability_read_word(hw->pdev, PCI_EXP_DEVCTL, &devctl);
 		mps_log = ((devctl & PCI_EXP_DEVCTL_PAYLOAD) >> 5) + 7;
 		mps = 1 << mps_log;
 		if (mps > pack_align)
-- 
2.17.1
