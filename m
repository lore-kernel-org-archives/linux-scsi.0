From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [RFC 19/22] target: Rename TPG register/deregister to target_* prefix
Date: Fri, 27 Mar 2015 08:05:09 +0000
Message-ID: <1427443512-8925-20-git-send-email-nab@daterainc.com>
References: <1427443512-8925-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:36621 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637AbbC0IGa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Mar 2015 04:06:30 -0400
Received: by obbld8 with SMTP id ld8so13554793obb.3
        for <linux-scsi@vger.kernel.org>; Fri, 27 Mar 2015 01:06:30 -0700 (PDT)
In-Reply-To: <1427443512-8925-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This includes:

  - target_register_tpg
  - target_deregister_tpg

This includes updates for loopback, tcm_fc, iscsi/iser-target,
ib_srpt, sbp-target, usb-gadget, tcm_qla2xxx, vhost-scsi and
xen-scsiback.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c        |  7 ++++---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c           | 10 +++++-----
 drivers/target/iscsi/iscsi_target_configfs.c |  4 ++--
 drivers/target/iscsi/iscsi_target_tpg.c      |  8 ++++----
 drivers/target/loopback/tcm_loop.c           |  8 ++++----
 drivers/target/sbp/sbp_target.c              |  8 ++++----
 drivers/target/target_core_tpg.c             |  8 ++++----
 drivers/target/tcm_fc/tfc_conf.c             |  6 +++---
 drivers/usb/gadget/legacy/tcm_usb_gadget.c   |  8 ++++----
 drivers/vhost/scsi.c                         |  6 +++---
 drivers/xen/xen-scsiback.c                   |  6 +++---
 include/target/target_core_fabric.h          |  4 ++--
 12 files changed, 42 insertions(+), 41 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index c2f833d..f4f0853 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -3851,8 +3851,9 @@ static struct se_portal_group *srpt_make_tpg(struct se_wwn *wwn,
 	int res;
 
 	/* Initialize sport->port_wwn and sport->port_tpg_1 */
-	res = core_tpg_register(&srpt_target->tf_ops, &sport->port_wwn,
-			&sport->port_tpg_1, sport, TRANSPORT_TPG_TYPE_NORMAL);
+	res = target_register_tpg(&srpt_target->tf_ops, &sport->port_wwn,
+				  &sport->port_tpg_1, sport,
+				  TRANSPORT_TPG_TYPE_NORMAL);
 	if (res)
 		return ERR_PTR(res);
 
@@ -3869,7 +3870,7 @@ static void srpt_drop_tpg(struct se_portal_group *tpg)
 				struct srpt_port, port_tpg_1);
 
 	sport->enabled = false;
-	core_tpg_deregister(&sport->port_tpg_1);
+	target_deregister_tpg(&sport->port_tpg_1);
 }
 
 /**
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index e29515b..e9f67ef 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -1124,8 +1124,8 @@ static struct se_portal_group *tcm_qla2xxx_make_tpg(
 	tpg->tpg_attrib.cache_dynamic_acls = 1;
 	tpg->tpg_attrib.demo_mode_login_only = 1;
 
-	ret = core_tpg_register(&tcm_qla2xxx_fabric_configfs->tf_ops, wwn,
-				&tpg->se_tpg, tpg, TRANSPORT_TPG_TYPE_NORMAL);
+	ret = target_register_tpg(&tcm_qla2xxx_fabric_configfs->tf_ops, wwn,
+				  &tpg->se_tpg, tpg, TRANSPORT_TPG_TYPE_NORMAL);
 	if (ret < 0) {
 		kfree(tpg);
 		return NULL;
@@ -1149,7 +1149,7 @@ static void tcm_qla2xxx_drop_tpg(struct se_portal_group *se_tpg)
 	if (vha->vha_tgt.qla_tgt && !vha->vha_tgt.qla_tgt->tgt_stop)
 		qlt_stop_phase1(vha->vha_tgt.qla_tgt);
 
-	core_tpg_deregister(se_tpg);
+	target_deregister_tpg(se_tpg);
 	/*
 	 * Clear local TPG=1 pointer for non NPIV mode.
 	 */
@@ -1244,8 +1244,8 @@ static struct se_portal_group *tcm_qla2xxx_npiv_make_tpg(
 	tpg->tpg_attrib.cache_dynamic_acls = 1;
 	tpg->tpg_attrib.demo_mode_login_only = 1;
 
-	ret = core_tpg_register(&tcm_qla2xxx_npiv_fabric_configfs->tf_ops, wwn,
-				&tpg->se_tpg, tpg, TRANSPORT_TPG_TYPE_NORMAL);
+	ret = target_register_tpg(&tcm_qla2xxx_npiv_fabric_configfs->tf_ops, wwn,
+				  &tpg->se_tpg, tpg, TRANSPORT_TPG_TYPE_NORMAL);
 	if (ret < 0) {
 		kfree(tpg);
 		return NULL;
diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index 167782a..4cafb76 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -1449,7 +1449,7 @@ static struct se_portal_group *lio_target_tiqn_addtpg(
 	if (!tpg)
 		return NULL;
 
-	ret = core_tpg_register(
+	ret = target_register_tpg(
 			&lio_target_fabric_configfs->tf_ops,
 			wwn, &tpg->tpg_se_tpg, tpg,
 			TRANSPORT_TPG_TYPE_NORMAL);
@@ -1465,7 +1465,7 @@ static struct se_portal_group *lio_target_tiqn_addtpg(
 			name);
 	return &tpg->tpg_se_tpg;
 out:
-	core_tpg_deregister(&tpg->tpg_se_tpg);
+	target_deregister_tpg(&tpg->tpg_se_tpg);
 	kfree(tpg);
 	return NULL;
 }
diff --git a/drivers/target/iscsi/iscsi_target_tpg.c b/drivers/target/iscsi/iscsi_target_tpg.c
index 4ebc20b..e1b93582 100644
--- a/drivers/target/iscsi/iscsi_target_tpg.c
+++ b/drivers/target/iscsi/iscsi_target_tpg.c
@@ -68,7 +68,7 @@ int iscsit_load_discovery_tpg(void)
 		return -1;
 	}
 
-	ret = core_tpg_register(
+	ret = target_register_tpg(
 			&lio_target_fabric_configfs->tf_ops,
 			NULL, &tpg->tpg_se_tpg, tpg,
 			TRANSPORT_TPG_TYPE_DISCOVERY);
@@ -107,7 +107,7 @@ int iscsit_load_discovery_tpg(void)
 	return 0;
 out:
 	if (tpg->sid == 1)
-		core_tpg_deregister(&tpg->tpg_se_tpg);
+		target_deregister_tpg(&tpg->tpg_se_tpg);
 	kfree(tpg);
 	return -1;
 }
@@ -119,7 +119,7 @@ void iscsit_release_discovery_tpg(void)
 	if (!tpg)
 		return;
 
-	core_tpg_deregister(&tpg->tpg_se_tpg);
+	target_deregister_tpg(&tpg->tpg_se_tpg);
 
 	kfree(tpg);
 	iscsit_global->discovery_tpg = NULL;
@@ -289,7 +289,7 @@ int iscsit_tpg_del_portal_group(
 		tpg->param_list = NULL;
 	}
 
-	core_tpg_deregister(&tpg->tpg_se_tpg);
+	target_deregister_tpg(&tpg->tpg_se_tpg);
 
 	spin_lock(&tpg->tpg_state_lock);
 	tpg->tpg_state = TPG_STATE_FREE;
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index b271624..a05b86c 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -1234,9 +1234,9 @@ static struct se_portal_group *tcm_loop_make_naa_tpg(
 	/*
 	 * Register the tl_tpg as a emulated SAS TCM Target Endpoint
 	 */
-	ret = core_tpg_register(&tcm_loop_fabric_configfs->tf_ops,
-			wwn, &tl_tpg->tl_se_tpg, tl_tpg,
-			TRANSPORT_TPG_TYPE_NORMAL);
+	ret = target_register_tpg(&tcm_loop_fabric_configfs->tf_ops,
+				  wwn, &tl_tpg->tl_se_tpg, tl_tpg,
+				  TRANSPORT_TPG_TYPE_NORMAL);
 	if (ret < 0)
 		return ERR_PTR(-ENOMEM);
 
@@ -1265,7 +1265,7 @@ static void tcm_loop_drop_naa_tpg(
 	/*
 	 * Deregister the tl_tpg as a emulated SAS TCM Target Endpoint
 	 */
-	core_tpg_deregister(se_tpg);
+	target_deregister_tpg(se_tpg);
 
 	tl_tpg->tl_hba = NULL;
 	tl_tpg->tl_tpgt = 0;
diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index f433d56..094d040 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -2211,9 +2211,9 @@ static struct se_portal_group *sbp_make_tpg(
 		goto out_free_tpg;
 	}
 
-	ret = core_tpg_register(&sbp_fabric_configfs->tf_ops, wwn,
-			&tpg->se_tpg, (void *)tpg,
-			TRANSPORT_TPG_TYPE_NORMAL);
+	ret = target_register_tpg(&sbp_fabric_configfs->tf_ops, wwn,
+				  &tpg->se_tpg, (void *)tpg,
+				  TRANSPORT_TPG_TYPE_NORMAL);
 	if (ret < 0)
 		goto out_unreg_mgt_agt;
 
@@ -2232,7 +2232,7 @@ static void sbp_drop_tpg(struct se_portal_group *se_tpg)
 	struct sbp_tpg *tpg = container_of(se_tpg, struct sbp_tpg, se_tpg);
 	struct sbp_tport *tport = tpg->tport;
 
-	core_tpg_deregister(se_tpg);
+	target_deregister_tpg(se_tpg);
 	sbp_management_agent_unregister(tport->mgt_agt);
 	tport->tpg = NULL;
 	kfree(tpg);
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 86dda22..513e6bd 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -644,7 +644,7 @@ static int core_tpg_setup_virtual_lun0(struct se_portal_group *se_tpg)
 	return 0;
 }
 
-int core_tpg_register(
+int target_register_tpg(
 	struct target_core_fabric_ops *tfo,
 	struct se_wwn *se_wwn,
 	struct se_portal_group *se_tpg,
@@ -705,9 +705,9 @@ int core_tpg_register(
 
 	return 0;
 }
-EXPORT_SYMBOL(core_tpg_register);
+EXPORT_SYMBOL(target_register_tpg);
 
-int core_tpg_deregister(struct se_portal_group *se_tpg)
+int target_deregister_tpg(struct se_portal_group *se_tpg)
 {
 	struct se_node_acl *nacl, *nacl_tmp;
 	LIST_HEAD(node_list);
@@ -750,7 +750,7 @@ int core_tpg_deregister(struct se_portal_group *se_tpg)
 	array_free(se_tpg->tpg_lun_list, TRANSPORT_MAX_LUNS_PER_TPG);
 	return 0;
 }
-EXPORT_SYMBOL(core_tpg_deregister);
+EXPORT_SYMBOL(target_deregister_tpg);
 
 struct se_lun *core_tpg_alloc_lun(
 	struct se_portal_group *tpg,
diff --git a/drivers/target/tcm_fc/tfc_conf.c b/drivers/target/tcm_fc/tfc_conf.c
index 85dde28..9aa67ce 100644
--- a/drivers/target/tcm_fc/tfc_conf.c
+++ b/drivers/target/tcm_fc/tfc_conf.c
@@ -337,8 +337,8 @@ static struct se_portal_group *ft_add_tpg(
 		return NULL;
 	}
 
-	ret = core_tpg_register(&ft_configfs->tf_ops, wwn, &tpg->se_tpg,
-				tpg, TRANSPORT_TPG_TYPE_NORMAL);
+	ret = target_register_tpg(&ft_configfs->tf_ops, wwn, &tpg->se_tpg,
+				  tpg, TRANSPORT_TPG_TYPE_NORMAL);
 	if (ret < 0) {
 		destroy_workqueue(wq);
 		kfree(tpg);
@@ -374,7 +374,7 @@ static void ft_del_tpg(struct se_portal_group *se_tpg)
 	}
 	mutex_unlock(&ft_lport_lock);
 
-	core_tpg_deregister(se_tpg);
+	target_deregister_tpg(se_tpg);
 	kfree(tpg);
 }
 
diff --git a/drivers/usb/gadget/legacy/tcm_usb_gadget.c b/drivers/usb/gadget/legacy/tcm_usb_gadget.c
index 81a8b07..3db4b44 100644
--- a/drivers/usb/gadget/legacy/tcm_usb_gadget.c
+++ b/drivers/usb/gadget/legacy/tcm_usb_gadget.c
@@ -1572,9 +1572,9 @@ static struct se_portal_group *usbg_make_tpg(
 	tpg->tport = tport;
 	tpg->tport_tpgt = tpgt;
 
-	ret = core_tpg_register(&usbg_fabric_configfs->tf_ops, wwn,
-				&tpg->se_tpg, tpg,
-				TRANSPORT_TPG_TYPE_NORMAL);
+	ret = target_register_tpg(&usbg_fabric_configfs->tf_ops, wwn,
+				  &tpg->se_tpg, tpg,
+				  TRANSPORT_TPG_TYPE_NORMAL);
 	if (ret < 0) {
 		destroy_workqueue(tpg->workqueue);
 		kfree(tpg);
@@ -1589,7 +1589,7 @@ static void usbg_drop_tpg(struct se_portal_group *se_tpg)
 	struct usbg_tpg *tpg = container_of(se_tpg,
 				struct usbg_tpg, se_tpg);
 
-	core_tpg_deregister(se_tpg);
+	target_deregister_tpg(se_tpg);
 	destroy_workqueue(tpg->workqueue);
 	kfree(tpg);
 	the_only_tpg_I_currently_have = NULL;
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 7e745fd..4122073 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -2155,8 +2155,8 @@ vhost_scsi_make_tpg(struct se_wwn *wwn,
 	tpg->tport = tport;
 	tpg->tport_tpgt = tpgt;
 
-	ret = core_tpg_register(&vhost_scsi_fabric_configfs->tf_ops, wwn,
-				&tpg->se_tpg, tpg, TRANSPORT_TPG_TYPE_NORMAL);
+	ret = target_register_tpg(&vhost_scsi_fabric_configfs->tf_ops, wwn,
+				  &tpg->se_tpg, tpg, TRANSPORT_TPG_TYPE_NORMAL);
 	if (ret < 0) {
 		kfree(tpg);
 		return NULL;
@@ -2183,7 +2183,7 @@ static void vhost_scsi_drop_tpg(struct se_portal_group *se_tpg)
 	/*
 	 * Deregister the se_tpg from TCM..
 	 */
-	core_tpg_deregister(se_tpg);
+	target_deregister_tpg(se_tpg);
 	kfree(tpg);
 }
 
diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index 8511277..00772de 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -1898,8 +1898,8 @@ scsiback_make_tpg(struct se_wwn *wwn,
 	tpg->tport = tport;
 	tpg->tport_tpgt = tpgt;
 
-	ret = core_tpg_register(&scsiback_fabric_configfs->tf_ops, wwn,
-				&tpg->se_tpg, tpg, TRANSPORT_TPG_TYPE_NORMAL);
+	ret = target_register_tpg(&scsiback_fabric_configfs->tf_ops, wwn,
+				  &tpg->se_tpg, tpg, TRANSPORT_TPG_TYPE_NORMAL);
 	if (ret < 0) {
 		kfree(tpg);
 		return NULL;
@@ -1926,7 +1926,7 @@ static void scsiback_drop_tpg(struct se_portal_group *se_tpg)
 	/*
 	 * Deregister the se_tpg from TCM..
 	 */
-	core_tpg_deregister(se_tpg);
+	target_deregister_tpg(se_tpg);
 	kfree(tpg);
 }
 
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index e33c67b..9b4dc7a 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -160,9 +160,9 @@ int	target_set_initiator_node_queue_depth(struct se_portal_group *,
 		unsigned char *, u32, int);
 int	target_set_initiator_node_tag(struct se_portal_group *,
 		struct se_node_acl *, const char *);
-int	core_tpg_register(struct target_core_fabric_ops *, struct se_wwn *,
+int	target_register_tpg(struct target_core_fabric_ops *, struct se_wwn *,
 		struct se_portal_group *, void *, int);
-int	core_tpg_deregister(struct se_portal_group *);
+int	target_deregister_tpg(struct se_portal_group *);
 
 /* SAS helpers */
 u8	sas_get_fabric_proto_ident(struct se_portal_group *);
-- 
1.9.1

