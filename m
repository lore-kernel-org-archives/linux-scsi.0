Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A908C25B08
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Aug 2022 16:29:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238424AbiHCQ3r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Aug 2022 12:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238303AbiHCQ3e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2022 12:29:34 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01A0547BA0;
        Wed,  3 Aug 2022 09:29:25 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 79B5A412FA;
        Wed,  3 Aug 2022 16:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1659544162; x=1661358563; bh=xG+WTqoRBkLpo8ujtBOSAJV99
        F2eWXKbZllm0H+sg0M=; b=BxyoCKEEeVssxHJ9c/AqbdqLrnXHFllsQeEvfcDsP
        J09X3z51SoSgQCedOcurVFjuvPgClKp4hP6WOS9CNuMYOQJQHxTxlbK/twuPi7E/
        HpCcZ557IWV1RpAbpaPuSY8ubWunH8hVGpMyk8990JCAJaUvrDlURpI4gXln+ffQ
        LU=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id IvMADmlFvq1i; Wed,  3 Aug 2022 19:29:22 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (t-exch-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 9352341291;
        Wed,  3 Aug 2022 19:29:16 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Wed, 3 Aug 2022 19:29:16 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Wed, 3 Aug 2022 19:29:15 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [RFC PATCH 17/48] target: core: make some functions public
Date:   Fri, 10 Dec 2021 15:43:09 +0300
Message-ID: <20220803162857.27770-18-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220803162857.27770-1-d.bogdanov@yadro.com>
References: <20220803162857.27770-1-d.bogdanov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make functions of alloc/free and reserve/release reservation be public
to use them from cluster code.

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/target_core_pr.c | 51 +++++++++++++++++++--------------
 drivers/target/target_core_pr.h | 24 ++++++++++++++++
 2 files changed, 54 insertions(+), 21 deletions(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index aa967ea74e5b..aaa383e1ee58 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -64,9 +64,6 @@ enum preempt_type {
 	PREEMPT_AND_ABORT,
 };
 
-static void __core_scsi3_complete_pro_release(struct se_device *,
-					      struct t10_pr_registration *, int, int);
-
 static int is_reservation_holder(
 	struct t10_pr_registration *pr_res_holder,
 	struct t10_pr_registration *pr_reg)
@@ -606,7 +603,7 @@ static u32 core_scsi3_pr_generation(struct se_device *dev)
 	return atomic_inc_return(&dev->t10_pr.pr_generation);
 }
 
-static struct t10_pr_registration *__core_scsi3_do_alloc_registration(
+struct t10_pr_registration *__core_scsi3_do_alloc_registration(
 	struct se_device *dev,
 	struct se_node_acl *nacl,
 	const char *initiatorname,
@@ -1261,7 +1258,7 @@ static int core_scsi3_check_implicit_release(
 	return ret;
 }
 
-static void __core_scsi3_free_registration(
+void __core_scsi3_free_registration(
 	struct se_device *dev,
 	struct t10_pr_registration *pr_reg,
 	struct list_head *preempt_and_abort_list,
@@ -2219,6 +2216,32 @@ unsigned char *core_scsi3_pr_dump_type(int type)
 	return "Unknown SPC-3 PR Type";
 }
 
+void __core_scsi3_set_reservation(struct se_device *dev,
+				  struct t10_pr_registration *pr_reg,
+				  int scope, int type)
+{
+	char i_buf[PR_REG_ISID_ID_LEN];
+
+	memset(i_buf, 0, PR_REG_ISID_ID_LEN);
+
+	lockdep_assert_held(&dev->dev_reservation_lock);
+
+	pr_reg->pr_res_scope = scope;
+	pr_reg->pr_res_type = type;
+	pr_reg->pr_res_holder = 1;
+	dev->dev_pr_res_holder = pr_reg;
+	core_pr_dump_initiator_port(pr_reg, i_buf, PR_REG_ISID_ID_LEN);
+
+	pr_debug("SPC-3 PR [%s] Service Action: RESERVE created new reservation holder TYPE: %s ALL_TG_PT: %d\n",
+		pr_reg->se_tpg->se_tpg_tfo->fabric_name,
+		core_scsi3_pr_dump_type(type),
+		(pr_reg->pr_reg_all_tg_pt) ? 1 : 0);
+	pr_debug("SPC-3 PR [%s] RESERVE Node: %s%s\n",
+			pr_reg->se_tpg->se_tpg_tfo->fabric_name,
+			pr_reg->pr_iport,
+			i_buf);
+}
+
 static sense_reason_t
 core_scsi3_pro_reserve(struct se_cmd *cmd, int type, int scope, u64 res_key)
 {
@@ -2227,7 +2250,6 @@ core_scsi3_pro_reserve(struct se_cmd *cmd, int type, int scope, u64 res_key)
 	struct se_lun *se_lun = cmd->se_lun;
 	struct t10_pr_registration *pr_reg, *pr_res_holder;
 	struct t10_reservation *pr_tmpl = &dev->t10_pr;
-	char i_buf[PR_REG_ISID_ID_LEN] = { };
 	sense_reason_t ret;
 
 	if (!se_sess || !se_lun) {
@@ -2346,20 +2368,7 @@ core_scsi3_pro_reserve(struct se_cmd *cmd, int type, int scope, u64 res_key)
 	 * Otherwise, our *pr_reg becomes the PR reservation holder for said
 	 * TYPE/SCOPE.  Also set the received scope and type in *pr_reg.
 	 */
-	pr_reg->pr_res_scope = scope;
-	pr_reg->pr_res_type = type;
-	pr_reg->pr_res_holder = 1;
-	dev->dev_pr_res_holder = pr_reg;
-	core_pr_dump_initiator_port(pr_reg, i_buf, PR_REG_ISID_ID_LEN);
-
-	pr_debug("SPC-3 PR [%s] Service Action: RESERVE created new"
-		" reservation holder TYPE: %s ALL_TG_PT: %d\n",
-		cmd->se_tfo->fabric_name, core_scsi3_pr_dump_type(type),
-		(pr_reg->pr_reg_all_tg_pt) ? 1 : 0);
-	pr_debug("SPC-3 PR [%s] RESERVE Node: %s%s\n",
-			cmd->se_tfo->fabric_name,
-			se_sess->se_node_acl->initiatorname,
-			i_buf);
+	__core_scsi3_set_reservation(dev, pr_reg, scope, type);
 	spin_unlock(&dev->dev_reservation_lock);
 
 	if (pr_tmpl->pr_aptpl_active)
@@ -2390,7 +2399,7 @@ core_scsi3_emulate_pro_reserve(struct se_cmd *cmd, int type, int scope,
 	}
 }
 
-static void __core_scsi3_complete_pro_release(
+void __core_scsi3_complete_pro_release(
 	struct se_device *dev,
 	struct t10_pr_registration *pr_reg,
 	int explicit,
diff --git a/drivers/target/target_core_pr.h b/drivers/target/target_core_pr.h
index 202f9aec963a..9c4710f34d94 100644
--- a/drivers/target/target_core_pr.h
+++ b/drivers/target/target_core_pr.h
@@ -75,4 +75,28 @@ extern sense_reason_t target_scsi3_emulate_pr_in(struct se_cmd *);
 extern sense_reason_t target_scsi3_emulate_pr_out(struct se_cmd *);
 extern sense_reason_t target_check_reservation(struct se_cmd *);
 
+void __core_scsi3_set_reservation(struct se_device *dev,
+				  struct t10_pr_registration *pr_reg,
+				  int scope, int type);
+void __core_scsi3_complete_pro_release(struct se_device *dev,
+				       struct t10_pr_registration *pr_reg,
+				       int explicit, int unreg);
+struct t10_pr_registration *__core_scsi3_do_alloc_registration(
+					struct se_device *dev,
+					struct se_node_acl *nacl,
+					const char *initiatorname,
+					u64 unpacked_lun,
+					struct se_portal_group *se_tpg,
+					struct se_dev_entry *dest_deve,
+					u64 mapped_lun,
+					unsigned char *isid,
+					u64 sa_res_key,
+					int all_tg_pt,
+					int aptpl);
+void __core_scsi3_free_registration(struct se_device *dev,
+				    struct t10_pr_registration *pr_reg,
+				    struct list_head *preempt_and_abort_list,
+				    int dec_holders);
+
+
 #endif /* TARGET_CORE_PR_H */
-- 
2.25.1

