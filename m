From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v2 09/10] qla2xxx: Fix invalid handle erroneous message.
Date: Wed, 21 Dec 2016 13:57:38 -0800
Message-ID: <1482357459-31079-10-git-send-email-himanshu.madhani@cavium.com>
References: <1482357459-31079-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1482357459-31079-1-git-send-email-himanshu.madhani@cavium.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, bart.vanassche@gmail.com, hch@infradead.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com
List-Id: linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

Termination of Immediate Notify IOCB was using wrong
IOCB handle. IOCB completion code was unable to find
appropriate code path due to wrong handle.

Following message is seen in the logs.

"Error entry - invalid handle/queue (ffff)."

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_isr.c    | 4 ++++
 drivers/scsi/qla2xxx/qla_target.c | 2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index af840bf..eefcf2f 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2495,6 +2495,10 @@ struct scsi_dif_tuple {
 	if (pkt->entry_status & RF_BUSY)
 		res = DID_BUS_BUSY << 16;
 
+	if (pkt->entry_type == NOTIFY_ACK_TYPE &&
+	    pkt->handle == QLA_TGT_SKIP_HANDLE)
+		return;
+
 	sp = qla2x00_get_sp_from_handle(vha, func, req, pkt);
 	if (sp) {
 		sp->done(ha, sp, res);
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 9252694..c02f31a 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -3061,7 +3061,7 @@ static int __qlt_send_term_imm_notif(struct scsi_qla_host *vha,
 
 	pkt->entry_type = NOTIFY_ACK_TYPE;
 	pkt->entry_count = 1;
-	pkt->handle = QLA_TGT_SKIP_HANDLE | CTIO_COMPLETION_HANDLE_MARK;
+	pkt->handle = QLA_TGT_SKIP_HANDLE;
 
 	nack = (struct nack_to_isp *)pkt;
 	nack->ox_id = ntfy->ox_id;
-- 
1.8.3.1
