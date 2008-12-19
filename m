From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [LIO-Target/MIB 13/14]: Convert logic to use generic
	target_core_mod v3.0 code
Date: Fri, 19 Dec 2008 15:37:37 -0800
Message-ID: <1229729857.4560.126.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:27467 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753605AbYLSXiG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Dec 2008 18:38:06 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

>From c15b0b2bb53e5f7e4d7fd659014b86a263d21237 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Fri, 19 Dec 2008 14:43:56 -0800
Subject: [PATCH] [LIO-Target/MIB]: Convert logic to use generic target_core_mod v3.0 code

Convert the iSCSI MIBs code to use se_node_acl_t and se_portal_group_t->tpg_sess_list,
in a number of different MIBs.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/iscsi_target_mib.c |  114 ++++++++++++++++++++---------------
 1 files changed, 65 insertions(+), 49 deletions(-)

diff --git a/drivers/lio-core/iscsi_target_mib.c b/drivers/lio-core/iscsi_target_mib.c
index 1896889..8b600e3 100644
--- a/drivers/lio-core/iscsi_target_mib.c
+++ b/drivers/lio-core/iscsi_target_mib.c
@@ -864,7 +864,7 @@ int do_tgt_auth_check(void *p)
 {
 	iscsi_portal_group_t *tpg = (iscsi_portal_group_t *)p;
 
-	return(tpg->num_node_acls);
+	return(SE_TPG(tpg)->num_node_acls);
 }
 
 static void *tgt_auth_seq_start(struct seq_file *seq, loff_t *pos)
@@ -886,7 +886,7 @@ static int tgt_auth_seq_show(struct seq_file *seq, void *v)
 {
 	iscsi_portal_group_t *tpg;
 	table_iter_t *iterp = (table_iter_t *)seq->private;
-	iscsi_node_acl_t *acl;
+	se_node_acl_t *acl;
 	iscsi_tiqn_t *tiqn;
 
 	if (v == SEQ_START_TOKEN)
@@ -896,13 +896,13 @@ static int tgt_auth_seq_show(struct seq_file *seq, void *v)
 	if (!(tpg = iscsi_get_tpg_from_tpgt(tiqn, iterp->ti_offset, 0)))
 		return(0);
 
-	spin_lock_bh(&tpg->acl_node_lock);
-	for (acl = tpg->acl_node_head; acl; acl = acl->next) {
+	spin_lock_bh(&SE_TPG(tpg)->acl_node_lock);
+	for (acl = SE_TPG(tpg)->acl_node_head; acl; acl = acl->next) {
 		seq_printf(seq,"%u %u %u %s\n",
 			   tiqn->tiqn_index, ISCSI_NODE_INDEX, acl->acl_index, 
 			   acl->initiatorname[0] ? acl->initiatorname : NONE);
 	}
-	spin_unlock_bh(&tpg->acl_node_lock);
+	spin_unlock_bh(&SE_TPG(tpg)->acl_node_lock);
 
 	/* Release the semaphore */
 	iscsi_put_tpg(tpg);
@@ -962,6 +962,7 @@ static int sess_attr_seq_show(struct seq_file *seq, void *v)
 	iscsi_session_t *sess;
 	iscsi_sess_ops_t *sops;
 	iscsi_tiqn_t *tiqn;
+	se_session_t *se_sess;
 	table_iter_t *iterp = (table_iter_t *)seq->private;
 
 	if (v == SEQ_START_TOKEN)
@@ -974,8 +975,9 @@ static int sess_attr_seq_show(struct seq_file *seq, void *v)
 	if (!(tpg = iscsi_get_tpg_from_tpgt(tiqn, iterp->ti_offset, 0)))
 		return(0);
 
-	spin_lock_bh(&tpg->session_lock);
-	for (sess = tpg->session_head; sess; sess = sess->next) {
+	spin_lock_bh(&SE_TPG(tpg)->session_lock);
+	list_for_each_entry(se_sess, &SE_TPG(tpg)->tpg_sess_list, sess_list) {
+		sess = (iscsi_session_t *)se_sess->fabric_sess_ptr;
 		sops = sess->sess_ops;
 
 		seq_printf(seq, "%u %u %u %s %s %s %u ", 
@@ -1005,7 +1007,7 @@ static int sess_attr_seq_show(struct seq_file *seq, void *v)
 		seq_printf(seq, "tgt_alias: %s\n", sops->TargetAlias[0]?
 			   sops->TargetAlias:NONE); 
 	}
-	spin_unlock_bh(&tpg->session_lock);
+	spin_unlock_bh(&SE_TPG(tpg)->session_lock);
 
 	/* Release the semaphore */
 	iscsi_put_tpg(tpg);
@@ -1056,6 +1058,7 @@ static int sess_stats_seq_show(struct seq_file *seq, void *v)
 	iscsi_portal_group_t *tpg;
 	iscsi_session_t *sess;
 	iscsi_tiqn_t *tiqn;
+	se_session_t *se_sess;
 	table_iter_t *iterp = (table_iter_t *)seq->private;
 
 	if (v == SEQ_START_TOKEN)
@@ -1066,8 +1069,10 @@ static int sess_stats_seq_show(struct seq_file *seq, void *v)
 	if (!(tpg = iscsi_get_tpg_from_tpgt(tiqn, iterp->ti_offset, 0)))
 		return(0);
 
-	spin_lock_bh(&tpg->session_lock);
-	for (sess = tpg->session_head; sess; sess = sess->next) {
+	spin_lock_bh(&SE_TPG(tpg)->session_lock);
+	list_for_each_entry(se_sess, &SE_TPG(tpg)->tpg_sess_list, sess_list) {
+		sess = (iscsi_session_t *)se_sess->fabric_sess_ptr;
+
 		spin_lock_bh(&sess->session_stats_lock);
 		seq_printf(seq, "%u %u %u %u %u %llu %llu\n",
 			tiqn->tiqn_index,
@@ -1078,7 +1083,7 @@ static int sess_stats_seq_show(struct seq_file *seq, void *v)
 			(unsigned long long)sess->rx_data_octets);
 		spin_unlock_bh(&sess->session_stats_lock);
 	}
-	spin_unlock_bh(&tpg->session_lock);
+	spin_unlock_bh(&SE_TPG(tpg)->session_lock);
 
 	iscsi_put_tpg(tpg);
 
@@ -1128,6 +1133,7 @@ static int sess_conn_err_stats_seq_show(struct seq_file *seq, void *v)
 	iscsi_portal_group_t *tpg;
 	iscsi_session_t *sess;
 	iscsi_tiqn_t *tiqn;
+	se_session_t *se_sess;
 	table_iter_t *iterp = (table_iter_t *)seq->private;
 
 	if (v == SEQ_START_TOKEN)
@@ -1137,8 +1143,10 @@ static int sess_conn_err_stats_seq_show(struct seq_file *seq, void *v)
 	if (!(tpg = iscsi_get_tpg_from_tpgt(tiqn, iterp->ti_offset, 0)))
 		return(0);
 
-	spin_lock_bh(&tpg->session_lock);
-	for (sess = tpg->session_head; sess; sess = sess->next) {
+	spin_lock_bh(&SE_TPG(tpg)->session_lock);
+	list_for_each_entry(se_sess, &SE_TPG(tpg)->tpg_sess_list, sess_list) {
+		sess = (iscsi_session_t *)se_sess->fabric_sess_ptr;
+
 		spin_lock_bh(&sess->session_stats_lock);
 		seq_printf(seq, "%u %u %u %u %u\n", 
 			   tiqn->tiqn_index,
@@ -1148,7 +1156,7 @@ static int sess_conn_err_stats_seq_show(struct seq_file *seq, void *v)
 			   sess->conn_timeout_errors);
 		spin_unlock_bh(&sess->session_stats_lock);
 	}
-	spin_unlock_bh(&tpg->session_lock);
+	spin_unlock_bh(&SE_TPG(tpg)->session_lock);
 
 	/* Release the semaphore */
 	iscsi_put_tpg(tpg);
@@ -1202,6 +1210,7 @@ static int conn_attr_seq_show(struct seq_file *seq, void *v)
 	iscsi_tiqn_t *tiqn;
 	iscsi_conn_t *conn;
 	iscsi_conn_ops_t *conn_ops;
+	se_session_t *se_sess;
 	table_iter_t *iterp = (table_iter_t *)seq->private;
 	char state_str[16]; 
 	char proto_str[16]; 
@@ -1216,8 +1225,9 @@ static int conn_attr_seq_show(struct seq_file *seq, void *v)
 	if (!(tpg = iscsi_get_tpg_from_tpgt(tiqn, iterp->ti_offset, 0)))
 		return(0);
 
-	spin_lock_bh(&tpg->session_lock);
-	for (sess = tpg->session_head; sess; sess = sess->next) {
+	spin_lock_bh(&SE_TPG(tpg)->session_lock);
+	list_for_each_entry(se_sess, &SE_TPG(tpg)->tpg_sess_list, sess_list) {
+		sess = (iscsi_session_t *)se_sess->fabric_sess_ptr;
 
 		spin_lock(&sess->conn_lock);
 		for (conn = sess->conn_head; conn; conn = conn->next) {
@@ -1272,7 +1282,7 @@ static int conn_attr_seq_show(struct seq_file *seq, void *v)
 		}
 		spin_unlock(&sess->conn_lock);
 	}
-	spin_unlock_bh(&tpg->session_lock);
+	spin_unlock_bh(&SE_TPG(tpg)->session_lock);
 
 	iscsi_put_tpg(tpg);
 
@@ -1325,9 +1335,9 @@ extern int lio_scsi_auth_intr_seq_show(struct seq_file *seq, void *v)
 {
 	iscsi_portal_group_t *tpg;
 	table_iter_t *iterp = (table_iter_t *)seq->private;
-	iscsi_node_acl_t *acl;
 	se_dev_entry_t *deve;
 	se_lun_t *lun;
+	se_node_acl_t *se_nacl;
 	iscsi_tiqn_t *tiqn;
 	int j; 
 
@@ -1336,28 +1346,28 @@ extern int lio_scsi_auth_intr_seq_show(struct seq_file *seq, void *v)
 	if (!(tpg = iscsi_get_tpg_from_tpgt(tiqn, iterp->ti_offset, 0)))
 		return(0);
 
-	spin_lock_bh(&tpg->acl_node_lock);
-	for (acl = tpg->acl_node_head; acl; acl = acl->next) {
-		spin_lock_bh(&acl->device_list_lock);
-		for (j = 0; j < ISCSI_MAX_LUNS_PER_TPG; j++) {
-			deve = &acl->device_list[j];
-			if (!(deve->lun_flags & ISCSI_LUNFLAGS_INITIATOR_ACCESS) ||
-			     (!deve->iscsi_lun))
+	spin_lock_bh(&SE_TPG(tpg)->acl_node_lock);
+	for (se_nacl = SE_TPG(tpg)->acl_node_head; se_nacl; se_nacl = se_nacl->next) {
+		spin_lock_bh(&se_nacl->device_list_lock);
+		for (j = 0; j < TRANSPORT_MAX_LUNS_PER_TPG; j++) {
+			deve = &se_nacl->device_list[j];
+			if (!(deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS) ||
+			     (!deve->se_lun))
 				continue;
 
-			lun = deve->iscsi_lun;
-			if ((lun->lun_type != ISCSI_LUN_TYPE_DEVICE) ||
-			    (!lun->iscsi_dev))
+			lun = deve->se_lun;
+			if ((lun->lun_type != TRANSPORT_LUN_TYPE_DEVICE) ||
+			    (!lun->se_dev))
 				continue;
 
 			seq_printf(seq,"%u %u %u %u %u %s %u %u %u %u %u %u %u %s\n",
 				tiqn->tiqn_index, /* scsiInstIndex */
-				lun->iscsi_dev->dev_index, /* scsiDeviceIndex */
+				lun->se_dev->dev_index, /* scsiDeviceIndex */
 				tpg->tpgt, /* scsiAuthIntrTgtPortIndex */
-				acl->acl_index, /* scsiAuthIntrIndex */
+				se_nacl->acl_index, /* scsiAuthIntrIndex */
 				1, /* scsiAuthIntrDevOrPort */
-				acl->initiatorname[0] ?
-					acl->initiatorname:NONE, /* scsiAuthIntrName */
+				se_nacl->initiatorname[0] ?
+					se_nacl->initiatorname:NONE, /* scsiAuthIntrName */
 				0, /* FIXME: scsiAuthIntrLunMapIndex */
 				deve->attach_count,  /* scsiAuthIntrAttachedTimes */
 				deve->total_cmds, /* scsiAuthIntrOutCommands */
@@ -1367,9 +1377,9 @@ extern int lio_scsi_auth_intr_seq_show(struct seq_file *seq, void *v)
 				(u32)(((u32)deve->creation_time - INITIAL_JIFFIES)*100/HZ), /* scsiAuthIntrLastCreation */
 				"Ready"); /* FIXME: scsiAuthIntrRowStatus */
 		}
-		spin_unlock_bh(&acl->device_list_lock);
+		spin_unlock_bh(&se_nacl->device_list_lock);
 	}
-	spin_unlock_bh(&tpg->acl_node_lock);
+	spin_unlock_bh(&SE_TPG(tpg)->acl_node_lock);
 
 	/* Release the semaphore */
 	iscsi_put_tpg(tpg);
@@ -1407,6 +1417,8 @@ extern int lio_scsi_att_intr_port_seq_show(struct seq_file *seq, void *v)
 	table_iter_t *iterp = (table_iter_t *)seq->private;
 	se_dev_entry_t *deve;
 	se_lun_t *lun;
+	se_node_acl_t *se_nacl;
+	se_session_t *se_sess;
 	iscsi_tiqn_t *tiqn;
 	int j;
 
@@ -1415,42 +1427,46 @@ extern int lio_scsi_att_intr_port_seq_show(struct seq_file *seq, void *v)
 	if (!(tpg = iscsi_get_tpg_from_tpgt(tiqn, iterp->ti_offset, 0)))
 		return(0);
 
-	spin_lock_bh(&tpg->session_lock);
-	for (sess = tpg->session_head; sess; sess = sess->next) {
+	spin_lock_bh(&SE_TPG(tpg)->session_lock);
+	list_for_each_entry(se_sess, &SE_TPG(tpg)->tpg_sess_list, sess_list) {
+		sess = (iscsi_session_t *)se_sess->fabric_sess_ptr;
 		sops = sess->sess_ops;
+
 		if ((sess->session_state != TARG_SESS_STATE_LOGGED_IN) ||
-		    (!sess->node_acl) || (!sess->node_acl->device_list)) {
+		    (!se_sess->se_node_acl) ||
+		    (!se_sess->se_node_acl->device_list)) {
 			continue;
 		}
+		se_nacl = se_sess->se_node_acl;
 
-		spin_lock_bh(&sess->node_acl->device_list_lock);
-		for (j = 0; j < ISCSI_MAX_LUNS_PER_TPG; j++) {
-			deve = &sess->node_acl->device_list[j];
-			if (!(deve->lun_flags & ISCSI_LUNFLAGS_INITIATOR_ACCESS)
-			    || (!deve->iscsi_lun))
+		spin_lock_bh(&se_nacl->device_list_lock);
+		for (j = 0; j < TRANSPORT_MAX_LUNS_PER_TPG; j++) {
+			deve = &se_nacl->device_list[j];
+			if (!(deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS)
+			    || (!deve->se_lun))
 				continue;
 
-			lun = deve->iscsi_lun;
-			if ((lun->lun_type != ISCSI_LUN_TYPE_DEVICE) ||
-			    (!lun->iscsi_dev))
+			lun = deve->se_lun;
+			if ((lun->lun_type != TRANSPORT_LUN_TYPE_DEVICE) ||
+			    (!lun->se_dev))
 				continue;
 
 			seq_printf(seq,"%u %u %u %u %u "
 				   "%s+i+%02X%02X%02X%02X%02X%02X\n",
 				   tiqn->tiqn_index, /* scsiInstIndex */
-				   lun->iscsi_dev->dev_index, /* scsiDeviceIndex */
+				   lun->se_dev->dev_index, /* scsiDeviceIndex */
 				   tpg->tpgt, /* scsiPortIndex */
 				   sess->session_index,  /* scsiAttIntrPortIndex */
-				   sess->node_acl->acl_index, /* scsiAttIntrPortAuthIntrIdx */
+				   se_nacl->acl_index, /* scsiAttIntrPortAuthIntrIdx */
 				   sops->InitiatorName[0]?
 					  sops->InitiatorName:NONE, /* scsiAttIntrPortName */
 				   sess->isid[0], sess->isid[1], sess->isid[2],
 				   sess->isid[3], sess->isid[4], sess->isid[5]);
 			   					/* scsiAttIntrPortIdentifier */
 		}
-		spin_unlock_bh(&sess->node_acl->device_list_lock);
+		spin_unlock_bh(&se_nacl->device_list_lock);
 	}
-	spin_unlock_bh(&tpg->session_lock);
+	spin_unlock_bh(&SE_TPG(tpg)->session_lock);
 
 	/* Release the semaphore */
 	iscsi_put_tpg(tpg);
-- 
1.5.4.1



