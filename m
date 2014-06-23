From: Andy Grover <agrover@redhat.com>
Subject: [PATCHv2 RESENDv2 1/9] target: Add locking to some accesses to nacl.device_list
Date: Mon, 23 Jun 2014 16:55:30 -0700
Message-ID: <1403567738-13310-2-git-send-email-agrover@redhat.com>
References: <1403567738-13310-1-git-send-email-agrover@redhat.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1403567738-13310-1-git-send-email-agrover@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, hch@lst.de, nab@linux-iscsi.org
List-Id: linux-scsi@vger.kernel.org

Make sure all accesses of deve elements in device_list are protected. This
will become critically important once device_list entries are potentially
NULL.

Reported-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/target_core_device.c          |  7 ++---
 drivers/target/target_core_fabric_configfs.c | 10 +++++--
 drivers/target/target_core_pr.c              | 40 +++++++++++++++++++++-------
 drivers/target/target_core_ua.c              |  3 +++
 4 files changed, 46 insertions(+), 14 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 26416c1..9789a11 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -361,11 +361,12 @@ int core_enable_device_list_for_node(
 
 	deve->creation_time = get_jiffies_64();
 	deve->attach_count++;
-	spin_unlock_irq(&nacl->device_list_lock);
 
-	spin_lock_bh(&port->sep_alua_lock);
+	spin_lock(&port->sep_alua_lock);
 	list_add_tail(&deve->alua_port_list, &port->sep_alua_list);
-	spin_unlock_bh(&port->sep_alua_lock);
+	spin_unlock(&port->sep_alua_lock);
+
+	spin_unlock_irq(&nacl->device_list_lock);
 
 	return 0;
 }
diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index 7de9f04..804e7f0 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -141,13 +141,19 @@ static int target_fabric_mappedlun_unlink(
 	struct se_lun_acl *lacl = container_of(to_config_group(lun_acl_ci),
 			struct se_lun_acl, se_lun_group);
 	struct se_node_acl *nacl = lacl->se_lun_nacl;
-	struct se_dev_entry *deve = nacl->device_list[lacl->mapped_lun];
+	struct se_dev_entry *deve;
 	struct se_portal_group *se_tpg;
+
+	spin_lock_irq(&nacl->device_list_lock);
+	deve = nacl->device_list[lacl->mapped_lun];
 	/*
 	 * Determine if the underlying MappedLUN has already been released..
 	 */
-	if (!deve->se_lun)
+	if (!deve->se_lun) {
+		spin_unlock_irq(&nacl->device_list_lock);
 		return 0;
+	}
+	spin_unlock_irq(&nacl->device_list_lock);
 
 	lun = container_of(to_config_group(lun_ci), struct se_lun, lun_group);
 	se_tpg = lun->lun_sep->sep_tpg;
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 3013287..552eedf 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -311,8 +311,13 @@ static int core_scsi3_pr_seq_non_holder(
 	int we = 0; /* Write Exclusive */
 	int legacy = 0; /* Act like a legacy device and return
 			 * RESERVATION CONFLICT on some CDBs */
+	int def_pr_registered;
 
+	spin_lock_irq(&se_sess->se_node_acl->device_list_lock);
 	se_deve = se_sess->se_node_acl->device_list[cmd->orig_fe_lun];
+	def_pr_registered = se_deve->def_pr_registered;
+	spin_unlock_irq(&se_sess->se_node_acl->device_list_lock);
+
 	/*
 	 * Determine if the registration should be ignored due to
 	 * non-matching ISIDs in target_scsi3_pr_reservation_check().
@@ -329,7 +334,7 @@ static int core_scsi3_pr_seq_non_holder(
 		 * Some commands are only allowed for the persistent reservation
 		 * holder.
 		 */
-		if ((se_deve->def_pr_registered) && !(ignore_reg))
+		if ((def_pr_registered) && !(ignore_reg))
 			registered_nexus = 1;
 		break;
 	case PR_TYPE_WRITE_EXCLUSIVE_REGONLY:
@@ -339,7 +344,7 @@ static int core_scsi3_pr_seq_non_holder(
 		 * Some commands are only allowed for registered I_T Nexuses.
 		 */
 		reg_only = 1;
-		if ((se_deve->def_pr_registered) && !(ignore_reg))
+		if ((def_pr_registered) && !(ignore_reg))
 			registered_nexus = 1;
 		break;
 	case PR_TYPE_WRITE_EXCLUSIVE_ALLREG:
@@ -349,7 +354,7 @@ static int core_scsi3_pr_seq_non_holder(
 		 * Each registered I_T Nexus is a reservation holder.
 		 */
 		all_reg = 1;
-		if ((se_deve->def_pr_registered) && !(ignore_reg))
+		if ((def_pr_registered) && !(ignore_reg))
 			registered_nexus = 1;
 		break;
 	default:
@@ -947,13 +952,21 @@ int core_scsi3_check_aptpl_registration(
 	struct se_lun_acl *lun_acl)
 {
 	struct se_node_acl *nacl = lun_acl->se_lun_nacl;
-	struct se_dev_entry *deve = nacl->device_list[lun_acl->mapped_lun];
+	struct se_dev_entry *deve;
+	int ret;
 
 	if (dev->dev_reservation_flags & DRF_SPC2_RESERVATIONS)
 		return 0;
 
-	return __core_scsi3_check_aptpl_registration(dev, tpg, lun,
-				lun->unpacked_lun, nacl, deve);
+	spin_lock_irq(&nacl->device_list_lock);
+	deve = nacl->device_list[lun_acl->mapped_lun];
+
+	ret =  __core_scsi3_check_aptpl_registration(dev, tpg, lun,
+			lun->unpacked_lun, nacl, deve);
+
+	spin_unlock_irq(&nacl->device_list_lock);
+
+	return ret;
 }
 
 static void __core_scsi3_dump_registration(
@@ -1451,7 +1464,6 @@ core_scsi3_decode_spec_i_port(
 
 	memset(dest_iport, 0, 64);
 
-	local_se_deve = se_sess->se_node_acl->device_list[cmd->orig_fe_lun];
 	/*
 	 * Allocate a struct pr_transport_id_holder and setup the
 	 * local_node_acl and local_se_deve pointers and add to
@@ -1466,11 +1478,18 @@ core_scsi3_decode_spec_i_port(
 	INIT_LIST_HEAD(&tidh_new->dest_list);
 	tidh_new->dest_tpg = tpg;
 	tidh_new->dest_node_acl = se_sess->se_node_acl;
+
+	spin_lock_irq(&se_sess->se_node_acl->device_list_lock);
+	local_se_deve = se_sess->se_node_acl->device_list[cmd->orig_fe_lun];
+
 	tidh_new->dest_se_deve = local_se_deve;
 
 	local_pr_reg = __core_scsi3_alloc_registration(cmd->se_dev,
 				se_sess->se_node_acl, local_se_deve, l_isid,
 				sa_res_key, all_tg_pt, aptpl);
+
+	spin_unlock_irq(&se_sess->se_node_acl->device_list_lock);
+
 	if (!local_pr_reg) {
 		kfree(tidh_new);
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
@@ -2002,7 +2021,6 @@ core_scsi3_emulate_pro_register(struct se_cmd *cmd, u64 res_key, u64 sa_res_key,
 {
 	struct se_session *se_sess = cmd->se_sess;
 	struct se_device *dev = cmd->se_dev;
-	struct se_dev_entry *se_deve;
 	struct se_lun *se_lun = cmd->se_lun;
 	struct se_portal_group *se_tpg;
 	struct t10_pr_registration *pr_reg, *pr_reg_p, *pr_reg_tmp;
@@ -2016,7 +2034,6 @@ core_scsi3_emulate_pro_register(struct se_cmd *cmd, u64 res_key, u64 sa_res_key,
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
 	se_tpg = se_sess->se_tpg;
-	se_deve = se_sess->se_node_acl->device_list[cmd->orig_fe_lun];
 
 	if (se_tpg->se_tpg_tfo->sess_get_initiator_sid) {
 		memset(&isid_buf[0], 0, PR_REG_ISID_LEN);
@@ -2041,19 +2058,24 @@ core_scsi3_emulate_pro_register(struct se_cmd *cmd, u64 res_key, u64 sa_res_key,
 			return 0;
 
 		if (!spec_i_pt) {
+			struct se_dev_entry *se_deve;
 			/*
 			 * Perform the Service Action REGISTER on the Initiator
 			 * Port Endpoint that the PRO was received from on the
 			 * Logical Unit of the SCSI device server.
 			 */
+			spin_lock_irq(&se_sess->se_node_acl->device_list_lock);
+			se_deve = se_sess->se_node_acl->device_list[cmd->orig_fe_lun];
 			if (core_scsi3_alloc_registration(cmd->se_dev,
 					se_sess->se_node_acl, se_deve, isid_ptr,
 					sa_res_key, all_tg_pt, aptpl,
 					register_type, 0)) {
 				pr_err("Unable to allocate"
 					" struct t10_pr_registration\n");
+				spin_unlock_irq(&se_sess->se_node_acl->device_list_lock);
 				return TCM_INVALID_PARAMETER_LIST;
 			}
+			spin_unlock_irq(&se_sess->se_node_acl->device_list_lock);
 		} else {
 			/*
 			 * Register both the Initiator port that received
diff --git a/drivers/target/target_core_ua.c b/drivers/target/target_core_ua.c
index 505519b..c63abad 100644
--- a/drivers/target/target_core_ua.c
+++ b/drivers/target/target_core_ua.c
@@ -51,9 +51,12 @@ target_scsi3_ua_check(struct se_cmd *cmd)
 	if (!nacl)
 		return 0;
 
+	spin_lock_irq(&nacl->device_list_lock);
 	deve = nacl->device_list[cmd->orig_fe_lun];
 	if (!atomic_read(&deve->ua_count))
 		return 0;
+	spin_unlock_irq(&nacl->device_list_lock);
+
 	/*
 	 * From sam4r14, section 5.14 Unit attention condition:
 	 *
-- 
1.9.3
