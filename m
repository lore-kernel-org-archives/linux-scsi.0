From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 9/9] loopback: Add fabric_prot_type attribute support
Date: Sat, 28 Feb 2015 10:36:06 +0000
Message-ID: <1425119766-11878-10-git-send-email-nab@daterainc.com>
References: <1425119766-11878-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1425119766-11878-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Martin Petersen <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch updates loopback to add a new fabric_prot_type TPG attribute,
used for controlling LLD level protection into LIO when the backend
device does not support T10-PI.

Also, go ahead and set DIN_PASS + DOUT_PASS so target-core knows that
it will be doing any WRITE_STRIP and READ_INSERT operations.

Note this currently forces the use of TARGET_DIF_TYPE1_PROT.

Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/loopback/tcm_loop.c | 51 ++++++++++++++++++++++++++++++++++++--
 drivers/target/loopback/tcm_loop.h |  1 +
 2 files changed, 50 insertions(+), 2 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index c36bd7c..696c2ca 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -697,6 +697,13 @@ static int tcm_loop_check_prod_mode_write_protect(struct se_portal_group *se_tpg
 	return 0;
 }
 
+static int tcm_loop_check_prot_fabric_only(struct se_portal_group *se_tpg)
+{
+	struct tcm_loop_tpg *tl_tpg = container_of(se_tpg, struct tcm_loop_tpg,
+						   tl_se_tpg);
+	return tl_tpg->tl_fabric_prot_type;
+}
+
 static struct se_node_acl *tcm_loop_tpg_alloc_fabric_acl(
 	struct se_portal_group *se_tpg)
 {
@@ -912,6 +919,42 @@ static void tcm_loop_port_unlink(
 
 /* End items for tcm_loop_port_cit */
 
+static ssize_t tcm_loop_tpg_attrib_show_fabric_prot_type(
+	struct se_portal_group *se_tpg,
+	char *page)
+{
+	struct tcm_loop_tpg *tl_tpg = container_of(se_tpg, struct tcm_loop_tpg,
+						   tl_se_tpg);
+
+	return sprintf(page, "%d\n", tl_tpg->tl_fabric_prot_type);
+}
+
+static ssize_t tcm_loop_tpg_attrib_store_fabric_prot_type(
+	struct se_portal_group *se_tpg,
+	const char *page,
+	size_t count)
+{
+	struct tcm_loop_tpg *tl_tpg = container_of(se_tpg, struct tcm_loop_tpg,
+						   tl_se_tpg);
+	unsigned long val;
+	int ret = kstrtoul(page, 0, &val);
+
+	if (ret) {
+		pr_err("kstrtoul() returned %d for fabric_prot_type\n", ret);
+		return ret;
+	}
+	tl_tpg->tl_fabric_prot_type = val;
+
+	return count;
+}
+
+TF_TPG_ATTRIB_ATTR(tcm_loop, fabric_prot_type, S_IRUGO | S_IWUSR);
+
+static struct configfs_attribute *tcm_loop_tpg_attrib_attrs[] = {
+	&tcm_loop_tpg_attrib_fabric_prot_type.attr,
+	NULL,
+};
+
 /* Start items for tcm_loop_nexus_cit */
 
 static int tcm_loop_make_nexus(
@@ -937,7 +980,8 @@ static int tcm_loop_make_nexus(
 	/*
 	 * Initialize the struct se_session pointer
 	 */
-	tl_nexus->se_sess = transport_init_session(TARGET_PROT_ALL);
+	tl_nexus->se_sess = transport_init_session(
+				TARGET_PROT_DIN_PASS | TARGET_PROT_DOUT_PASS);
 	if (IS_ERR(tl_nexus->se_sess)) {
 		ret = PTR_ERR(tl_nexus->se_sess);
 		goto out;
@@ -1186,6 +1230,7 @@ static struct se_portal_group *tcm_loop_make_naa_tpg(
 	tl_tpg = &tl_hba->tl_hba_tpgs[tpgt];
 	tl_tpg->tl_hba = tl_hba;
 	tl_tpg->tl_tpgt = tpgt;
+	tl_tpg->tl_fabric_prot_type = TARGET_DIF_TYPE1_PROT;
 	/*
 	 * Register the tl_tpg as a emulated SAS TCM Target Endpoint
 	 */
@@ -1374,6 +1419,8 @@ static int tcm_loop_register_configfs(void)
 					&tcm_loop_check_demo_mode_write_protect;
 	fabric->tf_ops.tpg_check_prod_mode_write_protect =
 					&tcm_loop_check_prod_mode_write_protect;
+	fabric->tf_ops.tpg_check_prot_fabric_only =
+					&tcm_loop_check_prot_fabric_only;
 	/*
 	 * The TCM loopback fabric module runs in demo-mode to a local
 	 * virtual SCSI device, so fabric dependent initator ACLs are
@@ -1426,7 +1473,7 @@ static int tcm_loop_register_configfs(void)
 	 */
 	fabric->tf_cit_tmpl.tfc_wwn_cit.ct_attrs = tcm_loop_wwn_attrs;
 	fabric->tf_cit_tmpl.tfc_tpg_base_cit.ct_attrs = tcm_loop_tpg_attrs;
-	fabric->tf_cit_tmpl.tfc_tpg_attrib_cit.ct_attrs = NULL;
+	fabric->tf_cit_tmpl.tfc_tpg_attrib_cit.ct_attrs = tcm_loop_tpg_attrib_attrs;
 	fabric->tf_cit_tmpl.tfc_tpg_param_cit.ct_attrs = NULL;
 	fabric->tf_cit_tmpl.tfc_tpg_np_base_cit.ct_attrs = NULL;
 	/*
diff --git a/drivers/target/loopback/tcm_loop.h b/drivers/target/loopback/tcm_loop.h
index 6ae49f2..1e72ff7 100644
--- a/drivers/target/loopback/tcm_loop.h
+++ b/drivers/target/loopback/tcm_loop.h
@@ -43,6 +43,7 @@ struct tcm_loop_nacl {
 struct tcm_loop_tpg {
 	unsigned short tl_tpgt;
 	unsigned short tl_transport_status;
+	enum target_prot_type tl_fabric_prot_type;
 	atomic_t tl_tpg_port_count;
 	struct se_portal_group tl_se_tpg;
 	struct tcm_loop_hba *tl_hba;
-- 
1.9.1
