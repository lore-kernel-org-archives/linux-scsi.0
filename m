From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 18/22] qla2xxx: Fix slow mem alloc behind lock
Date: Tue, 6 Dec 2016 12:30:47 -0800
Message-ID: <1481056251-2310-19-git-send-email-himanshu.madhani@cavium.com>
References: <1481056251-2310-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0076.outbound.protection.outlook.com ([104.47.37.76]:34256
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752656AbcLFUbd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 6 Dec 2016 15:31:33 -0500
In-Reply-To: <1481056251-2310-1-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com

From: Quinn Tran <quinn.tran@cavium.com>

In Some instance following stack trace is seen for slow
memory allocation with lock held

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

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_gbl.h    |  1 +
 drivers/scsi/qla2xxx/qla_os.c     | 35 ++++++++++++++++++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_target.c | 11 +++++------
 3 files changed, 40 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 2e28b3f..9489a1c 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -143,6 +143,7 @@ int qla24xx_post_newsess_work(struct scsi_qla_host *, port_id_t *,
 extern int ql_dm_tgt_ex_pct;
 extern struct workqueue_struct *qla_wq;
 extern int ql2xmvasynctoatio;
+extern struct kmem_cache *qla_tgt_plogi_cachep;
 
 
 extern int qla2x00_loop_reset(scsi_qla_host_t *);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 87dc64a..8137238 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4486,8 +4486,9 @@ int qla24xx_post_upd_fcport_work(struct scsi_qla_host *vha, fc_port_t *fcport)
 void qla24xx_create_new_sess(struct scsi_qla_host *vha, struct qla_work_evt *e)
 {
 	unsigned long flags;
-	fc_port_t *fcport =  NULL;
+	fc_port_t *fcport =  NULL, *tfcp;
 	qlt_plogi_ack_t *pla = (qlt_plogi_ack_t *)e->u.new_sess.pla;
+	uint8_t free_fcport = 0;
 
 	spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
 	fcport = qla2x00_find_fcport_by_wwpn(vha, e->u.new_sess.port_name, 1);
@@ -4502,6 +4503,8 @@ void qla24xx_create_new_sess(struct scsi_qla_host *vha, struct qla_work_evt *e)
 			pla->ref_count--;
 		}
 	} else {
+		spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
+
 		fcport = qla2x00_alloc_fcport(vha, GFP_KERNEL);
 		if (fcport) {
 			fcport->d_id = e->u.new_sess.id;
@@ -4511,6 +4514,30 @@ void qla24xx_create_new_sess(struct scsi_qla_host *vha, struct qla_work_evt *e)
 
 			memcpy(&fcport->port_name, e->u.new_sess.port_name,
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
+				   "%s %8phC found existing fcport b4 add. DS %d LS %d\n",
+				   __func__, tfcp->port_name, tfcp->disc_state,
+				   tfcp->fw_login_state);
+
+			free_fcport = 1;
+		} else {
+
 			list_add_tail(&fcport->list, &vha->vp_fcports);
 
 			if (pla) {
@@ -4527,6 +4554,12 @@ void qla24xx_create_new_sess(struct scsi_qla_host *vha, struct qla_work_evt *e)
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
index 54a5337..8a4b506 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -49,13 +49,12 @@
 module_param(qlop_mode, charp, S_IRUGO);
 MODULE_PARM_DESC(qlop_mode,
 	"Determines operating mode. Possible values: "
-	"\"exclusive\" - initiator mode will be enabled on load, "
-	"disabled on enabling target mode and then on disabling target mode "
-	"enabled back; "
+	"\"exclusive\" - Initiator Mode will be enabled on load. "
+	" Target Mode can be activated when ready.  Only one mode can be active at a time; "
 	"\"tgt_mode\" - Target mode only. Initiator mode will never be enabled; "
-	"\"dual_mode\" - Initiator Modes will be enabled. Target Mode can be "
+	"\"dual_mode\" - Initiator Modes will be enabled on load. Target Mode can be "
 	"activated when ready; "
-	"\"ini_mode\" (default) - initiator mode will always stay enabled.");
+	"\"ini_mode\" (default) - Initiator mode will always stay enabled.");
 
 int ql_dm_tgt_ex_pct = 50;
 module_param(ql_dm_tgt_ex_pct, int, S_IRUGO|S_IWUSR);
@@ -133,7 +132,7 @@ static struct fc_port *qlt_create_sess(struct scsi_qla_host *vha,
 /*
  * Global Variables
  */
-static struct kmem_cache *qla_tgt_plogi_cachep;
+struct kmem_cache *qla_tgt_plogi_cachep;
 static struct workqueue_struct *qla_tgt_wq;
 static DEFINE_MUTEX(qla_tgt_mutex);
 LIST_HEAD(qla_tgt_glist);
-- 
1.8.3.1

