Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24685C19F29
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Aug 2022 16:29:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238378AbiHCQ3f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Aug 2022 12:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233932AbiHCQ3d (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2022 12:29:33 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E422F459B6;
        Wed,  3 Aug 2022 09:29:21 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 864AD412E3;
        Wed,  3 Aug 2022 16:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1659544159; x=1661358560; bh=gV3Bft/U4CnMbfHDO5HaUCMRP
        MMl6olr1lhlIr5XPZE=; b=JzR5lTOeThtoqKgYVPFN2qR3rNv7v1TBIAGcwScGm
        r/Ru7FSQ6tfnkBUWPuOX2SLB7V/pbnNbyO2OQa27lDObQ2VlucgHZsW+3qWUw3iu
        m+A2rIa8p8M/RBGndVf/5y8dfTTjzC0o8b7kAp4mHg4bfjbfEPTxspCiLtkn+PTD
        Pw=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Uyb7NvTxePDZ; Wed,  3 Aug 2022 19:29:19 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id DFD8141284;
        Wed,  3 Aug 2022 19:29:14 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Wed, 3 Aug 2022 19:29:14 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Wed, 3 Aug 2022 19:29:14 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [RFC PATCH 12/48] target: core: fix memory leak in preempt_and_abort
Date:   Wed, 2 Mar 2022 10:13:09 +0300
Message-ID: <20220803162857.27770-13-d.bogdanov@yadro.com>
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

Always release preempt_and_abort_list to avoid memory leak of
t10_pr_registration objects in it.

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/target_core_pr.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index c278ff721da3..0b3a22f51c5e 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -2954,11 +2954,12 @@ core_scsi3_pro_preempt(struct se_cmd *cmd, int type, int scope, u64 res_key,
 			__core_scsi3_complete_pro_preempt(dev, pr_reg_n,
 				(preempt_type == PREEMPT_AND_ABORT) ? &preempt_and_abort_list : NULL,
 				type, scope, preempt_type);
-
-			if (preempt_type == PREEMPT_AND_ABORT)
-				core_scsi3_release_preempt_and_abort(
-					&preempt_and_abort_list, pr_reg_n);
 		}
+
+		if (preempt_type == PREEMPT_AND_ABORT)
+			core_scsi3_release_preempt_and_abort(
+				&preempt_and_abort_list, pr_reg_n);
+
 		spin_unlock(&dev->dev_reservation_lock);
 
 		if (pr_tmpl->pr_aptpl_active)
-- 
2.25.1

