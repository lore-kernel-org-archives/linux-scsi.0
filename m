From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 4/4] target: Drop unnecessary core_tpg_register TFO parameter
Date: Tue, 26 May 2015 06:57:25 +0000
Message-ID: <1432623445-25776-5-git-send-email-nab@daterainc.com>
References: <1432623445-25776-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:33647 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbbEZHAU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 May 2015 03:00:20 -0400
Received: by obbnx5 with SMTP id nx5so67464294obb.0
        for <linux-scsi@vger.kernel.org>; Tue, 26 May 2015 00:00:20 -0700 (PDT)
In-Reply-To: <1432623445-25776-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch drops unnecessary target_core_fabric_ops parameter usage
for core_tpg_register() during fabric driver TFO->fabric_make_tpg()
se_portal_group creation callback execution.

Instead, use the existing se_wwn->wwn_tf->tf_ops pointer to ensure
fabric driver is really using the same TFO provided at module_init
time.

Also go ahead and drop the forward TFO declarations tree-wide, and
handling the special case for iscsi-target discovery TPG.

Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c        |  4 +---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c           |  9 ++-------
 drivers/target/iscsi/iscsi_target_configfs.c |  3 +--
 drivers/target/iscsi/iscsi_target_tpg.c      |  8 ++++++--
 drivers/target/loopback/tcm_loop.c           |  5 +----
 drivers/target/sbp/sbp_target.c              |  2 +-
 drivers/target/target_core_tpg.c             | 14 +++++++++-----
 drivers/target/tcm_fc/tfc_conf.c             |  5 +----
 drivers/usb/gadget/legacy/tcm_usb_gadget.c   |  5 +----
 drivers/vhost/scsi.c                         |  4 +---
 drivers/xen/xen-scsiback.c                   |  5 +----
 include/target/target_core_fabric.h          |  3 +--
 12 files changed, 26 insertions(+), 41 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index dbad5c6..cea207e 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -92,7 +92,6 @@ MODULE_PARM_DESC(srpt_service_guid,
 		 " instead of using the node_guid of the first HCA.");
 
 static struct ib_client srpt_client;
-static const struct target_core_fabric_ops srpt_template;
 static void srpt_release_channel(struct srpt_rdma_ch *ch);
 static int srpt_queue_status(struct se_cmd *cmd);
 
@@ -3733,8 +3732,7 @@ static struct se_portal_group *srpt_make_tpg(struct se_wwn *wwn,
 	int res;
 
 	/* Initialize sport->port_wwn and sport->port_tpg_1 */
-	res = core_tpg_register(&srpt_template, &sport->port_wwn,
-			&sport->port_tpg_1, SCSI_PROTOCOL_SRP);
+	res = core_tpg_register(&sport->port_wwn, &sport->port_tpg_1, SCSI_PROTOCOL_SRP);
 	if (res)
 		return ERR_PTR(res);
 
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index cb53144..e14a7fd 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -52,9 +52,6 @@
 static struct workqueue_struct *tcm_qla2xxx_free_wq;
 static struct workqueue_struct *tcm_qla2xxx_cmd_wq;
 
-static const struct target_core_fabric_ops tcm_qla2xxx_ops;
-static const struct target_core_fabric_ops tcm_qla2xxx_npiv_ops;
-
 /*
  * Parse WWN.
  * If strict, we require lower-case hex and colon separators to be sure
@@ -1004,8 +1001,7 @@ static struct se_portal_group *tcm_qla2xxx_make_tpg(
 	tpg->tpg_attrib.cache_dynamic_acls = 1;
 	tpg->tpg_attrib.demo_mode_login_only = 1;
 
-	ret = core_tpg_register(&tcm_qla2xxx_ops, wwn, &tpg->se_tpg,
-				SCSI_PROTOCOL_FCP);
+	ret = core_tpg_register(wwn, &tpg->se_tpg, SCSI_PROTOCOL_FCP);
 	if (ret < 0) {
 		kfree(tpg);
 		return NULL;
@@ -1124,8 +1120,7 @@ static struct se_portal_group *tcm_qla2xxx_npiv_make_tpg(
 	tpg->tpg_attrib.cache_dynamic_acls = 1;
 	tpg->tpg_attrib.demo_mode_login_only = 1;
 
-	ret = core_tpg_register(&tcm_qla2xxx_npiv_ops, wwn, &tpg->se_tpg,
-				SCSI_PROTOCOL_FCP);
+	ret = core_tpg_register(wwn, &tpg->se_tpg, SCSI_PROTOCOL_FCP);
 	if (ret < 0) {
 		kfree(tpg);
 		return NULL;
diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index 523ae55..c1898c8 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -1419,8 +1419,7 @@ static struct se_portal_group *lio_target_tiqn_addtpg(
 	if (!tpg)
 		return NULL;
 
-	ret = core_tpg_register(&iscsi_ops, wwn, &tpg->tpg_se_tpg,
-				SCSI_PROTOCOL_ISCSI);
+	ret = core_tpg_register(wwn, &tpg->tpg_se_tpg, SCSI_PROTOCOL_ISCSI);
 	if (ret < 0)
 		return NULL;
 
diff --git a/drivers/target/iscsi/iscsi_target_tpg.c b/drivers/target/iscsi/iscsi_target_tpg.c
index 86f888e..36c52dd 100644
--- a/drivers/target/iscsi/iscsi_target_tpg.c
+++ b/drivers/target/iscsi/iscsi_target_tpg.c
@@ -66,8 +66,12 @@ int iscsit_load_discovery_tpg(void)
 		pr_err("Unable to allocate struct iscsi_portal_group\n");
 		return -1;
 	}
-
-	ret = core_tpg_register(&iscsi_ops, NULL, &tpg->tpg_se_tpg, -1);
+	/*
+	 * Save iscsi_ops pointer for special case discovery TPG that
+	 * doesn't exist as se_wwn->wwn_group within configfs.
+	 */
+	tpg->tpg_se_tpg.se_tpg_tfo = &iscsi_ops;
+	ret = core_tpg_register(NULL, &tpg->tpg_se_tpg, -1);
 	if (ret < 0) {
 		kfree(tpg);
 		return -1;
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index b0c1761..bd9d11a 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -40,8 +40,6 @@
 
 #define to_tcm_loop_hba(hba)	container_of(hba, struct tcm_loop_hba, dev)
 
-static const struct target_core_fabric_ops loop_ops;
-
 static struct workqueue_struct *tcm_loop_workqueue;
 static struct kmem_cache *tcm_loop_cmd_cache;
 
@@ -1081,8 +1079,7 @@ static struct se_portal_group *tcm_loop_make_naa_tpg(
 	/*
 	 * Register the tl_tpg as a emulated SAS TCM Target Endpoint
 	 */
-	ret = core_tpg_register(&loop_ops, wwn, &tl_tpg->tl_se_tpg,
-				tl_hba->tl_proto_id);
+	ret = core_tpg_register(wwn, &tl_tpg->tl_se_tpg, tl_hba->tl_proto_id);
 	if (ret < 0)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index 47fb12f..e9d0b32 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -2052,7 +2052,7 @@ static struct se_portal_group *sbp_make_tpg(
 		goto out_free_tpg;
 	}
 
-	ret = core_tpg_register(&sbp_ops, wwn, &tpg->se_tpg, SCSI_PROTOCOL_SBP);
+	ret = core_tpg_register(wwn, &tpg->se_tpg, SCSI_PROTOCOL_SBP);
 	if (ret < 0)
 		goto out_unreg_mgt_agt;
 
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 2ec1ed1..d61c999 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -486,16 +486,19 @@ static void core_tpg_lun_ref_release(struct percpu_ref *ref)
 }
 
 int core_tpg_register(
-	const struct target_core_fabric_ops *tfo,
 	struct se_wwn *se_wwn,
 	struct se_portal_group *se_tpg,
 	int proto_id)
 {
 	int ret;
 
+	if (!se_tpg)
+		return -EINVAL;
+
 	INIT_HLIST_HEAD(&se_tpg->tpg_lun_hlist);
 	se_tpg->proto_id = proto_id;
-	se_tpg->se_tpg_tfo = tfo;
+	if (se_wwn)
+		se_tpg->se_tpg_tfo = se_wwn->wwn_tf->tf_ops;
 	se_tpg->se_tpg_wwn = se_wwn;
 	atomic_set(&se_tpg->tpg_pr_ref_count, 0);
 	INIT_LIST_HEAD(&se_tpg->acl_node_list);
@@ -523,9 +526,10 @@ int core_tpg_register(
 	spin_unlock_bh(&tpg_lock);
 
 	pr_debug("TARGET_CORE[%s]: Allocated portal_group for endpoint: %s, "
-		 "Proto: %d, Portal Tag: %u\n", tfo->get_fabric_name(),
-		tfo->tpg_get_wwn(se_tpg) ? tfo->tpg_get_wwn(se_tpg) : NULL,
-		se_tpg->proto_id, tfo->tpg_get_tag(se_tpg));
+		 "Proto: %d, Portal Tag: %u\n", se_tpg->se_tpg_tfo->get_fabric_name(),
+		se_tpg->se_tpg_tfo->tpg_get_wwn(se_tpg) ?
+		se_tpg->se_tpg_tfo->tpg_get_wwn(se_tpg) : NULL,
+		se_tpg->proto_id, se_tpg->se_tpg_tfo->tpg_get_tag(se_tpg));
 
 	return 0;
 }
diff --git a/drivers/target/tcm_fc/tfc_conf.c b/drivers/target/tcm_fc/tfc_conf.c
index 8e1a54f..80a4477 100644
--- a/drivers/target/tcm_fc/tfc_conf.c
+++ b/drivers/target/tcm_fc/tfc_conf.c
@@ -47,8 +47,6 @@
 
 #include "tcm_fc.h"
 
-static const struct target_core_fabric_ops ft_fabric_ops;
-
 static LIST_HEAD(ft_wwn_list);
 DEFINE_MUTEX(ft_lport_lock);
 
@@ -282,8 +280,7 @@ static struct se_portal_group *ft_add_tpg(
 		return NULL;
 	}
 
-	ret = core_tpg_register(&ft_fabric_ops, wwn, &tpg->se_tpg,
-				SCSI_PROTOCOL_FCP);
+	ret = core_tpg_register(wwn, &tpg->se_tpg, SCSI_PROTOCOL_FCP);
 	if (ret < 0) {
 		destroy_workqueue(wq);
 		kfree(tpg);
diff --git a/drivers/usb/gadget/legacy/tcm_usb_gadget.c b/drivers/usb/gadget/legacy/tcm_usb_gadget.c
index 16b9a16..4ff426e 100644
--- a/drivers/usb/gadget/legacy/tcm_usb_gadget.c
+++ b/drivers/usb/gadget/legacy/tcm_usb_gadget.c
@@ -28,8 +28,6 @@
 
 USB_GADGET_COMPOSITE_OPTIONS();
 
-static const struct target_core_fabric_ops usbg_ops;
-
 static inline struct f_uas *to_f_uas(struct usb_function *f)
 {
 	return container_of(f, struct f_uas, function);
@@ -1418,8 +1416,7 @@ static struct se_portal_group *usbg_make_tpg(
 	 * SPC doesn't assign a protocol identifier for USB-SCSI, so we
 	 * pretend to be SAS..
 	 */
-	ret = core_tpg_register(&usbg_ops, wwn, &tpg->se_tpg,
-				SCSI_PROTOCOL_SAS);
+	ret = core_tpg_register(wwn, &tpg->se_tpg, SCSI_PROTOCOL_SAS);
 	if (ret < 0) {
 		destroy_workqueue(tpg->workqueue);
 		kfree(tpg);
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index dcd228b..450aece 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -206,7 +206,6 @@ struct vhost_scsi {
 	int vs_events_nr; /* num of pending events, protected by vq->mutex */
 };
 
-static struct target_core_fabric_ops vhost_scsi_ops;
 static struct workqueue_struct *vhost_scsi_workqueue;
 
 /* Global spinlock to protect vhost_scsi TPG list for vhost IOCTL access */
@@ -2001,8 +2000,7 @@ vhost_scsi_make_tpg(struct se_wwn *wwn,
 	tpg->tport = tport;
 	tpg->tport_tpgt = tpgt;
 
-	ret = core_tpg_register(&vhost_scsi_ops, wwn, &tpg->se_tpg,
-				tport->tport_proto_id);
+	ret = core_tpg_register(wwn, &tpg->se_tpg, tport->tport_proto_id);
 	if (ret < 0) {
 		kfree(tpg);
 		return NULL;
diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index 555033b..25144a0 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -203,8 +203,6 @@ static LIST_HEAD(scsiback_free_pages);
 static DEFINE_MUTEX(scsiback_mutex);
 static LIST_HEAD(scsiback_list);
 
-static const struct target_core_fabric_ops scsiback_ops;
-
 static void scsiback_get(struct vscsibk_info *info)
 {
 	atomic_inc(&info->nr_unreplied_reqs);
@@ -1765,8 +1763,7 @@ scsiback_make_tpg(struct se_wwn *wwn,
 	tpg->tport = tport;
 	tpg->tport_tpgt = tpgt;
 
-	ret = core_tpg_register(&scsiback_ops, wwn, &tpg->se_tpg,
-				tport->tport_proto_id);
+	ret = core_tpg_register(wwn, &tpg->se_tpg, tport->tport_proto_id);
 	if (ret < 0) {
 		kfree(tpg);
 		return NULL;
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index b1e00a7..d6216b7 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -161,8 +161,7 @@ int	core_tpg_set_initiator_node_queue_depth(struct se_portal_group *,
 		unsigned char *, u32, int);
 int	core_tpg_set_initiator_node_tag(struct se_portal_group *,
 		struct se_node_acl *, const char *);
-int	core_tpg_register(const struct target_core_fabric_ops *,
-		struct se_wwn *, struct se_portal_group *, int);
+int	core_tpg_register(struct se_wwn *, struct se_portal_group *, int);
 int	core_tpg_deregister(struct se_portal_group *);
 
 /*
-- 
1.9.1

