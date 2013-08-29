From: Raviv Shvili <rshvili@codeaurora.org>
Subject: [RESEND/PATCH 1/2] scsi: ufs: fix the setting interrupt aggregation counter
Date: Thu, 29 Aug 2013 11:54:11 +0300
Message-ID: <1377766453-5188-1-git-send-email-rshvili@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: scsi-misc@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, Raviv Shvili <rshvili@codeaurora.org>, Seungwon Jeon <tgih.jun@samsung.com>, "open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

IACTH(Interrupt aggregation counter threshold) value is allowed
up to 0x1F and current setting value is the maximum.
This value is related with NUTRS(max:0x20) of HCI's capability.
Considering HCI controller doesn't support the maximum, IACTH
setting should be adjusted with possible value.
For that, existing 'ufshcd_config_int_aggr' is split into two part
[reset, configure].

Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>


diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index d552cb1..648ecb0 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -81,6 +81,19 @@
 /* Expose the flag value from utp_upiu_query.value */
 #define MASK_QUERY_UPIU_FLAG_LOC 0xFF
 
+#define ufshcd_toggle_vreg(_dev, _vreg, _on)				\
+	({                                                              \
+		int _ret;                                               \
+		if (_on)                                                \
+			_ret = ufshcd_enable_vreg(_dev, _vreg);         \
+		else                                                    \
+			_ret = ufshcd_disable_vreg(_dev, _vreg);        \
+		_ret;                                                   \
+	})
+
+/* Interrupt aggregation default timeout, unit: 40us */
+#define INT_AGGR_DEF_TO	0x02
+
 enum {
 	UFSHCD_MAX_CHANNEL	= 0,
 	UFSHCD_MAX_ID		= 1,
@@ -116,12 +129,6 @@ enum {
 	UFSHCD_INT_CLEAR,
 };
 
-/* Interrupt aggregation options */
-enum {
-	INT_AGGR_RESET,
-	INT_AGGR_CONFIG,
-};
-
 #define ufshcd_set_eh_in_progress(h) \
 	(h->eh_flags |= UFSHCD_EH_IN_PROGRESS)
 #define ufshcd_eh_in_progress(h) \
@@ -349,30 +356,30 @@ static inline bool ufshcd_is_exception_event(struct utp_upiu_rsp *ucd_rsp_ptr)
 }
 
 /**
- * ufshcd_config_int_aggr - Configure interrupt aggregation values.
- *		Currently there is no use case where we want to configure
- *		interrupt aggregation dynamically. So to configure interrupt
- *		aggregation, #define INT_AGGR_COUNTER_THRESHOLD_VALUE and
- *		INT_AGGR_TIMEOUT_VALUE are used.
+ * ufshcd_reset_intr_aggr - Reset interrupt aggregation values.
  * @hba: per adapter instance
- * @option: Interrupt aggregation option
  */
 static inline void
-ufshcd_config_int_aggr(struct ufs_hba *hba, int option)
+ufshcd_reset_intr_aggr(struct ufs_hba *hba)
 {
-	switch (option) {
-	case INT_AGGR_RESET:
-		ufshcd_writel(hba, INT_AGGR_ENABLE |
-			      INT_AGGR_COUNTER_AND_TIMER_RESET,
-			      REG_UTP_TRANSFER_REQ_INT_AGG_CONTROL);
-		break;
-	case INT_AGGR_CONFIG:
-		ufshcd_writel(hba, INT_AGGR_ENABLE | INT_AGGR_PARAM_WRITE |
-			      INT_AGGR_COUNTER_THRESHOLD_VALUE |
-			      INT_AGGR_TIMEOUT_VALUE,
-			      REG_UTP_TRANSFER_REQ_INT_AGG_CONTROL);
-		break;
-	}
+	ufshcd_writel(hba, INT_AGGR_ENABLE |
+		      INT_AGGR_COUNTER_AND_TIMER_RESET,
+		      REG_UTP_TRANSFER_REQ_INT_AGG_CONTROL);
+}
+
+/**
+ * ufshcd_config_intr_aggr - Configure interrupt aggregation values.
+ * @hba: per adapter instance
+ * @cnt: Interrupt aggregation counter threshold
+ * @tmout: Interrupt aggregation timeout value
+ */
+static inline void
+ufshcd_config_intr_aggr(struct ufs_hba *hba, u8 cnt, u8 tmout)
+{
+	ufshcd_writel(hba, INT_AGGR_ENABLE | INT_AGGR_PARAM_WRITE |
+		      INT_AGGR_COUNTER_THLD_VAL(cnt) |
+		      INT_AGGR_TIMEOUT_VAL(tmout),
+		      REG_UTP_TRANSFER_REQ_INT_AGG_CONTROL);
 }
 
 /**
@@ -1523,7 +1530,7 @@ static int ufshcd_make_hba_operational(struct ufs_hba *hba)
 	ufshcd_enable_intr(hba, UFSHCD_ENABLE_INTRS);
 
 	/* Configure interrupt aggregation */
-	ufshcd_config_int_aggr(hba, INT_AGGR_CONFIG);
+	ufshcd_config_intr_aggr(hba, hba->nutrs - 1, INT_AGGR_DEF_TO);
 
 	/* Configure UTRL and UTMRL base address registers */
 	ufshcd_writel(hba, lower_32_bits(hba->utrdl_dma_addr),
@@ -1971,7 +1978,7 @@ static void ufshcd_transfer_req_compl(struct ufs_hba *hba)
 	 * false interrupt if device completes another request after resetting
 	 * aggregation and before reading the DB.
 	 */
-	ufshcd_config_int_aggr(hba, INT_AGGR_RESET);
+	ufshcd_reset_intr_aggr(hba);
 
 	tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
 	completed_reqs = tr_doorbell ^ hba->outstanding_reqs;
diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
index f1e1b74..739ae3a 100644
--- a/drivers/scsi/ufs/ufshci.h
+++ b/drivers/scsi/ufs/ufshci.h
@@ -226,8 +226,8 @@ enum {
 
 #define MASK_UIC_COMMAND_RESULT			0xFF
 
-#define INT_AGGR_COUNTER_THRESHOLD_VALUE	(0x1F << 8)
-#define INT_AGGR_TIMEOUT_VALUE			(0x02)
+#define INT_AGGR_COUNTER_THLD_VAL(c)	(((c) & 0x1F) << 8)
+#define INT_AGGR_TIMEOUT_VAL(t)		(((t) & 0xFF) << 0)
 
 /* Interrupt disable masks */
 enum {
--
