Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FD0CC56202
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 16:59:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DFF32465E
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 16:59:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="CR+JWaFf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728253AbgKQQ6q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Nov 2020 11:58:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:43760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728160AbgKQQ6q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Nov 2020 11:58:46 -0500
Received: from localhost (unknown [104.132.1.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B27ED22447;
        Tue, 17 Nov 2020 16:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605632325;
        bh=m7fEyJUI86RiTgxV9+ZcE0tSXdxgH+KJnjANyYtn9M4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CR+JWaFfhsK7T7TE0ZrhviYZZ4wXj3vwiye5RhMiAI/xay3TpbbVauBLUPvldOq5y
         xUHConB81QOSBhCpyAS2OZ2WRliWc9q5odd7H/fC/4hFIrXTaCdrUgdIaPknUaT2UC
         VapYYJb+X/1MTBrpVlgA1t/7Nv/cQxjHUqoaEc5o=
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com
Cc:     cang@codeaurora.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        bvanassche@acm.org, martin.petersen@oracle.com,
        stanley.chu@mediatek.com, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH v5 1/7] scsi: ufs: avoid to call REQ_CLKS_OFF to CLKS_OFF
Date:   Tue, 17 Nov 2020 08:58:33 -0800
Message-Id: <20201117165839.1643377-2-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.29.2.299.gdc1121823c-goog
In-Reply-To: <20201117165839.1643377-1-jaegeuk@kernel.org>
References: <20201117165839.1643377-1-jaegeuk@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Once UFS was gated with CLKS_OFF, it should not call REQ_CLKS_OFF again, which
caused hibern8_enter failure.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index b8f573a02713..cc8d5f0c3fdc 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1745,7 +1745,8 @@ static void __ufshcd_release(struct ufs_hba *hba)
 	if (hba->clk_gating.active_reqs || hba->clk_gating.is_suspended ||
 	    hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL ||
 	    ufshcd_any_tag_in_use(hba) || hba->outstanding_tasks ||
-	    hba->active_uic_cmd || hba->uic_async_done)
+	    hba->active_uic_cmd || hba->uic_async_done ||
+	    hba->clk_gating.state == CLKS_OFF)
 		return;
 
 	hba->clk_gating.state = REQ_CLKS_OFF;
-- 
2.29.2.299.gdc1121823c-goog

