From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH 2/4] qla2xxx: Use ATIO type to send correct tmr response
Date: Thu, 4 Feb 2016 11:45:17 -0500
Message-ID: <1454604319-27947-3-git-send-email-himanshu.madhani@qlogic.com>
References: <1454604319-27947-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1454604319-27947-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org, himanshu.madhani@qlogic.com
List-Id: linux-scsi@vger.kernel.org

From: Swapnil Nagle <swapnil.nagle@purestorage.com>

The function value inside se_cmd can change if the TMR is cancelled.
Use original ATIO Type to correctly determine CTIO response.

Signed-off-by: Swapnil Nagle <swapnil.nagle@purestroage.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_target.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 74eb776..46c6679 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1756,7 +1756,7 @@ void qlt_xmit_tm_rsp(struct qla_tgt_mgmt_cmd *mcmd)
 		qlt_send_notify_ack(vha, &mcmd->orig_iocb.imm_ntfy,
 		    0, 0, 0, 0, 0, 0);
 	else {
-		if (mcmd->se_cmd.se_tmr_req->function == TMR_ABORT_TASK)
+		if (mcmd->orig_iocb.atio.u.raw.entry_type == ABTS_RECV_24XX)
 			qlt_24xx_send_abts_resp(vha, &mcmd->orig_iocb.abts,
 			    mcmd->fc_tm_rsp, false);
 		else
-- 
1.7.7
