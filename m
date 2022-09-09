Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96437ECAAA1
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Sep 2022 09:05:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232046AbiIIJFW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Sep 2022 05:05:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231925AbiIIJEz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Sep 2022 05:04:55 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E12FB48C87;
        Fri,  9 Sep 2022 02:04:36 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 0B0F3569A2;
        Fri,  9 Sep 2022 09:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1662714273; x=1664528674; bh=bkdklHoVr/PhUB7nGVy0bqe1T
        TpazuNKU/WFDo18u8g=; b=PBYq93DRFDnS5z/r86awbIKC8DLmOY11dLh/RwB1z
        F4/mn5BMo+ULnfN1RLOTHP4e2FI35/JeQIX4r+AU4TEUcj+HPRP4QAgZPeIxnbcV
        4vf6JDWAjFklFPxbkWaKFDXP26sAe+On9tpIO+k2+/R1oQOK5McHfL7AEMejAO0u
        wQ=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id QC1iGHHNUKLs; Fri,  9 Sep 2022 12:04:33 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (T-EXCH-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 861D056988;
        Fri,  9 Sep 2022 12:04:32 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Fri, 9 Sep 2022 12:04:32 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Fri, 9 Sep 2022 12:04:31 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     Bart Van Assche <bvanassche@acm.org>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>, Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [PATCH v2 2/4] target: core: fix memory leak in preempt_and_abort
Date:   Fri, 9 Sep 2022 12:04:23 +0300
Message-ID: <20220909090425.14479-3-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220909090425.14479-1-d.bogdanov@yadro.com>
References: <20220909090425.14479-1-d.bogdanov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-02.corp.yadro.com (172.17.10.102) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Always release preempt_and_abort_list to avoid memory leak of
t10_pr_registration objects in it.

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/target_core_pr.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 1521a97ddac2..e3869576f254 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -2956,13 +2956,14 @@ core_scsi3_pro_preempt(struct se_cmd *cmd, int type, int scope, u64 res_key,
 			__core_scsi3_complete_pro_preempt(dev, pr_reg_n,
 				(preempt_type == PREEMPT_AND_ABORT) ? &preempt_and_abort_list : NULL,
 				type, scope, preempt_type);
-
-			if (preempt_type == PREEMPT_AND_ABORT)
-				core_scsi3_release_preempt_and_abort(
-					&preempt_and_abort_list, pr_reg_n);
 		}
+
 		spin_unlock(&dev->dev_reservation_lock);
 
+		if (preempt_type == PREEMPT_AND_ABORT)
+			core_scsi3_release_preempt_and_abort(
+				&preempt_and_abort_list, pr_reg_n);
+
 		if (pr_tmpl->pr_aptpl_active)
 			core_scsi3_update_and_write_aptpl(cmd->se_dev, true);
 
-- 
2.25.1

