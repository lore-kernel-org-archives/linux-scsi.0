From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH RESUBMIT 16/23] qla2xxx: Simplify the ISPFX00 interrupt handler code for ISPFX00.
Date: Wed, 26 Feb 2014 04:15:11 -0500
Message-ID: <1393406118-6586-17-git-send-email-saurav.kashyap@qlogic.com>
References: <1393406118-6586-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:12530 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751233AbaBZJuv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Feb 2014 04:50:51 -0500
In-Reply-To: <1393406118-6586-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mr.c |   25 +++++++++----------------
 drivers/scsi/qla2xxx/qla_mr.h |    4 ----
 2 files changed, 9 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 290322f..046a169 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -3014,6 +3014,7 @@ qlafx00_intr_handler(int irq, void *dev_id)
 	struct rsp_que *rsp;
 	unsigned long	flags;
 	uint32_t clr_intr = 0;
+	uint32_t intr_stat = 0;
 
 	rsp = (struct rsp_que *) dev_id;
 	if (!rsp) {
@@ -3035,34 +3036,26 @@ qlafx00_intr_handler(int irq, void *dev_id)
 		stat = QLAFX00_RD_INTR_REG(ha);
 		if (qla2x00_check_reg_for_disconnect(vha, stat))
 			break;
-		if ((stat & QLAFX00_HST_INT_STS_BITS) == 0)
+		intr_stat = stat & QLAFX00_HST_INT_STS_BITS;
+		if (!intr_stat)
 			break;
 
-		switch (stat & QLAFX00_HST_INT_STS_BITS) {
-		case QLAFX00_INTR_MB_CMPLT:
-		case QLAFX00_INTR_MB_RSP_CMPLT:
-		case QLAFX00_INTR_MB_ASYNC_CMPLT:
-		case QLAFX00_INTR_ALL_CMPLT:
+		if (stat & QLAFX00_INTR_MB_CMPLT) {
 			mb[0] = RD_REG_WORD(&reg->mailbox16);
 			qlafx00_mbx_completion(vha, mb[0]);
 			status |= MBX_INTERRUPT;
 			clr_intr |= QLAFX00_INTR_MB_CMPLT;
-			break;
-		case QLAFX00_INTR_ASYNC_CMPLT:
-		case QLAFX00_INTR_RSP_ASYNC_CMPLT:
+		}
+		if (intr_stat & QLAFX00_INTR_ASYNC_CMPLT) {
 			ha->aenmb[0] = RD_REG_WORD(&reg->aenmailbox0);
 			qlafx00_async_event(vha);
 			clr_intr |= QLAFX00_INTR_ASYNC_CMPLT;
-			break;
-		case QLAFX00_INTR_RSP_CMPLT:
+		}
+		if (intr_stat & QLAFX00_INTR_RSP_CMPLT) {
 			qlafx00_process_response_queue(vha, rsp);
 			clr_intr |= QLAFX00_INTR_RSP_CMPLT;
-			break;
-		default:
-			ql_dbg(ql_dbg_async, vha, 0x507a,
-			    "Unrecognized interrupt type (%d).\n", stat);
-			break;
 		}
+
 		QLAFX00_CLR_INTR_REG(ha, clr_intr);
 		QLAFX00_RD_INTR_REG(ha);
 	}
diff --git a/drivers/scsi/qla2xxx/qla_mr.h b/drivers/scsi/qla2xxx/qla_mr.h
index 3cf5ddc..e529dfa 100644
--- a/drivers/scsi/qla2xxx/qla_mr.h
+++ b/drivers/scsi/qla2xxx/qla_mr.h
@@ -336,11 +336,7 @@ struct config_info_data {
 
 #define QLAFX00_INTR_MB_CMPLT		0x1
 #define QLAFX00_INTR_RSP_CMPLT		0x2
-#define QLAFX00_INTR_MB_RSP_CMPLT	0x3
 #define QLAFX00_INTR_ASYNC_CMPLT	0x4
-#define QLAFX00_INTR_MB_ASYNC_CMPLT	0x5
-#define QLAFX00_INTR_RSP_ASYNC_CMPLT	0x6
-#define QLAFX00_INTR_ALL_CMPLT		0x7
 
 #define QLAFX00_MBA_SYSTEM_ERR		0x8002
 #define QLAFX00_MBA_TEMP_OVER		0x8005
-- 
1.7.7

