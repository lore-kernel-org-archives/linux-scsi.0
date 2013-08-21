From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 1/5] target: Remove TF_CIT_TMPL macro
Date: Tue, 20 Aug 2013 18:00:03 -0700
Message-ID: <1377046807-15860-2-git-send-email-agrover@redhat.com>
References: <1377046807-15860-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41242 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752091Ab3HUCKV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Aug 2013 22:10:21 -0400
In-Reply-To: <1377046807-15860-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

Remove a lingering macro that just hid a dereference.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 Documentation/target/tcm_mod_builder.py      |   18 ++++++------
 drivers/scsi/qla2xxx/tcm_qla2xxx.c           |   36 ++++++++++++------------
 drivers/target/iscsi/iscsi_target_configfs.c |   22 +++++++-------
 drivers/target/loopback/tcm_loop.c           |   10 +++---
 drivers/target/sbp/sbp_target.c              |   18 ++++++------
 drivers/target/target_core_configfs.c        |    6 ++--
 drivers/target/target_core_fabric_configfs.c |   38 +++++++++++++-------------
 drivers/target/tcm_fc/tfc_conf.c             |   18 ++++++------
 drivers/usb/gadget/tcm_usb_gadget.c          |   18 ++++++------
 drivers/vhost/scsi.c                         |   18 ++++++------
 include/target/target_core_configfs.h        |    1 -
 11 files changed, 101 insertions(+), 102 deletions(-)

diff --git a/Documentation/target/tcm_mod_builder.py b/Documentation/target/tcm_mod_builder.py
index 3fe0d81..db194c8 100755
--- a/Documentation/target/tcm_mod_builder.py
+++ b/Documentation/target/tcm_mod_builder.py
@@ -440,15 +440,15 @@ def tcm_mod_build_configfs(proto_ident, fabric_mod_dir_var, fabric_mod_name):
 	buf += "	/*\n"
 	buf += "	 * Setup default attribute lists for various fabric->tf_cit_tmpl\n"
 	buf += "	 */\n"
-	buf += "	TF_CIT_TMPL(fabric)->tfc_wwn_cit.ct_attrs = " + fabric_mod_name + "_wwn_attrs;\n"
-	buf += "	TF_CIT_TMPL(fabric)->tfc_tpg_base_cit.ct_attrs = NULL;\n"
-	buf += "	TF_CIT_TMPL(fabric)->tfc_tpg_attrib_cit.ct_attrs = NULL;\n"
-	buf += "	TF_CIT_TMPL(fabric)->tfc_tpg_param_cit.ct_attrs = NULL;\n"
-	buf += "	TF_CIT_TMPL(fabric)->tfc_tpg_np_base_cit.ct_attrs = NULL;\n"
-	buf += "	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_base_cit.ct_attrs = NULL;\n"
-	buf += "	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_attrib_cit.ct_attrs = NULL;\n"
-	buf += "	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_auth_cit.ct_attrs = NULL;\n"
-	buf += "	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_param_cit.ct_attrs = NULL;\n"
+	buf += "	fabric->tf_cit_tmpl.tfc_wwn_cit.ct_attrs = " + fabric_mod_name + "_wwn_attrs;\n"
+	buf += "	fabric->tf_cit_tmpl.tfc_tpg_base_cit.ct_attrs = NULL;\n"
+	buf += "	fabric->tf_cit_tmpl.tfc_tpg_attrib_cit.ct_attrs = NULL;\n"
+	buf += "	fabric->tf_cit_tmpl.tfc_tpg_param_cit.ct_attrs = NULL;\n"
+	buf += "	fabric->tf_cit_tmpl.tfc_tpg_np_base_cit.ct_attrs = NULL;\n"
+	buf += "	fabric->tf_cit_tmpl.tfc_tpg_nacl_base_cit.ct_attrs = NULL;\n"
+	buf += "	fabric->tf_cit_tmpl.tfc_tpg_nacl_attrib_cit.ct_attrs = NULL;\n"
+	buf += "	fabric->tf_cit_tmpl.tfc_tpg_nacl_auth_cit.ct_attrs = NULL;\n"
+	buf += "	fabric->tf_cit_tmpl.tfc_tpg_nacl_param_cit.ct_attrs = NULL;\n"
 	buf += "	/*\n"
 	buf += "	 * Register the fabric for use within TCM\n"
 	buf += "	 */\n"
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 6a93a91..947edef 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -1862,16 +1862,16 @@ static int tcm_qla2xxx_register_configfs(void)
 	/*
 	 * Setup default attribute lists for various fabric->tf_cit_tmpl
 	 */
-	TF_CIT_TMPL(fabric)->tfc_wwn_cit.ct_attrs = tcm_qla2xxx_wwn_attrs;
-	TF_CIT_TMPL(fabric)->tfc_tpg_base_cit.ct_attrs = tcm_qla2xxx_tpg_attrs;
-	TF_CIT_TMPL(fabric)->tfc_tpg_attrib_cit.ct_attrs =
+	fabric->tf_cit_tmpl.tfc_wwn_cit.ct_attrs = tcm_qla2xxx_wwn_attrs;
+	fabric->tf_cit_tmpl.tfc_tpg_base_cit.ct_attrs = tcm_qla2xxx_tpg_attrs;
+	fabric->tf_cit_tmpl.tfc_tpg_attrib_cit.ct_attrs =
 						tcm_qla2xxx_tpg_attrib_attrs;
-	TF_CIT_TMPL(fabric)->tfc_tpg_param_cit.ct_attrs = NULL;
-	TF_CIT_TMPL(fabric)->tfc_tpg_np_base_cit.ct_attrs = NULL;
-	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_base_cit.ct_attrs = NULL;
-	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_attrib_cit.ct_attrs = NULL;
-	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_auth_cit.ct_attrs = NULL;
-	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_param_cit.ct_attrs = NULL;
+	fabric->tf_cit_tmpl.tfc_tpg_param_cit.ct_attrs = NULL;
+	fabric->tf_cit_tmpl.tfc_tpg_np_base_cit.ct_attrs = NULL;
+	fabric->tf_cit_tmpl.tfc_tpg_nacl_base_cit.ct_attrs = NULL;
+	fabric->tf_cit_tmpl.tfc_tpg_nacl_attrib_cit.ct_attrs = NULL;
+	fabric->tf_cit_tmpl.tfc_tpg_nacl_auth_cit.ct_attrs = NULL;
+	fabric->tf_cit_tmpl.tfc_tpg_nacl_param_cit.ct_attrs = NULL;
 	/*
 	 * Register the fabric for use within TCM
 	 */
@@ -1902,15 +1902,15 @@ static int tcm_qla2xxx_register_configfs(void)
 	/*
 	 * Setup default attribute lists for various npiv_fabric->tf_cit_tmpl
 	 */
-	TF_CIT_TMPL(npiv_fabric)->tfc_wwn_cit.ct_attrs = tcm_qla2xxx_wwn_attrs;
-	TF_CIT_TMPL(npiv_fabric)->tfc_tpg_base_cit.ct_attrs = NULL;
-	TF_CIT_TMPL(npiv_fabric)->tfc_tpg_attrib_cit.ct_attrs = NULL;
-	TF_CIT_TMPL(npiv_fabric)->tfc_tpg_param_cit.ct_attrs = NULL;
-	TF_CIT_TMPL(npiv_fabric)->tfc_tpg_np_base_cit.ct_attrs = NULL;
-	TF_CIT_TMPL(npiv_fabric)->tfc_tpg_nacl_base_cit.ct_attrs = NULL;
-	TF_CIT_TMPL(npiv_fabric)->tfc_tpg_nacl_attrib_cit.ct_attrs = NULL;
-	TF_CIT_TMPL(npiv_fabric)->tfc_tpg_nacl_auth_cit.ct_attrs = NULL;
-	TF_CIT_TMPL(npiv_fabric)->tfc_tpg_nacl_param_cit.ct_attrs = NULL;
+	npiv_fabric->tf_cit_tmpl.tfc_wwn_cit.ct_attrs = tcm_qla2xxx_wwn_attrs;
+	npiv_fabric->tf_cit_tmpl.tfc_tpg_base_cit.ct_attrs = NULL;
+	npiv_fabric->tf_cit_tmpl.tfc_tpg_attrib_cit.ct_attrs = NULL;
+	npiv_fabric->tf_cit_tmpl.tfc_tpg_param_cit.ct_attrs = NULL;
+	npiv_fabric->tf_cit_tmpl.tfc_tpg_np_base_cit.ct_attrs = NULL;
+	npiv_fabric->tf_cit_tmpl.tfc_tpg_nacl_base_cit.ct_attrs = NULL;
+	npiv_fabric->tf_cit_tmpl.tfc_tpg_nacl_attrib_cit.ct_attrs = NULL;
+	npiv_fabric->tf_cit_tmpl.tfc_tpg_nacl_auth_cit.ct_attrs = NULL;
+	npiv_fabric->tf_cit_tmpl.tfc_tpg_nacl_param_cit.ct_attrs = NULL;
 	/*
 	 * Register the npiv_fabric for use within TCM
 	 */
diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index 116114f..9eb7855 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -1997,17 +1997,17 @@ int iscsi_target_register_configfs(void)
 	 * Setup default attribute lists for various fabric->tf_cit_tmpl
 	 * sturct config_item_type's
 	 */
-	TF_CIT_TMPL(fabric)->tfc_discovery_cit.ct_attrs = lio_target_discovery_auth_attrs;
-	TF_CIT_TMPL(fabric)->tfc_wwn_cit.ct_attrs = lio_target_wwn_attrs;
-	TF_CIT_TMPL(fabric)->tfc_tpg_base_cit.ct_attrs = lio_target_tpg_attrs;
-	TF_CIT_TMPL(fabric)->tfc_tpg_attrib_cit.ct_attrs = lio_target_tpg_attrib_attrs;
-	TF_CIT_TMPL(fabric)->tfc_tpg_auth_cit.ct_attrs = lio_target_tpg_auth_attrs;
-	TF_CIT_TMPL(fabric)->tfc_tpg_param_cit.ct_attrs = lio_target_tpg_param_attrs;
-	TF_CIT_TMPL(fabric)->tfc_tpg_np_base_cit.ct_attrs = lio_target_portal_attrs;
-	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_base_cit.ct_attrs = lio_target_initiator_attrs;
-	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_attrib_cit.ct_attrs = lio_target_nacl_attrib_attrs;
-	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_auth_cit.ct_attrs = lio_target_nacl_auth_attrs;
-	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_param_cit.ct_attrs = lio_target_nacl_param_attrs;
+	fabric->tf_cit_tmpl.tfc_discovery_cit.ct_attrs = lio_target_discovery_auth_attrs;
+	fabric->tf_cit_tmpl.tfc_wwn_cit.ct_attrs = lio_target_wwn_attrs;
+	fabric->tf_cit_tmpl.tfc_tpg_base_cit.ct_attrs = lio_target_tpg_attrs;
+	fabric->tf_cit_tmpl.tfc_tpg_attrib_cit.ct_attrs = lio_target_tpg_attrib_attrs;
+	fabric->tf_cit_tmpl.tfc_tpg_auth_cit.ct_attrs = lio_target_tpg_auth_attrs;
+	fabric->tf_cit_tmpl.tfc_tpg_param_cit.ct_attrs = lio_target_tpg_param_attrs;
+	fabric->tf_cit_tmpl.tfc_tpg_np_base_cit.ct_attrs = lio_target_portal_attrs;
+	fabric->tf_cit_tmpl.tfc_tpg_nacl_base_cit.ct_attrs = lio_target_initiator_attrs;
+	fabric->tf_cit_tmpl.tfc_tpg_nacl_attrib_cit.ct_attrs = lio_target_nacl_attrib_attrs;
+	fabric->tf_cit_tmpl.tfc_tpg_nacl_auth_cit.ct_attrs = lio_target_nacl_auth_attrs;
+	fabric->tf_cit_tmpl.tfc_tpg_nacl_param_cit.ct_attrs = lio_target_nacl_param_attrs;
 
 	ret = target_fabric_configfs_register(fabric);
 	if (ret < 0) {
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 568ad25..ab4d54e 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -1334,11 +1334,11 @@ static int tcm_loop_register_configfs(void)
 	/*
 	 * Setup default attribute lists for various fabric->tf_cit_tmpl
 	 */
-	TF_CIT_TMPL(fabric)->tfc_wwn_cit.ct_attrs = tcm_loop_wwn_attrs;
-	TF_CIT_TMPL(fabric)->tfc_tpg_base_cit.ct_attrs = tcm_loop_tpg_attrs;
-	TF_CIT_TMPL(fabric)->tfc_tpg_attrib_cit.ct_attrs = NULL;
-	TF_CIT_TMPL(fabric)->tfc_tpg_param_cit.ct_attrs = NULL;
-	TF_CIT_TMPL(fabric)->tfc_tpg_np_base_cit.ct_attrs = NULL;
+	fabric->tf_cit_tmpl.tfc_wwn_cit.ct_attrs = tcm_loop_wwn_attrs;
+	fabric->tf_cit_tmpl.tfc_tpg_base_cit.ct_attrs = tcm_loop_tpg_attrs;
+	fabric->tf_cit_tmpl.tfc_tpg_attrib_cit.ct_attrs = NULL;
+	fabric->tf_cit_tmpl.tfc_tpg_param_cit.ct_attrs = NULL;
+	fabric->tf_cit_tmpl.tfc_tpg_np_base_cit.ct_attrs = NULL;
 	/*
 	 * Once fabric->tf_ops has been setup, now register the fabric for
 	 * use within TCM
diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index e51b09a..24884ca 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -2556,15 +2556,15 @@ static int sbp_register_configfs(void)
 	/*
 	 * Setup default attribute lists for various fabric->tf_cit_tmpl
 	 */
-	TF_CIT_TMPL(fabric)->tfc_wwn_cit.ct_attrs = sbp_wwn_attrs;
-	TF_CIT_TMPL(fabric)->tfc_tpg_base_cit.ct_attrs = sbp_tpg_base_attrs;
-	TF_CIT_TMPL(fabric)->tfc_tpg_attrib_cit.ct_attrs = sbp_tpg_attrib_attrs;
-	TF_CIT_TMPL(fabric)->tfc_tpg_param_cit.ct_attrs = NULL;
-	TF_CIT_TMPL(fabric)->tfc_tpg_np_base_cit.ct_attrs = NULL;
-	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_base_cit.ct_attrs = NULL;
-	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_attrib_cit.ct_attrs = NULL;
-	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_auth_cit.ct_attrs = NULL;
-	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_param_cit.ct_attrs = NULL;
+	fabric->tf_cit_tmpl.tfc_wwn_cit.ct_attrs = sbp_wwn_attrs;
+	fabric->tf_cit_tmpl.tfc_tpg_base_cit.ct_attrs = sbp_tpg_base_attrs;
+	fabric->tf_cit_tmpl.tfc_tpg_attrib_cit.ct_attrs = sbp_tpg_attrib_attrs;
+	fabric->tf_cit_tmpl.tfc_tpg_param_cit.ct_attrs = NULL;
+	fabric->tf_cit_tmpl.tfc_tpg_np_base_cit.ct_attrs = NULL;
+	fabric->tf_cit_tmpl.tfc_tpg_nacl_base_cit.ct_attrs = NULL;
+	fabric->tf_cit_tmpl.tfc_tpg_nacl_attrib_cit.ct_attrs = NULL;
+	fabric->tf_cit_tmpl.tfc_tpg_nacl_auth_cit.ct_attrs = NULL;
+	fabric->tf_cit_tmpl.tfc_tpg_nacl_param_cit.ct_attrs = NULL;
 
 	ret = target_fabric_configfs_register(fabric);
 	if (ret < 0) {
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index f67a9af..fff9291 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -176,16 +176,16 @@ static struct config_group *target_core_register_fabric(
 	 * struct target_fabric_configfs *tf will contain a usage reference.
 	 */
 	pr_debug("Target_Core_ConfigFS: REGISTER tfc_wwn_cit -> %p\n",
-			&TF_CIT_TMPL(tf)->tfc_wwn_cit);
+			&tf->tf_cit_tmpl.tfc_wwn_cit);
 
 	tf->tf_group.default_groups = tf->tf_default_groups;
 	tf->tf_group.default_groups[0] = &tf->tf_disc_group;
 	tf->tf_group.default_groups[1] = NULL;
 
 	config_group_init_type_name(&tf->tf_group, name,
-			&TF_CIT_TMPL(tf)->tfc_wwn_cit);
+			&tf->tf_cit_tmpl.tfc_wwn_cit);
 	config_group_init_type_name(&tf->tf_disc_group, "discovery_auth",
-			&TF_CIT_TMPL(tf)->tfc_discovery_cit);
+			&tf->tf_cit_tmpl.tfc_discovery_cit);
 
 	pr_debug("Target_Core_ConfigFS: REGISTER -> Allocated Fabric:"
 			" %s\n", tf->tf_group.cg_item.ci_name);
diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index f5ce68f..59301f4 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -385,9 +385,9 @@ static struct config_group *target_fabric_make_mappedlun(
 	}
 
 	config_group_init_type_name(&lacl->se_lun_group, name,
-			&TF_CIT_TMPL(tf)->tfc_tpg_mappedlun_cit);
+			&tf->tf_cit_tmpl.tfc_tpg_mappedlun_cit);
 	config_group_init_type_name(&lacl->ml_stat_grps.stat_group,
-			"statistics", &TF_CIT_TMPL(tf)->tfc_tpg_mappedlun_stat_cit);
+			"statistics", &tf->tf_cit_tmpl.tfc_tpg_mappedlun_stat_cit);
 	lacl_cg->default_groups[0] = &lacl->ml_stat_grps.stat_group;
 	lacl_cg->default_groups[1] = NULL;
 
@@ -504,16 +504,16 @@ static struct config_group *target_fabric_make_nodeacl(
 	nacl_cg->default_groups[4] = NULL;
 
 	config_group_init_type_name(&se_nacl->acl_group, name,
-			&TF_CIT_TMPL(tf)->tfc_tpg_nacl_base_cit);
+			&tf->tf_cit_tmpl.tfc_tpg_nacl_base_cit);
 	config_group_init_type_name(&se_nacl->acl_attrib_group, "attrib",
-			&TF_CIT_TMPL(tf)->tfc_tpg_nacl_attrib_cit);
+			&tf->tf_cit_tmpl.tfc_tpg_nacl_attrib_cit);
 	config_group_init_type_name(&se_nacl->acl_auth_group, "auth",
-			&TF_CIT_TMPL(tf)->tfc_tpg_nacl_auth_cit);
+			&tf->tf_cit_tmpl.tfc_tpg_nacl_auth_cit);
 	config_group_init_type_name(&se_nacl->acl_param_group, "param",
-			&TF_CIT_TMPL(tf)->tfc_tpg_nacl_param_cit);
+			&tf->tf_cit_tmpl.tfc_tpg_nacl_param_cit);
 	config_group_init_type_name(&se_nacl->acl_fabric_stat_group,
 			"fabric_statistics",
-			&TF_CIT_TMPL(tf)->tfc_tpg_nacl_stat_cit);
+			&tf->tf_cit_tmpl.tfc_tpg_nacl_stat_cit);
 
 	return &se_nacl->acl_group;
 }
@@ -595,7 +595,7 @@ static struct config_group *target_fabric_make_np(
 
 	se_tpg_np->tpg_np_parent = se_tpg;
 	config_group_init_type_name(&se_tpg_np->tpg_np_group, name,
-			&TF_CIT_TMPL(tf)->tfc_tpg_np_base_cit);
+			&tf->tf_cit_tmpl.tfc_tpg_np_base_cit);
 
 	return &se_tpg_np->tpg_np_group;
 }
@@ -899,9 +899,9 @@ static struct config_group *target_fabric_make_lun(
 	}
 
 	config_group_init_type_name(&lun->lun_group, name,
-			&TF_CIT_TMPL(tf)->tfc_tpg_port_cit);
+			&tf->tf_cit_tmpl.tfc_tpg_port_cit);
 	config_group_init_type_name(&lun->port_stat_grps.stat_group,
-			"statistics", &TF_CIT_TMPL(tf)->tfc_tpg_port_stat_cit);
+			"statistics", &tf->tf_cit_tmpl.tfc_tpg_port_stat_cit);
 	lun_cg->default_groups[0] = &lun->port_stat_grps.stat_group;
 	lun_cg->default_groups[1] = NULL;
 
@@ -1056,19 +1056,19 @@ static struct config_group *target_fabric_make_tpg(
 	se_tpg->tpg_group.default_groups[6] = NULL;
 
 	config_group_init_type_name(&se_tpg->tpg_group, name,
-			&TF_CIT_TMPL(tf)->tfc_tpg_base_cit);
+			&tf->tf_cit_tmpl.tfc_tpg_base_cit);
 	config_group_init_type_name(&se_tpg->tpg_lun_group, "lun",
-			&TF_CIT_TMPL(tf)->tfc_tpg_lun_cit);
+			&tf->tf_cit_tmpl.tfc_tpg_lun_cit);
 	config_group_init_type_name(&se_tpg->tpg_np_group, "np",
-			&TF_CIT_TMPL(tf)->tfc_tpg_np_cit);
+			&tf->tf_cit_tmpl.tfc_tpg_np_cit);
 	config_group_init_type_name(&se_tpg->tpg_acl_group, "acls",
-			&TF_CIT_TMPL(tf)->tfc_tpg_nacl_cit);
+			&tf->tf_cit_tmpl.tfc_tpg_nacl_cit);
 	config_group_init_type_name(&se_tpg->tpg_attrib_group, "attrib",
-			&TF_CIT_TMPL(tf)->tfc_tpg_attrib_cit);
+			&tf->tf_cit_tmpl.tfc_tpg_attrib_cit);
 	config_group_init_type_name(&se_tpg->tpg_auth_group, "auth",
-			&TF_CIT_TMPL(tf)->tfc_tpg_auth_cit);
+			&tf->tf_cit_tmpl.tfc_tpg_auth_cit);
 	config_group_init_type_name(&se_tpg->tpg_param_group, "param",
-			&TF_CIT_TMPL(tf)->tfc_tpg_param_cit);
+			&tf->tf_cit_tmpl.tfc_tpg_param_cit);
 
 	return &se_tpg->tpg_group;
 }
@@ -1155,9 +1155,9 @@ static struct config_group *target_fabric_make_wwn(
 	wwn->wwn_group.default_groups[1] = NULL;
 
 	config_group_init_type_name(&wwn->wwn_group, name,
-			&TF_CIT_TMPL(tf)->tfc_tpg_cit);
+			&tf->tf_cit_tmpl.tfc_tpg_cit);
 	config_group_init_type_name(&wwn->fabric_stat_group, "fabric_statistics",
-			&TF_CIT_TMPL(tf)->tfc_wwn_fabric_stats_cit);
+			&tf->tf_cit_tmpl.tfc_wwn_fabric_stats_cit);
 
 	return &wwn->wwn_group;
 }
diff --git a/drivers/target/tcm_fc/tfc_conf.c b/drivers/target/tcm_fc/tfc_conf.c
index 4e00508..c6932fb 100644
--- a/drivers/target/tcm_fc/tfc_conf.c
+++ b/drivers/target/tcm_fc/tfc_conf.c
@@ -571,16 +571,16 @@ int ft_register_configfs(void)
 	/*
 	 * Setup default attribute lists for various fabric->tf_cit_tmpl
 	 */
-	TF_CIT_TMPL(fabric)->tfc_wwn_cit.ct_attrs = ft_wwn_attrs;
-	TF_CIT_TMPL(fabric)->tfc_tpg_base_cit.ct_attrs = NULL;
-	TF_CIT_TMPL(fabric)->tfc_tpg_attrib_cit.ct_attrs = NULL;
-	TF_CIT_TMPL(fabric)->tfc_tpg_param_cit.ct_attrs = NULL;
-	TF_CIT_TMPL(fabric)->tfc_tpg_np_base_cit.ct_attrs = NULL;
-	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_base_cit.ct_attrs =
+	fabric->tf_cit_tmpl.tfc_wwn_cit.ct_attrs = ft_wwn_attrs;
+	fabric->tf_cit_tmpl.tfc_tpg_base_cit.ct_attrs = NULL;
+	fabric->tf_cit_tmpl.tfc_tpg_attrib_cit.ct_attrs = NULL;
+	fabric->tf_cit_tmpl.tfc_tpg_param_cit.ct_attrs = NULL;
+	fabric->tf_cit_tmpl.tfc_tpg_np_base_cit.ct_attrs = NULL;
+	fabric->tf_cit_tmpl.tfc_tpg_nacl_base_cit.ct_attrs =
 						    ft_nacl_base_attrs;
-	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_attrib_cit.ct_attrs = NULL;
-	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_auth_cit.ct_attrs = NULL;
-	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_param_cit.ct_attrs = NULL;
+	fabric->tf_cit_tmpl.tfc_tpg_nacl_attrib_cit.ct_attrs = NULL;
+	fabric->tf_cit_tmpl.tfc_tpg_nacl_auth_cit.ct_attrs = NULL;
+	fabric->tf_cit_tmpl.tfc_tpg_nacl_param_cit.ct_attrs = NULL;
 	/*
 	 * register the fabric for use within TCM
 	 */
diff --git a/drivers/usb/gadget/tcm_usb_gadget.c b/drivers/usb/gadget/tcm_usb_gadget.c
index 0ff3339..9d89905 100644
--- a/drivers/usb/gadget/tcm_usb_gadget.c
+++ b/drivers/usb/gadget/tcm_usb_gadget.c
@@ -1923,15 +1923,15 @@ static int usbg_register_configfs(void)
 	}
 
 	fabric->tf_ops = usbg_ops;
-	TF_CIT_TMPL(fabric)->tfc_wwn_cit.ct_attrs = usbg_wwn_attrs;
-	TF_CIT_TMPL(fabric)->tfc_tpg_base_cit.ct_attrs = usbg_base_attrs;
-	TF_CIT_TMPL(fabric)->tfc_tpg_attrib_cit.ct_attrs = NULL;
-	TF_CIT_TMPL(fabric)->tfc_tpg_param_cit.ct_attrs = NULL;
-	TF_CIT_TMPL(fabric)->tfc_tpg_np_base_cit.ct_attrs = NULL;
-	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_base_cit.ct_attrs = NULL;
-	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_attrib_cit.ct_attrs = NULL;
-	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_auth_cit.ct_attrs = NULL;
-	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_param_cit.ct_attrs = NULL;
+	fabric->tf_cit_tmpl.tfc_wwn_cit.ct_attrs = usbg_wwn_attrs;
+	fabric->tf_cit_tmpl.tfc_tpg_base_cit.ct_attrs = usbg_base_attrs;
+	fabric->tf_cit_tmpl.tfc_tpg_attrib_cit.ct_attrs = NULL;
+	fabric->tf_cit_tmpl.tfc_tpg_param_cit.ct_attrs = NULL;
+	fabric->tf_cit_tmpl.tfc_tpg_np_base_cit.ct_attrs = NULL;
+	fabric->tf_cit_tmpl.tfc_tpg_nacl_base_cit.ct_attrs = NULL;
+	fabric->tf_cit_tmpl.tfc_tpg_nacl_attrib_cit.ct_attrs = NULL;
+	fabric->tf_cit_tmpl.tfc_tpg_nacl_auth_cit.ct_attrs = NULL;
+	fabric->tf_cit_tmpl.tfc_tpg_nacl_param_cit.ct_attrs = NULL;
 	ret = target_fabric_configfs_register(fabric);
 	if (ret < 0) {
 		printk(KERN_ERR "target_fabric_configfs_register() failed"
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 8e8788e..4cdd946 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -2150,15 +2150,15 @@ static int tcm_vhost_register_configfs(void)
 	/*
 	 * Setup default attribute lists for various fabric->tf_cit_tmpl
 	 */
-	TF_CIT_TMPL(fabric)->tfc_wwn_cit.ct_attrs = tcm_vhost_wwn_attrs;
-	TF_CIT_TMPL(fabric)->tfc_tpg_base_cit.ct_attrs = tcm_vhost_tpg_attrs;
-	TF_CIT_TMPL(fabric)->tfc_tpg_attrib_cit.ct_attrs = NULL;
-	TF_CIT_TMPL(fabric)->tfc_tpg_param_cit.ct_attrs = NULL;
-	TF_CIT_TMPL(fabric)->tfc_tpg_np_base_cit.ct_attrs = NULL;
-	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_base_cit.ct_attrs = NULL;
-	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_attrib_cit.ct_attrs = NULL;
-	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_auth_cit.ct_attrs = NULL;
-	TF_CIT_TMPL(fabric)->tfc_tpg_nacl_param_cit.ct_attrs = NULL;
+	fabric->tf_cit_tmpl.tfc_wwn_cit.ct_attrs = tcm_vhost_wwn_attrs;
+	fabric->tf_cit_tmpl.tfc_tpg_base_cit.ct_attrs = tcm_vhost_tpg_attrs;
+	fabric->tf_cit_tmpl.tfc_tpg_attrib_cit.ct_attrs = NULL;
+	fabric->tf_cit_tmpl.tfc_tpg_param_cit.ct_attrs = NULL;
+	fabric->tf_cit_tmpl.tfc_tpg_np_base_cit.ct_attrs = NULL;
+	fabric->tf_cit_tmpl.tfc_tpg_nacl_base_cit.ct_attrs = NULL;
+	fabric->tf_cit_tmpl.tfc_tpg_nacl_attrib_cit.ct_attrs = NULL;
+	fabric->tf_cit_tmpl.tfc_tpg_nacl_auth_cit.ct_attrs = NULL;
+	fabric->tf_cit_tmpl.tfc_tpg_nacl_param_cit.ct_attrs = NULL;
 	/*
 	 * Register the fabric for use within TCM
 	 */
diff --git a/include/target/target_core_configfs.h b/include/target/target_core_configfs.h
index 713c500..e080138 100644
--- a/include/target/target_core_configfs.h
+++ b/include/target/target_core_configfs.h
@@ -54,4 +54,3 @@ struct target_fabric_configfs {
 	struct target_fabric_configfs_template tf_cit_tmpl;
 };
 
-#define TF_CIT_TMPL(tf) (&(tf)->tf_cit_tmpl)
-- 
1.7.1

