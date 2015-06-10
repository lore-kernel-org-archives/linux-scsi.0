From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH 1/9] qla2xxx: Fix hardware lock/unlock issue causing kernel panic.
Date: Wed, 10 Jun 2015 11:05:17 -0400
Message-ID: <1433948725-4073-2-git-send-email-himanshu.madhani@qlogic.com>
References: <1433948725-4073-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:53855 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965993AbbFJPtL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Jun 2015 11:49:11 -0400
In-Reply-To: <1433948725-4073-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Saurav Kashyap <saurav.kashyap@qlogic.com>

[ Upstream commit ef86cb2059a14b4024c7320999ee58e938873032 ]

This patch fixes a kernel panic for qla2xxx Target core
Module driver introduced by a fix in the qla2xxx initiator code.

Commit ef86cb2 ("qla2xxx: Mark port lost when we receive an RSCN for it.")
introduced the regression for qla2xxx Target driver.

Stack trace will have following signature

 --- <NMI exception stack> ---
[ffff88081faa3cc8] _raw_spin_lock_irqsave at ffffffff815b1f03
[ffff88081faa3cd0] qlt_fc_port_deleted at ffffffffa096ccd0 [qla2xxx]
[ffff88081faa3d20] qla2x00_schedule_rport_del at ffffffffa0913831[qla2xxx]
[ffff88081faa3d50] qla2x00_mark_device_lost at ffffffffa09159c5[qla2xxx]
[ffff88081faa3db0] qla2x00_async_event at ffffffffa0938d59 [qla2xxx]
[ffff88081faa3e30] qla24xx_msix_default at ffffffffa093a326 [qla2xxx]
[ffff88081faa3e90] handle_irq_event_percpu at ffffffff810a7b8d
[ffff88081faa3ee0] handle_irq_event at ffffffff810a7d32
[ffff88081faa3f10] handle_edge_irq at ffffffff810ab6b9
[ffff88081faa3f30] handle_irq at ffffffff8100619c
[ffff88081faa3f70] do_IRQ at ffffffff815b4b1c
 --- <IRQ stack> ---

Cc: <stable@vger.kernel.org>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c   |    4 ++++
 drivers/scsi/qla2xxx/qla_target.c |    6 ------
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 285cb20..3c1550a 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2924,6 +2924,7 @@ qla2x00_rport_del(void *data)
 	struct fc_rport *rport;
 	scsi_qla_host_t *vha = fcport->vha;
 	unsigned long flags;
+	unsigned long vha_flags;
 
 	spin_lock_irqsave(fcport->vha->host->host_lock, flags);
 	rport = fcport->drport ? fcport->drport: fcport->rport;
@@ -2935,7 +2936,9 @@ qla2x00_rport_del(void *data)
 		 * Release the target mode FC NEXUS in qla_target.c code
 		 * if target mod is enabled.
 		 */
+		spin_lock_irqsave(&vha->hw->hardware_lock, vha_flags);
 		qlt_fc_port_deleted(vha, fcport);
+		spin_unlock_irqrestore(&vha->hw->hardware_lock, vha_flags);
 	}
 }
 
@@ -3303,6 +3306,7 @@ qla2x00_reg_remote_port(scsi_qla_host_t *vha, fc_port_t *fcport)
 	 * Create target mode FC NEXUS in qla_target.c if target mode is
 	 * enabled..
 	 */
+
 	qlt_fc_port_added(vha, fcport);
 
 	spin_lock_irqsave(fcport->vha->host->host_lock, flags);
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index fe8a8d1..ed39ed2 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -782,10 +782,8 @@ void qlt_fc_port_added(struct scsi_qla_host *vha, fc_port_t *fcport)
 
 void qlt_fc_port_deleted(struct scsi_qla_host *vha, fc_port_t *fcport)
 {
-	struct qla_hw_data *ha = vha->hw;
 	struct qla_tgt *tgt = vha->vha_tgt.qla_tgt;
 	struct qla_tgt_sess *sess;
-	unsigned long flags;
 
 	if (!vha->hw->tgt.tgt_ops)
 		return;
@@ -793,14 +791,11 @@ void qlt_fc_port_deleted(struct scsi_qla_host *vha, fc_port_t *fcport)
 	if (!tgt || (fcport->port_type != FCT_INITIATOR))
 		return;
 
-	spin_lock_irqsave(&ha->hardware_lock, flags);
 	if (tgt->tgt_stop) {
-		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 		return;
 	}
 	sess = qlt_find_sess_by_port_name(tgt, fcport->port_name);
 	if (!sess) {
-		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 		return;
 	}
 
@@ -808,7 +803,6 @@ void qlt_fc_port_deleted(struct scsi_qla_host *vha, fc_port_t *fcport)
 
 	sess->local = 1;
 	qlt_schedule_sess_for_deletion(sess, false);
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 }
 
 static inline int test_tgt_sess_count(struct qla_tgt *tgt)
-- 
1.7.7

