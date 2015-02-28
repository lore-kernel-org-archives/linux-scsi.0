From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 2/9] target: Add protected fabric + unprotected device support
Date: Sat, 28 Feb 2015 10:35:59 +0000
Message-ID: <1425119766-11878-3-git-send-email-nab@daterainc.com>
References: <1425119766-11878-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:33008 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbbB1LJ7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Feb 2015 06:09:59 -0500
Received: by mail-ob0-f175.google.com with SMTP id va2so23308608obc.6
        for <linux-scsi@vger.kernel.org>; Sat, 28 Feb 2015 03:09:59 -0800 (PST)
In-Reply-To: <1425119766-11878-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Martin Petersen <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Doug Gilbert <dgilbert@interlog.com>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds a new target_core_fabric_ops callback for allowing fabric
drivers to expose a TPG attribute for signaling when a T10-PI protected
fabric wants to function with an un-protected device without T10-PI.

This specifically is to allow LIO to perform WRITE_STRIP + READ_INSERT
operations when functioning with non T10-PI enabled devices, seperate
from any available hw offloads the fabric supports.

This is done using a new se_sess->sess_prot_type that is set at fabric
session creation time based upon the TPG attribute.  It currently cannot
be changed for individual sessions after initial creation.

Also, update existing target_core_sbc.c code to honor sess_prot_type when
setting up cmd->prot_op + cmd->prot_type assignments.

Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Doug Gilbert <dgilbert@interlog.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_sbc.c       | 44 +++++++++++++++++++++++++---------
 drivers/target/target_core_transport.c |  8 +++++++
 include/target/target_core_base.h      |  1 +
 include/target/target_core_fabric.h    |  8 +++++++
 4 files changed, 50 insertions(+), 11 deletions(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 95a7a74..5b3564a 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -581,12 +581,13 @@ sbc_compare_and_write(struct se_cmd *cmd)
 }
 
 static int
-sbc_set_prot_op_checks(u8 protect, enum target_prot_type prot_type,
+sbc_set_prot_op_checks(u8 protect, bool fabric_prot, enum target_prot_type prot_type,
 		       bool is_write, struct se_cmd *cmd)
 {
 	if (is_write) {
-		cmd->prot_op = protect ? TARGET_PROT_DOUT_PASS :
-					 TARGET_PROT_DOUT_INSERT;
+		cmd->prot_op = fabric_prot ? TARGET_PROT_DOUT_STRIP :
+			       protect ? TARGET_PROT_DOUT_PASS :
+			       TARGET_PROT_DOUT_INSERT;
 		switch (protect) {
 		case 0x0:
 		case 0x3:
@@ -610,8 +611,9 @@ sbc_set_prot_op_checks(u8 protect, enum target_prot_type prot_type,
 			return -EINVAL;
 		}
 	} else {
-		cmd->prot_op = protect ? TARGET_PROT_DIN_PASS :
-					 TARGET_PROT_DIN_STRIP;
+		cmd->prot_op = fabric_prot ? TARGET_PROT_DIN_INSERT :
+			       protect ? TARGET_PROT_DIN_PASS :
+			       TARGET_PROT_DIN_STRIP;
 		switch (protect) {
 		case 0x0:
 		case 0x1:
@@ -644,11 +646,15 @@ sbc_check_prot(struct se_device *dev, struct se_cmd *cmd, unsigned char *cdb,
 	       u32 sectors, bool is_write)
 {
 	u8 protect = cdb[1] >> 5;
+	int sp_ops = cmd->se_sess->sup_prot_ops;
+	int pi_prot_type = dev->dev_attrib.pi_prot_type;
+	bool fabric_prot = false;
 
 	if (!cmd->t_prot_sg || !cmd->t_prot_nents) {
-		if (protect && !dev->dev_attrib.pi_prot_type) {
-			pr_err("CDB contains protect bit, but device does not"
-			       " advertise PROTECT=1 feature bit\n");
+		if (protect &&
+		    !dev->dev_attrib.pi_prot_type && !cmd->se_sess->sess_prot_type) {
+			pr_err("CDB contains protect bit, but device + fabric does"
+			       " not advertise PROTECT=1 feature bit\n");
 			return TCM_INVALID_CDB_FIELD;
 		}
 		if (cmd->prot_pto)
@@ -669,15 +675,28 @@ sbc_check_prot(struct se_device *dev, struct se_cmd *cmd, unsigned char *cdb,
 		cmd->reftag_seed = cmd->t_task_lba;
 		break;
 	case TARGET_DIF_TYPE0_PROT:
+		/*
+		 * See if the fabric supports T10-PI, and the session has been
+		 * configured to allow export PROTECT=1 feature bit with backend
+		 * devices that don't support T10-PI.
+		 */
+		fabric_prot = is_write ?
+			      (sp_ops & (TARGET_PROT_DOUT_PASS | TARGET_PROT_DOUT_STRIP)) :
+			      (sp_ops & (TARGET_PROT_DIN_PASS | TARGET_PROT_DIN_INSERT));
+
+		if (fabric_prot && cmd->se_sess->sess_prot_type) {
+			pi_prot_type = cmd->se_sess->sess_prot_type;
+			break;
+		}
+		/* Fallthrough */
 	default:
 		return TCM_NO_SENSE;
 	}
 
-	if (sbc_set_prot_op_checks(protect, dev->dev_attrib.pi_prot_type,
-				   is_write, cmd))
+	if (sbc_set_prot_op_checks(protect, fabric_prot, pi_prot_type, is_write, cmd))
 		return TCM_INVALID_CDB_FIELD;
 
-	cmd->prot_type = dev->dev_attrib.pi_prot_type;
+	cmd->prot_type = pi_prot_type;
 	cmd->prot_length = dev->prot_length * sectors;
 
 	/**
@@ -1231,6 +1250,9 @@ sbc_dif_copy_prot(struct se_cmd *cmd, unsigned int sectors, bool read,
 	unsigned int i, len, left;
 	unsigned int offset = sg_off;
 
+	if (!sg)
+		return;
+
 	left = sectors * dev->prot_length;
 
 	for_each_sg(cmd->t_prot_sg, psg, cmd->t_prot_nents, i) {
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index ac3cbab..38d9d1b 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -322,11 +322,19 @@ void __transport_register_session(
 	struct se_session *se_sess,
 	void *fabric_sess_ptr)
 {
+	struct target_core_fabric_ops *tfo = se_tpg->se_tpg_tfo;
 	unsigned char buf[PR_REG_ISID_LEN];
 
 	se_sess->se_tpg = se_tpg;
 	se_sess->fabric_sess_ptr = fabric_sess_ptr;
 	/*
+	 * Determine if fabric allows for T10-PI feature bits to be exposed
+	 * to initiators for device backends with !dev->dev_attrib.pi_prot_type
+	 */
+	if (tfo->tpg_check_prot_fabric_only)
+		se_sess->sess_prot_type = tfo->tpg_check_prot_fabric_only(se_tpg);
+
+	/*
 	 * Used by struct se_node_acl's under ConfigFS to locate active se_session-t
 	 *
 	 * Only set for struct se_session's that will actually be moving I/O.
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 672150b..fe25a78 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -616,6 +616,7 @@ struct se_session {
 	unsigned		sess_tearing_down:1;
 	u64			sess_bin_isid;
 	enum target_prot_op	sup_prot_ops;
+	enum target_prot_type	sess_prot_type;
 	struct se_node_acl	*se_node_acl;
 	struct se_portal_group *se_tpg;
 	void			*fabric_sess_ptr;
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 22a4e98e..9811c85 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -27,6 +27,14 @@ struct target_core_fabric_ops {
 	 * inquiry response
 	 */
 	int (*tpg_check_demo_mode_login_only)(struct se_portal_group *);
+	/*
+	 * Optionally used as a configfs tunable to determine when
+	 * target-core should signal the PROTECT=1 feature bit for
+	 * backends that don't support T10-PI, so that either fabric
+	 * HW offload or target-core emulation performs the associated
+	 * WRITE_STRIP and READ_INSERT operations.
+	 */
+	int (*tpg_check_prot_fabric_only)(struct se_portal_group *);
 	struct se_node_acl *(*tpg_alloc_fabric_acl)(
 					struct se_portal_group *);
 	void (*tpg_release_fabric_acl)(struct se_portal_group *,
-- 
1.9.1

