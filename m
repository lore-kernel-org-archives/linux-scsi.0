From: Santosh Y <santoshsy@gmail.com>
Subject: [PATCH 2/6] scsi: ufs: fix the setting interrupt aggregation counter
Date: Sat, 31 Aug 2013 21:40:20 +0530
Message-ID: <1377965424-30991-3-git-send-email-santoshsy@gmail.com>
References: <1377965424-30991-1-git-send-email-santoshsy@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:58297 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901Ab3HaQLM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 31 Aug 2013 12:11:12 -0400
Received: by mail-pa0-f42.google.com with SMTP id lj1so3539922pab.1
        for <linux-scsi@vger.kernel.org>; Sat, 31 Aug 2013 09:11:11 -0700 (PDT)
In-Reply-To: <1377965424-30991-1-git-send-email-santoshsy@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, vinholikatti@gmail.com, Seungwon Jeon <tgih.jun@samsung.com>, Santosh Y <santoshsy@gmail.com>

From: Seungwon Jeon <tgih.jun@samsung.com>

IACTH(Interrupt aggregation counter threshold) value is allowed
up to 0x1F and current setting value is the maximum.
This value is related with NUTRS(max:0x20) of HCI's capability.
Considering HCI controller doesn't support the maximum, IACTH
setting should be adjusted with possible value.
For that, existing 'ufshcd_config_int_aggr' is split into two part
[reset, configure].

Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>
Tested-by: Yaniv Gardi <ygardi@codeaurora.org>
Signed-off-by: Santosh Y <santoshsy@gmail.com>

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index ac3d56b..86d7286 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -59,6 +59,9 @@
 /* Expose the flag value from utp_upiu_query.value */
 #define MASK_QUERY_UPIU_FLAG_LOC 0xFF
 
+/* Interrupt aggregation default timeout, unit: 40us */
+#define INT_AGGR_DEF_TO	0x02
+
 enum {
 	UFSHCD_MAX_CHANNEL	= 0,
 	UFSHCD_MAX_ID		= 1,
@@ -94,12 +97,6 @@ enum {
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
@@ -340,30 +337,30 @@ static inline bool ufshcd_is_exception_event(struct utp_upiu_rsp *ucd_rsp_ptr)
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
@@ -1523,7 +1520,7 @@ static int ufshcd_make_hba_operational(struct ufs_hba *hba)
 	ufshcd_enable_intr(hba, UFSHCD_ENABLE_INTRS);
 
 	/* Configure interrupt aggregation */
-	ufshcd_config_int_aggr(hba, INT_AGGR_CONFIG);
+	ufshcd_config_intr_aggr(hba, hba->nutrs - 1, INT_AGGR_DEF_TO);
 
 	/* Configure UTRL and UTMRL base address registers */
 	ufshcd_writel(hba, lower_32_bits(hba->utrdl_dma_addr),
@@ -1971,7 +1968,7 @@ static void ufshcd_transfer_req_compl(struct ufs_hba *hba)
 
 	/* Reset interrupt aggregation counters */
 	if (int_aggr_reset)
-		ufshcd_config_int_aggr(hba, INT_AGGR_RESET);
+		ufshcd_reset_intr_aggr(hba);
 }
 
 /**
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
1.8.4

