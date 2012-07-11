From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 2/4] isci: fix COMSAS negation timout workaround for WD SAS
 drives
Date: Wed, 11 Jul 2012 14:59:34 -0700
Message-ID: <20120711215934.26813.57112.stgit@dwillia2-linux.jf.intel.com>
References: <20120711215901.26813.19955.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:27696 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932415Ab2GKVmq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Jul 2012 17:42:46 -0400
In-Reply-To: <20120711215901.26813.19955.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org

From: Dave Maurer <david.c.maurer@intel.com>

The following patch is a fix for the WD workaround
COMSAS negation timeout change. This patch disables the
OOB SM when the OOB is placed in reset, which allows
the updated COMSAS negation timeout value to take
effect.

Cc: Dan Thompson <daniel.j.thompson@intel.com>
Reported-by: Dan Thompson <daniel.j.thompson@intel.com>
Signed-off-by: Dave Maurer <david.c.maurer@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/phy.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/isci/phy.c b/drivers/scsi/isci/phy.c
index 18f43d4..ebb8f53 100644
--- a/drivers/scsi/isci/phy.c
+++ b/drivers/scsi/isci/phy.c
@@ -1205,6 +1205,7 @@ static void scu_link_layer_start_oob(struct isci_phy *iphy)
 	/** Reset OOB sequence - start */
 	val = readl(&ll->phy_configuration);
 	val &= ~(SCU_SAS_PCFG_GEN_BIT(OOB_RESET) |
+		 SCU_SAS_PCFG_GEN_BIT(OOB_ENABLE) |
 		 SCU_SAS_PCFG_GEN_BIT(HARD_RESET));
 	writel(val, &ll->phy_configuration);
 	readl(&ll->phy_configuration); /* flush */
@@ -1236,6 +1237,7 @@ static void scu_link_layer_tx_hard_reset(
 	 * to the starting state. */
 	phy_configuration_value =
 		readl(&iphy->link_layer_registers->phy_configuration);
+	phy_configuration_value &= ~(SCU_SAS_PCFG_GEN_BIT(OOB_ENABLE));
 	phy_configuration_value |=
 		(SCU_SAS_PCFG_GEN_BIT(HARD_RESET) |
 		 SCU_SAS_PCFG_GEN_BIT(OOB_RESET));

