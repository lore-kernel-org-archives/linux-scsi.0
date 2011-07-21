From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 027/103] target: Remove #defines that just perform indirection
Date: Thu, 21 Jul 2011 00:05:03 -0700
Message-ID: <1311231979-6631-28-git-send-email-nab@linux-iscsi.org>
References: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm23.bullet.mail.bf1.yahoo.com ([98.139.212.182]:28211 "HELO
	nm23.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752099Ab1GUHGW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:06:22 -0400
In-Reply-To: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>

From: Andy Grover <agrover@redhat.com>

Generally, the kernel style prefers to use such macros for longer
conversions, container_of, that sort of thing. If it's just to refer to a
member variable, then for clarity it can just be used directly.

Usually the length difference is small, but one macro does shorten a
struct member name: se_subsystem_dev.t10_reservation. We shorten
t10_reservation member name (but not type) to t10_pr.

Finally, there are some bare numbers in _stat.c that this patch fixes
by using sizeof(), and we also remove extraneous memcpy()s.

Finally, make string fields in struct t10_wwn chars, to cut down on
casting.

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/loopback/tcm_loop.c           |    4 +-
 drivers/target/target_core_alua.c            |  138 ++--
 drivers/target/target_core_cdb.c             |  134 ++--
 drivers/target/target_core_configfs.c        |   79 +-
 drivers/target/target_core_device.c          |  297 ++++----
 drivers/target/target_core_fabric_configfs.c |   12 +-
 drivers/target/target_core_file.c            |   24 +-
 drivers/target/target_core_iblock.c          |   42 +-
 drivers/target/target_core_pr.c              |  328 ++++----
 drivers/target/target_core_pscsi.c           |   19 +-
 drivers/target/target_core_rd.c              |   28 +-
 drivers/target/target_core_stat.c            |  112 ++--
 drivers/target/target_core_tmr.c             |   82 +-
 drivers/target/target_core_tpg.c             |  106 ++--
 drivers/target/target_core_transport.c       | 1196 +++++++++++++-------------
 drivers/target/target_core_ua.c              |   16 +-
 drivers/target/tcm_fc/tfc_cmd.c              |    6 +-
 drivers/target/tcm_fc/tfc_io.c               |    4 +-
 include/target/target_core_base.h            |   38 +-
 include/target/target_core_transport.h       |    3 -
 20 files changed, 1318 insertions(+), 1350 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 26e3681..1f1695a 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -118,7 +118,7 @@ static struct se_cmd *tcm_loop_allocate_core_cmd(
 	 * Signal BIDI usage with T_TASK(cmd)->t_tasks_bidi
 	 */
 	if (scsi_bidi_cmnd(sc))
-		T_TASK(se_cmd)->t_tasks_bidi = 1;
+		se_cmd->t_task->t_tasks_bidi = 1;
 	/*
 	 * Locate the struct se_lun pointer and attach it to struct se_cmd
 	 */
@@ -176,7 +176,7 @@ static int tcm_loop_new_cmd_map(struct se_cmd *se_cmd)
 		 * For BIDI commands, pass in the extra READ buffer
 		 * to transport_generic_map_mem_to_cmd() below..
 		 */
-		if (T_TASK(se_cmd)->t_tasks_bidi) {
+		if (se_cmd->t_task->t_tasks_bidi) {
 			struct scsi_data_buffer *sdb = scsi_in(sc);
 
 			mem_bidi_ptr = (void *)sdb->table.sgl;
diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 62522d6..bfc42ad 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -61,16 +61,16 @@ struct t10_alua_lu_gp *default_lu_gp;
  */
 int core_emulate_report_target_port_groups(struct se_cmd *cmd)
 {
-	struct se_subsystem_dev *su_dev = SE_DEV(cmd)->se_sub_dev;
+	struct se_subsystem_dev *su_dev = cmd->se_lun->lun_se_dev->se_sub_dev;
 	struct se_port *port;
 	struct t10_alua_tg_pt_gp *tg_pt_gp;
 	struct t10_alua_tg_pt_gp_member *tg_pt_gp_mem;
-	unsigned char *buf = (unsigned char *)T_TASK(cmd)->t_task_buf;
+	unsigned char *buf = (unsigned char *)cmd->t_task->t_task_buf;
 	u32 rd_len = 0, off = 4; /* Skip over RESERVED area to first
 				    Target port group descriptor */
 
-	spin_lock(&T10_ALUA(su_dev)->tg_pt_gps_lock);
-	list_for_each_entry(tg_pt_gp, &T10_ALUA(su_dev)->tg_pt_gps_list,
+	spin_lock(&su_dev->t10_alua.tg_pt_gps_lock);
+	list_for_each_entry(tg_pt_gp, &su_dev->t10_alua.tg_pt_gps_list,
 			tg_pt_gp_list) {
 		/*
 		 * PREF: Preferred target port bit, determine if this
@@ -132,7 +132,7 @@ int core_emulate_report_target_port_groups(struct se_cmd *cmd)
 		}
 		spin_unlock(&tg_pt_gp->tg_pt_gp_lock);
 	}
-	spin_unlock(&T10_ALUA(su_dev)->tg_pt_gps_lock);
+	spin_unlock(&su_dev->t10_alua.tg_pt_gps_lock);
 	/*
 	 * Set the RETURN DATA LENGTH set in the header of the DataIN Payload
 	 */
@@ -151,13 +151,13 @@ int core_emulate_report_target_port_groups(struct se_cmd *cmd)
  */
 int core_emulate_set_target_port_groups(struct se_cmd *cmd)
 {
-	struct se_device *dev = SE_DEV(cmd);
-	struct se_subsystem_dev *su_dev = SE_DEV(cmd)->se_sub_dev;
-	struct se_port *port, *l_port = SE_LUN(cmd)->lun_sep;
-	struct se_node_acl *nacl = SE_SESS(cmd)->se_node_acl;
+	struct se_device *dev = cmd->se_lun->lun_se_dev;
+	struct se_subsystem_dev *su_dev = dev->se_sub_dev;
+	struct se_port *port, *l_port = cmd->se_lun->lun_sep;
+	struct se_node_acl *nacl = cmd->se_sess->se_node_acl;
 	struct t10_alua_tg_pt_gp *tg_pt_gp = NULL, *l_tg_pt_gp;
 	struct t10_alua_tg_pt_gp_member *tg_pt_gp_mem, *l_tg_pt_gp_mem;
-	unsigned char *buf = (unsigned char *)T_TASK(cmd)->t_task_buf;
+	unsigned char *buf = (unsigned char *)cmd->t_task->t_task_buf;
 	unsigned char *ptr = &buf[4]; /* Skip over RESERVED area in header */
 	u32 len = 4; /* Skip over RESERVED area in header */
 	int alua_access_state, primary = 0, rc;
@@ -232,9 +232,9 @@ int core_emulate_set_target_port_groups(struct se_cmd *cmd)
 			 * Locate the matching target port group ID from
 			 * the global tg_pt_gp list
 			 */
-			spin_lock(&T10_ALUA(su_dev)->tg_pt_gps_lock);
+			spin_lock(&su_dev->t10_alua.tg_pt_gps_lock);
 			list_for_each_entry(tg_pt_gp,
-					&T10_ALUA(su_dev)->tg_pt_gps_list,
+					&su_dev->t10_alua.tg_pt_gps_list,
 					tg_pt_gp_list) {
 				if (!(tg_pt_gp->tg_pt_gp_valid_id))
 					continue;
@@ -244,18 +244,18 @@ int core_emulate_set_target_port_groups(struct se_cmd *cmd)
 
 				atomic_inc(&tg_pt_gp->tg_pt_gp_ref_cnt);
 				smp_mb__after_atomic_inc();
-				spin_unlock(&T10_ALUA(su_dev)->tg_pt_gps_lock);
+				spin_unlock(&su_dev->t10_alua.tg_pt_gps_lock);
 
 				rc = core_alua_do_port_transition(tg_pt_gp,
 						dev, l_port, nacl,
 						alua_access_state, 1);
 
-				spin_lock(&T10_ALUA(su_dev)->tg_pt_gps_lock);
+				spin_lock(&su_dev->t10_alua.tg_pt_gps_lock);
 				atomic_dec(&tg_pt_gp->tg_pt_gp_ref_cnt);
 				smp_mb__after_atomic_dec();
 				break;
 			}
-			spin_unlock(&T10_ALUA(su_dev)->tg_pt_gps_lock);
+			spin_unlock(&su_dev->t10_alua.tg_pt_gps_lock);
 			/*
 			 * If not matching target port group ID can be located
 			 * throw an exception with ASCQ: INVALID_PARAMETER_LIST
@@ -472,7 +472,7 @@ static int core_alua_state_check(
 	unsigned char *cdb,
 	u8 *alua_ascq)
 {
-	struct se_lun *lun = SE_LUN(cmd);
+	struct se_lun *lun = cmd->se_lun;
 	struct se_port *port = lun->lun_sep;
 	struct t10_alua_tg_pt_gp *tg_pt_gp;
 	struct t10_alua_tg_pt_gp_member *tg_pt_gp_mem;
@@ -874,9 +874,9 @@ int core_alua_do_port_transition(
 		smp_mb__after_atomic_inc();
 		spin_unlock(&lu_gp->lu_gp_lock);
 
-		spin_lock(&T10_ALUA(su_dev)->tg_pt_gps_lock);
+		spin_lock(&su_dev->t10_alua.tg_pt_gps_lock);
 		list_for_each_entry(tg_pt_gp,
-				&T10_ALUA(su_dev)->tg_pt_gps_list,
+				&su_dev->t10_alua.tg_pt_gps_list,
 				tg_pt_gp_list) {
 
 			if (!(tg_pt_gp->tg_pt_gp_valid_id))
@@ -901,7 +901,7 @@ int core_alua_do_port_transition(
 			}
 			atomic_inc(&tg_pt_gp->tg_pt_gp_ref_cnt);
 			smp_mb__after_atomic_inc();
-			spin_unlock(&T10_ALUA(su_dev)->tg_pt_gps_lock);
+			spin_unlock(&su_dev->t10_alua.tg_pt_gps_lock);
 			/*
 			 * core_alua_do_transition_tg_pt() will always return
 			 * success.
@@ -909,11 +909,11 @@ int core_alua_do_port_transition(
 			core_alua_do_transition_tg_pt(tg_pt_gp, port,
 					nacl, md_buf, new_state, explict);
 
-			spin_lock(&T10_ALUA(su_dev)->tg_pt_gps_lock);
+			spin_lock(&su_dev->t10_alua.tg_pt_gps_lock);
 			atomic_dec(&tg_pt_gp->tg_pt_gp_ref_cnt);
 			smp_mb__after_atomic_dec();
 		}
-		spin_unlock(&T10_ALUA(su_dev)->tg_pt_gps_lock);
+		spin_unlock(&su_dev->t10_alua.tg_pt_gps_lock);
 
 		spin_lock(&lu_gp->lu_gp_lock);
 		atomic_dec(&lu_gp_mem->lu_gp_mem_ref_cnt);
@@ -950,11 +950,11 @@ static int core_alua_update_tpg_secondary_metadata(
 	memset(wwn, 0, ALUA_SECONDARY_METADATA_WWN_LEN);
 
 	len = snprintf(wwn, ALUA_SECONDARY_METADATA_WWN_LEN, "%s",
-			TPG_TFO(se_tpg)->tpg_get_wwn(se_tpg));
+			se_tpg->se_tpg_tfo->tpg_get_wwn(se_tpg));
 
-	if (TPG_TFO(se_tpg)->tpg_get_tag != NULL)
+	if (se_tpg->se_tpg_tfo->tpg_get_tag != NULL)
 		snprintf(wwn+len, ALUA_SECONDARY_METADATA_WWN_LEN-len, "+%hu",
-				TPG_TFO(se_tpg)->tpg_get_tag(se_tpg));
+				se_tpg->se_tpg_tfo->tpg_get_tag(se_tpg));
 
 	len = snprintf(md_buf, md_buf_len, "alua_tg_pt_offline=%d\n"
 			"alua_tg_pt_status=0x%02x\n",
@@ -962,7 +962,7 @@ static int core_alua_update_tpg_secondary_metadata(
 			port->sep_tg_pt_secondary_stat);
 
 	snprintf(path, ALUA_METADATA_PATH_LEN, "/var/target/alua/%s/%s/lun_%u",
-			TPG_TFO(se_tpg)->get_fabric_name(), wwn,
+			se_tpg->se_tpg_tfo->get_fabric_name(), wwn,
 			port->sep_lun->unpacked_lun);
 
 	return core_alua_write_tpg_metadata(path, md_buf, len);
@@ -1190,7 +1190,7 @@ void core_alua_free_lu_gp(struct t10_alua_lu_gp *lu_gp)
 void core_alua_free_lu_gp_mem(struct se_device *dev)
 {
 	struct se_subsystem_dev *su_dev = dev->se_sub_dev;
-	struct t10_alua *alua = T10_ALUA(su_dev);
+	struct t10_alua *alua = &su_dev->t10_alua;
 	struct t10_alua_lu_gp *lu_gp;
 	struct t10_alua_lu_gp_member *lu_gp_mem;
 
@@ -1312,14 +1312,14 @@ struct t10_alua_tg_pt_gp *core_alua_allocate_tg_pt_gp(
 	tg_pt_gp->tg_pt_gp_trans_delay_msecs = ALUA_DEFAULT_TRANS_DELAY_MSECS;
 
 	if (def_group) {
-		spin_lock(&T10_ALUA(su_dev)->tg_pt_gps_lock);
+		spin_lock(&su_dev->t10_alua.tg_pt_gps_lock);
 		tg_pt_gp->tg_pt_gp_id =
-				T10_ALUA(su_dev)->alua_tg_pt_gps_counter++;
+				su_dev->t10_alua.alua_tg_pt_gps_counter++;
 		tg_pt_gp->tg_pt_gp_valid_id = 1;
-		T10_ALUA(su_dev)->alua_tg_pt_gps_count++;
+		su_dev->t10_alua.alua_tg_pt_gps_count++;
 		list_add_tail(&tg_pt_gp->tg_pt_gp_list,
-			      &T10_ALUA(su_dev)->tg_pt_gps_list);
-		spin_unlock(&T10_ALUA(su_dev)->tg_pt_gps_lock);
+			      &su_dev->t10_alua.tg_pt_gps_list);
+		spin_unlock(&su_dev->t10_alua.tg_pt_gps_lock);
 	}
 
 	return tg_pt_gp;
@@ -1341,19 +1341,19 @@ int core_alua_set_tg_pt_gp_id(
 		return -EINVAL;
 	}
 
-	spin_lock(&T10_ALUA(su_dev)->tg_pt_gps_lock);
-	if (T10_ALUA(su_dev)->alua_tg_pt_gps_count == 0x0000ffff) {
+	spin_lock(&su_dev->t10_alua.tg_pt_gps_lock);
+	if (su_dev->t10_alua.alua_tg_pt_gps_count == 0x0000ffff) {
 		printk(KERN_ERR "Maximum ALUA alua_tg_pt_gps_count:"
 			" 0x0000ffff reached\n");
-		spin_unlock(&T10_ALUA(su_dev)->tg_pt_gps_lock);
+		spin_unlock(&su_dev->t10_alua.tg_pt_gps_lock);
 		kmem_cache_free(t10_alua_tg_pt_gp_cache, tg_pt_gp);
 		return -ENOSPC;
 	}
 again:
 	tg_pt_gp_id_tmp = (tg_pt_gp_id != 0) ? tg_pt_gp_id :
-			T10_ALUA(su_dev)->alua_tg_pt_gps_counter++;
+			su_dev->t10_alua.alua_tg_pt_gps_counter++;
 
-	list_for_each_entry(tg_pt_gp_tmp, &T10_ALUA(su_dev)->tg_pt_gps_list,
+	list_for_each_entry(tg_pt_gp_tmp, &su_dev->t10_alua.tg_pt_gps_list,
 			tg_pt_gp_list) {
 		if (tg_pt_gp_tmp->tg_pt_gp_id == tg_pt_gp_id_tmp) {
 			if (!(tg_pt_gp_id))
@@ -1361,7 +1361,7 @@ again:
 
 			printk(KERN_ERR "ALUA Target Port Group ID: %hu already"
 				" exists, ignoring request\n", tg_pt_gp_id);
-			spin_unlock(&T10_ALUA(su_dev)->tg_pt_gps_lock);
+			spin_unlock(&su_dev->t10_alua.tg_pt_gps_lock);
 			return -EINVAL;
 		}
 	}
@@ -1369,9 +1369,9 @@ again:
 	tg_pt_gp->tg_pt_gp_id = tg_pt_gp_id_tmp;
 	tg_pt_gp->tg_pt_gp_valid_id = 1;
 	list_add_tail(&tg_pt_gp->tg_pt_gp_list,
-			&T10_ALUA(su_dev)->tg_pt_gps_list);
-	T10_ALUA(su_dev)->alua_tg_pt_gps_count++;
-	spin_unlock(&T10_ALUA(su_dev)->tg_pt_gps_lock);
+			&su_dev->t10_alua.tg_pt_gps_list);
+	su_dev->t10_alua.alua_tg_pt_gps_count++;
+	spin_unlock(&su_dev->t10_alua.tg_pt_gps_lock);
 
 	return 0;
 }
@@ -1411,10 +1411,10 @@ void core_alua_free_tg_pt_gp(
 	 * no assications *OR* explict ALUA via SET_TARGET_PORT_GROUPS
 	 * can be made while we are releasing struct t10_alua_tg_pt_gp.
 	 */
-	spin_lock(&T10_ALUA(su_dev)->tg_pt_gps_lock);
+	spin_lock(&su_dev->t10_alua.tg_pt_gps_lock);
 	list_del(&tg_pt_gp->tg_pt_gp_list);
-	T10_ALUA(su_dev)->alua_tg_pt_gps_counter--;
-	spin_unlock(&T10_ALUA(su_dev)->tg_pt_gps_lock);
+	su_dev->t10_alua.alua_tg_pt_gps_counter--;
+	spin_unlock(&su_dev->t10_alua.tg_pt_gps_lock);
 	/*
 	 * Allow a struct t10_alua_tg_pt_gp_member * referenced by
 	 * core_alua_get_tg_pt_gp_by_name() in
@@ -1446,9 +1446,9 @@ void core_alua_free_tg_pt_gp(
 		 * default_tg_pt_gp.
 		 */
 		spin_lock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
-		if (tg_pt_gp != T10_ALUA(su_dev)->default_tg_pt_gp) {
+		if (tg_pt_gp != su_dev->t10_alua.default_tg_pt_gp) {
 			__core_alua_attach_tg_pt_gp_mem(tg_pt_gp_mem,
-					T10_ALUA(su_dev)->default_tg_pt_gp);
+					su_dev->t10_alua.default_tg_pt_gp);
 		} else
 			tg_pt_gp_mem->tg_pt_gp = NULL;
 		spin_unlock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
@@ -1463,7 +1463,7 @@ void core_alua_free_tg_pt_gp(
 void core_alua_free_tg_pt_gp_mem(struct se_port *port)
 {
 	struct se_subsystem_dev *su_dev = port->sep_lun->lun_se_dev->se_sub_dev;
-	struct t10_alua *alua = T10_ALUA(su_dev);
+	struct t10_alua *alua = &su_dev->t10_alua;
 	struct t10_alua_tg_pt_gp *tg_pt_gp;
 	struct t10_alua_tg_pt_gp_member *tg_pt_gp_mem;
 
@@ -1501,19 +1501,19 @@ static struct t10_alua_tg_pt_gp *core_alua_get_tg_pt_gp_by_name(
 	struct t10_alua_tg_pt_gp *tg_pt_gp;
 	struct config_item *ci;
 
-	spin_lock(&T10_ALUA(su_dev)->tg_pt_gps_lock);
-	list_for_each_entry(tg_pt_gp, &T10_ALUA(su_dev)->tg_pt_gps_list,
+	spin_lock(&su_dev->t10_alua.tg_pt_gps_lock);
+	list_for_each_entry(tg_pt_gp, &su_dev->t10_alua.tg_pt_gps_list,
 			tg_pt_gp_list) {
 		if (!(tg_pt_gp->tg_pt_gp_valid_id))
 			continue;
 		ci = &tg_pt_gp->tg_pt_gp_group.cg_item;
 		if (!(strcmp(config_item_name(ci), name))) {
 			atomic_inc(&tg_pt_gp->tg_pt_gp_ref_cnt);
-			spin_unlock(&T10_ALUA(su_dev)->tg_pt_gps_lock);
+			spin_unlock(&su_dev->t10_alua.tg_pt_gps_lock);
 			return tg_pt_gp;
 		}
 	}
-	spin_unlock(&T10_ALUA(su_dev)->tg_pt_gps_lock);
+	spin_unlock(&su_dev->t10_alua.tg_pt_gps_lock);
 
 	return NULL;
 }
@@ -1523,9 +1523,9 @@ static void core_alua_put_tg_pt_gp_from_name(
 {
 	struct se_subsystem_dev *su_dev = tg_pt_gp->tg_pt_gp_su_dev;
 
-	spin_lock(&T10_ALUA(su_dev)->tg_pt_gps_lock);
+	spin_lock(&su_dev->t10_alua.tg_pt_gps_lock);
 	atomic_dec(&tg_pt_gp->tg_pt_gp_ref_cnt);
-	spin_unlock(&T10_ALUA(su_dev)->tg_pt_gps_lock);
+	spin_unlock(&su_dev->t10_alua.tg_pt_gps_lock);
 }
 
 /*
@@ -1563,7 +1563,7 @@ ssize_t core_alua_show_tg_pt_gp_info(struct se_port *port, char *page)
 {
 	struct se_subsystem_dev *su_dev = port->sep_lun->lun_se_dev->se_sub_dev;
 	struct config_item *tg_pt_ci;
-	struct t10_alua *alua = T10_ALUA(su_dev);
+	struct t10_alua *alua = &su_dev->t10_alua;
 	struct t10_alua_tg_pt_gp *tg_pt_gp;
 	struct t10_alua_tg_pt_gp_member *tg_pt_gp_mem;
 	ssize_t len = 0;
@@ -1613,10 +1613,10 @@ ssize_t core_alua_store_tg_pt_gp_info(
 	tpg = port->sep_tpg;
 	lun = port->sep_lun;
 
-	if (T10_ALUA(su_dev)->alua_type != SPC3_ALUA_EMULATED) {
+	if (su_dev->t10_alua.alua_type != SPC3_ALUA_EMULATED) {
 		printk(KERN_WARNING "SPC3_ALUA_EMULATED not enabled for"
-			" %s/tpgt_%hu/%s\n", TPG_TFO(tpg)->tpg_get_wwn(tpg),
-			TPG_TFO(tpg)->tpg_get_tag(tpg),
+			" %s/tpgt_%hu/%s\n", tpg->se_tpg_tfo->tpg_get_wwn(tpg),
+			tpg->se_tpg_tfo->tpg_get_tag(tpg),
 			config_item_name(&lun->lun_group.cg_item));
 		return -EINVAL;
 	}
@@ -1662,8 +1662,8 @@ ssize_t core_alua_store_tg_pt_gp_info(
 				" %s/tpgt_%hu/%s from ALUA Target Port Group:"
 				" alua/%s, ID: %hu back to"
 				" default_tg_pt_gp\n",
-				TPG_TFO(tpg)->tpg_get_wwn(tpg),
-				TPG_TFO(tpg)->tpg_get_tag(tpg),
+				tpg->se_tpg_tfo->tpg_get_wwn(tpg),
+				tpg->se_tpg_tfo->tpg_get_tag(tpg),
 				config_item_name(&lun->lun_group.cg_item),
 				config_item_name(
 					&tg_pt_gp->tg_pt_gp_group.cg_item),
@@ -1671,7 +1671,7 @@ ssize_t core_alua_store_tg_pt_gp_info(
 
 			__core_alua_drop_tg_pt_gp_mem(tg_pt_gp_mem, tg_pt_gp);
 			__core_alua_attach_tg_pt_gp_mem(tg_pt_gp_mem,
-					T10_ALUA(su_dev)->default_tg_pt_gp);
+					su_dev->t10_alua.default_tg_pt_gp);
 			spin_unlock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
 
 			return count;
@@ -1689,8 +1689,8 @@ ssize_t core_alua_store_tg_pt_gp_info(
 	spin_unlock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
 	printk(KERN_INFO "Target_Core_ConfigFS: %s %s/tpgt_%hu/%s to ALUA"
 		" Target Port Group: alua/%s, ID: %hu\n", (move) ?
-		"Moving" : "Adding", TPG_TFO(tpg)->tpg_get_wwn(tpg),
-		TPG_TFO(tpg)->tpg_get_tag(tpg),
+		"Moving" : "Adding", tpg->se_tpg_tfo->tpg_get_wwn(tpg),
+		tpg->se_tpg_tfo->tpg_get_tag(tpg),
 		config_item_name(&lun->lun_group.cg_item),
 		config_item_name(&tg_pt_gp_new->tg_pt_gp_group.cg_item),
 		tg_pt_gp_new->tg_pt_gp_id);
@@ -1947,7 +1947,7 @@ ssize_t core_alua_store_secondary_write_metadata(
 int core_setup_alua(struct se_device *dev, int force_pt)
 {
 	struct se_subsystem_dev *su_dev = dev->se_sub_dev;
-	struct t10_alua *alua = T10_ALUA(su_dev);
+	struct t10_alua *alua = &su_dev->t10_alua;
 	struct t10_alua_lu_gp_member *lu_gp_mem;
 	/*
 	 * If this device is from Target_Core_Mod/pSCSI, use the ALUA logic
@@ -1955,21 +1955,21 @@ int core_setup_alua(struct se_device *dev, int force_pt)
 	 * cause a problem because libata and some SATA RAID HBAs appear
 	 * under Linux/SCSI, but emulate SCSI logic themselves.
 	 */
-	if (((TRANSPORT(dev)->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV) &&
-	    !(DEV_ATTRIB(dev)->emulate_alua)) || force_pt) {
+	if (((dev->transport->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV) &&
+	    !(dev->se_sub_dev->se_dev_attrib.emulate_alua)) || force_pt) {
 		alua->alua_type = SPC_ALUA_PASSTHROUGH;
 		alua->alua_state_check = &core_alua_state_check_nop;
 		printk(KERN_INFO "%s: Using SPC_ALUA_PASSTHROUGH, no ALUA"
-			" emulation\n", TRANSPORT(dev)->name);
+			" emulation\n", dev->transport->name);
 		return 0;
 	}
 	/*
 	 * If SPC-3 or above is reported by real or emulated struct se_device,
 	 * use emulated ALUA.
 	 */
-	if (TRANSPORT(dev)->get_device_rev(dev) >= SCSI_3) {
+	if (dev->transport->get_device_rev(dev) >= SCSI_3) {
 		printk(KERN_INFO "%s: Enabling ALUA Emulation for SPC-3"
-			" device\n", TRANSPORT(dev)->name);
+			" device\n", dev->transport->name);
 		/*
 		 * Associate this struct se_device with the default ALUA
 		 * LUN Group.
@@ -1987,12 +1987,12 @@ int core_setup_alua(struct se_device *dev, int force_pt)
 
 		printk(KERN_INFO "%s: Adding to default ALUA LU Group:"
 			" core/alua/lu_gps/default_lu_gp\n",
-			TRANSPORT(dev)->name);
+			dev->transport->name);
 	} else {
 		alua->alua_type = SPC2_ALUA_DISABLED;
 		alua->alua_state_check = &core_alua_state_check_nop;
 		printk(KERN_INFO "%s: Disabling ALUA Emulation for SPC-2"
-			" device\n", TRANSPORT(dev)->name);
+			" device\n", dev->transport->name);
 	}
 
 	return 0;
diff --git a/drivers/target/target_core_cdb.c b/drivers/target/target_core_cdb.c
index b39ffad..7d9ccf3 100644
--- a/drivers/target/target_core_cdb.c
+++ b/drivers/target/target_core_cdb.c
@@ -64,8 +64,8 @@ target_fill_alua_data(struct se_port *port, unsigned char *buf)
 static int
 target_emulate_inquiry_std(struct se_cmd *cmd)
 {
-	struct se_lun *lun = SE_LUN(cmd);
-	struct se_device *dev = SE_DEV(cmd);
+	struct se_lun *lun = cmd->se_lun;
+	struct se_device *dev = cmd->se_lun->lun_se_dev;
 	unsigned char *buf = cmd->t_task->t_task_buf;
 
 	/*
@@ -86,7 +86,7 @@ target_emulate_inquiry_std(struct se_cmd *cmd)
 	/*
 	 * Enable SCCS and TPGS fields for Emulated ALUA
 	 */
-	if (T10_ALUA(dev->se_sub_dev)->alua_type == SPC3_ALUA_EMULATED)
+	if (dev->se_sub_dev->t10_alua.alua_type == SPC3_ALUA_EMULATED)
 		target_fill_alua_data(lun->lun_sep, buf);
 
 	if (cmd->data_length < 8) {
@@ -107,9 +107,9 @@ target_emulate_inquiry_std(struct se_cmd *cmd)
 
 	snprintf((unsigned char *)&buf[8], 8, "LIO-ORG");
 	snprintf((unsigned char *)&buf[16], 16, "%s",
-		 &DEV_T10_WWN(dev)->model[0]);
+		 &dev->se_sub_dev->t10_wwn.model[0]);
 	snprintf((unsigned char *)&buf[32], 4, "%s",
-		 &DEV_T10_WWN(dev)->revision[0]);
+		 &dev->se_sub_dev->t10_wwn.revision[0]);
 	buf[4] = 31; /* Set additional length to 31 */
 	return 0;
 }
@@ -128,7 +128,7 @@ target_emulate_evpd_00(struct se_cmd *cmd, unsigned char *buf)
 	 * Registered Extended LUN WWN has been set via ConfigFS
 	 * during device creation/restart.
 	 */
-	if (SE_DEV(cmd)->se_sub_dev->su_dev_flags &
+	if (cmd->se_lun->lun_se_dev->se_sub_dev->su_dev_flags &
 			SDF_EMULATED_VPD_UNIT_SERIAL) {
 		buf[3] = 3;
 		buf[5] = 0x80;
@@ -143,7 +143,7 @@ target_emulate_evpd_00(struct se_cmd *cmd, unsigned char *buf)
 static int
 target_emulate_evpd_80(struct se_cmd *cmd, unsigned char *buf)
 {
-	struct se_device *dev = SE_DEV(cmd);
+	struct se_device *dev = cmd->se_lun->lun_se_dev;
 	u16 len = 0;
 
 	buf[1] = 0x80;
@@ -152,7 +152,7 @@ target_emulate_evpd_80(struct se_cmd *cmd, unsigned char *buf)
 		u32 unit_serial_len;
 
 		unit_serial_len =
-			strlen(&DEV_T10_WWN(dev)->unit_serial[0]);
+			strlen(&dev->se_sub_dev->t10_wwn.unit_serial[0]);
 		unit_serial_len++; /* For NULL Terminator */
 
 		if (((len + 4) + unit_serial_len) > cmd->data_length) {
@@ -162,7 +162,7 @@ target_emulate_evpd_80(struct se_cmd *cmd, unsigned char *buf)
 			return 0;
 		}
 		len += sprintf((unsigned char *)&buf[4], "%s",
-			&DEV_T10_WWN(dev)->unit_serial[0]);
+			&dev->se_sub_dev->t10_wwn.unit_serial[0]);
 		len++; /* Extra Byte for NULL Terminator */
 		buf[3] = len;
 	}
@@ -176,15 +176,15 @@ target_emulate_evpd_80(struct se_cmd *cmd, unsigned char *buf)
 static int
 target_emulate_evpd_83(struct se_cmd *cmd, unsigned char *buf)
 {
-	struct se_device *dev = SE_DEV(cmd);
-	struct se_lun *lun = SE_LUN(cmd);
+	struct se_device *dev = cmd->se_lun->lun_se_dev;
+	struct se_lun *lun = cmd->se_lun;
 	struct se_port *port = NULL;
 	struct se_portal_group *tpg = NULL;
 	struct t10_alua_lu_gp_member *lu_gp_mem;
 	struct t10_alua_tg_pt_gp *tg_pt_gp;
 	struct t10_alua_tg_pt_gp_member *tg_pt_gp_mem;
 	unsigned char binary, binary_new;
-	unsigned char *prod = &DEV_T10_WWN(dev)->model[0];
+	unsigned char *prod = &dev->se_sub_dev->t10_wwn.model[0];
 	u32 prod_len;
 	u32 unit_serial_len, off = 0;
 	int i;
@@ -238,11 +238,11 @@ target_emulate_evpd_83(struct se_cmd *cmd, unsigned char *buf)
 	 * VENDOR_SPECIFIC_IDENTIFIER_EXTENTION
 	 */
 	binary = transport_asciihex_to_binaryhex(
-				&DEV_T10_WWN(dev)->unit_serial[0]);
+				&dev->se_sub_dev->t10_wwn.unit_serial[0]);
 	buf[off++] |= (binary & 0xf0) >> 4;
 	for (i = 0; i < 24; i += 2) {
 		binary_new = transport_asciihex_to_binaryhex(
-			&DEV_T10_WWN(dev)->unit_serial[i+2]);
+			&dev->se_sub_dev->t10_wwn.unit_serial[i+2]);
 		buf[off] = (binary & 0x0f) << 4;
 		buf[off++] |= (binary_new & 0xf0) >> 4;
 		binary = binary_new;
@@ -263,7 +263,7 @@ check_t10_vend_desc:
 	if (dev->se_sub_dev->su_dev_flags &
 			SDF_EMULATED_VPD_UNIT_SERIAL) {
 		unit_serial_len =
-			strlen(&DEV_T10_WWN(dev)->unit_serial[0]);
+			strlen(&dev->se_sub_dev->t10_wwn.unit_serial[0]);
 		unit_serial_len++; /* For NULL Terminator */
 
 		if ((len + (id_len + 4) +
@@ -274,7 +274,7 @@ check_t10_vend_desc:
 		}
 		id_len += sprintf((unsigned char *)&buf[off+12],
 				"%s:%s", prod,
-				&DEV_T10_WWN(dev)->unit_serial[0]);
+				&dev->se_sub_dev->t10_wwn.unit_serial[0]);
 	}
 	buf[off] = 0x2; /* ASCII */
 	buf[off+1] = 0x1; /* T10 Vendor ID */
@@ -312,7 +312,7 @@ check_port:
 			goto check_tpgi;
 		}
 		buf[off] =
-			(TPG_TFO(tpg)->get_fabric_proto_ident(tpg) << 4);
+			(tpg->se_tpg_tfo->get_fabric_proto_ident(tpg) << 4);
 		buf[off++] |= 0x1; /* CODE SET == Binary */
 		buf[off] = 0x80; /* Set PIV=1 */
 		/* Set ASSOICATION == target port: 01b */
@@ -335,7 +335,7 @@ check_port:
 		 * section 7.5.1 Table 362
 		 */
 check_tpgi:
-		if (T10_ALUA(dev->se_sub_dev)->alua_type !=
+		if (dev->se_sub_dev->t10_alua.alua_type !=
 				SPC3_ALUA_EMULATED)
 			goto check_scsi_name;
 
@@ -357,7 +357,7 @@ check_tpgi:
 		spin_unlock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
 
 		buf[off] =
-			(TPG_TFO(tpg)->get_fabric_proto_ident(tpg) << 4);
+			(tpg->se_tpg_tfo->get_fabric_proto_ident(tpg) << 4);
 		buf[off++] |= 0x1; /* CODE SET == Binary */
 		buf[off] = 0x80; /* Set PIV=1 */
 		/* Set ASSOICATION == target port: 01b */
@@ -409,7 +409,7 @@ check_lu_gp:
 		 * section 7.5.1 Table 362
 		 */
 check_scsi_name:
-		scsi_name_len = strlen(TPG_TFO(tpg)->tpg_get_wwn(tpg));
+		scsi_name_len = strlen(tpg->se_tpg_tfo->tpg_get_wwn(tpg));
 		/* UTF-8 ",t,0x<16-bit TPGT>" + NULL Terminator */
 		scsi_name_len += 10;
 		/* Check for 4-byte padding */
@@ -424,7 +424,7 @@ check_scsi_name:
 			goto set_len;
 		}
 		buf[off] =
-			(TPG_TFO(tpg)->get_fabric_proto_ident(tpg) << 4);
+			(tpg->se_tpg_tfo->get_fabric_proto_ident(tpg) << 4);
 		buf[off++] |= 0x3; /* CODE SET == UTF-8 */
 		buf[off] = 0x80; /* Set PIV=1 */
 		/* Set ASSOICATION == target port: 01b */
@@ -438,9 +438,9 @@ check_scsi_name:
 		 * Target Port, this means "<iSCSI name>,t,0x<TPGT> in
 		 * UTF-8 encoding.
 		 */
-		tpgt = TPG_TFO(tpg)->tpg_get_tag(tpg);
+		tpgt = tpg->se_tpg_tfo->tpg_get_tag(tpg);
 		scsi_name_len = sprintf(&buf[off], "%s,t,0x%04x",
-					TPG_TFO(tpg)->tpg_get_wwn(tpg), tpgt);
+					tpg->se_tpg_tfo->tpg_get_wwn(tpg), tpgt);
 		scsi_name_len += 1 /* Include  NULL terminator */;
 		/*
 		 * The null-terminated, null-padded (see 4.4.2) SCSI
@@ -477,7 +477,7 @@ target_emulate_evpd_86(struct se_cmd *cmd, unsigned char *buf)
 	buf[5] = 0x07;
 
 	/* If WriteCache emulation is enabled, set V_SUP */
-	if (DEV_ATTRIB(SE_DEV(cmd))->emulate_write_cache > 0)
+	if (cmd->se_lun->lun_se_dev->se_sub_dev->se_dev_attrib.emulate_write_cache > 0)
 		buf[6] = 0x01;
 	return 0;
 }
@@ -486,7 +486,7 @@ target_emulate_evpd_86(struct se_cmd *cmd, unsigned char *buf)
 static int
 target_emulate_evpd_b0(struct se_cmd *cmd, unsigned char *buf)
 {
-	struct se_device *dev = SE_DEV(cmd);
+	struct se_device *dev = cmd->se_lun->lun_se_dev;
 	int have_tp = 0;
 
 	/*
@@ -494,7 +494,7 @@ target_emulate_evpd_b0(struct se_cmd *cmd, unsigned char *buf)
 	 * emulate_tpu=1 or emulate_tpws=1 we will be expect a
 	 * different page length for Thin Provisioning.
 	 */
-	if (DEV_ATTRIB(dev)->emulate_tpu || DEV_ATTRIB(dev)->emulate_tpws)
+	if (dev->se_sub_dev->se_dev_attrib.emulate_tpu || dev->se_sub_dev->se_dev_attrib.emulate_tpws)
 		have_tp = 1;
 
 	if (cmd->data_length < (0x10 + 4)) {
@@ -523,12 +523,12 @@ target_emulate_evpd_b0(struct se_cmd *cmd, unsigned char *buf)
 	/*
 	 * Set MAXIMUM TRANSFER LENGTH
 	 */
-	put_unaligned_be32(DEV_ATTRIB(dev)->max_sectors, &buf[8]);
+	put_unaligned_be32(dev->se_sub_dev->se_dev_attrib.max_sectors, &buf[8]);
 
 	/*
 	 * Set OPTIMAL TRANSFER LENGTH
 	 */
-	put_unaligned_be32(DEV_ATTRIB(dev)->optimal_sectors, &buf[12]);
+	put_unaligned_be32(dev->se_sub_dev->se_dev_attrib.optimal_sectors, &buf[12]);
 
 	/*
 	 * Exit now if we don't support TP or the initiator sent a too
@@ -540,25 +540,25 @@ target_emulate_evpd_b0(struct se_cmd *cmd, unsigned char *buf)
 	/*
 	 * Set MAXIMUM UNMAP LBA COUNT
 	 */
-	put_unaligned_be32(DEV_ATTRIB(dev)->max_unmap_lba_count, &buf[20]);
+	put_unaligned_be32(dev->se_sub_dev->se_dev_attrib.max_unmap_lba_count, &buf[20]);
 
 	/*
 	 * Set MAXIMUM UNMAP BLOCK DESCRIPTOR COUNT
 	 */
-	put_unaligned_be32(DEV_ATTRIB(dev)->max_unmap_block_desc_count,
+	put_unaligned_be32(dev->se_sub_dev->se_dev_attrib.max_unmap_block_desc_count,
 			   &buf[24]);
 
 	/*
 	 * Set OPTIMAL UNMAP GRANULARITY
 	 */
-	put_unaligned_be32(DEV_ATTRIB(dev)->unmap_granularity, &buf[28]);
+	put_unaligned_be32(dev->se_sub_dev->se_dev_attrib.unmap_granularity, &buf[28]);
 
 	/*
 	 * UNMAP GRANULARITY ALIGNMENT
 	 */
-	put_unaligned_be32(DEV_ATTRIB(dev)->unmap_granularity_alignment,
+	put_unaligned_be32(dev->se_sub_dev->se_dev_attrib.unmap_granularity_alignment,
 			   &buf[32]);
-	if (DEV_ATTRIB(dev)->unmap_granularity_alignment != 0)
+	if (dev->se_sub_dev->se_dev_attrib.unmap_granularity_alignment != 0)
 		buf[32] |= 0x80; /* Set the UGAVALID bit */
 
 	return 0;
@@ -568,7 +568,7 @@ target_emulate_evpd_b0(struct se_cmd *cmd, unsigned char *buf)
 static int
 target_emulate_evpd_b2(struct se_cmd *cmd, unsigned char *buf)
 {
-	struct se_device *dev = SE_DEV(cmd);
+	struct se_device *dev = cmd->se_lun->lun_se_dev;
 
 	/*
 	 * From sbc3r22 section 6.5.4 Thin Provisioning VPD page:
@@ -602,7 +602,7 @@ target_emulate_evpd_b2(struct se_cmd *cmd, unsigned char *buf)
 	 * the UNMAP command (see 5.25). A TPU bit set to zero indicates
 	 * that the device server does not support the UNMAP command.
 	 */
-	if (DEV_ATTRIB(dev)->emulate_tpu != 0)
+	if (dev->se_sub_dev->se_dev_attrib.emulate_tpu != 0)
 		buf[5] = 0x80;
 
 	/*
@@ -611,7 +611,7 @@ target_emulate_evpd_b2(struct se_cmd *cmd, unsigned char *buf)
 	 * A TPWS bit set to zero indicates that the device server does not
 	 * support the use of the WRITE SAME (16) command to unmap LBAs.
 	 */
-	if (DEV_ATTRIB(dev)->emulate_tpws != 0)
+	if (dev->se_sub_dev->se_dev_attrib.emulate_tpws != 0)
 		buf[5] |= 0x40;
 
 	return 0;
@@ -620,7 +620,7 @@ target_emulate_evpd_b2(struct se_cmd *cmd, unsigned char *buf)
 static int
 target_emulate_inquiry(struct se_cmd *cmd)
 {
-	struct se_device *dev = SE_DEV(cmd);
+	struct se_device *dev = cmd->se_lun->lun_se_dev;
 	unsigned char *buf = cmd->t_task->t_task_buf;
 	unsigned char *cdb = cmd->t_task->t_task_cdb;
 
@@ -665,7 +665,7 @@ target_emulate_inquiry(struct se_cmd *cmd)
 static int
 target_emulate_readcapacity(struct se_cmd *cmd)
 {
-	struct se_device *dev = SE_DEV(cmd);
+	struct se_device *dev = cmd->se_lun->lun_se_dev;
 	unsigned char *buf = cmd->t_task->t_task_buf;
 	unsigned long long blocks_long = dev->transport->get_blocks(dev);
 	u32 blocks;
@@ -679,14 +679,14 @@ target_emulate_readcapacity(struct se_cmd *cmd)
 	buf[1] = (blocks >> 16) & 0xff;
 	buf[2] = (blocks >> 8) & 0xff;
 	buf[3] = blocks & 0xff;
-	buf[4] = (DEV_ATTRIB(dev)->block_size >> 24) & 0xff;
-	buf[5] = (DEV_ATTRIB(dev)->block_size >> 16) & 0xff;
-	buf[6] = (DEV_ATTRIB(dev)->block_size >> 8) & 0xff;
-	buf[7] = DEV_ATTRIB(dev)->block_size & 0xff;
+	buf[4] = (dev->se_sub_dev->se_dev_attrib.block_size >> 24) & 0xff;
+	buf[5] = (dev->se_sub_dev->se_dev_attrib.block_size >> 16) & 0xff;
+	buf[6] = (dev->se_sub_dev->se_dev_attrib.block_size >> 8) & 0xff;
+	buf[7] = dev->se_sub_dev->se_dev_attrib.block_size & 0xff;
 	/*
 	 * Set max 32-bit blocks to signal SERVICE ACTION READ_CAPACITY_16
 	*/
-	if (DEV_ATTRIB(dev)->emulate_tpu || DEV_ATTRIB(dev)->emulate_tpws)
+	if (dev->se_sub_dev->se_dev_attrib.emulate_tpu || dev->se_sub_dev->se_dev_attrib.emulate_tpws)
 		put_unaligned_be32(0xFFFFFFFF, &buf[0]);
 
 	return 0;
@@ -695,7 +695,7 @@ target_emulate_readcapacity(struct se_cmd *cmd)
 static int
 target_emulate_readcapacity_16(struct se_cmd *cmd)
 {
-	struct se_device *dev = SE_DEV(cmd);
+	struct se_device *dev = cmd->se_lun->lun_se_dev;
 	unsigned char *buf = cmd->t_task->t_task_buf;
 	unsigned long long blocks = dev->transport->get_blocks(dev);
 
@@ -707,15 +707,15 @@ target_emulate_readcapacity_16(struct se_cmd *cmd)
 	buf[5] = (blocks >> 16) & 0xff;
 	buf[6] = (blocks >> 8) & 0xff;
 	buf[7] = blocks & 0xff;
-	buf[8] = (DEV_ATTRIB(dev)->block_size >> 24) & 0xff;
-	buf[9] = (DEV_ATTRIB(dev)->block_size >> 16) & 0xff;
-	buf[10] = (DEV_ATTRIB(dev)->block_size >> 8) & 0xff;
-	buf[11] = DEV_ATTRIB(dev)->block_size & 0xff;
+	buf[8] = (dev->se_sub_dev->se_dev_attrib.block_size >> 24) & 0xff;
+	buf[9] = (dev->se_sub_dev->se_dev_attrib.block_size >> 16) & 0xff;
+	buf[10] = (dev->se_sub_dev->se_dev_attrib.block_size >> 8) & 0xff;
+	buf[11] = dev->se_sub_dev->se_dev_attrib.block_size & 0xff;
 	/*
 	 * Set Thin Provisioning Enable bit following sbc3r22 in section
 	 * READ CAPACITY (16) byte 14 if emulate_tpu or emulate_tpws is enabled.
 	 */
-	if (DEV_ATTRIB(dev)->emulate_tpu || DEV_ATTRIB(dev)->emulate_tpws)
+	if (dev->se_sub_dev->se_dev_attrib.emulate_tpu || dev->se_sub_dev->se_dev_attrib.emulate_tpws)
 		buf[14] = 0x80;
 
 	return 0;
@@ -765,8 +765,8 @@ target_modesense_control(struct se_device *dev, unsigned char *p)
 	 * for a BUSY, TASK SET FULL, or RESERVATION CONFLICT status regardless
 	 * to the number of commands completed with one of those status codes.
 	 */
-	p[4] = (DEV_ATTRIB(dev)->emulate_ua_intlck_ctrl == 2) ? 0x30 :
-	       (DEV_ATTRIB(dev)->emulate_ua_intlck_ctrl == 1) ? 0x20 : 0x00;
+	p[4] = (dev->se_sub_dev->se_dev_attrib.emulate_ua_intlck_ctrl == 2) ? 0x30 :
+	       (dev->se_sub_dev->se_dev_attrib.emulate_ua_intlck_ctrl == 1) ? 0x20 : 0x00;
 	/*
 	 * From spc4r17, section 7.4.6 Control mode Page
 	 *
@@ -779,7 +779,7 @@ target_modesense_control(struct se_device *dev, unsigned char *p)
 	 * which the command was received shall be completed with TASK ABORTED
 	 * status (see SAM-4).
 	 */
-	p[5] = (DEV_ATTRIB(dev)->emulate_tas) ? 0x40 : 0x00;
+	p[5] = (dev->se_sub_dev->se_dev_attrib.emulate_tas) ? 0x40 : 0x00;
 	p[8] = 0xff;
 	p[9] = 0xff;
 	p[11] = 30;
@@ -792,7 +792,7 @@ target_modesense_caching(struct se_device *dev, unsigned char *p)
 {
 	p[0] = 0x08;
 	p[1] = 0x12;
-	if (DEV_ATTRIB(dev)->emulate_write_cache > 0)
+	if (dev->se_sub_dev->se_dev_attrib.emulate_write_cache > 0)
 		p[2] = 0x04; /* Write Cache Enable */
 	p[12] = 0x20; /* Disabled Read Ahead */
 
@@ -830,7 +830,7 @@ target_modesense_dpofua(unsigned char *buf, int type)
 static int
 target_emulate_modesense(struct se_cmd *cmd, int ten)
 {
-	struct se_device *dev = SE_DEV(cmd);
+	struct se_device *dev = cmd->se_lun->lun_se_dev;
 	char *cdb = cmd->t_task->t_task_cdb;
 	unsigned char *rbuf = cmd->t_task->t_task_buf;
 	int type = dev->transport->get_device_type(dev);
@@ -867,13 +867,13 @@ target_emulate_modesense(struct se_cmd *cmd, int ten)
 		buf[0] = (offset >> 8) & 0xff;
 		buf[1] = offset & 0xff;
 
-		if ((SE_LUN(cmd)->lun_access & TRANSPORT_LUNFLAGS_READ_ONLY) ||
+		if ((cmd->se_lun->lun_access & TRANSPORT_LUNFLAGS_READ_ONLY) ||
 		    (cmd->se_deve &&
 		    (cmd->se_deve->lun_flags & TRANSPORT_LUNFLAGS_READ_ONLY)))
 			target_modesense_write_protect(&buf[3], type);
 
-		if ((DEV_ATTRIB(dev)->emulate_write_cache > 0) &&
-		    (DEV_ATTRIB(dev)->emulate_fua_write > 0))
+		if ((dev->se_sub_dev->se_dev_attrib.emulate_write_cache > 0) &&
+		    (dev->se_sub_dev->se_dev_attrib.emulate_fua_write > 0))
 			target_modesense_dpofua(&buf[3], type);
 
 		if ((offset + 2) > cmd->data_length)
@@ -883,13 +883,13 @@ target_emulate_modesense(struct se_cmd *cmd, int ten)
 		offset -= 1;
 		buf[0] = offset & 0xff;
 
-		if ((SE_LUN(cmd)->lun_access & TRANSPORT_LUNFLAGS_READ_ONLY) ||
+		if ((cmd->se_lun->lun_access & TRANSPORT_LUNFLAGS_READ_ONLY) ||
 		    (cmd->se_deve &&
 		    (cmd->se_deve->lun_flags & TRANSPORT_LUNFLAGS_READ_ONLY)))
 			target_modesense_write_protect(&buf[2], type);
 
-		if ((DEV_ATTRIB(dev)->emulate_write_cache > 0) &&
-		    (DEV_ATTRIB(dev)->emulate_fua_write > 0))
+		if ((dev->se_sub_dev->se_dev_attrib.emulate_write_cache > 0) &&
+		    (dev->se_sub_dev->se_dev_attrib.emulate_fua_write > 0))
 			target_modesense_dpofua(&buf[2], type);
 
 		if ((offset + 1) > cmd->data_length)
@@ -963,8 +963,8 @@ target_emulate_request_sense(struct se_cmd *cmd)
 static int
 target_emulate_unmap(struct se_task *task)
 {
-	struct se_cmd *cmd = TASK_CMD(task);
-	struct se_device *dev = SE_DEV(cmd);
+	struct se_cmd *cmd = task->task_se_cmd;
+	struct se_device *dev = cmd->se_lun->lun_se_dev;
 	unsigned char *buf = cmd->t_task->t_task_buf, *ptr = NULL;
 	unsigned char *cdb = &cmd->t_task->t_task_cdb[0];
 	sector_t lba;
@@ -1010,13 +1010,13 @@ target_emulate_unmap(struct se_task *task)
 static int
 target_emulate_write_same(struct se_task *task)
 {
-	struct se_cmd *cmd = TASK_CMD(task);
-	struct se_device *dev = SE_DEV(cmd);
+	struct se_cmd *cmd = task->task_se_cmd;
+	struct se_device *dev = cmd->se_lun->lun_se_dev;
 	sector_t lba = cmd->t_task->t_task_lba;
 	unsigned int range;
 	int ret;
 
-	range = (cmd->data_length / DEV_ATTRIB(dev)->block_size);
+	range = (cmd->data_length / dev->se_sub_dev->se_dev_attrib.block_size);
 
 	printk(KERN_INFO "WRITE_SAME UNMAP: LBA: %llu Range: %u\n",
 			 (unsigned long long)lba, range);
@@ -1035,8 +1035,8 @@ target_emulate_write_same(struct se_task *task)
 int
 transport_emulate_control_cdb(struct se_task *task)
 {
-	struct se_cmd *cmd = TASK_CMD(task);
-	struct se_device *dev = SE_DEV(cmd);
+	struct se_cmd *cmd = task->task_se_cmd;
+	struct se_device *dev = cmd->se_lun->lun_se_dev;
 	unsigned short service_action;
 	int ret = 0;
 
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 8196b72..64418ef 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -625,7 +625,8 @@ static ssize_t target_core_dev_show_attr_##_name(			\
 		spin_unlock(&se_dev->se_dev_lock); 			\
 		return -ENODEV;						\
 	}								\
-	rb = snprintf(page, PAGE_SIZE, "%u\n", (u32)DEV_ATTRIB(dev)->_name); \
+	rb = snprintf(page, PAGE_SIZE, "%u\n",				\
+		(u32)dev->se_sub_dev->se_dev_attrib._name);		\
 	spin_unlock(&se_dev->se_dev_lock);				\
 									\
 	return rb;							\
@@ -1087,7 +1088,7 @@ static ssize_t target_core_dev_pr_show_spc3_res(
 				PR_REG_ISID_ID_LEN);
 
 	*len += sprintf(page + *len, "SPC-3 Reservation: %s Initiator: %s%s\n",
-		TPG_TFO(se_nacl->se_tpg)->get_fabric_name(),
+		se_nacl->se_tpg->se_tpg_tfo->get_fabric_name(),
 		se_nacl->initiatorname, (prf_isid) ? &i_buf[0] : "");
 	spin_unlock(&dev->dev_reservation_lock);
 
@@ -1109,7 +1110,7 @@ static ssize_t target_core_dev_pr_show_spc2_res(
 		return *len;
 	}
 	*len += sprintf(page + *len, "SPC-2 Reservation: %s Initiator: %s\n",
-		TPG_TFO(se_nacl->se_tpg)->get_fabric_name(),
+		se_nacl->se_tpg->se_tpg_tfo->get_fabric_name(),
 		se_nacl->initiatorname);
 	spin_unlock(&dev->dev_reservation_lock);
 
@@ -1125,7 +1126,7 @@ static ssize_t target_core_dev_pr_show_attr_res_holder(
 	if (!(su_dev->se_dev_ptr))
 		return -ENODEV;
 
-	switch (T10_RES(su_dev)->res_type) {
+	switch (su_dev->t10_pr.res_type) {
 	case SPC3_PERSISTENT_RESERVATIONS:
 		target_core_dev_pr_show_spc3_res(su_dev->se_dev_ptr,
 				page, &len);
@@ -1162,7 +1163,7 @@ static ssize_t target_core_dev_pr_show_attr_res_pr_all_tgt_pts(
 	if (!(dev))
 		return -ENODEV;
 
-	if (T10_RES(su_dev)->res_type != SPC3_PERSISTENT_RESERVATIONS)
+	if (su_dev->t10_pr.res_type != SPC3_PERSISTENT_RESERVATIONS)
 		return len;
 
 	spin_lock(&dev->dev_reservation_lock);
@@ -1199,10 +1200,10 @@ static ssize_t target_core_dev_pr_show_attr_res_pr_generation(
 	if (!(su_dev->se_dev_ptr))
 		return -ENODEV;
 
-	if (T10_RES(su_dev)->res_type != SPC3_PERSISTENT_RESERVATIONS)
+	if (su_dev->t10_pr.res_type != SPC3_PERSISTENT_RESERVATIONS)
 		return 0;
 
-	return sprintf(page, "0x%08x\n", T10_RES(su_dev)->pr_generation);
+	return sprintf(page, "0x%08x\n", su_dev->t10_pr.pr_generation);
 }
 
 SE_DEV_PR_ATTR_RO(res_pr_generation);
@@ -1226,7 +1227,7 @@ static ssize_t target_core_dev_pr_show_attr_res_pr_holder_tg_port(
 	if (!(dev))
 		return -ENODEV;
 
-	if (T10_RES(su_dev)->res_type != SPC3_PERSISTENT_RESERVATIONS)
+	if (su_dev->t10_pr.res_type != SPC3_PERSISTENT_RESERVATIONS)
 		return len;
 
 	spin_lock(&dev->dev_reservation_lock);
@@ -1239,7 +1240,7 @@ static ssize_t target_core_dev_pr_show_attr_res_pr_holder_tg_port(
 	se_nacl = pr_reg->pr_reg_nacl;
 	se_tpg = se_nacl->se_tpg;
 	lun = pr_reg->pr_reg_tg_pt_lun;
-	tfo = TPG_TFO(se_tpg);
+	tfo = se_tpg->se_tpg_tfo;
 
 	len += sprintf(page+len, "SPC-3 Reservation: %s"
 		" Target Node Endpoint: %s\n", tfo->get_fabric_name(),
@@ -1273,13 +1274,13 @@ static ssize_t target_core_dev_pr_show_attr_res_pr_registered_i_pts(
 	if (!(su_dev->se_dev_ptr))
 		return -ENODEV;
 
-	if (T10_RES(su_dev)->res_type != SPC3_PERSISTENT_RESERVATIONS)
+	if (su_dev->t10_pr.res_type != SPC3_PERSISTENT_RESERVATIONS)
 		return len;
 
 	len += sprintf(page+len, "SPC-3 PR Registrations:\n");
 
-	spin_lock(&T10_RES(su_dev)->registration_lock);
-	list_for_each_entry(pr_reg, &T10_RES(su_dev)->registration_list,
+	spin_lock(&su_dev->t10_pr.registration_lock);
+	list_for_each_entry(pr_reg, &su_dev->t10_pr.registration_list,
 			pr_reg_list) {
 
 		memset(buf, 0, 384);
@@ -1299,7 +1300,7 @@ static ssize_t target_core_dev_pr_show_attr_res_pr_registered_i_pts(
 		len += sprintf(page+len, "%s", buf);
 		reg_count++;
 	}
-	spin_unlock(&T10_RES(su_dev)->registration_lock);
+	spin_unlock(&su_dev->t10_pr.registration_lock);
 
 	if (!(reg_count))
 		len += sprintf(page+len, "None\n");
@@ -1324,7 +1325,7 @@ static ssize_t target_core_dev_pr_show_attr_res_pr_type(
 	if (!(dev))
 		return -ENODEV;
 
-	if (T10_RES(su_dev)->res_type != SPC3_PERSISTENT_RESERVATIONS)
+	if (su_dev->t10_pr.res_type != SPC3_PERSISTENT_RESERVATIONS)
 		return len;
 
 	spin_lock(&dev->dev_reservation_lock);
@@ -1355,7 +1356,7 @@ static ssize_t target_core_dev_pr_show_attr_res_type(
 	if (!(su_dev->se_dev_ptr))
 		return -ENODEV;
 
-	switch (T10_RES(su_dev)->res_type) {
+	switch (su_dev->t10_pr.res_type) {
 	case SPC3_PERSISTENT_RESERVATIONS:
 		len = sprintf(page, "SPC3_PERSISTENT_RESERVATIONS\n");
 		break;
@@ -1386,11 +1387,11 @@ static ssize_t target_core_dev_pr_show_attr_res_aptpl_active(
 	if (!(su_dev->se_dev_ptr))
 		return -ENODEV;
 
-	if (T10_RES(su_dev)->res_type != SPC3_PERSISTENT_RESERVATIONS)
+	if (su_dev->t10_pr.res_type != SPC3_PERSISTENT_RESERVATIONS)
 		return 0;
 
 	return sprintf(page, "APTPL Bit Status: %s\n",
-		(T10_RES(su_dev)->pr_aptpl_active) ? "Activated" : "Disabled");
+		(su_dev->t10_pr.pr_aptpl_active) ? "Activated" : "Disabled");
 }
 
 SE_DEV_PR_ATTR_RO(res_aptpl_active);
@@ -1405,7 +1406,7 @@ static ssize_t target_core_dev_pr_show_attr_res_aptpl_metadata(
 	if (!(su_dev->se_dev_ptr))
 		return -ENODEV;
 
-	if (T10_RES(su_dev)->res_type != SPC3_PERSISTENT_RESERVATIONS)
+	if (su_dev->t10_pr.res_type != SPC3_PERSISTENT_RESERVATIONS)
 		return 0;
 
 	return sprintf(page, "Ready to process PR APTPL metadata..\n");
@@ -1457,7 +1458,7 @@ static ssize_t target_core_dev_pr_store_attr_res_aptpl_metadata(
 	if (!(dev))
 		return -ENODEV;
 
-	if (T10_RES(su_dev)->res_type != SPC3_PERSISTENT_RESERVATIONS)
+	if (su_dev->t10_pr.res_type != SPC3_PERSISTENT_RESERVATIONS)
 		return 0;
 
 	if (atomic_read(&dev->dev_export_obj.obj_access_count)) {
@@ -1603,7 +1604,7 @@ static ssize_t target_core_dev_pr_store_attr_res_aptpl_metadata(
 		goto out;
 	}
 
-	ret = core_scsi3_alloc_aptpl_registration(T10_RES(su_dev), sa_res_key,
+	ret = core_scsi3_alloc_aptpl_registration(&su_dev->t10_pr, sa_res_key,
 			i_port, isid, mapped_lun, t_port, tpgt, target_lun,
 			res_holder, all_tg_pt, type);
 out:
@@ -1851,7 +1852,7 @@ static ssize_t target_core_show_alua_lu_gp(void *p, char *page)
 	if (!(dev))
 		return -ENODEV;
 
-	if (T10_ALUA(su_dev)->alua_type != SPC3_ALUA_EMULATED)
+	if (su_dev->t10_alua.alua_type != SPC3_ALUA_EMULATED)
 		return len;
 
 	lu_gp_mem = dev->dev_alua_lu_gp_mem;
@@ -1890,7 +1891,7 @@ static ssize_t target_core_store_alua_lu_gp(
 	if (!(dev))
 		return -ENODEV;
 
-	if (T10_ALUA(su_dev)->alua_type != SPC3_ALUA_EMULATED) {
+	if (su_dev->t10_alua.alua_type != SPC3_ALUA_EMULATED) {
 		printk(KERN_WARNING "SPC3_ALUA_EMULATED not enabled for %s/%s\n",
 			config_item_name(&hba->hba_group.cg_item),
 			config_item_name(&su_dev->se_dev_group.cg_item));
@@ -2566,9 +2567,9 @@ static ssize_t target_core_alua_tg_pt_gp_show_attr_members(
 		lun = port->sep_lun;
 
 		cur_len = snprintf(buf, TG_PT_GROUP_NAME_BUF, "%s/%s/tpgt_%hu"
-			"/%s\n", TPG_TFO(tpg)->get_fabric_name(),
-			TPG_TFO(tpg)->tpg_get_wwn(tpg),
-			TPG_TFO(tpg)->tpg_get_tag(tpg),
+			"/%s\n", tpg->se_tpg_tfo->get_fabric_name(),
+			tpg->se_tpg_tfo->tpg_get_wwn(tpg),
+			tpg->se_tpg_tfo->tpg_get_tag(tpg),
 			config_item_name(&lun->lun_group.cg_item));
 		cur_len++; /* Extra byte for NULL terminator */
 
@@ -2760,14 +2761,14 @@ static struct config_group *target_core_make_subdev(
 	INIT_LIST_HEAD(&se_dev->se_dev_node);
 	INIT_LIST_HEAD(&se_dev->t10_wwn.t10_vpd_list);
 	spin_lock_init(&se_dev->t10_wwn.t10_vpd_lock);
-	INIT_LIST_HEAD(&se_dev->t10_reservation.registration_list);
-	INIT_LIST_HEAD(&se_dev->t10_reservation.aptpl_reg_list);
-	spin_lock_init(&se_dev->t10_reservation.registration_lock);
-	spin_lock_init(&se_dev->t10_reservation.aptpl_reg_lock);
+	INIT_LIST_HEAD(&se_dev->t10_pr.registration_list);
+	INIT_LIST_HEAD(&se_dev->t10_pr.aptpl_reg_list);
+	spin_lock_init(&se_dev->t10_pr.registration_lock);
+	spin_lock_init(&se_dev->t10_pr.aptpl_reg_lock);
 	INIT_LIST_HEAD(&se_dev->t10_alua.tg_pt_gps_list);
 	spin_lock_init(&se_dev->t10_alua.tg_pt_gps_lock);
 	spin_lock_init(&se_dev->se_dev_lock);
-	se_dev->t10_reservation.pr_aptpl_buf_len = PR_APTPL_BUF_LEN;
+	se_dev->t10_pr.pr_aptpl_buf_len = PR_APTPL_BUF_LEN;
 	se_dev->t10_wwn.t10_sub_dev = se_dev;
 	se_dev->t10_alua.t10_sub_dev = se_dev;
 	se_dev->se_dev_attrib.da_sub_dev = se_dev;
@@ -2823,7 +2824,7 @@ static struct config_group *target_core_make_subdev(
 	if (!(tg_pt_gp))
 		goto out;
 
-	tg_pt_gp_cg = &T10_ALUA(se_dev)->alua_tg_pt_gps_group;
+	tg_pt_gp_cg = &se_dev->t10_alua.alua_tg_pt_gps_group;
 	tg_pt_gp_cg->default_groups = kzalloc(sizeof(struct config_group) * 2,
 				GFP_KERNEL);
 	if (!(tg_pt_gp_cg->default_groups)) {
@@ -2836,11 +2837,11 @@ static struct config_group *target_core_make_subdev(
 			"default_tg_pt_gp", &target_core_alua_tg_pt_gp_cit);
 	tg_pt_gp_cg->default_groups[0] = &tg_pt_gp->tg_pt_gp_group;
 	tg_pt_gp_cg->default_groups[1] = NULL;
-	T10_ALUA(se_dev)->default_tg_pt_gp = tg_pt_gp;
+	se_dev->t10_alua.default_tg_pt_gp = tg_pt_gp;
 	/*
 	 * Add core/$HBA/$DEV/statistics/ default groups
 	 */
-	dev_stat_grp = &DEV_STAT_GRP(se_dev)->stat_group;
+	dev_stat_grp = &se_dev->dev_stat_grps.stat_group;
 	dev_stat_grp->default_groups = kzalloc(sizeof(struct config_group) * 4,
 				GFP_KERNEL);
 	if (!dev_stat_grp->default_groups) {
@@ -2855,9 +2856,9 @@ static struct config_group *target_core_make_subdev(
 	mutex_unlock(&hba->hba_access_mutex);
 	return &se_dev->se_dev_group;
 out:
-	if (T10_ALUA(se_dev)->default_tg_pt_gp) {
-		core_alua_free_tg_pt_gp(T10_ALUA(se_dev)->default_tg_pt_gp);
-		T10_ALUA(se_dev)->default_tg_pt_gp = NULL;
+	if (se_dev->t10_alua.default_tg_pt_gp) {
+		core_alua_free_tg_pt_gp(se_dev->t10_alua.default_tg_pt_gp);
+		se_dev->t10_alua.default_tg_pt_gp = NULL;
 	}
 	if (dev_stat_grp)
 		kfree(dev_stat_grp->default_groups);
@@ -2894,7 +2895,7 @@ static void target_core_drop_subdev(
 	list_del(&se_dev->se_dev_node);
 	spin_unlock(&se_device_lock);
 
-	dev_stat_grp = &DEV_STAT_GRP(se_dev)->stat_group;
+	dev_stat_grp = &se_dev->dev_stat_grps.stat_group;
 	for (i = 0; dev_stat_grp->default_groups[i]; i++) {
 		df_item = &dev_stat_grp->default_groups[i]->cg_item;
 		dev_stat_grp->default_groups[i] = NULL;
@@ -2902,7 +2903,7 @@ static void target_core_drop_subdev(
 	}
 	kfree(dev_stat_grp->default_groups);
 
-	tg_pt_gp_cg = &T10_ALUA(se_dev)->alua_tg_pt_gps_group;
+	tg_pt_gp_cg = &se_dev->t10_alua.alua_tg_pt_gps_group;
 	for (i = 0; tg_pt_gp_cg->default_groups[i]; i++) {
 		df_item = &tg_pt_gp_cg->default_groups[i]->cg_item;
 		tg_pt_gp_cg->default_groups[i] = NULL;
@@ -2913,7 +2914,7 @@ static void target_core_drop_subdev(
 	 * core_alua_free_tg_pt_gp() is called from ->default_tg_pt_gp
 	 * directly from target_core_alua_tg_pt_gp_release().
 	 */
-	T10_ALUA(se_dev)->default_tg_pt_gp = NULL;
+	se_dev->t10_alua.default_tg_pt_gp = NULL;
 
 	dev_cg = &se_dev->se_dev_group;
 	for (i = 0; dev_cg->default_groups[i]; i++) {
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index ff57891..fd92385 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -65,7 +65,7 @@ int transport_get_lun_for_cmd(
 {
 	struct se_dev_entry *deve;
 	struct se_lun *se_lun = NULL;
-	struct se_session *se_sess = SE_SESS(se_cmd);
+	struct se_session *se_sess = se_cmd->se_sess;
 	unsigned long flags;
 	int read_only = 0;
 
@@ -75,9 +75,9 @@ int transport_get_lun_for_cmd(
 		return -ENODEV;
 	}
 
-	spin_lock_irq(&SE_NODE_ACL(se_sess)->device_list_lock);
+	spin_lock_irq(&se_sess->se_node_acl->device_list_lock);
 	deve = se_cmd->se_deve =
-			&SE_NODE_ACL(se_sess)->device_list[unpacked_lun];
+			&se_sess->se_node_acl->device_list[unpacked_lun];
 	if (deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS) {
 		if (se_cmd) {
 			deve->total_cmds++;
@@ -100,11 +100,11 @@ int transport_get_lun_for_cmd(
 		se_lun = se_cmd->se_lun = deve->se_lun;
 		se_cmd->pr_res_key = deve->pr_res_key;
 		se_cmd->orig_fe_lun = unpacked_lun;
-		se_cmd->se_orig_obj_ptr = SE_LUN(se_cmd)->lun_se_dev;
+		se_cmd->se_orig_obj_ptr = se_cmd->se_lun->lun_se_dev;
 		se_cmd->se_cmd_flags |= SCF_SE_LUN_CMD;
 	}
 out:
-	spin_unlock_irq(&SE_NODE_ACL(se_sess)->device_list_lock);
+	spin_unlock_irq(&se_sess->se_node_acl->device_list_lock);
 
 	if (!se_lun) {
 		if (read_only) {
@@ -112,7 +112,7 @@ out:
 			se_cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
 			printk("TARGET_CORE[%s]: Detected WRITE_PROTECTED LUN"
 				" Access for 0x%08x\n",
-				CMD_TFO(se_cmd)->get_fabric_name(),
+				se_cmd->se_tfo->get_fabric_name(),
 				unpacked_lun);
 			return -EACCES;
 		} else {
@@ -126,7 +126,7 @@ out:
 				se_cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
 				printk("TARGET_CORE[%s]: Detected NON_EXISTENT_LUN"
 					" Access for 0x%08x\n",
-					CMD_TFO(se_cmd)->get_fabric_name(),
+					se_cmd->se_tfo->get_fabric_name(),
 					unpacked_lun);
 				return -ENODEV;
 			}
@@ -141,11 +141,11 @@ out:
 			}
 #if 0
 			printk("TARGET_CORE[%s]: Using virtual LUN0! :-)\n",
-				CMD_TFO(se_cmd)->get_fabric_name());
+				se_cmd->se_tfo->get_fabric_name());
 #endif
 			se_lun = se_cmd->se_lun = &se_sess->se_tpg->tpg_virt_lun0;
 			se_cmd->orig_fe_lun = 0;
-			se_cmd->se_orig_obj_ptr = SE_LUN(se_cmd)->lun_se_dev;
+			se_cmd->se_orig_obj_ptr = se_cmd->se_lun->lun_se_dev;
 			se_cmd->se_cmd_flags |= SCF_SE_LUN_CMD;
 		}
 	}
@@ -176,10 +176,10 @@ out:
 	 */
 	spin_lock_irqsave(&se_lun->lun_cmd_lock, flags);
 	list_add_tail(&se_cmd->se_lun_list, &se_lun->lun_cmd_list);
-	atomic_set(&T_TASK(se_cmd)->transport_lun_active, 1);
+	atomic_set(&se_cmd->t_task->transport_lun_active, 1);
 #if 0
 	printk(KERN_INFO "Adding ITT: 0x%08x to LUN LIST[%d]\n",
-		CMD_TFO(se_cmd)->get_task_tag(se_cmd), se_lun->unpacked_lun);
+		se_cmd->se_tfo->get_task_tag(se_cmd), se_lun->unpacked_lun);
 #endif
 	spin_unlock_irqrestore(&se_lun->lun_cmd_lock, flags);
 
@@ -194,7 +194,7 @@ int transport_get_lun_for_tmr(
 	struct se_device *dev = NULL;
 	struct se_dev_entry *deve;
 	struct se_lun *se_lun = NULL;
-	struct se_session *se_sess = SE_SESS(se_cmd);
+	struct se_session *se_sess = se_cmd->se_sess;
 	struct se_tmr_req *se_tmr = se_cmd->se_tmr_req;
 
 	if (unpacked_lun >= TRANSPORT_MAX_LUNS_PER_TPG) {
@@ -203,23 +203,23 @@ int transport_get_lun_for_tmr(
 		return -ENODEV;
 	}
 
-	spin_lock_irq(&SE_NODE_ACL(se_sess)->device_list_lock);
+	spin_lock_irq(&se_sess->se_node_acl->device_list_lock);
 	deve = se_cmd->se_deve =
-			&SE_NODE_ACL(se_sess)->device_list[unpacked_lun];
+			&se_sess->se_node_acl->device_list[unpacked_lun];
 	if (deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS) {
 		se_lun = se_cmd->se_lun = se_tmr->tmr_lun = deve->se_lun;
 		dev = se_lun->lun_se_dev;
 		se_cmd->pr_res_key = deve->pr_res_key;
 		se_cmd->orig_fe_lun = unpacked_lun;
-		se_cmd->se_orig_obj_ptr = SE_LUN(se_cmd)->lun_se_dev;
+		se_cmd->se_orig_obj_ptr = se_cmd->se_lun->lun_se_dev;
 /*		se_cmd->se_cmd_flags |= SCF_SE_LUN_CMD; */
 	}
-	spin_unlock_irq(&SE_NODE_ACL(se_sess)->device_list_lock);
+	spin_unlock_irq(&se_sess->se_node_acl->device_list_lock);
 
 	if (!se_lun) {
 		printk(KERN_INFO "TARGET_CORE[%s]: Detected NON_EXISTENT_LUN"
 			" Access for 0x%08x\n",
-			CMD_TFO(se_cmd)->get_fabric_name(),
+			se_cmd->se_tfo->get_fabric_name(),
 			unpacked_lun);
 		se_cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
 		return -ENODEV;
@@ -268,14 +268,14 @@ struct se_dev_entry *core_get_se_deve_from_rtpi(
 		if (!(lun)) {
 			printk(KERN_ERR "%s device entries device pointer is"
 				" NULL, but Initiator has access.\n",
-				TPG_TFO(tpg)->get_fabric_name());
+				tpg->se_tpg_tfo->get_fabric_name());
 			continue;
 		}
 		port = lun->lun_sep;
 		if (!(port)) {
 			printk(KERN_ERR "%s device entries device pointer is"
 				" NULL, but Initiator has access.\n",
-				TPG_TFO(tpg)->get_fabric_name());
+				tpg->se_tpg_tfo->get_fabric_name());
 			continue;
 		}
 		if (port->sep_rtpi != rtpi)
@@ -313,7 +313,7 @@ int core_free_device_list_for_node(
 		if (!deve->se_lun) {
 			printk(KERN_ERR "%s device entries device pointer is"
 				" NULL, but Initiator has access.\n",
-				TPG_TFO(tpg)->get_fabric_name());
+				tpg->se_tpg_tfo->get_fabric_name());
 			continue;
 		}
 		lun = deve->se_lun;
@@ -564,7 +564,7 @@ static void core_export_port(
 	struct se_port *port,
 	struct se_lun *lun)
 {
-	struct se_subsystem_dev *su_dev = SU_DEV(dev);
+	struct se_subsystem_dev *su_dev = dev->se_sub_dev;
 	struct t10_alua_tg_pt_gp_member *tg_pt_gp_mem = NULL;
 
 	spin_lock(&dev->se_port_lock);
@@ -577,7 +577,7 @@ static void core_export_port(
 	list_add_tail(&port->sep_list, &dev->dev_sep_list);
 	spin_unlock(&dev->se_port_lock);
 
-	if (T10_ALUA(su_dev)->alua_type == SPC3_ALUA_EMULATED) {
+	if (su_dev->t10_alua.alua_type == SPC3_ALUA_EMULATED) {
 		tg_pt_gp_mem = core_alua_allocate_tg_pt_gp_mem(port);
 		if (IS_ERR(tg_pt_gp_mem) || !tg_pt_gp_mem) {
 			printk(KERN_ERR "Unable to allocate t10_alua_tg_pt"
@@ -586,11 +586,11 @@ static void core_export_port(
 		}
 		spin_lock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
 		__core_alua_attach_tg_pt_gp_mem(tg_pt_gp_mem,
-			T10_ALUA(su_dev)->default_tg_pt_gp);
+			su_dev->t10_alua.default_tg_pt_gp);
 		spin_unlock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
 		printk(KERN_INFO "%s/%s: Adding to default ALUA Target Port"
 			" Group: alua/default_tg_pt_gp\n",
-			TRANSPORT(dev)->name, TPG_TFO(tpg)->get_fabric_name());
+			dev->transport->name, tpg->se_tpg_tfo->get_fabric_name());
 	}
 
 	dev->dev_port_count++;
@@ -665,12 +665,12 @@ int transport_core_report_lun_response(struct se_cmd *se_cmd)
 {
 	struct se_dev_entry *deve;
 	struct se_lun *se_lun;
-	struct se_session *se_sess = SE_SESS(se_cmd);
+	struct se_session *se_sess = se_cmd->se_sess;
 	struct se_task *se_task;
-	unsigned char *buf = (unsigned char *)T_TASK(se_cmd)->t_task_buf;
+	unsigned char *buf = se_cmd->t_task->t_task_buf;
 	u32 cdb_offset = 0, lun_count = 0, offset = 8, i;
 
-	list_for_each_entry(se_task, &T_TASK(se_cmd)->t_task_list, t_list)
+	list_for_each_entry(se_task, &se_cmd->t_task->t_task_list, t_list)
 		break;
 
 	if (!(se_task)) {
@@ -689,9 +689,9 @@ int transport_core_report_lun_response(struct se_cmd *se_cmd)
 		goto done;
 	}
 
-	spin_lock_irq(&SE_NODE_ACL(se_sess)->device_list_lock);
+	spin_lock_irq(&se_sess->se_node_acl->device_list_lock);
 	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
-		deve = &SE_NODE_ACL(se_sess)->device_list[i];
+		deve = &se_sess->se_node_acl->device_list[i];
 		if (!(deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS))
 			continue;
 		se_lun = deve->se_lun;
@@ -708,7 +708,7 @@ int transport_core_report_lun_response(struct se_cmd *se_cmd)
 		offset += 8;
 		cdb_offset += 8;
 	}
-	spin_unlock_irq(&SE_NODE_ACL(se_sess)->device_list_lock);
+	spin_unlock_irq(&se_sess->se_node_acl->device_list_lock);
 
 	/*
 	 * See SPC3 r07, page 159.
@@ -759,13 +759,13 @@ void se_release_vpd_for_dev(struct se_device *dev)
 {
 	struct t10_vpd *vpd, *vpd_tmp;
 
-	spin_lock(&DEV_T10_WWN(dev)->t10_vpd_lock);
+	spin_lock(&dev->se_sub_dev->t10_wwn.t10_vpd_lock);
 	list_for_each_entry_safe(vpd, vpd_tmp,
-			&DEV_T10_WWN(dev)->t10_vpd_list, vpd_list) {
+			&dev->se_sub_dev->t10_wwn.t10_vpd_list, vpd_list) {
 		list_del(&vpd->vpd_list);
 		kfree(vpd);
 	}
-	spin_unlock(&DEV_T10_WWN(dev)->t10_vpd_lock);
+	spin_unlock(&dev->se_sub_dev->t10_wwn.t10_vpd_lock);
 }
 
 /*	se_free_virtual_device():
@@ -851,48 +851,48 @@ void se_dev_set_default_attribs(
 {
 	struct queue_limits *limits = &dev_limits->limits;
 
-	DEV_ATTRIB(dev)->emulate_dpo = DA_EMULATE_DPO;
-	DEV_ATTRIB(dev)->emulate_fua_write = DA_EMULATE_FUA_WRITE;
-	DEV_ATTRIB(dev)->emulate_fua_read = DA_EMULATE_FUA_READ;
-	DEV_ATTRIB(dev)->emulate_write_cache = DA_EMULATE_WRITE_CACHE;
-	DEV_ATTRIB(dev)->emulate_ua_intlck_ctrl = DA_EMULATE_UA_INTLLCK_CTRL;
-	DEV_ATTRIB(dev)->emulate_tas = DA_EMULATE_TAS;
-	DEV_ATTRIB(dev)->emulate_tpu = DA_EMULATE_TPU;
-	DEV_ATTRIB(dev)->emulate_tpws = DA_EMULATE_TPWS;
-	DEV_ATTRIB(dev)->emulate_reservations = DA_EMULATE_RESERVATIONS;
-	DEV_ATTRIB(dev)->emulate_alua = DA_EMULATE_ALUA;
-	DEV_ATTRIB(dev)->enforce_pr_isids = DA_ENFORCE_PR_ISIDS;
+	dev->se_sub_dev->se_dev_attrib.emulate_dpo = DA_EMULATE_DPO;
+	dev->se_sub_dev->se_dev_attrib.emulate_fua_write = DA_EMULATE_FUA_WRITE;
+	dev->se_sub_dev->se_dev_attrib.emulate_fua_read = DA_EMULATE_FUA_READ;
+	dev->se_sub_dev->se_dev_attrib.emulate_write_cache = DA_EMULATE_WRITE_CACHE;
+	dev->se_sub_dev->se_dev_attrib.emulate_ua_intlck_ctrl = DA_EMULATE_UA_INTLLCK_CTRL;
+	dev->se_sub_dev->se_dev_attrib.emulate_tas = DA_EMULATE_TAS;
+	dev->se_sub_dev->se_dev_attrib.emulate_tpu = DA_EMULATE_TPU;
+	dev->se_sub_dev->se_dev_attrib.emulate_tpws = DA_EMULATE_TPWS;
+	dev->se_sub_dev->se_dev_attrib.emulate_reservations = DA_EMULATE_RESERVATIONS;
+	dev->se_sub_dev->se_dev_attrib.emulate_alua = DA_EMULATE_ALUA;
+	dev->se_sub_dev->se_dev_attrib.enforce_pr_isids = DA_ENFORCE_PR_ISIDS;
 	/*
 	 * The TPU=1 and TPWS=1 settings will be set in TCM/IBLOCK
 	 * iblock_create_virtdevice() from struct queue_limits values
 	 * if blk_queue_discard()==1
 	 */
-	DEV_ATTRIB(dev)->max_unmap_lba_count = DA_MAX_UNMAP_LBA_COUNT;
-	DEV_ATTRIB(dev)->max_unmap_block_desc_count =
-				DA_MAX_UNMAP_BLOCK_DESC_COUNT;
-	DEV_ATTRIB(dev)->unmap_granularity = DA_UNMAP_GRANULARITY_DEFAULT;
-	DEV_ATTRIB(dev)->unmap_granularity_alignment =
+	dev->se_sub_dev->se_dev_attrib.max_unmap_lba_count = DA_MAX_UNMAP_LBA_COUNT;
+	dev->se_sub_dev->se_dev_attrib.max_unmap_block_desc_count =
+		DA_MAX_UNMAP_BLOCK_DESC_COUNT;
+	dev->se_sub_dev->se_dev_attrib.unmap_granularity = DA_UNMAP_GRANULARITY_DEFAULT;
+	dev->se_sub_dev->se_dev_attrib.unmap_granularity_alignment =
 				DA_UNMAP_GRANULARITY_ALIGNMENT_DEFAULT;
 	/*
 	 * block_size is based on subsystem plugin dependent requirements.
 	 */
-	DEV_ATTRIB(dev)->hw_block_size = limits->logical_block_size;
-	DEV_ATTRIB(dev)->block_size = limits->logical_block_size;
+	dev->se_sub_dev->se_dev_attrib.hw_block_size = limits->logical_block_size;
+	dev->se_sub_dev->se_dev_attrib.block_size = limits->logical_block_size;
 	/*
 	 * max_sectors is based on subsystem plugin dependent requirements.
 	 */
-	DEV_ATTRIB(dev)->hw_max_sectors = limits->max_hw_sectors;
-	DEV_ATTRIB(dev)->max_sectors = limits->max_sectors;
+	dev->se_sub_dev->se_dev_attrib.hw_max_sectors = limits->max_hw_sectors;
+	dev->se_sub_dev->se_dev_attrib.max_sectors = limits->max_sectors;
 	/*
 	 * Set optimal_sectors from max_sectors, which can be lowered via
 	 * configfs.
 	 */
-	DEV_ATTRIB(dev)->optimal_sectors = limits->max_sectors;
+	dev->se_sub_dev->se_dev_attrib.optimal_sectors = limits->max_sectors;
 	/*
 	 * queue_depth is based on subsystem plugin dependent requirements.
 	 */
-	DEV_ATTRIB(dev)->hw_queue_depth = dev_limits->hw_queue_depth;
-	DEV_ATTRIB(dev)->queue_depth = dev_limits->queue_depth;
+	dev->se_sub_dev->se_dev_attrib.hw_queue_depth = dev_limits->hw_queue_depth;
+	dev->se_sub_dev->se_dev_attrib.queue_depth = dev_limits->queue_depth;
 }
 
 int se_dev_set_task_timeout(struct se_device *dev, u32 task_timeout)
@@ -902,7 +902,7 @@ int se_dev_set_task_timeout(struct se_device *dev, u32 task_timeout)
 			" DA_TASK_TIMEOUT_MAX\n", dev, task_timeout);
 		return -EINVAL;
 	} else {
-		DEV_ATTRIB(dev)->task_timeout = task_timeout;
+		dev->se_sub_dev->se_dev_attrib.task_timeout = task_timeout;
 		printk(KERN_INFO "dev[%p]: Set SE Device task_timeout: %u\n",
 			dev, task_timeout);
 	}
@@ -914,9 +914,9 @@ int se_dev_set_max_unmap_lba_count(
 	struct se_device *dev,
 	u32 max_unmap_lba_count)
 {
-	DEV_ATTRIB(dev)->max_unmap_lba_count = max_unmap_lba_count;
+	dev->se_sub_dev->se_dev_attrib.max_unmap_lba_count = max_unmap_lba_count;
 	printk(KERN_INFO "dev[%p]: Set max_unmap_lba_count: %u\n",
-			dev, DEV_ATTRIB(dev)->max_unmap_lba_count);
+			dev, dev->se_sub_dev->se_dev_attrib.max_unmap_lba_count);
 	return 0;
 }
 
@@ -924,9 +924,10 @@ int se_dev_set_max_unmap_block_desc_count(
 	struct se_device *dev,
 	u32 max_unmap_block_desc_count)
 {
-	DEV_ATTRIB(dev)->max_unmap_block_desc_count = max_unmap_block_desc_count;
+	dev->se_sub_dev->se_dev_attrib.max_unmap_block_desc_count =
+		max_unmap_block_desc_count;
 	printk(KERN_INFO "dev[%p]: Set max_unmap_block_desc_count: %u\n",
-			dev, DEV_ATTRIB(dev)->max_unmap_block_desc_count);
+			dev, dev->se_sub_dev->se_dev_attrib.max_unmap_block_desc_count);
 	return 0;
 }
 
@@ -934,9 +935,9 @@ int se_dev_set_unmap_granularity(
 	struct se_device *dev,
 	u32 unmap_granularity)
 {
-	DEV_ATTRIB(dev)->unmap_granularity = unmap_granularity;
+	dev->se_sub_dev->se_dev_attrib.unmap_granularity = unmap_granularity;
 	printk(KERN_INFO "dev[%p]: Set unmap_granularity: %u\n",
-			dev, DEV_ATTRIB(dev)->unmap_granularity);
+			dev, dev->se_sub_dev->se_dev_attrib.unmap_granularity);
 	return 0;
 }
 
@@ -944,9 +945,9 @@ int se_dev_set_unmap_granularity_alignment(
 	struct se_device *dev,
 	u32 unmap_granularity_alignment)
 {
-	DEV_ATTRIB(dev)->unmap_granularity_alignment = unmap_granularity_alignment;
+	dev->se_sub_dev->se_dev_attrib.unmap_granularity_alignment = unmap_granularity_alignment;
 	printk(KERN_INFO "dev[%p]: Set unmap_granularity_alignment: %u\n",
-			dev, DEV_ATTRIB(dev)->unmap_granularity_alignment);
+			dev, dev->se_sub_dev->se_dev_attrib.unmap_granularity_alignment);
 	return 0;
 }
 
@@ -956,17 +957,17 @@ int se_dev_set_emulate_dpo(struct se_device *dev, int flag)
 		printk(KERN_ERR "Illegal value %d\n", flag);
 		return -EINVAL;
 	}
-	if (TRANSPORT(dev)->dpo_emulated == NULL) {
-		printk(KERN_ERR "TRANSPORT(dev)->dpo_emulated is NULL\n");
+	if (dev->transport->dpo_emulated == NULL) {
+		printk(KERN_ERR "dev->transport->dpo_emulated is NULL\n");
 		return -EINVAL;
 	}
-	if (TRANSPORT(dev)->dpo_emulated(dev) == 0) {
-		printk(KERN_ERR "TRANSPORT(dev)->dpo_emulated not supported\n");
+	if (dev->transport->dpo_emulated(dev) == 0) {
+		printk(KERN_ERR "dev->transport->dpo_emulated not supported\n");
 		return -EINVAL;
 	}
-	DEV_ATTRIB(dev)->emulate_dpo = flag;
+	dev->se_sub_dev->se_dev_attrib.emulate_dpo = flag;
 	printk(KERN_INFO "dev[%p]: SE Device Page Out (DPO) Emulation"
-			" bit: %d\n", dev, DEV_ATTRIB(dev)->emulate_dpo);
+			" bit: %d\n", dev, dev->se_sub_dev->se_dev_attrib.emulate_dpo);
 	return 0;
 }
 
@@ -976,17 +977,17 @@ int se_dev_set_emulate_fua_write(struct se_device *dev, int flag)
 		printk(KERN_ERR "Illegal value %d\n", flag);
 		return -EINVAL;
 	}
-	if (TRANSPORT(dev)->fua_write_emulated == NULL) {
-		printk(KERN_ERR "TRANSPORT(dev)->fua_write_emulated is NULL\n");
+	if (dev->transport->fua_write_emulated == NULL) {
+		printk(KERN_ERR "dev->transport->fua_write_emulated is NULL\n");
 		return -EINVAL;
 	}
-	if (TRANSPORT(dev)->fua_write_emulated(dev) == 0) {
-		printk(KERN_ERR "TRANSPORT(dev)->fua_write_emulated not supported\n");
+	if (dev->transport->fua_write_emulated(dev) == 0) {
+		printk(KERN_ERR "dev->transport->fua_write_emulated not supported\n");
 		return -EINVAL;
 	}
-	DEV_ATTRIB(dev)->emulate_fua_write = flag;
+	dev->se_sub_dev->se_dev_attrib.emulate_fua_write = flag;
 	printk(KERN_INFO "dev[%p]: SE Device Forced Unit Access WRITEs: %d\n",
-			dev, DEV_ATTRIB(dev)->emulate_fua_write);
+			dev, dev->se_sub_dev->se_dev_attrib.emulate_fua_write);
 	return 0;
 }
 
@@ -996,17 +997,17 @@ int se_dev_set_emulate_fua_read(struct se_device *dev, int flag)
 		printk(KERN_ERR "Illegal value %d\n", flag);
 		return -EINVAL;
 	}
-	if (TRANSPORT(dev)->fua_read_emulated == NULL) {
-		printk(KERN_ERR "TRANSPORT(dev)->fua_read_emulated is NULL\n");
+	if (dev->transport->fua_read_emulated == NULL) {
+		printk(KERN_ERR "dev->transport->fua_read_emulated is NULL\n");
 		return -EINVAL;
 	}
-	if (TRANSPORT(dev)->fua_read_emulated(dev) == 0) {
-		printk(KERN_ERR "TRANSPORT(dev)->fua_read_emulated not supported\n");
+	if (dev->transport->fua_read_emulated(dev) == 0) {
+		printk(KERN_ERR "dev->transport->fua_read_emulated not supported\n");
 		return -EINVAL;
 	}
-	DEV_ATTRIB(dev)->emulate_fua_read = flag;
+	dev->se_sub_dev->se_dev_attrib.emulate_fua_read = flag;
 	printk(KERN_INFO "dev[%p]: SE Device Forced Unit Access READs: %d\n",
-			dev, DEV_ATTRIB(dev)->emulate_fua_read);
+			dev, dev->se_sub_dev->se_dev_attrib.emulate_fua_read);
 	return 0;
 }
 
@@ -1016,17 +1017,17 @@ int se_dev_set_emulate_write_cache(struct se_device *dev, int flag)
 		printk(KERN_ERR "Illegal value %d\n", flag);
 		return -EINVAL;
 	}
-	if (TRANSPORT(dev)->write_cache_emulated == NULL) {
-		printk(KERN_ERR "TRANSPORT(dev)->write_cache_emulated is NULL\n");
+	if (dev->transport->write_cache_emulated == NULL) {
+		printk(KERN_ERR "dev->transport->write_cache_emulated is NULL\n");
 		return -EINVAL;
 	}
-	if (TRANSPORT(dev)->write_cache_emulated(dev) == 0) {
-		printk(KERN_ERR "TRANSPORT(dev)->write_cache_emulated not supported\n");
+	if (dev->transport->write_cache_emulated(dev) == 0) {
+		printk(KERN_ERR "dev->transport->write_cache_emulated not supported\n");
 		return -EINVAL;
 	}
-	DEV_ATTRIB(dev)->emulate_write_cache = flag;
+	dev->se_sub_dev->se_dev_attrib.emulate_write_cache = flag;
 	printk(KERN_INFO "dev[%p]: SE Device WRITE_CACHE_EMULATION flag: %d\n",
-			dev, DEV_ATTRIB(dev)->emulate_write_cache);
+			dev, dev->se_sub_dev->se_dev_attrib.emulate_write_cache);
 	return 0;
 }
 
@@ -1044,9 +1045,9 @@ int se_dev_set_emulate_ua_intlck_ctrl(struct se_device *dev, int flag)
 			atomic_read(&dev->dev_export_obj.obj_access_count));
 		return -EINVAL;
 	}
-	DEV_ATTRIB(dev)->emulate_ua_intlck_ctrl = flag;
+	dev->se_sub_dev->se_dev_attrib.emulate_ua_intlck_ctrl = flag;
 	printk(KERN_INFO "dev[%p]: SE Device UA_INTRLCK_CTRL flag: %d\n",
-		dev, DEV_ATTRIB(dev)->emulate_ua_intlck_ctrl);
+		dev, dev->se_sub_dev->se_dev_attrib.emulate_ua_intlck_ctrl);
 
 	return 0;
 }
@@ -1064,9 +1065,9 @@ int se_dev_set_emulate_tas(struct se_device *dev, int flag)
 			atomic_read(&dev->dev_export_obj.obj_access_count));
 		return -EINVAL;
 	}
-	DEV_ATTRIB(dev)->emulate_tas = flag;
+	dev->se_sub_dev->se_dev_attrib.emulate_tas = flag;
 	printk(KERN_INFO "dev[%p]: SE Device TASK_ABORTED status bit: %s\n",
-		dev, (DEV_ATTRIB(dev)->emulate_tas) ? "Enabled" : "Disabled");
+		dev, (dev->se_sub_dev->se_dev_attrib.emulate_tas) ? "Enabled" : "Disabled");
 
 	return 0;
 }
@@ -1081,12 +1082,12 @@ int se_dev_set_emulate_tpu(struct se_device *dev, int flag)
 	 * We expect this value to be non-zero when generic Block Layer
 	 * Discard supported is detected iblock_create_virtdevice().
 	 */
-	if (!(DEV_ATTRIB(dev)->max_unmap_block_desc_count)) {
+	if (!(dev->se_sub_dev->se_dev_attrib.max_unmap_block_desc_count)) {
 		printk(KERN_ERR "Generic Block Discard not supported\n");
 		return -ENOSYS;
 	}
 
-	DEV_ATTRIB(dev)->emulate_tpu = flag;
+	dev->se_sub_dev->se_dev_attrib.emulate_tpu = flag;
 	printk(KERN_INFO "dev[%p]: SE Device Thin Provisioning UNMAP bit: %d\n",
 				dev, flag);
 	return 0;
@@ -1102,12 +1103,12 @@ int se_dev_set_emulate_tpws(struct se_device *dev, int flag)
 	 * We expect this value to be non-zero when generic Block Layer
 	 * Discard supported is detected iblock_create_virtdevice().
 	 */
-	if (!(DEV_ATTRIB(dev)->max_unmap_block_desc_count)) {
+	if (!(dev->se_sub_dev->se_dev_attrib.max_unmap_block_desc_count)) {
 		printk(KERN_ERR "Generic Block Discard not supported\n");
 		return -ENOSYS;
 	}
 
-	DEV_ATTRIB(dev)->emulate_tpws = flag;
+	dev->se_sub_dev->se_dev_attrib.emulate_tpws = flag;
 	printk(KERN_INFO "dev[%p]: SE Device Thin Provisioning WRITE_SAME: %d\n",
 				dev, flag);
 	return 0;
@@ -1119,9 +1120,9 @@ int se_dev_set_enforce_pr_isids(struct se_device *dev, int flag)
 		printk(KERN_ERR "Illegal value %d\n", flag);
 		return -EINVAL;
 	}
-	DEV_ATTRIB(dev)->enforce_pr_isids = flag;
+	dev->se_sub_dev->se_dev_attrib.enforce_pr_isids = flag;
 	printk(KERN_INFO "dev[%p]: SE Device enforce_pr_isids bit: %s\n", dev,
-		(DEV_ATTRIB(dev)->enforce_pr_isids) ? "Enabled" : "Disabled");
+		(dev->se_sub_dev->se_dev_attrib.enforce_pr_isids) ? "Enabled" : "Disabled");
 	return 0;
 }
 
@@ -1144,27 +1145,27 @@ int se_dev_set_queue_depth(struct se_device *dev, u32 queue_depth)
 		return -EINVAL;
 	}
 
-	if (TRANSPORT(dev)->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV) {
-		if (queue_depth > DEV_ATTRIB(dev)->hw_queue_depth) {
+	if (dev->transport->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV) {
+		if (queue_depth > dev->se_sub_dev->se_dev_attrib.hw_queue_depth) {
 			printk(KERN_ERR "dev[%p]: Passed queue_depth: %u"
 				" exceeds TCM/SE_Device TCQ: %u\n",
 				dev, queue_depth,
-				DEV_ATTRIB(dev)->hw_queue_depth);
+				dev->se_sub_dev->se_dev_attrib.hw_queue_depth);
 			return -EINVAL;
 		}
 	} else {
-		if (queue_depth > DEV_ATTRIB(dev)->queue_depth) {
-			if (queue_depth > DEV_ATTRIB(dev)->hw_queue_depth) {
+		if (queue_depth > dev->se_sub_dev->se_dev_attrib.queue_depth) {
+			if (queue_depth > dev->se_sub_dev->se_dev_attrib.hw_queue_depth) {
 				printk(KERN_ERR "dev[%p]: Passed queue_depth:"
 					" %u exceeds TCM/SE_Device MAX"
 					" TCQ: %u\n", dev, queue_depth,
-					DEV_ATTRIB(dev)->hw_queue_depth);
+					dev->se_sub_dev->se_dev_attrib.hw_queue_depth);
 				return -EINVAL;
 			}
 		}
 	}
 
-	DEV_ATTRIB(dev)->queue_depth = dev->queue_depth = queue_depth;
+	dev->se_sub_dev->se_dev_attrib.queue_depth = dev->queue_depth = queue_depth;
 	if (queue_depth > orig_queue_depth)
 		atomic_add(queue_depth - orig_queue_depth, &dev->depth_left);
 	else if (queue_depth < orig_queue_depth)
@@ -1196,21 +1197,21 @@ int se_dev_set_max_sectors(struct se_device *dev, u32 max_sectors)
 				DA_STATUS_MAX_SECTORS_MIN);
 		return -EINVAL;
 	}
-	if (TRANSPORT(dev)->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV) {
-		if (max_sectors > DEV_ATTRIB(dev)->hw_max_sectors) {
+	if (dev->transport->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV) {
+		if (max_sectors > dev->se_sub_dev->se_dev_attrib.hw_max_sectors) {
 			printk(KERN_ERR "dev[%p]: Passed max_sectors: %u"
 				" greater than TCM/SE_Device max_sectors:"
 				" %u\n", dev, max_sectors,
-				DEV_ATTRIB(dev)->hw_max_sectors);
+				dev->se_sub_dev->se_dev_attrib.hw_max_sectors);
 			 return -EINVAL;
 		}
 	} else {
 		if (!(force) && (max_sectors >
-				 DEV_ATTRIB(dev)->hw_max_sectors)) {
+				 dev->se_sub_dev->se_dev_attrib.hw_max_sectors)) {
 			printk(KERN_ERR "dev[%p]: Passed max_sectors: %u"
 				" greater than TCM/SE_Device max_sectors"
 				": %u, use force=1 to override.\n", dev,
-				max_sectors, DEV_ATTRIB(dev)->hw_max_sectors);
+				max_sectors, dev->se_sub_dev->se_dev_attrib.hw_max_sectors);
 			return -EINVAL;
 		}
 		if (max_sectors > DA_STATUS_MAX_SECTORS_MAX) {
@@ -1222,7 +1223,7 @@ int se_dev_set_max_sectors(struct se_device *dev, u32 max_sectors)
 		}
 	}
 
-	DEV_ATTRIB(dev)->max_sectors = max_sectors;
+	dev->se_sub_dev->se_dev_attrib.max_sectors = max_sectors;
 	printk("dev[%p]: SE Device max_sectors changed to %u\n",
 			dev, max_sectors);
 	return 0;
@@ -1236,19 +1237,19 @@ int se_dev_set_optimal_sectors(struct se_device *dev, u32 optimal_sectors)
 			dev, atomic_read(&dev->dev_export_obj.obj_access_count));
 		return -EINVAL;
 	}
-	if (TRANSPORT(dev)->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV) {
+	if (dev->transport->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV) {
 		printk(KERN_ERR "dev[%p]: Passed optimal_sectors cannot be"
 				" changed for TCM/pSCSI\n", dev);
 		return -EINVAL;
 	}
-	if (optimal_sectors > DEV_ATTRIB(dev)->max_sectors) {
+	if (optimal_sectors > dev->se_sub_dev->se_dev_attrib.max_sectors) {
 		printk(KERN_ERR "dev[%p]: Passed optimal_sectors %u cannot be"
 			" greater than max_sectors: %u\n", dev,
-			optimal_sectors, DEV_ATTRIB(dev)->max_sectors);
+			optimal_sectors, dev->se_sub_dev->se_dev_attrib.max_sectors);
 		return -EINVAL;
 	}
 
-	DEV_ATTRIB(dev)->optimal_sectors = optimal_sectors;
+	dev->se_sub_dev->se_dev_attrib.optimal_sectors = optimal_sectors;
 	printk(KERN_INFO "dev[%p]: SE Device optimal_sectors changed to %u\n",
 			dev, optimal_sectors);
 	return 0;
@@ -1273,14 +1274,14 @@ int se_dev_set_block_size(struct se_device *dev, u32 block_size)
 		return -EINVAL;
 	}
 
-	if (TRANSPORT(dev)->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV) {
+	if (dev->transport->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV) {
 		printk(KERN_ERR "dev[%p]: Not allowed to change block_size for"
 			" Physical Device, use for Linux/SCSI to change"
 			" block_size for underlying hardware\n", dev);
 		return -EINVAL;
 	}
 
-	DEV_ATTRIB(dev)->block_size = block_size;
+	dev->se_sub_dev->se_dev_attrib.block_size = block_size;
 	printk(KERN_INFO "dev[%p]: SE Device block_size changed to %u\n",
 			dev, block_size);
 	return 0;
@@ -1314,14 +1315,14 @@ struct se_lun *core_dev_add_lun(
 		return NULL;
 
 	printk(KERN_INFO "%s_TPG[%u]_LUN[%u] - Activated %s Logical Unit from"
-		" CORE HBA: %u\n", TPG_TFO(tpg)->get_fabric_name(),
-		TPG_TFO(tpg)->tpg_get_tag(tpg), lun_p->unpacked_lun,
-		TPG_TFO(tpg)->get_fabric_name(), hba->hba_id);
+		" CORE HBA: %u\n", tpg->se_tpg_tfo->get_fabric_name(),
+		tpg->se_tpg_tfo->tpg_get_tag(tpg), lun_p->unpacked_lun,
+		tpg->se_tpg_tfo->get_fabric_name(), hba->hba_id);
 	/*
 	 * Update LUN maps for dynamically added initiators when
 	 * generate_node_acl is enabled.
 	 */
-	if (TPG_TFO(tpg)->tpg_check_demo_mode(tpg)) {
+	if (tpg->se_tpg_tfo->tpg_check_demo_mode(tpg)) {
 		struct se_node_acl *acl;
 		spin_lock_bh(&tpg->acl_node_lock);
 		list_for_each_entry(acl, &tpg->acl_node_list, acl_list) {
@@ -1355,9 +1356,9 @@ int core_dev_del_lun(
 	core_tpg_post_dellun(tpg, lun);
 
 	printk(KERN_INFO "%s_TPG[%u]_LUN[%u] - Deactivated %s Logical Unit from"
-		" device object\n", TPG_TFO(tpg)->get_fabric_name(),
-		TPG_TFO(tpg)->tpg_get_tag(tpg), unpacked_lun,
-		TPG_TFO(tpg)->get_fabric_name());
+		" device object\n", tpg->se_tpg_tfo->get_fabric_name(),
+		tpg->se_tpg_tfo->tpg_get_tag(tpg), unpacked_lun,
+		tpg->se_tpg_tfo->get_fabric_name());
 
 	return 0;
 }
@@ -1370,9 +1371,9 @@ struct se_lun *core_get_lun_from_tpg(struct se_portal_group *tpg, u32 unpacked_l
 	if (unpacked_lun > (TRANSPORT_MAX_LUNS_PER_TPG-1)) {
 		printk(KERN_ERR "%s LUN: %u exceeds TRANSPORT_MAX_LUNS"
 			"_PER_TPG-1: %u for Target Portal Group: %hu\n",
-			TPG_TFO(tpg)->get_fabric_name(), unpacked_lun,
+			tpg->se_tpg_tfo->get_fabric_name(), unpacked_lun,
 			TRANSPORT_MAX_LUNS_PER_TPG-1,
-			TPG_TFO(tpg)->tpg_get_tag(tpg));
+			tpg->se_tpg_tfo->tpg_get_tag(tpg));
 		spin_unlock(&tpg->tpg_lun_lock);
 		return NULL;
 	}
@@ -1381,8 +1382,8 @@ struct se_lun *core_get_lun_from_tpg(struct se_portal_group *tpg, u32 unpacked_l
 	if (lun->lun_status != TRANSPORT_LUN_STATUS_FREE) {
 		printk(KERN_ERR "%s Logical Unit Number: %u is not free on"
 			" Target Portal Group: %hu, ignoring request.\n",
-			TPG_TFO(tpg)->get_fabric_name(), unpacked_lun,
-			TPG_TFO(tpg)->tpg_get_tag(tpg));
+			tpg->se_tpg_tfo->get_fabric_name(), unpacked_lun,
+			tpg->se_tpg_tfo->tpg_get_tag(tpg));
 		spin_unlock(&tpg->tpg_lun_lock);
 		return NULL;
 	}
@@ -1403,9 +1404,9 @@ static struct se_lun *core_dev_get_lun(struct se_portal_group *tpg, u32 unpacked
 	if (unpacked_lun > (TRANSPORT_MAX_LUNS_PER_TPG-1)) {
 		printk(KERN_ERR "%s LUN: %u exceeds TRANSPORT_MAX_LUNS_PER"
 			"_TPG-1: %u for Target Portal Group: %hu\n",
-			TPG_TFO(tpg)->get_fabric_name(), unpacked_lun,
+			tpg->se_tpg_tfo->get_fabric_name(), unpacked_lun,
 			TRANSPORT_MAX_LUNS_PER_TPG-1,
-			TPG_TFO(tpg)->tpg_get_tag(tpg));
+			tpg->se_tpg_tfo->tpg_get_tag(tpg));
 		spin_unlock(&tpg->tpg_lun_lock);
 		return NULL;
 	}
@@ -1414,8 +1415,8 @@ static struct se_lun *core_dev_get_lun(struct se_portal_group *tpg, u32 unpacked
 	if (lun->lun_status != TRANSPORT_LUN_STATUS_ACTIVE) {
 		printk(KERN_ERR "%s Logical Unit Number: %u is not active on"
 			" Target Portal Group: %hu, ignoring request.\n",
-			TPG_TFO(tpg)->get_fabric_name(), unpacked_lun,
-			TPG_TFO(tpg)->tpg_get_tag(tpg));
+			tpg->se_tpg_tfo->get_fabric_name(), unpacked_lun,
+			tpg->se_tpg_tfo->tpg_get_tag(tpg));
 		spin_unlock(&tpg->tpg_lun_lock);
 		return NULL;
 	}
@@ -1435,7 +1436,7 @@ struct se_lun_acl *core_dev_init_initiator_node_lun_acl(
 
 	if (strlen(initiatorname) >= TRANSPORT_IQN_LEN) {
 		printk(KERN_ERR "%s InitiatorName exceeds maximum size.\n",
-			TPG_TFO(tpg)->get_fabric_name());
+			tpg->se_tpg_tfo->get_fabric_name());
 		*ret = -EOVERFLOW;
 		return NULL;
 	}
@@ -1472,8 +1473,8 @@ int core_dev_add_initiator_node_lun_acl(
 	if (!(lun)) {
 		printk(KERN_ERR "%s Logical Unit Number: %u is not active on"
 			" Target Portal Group: %hu, ignoring request.\n",
-			TPG_TFO(tpg)->get_fabric_name(), unpacked_lun,
-			TPG_TFO(tpg)->tpg_get_tag(tpg));
+			tpg->se_tpg_tfo->get_fabric_name(), unpacked_lun,
+			tpg->se_tpg_tfo->tpg_get_tag(tpg));
 		return -EINVAL;
 	}
 
@@ -1498,8 +1499,8 @@ int core_dev_add_initiator_node_lun_acl(
 	spin_unlock(&lun->lun_acl_lock);
 
 	printk(KERN_INFO "%s_TPG[%hu]_LUN[%u->%u] - Added %s ACL for "
-		" InitiatorNode: %s\n", TPG_TFO(tpg)->get_fabric_name(),
-		TPG_TFO(tpg)->tpg_get_tag(tpg), unpacked_lun, lacl->mapped_lun,
+		" InitiatorNode: %s\n", tpg->se_tpg_tfo->get_fabric_name(),
+		tpg->se_tpg_tfo->tpg_get_tag(tpg), unpacked_lun, lacl->mapped_lun,
 		(lun_access & TRANSPORT_LUNFLAGS_READ_WRITE) ? "RW" : "RO",
 		lacl->initiatorname);
 	/*
@@ -1538,8 +1539,8 @@ int core_dev_del_initiator_node_lun_acl(
 
 	printk(KERN_INFO "%s_TPG[%hu]_LUN[%u] - Removed ACL for"
 		" InitiatorNode: %s Mapped LUN: %u\n",
-		TPG_TFO(tpg)->get_fabric_name(),
-		TPG_TFO(tpg)->tpg_get_tag(tpg), lun->unpacked_lun,
+		tpg->se_tpg_tfo->get_fabric_name(),
+		tpg->se_tpg_tfo->tpg_get_tag(tpg), lun->unpacked_lun,
 		lacl->initiatorname, lacl->mapped_lun);
 
 	return 0;
@@ -1550,9 +1551,9 @@ void core_dev_free_initiator_node_lun_acl(
 	struct se_lun_acl *lacl)
 {
 	printk("%s_TPG[%hu] - Freeing ACL for %s InitiatorNode: %s"
-		" Mapped LUN: %u\n", TPG_TFO(tpg)->get_fabric_name(),
-		TPG_TFO(tpg)->tpg_get_tag(tpg),
-		TPG_TFO(tpg)->get_fabric_name(),
+		" Mapped LUN: %u\n", tpg->se_tpg_tfo->get_fabric_name(),
+		tpg->se_tpg_tfo->tpg_get_tag(tpg),
+		tpg->se_tpg_tfo->get_fabric_name(),
 		lacl->initiatorname, lacl->mapped_lun);
 
 	kfree(lacl);
@@ -1584,14 +1585,14 @@ int core_dev_setup_virtual_lun0(void)
 	INIT_LIST_HEAD(&se_dev->se_dev_node);
 	INIT_LIST_HEAD(&se_dev->t10_wwn.t10_vpd_list);
 	spin_lock_init(&se_dev->t10_wwn.t10_vpd_lock);
-	INIT_LIST_HEAD(&se_dev->t10_reservation.registration_list);
-	INIT_LIST_HEAD(&se_dev->t10_reservation.aptpl_reg_list);
-	spin_lock_init(&se_dev->t10_reservation.registration_lock);
-	spin_lock_init(&se_dev->t10_reservation.aptpl_reg_lock);
+	INIT_LIST_HEAD(&se_dev->t10_pr.registration_list);
+	INIT_LIST_HEAD(&se_dev->t10_pr.aptpl_reg_list);
+	spin_lock_init(&se_dev->t10_pr.registration_lock);
+	spin_lock_init(&se_dev->t10_pr.aptpl_reg_lock);
 	INIT_LIST_HEAD(&se_dev->t10_alua.tg_pt_gps_list);
 	spin_lock_init(&se_dev->t10_alua.tg_pt_gps_lock);
 	spin_lock_init(&se_dev->se_dev_lock);
-	se_dev->t10_reservation.pr_aptpl_buf_len = PR_APTPL_BUF_LEN;
+	se_dev->t10_pr.pr_aptpl_buf_len = PR_APTPL_BUF_LEN;
 	se_dev->t10_wwn.t10_sub_dev = se_dev;
 	se_dev->t10_alua.t10_sub_dev = se_dev;
 	se_dev->se_dev_attrib.da_sub_dev = se_dev;
diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index 07ab5a3..0b1659d 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -118,7 +118,7 @@ static int target_fabric_mappedlun_link(
 		lun_access = deve->lun_flags;
 	else
 		lun_access =
-			(TPG_TFO(se_tpg)->tpg_check_prod_mode_write_protect(
+			(se_tpg->se_tpg_tfo->tpg_check_prod_mode_write_protect(
 				se_tpg)) ? TRANSPORT_LUNFLAGS_READ_ONLY :
 					   TRANSPORT_LUNFLAGS_READ_WRITE;
 	spin_unlock_irq(&lacl->se_lun_nacl->device_list_lock);
@@ -204,7 +204,7 @@ static ssize_t target_fabric_mappedlun_store_write_protect(
 
 	printk(KERN_INFO "%s_ConfigFS: Changed Initiator ACL: %s"
 		" Mapped LUN: %u Write Protect bit to %s\n",
-		TPG_TFO(se_tpg)->get_fabric_name(),
+		se_tpg->se_tpg_tfo->get_fabric_name(),
 		lacl->initiatorname, lacl->mapped_lun, (op) ? "ON" : "OFF");
 
 	return count;
@@ -379,7 +379,7 @@ static struct config_group *target_fabric_make_mappedlun(
 	lacl_cg->default_groups[0] = &lacl->ml_stat_grps.stat_group;
 	lacl_cg->default_groups[1] = NULL;
 
-	ml_stat_grp = &ML_STAT_GRPS(lacl)->stat_group;
+	ml_stat_grp = &lacl->ml_stat_grps.stat_group;
 	ml_stat_grp->default_groups = kzalloc(sizeof(struct config_group) * 3,
 				GFP_KERNEL);
 	if (!ml_stat_grp->default_groups) {
@@ -408,7 +408,7 @@ static void target_fabric_drop_mappedlun(
 	struct config_group *lacl_cg = NULL, *ml_stat_grp = NULL;
 	int i;
 
-	ml_stat_grp = &ML_STAT_GRPS(lacl)->stat_group;
+	ml_stat_grp = &lacl->ml_stat_grps.stat_group;
 	for (i = 0; ml_stat_grp->default_groups[i]; i++) {
 		df_item = &ml_stat_grp->default_groups[i]->cg_item;
 		ml_stat_grp->default_groups[i] = NULL;
@@ -914,7 +914,7 @@ static struct config_group *target_fabric_make_lun(
 	lun_cg->default_groups[0] = &lun->port_stat_grps.stat_group;
 	lun_cg->default_groups[1] = NULL;
 
-	port_stat_grp = &PORT_STAT_GRP(lun)->stat_group;
+	port_stat_grp = &lun->port_stat_grps.stat_group;
 	port_stat_grp->default_groups =  kzalloc(sizeof(struct config_group) * 3,
 				GFP_KERNEL);
 	if (!port_stat_grp->default_groups) {
@@ -941,7 +941,7 @@ static void target_fabric_drop_lun(
 	struct config_group *lun_cg, *port_stat_grp;
 	int i;
 
-	port_stat_grp = &PORT_STAT_GRP(lun)->stat_group;
+	port_stat_grp = &lun->port_stat_grps.stat_group;
 	for (i = 0; port_stat_grp->default_groups[i]; i++) {
 		df_item = &port_stat_grp->default_groups[i]->cg_item;
 		port_stat_grp->default_groups[i] = NULL;
diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 5ca1f5b..0c44bc0 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -72,7 +72,7 @@ static int fd_attach_hba(struct se_hba *hba, u32 host_id)
 
 	fd_host->fd_host_id = host_id;
 
-	hba->hba_ptr = (void *) fd_host;
+	hba->hba_ptr = fd_host;
 
 	printk(KERN_INFO "CORE_HBA[%d] - TCM FILEIO HBA Driver %s on Generic"
 		" Target Core Stack %s\n", hba->hba_id, FD_VERSION,
@@ -279,7 +279,7 @@ fd_alloc_task(struct se_cmd *cmd)
 		return NULL;
 	}
 
-	fd_req->fd_dev = SE_DEV(cmd)->dev_ptr;
+	fd_req->fd_dev = cmd->se_lun->lun_se_dev->dev_ptr;
 
 	return &fd_req->fd_task;
 }
@@ -291,7 +291,8 @@ static int fd_do_readv(struct se_task *task)
 	struct scatterlist *sg = task->task_sg;
 	struct iovec *iov;
 	mm_segment_t old_fs;
-	loff_t pos = (task->task_lba * DEV_ATTRIB(task->se_dev)->block_size);
+	loff_t pos = (task->task_lba *
+		      task->se_dev->se_sub_dev->se_dev_attrib.block_size);
 	int ret = 0, i;
 
 	iov = kzalloc(sizeof(struct iovec) * task->task_sg_num, GFP_KERNEL);
@@ -341,7 +342,8 @@ static int fd_do_writev(struct se_task *task)
 	struct scatterlist *sg = task->task_sg;
 	struct iovec *iov;
 	mm_segment_t old_fs;
-	loff_t pos = (task->task_lba * DEV_ATTRIB(task->se_dev)->block_size);
+	loff_t pos = (task->task_lba *
+		      task->se_dev->se_sub_dev->se_dev_attrib.block_size);
 	int ret, i = 0;
 
 	iov = kzalloc(sizeof(struct iovec) * task->task_sg_num, GFP_KERNEL);
@@ -372,7 +374,7 @@ static int fd_do_writev(struct se_task *task)
 
 static void fd_emulate_sync_cache(struct se_task *task)
 {
-	struct se_cmd *cmd = TASK_CMD(task);
+	struct se_cmd *cmd = task->task_se_cmd;
 	struct se_device *dev = cmd->se_dev;
 	struct fd_dev *fd_dev = dev->dev_ptr;
 	int immed = (cmd->t_task->t_task_cdb[1] & 0x2);
@@ -393,7 +395,7 @@ static void fd_emulate_sync_cache(struct se_task *task)
 		start = 0;
 		end = LLONG_MAX;
 	} else {
-		start = cmd->t_task->t_task_lba * DEV_ATTRIB(dev)->block_size;
+		start = cmd->t_task->t_task_lba * dev->se_sub_dev->se_dev_attrib.block_size;
 		if (cmd->data_length)
 			end = start + cmd->data_length;
 		else
@@ -443,7 +445,7 @@ static void fd_emulate_write_fua(struct se_cmd *cmd, struct se_task *task)
 {
 	struct se_device *dev = cmd->se_dev;
 	struct fd_dev *fd_dev = dev->dev_ptr;
-	loff_t start = task->task_lba * DEV_ATTRIB(dev)->block_size;
+	loff_t start = task->task_lba * dev->se_sub_dev->se_dev_attrib.block_size;
 	loff_t end = start + task->task_size;
 	int ret;
 
@@ -471,9 +473,9 @@ static int fd_do_task(struct se_task *task)
 		ret = fd_do_writev(task);
 
 		if (ret > 0 &&
-		    DEV_ATTRIB(dev)->emulate_write_cache > 0 &&
-		    DEV_ATTRIB(dev)->emulate_fua_write > 0 &&
-		    T_TASK(cmd)->t_tasks_fua) {
+		    dev->se_sub_dev->se_dev_attrib.emulate_write_cache > 0 &&
+		    dev->se_sub_dev->se_dev_attrib.emulate_fua_write > 0 &&
+		    cmd->t_task->t_tasks_fua) {
 			/*
 			 * We might need to be a bit smarter here
 			 * and return some sense data to let the initiator
@@ -651,7 +653,7 @@ static sector_t fd_get_blocks(struct se_device *dev)
 {
 	struct fd_dev *fd_dev = dev->dev_ptr;
 	unsigned long long blocks_long = div_u64(fd_dev->fd_dev_size,
-			DEV_ATTRIB(dev)->block_size);
+			dev->se_sub_dev->se_dev_attrib.block_size);
 
 	return blocks_long;
 }
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 5bd4f1c..fb15987 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -185,15 +185,15 @@ static struct se_device *iblock_create_virtdevice(
 	 * in ATA and we need to set TPE=1
 	 */
 	if (blk_queue_discard(q)) {
-		DEV_ATTRIB(dev)->max_unmap_lba_count =
+		dev->se_sub_dev->se_dev_attrib.max_unmap_lba_count =
 				q->limits.max_discard_sectors;
 		/*
 		 * Currently hardcoded to 1 in Linux/SCSI code..
 		 */
-		DEV_ATTRIB(dev)->max_unmap_block_desc_count = 1;
-		DEV_ATTRIB(dev)->unmap_granularity =
+		dev->se_sub_dev->se_dev_attrib.max_unmap_block_desc_count = 1;
+		dev->se_sub_dev->se_dev_attrib.unmap_granularity =
 				q->limits.discard_granularity;
-		DEV_ATTRIB(dev)->unmap_granularity_alignment =
+		dev->se_sub_dev->se_dev_attrib.unmap_granularity_alignment =
 				q->limits.discard_alignment;
 
 		printk(KERN_INFO "IBLOCK: BLOCK Discard support available,"
@@ -240,7 +240,7 @@ iblock_alloc_task(struct se_cmd *cmd)
 		return NULL;
 	}
 
-	ib_req->ib_dev = SE_DEV(cmd)->dev_ptr;
+	ib_req->ib_dev = cmd->se_lun->lun_se_dev->dev_ptr;
 	atomic_set(&ib_req->ib_bio_cnt, 0);
 	return &ib_req->ib_task;
 }
@@ -254,12 +254,12 @@ static unsigned long long iblock_emulate_read_cap_with_block_size(
 					bdev_logical_block_size(bd)) - 1);
 	u32 block_size = bdev_logical_block_size(bd);
 
-	if (block_size == DEV_ATTRIB(dev)->block_size)
+	if (block_size == dev->se_sub_dev->se_dev_attrib.block_size)
 		return blocks_long;
 
 	switch (block_size) {
 	case 4096:
-		switch (DEV_ATTRIB(dev)->block_size) {
+		switch (dev->se_sub_dev->se_dev_attrib.block_size) {
 		case 2048:
 			blocks_long <<= 1;
 			break;
@@ -273,7 +273,7 @@ static unsigned long long iblock_emulate_read_cap_with_block_size(
 		}
 		break;
 	case 2048:
-		switch (DEV_ATTRIB(dev)->block_size) {
+		switch (dev->se_sub_dev->se_dev_attrib.block_size) {
 		case 4096:
 			blocks_long >>= 1;
 			break;
@@ -288,7 +288,7 @@ static unsigned long long iblock_emulate_read_cap_with_block_size(
 		}
 		break;
 	case 1024:
-		switch (DEV_ATTRIB(dev)->block_size) {
+		switch (dev->se_sub_dev->se_dev_attrib.block_size) {
 		case 4096:
 			blocks_long >>= 2;
 			break;
@@ -303,7 +303,7 @@ static unsigned long long iblock_emulate_read_cap_with_block_size(
 		}
 		break;
 	case 512:
-		switch (DEV_ATTRIB(dev)->block_size) {
+		switch (dev->se_sub_dev->se_dev_attrib.block_size) {
 		case 4096:
 			blocks_long >>= 3;
 			break;
@@ -329,9 +329,9 @@ static unsigned long long iblock_emulate_read_cap_with_block_size(
  */
 static void iblock_emulate_sync_cache(struct se_task *task)
 {
-	struct se_cmd *cmd = TASK_CMD(task);
+	struct se_cmd *cmd = task->task_se_cmd;
 	struct iblock_dev *ib_dev = cmd->se_dev->dev_ptr;
-	int immed = (T_TASK(cmd)->t_task_cdb[1] & 0x2);
+	int immed = (cmd->t_task->t_task_cdb[1] & 0x2);
 	sector_t error_sector;
 	int ret;
 
@@ -398,9 +398,9 @@ static int iblock_do_task(struct se_task *task)
 		 * Force data to disk if we pretend to not have a volatile
 		 * write cache, or the initiator set the Force Unit Access bit.
 		 */
-		if (DEV_ATTRIB(dev)->emulate_write_cache == 0 ||
-		    (DEV_ATTRIB(dev)->emulate_fua_write > 0 &&
-		     T_TASK(task->task_se_cmd)->t_tasks_fua))
+		if (dev->se_sub_dev->se_dev_attrib.emulate_write_cache == 0 ||
+		    (dev->se_sub_dev->se_dev_attrib.emulate_fua_write > 0 &&
+		     task->task_se_cmd->t_task->t_tasks_fua))
 			rw = WRITE_FUA;
 		else
 			rw = WRITE;
@@ -608,7 +608,7 @@ static struct bio *iblock_get_bio(
 static int iblock_map_task_SG(struct se_task *task)
 {
 	struct se_cmd *cmd = task->task_se_cmd;
-	struct se_device *dev = SE_DEV(cmd);
+	struct se_device *dev = cmd->se_lun->lun_se_dev;
 	struct iblock_dev *ib_dev = task->se_dev->dev_ptr;
 	struct iblock_req *ib_req = IBLOCK_REQ(task);
 	struct bio *bio = NULL, *hbio = NULL, *tbio = NULL;
@@ -620,17 +620,17 @@ static int iblock_map_task_SG(struct se_task *task)
 	 * Do starting conversion up from non 512-byte blocksize with
 	 * struct se_task SCSI blocksize into Linux/Block 512 units for BIO.
 	 */
-	if (DEV_ATTRIB(dev)->block_size == 4096)
+	if (dev->se_sub_dev->se_dev_attrib.block_size == 4096)
 		block_lba = (task->task_lba << 3);
-	else if (DEV_ATTRIB(dev)->block_size == 2048)
+	else if (dev->se_sub_dev->se_dev_attrib.block_size == 2048)
 		block_lba = (task->task_lba << 2);
-	else if (DEV_ATTRIB(dev)->block_size == 1024)
+	else if (dev->se_sub_dev->se_dev_attrib.block_size == 1024)
 		block_lba = (task->task_lba << 1);
-	else if (DEV_ATTRIB(dev)->block_size == 512)
+	else if (dev->se_sub_dev->se_dev_attrib.block_size == 512)
 		block_lba = task->task_lba;
 	else {
 		printk(KERN_ERR "Unsupported SCSI -> BLOCK LBA conversion:"
-				" %u\n", DEV_ATTRIB(dev)->block_size);
+				" %u\n", dev->se_sub_dev->se_dev_attrib.block_size);
 		return PYX_TRANSPORT_LU_COMM_FAILURE;
 	}
 
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 2ddbe0d..27a7525 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -143,8 +143,8 @@ static int core_scsi2_reservation_release(struct se_cmd *cmd)
 		dev->dev_flags &= ~DF_SPC2_RESERVATIONS_WITH_ISID;
 	}
 	printk(KERN_INFO "SCSI-2 Released reservation for %s LUN: %u ->"
-		" MAPPED LUN: %u for %s\n", TPG_TFO(tpg)->get_fabric_name(),
-		SE_LUN(cmd)->unpacked_lun, cmd->se_deve->mapped_lun,
+		" MAPPED LUN: %u for %s\n", tpg->se_tpg_tfo->get_fabric_name(),
+		cmd->se_lun->unpacked_lun, cmd->se_deve->mapped_lun,
 		sess->se_node_acl->initiatorname);
 	spin_unlock(&dev->dev_reservation_lock);
 
@@ -157,8 +157,8 @@ static int core_scsi2_reservation_reserve(struct se_cmd *cmd)
 	struct se_session *sess = cmd->se_sess;
 	struct se_portal_group *tpg = sess->se_tpg;
 
-	if ((T_TASK(cmd)->t_task_cdb[1] & 0x01) &&
-	    (T_TASK(cmd)->t_task_cdb[1] & 0x02)) {
+	if ((cmd->t_task->t_task_cdb[1] & 0x01) &&
+	    (cmd->t_task->t_task_cdb[1] & 0x02)) {
 		printk(KERN_ERR "LongIO and Obselete Bits set, returning"
 				" ILLEGAL_REQUEST\n");
 		return PYX_TRANSPORT_ILLEGAL_REQUEST;
@@ -174,12 +174,12 @@ static int core_scsi2_reservation_reserve(struct se_cmd *cmd)
 	if (dev->dev_reserved_node_acl &&
 	   (dev->dev_reserved_node_acl != sess->se_node_acl)) {
 		printk(KERN_ERR "SCSI-2 RESERVATION CONFLIFT for %s fabric\n",
-			TPG_TFO(tpg)->get_fabric_name());
+			tpg->se_tpg_tfo->get_fabric_name());
 		printk(KERN_ERR "Original reserver LUN: %u %s\n",
-			SE_LUN(cmd)->unpacked_lun,
+			cmd->se_lun->unpacked_lun,
 			dev->dev_reserved_node_acl->initiatorname);
 		printk(KERN_ERR "Current attempt - LUN: %u -> MAPPED LUN: %u"
-			" from %s \n", SE_LUN(cmd)->unpacked_lun,
+			" from %s \n", cmd->se_lun->unpacked_lun,
 			cmd->se_deve->mapped_lun,
 			sess->se_node_acl->initiatorname);
 		spin_unlock(&dev->dev_reservation_lock);
@@ -193,8 +193,8 @@ static int core_scsi2_reservation_reserve(struct se_cmd *cmd)
 		dev->dev_flags |= DF_SPC2_RESERVATIONS_WITH_ISID;
 	}
 	printk(KERN_INFO "SCSI-2 Reserved %s LUN: %u -> MAPPED LUN: %u"
-		" for %s\n", TPG_TFO(tpg)->get_fabric_name(),
-		SE_LUN(cmd)->unpacked_lun, cmd->se_deve->mapped_lun,
+		" for %s\n", tpg->se_tpg_tfo->get_fabric_name(),
+		cmd->se_lun->unpacked_lun, cmd->se_deve->mapped_lun,
 		sess->se_node_acl->initiatorname);
 	spin_unlock(&dev->dev_reservation_lock);
 
@@ -215,9 +215,9 @@ int core_scsi2_emulate_crh(struct se_cmd *cmd)
 	struct se_session *se_sess = cmd->se_sess;
 	struct se_subsystem_dev *su_dev = cmd->se_dev->se_sub_dev;
 	struct t10_pr_registration *pr_reg;
-	struct t10_reservation_template *pr_tmpl = &su_dev->t10_reservation;
-	unsigned char *cdb = &T_TASK(cmd)->t_task_cdb[0];
-	int crh = (T10_RES(su_dev)->res_type == SPC3_PERSISTENT_RESERVATIONS);
+	struct t10_reservation *pr_tmpl = &su_dev->t10_pr;
+	unsigned char *cdb = &cmd->t_task->t_task_cdb[0];
+	int crh = (su_dev->t10_pr.res_type == SPC3_PERSISTENT_RESERVATIONS);
 	int conflict = 0;
 
 	if (!(se_sess))
@@ -307,7 +307,7 @@ static int core_scsi3_pr_seq_non_holder(
 	u32 pr_reg_type)
 {
 	struct se_dev_entry *se_deve;
-	struct se_session *se_sess = SE_SESS(cmd);
+	struct se_session *se_sess = cmd->se_sess;
 	int other_cdb = 0, ignore_reg;
 	int registered_nexus = 0, ret = 1; /* Conflict by default */
 	int all_reg = 0, reg_only = 0; /* ALL_REG, REG_ONLY */
@@ -549,7 +549,7 @@ static int core_scsi3_pr_seq_non_holder(
 
 static u32 core_scsi3_pr_generation(struct se_device *dev)
 {
-	struct se_subsystem_dev *su_dev = SU_DEV(dev);
+	struct se_subsystem_dev *su_dev = dev->se_sub_dev;
 	u32 prg;
 	/*
 	 * PRGeneration field shall contain the value of a 32-bit wrapping
@@ -561,7 +561,7 @@ static u32 core_scsi3_pr_generation(struct se_device *dev)
 	 * See spc4r17 section 6.3.12 READ_KEYS service action
 	 */
 	spin_lock(&dev->dev_reservation_lock);
-	prg = T10_RES(su_dev)->pr_generation++;
+	prg = su_dev->t10_pr.pr_generation++;
 	spin_unlock(&dev->dev_reservation_lock);
 
 	return prg;
@@ -620,7 +620,7 @@ static struct t10_pr_registration *__core_scsi3_do_alloc_registration(
 	int all_tg_pt,
 	int aptpl)
 {
-	struct se_subsystem_dev *su_dev = SU_DEV(dev);
+	struct se_subsystem_dev *su_dev = dev->se_sub_dev;
 	struct t10_pr_registration *pr_reg;
 
 	pr_reg = kmem_cache_zalloc(t10_pr_reg_cache, GFP_ATOMIC);
@@ -629,7 +629,7 @@ static struct t10_pr_registration *__core_scsi3_do_alloc_registration(
 		return NULL;
 	}
 
-	pr_reg->pr_aptpl_buf = kzalloc(T10_RES(su_dev)->pr_aptpl_buf_len,
+	pr_reg->pr_aptpl_buf = kzalloc(su_dev->t10_pr.pr_aptpl_buf_len,
 					GFP_ATOMIC);
 	if (!(pr_reg->pr_aptpl_buf)) {
 		printk(KERN_ERR "Unable to allocate pr_reg->pr_aptpl_buf\n");
@@ -803,7 +803,7 @@ out:
 }
 
 int core_scsi3_alloc_aptpl_registration(
-	struct t10_reservation_template *pr_tmpl,
+	struct t10_reservation *pr_tmpl,
 	u64 sa_res_key,
 	unsigned char *i_port,
 	unsigned char *isid,
@@ -893,11 +893,11 @@ static void core_scsi3_aptpl_reserve(
 
 	printk(KERN_INFO "SPC-3 PR [%s] Service Action: APTPL RESERVE created"
 		" new reservation holder TYPE: %s ALL_TG_PT: %d\n",
-		TPG_TFO(tpg)->get_fabric_name(),
+		tpg->se_tpg_tfo->get_fabric_name(),
 		core_scsi3_pr_dump_type(pr_reg->pr_res_type),
 		(pr_reg->pr_reg_all_tg_pt) ? 1 : 0);
 	printk(KERN_INFO "SPC-3 PR [%s] RESERVE Node: %s%s\n",
-		TPG_TFO(tpg)->get_fabric_name(), node_acl->initiatorname,
+		tpg->se_tpg_tfo->get_fabric_name(), node_acl->initiatorname,
 		(prf_isid) ? &i_buf[0] : "");
 }
 
@@ -913,7 +913,7 @@ static int __core_scsi3_check_aptpl_registration(
 	struct se_dev_entry *deve)
 {
 	struct t10_pr_registration *pr_reg, *pr_reg_tmp;
-	struct t10_reservation_template *pr_tmpl = &SU_DEV(dev)->t10_reservation;
+	struct t10_reservation *pr_tmpl = &dev->se_sub_dev->t10_pr;
 	unsigned char i_port[PR_APTPL_MAX_IPORT_LEN];
 	unsigned char t_port[PR_APTPL_MAX_TPORT_LEN];
 	u16 tpgt;
@@ -925,8 +925,8 @@ static int __core_scsi3_check_aptpl_registration(
 	 */
 	snprintf(i_port, PR_APTPL_MAX_IPORT_LEN, "%s", nacl->initiatorname);
 	snprintf(t_port, PR_APTPL_MAX_TPORT_LEN, "%s",
-			TPG_TFO(tpg)->tpg_get_wwn(tpg));
-	tpgt = TPG_TFO(tpg)->tpg_get_tag(tpg);
+			tpg->se_tpg_tfo->tpg_get_wwn(tpg));
+	tpgt = tpg->se_tpg_tfo->tpg_get_tag(tpg);
 	/*
 	 * Look for the matching registrations+reservation from those
 	 * created from APTPL metadata.  Note that multiple registrations
@@ -980,11 +980,11 @@ int core_scsi3_check_aptpl_registration(
 	struct se_lun *lun,
 	struct se_lun_acl *lun_acl)
 {
-	struct se_subsystem_dev *su_dev = SU_DEV(dev);
+	struct se_subsystem_dev *su_dev = dev->se_sub_dev;
 	struct se_node_acl *nacl = lun_acl->se_lun_nacl;
 	struct se_dev_entry *deve = &nacl->device_list[lun_acl->mapped_lun];
 
-	if (T10_RES(su_dev)->res_type != SPC3_PERSISTENT_RESERVATIONS)
+	if (su_dev->t10_pr.res_type != SPC3_PERSISTENT_RESERVATIONS)
 		return 0;
 
 	return __core_scsi3_check_aptpl_registration(dev, tpg, lun,
@@ -1017,7 +1017,7 @@ static void __core_scsi3_dump_registration(
 	printk(KERN_INFO "SPC-3 PR [%s] for %s TCM Subsystem %s Object Target"
 		" Port(s)\n",  tfo->get_fabric_name(),
 		(pr_reg->pr_reg_all_tg_pt) ? "ALL" : "SINGLE",
-		TRANSPORT(dev)->name);
+		dev->transport->name);
 	printk(KERN_INFO "SPC-3 PR [%s] SA Res Key: 0x%016Lx PRgeneration:"
 		" 0x%08x  APTPL: %d\n", tfo->get_fabric_name(),
 		pr_reg->pr_res_key, pr_reg->pr_res_generation,
@@ -1035,10 +1035,10 @@ static void __core_scsi3_add_registration(
 	int register_type,
 	int register_move)
 {
-	struct se_subsystem_dev *su_dev = SU_DEV(dev);
+	struct se_subsystem_dev *su_dev = dev->se_sub_dev;
 	struct target_core_fabric_ops *tfo = nacl->se_tpg->se_tpg_tfo;
 	struct t10_pr_registration *pr_reg_tmp, *pr_reg_tmp_safe;
-	struct t10_reservation_template *pr_tmpl = &SU_DEV(dev)->t10_reservation;
+	struct t10_reservation *pr_tmpl = &dev->se_sub_dev->t10_pr;
 
 	/*
 	 * Increment PRgeneration counter for struct se_device upon a successful
@@ -1050,7 +1050,7 @@ static void __core_scsi3_add_registration(
 	 * for the REGISTER.
 	 */
 	pr_reg->pr_res_generation = (register_move) ?
-			T10_RES(su_dev)->pr_generation++ :
+			su_dev->t10_pr.pr_generation++ :
 			core_scsi3_pr_generation(dev);
 
 	spin_lock(&pr_tmpl->registration_lock);
@@ -1119,7 +1119,7 @@ static struct t10_pr_registration *__core_scsi3_locate_pr_reg(
 	struct se_node_acl *nacl,
 	unsigned char *isid)
 {
-	struct t10_reservation_template *pr_tmpl = &SU_DEV(dev)->t10_reservation;
+	struct t10_reservation *pr_tmpl = &dev->se_sub_dev->t10_pr;
 	struct t10_pr_registration *pr_reg, *pr_reg_tmp;
 	struct se_portal_group *tpg;
 
@@ -1143,8 +1143,8 @@ static struct t10_pr_registration *__core_scsi3_locate_pr_reg(
 			 * SCSI Intiatior TransportID w/ ISIDs is enforced
 			 * for fabric modules (iSCSI) requiring them.
 			 */
-			if (TPG_TFO(tpg)->sess_get_initiator_sid != NULL) {
-				if (DEV_ATTRIB(dev)->enforce_pr_isids)
+			if (tpg->se_tpg_tfo->sess_get_initiator_sid != NULL) {
+				if (dev->se_sub_dev->se_dev_attrib.enforce_pr_isids)
 					continue;
 			}
 			atomic_inc(&pr_reg->pr_res_holders);
@@ -1180,9 +1180,9 @@ static struct t10_pr_registration *core_scsi3_locate_pr_reg(
 	struct se_portal_group *tpg = nacl->se_tpg;
 	unsigned char buf[PR_REG_ISID_LEN], *isid_ptr = NULL;
 
-	if (TPG_TFO(tpg)->sess_get_initiator_sid != NULL) {
+	if (tpg->se_tpg_tfo->sess_get_initiator_sid != NULL) {
 		memset(&buf[0], 0, PR_REG_ISID_LEN);
-		TPG_TFO(tpg)->sess_get_initiator_sid(sess, &buf[0],
+		tpg->se_tpg_tfo->sess_get_initiator_sid(sess, &buf[0],
 					PR_REG_ISID_LEN);
 		isid_ptr = &buf[0];
 	}
@@ -1248,7 +1248,7 @@ static int core_scsi3_check_implict_release(
 }
 
 /*
- * Called with struct t10_reservation_template->registration_lock held.
+ * Called with struct t10_reservation->registration_lock held.
  */
 static void __core_scsi3_free_registration(
 	struct se_device *dev,
@@ -1258,7 +1258,7 @@ static void __core_scsi3_free_registration(
 {
 	struct target_core_fabric_ops *tfo =
 			pr_reg->pr_reg_nacl->se_tpg->se_tpg_tfo;
-	struct t10_reservation_template *pr_tmpl = &SU_DEV(dev)->t10_reservation;
+	struct t10_reservation *pr_tmpl = &dev->se_sub_dev->t10_pr;
 	char i_buf[PR_REG_ISID_ID_LEN];
 	int prf_isid;
 
@@ -1296,7 +1296,7 @@ static void __core_scsi3_free_registration(
 	printk(KERN_INFO "SPC-3 PR [%s] for %s TCM Subsystem %s Object Target"
 		" Port(s)\n", tfo->get_fabric_name(),
 		(pr_reg->pr_reg_all_tg_pt) ? "ALL" : "SINGLE",
-		TRANSPORT(dev)->name);
+		dev->transport->name);
 	printk(KERN_INFO "SPC-3 PR [%s] SA Res Key: 0x%016Lx PRgeneration:"
 		" 0x%08x\n", tfo->get_fabric_name(), pr_reg->pr_res_key,
 		pr_reg->pr_res_generation);
@@ -1319,7 +1319,7 @@ void core_scsi3_free_pr_reg_from_nacl(
 	struct se_device *dev,
 	struct se_node_acl *nacl)
 {
-	struct t10_reservation_template *pr_tmpl = &SU_DEV(dev)->t10_reservation;
+	struct t10_reservation *pr_tmpl = &dev->se_sub_dev->t10_pr;
 	struct t10_pr_registration *pr_reg, *pr_reg_tmp, *pr_res_holder;
 	/*
 	 * If the passed se_node_acl matches the reservation holder,
@@ -1349,7 +1349,7 @@ void core_scsi3_free_pr_reg_from_nacl(
 void core_scsi3_free_all_registrations(
 	struct se_device *dev)
 {
-	struct t10_reservation_template *pr_tmpl = &SU_DEV(dev)->t10_reservation;
+	struct t10_reservation *pr_tmpl = &dev->se_sub_dev->t10_pr;
 	struct t10_pr_registration *pr_reg, *pr_reg_tmp, *pr_res_holder;
 
 	spin_lock(&dev->dev_reservation_lock);
@@ -1381,13 +1381,13 @@ void core_scsi3_free_all_registrations(
 
 static int core_scsi3_tpg_depend_item(struct se_portal_group *tpg)
 {
-	return configfs_depend_item(TPG_TFO(tpg)->tf_subsys,
+	return configfs_depend_item(tpg->se_tpg_tfo->tf_subsys,
 			&tpg->tpg_group.cg_item);
 }
 
 static void core_scsi3_tpg_undepend_item(struct se_portal_group *tpg)
 {
-	configfs_undepend_item(TPG_TFO(tpg)->tf_subsys,
+	configfs_undepend_item(tpg->se_tpg_tfo->tf_subsys,
 			&tpg->tpg_group.cg_item);
 
 	atomic_dec(&tpg->tpg_pr_ref_count);
@@ -1401,7 +1401,7 @@ static int core_scsi3_nodeacl_depend_item(struct se_node_acl *nacl)
 	if (nacl->dynamic_node_acl)
 		return 0;
 
-	return configfs_depend_item(TPG_TFO(tpg)->tf_subsys,
+	return configfs_depend_item(tpg->se_tpg_tfo->tf_subsys,
 			&nacl->acl_group.cg_item);
 }
 
@@ -1415,7 +1415,7 @@ static void core_scsi3_nodeacl_undepend_item(struct se_node_acl *nacl)
 		return;
 	}
 
-	configfs_undepend_item(TPG_TFO(tpg)->tf_subsys,
+	configfs_undepend_item(tpg->se_tpg_tfo->tf_subsys,
 			&nacl->acl_group.cg_item);
 
 	atomic_dec(&nacl->acl_pr_ref_count);
@@ -1436,7 +1436,7 @@ static int core_scsi3_lunacl_depend_item(struct se_dev_entry *se_deve)
 	nacl = lun_acl->se_lun_nacl;
 	tpg = nacl->se_tpg;
 
-	return configfs_depend_item(TPG_TFO(tpg)->tf_subsys,
+	return configfs_depend_item(tpg->se_tpg_tfo->tf_subsys,
 			&lun_acl->se_lun_group.cg_item);
 }
 
@@ -1456,7 +1456,7 @@ static void core_scsi3_lunacl_undepend_item(struct se_dev_entry *se_deve)
 	nacl = lun_acl->se_lun_nacl;
 	tpg = nacl->se_tpg;
 
-	configfs_undepend_item(TPG_TFO(tpg)->tf_subsys,
+	configfs_undepend_item(tpg->se_tpg_tfo->tf_subsys,
 			&lun_acl->se_lun_group.cg_item);
 
 	atomic_dec(&se_deve->pr_ref_count);
@@ -1471,10 +1471,10 @@ static int core_scsi3_decode_spec_i_port(
 	int all_tg_pt,
 	int aptpl)
 {
-	struct se_device *dev = SE_DEV(cmd);
+	struct se_device *dev = cmd->se_lun->lun_se_dev;
 	struct se_port *tmp_port;
 	struct se_portal_group *dest_tpg = NULL, *tmp_tpg;
-	struct se_session *se_sess = SE_SESS(cmd);
+	struct se_session *se_sess = cmd->se_sess;
 	struct se_node_acl *dest_node_acl = NULL;
 	struct se_dev_entry *dest_se_deve = NULL, *local_se_deve;
 	struct t10_pr_registration *dest_pr_reg, *local_pr_reg, *pr_reg_e;
@@ -1482,7 +1482,7 @@ static int core_scsi3_decode_spec_i_port(
 	struct list_head tid_dest_list;
 	struct pr_transport_id_holder *tidh_new, *tidh, *tidh_tmp;
 	struct target_core_fabric_ops *tmp_tf_ops;
-	unsigned char *buf = (unsigned char *)T_TASK(cmd)->t_task_buf;
+	unsigned char *buf = (unsigned char *)cmd->t_task->t_task_buf;
 	unsigned char *ptr, *i_str = NULL, proto_ident, tmp_proto_ident;
 	char *iport_ptr = NULL, dest_iport[64], i_buf[PR_REG_ISID_ID_LEN];
 	u32 tpdl, tid_len = 0;
@@ -1509,7 +1509,7 @@ static int core_scsi3_decode_spec_i_port(
 	tidh_new->dest_node_acl = se_sess->se_node_acl;
 	tidh_new->dest_se_deve = local_se_deve;
 
-	local_pr_reg = __core_scsi3_alloc_registration(SE_DEV(cmd),
+	local_pr_reg = __core_scsi3_alloc_registration(cmd->se_lun->lun_se_dev,
 				se_sess->se_node_acl, local_se_deve, l_isid,
 				sa_res_key, all_tg_pt, aptpl);
 	if (!(local_pr_reg)) {
@@ -1557,7 +1557,7 @@ static int core_scsi3_decode_spec_i_port(
 			tmp_tpg = tmp_port->sep_tpg;
 			if (!(tmp_tpg))
 				continue;
-			tmp_tf_ops = TPG_TFO(tmp_tpg);
+			tmp_tf_ops = tmp_tpg->se_tpg_tfo;
 			if (!(tmp_tf_ops))
 				continue;
 			if (!(tmp_tf_ops->get_fabric_proto_ident) ||
@@ -1625,7 +1625,7 @@ static int core_scsi3_decode_spec_i_port(
 			dest_tpg = tmp_tpg;
 			printk(KERN_INFO "SPC-3 PR SPEC_I_PT: Located %s Node:"
 				" %s Port RTPI: %hu\n",
-				TPG_TFO(dest_tpg)->get_fabric_name(),
+				dest_tpg->se_tpg_tfo->get_fabric_name(),
 				dest_node_acl->initiatorname, dest_rtpi);
 
 			spin_lock(&dev->se_port_lock);
@@ -1642,7 +1642,7 @@ static int core_scsi3_decode_spec_i_port(
 #if 0
 		printk("SPC-3 PR SPEC_I_PT: Got %s data_length: %u tpdl: %u"
 			" tid_len: %d for %s + %s\n",
-			TPG_TFO(dest_tpg)->get_fabric_name(), cmd->data_length,
+			dest_tpg->se_tpg_tfo->get_fabric_name(), cmd->data_length,
 			tpdl, tid_len, i_str, iport_ptr);
 #endif
 		if (tid_len > tpdl) {
@@ -1663,7 +1663,7 @@ static int core_scsi3_decode_spec_i_port(
 		if (!(dest_se_deve)) {
 			printk(KERN_ERR "Unable to locate %s dest_se_deve"
 				" from destination RTPI: %hu\n",
-				TPG_TFO(dest_tpg)->get_fabric_name(),
+				dest_tpg->se_tpg_tfo->get_fabric_name(),
 				dest_rtpi);
 
 			core_scsi3_nodeacl_undepend_item(dest_node_acl);
@@ -1686,7 +1686,7 @@ static int core_scsi3_decode_spec_i_port(
 #if 0
 		printk(KERN_INFO "SPC-3 PR SPEC_I_PT: Located %s Node: %s"
 			" dest_se_deve mapped_lun: %u\n",
-			TPG_TFO(dest_tpg)->get_fabric_name(),
+			dest_tpg->se_tpg_tfo->get_fabric_name(),
 			dest_node_acl->initiatorname, dest_se_deve->mapped_lun);
 #endif
 		/*
@@ -1741,7 +1741,7 @@ static int core_scsi3_decode_spec_i_port(
 		 * and then call __core_scsi3_add_registration() in the
 		 * 2nd loop which will never fail.
 		 */
-		dest_pr_reg = __core_scsi3_alloc_registration(SE_DEV(cmd),
+		dest_pr_reg = __core_scsi3_alloc_registration(cmd->se_lun->lun_se_dev,
 				dest_node_acl, dest_se_deve, iport_ptr,
 				sa_res_key, all_tg_pt, aptpl);
 		if (!(dest_pr_reg)) {
@@ -1787,12 +1787,12 @@ static int core_scsi3_decode_spec_i_port(
 		prf_isid = core_pr_dump_initiator_port(dest_pr_reg, &i_buf[0],
 						PR_REG_ISID_ID_LEN);
 
-		__core_scsi3_add_registration(SE_DEV(cmd), dest_node_acl,
+		__core_scsi3_add_registration(cmd->se_lun->lun_se_dev, dest_node_acl,
 					dest_pr_reg, 0, 0);
 
 		printk(KERN_INFO "SPC-3 PR [%s] SPEC_I_PT: Successfully"
 			" registered Transport ID for Node: %s%s Mapped LUN:"
-			" %u\n", TPG_TFO(dest_tpg)->get_fabric_name(),
+			" %u\n", dest_tpg->se_tpg_tfo->get_fabric_name(),
 			dest_node_acl->initiatorname, (prf_isid) ?
 			&i_buf[0] : "", dest_se_deve->mapped_lun);
 
@@ -1855,7 +1855,7 @@ static int __core_scsi3_update_aptpl_buf(
 {
 	struct se_lun *lun;
 	struct se_portal_group *tpg;
-	struct se_subsystem_dev *su_dev = SU_DEV(dev);
+	struct se_subsystem_dev *su_dev = dev->se_sub_dev;
 	struct t10_pr_registration *pr_reg;
 	unsigned char tmp[512], isid_buf[32];
 	ssize_t len = 0;
@@ -1873,8 +1873,8 @@ static int __core_scsi3_update_aptpl_buf(
 	/*
 	 * Walk the registration list..
 	 */
-	spin_lock(&T10_RES(su_dev)->registration_lock);
-	list_for_each_entry(pr_reg, &T10_RES(su_dev)->registration_list,
+	spin_lock(&su_dev->t10_pr.registration_lock);
+	list_for_each_entry(pr_reg, &su_dev->t10_pr.registration_list,
 			pr_reg_list) {
 
 		tmp[0] = '\0';
@@ -1900,7 +1900,7 @@ static int __core_scsi3_update_aptpl_buf(
 				"res_holder=1\nres_type=%02x\n"
 				"res_scope=%02x\nres_all_tg_pt=%d\n"
 				"mapped_lun=%u\n", reg_count,
-				TPG_TFO(tpg)->get_fabric_name(),
+				tpg->se_tpg_tfo->get_fabric_name(),
 				pr_reg->pr_reg_nacl->initiatorname, isid_buf,
 				pr_reg->pr_res_key, pr_reg->pr_res_type,
 				pr_reg->pr_res_scope, pr_reg->pr_reg_all_tg_pt,
@@ -1910,7 +1910,7 @@ static int __core_scsi3_update_aptpl_buf(
 				"initiator_fabric=%s\ninitiator_node=%s\n%s"
 				"sa_res_key=%llu\nres_holder=0\n"
 				"res_all_tg_pt=%d\nmapped_lun=%u\n",
-				reg_count, TPG_TFO(tpg)->get_fabric_name(),
+				reg_count, tpg->se_tpg_tfo->get_fabric_name(),
 				pr_reg->pr_reg_nacl->initiatorname, isid_buf,
 				pr_reg->pr_res_key, pr_reg->pr_reg_all_tg_pt,
 				pr_reg->pr_res_mapped_lun);
@@ -1919,7 +1919,7 @@ static int __core_scsi3_update_aptpl_buf(
 		if ((len + strlen(tmp) >= pr_aptpl_buf_len)) {
 			printk(KERN_ERR "Unable to update renaming"
 				" APTPL metadata\n");
-			spin_unlock(&T10_RES(su_dev)->registration_lock);
+			spin_unlock(&su_dev->t10_pr.registration_lock);
 			return -EMSGSIZE;
 		}
 		len += sprintf(buf+len, "%s", tmp);
@@ -1929,21 +1929,21 @@ static int __core_scsi3_update_aptpl_buf(
 		 */
 		snprintf(tmp, 512, "target_fabric=%s\ntarget_node=%s\n"
 			"tpgt=%hu\nport_rtpi=%hu\ntarget_lun=%u\nPR_REG_END:"
-			" %d\n", TPG_TFO(tpg)->get_fabric_name(),
-			TPG_TFO(tpg)->tpg_get_wwn(tpg),
-			TPG_TFO(tpg)->tpg_get_tag(tpg),
+			" %d\n", tpg->se_tpg_tfo->get_fabric_name(),
+			tpg->se_tpg_tfo->tpg_get_wwn(tpg),
+			tpg->se_tpg_tfo->tpg_get_tag(tpg),
 			lun->lun_sep->sep_rtpi, lun->unpacked_lun, reg_count);
 
 		if ((len + strlen(tmp) >= pr_aptpl_buf_len)) {
 			printk(KERN_ERR "Unable to update renaming"
 				" APTPL metadata\n");
-			spin_unlock(&T10_RES(su_dev)->registration_lock);
+			spin_unlock(&su_dev->t10_pr.registration_lock);
 			return -EMSGSIZE;
 		}
 		len += sprintf(buf+len, "%s", tmp);
 		reg_count++;
 	}
-	spin_unlock(&T10_RES(su_dev)->registration_lock);
+	spin_unlock(&su_dev->t10_pr.registration_lock);
 
 	if (!(reg_count))
 		len += sprintf(buf+len, "No Registrations or Reservations");
@@ -1975,7 +1975,7 @@ static int __core_scsi3_write_aptpl_to_file(
 	unsigned char *buf,
 	u32 pr_aptpl_buf_len)
 {
-	struct t10_wwn *wwn = &SU_DEV(dev)->t10_wwn;
+	struct t10_wwn *wwn = &dev->se_sub_dev->t10_wwn;
 	struct file *file;
 	struct iovec iov[1];
 	mm_segment_t old_fs;
@@ -2070,13 +2070,13 @@ static int core_scsi3_emulate_pro_register(
 	int spec_i_pt,
 	int ignore_key)
 {
-	struct se_session *se_sess = SE_SESS(cmd);
-	struct se_device *dev = SE_DEV(cmd);
+	struct se_session *se_sess = cmd->se_sess;
+	struct se_device *dev = cmd->se_lun->lun_se_dev;
 	struct se_dev_entry *se_deve;
-	struct se_lun *se_lun = SE_LUN(cmd);
+	struct se_lun *se_lun = cmd->se_lun;
 	struct se_portal_group *se_tpg;
 	struct t10_pr_registration *pr_reg, *pr_reg_p, *pr_reg_tmp, *pr_reg_e;
-	struct t10_reservation_template *pr_tmpl = &SU_DEV(dev)->t10_reservation;
+	struct t10_reservation *pr_tmpl = &dev->se_sub_dev->t10_pr;
 	/* Used for APTPL metadata w/ UNREGISTER */
 	unsigned char *pr_aptpl_buf = NULL;
 	unsigned char isid_buf[PR_REG_ISID_LEN], *isid_ptr = NULL;
@@ -2089,9 +2089,9 @@ static int core_scsi3_emulate_pro_register(
 	se_tpg = se_sess->se_tpg;
 	se_deve = &se_sess->se_node_acl->device_list[cmd->orig_fe_lun];
 
-	if (TPG_TFO(se_tpg)->sess_get_initiator_sid != NULL) {
+	if (se_tpg->se_tpg_tfo->sess_get_initiator_sid) {
 		memset(&isid_buf[0], 0, PR_REG_ISID_LEN);
-		TPG_TFO(se_tpg)->sess_get_initiator_sid(se_sess, &isid_buf[0],
+		se_tpg->se_tpg_tfo->sess_get_initiator_sid(se_sess, &isid_buf[0],
 				PR_REG_ISID_LEN);
 		isid_ptr = &isid_buf[0];
 	}
@@ -2117,7 +2117,7 @@ static int core_scsi3_emulate_pro_register(
 			 * Port Endpoint that the PRO was received from on the
 			 * Logical Unit of the SCSI device server.
 			 */
-			ret = core_scsi3_alloc_registration(SE_DEV(cmd),
+			ret = core_scsi3_alloc_registration(cmd->se_lun->lun_se_dev,
 					se_sess->se_node_acl, se_deve, isid_ptr,
 					sa_res_key, all_tg_pt, aptpl,
 					ignore_key, 0);
@@ -2145,7 +2145,7 @@ static int core_scsi3_emulate_pro_register(
 		 */
 		if (!(aptpl)) {
 			pr_tmpl->pr_aptpl_active = 0;
-			core_scsi3_update_and_write_aptpl(SE_DEV(cmd), NULL, 0);
+			core_scsi3_update_and_write_aptpl(cmd->se_lun->lun_se_dev, NULL, 0);
 			printk("SPC-3 PR: Set APTPL Bit Deactivated for"
 					" REGISTER\n");
 			return 0;
@@ -2155,10 +2155,10 @@ static int core_scsi3_emulate_pro_register(
 		 * update the APTPL metadata information using its
 		 * preallocated *pr_reg->pr_aptpl_buf.
 		 */
-		pr_reg = core_scsi3_locate_pr_reg(SE_DEV(cmd),
+		pr_reg = core_scsi3_locate_pr_reg(cmd->se_lun->lun_se_dev,
 				se_sess->se_node_acl, se_sess);
 
-		ret = core_scsi3_update_and_write_aptpl(SE_DEV(cmd),
+		ret = core_scsi3_update_and_write_aptpl(cmd->se_lun->lun_se_dev,
 				&pr_reg->pr_aptpl_buf[0],
 				pr_tmpl->pr_aptpl_buf_len);
 		if (!(ret)) {
@@ -2223,7 +2223,7 @@ static int core_scsi3_emulate_pro_register(
 		 */
 		if (!(sa_res_key)) {
 			pr_holder = core_scsi3_check_implict_release(
-					SE_DEV(cmd), pr_reg);
+					cmd->se_lun->lun_se_dev, pr_reg);
 			if (pr_holder < 0) {
 				kfree(pr_aptpl_buf);
 				core_scsi3_put_pr_reg(pr_reg);
@@ -2260,7 +2260,7 @@ static int core_scsi3_emulate_pro_register(
 			/*
 			 * Release the calling I_T Nexus registration now..
 			 */
-			__core_scsi3_free_registration(SE_DEV(cmd), pr_reg,
+			__core_scsi3_free_registration(cmd->se_lun->lun_se_dev, pr_reg,
 							NULL, 1);
 			/*
 			 * From spc4r17, section 5.7.11.3 Unregistering
@@ -2315,11 +2315,11 @@ static int core_scsi3_emulate_pro_register(
 			 * READ_KEYS service action.
 			 */
 			pr_reg->pr_res_generation = core_scsi3_pr_generation(
-							SE_DEV(cmd));
+							cmd->se_lun->lun_se_dev);
 			pr_reg->pr_res_key = sa_res_key;
 			printk("SPC-3 PR [%s] REGISTER%s: Changed Reservation"
 				" Key for %s to: 0x%016Lx PRgeneration:"
-				" 0x%08x\n", CMD_TFO(cmd)->get_fabric_name(),
+				" 0x%08x\n", cmd->se_tfo->get_fabric_name(),
 				(ignore_key) ? "_AND_IGNORE_EXISTING_KEY" : "",
 				pr_reg->pr_reg_nacl->initiatorname,
 				pr_reg->pr_res_key, pr_reg->pr_res_generation);
@@ -2378,12 +2378,12 @@ static int core_scsi3_pro_reserve(
 	int scope,
 	u64 res_key)
 {
-	struct se_session *se_sess = SE_SESS(cmd);
+	struct se_session *se_sess = cmd->se_sess;
 	struct se_dev_entry *se_deve;
-	struct se_lun *se_lun = SE_LUN(cmd);
+	struct se_lun *se_lun = cmd->se_lun;
 	struct se_portal_group *se_tpg;
 	struct t10_pr_registration *pr_reg, *pr_res_holder;
-	struct t10_reservation_template *pr_tmpl = &SU_DEV(dev)->t10_reservation;
+	struct t10_reservation *pr_tmpl = &dev->se_sub_dev->t10_pr;
 	char i_buf[PR_REG_ISID_ID_LEN];
 	int ret, prf_isid;
 
@@ -2398,7 +2398,7 @@ static int core_scsi3_pro_reserve(
 	/*
 	 * Locate the existing *pr_reg via struct se_node_acl pointers
 	 */
-	pr_reg = core_scsi3_locate_pr_reg(SE_DEV(cmd), se_sess->se_node_acl,
+	pr_reg = core_scsi3_locate_pr_reg(cmd->se_lun->lun_se_dev, se_sess->se_node_acl,
 				se_sess);
 	if (!(pr_reg)) {
 		printk(KERN_ERR "SPC-3 PR: Unable to locate"
@@ -2459,9 +2459,9 @@ static int core_scsi3_pro_reserve(
 			printk(KERN_ERR "SPC-3 PR: Attempted RESERVE from"
 				" [%s]: %s while reservation already held by"
 				" [%s]: %s, returning RESERVATION_CONFLICT\n",
-				CMD_TFO(cmd)->get_fabric_name(),
+				cmd->se_tfo->get_fabric_name(),
 				se_sess->se_node_acl->initiatorname,
-				TPG_TFO(pr_res_nacl->se_tpg)->get_fabric_name(),
+				pr_res_nacl->se_tpg->se_tpg_tfo->get_fabric_name(),
 				pr_res_holder->pr_reg_nacl->initiatorname);
 
 			spin_unlock(&dev->dev_reservation_lock);
@@ -2482,9 +2482,9 @@ static int core_scsi3_pro_reserve(
 				" [%s]: %s trying to change TYPE and/or SCOPE,"
 				" while reservation already held by [%s]: %s,"
 				" returning RESERVATION_CONFLICT\n",
-				CMD_TFO(cmd)->get_fabric_name(),
+				cmd->se_tfo->get_fabric_name(),
 				se_sess->se_node_acl->initiatorname,
-				TPG_TFO(pr_res_nacl->se_tpg)->get_fabric_name(),
+				pr_res_nacl->se_tpg->se_tpg_tfo->get_fabric_name(),
 				pr_res_holder->pr_reg_nacl->initiatorname);
 
 			spin_unlock(&dev->dev_reservation_lock);
@@ -2518,16 +2518,16 @@ static int core_scsi3_pro_reserve(
 
 	printk(KERN_INFO "SPC-3 PR [%s] Service Action: RESERVE created new"
 		" reservation holder TYPE: %s ALL_TG_PT: %d\n",
-		CMD_TFO(cmd)->get_fabric_name(), core_scsi3_pr_dump_type(type),
+		cmd->se_tfo->get_fabric_name(), core_scsi3_pr_dump_type(type),
 		(pr_reg->pr_reg_all_tg_pt) ? 1 : 0);
 	printk(KERN_INFO "SPC-3 PR [%s] RESERVE Node: %s%s\n",
-			CMD_TFO(cmd)->get_fabric_name(),
+			cmd->se_tfo->get_fabric_name(),
 			se_sess->se_node_acl->initiatorname,
 			(prf_isid) ? &i_buf[0] : "");
 	spin_unlock(&dev->dev_reservation_lock);
 
 	if (pr_tmpl->pr_aptpl_active) {
-		ret = core_scsi3_update_and_write_aptpl(SE_DEV(cmd),
+		ret = core_scsi3_update_and_write_aptpl(cmd->se_lun->lun_se_dev,
 				&pr_reg->pr_aptpl_buf[0],
 				pr_tmpl->pr_aptpl_buf_len);
 		if (!(ret))
@@ -2608,10 +2608,10 @@ static int core_scsi3_emulate_pro_release(
 	u64 res_key)
 {
 	struct se_device *dev = cmd->se_dev;
-	struct se_session *se_sess = SE_SESS(cmd);
-	struct se_lun *se_lun = SE_LUN(cmd);
+	struct se_session *se_sess = cmd->se_sess;
+	struct se_lun *se_lun = cmd->se_lun;
 	struct t10_pr_registration *pr_reg, *pr_reg_p, *pr_res_holder;
-	struct t10_reservation_template *pr_tmpl = &SU_DEV(dev)->t10_reservation;
+	struct t10_reservation *pr_tmpl = &dev->se_sub_dev->t10_pr;
 	int ret, all_reg = 0;
 
 	if (!(se_sess) || !(se_lun)) {
@@ -2698,9 +2698,9 @@ static int core_scsi3_emulate_pro_release(
 			" reservation from [%s]: %s with different TYPE "
 			"and/or SCOPE  while reservation already held by"
 			" [%s]: %s, returning RESERVATION_CONFLICT\n",
-			CMD_TFO(cmd)->get_fabric_name(),
+			cmd->se_tfo->get_fabric_name(),
 			se_sess->se_node_acl->initiatorname,
-			TPG_TFO(pr_res_nacl->se_tpg)->get_fabric_name(),
+			pr_res_nacl->se_tpg->se_tpg_tfo->get_fabric_name(),
 			pr_res_holder->pr_reg_nacl->initiatorname);
 
 		spin_unlock(&dev->dev_reservation_lock);
@@ -2758,7 +2758,7 @@ static int core_scsi3_emulate_pro_release(
 
 write_aptpl:
 	if (pr_tmpl->pr_aptpl_active) {
-		ret = core_scsi3_update_and_write_aptpl(SE_DEV(cmd),
+		ret = core_scsi3_update_and_write_aptpl(cmd->se_lun->lun_se_dev,
 				&pr_reg->pr_aptpl_buf[0],
 				pr_tmpl->pr_aptpl_buf_len);
 		if (!(ret))
@@ -2775,15 +2775,15 @@ static int core_scsi3_emulate_pro_clear(
 {
 	struct se_device *dev = cmd->se_dev;
 	struct se_node_acl *pr_reg_nacl;
-	struct se_session *se_sess = SE_SESS(cmd);
-	struct t10_reservation_template *pr_tmpl = &SU_DEV(dev)->t10_reservation;
+	struct se_session *se_sess = cmd->se_sess;
+	struct t10_reservation *pr_tmpl = &dev->se_sub_dev->t10_pr;
 	struct t10_pr_registration *pr_reg, *pr_reg_tmp, *pr_reg_n, *pr_res_holder;
 	u32 pr_res_mapped_lun = 0;
 	int calling_it_nexus = 0;
 	/*
 	 * Locate the existing *pr_reg via struct se_node_acl pointers
 	 */
-	pr_reg_n = core_scsi3_locate_pr_reg(SE_DEV(cmd),
+	pr_reg_n = core_scsi3_locate_pr_reg(cmd->se_lun->lun_se_dev,
 			se_sess->se_node_acl, se_sess);
 	if (!(pr_reg_n)) {
 		printk(KERN_ERR "SPC-3 PR: Unable to locate"
@@ -2846,10 +2846,10 @@ static int core_scsi3_emulate_pro_clear(
 	spin_unlock(&pr_tmpl->registration_lock);
 
 	printk(KERN_INFO "SPC-3 PR [%s] Service Action: CLEAR complete\n",
-		CMD_TFO(cmd)->get_fabric_name());
+		cmd->se_tfo->get_fabric_name());
 
 	if (pr_tmpl->pr_aptpl_active) {
-		core_scsi3_update_and_write_aptpl(SE_DEV(cmd), NULL, 0);
+		core_scsi3_update_and_write_aptpl(cmd->se_lun->lun_se_dev, NULL, 0);
 		printk(KERN_INFO "SPC-3 PR: Updated APTPL metadata"
 				" for CLEAR\n");
 	}
@@ -2954,13 +2954,13 @@ static int core_scsi3_pro_preempt(
 	u64 sa_res_key,
 	int abort)
 {
-	struct se_device *dev = SE_DEV(cmd);
+	struct se_device *dev = cmd->se_lun->lun_se_dev;
 	struct se_dev_entry *se_deve;
 	struct se_node_acl *pr_reg_nacl;
-	struct se_session *se_sess = SE_SESS(cmd);
+	struct se_session *se_sess = cmd->se_sess;
 	struct list_head preempt_and_abort_list;
 	struct t10_pr_registration *pr_reg, *pr_reg_tmp, *pr_reg_n, *pr_res_holder;
-	struct t10_reservation_template *pr_tmpl = &SU_DEV(dev)->t10_reservation;
+	struct t10_reservation *pr_tmpl = &dev->se_sub_dev->t10_pr;
 	u32 pr_res_mapped_lun = 0;
 	int all_reg = 0, calling_it_nexus = 0, released_regs = 0;
 	int prh_type = 0, prh_scope = 0, ret;
@@ -2969,7 +2969,7 @@ static int core_scsi3_pro_preempt(
 		return PYX_TRANSPORT_LU_COMM_FAILURE;
 
 	se_deve = &se_sess->se_node_acl->device_list[cmd->orig_fe_lun];
-	pr_reg_n = core_scsi3_locate_pr_reg(SE_DEV(cmd), se_sess->se_node_acl,
+	pr_reg_n = core_scsi3_locate_pr_reg(cmd->se_lun->lun_se_dev, se_sess->se_node_acl,
 				se_sess);
 	if (!(pr_reg_n)) {
 		printk(KERN_ERR "SPC-3 PR: Unable to locate"
@@ -3111,7 +3111,7 @@ static int core_scsi3_pro_preempt(
 		spin_unlock(&dev->dev_reservation_lock);
 
 		if (pr_tmpl->pr_aptpl_active) {
-			ret = core_scsi3_update_and_write_aptpl(SE_DEV(cmd),
+			ret = core_scsi3_update_and_write_aptpl(cmd->se_lun->lun_se_dev,
 					&pr_reg_n->pr_aptpl_buf[0],
 					pr_tmpl->pr_aptpl_buf_len);
 			if (!(ret))
@@ -3121,7 +3121,7 @@ static int core_scsi3_pro_preempt(
 		}
 
 		core_scsi3_put_pr_reg(pr_reg_n);
-		core_scsi3_pr_generation(SE_DEV(cmd));
+		core_scsi3_pr_generation(cmd->se_lun->lun_se_dev);
 		return 0;
 	}
 	/*
@@ -3247,7 +3247,7 @@ static int core_scsi3_pro_preempt(
 	}
 
 	if (pr_tmpl->pr_aptpl_active) {
-		ret = core_scsi3_update_and_write_aptpl(SE_DEV(cmd),
+		ret = core_scsi3_update_and_write_aptpl(cmd->se_lun->lun_se_dev,
 				&pr_reg_n->pr_aptpl_buf[0],
 				pr_tmpl->pr_aptpl_buf_len);
 		if (!(ret))
@@ -3256,7 +3256,7 @@ static int core_scsi3_pro_preempt(
 	}
 
 	core_scsi3_put_pr_reg(pr_reg_n);
-	core_scsi3_pr_generation(SE_DEV(cmd));
+	core_scsi3_pr_generation(cmd->se_lun->lun_se_dev);
 	return 0;
 }
 
@@ -3297,17 +3297,17 @@ static int core_scsi3_emulate_pro_register_and_move(
 	int aptpl,
 	int unreg)
 {
-	struct se_session *se_sess = SE_SESS(cmd);
-	struct se_device *dev = SE_DEV(cmd);
+	struct se_session *se_sess = cmd->se_sess;
+	struct se_device *dev = cmd->se_lun->lun_se_dev;
 	struct se_dev_entry *se_deve, *dest_se_deve = NULL;
-	struct se_lun *se_lun = SE_LUN(cmd);
+	struct se_lun *se_lun = cmd->se_lun;
 	struct se_node_acl *pr_res_nacl, *pr_reg_nacl, *dest_node_acl = NULL;
 	struct se_port *se_port;
 	struct se_portal_group *se_tpg, *dest_se_tpg = NULL;
 	struct target_core_fabric_ops *dest_tf_ops = NULL, *tf_ops;
 	struct t10_pr_registration *pr_reg, *pr_res_holder, *dest_pr_reg;
-	struct t10_reservation_template *pr_tmpl = &SU_DEV(dev)->t10_reservation;
-	unsigned char *buf = (unsigned char *)T_TASK(cmd)->t_task_buf;
+	struct t10_reservation *pr_tmpl = &dev->se_sub_dev->t10_pr;
+	unsigned char *buf = (unsigned char *)cmd->t_task->t_task_buf;
 	unsigned char *initiator_str;
 	char *iport_ptr = NULL, dest_iport[64], i_buf[PR_REG_ISID_ID_LEN];
 	u32 tid_len, tmp_tid_len;
@@ -3322,7 +3322,7 @@ static int core_scsi3_emulate_pro_register_and_move(
 	memset(dest_iport, 0, 64);
 	memset(i_buf, 0, PR_REG_ISID_ID_LEN);
 	se_tpg = se_sess->se_tpg;
-	tf_ops = TPG_TFO(se_tpg);
+	tf_ops = se_tpg->se_tpg_tfo;
 	se_deve = &se_sess->se_node_acl->device_list[cmd->orig_fe_lun];
 	/*
 	 * Follow logic from spc4r17 Section 5.7.8, Table 50 --
@@ -3330,7 +3330,7 @@ static int core_scsi3_emulate_pro_register_and_move(
 	 *
 	 * Locate the existing *pr_reg via struct se_node_acl pointers
 	 */
-	pr_reg = core_scsi3_locate_pr_reg(SE_DEV(cmd), se_sess->se_node_acl,
+	pr_reg = core_scsi3_locate_pr_reg(cmd->se_lun->lun_se_dev, se_sess->se_node_acl,
 				se_sess);
 	if (!(pr_reg)) {
 		printk(KERN_ERR "SPC-3 PR: Unable to locate PR_REGISTERED"
@@ -3384,7 +3384,7 @@ static int core_scsi3_emulate_pro_register_and_move(
 		dest_se_tpg = se_port->sep_tpg;
 		if (!(dest_se_tpg))
 			continue;
-		dest_tf_ops = TPG_TFO(dest_se_tpg);
+		dest_tf_ops = dest_se_tpg->se_tpg_tfo;
 		if (!(dest_tf_ops))
 			continue;
 
@@ -3612,7 +3612,7 @@ after_iport_check:
 	dest_pr_reg = __core_scsi3_locate_pr_reg(dev, dest_node_acl,
 					iport_ptr);
 	if (!(dest_pr_reg)) {
-		ret = core_scsi3_alloc_registration(SE_DEV(cmd),
+		ret = core_scsi3_alloc_registration(cmd->se_lun->lun_se_dev,
 				dest_node_acl, dest_se_deve, iport_ptr,
 				sa_res_key, 0, aptpl, 2, 1);
 		if (ret != 0) {
@@ -3683,12 +3683,12 @@ after_iport_check:
 	 */
 	if (!(aptpl)) {
 		pr_tmpl->pr_aptpl_active = 0;
-		core_scsi3_update_and_write_aptpl(SE_DEV(cmd), NULL, 0);
+		core_scsi3_update_and_write_aptpl(cmd->se_lun->lun_se_dev, NULL, 0);
 		printk("SPC-3 PR: Set APTPL Bit Deactivated for"
 				" REGISTER_AND_MOVE\n");
 	} else {
 		pr_tmpl->pr_aptpl_active = 1;
-		ret = core_scsi3_update_and_write_aptpl(SE_DEV(cmd),
+		ret = core_scsi3_update_and_write_aptpl(cmd->se_lun->lun_se_dev,
 				&dest_pr_reg->pr_aptpl_buf[0],
 				pr_tmpl->pr_aptpl_buf_len);
 		if (!(ret))
@@ -3723,7 +3723,7 @@ static unsigned long long core_scsi3_extract_reservation_key(unsigned char *cdb)
  */
 static int core_scsi3_emulate_pr_out(struct se_cmd *cmd, unsigned char *cdb)
 {
-	unsigned char *buf = (unsigned char *)T_TASK(cmd)->t_task_buf;
+	unsigned char *buf = (unsigned char *)cmd->t_task->t_task_buf;
 	u64 res_key, sa_res_key;
 	int sa, scope, type, aptpl;
 	int spec_i_pt = 0, all_tg_pt = 0, unreg = 0;
@@ -3731,7 +3731,7 @@ static int core_scsi3_emulate_pr_out(struct se_cmd *cmd, unsigned char *cdb)
 	 * FIXME: A NULL struct se_session pointer means an this is not coming from
 	 * a $FABRIC_MOD's nexus, but from internal passthrough ops.
 	 */
-	if (!(SE_SESS(cmd)))
+	if (!(cmd->se_sess))
 		return PYX_TRANSPORT_LU_COMM_FAILURE;
 
 	if (cmd->data_length < 24) {
@@ -3827,10 +3827,10 @@ static int core_scsi3_emulate_pr_out(struct se_cmd *cmd, unsigned char *cdb)
  */
 static int core_scsi3_pri_read_keys(struct se_cmd *cmd)
 {
-	struct se_device *se_dev = SE_DEV(cmd);
-	struct se_subsystem_dev *su_dev = SU_DEV(se_dev);
+	struct se_device *se_dev = cmd->se_lun->lun_se_dev;
+	struct se_subsystem_dev *su_dev = se_dev->se_sub_dev;
 	struct t10_pr_registration *pr_reg;
-	unsigned char *buf = (unsigned char *)T_TASK(cmd)->t_task_buf;
+	unsigned char *buf = (unsigned char *)cmd->t_task->t_task_buf;
 	u32 add_len = 0, off = 8;
 
 	if (cmd->data_length < 8) {
@@ -3839,13 +3839,13 @@ static int core_scsi3_pri_read_keys(struct se_cmd *cmd)
 		return PYX_TRANSPORT_INVALID_CDB_FIELD;
 	}
 
-	buf[0] = ((T10_RES(su_dev)->pr_generation >> 24) & 0xff);
-	buf[1] = ((T10_RES(su_dev)->pr_generation >> 16) & 0xff);
-	buf[2] = ((T10_RES(su_dev)->pr_generation >> 8) & 0xff);
-	buf[3] = (T10_RES(su_dev)->pr_generation & 0xff);
+	buf[0] = ((su_dev->t10_pr.pr_generation >> 24) & 0xff);
+	buf[1] = ((su_dev->t10_pr.pr_generation >> 16) & 0xff);
+	buf[2] = ((su_dev->t10_pr.pr_generation >> 8) & 0xff);
+	buf[3] = (su_dev->t10_pr.pr_generation & 0xff);
 
-	spin_lock(&T10_RES(su_dev)->registration_lock);
-	list_for_each_entry(pr_reg, &T10_RES(su_dev)->registration_list,
+	spin_lock(&su_dev->t10_pr.registration_lock);
+	list_for_each_entry(pr_reg, &su_dev->t10_pr.registration_list,
 			pr_reg_list) {
 		/*
 		 * Check for overflow of 8byte PRI READ_KEYS payload and
@@ -3865,7 +3865,7 @@ static int core_scsi3_pri_read_keys(struct se_cmd *cmd)
 
 		add_len += 8;
 	}
-	spin_unlock(&T10_RES(su_dev)->registration_lock);
+	spin_unlock(&su_dev->t10_pr.registration_lock);
 
 	buf[4] = ((add_len >> 24) & 0xff);
 	buf[5] = ((add_len >> 16) & 0xff);
@@ -3882,10 +3882,10 @@ static int core_scsi3_pri_read_keys(struct se_cmd *cmd)
  */
 static int core_scsi3_pri_read_reservation(struct se_cmd *cmd)
 {
-	struct se_device *se_dev = SE_DEV(cmd);
-	struct se_subsystem_dev *su_dev = SU_DEV(se_dev);
+	struct se_device *se_dev = cmd->se_lun->lun_se_dev;
+	struct se_subsystem_dev *su_dev = se_dev->se_sub_dev;
 	struct t10_pr_registration *pr_reg;
-	unsigned char *buf = (unsigned char *)T_TASK(cmd)->t_task_buf;
+	unsigned char *buf = (unsigned char *)cmd->t_task->t_task_buf;
 	u64 pr_res_key;
 	u32 add_len = 16; /* Hardcoded to 16 when a reservation is held. */
 
@@ -3895,10 +3895,10 @@ static int core_scsi3_pri_read_reservation(struct se_cmd *cmd)
 		return PYX_TRANSPORT_INVALID_CDB_FIELD;
 	}
 
-	buf[0] = ((T10_RES(su_dev)->pr_generation >> 24) & 0xff);
-	buf[1] = ((T10_RES(su_dev)->pr_generation >> 16) & 0xff);
-	buf[2] = ((T10_RES(su_dev)->pr_generation >> 8) & 0xff);
-	buf[3] = (T10_RES(su_dev)->pr_generation & 0xff);
+	buf[0] = ((su_dev->t10_pr.pr_generation >> 24) & 0xff);
+	buf[1] = ((su_dev->t10_pr.pr_generation >> 16) & 0xff);
+	buf[2] = ((su_dev->t10_pr.pr_generation >> 8) & 0xff);
+	buf[3] = (su_dev->t10_pr.pr_generation & 0xff);
 
 	spin_lock(&se_dev->dev_reservation_lock);
 	pr_reg = se_dev->dev_pr_res_holder;
@@ -3963,9 +3963,9 @@ static int core_scsi3_pri_read_reservation(struct se_cmd *cmd)
  */
 static int core_scsi3_pri_report_capabilities(struct se_cmd *cmd)
 {
-	struct se_device *dev = SE_DEV(cmd);
-	struct t10_reservation_template *pr_tmpl = &SU_DEV(dev)->t10_reservation;
-	unsigned char *buf = (unsigned char *)T_TASK(cmd)->t_task_buf;
+	struct se_device *dev = cmd->se_lun->lun_se_dev;
+	struct t10_reservation *pr_tmpl = &dev->se_sub_dev->t10_pr;
+	unsigned char *buf = (unsigned char *)cmd->t_task->t_task_buf;
 	u16 add_len = 8; /* Hardcoded to 8. */
 
 	if (cmd->data_length < 6) {
@@ -4014,13 +4014,13 @@ static int core_scsi3_pri_report_capabilities(struct se_cmd *cmd)
  */
 static int core_scsi3_pri_read_full_status(struct se_cmd *cmd)
 {
-	struct se_device *se_dev = SE_DEV(cmd);
+	struct se_device *se_dev = cmd->se_lun->lun_se_dev;
 	struct se_node_acl *se_nacl;
-	struct se_subsystem_dev *su_dev = SU_DEV(se_dev);
+	struct se_subsystem_dev *su_dev = se_dev->se_sub_dev;
 	struct se_portal_group *se_tpg;
 	struct t10_pr_registration *pr_reg, *pr_reg_tmp;
-	struct t10_reservation *pr_tmpl = &SU_DEV(se_dev)->t10_reservation;
-	unsigned char *buf = (unsigned char *)T_TASK(cmd)->t_task_buf;
+	struct t10_reservation *pr_tmpl = &se_dev->se_sub_dev->t10_pr;
+	unsigned char *buf = (unsigned char *)cmd->t_task->t_task_buf;
 	u32 add_desc_len = 0, add_len = 0, desc_len, exp_desc_len;
 	u32 off = 8; /* off into first Full Status descriptor */
 	int format_code = 0;
@@ -4031,10 +4031,10 @@ static int core_scsi3_pri_read_full_status(struct se_cmd *cmd)
 		return PYX_TRANSPORT_INVALID_CDB_FIELD;
 	}
 
-	buf[0] = ((T10_RES(su_dev)->pr_generation >> 24) & 0xff);
-	buf[1] = ((T10_RES(su_dev)->pr_generation >> 16) & 0xff);
-	buf[2] = ((T10_RES(su_dev)->pr_generation >> 8) & 0xff);
-	buf[3] = (T10_RES(su_dev)->pr_generation & 0xff);
+	buf[0] = ((su_dev->t10_pr.pr_generation >> 24) & 0xff);
+	buf[1] = ((su_dev->t10_pr.pr_generation >> 16) & 0xff);
+	buf[2] = ((su_dev->t10_pr.pr_generation >> 8) & 0xff);
+	buf[3] = (su_dev->t10_pr.pr_generation & 0xff);
 
 	spin_lock(&pr_tmpl->registration_lock);
 	list_for_each_entry_safe(pr_reg, pr_reg_tmp,
@@ -4051,7 +4051,7 @@ static int core_scsi3_pri_read_full_status(struct se_cmd *cmd)
 		 * Determine expected length of $FABRIC_MOD specific
 		 * TransportID full status descriptor..
 		 */
-		exp_desc_len = TPG_TFO(se_tpg)->tpg_get_pr_transport_id_len(
+		exp_desc_len = se_tpg->se_tpg_tfo->tpg_get_pr_transport_id_len(
 				se_tpg, se_nacl, pr_reg, &format_code);
 
 		if ((exp_desc_len + add_len) > cmd->data_length) {
@@ -4116,7 +4116,7 @@ static int core_scsi3_pri_read_full_status(struct se_cmd *cmd)
 		/*
 		 * Now, have the $FABRIC_MOD fill in the protocol identifier
 		 */
-		desc_len = TPG_TFO(se_tpg)->tpg_get_pr_transport_id(se_tpg,
+		desc_len = se_tpg->se_tpg_tfo->tpg_get_pr_transport_id(se_tpg,
 				se_nacl, pr_reg, &format_code, &buf[off+4]);
 
 		spin_lock(&pr_tmpl->registration_lock);
@@ -4174,7 +4174,7 @@ static int core_scsi3_emulate_pr_in(struct se_cmd *cmd, unsigned char *cdb)
 
 int core_scsi3_emulate_pr(struct se_cmd *cmd)
 {
-	unsigned char *cdb = &T_TASK(cmd)->t_task_cdb[0];
+	unsigned char *cdb = &cmd->t_task->t_task_cdb[0];
 	struct se_device *dev = cmd->se_dev;
 	/*
 	 * Following spc2r20 5.5.1 Reservations overview:
@@ -4213,39 +4213,39 @@ static int core_pt_seq_non_holder(
 int core_setup_reservations(struct se_device *dev, int force_pt)
 {
 	struct se_subsystem_dev *su_dev = dev->se_sub_dev;
-	struct t10_reservation *rest = &su_dev->t10_reservation;
+	struct t10_reservation *rest = &su_dev->t10_pr;
 	/*
 	 * If this device is from Target_Core_Mod/pSCSI, use the reservations
 	 * of the Underlying SCSI hardware.  In Linux/SCSI terms, this can
 	 * cause a problem because libata and some SATA RAID HBAs appear
 	 * under Linux/SCSI, but to emulate reservations themselves.
 	 */
-	if (((TRANSPORT(dev)->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV) &&
-	    !(DEV_ATTRIB(dev)->emulate_reservations)) || force_pt) {
+	if (((dev->transport->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV) &&
+	    !(dev->se_sub_dev->se_dev_attrib.emulate_reservations)) || force_pt) {
 		rest->res_type = SPC_PASSTHROUGH;
 		rest->pr_ops.t10_reservation_check = &core_pt_reservation_check;
 		rest->pr_ops.t10_seq_non_holder = &core_pt_seq_non_holder;
 		printk(KERN_INFO "%s: Using SPC_PASSTHROUGH, no reservation"
-			" emulation\n", TRANSPORT(dev)->name);
+			" emulation\n", dev->transport->name);
 		return 0;
 	}
 	/*
 	 * If SPC-3 or above is reported by real or emulated struct se_device,
 	 * use emulated Persistent Reservations.
 	 */
-	if (TRANSPORT(dev)->get_device_rev(dev) >= SCSI_3) {
+	if (dev->transport->get_device_rev(dev) >= SCSI_3) {
 		rest->res_type = SPC3_PERSISTENT_RESERVATIONS;
 		rest->pr_ops.t10_reservation_check = &core_scsi3_pr_reservation_check;
 		rest->pr_ops.t10_seq_non_holder = &core_scsi3_pr_seq_non_holder;
 		printk(KERN_INFO "%s: Using SPC3_PERSISTENT_RESERVATIONS"
-			" emulation\n", TRANSPORT(dev)->name);
+			" emulation\n", dev->transport->name);
 	} else {
 		rest->res_type = SPC2_RESERVATIONS;
 		rest->pr_ops.t10_reservation_check = &core_scsi2_reservation_check;
 		rest->pr_ops.t10_seq_non_holder =
 				&core_scsi2_reservation_seq_non_holder;
 		printk(KERN_INFO "%s: Using SPC2_RESERVATIONS emulation\n",
-			TRANSPORT(dev)->name);
+			dev->transport->name);
 	}
 
 	return 0;
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index afe5f57..44a79a5 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -692,13 +692,12 @@ static int pscsi_transport_complete(struct se_task *task)
 	 */
 	if (((cdb[0] == MODE_SENSE) || (cdb[0] == MODE_SENSE_10)) &&
 	     (status_byte(result) << 1) == SAM_STAT_GOOD) {
-		if (!TASK_CMD(task)->se_deve)
+		if (!task->task_se_cmd->se_deve)
 			goto after_mode_sense;
 
-		if (TASK_CMD(task)->se_deve->lun_flags &
+		if (task->task_se_cmd->se_deve->lun_flags &
 				TRANSPORT_LUNFLAGS_READ_ONLY) {
-			unsigned char *buf = (unsigned char *)
-				T_TASK(task->task_se_cmd)->t_task_buf;
+			unsigned char *buf = task->task_se_cmd->t_task->t_task_buf;
 
 			if (cdb[0] == MODE_SENSE_10) {
 				if (!(buf[3] & 0x80))
@@ -764,7 +763,7 @@ static struct se_task *
 pscsi_alloc_task(struct se_cmd *cmd)
 {
 	struct pscsi_plugin_task *pt;
-	unsigned char *cdb = T_TASK(cmd)->t_task_cdb;
+	unsigned char *cdb = cmd->t_task->t_task_cdb;
 
 	pt = kzalloc(sizeof(struct pscsi_plugin_task), GFP_KERNEL);
 	if (!pt) {
@@ -777,7 +776,7 @@ pscsi_alloc_task(struct se_cmd *cmd)
 	 * allocate the extended CDB buffer for per struct se_task context
 	 * pt->pscsi_cdb now.
 	 */
-	if (T_TASK(cmd)->t_task_cdb != T_TASK(cmd)->__t_task_cdb) {
+	if (cmd->t_task->t_task_cdb != cmd->t_task->__t_task_cdb) {
 
 		pt->pscsi_cdb = kzalloc(scsi_command_size(cdb), GFP_KERNEL);
 		if (!(pt->pscsi_cdb)) {
@@ -890,7 +889,7 @@ static void pscsi_free_task(struct se_task *task)
 	 * Release the extended CDB allocation from pscsi_alloc_task()
 	 * if one exists.
 	 */
-	if (T_TASK(cmd)->t_task_cdb != T_TASK(cmd)->__t_task_cdb)
+	if (cmd->t_task->t_task_cdb != cmd->t_task->__t_task_cdb)
 		kfree(pt->pscsi_cdb);
 	/*
 	 * We do not release the bio(s) here associated with this task, as
@@ -1255,7 +1254,7 @@ static int pscsi_map_task_SG(struct se_task *task)
  */
 static int pscsi_map_task_non_SG(struct se_task *task)
 {
-	struct se_cmd *cmd = TASK_CMD(task);
+	struct se_cmd *cmd = task->task_se_cmd;
 	struct pscsi_plugin_task *pt = PSCSI_TASK(task);
 	struct pscsi_dev_virt *pdv = task->se_dev->dev_ptr;
 	int ret = 0;
@@ -1267,7 +1266,7 @@ static int pscsi_map_task_non_SG(struct se_task *task)
 		return 0;
 
 	ret = blk_rq_map_kern(pdv->pdv_sd->request_queue,
-			pt->pscsi_req, T_TASK(cmd)->t_task_buf,
+			pt->pscsi_req, cmd->t_task->t_task_buf,
 			task->task_size, GFP_KERNEL);
 	if (ret < 0) {
 		printk(KERN_ERR "PSCSI: blk_rq_map_kern() failed: %d\n", ret);
@@ -1364,7 +1363,7 @@ static inline void pscsi_process_SAM_status(
 			pt->pscsi_result);
 		task->task_scsi_status = SAM_STAT_CHECK_CONDITION;
 		task->task_error_status = PYX_TRANSPORT_UNKNOWN_SAM_OPCODE;
-		TASK_CMD(task)->transport_error_status =
+		task->task_se_cmd->transport_error_status =
 					PYX_TRANSPORT_UNKNOWN_SAM_OPCODE;
 		transport_complete_task(task, 0);
 		break;
diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 0a424bb..fbf06c3 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -336,7 +336,7 @@ rd_alloc_task(struct se_cmd *cmd)
 		printk(KERN_ERR "Unable to allocate struct rd_request\n");
 		return NULL;
 	}
-	rd_req->rd_dev = SE_DEV(cmd)->dev_ptr;
+	rd_req->rd_dev = cmd->se_lun->lun_se_dev->dev_ptr;
 
 	return &rd_req->rd_task;
 }
@@ -620,11 +620,11 @@ static int rd_MEMCPY_do_task(struct se_task *task)
 	unsigned long long lba;
 	int ret;
 
-	req->rd_page = (task->task_lba * DEV_ATTRIB(dev)->block_size) / PAGE_SIZE;
+	req->rd_page = (task->task_lba * dev->se_sub_dev->se_dev_attrib.block_size) / PAGE_SIZE;
 	lba = task->task_lba;
 	req->rd_offset = (do_div(lba,
-			  (PAGE_SIZE / DEV_ATTRIB(dev)->block_size))) *
-			   DEV_ATTRIB(dev)->block_size;
+			  (PAGE_SIZE / dev->se_sub_dev->se_dev_attrib.block_size))) *
+			   dev->se_sub_dev->se_dev_attrib.block_size;
 	req->rd_size = task->task_size;
 
 	if (task->task_data_direction == DMA_FROM_DEVICE)
@@ -737,7 +737,7 @@ check_eot:
 	}
 
 out:
-	T_TASK(task->task_se_cmd)->t_tasks_se_num += *se_mem_cnt;
+	task->task_se_cmd->t_task->t_tasks_se_num += *se_mem_cnt;
 #ifdef DEBUG_RAMDISK_DR
 	printk(KERN_INFO "RD_DR - Allocated %u struct se_mem segments for task\n",
 			*se_mem_cnt);
@@ -819,7 +819,7 @@ static int rd_DIRECT_without_offset(
 	}
 
 out:
-	T_TASK(task->task_se_cmd)->t_tasks_se_num += *se_mem_cnt;
+	task->task_se_cmd->t_task->t_tasks_se_num += *se_mem_cnt;
 #ifdef DEBUG_RAMDISK_DR
 	printk(KERN_INFO "RD_DR - Allocated %u struct se_mem segments for task\n",
 			*se_mem_cnt);
@@ -845,13 +845,11 @@ static int rd_DIRECT_do_se_mem_map(
 	u32 task_offset = *task_offset_in;
 	unsigned long long lba;
 	int ret;
+	int block_size = task->se_dev->se_sub_dev->se_dev_attrib.block_size;
 
-	req->rd_page = ((task->task_lba * DEV_ATTRIB(task->se_dev)->block_size) /
-			PAGE_SIZE);
 	lba = task->task_lba;
-	req->rd_offset = (do_div(lba,
-			  (PAGE_SIZE / DEV_ATTRIB(task->se_dev)->block_size))) *
-			   DEV_ATTRIB(task->se_dev)->block_size;
+	req->rd_page = ((task->task_lba * block_size) /	PAGE_SIZE);
+	req->rd_offset = (do_div(lba, (PAGE_SIZE / block_size))) * block_size;
 	req->rd_size = task->task_size;
 
 	if (req->rd_offset)
@@ -864,7 +862,7 @@ static int rd_DIRECT_do_se_mem_map(
 	if (ret < 0)
 		return ret;
 
-	if (CMD_TFO(cmd)->task_sg_chaining == 0)
+	if (cmd->se_tfo->task_sg_chaining == 0)
 		return 0;
 	/*
 	 * Currently prevent writers from multiple HW fabrics doing
@@ -882,14 +880,14 @@ static int rd_DIRECT_do_se_mem_map(
 	 * across multiple struct se_task->task_sg[].
 	 */
 	ret = transport_init_task_sg(task,
-			list_entry(T_TASK(cmd)->t_mem_list->next,
+			list_entry(cmd->t_task->t_mem_list->next,
 				   struct se_mem, se_list),
 			task_offset);
 	if (ret <= 0)
 		return ret;
 
 	return transport_map_mem_to_sg(task, se_mem_list, task->task_sg,
-			list_entry(T_TASK(cmd)->t_mem_list->next,
+			list_entry(cmd->t_task->t_mem_list->next,
 				   struct se_mem, se_list),
 			out_se_mem, se_mem_cnt, task_offset_in);
 }
@@ -1019,7 +1017,7 @@ static sector_t rd_get_blocks(struct se_device *dev)
 {
 	struct rd_dev *rd_dev = dev->dev_ptr;
 	unsigned long long blocks_long = ((rd_dev->rd_page_count * PAGE_SIZE) /
-			DEV_ATTRIB(dev)->block_size) - 1;
+			dev->se_sub_dev->se_dev_attrib.block_size) - 1;
 
 	return blocks_long;
 }
diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
index 5e3a067..a8d6e1d 100644
--- a/drivers/target/target_core_stat.c
+++ b/drivers/target/target_core_stat.c
@@ -402,8 +402,8 @@ static ssize_t target_stat_scsi_lu_show_attr_lu_name(
 		return -ENODEV;
 	/* scsiLuWwnName */
 	return snprintf(page, PAGE_SIZE, "%s\n",
-			(strlen(DEV_T10_WWN(dev)->unit_serial)) ?
-			(char *)&DEV_T10_WWN(dev)->unit_serial[0] : "None");
+			(strlen(dev->se_sub_dev->t10_wwn.unit_serial)) ?
+			dev->se_sub_dev->t10_wwn.unit_serial : "None");
 }
 DEV_STAT_SCSI_LU_ATTR_RO(lu_name);
 
@@ -413,17 +413,17 @@ static ssize_t target_stat_scsi_lu_show_attr_vend(
 	struct se_subsystem_dev *se_subdev = container_of(sgrps,
 			struct se_subsystem_dev, dev_stat_grps);
 	struct se_device *dev = se_subdev->se_dev_ptr;
-	int j;
-	char str[28];
+	int i;
+	char str[sizeof(dev->se_sub_dev->t10_wwn.vendor)+1];
 
 	if (!dev)
 		return -ENODEV;
+
 	/* scsiLuVendorId */
-	memcpy(&str[0], (void *)DEV_T10_WWN(dev), 28);
-	for (j = 0; j < 8; j++)
-		str[j] = ISPRINT(DEV_T10_WWN(dev)->vendor[j]) ?
-				DEV_T10_WWN(dev)->vendor[j] : 0x20;
-	str[8] = 0;
+	for (i = 0; i < sizeof(dev->se_sub_dev->t10_wwn.vendor); i++)
+		str[i] = ISPRINT(dev->se_sub_dev->t10_wwn.vendor[i]) ?
+			dev->se_sub_dev->t10_wwn.vendor[i] : ' ';
+	str[i] = '\0';
 	return snprintf(page, PAGE_SIZE, "%s\n", str);
 }
 DEV_STAT_SCSI_LU_ATTR_RO(vend);
@@ -434,18 +434,17 @@ static ssize_t target_stat_scsi_lu_show_attr_prod(
 	struct se_subsystem_dev *se_subdev = container_of(sgrps,
 			struct se_subsystem_dev, dev_stat_grps);
 	struct se_device *dev = se_subdev->se_dev_ptr;
-	int j;
-	char str[28];
+	int i;
+	char str[sizeof(dev->se_sub_dev->t10_wwn.model)+1];
 
 	if (!dev)
 		return -ENODEV;
 
 	/* scsiLuProductId */
-	memcpy(&str[0], (void *)DEV_T10_WWN(dev), 28);
-	for (j = 0; j < 16; j++)
-		str[j] = ISPRINT(DEV_T10_WWN(dev)->model[j]) ?
-				DEV_T10_WWN(dev)->model[j] : 0x20;
-	str[16] = 0;
+	for (i = 0; i < sizeof(dev->se_sub_dev->t10_wwn.vendor); i++)
+		str[i] = ISPRINT(dev->se_sub_dev->t10_wwn.model[i]) ?
+			dev->se_sub_dev->t10_wwn.model[i] : ' ';
+	str[i] = '\0';
 	return snprintf(page, PAGE_SIZE, "%s\n", str);
 }
 DEV_STAT_SCSI_LU_ATTR_RO(prod);
@@ -456,18 +455,17 @@ static ssize_t target_stat_scsi_lu_show_attr_rev(
 	struct se_subsystem_dev *se_subdev = container_of(sgrps,
 			struct se_subsystem_dev, dev_stat_grps);
 	struct se_device *dev = se_subdev->se_dev_ptr;
-	int j;
-	char str[28];
+	int i;
+	char str[sizeof(dev->se_sub_dev->t10_wwn.revision)+1];
 
 	if (!dev)
 		return -ENODEV;
 
 	/* scsiLuRevisionId */
-	memcpy(&str[0], (void *)DEV_T10_WWN(dev), 28);
-	for (j = 0; j < 4; j++)
-		str[j] = ISPRINT(DEV_T10_WWN(dev)->revision[j]) ?
-				DEV_T10_WWN(dev)->revision[j] : 0x20;
-	str[4] = 0;
+	for (i = 0; i < sizeof(dev->se_sub_dev->t10_wwn.revision); i++)
+		str[i] = ISPRINT(dev->se_sub_dev->t10_wwn.revision[i]) ?
+			dev->se_sub_dev->t10_wwn.revision[i] : ' ';
+	str[i] = '\0';
 	return snprintf(page, PAGE_SIZE, "%s\n", str);
 }
 DEV_STAT_SCSI_LU_ATTR_RO(rev);
@@ -484,7 +482,7 @@ static ssize_t target_stat_scsi_lu_show_attr_dev_type(
 
 	/* scsiLuPeripheralType */
 	return snprintf(page, PAGE_SIZE, "%u\n",
-			TRANSPORT(dev)->get_device_type(dev));
+			dev->transport->get_device_type(dev));
 }
 DEV_STAT_SCSI_LU_ATTR_RO(dev_type);
 
@@ -668,18 +666,18 @@ static struct config_item_type target_stat_scsi_lu_cit = {
  */
 void target_stat_setup_dev_default_groups(struct se_subsystem_dev *se_subdev)
 {
-	struct config_group *dev_stat_grp = &DEV_STAT_GRP(se_subdev)->stat_group;
+	struct config_group *dev_stat_grp = &se_subdev->dev_stat_grps.stat_group;
 
-	config_group_init_type_name(&DEV_STAT_GRP(se_subdev)->scsi_dev_group,
+	config_group_init_type_name(&se_subdev->dev_stat_grps.scsi_dev_group,
 			"scsi_dev", &target_stat_scsi_dev_cit);
-	config_group_init_type_name(&DEV_STAT_GRP(se_subdev)->scsi_tgt_dev_group,
+	config_group_init_type_name(&se_subdev->dev_stat_grps.scsi_tgt_dev_group,
 			"scsi_tgt_dev", &target_stat_scsi_tgt_dev_cit);
-	config_group_init_type_name(&DEV_STAT_GRP(se_subdev)->scsi_lu_group,
+	config_group_init_type_name(&se_subdev->dev_stat_grps.scsi_lu_group,
 			"scsi_lu", &target_stat_scsi_lu_cit);
 
-	dev_stat_grp->default_groups[0] = &DEV_STAT_GRP(se_subdev)->scsi_dev_group;
-	dev_stat_grp->default_groups[1] = &DEV_STAT_GRP(se_subdev)->scsi_tgt_dev_group;
-	dev_stat_grp->default_groups[2] = &DEV_STAT_GRP(se_subdev)->scsi_lu_group;
+	dev_stat_grp->default_groups[0] = &se_subdev->dev_stat_grps.scsi_dev_group;
+	dev_stat_grp->default_groups[1] = &se_subdev->dev_stat_grps.scsi_tgt_dev_group;
+	dev_stat_grp->default_groups[2] = &se_subdev->dev_stat_grps.scsi_lu_group;
 	dev_stat_grp->default_groups[3] = NULL;
 }
 
@@ -922,7 +920,7 @@ static ssize_t target_stat_scsi_tgt_port_show_attr_name(
 	tpg = sep->sep_tpg;
 
 	ret = snprintf(page, PAGE_SIZE, "%sPort#%u\n",
-		TPG_TFO(tpg)->get_fabric_name(), sep->sep_index);
+		tpg->se_tpg_tfo->get_fabric_name(), sep->sep_index);
 	spin_unlock(&lun->lun_sep_lock);
 	return ret;
 }
@@ -945,8 +943,8 @@ static ssize_t target_stat_scsi_tgt_port_show_attr_port_index(
 	tpg = sep->sep_tpg;
 
 	ret = snprintf(page, PAGE_SIZE, "%s%s%d\n",
-		TPG_TFO(tpg)->tpg_get_wwn(tpg), "+t+",
-		TPG_TFO(tpg)->tpg_get_tag(tpg));
+		tpg->se_tpg_tfo->tpg_get_wwn(tpg), "+t+",
+		tpg->se_tpg_tfo->tpg_get_tag(tpg));
 	spin_unlock(&lun->lun_sep_lock);
 	return ret;
 }
@@ -1128,7 +1126,7 @@ static ssize_t target_stat_scsi_transport_show_attr_device(
 	tpg = sep->sep_tpg;
 	/* scsiTransportType */
 	ret = snprintf(page, PAGE_SIZE, "scsiTransport%s\n",
-			TPG_TFO(tpg)->get_fabric_name());
+			tpg->se_tpg_tfo->get_fabric_name());
 	spin_unlock(&lun->lun_sep_lock);
 	return ret;
 }
@@ -1150,7 +1148,7 @@ static ssize_t target_stat_scsi_transport_show_attr_indx(
 	}
 	tpg = sep->sep_tpg;
 	ret = snprintf(page, PAGE_SIZE, "%u\n",
-			TPG_TFO(tpg)->tpg_get_inst_index(tpg));
+			tpg->se_tpg_tfo->tpg_get_inst_index(tpg));
 	spin_unlock(&lun->lun_sep_lock);
 	return ret;
 }
@@ -1173,10 +1171,10 @@ static ssize_t target_stat_scsi_transport_show_attr_dev_name(
 		return -ENODEV;
 	}
 	tpg = sep->sep_tpg;
-	wwn = DEV_T10_WWN(dev);
+	wwn = &dev->se_sub_dev->t10_wwn;
 	/* scsiTransportDevName */
 	ret = snprintf(page, PAGE_SIZE, "%s+%s\n",
-			TPG_TFO(tpg)->tpg_get_wwn(tpg),
+			tpg->se_tpg_tfo->tpg_get_wwn(tpg),
 			(strlen(wwn->unit_serial)) ? wwn->unit_serial :
 			wwn->vendor);
 	spin_unlock(&lun->lun_sep_lock);
@@ -1212,18 +1210,18 @@ static struct config_item_type target_stat_scsi_transport_cit = {
  */
 void target_stat_setup_port_default_groups(struct se_lun *lun)
 {
-	struct config_group *port_stat_grp = &PORT_STAT_GRP(lun)->stat_group;
+	struct config_group *port_stat_grp = &lun->port_stat_grps.stat_group;
 
-	config_group_init_type_name(&PORT_STAT_GRP(lun)->scsi_port_group,
+	config_group_init_type_name(&lun->port_stat_grps.scsi_port_group,
 			"scsi_port", &target_stat_scsi_port_cit);
-	config_group_init_type_name(&PORT_STAT_GRP(lun)->scsi_tgt_port_group,
+	config_group_init_type_name(&lun->port_stat_grps.scsi_tgt_port_group,
 			"scsi_tgt_port", &target_stat_scsi_tgt_port_cit);
-	config_group_init_type_name(&PORT_STAT_GRP(lun)->scsi_transport_group,
+	config_group_init_type_name(&lun->port_stat_grps.scsi_transport_group,
 			"scsi_transport", &target_stat_scsi_transport_cit);
 
-	port_stat_grp->default_groups[0] = &PORT_STAT_GRP(lun)->scsi_port_group;
-	port_stat_grp->default_groups[1] = &PORT_STAT_GRP(lun)->scsi_tgt_port_group;
-	port_stat_grp->default_groups[2] = &PORT_STAT_GRP(lun)->scsi_transport_group;
+	port_stat_grp->default_groups[0] = &lun->port_stat_grps.scsi_port_group;
+	port_stat_grp->default_groups[1] = &lun->port_stat_grps.scsi_tgt_port_group;
+	port_stat_grp->default_groups[2] = &lun->port_stat_grps.scsi_transport_group;
 	port_stat_grp->default_groups[3] = NULL;
 }
 
@@ -1264,7 +1262,7 @@ static ssize_t target_stat_scsi_auth_intr_show_attr_inst(
 	tpg = nacl->se_tpg;
 	/* scsiInstIndex */
 	ret = snprintf(page, PAGE_SIZE, "%u\n",
-			TPG_TFO(tpg)->tpg_get_inst_index(tpg));
+			tpg->se_tpg_tfo->tpg_get_inst_index(tpg));
 	spin_unlock_irq(&nacl->device_list_lock);
 	return ret;
 }
@@ -1314,7 +1312,7 @@ static ssize_t target_stat_scsi_auth_intr_show_attr_port(
 	}
 	tpg = nacl->se_tpg;
 	/* scsiAuthIntrTgtPortIndex */
-	ret = snprintf(page, PAGE_SIZE, "%u\n", TPG_TFO(tpg)->tpg_get_tag(tpg));
+	ret = snprintf(page, PAGE_SIZE, "%u\n", tpg->se_tpg_tfo->tpg_get_tag(tpg));
 	spin_unlock_irq(&nacl->device_list_lock);
 	return ret;
 }
@@ -1632,7 +1630,7 @@ static ssize_t target_stat_scsi_att_intr_port_show_attr_inst(
 	tpg = nacl->se_tpg;
 	/* scsiInstIndex */
 	ret = snprintf(page, PAGE_SIZE, "%u\n",
-			TPG_TFO(tpg)->tpg_get_inst_index(tpg));
+			tpg->se_tpg_tfo->tpg_get_inst_index(tpg));
 	spin_unlock_irq(&nacl->device_list_lock);
 	return ret;
 }
@@ -1682,7 +1680,7 @@ static ssize_t target_stat_scsi_att_intr_port_show_attr_port(
 	}
 	tpg = nacl->se_tpg;
 	/* scsiPortIndex */
-	ret = snprintf(page, PAGE_SIZE, "%u\n", TPG_TFO(tpg)->tpg_get_tag(tpg));
+	ret = snprintf(page, PAGE_SIZE, "%u\n", tpg->se_tpg_tfo->tpg_get_tag(tpg));
 	spin_unlock_irq(&nacl->device_list_lock);
 	return ret;
 }
@@ -1708,7 +1706,7 @@ static ssize_t target_stat_scsi_att_intr_port_show_attr_indx(
 	tpg = nacl->se_tpg;
 	/* scsiAttIntrPortIndex */
 	ret = snprintf(page, PAGE_SIZE, "%u\n",
-			TPG_TFO(tpg)->sess_get_index(se_sess));
+			tpg->se_tpg_tfo->sess_get_index(se_sess));
 	spin_unlock_irq(&nacl->nacl_sess_lock);
 	return ret;
 }
@@ -1757,8 +1755,8 @@ static ssize_t target_stat_scsi_att_intr_port_show_attr_port_ident(
 	tpg = nacl->se_tpg;
 	/* scsiAttIntrPortName+scsiAttIntrPortIdentifier */
 	memset(buf, 0, 64);
-	if (TPG_TFO(tpg)->sess_get_initiator_sid != NULL)
-		TPG_TFO(tpg)->sess_get_initiator_sid(se_sess,
+	if (tpg->se_tpg_tfo->sess_get_initiator_sid != NULL)
+		tpg->se_tpg_tfo->sess_get_initiator_sid(se_sess,
 				(unsigned char *)&buf[0], 64);
 
 	ret = snprintf(page, PAGE_SIZE, "%s+i+%s\n", nacl->initiatorname, buf);
@@ -1797,14 +1795,14 @@ static struct config_item_type target_stat_scsi_att_intr_port_cit = {
  */
 void target_stat_setup_mappedlun_default_groups(struct se_lun_acl *lacl)
 {
-	struct config_group *ml_stat_grp = &ML_STAT_GRPS(lacl)->stat_group;
+	struct config_group *ml_stat_grp = &lacl->ml_stat_grps.stat_group;
 
-	config_group_init_type_name(&ML_STAT_GRPS(lacl)->scsi_auth_intr_group,
+	config_group_init_type_name(&lacl->ml_stat_grps.scsi_auth_intr_group,
 			"scsi_auth_intr", &target_stat_scsi_auth_intr_cit);
-	config_group_init_type_name(&ML_STAT_GRPS(lacl)->scsi_att_intr_port_group,
+	config_group_init_type_name(&lacl->ml_stat_grps.scsi_att_intr_port_group,
 			"scsi_att_intr_port", &target_stat_scsi_att_intr_port_cit);
 
-	ml_stat_grp->default_groups[0] = &ML_STAT_GRPS(lacl)->scsi_auth_intr_group;
-	ml_stat_grp->default_groups[1] = &ML_STAT_GRPS(lacl)->scsi_att_intr_port_group;
+	ml_stat_grp->default_groups[0] = &lacl->ml_stat_grps.scsi_auth_intr_group;
+	ml_stat_grp->default_groups[1] = &lacl->ml_stat_grps.scsi_att_intr_port_group;
 	ml_stat_grp->default_groups[2] = NULL;
 }
diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index 7cd8e29..2f73749 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -133,7 +133,7 @@ int core_tmr_lun_reset(
 	 * which the command was received shall be completed with TASK ABORTED
 	 * status (see SAM-4).
 	 */
-	tas = DEV_ATTRIB(dev)->emulate_tas;
+	tas = dev->se_sub_dev->se_dev_attrib.emulate_tas;
 	/*
 	 * Determine if this se_tmr is coming from a $FABRIC_MOD
 	 * or struct se_device passthrough..
@@ -144,13 +144,13 @@ int core_tmr_lun_reset(
 		if (tmr_nacl && tmr_tpg) {
 			DEBUG_LR("LUN_RESET: TMR caller fabric: %s"
 				" initiator port %s\n",
-				TPG_TFO(tmr_tpg)->get_fabric_name(),
+				tmr_tpg->se_tpg_tfo->get_fabric_name(),
 				tmr_nacl->initiatorname);
 		}
 	}
 	DEBUG_LR("LUN_RESET: %s starting for [%s], tas: %d\n",
 		(preempt_and_abort_list) ? "Preempt" : "TMR",
-		TRANSPORT(dev)->name, tas);
+		dev->transport->name, tas);
 	/*
 	 * Release all pending and outgoing TMRs aside from the received
 	 * LUN_RESET tmr..
@@ -179,14 +179,14 @@ int core_tmr_lun_reset(
 			continue;
 		spin_unlock(&dev->se_tmr_lock);
 
-		spin_lock_irqsave(&T_TASK(cmd)->t_state_lock, flags);
-		if (!(atomic_read(&T_TASK(cmd)->t_transport_active))) {
-			spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
+		spin_lock_irqsave(&cmd->t_task->t_state_lock, flags);
+		if (!(atomic_read(&cmd->t_task->t_transport_active))) {
+			spin_unlock_irqrestore(&cmd->t_task->t_state_lock, flags);
 			spin_lock(&dev->se_tmr_lock);
 			continue;
 		}
 		if (cmd->t_state == TRANSPORT_ISTATE_PROCESSING) {
-			spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
+			spin_unlock_irqrestore(&cmd->t_task->t_state_lock, flags);
 			spin_lock(&dev->se_tmr_lock);
 			continue;
 		}
@@ -194,7 +194,7 @@ int core_tmr_lun_reset(
 			" Response: 0x%02x, t_state: %d\n",
 			(preempt_and_abort_list) ? "Preempt" : "", tmr_p,
 			tmr_p->function, tmr_p->response, cmd->t_state);
-		spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
+		spin_unlock_irqrestore(&cmd->t_task->t_state_lock, flags);
 
 		transport_cmd_finish_abort_tmr(cmd);
 		spin_lock(&dev->se_tmr_lock);
@@ -224,16 +224,16 @@ int core_tmr_lun_reset(
 	spin_lock_irqsave(&dev->execute_task_lock, flags);
 	list_for_each_entry_safe(task, task_tmp, &dev->state_task_list,
 				t_state_list) {
-		if (!(TASK_CMD(task))) {
-			printk(KERN_ERR "TASK_CMD(task) is NULL!\n");
+		if (!task->task_se_cmd) {
+			printk(KERN_ERR "task->task_se_cmd is NULL!\n");
 			continue;
 		}
-		cmd = TASK_CMD(task);
+		cmd = task->task_se_cmd;
 
-		if (!T_TASK(cmd)) {
-			printk(KERN_ERR "T_TASK(cmd) is NULL for task: %p cmd:"
+		if (!cmd->t_task) {
+			printk(KERN_ERR "cmd->t_task is NULL for task: %p cmd:"
 				" %p ITT: 0x%08x\n", task, cmd,
-				CMD_TFO(cmd)->get_task_tag(cmd));
+				cmd->se_tfo->get_task_tag(cmd));
 			continue;
 		}
 		/*
@@ -254,38 +254,38 @@ int core_tmr_lun_reset(
 		atomic_set(&task->task_state_active, 0);
 		spin_unlock_irqrestore(&dev->execute_task_lock, flags);
 
-		spin_lock_irqsave(&T_TASK(cmd)->t_state_lock, flags);
+		spin_lock_irqsave(&cmd->t_task->t_state_lock, flags);
 		DEBUG_LR("LUN_RESET: %s cmd: %p task: %p"
 			" ITT/CmdSN: 0x%08x/0x%08x, i_state: %d, t_state/"
 			"def_t_state: %d/%d cdb: 0x%02x\n",
 			(preempt_and_abort_list) ? "Preempt" : "", cmd, task,
-			CMD_TFO(cmd)->get_task_tag(cmd), 0,
-			CMD_TFO(cmd)->get_cmd_state(cmd), cmd->t_state,
-			cmd->deferred_t_state, T_TASK(cmd)->t_task_cdb[0]);
+			cmd->se_tfo->get_task_tag(cmd), 0,
+			cmd->se_tfo->get_cmd_state(cmd), cmd->t_state,
+			cmd->deferred_t_state, cmd->t_task->t_task_cdb[0]);
 		DEBUG_LR("LUN_RESET: ITT[0x%08x] - pr_res_key: 0x%016Lx"
 			" t_task_cdbs: %d t_task_cdbs_left: %d"
 			" t_task_cdbs_sent: %d -- t_transport_active: %d"
 			" t_transport_stop: %d t_transport_sent: %d\n",
-			CMD_TFO(cmd)->get_task_tag(cmd), cmd->pr_res_key,
-			T_TASK(cmd)->t_task_cdbs,
-			atomic_read(&T_TASK(cmd)->t_task_cdbs_left),
-			atomic_read(&T_TASK(cmd)->t_task_cdbs_sent),
-			atomic_read(&T_TASK(cmd)->t_transport_active),
-			atomic_read(&T_TASK(cmd)->t_transport_stop),
-			atomic_read(&T_TASK(cmd)->t_transport_sent));
+			cmd->se_tfo->get_task_tag(cmd), cmd->pr_res_key,
+			cmd->t_task->t_task_cdbs,
+			atomic_read(&cmd->t_task->t_task_cdbs_left),
+			atomic_read(&cmd->t_task->t_task_cdbs_sent),
+			atomic_read(&cmd->t_task->t_transport_active),
+			atomic_read(&cmd->t_task->t_transport_stop),
+			atomic_read(&cmd->t_task->t_transport_sent));
 
 		if (atomic_read(&task->task_active)) {
 			atomic_set(&task->task_stop, 1);
 			spin_unlock_irqrestore(
-				&T_TASK(cmd)->t_state_lock, flags);
+				&cmd->t_task->t_state_lock, flags);
 
 			DEBUG_LR("LUN_RESET: Waiting for task: %p to shutdown"
 				" for dev: %p\n", task, dev);
 			wait_for_completion(&task->task_stop_comp);
 			DEBUG_LR("LUN_RESET Completed task: %p shutdown for"
 				" dev: %p\n", task, dev);
-			spin_lock_irqsave(&T_TASK(cmd)->t_state_lock, flags);
-			atomic_dec(&T_TASK(cmd)->t_task_cdbs_left);
+			spin_lock_irqsave(&cmd->t_task->t_state_lock, flags);
+			atomic_dec(&cmd->t_task->t_task_cdbs_left);
 
 			atomic_set(&task->task_active, 0);
 			atomic_set(&task->task_stop, 0);
@@ -295,24 +295,24 @@ int core_tmr_lun_reset(
 		}
 		__transport_stop_task_timer(task, &flags);
 
-		if (!(atomic_dec_and_test(&T_TASK(cmd)->t_task_cdbs_ex_left))) {
+		if (!(atomic_dec_and_test(&cmd->t_task->t_task_cdbs_ex_left))) {
 			spin_unlock_irqrestore(
-					&T_TASK(cmd)->t_state_lock, flags);
+					&cmd->t_task->t_state_lock, flags);
 			DEBUG_LR("LUN_RESET: Skipping task: %p, dev: %p for"
 				" t_task_cdbs_ex_left: %d\n", task, dev,
-				atomic_read(&T_TASK(cmd)->t_task_cdbs_ex_left));
+				atomic_read(&cmd->t_task->t_task_cdbs_ex_left));
 
 			spin_lock_irqsave(&dev->execute_task_lock, flags);
 			continue;
 		}
-		fe_count = atomic_read(&T_TASK(cmd)->t_fe_count);
+		fe_count = atomic_read(&cmd->t_task->t_fe_count);
 
-		if (atomic_read(&T_TASK(cmd)->t_transport_active)) {
+		if (atomic_read(&cmd->t_task->t_transport_active)) {
 			DEBUG_LR("LUN_RESET: got t_transport_active = 1 for"
 				" task: %p, t_fe_count: %d dev: %p\n", task,
 				fe_count, dev);
-			atomic_set(&T_TASK(cmd)->t_transport_aborted, 1);
-			spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock,
+			atomic_set(&cmd->t_task->t_transport_aborted, 1);
+			spin_unlock_irqrestore(&cmd->t_task->t_state_lock,
 						flags);
 			core_tmr_handle_tas_abort(tmr_nacl, cmd, tas, fe_count);
 
@@ -321,8 +321,8 @@ int core_tmr_lun_reset(
 		}
 		DEBUG_LR("LUN_RESET: Got t_transport_active = 0 for task: %p,"
 			" t_fe_count: %d dev: %p\n", task, fe_count, dev);
-		atomic_set(&T_TASK(cmd)->t_transport_aborted, 1);
-		spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
+		atomic_set(&cmd->t_task->t_transport_aborted, 1);
+		spin_unlock_irqrestore(&cmd->t_task->t_state_lock, flags);
 		core_tmr_handle_tas_abort(tmr_nacl, cmd, tas, fe_count);
 
 		spin_lock_irqsave(&dev->execute_task_lock, flags);
@@ -365,7 +365,7 @@ int core_tmr_lun_reset(
 		if (prout_cmd == cmd)
 			continue;
 
-		atomic_dec(&T_TASK(cmd)->t_transport_queue_active);
+		atomic_dec(&cmd->t_task->t_transport_queue_active);
 		atomic_dec(&qobj->queue_cnt);
 		list_del(&qr->qr_list);
 		spin_unlock_irqrestore(&qobj->cmd_queue_lock, flags);
@@ -376,7 +376,7 @@ int core_tmr_lun_reset(
 		DEBUG_LR("LUN_RESET: %s from Device Queue: cmd: %p t_state:"
 			" %d t_fe_count: %d\n", (preempt_and_abort_list) ?
 			"Preempt" : "", cmd, state,
-			atomic_read(&T_TASK(cmd)->t_fe_count));
+			atomic_read(&cmd->t_task->t_fe_count));
 		/*
 		 * Signal that the command has failed via cmd->se_cmd_flags,
 		 * and call TFO->new_cmd_failure() to wakeup any fabric
@@ -388,7 +388,7 @@ int core_tmr_lun_reset(
 		transport_new_cmd_failure(cmd);
 
 		core_tmr_handle_tas_abort(tmr_nacl, cmd, tas,
-				atomic_read(&T_TASK(cmd)->t_fe_count));
+				atomic_read(&cmd->t_task->t_fe_count));
 		spin_lock_irqsave(&qobj->cmd_queue_lock, flags);
 	}
 	spin_unlock_irqrestore(&qobj->cmd_queue_lock, flags);
@@ -411,6 +411,6 @@ int core_tmr_lun_reset(
 
 	DEBUG_LR("LUN_RESET: %s for [%s] Complete\n",
 			(preempt_and_abort_list) ? "Preempt" : "TMR",
-			TRANSPORT(dev)->name);
+			dev->transport->name);
 	return 0;
 }
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 4e2bee9..448129f 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -74,7 +74,7 @@ static void core_clear_initiator_node_from_tpg(
 		if (!deve->se_lun) {
 			printk(KERN_ERR "%s device entries device pointer is"
 				" NULL, but Initiator has access.\n",
-				TPG_TFO(tpg)->get_fabric_name());
+				tpg->se_tpg_tfo->get_fabric_name());
 			continue;
 		}
 
@@ -177,7 +177,7 @@ void core_tpg_add_node_to_devs(
 		 * By default in LIO-Target $FABRIC_MOD,
 		 * demo_mode_write_protect is ON, or READ_ONLY;
 		 */
-		if (!(TPG_TFO(tpg)->tpg_check_demo_mode_write_protect(tpg))) {
+		if (!(tpg->se_tpg_tfo->tpg_check_demo_mode_write_protect(tpg))) {
 			if (dev->dev_flags & DF_READ_ONLY)
 				lun_access = TRANSPORT_LUNFLAGS_READ_ONLY;
 			else
@@ -187,7 +187,7 @@ void core_tpg_add_node_to_devs(
 			 * Allow only optical drives to issue R/W in default RO
 			 * demo mode.
 			 */
-			if (TRANSPORT(dev)->get_device_type(dev) == TYPE_DISK)
+			if (dev->transport->get_device_type(dev) == TYPE_DISK)
 				lun_access = TRANSPORT_LUNFLAGS_READ_ONLY;
 			else
 				lun_access = TRANSPORT_LUNFLAGS_READ_WRITE;
@@ -195,8 +195,8 @@ void core_tpg_add_node_to_devs(
 
 		printk(KERN_INFO "TARGET_CORE[%s]->TPG[%u]_LUN[%u] - Adding %s"
 			" access for LUN in Demo Mode\n",
-			TPG_TFO(tpg)->get_fabric_name(),
-			TPG_TFO(tpg)->tpg_get_tag(tpg), lun->unpacked_lun,
+			tpg->se_tpg_tfo->get_fabric_name(),
+			tpg->se_tpg_tfo->tpg_get_tag(tpg), lun->unpacked_lun,
 			(lun_access == TRANSPORT_LUNFLAGS_READ_WRITE) ?
 			"READ-WRITE" : "READ-ONLY");
 
@@ -217,7 +217,7 @@ static int core_set_queue_depth_for_node(
 {
 	if (!acl->queue_depth) {
 		printk(KERN_ERR "Queue depth for %s Initiator Node: %s is 0,"
-			"defaulting to 1.\n", TPG_TFO(tpg)->get_fabric_name(),
+			"defaulting to 1.\n", tpg->se_tpg_tfo->get_fabric_name(),
 			acl->initiatorname);
 		acl->queue_depth = 1;
 	}
@@ -268,10 +268,10 @@ struct se_node_acl *core_tpg_check_initiator_node_acl(
 	if ((acl))
 		return acl;
 
-	if (!(TPG_TFO(tpg)->tpg_check_demo_mode(tpg)))
+	if (!(tpg->se_tpg_tfo->tpg_check_demo_mode(tpg)))
 		return NULL;
 
-	acl =  TPG_TFO(tpg)->tpg_alloc_fabric_acl(tpg);
+	acl =  tpg->se_tpg_tfo->tpg_alloc_fabric_acl(tpg);
 	if (!(acl))
 		return NULL;
 
@@ -280,23 +280,23 @@ struct se_node_acl *core_tpg_check_initiator_node_acl(
 	spin_lock_init(&acl->device_list_lock);
 	spin_lock_init(&acl->nacl_sess_lock);
 	atomic_set(&acl->acl_pr_ref_count, 0);
-	acl->queue_depth = TPG_TFO(tpg)->tpg_get_default_depth(tpg);
+	acl->queue_depth = tpg->se_tpg_tfo->tpg_get_default_depth(tpg);
 	snprintf(acl->initiatorname, TRANSPORT_IQN_LEN, "%s", initiatorname);
 	acl->se_tpg = tpg;
 	acl->acl_index = scsi_get_new_index(SCSI_AUTH_INTR_INDEX);
 	spin_lock_init(&acl->stats_lock);
 	acl->dynamic_node_acl = 1;
 
-	TPG_TFO(tpg)->set_default_node_attributes(acl);
+	tpg->se_tpg_tfo->set_default_node_attributes(acl);
 
 	if (core_create_device_list_for_node(acl) < 0) {
-		TPG_TFO(tpg)->tpg_release_fabric_acl(tpg, acl);
+		tpg->se_tpg_tfo->tpg_release_fabric_acl(tpg, acl);
 		return NULL;
 	}
 
 	if (core_set_queue_depth_for_node(tpg, acl) < 0) {
 		core_free_device_list_for_node(acl, tpg);
-		TPG_TFO(tpg)->tpg_release_fabric_acl(tpg, acl);
+		tpg->se_tpg_tfo->tpg_release_fabric_acl(tpg, acl);
 		return NULL;
 	}
 
@@ -308,9 +308,9 @@ struct se_node_acl *core_tpg_check_initiator_node_acl(
 	spin_unlock_bh(&tpg->acl_node_lock);
 
 	printk("%s_TPG[%u] - Added DYNAMIC ACL with TCQ Depth: %d for %s"
-		" Initiator Node: %s\n", TPG_TFO(tpg)->get_fabric_name(),
-		TPG_TFO(tpg)->tpg_get_tag(tpg), acl->queue_depth,
-		TPG_TFO(tpg)->get_fabric_name(), initiatorname);
+		" Initiator Node: %s\n", tpg->se_tpg_tfo->get_fabric_name(),
+		tpg->se_tpg_tfo->tpg_get_tag(tpg), acl->queue_depth,
+		tpg->se_tpg_tfo->get_fabric_name(), initiatorname);
 
 	return acl;
 }
@@ -361,8 +361,8 @@ struct se_node_acl *core_tpg_add_initiator_node_acl(
 		if (acl->dynamic_node_acl) {
 			acl->dynamic_node_acl = 0;
 			printk(KERN_INFO "%s_TPG[%u] - Replacing dynamic ACL"
-				" for %s\n", TPG_TFO(tpg)->get_fabric_name(),
-				TPG_TFO(tpg)->tpg_get_tag(tpg), initiatorname);
+				" for %s\n", tpg->se_tpg_tfo->get_fabric_name(),
+				tpg->se_tpg_tfo->tpg_get_tag(tpg), initiatorname);
 			spin_unlock_bh(&tpg->acl_node_lock);
 			/*
 			 * Release the locally allocated struct se_node_acl
@@ -370,15 +370,15 @@ struct se_node_acl *core_tpg_add_initiator_node_acl(
 			 * a pointer to an existing demo mode node ACL.
 			 */
 			if (se_nacl)
-				TPG_TFO(tpg)->tpg_release_fabric_acl(tpg,
+				tpg->se_tpg_tfo->tpg_release_fabric_acl(tpg,
 							se_nacl);
 			goto done;
 		}
 
 		printk(KERN_ERR "ACL entry for %s Initiator"
 			" Node %s already exists for TPG %u, ignoring"
-			" request.\n",  TPG_TFO(tpg)->get_fabric_name(),
-			initiatorname, TPG_TFO(tpg)->tpg_get_tag(tpg));
+			" request.\n",  tpg->se_tpg_tfo->get_fabric_name(),
+			initiatorname, tpg->se_tpg_tfo->tpg_get_tag(tpg));
 		spin_unlock_bh(&tpg->acl_node_lock);
 		return ERR_PTR(-EEXIST);
 	}
@@ -406,16 +406,16 @@ struct se_node_acl *core_tpg_add_initiator_node_acl(
 	acl->acl_index = scsi_get_new_index(SCSI_AUTH_INTR_INDEX);
 	spin_lock_init(&acl->stats_lock);
 
-	TPG_TFO(tpg)->set_default_node_attributes(acl);
+	tpg->se_tpg_tfo->set_default_node_attributes(acl);
 
 	if (core_create_device_list_for_node(acl) < 0) {
-		TPG_TFO(tpg)->tpg_release_fabric_acl(tpg, acl);
+		tpg->se_tpg_tfo->tpg_release_fabric_acl(tpg, acl);
 		return ERR_PTR(-ENOMEM);
 	}
 
 	if (core_set_queue_depth_for_node(tpg, acl) < 0) {
 		core_free_device_list_for_node(acl, tpg);
-		TPG_TFO(tpg)->tpg_release_fabric_acl(tpg, acl);
+		tpg->se_tpg_tfo->tpg_release_fabric_acl(tpg, acl);
 		return ERR_PTR(-EINVAL);
 	}
 
@@ -426,9 +426,9 @@ struct se_node_acl *core_tpg_add_initiator_node_acl(
 
 done:
 	printk(KERN_INFO "%s_TPG[%hu] - Added ACL with TCQ Depth: %d for %s"
-		" Initiator Node: %s\n", TPG_TFO(tpg)->get_fabric_name(),
-		TPG_TFO(tpg)->tpg_get_tag(tpg), acl->queue_depth,
-		TPG_TFO(tpg)->get_fabric_name(), initiatorname);
+		" Initiator Node: %s\n", tpg->se_tpg_tfo->get_fabric_name(),
+		tpg->se_tpg_tfo->tpg_get_tag(tpg), acl->queue_depth,
+		tpg->se_tpg_tfo->get_fabric_name(), initiatorname);
 
 	return acl;
 }
@@ -463,7 +463,7 @@ int core_tpg_del_initiator_node_acl(
 		/*
 		 * Determine if the session needs to be closed by our context.
 		 */
-		if (!(TPG_TFO(tpg)->shutdown_session(sess)))
+		if (!(tpg->se_tpg_tfo->shutdown_session(sess)))
 			continue;
 
 		spin_unlock_bh(&tpg->session_lock);
@@ -471,7 +471,7 @@ int core_tpg_del_initiator_node_acl(
 		 * If the $FABRIC_MOD session for the Initiator Node ACL exists,
 		 * forcefully shutdown the $FABRIC_MOD session/nexus.
 		 */
-		TPG_TFO(tpg)->close_session(sess);
+		tpg->se_tpg_tfo->close_session(sess);
 
 		spin_lock_bh(&tpg->session_lock);
 	}
@@ -482,9 +482,9 @@ int core_tpg_del_initiator_node_acl(
 	core_free_device_list_for_node(acl, tpg);
 
 	printk(KERN_INFO "%s_TPG[%hu] - Deleted ACL with TCQ Depth: %d for %s"
-		" Initiator Node: %s\n", TPG_TFO(tpg)->get_fabric_name(),
-		TPG_TFO(tpg)->tpg_get_tag(tpg), acl->queue_depth,
-		TPG_TFO(tpg)->get_fabric_name(), acl->initiatorname);
+		" Initiator Node: %s\n", tpg->se_tpg_tfo->get_fabric_name(),
+		tpg->se_tpg_tfo->tpg_get_tag(tpg), acl->queue_depth,
+		tpg->se_tpg_tfo->get_fabric_name(), acl->initiatorname);
 
 	return 0;
 }
@@ -509,8 +509,8 @@ int core_tpg_set_initiator_node_queue_depth(
 	if (!(acl)) {
 		printk(KERN_ERR "Access Control List entry for %s Initiator"
 			" Node %s does not exists for TPG %hu, ignoring"
-			" request.\n", TPG_TFO(tpg)->get_fabric_name(),
-			initiatorname, TPG_TFO(tpg)->tpg_get_tag(tpg));
+			" request.\n", tpg->se_tpg_tfo->get_fabric_name(),
+			initiatorname, tpg->se_tpg_tfo->tpg_get_tag(tpg));
 		spin_unlock_bh(&tpg->acl_node_lock);
 		return -ENODEV;
 	}
@@ -531,7 +531,7 @@ int core_tpg_set_initiator_node_queue_depth(
 				" operational.  To forcefully change the queue"
 				" depth and force session reinstatement"
 				" use the \"force=1\" parameter.\n",
-				TPG_TFO(tpg)->get_fabric_name(), initiatorname);
+				tpg->se_tpg_tfo->get_fabric_name(), initiatorname);
 			spin_unlock_bh(&tpg->session_lock);
 
 			spin_lock_bh(&tpg->acl_node_lock);
@@ -543,7 +543,7 @@ int core_tpg_set_initiator_node_queue_depth(
 		/*
 		 * Determine if the session needs to be closed by our context.
 		 */
-		if (!(TPG_TFO(tpg)->shutdown_session(sess)))
+		if (!(tpg->se_tpg_tfo->shutdown_session(sess)))
 			continue;
 
 		init_sess = sess;
@@ -555,7 +555,7 @@ int core_tpg_set_initiator_node_queue_depth(
 	 * Change the value in the Node's struct se_node_acl, and call
 	 * core_set_queue_depth_for_node() to add the requested queue depth.
 	 *
-	 * Finally call  TPG_TFO(tpg)->close_session() to force session
+	 * Finally call  tpg->se_tpg_tfo->close_session() to force session
 	 * reinstatement to occur if there is an active session for the
 	 * $FABRIC_MOD Initiator Node in question.
 	 */
@@ -567,10 +567,10 @@ int core_tpg_set_initiator_node_queue_depth(
 		 * Force session reinstatement if
 		 * core_set_queue_depth_for_node() failed, because we assume
 		 * the $FABRIC_MOD has already the set session reinstatement
-		 * bit from TPG_TFO(tpg)->shutdown_session() called above.
+		 * bit from tpg->se_tpg_tfo->shutdown_session() called above.
 		 */
 		if (init_sess)
-			TPG_TFO(tpg)->close_session(init_sess);
+			tpg->se_tpg_tfo->close_session(init_sess);
 
 		spin_lock_bh(&tpg->acl_node_lock);
 		if (dynamic_acl)
@@ -584,12 +584,12 @@ int core_tpg_set_initiator_node_queue_depth(
 	 * forcefully shutdown the $FABRIC_MOD session/nexus.
 	 */
 	if (init_sess)
-		TPG_TFO(tpg)->close_session(init_sess);
+		tpg->se_tpg_tfo->close_session(init_sess);
 
 	printk(KERN_INFO "Successfuly changed queue depth to: %d for Initiator"
 		" Node: %s on %s Target Portal Group: %u\n", queue_depth,
-		initiatorname, TPG_TFO(tpg)->get_fabric_name(),
-		TPG_TFO(tpg)->tpg_get_tag(tpg));
+		initiatorname, tpg->se_tpg_tfo->get_fabric_name(),
+		tpg->se_tpg_tfo->tpg_get_tag(tpg));
 
 	spin_lock_bh(&tpg->acl_node_lock);
 	if (dynamic_acl)
@@ -703,9 +703,9 @@ int core_tpg_deregister(struct se_portal_group *se_tpg)
 	printk(KERN_INFO "TARGET_CORE[%s]: Deallocating %s struct se_portal_group"
 		" for endpoint: %s Portal Tag %u\n",
 		(se_tpg->se_tpg_type == TRANSPORT_TPG_TYPE_NORMAL) ?
-		"Normal" : "Discovery", TPG_TFO(se_tpg)->get_fabric_name(),
-		TPG_TFO(se_tpg)->tpg_get_wwn(se_tpg),
-		TPG_TFO(se_tpg)->tpg_get_tag(se_tpg));
+		"Normal" : "Discovery", se_tpg->se_tpg_tfo->get_fabric_name(),
+		se_tpg->se_tpg_tfo->tpg_get_wwn(se_tpg),
+		se_tpg->se_tpg_tfo->tpg_get_tag(se_tpg));
 
 	spin_lock_bh(&tpg_lock);
 	list_del(&se_tpg->se_tpg_node);
@@ -727,7 +727,7 @@ int core_tpg_deregister(struct se_portal_group *se_tpg)
 
 		core_tpg_wait_for_nacl_pr_ref(nacl);
 		core_free_device_list_for_node(nacl, se_tpg);
-		TPG_TFO(se_tpg)->tpg_release_fabric_acl(se_tpg, nacl);
+		se_tpg->se_tpg_tfo->tpg_release_fabric_acl(se_tpg, nacl);
 
 		spin_lock_bh(&se_tpg->acl_node_lock);
 	}
@@ -751,9 +751,9 @@ struct se_lun *core_tpg_pre_addlun(
 	if (unpacked_lun > (TRANSPORT_MAX_LUNS_PER_TPG-1)) {
 		printk(KERN_ERR "%s LUN: %u exceeds TRANSPORT_MAX_LUNS_PER_TPG"
 			"-1: %u for Target Portal Group: %u\n",
-			TPG_TFO(tpg)->get_fabric_name(),
+			tpg->se_tpg_tfo->get_fabric_name(),
 			unpacked_lun, TRANSPORT_MAX_LUNS_PER_TPG-1,
-			TPG_TFO(tpg)->tpg_get_tag(tpg));
+			tpg->se_tpg_tfo->tpg_get_tag(tpg));
 		return ERR_PTR(-EOVERFLOW);
 	}
 
@@ -762,8 +762,8 @@ struct se_lun *core_tpg_pre_addlun(
 	if (lun->lun_status == TRANSPORT_LUN_STATUS_ACTIVE) {
 		printk(KERN_ERR "TPG Logical Unit Number: %u is already active"
 			" on %s Target Portal Group: %u, ignoring request.\n",
-			unpacked_lun, TPG_TFO(tpg)->get_fabric_name(),
-			TPG_TFO(tpg)->tpg_get_tag(tpg));
+			unpacked_lun, tpg->se_tpg_tfo->get_fabric_name(),
+			tpg->se_tpg_tfo->tpg_get_tag(tpg));
 		spin_unlock(&tpg->tpg_lun_lock);
 		return ERR_PTR(-EINVAL);
 	}
@@ -810,9 +810,9 @@ struct se_lun *core_tpg_pre_dellun(
 	if (unpacked_lun > (TRANSPORT_MAX_LUNS_PER_TPG-1)) {
 		printk(KERN_ERR "%s LUN: %u exceeds TRANSPORT_MAX_LUNS_PER_TPG"
 			"-1: %u for Target Portal Group: %u\n",
-			TPG_TFO(tpg)->get_fabric_name(), unpacked_lun,
+			tpg->se_tpg_tfo->get_fabric_name(), unpacked_lun,
 			TRANSPORT_MAX_LUNS_PER_TPG-1,
-			TPG_TFO(tpg)->tpg_get_tag(tpg));
+			tpg->se_tpg_tfo->tpg_get_tag(tpg));
 		return ERR_PTR(-EOVERFLOW);
 	}
 
@@ -821,8 +821,8 @@ struct se_lun *core_tpg_pre_dellun(
 	if (lun->lun_status != TRANSPORT_LUN_STATUS_ACTIVE) {
 		printk(KERN_ERR "%s Logical Unit Number: %u is not active on"
 			" Target Portal Group: %u, ignoring request.\n",
-			TPG_TFO(tpg)->get_fabric_name(), unpacked_lun,
-			TPG_TFO(tpg)->tpg_get_tag(tpg));
+			tpg->se_tpg_tfo->get_fabric_name(), unpacked_lun,
+			tpg->se_tpg_tfo->tpg_get_tag(tpg));
 		spin_unlock(&tpg->tpg_lun_lock);
 		return ERR_PTR(-ENODEV);
 	}
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 101bc20..9c8641ea 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -456,9 +456,9 @@ void __transport_register_session(
 		 * If the fabric module supports an ISID based TransportID,
 		 * save this value in binary from the fabric I_T Nexus now.
 		 */
-		if (TPG_TFO(se_tpg)->sess_get_initiator_sid != NULL) {
+		if (se_tpg->se_tpg_tfo->sess_get_initiator_sid != NULL) {
 			memset(&buf[0], 0, PR_REG_ISID_LEN);
-			TPG_TFO(se_tpg)->sess_get_initiator_sid(se_sess,
+			se_tpg->se_tpg_tfo->sess_get_initiator_sid(se_sess,
 					&buf[0], PR_REG_ISID_LEN);
 			se_sess->sess_bin_isid = get_unaligned_be64(&buf[0]);
 		}
@@ -476,7 +476,7 @@ void __transport_register_session(
 	list_add_tail(&se_sess->sess_list, &se_tpg->tpg_sess_list);
 
 	printk(KERN_INFO "TARGET_CORE[%s]: Registered fabric_sess_ptr: %p\n",
-		TPG_TFO(se_tpg)->get_fabric_name(), se_sess->fabric_sess_ptr);
+		se_tpg->se_tpg_tfo->get_fabric_name(), se_sess->fabric_sess_ptr);
 }
 EXPORT_SYMBOL(__transport_register_session);
 
@@ -550,7 +550,7 @@ void transport_deregister_session(struct se_session *se_sess)
 	if ((se_nacl)) {
 		spin_lock_bh(&se_tpg->acl_node_lock);
 		if (se_nacl->dynamic_node_acl) {
-			if (!(TPG_TFO(se_tpg)->tpg_check_demo_mode_cache(
+			if (!(se_tpg->se_tpg_tfo->tpg_check_demo_mode_cache(
 					se_tpg))) {
 				list_del(&se_nacl->acl_list);
 				se_tpg->num_node_acls--;
@@ -558,7 +558,7 @@ void transport_deregister_session(struct se_session *se_sess)
 
 				core_tpg_wait_for_nacl_pr_ref(se_nacl);
 				core_free_device_list_for_node(se_nacl, se_tpg);
-				TPG_TFO(se_tpg)->tpg_release_fabric_acl(se_tpg,
+				se_tpg->se_tpg_tfo->tpg_release_fabric_acl(se_tpg,
 						se_nacl);
 				spin_lock_bh(&se_tpg->acl_node_lock);
 			}
@@ -569,12 +569,12 @@ void transport_deregister_session(struct se_session *se_sess)
 	transport_free_session(se_sess);
 
 	printk(KERN_INFO "TARGET_CORE[%s]: Deregistered fabric_sess\n",
-		TPG_TFO(se_tpg)->get_fabric_name());
+		se_tpg->se_tpg_tfo->get_fabric_name());
 }
 EXPORT_SYMBOL(transport_deregister_session);
 
 /*
- * Called with T_TASK(cmd)->t_state_lock held.
+ * Called with cmd->t_task->t_state_lock held.
  */
 static void transport_all_task_dev_remove_state(struct se_cmd *cmd)
 {
@@ -582,10 +582,10 @@ static void transport_all_task_dev_remove_state(struct se_cmd *cmd)
 	struct se_task *task;
 	unsigned long flags;
 
-	if (!T_TASK(cmd))
+	if (!cmd->t_task)
 		return;
 
-	list_for_each_entry(task, &T_TASK(cmd)->t_task_list, t_list) {
+	list_for_each_entry(task, &cmd->t_task->t_task_list, t_list) {
 		dev = task->se_dev;
 		if (!(dev))
 			continue;
@@ -599,11 +599,11 @@ static void transport_all_task_dev_remove_state(struct se_cmd *cmd)
 		spin_lock_irqsave(&dev->execute_task_lock, flags);
 		list_del(&task->t_state_list);
 		DEBUG_TSTATE("Removed ITT: 0x%08x dev: %p task[%p]\n",
-			CMD_TFO(cmd)->tfo_get_task_tag(cmd), dev, task);
+			cmd->se_tfo->tfo_get_task_tag(cmd), dev, task);
 		spin_unlock_irqrestore(&dev->execute_task_lock, flags);
 
 		atomic_set(&task->task_state_active, 0);
-		atomic_dec(&T_TASK(cmd)->t_task_cdbs_ex_left);
+		atomic_dec(&cmd->t_task->t_task_cdbs_ex_left);
 	}
 }
 
@@ -622,34 +622,34 @@ static int transport_cmd_check_stop(
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&T_TASK(cmd)->t_state_lock, flags);
+	spin_lock_irqsave(&cmd->t_task->t_state_lock, flags);
 	/*
 	 * Determine if IOCTL context caller in requesting the stopping of this
 	 * command for LUN shutdown purposes.
 	 */
-	if (atomic_read(&T_TASK(cmd)->transport_lun_stop)) {
-		DEBUG_CS("%s:%d atomic_read(&T_TASK(cmd)->transport_lun_stop)"
+	if (atomic_read(&cmd->t_task->transport_lun_stop)) {
+		DEBUG_CS("%s:%d atomic_read(&cmd->t_task->transport_lun_stop)"
 			" == TRUE for ITT: 0x%08x\n", __func__, __LINE__,
-			CMD_TFO(cmd)->get_task_tag(cmd));
+			cmd->se_tfo->get_task_tag(cmd));
 
 		cmd->deferred_t_state = cmd->t_state;
 		cmd->t_state = TRANSPORT_DEFERRED_CMD;
-		atomic_set(&T_TASK(cmd)->t_transport_active, 0);
+		atomic_set(&cmd->t_task->t_transport_active, 0);
 		if (transport_off == 2)
 			transport_all_task_dev_remove_state(cmd);
-		spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
+		spin_unlock_irqrestore(&cmd->t_task->t_state_lock, flags);
 
-		complete(&T_TASK(cmd)->transport_lun_stop_comp);
+		complete(&cmd->t_task->transport_lun_stop_comp);
 		return 1;
 	}
 	/*
 	 * Determine if frontend context caller is requesting the stopping of
 	 * this command for frontend exceptions.
 	 */
-	if (atomic_read(&T_TASK(cmd)->t_transport_stop)) {
-		DEBUG_CS("%s:%d atomic_read(&T_TASK(cmd)->t_transport_stop) =="
+	if (atomic_read(&cmd->t_task->t_transport_stop)) {
+		DEBUG_CS("%s:%d atomic_read(&cmd->t_task->t_transport_stop) =="
 			" TRUE for ITT: 0x%08x\n", __func__, __LINE__,
-			CMD_TFO(cmd)->get_task_tag(cmd));
+			cmd->se_tfo->get_task_tag(cmd));
 
 		cmd->deferred_t_state = cmd->t_state;
 		cmd->t_state = TRANSPORT_DEFERRED_CMD;
@@ -662,13 +662,13 @@ static int transport_cmd_check_stop(
 		 */
 		if (transport_off == 2)
 			cmd->se_lun = NULL;
-		spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
+		spin_unlock_irqrestore(&cmd->t_task->t_state_lock, flags);
 
-		complete(&T_TASK(cmd)->t_transport_stop_comp);
+		complete(&cmd->t_task->t_transport_stop_comp);
 		return 1;
 	}
 	if (transport_off) {
-		atomic_set(&T_TASK(cmd)->t_transport_active, 0);
+		atomic_set(&cmd->t_task->t_transport_active, 0);
 		if (transport_off == 2) {
 			transport_all_task_dev_remove_state(cmd);
 			/*
@@ -681,20 +681,20 @@ static int transport_cmd_check_stop(
 			 * their internally allocated I/O reference now and
 			 * struct se_cmd now.
 			 */
-			if (CMD_TFO(cmd)->check_stop_free != NULL) {
+			if (cmd->se_tfo->check_stop_free != NULL) {
 				spin_unlock_irqrestore(
-					&T_TASK(cmd)->t_state_lock, flags);
+					&cmd->t_task->t_state_lock, flags);
 
-				CMD_TFO(cmd)->check_stop_free(cmd);
+				cmd->se_tfo->check_stop_free(cmd);
 				return 1;
 			}
 		}
-		spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
+		spin_unlock_irqrestore(&cmd->t_task->t_state_lock, flags);
 
 		return 0;
 	} else if (t_state)
 		cmd->t_state = t_state;
-	spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
+	spin_unlock_irqrestore(&cmd->t_task->t_state_lock, flags);
 
 	return 0;
 }
@@ -706,30 +706,30 @@ static int transport_cmd_check_stop_to_fabric(struct se_cmd *cmd)
 
 static void transport_lun_remove_cmd(struct se_cmd *cmd)
 {
-	struct se_lun *lun = SE_LUN(cmd);
+	struct se_lun *lun = cmd->se_lun;
 	unsigned long flags;
 
 	if (!lun)
 		return;
 
-	spin_lock_irqsave(&T_TASK(cmd)->t_state_lock, flags);
-	if (!(atomic_read(&T_TASK(cmd)->transport_dev_active))) {
-		spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
+	spin_lock_irqsave(&cmd->t_task->t_state_lock, flags);
+	if (!(atomic_read(&cmd->t_task->transport_dev_active))) {
+		spin_unlock_irqrestore(&cmd->t_task->t_state_lock, flags);
 		goto check_lun;
 	}
-	atomic_set(&T_TASK(cmd)->transport_dev_active, 0);
+	atomic_set(&cmd->t_task->transport_dev_active, 0);
 	transport_all_task_dev_remove_state(cmd);
-	spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
+	spin_unlock_irqrestore(&cmd->t_task->t_state_lock, flags);
 
 
 check_lun:
 	spin_lock_irqsave(&lun->lun_cmd_lock, flags);
-	if (atomic_read(&T_TASK(cmd)->transport_lun_active)) {
+	if (atomic_read(&cmd->t_task->transport_lun_active)) {
 		list_del(&cmd->se_lun_list);
-		atomic_set(&T_TASK(cmd)->transport_lun_active, 0);
+		atomic_set(&cmd->t_task->transport_lun_active, 0);
 #if 0
 		printk(KERN_INFO "Removed ITT: 0x%08x from LUN LIST[%d]\n"
-			CMD_TFO(cmd)->get_task_tag(cmd), lun->unpacked_lun);
+			cmd->se_tfo->get_task_tag(cmd), lun->unpacked_lun);
 #endif
 	}
 	spin_unlock_irqrestore(&lun->lun_cmd_lock, flags);
@@ -737,7 +737,7 @@ check_lun:
 
 void transport_cmd_finish_abort(struct se_cmd *cmd, int remove)
 {
-	transport_remove_cmd_from_queue(cmd, &SE_DEV(cmd)->dev_queue_obj);
+	transport_remove_cmd_from_queue(cmd, &cmd->se_lun->lun_se_dev->dev_queue_obj);
 	transport_lun_remove_cmd(cmd);
 
 	if (transport_cmd_check_stop_to_fabric(cmd))
@@ -748,7 +748,7 @@ void transport_cmd_finish_abort(struct se_cmd *cmd, int remove)
 
 void transport_cmd_finish_abort_tmr(struct se_cmd *cmd)
 {
-	transport_remove_cmd_from_queue(cmd, &SE_DEV(cmd)->dev_queue_obj);
+	transport_remove_cmd_from_queue(cmd, &cmd->se_lun->lun_se_dev->dev_queue_obj);
 
 	if (transport_cmd_check_stop_to_fabric(cmd))
 		return;
@@ -777,15 +777,15 @@ static int transport_add_cmd_to_queue(
 	qr->state = t_state;
 
 	if (t_state) {
-		spin_lock_irqsave(&T_TASK(cmd)->t_state_lock, flags);
+		spin_lock_irqsave(&cmd->t_task->t_state_lock, flags);
 		cmd->t_state = t_state;
-		atomic_set(&T_TASK(cmd)->t_transport_active, 1);
-		spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
+		atomic_set(&cmd->t_task->t_transport_active, 1);
+		spin_unlock_irqrestore(&cmd->t_task->t_state_lock, flags);
 	}
 
 	spin_lock_irqsave(&qobj->cmd_queue_lock, flags);
 	list_add_tail(&qr->qr_list, &qobj->qobj_list);
-	atomic_inc(&T_TASK(cmd)->t_transport_queue_active);
+	atomic_inc(&cmd->t_task->t_transport_queue_active);
 	spin_unlock_irqrestore(&qobj->cmd_queue_lock, flags);
 
 	atomic_inc(&qobj->queue_cnt);
@@ -812,7 +812,7 @@ transport_get_qr_from_queue(struct se_queue_obj *qobj)
 		break;
 
 	if (qr->cmd)
-		atomic_dec(&T_TASK(qr->cmd)->t_transport_queue_active);
+		atomic_dec(&qr->cmd->t_task->t_transport_queue_active);
 
 	list_del(&qr->qr_list);
 	atomic_dec(&qobj->queue_cnt);
@@ -828,7 +828,7 @@ static void transport_remove_cmd_from_queue(struct se_cmd *cmd,
 	unsigned long flags;
 
 	spin_lock_irqsave(&qobj->cmd_queue_lock, flags);
-	if (!(atomic_read(&T_TASK(cmd)->t_transport_queue_active))) {
+	if (!(atomic_read(&cmd->t_task->t_transport_queue_active))) {
 		spin_unlock_irqrestore(&qobj->cmd_queue_lock, flags);
 		return;
 	}
@@ -837,17 +837,17 @@ static void transport_remove_cmd_from_queue(struct se_cmd *cmd,
 		if (qr->cmd != cmd)
 			continue;
 
-		atomic_dec(&T_TASK(qr->cmd)->t_transport_queue_active);
+		atomic_dec(&qr->cmd->t_task->t_transport_queue_active);
 		atomic_dec(&qobj->queue_cnt);
 		list_del(&qr->qr_list);
 		kfree(qr);
 	}
 	spin_unlock_irqrestore(&qobj->cmd_queue_lock, flags);
 
-	if (atomic_read(&T_TASK(cmd)->t_transport_queue_active)) {
+	if (atomic_read(&cmd->t_task->t_transport_queue_active)) {
 		printk(KERN_ERR "ITT: 0x%08x t_transport_queue_active: %d\n",
-			CMD_TFO(cmd)->get_task_tag(cmd),
-			atomic_read(&T_TASK(cmd)->t_transport_queue_active));
+			cmd->se_tfo->get_task_tag(cmd),
+			atomic_read(&cmd->t_task->t_transport_queue_active));
 	}
 }
 
@@ -857,7 +857,7 @@ static void transport_remove_cmd_from_queue(struct se_cmd *cmd,
  */
 void transport_complete_sync_cache(struct se_cmd *cmd, int good)
 {
-	struct se_task *task = list_entry(T_TASK(cmd)->t_task_list.next,
+	struct se_task *task = list_entry(cmd->t_task->t_task_list.next,
 				struct se_task, t_list);
 
 	if (good) {
@@ -866,7 +866,7 @@ void transport_complete_sync_cache(struct se_cmd *cmd, int good)
 	} else {
 		task->task_scsi_status = SAM_STAT_CHECK_CONDITION;
 		task->task_error_status = PYX_TRANSPORT_ILLEGAL_REQUEST;
-		TASK_CMD(task)->transport_error_status =
+		task->task_se_cmd->transport_error_status =
 					PYX_TRANSPORT_ILLEGAL_REQUEST;
 	}
 
@@ -881,18 +881,18 @@ EXPORT_SYMBOL(transport_complete_sync_cache);
  */
 void transport_complete_task(struct se_task *task, int success)
 {
-	struct se_cmd *cmd = TASK_CMD(task);
+	struct se_cmd *cmd = task->task_se_cmd;
 	struct se_device *dev = task->se_dev;
 	int t_state;
 	unsigned long flags;
 #if 0
 	printk(KERN_INFO "task: %p CDB: 0x%02x obj_ptr: %p\n", task,
-			T_TASK(cmd)->t_task_cdb[0], dev);
+			cmd->t_task->t_task_cdb[0], dev);
 #endif
 	if (dev)
 		atomic_inc(&dev->depth_left);
 
-	spin_lock_irqsave(&T_TASK(cmd)->t_state_lock, flags);
+	spin_lock_irqsave(&cmd->t_task->t_state_lock, flags);
 	atomic_set(&task->task_active, 0);
 
 	/*
@@ -914,14 +914,14 @@ void transport_complete_task(struct se_task *task, int success)
 	 */
 	if (atomic_read(&task->task_stop)) {
 		/*
-		 * Decrement T_TASK(cmd)->t_se_count if this task had
+		 * Decrement cmd->t_task->t_se_count if this task had
 		 * previously thrown its timeout exception handler.
 		 */
 		if (atomic_read(&task->task_timeout)) {
-			atomic_dec(&T_TASK(cmd)->t_se_count);
+			atomic_dec(&cmd->t_task->t_se_count);
 			atomic_set(&task->task_timeout, 0);
 		}
-		spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
+		spin_unlock_irqrestore(&cmd->t_task->t_state_lock, flags);
 
 		complete(&task->task_stop_comp);
 		return;
@@ -933,33 +933,33 @@ void transport_complete_task(struct se_task *task, int success)
 	 */
 	if (atomic_read(&task->task_timeout)) {
 		if (!(atomic_dec_and_test(
-				&T_TASK(cmd)->t_task_cdbs_timeout_left))) {
-			spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock,
+				&cmd->t_task->t_task_cdbs_timeout_left))) {
+			spin_unlock_irqrestore(&cmd->t_task->t_state_lock,
 				flags);
 			return;
 		}
 		t_state = TRANSPORT_COMPLETE_TIMEOUT;
-		spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
+		spin_unlock_irqrestore(&cmd->t_task->t_state_lock, flags);
 
 		transport_add_cmd_to_queue(cmd, t_state);
 		return;
 	}
-	atomic_dec(&T_TASK(cmd)->t_task_cdbs_timeout_left);
+	atomic_dec(&cmd->t_task->t_task_cdbs_timeout_left);
 
 	/*
 	 * Decrement the outstanding t_task_cdbs_left count.  The last
 	 * struct se_task from struct se_cmd will complete itself into the
 	 * device queue depending upon int success.
 	 */
-	if (!(atomic_dec_and_test(&T_TASK(cmd)->t_task_cdbs_left))) {
+	if (!(atomic_dec_and_test(&cmd->t_task->t_task_cdbs_left))) {
 		if (!success)
-			T_TASK(cmd)->t_tasks_failed = 1;
+			cmd->t_task->t_tasks_failed = 1;
 
-		spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
+		spin_unlock_irqrestore(&cmd->t_task->t_state_lock, flags);
 		return;
 	}
 
-	if (!success || T_TASK(cmd)->t_tasks_failed) {
+	if (!success || cmd->t_task->t_tasks_failed) {
 		t_state = TRANSPORT_COMPLETE_FAILURE;
 		if (!task->task_error_status) {
 			task->task_error_status =
@@ -968,10 +968,10 @@ void transport_complete_task(struct se_task *task, int success)
 				PYX_TRANSPORT_UNKNOWN_SAM_OPCODE;
 		}
 	} else {
-		atomic_set(&T_TASK(cmd)->t_transport_complete, 1);
+		atomic_set(&cmd->t_task->t_transport_complete, 1);
 		t_state = TRANSPORT_COMPLETE_OK;
 	}
-	spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
+	spin_unlock_irqrestore(&cmd->t_task->t_state_lock, flags);
 
 	transport_add_cmd_to_queue(cmd, t_state);
 }
@@ -1054,7 +1054,7 @@ static void __transport_add_task_to_execute_queue(
 	atomic_set(&task->task_state_active, 1);
 
 	DEBUG_TSTATE("Added ITT: 0x%08x task[%p] to dev: %p\n",
-		CMD_TFO(task->task_se_cmd)->get_task_tag(task->task_se_cmd),
+		task->task_se_cmd->se_tfo->get_task_tag(task->task_se_cmd),
 		task, dev);
 }
 
@@ -1064,8 +1064,8 @@ static void transport_add_tasks_to_state_queue(struct se_cmd *cmd)
 	struct se_task *task;
 	unsigned long flags;
 
-	spin_lock_irqsave(&T_TASK(cmd)->t_state_lock, flags);
-	list_for_each_entry(task, &T_TASK(cmd)->t_task_list, t_list) {
+	spin_lock_irqsave(&cmd->t_task->t_state_lock, flags);
+	list_for_each_entry(task, &cmd->t_task->t_task_list, t_list) {
 		dev = task->se_dev;
 
 		if (atomic_read(&task->task_state_active))
@@ -1076,22 +1076,22 @@ static void transport_add_tasks_to_state_queue(struct se_cmd *cmd)
 		atomic_set(&task->task_state_active, 1);
 
 		DEBUG_TSTATE("Added ITT: 0x%08x task[%p] to dev: %p\n",
-			CMD_TFO(task->task_se_cmd)->get_task_tag(
+			task->se_cmd->se_tfo->get_task_tag(
 			task->task_se_cmd), task, dev);
 
 		spin_unlock(&dev->execute_task_lock);
 	}
-	spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
+	spin_unlock_irqrestore(&cmd->t_task->t_state_lock, flags);
 }
 
 static void transport_add_tasks_from_cmd(struct se_cmd *cmd)
 {
-	struct se_device *dev = SE_DEV(cmd);
+	struct se_device *dev = cmd->se_lun->lun_se_dev;
 	struct se_task *task, *task_prev = NULL;
 	unsigned long flags;
 
 	spin_lock_irqsave(&dev->execute_task_lock, flags);
-	list_for_each_entry(task, &T_TASK(cmd)->t_task_list, t_list) {
+	list_for_each_entry(task, &cmd->t_task->t_task_list, t_list) {
 		if (atomic_read(&task->task_execute_queue))
 			continue;
 		/*
@@ -1196,7 +1196,7 @@ void transport_dump_dev_state(
 		atomic_read(&dev->execute_tasks), atomic_read(&dev->depth_left),
 		dev->queue_depth);
 	*bl += sprintf(b + *bl, "  SectorSize: %u  MaxSectors: %u\n",
-		DEV_ATTRIB(dev)->block_size, DEV_ATTRIB(dev)->max_sectors);
+		dev->se_sub_dev->se_dev_attrib.block_size, dev->se_sub_dev->se_dev_attrib.max_sectors);
 	*bl += sprintf(b + *bl, "        ");
 }
 
@@ -1224,8 +1224,8 @@ static void transport_release_all_cmds(struct se_device *dev)
 
 		printk(KERN_ERR "Releasing ITT: 0x%08x, i_state: %u,"
 			" t_state: %u directly\n",
-			CMD_TFO(cmd)->get_task_tag(cmd),
-			CMD_TFO(cmd)->get_cmd_state(cmd), t_state);
+			cmd->se_tfo->get_task_tag(cmd),
+			cmd->se_tfo->get_cmd_state(cmd), t_state);
 
 		transport_release_fe_cmd(cmd);
 		bug_out = 1;
@@ -1501,20 +1501,20 @@ static void core_setup_task_attr_emulation(struct se_device *dev)
 	 * This is currently not available in upsream Linux/SCSI Target
 	 * mode code, and is assumed to be disabled while using TCM/pSCSI.
 	 */
-	if (TRANSPORT(dev)->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV) {
+	if (dev->transport->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV) {
 		dev->dev_task_attr_type = SAM_TASK_ATTR_PASSTHROUGH;
 		return;
 	}
 
 	dev->dev_task_attr_type = SAM_TASK_ATTR_EMULATED;
 	DEBUG_STA("%s: Using SAM_TASK_ATTR_EMULATED for SPC: 0x%02x"
-		" device\n", TRANSPORT(dev)->name,
-		TRANSPORT(dev)->get_device_rev(dev));
+		" device\n", dev->transport->name,
+		dev->transport->get_device_rev(dev));
 }
 
 static void scsi_dump_inquiry(struct se_device *dev)
 {
-	struct t10_wwn *wwn = DEV_T10_WWN(dev);
+	struct t10_wwn *wwn = &dev->se_sub_dev->t10_wwn;
 	int i, device_type;
 	/*
 	 * Print Linux/SCSI style INQUIRY formatting to the kernel ring buffer
@@ -1542,10 +1542,10 @@ static void scsi_dump_inquiry(struct se_device *dev)
 
 	printk("\n");
 
-	device_type = TRANSPORT(dev)->get_device_type(dev);
+	device_type = dev->transport->get_device_type(dev);
 	printk("  Type:   %s ", scsi_device_type(device_type));
 	printk("                 ANSI SCSI revision: %02x\n",
-				TRANSPORT(dev)->get_device_rev(dev));
+				dev->transport->get_device_rev(dev));
 }
 
 struct se_device *transport_add_device_to_core_hba(
@@ -1629,10 +1629,10 @@ struct se_device *transport_add_device_to_core_hba(
 	 * Startup the struct se_device processing thread
 	 */
 	dev->process_thread = kthread_run(transport_processing_thread, dev,
-					  "LIO_%s", TRANSPORT(dev)->name);
+					  "LIO_%s", dev->transport->name);
 	if (IS_ERR(dev->process_thread)) {
 		printk(KERN_ERR "Unable to create kthread: LIO_%s\n",
-			TRANSPORT(dev)->name);
+			dev->transport->name);
 		goto out;
 	}
 
@@ -1644,16 +1644,16 @@ struct se_device *transport_add_device_to_core_hba(
 	 * originals once back into DEV_T10_WWN(dev) for the virtual device
 	 * setup.
 	 */
-	if (TRANSPORT(dev)->transport_type != TRANSPORT_PLUGIN_PHBA_PDEV) {
+	if (dev->transport->transport_type != TRANSPORT_PLUGIN_PHBA_PDEV) {
 		if (!(inquiry_prod) || !(inquiry_prod)) {
 			printk(KERN_ERR "All non TCM/pSCSI plugins require"
 				" INQUIRY consts\n");
 			goto out;
 		}
 
-		strncpy(&DEV_T10_WWN(dev)->vendor[0], "LIO-ORG", 8);
-		strncpy(&DEV_T10_WWN(dev)->model[0], inquiry_prod, 16);
-		strncpy(&DEV_T10_WWN(dev)->revision[0], inquiry_rev, 4);
+		strncpy(&dev->se_sub_dev->t10_wwn.vendor[0], "LIO-ORG", 8);
+		strncpy(&dev->se_sub_dev->t10_wwn.model[0], inquiry_prod, 16);
+		strncpy(&dev->se_sub_dev->t10_wwn.revision[0], inquiry_rev, 4);
 	}
 	scsi_dump_inquiry(dev);
 
@@ -1706,7 +1706,7 @@ transport_generic_get_task(struct se_cmd *cmd,
 		enum dma_data_direction data_direction)
 {
 	struct se_task *task;
-	struct se_device *dev = SE_DEV(cmd);
+	struct se_device *dev = cmd->se_lun->lun_se_dev;
 	unsigned long flags;
 
 	task = dev->transport->alloc_task(cmd);
@@ -1719,14 +1719,14 @@ transport_generic_get_task(struct se_cmd *cmd,
 	INIT_LIST_HEAD(&task->t_execute_list);
 	INIT_LIST_HEAD(&task->t_state_list);
 	init_completion(&task->task_stop_comp);
-	task->task_no = T_TASK(cmd)->t_tasks_no++;
+	task->task_no = cmd->t_task->t_tasks_no++;
 	task->task_se_cmd = cmd;
 	task->se_dev = dev;
 	task->task_data_direction = data_direction;
 
-	spin_lock_irqsave(&T_TASK(cmd)->t_state_lock, flags);
-	list_add_tail(&task->t_list, &T_TASK(cmd)->t_task_list);
-	spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
+	spin_lock_irqsave(&cmd->t_task->t_state_lock, flags);
+	list_add_tail(&task->t_list, &cmd->t_task->t_task_list);
+	spin_unlock_irqrestore(&cmd->t_task->t_state_lock, flags);
 
 	return task;
 }
@@ -1735,7 +1735,7 @@ static int transport_generic_cmd_sequencer(struct se_cmd *, unsigned char *);
 
 void transport_device_setup_cmd(struct se_cmd *cmd)
 {
-	cmd->se_dev = SE_LUN(cmd)->lun_se_dev;
+	cmd->se_dev = cmd->se_lun->lun_se_dev;
 }
 EXPORT_SYMBOL(transport_device_setup_cmd);
 
@@ -1760,12 +1760,12 @@ void transport_init_se_cmd(
 	 */
 	cmd->t_task = &cmd->t_task_backstore;
 
-	INIT_LIST_HEAD(&T_TASK(cmd)->t_task_list);
-	init_completion(&T_TASK(cmd)->transport_lun_fe_stop_comp);
-	init_completion(&T_TASK(cmd)->transport_lun_stop_comp);
-	init_completion(&T_TASK(cmd)->t_transport_stop_comp);
-	spin_lock_init(&T_TASK(cmd)->t_state_lock);
-	atomic_set(&T_TASK(cmd)->transport_dev_active, 1);
+	INIT_LIST_HEAD(&cmd->t_task->t_task_list);
+	init_completion(&cmd->t_task->transport_lun_fe_stop_comp);
+	init_completion(&cmd->t_task->transport_lun_stop_comp);
+	init_completion(&cmd->t_task->t_transport_stop_comp);
+	spin_lock_init(&cmd->t_task->t_state_lock);
+	atomic_set(&cmd->t_task->transport_dev_active, 1);
 
 	cmd->se_tfo = tfo;
 	cmd->se_sess = se_sess;
@@ -1782,7 +1782,7 @@ static int transport_check_alloc_task_attr(struct se_cmd *cmd)
 	 * Check if SAM Task Attribute emulation is enabled for this
 	 * struct se_device storage object
 	 */
-	if (SE_DEV(cmd)->dev_task_attr_type != SAM_TASK_ATTR_EMULATED)
+	if (cmd->se_lun->lun_se_dev->dev_task_attr_type != SAM_TASK_ATTR_EMULATED)
 		return 0;
 
 	if (cmd->sam_task_attr == MSG_ACA_TAG) {
@@ -1794,7 +1794,7 @@ static int transport_check_alloc_task_attr(struct se_cmd *cmd)
 	 * Used to determine when ORDERED commands should go from
 	 * Dormant to Active status.
 	 */
-	cmd->se_ordered_id = atomic_inc_return(&SE_DEV(cmd)->dev_ordered_id);
+	cmd->se_ordered_id = atomic_inc_return(&cmd->se_lun->lun_se_dev->dev_ordered_id);
 	smp_mb__after_atomic_inc();
 	DEBUG_STA("Allocated se_ordered_id: %u for Task Attr: 0x%02x on %s\n",
 			cmd->se_ordered_id, cmd->sam_task_attr,
@@ -1810,8 +1810,8 @@ void transport_free_se_cmd(
 	/*
 	 * Check and free any extended CDB buffer that was allocated
 	 */
-	if (T_TASK(se_cmd)->t_task_cdb != T_TASK(se_cmd)->__t_task_cdb)
-		kfree(T_TASK(se_cmd)->t_task_cdb);
+	if (se_cmd->t_task->t_task_cdb != se_cmd->t_task->__t_task_cdb)
+		kfree(se_cmd->t_task->t_task_cdb);
 }
 EXPORT_SYMBOL(transport_free_se_cmd);
 
@@ -1850,26 +1850,26 @@ int transport_generic_allocate_tasks(
 	 * allocate the additional extended CDB buffer now..  Otherwise
 	 * setup the pointer from __t_task_cdb to t_task_cdb.
 	 */
-	if (scsi_command_size(cdb) > sizeof(T_TASK(cmd)->__t_task_cdb)) {
-		T_TASK(cmd)->t_task_cdb = kzalloc(scsi_command_size(cdb),
+	if (scsi_command_size(cdb) > sizeof(cmd->t_task->__t_task_cdb)) {
+		cmd->t_task->t_task_cdb = kzalloc(scsi_command_size(cdb),
 						GFP_KERNEL);
-		if (!(T_TASK(cmd)->t_task_cdb)) {
-			printk(KERN_ERR "Unable to allocate T_TASK(cmd)->t_task_cdb"
-				" %u > sizeof(T_TASK(cmd)->__t_task_cdb): %lu ops\n",
+		if (!(cmd->t_task->t_task_cdb)) {
+			printk(KERN_ERR "Unable to allocate cmd->t_task->t_task_cdb"
+				" %u > sizeof(cmd->t_task->__t_task_cdb): %lu ops\n",
 				scsi_command_size(cdb),
-				(unsigned long)sizeof(T_TASK(cmd)->__t_task_cdb));
+				(unsigned long)sizeof(cmd->t_task->__t_task_cdb));
 			return -ENOMEM;
 		}
 	} else
-		T_TASK(cmd)->t_task_cdb = &T_TASK(cmd)->__t_task_cdb[0];
+		cmd->t_task->t_task_cdb = &cmd->t_task->__t_task_cdb[0];
 	/*
-	 * Copy the original CDB into T_TASK(cmd).
+	 * Copy the original CDB into cmd->t_task.
 	 */
-	memcpy(T_TASK(cmd)->t_task_cdb, cdb, scsi_command_size(cdb));
+	memcpy(cmd->t_task->t_task_cdb, cdb, scsi_command_size(cdb));
 	/*
 	 * Setup the received CDB based on SCSI defined opcodes and
 	 * perform unit attention, persistent reservations and ALUA
-	 * checks for virtual device backends.  The T_TASK(cmd)->t_task_cdb
+	 * checks for virtual device backends.  The cmd->t_task->t_task_cdb
 	 * pointer is expected to be setup before we reach this point.
 	 */
 	ret = transport_generic_cmd_sequencer(cmd, cdb);
@@ -1898,9 +1898,9 @@ EXPORT_SYMBOL(transport_generic_allocate_tasks);
 int transport_generic_handle_cdb(
 	struct se_cmd *cmd)
 {
-	if (!SE_LUN(cmd)) {
+	if (!cmd->se_lun) {
 		dump_stack();
-		printk(KERN_ERR "SE_LUN(cmd) is NULL\n");
+		printk(KERN_ERR "cmd->se_lun is NULL\n");
 		return -EINVAL;
 	}
 
@@ -1917,9 +1917,9 @@ EXPORT_SYMBOL(transport_generic_handle_cdb);
 int transport_generic_handle_cdb_map(
 	struct se_cmd *cmd)
 {
-	if (!SE_LUN(cmd)) {
+	if (!cmd->se_lun) {
 		dump_stack();
-		printk(KERN_ERR "SE_LUN(cmd) is NULL\n");
+		printk(KERN_ERR "cmd->se_lun is NULL\n");
 		return -EINVAL;
 	}
 
@@ -1990,14 +1990,14 @@ static int transport_stop_tasks_for_cmd(struct se_cmd *cmd)
 	int ret = 0;
 
 	DEBUG_TS("ITT[0x%08x] - Stopping tasks\n",
-		CMD_TFO(cmd)->get_task_tag(cmd));
+		cmd->se_tfo->get_task_tag(cmd));
 
 	/*
 	 * No tasks remain in the execution queue
 	 */
-	spin_lock_irqsave(&T_TASK(cmd)->t_state_lock, flags);
+	spin_lock_irqsave(&cmd->t_task->t_state_lock, flags);
 	list_for_each_entry_safe(task, task_tmp,
-				&T_TASK(cmd)->t_task_list, t_list) {
+				&cmd->t_task->t_task_list, t_list) {
 		DEBUG_TS("task_no[%d] - Processing task %p\n",
 				task->task_no, task);
 		/*
@@ -2006,14 +2006,14 @@ static int transport_stop_tasks_for_cmd(struct se_cmd *cmd)
 		 */
 		if (!atomic_read(&task->task_sent) &&
 		    !atomic_read(&task->task_active)) {
-			spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock,
+			spin_unlock_irqrestore(&cmd->t_task->t_state_lock,
 					flags);
 			transport_remove_task_from_execute_queue(task,
 					task->se_dev);
 
 			DEBUG_TS("task_no[%d] - Removed from execute queue\n",
 				task->task_no);
-			spin_lock_irqsave(&T_TASK(cmd)->t_state_lock, flags);
+			spin_lock_irqsave(&cmd->t_task->t_state_lock, flags);
 			continue;
 		}
 
@@ -2023,7 +2023,7 @@ static int transport_stop_tasks_for_cmd(struct se_cmd *cmd)
 		 */
 		if (atomic_read(&task->task_active)) {
 			atomic_set(&task->task_stop, 1);
-			spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock,
+			spin_unlock_irqrestore(&cmd->t_task->t_state_lock,
 					flags);
 
 			DEBUG_TS("task_no[%d] - Waiting to complete\n",
@@ -2032,8 +2032,8 @@ static int transport_stop_tasks_for_cmd(struct se_cmd *cmd)
 			DEBUG_TS("task_no[%d] - Stopped successfully\n",
 				task->task_no);
 
-			spin_lock_irqsave(&T_TASK(cmd)->t_state_lock, flags);
-			atomic_dec(&T_TASK(cmd)->t_task_cdbs_left);
+			spin_lock_irqsave(&cmd->t_task->t_state_lock, flags);
+			atomic_dec(&cmd->t_task->t_task_cdbs_left);
 
 			atomic_set(&task->task_active, 0);
 			atomic_set(&task->task_stop, 0);
@@ -2044,7 +2044,7 @@ static int transport_stop_tasks_for_cmd(struct se_cmd *cmd)
 
 		__transport_stop_task_timer(task, &flags);
 	}
-	spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
+	spin_unlock_irqrestore(&cmd->t_task->t_state_lock, flags);
 
 	return ret;
 }
@@ -2059,23 +2059,23 @@ static void transport_generic_request_failure(
 	int sc)
 {
 	DEBUG_GRF("-----[ Storage Engine Exception for cmd: %p ITT: 0x%08x"
-		" CDB: 0x%02x\n", cmd, CMD_TFO(cmd)->get_task_tag(cmd),
-		T_TASK(cmd)->t_task_cdb[0]);
+		" CDB: 0x%02x\n", cmd, cmd->se_tfo->get_task_tag(cmd),
+		cmd->t_task->t_task_cdb[0]);
 	DEBUG_GRF("-----[ i_state: %d t_state/def_t_state:"
 		" %d/%d transport_error_status: %d\n",
-		CMD_TFO(cmd)->get_cmd_state(cmd),
+		cmd->se_tfo->get_cmd_state(cmd),
 		cmd->t_state, cmd->deferred_t_state,
 		cmd->transport_error_status);
 	DEBUG_GRF("-----[ t_task_cdbs: %d t_task_cdbs_left: %d"
 		" t_task_cdbs_sent: %d t_task_cdbs_ex_left: %d --"
 		" t_transport_active: %d t_transport_stop: %d"
-		" t_transport_sent: %d\n", T_TASK(cmd)->t_task_cdbs,
-		atomic_read(&T_TASK(cmd)->t_task_cdbs_left),
-		atomic_read(&T_TASK(cmd)->t_task_cdbs_sent),
-		atomic_read(&T_TASK(cmd)->t_task_cdbs_ex_left),
-		atomic_read(&T_TASK(cmd)->t_transport_active),
-		atomic_read(&T_TASK(cmd)->t_transport_stop),
-		atomic_read(&T_TASK(cmd)->t_transport_sent));
+		" t_transport_sent: %d\n", cmd->t_task->t_task_cdbs,
+		atomic_read(&cmd->t_task->t_task_cdbs_left),
+		atomic_read(&cmd->t_task->t_task_cdbs_sent),
+		atomic_read(&cmd->t_task->t_task_cdbs_ex_left),
+		atomic_read(&cmd->t_task->t_transport_active),
+		atomic_read(&cmd->t_task->t_transport_stop),
+		atomic_read(&cmd->t_task->t_transport_sent));
 
 	transport_stop_all_task_timers(cmd);
 
@@ -2113,8 +2113,8 @@ static void transport_generic_request_failure(
 		 * we force this session to fall back to session
 		 * recovery.
 		 */
-		CMD_TFO(cmd)->fall_back_to_erl0(cmd->se_sess);
-		CMD_TFO(cmd)->stop_session(cmd->se_sess, 0, 0);
+		cmd->se_tfo->fall_back_to_erl0(cmd->se_sess);
+		cmd->se_tfo->stop_session(cmd->se_sess, 0, 0);
 
 		goto check_stop;
 	case PYX_TRANSPORT_LU_COMM_FAILURE:
@@ -2142,13 +2142,13 @@ static void transport_generic_request_failure(
 		 *
 		 * See spc4r17, section 7.4.6 Control Mode Page, Table 349
 		 */
-		if (SE_SESS(cmd) &&
-		    DEV_ATTRIB(cmd->se_dev)->emulate_ua_intlck_ctrl == 2)
-			core_scsi3_ua_allocate(SE_SESS(cmd)->se_node_acl,
+		if (cmd->se_sess &&
+		    cmd->se_dev->se_sub_dev->se_dev_attrib.emulate_ua_intlck_ctrl == 2)
+			core_scsi3_ua_allocate(cmd->se_sess->se_node_acl,
 				cmd->orig_fe_lun, 0x2C,
 				ASCQ_2CH_PREVIOUS_RESERVATION_CONFLICT_STATUS);
 
-		CMD_TFO(cmd)->queue_status(cmd);
+		cmd->se_tfo->queue_status(cmd);
 		goto check_stop;
 	case PYX_TRANSPORT_USE_SENSE_REASON:
 		/*
@@ -2157,7 +2157,7 @@ static void transport_generic_request_failure(
 		break;
 	default:
 		printk(KERN_ERR "Unknown transport error for CDB 0x%02x: %d\n",
-			T_TASK(cmd)->t_task_cdb[0],
+			cmd->t_task->t_task_cdb[0],
 			cmd->transport_error_status);
 		cmd->scsi_sense_reason = TCM_UNSUPPORTED_SCSI_OPCODE;
 		break;
@@ -2178,19 +2178,19 @@ static void transport_direct_request_timeout(struct se_cmd *cmd)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&T_TASK(cmd)->t_state_lock, flags);
-	if (!(atomic_read(&T_TASK(cmd)->t_transport_timeout))) {
-		spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
+	spin_lock_irqsave(&cmd->t_task->t_state_lock, flags);
+	if (!(atomic_read(&cmd->t_task->t_transport_timeout))) {
+		spin_unlock_irqrestore(&cmd->t_task->t_state_lock, flags);
 		return;
 	}
-	if (atomic_read(&T_TASK(cmd)->t_task_cdbs_timeout_left)) {
-		spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
+	if (atomic_read(&cmd->t_task->t_task_cdbs_timeout_left)) {
+		spin_unlock_irqrestore(&cmd->t_task->t_state_lock, flags);
 		return;
 	}
 
-	atomic_sub(atomic_read(&T_TASK(cmd)->t_transport_timeout),
-		   &T_TASK(cmd)->t_se_count);
-	spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
+	atomic_sub(atomic_read(&cmd->t_task->t_transport_timeout),
+		   &cmd->t_task->t_se_count);
+	spin_unlock_irqrestore(&cmd->t_task->t_state_lock, flags);
 }
 
 static void transport_generic_request_timeout(struct se_cmd *cmd)
@@ -2198,16 +2198,16 @@ static void transport_generic_request_timeout(struct se_cmd *cmd)
 	unsigned long flags;
 
 	/*
-	 * Reset T_TASK(cmd)->t_se_count to allow transport_generic_remove()
+	 * Reset cmd->t_task->t_se_count to allow transport_generic_remove()
 	 * to allow last call to free memory resources.
 	 */
-	spin_lock_irqsave(&T_TASK(cmd)->t_state_lock, flags);
-	if (atomic_read(&T_TASK(cmd)->t_transport_timeout) > 1) {
-		int tmp = (atomic_read(&T_TASK(cmd)->t_transport_timeout) - 1);
+	spin_lock_irqsave(&cmd->t_task->t_state_lock, flags);
+	if (atomic_read(&cmd->t_task->t_transport_timeout) > 1) {
+		int tmp = (atomic_read(&cmd->t_task->t_transport_timeout) - 1);
 
-		atomic_sub(tmp, &T_TASK(cmd)->t_se_count);
+		atomic_sub(tmp, &cmd->t_task->t_se_count);
 	}
-	spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
+	spin_unlock_irqrestore(&cmd->t_task->t_state_lock, flags);
 
 	transport_generic_remove(cmd, 0, 0);
 }
@@ -2223,8 +2223,8 @@ transport_generic_allocate_buf(struct se_cmd *cmd, u32 data_length)
 		return -ENOMEM;
 	}
 
-	T_TASK(cmd)->t_tasks_se_num = 0;
-	T_TASK(cmd)->t_task_buf = buf;
+	cmd->t_task->t_tasks_se_num = 0;
+	cmd->t_task->t_task_buf = buf;
 
 	return 0;
 }
@@ -2266,9 +2266,9 @@ static void transport_set_supported_SAM_opcode(struct se_cmd *se_cmd)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&T_TASK(se_cmd)->t_state_lock, flags);
+	spin_lock_irqsave(&se_cmd->t_task->t_state_lock, flags);
 	se_cmd->se_cmd_flags |= SCF_SUPPORTED_SAM_OPCODE;
-	spin_unlock_irqrestore(&T_TASK(se_cmd)->t_state_lock, flags);
+	spin_unlock_irqrestore(&se_cmd->t_task->t_state_lock, flags);
 }
 
 /*
@@ -2277,14 +2277,14 @@ static void transport_set_supported_SAM_opcode(struct se_cmd *se_cmd)
 static void transport_task_timeout_handler(unsigned long data)
 {
 	struct se_task *task = (struct se_task *)data;
-	struct se_cmd *cmd = TASK_CMD(task);
+	struct se_cmd *cmd = task->task_se_cmd;
 	unsigned long flags;
 
 	DEBUG_TT("transport task timeout fired! task: %p cmd: %p\n", task, cmd);
 
-	spin_lock_irqsave(&T_TASK(cmd)->t_state_lock, flags);
+	spin_lock_irqsave(&cmd->t_task->t_state_lock, flags);
 	if (task->task_flags & TF_STOP) {
-		spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
+		spin_unlock_irqrestore(&cmd->t_task->t_state_lock, flags);
 		return;
 	}
 	task->task_flags &= ~TF_RUNNING;
@@ -2295,13 +2295,13 @@ static void transport_task_timeout_handler(unsigned long data)
 	if (!(atomic_read(&task->task_active))) {
 		DEBUG_TT("transport task: %p cmd: %p timeout task_active"
 				" == 0\n", task, cmd);
-		spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
+		spin_unlock_irqrestore(&cmd->t_task->t_state_lock, flags);
 		return;
 	}
 
-	atomic_inc(&T_TASK(cmd)->t_se_count);
-	atomic_inc(&T_TASK(cmd)->t_transport_timeout);
-	T_TASK(cmd)->t_tasks_failed = 1;
+	atomic_inc(&cmd->t_task->t_se_count);
+	atomic_inc(&cmd->t_task->t_transport_timeout);
+	cmd->t_task->t_tasks_failed = 1;
 
 	atomic_set(&task->task_timeout, 1);
 	task->task_error_status = PYX_TRANSPORT_TASK_TIMEOUT;
@@ -2310,28 +2310,28 @@ static void transport_task_timeout_handler(unsigned long data)
 	if (atomic_read(&task->task_stop)) {
 		DEBUG_TT("transport task: %p cmd: %p timeout task_stop"
 				" == 1\n", task, cmd);
-		spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
+		spin_unlock_irqrestore(&cmd->t_task->t_state_lock, flags);
 		complete(&task->task_stop_comp);
 		return;
 	}
 
-	if (!(atomic_dec_and_test(&T_TASK(cmd)->t_task_cdbs_left))) {
+	if (!(atomic_dec_and_test(&cmd->t_task->t_task_cdbs_left))) {
 		DEBUG_TT("transport task: %p cmd: %p timeout non zero"
 				" t_task_cdbs_left\n", task, cmd);
-		spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
+		spin_unlock_irqrestore(&cmd->t_task->t_state_lock, flags);
 		return;
 	}
 	DEBUG_TT("transport task: %p cmd: %p timeout ZERO t_task_cdbs_left\n",
 			task, cmd);
 
 	cmd->t_state = TRANSPORT_COMPLETE_FAILURE;
-	spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
+	spin_unlock_irqrestore(&cmd->t_task->t_state_lock, flags);
 
 	transport_add_cmd_to_queue(cmd, TRANSPORT_COMPLETE_FAILURE);
 }
 
 /*
- * Called with T_TASK(cmd)->t_state_lock held.
+ * Called with cmd->t_task->t_state_lock held.
  */
 static void transport_start_task_timer(struct se_task *task)
 {
@@ -2343,7 +2343,7 @@ static void transport_start_task_timer(struct se_task *task)
 	/*
 	 * If the task_timeout is disabled, exit now.
 	 */
-	timeout = DEV_ATTRIB(dev)->task_timeout;
+	timeout = dev->se_sub_dev->se_dev_attrib.task_timeout;
 	if (!(timeout))
 		return;
 
@@ -2361,21 +2361,21 @@ static void transport_start_task_timer(struct se_task *task)
 }
 
 /*
- * Called with spin_lock_irq(&T_TASK(cmd)->t_state_lock) held.
+ * Called with spin_lock_irq(&cmd->t_task->t_state_lock) held.
  */
 void __transport_stop_task_timer(struct se_task *task, unsigned long *flags)
 {
-	struct se_cmd *cmd = TASK_CMD(task);
+	struct se_cmd *cmd = task->task_se_cmd;
 
 	if (!(task->task_flags & TF_RUNNING))
 		return;
 
 	task->task_flags |= TF_STOP;
-	spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, *flags);
+	spin_unlock_irqrestore(&cmd->t_task->t_state_lock, *flags);
 
 	del_timer_sync(&task->task_timer);
 
-	spin_lock_irqsave(&T_TASK(cmd)->t_state_lock, *flags);
+	spin_lock_irqsave(&cmd->t_task->t_state_lock, *flags);
 	task->task_flags &= ~TF_RUNNING;
 	task->task_flags &= ~TF_STOP;
 }
@@ -2385,11 +2385,11 @@ static void transport_stop_all_task_timers(struct se_cmd *cmd)
 	struct se_task *task = NULL, *task_tmp;
 	unsigned long flags;
 
-	spin_lock_irqsave(&T_TASK(cmd)->t_state_lock, flags);
+	spin_lock_irqsave(&cmd->t_task->t_state_lock, flags);
 	list_for_each_entry_safe(task, task_tmp,
-				&T_TASK(cmd)->t_task_list, t_list)
+				&cmd->t_task->t_task_list, t_list)
 		__transport_stop_task_timer(task, &flags);
-	spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
+	spin_unlock_irqrestore(&cmd->t_task->t_state_lock, flags);
 }
 
 static inline int transport_tcq_window_closed(struct se_device *dev)
@@ -2413,45 +2413,45 @@ static inline int transport_tcq_window_closed(struct se_device *dev)
  */
 static inline int transport_execute_task_attr(struct se_cmd *cmd)
 {
-	if (SE_DEV(cmd)->dev_task_attr_type != SAM_TASK_ATTR_EMULATED)
+	if (cmd->se_lun->lun_se_dev->dev_task_attr_type != SAM_TASK_ATTR_EMULATED)
 		return 1;
 	/*
 	 * Check for the existence of HEAD_OF_QUEUE, and if true return 1
 	 * to allow the passed struct se_cmd list of tasks to the front of the list.
 	 */
 	 if (cmd->sam_task_attr == MSG_HEAD_TAG) {
-		atomic_inc(&SE_DEV(cmd)->dev_hoq_count);
+		atomic_inc(&cmd->se_lun->lun_se_dev->dev_hoq_count);
 		smp_mb__after_atomic_inc();
 		DEBUG_STA("Added HEAD_OF_QUEUE for CDB:"
 			" 0x%02x, se_ordered_id: %u\n",
-			T_TASK(cmd)->t_task_cdb[0],
+			cmd->t_task->t_task_cdb[0],
 			cmd->se_ordered_id);
 		return 1;
 	} else if (cmd->sam_task_attr == MSG_ORDERED_TAG) {
-		spin_lock(&SE_DEV(cmd)->ordered_cmd_lock);
+		spin_lock(&cmd->se_lun->lun_se_dev->ordered_cmd_lock);
 		list_add_tail(&cmd->se_ordered_list,
-				&SE_DEV(cmd)->ordered_cmd_list);
-		spin_unlock(&SE_DEV(cmd)->ordered_cmd_lock);
+				&cmd->se_lun->lun_se_dev->ordered_cmd_list);
+		spin_unlock(&cmd->se_lun->lun_se_dev->ordered_cmd_lock);
 
-		atomic_inc(&SE_DEV(cmd)->dev_ordered_sync);
+		atomic_inc(&cmd->se_lun->lun_se_dev->dev_ordered_sync);
 		smp_mb__after_atomic_inc();
 
 		DEBUG_STA("Added ORDERED for CDB: 0x%02x to ordered"
 				" list, se_ordered_id: %u\n",
-				T_TASK(cmd)->t_task_cdb[0],
+				cmd->t_task->t_task_cdb[0],
 				cmd->se_ordered_id);
 		/*
 		 * Add ORDERED command to tail of execution queue if
 		 * no other older commands exist that need to be
 		 * completed first.
 		 */
-		if (!(atomic_read(&SE_DEV(cmd)->simple_cmds)))
+		if (!(atomic_read(&cmd->se_lun->lun_se_dev->simple_cmds)))
 			return 1;
 	} else {
 		/*
 		 * For SIMPLE and UNTAGGED Task Attribute commands
 		 */
-		atomic_inc(&SE_DEV(cmd)->simple_cmds);
+		atomic_inc(&cmd->se_lun->lun_se_dev->simple_cmds);
 		smp_mb__after_atomic_inc();
 	}
 	/*
@@ -2459,20 +2459,20 @@ static inline int transport_execute_task_attr(struct se_cmd *cmd)
 	 * add the dormant task(s) built for the passed struct se_cmd to the
 	 * execution queue and become in Active state for this struct se_device.
 	 */
-	if (atomic_read(&SE_DEV(cmd)->dev_ordered_sync) != 0) {
+	if (atomic_read(&cmd->se_lun->lun_se_dev->dev_ordered_sync) != 0) {
 		/*
 		 * Otherwise, add cmd w/ tasks to delayed cmd queue that
 		 * will be drained upon completion of HEAD_OF_QUEUE task.
 		 */
-		spin_lock(&SE_DEV(cmd)->delayed_cmd_lock);
+		spin_lock(&cmd->se_lun->lun_se_dev->delayed_cmd_lock);
 		cmd->se_cmd_flags |= SCF_DELAYED_CMD_FROM_SAM_ATTR;
 		list_add_tail(&cmd->se_delayed_list,
-				&SE_DEV(cmd)->delayed_cmd_list);
-		spin_unlock(&SE_DEV(cmd)->delayed_cmd_lock);
+				&cmd->se_lun->lun_se_dev->delayed_cmd_list);
+		spin_unlock(&cmd->se_lun->lun_se_dev->delayed_cmd_lock);
 
 		DEBUG_STA("Added CDB: 0x%02x Task Attr: 0x%02x to"
 			" delayed CMD list, se_ordered_id: %u\n",
-			T_TASK(cmd)->t_task_cdb[0], cmd->sam_task_attr,
+			cmd->t_task->t_task_cdb[0], cmd->sam_task_attr,
 			cmd->se_ordered_id);
 		/*
 		 * Return zero to let transport_execute_tasks() know
@@ -2527,7 +2527,7 @@ static int transport_execute_tasks(struct se_cmd *cmd)
 	 * storage object.
 	 */
 execute_tasks:
-	__transport_execute_tasks(SE_DEV(cmd));
+	__transport_execute_tasks(cmd->se_lun->lun_se_dev);
 	return 0;
 }
 
@@ -2563,19 +2563,19 @@ check_depth:
 
 	atomic_dec(&dev->depth_left);
 
-	cmd = TASK_CMD(task);
+	cmd = task->task_se_cmd;
 
-	spin_lock_irqsave(&T_TASK(cmd)->t_state_lock, flags);
+	spin_lock_irqsave(&cmd->t_task->t_state_lock, flags);
 	atomic_set(&task->task_active, 1);
 	atomic_set(&task->task_sent, 1);
-	atomic_inc(&T_TASK(cmd)->t_task_cdbs_sent);
+	atomic_inc(&cmd->t_task->t_task_cdbs_sent);
 
-	if (atomic_read(&T_TASK(cmd)->t_task_cdbs_sent) ==
-	    T_TASK(cmd)->t_task_cdbs)
+	if (atomic_read(&cmd->t_task->t_task_cdbs_sent) ==
+	    cmd->t_task->t_task_cdbs)
 		atomic_set(&cmd->transport_sent, 1);
 
 	transport_start_task_timer(task);
-	spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
+	spin_unlock_irqrestore(&cmd->t_task->t_state_lock, flags);
 	/*
 	 * The struct se_cmd->transport_emulate_cdb() function pointer is used
 	 * to grab REPORT_LUNS and other CDBs we want to handle before they hit the
@@ -2613,11 +2613,11 @@ check_depth:
 		 * call ->do_task() directly and let the underlying TCM subsystem plugin
 		 * code handle the CDB emulation.
 		 */
-		if ((TRANSPORT(dev)->transport_type != TRANSPORT_PLUGIN_PHBA_PDEV) &&
-		    (!(TASK_CMD(task)->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB)))
+		if ((dev->transport->transport_type != TRANSPORT_PLUGIN_PHBA_PDEV) &&
+		    (!(task->task_se_cmd->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB)))
 			error = transport_emulate_control_cdb(task);
 		else
-			error = TRANSPORT(dev)->do_task(task);
+			error = dev->transport->do_task(task);
 
 		if (error != 0) {
 			cmd->transport_error_status = error;
@@ -2640,12 +2640,12 @@ void transport_new_cmd_failure(struct se_cmd *se_cmd)
 	 * Any unsolicited data will get dumped for failed command inside of
 	 * the fabric plugin
 	 */
-	spin_lock_irqsave(&T_TASK(se_cmd)->t_state_lock, flags);
+	spin_lock_irqsave(&se_cmd->t_task->t_state_lock, flags);
 	se_cmd->se_cmd_flags |= SCF_SE_CMD_FAILED;
 	se_cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
-	spin_unlock_irqrestore(&T_TASK(se_cmd)->t_state_lock, flags);
+	spin_unlock_irqrestore(&se_cmd->t_task->t_state_lock, flags);
 
-	CMD_TFO(se_cmd)->new_cmd_failure(se_cmd);
+	se_cmd->se_tfo->new_cmd_failure(se_cmd);
 }
 
 static void transport_nop_wait_for_tasks(struct se_cmd *, int, int);
@@ -2655,7 +2655,7 @@ static inline u32 transport_get_sectors_6(
 	struct se_cmd *cmd,
 	int *ret)
 {
-	struct se_device *dev = SE_LUN(cmd)->lun_se_dev;
+	struct se_device *dev = cmd->se_lun->lun_se_dev;
 
 	/*
 	 * Assume TYPE_DISK for non struct se_device objects.
@@ -2667,7 +2667,7 @@ static inline u32 transport_get_sectors_6(
 	/*
 	 * Use 24-bit allocation length for TYPE_TAPE.
 	 */
-	if (TRANSPORT(dev)->get_device_type(dev) == TYPE_TAPE)
+	if (dev->transport->get_device_type(dev) == TYPE_TAPE)
 		return (u32)(cdb[2] << 16) + (cdb[3] << 8) + cdb[4];
 
 	/*
@@ -2683,7 +2683,7 @@ static inline u32 transport_get_sectors_10(
 	struct se_cmd *cmd,
 	int *ret)
 {
-	struct se_device *dev = SE_LUN(cmd)->lun_se_dev;
+	struct se_device *dev = cmd->se_lun->lun_se_dev;
 
 	/*
 	 * Assume TYPE_DISK for non struct se_device objects.
@@ -2695,7 +2695,7 @@ static inline u32 transport_get_sectors_10(
 	/*
 	 * XXX_10 is not defined in SSC, throw an exception
 	 */
-	if (TRANSPORT(dev)->get_device_type(dev) == TYPE_TAPE) {
+	if (dev->transport->get_device_type(dev) == TYPE_TAPE) {
 		*ret = -EINVAL;
 		return 0;
 	}
@@ -2713,7 +2713,7 @@ static inline u32 transport_get_sectors_12(
 	struct se_cmd *cmd,
 	int *ret)
 {
-	struct se_device *dev = SE_LUN(cmd)->lun_se_dev;
+	struct se_device *dev = cmd->se_lun->lun_se_dev;
 
 	/*
 	 * Assume TYPE_DISK for non struct se_device objects.
@@ -2725,7 +2725,7 @@ static inline u32 transport_get_sectors_12(
 	/*
 	 * XXX_12 is not defined in SSC, throw an exception
 	 */
-	if (TRANSPORT(dev)->get_device_type(dev) == TYPE_TAPE) {
+	if (dev->transport->get_device_type(dev) == TYPE_TAPE) {
 		*ret = -EINVAL;
 		return 0;
 	}
@@ -2743,7 +2743,7 @@ static inline u32 transport_get_sectors_16(
 	struct se_cmd *cmd,
 	int *ret)
 {
-	struct se_device *dev = SE_LUN(cmd)->lun_se_dev;
+	struct se_device *dev = cmd->se_lun->lun_se_dev;
 
 	/*
 	 * Assume TYPE_DISK for non struct se_device objects.
@@ -2755,7 +2755,7 @@ static inline u32 transport_get_sectors_16(
 	/*
 	 * Use 24-bit allocation length for TYPE_TAPE.
 	 */
-	if (TRANSPORT(dev)->get_device_type(dev) == TYPE_TAPE)
+	if (dev->transport->get_device_type(dev) == TYPE_TAPE)
 		return (u32)(cdb[12] << 16) + (cdb[13] << 8) + cdb[14];
 
 type_disk:
@@ -2785,21 +2785,21 @@ static inline u32 transport_get_size(
 	unsigned char *cdb,
 	struct se_cmd *cmd)
 {
-	struct se_device *dev = SE_DEV(cmd);
+	struct se_device *dev = cmd->se_lun->lun_se_dev;
 
-	if (TRANSPORT(dev)->get_device_type(dev) == TYPE_TAPE) {
+	if (dev->transport->get_device_type(dev) == TYPE_TAPE) {
 		if (cdb[1] & 1) { /* sectors */
-			return DEV_ATTRIB(dev)->block_size * sectors;
+			return dev->se_sub_dev->se_dev_attrib.block_size * sectors;
 		} else /* bytes */
 			return sectors;
 	}
 #if 0
 	printk(KERN_INFO "Returning block_size: %u, sectors: %u == %u for"
-			" %s object\n", DEV_ATTRIB(dev)->block_size, sectors,
-			DEV_ATTRIB(dev)->block_size * sectors,
-			TRANSPORT(dev)->name);
+			" %s object\n", dev->se_sub_dev->se_dev_attrib.block_size, sectors,
+			dev->se_sub_dev->se_dev_attrib.block_size * sectors,
+			dev->transport->name);
 #endif
-	return DEV_ATTRIB(dev)->block_size * sectors;
+	return dev->se_sub_dev->se_dev_attrib.block_size * sectors;
 }
 
 unsigned char transport_asciihex_to_binaryhex(unsigned char val[2])
@@ -2853,17 +2853,17 @@ static void transport_xor_callback(struct se_cmd *cmd)
 		return;
 	}
 	/*
-	 * Copy the scatterlist WRITE buffer located at T_TASK(cmd)->t_mem_list
+	 * Copy the scatterlist WRITE buffer located at cmd->t_task->t_mem_list
 	 * into the locally allocated *buf
 	 */
-	transport_memcpy_se_mem_read_contig(cmd, buf, T_TASK(cmd)->t_mem_list);
+	transport_memcpy_se_mem_read_contig(cmd, buf, cmd->t_task->t_mem_list);
 	/*
 	 * Now perform the XOR against the BIDI read memory located at
-	 * T_TASK(cmd)->t_mem_bidi_list
+	 * cmd->t_task->t_mem_bidi_list
 	 */
 
 	offset = 0;
-	list_for_each_entry(se_mem, T_TASK(cmd)->t_mem_bidi_list, se_list) {
+	list_for_each_entry(se_mem, cmd->t_task->t_mem_bidi_list, se_list) {
 		addr = (unsigned char *)kmap_atomic(se_mem->se_page, KM_USER0);
 		if (!(addr))
 			goto out;
@@ -2889,16 +2889,16 @@ static int transport_get_sense_data(struct se_cmd *cmd)
 	unsigned long flags;
 	u32 offset = 0;
 
-	WARN_ON(!SE_LUN(cmd));
+	WARN_ON(!cmd->se_lun);
 
-	spin_lock_irqsave(&T_TASK(cmd)->t_state_lock, flags);
+	spin_lock_irqsave(&cmd->t_task->t_state_lock, flags);
 	if (cmd->se_cmd_flags & SCF_SENT_CHECK_CONDITION) {
-		spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
+		spin_unlock_irqrestore(&cmd->t_task->t_state_lock, flags);
 		return 0;
 	}
 
 	list_for_each_entry_safe(task, task_tmp,
-				&T_TASK(cmd)->t_task_list, t_list) {
+				&cmd->t_task->t_task_list, t_list) {
 
 		if (!task->task_sense)
 			continue;
@@ -2907,22 +2907,22 @@ static int transport_get_sense_data(struct se_cmd *cmd)
 		if (!(dev))
 			continue;
 
-		if (!TRANSPORT(dev)->get_sense_buffer) {
-			printk(KERN_ERR "TRANSPORT(dev)->get_sense_buffer"
+		if (!dev->transport->get_sense_buffer) {
+			printk(KERN_ERR "dev->transport->get_sense_buffer"
 					" is NULL\n");
 			continue;
 		}
 
-		sense_buffer = TRANSPORT(dev)->get_sense_buffer(task);
+		sense_buffer = dev->transport->get_sense_buffer(task);
 		if (!(sense_buffer)) {
 			printk(KERN_ERR "ITT[0x%08x]_TASK[%d]: Unable to locate"
 				" sense buffer for task with sense\n",
-				CMD_TFO(cmd)->get_task_tag(cmd), task->task_no);
+				cmd->se_tfo->get_task_tag(cmd), task->task_no);
 			continue;
 		}
-		spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
+		spin_unlock_irqrestore(&cmd->t_task->t_state_lock, flags);
 
-		offset = CMD_TFO(cmd)->set_fabric_sense_len(cmd,
+		offset = cmd->se_tfo->set_fabric_sense_len(cmd,
 				TRANSPORT_SENSE_BUFFER);
 
 		memcpy((void *)&buffer[offset], (void *)sense_buffer,
@@ -2934,11 +2934,11 @@ static int transport_get_sense_data(struct se_cmd *cmd)
 
 		printk(KERN_INFO "HBA_[%u]_PLUG[%s]: Set SAM STATUS: 0x%02x"
 				" and sense\n",
-			dev->se_hba->hba_id, TRANSPORT(dev)->name,
+			dev->se_hba->hba_id, dev->transport->name,
 				cmd->scsi_status);
 		return 0;
 	}
-	spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
+	spin_unlock_irqrestore(&cmd->t_task->t_state_lock, flags);
 
 	return -1;
 }
@@ -2970,9 +2970,9 @@ transport_handle_reservation_conflict(struct se_cmd *cmd)
 	 *
 	 * See spc4r17, section 7.4.6 Control Mode Page, Table 349
 	 */
-	if (SE_SESS(cmd) &&
-	    DEV_ATTRIB(cmd->se_dev)->emulate_ua_intlck_ctrl == 2)
-		core_scsi3_ua_allocate(SE_SESS(cmd)->se_node_acl,
+	if (cmd->se_sess &&
+	    cmd->se_dev->se_sub_dev->se_dev_attrib.emulate_ua_intlck_ctrl == 2)
+		core_scsi3_ua_allocate(cmd->se_sess->se_node_acl,
 			cmd->orig_fe_lun, 0x2C,
 			ASCQ_2CH_PREVIOUS_RESERVATION_CONFLICT_STATUS);
 	return -2;
@@ -2992,7 +2992,7 @@ static int transport_generic_cmd_sequencer(
 	struct se_cmd *cmd,
 	unsigned char *cdb)
 {
-	struct se_device *dev = SE_DEV(cmd);
+	struct se_device *dev = cmd->se_lun->lun_se_dev;
 	struct se_subsystem_dev *su_dev = dev->se_sub_dev;
 	int ret = 0, sector_ret = 0, passthrough;
 	u32 sectors = 0, size = 0, pr_reg_type = 0;
@@ -3011,7 +3011,7 @@ static int transport_generic_cmd_sequencer(
 	/*
 	 * Check status of Asymmetric Logical Unit Assignment port
 	 */
-	ret = T10_ALUA(su_dev)->alua_state_check(cmd, cdb, &alua_ascq);
+	ret = su_dev->t10_alua.alua_state_check(cmd, cdb, &alua_ascq);
 	if (ret != 0) {
 		cmd->transport_wait_for_tasks = &transport_nop_wait_for_tasks;
 		/*
@@ -3023,7 +3023,7 @@ static int transport_generic_cmd_sequencer(
 #if 0
 			printk(KERN_INFO "[%s]: ALUA TG Port not available,"
 				" SenseKey: NOT_READY, ASC/ASCQ: 0x04/0x%02x\n",
-				CMD_TFO(cmd)->get_fabric_name(), alua_ascq);
+				cmd->se_tfo->get_fabric_name(), alua_ascq);
 #endif
 			transport_set_sense_codes(cmd, 0x04, alua_ascq);
 			cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
@@ -3035,8 +3035,8 @@ static int transport_generic_cmd_sequencer(
 	/*
 	 * Check status for SPC-3 Persistent Reservations
 	 */
-	if (T10_PR_OPS(su_dev)->t10_reservation_check(cmd, &pr_reg_type) != 0) {
-		if (T10_PR_OPS(su_dev)->t10_seq_non_holder(
+	if (su_dev->t10_pr.pr_ops.t10_reservation_check(cmd, &pr_reg_type) != 0) {
+		if (su_dev->t10_pr.pr_ops.t10_seq_non_holder(
 					cmd, cdb, pr_reg_type) != 0)
 			return transport_handle_reservation_conflict(cmd);
 		/*
@@ -3053,7 +3053,7 @@ static int transport_generic_cmd_sequencer(
 			goto out_unsupported_cdb;
 		size = transport_get_size(sectors, cdb, cmd);
 		cmd->transport_split_cdb = &split_cdb_XX_6;
-		T_TASK(cmd)->t_task_lba = transport_lba_21(cdb);
+		cmd->t_task->t_task_lba = transport_lba_21(cdb);
 		cmd->se_cmd_flags |= SCF_SCSI_DATA_SG_IO_CDB;
 		break;
 	case READ_10:
@@ -3062,7 +3062,7 @@ static int transport_generic_cmd_sequencer(
 			goto out_unsupported_cdb;
 		size = transport_get_size(sectors, cdb, cmd);
 		cmd->transport_split_cdb = &split_cdb_XX_10;
-		T_TASK(cmd)->t_task_lba = transport_lba_32(cdb);
+		cmd->t_task->t_task_lba = transport_lba_32(cdb);
 		cmd->se_cmd_flags |= SCF_SCSI_DATA_SG_IO_CDB;
 		break;
 	case READ_12:
@@ -3071,7 +3071,7 @@ static int transport_generic_cmd_sequencer(
 			goto out_unsupported_cdb;
 		size = transport_get_size(sectors, cdb, cmd);
 		cmd->transport_split_cdb = &split_cdb_XX_12;
-		T_TASK(cmd)->t_task_lba = transport_lba_32(cdb);
+		cmd->t_task->t_task_lba = transport_lba_32(cdb);
 		cmd->se_cmd_flags |= SCF_SCSI_DATA_SG_IO_CDB;
 		break;
 	case READ_16:
@@ -3080,7 +3080,7 @@ static int transport_generic_cmd_sequencer(
 			goto out_unsupported_cdb;
 		size = transport_get_size(sectors, cdb, cmd);
 		cmd->transport_split_cdb = &split_cdb_XX_16;
-		T_TASK(cmd)->t_task_lba = transport_lba_64(cdb);
+		cmd->t_task->t_task_lba = transport_lba_64(cdb);
 		cmd->se_cmd_flags |= SCF_SCSI_DATA_SG_IO_CDB;
 		break;
 	case WRITE_6:
@@ -3089,7 +3089,7 @@ static int transport_generic_cmd_sequencer(
 			goto out_unsupported_cdb;
 		size = transport_get_size(sectors, cdb, cmd);
 		cmd->transport_split_cdb = &split_cdb_XX_6;
-		T_TASK(cmd)->t_task_lba = transport_lba_21(cdb);
+		cmd->t_task->t_task_lba = transport_lba_21(cdb);
 		cmd->se_cmd_flags |= SCF_SCSI_DATA_SG_IO_CDB;
 		break;
 	case WRITE_10:
@@ -3098,8 +3098,8 @@ static int transport_generic_cmd_sequencer(
 			goto out_unsupported_cdb;
 		size = transport_get_size(sectors, cdb, cmd);
 		cmd->transport_split_cdb = &split_cdb_XX_10;
-		T_TASK(cmd)->t_task_lba = transport_lba_32(cdb);
-		T_TASK(cmd)->t_tasks_fua = (cdb[1] & 0x8);
+		cmd->t_task->t_task_lba = transport_lba_32(cdb);
+		cmd->t_task->t_tasks_fua = (cdb[1] & 0x8);
 		cmd->se_cmd_flags |= SCF_SCSI_DATA_SG_IO_CDB;
 		break;
 	case WRITE_12:
@@ -3108,8 +3108,8 @@ static int transport_generic_cmd_sequencer(
 			goto out_unsupported_cdb;
 		size = transport_get_size(sectors, cdb, cmd);
 		cmd->transport_split_cdb = &split_cdb_XX_12;
-		T_TASK(cmd)->t_task_lba = transport_lba_32(cdb);
-		T_TASK(cmd)->t_tasks_fua = (cdb[1] & 0x8);
+		cmd->t_task->t_task_lba = transport_lba_32(cdb);
+		cmd->t_task->t_tasks_fua = (cdb[1] & 0x8);
 		cmd->se_cmd_flags |= SCF_SCSI_DATA_SG_IO_CDB;
 		break;
 	case WRITE_16:
@@ -3118,22 +3118,22 @@ static int transport_generic_cmd_sequencer(
 			goto out_unsupported_cdb;
 		size = transport_get_size(sectors, cdb, cmd);
 		cmd->transport_split_cdb = &split_cdb_XX_16;
-		T_TASK(cmd)->t_task_lba = transport_lba_64(cdb);
-		T_TASK(cmd)->t_tasks_fua = (cdb[1] & 0x8);
+		cmd->t_task->t_task_lba = transport_lba_64(cdb);
+		cmd->t_task->t_tasks_fua = (cdb[1] & 0x8);
 		cmd->se_cmd_flags |= SCF_SCSI_DATA_SG_IO_CDB;
 		break;
 	case XDWRITEREAD_10:
 		if ((cmd->data_direction != DMA_TO_DEVICE) ||
-		    !(T_TASK(cmd)->t_tasks_bidi))
+		    !(cmd->t_task->t_tasks_bidi))
 			goto out_invalid_cdb_field;
 		sectors = transport_get_sectors_10(cdb, cmd, &sector_ret);
 		if (sector_ret)
 			goto out_unsupported_cdb;
 		size = transport_get_size(sectors, cdb, cmd);
 		cmd->transport_split_cdb = &split_cdb_XX_10;
-		T_TASK(cmd)->t_task_lba = transport_lba_32(cdb);
+		cmd->t_task->t_task_lba = transport_lba_32(cdb);
 		cmd->se_cmd_flags |= SCF_SCSI_DATA_SG_IO_CDB;
-		passthrough = (TRANSPORT(dev)->transport_type ==
+		passthrough = (dev->transport->transport_type ==
 				TRANSPORT_PLUGIN_PHBA_PDEV);
 		/*
 		 * Skip the remaining assignments for TCM/PSCSI passthrough
@@ -3144,7 +3144,7 @@ static int transport_generic_cmd_sequencer(
 		 * Setup BIDI XOR callback to be run during transport_generic_complete_ok()
 		 */
 		cmd->transport_complete_callback = &transport_xor_callback;
-		T_TASK(cmd)->t_tasks_fua = (cdb[1] & 0x8);
+		cmd->t_task->t_tasks_fua = (cdb[1] & 0x8);
 		break;
 	case VARIABLE_LENGTH_CMD:
 		service_action = get_unaligned_be16(&cdb[8]);
@@ -3152,7 +3152,7 @@ static int transport_generic_cmd_sequencer(
 		 * Determine if this is TCM/PSCSI device and we should disable
 		 * internal emulation for this CDB.
 		 */
-		passthrough = (TRANSPORT(dev)->transport_type ==
+		passthrough = (dev->transport->transport_type ==
 					TRANSPORT_PLUGIN_PHBA_PDEV);
 
 		switch (service_action) {
@@ -3166,7 +3166,7 @@ static int transport_generic_cmd_sequencer(
 			 * XDWRITE_READ_32 logic.
 			 */
 			cmd->transport_split_cdb = &split_cdb_XX_32;
-			T_TASK(cmd)->t_task_lba = transport_lba_64_ext(cdb);
+			cmd->t_task->t_task_lba = transport_lba_64_ext(cdb);
 			cmd->se_cmd_flags |= SCF_SCSI_DATA_SG_IO_CDB;
 
 			/*
@@ -3180,14 +3180,14 @@ static int transport_generic_cmd_sequencer(
 			 * transport_generic_complete_ok()
 			 */
 			cmd->transport_complete_callback = &transport_xor_callback;
-			T_TASK(cmd)->t_tasks_fua = (cdb[10] & 0x8);
+			cmd->t_task->t_tasks_fua = (cdb[10] & 0x8);
 			break;
 		case WRITE_SAME_32:
 			sectors = transport_get_sectors_32(cdb, cmd, &sector_ret);
 			if (sector_ret)
 				goto out_unsupported_cdb;
 			size = transport_get_size(sectors, cdb, cmd);
-			T_TASK(cmd)->t_task_lba = get_unaligned_be64(&cdb[12]);
+			cmd->t_task->t_task_lba = get_unaligned_be64(&cdb[12]);
 			cmd->se_cmd_flags |= SCF_SCSI_CONTROL_SG_IO_CDB;
 
 			/*
@@ -3219,14 +3219,14 @@ static int transport_generic_cmd_sequencer(
 		}
 		break;
 	case MAINTENANCE_IN:
-		if (TRANSPORT(dev)->get_device_type(dev) != TYPE_ROM) {
+		if (dev->transport->get_device_type(dev) != TYPE_ROM) {
 			/* MAINTENANCE_IN from SCC-2 */
 			/*
 			 * Check for emulated MI_REPORT_TARGET_PGS.
 			 */
 			if (cdb[1] == MI_REPORT_TARGET_PGS) {
 				cmd->transport_emulate_cdb =
-				(T10_ALUA(su_dev)->alua_type ==
+				(su_dev->t10_alua.alua_type ==
 				 SPC3_ALUA_EMULATED) ?
 				core_emulate_report_target_port_groups :
 				NULL;
@@ -3273,7 +3273,7 @@ static int transport_generic_cmd_sequencer(
 	case PERSISTENT_RESERVE_IN:
 	case PERSISTENT_RESERVE_OUT:
 		cmd->transport_emulate_cdb =
-			(T10_RES(su_dev)->res_type ==
+			(su_dev->t10_pr.res_type ==
 			 SPC3_PERSISTENT_RESERVATIONS) ?
 			core_scsi3_emulate_pr : NULL;
 		size = (cdb[7] << 8) + cdb[8];
@@ -3289,14 +3289,14 @@ static int transport_generic_cmd_sequencer(
 		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_NONSG_IO_CDB;
 		break;
 	case MAINTENANCE_OUT:
-		if (TRANSPORT(dev)->get_device_type(dev) != TYPE_ROM) {
+		if (dev->transport->get_device_type(dev) != TYPE_ROM) {
 			/* MAINTENANCE_OUT from SCC-2
 			 *
 			 * Check for emulated MO_SET_TARGET_PGS.
 			 */
 			if (cdb[1] == MO_SET_TARGET_PGS) {
 				cmd->transport_emulate_cdb =
-				(T10_ALUA(su_dev)->alua_type ==
+				(su_dev->t10_alua.alua_type ==
 					SPC3_ALUA_EMULATED) ?
 				core_emulate_set_target_port_groups :
 				NULL;
@@ -3316,7 +3316,7 @@ static int transport_generic_cmd_sequencer(
 		 * Do implict HEAD_OF_QUEUE processing for INQUIRY.
 		 * See spc4r17 section 5.3
 		 */
-		if (SE_DEV(cmd)->dev_task_attr_type == SAM_TASK_ATTR_EMULATED)
+		if (cmd->se_lun->lun_se_dev->dev_task_attr_type == SAM_TASK_ATTR_EMULATED)
 			cmd->sam_task_attr = MSG_HEAD_TAG;
 		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_NONSG_IO_CDB;
 		break;
@@ -3393,7 +3393,7 @@ static int transport_generic_cmd_sequencer(
 		 * emulation disabled.
 		 */
 		cmd->transport_emulate_cdb =
-				(T10_RES(su_dev)->res_type !=
+				(su_dev->t10_pr.res_type !=
 				 SPC_PASSTHROUGH) ?
 				core_scsi2_emulate_crh : NULL;
 		cmd->se_cmd_flags |= SCF_SCSI_NON_DATA_CDB;
@@ -3410,7 +3410,7 @@ static int transport_generic_cmd_sequencer(
 			size = cmd->data_length;
 
 		cmd->transport_emulate_cdb =
-				(T10_RES(su_dev)->res_type !=
+				(su_dev->t10_pr.res_type !=
 				 SPC_PASSTHROUGH) ?
 				core_scsi2_emulate_crh : NULL;
 		cmd->se_cmd_flags |= SCF_SCSI_NON_DATA_CDB;
@@ -3422,10 +3422,10 @@ static int transport_generic_cmd_sequencer(
 		 */
 		if (cdb[0] == SYNCHRONIZE_CACHE) {
 			sectors = transport_get_sectors_10(cdb, cmd, &sector_ret);
-			T_TASK(cmd)->t_task_lba = transport_lba_32(cdb);
+			cmd->t_task->t_task_lba = transport_lba_32(cdb);
 		} else {
 			sectors = transport_get_sectors_16(cdb, cmd, &sector_ret);
-			T_TASK(cmd)->t_task_lba = transport_lba_64(cdb);
+			cmd->t_task->t_task_lba = transport_lba_64(cdb);
 		}
 		if (sector_ret)
 			goto out_unsupported_cdb;
@@ -3436,7 +3436,7 @@ static int transport_generic_cmd_sequencer(
 		/*
 		 * For TCM/pSCSI passthrough, skip cmd->transport_emulate_cdb()
 		 */
-		if (TRANSPORT(dev)->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV)
+		if (dev->transport->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV)
 			break;
 		/*
 		 * Set SCF_EMULATE_CDB_ASYNC to ensure asynchronous operation
@@ -3452,7 +3452,7 @@ static int transport_generic_cmd_sequencer(
 		break;
 	case UNMAP:
 		size = get_unaligned_be16(&cdb[7]);
-		passthrough = (TRANSPORT(dev)->transport_type ==
+		passthrough = (dev->transport->transport_type ==
 				TRANSPORT_PLUGIN_PHBA_PDEV);
 		/*
 		 * Determine if the received UNMAP used to for direct passthrough
@@ -3471,8 +3471,8 @@ static int transport_generic_cmd_sequencer(
 		if (sector_ret)
 			goto out_unsupported_cdb;
 		size = transport_get_size(sectors, cdb, cmd);
-		T_TASK(cmd)->t_task_lba = get_unaligned_be16(&cdb[2]);
-		passthrough = (TRANSPORT(dev)->transport_type ==
+		cmd->t_task->t_task_lba = get_unaligned_be16(&cdb[2]);
+		passthrough = (dev->transport->transport_type ==
 				TRANSPORT_PLUGIN_PHBA_PDEV);
 		/*
 		 * Determine if the received WRITE_SAME_16 is used to for direct
@@ -3524,14 +3524,14 @@ static int transport_generic_cmd_sequencer(
 		 * Do implict HEAD_OF_QUEUE processing for REPORT_LUNS
 		 * See spc4r17 section 5.3
 		 */
-		if (SE_DEV(cmd)->dev_task_attr_type == SAM_TASK_ATTR_EMULATED)
+		if (cmd->se_lun->lun_se_dev->dev_task_attr_type == SAM_TASK_ATTR_EMULATED)
 			cmd->sam_task_attr = MSG_HEAD_TAG;
 		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_NONSG_IO_CDB;
 		break;
 	default:
 		printk(KERN_WARNING "TARGET_CORE[%s]: Unsupported SCSI Opcode"
 			" 0x%02x, sending CHECK_CONDITION.\n",
-			CMD_TFO(cmd)->get_fabric_name(), cdb[0]);
+			cmd->se_tfo->get_fabric_name(), cdb[0]);
 		cmd->transport_wait_for_tasks = &transport_nop_wait_for_tasks;
 		goto out_unsupported_cdb;
 	}
@@ -3539,7 +3539,7 @@ static int transport_generic_cmd_sequencer(
 	if (size != cmd->data_length) {
 		printk(KERN_WARNING "TARGET_CORE[%s]: Expected Transfer Length:"
 			" %u does not match SCSI CDB Length: %u for SAM Opcode:"
-			" 0x%02x\n", CMD_TFO(cmd)->get_fabric_name(),
+			" 0x%02x\n", cmd->se_tfo->get_fabric_name(),
 				cmd->data_length, size, cdb[0]);
 
 		cmd->cmd_spdtl = size;
@@ -3553,10 +3553,10 @@ static int transport_generic_cmd_sequencer(
 		 * Reject READ_* or WRITE_* with overflow/underflow for
 		 * type SCF_SCSI_DATA_SG_IO_CDB.
 		 */
-		if (!(ret) && (DEV_ATTRIB(dev)->block_size != 512))  {
+		if (!(ret) && (dev->se_sub_dev->se_dev_attrib.block_size != 512))  {
 			printk(KERN_ERR "Failing OVERFLOW/UNDERFLOW for LBA op"
 				" CDB on non 512-byte sector setup subsystem"
-				" plugin: %s\n", TRANSPORT(dev)->name);
+				" plugin: %s\n", dev->transport->name);
 			/* Returns CHECK_CONDITION + INVALID_CDB_FIELD */
 			goto out_invalid_cdb_field;
 		}
@@ -3679,7 +3679,7 @@ static void transport_memcpy_se_mem_read_contig(
  */
 static void transport_complete_task_attr(struct se_cmd *cmd)
 {
-	struct se_device *dev = SE_DEV(cmd);
+	struct se_device *dev = cmd->se_lun->lun_se_dev;
 	struct se_cmd *cmd_p, *cmd_tmp;
 	int new_active_tasks = 0;
 
@@ -3750,7 +3750,7 @@ static void transport_generic_complete_ok(struct se_cmd *cmd)
 	 * delayed execution list after a HEAD_OF_QUEUE or ORDERED Task
 	 * Attribute.
 	 */
-	if (SE_DEV(cmd)->dev_task_attr_type == SAM_TASK_ATTR_EMULATED)
+	if (cmd->se_lun->lun_se_dev->dev_task_attr_type == SAM_TASK_ATTR_EMULATED)
 		transport_complete_task_attr(cmd);
 	/*
 	 * Check if we need to retrieve a sense buffer from
@@ -3782,8 +3782,8 @@ static void transport_generic_complete_ok(struct se_cmd *cmd)
 	switch (cmd->data_direction) {
 	case DMA_FROM_DEVICE:
 		spin_lock(&cmd->se_lun->lun_sep_lock);
-		if (SE_LUN(cmd)->lun_sep) {
-			SE_LUN(cmd)->lun_sep->sep_stats.tx_data_octets +=
+		if (cmd->se_lun->lun_sep) {
+			cmd->se_lun->lun_sep->sep_stats.tx_data_octets +=
 					cmd->data_length;
 		}
 		spin_unlock(&cmd->se_lun->lun_sep_lock);
@@ -3794,34 +3794,34 @@ static void transport_generic_complete_ok(struct se_cmd *cmd)
 		 */
 		if (cmd->se_cmd_flags & SCF_PASSTHROUGH_CONTIG_TO_SG)
 			transport_memcpy_write_contig(cmd,
-				 T_TASK(cmd)->t_task_pt_sgl,
-				 T_TASK(cmd)->t_task_buf);
+				 cmd->t_task->t_task_pt_sgl,
+				 cmd->t_task->t_task_buf);
 
-		CMD_TFO(cmd)->queue_data_in(cmd);
+		cmd->se_tfo->queue_data_in(cmd);
 		break;
 	case DMA_TO_DEVICE:
 		spin_lock(&cmd->se_lun->lun_sep_lock);
-		if (SE_LUN(cmd)->lun_sep) {
-			SE_LUN(cmd)->lun_sep->sep_stats.rx_data_octets +=
+		if (cmd->se_lun->lun_sep) {
+			cmd->se_lun->lun_sep->sep_stats.rx_data_octets +=
 				cmd->data_length;
 		}
 		spin_unlock(&cmd->se_lun->lun_sep_lock);
 		/*
 		 * Check if we need to send READ payload for BIDI-COMMAND
 		 */
-		if (T_TASK(cmd)->t_mem_bidi_list != NULL) {
+		if (cmd->t_task->t_mem_bidi_list != NULL) {
 			spin_lock(&cmd->se_lun->lun_sep_lock);
-			if (SE_LUN(cmd)->lun_sep) {
-				SE_LUN(cmd)->lun_sep->sep_stats.tx_data_octets +=
+			if (cmd->se_lun->lun_sep) {
+				cmd->se_lun->lun_sep->sep_stats.tx_data_octets +=
 					cmd->data_length;
 			}
 			spin_unlock(&cmd->se_lun->lun_sep_lock);
-			CMD_TFO(cmd)->queue_data_in(cmd);
+			cmd->se_tfo->queue_data_in(cmd);
 			break;
 		}
 		/* Fall through for DMA_TO_DEVICE */
 	case DMA_NONE:
-		CMD_TFO(cmd)->queue_status(cmd);
+		cmd->se_tfo->queue_status(cmd);
 		break;
 	default:
 		break;
@@ -3836,9 +3836,9 @@ static void transport_free_dev_tasks(struct se_cmd *cmd)
 	struct se_task *task, *task_tmp;
 	unsigned long flags;
 
-	spin_lock_irqsave(&T_TASK(cmd)->t_state_lock, flags);
+	spin_lock_irqsave(&cmd->t_task->t_state_lock, flags);
 	list_for_each_entry_safe(task, task_tmp,
-				&T_TASK(cmd)->t_task_list, t_list) {
+				&cmd->t_task->t_task_list, t_list) {
 		if (atomic_read(&task->task_active))
 			continue;
 
@@ -3847,15 +3847,15 @@ static void transport_free_dev_tasks(struct se_cmd *cmd)
 
 		list_del(&task->t_list);
 
-		spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
+		spin_unlock_irqrestore(&cmd->t_task->t_state_lock, flags);
 		if (task->se_dev)
-			TRANSPORT(task->se_dev)->free_task(task);
+			task->se_dev->transport->free_task(task);
 		else
 			printk(KERN_ERR "task[%u] - task->se_dev is NULL\n",
 				task->task_no);
-		spin_lock_irqsave(&T_TASK(cmd)->t_state_lock, flags);
+		spin_lock_irqsave(&cmd->t_task->t_state_lock, flags);
 	}
-	spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
+	spin_unlock_irqrestore(&cmd->t_task->t_state_lock, flags);
 }
 
 static inline void transport_free_pages(struct se_cmd *cmd)
@@ -3868,9 +3868,9 @@ static inline void transport_free_pages(struct se_cmd *cmd)
 	if (cmd->se_dev->transport->do_se_mem_map)
 		free_page = 0;
 
-	if (T_TASK(cmd)->t_task_buf) {
-		kfree(T_TASK(cmd)->t_task_buf);
-		T_TASK(cmd)->t_task_buf = NULL;
+	if (cmd->t_task->t_task_buf) {
+		kfree(cmd->t_task->t_task_buf);
+		cmd->t_task->t_task_buf = NULL;
 		return;
 	}
 
@@ -3880,11 +3880,11 @@ static inline void transport_free_pages(struct se_cmd *cmd)
 	if (cmd->se_cmd_flags & SCF_CMD_PASSTHROUGH_NOALLOC)
 		return;
 
-	if (!(T_TASK(cmd)->t_tasks_se_num))
+	if (!(cmd->t_task->t_tasks_se_num))
 		return;
 
 	list_for_each_entry_safe(se_mem, se_mem_tmp,
-			T_TASK(cmd)->t_mem_list, se_list) {
+			cmd->t_task->t_mem_list, se_list) {
 		/*
 		 * We only release call __free_page(struct se_mem->se_page) when
 		 * SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC is NOT in use,
@@ -3896,9 +3896,9 @@ static inline void transport_free_pages(struct se_cmd *cmd)
 		kmem_cache_free(se_mem_cache, se_mem);
 	}
 
-	if (T_TASK(cmd)->t_mem_bidi_list && T_TASK(cmd)->t_tasks_se_bidi_num) {
+	if (cmd->t_task->t_mem_bidi_list && cmd->t_task->t_tasks_se_bidi_num) {
 		list_for_each_entry_safe(se_mem, se_mem_tmp,
-				T_TASK(cmd)->t_mem_bidi_list, se_list) {
+				cmd->t_task->t_mem_bidi_list, se_list) {
 			/*
 			 * We only release call __free_page(struct se_mem->se_page) when
 			 * SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC is NOT in use,
@@ -3911,11 +3911,11 @@ static inline void transport_free_pages(struct se_cmd *cmd)
 		}
 	}
 
-	kfree(T_TASK(cmd)->t_mem_bidi_list);
-	T_TASK(cmd)->t_mem_bidi_list = NULL;
-	kfree(T_TASK(cmd)->t_mem_list);
-	T_TASK(cmd)->t_mem_list = NULL;
-	T_TASK(cmd)->t_tasks_se_num = 0;
+	kfree(cmd->t_task->t_mem_bidi_list);
+	cmd->t_task->t_mem_bidi_list = NULL;
+	kfree(cmd->t_task->t_mem_list);
+	cmd->t_task->t_mem_list = NULL;
+	cmd->t_task->t_tasks_se_num = 0;
 }
 
 static inline void transport_release_tasks(struct se_cmd *cmd)
@@ -3927,23 +3927,23 @@ static inline int transport_dec_and_check(struct se_cmd *cmd)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&T_TASK(cmd)->t_state_lock, flags);
-	if (atomic_read(&T_TASK(cmd)->t_fe_count)) {
-		if (!(atomic_dec_and_test(&T_TASK(cmd)->t_fe_count))) {
-			spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock,
+	spin_lock_irqsave(&cmd->t_task->t_state_lock, flags);
+	if (atomic_read(&cmd->t_task->t_fe_count)) {
+		if (!(atomic_dec_and_test(&cmd->t_task->t_fe_count))) {
+			spin_unlock_irqrestore(&cmd->t_task->t_state_lock,
 					flags);
 			return 1;
 		}
 	}
 
-	if (atomic_read(&T_TASK(cmd)->t_se_count)) {
-		if (!(atomic_dec_and_test(&T_TASK(cmd)->t_se_count))) {
-			spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock,
+	if (atomic_read(&cmd->t_task->t_se_count)) {
+		if (!(atomic_dec_and_test(&cmd->t_task->t_se_count))) {
+			spin_unlock_irqrestore(&cmd->t_task->t_state_lock,
 					flags);
 			return 1;
 		}
 	}
-	spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
+	spin_unlock_irqrestore(&cmd->t_task->t_state_lock, flags);
 
 	return 0;
 }
@@ -3955,20 +3955,20 @@ static void transport_release_fe_cmd(struct se_cmd *cmd)
 	if (transport_dec_and_check(cmd))
 		return;
 
-	spin_lock_irqsave(&T_TASK(cmd)->t_state_lock, flags);
-	if (!(atomic_read(&T_TASK(cmd)->transport_dev_active))) {
-		spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
+	spin_lock_irqsave(&cmd->t_task->t_state_lock, flags);
+	if (!(atomic_read(&cmd->t_task->transport_dev_active))) {
+		spin_unlock_irqrestore(&cmd->t_task->t_state_lock, flags);
 		goto free_pages;
 	}
-	atomic_set(&T_TASK(cmd)->transport_dev_active, 0);
+	atomic_set(&cmd->t_task->transport_dev_active, 0);
 	transport_all_task_dev_remove_state(cmd);
-	spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
+	spin_unlock_irqrestore(&cmd->t_task->t_state_lock, flags);
 
 	transport_release_tasks(cmd);
 free_pages:
 	transport_free_pages(cmd);
 	transport_free_se_cmd(cmd);
-	CMD_TFO(cmd)->release_cmd_direct(cmd);
+	cmd->se_tfo->release_cmd_direct(cmd);
 }
 
 static int transport_generic_remove(
@@ -3978,27 +3978,27 @@ static int transport_generic_remove(
 {
 	unsigned long flags;
 
-	if (!(T_TASK(cmd)))
+	if (!(cmd->t_task))
 		goto release_cmd;
 
 	if (transport_dec_and_check(cmd)) {
 		if (session_reinstatement) {
-			spin_lock_irqsave(&T_TASK(cmd)->t_state_lock, flags);
+			spin_lock_irqsave(&cmd->t_task->t_state_lock, flags);
 			transport_all_task_dev_remove_state(cmd);
-			spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock,
+			spin_unlock_irqrestore(&cmd->t_task->t_state_lock,
 					flags);
 		}
 		return 1;
 	}
 
-	spin_lock_irqsave(&T_TASK(cmd)->t_state_lock, flags);
-	if (!(atomic_read(&T_TASK(cmd)->transport_dev_active))) {
-		spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
+	spin_lock_irqsave(&cmd->t_task->t_state_lock, flags);
+	if (!(atomic_read(&cmd->t_task->transport_dev_active))) {
+		spin_unlock_irqrestore(&cmd->t_task->t_state_lock, flags);
 		goto free_pages;
 	}
-	atomic_set(&T_TASK(cmd)->transport_dev_active, 0);
+	atomic_set(&cmd->t_task->transport_dev_active, 0);
 	transport_all_task_dev_remove_state(cmd);
-	spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
+	spin_unlock_irqrestore(&cmd->t_task->t_state_lock, flags);
 
 	transport_release_tasks(cmd);
 free_pages:
@@ -4009,7 +4009,7 @@ release_cmd:
 		transport_release_cmd_to_pool(cmd);
 	} else {
 		transport_free_se_cmd(cmd);
-		CMD_TFO(cmd)->release_cmd_direct(cmd);
+		cmd->se_tfo->release_cmd_direct(cmd);
 	}
 
 	return 0;
@@ -4049,8 +4049,8 @@ int transport_generic_map_mem_to_cmd(
 			return -ENOSYS;
 		}
 
-		T_TASK(cmd)->t_mem_list = (struct list_head *)mem;
-		T_TASK(cmd)->t_tasks_se_num = sg_mem_num;
+		cmd->t_task->t_mem_list = (struct list_head *)mem;
+		cmd->t_task->t_tasks_se_num = sg_mem_num;
 		cmd->se_cmd_flags |= SCF_CMD_PASSTHROUGH_NOALLOC;
 		return 0;
 	}
@@ -4065,36 +4065,36 @@ int transport_generic_map_mem_to_cmd(
 		 * processed into a TCM struct se_subsystem_dev, we do the mapping
 		 * from the passed physical memory to struct se_mem->se_page here.
 		 */
-		T_TASK(cmd)->t_mem_list = transport_init_se_mem_list();
-		if (!(T_TASK(cmd)->t_mem_list))
+		cmd->t_task->t_mem_list = transport_init_se_mem_list();
+		if (!(cmd->t_task->t_mem_list))
 			return -ENOMEM;
 
 		ret = transport_map_sg_to_mem(cmd,
-			T_TASK(cmd)->t_mem_list, mem, &se_mem_cnt_out);
+			cmd->t_task->t_mem_list, mem, &se_mem_cnt_out);
 		if (ret < 0)
 			return -ENOMEM;
 
-		T_TASK(cmd)->t_tasks_se_num = se_mem_cnt_out;
+		cmd->t_task->t_tasks_se_num = se_mem_cnt_out;
 		/*
 		 * Setup BIDI READ list of struct se_mem elements
 		 */
 		if ((mem_bidi_in) && (sg_mem_bidi_num)) {
-			T_TASK(cmd)->t_mem_bidi_list = transport_init_se_mem_list();
-			if (!(T_TASK(cmd)->t_mem_bidi_list)) {
-				kfree(T_TASK(cmd)->t_mem_list);
+			cmd->t_task->t_mem_bidi_list = transport_init_se_mem_list();
+			if (!(cmd->t_task->t_mem_bidi_list)) {
+				kfree(cmd->t_task->t_mem_list);
 				return -ENOMEM;
 			}
 			se_mem_cnt_out = 0;
 
 			ret = transport_map_sg_to_mem(cmd,
-				T_TASK(cmd)->t_mem_bidi_list, mem_bidi_in,
+				cmd->t_task->t_mem_bidi_list, mem_bidi_in,
 				&se_mem_cnt_out);
 			if (ret < 0) {
-				kfree(T_TASK(cmd)->t_mem_list);
+				kfree(cmd->t_task->t_mem_list);
 				return -ENOMEM;
 			}
 
-			T_TASK(cmd)->t_tasks_se_bidi_num = se_mem_cnt_out;
+			cmd->t_task->t_tasks_se_bidi_num = se_mem_cnt_out;
 		}
 		cmd->se_cmd_flags |= SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC;
 
@@ -4114,7 +4114,7 @@ int transport_generic_map_mem_to_cmd(
 		 * struct scatterlist format.
 		 */
 		cmd->se_cmd_flags |= SCF_PASSTHROUGH_CONTIG_TO_SG;
-		T_TASK(cmd)->t_task_pt_sgl = mem;
+		cmd->t_task->t_task_pt_sgl = mem;
 	}
 
 	return 0;
@@ -4129,21 +4129,21 @@ static inline long long transport_dev_end_lba(struct se_device *dev)
 
 static int transport_get_sectors(struct se_cmd *cmd)
 {
-	struct se_device *dev = SE_DEV(cmd);
+	struct se_device *dev = cmd->se_lun->lun_se_dev;
 
-	T_TASK(cmd)->t_tasks_sectors =
-		(cmd->data_length / DEV_ATTRIB(dev)->block_size);
-	if (!(T_TASK(cmd)->t_tasks_sectors))
-		T_TASK(cmd)->t_tasks_sectors = 1;
+	cmd->t_task->t_tasks_sectors =
+		(cmd->data_length / dev->se_sub_dev->se_dev_attrib.block_size);
+	if (!(cmd->t_task->t_tasks_sectors))
+		cmd->t_task->t_tasks_sectors = 1;
 
-	if (TRANSPORT(dev)->get_device_type(dev) != TYPE_DISK)
+	if (dev->transport->get_device_type(dev) != TYPE_DISK)
 		return 0;
 
-	if ((T_TASK(cmd)->t_task_lba + T_TASK(cmd)->t_tasks_sectors) >
+	if ((cmd->t_task->t_task_lba + cmd->t_task->t_tasks_sectors) >
 	     transport_dev_end_lba(dev)) {
 		printk(KERN_ERR "LBA: %llu Sectors: %u exceeds"
 			" transport_dev_end_lba(): %llu\n",
-			T_TASK(cmd)->t_task_lba, T_TASK(cmd)->t_tasks_sectors,
+			cmd->t_task->t_task_lba, cmd->t_task->t_tasks_sectors,
 			transport_dev_end_lba(dev));
 		cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
 		cmd->scsi_sense_reason = TCM_SECTOR_COUNT_TOO_MANY;
@@ -4155,26 +4155,26 @@ static int transport_get_sectors(struct se_cmd *cmd)
 
 static int transport_new_cmd_obj(struct se_cmd *cmd)
 {
-	struct se_device *dev = SE_DEV(cmd);
+	struct se_device *dev = cmd->se_lun->lun_se_dev;
 	u32 task_cdbs = 0, rc;
 
 	if (!(cmd->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB)) {
 		task_cdbs++;
-		T_TASK(cmd)->t_task_cdbs++;
+		cmd->t_task->t_task_cdbs++;
 	} else {
 		int set_counts = 1;
 
 		/*
 		 * Setup any BIDI READ tasks and memory from
-		 * T_TASK(cmd)->t_mem_bidi_list so the READ struct se_tasks
+		 * cmd->t_task->t_mem_bidi_list so the READ struct se_tasks
 		 * are queued first for the non pSCSI passthrough case.
 		 */
-		if ((T_TASK(cmd)->t_mem_bidi_list != NULL) &&
-		    (TRANSPORT(dev)->transport_type != TRANSPORT_PLUGIN_PHBA_PDEV)) {
+		if ((cmd->t_task->t_mem_bidi_list != NULL) &&
+		    (dev->transport->transport_type != TRANSPORT_PLUGIN_PHBA_PDEV)) {
 			rc = transport_generic_get_cdb_count(cmd,
-				T_TASK(cmd)->t_task_lba,
-				T_TASK(cmd)->t_tasks_sectors,
-				DMA_FROM_DEVICE, T_TASK(cmd)->t_mem_bidi_list,
+				cmd->t_task->t_task_lba,
+				cmd->t_task->t_tasks_sectors,
+				DMA_FROM_DEVICE, cmd->t_task->t_mem_bidi_list,
 				set_counts);
 			if (!(rc)) {
 				cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
@@ -4185,13 +4185,13 @@ static int transport_new_cmd_obj(struct se_cmd *cmd)
 			set_counts = 0;
 		}
 		/*
-		 * Setup the tasks and memory from T_TASK(cmd)->t_mem_list
+		 * Setup the tasks and memory from cmd->t_task->t_mem_list
 		 * Note for BIDI transfers this will contain the WRITE payload
 		 */
 		task_cdbs = transport_generic_get_cdb_count(cmd,
-				T_TASK(cmd)->t_task_lba,
-				T_TASK(cmd)->t_tasks_sectors,
-				cmd->data_direction, T_TASK(cmd)->t_mem_list,
+				cmd->t_task->t_task_lba,
+				cmd->t_task->t_tasks_sectors,
+				cmd->data_direction, cmd->t_task->t_mem_list,
 				set_counts);
 		if (!(task_cdbs)) {
 			cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
@@ -4199,19 +4199,19 @@ static int transport_new_cmd_obj(struct se_cmd *cmd)
 					TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 			return PYX_TRANSPORT_LU_COMM_FAILURE;
 		}
-		T_TASK(cmd)->t_task_cdbs += task_cdbs;
+		cmd->t_task->t_task_cdbs += task_cdbs;
 
 #if 0
 		printk(KERN_INFO "data_length: %u, LBA: %llu t_tasks_sectors:"
 			" %u, t_task_cdbs: %u\n", obj_ptr, cmd->data_length,
-			T_TASK(cmd)->t_task_lba, T_TASK(cmd)->t_tasks_sectors,
-			T_TASK(cmd)->t_task_cdbs);
+			cmd->t_task->t_task_lba, cmd->t_task->t_tasks_sectors,
+			cmd->t_task->t_task_cdbs);
 #endif
 	}
 
-	atomic_set(&T_TASK(cmd)->t_task_cdbs_left, task_cdbs);
-	atomic_set(&T_TASK(cmd)->t_task_cdbs_ex_left, task_cdbs);
-	atomic_set(&T_TASK(cmd)->t_task_cdbs_timeout_left, task_cdbs);
+	atomic_set(&cmd->t_task->t_task_cdbs_left, task_cdbs);
+	atomic_set(&cmd->t_task->t_task_cdbs_ex_left, task_cdbs);
+	atomic_set(&cmd->t_task->t_task_cdbs_timeout_left, task_cdbs);
 	return 0;
 }
 
@@ -4235,8 +4235,8 @@ transport_generic_get_mem(struct se_cmd *cmd, u32 length, u32 dma_size)
 	unsigned char *buf;
 	struct se_mem *se_mem;
 
-	T_TASK(cmd)->t_mem_list = transport_init_se_mem_list();
-	if (!(T_TASK(cmd)->t_mem_list))
+	cmd->t_task->t_mem_list = transport_init_se_mem_list();
+	if (!(cmd->t_task->t_mem_list))
 		return -ENOMEM;
 
 	/*
@@ -4248,10 +4248,10 @@ transport_generic_get_mem(struct se_cmd *cmd, u32 length, u32 dma_size)
 	/*
 	 * Setup BIDI-COMMAND READ list of struct se_mem elements
 	 */
-	if (T_TASK(cmd)->t_tasks_bidi) {
-		T_TASK(cmd)->t_mem_bidi_list = transport_init_se_mem_list();
-		if (!(T_TASK(cmd)->t_mem_bidi_list)) {
-			kfree(T_TASK(cmd)->t_mem_list);
+	if (cmd->t_task->t_tasks_bidi) {
+		cmd->t_task->t_mem_bidi_list = transport_init_se_mem_list();
+		if (!(cmd->t_task->t_mem_bidi_list)) {
+			kfree(cmd->t_task->t_mem_list);
 			return -ENOMEM;
 		}
 	}
@@ -4280,8 +4280,8 @@ transport_generic_get_mem(struct se_cmd *cmd, u32 length, u32 dma_size)
 		memset(buf, 0, se_mem->se_len);
 		kunmap_atomic(buf, KM_IRQ0);
 
-		list_add_tail(&se_mem->se_list, T_TASK(cmd)->t_mem_list);
-		T_TASK(cmd)->t_tasks_se_num++;
+		list_add_tail(&se_mem->se_list, cmd->t_task->t_mem_list);
+		cmd->t_task->t_tasks_se_num++;
 
 		DEBUG_MEM("Allocated struct se_mem page(%p) Length(%u)"
 			" Offset(%u)\n", se_mem->se_page, se_mem->se_len,
@@ -4291,7 +4291,7 @@ transport_generic_get_mem(struct se_cmd *cmd, u32 length, u32 dma_size)
 	}
 
 	DEBUG_MEM("Allocated total struct se_mem elements(%u)\n",
-			T_TASK(cmd)->t_tasks_se_num);
+			cmd->t_task->t_tasks_se_num);
 
 	return 0;
 out:
@@ -4307,9 +4307,9 @@ int transport_init_task_sg(
 	u32 task_offset)
 {
 	struct se_cmd *se_cmd = task->task_se_cmd;
-	struct se_device *se_dev = SE_DEV(se_cmd);
+	struct se_device *se_dev = se_cmd->se_lun->lun_se_dev;
 	struct se_mem *se_mem = in_se_mem;
-	struct target_core_fabric_ops *tfo = CMD_TFO(se_cmd);
+	struct target_core_fabric_ops *tfo = se_cmd->se_tfo;
 	u32 sg_length, task_size = task->task_size, task_sg_num_padded;
 
 	while (task_size != 0) {
@@ -4323,7 +4323,7 @@ int transport_init_task_sg(
 				sg_length = se_mem->se_len;
 
 				if (!(list_is_last(&se_mem->se_list,
-						T_TASK(se_cmd)->t_mem_list)))
+						se_cmd->t_task->t_mem_list)))
 					se_mem = list_entry(se_mem->se_list.next,
 							struct se_mem, se_list);
 			} else {
@@ -4343,7 +4343,7 @@ int transport_init_task_sg(
 				sg_length = (se_mem->se_len - task_offset);
 
 				if (!(list_is_last(&se_mem->se_list,
-						T_TASK(se_cmd)->t_mem_list)))
+						se_cmd->t_task->t_mem_list)))
 					se_mem = list_entry(se_mem->se_list.next,
 							struct se_mem, se_list);
 			}
@@ -4384,8 +4384,8 @@ next:
 	 * Setup task->task_sg_bidi for SCSI READ payload for
 	 * TCM/pSCSI passthrough if present for BIDI-COMMAND
 	 */
-	if ((T_TASK(se_cmd)->t_mem_bidi_list != NULL) &&
-	    (TRANSPORT(se_dev)->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV)) {
+	if ((se_cmd->t_task->t_mem_bidi_list != NULL) &&
+	    (se_dev->transport->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV)) {
 		task->task_sg_bidi = kzalloc(task_sg_num_padded *
 				sizeof(struct scatterlist), GFP_KERNEL);
 		if (!(task->task_sg_bidi)) {
@@ -4430,13 +4430,13 @@ static inline int transport_set_tasks_sectors_disk(
 	if ((lba + sectors) > transport_dev_end_lba(dev)) {
 		task->task_sectors = ((transport_dev_end_lba(dev) - lba) + 1);
 
-		if (task->task_sectors > DEV_ATTRIB(dev)->max_sectors) {
-			task->task_sectors = DEV_ATTRIB(dev)->max_sectors;
+		if (task->task_sectors > dev->se_sub_dev->se_dev_attrib.max_sectors) {
+			task->task_sectors = dev->se_sub_dev->se_dev_attrib.max_sectors;
 			*max_sectors_set = 1;
 		}
 	} else {
-		if (sectors > DEV_ATTRIB(dev)->max_sectors) {
-			task->task_sectors = DEV_ATTRIB(dev)->max_sectors;
+		if (sectors > dev->se_sub_dev->se_dev_attrib.max_sectors) {
+			task->task_sectors = dev->se_sub_dev->se_dev_attrib.max_sectors;
 			*max_sectors_set = 1;
 		} else
 			task->task_sectors = sectors;
@@ -4452,8 +4452,8 @@ static inline int transport_set_tasks_sectors_non_disk(
 	u32 sectors,
 	int *max_sectors_set)
 {
-	if (sectors > DEV_ATTRIB(dev)->max_sectors) {
-		task->task_sectors = DEV_ATTRIB(dev)->max_sectors;
+	if (sectors > dev->se_sub_dev->se_dev_attrib.max_sectors) {
+		task->task_sectors = dev->se_sub_dev->se_dev_attrib.max_sectors;
 		*max_sectors_set = 1;
 	} else
 		task->task_sectors = sectors;
@@ -4468,7 +4468,7 @@ static inline int transport_set_tasks_sectors(
 	u32 sectors,
 	int *max_sectors_set)
 {
-	return (TRANSPORT(dev)->get_device_type(dev) == TYPE_DISK) ?
+	return (dev->transport->get_device_type(dev) == TYPE_DISK) ?
 		transport_set_tasks_sectors_disk(task, dev, lba, sectors,
 				max_sectors_set) :
 		transport_set_tasks_sectors_non_disk(task, dev, lba, sectors,
@@ -4568,7 +4568,7 @@ int transport_map_mem_to_sg(
 				sg->length = se_mem->se_len;
 
 				if (!(list_is_last(&se_mem->se_list,
-						T_TASK(se_cmd)->t_mem_list))) {
+						se_cmd->t_task->t_mem_list))) {
 					se_mem = list_entry(se_mem->se_list.next,
 							struct se_mem, se_list);
 					(*se_mem_cnt)++;
@@ -4604,7 +4604,7 @@ int transport_map_mem_to_sg(
 				sg->length = (se_mem->se_len - *task_offset);
 
 				if (!(list_is_last(&se_mem->se_list,
-						T_TASK(se_cmd)->t_mem_list))) {
+						se_cmd->t_task->t_mem_list))) {
 					se_mem = list_entry(se_mem->se_list.next,
 							struct se_mem, se_list);
 					(*se_mem_cnt)++;
@@ -4648,7 +4648,7 @@ void transport_do_task_sg_chain(struct se_cmd *cmd)
 	struct scatterlist *sg_head_cur = NULL, *sg_link_cur = NULL;
 	struct scatterlist *sg, *sg_end = NULL, *sg_end_cur = NULL;
 	struct se_task *task;
-	struct target_core_fabric_ops *tfo = CMD_TFO(cmd);
+	struct target_core_fabric_ops *tfo = cmd->se_tfo;
 	u32 task_sg_num = 0, sg_count = 0;
 	int i;
 
@@ -4662,7 +4662,7 @@ void transport_do_task_sg_chain(struct se_cmd *cmd)
 	 * Walk the struct se_task list and setup scatterlist chains
 	 * for each contiguosly allocated struct se_task->task_sg[].
 	 */
-	list_for_each_entry(task, &T_TASK(cmd)->t_task_list, t_list) {
+	list_for_each_entry(task, &cmd->t_task->t_task_list, t_list) {
 		if (!(task->task_sg) || !(task->task_padded_sg))
 			continue;
 
@@ -4673,7 +4673,7 @@ void transport_do_task_sg_chain(struct se_cmd *cmd)
 			 * Either add chain or mark end of scatterlist
 			 */
 			if (!(list_is_last(&task->t_list,
-					&T_TASK(cmd)->t_task_list))) {
+					&cmd->t_task->t_task_list))) {
 				/*
 				 * Clear existing SGL termination bit set in
 				 * transport_init_task_sg(), see sg_mark_end()
@@ -4699,7 +4699,7 @@ void transport_do_task_sg_chain(struct se_cmd *cmd)
 		/*
 		 * Check for single task..
 		 */
-		if (!(list_is_last(&task->t_list, &T_TASK(cmd)->t_task_list))) {
+		if (!(list_is_last(&task->t_list, &cmd->t_task->t_task_list))) {
 			/*
 			 * Clear existing SGL termination bit set in
 			 * transport_init_task_sg(), see sg_mark_end()
@@ -4717,15 +4717,15 @@ void transport_do_task_sg_chain(struct se_cmd *cmd)
 	 * Setup the starting pointer and total t_tasks_sg_linked_no including
 	 * padding SGs for linking and to mark the end.
 	 */
-	T_TASK(cmd)->t_tasks_sg_chained = sg_first;
-	T_TASK(cmd)->t_tasks_sg_chained_no = sg_count;
+	cmd->t_task->t_tasks_sg_chained = sg_first;
+	cmd->t_task->t_tasks_sg_chained_no = sg_count;
 
-	DEBUG_CMD_M("Setup cmd: %p T_TASK(cmd)->t_tasks_sg_chained: %p and"
-		" t_tasks_sg_chained_no: %u\n", cmd, T_TASK(cmd)->t_tasks_sg_chained,
-		T_TASK(cmd)->t_tasks_sg_chained_no);
+	DEBUG_CMD_M("Setup cmd: %p cmd->t_task->t_tasks_sg_chained: %p and"
+		" t_tasks_sg_chained_no: %u\n", cmd, cmd->t_task->t_tasks_sg_chained,
+		cmd->t_task->t_tasks_sg_chained_no);
 
-	for_each_sg(T_TASK(cmd)->t_tasks_sg_chained, sg,
-			T_TASK(cmd)->t_tasks_sg_chained_no, i) {
+	for_each_sg(cmd->t_task->t_tasks_sg_chained, sg,
+			cmd->t_task->t_tasks_sg_chained_no, i) {
 
 		DEBUG_CMD_M("SG[%d]: %p page: %p length: %d offset: %d, magic: 0x%08x\n",
 			i, sg, sg_page(sg), sg->length, sg->offset, sg->sg_magic);
@@ -4753,12 +4753,12 @@ static int transport_do_se_mem_map(
 	 * se_subsystem_api_t->do_se_mem_map is used when internal allocation
 	 * has been done by the transport plugin.
 	 */
-	if (TRANSPORT(dev)->do_se_mem_map) {
-		ret = TRANSPORT(dev)->do_se_mem_map(task, se_mem_list,
+	if (dev->transport->do_se_mem_map) {
+		ret = dev->transport->do_se_mem_map(task, se_mem_list,
 				in_mem, in_se_mem, out_se_mem, se_mem_cnt,
 				task_offset_in);
 		if (ret == 0)
-			T_TASK(task->task_se_cmd)->t_tasks_se_num += *se_mem_cnt;
+			task->task_se_cmd->t_task->t_tasks_se_num += *se_mem_cnt;
 
 		return ret;
 	}
@@ -4808,7 +4808,7 @@ static u32 transport_generic_get_cdb_count(
 	struct se_task *task;
 	struct se_mem *se_mem = NULL, *se_mem_lout = NULL;
 	struct se_mem *se_mem_bidi = NULL, *se_mem_bidi_lout = NULL;
-	struct se_device *dev = SE_DEV(cmd);
+	struct se_device *dev = cmd->se_lun->lun_se_dev;
 	int max_sectors_set = 0, ret;
 	u32 task_offset_in = 0, se_mem_cnt = 0, se_mem_bidi_cnt = 0, task_cdbs = 0;
 
@@ -4827,15 +4827,15 @@ static u32 transport_generic_get_cdb_count(
 	 * Check for extra se_mem_bidi mapping for BIDI-COMMANDs to
 	 * struct se_task->task_sg_bidi for TCM/pSCSI passthrough operation
 	 */
-	if ((T_TASK(cmd)->t_mem_bidi_list != NULL) &&
-	    !(list_empty(T_TASK(cmd)->t_mem_bidi_list)) &&
-	    (TRANSPORT(dev)->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV))
-		se_mem_bidi = list_entry(T_TASK(cmd)->t_mem_bidi_list->next,
+	if ((cmd->t_task->t_mem_bidi_list != NULL) &&
+	    !(list_empty(cmd->t_task->t_mem_bidi_list)) &&
+	    (dev->transport->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV))
+		se_mem_bidi = list_entry(cmd->t_task->t_mem_bidi_list->next,
 					struct se_mem, se_list);
 
 	while (sectors) {
 		DEBUG_VOL("ITT[0x%08x] LBA(%llu) SectorsLeft(%u) EOBJ(%llu)\n",
-			CMD_TFO(cmd)->get_task_tag(cmd), lba, sectors,
+			cmd->se_tfo->get_task_tag(cmd), lba, sectors,
 			transport_dev_end_lba(dev));
 
 		task = transport_generic_get_task(cmd, data_direction);
@@ -4849,19 +4849,19 @@ static u32 transport_generic_get_cdb_count(
 		lba += task->task_sectors;
 		sectors -= task->task_sectors;
 		task->task_size = (task->task_sectors *
-				   DEV_ATTRIB(dev)->block_size);
+				   dev->se_sub_dev->se_dev_attrib.block_size);
 
-		cdb = TRANSPORT(dev)->get_cdb(task);
+		cdb = dev->transport->get_cdb(task);
 		if ((cdb)) {
-			memcpy(cdb, T_TASK(cmd)->t_task_cdb,
-				scsi_command_size(T_TASK(cmd)->t_task_cdb));
+			memcpy(cdb, cmd->t_task->t_task_cdb,
+				scsi_command_size(cmd->t_task->t_task_cdb));
 			cmd->transport_split_cdb(task->task_lba,
 					&task->task_sectors, cdb);
 		}
 
 		/*
 		 * Perform the SE OBJ plugin and/or Transport plugin specific
-		 * mapping for T_TASK(cmd)->t_mem_list. And setup the
+		 * mapping for cmd->t_task->t_mem_list. And setup the
 		 * task->task_sg and if necessary task->task_sg_bidi
 		 */
 		ret = transport_do_se_mem_map(dev, task, mem_list,
@@ -4872,7 +4872,7 @@ static u32 transport_generic_get_cdb_count(
 
 		se_mem = se_mem_lout;
 		/*
-		 * Setup the T_TASK(cmd)->t_mem_bidi_list -> task->task_sg_bidi
+		 * Setup the cmd->t_task->t_mem_bidi_list -> task->task_sg_bidi
 		 * mapping for SCSI READ for BIDI-COMMAND passthrough with TCM/pSCSI
 		 *
 		 * Note that the first call to transport_do_se_mem_map() above will
@@ -4882,7 +4882,7 @@ static u32 transport_generic_get_cdb_count(
 		 */
 		if (task->task_sg_bidi != NULL) {
 			ret = transport_do_se_mem_map(dev, task,
-				T_TASK(cmd)->t_mem_bidi_list, NULL,
+				cmd->t_task->t_mem_bidi_list, NULL,
 				se_mem_bidi, &se_mem_bidi_lout, &se_mem_bidi_cnt,
 				&task_offset_in);
 			if (ret < 0)
@@ -4905,12 +4905,12 @@ static u32 transport_generic_get_cdb_count(
 	}
 
 	if (set_counts) {
-		atomic_inc(&T_TASK(cmd)->t_fe_count);
-		atomic_inc(&T_TASK(cmd)->t_se_count);
+		atomic_inc(&cmd->t_task->t_fe_count);
+		atomic_inc(&cmd->t_task->t_se_count);
 	}
 
 	DEBUG_VOL("ITT[0x%08x] total %s cdbs(%u)\n",
-		CMD_TFO(cmd)->get_task_tag(cmd), (data_direction == DMA_TO_DEVICE)
+		cmd->se_tfo->get_task_tag(cmd), (data_direction == DMA_TO_DEVICE)
 		? "DMA_TO_DEVICE" : "DMA_FROM_DEVICE", task_cdbs);
 
 	return task_cdbs;
@@ -4921,7 +4921,7 @@ out:
 static int
 transport_map_control_cmd_to_task(struct se_cmd *cmd)
 {
-	struct se_device *dev = SE_DEV(cmd);
+	struct se_device *dev = cmd->se_lun->lun_se_dev;
 	unsigned char *cdb;
 	struct se_task *task;
 	int ret;
@@ -4930,7 +4930,7 @@ transport_map_control_cmd_to_task(struct se_cmd *cmd)
 	if (!task)
 		return PYX_TRANSPORT_OUT_OF_MEMORY_RESOURCES;
 
-	cdb = TRANSPORT(dev)->get_cdb(task);
+	cdb = dev->transport->get_cdb(task);
 	if (cdb)
 		memcpy(cdb, cmd->t_task->t_task_cdb,
 			scsi_command_size(cmd->t_task->t_task_cdb));
@@ -4946,8 +4946,8 @@ transport_map_control_cmd_to_task(struct se_cmd *cmd)
 		struct se_mem *se_mem = NULL, *se_mem_lout = NULL;
 		u32 se_mem_cnt = 0, task_offset = 0;
 
-		if (!list_empty(T_TASK(cmd)->t_mem_list))
-			se_mem = list_entry(T_TASK(cmd)->t_mem_list->next,
+		if (!list_empty(cmd->t_task->t_mem_list))
+			se_mem = list_entry(cmd->t_task->t_mem_list->next,
 					struct se_mem, se_list);
 
 		ret = transport_do_se_mem_map(dev, task,
@@ -4986,14 +4986,14 @@ static int transport_generic_new_cmd(struct se_cmd *cmd)
 {
 	struct se_portal_group *se_tpg;
 	struct se_task *task;
-	struct se_device *dev = SE_DEV(cmd);
+	struct se_device *dev = cmd->se_lun->lun_se_dev;
 	int ret = 0;
 
 	/*
 	 * Determine is the TCM fabric module has already allocated physical
 	 * memory, and is directly calling transport_generic_map_mem_to_cmd()
 	 * to setup beforehand the linked list of physical memory at
-	 * T_TASK(cmd)->t_mem_list of struct se_mem->se_page
+	 * cmd->t_task->t_mem_list of struct se_mem->se_page
 	 */
 	if (!(cmd->se_cmd_flags & SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC)) {
 		ret = transport_allocate_resources(cmd);
@@ -5014,15 +5014,15 @@ static int transport_generic_new_cmd(struct se_cmd *cmd)
 	 * Linux/NET via kernel sockets and needs to allocate a
 	 * struct iovec array to complete the struct se_cmd
 	 */
-	se_tpg = SE_LUN(cmd)->lun_sep->sep_tpg;
-	if (TPG_TFO(se_tpg)->alloc_cmd_iovecs != NULL) {
-		ret = TPG_TFO(se_tpg)->alloc_cmd_iovecs(cmd);
+	se_tpg = cmd->se_lun->lun_sep->sep_tpg;
+	if (se_tpg->se_tpg_tfo->alloc_cmd_iovecs != NULL) {
+		ret = se_tpg->se_tpg_tfo->alloc_cmd_iovecs(cmd);
 		if (ret < 0)
 			return PYX_TRANSPORT_OUT_OF_MEMORY_RESOURCES;
 	}
 
 	if (cmd->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB) {
-		list_for_each_entry(task, &T_TASK(cmd)->t_task_list, t_list) {
+		list_for_each_entry(task, &cmd->t_task->t_task_list, t_list) {
 			if (atomic_read(&task->task_sent))
 				continue;
 			if (!dev->transport->map_task_SG)
@@ -5069,9 +5069,9 @@ void transport_generic_process_write(struct se_cmd *cmd)
 	 * original EDTL
 	 */
 	if (cmd->se_cmd_flags & SCF_UNDERFLOW_BIT) {
-		if (!T_TASK(cmd)->t_tasks_se_num) {
+		if (!cmd->t_task->t_tasks_se_num) {
 			unsigned char *dst, *buf =
-				(unsigned char *)T_TASK(cmd)->t_task_buf;
+				(unsigned char *)cmd->t_task->t_task_buf;
 
 			dst = kzalloc(cmd->cmd_spdtl), GFP_KERNEL);
 			if (!(dst)) {
@@ -5083,15 +5083,15 @@ void transport_generic_process_write(struct se_cmd *cmd)
 			}
 			memcpy(dst, buf, cmd->cmd_spdtl);
 
-			kfree(T_TASK(cmd)->t_task_buf);
-			T_TASK(cmd)->t_task_buf = dst;
+			kfree(cmd->t_task->t_task_buf);
+			cmd->t_task->t_task_buf = dst;
 		} else {
 			struct scatterlist *sg =
-				(struct scatterlist *sg)T_TASK(cmd)->t_task_buf;
+				(struct scatterlist *sg)cmd->t_task->t_task_buf;
 			struct scatterlist *orig_sg;
 
 			orig_sg = kzalloc(sizeof(struct scatterlist) *
-					T_TASK(cmd)->t_tasks_se_num,
+					cmd->t_task->t_tasks_se_num,
 					GFP_KERNEL))) {
 			if (!(orig_sg)) {
 				printk(KERN_ERR "Unable to allocate memory"
@@ -5101,9 +5101,9 @@ void transport_generic_process_write(struct se_cmd *cmd)
 				return;
 			}
 
-			memcpy(orig_sg, T_TASK(cmd)->t_task_buf,
+			memcpy(orig_sg, cmd->t_task->t_task_buf,
 					sizeof(struct scatterlist) *
-					T_TASK(cmd)->t_tasks_se_num);
+					cmd->t_task->t_tasks_se_num);
 
 			cmd->data_length = cmd->cmd_spdtl;
 			/*
@@ -5134,24 +5134,24 @@ static int transport_generic_write_pending(struct se_cmd *cmd)
 	unsigned long flags;
 	int ret;
 
-	spin_lock_irqsave(&T_TASK(cmd)->t_state_lock, flags);
+	spin_lock_irqsave(&cmd->t_task->t_state_lock, flags);
 	cmd->t_state = TRANSPORT_WRITE_PENDING;
-	spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
+	spin_unlock_irqrestore(&cmd->t_task->t_state_lock, flags);
 	/*
 	 * For the TCM control CDBs using a contiguous buffer, do the memcpy
 	 * from the passed Linux/SCSI struct scatterlist located at
-	 * T_TASK(se_cmd)->t_task_pt_buf to the contiguous buffer at
-	 * T_TASK(se_cmd)->t_task_buf.
+	 * se_cmd->t_task->t_task_pt_buf to the contiguous buffer at
+	 * se_cmd->t_task->t_task_buf.
 	 */
 	if (cmd->se_cmd_flags & SCF_PASSTHROUGH_CONTIG_TO_SG)
 		transport_memcpy_read_contig(cmd,
-				T_TASK(cmd)->t_task_buf,
-				T_TASK(cmd)->t_task_pt_sgl);
+				cmd->t_task->t_task_buf,
+				cmd->t_task->t_task_pt_sgl);
 	/*
 	 * Clear the se_cmd for WRITE_PENDING status in order to set
-	 * T_TASK(cmd)->t_transport_active=0 so that transport_generic_handle_data
+	 * cmd->t_task->t_transport_active=0 so that transport_generic_handle_data
 	 * can be called from HW target mode interrupt code.  This is safe
-	 * to be called with transport_off=1 before the CMD_TFO(cmd)->write_pending
+	 * to be called with transport_off=1 before the cmd->se_tfo->write_pending
 	 * because the se_cmd->se_lun pointer is not being cleared.
 	 */
 	transport_cmd_check_stop(cmd, 1, 0);
@@ -5160,7 +5160,7 @@ static int transport_generic_write_pending(struct se_cmd *cmd)
 	 * Call the fabric write_pending function here to let the
 	 * frontend know that WRITE buffers are ready.
 	 */
-	ret = CMD_TFO(cmd)->write_pending(cmd);
+	ret = cmd->se_tfo->write_pending(cmd);
 	if (ret < 0)
 		return ret;
 
@@ -5173,11 +5173,11 @@ static int transport_generic_write_pending(struct se_cmd *cmd)
  */
 void transport_release_cmd_to_pool(struct se_cmd *cmd)
 {
-	BUG_ON(!T_TASK(cmd));
-	BUG_ON(!CMD_TFO(cmd));
+	BUG_ON(!cmd->t_task);
+	BUG_ON(!cmd->se_tfo);
 
 	transport_free_se_cmd(cmd);
-	CMD_TFO(cmd)->release_cmd_to_pool(cmd);
+	cmd->se_tfo->release_cmd_to_pool(cmd);
 }
 EXPORT_SYMBOL(transport_release_cmd_to_pool);
 
@@ -5191,16 +5191,16 @@ void transport_generic_free_cmd(
 	int release_to_pool,
 	int session_reinstatement)
 {
-	if (!(cmd->se_cmd_flags & SCF_SE_LUN_CMD) || !T_TASK(cmd))
+	if (!(cmd->se_cmd_flags & SCF_SE_LUN_CMD) || !cmd->t_task)
 		transport_release_cmd_to_pool(cmd);
 	else {
 		core_dec_lacl_count(cmd->se_sess->se_node_acl, cmd);
 
-		if (SE_LUN(cmd)) {
+		if (cmd->se_lun) {
 #if 0
 			printk(KERN_INFO "cmd: %p ITT: 0x%08x contains"
-				" SE_LUN(cmd)\n", cmd,
-				CMD_TFO(cmd)->get_task_tag(cmd));
+				" cmd->se_lun\n", cmd,
+				cmd->se_tfo->get_task_tag(cmd));
 #endif
 			transport_lun_remove_cmd(cmd);
 		}
@@ -5237,32 +5237,32 @@ static int transport_lun_wait_for_tasks(struct se_cmd *cmd, struct se_lun *lun)
 	 * If the frontend has already requested this struct se_cmd to
 	 * be stopped, we can safely ignore this struct se_cmd.
 	 */
-	spin_lock_irqsave(&T_TASK(cmd)->t_state_lock, flags);
-	if (atomic_read(&T_TASK(cmd)->t_transport_stop)) {
-		atomic_set(&T_TASK(cmd)->transport_lun_stop, 0);
+	spin_lock_irqsave(&cmd->t_task->t_state_lock, flags);
+	if (atomic_read(&cmd->t_task->t_transport_stop)) {
+		atomic_set(&cmd->t_task->transport_lun_stop, 0);
 		DEBUG_TRANSPORT_S("ConfigFS ITT[0x%08x] - t_transport_stop =="
-			" TRUE, skipping\n", CMD_TFO(cmd)->get_task_tag(cmd));
-		spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
+			" TRUE, skipping\n", cmd->se_tfo->get_task_tag(cmd));
+		spin_unlock_irqrestore(&cmd->t_task->t_state_lock, flags);
 		transport_cmd_check_stop(cmd, 1, 0);
 		return -EPERM;
 	}
-	atomic_set(&T_TASK(cmd)->transport_lun_fe_stop, 1);
-	spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
+	atomic_set(&cmd->t_task->transport_lun_fe_stop, 1);
+	spin_unlock_irqrestore(&cmd->t_task->t_state_lock, flags);
 
-	wake_up_interruptible(&SE_DEV(cmd)->dev_queue_obj.thread_wq);
+	wake_up_interruptible(&cmd->se_lun->lun_se_dev->dev_queue_obj.thread_wq);
 
 	ret = transport_stop_tasks_for_cmd(cmd);
 
 	DEBUG_TRANSPORT_S("ConfigFS: cmd: %p t_task_cdbs: %d stop tasks ret:"
-			" %d\n", cmd, T_TASK(cmd)->t_task_cdbs, ret);
+			" %d\n", cmd, cmd->t_task->t_task_cdbs, ret);
 	if (!ret) {
 		DEBUG_TRANSPORT_S("ConfigFS: ITT[0x%08x] - stopping cmd....\n",
-				CMD_TFO(cmd)->get_task_tag(cmd));
-		wait_for_completion(&T_TASK(cmd)->transport_lun_stop_comp);
+				cmd->se_tfo->get_task_tag(cmd));
+		wait_for_completion(&cmd->t_task->transport_lun_stop_comp);
 		DEBUG_TRANSPORT_S("ConfigFS: ITT[0x%08x] - stopped cmd....\n",
-				CMD_TFO(cmd)->get_task_tag(cmd));
+				cmd->se_tfo->get_task_tag(cmd));
 	}
-	transport_remove_cmd_from_queue(cmd, &SE_DEV(cmd)->dev_queue_obj);
+	transport_remove_cmd_from_queue(cmd, &cmd->se_lun->lun_se_dev->dev_queue_obj);
 
 	return 0;
 }
@@ -5288,33 +5288,33 @@ static void __transport_clear_lun_from_sessions(struct se_lun *lun)
 			struct se_cmd, se_lun_list);
 		list_del(&cmd->se_lun_list);
 
-		if (!(T_TASK(cmd))) {
-			printk(KERN_ERR "ITT: 0x%08x, T_TASK(cmd) = NULL"
+		if (!(cmd->t_task)) {
+			printk(KERN_ERR "ITT: 0x%08x, cmd->t_task = NULL"
 				"[i,t]_state: %u/%u\n",
-				CMD_TFO(cmd)->get_task_tag(cmd),
-				CMD_TFO(cmd)->get_cmd_state(cmd), cmd->t_state);
+				cmd->se_tfo->get_task_tag(cmd),
+				cmd->se_tfo->get_cmd_state(cmd), cmd->t_state);
 			BUG();
 		}
-		atomic_set(&T_TASK(cmd)->transport_lun_active, 0);
+		atomic_set(&cmd->t_task->transport_lun_active, 0);
 		/*
 		 * This will notify iscsi_target_transport.c:
 		 * transport_cmd_check_stop() that a LUN shutdown is in
 		 * progress for the iscsi_cmd_t.
 		 */
-		spin_lock(&T_TASK(cmd)->t_state_lock);
-		DEBUG_CLEAR_L("SE_LUN[%d] - Setting T_TASK(cmd)->transport"
+		spin_lock(&cmd->t_task->t_state_lock);
+		DEBUG_CLEAR_L("SE_LUN[%d] - Setting cmd->t_task->transport"
 			"_lun_stop for  ITT: 0x%08x\n",
-			SE_LUN(cmd)->unpacked_lun,
-			CMD_TFO(cmd)->get_task_tag(cmd));
-		atomic_set(&T_TASK(cmd)->transport_lun_stop, 1);
-		spin_unlock(&T_TASK(cmd)->t_state_lock);
+			cmd->se_lun->unpacked_lun,
+			cmd->se_tfo->get_task_tag(cmd));
+		atomic_set(&cmd->t_task->transport_lun_stop, 1);
+		spin_unlock(&cmd->t_task->t_state_lock);
 
 		spin_unlock_irqrestore(&lun->lun_cmd_lock, lun_flags);
 
-		if (!(SE_LUN(cmd))) {
+		if (!(cmd->se_lun)) {
 			printk(KERN_ERR "ITT: 0x%08x, [i,t]_state: %u/%u\n",
-				CMD_TFO(cmd)->get_task_tag(cmd),
-				CMD_TFO(cmd)->get_cmd_state(cmd), cmd->t_state);
+				cmd->se_tfo->get_task_tag(cmd),
+				cmd->se_tfo->get_cmd_state(cmd), cmd->t_state);
 			BUG();
 		}
 		/*
@@ -5322,27 +5322,27 @@ static void __transport_clear_lun_from_sessions(struct se_lun *lun)
 		 * and/or stop its context.
 		 */
 		DEBUG_CLEAR_L("SE_LUN[%d] - ITT: 0x%08x before transport"
-			"_lun_wait_for_tasks()\n", SE_LUN(cmd)->unpacked_lun,
-			CMD_TFO(cmd)->get_task_tag(cmd));
+			"_lun_wait_for_tasks()\n", cmd->se_lun->unpacked_lun,
+			cmd->se_tfo->get_task_tag(cmd));
 
-		if (transport_lun_wait_for_tasks(cmd, SE_LUN(cmd)) < 0) {
+		if (transport_lun_wait_for_tasks(cmd, cmd->se_lun) < 0) {
 			spin_lock_irqsave(&lun->lun_cmd_lock, lun_flags);
 			continue;
 		}
 
 		DEBUG_CLEAR_L("SE_LUN[%d] - ITT: 0x%08x after transport_lun"
 			"_wait_for_tasks(): SUCCESS\n",
-			SE_LUN(cmd)->unpacked_lun,
-			CMD_TFO(cmd)->get_task_tag(cmd));
+			cmd->se_lun->unpacked_lun,
+			cmd->se_tfo->get_task_tag(cmd));
 
-		spin_lock_irqsave(&T_TASK(cmd)->t_state_lock, cmd_flags);
-		if (!(atomic_read(&T_TASK(cmd)->transport_dev_active))) {
-			spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, cmd_flags);
+		spin_lock_irqsave(&cmd->t_task->t_state_lock, cmd_flags);
+		if (!(atomic_read(&cmd->t_task->transport_dev_active))) {
+			spin_unlock_irqrestore(&cmd->t_task->t_state_lock, cmd_flags);
 			goto check_cond;
 		}
-		atomic_set(&T_TASK(cmd)->transport_dev_active, 0);
+		atomic_set(&cmd->t_task->transport_dev_active, 0);
 		transport_all_task_dev_remove_state(cmd);
-		spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, cmd_flags);
+		spin_unlock_irqrestore(&cmd->t_task->t_state_lock, cmd_flags);
 
 		transport_free_dev_tasks(cmd);
 		/*
@@ -5359,24 +5359,24 @@ check_cond:
 		 * be released, notify the waiting thread now that LU has
 		 * finished accessing it.
 		 */
-		spin_lock_irqsave(&T_TASK(cmd)->t_state_lock, cmd_flags);
-		if (atomic_read(&T_TASK(cmd)->transport_lun_fe_stop)) {
+		spin_lock_irqsave(&cmd->t_task->t_state_lock, cmd_flags);
+		if (atomic_read(&cmd->t_task->transport_lun_fe_stop)) {
 			DEBUG_CLEAR_L("SE_LUN[%d] - Detected FE stop for"
 				" struct se_cmd: %p ITT: 0x%08x\n",
 				lun->unpacked_lun,
-				cmd, CMD_TFO(cmd)->get_task_tag(cmd));
+				cmd, cmd->se_tfo->get_task_tag(cmd));
 
-			spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock,
+			spin_unlock_irqrestore(&cmd->t_task->t_state_lock,
 					cmd_flags);
 			transport_cmd_check_stop(cmd, 1, 0);
-			complete(&T_TASK(cmd)->transport_lun_fe_stop_comp);
+			complete(&cmd->t_task->transport_lun_fe_stop_comp);
 			spin_lock_irqsave(&lun->lun_cmd_lock, lun_flags);
 			continue;
 		}
 		DEBUG_CLEAR_L("SE_LUN[%d] - ITT: 0x%08x finished processing\n",
-			lun->unpacked_lun, CMD_TFO(cmd)->get_task_tag(cmd));
+			lun->unpacked_lun, cmd->se_tfo->get_task_tag(cmd));
 
-		spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, cmd_flags);
+		spin_unlock_irqrestore(&cmd->t_task->t_state_lock, cmd_flags);
 		spin_lock_irqsave(&lun->lun_cmd_lock, lun_flags);
 	}
 	spin_unlock_irqrestore(&lun->lun_cmd_lock, lun_flags);
@@ -5422,20 +5422,20 @@ static void transport_generic_wait_for_tasks(
 	if (!(cmd->se_cmd_flags & SCF_SE_LUN_CMD) && !(cmd->se_tmr_req))
 		return;
 
-	spin_lock_irqsave(&T_TASK(cmd)->t_state_lock, flags);
+	spin_lock_irqsave(&cmd->t_task->t_state_lock, flags);
 	/*
 	 * If we are already stopped due to an external event (ie: LUN shutdown)
 	 * sleep until the connection can have the passed struct se_cmd back.
-	 * The T_TASK(cmd)->transport_lun_stopped_sem will be upped by
+	 * The cmd->t_task->transport_lun_stopped_sem will be upped by
 	 * transport_clear_lun_from_sessions() once the ConfigFS context caller
 	 * has completed its operation on the struct se_cmd.
 	 */
-	if (atomic_read(&T_TASK(cmd)->transport_lun_stop)) {
+	if (atomic_read(&cmd->t_task->transport_lun_stop)) {
 
 		DEBUG_TRANSPORT_S("wait_for_tasks: Stopping"
-			" wait_for_completion(&T_TASK(cmd)transport_lun_fe"
+			" wait_for_completion(&cmd->t_tasktransport_lun_fe"
 			"_stop_comp); for ITT: 0x%08x\n",
-			CMD_TFO(cmd)->get_task_tag(cmd));
+			cmd->se_tfo->get_task_tag(cmd));
 		/*
 		 * There is a special case for WRITES where a FE exception +
 		 * LUN shutdown means ConfigFS context is still sleeping on
@@ -5443,10 +5443,10 @@ static void transport_generic_wait_for_tasks(
 		 * We go ahead and up transport_lun_stop_comp just to be sure
 		 * here.
 		 */
-		spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
-		complete(&T_TASK(cmd)->transport_lun_stop_comp);
-		wait_for_completion(&T_TASK(cmd)->transport_lun_fe_stop_comp);
-		spin_lock_irqsave(&T_TASK(cmd)->t_state_lock, flags);
+		spin_unlock_irqrestore(&cmd->t_task->t_state_lock, flags);
+		complete(&cmd->t_task->transport_lun_stop_comp);
+		wait_for_completion(&cmd->t_task->transport_lun_fe_stop_comp);
+		spin_lock_irqsave(&cmd->t_task->t_state_lock, flags);
 
 		transport_all_task_dev_remove_state(cmd);
 		/*
@@ -5455,39 +5455,39 @@ static void transport_generic_wait_for_tasks(
 		 * normal means below.
 		 */
 		DEBUG_TRANSPORT_S("wait_for_tasks: Stopped"
-			" wait_for_completion(&T_TASK(cmd)transport_lun_fe_"
+			" wait_for_completion(&cmd->t_tasktransport_lun_fe_"
 			"stop_comp); for ITT: 0x%08x\n",
-			CMD_TFO(cmd)->get_task_tag(cmd));
+			cmd->se_tfo->get_task_tag(cmd));
 
-		atomic_set(&T_TASK(cmd)->transport_lun_stop, 0);
+		atomic_set(&cmd->t_task->transport_lun_stop, 0);
 	}
-	if (!atomic_read(&T_TASK(cmd)->t_transport_active) ||
-	     atomic_read(&T_TASK(cmd)->t_transport_aborted))
+	if (!atomic_read(&cmd->t_task->t_transport_active) ||
+	     atomic_read(&cmd->t_task->t_transport_aborted))
 		goto remove;
 
-	atomic_set(&T_TASK(cmd)->t_transport_stop, 1);
+	atomic_set(&cmd->t_task->t_transport_stop, 1);
 
 	DEBUG_TRANSPORT_S("wait_for_tasks: Stopping %p ITT: 0x%08x"
 		" i_state: %d, t_state/def_t_state: %d/%d, t_transport_stop"
-		" = TRUE\n", cmd, CMD_TFO(cmd)->get_task_tag(cmd),
-		CMD_TFO(cmd)->get_cmd_state(cmd), cmd->t_state,
+		" = TRUE\n", cmd, cmd->se_tfo->get_task_tag(cmd),
+		cmd->se_tfo->get_cmd_state(cmd), cmd->t_state,
 		cmd->deferred_t_state);
 
-	spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
+	spin_unlock_irqrestore(&cmd->t_task->t_state_lock, flags);
 
-	wake_up_interruptible(&SE_DEV(cmd)->dev_queue_obj.thread_wq);
+	wake_up_interruptible(&cmd->se_lun->lun_se_dev->dev_queue_obj.thread_wq);
 
-	wait_for_completion(&T_TASK(cmd)->t_transport_stop_comp);
+	wait_for_completion(&cmd->t_task->t_transport_stop_comp);
 
-	spin_lock_irqsave(&T_TASK(cmd)->t_state_lock, flags);
-	atomic_set(&T_TASK(cmd)->t_transport_active, 0);
-	atomic_set(&T_TASK(cmd)->t_transport_stop, 0);
+	spin_lock_irqsave(&cmd->t_task->t_state_lock, flags);
+	atomic_set(&cmd->t_task->t_transport_active, 0);
+	atomic_set(&cmd->t_task->t_transport_stop, 0);
 
 	DEBUG_TRANSPORT_S("wait_for_tasks: Stopped wait_for_compltion("
-		"&T_TASK(cmd)->t_transport_stop_comp) for ITT: 0x%08x\n",
-		CMD_TFO(cmd)->get_task_tag(cmd));
+		"&cmd->t_task->t_transport_stop_comp) for ITT: 0x%08x\n",
+		cmd->se_tfo->get_task_tag(cmd));
 remove:
-	spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
+	spin_unlock_irqrestore(&cmd->t_task->t_state_lock, flags);
 	if (!remove_cmd)
 		return;
 
@@ -5526,13 +5526,13 @@ int transport_send_check_condition_and_sense(
 	int offset;
 	u8 asc = 0, ascq = 0;
 
-	spin_lock_irqsave(&T_TASK(cmd)->t_state_lock, flags);
+	spin_lock_irqsave(&cmd->t_task->t_state_lock, flags);
 	if (cmd->se_cmd_flags & SCF_SENT_CHECK_CONDITION) {
-		spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
+		spin_unlock_irqrestore(&cmd->t_task->t_state_lock, flags);
 		return 0;
 	}
 	cmd->se_cmd_flags |= SCF_SENT_CHECK_CONDITION;
-	spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
+	spin_unlock_irqrestore(&cmd->t_task->t_state_lock, flags);
 
 	if (!reason && from_transport)
 		goto after_reason;
@@ -5545,7 +5545,7 @@ int transport_send_check_condition_and_sense(
 	 * TRANSPORT_SENSE_BUFFER is now set to SCSI_SENSE_BUFFERSIZE
 	 * from include/scsi/scsi_cmnd.h
 	 */
-	offset = CMD_TFO(cmd)->set_fabric_sense_len(cmd,
+	offset = cmd->se_tfo->set_fabric_sense_len(cmd,
 				TRANSPORT_SENSE_BUFFER);
 	/*
 	 * Actual SENSE DATA, see SPC-3 7.23.2  SPC_SENSE_KEY_OFFSET uses
@@ -5682,7 +5682,7 @@ int transport_send_check_condition_and_sense(
 	cmd->scsi_sense_length  = TRANSPORT_SENSE_BUFFER + offset;
 
 after_reason:
-	CMD_TFO(cmd)->queue_status(cmd);
+	cmd->se_tfo->queue_status(cmd);
 	return 0;
 }
 EXPORT_SYMBOL(transport_send_check_condition_and_sense);
@@ -5691,18 +5691,18 @@ int transport_check_aborted_status(struct se_cmd *cmd, int send_status)
 {
 	int ret = 0;
 
-	if (atomic_read(&T_TASK(cmd)->t_transport_aborted) != 0) {
+	if (atomic_read(&cmd->t_task->t_transport_aborted) != 0) {
 		if (!(send_status) ||
 		     (cmd->se_cmd_flags & SCF_SENT_DELAYED_TAS))
 			return 1;
 #if 0
 		printk(KERN_INFO "Sending delayed SAM_STAT_TASK_ABORTED"
 			" status for CDB: 0x%02x ITT: 0x%08x\n",
-			T_TASK(cmd)->t_task_cdb[0],
-			CMD_TFO(cmd)->get_task_tag(cmd));
+			cmd->t_task->t_task_cdb[0],
+			cmd->se_tfo->get_task_tag(cmd));
 #endif
 		cmd->se_cmd_flags |= SCF_SENT_DELAYED_TAS;
-		CMD_TFO(cmd)->queue_status(cmd);
+		cmd->se_tfo->queue_status(cmd);
 		ret = 1;
 	}
 	return ret;
@@ -5718,8 +5718,8 @@ void transport_send_task_abort(struct se_cmd *cmd)
 	 * queued back to fabric module by transport_check_aborted_status().
 	 */
 	if (cmd->data_direction == DMA_TO_DEVICE) {
-		if (CMD_TFO(cmd)->write_pending_status(cmd) != 0) {
-			atomic_inc(&T_TASK(cmd)->t_transport_aborted);
+		if (cmd->se_tfo->write_pending_status(cmd) != 0) {
+			atomic_inc(&cmd->t_task->t_transport_aborted);
 			smp_mb__after_atomic_inc();
 			cmd->scsi_status = SAM_STAT_TASK_ABORTED;
 			transport_new_cmd_failure(cmd);
@@ -5729,10 +5729,10 @@ void transport_send_task_abort(struct se_cmd *cmd)
 	cmd->scsi_status = SAM_STAT_TASK_ABORTED;
 #if 0
 	printk(KERN_INFO "Setting SAM_STAT_TASK_ABORTED status for CDB: 0x%02x,"
-		" ITT: 0x%08x\n", T_TASK(cmd)->t_task_cdb[0],
-		CMD_TFO(cmd)->get_task_tag(cmd));
+		" ITT: 0x%08x\n", cmd->t_task->t_task_cdb[0],
+		cmd->se_tfo->get_task_tag(cmd));
 #endif
-	CMD_TFO(cmd)->queue_status(cmd);
+	cmd->se_tfo->queue_status(cmd);
 }
 
 /*	transport_generic_do_tmr():
@@ -5742,7 +5742,7 @@ void transport_send_task_abort(struct se_cmd *cmd)
 int transport_generic_do_tmr(struct se_cmd *cmd)
 {
 	struct se_cmd *ref_cmd;
-	struct se_device *dev = SE_DEV(cmd);
+	struct se_device *dev = cmd->se_lun->lun_se_dev;
 	struct se_tmr_req *tmr = cmd->se_tmr_req;
 	int ret;
 
@@ -5775,7 +5775,7 @@ int transport_generic_do_tmr(struct se_cmd *cmd)
 	}
 
 	cmd->t_state = TRANSPORT_ISTATE_PROCESSING;
-	CMD_TFO(cmd)->queue_tm_rsp(cmd);
+	cmd->se_tfo->queue_tm_rsp(cmd);
 
 	transport_cmd_check_stop(cmd, 2, 0);
 	return 0;
@@ -5814,44 +5814,44 @@ static void transport_processing_shutdown(struct se_device *dev)
 	 */
 	spin_lock_irqsave(&dev->execute_task_lock, flags);
 	while ((task = transport_get_task_from_state_list(dev))) {
-		if (!(TASK_CMD(task))) {
-			printk(KERN_ERR "TASK_CMD(task) is NULL!\n");
+		if (!task->task_se_cmd) {
+			printk(KERN_ERR "task->task_se_cmd is NULL!\n");
 			continue;
 		}
-		cmd = TASK_CMD(task);
+		cmd = task->task_se_cmd;
 
-		if (!T_TASK(cmd)) {
-			printk(KERN_ERR "T_TASK(cmd) is NULL for task: %p cmd:"
+		if (!cmd->t_task) {
+			printk(KERN_ERR "cmd->t_task is NULL for task: %p cmd:"
 				" %p ITT: 0x%08x\n", task, cmd,
-				CMD_TFO(cmd)->get_task_tag(cmd));
+				cmd->se_tfo->get_task_tag(cmd));
 			continue;
 		}
 		spin_unlock_irqrestore(&dev->execute_task_lock, flags);
 
-		spin_lock_irqsave(&T_TASK(cmd)->t_state_lock, flags);
+		spin_lock_irqsave(&cmd->t_task->t_state_lock, flags);
 
 		DEBUG_DO("PT: cmd: %p task: %p ITT/CmdSN: 0x%08x/0x%08x,"
 			" i_state/def_i_state: %d/%d, t_state/def_t_state:"
 			" %d/%d cdb: 0x%02x\n", cmd, task,
-			CMD_TFO(cmd)->get_task_tag(cmd), cmd->cmd_sn,
-			CMD_TFO(cmd)->get_cmd_state(cmd), cmd->deferred_i_state,
+			cmd->se_tfo->get_task_tag(cmd), cmd->cmd_sn,
+			cmd->se_tfo->get_cmd_state(cmd), cmd->deferred_i_state,
 			cmd->t_state, cmd->deferred_t_state,
-			T_TASK(cmd)->t_task_cdb[0]);
+			cmd->t_task->t_task_cdb[0]);
 		DEBUG_DO("PT: ITT[0x%08x] - t_task_cdbs: %d t_task_cdbs_left:"
 			" %d t_task_cdbs_sent: %d -- t_transport_active: %d"
 			" t_transport_stop: %d t_transport_sent: %d\n",
-			CMD_TFO(cmd)->get_task_tag(cmd),
-			T_TASK(cmd)->t_task_cdbs,
-			atomic_read(&T_TASK(cmd)->t_task_cdbs_left),
-			atomic_read(&T_TASK(cmd)->t_task_cdbs_sent),
-			atomic_read(&T_TASK(cmd)->t_transport_active),
-			atomic_read(&T_TASK(cmd)->t_transport_stop),
-			atomic_read(&T_TASK(cmd)->t_transport_sent));
+			cmd->se_tfo->get_task_tag(cmd),
+			cmd->t_task->t_task_cdbs,
+			atomic_read(&cmd->t_task->t_task_cdbs_left),
+			atomic_read(&cmd->t_task->t_task_cdbs_sent),
+			atomic_read(&cmd->t_task->t_transport_active),
+			atomic_read(&cmd->t_task->t_transport_stop),
+			atomic_read(&cmd->t_task->t_transport_sent));
 
 		if (atomic_read(&task->task_active)) {
 			atomic_set(&task->task_stop, 1);
 			spin_unlock_irqrestore(
-				&T_TASK(cmd)->t_state_lock, flags);
+				&cmd->t_task->t_state_lock, flags);
 
 			DEBUG_DO("Waiting for task: %p to shutdown for dev:"
 				" %p\n", task, dev);
@@ -5859,8 +5859,8 @@ static void transport_processing_shutdown(struct se_device *dev)
 			DEBUG_DO("Completed task: %p shutdown for dev: %p\n",
 				task, dev);
 
-			spin_lock_irqsave(&T_TASK(cmd)->t_state_lock, flags);
-			atomic_dec(&T_TASK(cmd)->t_task_cdbs_left);
+			spin_lock_irqsave(&cmd->t_task->t_state_lock, flags);
+			atomic_dec(&cmd->t_task->t_task_cdbs_left);
 
 			atomic_set(&task->task_active, 0);
 			atomic_set(&task->task_stop, 0);
@@ -5870,39 +5870,39 @@ static void transport_processing_shutdown(struct se_device *dev)
 		}
 		__transport_stop_task_timer(task, &flags);
 
-		if (!(atomic_dec_and_test(&T_TASK(cmd)->t_task_cdbs_ex_left))) {
+		if (!(atomic_dec_and_test(&cmd->t_task->t_task_cdbs_ex_left))) {
 			spin_unlock_irqrestore(
-					&T_TASK(cmd)->t_state_lock, flags);
+					&cmd->t_task->t_state_lock, flags);
 
 			DEBUG_DO("Skipping task: %p, dev: %p for"
 				" t_task_cdbs_ex_left: %d\n", task, dev,
-				atomic_read(&T_TASK(cmd)->t_task_cdbs_ex_left));
+				atomic_read(&cmd->t_task->t_task_cdbs_ex_left));
 
 			spin_lock_irqsave(&dev->execute_task_lock, flags);
 			continue;
 		}
 
-		if (atomic_read(&T_TASK(cmd)->t_transport_active)) {
+		if (atomic_read(&cmd->t_task->t_transport_active)) {
 			DEBUG_DO("got t_transport_active = 1 for task: %p, dev:"
 					" %p\n", task, dev);
 
-			if (atomic_read(&T_TASK(cmd)->t_fe_count)) {
+			if (atomic_read(&cmd->t_task->t_fe_count)) {
 				spin_unlock_irqrestore(
-					&T_TASK(cmd)->t_state_lock, flags);
+					&cmd->t_task->t_state_lock, flags);
 				transport_send_check_condition_and_sense(
 					cmd, TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE,
 					0);
 				transport_remove_cmd_from_queue(cmd,
-					&SE_DEV(cmd)->dev_queue_obj);
+					&cmd->se_lun->lun_se_dev->dev_queue_obj);
 
 				transport_lun_remove_cmd(cmd);
 				transport_cmd_check_stop(cmd, 1, 0);
 			} else {
 				spin_unlock_irqrestore(
-					&T_TASK(cmd)->t_state_lock, flags);
+					&cmd->t_task->t_state_lock, flags);
 
 				transport_remove_cmd_from_queue(cmd,
-					&SE_DEV(cmd)->dev_queue_obj);
+					&cmd->se_lun->lun_se_dev->dev_queue_obj);
 
 				transport_lun_remove_cmd(cmd);
 
@@ -5916,22 +5916,22 @@ static void transport_processing_shutdown(struct se_device *dev)
 		DEBUG_DO("Got t_transport_active = 0 for task: %p, dev: %p\n",
 				task, dev);
 
-		if (atomic_read(&T_TASK(cmd)->t_fe_count)) {
+		if (atomic_read(&cmd->t_task->t_fe_count)) {
 			spin_unlock_irqrestore(
-				&T_TASK(cmd)->t_state_lock, flags);
+				&cmd->t_task->t_state_lock, flags);
 			transport_send_check_condition_and_sense(cmd,
 				TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE, 0);
 			transport_remove_cmd_from_queue(cmd,
-				&SE_DEV(cmd)->dev_queue_obj);
+				&cmd->se_lun->lun_se_dev->dev_queue_obj);
 
 			transport_lun_remove_cmd(cmd);
 			transport_cmd_check_stop(cmd, 1, 0);
 		} else {
 			spin_unlock_irqrestore(
-				&T_TASK(cmd)->t_state_lock, flags);
+				&cmd->t_task->t_state_lock, flags);
 
 			transport_remove_cmd_from_queue(cmd,
-				&SE_DEV(cmd)->dev_queue_obj);
+				&cmd->se_lun->lun_se_dev->dev_queue_obj);
 			transport_lun_remove_cmd(cmd);
 
 			if (transport_cmd_check_stop(cmd, 1, 0))
@@ -5952,7 +5952,7 @@ static void transport_processing_shutdown(struct se_device *dev)
 		DEBUG_DO("From Device Queue: cmd: %p t_state: %d\n",
 				cmd, state);
 
-		if (atomic_read(&T_TASK(cmd)->t_fe_count)) {
+		if (atomic_read(&cmd->t_task->t_fe_count)) {
 			transport_send_check_condition_and_sense(cmd,
 				TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE, 0);
 
@@ -6007,12 +6007,12 @@ get_cmd:
 
 		switch (t_state) {
 		case TRANSPORT_NEW_CMD_MAP:
-			if (!(CMD_TFO(cmd)->new_cmd_map)) {
-				printk(KERN_ERR "CMD_TFO(cmd)->new_cmd_map is"
+			if (!(cmd->se_tfo->new_cmd_map)) {
+				printk(KERN_ERR "cmd->se_tfo->new_cmd_map is"
 					" NULL for TRANSPORT_NEW_CMD_MAP\n");
 				BUG();
 			}
-			ret = CMD_TFO(cmd)->new_cmd_map(cmd);
+			ret = cmd->se_tfo->new_cmd_map(cmd);
 			if (ret < 0) {
 				cmd->transport_error_status = ret;
 				transport_generic_request_failure(cmd, NULL,
@@ -6057,9 +6057,9 @@ get_cmd:
 			printk(KERN_ERR "Unknown t_state: %d deferred_t_state:"
 				" %d for ITT: 0x%08x i_state: %d on SE LUN:"
 				" %u\n", t_state, cmd->deferred_t_state,
-				CMD_TFO(cmd)->get_task_tag(cmd),
-				CMD_TFO(cmd)->get_cmd_state(cmd),
-				SE_LUN(cmd)->unpacked_lun);
+				cmd->se_tfo->get_task_tag(cmd),
+				cmd->se_tfo->get_cmd_state(cmd),
+				cmd->se_lun->unpacked_lun);
 			BUG();
 		}
 
diff --git a/drivers/target/target_core_ua.c b/drivers/target/target_core_ua.c
index 4f754ca..16f41d1 100644
--- a/drivers/target/target_core_ua.c
+++ b/drivers/target/target_core_ua.c
@@ -179,7 +179,7 @@ int core_scsi3_ua_allocate(
 
 	printk(KERN_INFO "[%s]: Allocated UNIT ATTENTION, mapped LUN: %u, ASC:"
 		" 0x%02x, ASCQ: 0x%02x\n",
-		TPG_TFO(nacl->se_tpg)->get_fabric_name(), unpacked_lun,
+		nacl->se_tpg->se_tpg_tfo->get_fabric_name(), unpacked_lun,
 		asc, ascq);
 
 	atomic_inc(&deve->ua_count);
@@ -208,7 +208,7 @@ void core_scsi3_ua_for_check_condition(
 	u8 *asc,
 	u8 *ascq)
 {
-	struct se_device *dev = SE_DEV(cmd);
+	struct se_device *dev = cmd->se_lun->lun_se_dev;
 	struct se_dev_entry *deve;
 	struct se_session *sess = cmd->se_sess;
 	struct se_node_acl *nacl;
@@ -240,7 +240,7 @@ void core_scsi3_ua_for_check_condition(
 		 * highest priority UNIT_ATTENTION and ASC/ASCQ without
 		 * clearing it.
 		 */
-		if (DEV_ATTRIB(dev)->emulate_ua_intlck_ctrl != 0) {
+		if (dev->se_sub_dev->se_dev_attrib.emulate_ua_intlck_ctrl != 0) {
 			*asc = ua->ua_asc;
 			*ascq = ua->ua_ascq;
 			break;
@@ -267,10 +267,10 @@ void core_scsi3_ua_for_check_condition(
 	printk(KERN_INFO "[%s]: %s UNIT ATTENTION condition with"
 		" INTLCK_CTRL: %d, mapped LUN: %u, got CDB: 0x%02x"
 		" reported ASC: 0x%02x, ASCQ: 0x%02x\n",
-		TPG_TFO(nacl->se_tpg)->get_fabric_name(),
-		(DEV_ATTRIB(dev)->emulate_ua_intlck_ctrl != 0) ? "Reporting" :
-		"Releasing", DEV_ATTRIB(dev)->emulate_ua_intlck_ctrl,
-		cmd->orig_fe_lun, T_TASK(cmd)->t_task_cdb[0], *asc, *ascq);
+		nacl->se_tpg->se_tpg_tfo->get_fabric_name(),
+		(dev->se_sub_dev->se_dev_attrib.emulate_ua_intlck_ctrl != 0) ? "Reporting" :
+		"Releasing", dev->se_sub_dev->se_dev_attrib.emulate_ua_intlck_ctrl,
+		cmd->orig_fe_lun, cmd->t_task->t_task_cdb[0], *asc, *ascq);
 }
 
 int core_scsi3_ua_clear_for_request_sense(
@@ -325,7 +325,7 @@ int core_scsi3_ua_clear_for_request_sense(
 
 	printk(KERN_INFO "[%s]: Released UNIT ATTENTION condition, mapped"
 		" LUN: %u, got REQUEST_SENSE reported ASC: 0x%02x,"
-		" ASCQ: 0x%02x\n", TPG_TFO(nacl->se_tpg)->get_fabric_name(),
+		" ASCQ: 0x%02x\n", nacl->se_tpg->se_tpg_tfo->get_fabric_name(),
 		cmd->orig_fe_lun, *asc, *ascq);
 
 	return (head) ? -EPERM : 0;
diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index 5823ccf..19b2b99 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -72,7 +72,7 @@ void ft_dump_cmd(struct ft_cmd *cmd, const char *caller)
 		caller, cmd, cmd->cdb);
 	printk(KERN_INFO "%s: cmd %p lun %d\n", caller, cmd, cmd->lun);
 
-	task = T_TASK(se_cmd);
+	task = se_cmd->t_task;
 	printk(KERN_INFO "%s: cmd %p task %p se_num %u buf %p len %u se_cmd_flags <0x%x>\n",
 	       caller, cmd, task, task->t_tasks_se_num,
 	       task->t_task_buf, se_cmd->data_length, se_cmd->se_cmd_flags);
@@ -262,9 +262,9 @@ int ft_write_pending(struct se_cmd *se_cmd)
 				 * TCM/LIO target
 				 */
 				transport_do_task_sg_chain(se_cmd);
-				cmd->sg = T_TASK(se_cmd)->t_tasks_sg_chained;
+				cmd->sg = se_cmd->t_task->t_tasks_sg_chained;
 				cmd->sg_cnt =
-					T_TASK(se_cmd)->t_tasks_sg_chained_no;
+					se_cmd->t_task->t_tasks_sg_chained_no;
 			}
 			if (cmd->sg && lport->tt.ddp_setup(lport, ep->xid,
 						    cmd->sg, cmd->sg_cnt))
diff --git a/drivers/target/tcm_fc/tfc_io.c b/drivers/target/tcm_fc/tfc_io.c
index 8c4a240..47efcfb 100644
--- a/drivers/target/tcm_fc/tfc_io.c
+++ b/drivers/target/tcm_fc/tfc_io.c
@@ -90,7 +90,7 @@ int ft_queue_data_in(struct se_cmd *se_cmd)
 	lport = ep->lp;
 	cmd->seq = lport->tt.seq_start_next(cmd->seq);
 
-	task = T_TASK(se_cmd);
+	task = se_cmd->t_task;
 	BUG_ON(!task);
 	remaining = se_cmd->data_length;
 
@@ -236,7 +236,7 @@ void ft_recv_write_data(struct ft_cmd *cmd, struct fc_frame *fp)
 	u32 f_ctl;
 	void *buf;
 
-	task = T_TASK(se_cmd);
+	task = se_cmd->t_task;
 	BUG_ON(!task);
 
 	fh = fc_frame_header_get(fp);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 2b989b3..b0b83ed 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -286,10 +286,10 @@ struct t10_vpd {
 } ____cacheline_aligned;
 
 struct t10_wwn {
-	unsigned char vendor[8];
-	unsigned char model[16];
-	unsigned char revision[4];
-	unsigned char unit_serial[INQUIRY_VPD_SERIAL_LEN];
+	char vendor[8];
+	char model[16];
+	char revision[4];
+	char unit_serial[INQUIRY_VPD_SERIAL_LEN];
 	spinlock_t t10_vpd_lock;
 	struct se_subsystem_dev *t10_sub_dev;
 	struct config_group t10_wwn_group;
@@ -490,9 +490,6 @@ struct se_task {
 	struct list_head t_state_list;
 } ____cacheline_aligned;
 
-#define TASK_CMD(task)	((task)->task_se_cmd)
-#define TASK_DEV(task)	((task)->se_dev)
-
 struct se_cmd {
 	/* SAM response code being sent to initiator */
 	u8			scsi_status;
@@ -547,9 +544,6 @@ struct se_cmd {
 	void (*transport_complete_callback)(struct se_cmd *);
 } ____cacheline_aligned;
 
-#define T_TASK(cmd)     ((cmd)->t_task)
-#define CMD_TFO(cmd)	((cmd)->se_tfo)
-
 struct se_tmr_req {
 	/* Task Management function to be preformed */
 	u8			function;
@@ -612,9 +606,6 @@ struct se_session {
 	struct list_head	sess_acl_list;
 } ____cacheline_aligned;
 
-#define SE_SESS(cmd)		((cmd)->se_sess)
-#define SE_NODE_ACL(sess)	((sess)->se_node_acl)
-
 struct se_device;
 struct se_transform_info;
 struct scatterlist;
@@ -635,8 +626,6 @@ struct se_lun_acl {
 	struct se_ml_stat_grps	ml_stat_grps;
 }  ____cacheline_aligned;
 
-#define ML_STAT_GRPS(lacl)	(&(lacl)->ml_stat_grps)
-
 struct se_dev_entry {
 	bool			def_pr_registered;
 	/* See transport_lunflags_table */
@@ -722,7 +711,7 @@ struct se_subsystem_dev {
 	/* T10 Inquiry and VPD WWN Information */
 	struct t10_wwn	t10_wwn;
 	/* T10 SPC-2 + SPC-3 Reservations */
-	struct t10_reservation t10_reservation;
+	struct t10_reservation t10_pr;
 	spinlock_t      se_dev_lock;
 	void            *se_dev_su_ptr;
 	struct list_head se_dev_node;
@@ -733,11 +722,6 @@ struct se_subsystem_dev {
 	struct se_dev_stat_grps dev_stat_grps;
 } ____cacheline_aligned;
 
-#define T10_ALUA(su_dev)	(&(su_dev)->t10_alua)
-#define T10_RES(su_dev)		(&(su_dev)->t10_reservation)
-#define T10_PR_OPS(su_dev)	(&(su_dev)->t10_reservation.pr_ops)
-#define DEV_STAT_GRP(dev)	(&(dev)->dev_stat_grps)
-
 struct se_device {
 	/* Set to 1 if thread is NOT sleeping on thread_sem */
 	u8			thread_active;
@@ -818,11 +802,6 @@ struct se_device {
 	struct list_head	g_se_dev_list;
 }  ____cacheline_aligned;
 
-#define SE_DEV(cmd)		((cmd)->se_lun->lun_se_dev)
-#define SU_DEV(dev)		((dev)->se_sub_dev)
-#define DEV_ATTRIB(dev)		(&(dev)->se_sub_dev->se_dev_attrib)
-#define DEV_T10_WWN(dev)	(&(dev)->se_sub_dev->t10_wwn)
-
 struct se_hba {
 	u16			hba_tpgt;
 	u32			hba_id;
@@ -842,8 +821,6 @@ struct se_hba {
 	struct se_subsystem_api *transport;
 }  ____cacheline_aligned;
 
-#define SE_HBA(dev)		((dev)->se_hba)
-
 struct se_port_stat_grps {
 	struct config_group stat_group;
 	struct config_group scsi_port_group;
@@ -870,9 +847,6 @@ struct se_lun {
 	struct se_port_stat_grps port_stat_grps;
 } ____cacheline_aligned;
 
-#define SE_LUN(cmd)		((cmd)->se_lun)
-#define PORT_STAT_GRP(lun)	(&(lun)->port_stat_grps)
-
 struct scsi_port_stats {
        u64     cmd_pdus;
        u64     tx_data_octets;
@@ -938,8 +912,6 @@ struct se_portal_group {
 	struct config_group	tpg_param_group;
 } ____cacheline_aligned;
 
-#define TPG_TFO(se_tpg)	((se_tpg)->se_tpg_tfo)
-
 struct se_wwn {
 	struct target_fabric_configfs *wwn_tf;
 	struct config_group	wwn_group;
diff --git a/include/target/target_core_transport.h b/include/target/target_core_transport.h
index da982e9..1dd4d18 100644
--- a/include/target/target_core_transport.h
+++ b/include/target/target_core_transport.h
@@ -351,7 +351,4 @@ struct se_subsystem_api {
 	unsigned char *(*get_sense_buffer)(struct se_task *);
 } ____cacheline_aligned;
 
-#define TRANSPORT(dev)		((dev)->transport)
-#define HBA_TRANSPORT(hba)	((hba)->transport)
-
 #endif /* TARGET_CORE_TRANSPORT_H */
-- 
1.7.6

