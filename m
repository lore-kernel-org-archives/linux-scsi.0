Return-Path: <SRS0=Jnta=D7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9426C55178
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Oct 2020 15:06:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7249B222C3
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Oct 2020 15:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603552019;
	bh=hJq6gHeglXeioT2p+UkEfD7VO+LTb3XRjMAAYvwCArA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Yl/NAwmALkPp/5SFPRaA6hRIKo0vzGAF3JV6v+E8pm6a30DOVwc6mJ5pxh9w63iWq
	 6G17xqIHi+iT1YM94Iwp7txDENagSlOuCbp9KkvJnMNoWSjRuii5+JTr5G5IRA6eG4
	 lxKc/9WehXQCEpser1KUtjjrJjYW0jjaaUUlrK4I=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1760505AbgJXPGy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Oct 2020 11:06:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:60774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760487AbgJXPGw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 24 Oct 2020 11:06:52 -0400
Received: from localhost (unknown [104.132.1.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F00A2225F;
        Sat, 24 Oct 2020 15:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603552012;
        bh=hJq6gHeglXeioT2p+UkEfD7VO+LTb3XRjMAAYvwCArA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OB2xj8TKyNzK+H3Wy7zmQPn1SNAqPCVdf/Vt/yvvVfMd3nX79mfjTExTgXezfpatV
         NvVs21u9lbZlDAaGVlhwcO1YSvfARNKm87ynq2hWcwkgfXMCxrJb/HBqR2oZHeA038
         wShYwbMasNEyinsT5ALk/rwFhUwF+/RkkRtJtuu0=
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, kernel-team@android.com
Cc:     cang@codeaurora.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        bvanassche@acm.org, Jaegeuk Kim <jaegeuk@google.com>
Subject: [PATCH v3 3/5] scsi: ufs: use WQ_HIGHPRI for gating work
Date:   Sat, 24 Oct 2020 08:06:44 -0700
Message-Id: <20201024150646.1790529-4-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.29.0.rc1.297.gfa9743e501-goog
In-Reply-To: <20201024150646.1790529-1-jaegeuk@kernel.org>
References: <20201024150646.1790529-1-jaegeuk@kernel.org>
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
---
 drivers/scsi/ufs/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 011e80a21170..bc0d623aed66 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1867,7 +1867,7 @@ static void ufshcd_init_clk_gating(struct ufs_hba *hba)
 	snprintf(wq_name, ARRAY_SIZE(wq_name), "ufs_clk_gating_%d",
 		 hba->host->host_no);
 	hba->clk_gating.clk_gating_workq = alloc_ordered_workqueue(wq_name,
-							   WQ_MEM_RECLAIM);
+					WQ_MEM_RECLAIM | WQ_HIGHPRI);
 
 	hba->clk_gating.is_enabled = true;
 
-- 
2.29.0.rc1.297.gfa9743e501-goog

