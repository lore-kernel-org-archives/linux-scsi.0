From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 42/43] qla2xxx: Serialize session free in  qlt_free_session_done
Date: Tue, 19 Dec 2017 22:56:43 -0800
Message-ID: <20171220065644.21511-43-himanshu.madhani@cavium.com>
References: <20171220065644.21511-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0057.outbound.protection.outlook.com ([104.47.32.57]:8134
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932477AbdLTG5x (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Dec 2017 01:57:53 -0500
In-Reply-To: <20171220065644.21511-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

Add free_pending flag to serialize queueing of
free_work element onto the work queue

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_def.h    |  1 +
 drivers/scsi/qla2xxx/qla_target.c | 13 +++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 0c31c8ad0c1e..3feb843ef333 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2384,6 +2384,7 @@ typedef struct fc_port {
 
 	unsigned int conf_compl_supported:1;
 	unsigned int deleted:2;
+	unsigned int free_pending:1;
 	unsigned int local:1;
 	unsigned int logout_on_delete:1;
 	unsigned int logo_ack_needed:1;
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 814dfb1036de..225b88c47505 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1105,6 +1105,7 @@ static void qlt_free_session_done(struct work_struct *work)
 			sess->plogi_link[QLT_PLOGI_LINK_SAME_WWN] = NULL;
 		}
 	}
+
 	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf001,
@@ -1118,6 +1119,9 @@ static void qlt_free_session_done(struct work_struct *work)
 		wake_up_all(&vha->fcport_waitQ);
 
 	base_vha = pci_get_drvdata(ha->pdev);
+
+	sess->free_pending = 0;
+
 	if (test_bit(PFLG_DRIVER_REMOVING, &base_vha->pci_flags))
 		return;
 
@@ -1140,11 +1144,20 @@ static void qlt_free_session_done(struct work_struct *work)
 void qlt_unreg_sess(struct fc_port *sess)
 {
 	struct scsi_qla_host *vha = sess->vha;
+	unsigned long flags;
 
 	ql_dbg(ql_dbg_disc, sess->vha, 0x210a,
 	    "%s sess %p for deletion %8phC\n",
 	    __func__, sess, sess->port_name);
 
+	spin_lock_irqsave(&sess->vha->work_lock, flags);
+	if (sess->free_pending) {
+		spin_unlock_irqrestore(&sess->vha->work_lock, flags);
+		return;
+	}
+	sess->free_pending = 1;
+	spin_unlock_irqrestore(&sess->vha->work_lock, flags);
+
 	if (sess->se_sess)
 		vha->hw->tgt.tgt_ops->clear_nacl_from_fcport_map(sess);
 
-- 
2.12.0
