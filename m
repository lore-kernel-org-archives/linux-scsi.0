From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 2/3] qla2xxx: Fix slow mem alloc behind lock
Date: Wed, 30 Aug 2017 10:16:49 -0700
Message-ID: <20170830171650.32341-3-himanshu.madhani@cavium.com>
References: <20170830171650.32341-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0054.outbound.protection.outlook.com ([104.47.40.54]:4311
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752089AbdH3RRC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 30 Aug 2017 13:17:02 -0400
In-Reply-To: <20170830171650.32341-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@qlogic.com>

Call Trace:
 [<ffffffff81341687>] dump_stack+0x6b/0xa4
 [<ffffffff810c3e30>] ? print_irqtrace_events+0xd0/0xe0
 [<ffffffff8109e3c3>] ___might_sleep+0x183/0x240
 [<ffffffff8109e4d2>] __might_sleep+0x52/0x90
 [<ffffffff811fe17b>] kmem_cache_alloc_trace+0x5b/0x300
 [<ffffffff810c666b>] ? __lock_acquired+0x30b/0x420
 [<ffffffffa0733c28>] qla2x00_alloc_fcport+0x38/0x2a0 [qla2xxx]
 [<ffffffffa07217f4>] ? qla2x00_do_work+0x34/0x2b0 [qla2xxx]
 [<ffffffff816cc82b>] ? _raw_spin_lock_irqsave+0x7b/0x90
 [<ffffffffa072169a>] ? qla24xx_create_new_sess+0x3a/0x160 [qla2xxx]
 [<ffffffffa0721723>] qla24xx_create_new_sess+0xc3/0x160 [qla2xxx]
 [<ffffffff810c91ed>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffffa07218f8>] qla2x00_do_work+0x138/0x2b0 [qla2xxx]

Signed-off-by: Quinn Tran <quinn.tran@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_gbl.h    |  1 +
 drivers/scsi/qla2xxx/qla_os.c     | 33 ++++++++++++++++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_target.c |  2 +-
 3 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 0b219b3ca653..f852ca60c49f 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -113,6 +113,7 @@ int qla24xx_post_gpdb_work(struct scsi_qla_host *, fc_port_t *, u8);
 extern char qla2x00_version_str[];
 
 extern struct kmem_cache *srb_cachep;
+extern struct kmem_cache *qla_tgt_plogi_cachep;
 
 extern int ql2xlogintimeout;
 extern int qlport_down_retry;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 56bd086b79ea..5b2437a5ea44 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4677,9 +4677,10 @@ static
 void qla24xx_create_new_sess(struct scsi_qla_host *vha, struct qla_work_evt *e)
 {
 	unsigned long flags;
-	fc_port_t *fcport =  NULL;
+	fc_port_t *fcport =  NULL, *tfcp;
 	struct qlt_plogi_ack_t *pla =
 	    (struct qlt_plogi_ack_t *)e->u.new_sess.pla;
+	uint8_t free_fcport = 0;
 
 	spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
 	fcport = qla2x00_find_fcport_by_wwpn(vha, e->u.new_sess.port_name, 1);
@@ -4694,6 +4695,7 @@ void qla24xx_create_new_sess(struct scsi_qla_host *vha, struct qla_work_evt *e)
 			pla->ref_count--;
 		}
 	} else {
+		spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
 		fcport = qla2x00_alloc_fcport(vha, GFP_KERNEL);
 		if (fcport) {
 			fcport->d_id = e->u.new_sess.id;
@@ -4703,6 +4705,29 @@ void qla24xx_create_new_sess(struct scsi_qla_host *vha, struct qla_work_evt *e)
 
 			memcpy(fcport->port_name, e->u.new_sess.port_name,
 			    WWN_SIZE);
+		} else {
+			ql_dbg(ql_dbg_disc, vha, 0xffff,
+				   "%s %8phC mem alloc fail.\n",
+				   __func__, e->u.new_sess.port_name);
+
+			if (pla)
+				kmem_cache_free(qla_tgt_plogi_cachep, pla);
+			return;
+		}
+
+		spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
+		/* search again to make sure one else got ahead */
+		tfcp = qla2x00_find_fcport_by_wwpn(vha,
+		    e->u.new_sess.port_name, 1);
+		if (tfcp) {
+			/* should rarily happen */
+			ql_dbg(ql_dbg_disc, vha, 0xffff,
+			    "%s %8phC found existing fcport b4 add. DS %d LS %d\n",
+			    __func__, tfcp->port_name, tfcp->disc_state,
+			    tfcp->fw_login_state);
+
+			free_fcport = 1;
+		} else {
 			list_add_tail(&fcport->list, &vha->vp_fcports);
 
 			if (pla) {
@@ -4720,6 +4745,12 @@ void qla24xx_create_new_sess(struct scsi_qla_host *vha, struct qla_work_evt *e)
 		else
 			qla24xx_async_gnl(vha, fcport);
 	}
+
+	if (free_fcport) {
+		qla2x00_free_fcport(fcport);
+		if (pla)
+			kmem_cache_free(qla_tgt_plogi_cachep, pla);
+	}
 }
 
 void
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 43113d52893b..192554b1536f 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -145,7 +145,7 @@ static void qlt_send_busy(struct qla_qpair *, struct atio_from_isp *,
  * Global Variables
  */
 static struct kmem_cache *qla_tgt_mgmt_cmd_cachep;
-static struct kmem_cache *qla_tgt_plogi_cachep;
+struct kmem_cache *qla_tgt_plogi_cachep;
 static mempool_t *qla_tgt_mgmt_cmd_mempool;
 static struct workqueue_struct *qla_tgt_wq;
 static DEFINE_MUTEX(qla_tgt_mutex);
-- 
2.12.0
