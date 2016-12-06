From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 01/22] qla2xxx: Fix wrong IOCB type assumption.
Date: Tue, 6 Dec 2016 12:30:30 -0800
Message-ID: <1481056251-2310-2-git-send-email-himanshu.madhani@cavium.com>
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

qlt_reset is call with Immedidate Notification IOCB only.
Current code wrongly cast it as ATIO IOCB.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_target.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index bff9689..8a762a6 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -668,11 +668,10 @@ static int qlt_reset(struct scsi_qla_host *vha, void *iocb, int mcmd)
 {
 	struct qla_hw_data *ha = vha->hw;
 	struct qla_tgt_sess *sess = NULL;
-	uint32_t unpacked_lun, lun = 0;
+	uint32_t unpacked_lun = 0;
 	uint16_t loop_id;
 	int res = 0;
 	struct imm_ntfy_from_isp *n = (struct imm_ntfy_from_isp *)iocb;
-	struct atio_from_isp *a = (struct atio_from_isp *)iocb;
 	unsigned long flags;
 
 	loop_id = le16_to_cpu(n->u.isp24.nport_handle);
@@ -725,9 +724,6 @@ static int qlt_reset(struct scsi_qla_host *vha, void *iocb, int mcmd)
 	    "loop_id %d)\n", vha->host_no, sess, sess->port_name,
 	    mcmd, loop_id);
 
-	lun = a->u.isp24.fcp_cmnd.lun;
-	unpacked_lun = scsilun_to_int((struct scsi_lun *)&lun);
-
 	return qlt_issue_task_mgmt(sess, unpacked_lun, mcmd,
 	    iocb, QLA24XX_MGMT_SEND_NACK);
 }
-- 
1.8.3.1
