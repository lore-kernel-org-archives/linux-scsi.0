From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 3/3] [TCM_Loop/ConfigFS]: Convert layout to use generic configfs struct config_item_types
Date: Mon, 22 Feb 2010 17:04:20 -0800
Message-ID: <1266887060-3875-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp107.sbc.mail.gq1.yahoo.com ([67.195.14.110]:35648 "HELO
	smtp107.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753569Ab0BWBLE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Feb 2010 20:11:04 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts the TCM_Loop virtual SAS fabric module configfs code in tcm_loop_configfs.c
to use the new generic configfs infrastructure provied in target_core_fabric_configfs.c.  With this
patch tcm_loop_configfs.c no longer defines it's own static struct config_item_type's, and uses
the generic 'cits' hanging off struct target_fabric_configfs->tf_cit_tmpl. The following changes in
tcm_loop_register_configfs() shows the adapted fabric API functions, and how local static
attribute structures are setup to hang off the generic fabric cits.

       /*
        * Setup function pointers for generic logic in target_core_fabric_configfs.c
        */
       fabric->tf_ops.fabric_make_wwn = &tcm_loop_make_scsi_hba;
       fabric->tf_ops.fabric_drop_wwn = &tcm_loop_drop_scsi_hba;
       fabric->tf_ops.fabric_make_tpg = &tcm_loop_make_naa_tpg;
       fabric->tf_ops.fabric_drop_tpg = &tcm_loop_drop_naa_tpg;
       /*
        * fabric_post_link() and fabric_pre_unlink() are used for
        * registration and release of TCM Loop Virtual SCSI LUNs.
        */
       fabric->tf_ops.fabric_post_link = &tcm_loop_port_link;
       fabric->tf_ops.fabric_pre_unlink = &tcm_loop_port_unlink;
       fabric->tf_ops.fabric_make_np = NULL;
       fabric->tf_ops.fabric_drop_np = NULL;
       /*
        * Setup default attribute lists for various fabric->tf_cit_tmpl
        */
       TF_CIT_TMPL(fabric)->tfc_wwn_cit.ct_attrs = tcm_loop_wwn_attrs;
       TF_CIT_TMPL(fabric)->tfc_tpg_base_cit.ct_attrs = tcm_loop_tpg_attrs;
       TF_CIT_TMPL(fabric)->tfc_tpg_attrib_cit.ct_attrs = NULL;
       TF_CIT_TMPL(fabric)->tfc_tpg_param_cit.ct_attrs = NULL;
       TF_CIT_TMPL(fabric)->tfc_tpg_np_base_cit.ct_attrs = NULL;
       /*

The existing TCM_Loop v3.x fabric layout of /sys/kernel/config/target/loopback/$NAA_WWN/tpgt_$TPGT/
is up and running with this patch.  The one notable change between this patch
and existing TCM_Loop v3.x code is using a TF_TPG_BASE_ATTR() define for
loopback/$NAA_WWN/tpgt_$TPG/nexus and echoing in the SAS Initiator Port WWN to create
the virtual SAS I_T Nexus in a TCM session, instead of having a seperate 'nexus' default
group under struct tcm_loop_tpg.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/tcm_loop/tcm_loop_configfs.c    |  435 +++++++++---------------
 drivers/target/tcm_loop/tcm_loop_core.h        |   18 +-
 drivers/target/tcm_loop/tcm_loop_fabric_scsi.c |    2 +-
 3 files changed, 165 insertions(+), 290 deletions(-)

diff --git a/drivers/target/tcm_loop/tcm_loop_configfs.c b/drivers/target/tcm_loop/tcm_loop_configfs.c
index c4e4403..0f52e24 100644
--- a/drivers/target/tcm_loop/tcm_loop_configfs.c
+++ b/drivers/target/tcm_loop/tcm_loop_configfs.c
@@ -4,10 +4,10 @@
  * This file contains the configfs implementation for TCM_Loop Virtual SAS
  * target to Linux/SCSI SAS initiator node
  *
- * Copyright (c) 2009 Rising Tide, Inc.
- * Copyright (c) 2009 Linux-iSCSI.org
+ * Copyright (c) 2009, 2010 Rising Tide, Inc.
+ * Copyright (c) 2009, 2010 Linux-iSCSI.org
  *
- * Copyright (c) 2009 Nicholas A. Bellinger <nab@linux-iscsi.org>
+ * Copyright (c) 2009, 2010 Nicholas A. Bellinger <nab@linux-iscsi.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -39,6 +39,7 @@
 #include <target/target_core_base.h>
 #include <target/target_core_transport.h>
 #include <target/target_core_fabric_ops.h>
+#include <target/target_core_fabric_configfs.h>
 #include <target/target_core_device.h>
 #include <target/target_core_tpg.h>
 #include <target/target_core_configfs.h>
@@ -59,63 +60,32 @@ static int tcm_loop_hba_no_cnt;
 
 /* Start items for tcm_loop_port_cit */
 
-static int tcm_loop_port_link(
-	struct config_item *tl_lun_ci,
-	struct config_item *se_dev_ci)
+int tcm_loop_port_link(
+	struct se_portal_group_s *se_tpg,
+	struct se_lun_s *lun)
 {
-	se_lun_t *lun = container_of(to_config_group(tl_lun_ci),
-				se_lun_t, lun_group);
-	se_lun_t *lun_p;
-	se_portal_group_t *se_tpg;
-	struct config_item *tpg_ci;
-	struct tcm_loop_hba *tl_hba;
-	struct tcm_loop_tpg *tl_tpg;
-	se_subsystem_dev_t *se_sub_dev = container_of(
-		to_config_group(se_dev_ci), se_subsystem_dev_t, se_dev_group);
-
-	tpg_ci = &tl_lun_ci->ci_parent->ci_group->cg_item;
-	if (!(tpg_ci)) {
-		printk(KERN_ERR "Unable to locate config_item tpg_ci\n");
-		return -EINVAL;
-	}
-	se_tpg = container_of(to_config_group(tpg_ci),
-				se_portal_group_t, tpg_group);
-	tl_tpg = (struct tcm_loop_tpg *)se_tpg->se_tpg_fabric_ptr;
-	tl_hba = tl_tpg->tl_hba;
+	struct tcm_loop_tpg *tl_tpg = container_of(se_tpg,
+				struct tcm_loop_tpg, tl_se_tpg);
+	struct tcm_loop_hba *tl_hba = tl_tpg->tl_hba;
 
-	lun_p = core_dev_add_lun(se_tpg,
-			se_sub_dev->se_dev_hba,
-			se_sub_dev->se_dev_ptr, lun->unpacked_lun);
-	if (IS_ERR(lun_p) || !(lun_p)) {
-		printk(KERN_ERR "core_dev_add_lun() failed\n");
-		return -EINVAL;
-	}
-	printk(KERN_INFO "TCM_Loop_ConfigFS: Port Link Successful\n");
 	/*
 	 * Add Linux/SCSI struct scsi_device by HCTL
 	 */
 	scsi_add_device(tl_hba->sh, 0, tl_tpg->tl_tpgt, lun->unpacked_lun);
+
+	printk(KERN_INFO "TCM_Loop_ConfigFS: Port Link Successful\n");
 	return 0;
 }
 
-static int tcm_loop_port_unlink(
-	struct config_item *tl_lun_ci,
-	struct config_item *se_dev_ci)
+void tcm_loop_port_unlink(
+	struct se_portal_group_s *se_tpg,
+	struct se_lun_s *se_lun)
 {
-	se_lun_t *se_lun;
-	se_portal_group_t *se_tpg;
-	struct config_item *tpg_ci;
 	struct scsi_device *sd;
 	struct tcm_loop_hba *tl_hba;
 	struct tcm_loop_tpg *tl_tpg;
 
-	se_lun = container_of(to_config_group(tl_lun_ci), struct se_lun_s,
-			lun_group);
-
-	tpg_ci = &tl_lun_ci->ci_parent->ci_group->cg_item;
-	se_tpg = container_of(to_config_group(tpg_ci),
-				se_portal_group_t, tpg_group);
-	tl_tpg = (struct tcm_loop_tpg *)se_tpg->se_tpg_fabric_ptr;
+	tl_tpg = container_of(se_tpg, struct tcm_loop_tpg, tl_se_tpg);
 	tl_hba = tl_tpg->tl_hba;	
 
 	sd = scsi_device_lookup(tl_hba->sh, 0, tl_tpg->tl_tpgt,
@@ -123,7 +93,7 @@ static int tcm_loop_port_unlink(
 	if (!(sd)) {
 		printk(KERN_ERR "Unable to locate struct scsi_device for %d:%d:"
 			"%d\n", 0, tl_tpg->tl_tpgt, se_lun->unpacked_lun);
-		return -EINVAL;	
+		return;
 	}
 	/*
 	 * Remove Linux/SCSI struct scsi_device by HCTL
@@ -131,108 +101,30 @@ static int tcm_loop_port_unlink(
 	scsi_remove_device(sd);	
 	scsi_device_put(sd);
 
-	core_dev_del_lun(se_tpg, se_lun->unpacked_lun);
 	printk(KERN_INFO "TCM_Loop_ConfigFS: Port Unlink Successful\n");
-	return 0;
 }
 
-static struct configfs_item_operations tcm_loop_port_item_ops = {
-	.allow_link		= &tcm_loop_port_link,
-	.drop_link		= &tcm_loop_port_unlink,
-};
-
-static struct config_item_type tcm_loop_port_cit = {
-	.ct_item_ops		= &tcm_loop_port_item_ops,
-	.ct_group_ops		= NULL,
-	.ct_attrs		= NULL,
-	.ct_owner		= THIS_MODULE,			
-};
-
 /* End items for tcm_loop_port_cit */
 
-/* Start items for tcm_loop_lun_cit */
-
-static struct config_group *tcm_loop_make_lun(
-	struct config_group *group,
-	const char *name)
-{
-	se_lun_t *lun;
-	struct tcm_loop_tpg *tl_tpg;	
-	char *str, *endptr;
-	u32 lun_id;
-
-	str = strstr(name, "_");
-	if (!(str)) {
-		printk(KERN_ERR "Unable to locate \'_\" in"
-				" \"lun_$LUN_NUMBER\"\n");
-		return ERR_PTR(-EINVAL);
-	}
-	str++; /* Advance over _ delim.. */
-	lun_id = simple_strtoul(str, &endptr, 0);
-	tl_tpg = container_of(group, struct tcm_loop_tpg,
-			tl_tpg_lun_group);
-
-	lun = core_get_lun_from_tpg(tl_tpg->tl_se_tpg, lun_id);
-	if (!(lun))
-		return ERR_PTR(-EINVAL);
-
-	config_group_init_type_name(&lun->lun_group, name,
-			&tcm_loop_port_cit);
-
-	return &lun->lun_group;
-}
-
-static void tcm_loop_drop_lun(
-	struct config_group *group,
-	struct config_item *item)
-{
-	config_item_put(item);
-	return;
-}
-
-static struct configfs_group_operations tcm_loop_lun_group_ops = {
-	.make_group		= &tcm_loop_make_lun,
-	.drop_item		= &tcm_loop_drop_lun,
-};
-
-static struct config_item_type tcm_loop_lun_cit = {
-	.ct_item_ops		= NULL,
-	.ct_group_ops		= &tcm_loop_lun_group_ops,
-	.ct_attrs		= NULL,
-	.ct_owner		= THIS_MODULE,
-};
-
-/* End items for tcm_loop_lun_cit */
-
-/* Start items for tcm_loop_iport_cit */
-
-static struct config_item_type tcm_loop_iport_cit = {
-	.ct_item_ops		= NULL,
-	.ct_group_ops		= NULL,
-	.ct_attrs		= NULL,
-	.ct_owner		= THIS_MODULE,
-};
-
-/* End items for tcm_loop_iport_cit */
-
 /* Start items for tcm_loop_nexus_cit */
 
-static struct config_group *tcm_loop_make_nexus(
-	struct config_group *group,
+static int tcm_loop_make_nexus(
+	struct tcm_loop_tpg *tl_tpg,
 	const char *name)
 {
 	se_portal_group_t *se_tpg;
 	struct tcm_loop_nexus *tl_nexus;
-	struct tcm_loop_tpg *tl_tpg;
 
-	tl_tpg = container_of(group, struct tcm_loop_tpg,
-			tl_tpg_nexus_group);
-	se_tpg = tl_tpg->tl_se_tpg;
+	if (tl_tpg->tl_hba->tl_nexus) {
+		printk(KERN_INFO "tl_tpg->tl_hba->tl_nexus already exists\n");
+		return -EEXIST;
+	}
+	se_tpg = &tl_tpg->tl_se_tpg;
 
 	tl_nexus = kzalloc(sizeof(struct tcm_loop_nexus), GFP_KERNEL);
 	if (!(tl_nexus)) {
 		printk(KERN_ERR "Unable to allocate struct tcm_loop_nexus\n");
-		return NULL;
+		return -ENOMEM;
 	}
 	tl_tpg->tl_hba->tl_nexus = tl_nexus;
 	/*
@@ -259,74 +151,118 @@ static struct config_group *tcm_loop_make_nexus(
 	__transport_register_session(se_tpg, tl_nexus->se_sess->se_node_acl,
 			tl_nexus->se_sess, (void *)tl_nexus);
 
-	config_group_init_type_name(&tl_nexus->tl_iport_group, name,
-				&tcm_loop_iport_cit);
-
 	printk(KERN_INFO "TCM_Loop_ConfigFS: Established I_T Nexus to emulated"
 			" SAS Initiator Port: %s\n", name);
-	return &tl_nexus->tl_iport_group;
+	return 0;
 
 out:
 	kfree(tl_nexus);	
-	return NULL;
+	return -ENOMEM;
 }
 
 static void tcm_loop_drop_nexus(
-	struct config_group *group,
-	struct config_item *item)
+	struct tcm_loop_tpg *tpg)
 {
 	struct tcm_loop_nexus *tl_nexus;
-	struct config_item *tcm_loop_dev_ci;
 
-	tcm_loop_dev_ci = &group->cg_item;
-	tl_nexus = container_of(to_config_group(item),
-			struct tcm_loop_nexus, tl_iport_group);
+	tl_nexus = tpg->tl_hba->tl_nexus;
+	if (!(tl_nexus))
+		return;
 
 	printk(KERN_INFO "TCM_Loop_ConfigFS: Removing I_T Nexus to emulated"
-		" SAS Initiator Port: %s\n", config_item_name(item));
+		" SAS Initiator Port: %s\n",
+		tl_nexus->se_sess->se_node_acl->initiatorname);
 	/*
 	 * Release the SCSI I_T Nexus to the emulated SAS Target Port
 	 */
 	transport_deregister_session(tl_nexus->se_sess);
+	tpg->tl_hba->tl_nexus = NULL;
 	kfree(tl_nexus);
-
-	config_item_put(item);
 }
 
-static struct configfs_group_operations tcm_loop_nexus_group_ops = {
-	.make_group		= &tcm_loop_make_nexus,
-	.drop_item		= &tcm_loop_drop_nexus,
-};
+/* End items for tcm_loop_nexus_cit */
 
-static struct config_item_type tcm_loop_nexus_cit = {
-	.ct_item_ops		= NULL,
-	.ct_group_ops		= &tcm_loop_nexus_group_ops,
-	.ct_attrs		= NULL,
-	.ct_owner		= THIS_MODULE,
-};
+static ssize_t tcm_loop_tpg_show_nexus(
+	struct se_portal_group_s *se_tpg,
+	char *page)
+{
+	struct tcm_loop_tpg *tl_tpg = container_of(se_tpg,
+			struct tcm_loop_tpg, tl_se_tpg);
+	struct tcm_loop_nexus *tl_nexus;
+	ssize_t ret;
 
-/* End items for tcm_loop_nexus_cit */
+	tl_nexus = tl_tpg->tl_hba->tl_nexus;
+	if (!(tl_nexus))
+		return -ENODEV;
 
-/* Start items for tcm_loop_tpg_cit */
+	ret = snprintf(page, PAGE_SIZE, "%s",
+		tl_nexus->se_sess->se_node_acl->initiatorname);
 
-static struct config_item_type tcm_loop_tpg_cit = {
-	.ct_item_ops		= NULL,
-	.ct_group_ops		= NULL,
-	.ct_attrs		= NULL,
-	.ct_owner		= THIS_MODULE,
-};
+	return ret;
+}
 
-/* End items for tcm_loop_tpg_cit */
+static ssize_t tcm_loop_tpg_store_nexus(
+	struct se_portal_group_s *se_tpg,
+	const char *page,
+	size_t count)
+{
+	struct tcm_loop_tpg *tl_tpg = container_of(se_tpg,
+			struct tcm_loop_tpg, tl_se_tpg);
+	unsigned char i_port[TL_NAA_SAS_ADDR_LEN], *ptr;
+	int ret;
+	/*
+	 * Shutdown the active I_T nexus if 'NULL' is passed..
+	 */
+	if (!(strncmp(page, "NULL", 4))) {
+		tcm_loop_drop_nexus(tl_tpg);
+		return count;
+	}
+	/*
+	 * Otherwise validate the passed NAA WWN for the virtual SAS
+	 * Initiator port, and call tcm_loop_make_nexus()
+	 */
+	if (strlen(page) > TL_NAA_SAS_ADDR_LEN) {
+		printk(KERN_ERR "Emulated NAA Sas Address: %s, exceeds"
+			" max: %d\n", page, TL_NAA_SAS_ADDR_LEN);
+		return -EINVAL;
+	}
+	snprintf(&i_port[0], TL_NAA_SAS_ADDR_LEN, "%s", page);
+
+	ptr = strstr(i_port, "naa.");
+	if (!(ptr)) {
+		printk(KERN_ERR "Unable to locate \"naa.\" prefix for emulated"
+                        " SAS Initiator Port\n");
+		return -EINVAL;
+	}
+	/*
+	 * Clear any trailing newline for the NAA WWN
+	 */
+	if (i_port[strlen(i_port)-1] == '\n')
+		i_port[strlen(i_port)-1] = '\0';
+		
+	ret = tcm_loop_make_nexus(tl_tpg, i_port);
+	if (ret < 0)
+		return ret;
+
+	return count;
+}
+
+TF_TPG_BASE_ATTR(tcm_loop, nexus, S_IRUGO | S_IWUSR);
+
+static struct configfs_attribute *tcm_loop_tpg_attrs[] = {
+	&tcm_loop_tpg_nexus.attr,
+	NULL,
+};
 
 /* Start items for tcm_loop_naa_cit */
 
-static struct config_group *tcm_loop_make_naa_tpg(
+struct se_portal_group_s *tcm_loop_make_naa_tpg(
+	struct se_wwn_s *wwn,
 	struct config_group *group,
 	const char *name)
 {
-	struct config_group *tpg_cg;
-	struct tcm_loop_hba *tl_hba = container_of(group,
-			struct tcm_loop_hba, tl_hba_group);
+	struct tcm_loop_hba *tl_hba = container_of(wwn,
+			struct tcm_loop_hba, tl_hba_wwn);
 	struct tcm_loop_tpg *tl_tpg;
 	char *tpgt_str, *end_ptr;
 	int ret;
@@ -352,86 +288,54 @@ static struct config_group *tcm_loop_make_naa_tpg(
 	/*
 	 * Register the tl_tpg as a emulated SAS TCM Target Endpoint
 	 */
-	tl_tpg->tl_se_tpg = core_tpg_register(&tcm_loop_fabric_configfs->tf_ops,
-			(void *)tl_tpg, TRANSPORT_TPG_TYPE_NORMAL);
-	if (IS_ERR(tl_tpg->tl_se_tpg))
+	ret = core_tpg_register(&tcm_loop_fabric_configfs->tf_ops,
+			wwn, &tl_tpg->tl_se_tpg, (void *)tl_tpg,
+			TRANSPORT_TPG_TYPE_NORMAL);
+	if (ret < 0)
 		return ERR_PTR(-ENOMEM);
-	/*
-	 * Locate the pointer to the struct config_group that will be
-	 * registered below in order to setup the default groups.
-	 */
-	tpg_cg = &tl_tpg->tl_se_tpg->tpg_group;
 
-	tpg_cg->default_groups = kzalloc(sizeof(struct config_group) * 3,
-			GFP_KERNEL);
-	if (!(tpg_cg->default_groups)) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	config_group_init_type_name(&tl_tpg->tl_tpg_lun_group, "lun",
-			&tcm_loop_lun_cit);
-	config_group_init_type_name(&tl_tpg->tl_tpg_nexus_group, "nexus",
-			&tcm_loop_nexus_cit);
-	tpg_cg->default_groups[0] = &tl_tpg->tl_tpg_lun_group;
-	tpg_cg->default_groups[1] = &tl_tpg->tl_tpg_nexus_group;
-	tpg_cg->default_groups[2] = NULL;
-	
-	config_group_init_type_name(tpg_cg, name, &tcm_loop_tpg_cit);
 	printk(KERN_INFO "TCM_Loop_ConfigFS: Allocated Emulated SAS"
 		" Target Port %s,t,0x%04x\n",
-		config_item_name(&tl_hba->tl_hba_group.cg_item), tpgt);
+		config_item_name(&wwn->wwn_group.cg_item), tpgt);
 
-	return tpg_cg;
+	return &tl_tpg->tl_se_tpg;
 
 out:
-	if (tl_tpg->tl_se_tpg)
-		core_tpg_deregister(tl_tpg->tl_se_tpg);
+	core_tpg_deregister(&tl_tpg->tl_se_tpg);
 	return ERR_PTR(ret);
 }
 
-static void tcm_loop_drop_naa_tpg(
-	struct config_group *group,
-	struct config_item *item)
+void tcm_loop_drop_naa_tpg(
+	struct se_portal_group_s *se_tpg)
 {
-	se_portal_group_t *se_tpg = container_of(to_config_group(item),
-				struct se_portal_group_s, tpg_group);
-	struct tcm_loop_tpg *tl_tpg;
+	struct se_wwn_s *wwn = se_tpg->se_tpg_wwn;
+	struct tcm_loop_tpg *tl_tpg = container_of(se_tpg,
+				struct tcm_loop_tpg, tl_se_tpg);
 	struct tcm_loop_hba *tl_hba;
 	unsigned short tpgt;
 
-	tl_tpg = (struct tcm_loop_tpg *)se_tpg->se_tpg_fabric_ptr;
 	tl_hba = tl_tpg->tl_hba;
 	tpgt = tl_tpg->tl_tpgt;
 	/*
+	 * Release the I_T Nexus for the Virtual SAS link if present
+	 */
+	tcm_loop_drop_nexus(tl_tpg);
+	/*
 	 * Deregister the tl_tpg as a emulated SAS TCM Target Endpoint
 	 */
 	core_tpg_deregister(se_tpg);
 
 	printk(KERN_INFO "TCM_Loop_ConfigFS: Deallocated Emulated SAS"
 		" Target Port %s,t,0x%04x\n",
-		config_item_name(&tl_hba->tl_hba_group.cg_item), tpgt);
-
-	config_item_put(item);
+		config_item_name(&wwn->wwn_group.cg_item), tpgt);
 }
 
-static struct configfs_group_operations tcm_loop_naa_group_ops = {
-	.make_group		= &tcm_loop_make_naa_tpg,
-	.drop_item		= &tcm_loop_drop_naa_tpg,
-};
-
-static struct config_item_type tcm_loop_naa_cit = {
-	.ct_item_ops		= NULL,
-	.ct_group_ops		= &tcm_loop_naa_group_ops,
-	.ct_attrs		= NULL,
-	.ct_owner		= THIS_MODULE,
-};
-
 /* End items for tcm_loop_naa_cit */
 
 /* Start items for tcm_loop_cit */
 
-static struct config_group *tcm_loop_make_scsi_hba(
+struct se_wwn_s *tcm_loop_make_scsi_hba(
+	struct target_fabric_configfs *tf,
 	struct config_group *group,
 	const char *name)
 {
@@ -504,37 +408,24 @@ static struct config_group *tcm_loop_make_scsi_hba(
 	}
 	wait_for_completion(&tl_hba->tl_hba_qobj->thread_create_comp);
 
-	tl_hba_ci = &tl_hba->tl_hba_group.cg_item;
-	config_group_init_type_name(&tl_hba->tl_hba_group, name,
-				&tcm_loop_naa_cit);
-
 	tcm_loop_hba_no_cnt++;
 	printk(KERN_INFO "TCM_Loop_ConfigFS: Allocated emulated Target"
 		" SAS Address: %s at Linux/SCSI Host ID: %d\n",
-			config_item_name(tl_hba_ci), sh->host_no);
-
-	return &tl_hba->tl_hba_group;
+			name, sh->host_no);
 
+	return &tl_hba->tl_hba_wwn;
 out:
 	kfree(tl_hba->tl_hba_qobj);
 	kfree(tl_hba);
 	return ERR_PTR(ret);
 }
 
-static void tcm_loop_drop_scsi_hba(
-	struct config_group *group,
-	struct config_item *item)
+void tcm_loop_drop_scsi_hba(
+	struct se_wwn_s *wwn)
 {
-	struct tcm_loop_hba *tl_hba;
-	int host_no;
-
-	tl_hba = container_of(to_config_group(item),
-			struct tcm_loop_hba, tl_hba_group);
-	if (!(tl_hba)) {
-		printk(KERN_ERR "Unable to locate struct tcm_loop_hba\n");
-		return;
-	}
-	host_no = tl_hba->sh->host_no;
+	struct tcm_loop_hba *tl_hba = container_of(wwn,
+				struct tcm_loop_hba, tl_hba_wwn);
+	int host_no = tl_hba->sh->host_no;
 
 	/*
 	 * Shutdown the per HBA tcm_loop processing kthread
@@ -550,17 +441,12 @@ static void tcm_loop_drop_scsi_hba(
 
 	printk(KERN_INFO "TCM_Loop_ConfigFS: Deallocated emulated Target"
 		" SAS Address: %s at Linux/SCSI Host ID: %d\n",
-			config_item_name(item), host_no);
-	/*
-	 * Make last configfs callback to release struct config_item
-	 */
-	config_item_put(item);
+		config_item_name(&wwn->wwn_group.cg_item), host_no);
 }
 
 /* Start items for tcm_loop_cit */
-static ssize_t tcm_loop_attr_version(
-	struct config_item *item,
-	struct configfs_attribute *attr,
+static ssize_t tcm_loop_wwn_show_attr_version(
+	struct target_fabric_configfs *tf,
 	char *page)
 {
 	return sprintf(page, "TCM Loopback Fabric module %s on %s/%s"
@@ -568,33 +454,13 @@ static ssize_t tcm_loop_attr_version(
 		utsname()->machine);
 }
 
-static struct configfs_item_operations tcm_loop_item_ops = {
-	.show_attribute	= &tcm_loop_attr_version,
-};
-
-static struct configfs_attribute tcm_loop_item_attr_version = {
-	.ca_owner	= THIS_MODULE,
-	.ca_name	= "version",
-	.ca_mode	= S_IRUGO,
-};
-
-static struct configfs_group_operations tcm_loop_hba_group_ops = {
-	.make_group	= &tcm_loop_make_scsi_hba,
-	.drop_item	= &tcm_loop_drop_scsi_hba,
-};
+TF_WWN_ATTR_RO(tcm_loop, version);
 
-static struct configfs_attribute *tcm_loop_attrs[] = {
-	&tcm_loop_item_attr_version,
+static struct configfs_attribute *tcm_loop_wwn_attrs[] = {
+	&tcm_loop_wwn_version.attr,
 	NULL,
 };
 
-static struct config_item_type tcm_loop_cit = {
-	.ct_item_ops	= &tcm_loop_item_ops,
-	.ct_group_ops	= &tcm_loop_hba_group_ops,
-	.ct_attrs	= tcm_loop_attrs,
-	.ct_owner	= THIS_MODULE,
-};
-
 /* End items for tcm_loop_cit */
 
 int tcm_loop_register_configfs(void)
@@ -609,7 +475,7 @@ int tcm_loop_register_configfs(void)
 	/*
 	 * Register the top level struct config_item_type with TCM core
 	 */
-	fabric = target_fabric_configfs_init(&tcm_loop_cit, "loopback");
+	fabric = target_fabric_configfs_init(THIS_MODULE, "loopback");
 	if (!(fabric)) {
 		printk(KERN_ERR "tcm_loop_register_configfs() failed!\n");
 		return -1;
@@ -685,6 +551,29 @@ int tcm_loop_register_configfs(void)
 	fabric->reg_default_groups_callback = NULL;
 	tf_cg = &fabric->tf_group;
 	/*
+	 * Setup function pointers for generic logic in target_core_fabric_configfs.c
+	 */
+	fabric->tf_ops.fabric_make_wwn = &tcm_loop_make_scsi_hba;
+	fabric->tf_ops.fabric_drop_wwn = &tcm_loop_drop_scsi_hba;
+	fabric->tf_ops.fabric_make_tpg = &tcm_loop_make_naa_tpg;
+	fabric->tf_ops.fabric_drop_tpg = &tcm_loop_drop_naa_tpg;
+	/*
+	 * fabric_post_link() and fabric_pre_unlink() are used for
+	 * registration and release of TCM Loop Virtual SCSI LUNs.
+	 */
+	fabric->tf_ops.fabric_post_link = &tcm_loop_port_link;
+	fabric->tf_ops.fabric_pre_unlink = &tcm_loop_port_unlink;
+	fabric->tf_ops.fabric_make_np = NULL;
+	fabric->tf_ops.fabric_drop_np = NULL;
+	/*
+	 * Setup default attribute lists for various fabric->tf_cit_tmpl
+	 */
+	TF_CIT_TMPL(fabric)->tfc_wwn_cit.ct_attrs = tcm_loop_wwn_attrs;
+	TF_CIT_TMPL(fabric)->tfc_tpg_base_cit.ct_attrs = tcm_loop_tpg_attrs;
+	TF_CIT_TMPL(fabric)->tfc_tpg_attrib_cit.ct_attrs = NULL;
+	TF_CIT_TMPL(fabric)->tfc_tpg_param_cit.ct_attrs = NULL;
+	TF_CIT_TMPL(fabric)->tfc_tpg_np_base_cit.ct_attrs = NULL;
+	/*
 	 * Once fabric->tf_ops has been setup, now register the fabric for
 	 * use within TCM
 	 */
diff --git a/drivers/target/tcm_loop/tcm_loop_core.h b/drivers/target/tcm_loop/tcm_loop_core.h
index 762febe..9d876d5 100644
--- a/drivers/target/tcm_loop/tcm_loop_core.h
+++ b/drivers/target/tcm_loop/tcm_loop_core.h
@@ -30,30 +30,16 @@ struct tcm_loop_nexus {
 	 * Pointer to TCM session for I_T Nexus
 	 */
 	struct se_session_s *se_sess;
-	/*
-	 * Used to reference the emulated SAS Address for SCSI Initiator Port
-	 */
-	struct config_group tl_iport_group;
 };
 
 struct tcm_loop_nacl {
 	struct se_node_acl_s *se_nacl;
 };
 
-struct tcm_loop_dev {
-	struct se_device_s *se_dev;
-	struct scsi_device *sd;
-	struct tcm_loop_hba *tl_hba;
-	struct tcm_loop_nexus *tl_nexus;
-	struct config_group tl_dev_group;
-};
-
 struct tcm_loop_tpg {
 	unsigned short tl_tpgt;
-	struct se_portal_group_s *tl_se_tpg;
+	struct se_portal_group_s tl_se_tpg;
 	struct tcm_loop_hba *tl_hba;
-	struct config_group tl_tpg_lun_group;
-	struct config_group tl_tpg_nexus_group;
 };
 
 struct tcm_loop_hba {
@@ -68,5 +54,5 @@ struct tcm_loop_hba {
 	struct device dev;
 	struct Scsi_Host *sh;
 	struct tcm_loop_tpg tl_hba_tpgs[TL_TPGS_PER_HBA];
-	struct config_group tl_hba_group;
+	struct se_wwn_s tl_hba_wwn;
 };
diff --git a/drivers/target/tcm_loop/tcm_loop_fabric_scsi.c b/drivers/target/tcm_loop/tcm_loop_fabric_scsi.c
index 40743c4..1926043 100644
--- a/drivers/target/tcm_loop/tcm_loop_fabric_scsi.c
+++ b/drivers/target/tcm_loop/tcm_loop_fabric_scsi.c
@@ -324,7 +324,7 @@ static int tcm_loop_queuecommand(
 		return 0;	
 	}
 	tl_tpg = &tl_hba->tl_hba_tpgs[sc->device->id];
-	se_tpg = tl_tpg->tl_se_tpg;
+	se_tpg = &tl_tpg->tl_se_tpg;
 
 	if (sc->sc_data_direction == DMA_TO_DEVICE)
 		data_direction = SE_DIRECTION_WRITE;
-- 
1.5.6.5

