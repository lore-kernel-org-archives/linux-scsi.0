From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 2/5] qla2xxx: Check + fail when npiv_vports_inuse exists in shutdown
Date: Thu, 20 Feb 2014 21:03:26 +0000
Message-ID: <1392930209-25065-3-git-send-email-nab@daterainc.com>
References: <1392930209-25065-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1392930209-25065-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Sawan Chandak <sawan.chandak@qlogic.com>, Quinn Tran <quinn.tran@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds an check to qlt_stop_phase1() to avoid shutdown
when the base_vha contains a non-zero fc_host->npiv_vports_inuse
count.

This includes holding qla_tgt_mutex in qlt_stop_phase1() between
the fc_host->npiv_vports_inuse check + setting of tgt->tgt_stop to
avoid a possible race between qlt_lport_register() -> tcm_qla2xxx
-> tcm_qla2xxx_lport_register_npiv_cb() calling fc_vport_create().

Cc: Sawan Chandak <sawan.chandak@qlogic.com>
Cc: Quinn Tran <quinn.tran@qlogic.com>
Cc: Saurav Kashyap <saurav.kashyap@qlogic.com>
Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/qla2xxx/qla_target.c |   23 ++++++++++++++++++++---
 drivers/scsi/qla2xxx/qla_target.h |    2 +-
 2 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index ea3eaef..f2e1c5a 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -790,17 +790,32 @@ static inline int test_tgt_sess_count(struct qla_tgt *tgt)
 }
 
 /* Called by tcm_qla2xxx configfs code */
-void qlt_stop_phase1(struct qla_tgt *tgt)
+int qlt_stop_phase1(struct qla_tgt *tgt)
 {
 	struct scsi_qla_host *vha = tgt->vha;
 	struct qla_hw_data *ha = tgt->ha;
 	unsigned long flags;
 
+	mutex_lock(&qla_tgt_mutex);
+	if (!vha->fc_vport) {
+		struct Scsi_Host *sh = vha->host;
+		struct fc_host_attrs *fc_host = shost_to_fc_host(sh);
+		bool npiv_vports;
+
+		spin_lock_irqsave(sh->host_lock, flags);
+		npiv_vports = (fc_host->npiv_vports_inuse);
+		spin_unlock_irqrestore(sh->host_lock, flags);
+
+		if (npiv_vports) {
+			mutex_unlock(&qla_tgt_mutex);
+			return -EPERM;
+		}
+	}
 	if (tgt->tgt_stop || tgt->tgt_stopped) {
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf04e,
 		    "Already in tgt->tgt_stop or tgt_stopped state\n");
-		dump_stack();
-		return;
+		mutex_unlock(&qla_tgt_mutex);
+		return -EPERM;
 	}
 
 	ql_dbg(ql_dbg_tgt, vha, 0xe003, "Stopping target for host %ld(%p)\n",
@@ -815,6 +830,7 @@ void qlt_stop_phase1(struct qla_tgt *tgt)
 	qlt_clear_tgt_db(tgt, true);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	mutex_unlock(&vha->vha_tgt.tgt_mutex);
+	mutex_unlock(&qla_tgt_mutex);
 
 	flush_delayed_work(&tgt->sess_del_work);
 
@@ -841,6 +857,7 @@ void qlt_stop_phase1(struct qla_tgt *tgt)
 
 	/* Wait for sessions to clear out (just in case) */
 	wait_event(tgt->waitQ, test_tgt_sess_count(tgt));
+	return 0;
 }
 EXPORT_SYMBOL(qlt_stop_phase1);
 
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index 66e755c..ce33d8c 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -1001,7 +1001,7 @@ extern void qlt_modify_vp_config(struct scsi_qla_host *,
 extern void qlt_probe_one_stage1(struct scsi_qla_host *, struct qla_hw_data *);
 extern int qlt_mem_alloc(struct qla_hw_data *);
 extern void qlt_mem_free(struct qla_hw_data *);
-extern void qlt_stop_phase1(struct qla_tgt *);
+extern int qlt_stop_phase1(struct qla_tgt *);
 extern void qlt_stop_phase2(struct qla_tgt *);
 extern irqreturn_t qla83xx_msix_atio_q(int, void *);
 extern void qlt_83xx_iospace_config(struct qla_hw_data *);
-- 
1.7.10.4
