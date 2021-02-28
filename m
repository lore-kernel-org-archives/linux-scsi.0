Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B35DC433E6
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Feb 2021 06:01:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2540164E51
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Feb 2021 06:01:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbhB1GB3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Feb 2021 01:01:29 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:23274 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbhB1GBU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Feb 2021 01:01:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614492079; x=1646028079;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Q9fOr4vcTb78Z/6ksHocIr7ake9JHd9N3cFm8gyqUu4=;
  b=dPe2W5vwMGJjSzmCts4RIeBo/M9ifhb12DQ6FdbCflS9l9gQTqcqP44c
   7gKNHZxQ1hWG4IjPRnXuqT4IxyrQ+pfO0vqMyvjfNZ14KggMVxVMxf/+4
   odVZ0IAiguUeGkTqfo8sYqHUG32XUDwoQCB+lGC9Z7h2v2UNyBBGJCFrh
   e9FYpsIfTr2v+U7yh+1wM6jucXnh2u8G8ZefhLFSwZRsJpHEq4xNQes1I
   WaN2g0QX28hVP9B46eKi/FUal5xc9QrmPBh51ZpZISYrm0SxcCr0EOQ7V
   s0neP8YIoHfSDckcMjq5nHWnErTrtq5H8waVkZKGthe3OvcHAqygpgfZ6
   w==;
IronPort-SDR: LNrOIzGWEW+1dbf/1i0CQ8sEeebwG1MDAMtHylf1fYoMACgaOZ3uP4mC8RXBJ41Gx7Fb1U17nc
 Z11q6YQToDIxxUO+icx5udnnA0fgWc4D00SJEbeRxQn5yY2XSehQlGn1gSwF9H5Ljtm1rZB3lP
 3476Sh83W/v7wDVVvzvLt7WSc2ayktVzgi2EIBCg5TbsIW5U8keBpMweDVZFY2lEK98kE0EdxQ
 u9mexBFcoOiH3nIefZqTQJ37JGQlFavh/AcfJ516d8EFx2vdsqmENaa4D9KNI5z/GmXNUFbyra
 VPU=
X-IronPort-AV: E=Sophos;i="5.81,211,1610380800"; 
   d="scan'208";a="271564194"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 28 Feb 2021 14:00:24 +0800
IronPort-SDR: jlLyEmQ7MnWpCp5cidiOJ+Z5eJeyyhaUdYaqMITKmypsZkj0EFYHy+lzo2za13fo52D8t45Dsz
 i4wimf31SHMPkNFltd+dArckltMXORgYYVsBtc2vvqn0JD+kLnkZdIOtF1RSkeSrljFB9dFBO2
 wUrFJeB5V53Yd5enTDXuNlRKoyMfFpaKrfAZhaRpwB0RerJuOrp0HdPupWIM0Tll7SH5NoY7b5
 uB9yd3Feu/BUGUZJ7qRF/8rs7eET6gBo4mHdSSBwA72f2rnW8NL4kGevnL84yJxxIsDcbcxDPA
 f5q6tdeT2FgBOgNGRUQhqlN2
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2021 21:41:42 -0800
IronPort-SDR: puhgLlV5fXGevrQevSzsIkCuOGC5HZ5Xel723RCpoFHGFrFKa0hPtT6yxzKueGRYKu3ZZtxc36
 kN5eKqnZGb0ImNyDECEwe02lC90kItqjVIL6HGn1Pu5gVa5v97cY0+o6l4J/o0Uxp8/Tib18QF
 phpY7RPzu7OYy0QoorpegXpgpVGRnEAf5UvyBS9mk6+e1TS8j63egfwTXo3WBGnbUnky//wyBT
 SGaQtH7odmZ27DM/f7RYCdzK7FMmDaIOU7JP00iD7NzGtfknz+1TKjTSRWnw0yik3TQAggPJww
 QOA=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
  by uls-op-cesaip01.wdc.com with ESMTP; 27 Feb 2021 22:00:24 -0800
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, hare@suse.de, jejb@linux.ibm.com,
        mlombard@redhat.com, michael.christie@oracle.com,
        bvanassche@acm.org, houpu@bytedance.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH 22/23] target/pr: remove the memset with declare-init
Date:   Sat, 27 Feb 2021 21:56:44 -0800
Message-Id: <20210228055645.22253-23-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.22.1.dirty
In-Reply-To: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
References: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of initializing the array with memset, use declare init pattern
that is present under the kernel tree in other drivers so we can remove
the memset call.

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

