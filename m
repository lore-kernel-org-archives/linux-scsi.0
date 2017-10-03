From: Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v2 1/4] scsi: ufs: Change HCI macro to actual bit position
Date: Tue, 03 Oct 2017 20:51:22 +0530
Message-ID: <1507044085-16905-1-git-send-email-alim.akhtar@samsung.com>
References: <CGME20171003152909epcas2p4e6e80cb1c544c38c33267a2d2767e40e@epcas2p4.samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: vinholikatti@gmail.com, martin.petersen@oracle.com, subhashj@codeaurora.org, Bart.VanAssche@wdc.com
List-Id: linux-scsi@vger.kernel.org

Currently UFS HCI uses UFS_BIT() macro to get various bit
position for the hardware registers status bits. Which makes
code longer instead of shorter. This macro does not improve
code readability as well.
Lets re-write these macro definition with the actual bit position.

Suggested-by: Bart Van Assche <Bart.VanAssche@wdc.com>
Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
---
* Changes since V1:
 - addressed review comments from Bart.

 drivers/scsi/ufs/ufshcd.h | 14 +++++-----
 drivers/scsi/ufs/ufshci.h | 66 +++++++++++++++++++++++++----------------------
 2 files changed, 42 insertions(+), 38 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index cdc8bd0..ce2920b 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -544,13 +544,13 @@ struct ufs_hba {
 	bool is_irq_enabled;
 
 	/* Interrupt aggregation support is broken */
-	#define UFSHCD_QUIRK_BROKEN_INTR_AGGR			UFS_BIT(0)
+	#define UFSHCD_QUIRK_BROKEN_INTR_AGGR			0x1
 
 	/*
 	 * delay before each dme command is required as the unipro
 	 * layer has shown instabilities
 	 */
-	#define UFSHCD_QUIRK_DELAY_BEFORE_DME_CMDS		UFS_BIT(1)
+	#define UFSHCD_QUIRK_DELAY_BEFORE_DME_CMDS		0x2
 
 	/*
 	 * If UFS host controller is having issue in processing LCC (Line
@@ -559,21 +559,21 @@ struct ufs_hba {
 	 * the LCC transmission on UFS device (by clearing TX_LCC_ENABLE
 	 * attribute of device to 0).
 	 */
-	#define UFSHCD_QUIRK_BROKEN_LCC				UFS_BIT(2)
+	#define UFSHCD_QUIRK_BROKEN_LCC				0x4
 
 	/*
 	 * The attribute PA_RXHSUNTERMCAP specifies whether or not the
 	 * inbound Link supports unterminated line in HS mode. Setting this
 	 * attribute to 1 fixes moving to HS gear.
 	 */
-	#define UFSHCD_QUIRK_BROKEN_PA_RXHSUNTERMCAP		UFS_BIT(3)
+	#define UFSHCD_QUIRK_BROKEN_PA_RXHSUNTERMCAP		0x8
 
 	/*
 	 * This quirk needs to be enabled if the host contoller only allows
 	 * accessing the peer dme attributes in AUTO mode (FAST AUTO or
 	 * SLOW AUTO).
 	 */
-	#define UFSHCD_QUIRK_DME_PEER_ACCESS_AUTO_MODE		UFS_BIT(4)
+	#define UFSHCD_QUIRK_DME_PEER_ACCESS_AUTO_MODE		0x10
 
 	/*
 	 * This quirk needs to be enabled if the host contoller doesn't
@@ -581,13 +581,13 @@ struct ufs_hba {
 	 * is enabled, standard UFS host driver will call the vendor specific
 	 * ops (get_ufs_hci_version) to get the correct version.
 	 */
-	#define UFSHCD_QUIRK_BROKEN_UFS_HCI_VERSION		UFS_BIT(5)
+	#define UFSHCD_QUIRK_BROKEN_UFS_HCI_VERSION		0x20
 
 	/*
 	 * This quirk needs to be enabled if the host contoller regards
 	 * resolution of the values of PRDTO and PRDTL in UTRD as byte.
 	 */
-	#define UFSHCD_QUIRK_PRDT_BYTE_GRAN			UFS_BIT(7)
+	#define UFSHCD_QUIRK_PRDT_BYTE_GRAN			0x80
 
 	unsigned int quirks;	/* Deviations from standard UFSHCI spec. */
 
diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
index f60145d..0d78ed3 100644
--- a/drivers/scsi/ufs/ufshci.h
+++ b/drivers/scsi/ufs/ufshci.h
@@ -121,20 +121,23 @@ enum {
 
 #define UFS_BIT(x)	(1L << (x))
 
-#define UTP_TRANSFER_REQ_COMPL			UFS_BIT(0)
-#define UIC_DME_END_PT_RESET			UFS_BIT(1)
-#define UIC_ERROR				UFS_BIT(2)
-#define UIC_TEST_MODE				UFS_BIT(3)
-#define UIC_POWER_MODE				UFS_BIT(4)
-#define UIC_HIBERNATE_EXIT			UFS_BIT(5)
-#define UIC_HIBERNATE_ENTER			UFS_BIT(6)
-#define UIC_LINK_LOST				UFS_BIT(7)
-#define UIC_LINK_STARTUP			UFS_BIT(8)
-#define UTP_TASK_REQ_COMPL			UFS_BIT(9)
-#define UIC_COMMAND_COMPL			UFS_BIT(10)
-#define DEVICE_FATAL_ERROR			UFS_BIT(11)
-#define CONTROLLER_FATAL_ERROR			UFS_BIT(16)
-#define SYSTEM_BUS_FATAL_ERROR			UFS_BIT(17)
+/*
+ * IS - Interrupt Status - 20h
+ */
+#define UTP_TRANSFER_REQ_COMPL			0x1
+#define UIC_DME_END_PT_RESET			0x2
+#define UIC_ERROR				0x4
+#define UIC_TEST_MODE				0x8
+#define UIC_POWER_MODE				0x10
+#define UIC_HIBERNATE_EXIT			0x20
+#define UIC_HIBERNATE_ENTER			0x40
+#define UIC_LINK_LOST				0x80
+#define UIC_LINK_STARTUP			0x100
+#define UTP_TASK_REQ_COMPL			0x200
+#define UIC_COMMAND_COMPL			0x400
+#define DEVICE_FATAL_ERROR			0x800
+#define CONTROLLER_FATAL_ERROR			0x10000
+#define SYSTEM_BUS_FATAL_ERROR			0x20000
 
 #define UFSHCD_UIC_PWR_MASK	(UIC_HIBERNATE_ENTER |\
 				UIC_HIBERNATE_EXIT |\
@@ -152,10 +155,10 @@ enum {
 				SYSTEM_BUS_FATAL_ERROR)
 
 /* HCS - Host Controller Status 30h */
-#define DEVICE_PRESENT				UFS_BIT(0)
-#define UTP_TRANSFER_REQ_LIST_READY		UFS_BIT(1)
-#define UTP_TASK_REQ_LIST_READY			UFS_BIT(2)
-#define UIC_COMMAND_READY			UFS_BIT(3)
+#define DEVICE_PRESENT				0x1
+#define UTP_TRANSFER_REQ_LIST_READY		0x2
+#define UTP_TASK_REQ_LIST_READY			0x4
+#define UIC_COMMAND_READY			0x8
 #define HOST_ERROR_INDICATOR			UFS_BIT(4)
 #define DEVICE_ERROR_INDICATOR			UFS_BIT(5)
 #define UIC_POWER_MODE_CHANGE_REQ_STATUS_MASK	UFS_MASK(0x7, 8)
@@ -174,46 +177,47 @@ enum {
 };
 
 /* HCE - Host Controller Enable 34h */
-#define CONTROLLER_ENABLE	UFS_BIT(0)
+#define CONTROLLER_ENABLE	0x1
 #define CONTROLLER_DISABLE	0x0
-#define CRYPTO_GENERAL_ENABLE	UFS_BIT(1)
+#define CRYPTO_GENERAL_ENABLE	0x2
 
 /* UECPA - Host UIC Error Code PHY Adapter Layer 38h */
-#define UIC_PHY_ADAPTER_LAYER_ERROR			UFS_BIT(31)
+#define UIC_PHY_ADAPTER_LAYER_ERROR			0x80000000
 #define UIC_PHY_ADAPTER_LAYER_ERROR_CODE_MASK		0x1F
 #define UIC_PHY_ADAPTER_LAYER_LANE_ERR_MASK		0xF
 
 /* UECDL - Host UIC Error Code Data Link Layer 3Ch */
-#define UIC_DATA_LINK_LAYER_ERROR		UFS_BIT(31)
+#define UIC_DATA_LINK_LAYER_ERROR		0x80000000
 #define UIC_DATA_LINK_LAYER_ERROR_CODE_MASK	0x7FFF
 #define UIC_DATA_LINK_LAYER_ERROR_PA_INIT	0x2000
 #define UIC_DATA_LINK_LAYER_ERROR_NAC_RECEIVED	0x0001
 #define UIC_DATA_LINK_LAYER_ERROR_TCx_REPLAY_TIMEOUT 0x0002
 
 /* UECN - Host UIC Error Code Network Layer 40h */
-#define UIC_NETWORK_LAYER_ERROR			UFS_BIT(31)
+#define UIC_NETWORK_LAYER_ERROR			0x80000000
 #define UIC_NETWORK_LAYER_ERROR_CODE_MASK	0x7
 
 /* UECT - Host UIC Error Code Transport Layer 44h */
-#define UIC_TRANSPORT_LAYER_ERROR		UFS_BIT(31)
+#define UIC_TRANSPORT_LAYER_ERROR		0x80000000
 #define UIC_TRANSPORT_LAYER_ERROR_CODE_MASK	0x7F
 
 /* UECDME - Host UIC Error Code DME 48h */
-#define UIC_DME_ERROR			UFS_BIT(31)
+#define UIC_DME_ERROR			0x80000000
 #define UIC_DME_ERROR_CODE_MASK		0x1
 
+/* UTRIACR - Interrupt Aggregation control register - 0x4Ch */
 #define INT_AGGR_TIMEOUT_VAL_MASK		0xFF
 #define INT_AGGR_COUNTER_THRESHOLD_MASK		UFS_MASK(0x1F, 8)
-#define INT_AGGR_COUNTER_AND_TIMER_RESET	UFS_BIT(16)
-#define INT_AGGR_STATUS_BIT			UFS_BIT(20)
-#define INT_AGGR_PARAM_WRITE			UFS_BIT(24)
-#define INT_AGGR_ENABLE				UFS_BIT(31)
+#define INT_AGGR_COUNTER_AND_TIMER_RESET	0x10000
+#define INT_AGGR_STATUS_BIT			0x100000
+#define INT_AGGR_PARAM_WRITE			0x1000000
+#define INT_AGGR_ENABLE				0x80000000
 
 /* UTRLRSR - UTP Transfer Request Run-Stop Register 60h */
-#define UTP_TRANSFER_REQ_LIST_RUN_STOP_BIT	UFS_BIT(0)
+#define UTP_TRANSFER_REQ_LIST_RUN_STOP_BIT	0x1
 
 /* UTMRLRSR - UTP Task Management Request Run-Stop Register 80h */
-#define UTP_TASK_REQ_LIST_RUN_STOP_BIT		UFS_BIT(0)
+#define UTP_TASK_REQ_LIST_RUN_STOP_BIT		0x1
 
 /* UICCMD - UIC Command */
 #define COMMAND_OPCODE_MASK		0xFF
-- 
2.7.4
