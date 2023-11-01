Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B40CBC4332F
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Nov 2023 07:21:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbjKAHVz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Nov 2023 03:21:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjKAHVy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Nov 2023 03:21:54 -0400
Received: from SHSQR01.spreadtrum.com (mx1.unisoc.com [222.66.158.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C1C6C2
        for <linux-scsi@vger.kernel.org>; Wed,  1 Nov 2023 00:21:50 -0700 (PDT)
Received: from dlp.unisoc.com ([10.29.3.86])
        by SHSQR01.spreadtrum.com with ESMTP id 3A17FH2T094633;
        Wed, 1 Nov 2023 15:15:17 +0800 (+08)
        (envelope-from Zhe.Wang1@unisoc.com)
Received: from SHDLP.spreadtrum.com (shmbx07.spreadtrum.com [10.0.1.12])
        by dlp.unisoc.com (SkyGuard) with ESMTPS id 4SKyp54k9Vz2LGsng;
        Wed,  1 Nov 2023 15:10:37 +0800 (CST)
Received: from xm9614pcu.spreadtrum.com (10.13.2.29) by shmbx07.spreadtrum.com
 (10.0.1.12) with Microsoft SMTP Server (TLS) id 15.0.1497.23; Wed, 1 Nov 2023
 15:15:16 +0800
From:   Zhe Wang <zhe.wang1@unisoc.com>
To:     <martin.petersen@oracle.com>, <jejb@linux.ibm.com>,
        <bvanassche@acm.org>, <alim.akhtar@samsung.com>,
        <avri.altman@wdc.com>, <quic_asutoshd@quicinc.com>
CC:     <linux-scsi@vger.kernel.org>, <orsonzhai@gmail.com>,
        <yuelin.tang@unisoc.com>, <zhenxiong.lai@unisoc.com>,
        <zhang.lyra@gmail.com>, <zhewang116@gmail.com>
Subject: [PATCH] scsi: ufs: core: Add compl_time_stamp_local_clock assignment
Date:   Wed, 1 Nov 2023 15:14:20 +0800
Message-ID: <20231101071420.29238-1-zhe.wang1@unisoc.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.13.2.29]
X-ClientProxiedBy: SHCAS03.spreadtrum.com (10.0.1.207) To
 shmbx07.spreadtrum.com (10.0.1.12)
X-MAIL: SHSQR01.spreadtrum.com 3A17FH2T094633
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The compl_time_stamp_local_clock assignment seems to have been
accidentally deleted in the previous patch, so it needs to be added
again for debugging needs.

Fixes: c30d8d010b5e ("scsi: ufs: core: Prepare for completion in MCQ")
Signed-off-by: Zhe Wang <zhe.wang1@unisoc.com>
---
 drivers/ufs/core/ufshcd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 8382e8cfa414..b35977fa931f 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5388,6 +5388,7 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba, int task_tag,
 
 	lrbp = &hba->lrb[task_tag];
 	lrbp->compl_time_stamp = ktime_get();
+	lrbp->compl_time_stamp_local_clock = local_clock();
 	cmd = lrbp->cmd;
 	if (cmd) {
 		if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))
-- 
2.17.1

