From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v3 03/10] target/pr: Change alloc_registration to avoid pr_reg_tg_pt_lun
Date: Tue, 26 May 2015 06:25:23 +0000
Message-ID: <1432621530-24171-4-git-send-email-nab@daterainc.com>
References: <1432621530-24171-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:36074 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbbEZGut (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 May 2015 02:50:49 -0400
Received: by obbea2 with SMTP id ea2so67249100obb.3
        for <linux-scsi@vger.kernel.org>; Mon, 25 May 2015 23:50:49 -0700 (PDT)
In-Reply-To: <1432621530-24171-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch changes __core_scsi3_do_alloc_registration() code to
drop pr_reg->pr_reg_tg_pt_lun pointer usage in favor of a new
pr_reg RPTI + existing target_lun.

It also includes changes to REGISTER, REGISTER_AND_MOVE and APTPL
feature bit codepaths.

Cc: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_configfs.c |   6 +-
 drivers/target/target_core_pr.c       | 121 ++++++++++++++++------------------
 include/target/target_core_base.h     |   4 +-
 3 files changed, 61 insertions(+), 70 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 2768221..67d6d5f 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -817,7 +817,6 @@ static ssize_t target_core_dev_pr_show_attr_res_pr_holder_tg_port(
 		struct se_device *dev, char *page)
 {
 	struct se_node_acl *se_nacl;
-	struct se_lun *lun;
 	struct se_portal_group *se_tpg;
 	struct t10_pr_registration *pr_reg;
 	const struct target_core_fabric_ops *tfo;
@@ -832,7 +831,6 @@ static ssize_t target_core_dev_pr_show_attr_res_pr_holder_tg_port(
 
 	se_nacl = pr_reg->pr_reg_nacl;
 	se_tpg = se_nacl->se_tpg;
-	lun = pr_reg->pr_reg_tg_pt_lun;
 	tfo = se_tpg->se_tpg_tfo;
 
 	len += sprintf(page+len, "SPC-3 Reservation: %s"
@@ -840,9 +838,9 @@ static ssize_t target_core_dev_pr_show_attr_res_pr_holder_tg_port(
 		tfo->tpg_get_wwn(se_tpg));
 	len += sprintf(page+len, "SPC-3 Reservation: Relative Port"
 		" Identifier Tag: %hu %s Portal Group Tag: %hu"
-		" %s Logical Unit: %u\n", lun->lun_sep->sep_rtpi,
+		" %s Logical Unit: %u\n", pr_reg->tg_pt_sep_rtpi,
 		tfo->get_fabric_name(), tfo->tpg_get_tag(se_tpg),
-		tfo->get_fabric_name(), lun->unpacked_lun);
+		tfo->get_fabric_name(), pr_reg->pr_aptpl_target_lun);
 
 out_unlock:
 	spin_unlock(&dev->dev_reservation_lock);
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 0b850bb..a3859ef 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -44,11 +44,10 @@
  * Used for Specify Initiator Ports Capable Bit (SPEC_I_PT)
  */
 struct pr_transport_id_holder {
-	int dest_local_nexus;
 	struct t10_pr_registration *dest_pr_reg;
 	struct se_portal_group *dest_tpg;
 	struct se_node_acl *dest_node_acl;
-	struct se_dev_entry __rcu *dest_se_deve;
+	struct se_dev_entry *dest_se_deve;
 	struct list_head dest_list;
 };
 
@@ -625,7 +624,9 @@ static u32 core_scsi3_pr_generation(struct se_device *dev)
 static struct t10_pr_registration *__core_scsi3_do_alloc_registration(
 	struct se_device *dev,
 	struct se_node_acl *nacl,
+	struct se_lun *lun,
 	struct se_dev_entry *deve,
+	u32 mapped_lun,
 	unsigned char *isid,
 	u64 sa_res_key,
 	int all_tg_pt,
@@ -647,12 +648,12 @@ static struct t10_pr_registration *__core_scsi3_do_alloc_registration(
 	atomic_set(&pr_reg->pr_res_holders, 0);
 	pr_reg->pr_reg_nacl = nacl;
 	pr_reg->pr_reg_deve = deve;
-	pr_reg->pr_res_mapped_lun = deve->mapped_lun;
-	pr_reg->pr_aptpl_target_lun = deve->se_lun->unpacked_lun;
+	pr_reg->pr_res_mapped_lun = mapped_lun;
+	pr_reg->pr_aptpl_target_lun = lun->unpacked_lun;
+	pr_reg->tg_pt_sep_rtpi = lun->lun_sep->sep_rtpi;
 	pr_reg->pr_res_key = sa_res_key;
 	pr_reg->pr_reg_all_tg_pt = all_tg_pt;
 	pr_reg->pr_reg_aptpl = aptpl;
-	pr_reg->pr_reg_tg_pt_lun = deve->se_lun;
 	/*
 	 * If an ISID value for this SCSI Initiator Port exists,
 	 * save it to the registration now.
@@ -676,7 +677,9 @@ static void core_scsi3_lunacl_undepend_item(struct se_dev_entry *);
 static struct t10_pr_registration *__core_scsi3_alloc_registration(
 	struct se_device *dev,
 	struct se_node_acl *nacl,
+	struct se_lun *lun,
 	struct se_dev_entry *deve,
+	u32 mapped_lun,
 	unsigned char *isid,
 	u64 sa_res_key,
 	int all_tg_pt,
@@ -684,6 +687,7 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 {
 	struct se_dev_entry *deve_tmp;
 	struct se_node_acl *nacl_tmp;
+	struct se_lun_acl *lacl_tmp;
 	struct se_port *port, *port_tmp;
 	const struct target_core_fabric_ops *tfo = nacl->se_tpg->se_tpg_tfo;
 	struct t10_pr_registration *pr_reg, *pr_reg_atp, *pr_reg_tmp, *pr_reg_tmp_safe;
@@ -692,8 +696,9 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 	 * Create a registration for the I_T Nexus upon which the
 	 * PROUT REGISTER was received.
 	 */
-	pr_reg = __core_scsi3_do_alloc_registration(dev, nacl, deve, isid,
-			sa_res_key, all_tg_pt, aptpl);
+	pr_reg = __core_scsi3_do_alloc_registration(dev, nacl, lun, deve, mapped_lun,
+						    isid, sa_res_key, all_tg_pt,
+						    aptpl);
 	if (!pr_reg)
 		return NULL;
 	/*
@@ -721,7 +726,8 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 			if (!deve_tmp->se_lun_acl)
 				continue;
 
-			nacl_tmp = deve_tmp->se_lun_acl->se_lun_nacl;
+			lacl_tmp = lockless_dereference(deve_tmp->se_lun_acl);
+			nacl_tmp = lacl_tmp->se_lun_nacl;
 			/*
 			 * Skip the matching struct se_node_acl that is allocated
 			 * above..
@@ -765,8 +771,10 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 			 * __core_scsi3_add_registration()
 			 */
 			pr_reg_atp = __core_scsi3_do_alloc_registration(dev,
-						nacl_tmp, deve_tmp, NULL,
-						sa_res_key, all_tg_pt, aptpl);
+						nacl_tmp,
+						lockless_dereference(deve_tmp->se_lun),
+						deve_tmp, deve_tmp->mapped_lun,
+						NULL, sa_res_key, all_tg_pt, aptpl);
 			if (!pr_reg_atp) {
 				atomic_dec_mb(&port->sep_tg_pt_ref_cnt);
 				core_scsi3_lunacl_undepend_item(deve_tmp);
@@ -835,7 +843,6 @@ int core_scsi3_alloc_aptpl_registration(
 	pr_reg->pr_res_key = sa_res_key;
 	pr_reg->pr_reg_all_tg_pt = all_tg_pt;
 	pr_reg->pr_reg_aptpl = 1;
-	pr_reg->pr_reg_tg_pt_lun = NULL;
 	pr_reg->pr_res_scope = 0; /* Always LUN_SCOPE */
 	pr_reg->pr_res_type = type;
 	/*
@@ -935,7 +942,7 @@ static int __core_scsi3_check_aptpl_registration(
 		     (pr_reg->pr_aptpl_target_lun == target_lun)) {
 
 			pr_reg->pr_reg_nacl = nacl;
-			pr_reg->pr_reg_tg_pt_lun = lun;
+			pr_reg->tg_pt_sep_rtpi = lun->lun_sep->sep_rtpi;
 
 			list_del(&pr_reg->pr_reg_aptpl_list);
 			spin_unlock(&pr_tmpl->aptpl_reg_lock);
@@ -1090,7 +1097,9 @@ static void __core_scsi3_add_registration(
 static int core_scsi3_alloc_registration(
 	struct se_device *dev,
 	struct se_node_acl *nacl,
+	struct se_lun *lun,
 	struct se_dev_entry *deve,
+	u32 mapped_lun,
 	unsigned char *isid,
 	u64 sa_res_key,
 	int all_tg_pt,
@@ -1100,8 +1109,9 @@ static int core_scsi3_alloc_registration(
 {
 	struct t10_pr_registration *pr_reg;
 
-	pr_reg = __core_scsi3_alloc_registration(dev, nacl, deve, isid,
-			sa_res_key, all_tg_pt, aptpl);
+	pr_reg = __core_scsi3_alloc_registration(dev, nacl, lun, deve, mapped_lun,
+						 isid, sa_res_key, all_tg_pt,
+						 aptpl);
 	if (!pr_reg)
 		return -EPERM;
 
@@ -1411,12 +1421,13 @@ static void core_scsi3_nodeacl_undepend_item(struct se_node_acl *nacl)
 
 static int core_scsi3_lunacl_depend_item(struct se_dev_entry *se_deve)
 {
-	struct se_lun_acl *lun_acl = se_deve->se_lun_acl;
+	struct se_lun_acl *lun_acl;
 	struct se_node_acl *nacl;
 	struct se_portal_group *tpg;
 	/*
 	 * For nacl->dynamic_node_acl=1
 	 */
+	lun_acl = lockless_dereference(se_deve->se_lun_acl);
 	if (!lun_acl)
 		return 0;
 
@@ -1434,7 +1445,7 @@ static void core_scsi3_lunacl_undepend_item(struct se_dev_entry *se_deve)
 	/*
 	 * For nacl->dynamic_node_acl=1
 	 */
-	lun_acl = se_deve->se_lun_acl;
+	lun_acl = lockless_dereference(se_deve->se_lun_acl);
 	if (!lun_acl) {
 		kref_put(&se_deve->pr_kref, target_pr_kref_release);
 		return;
@@ -1450,7 +1461,6 @@ static sense_reason_t
 core_scsi3_decode_spec_i_port(
 	struct se_cmd *cmd,
 	struct se_portal_group *tpg,
-	struct se_dev_entry *local_se_deve,
 	unsigned char *l_isid,
 	u64 sa_res_key,
 	int all_tg_pt,
@@ -1461,7 +1471,7 @@ core_scsi3_decode_spec_i_port(
 	struct se_portal_group *dest_tpg = NULL, *tmp_tpg;
 	struct se_session *se_sess = cmd->se_sess;
 	struct se_node_acl *dest_node_acl = NULL;
-	struct se_dev_entry __rcu *dest_se_deve = NULL;
+	struct se_dev_entry *dest_se_deve = NULL;
 	struct t10_pr_registration *dest_pr_reg, *local_pr_reg, *pr_reg_e;
 	struct t10_pr_registration *pr_reg_tmp, *pr_reg_tmp_safe;
 	LIST_HEAD(tid_dest_list);
@@ -1471,14 +1481,12 @@ core_scsi3_decode_spec_i_port(
 	char *iport_ptr = NULL, i_buf[PR_REG_ISID_ID_LEN];
 	sense_reason_t ret;
 	u32 tpdl, tid_len = 0;
-	int dest_local_nexus;
 	u32 dest_rtpi = 0;
 
 	/*
 	 * Allocate a struct pr_transport_id_holder and setup the
-	 * local_node_acl and local_se_deve pointers and add to
-	 * struct list_head tid_dest_list for add registration
-	 * processing in the loop of tid_dest_list below.
+	 * local_node_acl pointer and add to struct list_head tid_dest_list
+	 * for add registration processing in the loop of tid_dest_list below.
 	 */
 	tidh_new = kzalloc(sizeof(struct pr_transport_id_holder), GFP_KERNEL);
 	if (!tidh_new) {
@@ -1490,20 +1498,20 @@ core_scsi3_decode_spec_i_port(
 	tidh_new->dest_node_acl = se_sess->se_node_acl;
 
 	local_pr_reg = __core_scsi3_alloc_registration(cmd->se_dev,
-				se_sess->se_node_acl, local_se_deve, l_isid,
+				se_sess->se_node_acl, cmd->se_lun,
+				NULL, cmd->orig_fe_lun, l_isid,
 				sa_res_key, all_tg_pt, aptpl);
 	if (!local_pr_reg) {
 		kfree(tidh_new);
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
-	rcu_assign_pointer(tidh_new->dest_se_deve, local_se_deve);
 	tidh_new->dest_pr_reg = local_pr_reg;
 	/*
 	 * The local I_T nexus does not hold any configfs dependances,
-	 * so we set tid_h->dest_local_nexus=1 to prevent the
+	 * so we set tidh_new->dest_se_deve to NULL to prevent the
 	 * configfs_undepend_item() calls in the tid_dest_list loops below.
 	 */
-	tidh_new->dest_local_nexus = 1;
+	tidh_new->dest_se_deve = NULL;
 	list_add_tail(&tidh_new->dest_list, &tid_dest_list);
 
 	if (cmd->data_length < 28) {
@@ -1721,8 +1729,10 @@ core_scsi3_decode_spec_i_port(
 		 * 2nd loop which will never fail.
 		 */
 		dest_pr_reg = __core_scsi3_alloc_registration(cmd->se_dev,
-				dest_node_acl, dest_se_deve, iport_ptr,
-				sa_res_key, all_tg_pt, aptpl);
+					dest_node_acl,
+					lockless_dereference(dest_se_deve->se_lun),
+					dest_se_deve, dest_se_deve->mapped_lun,
+					iport_ptr, sa_res_key, all_tg_pt, aptpl);
 		if (!dest_pr_reg) {
 			core_scsi3_lunacl_undepend_item(dest_se_deve);
 			core_scsi3_nodeacl_undepend_item(dest_node_acl);
@@ -1760,7 +1770,6 @@ core_scsi3_decode_spec_i_port(
 		dest_node_acl = tidh->dest_node_acl;
 		dest_se_deve = tidh->dest_se_deve;
 		dest_pr_reg = tidh->dest_pr_reg;
-		dest_local_nexus = tidh->dest_local_nexus;
 
 		list_del(&tidh->dest_list);
 		kfree(tidh);
@@ -1774,9 +1783,10 @@ core_scsi3_decode_spec_i_port(
 		pr_debug("SPC-3 PR [%s] SPEC_I_PT: Successfully"
 			" registered Transport ID for Node: %s%s Mapped LUN:"
 			" %u\n", dest_tpg->se_tpg_tfo->get_fabric_name(),
-			dest_node_acl->initiatorname, i_buf, dest_se_deve->mapped_lun);
+			dest_node_acl->initiatorname, i_buf, (dest_se_deve) ?
+			dest_se_deve->mapped_lun : 0);
 
-		if (dest_local_nexus)
+		if (!dest_se_deve)
 			continue;
 
 		core_scsi3_lunacl_undepend_item(dest_se_deve);
@@ -1797,7 +1807,6 @@ out:
 		dest_node_acl = tidh->dest_node_acl;
 		dest_se_deve = tidh->dest_se_deve;
 		dest_pr_reg = tidh->dest_pr_reg;
-		dest_local_nexus = tidh->dest_local_nexus;
 
 		list_del(&tidh->dest_list);
 		kfree(tidh);
@@ -1815,7 +1824,7 @@ out:
 
 		kmem_cache_free(t10_pr_reg_cache, dest_pr_reg);
 
-		if (dest_local_nexus)
+		if (!dest_se_deve)
 			continue;
 
 		core_scsi3_lunacl_undepend_item(dest_se_deve);
@@ -1830,7 +1839,6 @@ static int core_scsi3_update_aptpl_buf(
 	unsigned char *buf,
 	u32 pr_aptpl_buf_len)
 {
-	struct se_lun *lun;
 	struct se_portal_group *tpg;
 	struct t10_pr_registration *pr_reg;
 	unsigned char tmp[512], isid_buf[32];
@@ -1849,7 +1857,6 @@ static int core_scsi3_update_aptpl_buf(
 		tmp[0] = '\0';
 		isid_buf[0] = '\0';
 		tpg = pr_reg->pr_reg_nacl->se_tpg;
-		lun = pr_reg->pr_reg_tg_pt_lun;
 		/*
 		 * Write out any ISID value to APTPL metadata that was included
 		 * in the original registration.
@@ -1901,7 +1908,8 @@ static int core_scsi3_update_aptpl_buf(
 			" %d\n", tpg->se_tpg_tfo->get_fabric_name(),
 			tpg->se_tpg_tfo->tpg_get_wwn(tpg),
 			tpg->se_tpg_tfo->tpg_get_tag(tpg),
-			lun->lun_sep->sep_rtpi, lun->unpacked_lun, reg_count);
+			pr_reg->tg_pt_sep_rtpi, pr_reg->pr_aptpl_target_lun,
+			reg_count);
 
 		if ((len + strlen(tmp) >= pr_aptpl_buf_len)) {
 			pr_err("Unable to update renaming APTPL metadata,"
@@ -2011,9 +2019,7 @@ core_scsi3_emulate_pro_register(struct se_cmd *cmd, u64 res_key, u64 sa_res_key,
 		bool aptpl, bool all_tg_pt, bool spec_i_pt, enum register_type register_type)
 {
 	struct se_session *se_sess = cmd->se_sess;
-	struct se_node_acl *nacl = se_sess->se_node_acl;
 	struct se_device *dev = cmd->se_dev;
-	struct se_dev_entry *se_deve;
 	struct se_lun *se_lun = cmd->se_lun;
 	struct se_portal_group *se_tpg;
 	struct t10_pr_registration *pr_reg, *pr_reg_p, *pr_reg_tmp;
@@ -2028,14 +2034,6 @@ core_scsi3_emulate_pro_register(struct se_cmd *cmd, u64 res_key, u64 sa_res_key,
 	}
 	se_tpg = se_sess->se_tpg;
 
-	rcu_read_lock();
-	se_deve = target_nacl_find_deve(nacl, cmd->orig_fe_lun);
-	if (!se_deve) {
-		pr_err("Unable to locate se_deve for PRO-REGISTER\n");
-		rcu_read_unlock();
-		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
-	}
-
 	if (se_tpg->se_tpg_tfo->sess_get_initiator_sid) {
 		memset(&isid_buf[0], 0, PR_REG_ISID_LEN);
 		se_tpg->se_tpg_tfo->sess_get_initiator_sid(se_sess, &isid_buf[0],
@@ -2050,16 +2048,14 @@ core_scsi3_emulate_pro_register(struct se_cmd *cmd, u64 res_key, u64 sa_res_key,
 		if (res_key) {
 			pr_warn("SPC-3 PR: Reservation Key non-zero"
 				" for SA REGISTER, returning CONFLICT\n");
-			rcu_read_unlock();
 			return TCM_RESERVATION_CONFLICT;
 		}
 		/*
 		 * Do nothing but return GOOD status.
 		 */
-		if (!sa_res_key) {
-			rcu_read_unlock();
+		if (!sa_res_key)
 			return 0;
-		}
+
 		if (!spec_i_pt) {
 			/*
 			 * Perform the Service Action REGISTER on the Initiator
@@ -2067,12 +2063,12 @@ core_scsi3_emulate_pro_register(struct se_cmd *cmd, u64 res_key, u64 sa_res_key,
 			 * Logical Unit of the SCSI device server.
 			 */
 			if (core_scsi3_alloc_registration(cmd->se_dev,
-					se_sess->se_node_acl, se_deve, isid_ptr,
+					se_sess->se_node_acl, cmd->se_lun,
+					NULL, cmd->orig_fe_lun, isid_ptr,
 					sa_res_key, all_tg_pt, aptpl,
 					register_type, 0)) {
 				pr_err("Unable to allocate"
 					" struct t10_pr_registration\n");
-				rcu_read_unlock();
 				return TCM_INVALID_PARAMETER_LIST;
 			}
 		} else {
@@ -2084,17 +2080,13 @@ core_scsi3_emulate_pro_register(struct se_cmd *cmd, u64 res_key, u64 sa_res_key,
 			 * logic from of core_scsi3_alloc_registration() for
 			 * each TransportID provided SCSI Initiator Port/Device
 			 */
-			ret = core_scsi3_decode_spec_i_port(cmd, se_tpg, se_deve,
+			ret = core_scsi3_decode_spec_i_port(cmd, se_tpg,
 					isid_ptr, sa_res_key, all_tg_pt, aptpl);
-			if (ret != 0) {
-				rcu_read_unlock();
+			if (ret != 0)
 				return ret;
-			}
 		}
-		rcu_read_unlock();
 		return core_scsi3_update_and_write_aptpl(dev, aptpl);
 	}
-	rcu_read_unlock();
 
 	/* ok, existing registration */
 
@@ -3441,9 +3433,10 @@ after_iport_check:
 					iport_ptr);
 	if (!dest_pr_reg) {
 		spin_unlock(&dev->dev_reservation_lock);
-		if (core_scsi3_alloc_registration(cmd->se_dev,
-				dest_node_acl, dest_se_deve, iport_ptr,
-				sa_res_key, 0, aptpl, 2, 1)) {
+		if (core_scsi3_alloc_registration(cmd->se_dev, dest_node_acl,
+					lockless_dereference(dest_se_deve->se_lun),
+					dest_se_deve, dest_se_deve->mapped_lun,
+					iport_ptr, sa_res_key, 0, aptpl, 2, 1)) {
 			ret = TCM_INVALID_PARAMETER_LIST;
 			goto out;
 		}
@@ -4011,10 +4004,10 @@ core_scsi3_pri_read_full_status(struct se_cmd *cmd)
 		 * IDENTIFIER field are not defined by this standard.
 		 */
 		if (!pr_reg->pr_reg_all_tg_pt) {
-			struct se_port *port = pr_reg->pr_reg_tg_pt_lun->lun_sep;
+			u16 sep_rtpi = pr_reg->tg_pt_sep_rtpi;
 
-			buf[off++] = ((port->sep_rtpi >> 8) & 0xff);
-			buf[off++] = (port->sep_rtpi & 0xff);
+			buf[off++] = ((sep_rtpi >> 8) & 0xff);
+			buf[off++] = (sep_rtpi & 0xff);
 		} else
 			off += 2; /* Skip over RELATIVE TARGET PORT IDENTIFIER */
 
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 508528a..cf3c6ad 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -372,13 +372,14 @@ struct t10_pr_registration {
 	bool isid_present_at_reg;
 	u32 pr_res_mapped_lun;
 	u32 pr_aptpl_target_lun;
+	u16 tg_pt_sep_rtpi;
 	u32 pr_res_generation;
 	u64 pr_reg_bin_isid;
 	u64 pr_res_key;
 	atomic_t pr_res_holders;
 	struct se_node_acl *pr_reg_nacl;
+	/* Used by ALL_TG_PT=1 registration with deve->pr_ref taken */
 	struct se_dev_entry *pr_reg_deve;
-	struct se_lun *pr_reg_tg_pt_lun;
 	struct list_head pr_reg_list;
 	struct list_head pr_reg_abort_list;
 	struct list_head pr_reg_aptpl_list;
@@ -498,7 +499,6 @@ struct se_cmd {
 	struct list_head	se_delayed_node;
 	struct list_head	se_qf_node;
 	struct se_device      *se_dev;
-	struct se_dev_entry   *se_deve;
 	struct se_lun		*se_lun;
 	/* Only used for internal passthrough and legacy TCM fabric modules */
 	struct se_session	*se_sess;
-- 
1.9.1

