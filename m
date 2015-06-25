From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH 07/11] qla2xxx: drop cmds/tmrs arrived while session is being deleted
Date: Thu, 25 Jun 2015 12:33:47 -0400
Message-ID: <1435250031-20525-8-git-send-email-himanshu.madhani@qlogic.com>
References: <1435250031-20525-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:53626 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752694AbbFYRSM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Jun 2015 13:18:12 -0400
In-Reply-To: <1435250031-20525-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Alexei Potashnik <alexei@purestorage.com>

If a new initiator (different WWN) shows up on the same fcport, old
initiator's session is scheduled for deletion. But there is a small
window between it being marked with QLA_SESS_DELETION_IN_PROGRESS
and qlt_unret_sess getting called when new session's commands will
keep finding old session in the fcport map.

This patch drops cmds/tmrs if they find session in the progress of
being deleted.

Cc: <stable@vger.kernel.org>
Signed-off-by: Alexei Potashnik <alexei@purestorage.com>
Acked-by: Quinn Tran <quinn.tran@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_target.c |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index b14623c..ed9fdd7 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1477,6 +1477,11 @@ static void qlt_24xx_handle_abts(struct scsi_qla_host *vha,
 		return;
 	}
 
+	if (sess->deleted == QLA_SESS_DELETION_IN_PROGRESS) {
+		qlt_24xx_send_abts_resp(vha, abts, FCP_TMF_REJECTED, false);
+		return;
+	}
+
 	rc = __qlt_24xx_handle_abts(vha, abts, sess);
 	if (rc != 0) {
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf054,
@@ -3776,6 +3781,16 @@ static int qlt_handle_cmd_for_atio(struct scsi_qla_host *vha,
 		queue_work(qla_tgt_wq, &op->work);
 		return 0;
 	}
+
+	/* Another WWN used to have our s_id. Our PLOGI scheduled its
+	 * session deletion, but it's still in sess_del_work wq */
+	if (sess->deleted == QLA_SESS_DELETION_IN_PROGRESS) {
+		ql_dbg(ql_dbg_io, vha, 0x3061,
+		    "New command while old session %p is being deleted\n",
+		    sess);
+		return -EFAULT;
+	}
+
 	/*
 	 * Do kref_get() before returning + dropping qla_hw_data->hardware_lock.
 	 */
@@ -3939,6 +3954,9 @@ static int qlt_handle_task_mgmt(struct scsi_qla_host *vha, void *iocb)
 		    sizeof(struct atio_from_isp));
 	}
 
+	if (sess->deleted == QLA_SESS_DELETION_IN_PROGRESS)
+		return -EFAULT;
+
 	return qlt_issue_task_mgmt(sess, unpacked_lun, fn, iocb, 0);
 }
 
@@ -5616,6 +5634,11 @@ static void qlt_abort_work(struct qla_tgt *tgt,
 		if (!sess)
 			goto out_term;
 	} else {
+		if (sess->deleted == QLA_SESS_DELETION_IN_PROGRESS) {
+			sess = NULL;
+			goto out_term;
+		}
+
 		kref_get(&sess->se_sess->sess_kref);
 	}
 
@@ -5670,6 +5693,11 @@ static void qlt_tmr_work(struct qla_tgt *tgt,
 		if (!sess)
 			goto out_term;
 	} else {
+		if (sess->deleted == QLA_SESS_DELETION_IN_PROGRESS) {
+			sess = NULL;
+			goto out_term;
+		}
+
 		kref_get(&sess->se_sess->sess_kref);
 	}
 
-- 
1.7.7

