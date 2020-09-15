Return-Path: <SRS0=8u70=CY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34D86C433E2
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 20:52:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4F8420771
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 20:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600203163;
	bh=biBRsrW4Fs+Y3FfatFGMejxQwq4kpwq0ahfzBoNIGAM=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=quglMd56DmBq8rNLTnzrcSHwuVUwXak8om6QiTnxcP3F6rIwDXGCpH7rHfhOJg1uD
	 Ubi5XmUDb7qVcaiRnFmelTGEsxjgVNnDI2+3uOy1KtjomSehNfmrWJdcNbtI/xQY4O
	 7dqxMip0Fn7FI1EkyquMr6KXhEHZOZbn6QqgYL2o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728047AbgIOUqq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Sep 2020 16:46:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:42646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726454AbgIOUqg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Sep 2020 16:46:36 -0400
Received: from localhost (unknown [104.132.1.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A4F120809;
        Tue, 15 Sep 2020 20:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600202796;
        bh=biBRsrW4Fs+Y3FfatFGMejxQwq4kpwq0ahfzBoNIGAM=;
        h=From:To:Cc:Subject:Date:From;
        b=TcTPD5CjNScvnACas/DuxQfwIjEVgKejo6dLSYhm84AuwpnT25q9TzTumsFBiJbCq
         0ltWf08wjOzM7tYCAoEJ6QMl1yuBlSB9OZ/ca/xZNMSyB0B3cLS6X5Pil/J2KyoWpB
         /+pt0YNu3CMzHZHBvVJXIxUlgKqGHqzwXplGgKCU=
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com
Cc:     Jaegeuk Kim <jaegeuk@google.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH 1/6] scsi: ufs: atomic update for clkgating_enable
Date:   Tue, 15 Sep 2020 13:45:27 -0700
Message-Id: <20200915204532.1672300-1-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@google.com>

When giving a stress test which enables/disables clkgating, we hit device
timeout sometimes. This patch avoids subtle racy condition to address it.

Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Avri Altman <avri.altman@wdc.com>
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
2.28.0.618.gf4bc123cb7-goog

