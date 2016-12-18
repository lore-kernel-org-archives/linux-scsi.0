From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 6/9] qla2xxx: Remove direct access of scsi_status field in se_cmd
Date: Sun, 18 Dec 2016 01:02:46 -0800
Message-ID: <1482051769-22941-7-git-send-email-himanshu.madhani@cavium.com>
References: <1482051769-22941-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1482051769-22941-1-git-send-email-himanshu.madhani@cavium.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, bart.vanassche@gmail.com, hch@infradead.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com
List-Id: linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_def.h    | 1 +
 drivers/scsi/qla2xxx/qla_target.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index f7df01b..1f9d2b9 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -1793,6 +1793,7 @@ struct crc_context {
 #define SS_RESIDUAL_OVER		BIT_10
 #define SS_SENSE_LEN_VALID		BIT_9
 #define SS_RESPONSE_INFO_LEN_VALID	BIT_8
+#define SS_SCSI_STATUS_BYTE	0xff
 
 #define SS_RESERVE_CONFLICT		(BIT_4 | BIT_3)
 #define SS_BUSY_CONDITION		BIT_3
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 20f1b50..1690794 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -2277,7 +2277,7 @@ static void qlt_24xx_init_ctio_to_isp(struct ctio7_to_24xx *ctio,
 		int i;
 
 		if (qlt_need_explicit_conf(prm->tgt->ha, prm->cmd, 1)) {
-			if (prm->cmd->se_cmd.scsi_status != 0) {
+			if ((prm->rq_result & SS_SCSI_STATUS_BYTE) != 0) {
 				ql_dbg(ql_dbg_tgt, prm->cmd->vha, 0xe017,
 				    "Skipping EXPLICIT_CONFORM and "
 				    "CTIO7_FLAGS_CONFORM_REQ for FCP READ w/ "
-- 
1.8.3.1
