From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v2 34/37] qla2xxx: Remove unused argument from qlt_schedule_sess_for_deletion()
Date: Thu, 28 Dec 2017 12:33:42 -0800
Message-ID: <20171228203345.2702-35-himanshu.madhani@cavium.com>
References: <20171228203345.2702-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0087.outbound.protection.outlook.com ([104.47.41.87]:57775
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754134AbdL1Uei (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 28 Dec 2017 15:34:38 -0500
In-Reply-To: <20171228203345.2702-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

Immeadiate flag is not used for scheduling session deletion.
Remove it to simplfy session deletion code path.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_gbl.h    |  2 +-
 drivers/scsi/qla2xxx/qla_init.c   | 10 +++++-----
 drivers/scsi/qla2xxx/qla_target.c | 16 +++++++---------
 3 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 3f3863c09de2..47bff9ab1176 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -887,7 +887,7 @@ void qla24xx_do_nack_work(struct scsi_qla_host *, struct qla_work_evt *);
 void qlt_plogi_ack_link(struct scsi_qla_host *, struct qlt_plogi_ack_t *,
 	struct fc_port *, enum qlt_plogi_link_t);
 void qlt_plogi_ack_unref(struct scsi_qla_host *, struct qlt_plogi_ack_t *);
-extern void qlt_schedule_sess_for_deletion(struct fc_port *, bool);
+extern void qlt_schedule_sess_for_deletion(struct fc_port *);
 extern void qlt_schedule_sess_for_deletion_lock(struct fc_port *);
 extern struct fc_port *qlt_find_sess_invalidate_other(scsi_qla_host_t *,
 	uint64_t wwn, port_id_t port_id, uint16_t loop_id, struct fc_port **);
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 956f51e78e5c..aaa8c07b2d8d 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -353,7 +353,7 @@ void qla24xx_handle_adisc_event(scsi_qla_host_t *vha, struct event_arg *ea)
 		ql_dbg(ql_dbg_disc, vha, 0x2066,
 		    "%s %8phC: adisc fail: post delete\n",
 		    __func__, ea->fcport->port_name);
-		qlt_schedule_sess_for_deletion(ea->fcport, 1);
+		qlt_schedule_sess_for_deletion(ea->fcport);
 		return;
 	}
 
@@ -527,7 +527,7 @@ static void qla24xx_handle_gnl_done_event(scsi_qla_host_t *vha,
 			ql_dbg(ql_dbg_disc, vha, 0x20e3,
 			    "%s %d %8phC post del sess\n",
 			    __func__, __LINE__, fcport->port_name);
-			qlt_schedule_sess_for_deletion(fcport, 1);
+			qlt_schedule_sess_for_deletion(fcport);
 			return;
 		}
 
@@ -599,7 +599,7 @@ static void qla24xx_handle_gnl_done_event(scsi_qla_host_t *vha,
 				    __func__, __LINE__,
 				    conflict_fcport->port_name);
 				qlt_schedule_sess_for_deletion
-					(conflict_fcport, 1);
+					(conflict_fcport);
 			}
 
 			/* FW already picked this loop id for another fcport */
@@ -1134,7 +1134,7 @@ static void qla_chk_n2n_b4_login(struct scsi_qla_host *vha, fc_port_t *fcport)
 				    "%s %d %8phC post del sess - out of loopid\n",
 				    __func__, __LINE__, fcport->port_name);
 				fcport->scan_state = 0;
-				qlt_schedule_sess_for_deletion(fcport, true);
+				qlt_schedule_sess_for_deletion(fcport);
 				return;
 			}
 		}
@@ -1780,7 +1780,7 @@ qla24xx_handle_plogi_done_event(struct scsi_qla_host *vha, struct event_arg *ea)
 			set_bit(lid, vha->hw->loop_id_map);
 			ea->fcport->loop_id = lid;
 			ea->fcport->keep_nport_handle = 0;
-			qlt_schedule_sess_for_deletion(ea->fcport, false);
+			qlt_schedule_sess_for_deletion(ea->fcport);
 		}
 		break;
 	}
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 786efdb5788a..867d089c3ebe 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1211,8 +1211,7 @@ static void qla24xx_chk_fcp_state(struct fc_port *sess)
 }
 
 /* ha->tgt.sess_lock supposed to be held on entry */
-void qlt_schedule_sess_for_deletion(struct fc_port *sess,
-	bool immediate)
+void qlt_schedule_sess_for_deletion(struct fc_port *sess)
 {
 	struct qla_tgt *tgt = sess->tgt;
 
@@ -1252,7 +1251,7 @@ void qlt_schedule_sess_for_deletion_lock(struct fc_port *sess)
 	unsigned long flags;
 	struct qla_hw_data *ha = sess->vha->hw;
 	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
-	qlt_schedule_sess_for_deletion(sess, 1);
+	qlt_schedule_sess_for_deletion(sess);
 	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 }
 
@@ -1264,7 +1263,7 @@ static void qlt_clear_tgt_db(struct qla_tgt *tgt)
 
 	list_for_each_entry(sess, &vha->vp_fcports, list) {
 		if (sess->se_sess)
-			qlt_schedule_sess_for_deletion(sess, 1);
+			qlt_schedule_sess_for_deletion(sess);
 	}
 
 	/* At this point tgt could be already dead */
@@ -1439,7 +1438,7 @@ qlt_fc_port_deleted(struct scsi_qla_host *vha, fc_port_t *fcport, int max_gen)
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf008, "qla_tgt_fc_port_deleted %p", sess);
 
 	sess->local = 1;
-	qlt_schedule_sess_for_deletion(sess, false);
+	qlt_schedule_sess_for_deletion(sess);
 	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
 }
 
@@ -4522,7 +4521,7 @@ qlt_find_sess_invalidate_other(scsi_qla_host_t *vha, uint64_t wwn,
 				 * might have cleared it when requested this session
 				 * deletion, so don't touch it
 				 */
-				qlt_schedule_sess_for_deletion(other_sess, true);
+				qlt_schedule_sess_for_deletion(other_sess);
 			} else {
 				/*
 				 * Another wwn used to have our s_id/loop_id
@@ -4535,8 +4534,7 @@ qlt_find_sess_invalidate_other(scsi_qla_host_t *vha, uint64_t wwn,
 				other_sess->keep_nport_handle = 1;
 				if (other_sess->disc_state != DSC_DELETED)
 					*conflict_sess = other_sess;
-				qlt_schedule_sess_for_deletion(other_sess,
-				    true);
+				qlt_schedule_sess_for_deletion(other_sess);
 			}
 			continue;
 		}
@@ -4550,7 +4548,7 @@ qlt_find_sess_invalidate_other(scsi_qla_host_t *vha, uint64_t wwn,
 
 			/* Same loop_id but different s_id
 			 * Ok to kill and logout */
-			qlt_schedule_sess_for_deletion(other_sess, true);
+			qlt_schedule_sess_for_deletion(other_sess);
 		}
 	}
 
-- 
2.12.0
