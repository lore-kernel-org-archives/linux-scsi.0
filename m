From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 06/11] qla2xxx: Use d_id instead of s_id for more clarity.
Date: Fri, 23 Dec 2016 20:23:34 -0800
Message-ID: <1482553419-4117-7-git-send-email-himanshu.madhani@cavium.com>
References: <1482553419-4117-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1482553419-4117-1-git-send-email-himanshu.madhani@cavium.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, bart.vanassche@gmail.com, hch@infradead.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com
List-Id: linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

Updated code with d_id from s_id for better readabilty
and clarity.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_dfs.c     |  6 +++---
 drivers/scsi/qla2xxx/qla_target.c  | 24 ++++++++++++------------
 drivers/scsi/qla2xxx/qla_target.h  |  2 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 32 ++++++++++++++++----------------
 4 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
index 34272fd..46697de 100644
--- a/drivers/scsi/qla2xxx/qla_dfs.c
+++ b/drivers/scsi/qla2xxx/qla_dfs.c
@@ -28,9 +28,9 @@
 		spin_lock_irqsave(&ha->tgt.sess_lock, flags);
 		list_for_each_entry(sess, &tgt->sess_list, sess_list_entry) {
 			seq_printf(s, "%02x:%02x:%02x  %8phC  %d\n",
-					   sess->s_id.b.domain,sess->s_id.b.area,
-					   sess->s_id.b.al_pa,	sess->port_name,
-					   sess->loop_id);
+				sess->d_id.b.domain,sess->d_id.b.area,
+				sess->d_id.b.al_pa,sess->port_name,
+				sess->loop_id);
 		}
 		spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 	}
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 8a10f93..890c53b 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -530,7 +530,7 @@ static void qlt_free_session_done(struct work_struct *work)
 		"%s: se_sess %p / sess %p from port %8phC loop_id %#04x"
 		" s_id %02x:%02x:%02x logout %d keep %d els_logo %d\n",
 		__func__, sess->se_sess, sess, sess->port_name, sess->loop_id,
-		sess->s_id.b.domain, sess->s_id.b.area, sess->s_id.b.al_pa,
+		sess->d_id.b.domain, sess->d_id.b.area, sess->d_id.b.al_pa,
 		sess->logout_on_delete, sess->keep_nport_handle,
 		sess->send_els_logo);
 
@@ -538,7 +538,7 @@ static void qlt_free_session_done(struct work_struct *work)
 
 	if (sess->send_els_logo) {
 		qlt_port_logo_t logo;
-		logo.id = sess->s_id;
+		logo.id = sess->d_id;
 		logo.cmd_count = 0;
 		qlt_send_first_logo(vha, &logo);
 	}
@@ -548,7 +548,7 @@ static void qlt_free_session_done(struct work_struct *work)
 
 		memset(&fcport, 0, sizeof(fcport));
 		fcport.loop_id = sess->loop_id;
-		fcport.d_id = sess->s_id;
+		fcport.d_id = sess->d_id;
 		memcpy(fcport.port_name, sess->port_name, WWN_SIZE);
 		fcport.vha = vha;
 		fcport.tgt_session = sess;
@@ -757,7 +757,7 @@ static void qlt_schedule_sess_for_deletion(struct qla_tgt_sess *sess,
 	    "qla_target(%d): session for port %8phC (loop ID %d s_id %02x:%02x:%02x)"
 	    " scheduled for deletion in %u secs (expires: %lu) immed: %d, logout: %d, gen: %#x\n",
 	    sess->vha->vp_idx, sess->port_name, sess->loop_id,
-	    sess->s_id.b.domain, sess->s_id.b.area, sess->s_id.b.al_pa,
+	    sess->d_id.b.domain, sess->d_id.b.area, sess->d_id.b.al_pa,
 	    dev_loss_tmo, sess->expires, immediate, sess->logout_on_delete,
 	    sess->generation);
 
@@ -892,8 +892,8 @@ static struct qla_tgt_sess *qlt_create_sess(
 			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf005,
 			    "Double sess %p found (s_id %x:%x:%x, "
 			    "loop_id %d), updating to d_id %x:%x:%x, "
-			    "loop_id %d", sess, sess->s_id.b.domain,
-			    sess->s_id.b.al_pa, sess->s_id.b.area,
+			    "loop_id %d", sess, sess->d_id.b.domain,
+			    sess->d_id.b.al_pa, sess->d_id.b.area,
 			    sess->loop_id, fcport->d_id.b.domain,
 			    fcport->d_id.b.al_pa, fcport->d_id.b.area,
 			    fcport->loop_id);
@@ -943,7 +943,7 @@ static struct qla_tgt_sess *qlt_create_sess(
 	}
 	sess->tgt = vha->vha_tgt.qla_tgt;
 	sess->vha = vha;
-	sess->s_id = fcport->d_id;
+	sess->d_id = fcport->d_id;
 	sess->loop_id = fcport->loop_id;
 	sess->local = local;
 	kref_init(&sess->sess_kref);
@@ -974,8 +974,8 @@ static struct qla_tgt_sess *qlt_create_sess(
 	    "qla_target(%d): %ssession for wwn %8phC (loop_id %d, "
 	    "s_id %x:%x:%x, confirmed completion %ssupported) added\n",
 	    vha->vp_idx, local ?  "local " : "", fcport->port_name,
-	    fcport->loop_id, sess->s_id.b.domain, sess->s_id.b.area,
-	    sess->s_id.b.al_pa, sess->conf_compl_supported ?  "" : "not ");
+	    fcport->loop_id, sess->d_id.b.domain, sess->d_id.b.area,
+	    sess->d_id.b.al_pa, sess->conf_compl_supported ?  "" : "not ");
 
 	/*
 	 * Determine if this fc_port->port_name is allowed to access
@@ -4051,7 +4051,7 @@ void qlt_logo_completion_handler(fc_port_t *fcport, int rc)
 		}
 
 		/* find other sess with nport_id collision */
-		if (port_id.b24 == other_sess->s_id.b24) {
+		if (port_id.b24 == other_sess->d_id.b24) {
 			if (loop_id != other_sess->loop_id) {
 				ql_dbg(ql_dbg_tgt_tmr, tgt->vha, 0x1000c,
 				    "Invalidating sess %p loop_id %d wwn %llx.\n",
@@ -4212,7 +4212,7 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 		  *    PLOGI and situation will correct itself.
 		  */
 		sess->keep_nport_handle = ((sess->loop_id == loop_id) &&
-					   (sess->s_id.b24 == port_id.b24));
+					   (sess->d_id.b24 == port_id.b24));
 		qlt_schedule_sess_for_deletion(sess, true);
 		break;
 
@@ -4260,7 +4260,7 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 
 			sess->local = 0;
 			sess->loop_id = loop_id;
-			sess->s_id = port_id;
+			sess->d_id = port_id;
 
 			if (wd3_lo & BIT_7)
 				sess->conf_compl_supported = 1;
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index 2f311b7..64e12fe 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -928,7 +928,7 @@ enum qla_sess_deletion {
  */
 struct qla_tgt_sess {
 	uint16_t loop_id;
-	port_id_t s_id;
+	port_id_t d_id;
 
 	unsigned int conf_compl_supported:1;
 	unsigned int deleted:2;
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 5f6223b3..d9720a9 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -1391,9 +1391,9 @@ static void tcm_qla2xxx_clear_sess_lookup(struct tcm_qla2xxx_lport *lport,
 	struct se_session *se_sess = sess->se_sess;
 	unsigned char be_sid[3];
 
-	be_sid[0] = sess->s_id.b.domain;
-	be_sid[1] = sess->s_id.b.area;
-	be_sid[2] = sess->s_id.b.al_pa;
+	be_sid[0] = sess->d_id.b.domain;
+	be_sid[1] = sess->d_id.b.area;
+	be_sid[2] = sess->d_id.b.al_pa;
 
 	tcm_qla2xxx_set_sess_by_s_id(lport, NULL, nacl, se_sess,
 				sess, be_sid);
@@ -1445,9 +1445,9 @@ static int tcm_qla2xxx_session_cb(struct se_portal_group *se_tpg,
 	unsigned long flags;
 	unsigned char be_sid[3];
 
-	be_sid[0] = qlat_sess->s_id.b.domain;
-	be_sid[1] = qlat_sess->s_id.b.area;
-	be_sid[2] = qlat_sess->s_id.b.al_pa;
+	be_sid[0] = qlat_sess->d_id.b.domain;
+	be_sid[1] = qlat_sess->d_id.b.area;
+	be_sid[2] = qlat_sess->d_id.b.al_pa;
 
 	/*
 	 * And now setup se_nacl and session pointers into HW lport internal
@@ -1527,11 +1527,11 @@ static void tcm_qla2xxx_update_sess(struct qla_tgt_sess *sess, port_id_t s_id,
 	u32 key;
 
 
-	if (sess->loop_id != loop_id || sess->s_id.b24 != s_id.b24)
+	if (sess->loop_id != loop_id || sess->d_id.b24 != s_id.b24)
 		pr_info("Updating session %p from port %8phC loop_id %d -> %d s_id %x:%x:%x -> %x:%x:%x\n",
 		    sess, sess->port_name,
-		    sess->loop_id, loop_id, sess->s_id.b.domain,
-		    sess->s_id.b.area, sess->s_id.b.al_pa, s_id.b.domain,
+		    sess->loop_id, loop_id, sess->d_id.b.domain,
+		    sess->d_id.b.area, sess->d_id.b.al_pa, s_id.b.domain,
 		    s_id.b.area, s_id.b.al_pa);
 
 	if (sess->loop_id != loop_id) {
@@ -1551,18 +1551,18 @@ static void tcm_qla2xxx_update_sess(struct qla_tgt_sess *sess, port_id_t s_id,
 		sess->loop_id = loop_id;
 	}
 
-	if (sess->s_id.b24 != s_id.b24) {
-		key = (((u32) sess->s_id.b.domain << 16) |
-		       ((u32) sess->s_id.b.area   <<  8) |
-		       ((u32) sess->s_id.b.al_pa));
+	if (sess->d_id.b24 != s_id.b24) {
+		key = (((u32) sess->d_id.b.domain << 16) |
+		       ((u32) sess->d_id.b.area   <<  8) |
+		       ((u32) sess->d_id.b.al_pa));
 
 		if (btree_lookup32(&lport->lport_fcport_map, key))
 			WARN(btree_remove32(&lport->lport_fcport_map, key) != se_nacl,
 			     "Found wrong se_nacl when updating s_id %x:%x:%x\n",
-			     sess->s_id.b.domain, sess->s_id.b.area, sess->s_id.b.al_pa);
+			     sess->d_id.b.domain, sess->d_id.b.area, sess->d_id.b.al_pa);
 		else
 			WARN(1, "No lport_fcport_map entry for s_id %x:%x:%x\n",
-			     sess->s_id.b.domain, sess->s_id.b.area, sess->s_id.b.al_pa);
+			     sess->d_id.b.domain, sess->d_id.b.area, sess->d_id.b.al_pa);
 
 		key = (((u32) s_id.b.domain << 16) |
 		       ((u32) s_id.b.area   <<  8) |
@@ -1576,7 +1576,7 @@ static void tcm_qla2xxx_update_sess(struct qla_tgt_sess *sess, port_id_t s_id,
 			btree_insert32(&lport->lport_fcport_map, key, se_nacl, GFP_ATOMIC);
 		}
 
-		sess->s_id = s_id;
+		sess->d_id = s_id;
 		nacl->nport_id = key;
 	}
 
-- 
1.8.3.1
