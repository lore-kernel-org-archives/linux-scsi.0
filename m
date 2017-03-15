From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v4 05/14] qla2xxx: Fix sess_lock & hardware_lock lock order problem.
Date: Wed, 15 Mar 2017 09:48:47 -0700
Message-ID: <20170315164856.17255-6-himanshu.madhani@cavium.com>
References: <20170315164856.17255-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20170315164856.17255-1-himanshu.madhani@cavium.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, Bart.VanAssche@sandisk.com, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com
List-Id: linux-scsi@vger.kernel.org

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
index a78c3e9bcb57..989f931af156 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -5727,30 +5727,23 @@ static void qlt_abort_work(struct qla_tgt *tgt,
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
@@ -5770,7 +5763,7 @@ static void qlt_tmr_work(struct qla_tgt *tgt,
 	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
 
 	if (tgt->tgt_stop)
-		goto out_term;
+		goto out_term2;
 
 	s_id = prm->tm_iocb2.u.isp24.fcp_hdr.s_id;
 	sess = ha->tgt.tgt_ops->find_sess_by_s_id(vha, s_id);
@@ -5782,11 +5775,11 @@ static void qlt_tmr_work(struct qla_tgt *tgt,
 
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
@@ -5794,7 +5787,7 @@ static void qlt_tmr_work(struct qla_tgt *tgt,
 			    "%s: kref_get fail %8phC\n",
 			     __func__, sess->port_name);
 			sess = NULL;
-			goto out_term;
+			goto out_term2;
 		}
 	}
 
@@ -5804,17 +5797,19 @@ static void qlt_tmr_work(struct qla_tgt *tgt,
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
2.12.0
