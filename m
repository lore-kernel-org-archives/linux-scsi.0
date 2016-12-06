From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 13/22] qla2xxx: Fix invalid handle erroneous message.
Date: Tue, 6 Dec 2016 12:30:42 -0800
Message-ID: <1481056251-2310-14-git-send-email-himanshu.madhani@cavium.com>
References: <1481056251-2310-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1481056251-2310-1-git-send-email-himanshu.madhani@cavium.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com
List-Id: linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

Termination of Immediate Notification IOCB was using
wrong IOCB handle. IOCB completion code was unable to
find appropriate code path due to wrong handle.

Following message is seen in the logs.

"Error entry - invalid handle/queue (ffff)."

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_isr.c    | 9 +++++++++
 drivers/scsi/qla2xxx/qla_target.c | 2 +-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 04899f4..c7f73b1 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2630,6 +2630,15 @@ struct scsi_dif_tuple {
 	if (pkt->entry_status & RF_BUSY)
 		res = DID_BUS_BUSY << 16;
 
+	if ((pkt->entry_type == NOTIFY_ACK_TYPE) &&
+		(pkt->handle == QLA_TGT_SKIP_HANDLE)) {
+		/* There are some NACK that uses the SP method and
+		 * some are not using the SP method of sending. filter
+		 * NACK here to prevent erroneous err.
+		 */
+		return;
+	}
+
 	sp = qla2x00_get_sp_from_handle(vha, func, req, pkt);
 	if (sp) {
 		sp->done(vha, sp, res);
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 8ccbd74..e6b2a45 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -3344,7 +3344,7 @@ static int __qlt_send_term_imm_notif(struct scsi_qla_host *vha,
 
 	pkt->entry_type = NOTIFY_ACK_TYPE;
 	pkt->entry_count = 1;
-	pkt->handle = QLA_TGT_SKIP_HANDLE | CTIO_COMPLETION_HANDLE_MARK;
+	pkt->handle = QLA_TGT_SKIP_HANDLE;
 
 	nack = (struct nack_to_isp *)pkt;
 	nack->ox_id = ntfy->ox_id;
-- 
1.8.3.1
