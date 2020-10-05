Return-Path: <SRS0=3mnS=DM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 129CEC4363A
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 22:36:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF1AD2078D
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 22:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601937404;
	bh=TKL2MsscyE/vIAfUltMtJXP6uFHSkqzpM4DPoVgZ1Tw=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=QIhurMufHodT57FjuvCsX+fmXbA9W1PBLisJSHPyPExcYkT5RlT9i0u+DY+Xh1+9O
	 aWAJ9G3moAbc0dAYGTFtDpBJKjM4H7Fcb+hxEdxnkEl8TQFdsDJMl7J5FBIEW0cuXZ
	 zaE+SkNITq9V33PKTfPyC227r0M4hpM6NROMOwns=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbgJEWgh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Oct 2020 18:36:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:56780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725917AbgJEWgh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 5 Oct 2020 18:36:37 -0400
Received: from localhost (unknown [104.132.1.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D02B2078A;
        Mon,  5 Oct 2020 22:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601937397;
        bh=TKL2MsscyE/vIAfUltMtJXP6uFHSkqzpM4DPoVgZ1Tw=;
        h=From:To:Cc:Subject:Date:From;
        b=zDlMHnRqW36LuoFxud7eaHvZumJlikFASkuU8WD3CCiGHGy2eNkDGzi9gV9xYQLVN
         BL0e8uFjmLNklLV5OkcXVhp6Gz6Cj6YSZbLzFldclDzBYe78vrrjjTzrxmIGBmlgsY
         35XeRlJ84TbKfygbL7ovaaXZfSuiPnxmfHqHXagI=
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com
Cc:     Jaegeuk Kim <jaegeuk@google.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>
Subject: [PATCH 1/4] scsi: ufs: atomic update for clkgating_enable
Date:   Mon,  5 Oct 2020 15:36:32 -0700
Message-Id: <20201005223635.2922805-1-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.28.0.806.g8561365e88-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@google.com>

When giving a stress test which enables/disables clkgating, we hit device
timeout sometimes. This patch avoids subtle racy condition to address it.

Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Can Guo <cang@codeaurora.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@google.com>
---
 drivers/scsi/ufs/ufshcd.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 1d157ff58d817..d929c3d1e58cc 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1791,19 +1791,19 @@ static ssize_t ufshcd_clkgate_enable_store(struct device *dev,
 		return -EINVAL;
 
 	value = !!value;
+
+	spin_lock_irqsave(hba->host->host_lock, flags);
 	if (value == hba->clk_gating.is_enabled)
 		goto out;
 
-	if (value) {
-		ufshcd_release(hba);
-	} else {
-		spin_lock_irqsave(hba->host->host_lock, flags);
+	if (value)
+		hba->clk_gating.active_reqs--;
+	else
 		hba->clk_gating.active_reqs++;
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
-	}
 
 	hba->clk_gating.is_enabled = value;
 out:
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
 	return count;
 }
 
-- 
2.28.0.806.g8561365e88-goog

