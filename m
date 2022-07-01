Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E2A5C19F2C
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Aug 2022 16:30:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238115AbiHCQaK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Aug 2022 12:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238222AbiHCQ3p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2022 12:29:45 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A312946DBF;
        Wed,  3 Aug 2022 09:29:43 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 4202441319;
        Wed,  3 Aug 2022 16:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1659544180; x=1661358581; bh=wgioVz2EmvpJGetHzuYpI2nLZ
        hLhNwegLTtp00ImE8k=; b=JFGJdBIEf2zphq/PbZf4/hX0pypFdufuv4aa3uzgF
        eYAtrkVOGkFGSVGizDxbGmDTw9CMc3TTvFFuBwmTviFocs/qOtuG88juIejwG0Vm
        vKKDvksT3exGye6x/GFhV0gBtjCGCbZTo8BcjfyNPpirzNzPft5waezRllQ6tPN6
        Ok=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id PD38rZ6KE3fa; Wed,  3 Aug 2022 19:29:40 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id D92EF41284;
        Wed,  3 Aug 2022 19:29:20 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Wed, 3 Aug 2022 19:29:20 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Wed, 3 Aug 2022 19:29:20 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [RFC PATCH 30/48] target: core: rethink APTPL registrations
Date:   Fri, 1 Jul 2022 10:26:25 +0300
Message-ID: <20220803162857.27770-31-d.bogdanov@yadro.com>
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

Make APTPL registrations be real registrations from the very beginning.
Just mark at deve creation that it has a PR registration if it exists.

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/target_core_pr.c | 104 +++++++++++++-------------------
 1 file changed, 43 insertions(+), 61 deletions(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index d177db3024c9..a984987f0a82 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -832,6 +832,28 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 	return NULL;
 }
 
+static void __core_scsi3_add_registration(struct se_device *, struct se_node_acl *,
+				struct t10_pr_registration *, enum register_type, int);
+
+static void core_scsi3_aptpl_reserve(
+	struct se_device *dev,
+	const char *initiatorname,
+	struct t10_pr_registration *pr_reg)
+{
+	char i_buf[PR_REG_ISID_ID_LEN] = { };
+
+	core_pr_dump_initiator_port(pr_reg, i_buf, PR_REG_ISID_ID_LEN);
+
+	spin_lock(&dev->dev_reservation_lock);
+	dev->dev_pr_res_holder = pr_reg;
+	spin_unlock(&dev->dev_reservation_lock);
+
+	pr_debug("SPC-3 PR Service Action: APTPL RESERVE created new reservation holder TYPE: %s ALL_TG_PT: %d\n",
+		core_scsi3_pr_dump_type(pr_reg->pr_res_type),
+		(pr_reg->pr_reg_all_tg_pt) ? 1 : 0);
+	pr_debug("SPC-3 PR RESERVE Node: %s%s\n", initiatorname, i_buf);
+}
+
 int core_scsi3_alloc_aptpl_registration(
 	struct t10_reservation *pr_tmpl,
 	u64 sa_res_key,
@@ -845,6 +867,7 @@ int core_scsi3_alloc_aptpl_registration(
 	u8 type,
 	u8 proto_id)
 {
+	struct se_device *dev = container_of(pr_tmpl, struct se_device, t10_pr);
 	struct t10_pr_registration *pr_reg;
 
 	if (!i_port || !sa_res_key) {
@@ -888,47 +911,24 @@ int core_scsi3_alloc_aptpl_registration(
 	 */
 	snprintf(pr_reg->pr_iport, PR_APTPL_MAX_IPORT_LEN, "%s", i_port);
 	target_gen_pr_transport_id(pr_reg, proto_id, i_port, isid);
+
+	pr_reg->pr_res_holder = res_holder;
+	__core_scsi3_add_registration(dev, NULL, pr_reg, REGISTER, 0);
+
+	if (pr_reg->pr_res_holder)
+		core_scsi3_aptpl_reserve(dev, i_port, pr_reg);
+
 	/*
-	 * Set pr_res_holder from caller, the pr_reg who is the reservation
-	 * holder will get it's pointer set in core_scsi3_aptpl_reserve() once
-	 * the Initiator Node LUN ACL from the fabric module is created for
-	 * this registration.
+	 * Reenable pr_aptpl_active to accept new metadata
+	 * updates once the SCSI device is active again..
 	 */
-	pr_reg->pr_res_holder = res_holder;
+	pr_tmpl->pr_aptpl_active = 1;
 
-	list_add_tail(&pr_reg->pr_reg_aptpl_list, &pr_tmpl->aptpl_reg_list);
 	pr_debug("SPC-3 PR APTPL Successfully added registration%s from"
 			" metadata\n", (res_holder) ? "+reservation" : "");
 	return 0;
 }
 
-static void core_scsi3_aptpl_reserve(
-	struct se_device *dev,
-	struct se_portal_group *tpg,
-	struct se_node_acl *node_acl,
-	struct t10_pr_registration *pr_reg)
-{
-	char i_buf[PR_REG_ISID_ID_LEN] = { };
-
-	core_pr_dump_initiator_port(pr_reg, i_buf, PR_REG_ISID_ID_LEN);
-
-	spin_lock(&dev->dev_reservation_lock);
-	dev->dev_pr_res_holder = pr_reg;
-	spin_unlock(&dev->dev_reservation_lock);
-
-	pr_debug("SPC-3 PR [%s] Service Action: APTPL RESERVE created"
-		" new reservation holder TYPE: %s ALL_TG_PT: %d\n",
-		tpg->se_tpg_tfo->fabric_name,
-		core_scsi3_pr_dump_type(pr_reg->pr_res_type),
-		(pr_reg->pr_reg_all_tg_pt) ? 1 : 0);
-	pr_debug("SPC-3 PR [%s] RESERVE Node: %s%s\n",
-		tpg->se_tpg_tfo->fabric_name, node_acl->initiatorname,
-		i_buf);
-}
-
-static void __core_scsi3_add_registration(struct se_device *, struct se_node_acl *,
-				struct t10_pr_registration *, enum register_type, int);
-
 static int __core_scsi3_check_aptpl_registration(
 	struct se_device *dev,
 	struct se_portal_group *tpg,
@@ -946,12 +946,13 @@ static int __core_scsi3_check_aptpl_registration(
 	 * may exist for fabrics that use ISIDs in their SCSI Initiator Port
 	 * TransportIDs.
 	 */
-	spin_lock(&pr_tmpl->aptpl_reg_lock);
-	list_for_each_entry_safe(pr_reg, pr_reg_tmp, &pr_tmpl->aptpl_reg_list,
-				pr_reg_aptpl_list) {
+	spin_lock(&pr_tmpl->registration_lock);
+	list_for_each_entry_safe(pr_reg, pr_reg_tmp,
+			&pr_tmpl->registration_list, pr_reg_list) {
 
-		if (!strcmp(pr_reg->pr_iport, nacl->initiatorname) &&
-		     (pr_reg->tg_pt_sep_rtpi == tpg->tpg_rtpi)) {
+		if (pr_reg->pr_reg_nacl == NULL &&
+		    !strcmp(pr_reg->pr_iport, nacl->initiatorname) &&
+		    (pr_reg->tg_pt_sep_rtpi == tpg->tpg_rtpi)) {
 			/*
 			 * Obtain the ->pr_reg_deve pointer + reference, that
 			 * is released by __core_scsi3_add_registration() below.
@@ -964,34 +965,15 @@ static int __core_scsi3_check_aptpl_registration(
 				rcu_read_unlock();
 				continue;
 			}
-			kref_get(&pr_reg->pr_reg_deve->pr_kref);
+			set_bit(DEF_PR_REG_ACTIVE, &pr_reg->pr_reg_deve->deve_flags);
+			pr_reg->pr_reg_deve = NULL;
 			rcu_read_unlock();
 
 			pr_reg->pr_reg_nacl = nacl;
-			pr_reg->tg_pt_sep_rtpi = lun->lun_tpg->tpg_rtpi;
-			list_del(&pr_reg->pr_reg_aptpl_list);
-			spin_unlock(&pr_tmpl->aptpl_reg_lock);
-			/*
-			 * At this point all of the pointers in *pr_reg will
-			 * be setup, so go ahead and add the registration.
-			 */
-			__core_scsi3_add_registration(dev, nacl, pr_reg, 0, 0);
-			/*
-			 * If this registration is the reservation holder,
-			 * make that happen now..
-			 */
-			if (pr_reg->pr_res_holder)
-				core_scsi3_aptpl_reserve(dev, tpg,
-						nacl, pr_reg);
-			/*
-			 * Reenable pr_aptpl_active to accept new metadata
-			 * updates once the SCSI device is active again..
-			 */
-			spin_lock(&pr_tmpl->aptpl_reg_lock);
-			pr_tmpl->pr_aptpl_active = 1;
+			pr_reg->pr_res_mapped_lun = mapped_lun;
 		}
 	}
-	spin_unlock(&pr_tmpl->aptpl_reg_lock);
+	spin_unlock(&pr_tmpl->registration_lock);
 
 	return 0;
 }
-- 
2.25.1

