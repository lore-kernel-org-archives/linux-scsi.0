Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E66DFC19F29
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Aug 2022 16:31:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238087AbiHCQb6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Aug 2022 12:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238545AbiHCQaj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2022 12:30:39 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D22545079;
        Wed,  3 Aug 2022 09:30:06 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id EA42141373;
        Wed,  3 Aug 2022 16:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1659544203; x=1661358604; bh=1bLe2bmEe6OtncXjy7yrZAf4g
        VDDxB/SLGnZp0Uh5Gw=; b=IXdS4qrfffxQKjPxMvScNC+RsHcvrXvR2/y4WZwo8
        WQJMeyqnE6PJE+zUZTxtlO/eoBfJ93v2m7ERahFfu7JyHTxbVbPC/sk9ig4Jah09
        3yFtbA50T7gK6pUwNuTMKMDBViJJAMl7pF1to9OhPnFBc0uTWF37FeDgnsiO5pjP
        uc=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id hxvtP1K1Fjci; Wed,  3 Aug 2022 19:30:03 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id DA4A2412E3;
        Wed,  3 Aug 2022 19:29:23 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Wed, 3 Aug 2022 19:29:23 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Wed, 3 Aug 2022 19:29:23 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [RFC PATCH 40/48] target: cluster: sync PR for dynamic acls
Date:   Fri, 24 Dec 2021 12:52:06 +0300
Message-ID: <20220803162857.27770-41-d.bogdanov@yadro.com>
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

Dynamic acls are not present in remote target, so use NULL for nacl
pointer for such registrants.

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/target_cluster_dlm.c | 10 ++++++++++
 drivers/target/target_core_pr.c     | 17 +++++++++++------
 2 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_cluster_dlm.c b/drivers/target/target_cluster_dlm.c
index 6b7cb3175e3a..6dbe1a0b21e2 100644
--- a/drivers/target/target_cluster_dlm.c
+++ b/drivers/target/target_cluster_dlm.c
@@ -466,6 +466,16 @@ target_create_pr_reg(struct se_device *dev,
 			spin_unlock(&lun->lun_deve_lock);
 			goto out;
 		}
+		/* deve not found - that is a dynamic acl */
+		pr_reg = __core_scsi3_do_alloc_registration(
+				dev, NULL, initiatorname, lun->unpacked_lun,
+				pr_reg_data->rtpi,
+				NULL, lun->unpacked_lun,
+				isid,
+				pr_reg_data->key,
+				pr_reg_data->is_all_tg_pt,
+				pr_data->pr_aptpl);
+
 		percpu_ref_put(&lun->lun_ref);
 		spin_unlock(&lun->lun_deve_lock);
 		spin_lock(&dev->se_port_lock);
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index fe2f64826e9e..22f2aa91cf2e 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -644,10 +644,13 @@ struct t10_pr_registration *__core_scsi3_do_alloc_registration(
 	 *
 	 * Otherwise, locate se_dev_entry now and obtain a reference until
 	 * registration completes in __core_scsi3_add_registration().
+	 *
+	 * NULL nacl means that this registration is for dynamic acl on a remote
+	 * target - no need to find a deve.
 	 */
 	if (dest_deve) {
 		pr_reg->pr_reg_deve = dest_deve;
-	} else {
+	} else if (nacl) {
 		rcu_read_lock();
 		pr_reg->pr_reg_deve = target_nacl_find_deve(nacl, mapped_lun);
 		if (!pr_reg->pr_reg_deve) {
@@ -1270,11 +1273,13 @@ void __core_scsi3_free_registration(
 		cpu_relax();
 	}
 
-	rcu_read_lock();
-	deve = target_nacl_find_deve(nacl, pr_reg->pr_res_mapped_lun);
-	if (deve)
-		clear_bit(DEF_PR_REG_ACTIVE, &deve->deve_flags);
-	rcu_read_unlock();
+	if (nacl) {
+		rcu_read_lock();
+		deve = target_nacl_find_deve(nacl, pr_reg->pr_res_mapped_lun);
+		if (deve)
+			clear_bit(DEF_PR_REG_ACTIVE, &deve->deve_flags);
+		rcu_read_unlock();
+	}
 
 	spin_lock(&pr_tmpl->registration_lock);
 	pr_debug("SPC-3 PR Service Action: UNREGISTER Initiator Node: %s%s\n",
-- 
2.25.1

