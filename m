From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 3/3] target: Change some fabric functions to return bool
Date: Thu, 13 Nov 2014 12:50:58 -0800
Message-ID: <1415911858-3123-3-git-send-email-agrover@redhat.com>
References: <1415911858-3123-1-git-send-email-agrover@redhat.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1415911858-3123-1-git-send-email-agrover@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, hch@lst.de, nab@linux-iscsi.org
List-Id: linux-scsi@vger.kernel.org

The tpg_check_* functions in the fabric_ops struct return 1 or 0,
so we can make their return type bool. Change fabrics to match.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c        |  8 ++++----
 drivers/scsi/qla2xxx/tcm_qla2xxx.c           | 10 +++++-----
 drivers/target/iscsi/iscsi_target_configfs.c |  8 ++++----
 drivers/target/loopback/tcm_loop.c           | 16 ++++++++--------
 drivers/target/sbp/sbp_target.c              |  8 ++++----
 drivers/target/tcm_fc/tfc_conf.c             |  4 ++--
 drivers/vhost/scsi.c                         |  8 ++++----
 include/target/target_core_fabric.h          | 10 +++++-----
 8 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 7206547..b505d98 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -3377,14 +3377,14 @@ static struct ib_client srpt_client = {
 	.remove = srpt_remove_one
 };
 
-static int srpt_check_true(struct se_portal_group *se_tpg)
+static bool srpt_check_true(struct se_portal_group *se_tpg)
 {
-	return 1;
+	return true;
 }
 
-static int srpt_check_false(struct se_portal_group *se_tpg)
+static bool srpt_check_false(struct se_portal_group *se_tpg)
 {
-	return 0;
+	return false;
 }
 
 static char *srpt_get_fabric_name(void)
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 73f9fee..d5558d0 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -296,7 +296,7 @@ static char *tcm_qla2xxx_parse_pr_out_transport_id(
 	return tid;
 }
 
-static int tcm_qla2xxx_check_demo_mode(struct se_portal_group *se_tpg)
+static bool tcm_qla2xxx_check_demo_mode(struct se_portal_group *se_tpg)
 {
 	struct tcm_qla2xxx_tpg *tpg = container_of(se_tpg,
 				struct tcm_qla2xxx_tpg, se_tpg);
@@ -304,7 +304,7 @@ static int tcm_qla2xxx_check_demo_mode(struct se_portal_group *se_tpg)
 	return tpg->tpg_attrib.generate_node_acls;
 }
 
-static int tcm_qla2xxx_check_demo_mode_cache(struct se_portal_group *se_tpg)
+static bool tcm_qla2xxx_check_demo_mode_cache(struct se_portal_group *se_tpg)
 {
 	struct tcm_qla2xxx_tpg *tpg = container_of(se_tpg,
 				struct tcm_qla2xxx_tpg, se_tpg);
@@ -312,7 +312,7 @@ static int tcm_qla2xxx_check_demo_mode_cache(struct se_portal_group *se_tpg)
 	return tpg->tpg_attrib.cache_dynamic_acls;
 }
 
-static int tcm_qla2xxx_check_demo_write_protect(struct se_portal_group *se_tpg)
+static bool tcm_qla2xxx_check_demo_write_protect(struct se_portal_group *se_tpg)
 {
 	struct tcm_qla2xxx_tpg *tpg = container_of(se_tpg,
 				struct tcm_qla2xxx_tpg, se_tpg);
@@ -320,7 +320,7 @@ static int tcm_qla2xxx_check_demo_write_protect(struct se_portal_group *se_tpg)
 	return tpg->tpg_attrib.demo_mode_write_protect;
 }
 
-static int tcm_qla2xxx_check_prod_write_protect(struct se_portal_group *se_tpg)
+static bool tcm_qla2xxx_check_prod_write_protect(struct se_portal_group *se_tpg)
 {
 	struct tcm_qla2xxx_tpg *tpg = container_of(se_tpg,
 				struct tcm_qla2xxx_tpg, se_tpg);
@@ -328,7 +328,7 @@ static int tcm_qla2xxx_check_prod_write_protect(struct se_portal_group *se_tpg)
 	return tpg->tpg_attrib.prod_mode_write_protect;
 }
 
-static int tcm_qla2xxx_check_demo_mode_login_only(struct se_portal_group *se_tpg)
+static bool tcm_qla2xxx_check_demo_mode_login_only(struct se_portal_group *se_tpg)
 {
 	struct tcm_qla2xxx_tpg *tpg = container_of(se_tpg,
 				struct tcm_qla2xxx_tpg, se_tpg);
diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index 9059c1e..a89b0dc 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -1847,21 +1847,21 @@ static u32 lio_tpg_get_default_depth(struct se_portal_group *se_tpg)
 	return tpg->tpg_attrib.default_cmdsn_depth;
 }
 
-static int lio_tpg_check_demo_mode(struct se_portal_group *se_tpg)
+static bool lio_tpg_check_demo_mode(struct se_portal_group *se_tpg)
 {
 	struct iscsi_portal_group *tpg = se_tpg->se_tpg_fabric_ptr;
 
 	return tpg->tpg_attrib.generate_node_acls;
 }
 
-static int lio_tpg_check_demo_mode_cache(struct se_portal_group *se_tpg)
+static bool lio_tpg_check_demo_mode_cache(struct se_portal_group *se_tpg)
 {
 	struct iscsi_portal_group *tpg = se_tpg->se_tpg_fabric_ptr;
 
 	return tpg->tpg_attrib.cache_dynamic_acls;
 }
 
-static int lio_tpg_check_demo_mode_write_protect(
+static bool lio_tpg_check_demo_mode_write_protect(
 	struct se_portal_group *se_tpg)
 {
 	struct iscsi_portal_group *tpg = se_tpg->se_tpg_fabric_ptr;
@@ -1869,7 +1869,7 @@ static int lio_tpg_check_demo_mode_write_protect(
 	return tpg->tpg_attrib.demo_mode_write_protect;
 }
 
-static int lio_tpg_check_prod_mode_write_protect(
+static bool lio_tpg_check_prod_mode_write_protect(
 	struct se_portal_group *se_tpg)
 {
 	struct iscsi_portal_group *tpg = se_tpg->se_tpg_fabric_ptr;
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index ab3ab27..48a5b42 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -750,23 +750,23 @@ static char *tcm_loop_parse_pr_out_transport_id(
  * Returning (1) here allows for target_core_mod struct se_node_acl to be generated
  * based upon the incoming fabric dependent SCSI Initiator Port
  */
-static int tcm_loop_check_demo_mode(struct se_portal_group *se_tpg)
+static bool tcm_loop_check_demo_mode(struct se_portal_group *se_tpg)
 {
-	return 1;
+	return true;
 }
 
-static int tcm_loop_check_demo_mode_cache(struct se_portal_group *se_tpg)
+static bool tcm_loop_check_demo_mode_cache(struct se_portal_group *se_tpg)
 {
-	return 0;
+	return false;
 }
 
 /*
  * Allow I_T Nexus full READ-WRITE access without explict Initiator Node ACLs for
  * local virtual Linux/SCSI LLD passthrough into VM hypervisor guest
  */
-static int tcm_loop_check_demo_mode_write_protect(struct se_portal_group *se_tpg)
+static bool tcm_loop_check_demo_mode_write_protect(struct se_portal_group *se_tpg)
 {
-	return 0;
+	return false;
 }
 
 /*
@@ -774,9 +774,9 @@ static int tcm_loop_check_demo_mode_write_protect(struct se_portal_group *se_tpg
  * never be called for TCM_Loop by target_core_fabric_configfs.c code.
  * It has been added here as a nop for target_fabric_tf_ops_check()
  */
-static int tcm_loop_check_prod_mode_write_protect(struct se_portal_group *se_tpg)
+static bool tcm_loop_check_prod_mode_write_protect(struct se_portal_group *se_tpg)
 {
-	return 0;
+	return false;
 }
 
 static struct se_node_acl *tcm_loop_tpg_alloc_fabric_acl(
diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index e7e9372..d56bfce 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -1679,14 +1679,14 @@ static void sbp_management_agent_unregister(struct sbp_management_agent *agent)
 	kfree(agent);
 }
 
-static int sbp_check_true(struct se_portal_group *se_tpg)
+static bool sbp_check_true(struct se_portal_group *se_tpg)
 {
-	return 1;
+	return true;
 }
 
-static int sbp_check_false(struct se_portal_group *se_tpg)
+static bool sbp_check_false(struct se_portal_group *se_tpg)
 {
-	return 0;
+	return false;
 }
 
 static char *sbp_get_fabric_name(void)
diff --git a/drivers/target/tcm_fc/tfc_conf.c b/drivers/target/tcm_fc/tfc_conf.c
index efdcb96..b35b283 100644
--- a/drivers/target/tcm_fc/tfc_conf.c
+++ b/drivers/target/tcm_fc/tfc_conf.c
@@ -491,9 +491,9 @@ static u32 ft_get_default_depth(struct se_portal_group *se_tpg)
 	return 1;
 }
 
-static int ft_check_false(struct se_portal_group *se_tpg)
+static bool ft_check_false(struct se_portal_group *se_tpg)
 {
-	return 0;
+	return false;
 }
 
 static void ft_set_default_node_attr(struct se_node_acl *se_nacl)
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 69906ca..48a44ba 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -278,14 +278,14 @@ static void tcm_vhost_put_inflight(struct vhost_scsi_inflight *inflight)
 	kref_put(&inflight->kref, tcm_vhost_done_inflight);
 }
 
-static int tcm_vhost_check_true(struct se_portal_group *se_tpg)
+static bool tcm_vhost_check_true(struct se_portal_group *se_tpg)
 {
-	return 1;
+	return true;
 }
 
-static int tcm_vhost_check_false(struct se_portal_group *se_tpg)
+static bool tcm_vhost_check_false(struct se_portal_group *se_tpg)
 {
-	return 0;
+	return false;
 }
 
 static char *tcm_vhost_get_fabric_name(void)
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 22a4e98..bc1e9f6 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -17,16 +17,16 @@ struct target_core_fabric_ops {
 				struct t10_pr_registration *, int *);
 	char *(*tpg_parse_pr_out_transport_id)(struct se_portal_group *,
 				const char *, u32 *, char **);
-	int (*tpg_check_demo_mode)(struct se_portal_group *);
-	int (*tpg_check_demo_mode_cache)(struct se_portal_group *);
-	int (*tpg_check_demo_mode_write_protect)(struct se_portal_group *);
-	int (*tpg_check_prod_mode_write_protect)(struct se_portal_group *);
+	bool (*tpg_check_demo_mode)(struct se_portal_group *);
+	bool (*tpg_check_demo_mode_cache)(struct se_portal_group *);
+	bool (*tpg_check_demo_mode_write_protect)(struct se_portal_group *);
+	bool (*tpg_check_prod_mode_write_protect)(struct se_portal_group *);
 	/*
 	 * Optionally used by fabrics to allow demo-mode login, but not
 	 * expose any TPG LUNs, and return 'not connected' in standard
 	 * inquiry response
 	 */
-	int (*tpg_check_demo_mode_login_only)(struct se_portal_group *);
+	bool (*tpg_check_demo_mode_login_only)(struct se_portal_group *);
 	struct se_node_acl *(*tpg_alloc_fabric_acl)(
 					struct se_portal_group *);
 	void (*tpg_release_fabric_acl)(struct se_portal_group *,
-- 
1.9.3
