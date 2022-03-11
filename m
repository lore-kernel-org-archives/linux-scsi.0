Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9408C19F2C
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Aug 2022 16:30:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238480AbiHCQ37 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Aug 2022 12:29:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238361AbiHCQ3e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2022 12:29:34 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 672D847BAA;
        Wed,  3 Aug 2022 09:29:29 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 14063412E2;
        Wed,  3 Aug 2022 16:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1659544166; x=1661358567; bh=HIZ0Axyq6o3ZC/QsHWwAfBYmY
        tWHLdgHTxqoX9QsDTc=; b=ux3+TX2gOkqZWWYv+NqXkBTsI9uPKHTcvJDsehv2+
        NVX+szKOY0aw57Y9qpCxyecv4e8qpsjWHh1GXkCFjYDz4CsZh9u2jKVdOf/ZNt5E
        jmPDc35FVt0EVv6A56XEKIvsmHs5mxoCkLmwlxWAw9g0iUnXw/KG4ef2HeFWJx8S
        Ko=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id LZO2pnpH6CpT; Wed,  3 Aug 2022 19:29:26 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (t-exch-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 7F38A412C8;
        Wed,  3 Aug 2022 19:29:18 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Wed, 3 Aug 2022 19:29:18 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Wed, 3 Aug 2022 19:29:17 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [RFC PATCH 23/48] target: core: refactor LUN_RESET code
Date:   Fri, 11 Mar 2022 11:33:58 +0300
Message-ID: <20220803162857.27770-24-d.bogdanov@yadro.com>
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

No function change, just extract a code of aborting all active commands
on the device. To make it possible to call TMF LUN_RESET code without
cluster related things - SCSI2 reservation or ACA condition.

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/target_core_internal.h  |  5 +++--
 drivers/target/target_core_pr.c        |  4 ++--
 drivers/target/target_core_tmr.c       | 27 +++++++++++++++++++-------
 drivers/target/target_core_transport.c |  6 +-----
 4 files changed, 26 insertions(+), 16 deletions(-)

diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index eeb405908987..b32ac78a26b0 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -112,8 +112,9 @@ int	core_delete_hba(struct se_hba *);
 /* target_core_tmr.c */
 void	core_tmr_abort_task(struct se_device *, struct se_tmr_req *,
 			struct se_session *);
-int	core_tmr_lun_reset(struct se_device *, struct se_tmr_req *,
-		struct list_head *, struct se_cmd *);
+int	core_tmr_lun_reset(struct se_device *dev, struct se_tmr_req *tmr);
+void	core_local_lun_reset(struct se_device *swc, struct se_tmr_req *tmr,
+		struct list_head *preempt_and_abort_list, struct se_cmd *prout_cmd);
 
 /* target_core_tpg.c */
 extern struct spinlock g_tpg_lock;
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index c4329f639323..dfecb155bf88 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -2936,7 +2936,7 @@ core_scsi3_pro_preempt(struct se_cmd *cmd, int type, int scope, u64 res_key,
 		 * registered I_T nexuses.
 		 */
 		if (preempt_type == PREEMPT_AND_ABORT) {
-			core_tmr_lun_reset(dev, NULL, &preempt_and_abort_list,
+			core_local_lun_reset(dev, NULL, &preempt_and_abort_list,
 					   cmd);
 			core_scsi3_release_preempt_and_abort(
 				&preempt_and_abort_list, pr_reg_n);
@@ -3067,7 +3067,7 @@ core_scsi3_pro_preempt(struct se_cmd *cmd, int type, int scope, u64 res_key,
 	 * new persistent reservation holder, the calling Initiator Port.
 	 */
 	if (preempt_type == PREEMPT_AND_ABORT) {
-		core_tmr_lun_reset(dev, NULL, &preempt_and_abort_list, cmd);
+		core_local_lun_reset(dev, NULL, &preempt_and_abort_list, cmd);
 		core_scsi3_release_preempt_and_abort(&preempt_and_abort_list,
 						pr_reg_n);
 	}
diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index 51d95e0b8885..2db45efedd97 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -22,6 +22,7 @@
 #include "target_core_internal.h"
 #include "target_core_alua.h"
 #include "target_core_pr.h"
+#include "target_core_ua.h"
 
 int core_tmr_alloc_req(
 	struct se_cmd *se_cmd,
@@ -342,7 +343,8 @@ static void core_tmr_drain_state_list(
 	}
 }
 
-int core_tmr_lun_reset(
+
+void core_local_lun_reset(
         struct se_device *dev,
         struct se_tmr_req *tmr,
         struct list_head *preempt_and_abort_list,
@@ -352,7 +354,8 @@ int core_tmr_lun_reset(
 	struct se_portal_group *tmr_tpg = NULL;
 	struct se_session *tmr_sess = NULL;
 	bool tas;
-        /*
+
+	/*
 	 * TASK_ABORTED status bit, this is configurable via ConfigFS
 	 * struct se_device attributes.  spc4r17 section 7.4.6 Control mode page
 	 *
@@ -387,23 +390,33 @@ int core_tmr_lun_reset(
 	core_tmr_drain_state_list(dev, prout_cmd, tmr_sess, tas,
 				preempt_and_abort_list);
 
+	pr_debug("LUN_RESET: %s for [%s] Complete\n",
+			(preempt_and_abort_list) ? "Preempt" : "TMR",
+			dev->transport->name);
+}
+
+int core_tmr_lun_reset(
+	struct se_device *dev,
+	struct se_tmr_req *tmr)
+{
+	core_local_lun_reset(dev, tmr, NULL, NULL);
+
 	/*
 	 * Clear any legacy SPC-2 reservation when called during
 	 * LOGICAL UNIT RESET
 	 */
-	if (!preempt_and_abort_list &&
-	     (dev->dev_reservation_flags & DRF_SPC2_RESERVATIONS)) {
+	if (dev->dev_reservation_flags & DRF_SPC2_RESERVATIONS) {
 		spin_lock(&dev->dev_reservation_lock);
 		target_release_reservation(dev);
 		spin_unlock(&dev->dev_reservation_lock);
 		pr_debug("LUN_RESET: SCSI-2 Released reservation\n");
 	}
 
+	target_dev_ua_allocate(dev, 0x29,
+			ASCQ_29H_BUS_DEVICE_RESET_FUNCTION_OCCURRED);
+
 	atomic_long_inc(&dev->num_resets);
 
-	pr_debug("LUN_RESET: %s for [%s] Complete\n",
-			(preempt_and_abort_list) ? "Preempt" : "TMR",
-			dev->transport->name);
 	return 0;
 }
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 5926316252eb..d3cbba294510 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3527,13 +3527,9 @@ static void target_tmr_work(struct work_struct *work)
 		tmr->response = TMR_TASK_MGMT_FUNCTION_NOT_SUPPORTED;
 		break;
 	case TMR_LUN_RESET:
-		ret = core_tmr_lun_reset(dev, tmr, NULL, NULL);
+		ret = core_tmr_lun_reset(dev, tmr);
 		tmr->response = (!ret) ? TMR_FUNCTION_COMPLETE :
 					 TMR_FUNCTION_REJECTED;
-		if (tmr->response == TMR_FUNCTION_COMPLETE) {
-			target_dev_ua_allocate(dev, 0x29,
-					       ASCQ_29H_BUS_DEVICE_RESET_FUNCTION_OCCURRED);
-		}
 		break;
 	case TMR_TARGET_WARM_RESET:
 		tmr->response = TMR_FUNCTION_REJECTED;
-- 
2.25.1

