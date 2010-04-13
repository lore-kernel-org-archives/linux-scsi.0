From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 3/4] [TCM/PR]: Update APTPL metadata logic for ISIDs in TransportID processing
Date: Mon, 12 Apr 2010 22:49:19 -0700
Message-ID: <1271137759-23376-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp126.sbc.mail.sp1.yahoo.com ([69.147.65.185]:22600 "HELO
	smtp126.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750882Ab0DMFIJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Apr 2010 01:08:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, LIO-Target devel <linux-iscsi-target-dev@googlegroups.com>, Douglas Gilbert <dgilbert@interlog.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch updates Activate Persistence across Target Power-Loss logic in
TCM/PR to handle fabrics presenting an ISID in TransportID processing.  This
includes per TCM backstore metadata written to out struct file in
 __core_scsi3_update_aptpl_buf(), and __core_scsi3_check_aptpl_registration()
while doing re-initialization for PR data structures from existing APTPL metadata.

This patch also changes the parser in target_core_dev_pr_store_attr_res_aptpl_metadata()
to scan for the new 'initiator_sid=' parameter from incoming configfs attribute data.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_configfs.c |   16 ++++++++++-
 drivers/target/target_core_pr.c       |   50 ++++++++++++++++++++++++++------
 include/target/target_core_pr.h       |    4 +-
 3 files changed, 57 insertions(+), 13 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index acd7fcd..3d0e263 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -1212,6 +1212,7 @@ static ssize_t target_core_dev_pr_store_attr_res_aptpl_metadata(
 {
 	se_device_t *dev;
 	unsigned char *i_fabric, *t_fabric, *i_port = NULL, *t_port = NULL;
+	unsigned char *isid = NULL;
 	char *ptr, *ptr2, *cur, *buf;
 	unsigned long long tmp_ll;
 	unsigned long tmp_l;
@@ -1270,6 +1271,19 @@ static ssize_t target_core_dev_pr_store_attr_res_aptpl_metadata(
 			i_port = ptr;
 			continue;
 		}
+		ptr2 = strstr(cur, "initiator_sid");
+		if (ptr2) {
+			transport_check_dev_params_delim(ptr, &cur);
+			if (strlen(ptr) > PR_REG_ISID_LEN) {
+				printk(KERN_ERR "APTPL metadata initiator_isid"
+					"= exceeds PR_REG_ISID_LEN: %d\n",
+					PR_REG_ISID_LEN);
+				ret = -1;
+				break;
+			}
+			isid = ptr;
+			continue;
+		}
 		ptr2 = strstr(cur, "sa_res_key");
 		if (ptr2) {
 			transport_check_dev_params_delim(ptr, &cur);
@@ -1420,7 +1434,7 @@ static ssize_t target_core_dev_pr_store_attr_res_aptpl_metadata(
 	}
 
 	ret = core_scsi3_alloc_aptpl_registration(T10_RES(su_dev), sa_res_key,
-			i_port, mapped_lun, t_port, tpgt, target_lun,
+			i_port, isid, mapped_lun, t_port, tpgt, target_lun,
 			res_holder, all_tg_pt, type);
 out:
 	kfree(buf);
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index f775db6..c700daf 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -814,6 +814,7 @@ int core_scsi3_alloc_aptpl_registration(
 	t10_reservation_template_t *pr_tmpl,
 	u64 sa_res_key,
 	unsigned char *i_port,
+	unsigned char *isid,
 	u32 mapped_lun,
 	unsigned char *t_port,
 	u16 tpgt,
@@ -853,6 +854,15 @@ int core_scsi3_alloc_aptpl_registration(
 	pr_reg->pr_res_scope = 0; /* Always LUN_SCOPE */
 	pr_reg->pr_res_type = type;
 	/*
+	 * If an ISID value had been saved in APTPL metadata for this
+	 * SCSI Initiator Port, restore it now.
+	 */
+	if (isid != NULL) {
+		pr_reg->pr_reg_bin_isid = get_unaligned_be64(isid);
+		snprintf(pr_reg->pr_reg_isid, PR_REG_ISID_LEN, "%s", isid);
+		pr_reg->pr_reg_flags |= PRF_ISID_PRESENT_AT_REG;
+        }
+	/*
 	 * Copy the i_port and t_port information from caller.
 	 */
 	snprintf(pr_reg->pr_iport, PR_APTPL_MAX_IPORT_LEN, "%s", i_port);
@@ -878,6 +888,13 @@ static void core_scsi3_aptpl_reserve(
 	se_node_acl_t *node_acl,
 	t10_pr_registration_t *pr_reg)
 {
+	char i_buf[PR_REG_ISID_ID_LEN];
+	int prf_isid;
+
+	memset(i_buf, 0, PR_REG_ISID_ID_LEN);
+	prf_isid = core_pr_dump_initiator_port(pr_reg, &i_buf[0],
+				PR_REG_ISID_ID_LEN);
+
 	spin_lock(&dev->dev_reservation_lock);
 	dev->dev_pr_res_holder = pr_reg;
 	spin_unlock(&dev->dev_reservation_lock);
@@ -887,8 +904,9 @@ static void core_scsi3_aptpl_reserve(
 		TPG_TFO(tpg)->get_fabric_name(),
 		core_scsi3_pr_dump_type(pr_reg->pr_res_type),
 		(pr_reg->pr_reg_all_tg_pt) ? 1 : 0);
-	printk(KERN_INFO "SPC-3 PR [%s] RESERVE Node: %s\n",
-		TPG_TFO(tpg)->get_fabric_name(), node_acl->initiatorname);
+	printk(KERN_INFO "SPC-3 PR [%s] RESERVE Node: %s%s\n",
+		TPG_TFO(tpg)->get_fabric_name(), node_acl->initiatorname,
+		(prf_isid) ? &i_buf[0] : "");
 }
 
 static void __core_scsi3_add_registration(se_device_t *, se_node_acl_t *,
@@ -917,7 +935,12 @@ static int __core_scsi3_check_aptpl_registration(
 	snprintf(t_port, PR_APTPL_MAX_TPORT_LEN, "%s",
 			TPG_TFO(tpg)->tpg_get_wwn(tpg));
 	tpgt = TPG_TFO(tpg)->tpg_get_tag(tpg);
-
+	/*
+	 * Look for the matching registrations+reservation from those
+	 * created from APTPL metadata.  Note that multiple registrations
+	 * may exist for fabrics that use ISIDs in their SCSI Initiator Port
+	 * TransportIDs.
+	 */
 	spin_lock(&pr_tmpl->aptpl_reg_lock);
 	list_for_each_entry_safe(pr_reg, pr_reg_tmp, &pr_tmpl->aptpl_reg_list,
 				pr_reg_aptpl_list) {
@@ -950,9 +973,8 @@ static int __core_scsi3_check_aptpl_registration(
 			 * Reenable pr_aptpl_active to accept new metadata
 			 * updates once the SCSI device is active again..
 			 */
+			spin_lock(&pr_tmpl->aptpl_reg_lock);
 			pr_tmpl->pr_aptpl_active = 1;
-
-			return 1;
 		}
 	}
 	spin_unlock(&pr_tmpl->aptpl_reg_lock);
@@ -1843,7 +1865,7 @@ static int __core_scsi3_update_aptpl_buf(
 	se_portal_group_t *tpg;
 	se_subsystem_dev_t *su_dev = SU_DEV(dev);
 	t10_pr_registration_t *pr_reg;
-	unsigned char tmp[1024];
+	unsigned char tmp[1024], isid_buf[32];
 	ssize_t len = 0;
 	int reg_count = 0;
 
@@ -1864,32 +1886,40 @@ static int __core_scsi3_update_aptpl_buf(
 			pr_reg_list) {
 
 		memset(tmp, 0, 1024);
+		memset(isid_buf, 0, 32);
 		tpg = pr_reg->pr_reg_nacl->se_tpg;
 		lun = pr_reg->pr_reg_tg_pt_lun;
 		/*
+		 * Write out any ISID value to APTPL metadata that was included
+		 * in the original registration.
+		 */	
+		if (pr_reg->pr_reg_flags & PRF_ISID_PRESENT_AT_REG)
+			snprintf(isid_buf, 32, "initiator_sid=%s\n",
+					pr_reg->pr_reg_isid);
+		/*
 		 * Include special metadata if the pr_reg matches the
 		 * reservation holder.
 		 */
 		if (dev->dev_pr_res_holder == pr_reg) {
 			snprintf(tmp, 1024, "PR_REG_START: %d"
 				"\ninitiator_fabric=%s\n"
-				"initiator_node=%s\n"
+				"initiator_node=%s\n%s"
 				"sa_res_key=%llu\n"
 				"res_holder=1\nres_type=%02x\n"
 				"res_scope=%02x\nres_all_tg_pt=%d\n"
 				"mapped_lun=%u\n", reg_count,
 				TPG_TFO(tpg)->get_fabric_name(),
-				pr_reg->pr_reg_nacl->initiatorname,
+				pr_reg->pr_reg_nacl->initiatorname, isid_buf,
 				pr_reg->pr_res_key, pr_reg->pr_res_type,
 				pr_reg->pr_res_scope, pr_reg->pr_reg_all_tg_pt,
 				pr_reg->pr_res_mapped_lun);
 		} else {
 			snprintf(tmp, 1024, "PR_REG_START: %d\n"
-				"initiator_fabric=%s\ninitiator_node=%s\n"
+				"initiator_fabric=%s\ninitiator_node=%s\n%s"
 				"sa_res_key=%llu\nres_holder=0\n"
 				"res_all_tg_pt=%d\nmapped_lun=%u\n",
 				reg_count, TPG_TFO(tpg)->get_fabric_name(),
-				pr_reg->pr_reg_nacl->initiatorname,
+				pr_reg->pr_reg_nacl->initiatorname, isid_buf,
 				pr_reg->pr_res_key, pr_reg->pr_reg_all_tg_pt,
 				pr_reg->pr_res_mapped_lun);
 		}
diff --git a/include/target/target_core_pr.h b/include/target/target_core_pr.h
index 4281ede..3708891 100644
--- a/include/target/target_core_pr.h
+++ b/include/target/target_core_pr.h
@@ -50,8 +50,8 @@ extern int core_pr_dump_initiator_port(struct t10_pr_registration_s *,
 extern int core_scsi2_emulate_crh(struct se_cmd_s *);
 extern int core_scsi3_alloc_aptpl_registration(
 			struct t10_reservation_template_s *, u64,
-			unsigned char *, u32, unsigned char *, u16, u32,
-			int, int, u8);
+			unsigned char *, unsigned char *, u32,
+			unsigned char *, u16, u32, int, int, u8);
 extern int core_scsi3_check_aptpl_registration(struct se_device_s *,
 			struct se_portal_group_s *, struct se_lun_s *,
 			struct se_lun_acl_s *);
-- 
1.5.6.5

