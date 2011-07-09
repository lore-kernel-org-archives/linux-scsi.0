From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 17/20] target: Extraneous paren removal in tcm_vhost and tcm_qla2xxx
Date: Fri,  8 Jul 2011 18:18:46 -0700
Message-ID: <1310174329-22228-18-git-send-email-agrover@redhat.com>
References: <1310078011-15504-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55780 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652Ab1GIBTE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Jul 2011 21:19:04 -0400
In-Reply-To: <1310078011-15504-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

Similar to the previous patch, this removes extraneous parens in
tcm_qla2xxx and tcm_vhost.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/tcm_qla2xxx/tcm_qla2xxx_configfs.c |   26 ++++++++++----------
 drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.c   |    2 +-
 drivers/target/tcm_vhost/tcm_vhost_configfs.c     |   12 +++++-----
 drivers/target/tcm_vhost/tcm_vhost_fabric.c       |    2 +-
 4 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/target/tcm_qla2xxx/tcm_qla2xxx_configfs.c b/drivers/target/tcm_qla2xxx/tcm_qla2xxx_configfs.c
index 1e2093b..4a06db4 100644
--- a/drivers/target/tcm_qla2xxx/tcm_qla2xxx_configfs.c
+++ b/drivers/target/tcm_qla2xxx/tcm_qla2xxx_configfs.c
@@ -170,7 +170,7 @@ static struct se_node_acl *tcm_qla2xxx_make_nodeacl(
 		return ERR_PTR(-EINVAL);
 
 	se_nacl_new = tcm_qla2xxx_alloc_fabric_acl(se_tpg);
-	if (!(se_nacl_new))
+	if (!se_nacl_new)
 		return ERR_PTR(-ENOMEM);
 //#warning FIXME: Hardcoded qla2xxx_nexus depth in tcm_qla2xxx_make_nodeacl()
 	qla2xxx_nexus_depth = 1;
@@ -377,14 +377,14 @@ static struct se_portal_group *tcm_qla2xxx_make_tpg(
 	if (strict_strtoul(name + 5, 10, &tpgt) || tpgt > USHRT_MAX)
 		return ERR_PTR(-EINVAL);
 	
-	if ((lport->qla_npiv_vp == NULL) && (tpgt != 1)) {
+	if (!lport->qla_npiv_vp && (tpgt != 1)) {
 		pr_err("In non NPIV mode, a single TPG=1 is used for"
 			" HW port mappings\n");
 		return ERR_PTR(-ENOSYS);
 	}
 
 	tpg = kzalloc(sizeof(struct tcm_qla2xxx_tpg), GFP_KERNEL);
-	if (!(tpg)) {
+	if (!tpg) {
 		pr_err("Unable to allocate struct tcm_qla2xxx_tpg\n");
 		return ERR_PTR(-ENOMEM);
 	}
@@ -424,7 +424,7 @@ static void tcm_qla2xxx_drop_tpg(struct se_portal_group *se_tpg)
 	 * Call into qla2x_target.c LLD logic to shutdown the active
 	 * FC Nexuses and disable target mode operation for this qla_hw_data
 	 */
-	if ((ha->qla_tgt != NULL) && !ha->qla_tgt->tgt_stopped)
+	if (ha->qla_tgt && !ha->qla_tgt->tgt_stopped)
 		qla_tgt_stop_phase1(ha->qla_tgt);
 
 	core_tpg_deregister(se_tpg);
@@ -454,7 +454,7 @@ static struct se_portal_group *tcm_qla2xxx_npiv_make_tpg(
 		return ERR_PTR(-EINVAL);
 
 	tpg = kzalloc(sizeof(struct tcm_qla2xxx_tpg), GFP_KERNEL);
-	if (!(tpg)) {
+	if (!tpg) {
 		pr_err("Unable to allocate struct tcm_qla2xxx_tpg\n");
 		return ERR_PTR(-ENOMEM);
 	}
@@ -859,7 +859,7 @@ static int tcm_qla2xxx_init_lport(
 
 	lport->lport_fcport_map = vmalloc(
 			sizeof(struct tcm_qla2xxx_fc_domain) * 256);
-	if (!(lport->lport_fcport_map)) {
+	if (!lport->lport_fcport_map) {
 		pr_err("Unable to allocate lport_fcport_map of %lu"
 			" bytes\n", sizeof(struct tcm_qla2xxx_fc_domain) * 256);
 		return -ENOMEM;
@@ -871,7 +871,7 @@ static int tcm_qla2xxx_init_lport(
 
 	lport->lport_loopid_map = vmalloc(sizeof(struct tcm_qla2xxx_fc_loopid) *
 				65536);
-	if (!(lport->lport_loopid_map)) {
+	if (!lport->lport_loopid_map) {
 		pr_err("Unable to allocate lport->lport_loopid_map"
 			" of %lu bytes\n", sizeof(struct tcm_qla2xxx_fc_loopid)
 			* 65536);
@@ -916,7 +916,7 @@ static struct se_wwn *tcm_qla2xxx_make_lport(
 		return ERR_PTR(-EINVAL);
 
 	lport = kzalloc(sizeof(struct tcm_qla2xxx_lport), GFP_KERNEL);
-	if (!(lport)) {
+	if (!lport) {
 		pr_err("Unable to allocate struct tcm_qla2xxx_lport\n");
 		return ERR_PTR(-ENOMEM);
 	}
@@ -1001,7 +1001,7 @@ static void tcm_qla2xxx_drop_lport(struct se_wwn *wwn)
 	 * shutdown of struct qla_tgt after the call to
 	 * qla_tgt_stop_phase1() from tcm_qla2xxx_drop_tpg() above..
 	 */
-	if ((ha->qla_tgt != NULL) && !ha->qla_tgt->tgt_stopped)
+	if (ha->qla_tgt && !ha->qla_tgt->tgt_stopped)
 		qla_tgt_stop_phase2(ha->qla_tgt);
 	/*
 	 * Clear the target_lport_ptr qla_target_template pointer in qla_hw_data
@@ -1040,7 +1040,7 @@ static struct se_wwn *tcm_qla2xxx_npiv_make_lport(
 		return ERR_PTR(-EINVAL);
 
 	lport = kzalloc(sizeof(struct tcm_qla2xxx_lport), GFP_KERNEL);
-	if (!(lport)) {
+	if (!lport) {
 		pr_err("Unable to allocate struct tcm_qla2xxx_lport"
 				" for NPIV\n");
 		return ERR_PTR(-ENOMEM);
@@ -1308,7 +1308,7 @@ static int tcm_qla2xxx_register_configfs(void)
 	 * Register the top level struct config_item_type with TCM core
 	 */
 	fabric = target_fabric_configfs_init(THIS_MODULE, "qla2xxx");
-	if (!(fabric)) {
+	if (!fabric) {
 		pr_err("target_fabric_configfs_init() failed\n");
 		return -ENOMEM;
 	}
@@ -1351,7 +1351,7 @@ static int tcm_qla2xxx_register_configfs(void)
 	 * Register the top level struct config_item_type for NPIV with TCM core
 	 */
 	npiv_fabric = target_fabric_configfs_init(THIS_MODULE, "qla2xxx_npiv");
-	if (!(npiv_fabric)) {
+	if (!npiv_fabric) {
 		pr_err("target_fabric_configfs_init() failed\n");
 		ret = -ENOMEM;
 		goto out;
@@ -1397,7 +1397,7 @@ out:
 
 static void tcm_qla2xxx_deregister_configfs(void)
 {
-	if (!(tcm_qla2xxx_fabric_configfs))
+	if (!tcm_qla2xxx_fabric_configfs)
 		return;
 
 	target_fabric_configfs_deregister(tcm_qla2xxx_fabric_configfs);
diff --git a/drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.c b/drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.c
index 9055366..80c02ee 100644
--- a/drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.c
+++ b/drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.c
@@ -357,7 +357,7 @@ struct se_node_acl *tcm_qla2xxx_alloc_fabric_acl(struct se_portal_group *se_tpg)
 	struct tcm_qla2xxx_nacl *nacl;
 
 	nacl = kzalloc(sizeof(struct tcm_qla2xxx_nacl), GFP_KERNEL);
-	if (!(nacl)) {
+	if (!nacl) {
 		pr_err("Unable to alocate struct tcm_qla2xxx_nacl\n");
 		return NULL;
 	}
diff --git a/drivers/target/tcm_vhost/tcm_vhost_configfs.c b/drivers/target/tcm_vhost/tcm_vhost_configfs.c
index 2230dc3..419efad 100644
--- a/drivers/target/tcm_vhost/tcm_vhost_configfs.c
+++ b/drivers/target/tcm_vhost/tcm_vhost_configfs.c
@@ -111,7 +111,7 @@ static struct se_node_acl *tcm_vhost_make_nodeacl(
 	/* tcm_vhost_parse_wwn(name, &wwpn, 1) < 0)
 		return ERR_PTR(-EINVAL); */
 	se_nacl_new = tcm_vhost_alloc_fabric_acl(se_tpg);
-	if (!(se_nacl_new))
+	if (!se_nacl_new)
 		return ERR_PTR(-ENOMEM);
 //#warning FIXME: Hardcoded nexus depth in tcm_vhost_make_nodeacl()
 	nexus_depth = 1;
@@ -283,7 +283,7 @@ static ssize_t tcm_vhost_tpg_store_nexus(
 	/*
 	 * Shutdown the active I_T nexus if 'NULL' is passed..
 	 */
-	if (!(strncmp(page, "NULL", 4))) {
+	if (!strncmp(page, "NULL", 4)) {
 		ret = tcm_vhost_drop_nexus(tv_tpg);
 		return (!ret) ? count : ret;
 	}
@@ -467,7 +467,7 @@ static struct se_portal_group *tcm_vhost_make_tpg(
 		return ERR_PTR(-EINVAL);
 
 	tpg = kzalloc(sizeof(struct tcm_vhost_tpg), GFP_KERNEL);
-	if (!(tpg)) {
+	if (!tpg) {
 		pr_err("Unable to allocate struct tcm_vhost_tpg");
 		return ERR_PTR(-ENOMEM);
 	}
@@ -523,7 +523,7 @@ static struct se_wwn *tcm_vhost_make_tport(
 		return ERR_PTR(-EINVAL); */
 
 	tport = kzalloc(sizeof(struct tcm_vhost_tport), GFP_KERNEL);
-	if (!(tport)) {
+	if (!tport) {
 		pr_err("Unable to allocate struct tcm_vhost_tport");
 		return ERR_PTR(-ENOMEM);
 	}
@@ -661,7 +661,7 @@ static int tcm_vhost_register_configfs(void)
 	 * Register the top level struct config_item_type with TCM core
 	 */
 	fabric = target_fabric_configfs_init(THIS_MODULE, "vhost");
-	if (!(fabric)) {
+	if (!fabric) {
 		pr_err("target_fabric_configfs_init() failed\n");
 		return -ENOMEM;
 	}
@@ -700,7 +700,7 @@ static int tcm_vhost_register_configfs(void)
 
 static void tcm_vhost_deregister_configfs(void)
 {
-	if (!(tcm_vhost_fabric_configfs))
+	if (!tcm_vhost_fabric_configfs)
 		return;
 
 	target_fabric_configfs_deregister(tcm_vhost_fabric_configfs);
diff --git a/drivers/target/tcm_vhost/tcm_vhost_fabric.c b/drivers/target/tcm_vhost/tcm_vhost_fabric.c
index 286c719..3967c44 100644
--- a/drivers/target/tcm_vhost/tcm_vhost_fabric.c
+++ b/drivers/target/tcm_vhost/tcm_vhost_fabric.c
@@ -201,7 +201,7 @@ struct se_node_acl *tcm_vhost_alloc_fabric_acl(struct se_portal_group *se_tpg)
 	struct tcm_vhost_nacl *nacl;
 
 	nacl = kzalloc(sizeof(struct tcm_vhost_nacl), GFP_KERNEL);
-	if (!(nacl)) {
+	if (!nacl) {
 		pr_err("Unable to alocate struct tcm_vhost_nacl\n");
 		return NULL;
 	}
-- 
1.7.1

