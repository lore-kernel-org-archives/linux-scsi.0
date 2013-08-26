From: Seungwon Jeon <tgih.jun@samsung.com>
Subject: [PATCH v3 2/6] scsi: ufs: fix the setting interrupt aggregation counter
Date: Mon, 26 Aug 2013 23:40:27 +0900
Message-ID: <003701cea26a$347a33a0$9d6e9ae0$%jun@samsung.com>
References: <1374280885-11526-1-git-send-email-mita@fixstars.com>
 <001d01ce8a06$76bb3420$64319c60$%jun@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:33159 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237Ab3HZOk2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Aug 2013 10:40:28 -0400
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MS500CT57FFS660@mailout3.samsung.com> for
 linux-scsi@vger.kernel.org; Mon, 26 Aug 2013 23:40:27 +0900 (KST)
In-reply-to: 
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: 'Vinayak Holikatti' <vinholikatti@gmail.com>, 'Santosh Y' <santoshsy@gmail.com>, "'James E.J. Bottomley'" <James.Bottomley@HansenPartnership.com>

IACTH(Interrupt aggregation counter threshold) value is allowed
up to 0x1F and current setting value is the maximum.
This value is related with NUTRS(max:0x20) of HCI's capability.
Considering HCI controller doesn't support the maximum, IACTH
setting should be adjusted with possible value.
For that, existing 'ufshcd_config_int_aggr' is split into two part
[reset, configure].

Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c |   53 +++++++++++++++++++++-----------------------
 drivers/scsi/ufs/ufshci.h |    4 +-
 2 files changed, 27 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 6ff16c9..c90b88a 100644
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
1.7.0.4


