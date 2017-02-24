From: Manish Rangankar <manish.rangankar@cavium.com>
Subject: [PATCH] qedi: Fix memory leak in tmf response processing.
Date: Fri, 24 Feb 2017 00:31:56 -0800
Message-ID: <1487925116-18650-1-git-send-email-manish.rangankar@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0050.outbound.protection.outlook.com ([104.47.33.50]:10373
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752029AbdBXItK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Feb 2017 03:49:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, lduncan@suse.com, cleech@redhat.com
Cc: linux-scsi@vger.kernel.org, QLogic-Storage-Upstream@cavium.com

From: "Dupuis, Chad" <chad.dupuis@cavium.com>

Signed-off-by: Manish Rangankar <manish.rangankar@cavium.com>
Signed-off-by: Chad Dupuis <chad.dupuis@cavium.com>
---
 drivers/scsi/qedi/qedi_fw.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index b1d3904..c9f0ef4 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -165,10 +165,9 @@ static void qedi_tmf_resp_work(struct work_struct *work)
 	iscsi_block_session(session->cls_session);
 	rval = qedi_cleanup_all_io(qedi, qedi_conn, qedi_cmd->task, true);
 	if (rval) {
-		clear_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
 		qedi_clear_task_idx(qedi, qedi_cmd->task_id);
 		iscsi_unblock_session(session->cls_session);
-		return;
+		goto exit_tmf_resp;
 	}
 
 	iscsi_unblock_session(session->cls_session);
@@ -177,6 +176,8 @@ static void qedi_tmf_resp_work(struct work_struct *work)
 	spin_lock(&session->back_lock);
 	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)resp_hdr_ptr, NULL, 0);
 	spin_unlock(&session->back_lock);
+
+exit_tmf_resp:
 	kfree(resp_hdr_ptr);
 	clear_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
 }
-- 
1.8.5.6
