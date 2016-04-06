From: zengzhaoxiu@163.com
Subject: [PATCH v2 19/30] scsi: use parity32 in isci's phy
Date: Wed,  6 Apr 2016 17:47:04 +0800
Message-ID: <1459936024-7866-1-git-send-email-zengzhaoxiu@163.com>
References: <57031D9D.801@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <57031D9D.801@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: intel-linux-scu@intel.com, artur.paszkiewicz@intel.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Zhaoxiu Zeng <zhaoxiu.zeng@gmail.com>
List-Id: linux-scsi@vger.kernel.org

From: Zhaoxiu Zeng <zhaoxiu.zeng@gmail.com>

Signed-off-by: Zhaoxiu Zeng <zhaoxiu.zeng@gmail.com>
---
 drivers/scsi/isci/phy.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/scsi/isci/phy.c b/drivers/scsi/isci/phy.c
index cb87b2e..a06aff6 100644
--- a/drivers/scsi/isci/phy.c
+++ b/drivers/scsi/isci/phy.c
@@ -122,8 +122,6 @@ sci_phy_link_layer_initialization(struct isci_phy *iphy,
 	int phy_idx = iphy->phy_index;
 	struct sci_phy_cap phy_cap;
 	u32 phy_configuration;
-	u32 parity_check = 0;
-	u32 parity_count = 0;
 	u32 llctl, link_rate;
 	u32 clksm_value = 0;
 	u32 sp_timeouts = 0;
@@ -225,18 +223,7 @@ sci_phy_link_layer_initialization(struct isci_phy *iphy,
 	/* The SAS specification indicates that the phy_capabilities that
 	 * are transmitted shall have an even parity.  Calculate the parity.
 	 */
-	parity_check = phy_cap.all;
-	while (parity_check != 0) {
-		if (parity_check & 0x1)
-			parity_count++;
-		parity_check >>= 1;
-	}
-
-	/* If parity indicates there are an odd number of bits set, then
-	 * set the parity bit to 1 in the phy capabilities.
-	 */
-	if ((parity_count % 2) != 0)
-		phy_cap.parity = 1;
+	phy_cap.parity = parity32(phy_cap.all);
 
 	writel(phy_cap.all, &llr->phy_capabilities);
 
-- 
2.5.0
