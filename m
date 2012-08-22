From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 22/42] qla2xxx: Use #defines instead of hardcoded values for intr status.
Date: Wed, 22 Aug 2012 14:21:16 -0400
Message-ID: <1345659696-3670-23-git-send-email-chad.dupuis@qlogic.com>
References: <1345659696-3670-1-git-send-email-chad.dupuis@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:44279 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S964967Ab2HVSiX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Aug 2012 14:38:23 -0400
In-Reply-To: <1345659696-3670-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Arun Easi <arun.easi@qlogic.com>

Signed-off-by: Arun Easi <arun.easi@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h |   11 +++++++++++
 drivers/scsi/qla2xxx/qla_isr.c |   36 ++++++++++++++++++------------------
 2 files changed, 29 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 9feb54c..a970dbf 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -675,6 +675,17 @@ typedef struct {
 /* 83XX FCoE specific */
 #define MBA_IDC_AEN		0x8200  /* FCoE: NIC Core state change AEN */
 
+/* Interrupt type codes */
+#define INTR_ROM_MB_SUCCESS		0x1
+#define INTR_ROM_MB_FAILED		0x2
+#define INTR_MB_SUCCESS			0x10
+#define INTR_MB_FAILED			0x11
+#define INTR_ASYNC_EVENT		0x12
+#define INTR_RSP_QUE_UPDATE		0x13
+#define INTR_RSP_QUE_UPDATE_83XX	0x14
+#define INTR_ATIO_QUE_UPDATE		0x1C
+#define INTR_ATIO_RSP_QUE_UPDATE	0x1D
+
 /* ISP mailbox loopback echo diagnostic error code */
 #define MBS_LB_RESET	0x17
 /*
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 6860992..a551827 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2522,29 +2522,29 @@ qla24xx_intr_handler(int irq, void *dev_id)
 			break;
 
 		switch (stat & 0xff) {
-		case 0x1:
-		case 0x2:
-		case 0x10:
-		case 0x11:
+		case INTR_ROM_MB_SUCCESS:
+		case INTR_ROM_MB_FAILED:
+		case INTR_MB_SUCCESS:
+		case INTR_MB_FAILED:
 			qla24xx_mbx_completion(vha, MSW(stat));
 			status |= MBX_INTERRUPT;
 
 			break;
-		case 0x12:
+		case INTR_ASYNC_EVENT:
 			mb[0] = MSW(stat);
 			mb[1] = RD_REG_WORD(&reg->mailbox1);
 			mb[2] = RD_REG_WORD(&reg->mailbox2);
 			mb[3] = RD_REG_WORD(&reg->mailbox3);
 			qla2x00_async_event(vha, rsp, mb);
 			break;
-		case 0x13:
-		case 0x14:
+		case INTR_RSP_QUE_UPDATE:
+		case INTR_RSP_QUE_UPDATE_83XX:
 			qla24xx_process_response_queue(vha, rsp);
 			break;
-		case 0x1C: /* ATIO queue updated */
+		case INTR_ATIO_QUE_UPDATE:
 			qlt_24xx_process_atio_queue(vha);
 			break;
-		case 0x1D: /* ATIO and response queues updated */
+		case INTR_ATIO_RSP_QUE_UPDATE:
 			qlt_24xx_process_atio_queue(vha);
 			qla24xx_process_response_queue(vha, rsp);
 			break;
@@ -2673,29 +2673,29 @@ qla24xx_msix_default(int irq, void *dev_id)
 			break;
 
 		switch (stat & 0xff) {
-		case 0x1:
-		case 0x2:
-		case 0x10:
-		case 0x11:
+		case INTR_ROM_MB_SUCCESS:
+		case INTR_ROM_MB_FAILED:
+		case INTR_MB_SUCCESS:
+		case INTR_MB_FAILED:
 			qla24xx_mbx_completion(vha, MSW(stat));
 			status |= MBX_INTERRUPT;
 
 			break;
-		case 0x12:
+		case INTR_ASYNC_EVENT:
 			mb[0] = MSW(stat);
 			mb[1] = RD_REG_WORD(&reg->mailbox1);
 			mb[2] = RD_REG_WORD(&reg->mailbox2);
 			mb[3] = RD_REG_WORD(&reg->mailbox3);
 			qla2x00_async_event(vha, rsp, mb);
 			break;
-		case 0x13:
-		case 0x14:
+		case INTR_RSP_QUE_UPDATE:
+		case INTR_RSP_QUE_UPDATE_83XX:
 			qla24xx_process_response_queue(vha, rsp);
 			break;
-		case 0x1C: /* ATIO queue updated */
+		case INTR_ATIO_QUE_UPDATE:
 			qlt_24xx_process_atio_queue(vha);
 			break;
-		case 0x1D: /* ATIO and response queues updated */
+		case INTR_ATIO_RSP_QUE_UPDATE:
 			qlt_24xx_process_atio_queue(vha);
 			qla24xx_process_response_queue(vha, rsp);
 			break;
-- 
1.7.7

