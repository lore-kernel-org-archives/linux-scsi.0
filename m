Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFD35C433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 21:42:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B369964EB8
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 21:42:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbhBTVmY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 20 Feb 2021 16:42:24 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:61339 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbhBTVl6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Feb 2021 16:41:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1613857317; x=1645393317;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=slEW5jUIHdjn6ZgklOXQG+55T+E7Y+l5P0x8rbnaJGc=;
  b=a2fhnTr34jrgs0DMUYFMgaW3FFcPGSXJuJZM+3dPvv7MzKFaHYtCnr4l
   VKTv7SlEnwjPR7BHCiJhKD+6WCzAtqez1hveRsON3IKuc6tE17iWPeYa8
   ELqDLJanaAlB+WyTzD34LMpLQcJZaepGH0ZCkZb0G/EdwflcQP7IYeOz7
   dd4Z9YnVzneB91pjMAg5OEQrTSF9qZjNWixiw2NP8Oc+Kv+qWoINLPTgJ
   ZmkTeFgTwUkHhtc1hBnzQyq0hB8+p/tpEZabuGvSfGUvM95kKxIRklRRq
   6lJD6OXOTmwHa9knPWwyXHxSf9QNq9T3QFgMM85zUeQ7+qsII6vMSuV9r
   A==;
IronPort-SDR: zpxZB9zCCrwwU4nZXmqt6kwEDIO7MkRquagMcxT+jKtYzU0pnn2gX8Uaz4Hc6Zxppft1nPKe/y
 lQfavDcd+Zl6NNS+JBfXlbsfRa6PxWD/OfLnsCGNmHB3e8UBJ3Nav6vkOuZbGh5v+60nNU3yMv
 lce916/HjECltogQ9OjIDkP7H4+CMjloBC5PiR/nZfDFXsuQwHp8oEz1N5kuQfWjmNaxmiDvg9
 +ghriwKe9pB/sQfmXb7ma1h08Yl2uPiqneaipP8ZgQArmF/ZIsRMGj85sakyzRvcZjrxZXqcOu
 tFw=
X-IronPort-AV: E=Sophos;i="5.81,193,1610380800"; 
   d="scan'208";a="270955012"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 21 Feb 2021 05:40:52 +0800
IronPort-SDR: uO0FNYYmxufwjbRexr2USOTzMbZ1apiTqWO18tD2WGKjkcdBaSyymoA/NSkfnQEVxbg18zdyk1
 2Z7HyEmHZFOuCH7TdPt8sg43SvMslNXxzUwx9xQ18Rw5w1/WxNt9EC7yA5igI/O2OgqwWCwXFG
 7Fn+BXdOlKcEi/8FF0VzNB5pEGN8q7rbFLgSZj0PJi0291SGFmhnJNKhDs6tUZh30RfFNjTxj2
 B1y8e0rI0xq6aAoMjKVrc2xLkbXNzX1wOwWX57EE+AqVwVDg6LNtR8aKweO18TxegRp0pJrg6N
 lnbeU3X3oLnSQWxWHGf6nbkv
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2021 13:24:15 -0800
IronPort-SDR: 52IIn5Z2HvQ2QL6R9+vrHuD/ZHyatKkqGm/NWnkdDPs5QJ1aoCEb5lV9Alli5MXBkGq0nHgulU
 RMEN8a7RAOZjmBP5JNzKtyGlKJ8r6E98zra/ovzGZuvjcWD/uKdx/UUeLLIJviR3DuNOBcMzVt
 Dawdc4If4XknE3xl/QSMy3Q7y7t2lWek0CcD7So9/xM9qOrwKw+sDK0IrscZGArm4Ve3db9mCb
 7TTRVanb2hT5glTrW2kJYiPRNvnB8ySTl6Kzt+24nnYKXYzUjDUlyvNdfLpDYbUxeSGYtCNiAz
 bgk=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
  by uls-op-cesaip02.wdc.com with ESMTP; 20 Feb 2021 13:40:52 -0800
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, hare@suse.de, jejb@linux.ibm.com,
        mlombard@redhat.com, michael.christie@oracle.com,
        houpu@bytedance.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [RFC PATCH 22/24] target/pr: remove the memset with declare-init
Date:   Sat, 20 Feb 2021 13:40:51 -0800
Message-Id: <20210220214051.7381-1-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.22.1.dirty
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 drivers/target/target_core_pr.c | 26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 3644d2642929..894cda06261c 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -896,9 +896,8 @@ static void core_scsi3_aptpl_reserve(
 	struct se_node_acl *node_acl,
 	struct t10_pr_registration *pr_reg)
 {
-	char i_buf[PR_REG_ISID_ID_LEN];
+	char i_buf[PR_REG_ISID_ID_LEN] = { };
 
-	memset(i_buf, 0, PR_REG_ISID_ID_LEN);
 	core_pr_dump_initiator_port(pr_reg, i_buf, PR_REG_ISID_ID_LEN);
 
 	spin_lock(&dev->dev_reservation_lock);
@@ -1021,9 +1020,8 @@ static void __core_scsi3_dump_registration(
 	enum register_type register_type)
 {
 	struct se_portal_group *se_tpg = nacl->se_tpg;
-	char i_buf[PR_REG_ISID_ID_LEN];
+	char i_buf[PR_REG_ISID_ID_LEN] = { };
 
-	memset(&i_buf[0], 0, PR_REG_ISID_ID_LEN);
 	core_pr_dump_initiator_port(pr_reg, i_buf, PR_REG_ISID_ID_LEN);
 
 	pr_debug("SPC-3 PR [%s] Service Action: REGISTER%s Initiator"
@@ -1283,11 +1281,10 @@ static void __core_scsi3_free_registration(
 	struct t10_reservation *pr_tmpl = &dev->t10_pr;
 	struct se_node_acl *nacl = pr_reg->pr_reg_nacl;
 	struct se_dev_entry *deve;
-	char i_buf[PR_REG_ISID_ID_LEN];
+	char i_buf[PR_REG_ISID_ID_LEN] = { };
 
 	lockdep_assert_held(&pr_tmpl->registration_lock);
 
-	memset(i_buf, 0, PR_REG_ISID_ID_LEN);
 	core_pr_dump_initiator_port(pr_reg, i_buf, PR_REG_ISID_ID_LEN);
 
 	if (!list_empty(&pr_reg->pr_reg_list))
@@ -2057,7 +2054,8 @@ core_scsi3_emulate_pro_register(struct se_cmd *cmd, u64 res_key, u64 sa_res_key,
 	struct se_portal_group *se_tpg;
 	struct t10_pr_registration *pr_reg, *pr_reg_p, *pr_reg_tmp;
 	struct t10_reservation *pr_tmpl = &dev->t10_pr;
-	unsigned char isid_buf[PR_REG_ISID_LEN], *isid_ptr = NULL;
+	unsigned char isid_buf[PR_REG_ISID_LEN] = { };
+	unsigned char *isid_ptr = NULL;
 	sense_reason_t ret = TCM_NO_SENSE;
 	int pr_holder = 0, type;
 
@@ -2068,7 +2066,6 @@ core_scsi3_emulate_pro_register(struct se_cmd *cmd, u64 res_key, u64 sa_res_key,
 	se_tpg = se_sess->se_tpg;
 
 	if (se_tpg->se_tpg_tfo->sess_get_initiator_sid) {
-		memset(&isid_buf[0], 0, PR_REG_ISID_LEN);
 		se_tpg->se_tpg_tfo->sess_get_initiator_sid(se_sess, &isid_buf[0],
 				PR_REG_ISID_LEN);
 		isid_ptr = &isid_buf[0];
@@ -2280,11 +2277,9 @@ core_scsi3_pro_reserve(struct se_cmd *cmd, int type, int scope, u64 res_key)
 	struct se_lun *se_lun = cmd->se_lun;
 	struct t10_pr_registration *pr_reg, *pr_res_holder;
 	struct t10_reservation *pr_tmpl = &dev->t10_pr;
-	char i_buf[PR_REG_ISID_ID_LEN];
+	char i_buf[PR_REG_ISID_ID_LEN] = { };
 	sense_reason_t ret;
 
-	memset(i_buf, 0, PR_REG_ISID_ID_LEN);
-
 	if (!se_sess || !se_lun) {
 		pr_err("SPC-3 PR: se_sess || struct se_lun is NULL!\n");
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
@@ -2455,12 +2450,11 @@ static void __core_scsi3_complete_pro_release(
 	int unreg)
 {
 	const struct target_core_fabric_ops *tfo = se_nacl->se_tpg->se_tpg_tfo;
-	char i_buf[PR_REG_ISID_ID_LEN];
+	char i_buf[PR_REG_ISID_ID_LEN] = { };
 	int pr_res_type = 0, pr_res_scope = 0;
 
 	lockdep_assert_held(&dev->dev_reservation_lock);
 
-	memset(i_buf, 0, PR_REG_ISID_ID_LEN);
 	core_pr_dump_initiator_port(pr_reg, i_buf, PR_REG_ISID_ID_LEN);
 	/*
 	 * Go ahead and release the current PR reservation holder.
@@ -2766,11 +2760,10 @@ static void __core_scsi3_complete_pro_preempt(
 {
 	struct se_node_acl *nacl = pr_reg->pr_reg_nacl;
 	const struct target_core_fabric_ops *tfo = nacl->se_tpg->se_tpg_tfo;
-	char i_buf[PR_REG_ISID_ID_LEN];
+	char i_buf[PR_REG_ISID_ID_LEN] = { };
 
 	lockdep_assert_held(&dev->dev_reservation_lock);
 
-	memset(i_buf, 0, PR_REG_ISID_ID_LEN);
 	core_pr_dump_initiator_port(pr_reg, i_buf, PR_REG_ISID_ID_LEN);
 	/*
 	 * Do an implicit RELEASE of the existing reservation.
@@ -3156,7 +3149,7 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 	struct t10_reservation *pr_tmpl = &dev->t10_pr;
 	unsigned char *buf;
 	const unsigned char *initiator_str;
-	char *iport_ptr = NULL, i_buf[PR_REG_ISID_ID_LEN];
+	char *iport_ptr = NULL, i_buf[PR_REG_ISID_ID_LEN] = { };
 	u32 tid_len, tmp_tid_len;
 	int new_reg = 0, type, scope, matching_iname;
 	sense_reason_t ret;
@@ -3168,7 +3161,6 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
 
-	memset(i_buf, 0, PR_REG_ISID_ID_LEN);
 	se_tpg = se_sess->se_tpg;
 	tf_ops = se_tpg->se_tpg_tfo;
 	/*
-- 
2.22.1

