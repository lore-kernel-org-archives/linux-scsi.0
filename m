From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v3 04/10] target/pr: cleanup core_scsi3_pr_seq_non_holder
Date: Tue, 26 May 2015 06:25:24 +0000
Message-ID: <1432621530-24171-5-git-send-email-nab@daterainc.com>
References: <1432621530-24171-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [209.85.214.182] ([209.85.214.182]:33660 "EHLO
	mail-ob0-f182.google.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751364AbbEZGgN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 May 2015 02:36:13 -0400
Received: by obbnx5 with SMTP id nx5so67135501obb.0
        for <linux-scsi@vger.kernel.org>; Mon, 25 May 2015 23:35:33 -0700 (PDT)
In-Reply-To: <1432621530-24171-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

From: Christoph Hellwig <hch@lst.de>

Clean up the mess of registered variables, and pass the isid mismatch
flag explicitly instead of overloading the registration type.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_pr.c | 44 +++++++++++++++++------------------------
 1 file changed, 18 insertions(+), 26 deletions(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index a3859ef..730f885 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -312,34 +312,31 @@ out:
  * This function is called by those initiator ports who are *NOT*
  * the active PR reservation holder when a reservation is present.
  */
-static int core_scsi3_pr_seq_non_holder(
-	struct se_cmd *cmd,
-	u32 pr_reg_type)
+static int core_scsi3_pr_seq_non_holder(struct se_cmd *cmd, u32 pr_reg_type,
+					bool isid_mismatch)
 {
 	unsigned char *cdb = cmd->t_task_cdb;
-	struct se_dev_entry *se_deve;
 	struct se_session *se_sess = cmd->se_sess;
 	struct se_node_acl *nacl = se_sess->se_node_acl;
-	int other_cdb = 0, ignore_reg;
+	int other_cdb = 0;
 	int registered_nexus = 0, ret = 1; /* Conflict by default */
 	int all_reg = 0, reg_only = 0; /* ALL_REG, REG_ONLY */
 	int we = 0; /* Write Exclusive */
 	int legacy = 0; /* Act like a legacy device and return
 			 * RESERVATION CONFLICT on some CDBs */
-	bool registered = false;
 
-	rcu_read_lock();
-	se_deve = target_nacl_find_deve(nacl, cmd->orig_fe_lun);
-	if (se_deve)
-		registered = test_bit(DEF_PR_REG_ACTIVE, &se_deve->deve_flags);
-	rcu_read_unlock();
-	/*
-	 * Determine if the registration should be ignored due to
-	 * non-matching ISIDs in target_scsi3_pr_reservation_check().
-	 */
-	ignore_reg = (pr_reg_type & 0x80000000);
-	if (ignore_reg)
-		pr_reg_type &= ~0x80000000;
+	if (isid_mismatch) {
+		registered_nexus = 0;
+	} else {
+		struct se_dev_entry *se_deve;
+
+		rcu_read_lock();
+		se_deve = target_nacl_find_deve(nacl, cmd->orig_fe_lun);
+		if (se_deve)
+			registered_nexus = test_bit(DEF_PR_REG_ACTIVE,
+						    &se_deve->deve_flags);
+		rcu_read_unlock();
+	}
 
 	switch (pr_reg_type) {
 	case PR_TYPE_WRITE_EXCLUSIVE:
@@ -349,8 +346,6 @@ static int core_scsi3_pr_seq_non_holder(
 		 * Some commands are only allowed for the persistent reservation
 		 * holder.
 		 */
-		if ((registered) && !(ignore_reg))
-			registered_nexus = 1;
 		break;
 	case PR_TYPE_WRITE_EXCLUSIVE_REGONLY:
 		we = 1;
@@ -359,8 +354,6 @@ static int core_scsi3_pr_seq_non_holder(
 		 * Some commands are only allowed for registered I_T Nexuses.
 		 */
 		reg_only = 1;
-		if ((registered) && !(ignore_reg))
-			registered_nexus = 1;
 		break;
 	case PR_TYPE_WRITE_EXCLUSIVE_ALLREG:
 		we = 1;
@@ -369,8 +362,6 @@ static int core_scsi3_pr_seq_non_holder(
 		 * Each registered I_T Nexus is a reservation holder.
 		 */
 		all_reg = 1;
-		if ((registered) && !(ignore_reg))
-			registered_nexus = 1;
 		break;
 	default:
 		return -EINVAL;
@@ -576,6 +567,7 @@ target_scsi3_pr_reservation_check(struct se_cmd *cmd)
 	struct se_device *dev = cmd->se_dev;
 	struct se_session *sess = cmd->se_sess;
 	u32 pr_reg_type;
+	bool isid_mismatch = false;
 
 	if (!dev->dev_pr_res_holder)
 		return 0;
@@ -588,7 +580,7 @@ target_scsi3_pr_reservation_check(struct se_cmd *cmd)
 	if (dev->dev_pr_res_holder->isid_present_at_reg) {
 		if (dev->dev_pr_res_holder->pr_reg_bin_isid !=
 		    sess->sess_bin_isid) {
-			pr_reg_type |= 0x80000000;
+			isid_mismatch = true;
 			goto check_nonholder;
 		}
 	}
@@ -596,7 +588,7 @@ target_scsi3_pr_reservation_check(struct se_cmd *cmd)
 	return 0;
 
 check_nonholder:
-	if (core_scsi3_pr_seq_non_holder(cmd, pr_reg_type))
+	if (core_scsi3_pr_seq_non_holder(cmd, pr_reg_type, isid_mismatch))
 		return TCM_RESERVATION_CONFLICT;
 	return 0;
 }
-- 
1.9.1

