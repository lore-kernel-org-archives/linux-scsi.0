From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/5] [TCM]: Add TPG parameter to struct target_core_fabric_ops->get_fabric_proto_ident()
Date: Wed, 12 May 2010 00:35:35 -0700
Message-ID: <1273649735-21746-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp104.sbc.mail.gq1.yahoo.com ([67.195.15.63]:37412 "HELO
	smtp104.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751584Ab0ELFSs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 May 2010 01:18:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LIO-Target devel <linux-iscsi-target-dev@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.e>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds a se_portal_group_t * parameter to struct target_core_fabric_ops->get_fabric_proto_ident()
so TCM fabric modules can locate internal TPG state to determine which Target Endpoint
SCSI protocol identifier should be reported based if the TCM fabric module is reporting
more than a single SCSI protocol.

It updates TCM ->get_fabric_proto_ident() parameter usage in target_core_pr.c for
SPEC_I_PT=1 + REGISTER_AND_MOVE ops, as well as in transport_generic_emulate_inquiry() for
EVPD 0x83 emulation.

It also updates the individual fabric module usages for TCM_Loop, TCM_FC and LIO-Target.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/lio-target/iscsi_target.c  |    2 +-
 drivers/target/lio-target/iscsi_target.h  |    2 +-
 drivers/target/target_core_pr.c           |    6 +++---
 drivers/target/target_core_transport.c    |    6 +++---
 drivers/target/tcm_fc/tfc_conf.c          |    2 +-
 drivers/target/tcm_loop/tcm_loop_fabric.c |    2 +-
 drivers/target/tcm_loop/tcm_loop_fabric.h |    2 +-
 include/target/target_core_fabric_ops.h   |    2 +-
 8 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/target/lio-target/iscsi_target.c b/drivers/target/lio-target/iscsi_target.c
index e4d3645..dce3f30 100644
--- a/drivers/target/lio-target/iscsi_target.c
+++ b/drivers/target/lio-target/iscsi_target.c
@@ -1197,7 +1197,7 @@ char *iscsi_get_fabric_name(void)
 	return "iSCSI";
 }
 
-u8 iscsi_get_fabric_proto_ident(void)
+u8 iscsi_get_fabric_proto_ident(se_portal_group_t *se_tpg)
 {
 	/*
 	 * This value is defined for "Internet SCSI (iSCSI)"
diff --git a/drivers/target/lio-target/iscsi_target.h b/drivers/target/lio-target/iscsi_target.h
index 26e4397..db030d1 100644
--- a/drivers/target/lio-target/iscsi_target.h
+++ b/drivers/target/lio-target/iscsi_target.h
@@ -16,7 +16,7 @@ extern int core_reset_np_thread(struct iscsi_np_s *, struct iscsi_tpg_np_s *,
 				struct iscsi_portal_group_s *, int);
 extern int core_del_np(iscsi_np_t *);
 extern char *iscsi_get_fabric_name(void);
-extern u8 iscsi_get_fabric_proto_ident(void);
+extern u8 iscsi_get_fabric_proto_ident(struct se_portal_group_s *);
 extern iscsi_cmd_t *iscsi_get_cmd(struct se_cmd_s *);
 extern u32 iscsi_get_task_tag(struct se_cmd_s *);
 extern int iscsi_get_cmd_state(struct se_cmd_s *);
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index c700daf..f78d279 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -1575,7 +1575,7 @@ static int core_scsi3_decode_spec_i_port(
 			 * Look for the matching proto_ident provided by
 			 * the received TransportID
 			 */
-			tmp_proto_ident = tmp_tf_ops->get_fabric_proto_ident();
+			tmp_proto_ident = tmp_tf_ops->get_fabric_proto_ident(tmp_tpg);
 			if (tmp_proto_ident != proto_ident) 
 				continue;
 			dest_rtpi = tmp_port->sep_rtpi;
@@ -3426,11 +3426,11 @@ static int core_scsi3_emulate_pro_register_and_move(
 	printk("SPC-3 PR REGISTER_AND_MOVE: Extracted Protocol Identifier:"
 			" 0x%02x\n", proto_ident);
 #endif
-	if (proto_ident != dest_tf_ops->get_fabric_proto_ident()) {
+	if (proto_ident != dest_tf_ops->get_fabric_proto_ident(dest_se_tpg)) {
 		printk(KERN_ERR "SPC-3 PR REGISTER_AND_MOVE: Received"
 			" proto_ident: 0x%02x does not match ident: 0x%02x"
 			" from fabric: %s\n", proto_ident,
-			dest_tf_ops->get_fabric_proto_ident(),
+			dest_tf_ops->get_fabric_proto_ident(dest_se_tpg),
 			dest_tf_ops->get_fabric_name());
 		ret = PYX_TRANSPORT_INVALID_PARAMETER_LIST;
 		goto out;
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index b70e9c3..bc9d3aa 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -4679,7 +4679,7 @@ check_port:
 				goto check_tpgi;
 			}
 			buf[off] =
-				(TPG_TFO(tpg)->get_fabric_proto_ident() << 4);
+				(TPG_TFO(tpg)->get_fabric_proto_ident(tpg) << 4);
 			buf[off++] |= 0x1; /* CODE SET == Binary */
 			buf[off] = 0x80; /* Set PIV=1 */
 			/* Set ASSOICATION == target port: 01b */
@@ -4724,7 +4724,7 @@ check_tpgi:
 			spin_unlock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
 
 			buf[off] =
-				(TPG_TFO(tpg)->get_fabric_proto_ident() << 4);
+				(TPG_TFO(tpg)->get_fabric_proto_ident(tpg) << 4);
 			buf[off++] |= 0x1; /* CODE SET == Binary */
 			buf[off] = 0x80; /* Set PIV=1 */
 			/* Set ASSOICATION == target port: 01b */
@@ -4791,7 +4791,7 @@ check_scsi_name:
 				goto set_len;
 			}
 			buf[off] =
-				(TPG_TFO(tpg)->get_fabric_proto_ident() << 4);
+				(TPG_TFO(tpg)->get_fabric_proto_ident(tpg) << 4);
 			buf[off++] |= 0x3; /* CODE SET == UTF-8 */
 			buf[off] = 0x80; /* Set PIV=1 */
 			/* Set ASSOICATION == target port: 01b */
diff --git a/drivers/target/tcm_fc/tfc_conf.c b/drivers/target/tcm_fc/tfc_conf.c
index 5608e3c..69b0092 100644
--- a/drivers/target/tcm_fc/tfc_conf.c
+++ b/drivers/target/tcm_fc/tfc_conf.c
@@ -480,7 +480,7 @@ static char *ft_get_fabric_name(void)
 	return "fc";
 }
 
-static u8 ft_get_fabric_proto_ident(void)
+static u8 ft_get_fabric_proto_ident(se_portal_group_t *se_tpg)
 {
 	return 0;	/* 0 = fcp-2 per SPC4 section 7.5.1 */
 }
diff --git a/drivers/target/tcm_loop/tcm_loop_fabric.c b/drivers/target/tcm_loop/tcm_loop_fabric.c
index 891c198..11cf196 100644
--- a/drivers/target/tcm_loop/tcm_loop_fabric.c
+++ b/drivers/target/tcm_loop/tcm_loop_fabric.c
@@ -51,7 +51,7 @@ char *tcm_loop_get_fabric_name(void)
 	return "loopback";
 }
 
-u8 tcm_loop_get_fabric_proto_ident(void)
+u8 tcm_loop_get_fabric_proto_ident(se_portal_group_t *se_tpg)
 {
 	/*
 	 * Return a SAS Serial SCSI Protocol identifier for loopback operations
diff --git a/drivers/target/tcm_loop/tcm_loop_fabric.h b/drivers/target/tcm_loop/tcm_loop_fabric.h
index 17a63d3..676c33a 100644
--- a/drivers/target/tcm_loop/tcm_loop_fabric.h
+++ b/drivers/target/tcm_loop/tcm_loop_fabric.h
@@ -1,5 +1,5 @@
 extern char *tcm_loop_get_fabric_name(void);
-extern u8 tcm_loop_get_fabric_proto_ident(void);
+extern u8 tcm_loop_get_fabric_proto_ident(se_portal_group_t *);
 extern char *tcm_loop_get_endpoint_wwn(se_portal_group_t *);
 extern u16 tcm_loop_get_tag(se_portal_group_t *);
 extern u32 tcm_loop_get_default_depth(se_portal_group_t *);
diff --git a/include/target/target_core_fabric_ops.h b/include/target/target_core_fabric_ops.h
index 5e63038..4b4d5c6 100644
--- a/include/target/target_core_fabric_ops.h
+++ b/include/target/target_core_fabric_ops.h
@@ -4,7 +4,7 @@ struct target_fabric_configfs;
 struct target_core_fabric_ops {
 	struct configfs_subsystem *tf_subsys;
 	char *(*get_fabric_name)(void);
-	u8 (*get_fabric_proto_ident)(void);
+	u8 (*get_fabric_proto_ident)(struct se_portal_group_s *);
 	char *(*tpg_get_wwn)(struct se_portal_group_s *);
 	u16 (*tpg_get_tag)(struct se_portal_group_s *);
 	u32 (*tpg_get_default_depth)(struct se_portal_group_s *);
-- 
1.5.6.5

