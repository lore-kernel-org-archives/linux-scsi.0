Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43E5FC3F6B0
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Aug 2022 16:32:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238363AbiHCQcM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Aug 2022 12:32:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236806AbiHCQbd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2022 12:31:33 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 088922AEB;
        Wed,  3 Aug 2022 09:30:13 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 841414137C;
        Wed,  3 Aug 2022 16:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1659544211; x=1661358612; bh=dDqzX1mALs+TsBue/pJSZwyxv
        N2QpHIjrzwOQ3a8ERA=; b=JsN6AIVhk40wrlTO8qrPb2xByyKjPlqpHJox2iAyQ
        W++Ho4co2+rmaBJlgpQHqCS4aisvjJO+kWfYREoRpANI9HzwoMwOpZsHKe5U5Era
        nn9ML33RylqdROrU8PdhNtwUy3fvw2Ch50NGtqXiv4UQKEEffr/Z5gftRevLnF+G
        Ns=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id g1-BKzSFUBFd; Wed,  3 Aug 2022 19:30:11 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 1CDF0412FE;
        Wed,  3 Aug 2022 19:29:26 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Wed, 3 Aug 2022 19:29:26 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Wed, 3 Aug 2022 19:29:24 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [RFC PATCH 44/48] target: cluster: support PR OUT preempt and abort
Date:   Fri, 4 Mar 2022 15:35:36 +0300
Message-ID: <20220803162857.27770-45-d.bogdanov@yadro.com>
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

Abort commands in the preempted I_T nexuses on all nodes in cluster by
PR OUT (PREEMPT AND ABORT) command.

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/target_cluster_dlm.c   | 17 +++++++++++++++--
 drivers/target/target_core_internal.h |  2 --
 drivers/target/target_core_pr.c       |  3 ++-
 drivers/target/target_core_pr.h       |  3 +++
 drivers/target/target_core_tmr.c      |  1 +
 include/target/target_core_base.h     |  3 +++
 6 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_cluster_dlm.c b/drivers/target/target_cluster_dlm.c
index cb44f6c0f0ac..91f8ffc7ad2f 100644
--- a/drivers/target/target_cluster_dlm.c
+++ b/drivers/target/target_cluster_dlm.c
@@ -571,6 +571,7 @@ static void target_pr_sync_cb(void *arg)
 	struct t10_pr_registration *pr_prev_res_holder = NULL;
 	struct pr_reg_lvb *pr_reg_data = NULL;
 	LIST_HEAD(to_be_deleted_list);
+	LIST_HEAD(preempt_and_abort_list);
 	struct async_group grp;
 	struct pr_lvb pr_data;
 	bool res_to_delete = false;
@@ -680,7 +681,9 @@ static void target_pr_sync_cb(void *arg)
 		pr_res_mapped_lun = pr_reg->pr_res_mapped_lun;
 
 		if (dev->dev_pr_res_holder != pr_reg)
-			__core_scsi3_free_registration(dev, pr_reg, NULL, 0);
+			__core_scsi3_free_registration(dev, pr_reg,
+				(pr_data.pro_sa == PRO_PREEMPT_AND_ABORT) ?
+				&preempt_and_abort_list : NULL, 0);
 		else
 			res_to_delete = true;
 
@@ -825,10 +828,20 @@ static void target_pr_sync_cb(void *arg)
 
 	if (res_to_delete) {
 		spin_lock(&dev->t10_pr.registration_lock);
-		__core_scsi3_free_registration(dev, pr_prev_res_holder, NULL, 0);
+		__core_scsi3_free_registration(dev, pr_prev_res_holder,
+				(pr_data.pro_sa == PRO_PREEMPT_AND_ABORT) ?
+				&preempt_and_abort_list : NULL, 0);
 		spin_unlock(&dev->t10_pr.registration_lock);
 	}
 
+	if (pr_data.pro_sa == PRO_PREEMPT_AND_ABORT) {
+		core_local_lun_reset(dev, NULL, &preempt_and_abort_list, NULL);
+
+		core_scsi3_release_preempt_and_abort(
+					&preempt_and_abort_list,
+					pr_reg_res_holder);
+	}
+
 	core_scsi3_update_and_write_aptpl(dev, dev->t10_pr.pr_aptpl_active);
 
 done:
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index 89f0ddca35ed..fc7c2a9d9507 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -119,8 +119,6 @@ int	core_delete_hba(struct se_hba *);
 void	core_tmr_abort_task(struct se_device *, struct se_tmr_req *,
 			struct se_session *);
 int	core_tmr_lun_reset(struct se_device *dev, struct se_tmr_req *tmr);
-void	core_local_lun_reset(struct se_device *swc, struct se_tmr_req *tmr,
-		struct list_head *preempt_and_abort_list, struct se_cmd *prout_cmd);
 
 /* target_core_tpg.c */
 extern struct spinlock g_tpg_lock;
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index fd89647c5ac7..a476dc3aa03f 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -2725,7 +2725,7 @@ static void __core_scsi3_complete_pro_preempt(
 				preempt_and_abort_list);
 }
 
-static void core_scsi3_release_preempt_and_abort(
+void core_scsi3_release_preempt_and_abort(
 	struct list_head *preempt_and_abort_list,
 	struct t10_pr_registration *pr_reg_holder)
 {
@@ -2747,6 +2747,7 @@ static void core_scsi3_release_preempt_and_abort(
 		kmem_cache_free(t10_pr_reg_cache, pr_reg);
 	}
 }
+EXPORT_SYMBOL(core_scsi3_release_preempt_and_abort);
 
 static sense_reason_t
 core_scsi3_pro_preempt(struct se_cmd *cmd, int type, int scope, u64 res_key,
diff --git a/drivers/target/target_core_pr.h b/drivers/target/target_core_pr.h
index a3a6013dc530..82b4a270f711 100644
--- a/drivers/target/target_core_pr.h
+++ b/drivers/target/target_core_pr.h
@@ -99,6 +99,9 @@ void __core_scsi3_free_registration(struct se_device *dev,
 				    struct t10_pr_registration *pr_reg,
 				    struct list_head *preempt_and_abort_list,
 				    int dec_holders);
+void core_scsi3_release_preempt_and_abort(
+				struct list_head *preempt_and_abort_list,
+				struct t10_pr_registration *pr_reg_holder);
 
 
 #endif /* TARGET_CORE_PR_H */
diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index 26df0f685499..6984bfa976a4 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -394,6 +394,7 @@ void core_local_lun_reset(
 			(preempt_and_abort_list) ? "Preempt" : "TMR",
 			dev->transport->name);
 }
+EXPORT_SYMBOL(core_local_lun_reset);
 
 int core_tmr_lun_reset(
 	struct se_device *dev,
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 6c99fb4aa151..af3c972c3376 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -1010,5 +1010,8 @@ u32 target_parse_pr_out_transport_id(
 int target_cmp_pr_transport_id(struct t10_pr_registration *pr_reg,
 			       unsigned char *tid);
 void	target_pr_kref_release(struct kref *kref);
+void	core_local_lun_reset(struct se_device *swc, struct se_tmr_req *tmr,
+		struct list_head *preempt_and_abort_list, struct se_cmd *prout_cmd);
+
 
 #endif /* TARGET_CORE_BASE_H */
-- 
2.25.1

