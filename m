From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 4/6] tcm: Convert struct se_node_acl->device_list_lock to spin_*lock_irq()
Date: Mon,  6 Sep 2010 14:37:28 -0700
Message-ID: <1283809048-13703-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Konrad Rzeszutek Wilk <konrad@darnok.org>, Boaz Harrosh <bharrosh@panasas.com>, Richard Sharpe <realrichardsharpe@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts the lock/unlock usage of struct se_node_acl->device_list_lock to use
spin_*lock_irq() instead of spin_*lock_bh() so that drivers/target/target_core_device.c:
transport_get_lun_for_cmd() may be called for initial struct se_cmd <-> struct se_lun
association from within interrupt context for HW target mode fabric modules.

This includes converting a number of cases outside of transport_get_lun_for_cmd(),
all of which are called from which process context.  There are two special cases in the
MIBs code at scsi_auth_intr_seq_show() and scsi_att_intr_port_seq_show() that require
dropping an existing lock before calling spin_lock_irq(&se_nacl->device_list_lock).
In order to safetly do this, an atomic count at struct se_node_acl->mib_ref_count and
struct se_session->mib_ref_count has been added, which are checked in
core_tpg_wait_for_mib_ref() and transport_deregister_session() respectively.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_device.c          |   54 +++++++++++++-------------
 drivers/target/target_core_fabric_configfs.c |    8 ++--
 drivers/target/target_core_mib.c             |   28 +++++++++++--
 drivers/target/target_core_tpg.c             |   18 ++++++--
 drivers/target/target_core_transport.c       |    8 ++++
 drivers/target/target_core_ua.c              |   20 +++++-----
 include/target/target_core_base.h            |    4 ++
 include/target/target_core_tpg.h             |    1 +
 8 files changed, 91 insertions(+), 50 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index cf14785..7c357a5 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -197,7 +197,7 @@ extern int __transport_get_lun_for_cmd(
 	unsigned long flags;
 	int read_only = 0;
 
-	spin_lock_bh(&SE_NODE_ACL(se_sess)->device_list_lock);
+	spin_lock_irq(&SE_NODE_ACL(se_sess)->device_list_lock);
 	deve = se_cmd->se_deve =
 			&SE_NODE_ACL(se_sess)->device_list[unpacked_lun];
 	if (deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS) {
@@ -226,7 +226,7 @@ extern int __transport_get_lun_for_cmd(
 		se_cmd->se_cmd_flags |= SCF_SE_LUN_CMD;
 	}
 out:
-	spin_unlock_bh(&SE_NODE_ACL(se_sess)->device_list_lock);
+	spin_unlock_irq(&SE_NODE_ACL(se_sess)->device_list_lock);
 
 	if (!se_lun) {
 		if (read_only) {
@@ -318,7 +318,7 @@ extern int transport_get_lun_for_tmr(
 	struct se_session *se_sess = SE_SESS(se_cmd);
 	struct se_tmr_req *se_tmr = se_cmd->se_tmr_req;
 
-	spin_lock_bh(&SE_NODE_ACL(se_sess)->device_list_lock);
+	spin_lock_irq(&SE_NODE_ACL(se_sess)->device_list_lock);
 	deve = se_cmd->se_deve =
 			&SE_NODE_ACL(se_sess)->device_list[unpacked_lun];
 	if (deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS) {
@@ -329,7 +329,7 @@ extern int transport_get_lun_for_tmr(
 		se_cmd->se_orig_obj_ptr = SE_LUN(se_cmd)->lun_se_dev;
 /*		se_cmd->se_cmd_flags |= SCF_SE_LUN_CMD; */
 	}
-	spin_unlock_bh(&SE_NODE_ACL(se_sess)->device_list_lock);
+	spin_unlock_irq(&SE_NODE_ACL(se_sess)->device_list_lock);
 
 	if (!se_lun) {
 		printk(KERN_INFO "TARGET_CORE[%s]: Detected NON_EXISTENT_LUN"
@@ -371,7 +371,7 @@ struct se_dev_entry *core_get_se_deve_from_rtpi(
 	struct se_portal_group *tpg = nacl->se_tpg;
 	u32 i;
 
-	spin_lock_bh(&nacl->device_list_lock);
+	spin_lock_irq(&nacl->device_list_lock);
 	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
 		deve = &nacl->device_list[i];
 
@@ -397,11 +397,11 @@ struct se_dev_entry *core_get_se_deve_from_rtpi(
 		
 		atomic_inc(&deve->pr_ref_count);
 		smp_mb__after_atomic_inc();
-		spin_unlock_bh(&nacl->device_list_lock);
+		spin_unlock_irq(&nacl->device_list_lock);
 
 		return deve;
 	}
-	spin_unlock_bh(&nacl->device_list_lock);
+	spin_unlock_irq(&nacl->device_list_lock);
 
 	return NULL;
 }
@@ -417,7 +417,7 @@ int core_free_device_list_for_node(
 	if (!nacl->device_list)
 		return 0;
 
-	spin_lock_bh(&nacl->device_list_lock);
+	spin_lock_irq(&nacl->device_list_lock);
 	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
 		deve = &nacl->device_list[i];
 
@@ -432,12 +432,12 @@ int core_free_device_list_for_node(
 		}
 		lun = deve->se_lun;
 
-		spin_unlock_bh(&nacl->device_list_lock);
+		spin_unlock_irq(&nacl->device_list_lock);
 		core_update_device_list_for_node(lun, NULL, deve->mapped_lun,
 			TRANSPORT_LUNFLAGS_NO_ACCESS, nacl, tpg, 0);
-		spin_lock_bh(&nacl->device_list_lock);
+		spin_lock_irq(&nacl->device_list_lock);
 	}
-	spin_unlock_bh(&nacl->device_list_lock);
+	spin_unlock_irq(&nacl->device_list_lock);
 
 	kfree(nacl->device_list);
 	nacl->device_list = NULL;
@@ -449,10 +449,10 @@ void core_dec_lacl_count(struct se_node_acl *se_nacl, struct se_cmd *se_cmd)
 {
 	struct se_dev_entry *deve;
 
-	spin_lock_bh(&se_nacl->device_list_lock);
+	spin_lock_irq(&se_nacl->device_list_lock);
 	deve = &se_nacl->device_list[se_cmd->orig_fe_lun];
 	deve->deve_cmds--;
-	spin_unlock_bh(&se_nacl->device_list_lock);
+	spin_unlock_irq(&se_nacl->device_list_lock);
 
 	return;
 }
@@ -464,7 +464,7 @@ void core_update_device_list_access(
 {
 	struct se_dev_entry *deve;
 
-	spin_lock_bh(&nacl->device_list_lock);
+	spin_lock_irq(&nacl->device_list_lock);
 	deve = &nacl->device_list[mapped_lun];
 	if (lun_access & TRANSPORT_LUNFLAGS_READ_WRITE) {
 		deve->lun_flags &= ~TRANSPORT_LUNFLAGS_READ_ONLY;
@@ -473,7 +473,7 @@ void core_update_device_list_access(
 		deve->lun_flags &= ~TRANSPORT_LUNFLAGS_READ_WRITE;
 		deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_ONLY;
 	}
-	spin_unlock_bh(&nacl->device_list_lock);
+	spin_unlock_irq(&nacl->device_list_lock);
 
 	return;
 }
@@ -507,7 +507,7 @@ int core_update_device_list_for_node(
 		spin_unlock_bh(&port->sep_alua_lock);
 	}
 
-	spin_lock_bh(&nacl->device_list_lock);
+	spin_lock_irq(&nacl->device_list_lock);
 	if (enable) {
 		/*
 		 * Check if the call is handling demo mode -> explict LUN ACL
@@ -545,12 +545,12 @@ int core_update_device_list_for_node(
 		}
 
 		if (trans) {	
-			spin_unlock_bh(&nacl->device_list_lock);
+			spin_unlock_irq(&nacl->device_list_lock);
 			return 0;
 		}
 		deve->creation_time = get_jiffies_64();
 		deve->attach_count++;
-		spin_unlock_bh(&nacl->device_list_lock);
+		spin_unlock_irq(&nacl->device_list_lock);
 
 		spin_lock_bh(&port->sep_alua_lock);
 		list_add_tail(&deve->alua_port_list, &port->sep_alua_list);
@@ -562,10 +562,10 @@ int core_update_device_list_for_node(
 	 * Wait for any in process SPEC_I_PT=1 or REGISTER_AND_MOVE
 	 * PR operation to complete.
 	 */
-	spin_unlock_bh(&nacl->device_list_lock);
+	spin_unlock_irq(&nacl->device_list_lock);
 	while (atomic_read(&deve->pr_ref_count) != 0)
 		msleep(100);
-	spin_lock_bh(&nacl->device_list_lock);
+	spin_lock_irq(&nacl->device_list_lock);
 	/*
 	 * Disable struct se_dev_entry LUN ACL mapping
 	 */
@@ -575,7 +575,7 @@ int core_update_device_list_for_node(
 	deve->lun_flags = 0;
 	deve->creation_time = 0;
 	deve->attach_count--;
-	spin_unlock_bh(&nacl->device_list_lock);
+	spin_unlock_irq(&nacl->device_list_lock);
 
 	core_scsi3_free_pr_reg_from_nacl(lun->lun_se_dev, nacl);
 	return 0;
@@ -595,20 +595,20 @@ void core_clear_lun_from_tpg(struct se_lun *lun, struct se_portal_group *tpg)
 	list_for_each_entry(nacl, &tpg->acl_node_list, acl_list) {
 		spin_unlock_bh(&tpg->acl_node_lock);
 
-		spin_lock_bh(&nacl->device_list_lock);
+		spin_lock_irq(&nacl->device_list_lock);
 		for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
 			deve = &nacl->device_list[i];
 			if (lun != deve->se_lun)
 				continue;
-			spin_unlock_bh(&nacl->device_list_lock);
+			spin_unlock_irq(&nacl->device_list_lock);
 
 			core_update_device_list_for_node(lun, NULL,
 				deve->mapped_lun, TRANSPORT_LUNFLAGS_NO_ACCESS,
 				nacl, tpg, 0);
 
-			spin_lock_bh(&nacl->device_list_lock);
+			spin_lock_irq(&nacl->device_list_lock);
 		}
-		spin_unlock_bh(&nacl->device_list_lock);
+		spin_unlock_irq(&nacl->device_list_lock);
 
 		spin_lock_bh(&tpg->acl_node_lock);
 	}
@@ -810,7 +810,7 @@ int transport_core_report_lun_response(struct se_cmd *se_cmd)
 		goto done;
 	}
 
-	spin_lock_bh(&SE_NODE_ACL(se_sess)->device_list_lock);
+	spin_lock_irq(&SE_NODE_ACL(se_sess)->device_list_lock);
 	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
 		deve = &SE_NODE_ACL(se_sess)->device_list[i];
 		if (!(deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS))
@@ -836,7 +836,7 @@ int transport_core_report_lun_response(struct se_cmd *se_cmd)
 		buf[offset++] = (lun & 0xff);
 		cdb_offset += 8;
 	}
-	spin_unlock_bh(&SE_NODE_ACL(se_sess)->device_list_lock);
+	spin_unlock_irq(&SE_NODE_ACL(se_sess)->device_list_lock);
 
 	/*
 	 * See SPC3 r07, page 159.
diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index e1a64eb..58da51a 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -111,7 +111,7 @@ static int target_fabric_mappedlun_link(
 	 * which be will write protected (READ-ONLY) when
 	 * tpg_1/attrib/demo_mode_write_protect=1
 	 */
-	spin_lock_bh(&lacl->se_lun_nacl->device_list_lock);
+	spin_lock_irq(&lacl->se_lun_nacl->device_list_lock);
 	deve = &lacl->se_lun_nacl->device_list[lacl->mapped_lun];
 	if (deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS)
 		lun_access = deve->lun_flags;
@@ -120,7 +120,7 @@ static int target_fabric_mappedlun_link(
 			(TPG_TFO(se_tpg)->tpg_check_prod_mode_write_protect(
 				se_tpg)) ? TRANSPORT_LUNFLAGS_READ_ONLY :
 					   TRANSPORT_LUNFLAGS_READ_WRITE;
-	spin_unlock_bh(&lacl->se_lun_nacl->device_list_lock);
+	spin_unlock_irq(&lacl->se_lun_nacl->device_list_lock);
 	/*
 	 * Determine the actual mapped LUN value user wants..
 	 *
@@ -162,12 +162,12 @@ static ssize_t target_fabric_mappedlun_show_write_protect(
 	struct se_dev_entry *deve;
 	ssize_t len;
 
-	spin_lock_bh(&se_nacl->device_list_lock);
+	spin_lock_irq(&se_nacl->device_list_lock);
 	deve = &se_nacl->device_list[lacl->mapped_lun];
 	len = sprintf(page, "%d\n",
 			(deve->lun_flags & TRANSPORT_LUNFLAGS_READ_ONLY) ?
 			1 : 0);
-	spin_unlock_bh(&se_nacl->device_list_lock);
+	spin_unlock_irq(&se_nacl->device_list_lock);
 
 	return len;
 }
diff --git a/drivers/target/target_core_mib.c b/drivers/target/target_core_mib.c
index 4453bbd..78abf49 100644
--- a/drivers/target/target_core_mib.c
+++ b/drivers/target/target_core_mib.c
@@ -614,7 +614,12 @@ static int scsi_auth_intr_seq_show(struct seq_file *seq, void *v)
 
 	spin_lock(&se_tpg->acl_node_lock);
 	list_for_each_entry(se_nacl, &se_tpg->acl_node_list, acl_list) {
-		spin_lock(&se_nacl->device_list_lock);
+
+		atomic_inc(&se_nacl->mib_ref_count);
+		smp_mb__after_atomic_inc();
+		spin_unlock(&se_tpg->acl_node_lock);
+
+		spin_lock_irq(&se_nacl->device_list_lock);
 		for (j = 0; j < TRANSPORT_MAX_LUNS_PER_TPG; j++) {
 			deve = &se_nacl->device_list[j];
 			if (!(deve->lun_flags &
@@ -660,7 +665,11 @@ static int scsi_auth_intr_seq_show(struct seq_file *seq, void *v)
 				/* FIXME: scsiAuthIntrRowStatus */
 				"Ready");
 		}
-		spin_unlock(&se_nacl->device_list_lock);
+		spin_unlock_irq(&se_nacl->device_list_lock);
+
+		spin_lock(&se_tpg->acl_node_lock);
+		atomic_dec(&se_nacl->mib_ref_count);
+		smp_mb__after_atomic_dec();
 	}
 	spin_unlock(&se_tpg->acl_node_lock);
 
@@ -736,9 +745,14 @@ static int scsi_att_intr_port_seq_show(struct seq_file *seq, void *v)
 		    (!se_sess->se_node_acl->device_list))
 			continue;
 
+		atomic_inc(&se_sess->mib_ref_count);
+		smp_mb__after_atomic_inc();
 		se_nacl = se_sess->se_node_acl;
+		atomic_inc(&se_nacl->mib_ref_count);
+		smp_mb__after_atomic_inc();
+		spin_unlock(&se_tpg->session_lock);
 
-		spin_lock(&se_nacl->device_list_lock);
+		spin_lock_irq(&se_nacl->device_list_lock);
 		for (j = 0; j < TRANSPORT_MAX_LUNS_PER_TPG; j++) {
 			deve = &se_nacl->device_list[j];
 			if (!(deve->lun_flags &
@@ -776,7 +790,13 @@ static int scsi_att_intr_port_seq_show(struct seq_file *seq, void *v)
 				/* scsiAttIntrPortIdentifier */
 				buf);
 		}
-		spin_unlock(&se_nacl->device_list_lock);
+		spin_unlock_irq(&se_nacl->device_list_lock);
+
+		spin_lock(&se_tpg->session_lock);
+		atomic_dec(&se_nacl->mib_ref_count);
+		smp_mb__after_atomic_dec();
+		atomic_dec(&se_sess->mib_ref_count);
+		smp_mb__after_atomic_dec();
 	}
 	spin_unlock(&se_tpg->session_lock);
 
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 24dceb6..75c3900 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -59,7 +59,7 @@ static void core_clear_initiator_node_from_tpg(
 	struct se_lun *lun;
 	struct se_lun_acl *acl, *acl_tmp;
 
-	spin_lock_bh(&nacl->device_list_lock);
+	spin_lock_irq(&nacl->device_list_lock);
 	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
 		deve = &nacl->device_list[i];
 
@@ -74,7 +74,7 @@ static void core_clear_initiator_node_from_tpg(
 		}
 
 		lun = deve->se_lun;
-		spin_unlock_bh(&nacl->device_list_lock);
+		spin_unlock_irq(&nacl->device_list_lock);
 		core_update_device_list_for_node(lun, NULL, deve->mapped_lun,
 			TRANSPORT_LUNFLAGS_NO_ACCESS, nacl, tpg, 0);
 
@@ -92,17 +92,17 @@ static void core_clear_initiator_node_from_tpg(
 				" mapped_lun: %u\n", nacl->initiatorname,
 				deve->mapped_lun);
 			spin_unlock(&lun->lun_acl_lock);
-			spin_lock_bh(&nacl->device_list_lock);
+			spin_lock_irq(&nacl->device_list_lock);
 			continue;
 		}
 
 		list_del(&acl->lacl_list);
 		spin_unlock(&lun->lun_acl_lock);
 
-		spin_lock_bh(&nacl->device_list_lock);
+		spin_lock_irq(&nacl->device_list_lock);
 		kfree(acl);
 	}
-	spin_unlock_bh(&nacl->device_list_lock);
+	spin_unlock_irq(&nacl->device_list_lock);
 }
 
 /*	__core_tpg_get_initiator_node_acl():
@@ -275,6 +275,7 @@ struct se_node_acl *core_tpg_check_initiator_node_acl(
 	spin_lock_init(&acl->device_list_lock);
 	spin_lock_init(&acl->nacl_sess_lock);
 	atomic_set(&acl->acl_pr_ref_count, 0);
+	atomic_set(&acl->mib_ref_count, 0);
 	acl->queue_depth = TPG_TFO(tpg)->tpg_get_default_depth(tpg);
 	snprintf(acl->initiatorname, TRANSPORT_IQN_LEN, "%s", initiatorname);
 	acl->se_tpg = tpg;
@@ -317,6 +318,12 @@ void core_tpg_wait_for_nacl_pr_ref(struct se_node_acl *nacl)
 		msleep(100);
 }
 
+void core_tpg_wait_for_mib_ref(struct se_node_acl *nacl)
+{
+	while (atomic_read(&nacl->mib_ref_count) != 0)
+		msleep(100);
+}
+
 void core_tpg_clear_object_luns(struct se_portal_group *tpg)
 {
 	int i, ret;
@@ -473,6 +480,7 @@ int core_tpg_del_initiator_node_acl(
 	spin_unlock_bh(&tpg->session_lock);
 
 	core_tpg_wait_for_nacl_pr_ref(acl);
+	core_tpg_wait_for_mib_ref(acl);
 	core_clear_initiator_node_from_tpg(acl, tpg);
 	core_free_device_list_for_node(acl, tpg);
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 602b2d8..56ed466 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -636,6 +636,7 @@ struct se_session *transport_init_session(void)
 	}
 	INIT_LIST_HEAD(&se_sess->sess_list);
 	INIT_LIST_HEAD(&se_sess->sess_acl_list);
+	atomic_set(&se_sess->mib_ref_count, 0);
 
 	return se_sess;
 }
@@ -744,6 +745,12 @@ void transport_deregister_session(struct se_session *se_sess)
 		transport_free_session(se_sess);
 		return;
 	}
+	/*
+	 * Wait for possible reference in drivers/target/target_core_mib.c:
+	 * scsi_att_intr_port_seq_show()
+	 */
+	while (atomic_read(&se_sess->mib_ref_count) != 0)
+		msleep(100);
 
 	spin_lock_bh(&se_tpg->session_lock);
 	list_del(&se_sess->sess_list);
@@ -766,6 +773,7 @@ void transport_deregister_session(struct se_session *se_sess)
 				spin_unlock_bh(&se_tpg->acl_node_lock);
 
 				core_tpg_wait_for_nacl_pr_ref(se_nacl);
+				core_tpg_wait_for_mib_ref(se_nacl);
 				core_free_device_list_for_node(se_nacl, se_tpg);
 				TPG_TFO(se_tpg)->tpg_release_fabric_acl(se_tpg,
 						se_nacl);
diff --git a/drivers/target/target_core_ua.c b/drivers/target/target_core_ua.c
index 2de23bd..a2ef346 100644
--- a/drivers/target/target_core_ua.c
+++ b/drivers/target/target_core_ua.c
@@ -112,7 +112,7 @@ int core_scsi3_ua_allocate(
 	ua->ua_asc = asc;
 	ua->ua_ascq = ascq;
 
-	spin_lock(&nacl->device_list_lock);
+	spin_lock_irq(&nacl->device_list_lock);
 	deve = &nacl->device_list[unpacked_lun];
 
 	spin_lock(&deve->ua_lock);
@@ -122,7 +122,7 @@ int core_scsi3_ua_allocate(
 		 */
 		if ((ua_p->ua_asc == asc) && (ua_p->ua_ascq == ascq)) {
 			spin_unlock(&deve->ua_lock);
-			spin_unlock(&nacl->device_list_lock);
+			spin_unlock_irq(&nacl->device_list_lock);
 			kmem_cache_free(se_ua_cache, ua);
 			return 0;
 		}
@@ -167,7 +167,7 @@ int core_scsi3_ua_allocate(
 			list_add_tail(&ua->ua_nacl_list,
 				&deve->ua_list);
 		spin_unlock(&deve->ua_lock);
-		spin_unlock(&nacl->device_list_lock);
+		spin_unlock_irq(&nacl->device_list_lock);
 
 		atomic_inc(&deve->ua_count);
 		smp_mb__after_atomic_inc();
@@ -175,7 +175,7 @@ int core_scsi3_ua_allocate(
 	}
 	list_add_tail(&ua->ua_nacl_list, &deve->ua_list);
 	spin_unlock(&deve->ua_lock);
-	spin_unlock(&nacl->device_list_lock);
+	spin_unlock_irq(&nacl->device_list_lock);
 
 	printk(KERN_INFO "[%s]: Allocated UNIT ATTENTION, mapped LUN: %u, ASC:"
 		" 0x%02x, ASCQ: 0x%02x\n",
@@ -222,10 +222,10 @@ void core_scsi3_ua_for_check_condition(
 	if (!(nacl))
 		return;
 
-	spin_lock(&nacl->device_list_lock);
+	spin_lock_irq(&nacl->device_list_lock);
 	deve = &nacl->device_list[cmd->orig_fe_lun];
 	if (!(atomic_read(&deve->ua_count))) {
-		spin_unlock(&nacl->device_list_lock);
+		spin_unlock_irq(&nacl->device_list_lock);
 		return;
 	}
 	/*
@@ -262,7 +262,7 @@ void core_scsi3_ua_for_check_condition(
 		smp_mb__after_atomic_dec();
 	}
 	spin_unlock(&deve->ua_lock);
-	spin_unlock(&nacl->device_list_lock);
+	spin_unlock_irq(&nacl->device_list_lock);
 
 	printk(KERN_INFO "[%s]: %s UNIT ATTENTION condition with"
 		" INTLCK_CTRL: %d, mapped LUN: %u, got CDB: 0x%02x"
@@ -291,10 +291,10 @@ int core_scsi3_ua_clear_for_request_sense(
 	if (!(nacl))
 		return -1;
 
-	spin_lock(&nacl->device_list_lock);
+	spin_lock_irq(&nacl->device_list_lock);
 	deve = &nacl->device_list[cmd->orig_fe_lun];
 	if (!(atomic_read(&deve->ua_count))) {
-		spin_unlock(&nacl->device_list_lock);
+		spin_unlock_irq(&nacl->device_list_lock);
 		return -1;
 	}
 	/*
@@ -321,7 +321,7 @@ int core_scsi3_ua_clear_for_request_sense(
 		smp_mb__after_atomic_dec();
 	}
 	spin_unlock(&deve->ua_lock);
-	spin_unlock(&nacl->device_list_lock);
+	spin_unlock_irq(&nacl->device_list_lock);
 
 	printk(KERN_INFO "[%s]: Released UNIT ATTENTION condition, mapped"
 		" LUN: %u, got REQUEST_SENSE reported ASC: 0x%02x,"
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index dbcc04a..c078f5a 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -668,6 +668,8 @@ struct se_node_acl {
 	spinlock_t		stats_lock;
 	/* Used for PR SPEC_I_PT=1 and REGISTER_AND_MOVE */
 	atomic_t		acl_pr_ref_count;
+	/* Used for MIB access */
+	atomic_t		mib_ref_count;
 	struct se_dev_entry	*device_list;
 	struct se_session	*nacl_sess;
 	struct se_portal_group *se_tpg;
@@ -683,6 +685,8 @@ struct se_node_acl {
 } ____cacheline_aligned;
 
 struct se_session {
+	/* Used for MIB access */
+	atomic_t		mib_ref_count;
 	u64			sess_bin_isid;
 	struct se_node_acl	*se_node_acl;
 	struct se_portal_group *se_tpg;
diff --git a/include/target/target_core_tpg.h b/include/target/target_core_tpg.h
index d211fef..90b097b 100644
--- a/include/target/target_core_tpg.h
+++ b/include/target/target_core_tpg.h
@@ -13,6 +13,7 @@ extern struct se_node_acl *core_tpg_check_initiator_node_acl(
 						struct se_portal_group *,
 						unsigned char *);
 extern void core_tpg_wait_for_nacl_pr_ref(struct se_node_acl *);
+extern void core_tpg_wait_for_mib_ref(struct se_node_acl *);
 extern void core_tpg_clear_object_luns(struct se_portal_group *);
 extern struct se_node_acl *core_tpg_add_initiator_node_acl(
 					struct se_portal_group *,
-- 
1.5.6.5
