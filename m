From: Xinghai Yu <yuxinghai@cn.fujitsu.com>
Subject: [PATCH] scsi/isci/phy.c: Code tidiness, delete the redundant function call "sci_change_state(&iphy->sm, SCI_PHY_STOPPED)" in "sci_phy_link_layer_initialization()"
Date: Fri, 19 Jul 2013 11:07:17 +0800
Message-ID: <1374203237-11290-1-git-send-email-yuxinghai@cn.fujitsu.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:60970 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933369Ab3GSDKk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Jul 2013 23:10:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: intel-linux-scu@intel.com, maciej.patelczyk@intel.com, dave.jiang@intel.com
Cc: linux-scsi@vger.kernel.org, Xinghai Yu <yuxinghai@cn.fujitsu.com>

The "sci_phy_link_layer_initialization()" was called only once in "sci_phy_initialize()" and it is called before a call of "sci_change_state(&iphy->sm, SCI_PHY_STOPPED)". So the same call in the end of "sci_phy_link_layer_initialization()" is redundant. 

Signed-off-by: Xinghai Yu <yuxinghai@cn.fujitsu.com>
---
 drivers/scsi/isci/phy.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/isci/phy.c b/drivers/scsi/isci/phy.c
index cb87b2e..82e8491 100644
--- a/drivers/scsi/isci/phy.c
+++ b/drivers/scsi/isci/phy.c
@@ -309,9 +309,6 @@ sci_phy_link_layer_initialization(struct isci_phy *iphy,
 	 */
 	writel(0, &llr->link_layer_hang_detection_timeout);
 
-	/* We can exit the initial state to the stopped state */
-	sci_change_state(&iphy->sm, SCI_PHY_STOPPED);
-
 	return SCI_SUCCESS;
 }
 
-- 
1.7.1

