From: Seungwon Jeon <tgih.jun@samsung.com>
Subject: [PATCH 3/7] scsi: ufs: fix the setting interrupt aggregation counter
Date: Fri, 26 Jul 2013 22:46:29 +0900
Message-ID: <001e01ce8a06$884df3d0$98e9db70$%jun@samsung.com>
References: <1374280885-11526-1-git-send-email-mita@fixstars.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:61599 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759016Ab3GZNqb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Jul 2013 09:46:31 -0400
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MQJ00I82Q9IZOT0@mailout4.samsung.com> for
 linux-scsi@vger.kernel.org; Fri, 26 Jul 2013 22:46:30 +0900 (KST)
In-reply-to: <1374280885-11526-1-git-send-email-mita@fixstars.com>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: 'Vinayak Holikatti' <vinholikatti@gmail.com>, 'Santosh Y' <santoshsy@gmail.com>, "'James E.J. Bottomley'" <JBottomley@parallels.com>

LACTH(Interrupt aggregation counter threshold) value is allowed
up to 0x1F and current setting value is the maximum.
This value is related with NUTRS(max:0x20) of HCI's capability.
Considering HCI controller doesn't support the maximum, LATCH
setting should be adjusted with possible value.
For that, existing 'ufshcd_config_int_aggr' is split into two part
[reset, configure].

Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c |   53 +++++++++++++++++++++-----------------------
 drivers/scsi/ufs/ufshci.h |    4 +-
 2 files changed, 27 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 688ae0e..7152ec4 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -43,6 +43,9 @@
 /* UIC command timeout, unit: ms */
 #define UIC_CMD_TIMEOUT	500
 
+/* Interrupt aggregation default timeout, unit: 40us */
+#define INT_AGGR_DEF_TO	0x02
+
 enum {
 	UFSHCD_MAX_CHANNEL	= 0,
 	UFSHCD_MAX_ID		= 1,
@@ -65,12 +68,6 @@ enum {
 	UFSHCD_INT_CLEAR,
 };
 
-/* Interrupt aggregation options */
-enum {
-	INT_AGGR_RESET,
-	INT_AGGR_CONFIG,
-};
-
 /**
  * ufshcd_get_intr_mask - Get the interrupt bit mask
  * @hba - Pointer to adapter instance
@@ -233,30 +230,30 @@ ufshcd_get_rsp_upiu_data_seg_len(struct utp_upiu_rsp *ucd_rsp_ptr)
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
+ * @cntr_thld: Interrupt aggregation counter threshold
+ * @timeout: Interrupt aggregation timeout value
+ */
+static inline void
+ufshcd_config_intr_aggr(struct ufs_hba *hba, u8 cnt, u8 timeout)
+{
+	ufshcd_writel(hba, INT_AGGR_ENABLE | INT_AGGR_PARAM_WRITE |
+		      INT_AGGR_COUNTER_THLD_VAL(cnt) |
+		      INT_AGGR_TIMEOUT_VAL(timeout),
+		      REG_UTP_TRANSFER_REQ_INT_AGG_CONTROL);
 }
 
 /**
@@ -853,7 +850,7 @@ static int ufshcd_make_hba_operational(struct ufs_hba *hba)
 	ufshcd_enable_intr(hba, UFSHCD_ENABLE_INTRS);
 
 	/* Configure interrupt aggregation */
-	ufshcd_config_int_aggr(hba, INT_AGGR_CONFIG);
+	ufshcd_config_intr_aggr(hba, hba->nutrs - 1, INT_AGGR_DEF_TO);
 
 	/* Configure UTRL and UTMRL base address registers */
 	ufshcd_writel(hba, lower_32_bits(hba->utrdl_dma_addr),
@@ -1299,7 +1296,7 @@ static void ufshcd_transfer_req_compl(struct ufs_hba *hba)
 	hba->outstanding_reqs ^= completed_reqs;
 
 	/* Reset interrupt aggregation counters */
-	ufshcd_config_int_aggr(hba, INT_AGGR_RESET);
+	ufshcd_reset_intr_aggr(hba);
 }
 
 /**
diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
index d5c5f14..a8f69cc 100644
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


