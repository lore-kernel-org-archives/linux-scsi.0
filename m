From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 3/9] isci: change sas phy timeouts from 54us to 59us
Date: Fri, 29 Jul 2011 17:16:50 -0700
Message-ID: <20110730001650.28430.30246.stgit@localhost6.localdomain6>
References: <20110730001320.28430.53496.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:31888 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752808Ab1G3AQv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Jul 2011 20:16:51 -0400
In-Reply-To: <20110730001320.28430.53496.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: Marcin Tomczak <marcin.tomczak@intel.com>, linux-scsi@vger.kernel.org

From: Marcin Tomczak <marcin.tomczak@intel.com>

Need the following workaround in the driver for interoperability with
the older Intel SSD drives and any other SATA drive that may exhibit the
same behavior. This is a corner case where SCU speed is limited to
either 3G or 1.5G and the drive has a period of DC idle when it switches
speed during SATA speed negotiation. Workaround :change PHYTOV[31:24]
from 0x36 to 0x3B.

Signed-off-by: Marcin Tomczak <marcin.tomczak@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/phy.c       |   13 +++++++++++++
 drivers/scsi/isci/registers.h |   12 ++++++++++++
 2 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/isci/phy.c b/drivers/scsi/isci/phy.c
index 79313a7..430fc8f 100644
--- a/drivers/scsi/isci/phy.c
+++ b/drivers/scsi/isci/phy.c
@@ -104,6 +104,7 @@ sci_phy_link_layer_initialization(struct isci_phy *iphy,
 	u32 parity_count = 0;
 	u32 llctl, link_rate;
 	u32 clksm_value = 0;
+	u32 sp_timeouts = 0;
 
 	iphy->link_layer_registers = reg;
 
@@ -211,6 +212,18 @@ sci_phy_link_layer_initialization(struct isci_phy *iphy,
 	llctl |= SCU_SAS_LLCTL_GEN_VAL(MAX_LINK_RATE, link_rate);
 	writel(llctl, &iphy->link_layer_registers->link_layer_control);
 
+	sp_timeouts = readl(&iphy->link_layer_registers->sas_phy_timeouts);
+
+	/* Clear the default 0x36 (54us) RATE_CHANGE timeout value. */
+	sp_timeouts &= ~SCU_SAS_PHYTOV_GEN_VAL(RATE_CHANGE, 0xFF);
+
+	/* Set RATE_CHANGE timeout value to 0x3B (59us).  This ensures SCU can
+	 * lock with 3Gb drive when SCU max rate is set to 1.5Gb.
+	 */
+	sp_timeouts |= SCU_SAS_PHYTOV_GEN_VAL(RATE_CHANGE, 0x3B);
+
+	writel(sp_timeouts, &iphy->link_layer_registers->sas_phy_timeouts);
+
 	if (is_a2(ihost->pdev)) {
 		/* Program the max ARB time for the PHY to 700us so we inter-operate with
 		 * the PMC expander which shuts down PHYs if the expander PHY generates too
diff --git a/drivers/scsi/isci/registers.h b/drivers/scsi/isci/registers.h
index 9b266c7..00afc73 100644
--- a/drivers/scsi/isci/registers.h
+++ b/drivers/scsi/isci/registers.h
@@ -1299,6 +1299,18 @@ struct scu_transport_layer_registers {
 #define SCU_AFE_XCVRCR_OFFSET       0x00DC
 #define SCU_AFE_LUTCR_OFFSET        0x00E0
 
+#define SCU_SAS_PHY_TIMER_TIMEOUT_VALUES_ALIGN_DETECTION_SHIFT          (0UL)
+#define SCU_SAS_PHY_TIMER_TIMEOUT_VALUES_ALIGN_DETECTION_MASK           (0x000000FFUL)
+#define SCU_SAS_PHY_TIMER_TIMEOUT_VALUES_HOT_PLUG_SHIFT                 (8UL)
+#define SCU_SAS_PHY_TIMER_TIMEOUT_VALUES_HOT_PLUG_MASK                  (0x0000FF00UL)
+#define SCU_SAS_PHY_TIMER_TIMEOUT_VALUES_COMSAS_DETECTION_SHIFT         (16UL)
+#define SCU_SAS_PHY_TIMER_TIMEOUT_VALUES_COMSAS_DETECTION_MASK          (0x00FF0000UL)
+#define SCU_SAS_PHY_TIMER_TIMEOUT_VALUES_RATE_CHANGE_SHIFT              (24UL)
+#define SCU_SAS_PHY_TIMER_TIMEOUT_VALUES_RATE_CHANGE_MASK               (0xFF000000UL)
+
+#define SCU_SAS_PHYTOV_GEN_VAL(name, value) \
+	SCU_GEN_VALUE(SCU_SAS_PHY_TIMER_TIMEOUT_VALUES_##name, value)
+
 #define SCU_SAS_LINK_LAYER_CONTROL_MAX_LINK_RATE_SHIFT                  (0)
 #define SCU_SAS_LINK_LAYER_CONTROL_MAX_LINK_RATE_MASK                   (0x00000003)
 #define SCU_SAS_LINK_LAYER_CONTROL_MAX_LINK_RATE_GEN1                   (0)

