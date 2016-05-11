From: zengzhaoxiu@163.com
Subject: [patch V4 18/31] scsi: use parity32 in isci's phy
Date: Wed, 11 May 2016 17:19:56 +0800
Message-ID: <1462958396-25400-1-git-send-email-zengzhaoxiu@163.com>
References: <1462955158-28394-1-git-send-email-zengzhaoxiu@163.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1462955158-28394-1-git-send-email-zengzhaoxiu@163.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Zhaoxiu Zeng <zhaoxiu.zeng@gmail.com>, Intel SCU Linux support <intel-linux-scu@intel.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
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
2.7.4
