From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v4 04/14] tcm_qla2xxx: Convert to target_alloc_session usage
Date: Fri, 11 Mar 2016 06:30:00 +0000
Message-ID: <1457677810-2478-5-git-send-email-nab@daterainc.com>
References: <1457677810-2478-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1457677810-2478-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Mike Christie <mchristi@redhat.com>, Sagi Grimberg <sagig@mellanox.com>, Andy Grover <agrover@redhat.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Juergen Gross <jgross@suse.com>, Andrzej Pietrasiewicz <andrzej.p@samsung.com>, Chris Boot <bootc@bootc.net>, Felipe Balbi <felipe.balbi@linux.intel.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Quinn Tran <quinn.tran@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts existing qla2xxx target mode assignment
of struct qla_tgt_sess related sid + loop_id values to use
a callback via the new target_alloc_session API caller.

Cc: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: Quinn Tran <quinn.tran@qlogic.com>
Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/qla2xxx/qla_target.c  |  8 +---
 drivers/scsi/qla2xxx/qla_target.h  |  2 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 79 +++++++++++++++++++-------------------
 3 files changed, 43 insertions(+), 46 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index ee967be..98d31366 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -879,7 +879,6 @@ static struct qla_tgt_sess *qlt_create_sess(
 	struct qla_hw_data *ha = vha->hw;
 	struct qla_tgt_sess *sess;
 	unsigned long flags;
-	unsigned char be_sid[3];
 
 	/* Check to avoid double sessions */
 	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
@@ -948,17 +947,14 @@ static struct qla_tgt_sess *qlt_create_sess(
 	    "Adding sess %p to tgt %p via ->check_initiator_node_acl()\n",
 	    sess, vha->vha_tgt.qla_tgt);
 
-	be_sid[0] = sess->s_id.b.domain;
-	be_sid[1] = sess->s_id.b.area;
-	be_sid[2] = sess->s_id.b.al_pa;
 	/*
 	 * Determine if this fc_port->port_name is allowed to access
 	 * target mode using explict NodeACLs+MappedLUNs, or using
 	 * TPG demo mode.  If this is successful a target mode FC nexus
 	 * is created.
 	 */
-	if (ha->tgt.tgt_ops->check_initiator_node_acl(vha,
-	    &fcport->port_name[0], sess, &be_sid[0], fcport->loop_id) < 0) {
+	if (ha->tgt.tgt_ops->check_initiator_node_acl(vha, &fcport->port_name[0],
+						      sess)) {
 		kfree(sess);
 		return NULL;
 	}
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index 22a6a76..d857fee 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -731,7 +731,7 @@ struct qla_tgt_func_tmpl {
 	void (*free_session)(struct qla_tgt_sess *);
 
 	int (*check_initiator_node_acl)(struct scsi_qla_host *, unsigned char *,
-					void *, uint8_t *, uint16_t);
+					struct qla_tgt_sess *);
 	void (*update_sess)(struct qla_tgt_sess *, port_id_t, uint16_t, bool);
 	struct qla_tgt_sess *(*find_sess_by_loop_id)(struct scsi_qla_host *,
 						const uint16_t);
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 1808a01..c1461d2 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -1406,6 +1406,39 @@ static void tcm_qla2xxx_free_session(struct qla_tgt_sess *sess)
 	transport_deregister_session(sess->se_sess);
 }
 
+static int tcm_qla2xxx_session_cb(struct se_portal_group *se_tpg,
+				  struct se_session *se_sess, void *p)
+{
+	struct tcm_qla2xxx_tpg *tpg = container_of(se_tpg,
+				struct tcm_qla2xxx_tpg, se_tpg);
+	struct tcm_qla2xxx_lport *lport = tpg->lport;
+	struct qla_hw_data *ha = lport->qla_vha->hw;
+	struct se_node_acl *se_nacl = se_sess->se_node_acl;
+	struct tcm_qla2xxx_nacl *nacl = container_of(se_nacl,
+				struct tcm_qla2xxx_nacl, se_node_acl);
+	struct qla_tgt_sess *qlat_sess = p;
+	uint16_t loop_id = qlat_sess->loop_id;
+	unsigned long flags;
+	unsigned char be_sid[3];
+
+	be_sid[0] = qlat_sess->s_id.b.domain;
+	be_sid[1] = qlat_sess->s_id.b.area;
+	be_sid[2] = qlat_sess->s_id.b.al_pa;
+
+	/*
+	 * And now setup se_nacl and session pointers into HW lport internal
+	 * mappings for fabric S_ID and LOOP_ID.
+	 */
+	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
+	tcm_qla2xxx_set_sess_by_s_id(lport, se_nacl, nacl,
+				     se_sess, qlat_sess, be_sid);
+	tcm_qla2xxx_set_sess_by_loop_id(lport, se_nacl, nacl,
+					se_sess, qlat_sess, loop_id);
+	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
+
+	return 0;
+}
+
 /*
  * Called via qlt_create_sess():ha->qla2x_tmpl->check_initiator_node_acl()
  * to locate struct se_node_acl
@@ -1413,20 +1446,13 @@ static void tcm_qla2xxx_free_session(struct qla_tgt_sess *sess)
 static int tcm_qla2xxx_check_initiator_node_acl(
 	scsi_qla_host_t *vha,
 	unsigned char *fc_wwpn,
-	void *qla_tgt_sess,
-	uint8_t *s_id,
-	uint16_t loop_id)
+	struct qla_tgt_sess *qlat_sess)
 {
 	struct qla_hw_data *ha = vha->hw;
 	struct tcm_qla2xxx_lport *lport;
 	struct tcm_qla2xxx_tpg *tpg;
-	struct tcm_qla2xxx_nacl *nacl;
-	struct se_portal_group *se_tpg;
-	struct se_node_acl *se_nacl;
 	struct se_session *se_sess;
-	struct qla_tgt_sess *sess = qla_tgt_sess;
 	unsigned char port_name[36];
-	unsigned long flags;
 	int num_tags = (ha->cur_fw_xcb_count) ? ha->cur_fw_xcb_count :
 		       TCM_QLA2XXX_DEFAULT_TAGS;
 
@@ -1444,15 +1470,6 @@ static int tcm_qla2xxx_check_initiator_node_acl(
 		pr_err("Unable to lcoate struct tcm_qla2xxx_lport->tpg_1\n");
 		return -EINVAL;
 	}
-	se_tpg = &tpg->se_tpg;
-
-	se_sess = transport_init_session_tags(num_tags,
-					      sizeof(struct qla_tgt_cmd),
-					      TARGET_PROT_ALL);
-	if (IS_ERR(se_sess)) {
-		pr_err("Unable to initialize struct se_session\n");
-		return PTR_ERR(se_sess);
-	}
 	/*
 	 * Format the FCP Initiator port_name into colon seperated values to
 	 * match the format by tcm_qla2xxx explict ConfigFS NodeACLs.
@@ -1463,28 +1480,12 @@ static int tcm_qla2xxx_check_initiator_node_acl(
 	 * Locate our struct se_node_acl either from an explict NodeACL created
 	 * via ConfigFS, or via running in TPG demo mode.
 	 */
-	se_sess->se_node_acl = core_tpg_check_initiator_node_acl(se_tpg,
-					port_name);
-	if (!se_sess->se_node_acl) {
-		transport_free_session(se_sess);
-		return -EINVAL;
-	}
-	se_nacl = se_sess->se_node_acl;
-	nacl = container_of(se_nacl, struct tcm_qla2xxx_nacl, se_node_acl);
-	/*
-	 * And now setup the new se_nacl and session pointers into our HW lport
-	 * mappings for fabric S_ID and LOOP_ID.
-	 */
-	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
-	tcm_qla2xxx_set_sess_by_s_id(lport, se_nacl, nacl, se_sess,
-			qla_tgt_sess, s_id);
-	tcm_qla2xxx_set_sess_by_loop_id(lport, se_nacl, nacl, se_sess,
-			qla_tgt_sess, loop_id);
-	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
-	/*
-	 * Finally register the new FC Nexus with TCM
-	 */
-	transport_register_session(se_nacl->se_tpg, se_nacl, se_sess, sess);
+	se_sess = target_alloc_session(&tpg->se_tpg, num_tags,
+				       sizeof(struct qla_tgt_cmd),
+				       TARGET_PROT_ALL, port_name,
+				       qlat_sess, tcm_qla2xxx_session_cb);
+	if (IS_ERR(se_sess))
+		return PTR_ERR(se_sess);
 
 	return 0;
 }
-- 
1.9.1
