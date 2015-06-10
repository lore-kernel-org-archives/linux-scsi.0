From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/2] target: use 64-bit LUNs
Date: Wed, 10 Jun 2015 08:41:22 +0200
Message-ID: <1433918483-46849-2-git-send-email-hare@suse.de>
References: <1433918483-46849-1-git-send-email-hare@suse.de>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1433918483-46849-1-git-send-email-hare@suse.de>
Sender: target-devel-owner@vger.kernel.org
To: Nic Bellinger <nab@daterainc.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

As we're now using a list to hold the LUNs the target core
can now converted to use 64-bit LUNs internally.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/target/iscsi/iscsi_target_tmr.c      |  4 +--
 drivers/target/loopback/tcm_loop.c           |  4 +--
 drivers/target/target_core_alua.c            |  2 +-
 drivers/target/target_core_configfs.c        | 12 ++++----
 drivers/target/target_core_device.c          | 30 +++++++++----------
 drivers/target/target_core_fabric_configfs.c | 18 ++++--------
 drivers/target/target_core_internal.h        | 10 +++----
 drivers/target/target_core_pr.c              | 43 ++++++++++++++--------------
 drivers/target/target_core_pr.h              |  6 ++--
 drivers/target/target_core_tpg.c             |  6 ++--
 drivers/target/target_core_transport.c       |  6 ++--
 drivers/target/target_core_ua.c              |  8 +++---
 drivers/target/target_core_ua.h              |  2 +-
 include/target/target_core_base.h            | 19 ++++++------
 include/target/target_core_fabric.h          | 10 +++----
 15 files changed, 88 insertions(+), 92 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_tmr.c b/drivers/target/iscsi/iscsi_target_tmr.c
index b0224a7..5159882 100644
--- a/drivers/target/iscsi/iscsi_target_tmr.c
+++ b/drivers/target/iscsi/iscsi_target_tmr.c
@@ -120,7 +120,7 @@ u8 iscsit_tmr_task_reassign(
 	struct iscsi_tmr_req *tmr_req = cmd->tmr_req;
 	struct se_tmr_req *se_tmr = cmd->se_cmd.se_tmr_req;
 	struct iscsi_tm *hdr = (struct iscsi_tm *) buf;
-	int ret, ref_lun;
+	u64 ret, ref_lun;
 
 	pr_debug("Got TASK_REASSIGN TMR ITT: 0x%08x,"
 		" RefTaskTag: 0x%08x, ExpDataSN: 0x%08x, CID: %hu\n",
@@ -164,7 +164,7 @@ u8 iscsit_tmr_task_reassign(
 	ref_lun = scsilun_to_int(&hdr->lun);
 	if (ref_lun != ref_cmd->se_cmd.orig_fe_lun) {
 		pr_err("Unable to perform connection recovery for"
-			" differing ref_lun: %d ref_cmd orig_fe_lun: %u\n",
+			" differing ref_lun: %llu ref_cmd orig_fe_lun: %llu\n",
 			ref_lun, ref_cmd->se_cmd.orig_fe_lun);
 		return ISCSI_TMF_RSP_REJECTED;
 	}
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 562906a..a7bb0b0 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -215,7 +215,7 @@ static int tcm_loop_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)
  * to struct scsi_device
  */
 static int tcm_loop_issue_tmr(struct tcm_loop_tpg *tl_tpg,
-			      int lun, int task, enum tcm_tmreq_table tmr)
+			      u64 lun, int task, enum tcm_tmreq_table tmr)
 {
 	struct se_cmd *se_cmd = NULL;
 	struct se_session *se_sess;
@@ -747,7 +747,7 @@ static void tcm_loop_port_unlink(
 				se_lun->unpacked_lun);
 	if (!sd) {
 		pr_err("Unable to locate struct scsi_device for %d:%d:"
-			"%d\n", 0, tl_tpg->tl_tpgt, se_lun->unpacked_lun);
+			"%llu\n", 0, tl_tpg->tl_tpgt, se_lun->unpacked_lun);
 		return;
 	}
 	/*
diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 02d8e1a..2318e6e 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -1257,7 +1257,7 @@ static int core_alua_update_tpg_secondary_metadata(struct se_lun *lun)
 			atomic_read(&lun->lun_tg_pt_secondary_offline),
 			lun->lun_tg_pt_secondary_stat);
 
-	snprintf(path, ALUA_METADATA_PATH_LEN, "/var/target/alua/%s/%s/lun_%u",
+	snprintf(path, ALUA_METADATA_PATH_LEN, "/var/target/alua/%s/%s/lun_%llu",
 			se_tpg->se_tpg_tfo->get_fabric_name(), wwn,
 			lun->unpacked_lun);
 
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index f97b969..68addbc 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -1438,7 +1438,7 @@ static ssize_t target_core_dev_pr_show_attr_res_pr_holder_tg_port(
 		tfo->tpg_get_wwn(se_tpg));
 	len += sprintf(page+len, "SPC-3 Reservation: Relative Port"
 		" Identifier Tag: %hu %s Portal Group Tag: %hu"
-		" %s Logical Unit: %u\n", pr_reg->tg_pt_sep_rtpi,
+		" %s Logical Unit: %llu\n", pr_reg->tg_pt_sep_rtpi,
 		tfo->get_fabric_name(), tfo->tpg_get_tag(se_tpg),
 		tfo->get_fabric_name(), pr_reg->pr_aptpl_target_lun);
 
@@ -1565,12 +1565,12 @@ static match_table_t tokens = {
 	{Opt_res_type, "res_type=%d"},
 	{Opt_res_scope, "res_scope=%d"},
 	{Opt_res_all_tg_pt, "res_all_tg_pt=%d"},
-	{Opt_mapped_lun, "mapped_lun=%d"},
+	{Opt_mapped_lun, "mapped_lun=%lld"},
 	{Opt_target_fabric, "target_fabric=%s"},
 	{Opt_target_node, "target_node=%s"},
 	{Opt_tpgt, "tpgt=%d"},
 	{Opt_port_rtpi, "port_rtpi=%d"},
-	{Opt_target_lun, "target_lun=%d"},
+	{Opt_target_lun, "target_lun=%lld"},
 	{Opt_err, NULL}
 };
 
@@ -1585,7 +1585,7 @@ static ssize_t target_core_dev_pr_store_attr_res_aptpl_metadata(
 	substring_t args[MAX_OPT_ARGS];
 	unsigned long long tmp_ll;
 	u64 sa_res_key = 0;
-	u32 mapped_lun = 0, target_lun = 0;
+	u64 mapped_lun = 0, target_lun = 0;
 	int ret = -1, res_holder = 0, all_tg_pt = 0, arg, token;
 	u16 tpgt = 0;
 	u8 type = 0;
@@ -1675,7 +1675,7 @@ static ssize_t target_core_dev_pr_store_attr_res_aptpl_metadata(
 			break;
 		case Opt_mapped_lun:
 			match_int(args, &arg);
-			mapped_lun = (u32)arg;
+			mapped_lun = (u64)arg;
 			break;
 		/*
 		 * PR APTPL Metadata for Target Port
@@ -1710,7 +1710,7 @@ static ssize_t target_core_dev_pr_store_attr_res_aptpl_metadata(
 			break;
 		case Opt_target_lun:
 			match_int(args, &arg);
-			target_lun = (u32)arg;
+			target_lun = (u64)arg;
 			break;
 		default:
 			break;
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 6941e3b..6fe4223 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -56,7 +56,7 @@ static struct se_hba *lun0_hba;
 struct se_device *g_lun0_dev;
 
 sense_reason_t
-transport_lookup_cmd_lun(struct se_cmd *se_cmd, u32 unpacked_lun)
+transport_lookup_cmd_lun(struct se_cmd *se_cmd, u64 unpacked_lun)
 {
 	struct se_lun *se_lun = NULL;
 	struct se_session *se_sess = se_cmd->se_sess;
@@ -74,7 +74,7 @@ transport_lookup_cmd_lun(struct se_cmd *se_cmd, u32 unpacked_lun)
 		if ((se_cmd->data_direction == DMA_TO_DEVICE) &&
 		    (deve->lun_flags & TRANSPORT_LUNFLAGS_READ_ONLY)) {
 			pr_err("TARGET_CORE[%s]: Detected WRITE_PROTECTED LUN"
-				" Access for 0x%08x\n",
+				" Access for 0x%08llx\n",
 				se_cmd->se_tfo->get_fabric_name(),
 				unpacked_lun);
 			rcu_read_unlock();
@@ -107,7 +107,7 @@ transport_lookup_cmd_lun(struct se_cmd *se_cmd, u32 unpacked_lun)
 		 */
 		if (unpacked_lun != 0) {
 			pr_err("TARGET_CORE[%s]: Detected NON_EXISTENT_LUN"
-				" Access for 0x%08x\n",
+				" Access for 0x%08llx\n",
 				se_cmd->se_tfo->get_fabric_name(),
 				unpacked_lun);
 			return TCM_NON_EXISTENT_LUN;
@@ -147,7 +147,7 @@ transport_lookup_cmd_lun(struct se_cmd *se_cmd, u32 unpacked_lun)
 }
 EXPORT_SYMBOL(transport_lookup_cmd_lun);
 
-int transport_lookup_tmr_lun(struct se_cmd *se_cmd, u32 unpacked_lun)
+int transport_lookup_tmr_lun(struct se_cmd *se_cmd, u64 unpacked_lun)
 {
 	struct se_dev_entry *deve;
 	struct se_lun *se_lun = NULL;
@@ -172,7 +172,7 @@ int transport_lookup_tmr_lun(struct se_cmd *se_cmd, u32 unpacked_lun)
 
 	if (!se_lun) {
 		pr_debug("TARGET_CORE[%s]: Detected NON_EXISTENT_LUN"
-			" Access for 0x%08x\n",
+			" Access for 0x%08llx\n",
 			se_cmd->se_tfo->get_fabric_name(),
 			unpacked_lun);
 		return -ENODEV;
@@ -260,7 +260,7 @@ void core_free_device_list_for_node(
 }
 
 void core_update_device_list_access(
-	u32 mapped_lun,
+	u64 mapped_lun,
 	u32 lun_access,
 	struct se_node_acl *nacl)
 {
@@ -283,7 +283,7 @@ void core_update_device_list_access(
 /*
  * Called with rcu_read_lock or nacl->device_list_lock held.
  */
-struct se_dev_entry *target_nacl_find_deve(struct se_node_acl *nacl, u32 mapped_lun)
+struct se_dev_entry *target_nacl_find_deve(struct se_node_acl *nacl, u64 mapped_lun)
 {
 	struct se_dev_entry *deve;
 
@@ -309,7 +309,7 @@ void target_pr_kref_release(struct kref *kref)
 int core_enable_device_list_for_node(
 	struct se_lun *lun,
 	struct se_lun_acl *lun_acl,
-	u32 mapped_lun,
+	u64 mapped_lun,
 	u32 lun_access,
 	struct se_node_acl *nacl,
 	struct se_portal_group *tpg)
@@ -550,7 +550,7 @@ int core_dev_add_lun(
 	if (rc < 0)
 		return rc;
 
-	pr_debug("%s_TPG[%u]_LUN[%u] - Activated %s Logical Unit from"
+	pr_debug("%s_TPG[%u]_LUN[%llu] - Activated %s Logical Unit from"
 		" CORE HBA: %u\n", tpg->se_tpg_tfo->get_fabric_name(),
 		tpg->se_tpg_tfo->tpg_get_tag(tpg), lun->unpacked_lun,
 		tpg->se_tpg_tfo->get_fabric_name(), dev->se_hba->hba_id);
@@ -583,7 +583,7 @@ void core_dev_del_lun(
 	struct se_portal_group *tpg,
 	struct se_lun *lun)
 {
-	pr_debug("%s_TPG[%u]_LUN[%u] - Deactivating %s Logical Unit from"
+	pr_debug("%s_TPG[%u]_LUN[%llu] - Deactivating %s Logical Unit from"
 		" device object\n", tpg->se_tpg_tfo->get_fabric_name(),
 		tpg->se_tpg_tfo->tpg_get_tag(tpg), lun->unpacked_lun,
 		tpg->se_tpg_tfo->get_fabric_name());
@@ -594,7 +594,7 @@ void core_dev_del_lun(
 struct se_lun_acl *core_dev_init_initiator_node_lun_acl(
 	struct se_portal_group *tpg,
 	struct se_node_acl *nacl,
-	u32 mapped_lun,
+	u64 mapped_lun,
 	int *ret)
 {
 	struct se_lun_acl *lacl;
@@ -646,7 +646,7 @@ int core_dev_add_initiator_node_lun_acl(
 			lun_access, nacl, tpg) < 0)
 		return -EINVAL;
 
-	pr_debug("%s_TPG[%hu]_LUN[%u->%u] - Added %s ACL for "
+	pr_debug("%s_TPG[%hu]_LUN[%llu->%llu] - Added %s ACL for "
 		" InitiatorNode: %s\n", tpg->se_tpg_tfo->get_fabric_name(),
 		tpg->se_tpg_tfo->tpg_get_tag(tpg), lun->unpacked_lun, lacl->mapped_lun,
 		(lun_access & TRANSPORT_LUNFLAGS_READ_WRITE) ? "RW" : "RO",
@@ -678,8 +678,8 @@ int core_dev_del_initiator_node_lun_acl(
 		core_disable_device_list_for_node(lun, deve, nacl, tpg);
 	mutex_unlock(&nacl->lun_entry_mutex);
 
-	pr_debug("%s_TPG[%hu]_LUN[%u] - Removed ACL for"
-		" InitiatorNode: %s Mapped LUN: %u\n",
+	pr_debug("%s_TPG[%hu]_LUN[%llu] - Removed ACL for"
+		" InitiatorNode: %s Mapped LUN: %llu\n",
 		tpg->se_tpg_tfo->get_fabric_name(),
 		tpg->se_tpg_tfo->tpg_get_tag(tpg), lun->unpacked_lun,
 		lacl->initiatorname, lacl->mapped_lun);
@@ -692,7 +692,7 @@ void core_dev_free_initiator_node_lun_acl(
 	struct se_lun_acl *lacl)
 {
 	pr_debug("%s_TPG[%hu] - Freeing ACL for %s InitiatorNode: %s"
-		" Mapped LUN: %u\n", tpg->se_tpg_tfo->get_fabric_name(),
+		" Mapped LUN: %llu\n", tpg->se_tpg_tfo->get_fabric_name(),
 		tpg->se_tpg_tfo->tpg_get_tag(tpg),
 		tpg->se_tpg_tfo->get_fabric_name(),
 		lacl->initiatorname, lacl->mapped_lun);
diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index 0ee182f..2fd493e 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -202,7 +202,7 @@ static ssize_t target_fabric_mappedlun_store_write_protect(
 			lacl->se_lun_nacl);
 
 	pr_debug("%s_ConfigFS: Changed Initiator ACL: %s"
-		" Mapped LUN: %u Write Protect bit to %s\n",
+		" Mapped LUN: %llu Write Protect bit to %s\n",
 		se_tpg->se_tpg_tfo->get_fabric_name(),
 		lacl->initiatorname, lacl->mapped_lun, (op) ? "ON" : "OFF");
 
@@ -322,7 +322,7 @@ static struct config_group *target_fabric_make_mappedlun(
 	struct config_item *acl_ci;
 	struct config_group *lacl_cg = NULL, *ml_stat_grp = NULL;
 	char *buf;
-	unsigned long mapped_lun;
+	unsigned long long mapped_lun;
 	int ret = 0;
 
 	acl_ci = &group->cg_item;
@@ -350,15 +350,11 @@ static struct config_group *target_fabric_make_mappedlun(
 	 * Determine the Mapped LUN value.  This is what the SCSI Initiator
 	 * Port will actually see.
 	 */
-	ret = kstrtoul(buf + 4, 0, &mapped_lun);
+	ret = kstrtoull(buf + 4, 0, &mapped_lun);
 	if (ret)
 		goto out;
-	if (mapped_lun > UINT_MAX) {
-		ret = -EINVAL;
-		goto out;
-	}
 	if (mapped_lun > (TRANSPORT_MAX_LUNS_PER_TPG-1)) {
-		pr_err("Mapped LUN: %lu exceeds TRANSPORT_MAX_LUNS_PER_TPG"
+		pr_err("Mapped LUN: %llu exceeds TRANSPORT_MAX_LUNS_PER_TPG"
 			"-1: %u for Target Portal Group: %u\n", mapped_lun,
 			TRANSPORT_MAX_LUNS_PER_TPG-1,
 			se_tpg->se_tpg_tfo->tpg_get_tag(se_tpg));
@@ -881,7 +877,7 @@ static struct config_group *target_fabric_make_lun(
 			struct se_portal_group, tpg_lun_group);
 	struct target_fabric_configfs *tf = se_tpg->se_tpg_wwn->wwn_tf;
 	struct config_group *lun_cg = NULL, *port_stat_grp = NULL;
-	unsigned long unpacked_lun;
+	unsigned long long unpacked_lun;
 	int errno;
 
 	if (strstr(name, "lun_") != name) {
@@ -889,11 +885,9 @@ static struct config_group *target_fabric_make_lun(
 				" \"lun_$LUN_NUMBER\"\n");
 		return ERR_PTR(-EINVAL);
 	}
-	errno = kstrtoul(name + 4, 0, &unpacked_lun);
+	errno = kstrtoull(name + 4, 0, &unpacked_lun);
 	if (errno)
 		return ERR_PTR(errno);
-	if (unpacked_lun > UINT_MAX)
-		return ERR_PTR(-EINVAL);
 
 	lun = core_tpg_alloc_lun(se_tpg, unpacked_lun);
 	if (IS_ERR(lun))
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index 8d8737a..5111789 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -26,10 +26,10 @@ struct se_dev_entry *core_get_se_deve_from_rtpi(struct se_node_acl *, u16);
 void	target_pr_kref_release(struct kref *);
 void	core_free_device_list_for_node(struct se_node_acl *,
 		struct se_portal_group *);
-void	core_update_device_list_access(u32, u32, struct se_node_acl *);
-struct se_dev_entry *target_nacl_find_deve(struct se_node_acl *, u32);
+void	core_update_device_list_access(u64, u32, struct se_node_acl *);
+struct se_dev_entry *target_nacl_find_deve(struct se_node_acl *, u64);
 int	core_enable_device_list_for_node(struct se_lun *, struct se_lun_acl *,
-		u32, u32, struct se_node_acl *, struct se_portal_group *);
+		u64, u32, struct se_node_acl *, struct se_portal_group *);
 void	core_disable_device_list_for_node(struct se_lun *, struct se_dev_entry *,
 		struct se_node_acl *, struct se_portal_group *);
 void	core_clear_lun_from_tpg(struct se_lun *, struct se_portal_group *);
@@ -37,7 +37,7 @@ int	core_dev_add_lun(struct se_portal_group *, struct se_device *,
 		struct se_lun *lun);
 void	core_dev_del_lun(struct se_portal_group *, struct se_lun *);
 struct se_lun_acl *core_dev_init_initiator_node_lun_acl(struct se_portal_group *,
-		struct se_node_acl *, u32, int *);
+		struct se_node_acl *, u64, int *);
 int	core_dev_add_initiator_node_lun_acl(struct se_portal_group *,
 		struct se_lun_acl *, struct se_lun *lun, u32);
 int	core_dev_del_initiator_node_lun_acl(struct se_lun *,
@@ -80,7 +80,7 @@ struct se_node_acl *__core_tpg_get_initiator_node_acl(struct se_portal_group *tp
 void	core_tpg_add_node_to_devs(struct se_node_acl *, struct se_portal_group *,
 				  struct se_lun *);
 void	core_tpg_wait_for_nacl_pr_ref(struct se_node_acl *);
-struct se_lun *core_tpg_alloc_lun(struct se_portal_group *, u32);
+struct se_lun *core_tpg_alloc_lun(struct se_portal_group *, u64);
 int	core_tpg_add_lun(struct se_portal_group *, struct se_lun *,
 		u32, struct se_device *);
 void core_tpg_remove_lun(struct se_portal_group *, struct se_lun *);
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 94935ea..436e30b 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -229,8 +229,9 @@ target_scsi2_reservation_release(struct se_cmd *cmd)
 		dev->dev_reservation_flags &= ~DRF_SPC2_RESERVATIONS_WITH_ISID;
 	}
 	tpg = sess->se_tpg;
-	pr_debug("SCSI-2 Released reservation for %s LUN: %u ->"
-		" MAPPED LUN: %u for %s\n", tpg->se_tpg_tfo->get_fabric_name(),
+	pr_debug("SCSI-2 Released reservation for %s LUN: %llu ->"
+		" MAPPED LUN: %llu for %s\n",
+		tpg->se_tpg_tfo->get_fabric_name(),
 		cmd->se_lun->unpacked_lun, cmd->orig_fe_lun,
 		sess->se_node_acl->initiatorname);
 
@@ -275,10 +276,10 @@ target_scsi2_reservation_reserve(struct se_cmd *cmd)
 	   (dev->dev_reserved_node_acl != sess->se_node_acl)) {
 		pr_err("SCSI-2 RESERVATION CONFLIFT for %s fabric\n",
 			tpg->se_tpg_tfo->get_fabric_name());
-		pr_err("Original reserver LUN: %u %s\n",
+		pr_err("Original reserver LUN: %llu %s\n",
 			cmd->se_lun->unpacked_lun,
 			dev->dev_reserved_node_acl->initiatorname);
-		pr_err("Current attempt - LUN: %u -> MAPPED LUN: %u"
+		pr_err("Current attempt - LUN: %llu -> MAPPED LUN: %llu"
 			" from %s \n", cmd->se_lun->unpacked_lun,
 			cmd->orig_fe_lun,
 			sess->se_node_acl->initiatorname);
@@ -292,7 +293,7 @@ target_scsi2_reservation_reserve(struct se_cmd *cmd)
 		dev->dev_res_bin_isid = sess->sess_bin_isid;
 		dev->dev_reservation_flags |= DRF_SPC2_RESERVATIONS_WITH_ISID;
 	}
-	pr_debug("SCSI-2 Reserved %s LUN: %u -> MAPPED LUN: %u"
+	pr_debug("SCSI-2 Reserved %s LUN: %llu -> MAPPED LUN: %llu"
 		" for %s\n", tpg->se_tpg_tfo->get_fabric_name(),
 		cmd->se_lun->unpacked_lun, cmd->orig_fe_lun,
 		sess->se_node_acl->initiatorname);
@@ -618,7 +619,7 @@ static struct t10_pr_registration *__core_scsi3_do_alloc_registration(
 	struct se_node_acl *nacl,
 	struct se_lun *lun,
 	struct se_dev_entry *deve,
-	u32 mapped_lun,
+	u64 mapped_lun,
 	unsigned char *isid,
 	u64 sa_res_key,
 	int all_tg_pt,
@@ -671,7 +672,7 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 	struct se_node_acl *nacl,
 	struct se_lun *lun,
 	struct se_dev_entry *deve,
-	u32 mapped_lun,
+	u64 mapped_lun,
 	unsigned char *isid,
 	u64 sa_res_key,
 	int all_tg_pt,
@@ -804,10 +805,10 @@ int core_scsi3_alloc_aptpl_registration(
 	u64 sa_res_key,
 	unsigned char *i_port,
 	unsigned char *isid,
-	u32 mapped_lun,
+	u64 mapped_lun,
 	unsigned char *t_port,
 	u16 tpgt,
-	u32 target_lun,
+	u64 target_lun,
 	int res_holder,
 	int all_tg_pt,
 	u8 type)
@@ -901,9 +902,9 @@ static int __core_scsi3_check_aptpl_registration(
 	struct se_device *dev,
 	struct se_portal_group *tpg,
 	struct se_lun *lun,
-	u32 target_lun,
+	u64 target_lun,
 	struct se_node_acl *nacl,
-	u32 mapped_lun)
+	u64 mapped_lun)
 {
 	struct t10_pr_registration *pr_reg, *pr_reg_tmp;
 	struct t10_reservation *pr_tmpl = &dev->t10_pr;
@@ -972,7 +973,7 @@ int core_scsi3_check_aptpl_registration(
 	struct se_portal_group *tpg,
 	struct se_lun *lun,
 	struct se_node_acl *nacl,
-	u32 mapped_lun)
+	u64 mapped_lun)
 {
 	if (dev->dev_reservation_flags & DRF_SPC2_RESERVATIONS)
 		return 0;
@@ -1094,7 +1095,7 @@ static int core_scsi3_alloc_registration(
 	struct se_node_acl *nacl,
 	struct se_lun *lun,
 	struct se_dev_entry *deve,
-	u32 mapped_lun,
+	u64 mapped_lun,
 	unsigned char *isid,
 	u64 sa_res_key,
 	int all_tg_pt,
@@ -1668,7 +1669,7 @@ core_scsi3_decode_spec_i_port(
 		}
 
 		pr_debug("SPC-3 PR SPEC_I_PT: Located %s Node: %s"
-			" dest_se_deve mapped_lun: %u\n",
+			" dest_se_deve mapped_lun: %llu\n",
 			dest_tpg->se_tpg_tfo->get_fabric_name(),
 			dest_node_acl->initiatorname, dest_se_deve->mapped_lun);
 
@@ -1780,7 +1781,7 @@ core_scsi3_decode_spec_i_port(
 
 		pr_debug("SPC-3 PR [%s] SPEC_I_PT: Successfully"
 			" registered Transport ID for Node: %s%s Mapped LUN:"
-			" %u\n", dest_tpg->se_tpg_tfo->get_fabric_name(),
+			" %llu\n", dest_tpg->se_tpg_tfo->get_fabric_name(),
 			dest_node_acl->initiatorname, i_buf, (dest_se_deve) ?
 			dest_se_deve->mapped_lun : 0);
 
@@ -1873,7 +1874,7 @@ static int core_scsi3_update_aptpl_buf(
 				"sa_res_key=%llu\n"
 				"res_holder=1\nres_type=%02x\n"
 				"res_scope=%02x\nres_all_tg_pt=%d\n"
-				"mapped_lun=%u\n", reg_count,
+				"mapped_lun=%llu\n", reg_count,
 				tpg->se_tpg_tfo->get_fabric_name(),
 				pr_reg->pr_reg_nacl->initiatorname, isid_buf,
 				pr_reg->pr_res_key, pr_reg->pr_res_type,
@@ -1883,7 +1884,7 @@ static int core_scsi3_update_aptpl_buf(
 			snprintf(tmp, 512, "PR_REG_START: %d\n"
 				"initiator_fabric=%s\ninitiator_node=%s\n%s"
 				"sa_res_key=%llu\nres_holder=0\n"
-				"res_all_tg_pt=%d\nmapped_lun=%u\n",
+				"res_all_tg_pt=%d\nmapped_lun=%llu\n",
 				reg_count, tpg->se_tpg_tfo->get_fabric_name(),
 				pr_reg->pr_reg_nacl->initiatorname, isid_buf,
 				pr_reg->pr_res_key, pr_reg->pr_reg_all_tg_pt,
@@ -1902,7 +1903,7 @@ static int core_scsi3_update_aptpl_buf(
 		 * Include information about the associated SCSI target port.
 		 */
 		snprintf(tmp, 512, "target_fabric=%s\ntarget_node=%s\n"
-			"tpgt=%hu\nport_rtpi=%hu\ntarget_lun=%u\nPR_REG_END:"
+			"tpgt=%hu\nport_rtpi=%hu\ntarget_lun=%llu\nPR_REG_END:"
 			" %d\n", tpg->se_tpg_tfo->get_fabric_name(),
 			tpg->se_tpg_tfo->tpg_get_wwn(tpg),
 			tpg->se_tpg_tfo->tpg_get_tag(tpg),
@@ -2646,7 +2647,7 @@ core_scsi3_emulate_pro_clear(struct se_cmd *cmd, u64 res_key)
 	struct se_session *se_sess = cmd->se_sess;
 	struct t10_reservation *pr_tmpl = &dev->t10_pr;
 	struct t10_pr_registration *pr_reg, *pr_reg_tmp, *pr_reg_n, *pr_res_holder;
-	u32 pr_res_mapped_lun = 0;
+	u64 pr_res_mapped_lun = 0;
 	int calling_it_nexus = 0;
 	/*
 	 * Locate the existing *pr_reg via struct se_node_acl pointers
@@ -2802,7 +2803,7 @@ core_scsi3_pro_preempt(struct se_cmd *cmd, int type, int scope, u64 res_key,
 	LIST_HEAD(preempt_and_abort_list);
 	struct t10_pr_registration *pr_reg, *pr_reg_tmp, *pr_reg_n, *pr_res_holder;
 	struct t10_reservation *pr_tmpl = &dev->t10_pr;
-	u32 pr_res_mapped_lun = 0;
+	u64 pr_res_mapped_lun = 0;
 	int all_reg = 0, calling_it_nexus = 0;
 	bool sa_res_key_unmatched = sa_res_key != 0;
 	int prh_type = 0, prh_scope = 0;
@@ -3350,7 +3351,7 @@ after_iport_check:
 	}
 
 	pr_debug("SPC-3 PR REGISTER_AND_MOVE: Located %s node %s LUN"
-		" ACL for dest_se_deve->mapped_lun: %u\n",
+		" ACL for dest_se_deve->mapped_lun: %llu\n",
 		dest_tf_ops->get_fabric_name(), dest_node_acl->initiatorname,
 		dest_se_deve->mapped_lun);
 
diff --git a/drivers/target/target_core_pr.h b/drivers/target/target_core_pr.h
index 749fd7b..e3d26e9 100644
--- a/drivers/target/target_core_pr.h
+++ b/drivers/target/target_core_pr.h
@@ -56,11 +56,11 @@ extern sense_reason_t target_scsi2_reservation_release(struct se_cmd *);
 extern sense_reason_t target_scsi2_reservation_reserve(struct se_cmd *);
 extern int core_scsi3_alloc_aptpl_registration(
 			struct t10_reservation *, u64,
-			unsigned char *, unsigned char *, u32,
-			unsigned char *, u16, u32, int, int, u8);
+			unsigned char *, unsigned char *, u64,
+			unsigned char *, u16, u64, int, int, u8);
 extern int core_scsi3_check_aptpl_registration(struct se_device *,
 			struct se_portal_group *, struct se_lun *,
-			struct se_node_acl *, u32);
+			struct se_node_acl *, u64);
 extern void core_scsi3_free_pr_reg_from_nacl(struct se_device *,
 					     struct se_node_acl *);
 extern void core_scsi3_free_all_registrations(struct se_device *);
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 2e77eeb..82ed8a0 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -122,7 +122,7 @@ void core_tpg_add_node_to_devs(
 				lun_access = TRANSPORT_LUNFLAGS_READ_WRITE;
 		}
 
-		pr_debug("TARGET_CORE[%s]->TPG[%u]_LUN[%u] - Adding %s"
+		pr_debug("TARGET_CORE[%s]->TPG[%u]_LUN[%llu] - Adding %s"
 			" access for LUN in Demo Mode\n",
 			tpg->se_tpg_tfo->get_fabric_name(),
 			tpg->se_tpg_tfo->tpg_get_tag(tpg), lun->unpacked_lun,
@@ -598,12 +598,12 @@ EXPORT_SYMBOL(core_tpg_deregister);
 
 struct se_lun *core_tpg_alloc_lun(
 	struct se_portal_group *tpg,
-	u32 unpacked_lun)
+	u64 unpacked_lun)
 {
 	struct se_lun *lun;
 
 	if (unpacked_lun > (TRANSPORT_MAX_LUNS_PER_TPG-1)) {
-		pr_err("%s LUN: %u exceeds TRANSPORT_MAX_LUNS_PER_TPG"
+		pr_err("%s LUN: %llu exceeds TRANSPORT_MAX_LUNS_PER_TPG"
 			"-1: %u for Target Portal Group: %u\n",
 			tpg->se_tpg_tfo->get_fabric_name(),
 			unpacked_lun, TRANSPORT_MAX_LUNS_PER_TPG-1,
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index f2640ec..3da2386 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1389,7 +1389,7 @@ transport_generic_map_mem_to_cmd(struct se_cmd *cmd, struct scatterlist *sgl,
  * assumes internal allocation of fabric payload buffer by target-core.
  */
 int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess,
-		unsigned char *cdb, unsigned char *sense, u32 unpacked_lun,
+		unsigned char *cdb, unsigned char *sense, u64 unpacked_lun,
 		u32 data_length, int task_attr, int data_dir, int flags,
 		struct scatterlist *sgl, u32 sgl_count,
 		struct scatterlist *sgl_bidi, u32 sgl_bidi_count,
@@ -1525,7 +1525,7 @@ EXPORT_SYMBOL(target_submit_cmd_map_sgls);
  * It also assumes interal target core SGL memory allocation.
  */
 int target_submit_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
-		unsigned char *cdb, unsigned char *sense, u32 unpacked_lun,
+		unsigned char *cdb, unsigned char *sense, u64 unpacked_lun,
 		u32 data_length, int task_attr, int data_dir, int flags)
 {
 	return target_submit_cmd_map_sgls(se_cmd, se_sess, cdb, sense,
@@ -1562,7 +1562,7 @@ static void target_complete_tmr_failure(struct work_struct *work)
  **/
 
 int target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
-		unsigned char *sense, u32 unpacked_lun,
+		unsigned char *sense, u64 unpacked_lun,
 		void *fabric_tmr_ptr, unsigned char tm_type,
 		gfp_t gfp, unsigned int tag, int flags)
 {
diff --git a/drivers/target/target_core_ua.c b/drivers/target/target_core_ua.c
index 6c9616d..e53d4ee 100644
--- a/drivers/target/target_core_ua.c
+++ b/drivers/target/target_core_ua.c
@@ -88,7 +88,7 @@ target_scsi3_ua_check(struct se_cmd *cmd)
 
 int core_scsi3_ua_allocate(
 	struct se_node_acl *nacl,
-	u32 unpacked_lun,
+	u64 unpacked_lun,
 	u8 asc,
 	u8 ascq)
 {
@@ -177,7 +177,7 @@ int core_scsi3_ua_allocate(
 	list_add_tail(&ua->ua_nacl_list, &deve->ua_list);
 	spin_unlock(&deve->ua_lock);
 
-	pr_debug("[%s]: Allocated UNIT ATTENTION, mapped LUN: %u, ASC:"
+	pr_debug("[%s]: Allocated UNIT ATTENTION, mapped LUN: %llu, ASC:"
 		" 0x%02x, ASCQ: 0x%02x\n",
 		nacl->se_tpg->se_tpg_tfo->get_fabric_name(), unpacked_lun,
 		asc, ascq);
@@ -267,7 +267,7 @@ void core_scsi3_ua_for_check_condition(
 	rcu_read_unlock();
 
 	pr_debug("[%s]: %s UNIT ATTENTION condition with"
-		" INTLCK_CTRL: %d, mapped LUN: %u, got CDB: 0x%02x"
+		" INTLCK_CTRL: %d, mapped LUN: %llu, got CDB: 0x%02x"
 		" reported ASC: 0x%02x, ASCQ: 0x%02x\n",
 		nacl->se_tpg->se_tpg_tfo->get_fabric_name(),
 		(dev->dev_attrib.emulate_ua_intlck_ctrl != 0) ? "Reporting" :
@@ -329,7 +329,7 @@ int core_scsi3_ua_clear_for_request_sense(
 	rcu_read_unlock();
 
 	pr_debug("[%s]: Released UNIT ATTENTION condition, mapped"
-		" LUN: %u, got REQUEST_SENSE reported ASC: 0x%02x,"
+		" LUN: %llu, got REQUEST_SENSE reported ASC: 0x%02x,"
 		" ASCQ: 0x%02x\n", nacl->se_tpg->se_tpg_tfo->get_fabric_name(),
 		cmd->orig_fe_lun, *asc, *ascq);
 
diff --git a/drivers/target/target_core_ua.h b/drivers/target/target_core_ua.h
index a6b56b3..6e592b1 100644
--- a/drivers/target/target_core_ua.h
+++ b/drivers/target/target_core_ua.h
@@ -28,7 +28,7 @@
 extern struct kmem_cache *se_ua_cache;
 
 extern sense_reason_t target_scsi3_ua_check(struct se_cmd *);
-extern int core_scsi3_ua_allocate(struct se_node_acl *, u32, u8, u8);
+extern int core_scsi3_ua_allocate(struct se_node_acl *, u64, u8, u8);
 extern void core_scsi3_ua_release_all(struct se_dev_entry *);
 extern void core_scsi3_ua_for_check_condition(struct se_cmd *, u8 *, u8 *);
 extern int core_scsi3_ua_clear_for_request_sense(struct se_cmd *,
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 8855249..64de2bd 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -356,8 +356,8 @@ struct t10_pr_registration {
 	int pr_res_scope;
 	/* Used for fabric initiator WWPNs using a ISID */
 	bool isid_present_at_reg;
-	u32 pr_res_mapped_lun;
-	u32 pr_aptpl_target_lun;
+	u64 pr_res_mapped_lun;
+	u64 pr_aptpl_target_lun;
 	u16 tg_pt_sep_rtpi;
 	u32 pr_res_generation;
 	u64 pr_reg_bin_isid;
@@ -477,7 +477,7 @@ struct se_cmd {
 	/* Total size in bytes associated with command */
 	u32			data_length;
 	u32			residual_count;
-	u32			orig_fe_lun;
+	u64			orig_fe_lun;
 	/* Persistent Reservation key */
 	u64			pr_res_key;
 	/* Used for sense data */
@@ -615,7 +615,7 @@ struct se_ml_stat_grps {
 
 struct se_lun_acl {
 	char			initiatorname[TRANSPORT_IQN_LEN];
-	u32			mapped_lun;
+	u64			mapped_lun;
 	struct se_node_acl	*se_lun_nacl;
 	struct se_lun		*se_lun;
 	struct config_group	se_lun_group;
@@ -624,10 +624,10 @@ struct se_lun_acl {
 
 struct se_dev_entry {
 	/* See transport_lunflags_table */
-	u32			lun_flags;
-	u32			mapped_lun;
+	u64			mapped_lun;
 	u64			pr_res_key;
 	u64			creation_time;
+	u32			lun_flags;
 	u32			attach_count;
 	atomic_long_t		total_cmds;
 	atomic_long_t		read_bytes;
@@ -697,14 +697,15 @@ struct scsi_port_stats {
 };
 
 struct se_lun {
-	/* RELATIVE TARGET PORT IDENTIFER */
-	u16			lun_rtpi;
+	u64			unpacked_lun;
 #define SE_LUN_LINK_MAGIC			0xffff7771
 	u32			lun_link_magic;
 	u32			lun_access;
 	u32			lun_flags;
-	u32			unpacked_lun;
 	u32			lun_index;
+
+	/* RELATIVE TARGET PORT IDENTIFER */
+	u16			lun_rtpi;
 	atomic_t		lun_acl_count;
 	struct se_device __rcu	*lun_se_dev;
 
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 72c4a12..3beb8d5 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -117,16 +117,16 @@ void	transport_deregister_session(struct se_session *);
 void	transport_init_se_cmd(struct se_cmd *,
 		const struct target_core_fabric_ops *,
 		struct se_session *, u32, int, int, unsigned char *);
-sense_reason_t transport_lookup_cmd_lun(struct se_cmd *, u32);
+sense_reason_t transport_lookup_cmd_lun(struct se_cmd *, u64);
 sense_reason_t target_setup_cmd_from_cdb(struct se_cmd *, unsigned char *);
 int	target_submit_cmd_map_sgls(struct se_cmd *, struct se_session *,
-		unsigned char *, unsigned char *, u32, u32, int, int, int,
+		unsigned char *, unsigned char *, u64, u32, int, int, int,
 		struct scatterlist *, u32, struct scatterlist *, u32,
 		struct scatterlist *, u32);
 int	target_submit_cmd(struct se_cmd *, struct se_session *, unsigned char *,
-		unsigned char *, u32, u32, int, int, int);
+		unsigned char *, u64, u32, int, int, int);
 int	target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
-		unsigned char *sense, u32 unpacked_lun,
+		unsigned char *sense, u64 unpacked_lun,
 		void *fabric_tmr_ptr, unsigned char tm_type,
 		gfp_t, unsigned int, int);
 int	transport_handle_cdb_direct(struct se_cmd *);
@@ -152,7 +152,7 @@ void	core_tmr_release_req(struct se_tmr_req *);
 int	transport_generic_handle_tmr(struct se_cmd *);
 void	transport_generic_request_failure(struct se_cmd *, sense_reason_t);
 void	__target_execute_cmd(struct se_cmd *);
-int	transport_lookup_tmr_lun(struct se_cmd *, u32);
+int	transport_lookup_tmr_lun(struct se_cmd *, u64);
 
 struct se_node_acl *core_tpg_get_initiator_node_acl(struct se_portal_group *tpg,
 		unsigned char *);
-- 
1.8.5.2
