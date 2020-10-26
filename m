Return-Path: <SRS0=a792=EB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 518ECC4363A
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 19:51:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0527E2076D
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 19:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603741898;
	bh=GdnDg70I0FbOI6oD/xlNrYATDeYPhO+xxXd+jEd3AtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=kzcEYq6HYl8DpQ9AnREMqIi0KDsp4jyl4qaGl9Cbl/fGcgATzzuOdu5p6aQcYBJvC
	 HIr4TljBWwlf0BH3HFzg/JyOgmwdWu/DKOVByEp8eNafVMe5MpdaoE/wIjxpGqobrP
	 3Hoab6ysAaPqAc/nLVCEF+DJw9Jm4N2EGU1glH8A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728866AbgJZTvh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Oct 2020 15:51:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:47568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728896AbgJZTvd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Oct 2020 15:51:33 -0400
Received: from localhost (unknown [104.132.1.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 784F621BE5;
        Mon, 26 Oct 2020 19:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603741892;
        bh=GdnDg70I0FbOI6oD/xlNrYATDeYPhO+xxXd+jEd3AtI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uQJ0NaESczCCWEHj2EONZjmKhk/HmXB32QzJ65AVbUBk31drs7KshH+2GlyzKGGT5
         mKW3VfxEiGBYFtxBZsttsuestgFrxNaWHXJRZygnUbUgJoBtXY0aE6Y3TRMK/LfYaJ
         JhWnHFfBTqqTvY0GfLvVVpvjRkOA3pov7gcEUBg4=
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com
Cc:     cang@codeaurora.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        bvanassche@acm.org, Jaegeuk Kim <jaegeuk@google.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH v4 3/5] scsi: ufs: use WQ_HIGHPRI for gating work
Date:   Mon, 26 Oct 2020 12:51:22 -0700
Message-Id: <20201026195124.363096-4-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.29.0.rc1.297.gfa9743e501-goog
In-Reply-To: <20201026195124.363096-1-jaegeuk@kernel.org>
References: <20201026195124.363096-1-jaegeuk@kernel.org>
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
2.29.0.rc1.297.gfa9743e501-goog

