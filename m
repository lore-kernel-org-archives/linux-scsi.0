From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v2 16/17] qla2xxx: Remove unused irq_cmd_count field.
Date: Tue, 30 May 2017 10:54:31 -0700
Message-ID: <20170530175432.26984-17-himanshu.madhani@cavium.com>
References: <20170530175432.26984-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0076.outbound.protection.outlook.com ([104.47.37.76]:56960
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751002AbdE3RzG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 30 May 2017 13:55:06 -0400
In-Reply-To: <20170530175432.26984-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

When driver is unloaded, all sessions are torn down, all
commmands are flushed, chip is reset to ensure there is
no knowledge of target mode in ISP. The irq_cmd_count field
was used to make sure all commands are processed on top of that.
The irq_cmd_count is now redundant and not needed.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_target.c | 9 +--------
 drivers/scsi/qla2xxx/qla_target.h | 1 -
 2 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 3eb8e63834e6..c96dcd31b47b 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -5338,8 +5338,6 @@ static void qlt_response_pkt(struct scsi_qla_host *vha, response_t *pkt)
 	 * Otherwise, some commands can stuck.
 	 */
 
-	tgt->irq_cmd_count++;
-
 	switch (pkt->entry_type) {
 	case CTIO_CRC2:
 	case CTIO_TYPE7:
@@ -5365,10 +5363,8 @@ static void qlt_response_pkt(struct scsi_qla_host *vha, response_t *pkt)
 		}
 
 		rc = qlt_chk_qfull_thresh_hold(vha, atio, true);
-		if (rc != 0) {
-			tgt->irq_cmd_count--;
+		if (rc != 0)
 			return;
-		}
 
 		rc = qlt_handle_cmd_for_atio(vha, atio);
 		if (unlikely(rc != 0)) {
@@ -5500,7 +5496,6 @@ static void qlt_response_pkt(struct scsi_qla_host *vha, response_t *pkt)
 		break;
 	}
 
-	tgt->irq_cmd_count--;
 }
 
 /*
@@ -5530,7 +5525,6 @@ void qlt_async_event(uint16_t code, struct scsi_qla_host *vha,
 	 * Otherwise, some commands can stuck.
 	 */
 
-	tgt->irq_cmd_count++;
 
 	switch (code) {
 	case MBA_RESET:			/* Reset */
@@ -5618,7 +5612,6 @@ void qlt_async_event(uint16_t code, struct scsi_qla_host *vha,
 		break;
 	}
 
-	tgt->irq_cmd_count--;
 }
 
 static fc_port_t *qlt_get_port_database(struct scsi_qla_host *vha,
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index 07ff565485b7..c328a267c4c3 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -790,7 +790,6 @@ struct qla_tgt {
 	 * because req_pkt() can drop/reaquire HW lock inside. Protected by
 	 * HW lock.
 	 */
-	int irq_cmd_count;
 	int atio_irq_cmd_count;
 
 	int datasegs_per_cmd, datasegs_per_cont, sg_tablesize;
-- 
2.12.0
