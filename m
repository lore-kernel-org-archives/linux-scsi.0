From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v3 13/14] qla2xxx: Fix sess_lock & hardware_lock lock order problem.
Date: Fri, 24 Feb 2017 13:37:42 -0800
Message-ID: <1487972263-3795-14-git-send-email-himanshu.madhani@cavium.com>
References: <1487972263-3795-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0060.outbound.protection.outlook.com ([104.47.33.60]:50293
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751332AbdBXViR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Feb 2017 16:38:17 -0500
In-Reply-To: <1487972263-3795-1-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, Bart.VanAssche@sandisk.com, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com

From: Quinn Tran <quinn.tran@cavium.com>

The main lock that needs to be held for CMD or TMR submission
to upper layer is the sess_lock. The sess_lock is used to
serialize cmd submission and session deletion. The addition
of hardware_lock being held is not necessary. This patch removes
hardware_lock dependency from CMD/TMR submission.

Use hardware_lock only for error response in this case.

Path1
       CPU0                    CPU1
       ----                    ----
  lock(&(&ha->tgt.sess_lock)->rlock);
                               lock(&(&ha->hardware_lock)->rlock);
                               lock(&(&ha->tgt.sess_lock)->rlock);
  lock(&(&ha->hardware_lock)->rlock);

Path2/deadlock
*** DEADLOCK ***
Call Trace:
dump_stack+0x85/0xc2
print_circular_bug+0x1e3/0x250
__lock_acquire+0x1425/0x1620
lock_acquire+0xbf/0x210
_raw_spin_lock_irqsave+0x53/0x70
qlt_sess_work_fn+0x21d/0x480 [qla2xxx]
process_one_work+0x1f4/0x6e0

Cc: <stable@vger.kernel.org>
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>
Reported-by: Bart Van Assche <Bart.VanAssche@sandisk.com>
Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_target.c | 41 +++++++++++++++++----------------------
 1 file changed, 18 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index e523c49..46a409e 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -5831,30 +5831,23 @@ static void qlt_abort_work(struct qla_tgt *tgt,
 		}
 	}
 
-	spin_lock_irqsave(&ha->hardware_lock, flags);
-
-	if (tgt->tgt_stop)
-		goto out_term;
-
 	rc = __qlt_24xx_handle_abts(vha, &prm->abts, sess);
+	ha->tgt.tgt_ops->put_sess(sess);
+	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags2);
+
 	if (rc != 0)
 		goto out_term;
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
-	if (sess)
-		ha->tgt.tgt_ops->put_sess(sess);
-	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags2);
 	return;
 
 out_term2:
-	spin_lock_irqsave(&ha->hardware_lock, flags);
+	if (sess)
+		ha->tgt.tgt_ops->put_sess(sess);
+	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags2);
 
 out_term:
+	spin_lock_irqsave(&ha->hardware_lock, flags);
 	qlt_24xx_send_abts_resp(vha, &prm->abts, FCP_TMF_REJECTED, false);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
-
-	if (sess)
-		ha->tgt.tgt_ops->put_sess(sess);
-	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags2);
 }
 
 static void qlt_tmr_work(struct qla_tgt *tgt,
@@ -5874,7 +5867,7 @@ static void qlt_tmr_work(struct qla_tgt *tgt,
 	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
 
 	if (tgt->tgt_stop)
-		goto out_term;
+		goto out_term2;
 
 	s_id = prm->tm_iocb2.u.isp24.fcp_hdr.s_id;
 	sess = ha->tgt.tgt_ops->find_sess_by_s_id(vha, s_id);
@@ -5886,11 +5879,11 @@ static void qlt_tmr_work(struct qla_tgt *tgt,
 
 		spin_lock_irqsave(&ha->tgt.sess_lock, flags);
 		if (!sess)
-			goto out_term;
+			goto out_term2;
 	} else {
 		if (sess->deleted) {
 			sess = NULL;
-			goto out_term;
+			goto out_term2;
 		}
 
 		if (!kref_get_unless_zero(&sess->sess_kref)) {
@@ -5898,7 +5891,7 @@ static void qlt_tmr_work(struct qla_tgt *tgt,
 			    "%s: kref_get fail %8phC\n",
 			     __func__, sess->port_name);
 			sess = NULL;
-			goto out_term;
+			goto out_term2;
 		}
 	}
 
@@ -5908,17 +5901,19 @@ static void qlt_tmr_work(struct qla_tgt *tgt,
 	unpacked_lun = scsilun_to_int((struct scsi_lun *)&lun);
 
 	rc = qlt_issue_task_mgmt(sess, unpacked_lun, fn, iocb, 0);
-	if (rc != 0)
-		goto out_term;
-
 	ha->tgt.tgt_ops->put_sess(sess);
 	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
+
+	if (rc != 0)
+		goto out_term;
 	return;
 
+out_term2:
+	if (sess)
+		ha->tgt.tgt_ops->put_sess(sess);
+	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 out_term:
 	qlt_send_term_exchange(vha, NULL, &prm->tm_iocb2, 1, 0);
-	ha->tgt.tgt_ops->put_sess(sess);
-	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 }
 
 static void qlt_sess_work_fn(struct work_struct *work)
-- 
1.8.3.1
