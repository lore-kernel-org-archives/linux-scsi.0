Return-Path: <SRS0=8u70=CY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0815C43461
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 20:53:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 701CE20809
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 20:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600203227;
	bh=NOLqD59ZXyc/29xCULK3dghDfnH/zVdAa3vvLnNbexQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=lpLStLEJVSG9snWKlYH5ytkne4L47jgHDohMwoumE7pnOC9rJ9WNTdGujgZ9/c5VK
	 FkaierPfS8zU3K6hzcmvW5CDKe0p/aBww1AaOEEgiM1DLace8YSL3LRFAjjgvbGzOU
	 qhmwvVBk5tkB9Rx/bJVY2aojnGu4GI4JfHmjnPfg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727923AbgIOUxc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Sep 2020 16:53:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:42694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728078AbgIOUqh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Sep 2020 16:46:37 -0400
Received: from localhost (unknown [104.132.1.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F87620771;
        Tue, 15 Sep 2020 20:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600202797;
        bh=NOLqD59ZXyc/29xCULK3dghDfnH/zVdAa3vvLnNbexQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BvJpNvDXs/tHKPSODHFGSmNMOIiMaLoVGbQdvVWU1ukJHP8Y9LXn2QWOnyanJyg4o
         x6i5/OeM1HiUgTUXIORPJb78N41aG+tvpX7TCMCskcQL7ZRL9yhLZeD/kR+6IqhmYu
         fGdgDNxhba/zQtaaWzREvL+ndA2H2+xvPrvIyUZg=
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com
Cc:     Jaegeuk Kim <jaegeuk@google.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH 3/6] scsi: ufs: use WQ_HIGHPRI for gating work
Date:   Tue, 15 Sep 2020 13:45:29 -0700
Message-Id: <20200915204532.1672300-3-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
In-Reply-To: <20200915204532.1672300-1-jaegeuk@kernel.org>
References: <20200915204532.1672300-1-jaegeuk@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@google.com>

Must have WQ_MEM_RECLAIM
``WQ_MEM_RECLAIM``
  All wq which might be used in the memory reclaim paths **MUST**
  have this flag set.  The wq is guaranteed to have at least one
  execution context regardless of memory pressure.

Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@google.com>
---
 drivers/scsi/ufs/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 5deba03a61f75..848e33ec40639 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1849,7 +1849,7 @@ static void ufshcd_init_clk_gating(struct ufs_hba *hba)
 	snprintf(wq_name, ARRAY_SIZE(wq_name), "ufs_clk_gating_%d",
 		 hba->host->host_no);
 	hba->clk_gating.clk_gating_workq = alloc_ordered_workqueue(wq_name,
-							   WQ_MEM_RECLAIM);
+					WQ_MEM_RECLAIM | WQ_HIGHPRI);
 
 	hba->clk_gating.is_enabled = true;
 
-- 
2.28.0.618.gf4bc123cb7-goog

