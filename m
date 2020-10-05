Return-Path: <SRS0=3mnS=DM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4694C4363A
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 22:36:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 681152078E
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 22:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601937412;
	bh=RhyUsFh8Oj9BZ0Tkwf+g+61O5+QJ5rAXX1sFTcNEPoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=rKe9cajKQ1GPWanYOKK0d/OMDpf1qV47D6X6MBFGIyjv1t198fBmsF5Auw2KPIaKn
	 FCKcJJBBcE313teIlWRS5YLfPYqiABXmY8NZvq+YAJ8/Xihb0ikwA+MeOL8f7kBaDh
	 SAnV2WUF9gNyRH6szQmGCuPr3KzPBUlinQCGDywc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727267AbgJEWgr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Oct 2020 18:36:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:56836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727229AbgJEWgi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 5 Oct 2020 18:36:38 -0400
Received: from localhost (unknown [104.132.1.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56D222078E;
        Mon,  5 Oct 2020 22:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601937398;
        bh=RhyUsFh8Oj9BZ0Tkwf+g+61O5+QJ5rAXX1sFTcNEPoI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JXLRaiau8dvduWBufMNInMtGOYX20vfAyVRI3y6828LZzejy07o5Asr8vxC5wFDsZ
         bKG+dJsOrCViSxvY+obWAbriDUbF/Mxdv6Vl2LvtN5IaARIeGTO7wCjLz9GROPc8hd
         7LKWHR2c64LLsj497TCm4yuHIJ37WpeiXCpHB410=
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com
Cc:     Jaegeuk Kim <jaegeuk@google.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>
Subject: [PATCH 3/4] scsi: ufs: use WQ_HIGHPRI for gating work
Date:   Mon,  5 Oct 2020 15:36:34 -0700
Message-Id: <20201005223635.2922805-3-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.28.0.806.g8561365e88-goog
In-Reply-To: <20201005223635.2922805-1-jaegeuk@kernel.org>
References: <20201005223635.2922805-1-jaegeuk@kernel.org>
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

Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Can Guo <cang@codeaurora.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@google.com>
---
 drivers/scsi/ufs/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 0bb07b50bd23e..76e95963887be 100644
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
2.28.0.806.g8561365e88-goog

