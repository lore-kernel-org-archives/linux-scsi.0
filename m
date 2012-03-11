From: Dan Williams <dan.j.williams@intel.com>
Subject: [isci PATCH v2 18/18] isci: Changes in COMSAS timings enabling ISCI
 to detect buggy disc drives.
Date: Sat, 10 Mar 2012 23:29:16 -0800
Message-ID: <20120311072916.6320.1087.stgit@dwillia2-linux.jf.intel.com>
References: <20120311072518.6320.61717.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120311072518.6320.61717.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org, Andrzej Jakowski <andrzej.jakowski@intel.com>
List-Id: linux-scsi@vger.kernel.org

From: Andrzej Jakowski <andrzej.jakowski@intel.com>

This patch extends timings in COMSAS signaling, so ISCI can detect disc
drives having issues to send COMSAS in correct time frame.

Signed-off-by: Andrzej Jakowski <andrzej.jakowski@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/phy.c       |   55 +++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/isci/registers.h |    8 ++++++
 2 files changed, 63 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/isci/phy.c b/drivers/scsi/isci/phy.c
index 474330f..85b26ac 100644
--- a/drivers/scsi/isci/phy.c
+++ b/drivers/scsi/isci/phy.c
@@ -668,6 +668,19 @@ static const char *phy_event_name(u32 event_code)
 		phy_to_host(iphy)->id, iphy->phy_index, \
 		phy_state_name(state), phy_event_name(code), code)
 
+
+void scu_link_layer_set_txcomsas_timeout(struct isci_phy *iphy, u32 timeout)
+{
+	u32 val;
+
+	/* Extend timeout */
+	val = readl(&iphy->link_layer_registers->transmit_comsas_signal);
+	val &= ~SCU_SAS_LLTXCOMSAS_GEN_VAL(NEGTIME, SCU_SAS_LINK_LAYER_TXCOMSAS_NEGTIME_MASK);
+	val |= SCU_SAS_LLTXCOMSAS_GEN_VAL(NEGTIME, timeout);
+
+	writel(val, &iphy->link_layer_registers->transmit_comsas_signal);
+}
+
 enum sci_status sci_phy_event_handler(struct isci_phy *iphy, u32 event_code)
 {
 	enum sci_phy_states state = iphy->sm.current_state_id;
@@ -683,6 +696,13 @@ enum sci_status sci_phy_event_handler(struct isci_phy *iphy, u32 event_code)
 			sci_phy_start_sata_link_training(iphy);
 			iphy->is_in_link_training = true;
 			break;
+		case SCU_EVENT_RECEIVED_IDENTIFY_TIMEOUT:
+		       /* Extend timeout value */
+		       scu_link_layer_set_txcomsas_timeout(iphy, SCU_SAS_LINK_LAYER_TXCOMSAS_NEGTIME_EXTENDED);
+
+		       /* Start the oob/sn state machine over again */
+		       sci_change_state(&iphy->sm, SCI_PHY_STARTING);
+		       break;
 		default:
 			phy_event_dbg(iphy, state, event_code);
 			return SCI_FAILURE;
@@ -717,9 +737,19 @@ enum sci_status sci_phy_event_handler(struct isci_phy *iphy, u32 event_code)
 			sci_phy_start_sata_link_training(iphy);
 			break;
 		case SCU_EVENT_LINK_FAILURE:
+			/* Change the timeout value to default */
+			scu_link_layer_set_txcomsas_timeout(iphy, SCU_SAS_LINK_LAYER_TXCOMSAS_NEGTIME_DEFAULT);
+
 			/* Link failure change state back to the starting state */
 			sci_change_state(&iphy->sm, SCI_PHY_STARTING);
 			break;
+		case SCU_EVENT_RECEIVED_IDENTIFY_TIMEOUT:
+		       /* Extend the timeout value */
+		       scu_link_layer_set_txcomsas_timeout(iphy, SCU_SAS_LINK_LAYER_TXCOMSAS_NEGTIME_EXTENDED);
+
+		       /* Start the oob/sn state machine over again */
+		       sci_change_state(&iphy->sm, SCI_PHY_STARTING);
+		       break;
 		default:
 			phy_event_warn(iphy, state, event_code);
 			return SCI_FAILURE;
@@ -740,7 +770,14 @@ enum sci_status sci_phy_event_handler(struct isci_phy *iphy, u32 event_code)
 			sci_phy_start_sata_link_training(iphy);
 			break;
 		case SCU_EVENT_RECEIVED_IDENTIFY_TIMEOUT:
+			/* Extend the timeout value */
+			scu_link_layer_set_txcomsas_timeout(iphy, SCU_SAS_LINK_LAYER_TXCOMSAS_NEGTIME_EXTENDED);
+
+			/* Start the oob/sn state machine over again */
+			sci_change_state(&iphy->sm, SCI_PHY_STARTING);
+			break;
 		case SCU_EVENT_LINK_FAILURE:
+			scu_link_layer_set_txcomsas_timeout(iphy, SCU_SAS_LINK_LAYER_TXCOMSAS_NEGTIME_DEFAULT);
 		case SCU_EVENT_HARD_RESET_RECEIVED:
 			/* Start the oob/sn state machine over again */
 			sci_change_state(&iphy->sm, SCI_PHY_STARTING);
@@ -753,6 +790,9 @@ enum sci_status sci_phy_event_handler(struct isci_phy *iphy, u32 event_code)
 	case SCI_PHY_SUB_AWAIT_SAS_POWER:
 		switch (scu_get_event_code(event_code)) {
 		case SCU_EVENT_LINK_FAILURE:
+			/* Change the timeout value to default */
+			scu_link_layer_set_txcomsas_timeout(iphy, SCU_SAS_LINK_LAYER_TXCOMSAS_NEGTIME_DEFAULT);
+
 			/* Link failure change state back to the starting state */
 			sci_change_state(&iphy->sm, SCI_PHY_STARTING);
 			break;
@@ -764,6 +804,9 @@ enum sci_status sci_phy_event_handler(struct isci_phy *iphy, u32 event_code)
 	case SCI_PHY_SUB_AWAIT_SATA_POWER:
 		switch (scu_get_event_code(event_code)) {
 		case SCU_EVENT_LINK_FAILURE:
+			/* Change the timeout value to default */
+			scu_link_layer_set_txcomsas_timeout(iphy, SCU_SAS_LINK_LAYER_TXCOMSAS_NEGTIME_DEFAULT);
+
 			/* Link failure change state back to the starting state */
 			sci_change_state(&iphy->sm, SCI_PHY_STARTING);
 			break;
@@ -788,6 +831,9 @@ enum sci_status sci_phy_event_handler(struct isci_phy *iphy, u32 event_code)
 	case SCI_PHY_SUB_AWAIT_SATA_PHY_EN:
 		switch (scu_get_event_code(event_code)) {
 		case SCU_EVENT_LINK_FAILURE:
+			/* Change the timeout value to default */
+			scu_link_layer_set_txcomsas_timeout(iphy, SCU_SAS_LINK_LAYER_TXCOMSAS_NEGTIME_DEFAULT);
+
 			/* Link failure change state back to the starting state */
 			sci_change_state(&iphy->sm, SCI_PHY_STARTING);
 			break;
@@ -836,6 +882,9 @@ enum sci_status sci_phy_event_handler(struct isci_phy *iphy, u32 event_code)
 						       SCI_PHY_SUB_AWAIT_SIG_FIS_UF);
 			break;
 		case SCU_EVENT_LINK_FAILURE:
+			/* Change the timeout value to default */
+			scu_link_layer_set_txcomsas_timeout(iphy, SCU_SAS_LINK_LAYER_TXCOMSAS_NEGTIME_DEFAULT);
+
 			/* Link failure change state back to the starting state */
 			sci_change_state(&iphy->sm, SCI_PHY_STARTING);
 			break;
@@ -859,6 +908,9 @@ enum sci_status sci_phy_event_handler(struct isci_phy *iphy, u32 event_code)
 			break;
 
 		case SCU_EVENT_LINK_FAILURE:
+			/* Change the timeout value to default */
+			scu_link_layer_set_txcomsas_timeout(iphy, SCU_SAS_LINK_LAYER_TXCOMSAS_NEGTIME_DEFAULT);
+
 			/* Link failure change state back to the starting state */
 			sci_change_state(&iphy->sm, SCI_PHY_STARTING);
 			break;
@@ -871,6 +923,9 @@ enum sci_status sci_phy_event_handler(struct isci_phy *iphy, u32 event_code)
 	case SCI_PHY_READY:
 		switch (scu_get_event_code(event_code)) {
 		case SCU_EVENT_LINK_FAILURE:
+			/* Set default timeout */
+			scu_link_layer_set_txcomsas_timeout(iphy, SCU_SAS_LINK_LAYER_TXCOMSAS_NEGTIME_DEFAULT);
+
 			/* Link failure change state back to the starting state */
 			sci_change_state(&iphy->sm, SCI_PHY_STARTING);
 			break;
diff --git a/drivers/scsi/isci/registers.h b/drivers/scsi/isci/registers.h
index f232f7e..6fe0141 100644
--- a/drivers/scsi/isci/registers.h
+++ b/drivers/scsi/isci/registers.h
@@ -1239,6 +1239,14 @@ struct scu_transport_layer_registers {
 #define SCU_SAS_LLCTL_GEN_BIT(name) \
 	SCU_GEN_BIT(SCU_SAS_LINK_LAYER_CONTROL_ ## name)
 
+#define SCU_SAS_LINK_LAYER_TXCOMSAS_NEGTIME_DEFAULT                     (0xF0)
+#define SCU_SAS_LINK_LAYER_TXCOMSAS_NEGTIME_EXTENDED                    (0x1FF)
+#define SCU_SAS_LINK_LAYER_TXCOMSAS_NEGTIME_SHIFT                       (0)
+#define SCU_SAS_LINK_LAYER_TXCOMSAS_NEGTIME_MASK                        (0x3FF)
+
+#define SCU_SAS_LLTXCOMSAS_GEN_VAL(name, value) \
+	SCU_GEN_VALUE(SCU_SAS_LINK_LAYER_TXCOMSAS_ ## name, value)
+
 
 /* #define SCU_FRXHECR_DCNT_OFFSET      0x00B0 */
 #define SCU_PSZGCR_OFFSET           0x00E4

