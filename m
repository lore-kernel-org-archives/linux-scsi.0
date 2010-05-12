From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 3/5] [TCM]: Add TPG parameter to struct target_core_fabric_ops->tpg_parse_pr_out_transport_id()
Date: Wed, 12 May 2010 00:35:42 -0700
Message-ID: <1273649742-21769-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp103.sbc.mail.gq1.yahoo.com ([67.195.15.62]:24037 "HELO
	smtp103.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751584Ab0ELFSz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 May 2010 01:18:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LIO-Target devel <linux-iscsi-target-dev@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.e>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds the missing se_portal_group_t * parameter to
struct target_core_fabric_ops->tpg_parse_pr_out_transport_id() so TCM fabric modules
can locate internal TPG state to determine which Target Endpoint SCSI protocol logic
should be followed when the TCM fabric module is supporting for more than a single
SCSI protocol.

The patch updates TCM -> tpg_parse_pr_out_transport_id() usage in target_core_pr.c
for SPEC_I_PT=1 + REGISTER_AND_MOVE ops.

It also updates the individual fabric module usages for TCM_Loop, TCM_FC and LIO-Target.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/lio-target/iscsi_target_tpg.c |    1 +
 drivers/target/lio-target/iscsi_target_tpg.h |    3 ++-
 drivers/target/target_core_pr.c              |    4 ++--
 drivers/target/tcm_fc/tfc_conf.c             |    3 ++-
 drivers/target/tcm_loop/tcm_loop_fabric.c    |    1 +
 drivers/target/tcm_loop/tcm_loop_fabric.h    |    3 ++-
 include/target/target_core_fabric_ops.h      |    3 ++-
 7 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/target/lio-target/iscsi_target_tpg.c b/drivers/target/lio-target/iscsi_target_tpg.c
index 670d6b7..c729043 100644
--- a/drivers/target/lio-target/iscsi_target_tpg.c
+++ b/drivers/target/lio-target/iscsi_target_tpg.c
@@ -234,6 +234,7 @@ u32 lio_tpg_get_pr_transport_id_len(
 }
 
 char *lio_tpg_parse_pr_out_transport_id(
+	se_portal_group_t *se_tpg,
 	const char *buf,
 	u32 *out_tid_len,
 	char **port_nexus_ptr)
diff --git a/drivers/target/lio-target/iscsi_target_tpg.h b/drivers/target/lio-target/iscsi_target_tpg.h
index e3bdb78..46b8518 100644
--- a/drivers/target/lio-target/iscsi_target_tpg.h
+++ b/drivers/target/lio-target/iscsi_target_tpg.h
@@ -10,7 +10,8 @@ extern u32 lio_tpg_get_pr_transport_id(struct se_portal_group_s *,
 extern u32 lio_tpg_get_pr_transport_id_len(struct se_portal_group_s *,
 			struct se_node_acl_s *, struct t10_pr_registration_s *,
 			int *);
-extern char *lio_tpg_parse_pr_out_transport_id(const char *, u32 *, char **);
+extern char *lio_tpg_parse_pr_out_transport_id(struct se_portal_group_s *,
+			const char *, u32 *, char **);
 extern int lio_tpg_check_demo_mode(struct se_portal_group_s *);
 extern int lio_tpg_check_demo_mode_cache(struct se_portal_group_s *);
 extern int lio_tpg_check_demo_mode_write_protect(struct se_portal_group_s *);
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index f78d279..2136e89 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -1581,7 +1581,7 @@ static int core_scsi3_decode_spec_i_port(
 			dest_rtpi = tmp_port->sep_rtpi;
 
 			i_str = tmp_tf_ops->tpg_parse_pr_out_transport_id(
-					(const char *)ptr, &tid_len,
+					tmp_tpg, (const char *)ptr, &tid_len,
 					&iport_ptr);
 			if (!(i_str))
 				continue;
@@ -3442,7 +3442,7 @@ static int core_scsi3_emulate_pro_register_and_move(
 		ret = PYX_TRANSPORT_LU_COMM_FAILURE;
 		goto out;
 	}
-	initiator_str = dest_tf_ops->tpg_parse_pr_out_transport_id(
+	initiator_str = dest_tf_ops->tpg_parse_pr_out_transport_id(dest_se_tpg,
 			(const char *)&buf[24], &tmp_tid_len, &iport_ptr);
 	if (!(initiator_str)) {
 		printk(KERN_ERR "SPC-3 PR REGISTER_AND_MOVE: Unable to locate"
diff --git a/drivers/target/tcm_fc/tfc_conf.c b/drivers/target/tcm_fc/tfc_conf.c
index 69b0092..1315df6 100644
--- a/drivers/target/tcm_fc/tfc_conf.c
+++ b/drivers/target/tcm_fc/tfc_conf.c
@@ -536,7 +536,8 @@ static u32 ft_get_pr_transport_id(se_portal_group_t *se_tpg,
 	return ft_get_pr_transport_id_len(se_tpg, se_nacl, pr_reg, format_code);
 }
 
-static char *ft_parse_pr_out_transport_id(const char *buf, u32 *out_tid_len,
+static char *ft_parse_pr_out_transport_id(se_portal_group_t *se_tpg,
+				          const char *buf, u32 *out_tid_len,
 					  char **port_nexus_ptr)
 {
 	struct ft_transport_id *id = (struct ft_transport_id *)buf;
diff --git a/drivers/target/tcm_loop/tcm_loop_fabric.c b/drivers/target/tcm_loop/tcm_loop_fabric.c
index 11cf196..30a90ec 100644
--- a/drivers/target/tcm_loop/tcm_loop_fabric.c
+++ b/drivers/target/tcm_loop/tcm_loop_fabric.c
@@ -144,6 +144,7 @@ u32 tcm_loop_get_pr_transport_id_len(
  * Persistent Reservation SPEC_I_PT=1 and PROUT REGISTER_AND_MOVE operations.
  */
 char *tcm_loop_parse_pr_out_transport_id(
+	se_portal_group_t *se_tpg,
 	const char *buf,
 	u32 *out_tid_len,
 	char **port_nexus_ptr)
diff --git a/drivers/target/tcm_loop/tcm_loop_fabric.h b/drivers/target/tcm_loop/tcm_loop_fabric.h
index 676c33a..d412b4a 100644
--- a/drivers/target/tcm_loop/tcm_loop_fabric.h
+++ b/drivers/target/tcm_loop/tcm_loop_fabric.h
@@ -9,7 +9,8 @@ extern u32 tcm_loop_get_pr_transport_id(se_portal_group_t *, se_node_acl_t *,
 extern u32 tcm_loop_get_pr_transport_id_len(se_portal_group_t *,
 				se_node_acl_t *, t10_pr_registration_t *,
 				int *);
-extern char *tcm_loop_parse_pr_out_transport_id(const char *, u32 *, char **);
+extern char *tcm_loop_parse_pr_out_transport_id(se_portal_group_t *,
+				const char *, u32 *, char **);
 extern int tcm_loop_check_demo_mode(se_portal_group_t *);
 extern int tcm_loop_check_demo_mode_cache(se_portal_group_t *);
 extern int tcm_loop_check_demo_mode_write_protect(se_portal_group_t *);
diff --git a/include/target/target_core_fabric_ops.h b/include/target/target_core_fabric_ops.h
index 4b4d5c6..ebc5a03 100644
--- a/include/target/target_core_fabric_ops.h
+++ b/include/target/target_core_fabric_ops.h
@@ -15,7 +15,8 @@ struct target_core_fabric_ops {
 	u32 (*tpg_get_pr_transport_id_len)(struct se_portal_group_s *,
 				struct se_node_acl_s *,
 				struct t10_pr_registration_s *, int *);
-	char *(*tpg_parse_pr_out_transport_id)(const char *, u32 *, char **);
+	char *(*tpg_parse_pr_out_transport_id)(struct se_portal_group_s *,
+				const char *, u32 *, char **);
 	int (*tpg_check_demo_mode)(struct se_portal_group_s *);
 	int (*tpg_check_demo_mode_cache)(struct se_portal_group_s *);
 	int (*tpg_check_demo_mode_write_protect)(struct se_portal_group_s *);
-- 
1.5.6.5

