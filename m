From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v3 12/15] qla2xxx: Remove redundant wait when target is stopped.
Date: Fri, 2 Jun 2017 09:12:04 -0700
Message-ID: <20170602161207.6660-13-himanshu.madhani@cavium.com>
References: <20170602161207.6660-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0089.outbound.protection.outlook.com ([104.47.40.89]:45201
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751208AbdFBQMa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 2 Jun 2017 12:12:30 -0400
In-Reply-To: <20170602161207.6660-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

Current code already destroy all target sessions when
target Mode is stopped. Target core would waits for
all commands that belong to each session to purge.
The extra wait for interrupts to settle down is not
relevant.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_target.c | 33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 324048476d9e..f9ccf845d084 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1427,6 +1427,8 @@ int qlt_stop_phase1(struct qla_tgt *tgt)
 
 		if (npiv_vports) {
 			mutex_unlock(&qla_tgt_mutex);
+			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf021,
+			    "NPIV is in use. Can not stop target\n");
 			return -EPERM;
 		}
 	}
@@ -1437,7 +1439,7 @@ int qlt_stop_phase1(struct qla_tgt *tgt)
 		return -EPERM;
 	}
 
-	ql_dbg(ql_dbg_tgt, vha, 0xe003, "Stopping target for host %ld(%p)\n",
+	ql_dbg(ql_dbg_tgt_mgt, vha, 0xe003, "Stopping target for host %ld(%p)\n",
 	    vha->host_no, vha);
 	/*
 	 * Mutex needed to sync with qla_tgt_fc_port_[added,deleted].
@@ -1480,9 +1482,7 @@ EXPORT_SYMBOL(qlt_stop_phase1);
 /* Called by tcm_qla2xxx configfs code */
 void qlt_stop_phase2(struct qla_tgt *tgt)
 {
-	struct qla_hw_data *ha = tgt->ha;
-	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
-	unsigned long flags;
+	scsi_qla_host_t *vha = tgt->vha;
 
 	if (tgt->tgt_stopped) {
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf04f,
@@ -1490,24 +1490,19 @@ void qlt_stop_phase2(struct qla_tgt *tgt)
 		dump_stack();
 		return;
 	}
-
-	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf00b,
-	    "Waiting for %d IRQ commands to complete (tgt %p)",
-	    tgt->irq_cmd_count, tgt);
+	if (!tgt->tgt_stop) {
+		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf00b,
+		    "%s: phase1 stop is not completed\n", __func__);
+		dump_stack();
+		return;
+	}
 
 	mutex_lock(&vha->vha_tgt.tgt_mutex);
-	spin_lock_irqsave(&ha->hardware_lock, flags);
-	while ((tgt->irq_cmd_count != 0) || (tgt->atio_irq_cmd_count != 0)) {
-		spin_unlock_irqrestore(&ha->hardware_lock, flags);
-		udelay(2);
-		spin_lock_irqsave(&ha->hardware_lock, flags);
-	}
 	tgt->tgt_stop = 0;
 	tgt->tgt_stopped = 1;
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	mutex_unlock(&vha->vha_tgt.tgt_mutex);
 
-	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf00c, "Stop of tgt %p finished",
+	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf00c, "Stop of tgt %p finished\n",
 	    tgt);
 }
 EXPORT_SYMBOL(qlt_stop_phase2);
@@ -1517,6 +1512,10 @@ static void qlt_release(struct qla_tgt *tgt)
 {
 	scsi_qla_host_t *vha = tgt->vha;
 
+	if ((vha->vha_tgt.qla_tgt != NULL) && !tgt->tgt_stop &&
+	    !tgt->tgt_stopped)
+		qlt_stop_phase1(tgt);
+
 	if ((vha->vha_tgt.qla_tgt != NULL) && !tgt->tgt_stopped)
 		qlt_stop_phase2(tgt);
 
@@ -5531,7 +5530,7 @@ void qlt_async_event(uint16_t code, struct scsi_qla_host *vha,
 	struct qla_tgt *tgt = vha->vha_tgt.qla_tgt;
 	int login_code;
 
-	if (!ha->tgt.tgt_ops)
+	if (!tgt || tgt->tgt_stop || tgt->tgt_stopped)
 		return;
 
 	if (unlikely(tgt == NULL)) {
-- 
2.12.0
