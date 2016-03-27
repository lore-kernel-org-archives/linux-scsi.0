From: "zhaoxiu.zeng" <zhaoxiu.zeng@gmail.com>
Subject: [PATCH 20/31] scsi: use parity32 in isci/phy.c
Date: Sun, 27 Mar 2016 15:20:51 +0800
Message-ID: <56F789D3.3060603@gmail.com>
References: <1458788612-4367-1-git-send-email-zhaoxiu.zeng@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:36254 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874AbcC0HVW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Mar 2016 03:21:22 -0400
In-Reply-To: <1458788612-4367-1-git-send-email-zhaoxiu.zeng@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Intel SCU Linux support <intel-linux-scu@intel.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

From: Zeng Zhaoxiu <zhaoxiu.zeng@gmail.com>

Signed-off-by: Zeng Zhaoxiu <zhaoxiu.zeng@gmail.com>
---
 drivers/scsi/isci/phy.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/isci/phy.c b/drivers/scsi/isci/phy.c
index cb87b2e..0b87ff4 100644
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
@@ -223,19 +221,11 @@ sci_phy_link_layer_initialization(struct isci_phy *iphy,
 	}
 
 	/* The SAS specification indicates that the phy_capabilities that
-	 * are transmitted shall have an even parity.  Calculate the parity.
+	 * are transmitted shall have an even parity. If parity indicates
+	 * there are an odd number of bits set, then set the parity bit
+	 * to 1 in the phy capabilities.
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
+	if (parity32(phy_cap.all))
 		phy_cap.parity = 1;
 
 	writel(phy_cap.all, &llr->phy_capabilities);
-- 
2.5.5

