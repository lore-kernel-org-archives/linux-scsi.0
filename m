From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 1/4] target: remove unneeded array
Date: Sun, 30 Nov 2014 19:14:12 +0100
Message-ID: <1417371255-2282-2-git-send-email-Julia.Lawall@lip6.fr>
References: <1417371255-2282-1-git-send-email-Julia.Lawall@lip6.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1417371255-2282-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: kernel-janitors@vger.kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Delete a local array that is only used to be initialized by memset.

A semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier x;
type T;
@@

{
... when any
-T x[...];
<+... when != x
- memset(x,...);
...+>
}
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/target/target_core_pr.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 4c261c3..a0f850b 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -1429,14 +1429,12 @@ core_scsi3_decode_spec_i_port(
 	struct target_core_fabric_ops *tmp_tf_ops;
 	unsigned char *buf;
 	unsigned char *ptr, *i_str = NULL, proto_ident, tmp_proto_ident;
-	char *iport_ptr = NULL, dest_iport[64], i_buf[PR_REG_ISID_ID_LEN];
+	char *iport_ptr = NULL, i_buf[PR_REG_ISID_ID_LEN];
 	sense_reason_t ret;
 	u32 tpdl, tid_len = 0;
 	int dest_local_nexus;
 	u32 dest_rtpi = 0;
 
-	memset(dest_iport, 0, 64);
-
 	local_se_deve = se_sess->se_node_acl->device_list[cmd->orig_fe_lun];
 	/*
 	 * Allocate a struct pr_transport_id_holder and setup the
@@ -3059,7 +3057,7 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	struct t10_reservation *pr_tmpl = &dev->t10_pr;
 	unsigned char *buf;
 	unsigned char *initiator_str;
-	char *iport_ptr = NULL, dest_iport[64], i_buf[PR_REG_ISID_ID_LEN];
+	char *iport_ptr = NULL, i_buf[PR_REG_ISID_ID_LEN];
 	u32 tid_len, tmp_tid_len;
 	int new_reg = 0, type, scope, matching_iname;
 	sense_reason_t ret;
@@ -3071,7 +3069,6 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
 
-	memset(dest_iport, 0, 64);
 	memset(i_buf, 0, PR_REG_ISID_ID_LEN);
 	se_tpg = se_sess->se_tpg;
 	tf_ops = se_tpg->se_tpg_tfo;
