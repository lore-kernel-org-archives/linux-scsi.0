From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 3/3] [TCM/PR]: Add support for intra-fabric SPEC_I_PT=1 TransportID processing
Date: Sun, 14 Mar 2010 01:17:59 -0800
Message-ID: <1268558279-10808-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp126.sbc.mail.sp1.yahoo.com ([69.147.65.185]:39799 "HELO
	smtp126.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754751Ab0CNJMS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Mar 2010 05:12:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LIO-Target devel <linux-iscsi-target-dev@googlegroups.com>, Douglas Gilbert <dgilbert@interlog.co>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds support for SPEC_I_PT=1 TransportID processing logic in
core_scsi3_decode_spec_i_port() to function across all available TCM fabric
modules regardless upon which fabric the TransportIDs arrived.

This includes the conversion to use the new demo-mode safe configfs dependency
wrappers in 9c8e057ee5 instead of using direct calls to configfs_depend_item()
and configfs_undepend_item() which originally required explict NodeACLs for
SPEC_I_PT=1 TransportID processing logic to function.

This patch also adds the *pr_ref_count + 1 references for TPG, NodeACL and
MappedLUN structures used by SPEC_I_PT=1 TransportID processing logic,
which are dropped when TransportID processing is complete by
core_scsi3_tpg_undepend_item(), core_scsi3_nodeacl_undepend_item() and
core_scsi3_lunacl_undepend_item() respectively.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_pr.c |  213 +++++++++++++++++++++++++--------------
 1 files changed, 138 insertions(+), 75 deletions(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 6211d59..fa39d3f 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -1127,19 +1127,22 @@ static int core_scsi3_decode_spec_i_port(
 	int all_tg_pt,
 	int aptpl)
 {
-	se_lun_t *lun = SE_LUN(cmd);
-	se_port_t *port = lun->lun_sep;
+	se_device_t *dev = SE_DEV(cmd);
+	se_port_t *tmp_port;
+	se_portal_group_t *dest_tpg = NULL, *tmp_tpg;
 	se_session_t *se_sess = SE_SESS(cmd);
 	se_node_acl_t *dest_node_acl;
 	se_dev_entry_t *dest_se_deve = NULL, *local_se_deve;
 	t10_pr_registration_t *dest_pr_reg, *local_pr_reg;
 	struct list_head tid_dest_list;
 	struct pr_transport_id_holder *tidh_new, *tidh, *tidh_tmp;
+	struct target_core_fabric_ops *tmp_tf_ops;
 	unsigned char *buf = (unsigned char *)T_TASK(cmd)->t_task_buf;
-	unsigned char *ptr, *i_str = NULL;
+	unsigned char *ptr, *i_str = NULL, proto_ident, tmp_proto_ident;
 	char *iport_ptr = NULL, dest_iport[64];
 	u32 tpdl, tid_len = 0;
 	int ret, dest_local_nexus;
+	u32 dest_rtpi;
 
 	memset(dest_iport, 0, 64);
 	INIT_LIST_HEAD(&tid_dest_list);
@@ -1157,6 +1160,7 @@ static int core_scsi3_decode_spec_i_port(
 		return PYX_TRANSPORT_LU_COMM_FAILURE;
 	}
 	INIT_LIST_HEAD(&tidh_new->dest_list);
+	tidh_new->dest_tpg = tpg;
 	tidh_new->dest_node_acl = se_sess->se_node_acl;
 	tidh_new->dest_se_deve = local_se_deve;
 
@@ -1192,16 +1196,6 @@ static int core_scsi3_decode_spec_i_port(
 		return PYX_TRANSPORT_INVALID_PARAMETER_LIST;
 	}
 	/*
-	 * struct target_fabric_core_ops->tpg_parse_pr_out_transport_id()
-	 * must exist to parse the fabric dependent transport IDs.
-	 */
-	if (TPG_TFO(tpg)->tpg_parse_pr_out_transport_id == NULL) {
-		printk(KERN_ERR "SPC-3 SPEC_I_PT: Fabric does not"
-			" containing a valid tpg_parse_pr_out_transport_id"
-			" function pointer\n");
-		return PYX_TRANSPORT_LU_COMM_FAILURE;
-	}
-	/*
 	 * Start processing the received transport IDs using the
 	 * receiving I_T Nexus portal's fabric dependent methods to
 	 * obtain the SCSI Initiator Port/Device Identifiers.
@@ -1209,49 +1203,109 @@ static int core_scsi3_decode_spec_i_port(
 	ptr = &buf[28];
 
 	while (tpdl > 0) {
-		i_str = TPG_TFO(tpg)->tpg_parse_pr_out_transport_id(
+		proto_ident = (ptr[0] & 0x0f);
+		dest_tpg = NULL;
+
+		spin_lock(&dev->se_port_lock);
+		list_for_each_entry(tmp_port, &dev->dev_sep_list, sep_list) {
+			tmp_tpg = tmp_port->sep_tpg;
+			if (!(tmp_tpg))
+				continue;
+			tmp_tf_ops = TPG_TFO(tmp_tpg);
+			if (!(tmp_tf_ops))
+				continue;
+			if (!(tmp_tf_ops->get_fabric_proto_ident) ||
+			    !(tmp_tf_ops->tpg_parse_pr_out_transport_id))
+				continue;
+			/*
+			 * Look for the matching proto_ident provided by
+			 * the received TransportID
+			 */
+			tmp_proto_ident = tmp_tf_ops->get_fabric_proto_ident();
+			if (tmp_proto_ident != proto_ident) 
+				continue;
+			dest_rtpi = tmp_port->sep_rtpi;
+
+			i_str = tmp_tf_ops->tpg_parse_pr_out_transport_id(
 					(const char *)ptr, &tid_len,
 					&iport_ptr);
-		if (!(i_str)) {
+			if (!(i_str))
+				continue;
+
+			atomic_inc(&tmp_tpg->tpg_pr_ref_count);
+			smp_mb__after_atomic_inc();
+			spin_unlock(&dev->se_port_lock);
+
+			ret = core_scsi3_tpg_depend_item(tmp_tpg);
+			if (ret != 0) {
+				printk(KERN_ERR " core_scsi3_tpg_depend_item()"
+					" for tmp_tpg\n");
+				atomic_dec(&tmp_tpg->tpg_pr_ref_count);
+				smp_mb__after_atomic_dec();
+				ret = PYX_TRANSPORT_LU_COMM_FAILURE;
+				goto out;
+			}
+			/*
+			 * Locate the desination initiator ACL to be registered
+			 * from the decoded fabric module specific TransportID
+			 * at *i_str.
+			 */
+			spin_lock_bh(&tmp_tpg->acl_node_lock);
+			dest_node_acl = __core_tpg_get_initiator_node_acl(
+						tmp_tpg, i_str);
+			atomic_inc(&dest_node_acl->acl_pr_ref_count);
+			smp_mb__after_atomic_inc();
+			spin_unlock_bh(&tmp_tpg->acl_node_lock);
+
+			if (!(dest_node_acl)) {
+				core_scsi3_tpg_undepend_item(tmp_tpg);
+				spin_lock(&dev->se_port_lock);
+				continue;
+			}
+
+			ret = core_scsi3_nodeacl_depend_item(dest_node_acl);
+			if (ret != 0) {
+				printk(KERN_ERR "configfs_depend_item() failed"
+					" for dest_node_acl->acl_group\n");
+				atomic_dec(&dest_node_acl->acl_pr_ref_count);
+				smp_mb__after_atomic_dec();
+				core_scsi3_tpg_undepend_item(tmp_tpg);
+				ret = PYX_TRANSPORT_LU_COMM_FAILURE;
+				goto out;
+			}
+
+			dest_tpg = tmp_tpg;
+			printk(KERN_INFO "SPC-3 PR SPEC_I_PT: Located %s Node:"
+				" %s Port RTPI: %hu\n",
+				TPG_TFO(dest_tpg)->get_fabric_name(),
+				dest_node_acl->initiatorname, dest_rtpi);
+
+			spin_lock(&dev->se_port_lock);
+			break;
+		}
+		spin_unlock(&dev->se_port_lock);
+		
+		if (!(dest_tpg)) {
 			printk(KERN_ERR "SPC-3 PR SPEC_I_PT: Unable to locate"
-				" i_str from Transport ID\n");
+					" dest_tpg\n");
 			ret = PYX_TRANSPORT_INVALID_PARAMETER_LIST;
 			goto out;
 		}
 #if 0
 		printk("SPC-3 PR SPEC_I_PT: Got %s data_length: %u tpdl: %u"
 			" tid_len: %d for %s + %s\n",
-			TPG_TFO(tpg)->get_fabric_name(), cmd->data_length,
+			TPG_TFO(dest_tpg)->get_fabric_name(), cmd->data_length,
 			tpdl, tid_len, i_str, iport_ptr);
 #endif
 		if (tid_len > tpdl) {
 			printk(KERN_ERR "SPC-3 PR SPEC_I_PT: Illegal tid_len:"
 				" %u for Transport ID: %s\n", tid_len, ptr);
+			core_scsi3_nodeacl_undepend_item(dest_node_acl);
+			core_scsi3_tpg_undepend_item(dest_tpg);
 			ret = PYX_TRANSPORT_INVALID_PARAMETER_LIST;
 			goto out;
 		}
 		/*
-		 * Locate the desination initiator ACL to be registered.
-		 */
-		dest_node_acl = core_tpg_get_initiator_node_acl(tpg, i_str);
-		if (!(dest_node_acl)) {
-			printk(KERN_ERR "Unable to locate %s dest_node_acl"
-				" for TransportID: %s %s\n",
-				TPG_TFO(tpg)->get_fabric_name(),
-				i_str, (iport_ptr != NULL) ? iport_ptr : "");
-			ret = PYX_TRANSPORT_INVALID_PARAMETER_LIST;
-			goto out;
-		}
-
-		ret = configfs_depend_item(TPG_TFO(tpg)->tf_subsys,
-				&dest_node_acl->acl_group.cg_item);
-		if (ret != 0) {
-			printk(KERN_ERR "configfs_depend_item() failed for"
-				" dest_node_acl->acl_group\n");
-			ret = PYX_TRANSPORT_LU_COMM_FAILURE;
-			goto out;
-		}
-		/*
 		 * If the a SCSI Initiator Port identifier is presented, then
 		 * the SCSI nexus must be present and matching the provided
 		 * TransportID.  The active se_session_t pointer is available
@@ -1264,17 +1318,16 @@ static int core_scsi3_decode_spec_i_port(
 					" presented in Transport ID, but no "
 					" active nexus exists for %s Fabric"
 					" Node: %s\n", iport_ptr,
-					TPG_TFO(tpg)->get_fabric_name(),
+					TPG_TFO(dest_tpg)->get_fabric_name(),
 					dest_node_acl->initiatorname);
 				spin_unlock(&dest_node_acl->nacl_sess_lock);
 
-				configfs_undepend_item(TPG_TFO(tpg)->tf_subsys,
-					&dest_node_acl->acl_group.cg_item);
-
+				core_scsi3_nodeacl_undepend_item(dest_node_acl);
+				core_scsi3_tpg_undepend_item(dest_tpg);
 				ret = PYX_TRANSPORT_INVALID_PARAMETER_LIST;
 				goto out;
 			}
-			TPG_TFO(tpg)->sess_get_initiator_wwn(
+			TPG_TFO(dest_tpg)->sess_get_initiator_wwn(
 					dest_node_acl->nacl_sess,
 					&dest_iport[0], 64);
 			spin_unlock(&dest_node_acl->nacl_sess_lock);
@@ -1284,9 +1337,8 @@ static int core_scsi3_decode_spec_i_port(
 					" %s and iport_ptr: %s do not match!\n",
 					dest_iport, iport_ptr);
 
-				configfs_undepend_item(TPG_TFO(tpg)->tf_subsys,
-					&dest_node_acl->acl_group.cg_item);
-
+				core_scsi3_nodeacl_undepend_item(dest_node_acl);
+				core_scsi3_tpg_undepend_item(dest_tpg);
 				ret = PYX_TRANSPORT_INVALID_PARAMETER_LIST;
 				goto out;
 			}
@@ -1295,29 +1347,36 @@ static int core_scsi3_decode_spec_i_port(
 		 * Locate the desintation se_dev_entry_t pointer for matching
 		 * RELATIVE TARGET PORT IDENTIFIER on the receiving I_T Nexus
 		 * Target Port.
-		 *
-		 * Note that core_get_se_deve_from_rtpi() will call
-		 * configfs_item_depend() on
-		 * deve->se_lun_acl->se_lun_group.cg_item.
 		 */
 		dest_se_deve = core_get_se_deve_from_rtpi(dest_node_acl,
-					port->sep_rtpi);
+					dest_rtpi);
 		if (!(dest_se_deve)) {
 			printk(KERN_ERR "Unable to locate %s dest_se_deve"
-				" from local RTPI: %hu\n",
-				TPG_TFO(tpg)->get_fabric_name(),
-				port->sep_rtpi);
-
-			configfs_undepend_item(TPG_TFO(tpg)->tf_subsys,
-				&dest_node_acl->acl_group.cg_item);
+				" from destination RTPI: %hu\n",
+				TPG_TFO(dest_tpg)->get_fabric_name(),
+				dest_rtpi);
 
+			core_scsi3_nodeacl_undepend_item(dest_node_acl);
+			core_scsi3_tpg_undepend_item(dest_tpg);
 			ret = PYX_TRANSPORT_INVALID_PARAMETER_LIST;
 			goto out;
 		}
+		
+		ret = core_scsi3_lunacl_depend_item(dest_se_deve);
+		if (ret < 0) {
+			printk(KERN_ERR "core_scsi3_lunacl_depend_item()"
+					" failed\n");
+			atomic_dec(&dest_se_deve->pr_ref_count);
+			smp_mb__after_atomic_dec();	
+			core_scsi3_nodeacl_undepend_item(dest_node_acl);
+			core_scsi3_tpg_undepend_item(dest_tpg);
+			ret = PYX_TRANSPORT_LU_COMM_FAILURE;
+			goto out;
+		}
 #if 0
 		printk(KERN_INFO "SPC-3 PR SPEC_I_PT: Located %s Node: %s"
 			" dest_se_deve mapped_lun: %u\n",
-			TPG_TFO(tpg)->get_fabric_name(),
+			TPG_TFO(dest_tpg)->get_fabric_name(),
 			dest_node_acl->initiatorname, dest_se_deve->mapped_lun);
 #endif
 		/*
@@ -1325,13 +1384,13 @@ static int core_scsi3_decode_spec_i_port(
 		 * this target port.
 		 */
 		if (dest_se_deve->deve_flags & DEF_PR_REGISTERED) {
-			configfs_undepend_item(TPG_TFO(tpg)->tf_subsys,
-			    &dest_se_deve->se_lun_acl->se_lun_group.cg_item);
-			configfs_undepend_item(TPG_TFO(tpg)->tf_subsys,
-			    &dest_node_acl->acl_group.cg_item);
+			core_scsi3_lunacl_undepend_item(dest_se_deve);
+			core_scsi3_nodeacl_undepend_item(dest_node_acl);
+			core_scsi3_tpg_undepend_item(dest_tpg);
 			ptr += tid_len;
 			tpdl -= tid_len;
 			tid_len = 0;
+			continue;
 		}
 		/*
 		 * Allocate a struct pr_transport_id_holder and setup
@@ -1342,10 +1401,14 @@ static int core_scsi3_decode_spec_i_port(
 				GFP_KERNEL);
 		if (!(tidh_new)) {
 			printk(KERN_ERR "Unable to allocate tidh_new\n");
+			core_scsi3_lunacl_undepend_item(dest_se_deve);
+			core_scsi3_nodeacl_undepend_item(dest_node_acl);
+			core_scsi3_tpg_undepend_item(dest_tpg);
 			ret = PYX_TRANSPORT_LU_COMM_FAILURE;
 			goto out;
 		}
 		INIT_LIST_HEAD(&tidh_new->dest_list);
+		tidh_new->dest_tpg = dest_tpg;
 		tidh_new->dest_node_acl = dest_node_acl;
 		tidh_new->dest_se_deve = dest_se_deve;
 
@@ -1369,10 +1432,10 @@ static int core_scsi3_decode_spec_i_port(
 				dest_node_acl, dest_se_deve,
 				sa_res_key, all_tg_pt, aptpl);
 		if (!(dest_pr_reg)) {
-			configfs_undepend_item(TPG_TFO(tpg)->tf_subsys,
-			    &dest_se_deve->se_lun_acl->se_lun_group.cg_item);
-			configfs_undepend_item(TPG_TFO(tpg)->tf_subsys,
-			    &dest_node_acl->acl_group.cg_item);
+			core_scsi3_lunacl_undepend_item(dest_se_deve);
+			core_scsi3_nodeacl_undepend_item(dest_node_acl);
+			core_scsi3_tpg_undepend_item(dest_tpg);
+			kfree(tidh_new);
 			ret = PYX_TRANSPORT_INVALID_PARAMETER_LIST;
 			goto out;
 		}
@@ -1398,6 +1461,7 @@ static int core_scsi3_decode_spec_i_port(
 	 * was received.
 	 */
 	list_for_each_entry_safe(tidh, tidh_tmp, &tid_dest_list, dest_list) {
+		dest_tpg = tidh->dest_tpg;
 		dest_node_acl = tidh->dest_node_acl;
 		dest_se_deve = tidh->dest_se_deve;
 		dest_pr_reg = tidh->dest_pr_reg;
@@ -1411,17 +1475,16 @@ static int core_scsi3_decode_spec_i_port(
 
 		printk(KERN_INFO "SPC-3 PR [%s] SPEC_I_PT: Successfully"
 			" registered Transport ID for Node: %s Mapped LUN:"
-			" %u\n", TPG_TFO(tpg)->get_fabric_name(),
+			" %u\n", TPG_TFO(dest_tpg)->get_fabric_name(),
 				dest_node_acl->initiatorname,
 				dest_se_deve->mapped_lun);
 
 		if (dest_local_nexus)
 			continue;
 
-		configfs_undepend_item(TPG_TFO(tpg)->tf_subsys,
-			&dest_se_deve->se_lun_acl->se_lun_group.cg_item);
-		configfs_undepend_item(TPG_TFO(tpg)->tf_subsys,
-			&dest_node_acl->acl_group.cg_item);
+		core_scsi3_lunacl_undepend_item(dest_se_deve);
+		core_scsi3_nodeacl_undepend_item(dest_node_acl);
+		core_scsi3_tpg_undepend_item(dest_tpg);
 	}
 
 	return 0;
@@ -1431,6 +1494,7 @@ out:
 	 * including *dest_pr_reg and the configfs dependances..
 	 */
 	list_for_each_entry_safe(tidh, tidh_tmp, &tid_dest_list, dest_list) {
+		dest_tpg = tidh->dest_tpg;
 		dest_node_acl = tidh->dest_node_acl;
 		dest_se_deve = tidh->dest_se_deve;
 		dest_pr_reg = tidh->dest_pr_reg;
@@ -1445,10 +1509,9 @@ out:
 		if (dest_local_nexus)
 			continue;
 
-		configfs_undepend_item(TPG_TFO(tpg)->tf_subsys,
-			&dest_se_deve->se_lun_acl->se_lun_group.cg_item);
-		configfs_undepend_item(TPG_TFO(tpg)->tf_subsys,
-			&dest_node_acl->acl_group.cg_item);
+		core_scsi3_lunacl_undepend_item(dest_se_deve);
+		core_scsi3_nodeacl_undepend_item(dest_node_acl);
+		core_scsi3_tpg_undepend_item(dest_tpg);
 	}
 	return ret;
 }
-- 
1.5.6.5

