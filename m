From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2 14/15] isci: fix start OOB
Date: Wed, 04 Jan 2012 01:33:36 -0800
Message-ID: <20120104093336.9147.16529.stgit@localhost6.localdomain6>
References: <20120104093015.9147.24234.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:46192 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754732Ab2ADJdh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Jan 2012 04:33:37 -0500
In-Reply-To: <20120104093015.9147.24234.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Marcin Tomczak <marcin.tomczak@intel.com>

From: Marcin Tomczak <marcin.tomczak@intel.com>

Split scu_link_layer_start_oob function to reset and enable and
add flush after all steps.

Signed-off-by: Marcin Tomczak <marcin.tomczak@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/phy.c |   35 ++++++++++++++++++-----------------
 1 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/isci/phy.c b/drivers/scsi/isci/phy.c
index 61000cd..fe18acf 100644
--- a/drivers/scsi/isci/phy.c
+++ b/drivers/scsi/isci/phy.c
@@ -1098,24 +1098,25 @@ static void scu_link_layer_stop_protocol_engine(
 	writel(enable_spinup_value, &iphy->link_layer_registers->notify_enable_spinup_control);
 }
 
-/**
- *
- *
- * This method will start the OOB/SN state machine for this struct isci_phy object.
- */
-static void scu_link_layer_start_oob(
-	struct isci_phy *iphy)
+static void scu_link_layer_start_oob(struct isci_phy *iphy)
 {
-	u32 scu_sas_pcfg_value;
-
-	scu_sas_pcfg_value =
-		readl(&iphy->link_layer_registers->phy_configuration);
-	scu_sas_pcfg_value |= SCU_SAS_PCFG_GEN_BIT(OOB_ENABLE);
-	scu_sas_pcfg_value &=
-		~(SCU_SAS_PCFG_GEN_BIT(OOB_RESET) |
-		SCU_SAS_PCFG_GEN_BIT(HARD_RESET));
-	writel(scu_sas_pcfg_value,
-	       &iphy->link_layer_registers->phy_configuration);
+	struct scu_link_layer_registers __iomem *ll = iphy->link_layer_registers;
+	u32 val;
+
+	/** Reset OOB sequence - start */
+	val = readl(&ll->phy_configuration);
+	val &= ~(SCU_SAS_PCFG_GEN_BIT(OOB_RESET) |
+		 SCU_SAS_PCFG_GEN_BIT(HARD_RESET));
+	writel(val, &ll->phy_configuration);
+	readl(&ll->phy_configuration); /* flush */
+	/** Reset OOB sequence - end */
+
+	/** Start OOB sequence - start */
+	val = readl(&ll->phy_configuration);
+	val |= SCU_SAS_PCFG_GEN_BIT(OOB_ENABLE);
+	writel(val, &ll->phy_configuration);
+	readl(&ll->phy_configuration); /* flush */
+	/** Start OOB sequence - end */
 }
 
 /**

