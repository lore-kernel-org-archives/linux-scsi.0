From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/4] [TCM/PR]: Add proper support for ISIDs in TransportID processing
Date: Mon, 12 Apr 2010 22:49:05 -0700
Message-ID: <1271137745-23330-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:23666 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750882Ab0DMFH5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Apr 2010 01:07:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, LIO-Target devel <linux-iscsi-target-dev@googlegroups.com>, Douglas Gilbert <dgilbert@interlog.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch updates TCM/PR to add proper support for processing SCSI Initiator Ports
that contain an Initiator Session ID in a single TransportID.  Note that iSCSI
is the only fabric defined by SPC-4 that can function in this manner, where a
iSCSI TransportID can be:

	*) iSCSI IQN device (InitiatorName)
	*) iSCSI Port Name (InitiatorName+ISID).

This patch to target_core_pr.c will check for the existence of the TCM fabric
module call struct target_core_fabric_ops->sess_get_initiator_sid() (only
expected to be set by iSCSI fabrics) to determine of ISIDs will be enforced,
and will then save the received ISID (if present) for the local fabric port to
t10_pr_registration_t->pr_reg_isid[] and sets PRF_ISID_PRESENT_AT_REG.

Note that this patch changes the default operation of TCM/PR to require the use
of InitiatorName+ISID TransportIDs for iSCSI with the LIO-Target fabric module.
This updates a number of PR functions to be ISID aware and to accept the optional
fabric pointer to ISID for both SPC-3 PR and legacy SPC-2 reservations operation.

For the fast path in core_scsi3_pr_reservation_check() and core_scsi2_reservation_check(),
a binary comparision is done on the registration/reservation time ISID against the
local I_T Nexus if ISIDs are in use for the underlying TCM fabric module.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_configfs.c  |   24 ++-
 drivers/target/target_core_pr.c        |  299 +++++++++++++++++++++++++------
 include/target/target_core_base.h      |    4 +
 include/target/target_core_pr.h        |    2 +
 include/target/target_core_transport.h |    1 +
 5 files changed, 266 insertions(+), 64 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index fc3ea81..acd7fcd 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -864,6 +864,10 @@ static ssize_t target_core_dev_pr_show_spc3_res(
 {
 	se_node_acl_t *se_nacl;
 	t10_pr_registration_t *pr_reg;
+	char i_buf[PR_REG_ISID_ID_LEN];
+	int prf_isid;
+
+	memset(i_buf, 0, PR_REG_ISID_ID_LEN);
 
 	spin_lock(&dev->dev_reservation_lock);
 	pr_reg = dev->dev_pr_res_holder;
@@ -873,9 +877,12 @@ static ssize_t target_core_dev_pr_show_spc3_res(
 		return *len;
 	}
 	se_nacl = pr_reg->pr_reg_nacl;
-	*len += sprintf(page + *len, "SPC-3 Reservation: %s Initiator: %s\n",
+	prf_isid = core_pr_dump_initiator_port(pr_reg, &i_buf[0],
+				PR_REG_ISID_ID_LEN);
+
+	*len += sprintf(page + *len, "SPC-3 Reservation: %s Initiator: %s%s\n",
 		TPG_TFO(se_nacl->se_tpg)->get_fabric_name(),
-		se_nacl->initiatorname);
+		se_nacl->initiatorname, (prf_isid) ? &i_buf[0] : "");
 	spin_unlock(&dev->dev_reservation_lock);
 
 	return *len;
@@ -1053,8 +1060,9 @@ static ssize_t target_core_dev_pr_show_attr_res_pr_registered_i_pts(
 	struct target_core_fabric_ops *tfo;
 	t10_pr_registration_t *pr_reg;
 	unsigned char buf[384];
+	char i_buf[PR_REG_ISID_ID_LEN];
 	ssize_t len = 0;
-	int reg_count = 0;
+	int reg_count = 0, prf_isid;
 
 	if (!(su_dev->se_dev_ptr))
 		return -ENODEV;
@@ -1069,11 +1077,15 @@ static ssize_t target_core_dev_pr_show_attr_res_pr_registered_i_pts(
 			pr_reg_list) {
 
 		memset(buf, 0, 384);
+		memset(i_buf, 0, PR_REG_ISID_ID_LEN);
 		tfo = pr_reg->pr_reg_nacl->se_tpg->se_tpg_tfo;
-		sprintf(buf, "%s Node: %s Key: 0x%016Lx PRgen: 0x%08x\n",
+		prf_isid = core_pr_dump_initiator_port(pr_reg, &i_buf[0],
+					PR_REG_ISID_ID_LEN);
+		sprintf(buf, "%s Node: %s%s Key: 0x%016Lx PRgen: 0x%08x\n",
 			tfo->get_fabric_name(),
-			pr_reg->pr_reg_nacl->initiatorname,
-			pr_reg->pr_res_key, pr_reg->pr_res_generation);
+			pr_reg->pr_reg_nacl->initiatorname, (prf_isid) ?
+			&i_buf[0] : "", pr_reg->pr_res_key,
+			pr_reg->pr_res_generation);
 
 		if ((len + strlen(buf) > PAGE_SIZE))
 			break;
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index f1b9a0b..7056530 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -33,6 +33,7 @@
 #include <linux/list.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
+#include <asm/unaligned.h>
 
 #include <target/target_core_base.h>
 #include <target/target_core_device.h>
@@ -60,6 +61,18 @@ struct pr_transport_id_holder {
 	struct list_head dest_list;
 };
 
+int core_pr_dump_initiator_port(
+	t10_pr_registration_t *pr_reg,
+	char *buf,
+	u32 size)
+{
+	if (!(pr_reg->pr_reg_flags & PRF_ISID_PRESENT_AT_REG))
+		return 0;
+
+	snprintf(buf, size, ",i,0x%s", &pr_reg->pr_reg_isid[0]);
+	return 1;
+}
+
 static void __core_scsi3_complete_pro_release(se_device_t *, se_node_acl_t *,
 			t10_pr_registration_t *, int);
 
@@ -94,7 +107,15 @@ int core_scsi2_reservation_check(se_cmd_t *cmd, u32 *pr_reg_type)
 		spin_unlock(&dev->dev_reservation_lock);
 		return 0;
 	}
-	ret = (dev->dev_reserved_node_acl != sess->se_node_acl) ? -1 : 0;
+	if (dev->dev_reserved_node_acl != sess->se_node_acl) {
+		spin_unlock(&dev->dev_reservation_lock);
+		return -1;
+	}
+	if (!(dev->dev_flags & DF_SPC2_RESERVATIONS_WITH_ISID)) {
+		spin_unlock(&dev->dev_reservation_lock);
+		return 0;
+	}
+	ret = (dev->dev_res_bin_isid == sess->sess_bin_isid) ? 0 : -1;
 	spin_unlock(&dev->dev_reservation_lock);
 
 	return ret;
@@ -122,6 +143,10 @@ int core_scsi2_reservation_release(se_cmd_t *cmd)
 	}
 	dev->dev_reserved_node_acl = NULL;
 	dev->dev_flags &= ~DF_SPC2_RESERVATIONS;
+	if (dev->dev_flags & DF_SPC2_RESERVATIONS_WITH_ISID) {
+		dev->dev_res_bin_isid = 0;
+		dev->dev_flags &= ~DF_SPC2_RESERVATIONS_WITH_ISID;
+	}
 	printk(KERN_INFO "SCSI-2 Released reservation for %s LUN: %u ->"
 		" MAPPED LUN: %u for %s\n", TPG_TFO(tpg)->get_fabric_name(),
 		SE_LUN(cmd)->unpacked_lun, cmd->se_deve->mapped_lun,
@@ -169,6 +194,10 @@ int core_scsi2_reservation_reserve(se_cmd_t *cmd)
 
 	dev->dev_reserved_node_acl = sess->se_node_acl;
 	dev->dev_flags |= DF_SPC2_RESERVATIONS;
+	if (sess->sess_bin_isid != 0) {
+		dev->dev_res_bin_isid = sess->sess_bin_isid;
+		dev->dev_flags |= DF_SPC2_RESERVATIONS_WITH_ISID;
+	}
 	printk(KERN_INFO "SCSI-2 Reserved %s LUN: %u -> MAPPED LUN: %u"
 		" for %s\n", TPG_TFO(tpg)->get_fabric_name(),
 		SE_LUN(cmd)->unpacked_lun, cmd->se_deve->mapped_lun,
@@ -180,7 +209,7 @@ int core_scsi2_reservation_reserve(se_cmd_t *cmd)
 EXPORT_SYMBOL(core_scsi2_reservation_reserve);
 
 static t10_pr_registration_t *core_scsi3_locate_pr_reg(se_device_t *,
-					se_node_acl_t *);
+					se_node_acl_t *, se_session_t *);
 static void core_scsi3_put_pr_reg(t10_pr_registration_t *);
 
 /*
@@ -204,7 +233,8 @@ int core_scsi2_emulate_crh(struct se_cmd_s *cmd)
 	if (!(crh))
 		goto after_crh;
 
-	pr_reg = core_scsi3_locate_pr_reg(cmd->se_dev, se_sess->se_node_acl);
+	pr_reg = core_scsi3_locate_pr_reg(cmd->se_dev, se_sess->se_node_acl,
+			se_sess);
 	if (pr_reg) {
 		/*
 		 * From spc4r17 5.7.3 Exceptions to SPC-2 RESERVE and RELEASE
@@ -285,7 +315,7 @@ static int core_scsi3_pr_seq_non_holder(
 {
 	se_dev_entry_t *se_deve;
 	se_session_t *se_sess = SE_SESS(cmd);
-	int other_cdb = 0;
+	int other_cdb = 0, ignore_reg;
 	int registered_nexus = 0, ret = 1; /* Conflict by default */
 	int all_reg = 0, reg_only = 0; /* ALL_REG, REG_ONLY */
 	int we = 0; /* Write Exclusive */
@@ -299,6 +329,13 @@ static int core_scsi3_pr_seq_non_holder(
 					cdb, pr_reg_type);
 
 	se_deve = &se_sess->se_node_acl->device_list[cmd->orig_fe_lun];
+	/*
+	 * Determine if the registration should be ignored due to
+	 * non-matching ISIDs in core_scsi3_pr_reservation_check().
+	 */
+	ignore_reg = (pr_reg_type & 0x80000000);	
+	if (ignore_reg)
+		pr_reg_type &= ~0x80000000;
 
 	switch (pr_reg_type) {
 	case PR_TYPE_WRITE_EXCLUSIVE:
@@ -308,7 +345,7 @@ static int core_scsi3_pr_seq_non_holder(
 		 * Some commands are only allowed for the persistent reservation
 		 * holder.
 		 */
-		if (se_deve->deve_flags & DEF_PR_REGISTERED)
+		if ((se_deve->deve_flags & DEF_PR_REGISTERED) && !(ignore_reg))
 			registered_nexus = 1;
 		break;
 	case PR_TYPE_WRITE_EXCLUSIVE_REGONLY:
@@ -318,7 +355,7 @@ static int core_scsi3_pr_seq_non_holder(
 		 * Some commands are only allowed for registered I_T Nexuses.
 		 */
 		reg_only = 1;
-		if (se_deve->deve_flags & DEF_PR_REGISTERED)
+		if ((se_deve->deve_flags & DEF_PR_REGISTERED) && !(ignore_reg))
 			registered_nexus = 1;
 		break;
 	case PR_TYPE_WRITE_EXCLUSIVE_ALLREG:
@@ -328,7 +365,7 @@ static int core_scsi3_pr_seq_non_holder(
 		 * Each registered I_T Nexus is a reservation holder.
 		 */
 		all_reg = 1;
-		if (se_deve->deve_flags & DEF_PR_REGISTERED)
+		if ((se_deve->deve_flags & DEF_PR_REGISTERED) && !(ignore_reg))
 			registered_nexus = 1;
 		break;
 	default:
@@ -561,8 +598,22 @@ static int core_scsi3_pr_reservation_check(
 	}
 	*pr_reg_type = dev->dev_pr_res_holder->pr_res_type;
 	cmd->pr_res_key = dev->dev_pr_res_holder->pr_res_key;
-	ret = (dev->dev_pr_res_holder->pr_reg_nacl != sess->se_node_acl) ?
-		-1 : 0;
+	if (dev->dev_pr_res_holder->pr_reg_nacl != sess->se_node_acl) {
+		spin_unlock(&dev->dev_reservation_lock);
+		return -1;
+	}
+	if (!(dev->dev_pr_res_holder->pr_reg_flags & PRF_ISID_PRESENT_AT_REG)) {
+		spin_unlock(&dev->dev_reservation_lock);
+		return 0;
+	}
+	ret = (dev->dev_pr_res_holder->pr_reg_bin_isid ==
+	       sess->sess_bin_isid) ? 0 : -1;
+	/*
+	 * Use bit in *pr_reg_type to notify ISID mismatch in
+	 * core_scsi3_pr_seq_non_holder().
+	 */
+	if (ret != 0)
+		*pr_reg_type |= 0x80000000;
 	spin_unlock(&dev->dev_reservation_lock);
 
 	return ret;
@@ -572,6 +623,7 @@ static t10_pr_registration_t *__core_scsi3_do_alloc_registration(
 	se_device_t *dev,
 	se_node_acl_t *nacl,
 	se_dev_entry_t *deve,
+	unsigned char *isid,
 	u64 sa_res_key,
 	int all_tg_pt,
 	int aptpl)
@@ -607,6 +659,15 @@ static t10_pr_registration_t *__core_scsi3_do_alloc_registration(
 	pr_reg->pr_reg_all_tg_pt = all_tg_pt;
 	pr_reg->pr_reg_aptpl = aptpl;
 	pr_reg->pr_reg_tg_pt_lun = deve->se_lun;
+	/*
+	 * If an ISID value for this SCSI Initiator Port exists,
+	 * save it to the registration now.
+	 */
+	if (isid != NULL) {
+		pr_reg->pr_reg_bin_isid = get_unaligned_be64(isid);
+		snprintf(pr_reg->pr_reg_isid, PR_REG_ISID_LEN, "%s", isid);
+		pr_reg->pr_reg_flags |= PRF_ISID_PRESENT_AT_REG;
+	}
 
 	return pr_reg;
 }
@@ -622,6 +683,7 @@ static t10_pr_registration_t *__core_scsi3_alloc_registration(
 	se_device_t *dev,
 	se_node_acl_t *nacl,
 	se_dev_entry_t *deve,
+	unsigned char *isid,
 	u64 sa_res_key,
 	int all_tg_pt,
 	int aptpl)
@@ -636,7 +698,7 @@ static t10_pr_registration_t *__core_scsi3_alloc_registration(
 	 * Create a registration for the I_T Nexus upon which the
 	 * PROUT REGISTER was received.
 	 */
-	pr_reg = __core_scsi3_do_alloc_registration(dev, nacl, deve,
+	pr_reg = __core_scsi3_do_alloc_registration(dev, nacl, deve, isid,
 			sa_res_key, all_tg_pt, aptpl);
 	if (!(pr_reg))
 		return NULL;
@@ -713,8 +775,8 @@ static t10_pr_registration_t *__core_scsi3_alloc_registration(
 			 * __core_scsi3_add_registration()
 			 */
 			pr_reg_atp = __core_scsi3_do_alloc_registration(dev,
-						nacl_tmp, deve_tmp, sa_res_key,
-						all_tg_pt, aptpl);
+						nacl_tmp, deve_tmp, NULL,
+						sa_res_key, all_tg_pt, aptpl);
 			if (!(pr_reg_atp)) {
 				atomic_dec(&port->sep_tg_pt_ref_cnt);
 				smp_mb__after_atomic_dec();
@@ -923,11 +985,18 @@ static void __core_scsi3_dump_registration(
 	int register_type)
 {
 	se_portal_group_t *se_tpg = nacl->se_tpg;
+	char i_buf[PR_REG_ISID_ID_LEN];
+	int prf_isid;
+
+	memset(&i_buf[0], 0, PR_REG_ISID_ID_LEN);
+	prf_isid = core_pr_dump_initiator_port(pr_reg, &i_buf[0],
+				PR_REG_ISID_ID_LEN);
 
 	printk(KERN_INFO "SPC-3 PR [%s] Service Action: REGISTER%s Initiator"
-		" Node: %s\n", tfo->get_fabric_name(), (register_type == 2) ?
+		" Node: %s%s\n", tfo->get_fabric_name(), (register_type == 2) ?
 		"_AND_MOVE" : (register_type == 1) ?
-		"_AND_IGNORE_EXISTING_KEY" : "", nacl->initiatorname);
+		"_AND_IGNORE_EXISTING_KEY" : "", nacl->initiatorname,
+		(prf_isid) ? i_buf : "");
 	printk(KERN_INFO "SPC-3 PR [%s] registration on Target Port: %s,0x%04x\n",
 		 tfo->get_fabric_name(), tfo->tpg_get_wwn(se_tpg),
 		tfo->tpg_get_tag(se_tpg));
@@ -1012,6 +1081,7 @@ static int core_scsi3_alloc_registration(
 	se_device_t *dev,
 	se_node_acl_t *nacl,
 	se_dev_entry_t *deve,
+	unsigned char *isid,
 	u64 sa_res_key,
 	int all_tg_pt,
 	int aptpl,
@@ -1020,7 +1090,7 @@ static int core_scsi3_alloc_registration(
 {
 	t10_pr_registration_t *pr_reg;
 
-	pr_reg = __core_scsi3_alloc_registration(dev, nacl, deve,
+	pr_reg = __core_scsi3_alloc_registration(dev, nacl, deve, isid,
 			sa_res_key, all_tg_pt, aptpl);
 	if (!(pr_reg))
 		return -1;
@@ -1030,28 +1100,82 @@ static int core_scsi3_alloc_registration(
 	return 0;
 }
 
-static t10_pr_registration_t *core_scsi3_locate_pr_reg(
+static t10_pr_registration_t *__core_scsi3_locate_pr_reg(
 	se_device_t *dev,
-	se_node_acl_t *nacl)
+	se_node_acl_t *nacl,
+	unsigned char *isid)
 {
 	t10_reservation_template_t *pr_tmpl = &SU_DEV(dev)->t10_reservation;
 	t10_pr_registration_t *pr_reg, *pr_reg_tmp;
+	se_portal_group_t *tpg;
 
 	spin_lock(&pr_tmpl->registration_lock);
 	list_for_each_entry_safe(pr_reg, pr_reg_tmp,
 			&pr_tmpl->registration_list, pr_reg_list) {
-		if (pr_reg->pr_reg_nacl == nacl) {
+		/*
+		 * First look for a matching se_node_acl_t
+		 */
+		if (pr_reg->pr_reg_nacl != nacl)
+			continue;
+
+		tpg = pr_reg->pr_reg_nacl->se_tpg;
+		/*
+		 * If this registration does NOT contain a fabric provided
+		 * ISID, then we have found a match.
+		 */
+		if (!(pr_reg->pr_reg_flags & PRF_ISID_PRESENT_AT_REG)) {
+			/*
+			 * Determine if this SCSI device server requires that
+			 * SCSI Intiatior TransportID w/ ISIDs is enforced
+			 * for fabric modules (iSCSI) requiring them.
+			 */
+			if (TPG_TFO(tpg)->sess_get_initiator_sid != NULL) {
+				if (DEV_ATTRIB(dev)->enforce_pr_isids)
+					continue;
+			}
 			atomic_inc(&pr_reg->pr_res_holders);
 			smp_mb__after_atomic_inc();
 			spin_unlock(&pr_tmpl->registration_lock);
 			return pr_reg;
 		}
+		/*
+		 * If the *pr_reg contains a fabric defined ISID for multi-value
+		 * SCSI Initiator Port TransportIDs, then we expect a valid
+		 * matching ISID to be provided by the local SCSI Initiator Port.
+		 */
+		if (!(isid))
+			continue;
+		if (strcmp(isid, pr_reg->pr_reg_isid))
+			continue;
+			
+		atomic_inc(&pr_reg->pr_res_holders);
+		smp_mb__after_atomic_inc();
+		spin_unlock(&pr_tmpl->registration_lock);
+		return pr_reg;
 	}
 	spin_unlock(&pr_tmpl->registration_lock);
 
 	return NULL;
 }
 
+static t10_pr_registration_t *core_scsi3_locate_pr_reg(
+	se_device_t *dev,
+	se_node_acl_t *nacl,
+	se_session_t *sess)
+{
+	se_portal_group_t *tpg = nacl->se_tpg;
+	unsigned char buf[PR_REG_ISID_LEN], *isid_ptr = NULL;
+
+	if (TPG_TFO(tpg)->sess_get_initiator_sid != NULL) {
+		memset(&buf[0], 0, PR_REG_ISID_LEN);
+		TPG_TFO(tpg)->sess_get_initiator_sid(sess, &buf[0],
+					PR_REG_ISID_LEN);
+		isid_ptr = &buf[0];
+	}
+
+	return __core_scsi3_locate_pr_reg(dev, nacl, isid_ptr);
+}
+
 static void core_scsi3_put_pr_reg(t10_pr_registration_t *pr_reg)
 {
 	atomic_dec(&pr_reg->pr_res_holders);
@@ -1121,6 +1245,12 @@ static void __core_scsi3_free_registration(
 	struct target_core_fabric_ops *tfo =
 			pr_reg->pr_reg_nacl->se_tpg->se_tpg_tfo;
 	t10_reservation_template_t *pr_tmpl = &SU_DEV(dev)->t10_reservation;
+	char i_buf[PR_REG_ISID_ID_LEN];
+	int prf_isid;
+
+	memset(i_buf, 0, PR_REG_ISID_ID_LEN);
+	prf_isid = core_pr_dump_initiator_port(pr_reg, &i_buf[0],
+				PR_REG_ISID_ID_LEN);
 
 	pr_reg->pr_reg_deve->deve_flags &= ~DEF_PR_REGISTERED;
 	pr_reg->pr_reg_deve->pr_res_key = 0;
@@ -1146,8 +1276,9 @@ static void __core_scsi3_free_registration(
 	}
 
 	printk(KERN_INFO "SPC-3 PR [%s] Service Action: UNREGISTER Initiator"
-		" Node: %s\n", tfo->get_fabric_name(),
-		pr_reg->pr_reg_nacl->initiatorname);
+		" Node: %s%s\n", tfo->get_fabric_name(),
+		pr_reg->pr_reg_nacl->initiatorname,
+		(prf_isid) ? &i_buf[0] : "");
 	printk(KERN_INFO "SPC-3 PR [%s] for %s TCM Subsystem %s Object Target"
 		" Port(s)\n", tfo->get_fabric_name(),
 		(pr_reg->pr_reg_all_tg_pt) ? "ALL" : "SINGLE",
@@ -1321,6 +1452,7 @@ static void core_scsi3_lunacl_undepend_item(se_dev_entry_t *se_deve)
 static int core_scsi3_decode_spec_i_port(
 	se_cmd_t *cmd,
 	se_portal_group_t *tpg,
+	unsigned char *l_isid,
 	u64 sa_res_key,
 	int all_tg_pt,
 	int aptpl)
@@ -1331,16 +1463,16 @@ static int core_scsi3_decode_spec_i_port(
 	se_session_t *se_sess = SE_SESS(cmd);
 	se_node_acl_t *dest_node_acl;
 	se_dev_entry_t *dest_se_deve = NULL, *local_se_deve;
-	t10_pr_registration_t *dest_pr_reg, *local_pr_reg;
+	t10_pr_registration_t *dest_pr_reg, *local_pr_reg, *pr_reg_e;
 	t10_pr_registration_t *pr_reg_tmp, *pr_reg_tmp_safe;
 	struct list_head tid_dest_list;
 	struct pr_transport_id_holder *tidh_new, *tidh, *tidh_tmp;
 	struct target_core_fabric_ops *tmp_tf_ops;
 	unsigned char *buf = (unsigned char *)T_TASK(cmd)->t_task_buf;
 	unsigned char *ptr, *i_str = NULL, proto_ident, tmp_proto_ident;
-	char *iport_ptr = NULL, dest_iport[64];
+	char *iport_ptr = NULL, dest_iport[64], i_buf[PR_REG_ISID_ID_LEN];
 	u32 tpdl, tid_len = 0;
-	int ret, dest_local_nexus;
+	int ret, dest_local_nexus, prf_isid;
 	u32 dest_rtpi;
 
 	memset(dest_iport, 0, 64);
@@ -1364,7 +1496,7 @@ static int core_scsi3_decode_spec_i_port(
 	tidh_new->dest_se_deve = local_se_deve;
 
 	local_pr_reg = __core_scsi3_alloc_registration(SE_DEV(cmd),
-				se_sess->se_node_acl, local_se_deve,
+				se_sess->se_node_acl, local_se_deve, l_isid,
 				sa_res_key, all_tg_pt, aptpl);
 	if (!(local_pr_reg)) {
 		kfree(tidh_new);
@@ -1593,7 +1725,7 @@ static int core_scsi3_decode_spec_i_port(
 		 * 2nd loop which will never fail.
 		 */
 		dest_pr_reg = __core_scsi3_alloc_registration(SE_DEV(cmd),
-				dest_node_acl, dest_se_deve,
+				dest_node_acl, dest_se_deve, iport_ptr,
 				sa_res_key, all_tg_pt, aptpl);
 		if (!(dest_pr_reg)) {
 			core_scsi3_lunacl_undepend_item(dest_se_deve);
@@ -1630,18 +1762,22 @@ static int core_scsi3_decode_spec_i_port(
 		dest_se_deve = tidh->dest_se_deve;
 		dest_pr_reg = tidh->dest_pr_reg;
 		dest_local_nexus = tidh->dest_local_nexus;
-
+		
 		list_del(&tidh->dest_list);
 		kfree(tidh);
 
+		memset(i_buf, 0, PR_REG_ISID_ID_LEN);
+		prf_isid = core_pr_dump_initiator_port(dest_pr_reg, &i_buf[0],
+						PR_REG_ISID_ID_LEN);
+
 		__core_scsi3_add_registration(SE_DEV(cmd), dest_node_acl,
 					dest_pr_reg, 0, 0);
 
 		printk(KERN_INFO "SPC-3 PR [%s] SPEC_I_PT: Successfully"
-			" registered Transport ID for Node: %s Mapped LUN:"
+			" registered Transport ID for Node: %s%s Mapped LUN:"
 			" %u\n", TPG_TFO(dest_tpg)->get_fabric_name(),
-				dest_node_acl->initiatorname,
-				dest_se_deve->mapped_lun);
+			dest_node_acl->initiatorname, (prf_isid) ?
+			&i_buf[0] : "", dest_se_deve->mapped_lun);
 
 		if (dest_local_nexus)
 			continue;
@@ -1914,10 +2050,11 @@ static int core_scsi3_emulate_pro_register(
 	se_dev_entry_t *se_deve;
 	se_lun_t *se_lun = SE_LUN(cmd);
 	se_portal_group_t *se_tpg;
-	t10_pr_registration_t *pr_reg, *pr_reg_p, *pr_reg_tmp;
+	t10_pr_registration_t *pr_reg, *pr_reg_p, *pr_reg_tmp, *pr_reg_e;
 	t10_reservation_template_t *pr_tmpl = &SU_DEV(dev)->t10_reservation;
 	/* Used for APTPL metadata w/ UNREGISTER */
 	unsigned char *pr_aptpl_buf = NULL;
+	unsigned char isid_buf[PR_REG_ISID_LEN], *isid_ptr = NULL;
 	int pr_holder = 0, ret = 0, type;
 
 	if (!(se_sess) || !(se_lun)) {
@@ -1926,6 +2063,13 @@ static int core_scsi3_emulate_pro_register(
 	}
 	se_tpg = se_sess->se_tpg;
 	se_deve = &se_sess->se_node_acl->device_list[cmd->orig_fe_lun];
+	
+	if (TPG_TFO(se_tpg)->sess_get_initiator_sid != NULL) {
+		memset(&isid_buf[0], 0, PR_REG_ISID_LEN);
+		TPG_TFO(se_tpg)->sess_get_initiator_sid(se_sess, &isid_buf[0],
+				PR_REG_ISID_LEN);
+		isid_ptr = &isid_buf[0];
+	}
 	/*
 	 * Follow logic from spc4r17 Section 5.7.7, Register Behaviors Table 47
 	 */
@@ -1948,7 +2092,7 @@ static int core_scsi3_emulate_pro_register(
 			 * Logical Unit of the SCSI device server.
 			 */
 			ret = core_scsi3_alloc_registration(SE_DEV(cmd),
-					se_sess->se_node_acl, se_deve,
+					se_sess->se_node_acl, se_deve, isid_ptr,
 					sa_res_key, all_tg_pt, aptpl,
 					ignore_key, 0);
 			if (ret != 0) {
@@ -1966,7 +2110,7 @@ static int core_scsi3_emulate_pro_register(
 			 * each TransportID provided SCSI Initiator Port/Device
 			 */
 			ret = core_scsi3_decode_spec_i_port(cmd, se_tpg,
-						sa_res_key, all_tg_pt, aptpl);
+					isid_ptr, sa_res_key, all_tg_pt, aptpl);
 			if (ret != 0)
 				return ret;
 		}
@@ -1986,7 +2130,7 @@ static int core_scsi3_emulate_pro_register(
 		 * preallocated *pr_reg->pr_aptpl_buf.
 		 */
 		pr_reg = core_scsi3_locate_pr_reg(SE_DEV(cmd),
-				se_sess->se_node_acl);
+				se_sess->se_node_acl, se_sess);
 
 		ret = core_scsi3_update_and_write_aptpl(SE_DEV(cmd),
 				&pr_reg->pr_aptpl_buf[0],
@@ -2219,7 +2363,10 @@ static int core_scsi3_pro_reserve(
 	se_portal_group_t *se_tpg;
 	t10_pr_registration_t *pr_reg, *pr_res_holder;
 	t10_reservation_template_t *pr_tmpl = &SU_DEV(dev)->t10_reservation;
-	int ret;
+	char i_buf[PR_REG_ISID_ID_LEN];
+	int ret, prf_isid;
+
+	memset(i_buf, 0, PR_REG_ISID_ID_LEN);
 
 	if (!(se_sess) || !(se_lun)) {
 		printk(KERN_ERR "SPC-3 PR: se_sess || se_lun_t is NULL!\n");
@@ -2230,7 +2377,8 @@ static int core_scsi3_pro_reserve(
 	/*
 	 * Locate the existing *pr_reg via se_node_acl_t pointers
 	 */
-	pr_reg = core_scsi3_locate_pr_reg(SE_DEV(cmd), se_sess->se_node_acl);
+	pr_reg = core_scsi3_locate_pr_reg(SE_DEV(cmd), se_sess->se_node_acl,
+				se_sess);
 	if (!(pr_reg)) {
 		printk(KERN_ERR "SPC-3 PR: Unable to locate"
 			" PR_REGISTERED *pr_reg for RESERVE\n");
@@ -2344,14 +2492,17 @@ static int core_scsi3_pro_reserve(
 	pr_reg->pr_res_type = type;
 	pr_reg->pr_res_holder = 1;
 	dev->dev_pr_res_holder = pr_reg;
+	prf_isid = core_pr_dump_initiator_port(pr_reg, &i_buf[0],
+				PR_REG_ISID_ID_LEN);
 
 	printk(KERN_INFO "SPC-3 PR [%s] Service Action: RESERVE created new"
 		" reservation holder TYPE: %s ALL_TG_PT: %d\n",
 		CMD_TFO(cmd)->get_fabric_name(), core_scsi3_pr_dump_type(type),
 		(pr_reg->pr_reg_all_tg_pt) ? 1 : 0);
-	printk(KERN_INFO "SPC-3 PR [%s] RESERVE Node: %s\n",
+	printk(KERN_INFO "SPC-3 PR [%s] RESERVE Node: %s%s\n",
 			CMD_TFO(cmd)->get_fabric_name(),
-			se_sess->se_node_acl->initiatorname);
+			se_sess->se_node_acl->initiatorname,
+			(prf_isid) ? &i_buf[0] : "");
 	spin_unlock(&dev->dev_reservation_lock);
 
 	if (pr_tmpl->pr_aptpl_active) {
@@ -2404,6 +2555,12 @@ static void __core_scsi3_complete_pro_release(
 	int explict)
 {
 	struct target_core_fabric_ops *tfo = se_nacl->se_tpg->se_tpg_tfo;
+	char i_buf[PR_REG_ISID_ID_LEN];
+	int prf_isid;
+	
+	memset(i_buf, 0, PR_REG_ISID_ID_LEN);
+	prf_isid = core_pr_dump_initiator_port(pr_reg, &i_buf[0],
+				PR_REG_ISID_ID_LEN);
 	/*
 	 * Go ahead and release the current PR reservation holder.
 	 */
@@ -2414,9 +2571,9 @@ static void __core_scsi3_complete_pro_release(
 		tfo->get_fabric_name(), (explict) ? "explict" : "implict",
 		core_scsi3_pr_dump_type(pr_reg->pr_res_type),
 		(pr_reg->pr_reg_all_tg_pt) ? 1 : 0);
-	printk(KERN_INFO "SPC-3 PR [%s] RELEASE Node: %s\n",
-		tfo->get_fabric_name(),
-		se_nacl->initiatorname);
+	printk(KERN_INFO "SPC-3 PR [%s] RELEASE Node: %s%s\n",
+		tfo->get_fabric_name(), se_nacl->initiatorname,
+		(prf_isid) ? &i_buf[0] : "");
 	/*
 	 * Clear TYPE and SCOPE for the next PROUT Service Action: RESERVE
 	 */
@@ -2443,7 +2600,7 @@ static int core_scsi3_emulate_pro_release(
 	/*
 	 * Locate the existing *pr_reg via se_node_acl_t pointers
 	 */
-	pr_reg = core_scsi3_locate_pr_reg(dev, se_sess->se_node_acl);
+	pr_reg = core_scsi3_locate_pr_reg(dev, se_sess->se_node_acl, se_sess);
 	if (!(pr_reg)) {
 		printk(KERN_ERR "SPC-3 PR: Unable to locate"
 			" PR_REGISTERED *pr_reg for RELEASE\n");
@@ -2606,7 +2763,7 @@ static int core_scsi3_emulate_pro_clear(
 	 * Locate the existing *pr_reg via se_node_acl_t pointers
 	 */
 	pr_reg_n = core_scsi3_locate_pr_reg(SE_DEV(cmd),
-			se_sess->se_node_acl);
+			se_sess->se_node_acl, se_sess);
 	if (!(pr_reg_n)) {
 		printk(KERN_ERR "SPC-3 PR: Unable to locate"
 			" PR_REGISTERED *pr_reg for CLEAR\n");
@@ -2693,6 +2850,12 @@ static void __core_scsi3_complete_pro_preempt(
 {
 	se_node_acl_t *nacl = pr_reg->pr_reg_nacl;
 	struct target_core_fabric_ops *tfo = nacl->se_tpg->se_tpg_tfo;
+	char i_buf[PR_REG_ISID_ID_LEN];
+	int prf_isid;
+
+	memset(i_buf, 0, PR_REG_ISID_ID_LEN);
+	prf_isid = core_pr_dump_initiator_port(pr_reg, &i_buf[0],
+				PR_REG_ISID_ID_LEN);
 	/*
 	 * Do an implict RELEASE of the existing reservation.
 	 */
@@ -2710,9 +2873,9 @@ static void __core_scsi3_complete_pro_preempt(
 		tfo->get_fabric_name(), (abort) ? "_AND_ABORT" : "",
 		core_scsi3_pr_dump_type(type),
 		(pr_reg->pr_reg_all_tg_pt) ? 1 : 0);
-	printk(KERN_INFO "SPC-3 PR [%s] PREEMPT%s from Node: %s\n",
+	printk(KERN_INFO "SPC-3 PR [%s] PREEMPT%s from Node: %s%s\n",
 		tfo->get_fabric_name(), (abort) ? "_AND_ABORT" : "",
-		nacl->initiatorname);
+		nacl->initiatorname, (prf_isid) ? &i_buf[0] : "");
 	/*
 	 * For PREEMPT_AND_ABORT, add the preempting reservation's
 	 * t10_pr_registration_t to the list that will be compared
@@ -2785,10 +2948,8 @@ static int core_scsi3_pro_preempt(
 		return PYX_TRANSPORT_LU_COMM_FAILURE;
 
 	se_deve = &se_sess->se_node_acl->device_list[cmd->orig_fe_lun];
-	if (!(se_deve->deve_flags & DEF_PR_REGISTERED))
-		return PYX_TRANSPORT_RESERVATION_CONFLICT;
-
-	pr_reg_n = core_scsi3_locate_pr_reg(SE_DEV(cmd), se_sess->se_node_acl);
+	pr_reg_n = core_scsi3_locate_pr_reg(SE_DEV(cmd), se_sess->se_node_acl,
+				se_sess);
 	if (!(pr_reg_n)) {
 		printk(KERN_ERR "SPC-3 PR: Unable to locate"
 			" PR_REGISTERED *pr_reg for PREEMPT%s\n",
@@ -3127,9 +3288,9 @@ static int core_scsi3_emulate_pro_register_and_move(
 	t10_reservation_template_t *pr_tmpl = &SU_DEV(dev)->t10_reservation;
 	unsigned char *buf = (unsigned char *)T_TASK(cmd)->t_task_buf;
 	unsigned char *initiator_str;
-	char *iport_ptr = NULL, dest_iport[64];
+	char *iport_ptr = NULL, dest_iport[64], i_buf[PR_REG_ISID_ID_LEN];
 	u32 tid_len, tmp_tid_len;
-	int new_reg = 0, type, scope, ret;
+	int new_reg = 0, type, scope, ret, matching_iname, prf_isid;
 	unsigned short rtpi;
 	unsigned char proto_ident;
 
@@ -3138,6 +3299,7 @@ static int core_scsi3_emulate_pro_register_and_move(
 		return PYX_TRANSPORT_LU_COMM_FAILURE;
 	}
 	memset(dest_iport, 0, 64);
+	memset(i_buf, 0, PR_REG_ISID_ID_LEN);
 	se_tpg = se_sess->se_tpg;
 	tf_ops = TPG_TFO(se_tpg);
 	se_deve = &se_sess->se_node_acl->device_list[cmd->orig_fe_lun];
@@ -3153,7 +3315,8 @@ static int core_scsi3_emulate_pro_register_and_move(
 	/*
 	 * Locate the existing *pr_reg via se_node_acl_t pointers
 	 */
-	pr_reg = core_scsi3_locate_pr_reg(SE_DEV(cmd), se_sess->se_node_acl);
+	pr_reg = core_scsi3_locate_pr_reg(SE_DEV(cmd), se_sess->se_node_acl,
+				se_sess);
 	if (!(pr_reg)) {
 		printk(KERN_ERR "SPC-3 PR: Unable to locate PR_REGISTERED"
 			" *pr_reg for REGISTER_AND_MOVE\n");
@@ -3279,21 +3442,37 @@ static int core_scsi3_emulate_pro_register_and_move(
 	 * IN PARAMETER LIST.
 	 */
 	pr_reg_nacl = pr_reg->pr_reg_nacl;
-	if (!(strcmp(initiator_str, pr_reg_nacl->initiatorname))) {
+	matching_iname = (!strcmp(initiator_str,
+				  pr_reg_nacl->initiatorname)) ? 1 : 0;
+	if (!(matching_iname))
+		goto after_iport_check;
+
+	if (!(iport_ptr) || !(pr_reg->pr_reg_flags & PRF_ISID_PRESENT_AT_REG)) {
 		printk(KERN_ERR "SPC-3 PR REGISTER_AND_MOVE: TransportID: %s"
 			" matches: %s on received I_T Nexus\n", initiator_str,
 			pr_reg_nacl->initiatorname);
 		ret = PYX_TRANSPORT_INVALID_PARAMETER_LIST;
 		goto out;
 	}
+	if (!(strcmp(iport_ptr, pr_reg->pr_reg_isid))) {
+		printk(KERN_ERR "SPC-3 PR REGISTER_AND_MOVE: TransportID: %s %s"
+			" matches: %s %s on received I_T Nexus\n",
+			initiator_str, iport_ptr, pr_reg_nacl->initiatorname,
+			pr_reg->pr_reg_isid);
+		ret = PYX_TRANSPORT_INVALID_PARAMETER_LIST;
+		goto out;
+	}
+after_iport_check:
 	/*
 	 * Locate the destination se_node_acl_t from the received Transport ID
 	 */
 	spin_lock_bh(&dest_se_tpg->acl_node_lock);
 	dest_node_acl = __core_tpg_get_initiator_node_acl(dest_se_tpg,
 				initiator_str);
-	atomic_inc(&dest_node_acl->acl_pr_ref_count);
-	smp_mb__after_atomic_inc();
+	if (dest_node_acl) {
+		atomic_inc(&dest_node_acl->acl_pr_ref_count);
+		smp_mb__after_atomic_inc();
+	}
 	spin_unlock_bh(&dest_se_tpg->acl_node_lock);
 
 	if (!(dest_node_acl)) {
@@ -3309,8 +3488,8 @@ static int core_scsi3_emulate_pro_register_and_move(
 			" dest_node_acl\n");
 		atomic_dec(&dest_node_acl->acl_pr_ref_count);
 		smp_mb__after_atomic_dec();
-		ret = PYX_TRANSPORT_LU_COMM_FAILURE;
 		dest_node_acl = NULL;
+		ret = PYX_TRANSPORT_LU_COMM_FAILURE;
 		goto out;
 	}
 #if 0
@@ -3335,6 +3514,7 @@ static int core_scsi3_emulate_pro_register_and_move(
 		printk(KERN_ERR "core_scsi3_lunacl_depend_item() failed\n");
 		atomic_dec(&dest_se_deve->pr_ref_count);
 		smp_mb__after_atomic_dec();
+		dest_se_deve = NULL;
 		ret = PYX_TRANSPORT_LU_COMM_FAILURE;
 		goto out;
 	}
@@ -3452,6 +3632,8 @@ static int core_scsi3_emulate_pro_register_and_move(
 	dest_pr_reg->pr_res_holder = 1;
 	dest_pr_reg->pr_res_type = type;
 	pr_reg->pr_res_scope = scope;
+	prf_isid = core_pr_dump_initiator_port(pr_reg, &i_buf[0],
+				PR_REG_ISID_ID_LEN);
 	/*
 	 * Increment PRGeneration for existing registrations..
 	 */
@@ -3465,10 +3647,11 @@ static int core_scsi3_emulate_pro_register_and_move(
 		core_scsi3_pr_dump_type(type), rtpi,
 		dest_pr_reg->pr_res_generation);
 	printk(KERN_INFO "SPC-3 PR Successfully moved reservation from"
-		" %s Fabric Node: %s -> %s Fabric Node: %s %s\n",
+		" %s Fabric Node: %s%s -> %s Fabric Node: %s %s\n",
 		tf_ops->get_fabric_name(), pr_reg_nacl->initiatorname,
-		dest_tf_ops->get_fabric_name(), dest_node_acl->initiatorname,
-		(iport_ptr != NULL) ? iport_ptr : "");
+		(prf_isid) ? &i_buf[0] : "", dest_tf_ops->get_fabric_name(),
+		dest_node_acl->initiatorname, (iport_ptr != NULL) ?
+		iport_ptr : "");
 	/*
 	 * It is now safe to release configfs group dependencies for destination
 	 * of Transport ID Initiator Device/Port Identifier
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 7b49640..e4a860a 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -363,6 +363,7 @@ typedef struct t10_pr_registration_s {
 	u32 pr_res_mapped_lun;
 	u32 pr_aptpl_target_lun;
 	u32 pr_res_generation;
+	u64 pr_reg_bin_isid;
 	u64 pr_res_key;
 	atomic_t pr_res_holders;
 	struct se_node_acl_s *pr_reg_nacl;
@@ -725,6 +726,7 @@ typedef struct se_dev_attrib_s {
 	int		emulate_tas;
 	int		emulate_reservations;
 	int		emulate_alua;
+	int		enforce_pr_isids;
 	u32		hw_block_size;
 	u32		block_size;
 	u32		hw_max_sectors;
@@ -797,6 +799,8 @@ typedef struct se_device_s {
 	u32			dev_tcq_window_closed;
 	/* Physical device queue depth */
 	u32			queue_depth;
+	/* Used for SPC-2 reservations enforce of ISIDs */
+	u64			dev_res_bin_isid;
 	t10_task_attr_index_t	dev_task_attr_type;
 	unsigned long long	dev_sectors_total;
 	/* Pointer to transport specific device structure */
diff --git a/include/target/target_core_pr.h b/include/target/target_core_pr.h
index 0fe3ee8..4281ede 100644
--- a/include/target/target_core_pr.h
+++ b/include/target/target_core_pr.h
@@ -45,6 +45,8 @@
 
 extern struct kmem_cache *t10_pr_reg_cache;
 
+extern int core_pr_dump_initiator_port(struct t10_pr_registration_s *,
+			char *, u32);
 extern int core_scsi2_emulate_crh(struct se_cmd_s *);
 extern int core_scsi3_alloc_aptpl_registration(
 			struct t10_reservation_template_s *, u64,
diff --git a/include/target/target_core_transport.h b/include/target/target_core_transport.h
index 87eb748..a049053 100644
--- a/include/target/target_core_transport.h
+++ b/include/target/target_core_transport.h
@@ -96,6 +96,7 @@
 #define DF_READ_ONLY				0x00000040
 #define DF_SPC3_PERSISTENT_RESERVE		0x00000080
 #define DF_SPC2_RESERVATIONS			0x00000100
+#define DF_SPC2_RESERVATIONS_WITH_ISID		0x00000200
 
 /* se_dev_attrib_t sanity values */
 /* 10 Minutes, see transport_get_default_task_timeout()  */
-- 
1.5.6.5

