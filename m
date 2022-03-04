Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC742C3F6B0
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Aug 2022 16:29:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238363AbiHCQ3o (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Aug 2022 12:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236336AbiHCQ3d (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2022 12:29:33 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D88346D9A;
        Wed,  3 Aug 2022 09:29:22 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id E6487412E2;
        Wed,  3 Aug 2022 16:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1659544159; x=1661358560; bh=IMSXmV/3YvcEX2ISgaseaYdnq
        ViOOm6e8B0STsuY//U=; b=btlmbsEGR1xYMw9PwR4oZ+HgBPg/ZYJh+Fheql6xD
        atpqhY5oZTjF3sX4sXKUR8UxvGYG5XQtDcoJ856GHXyYp8RDY5iZtpO68MpYL3yR
        sHmY2EIULqmbID04+HHWLlyyKXLJERgjr/Kp0UXh5TWHVXodE9O13eGm1/MouBTK
        c8=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id K7OxfYh3tbHs; Wed,  3 Aug 2022 19:29:19 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (t-exch-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 3141C412CD;
        Wed,  3 Aug 2022 19:29:15 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Wed, 3 Aug 2022 19:29:15 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Wed, 3 Aug 2022 19:29:14 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [RFC PATCH 13/48] target: core: abort all preempted regs if requested
Date:   Fri, 4 Mar 2022 13:44:33 +0300
Message-ID: <20220803162857.27770-14-d.bogdanov@yadro.com>
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

According to SPC the aborting shall always happened.

SPC-4: 5.12.11.2.6 Preempting and aborting
 If the SERVICE ACTION RESERVATION KEY field is set to zero and an all
 registrants persistent reservation is present, the device server shall
 abort all commands for all registered I_T nexuses.

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/target_core_pr.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 0b3a22f51c5e..b943f8f379cf 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -2956,9 +2956,23 @@ core_scsi3_pro_preempt(struct se_cmd *cmd, int type, int scope, u64 res_key,
 				type, scope, preempt_type);
 		}
 
-		if (preempt_type == PREEMPT_AND_ABORT)
+		/*
+		 * SPC-4 5.12.11.2.6 Preempting and aborting
+		 * The actions described in this subclause shall be performed
+		 * for all I_T nexuses that are registered with the non-zero
+		 * SERVICE ACTION RESERVATION KEY value, without regard for
+		 * whether the preempted I_T nexuses hold the persistent
+		 * reservation. If the SERVICE ACTION RESERVATION KEY field is
+		 * set to zero and an all registrants persistent reservation is
+		 * present, the device server shall abort all commands for all
+		 * registered I_T nexuses.
+		 */
+		if (preempt_type == PREEMPT_AND_ABORT) {
+			core_tmr_lun_reset(dev, NULL, &preempt_and_abort_list,
+					   cmd);
 			core_scsi3_release_preempt_and_abort(
 				&preempt_and_abort_list, pr_reg_n);
+		}
 
 		spin_unlock(&dev->dev_reservation_lock);
 
-- 
2.25.1

