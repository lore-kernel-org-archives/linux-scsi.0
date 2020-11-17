Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75824C64E7C
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 16:59:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 255F824248
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 16:59:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="pqpS1I8u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728459AbgKQQ67 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Nov 2020 11:58:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:43882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728107AbgKQQ6s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Nov 2020 11:58:48 -0500
Received: from localhost (unknown [104.132.1.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C5EA2465E;
        Tue, 17 Nov 2020 16:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605632328;
        bh=ZTUUxWxskv0UyOHOW3ine0OD5r7+QuFzK+yjFiialjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pqpS1I8ueaU03WEOkVo3+ZiGbjQIy1K/spFwpBG2OJL+4Ycn6URA52R1J/QSVOG8A
         hmWPfH8SoICnGA7gar0grzLiQ1Ik3dXS8mgWhtxWRZoazlNFI3Zv5V0g3wg7HWonks
         d0JulfjXezAXDtAtOQkyif1mxfR81iEeDWgTPrAQ=
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com
Cc:     cang@codeaurora.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        bvanassche@acm.org, martin.petersen@oracle.com,
        stanley.chu@mediatek.com, Jaegeuk Kim <jaegeuk@google.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH v5 4/7] scsi: ufs: use WQ_HIGHPRI for gating work
Date:   Tue, 17 Nov 2020 08:58:36 -0800
Message-Id: <20201117165839.1643377-5-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.29.2.299.gdc1121823c-goog
In-Reply-To: <20201117165839.1643377-1-jaegeuk@kernel.org>
References: <20201117165839.1643377-1-jaegeuk@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@google.com>

Must have WQ_MEM_RECLAIM
``WQ_MEM_RECLAIM``
  All wq which might be used in the memory reclaim paths **MUST**
  have this flag set.  The wq is guaranteed to have at least one
  execution context regardless of memory pressure.

Signed-off-by: Jaegeuk Kim <jaegeuk@google.com>
Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 8e696ca79b40..c45c0cff174e 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1868,7 +1868,7 @@ static void ufshcd_init_clk_gating(struct ufs_hba *hba)
 	snprintf(wq_name, ARRAY_SIZE(wq_name), "ufs_clk_gating_%d",
 		 hba->host->host_no);
 	hba->clk_gating.clk_gating_workq = alloc_ordered_workqueue(wq_name,
-							   WQ_MEM_RECLAIM);
+					WQ_MEM_RECLAIM | WQ_HIGHPRI);
 
 	hba->clk_gating.is_enabled = true;
 
-- 
2.29.2.299.gdc1121823c-goog

