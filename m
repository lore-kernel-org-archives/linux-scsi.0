Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20817C38145
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Sep 2022 13:59:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbiIGN7Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Sep 2022 09:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbiIGN7X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Sep 2022 09:59:23 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 986901E4;
        Wed,  7 Sep 2022 06:59:21 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 2D378449EB;
        Wed,  7 Sep 2022 13:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1662559158; x=1664373559; bh=NACBRGOBKNfBOlEOSW6Y/1DW8
        0zCFu2n39YFudlLjrI=; b=mHcBhMWvHu1bNU9qTUk9M5vsFSPawL1mc77u1pAus
        G5uco1dx1r1e6blnywaBzsv5Otfu/Wn0RDrKCw/K89pbFQ0K/eHuX8fW4o2Emxz6
        cq+tI27ebSXKBLpW9fosxFNCSnltCmSlEUrp2AVCjMGYZlffCpfmNfi8rE+AXeP0
        mk=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id bSPN0w-zXzQC; Wed,  7 Sep 2022 16:59:18 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (T-EXCH-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 7FD4846DAF;
        Wed,  7 Sep 2022 16:59:05 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Wed, 7 Sep 2022 16:59:05 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Wed, 7 Sep 2022 16:59:04 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [PATCH 3/4] target: core: abort all preempted regs if requested
Date:   Wed, 7 Sep 2022 16:58:50 +0300
Message-ID: <20220907135851.3756-4-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220907135851.3756-1-d.bogdanov@yadro.com>
References: <20220907135851.3756-1-d.bogdanov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-02.corp.yadro.com (172.17.10.102) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

According to SPC the preempted commands shall be always aborted.

SPC-4: 5.12.11.2.6 Preempting and aborting
c) all commands from the I_T nexus(es) associated with the persistent
reservations or registrations being preempted (i.e., preempted commands)
except the PERSISTENT RESERVE OUT command itself shall be aborted as
defined in SAM-5;

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/target_core_pr.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 24441427f7b4..8c83c5530536 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -2960,9 +2960,23 @@ core_scsi3_pro_preempt(struct se_cmd *cmd, int type, int scope, u64 res_key,
 
 		spin_unlock(&dev->dev_reservation_lock);
 
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
 
 		if (pr_tmpl->pr_aptpl_active)
 			core_scsi3_update_and_write_aptpl(cmd->se_dev, true);
-- 
2.25.1

