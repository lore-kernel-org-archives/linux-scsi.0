Return-Path: <SRS0=Jnta=D7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E78BBC56201
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Oct 2020 15:07:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B70942226B
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Oct 2020 15:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603552030;
	bh=VcDXgxS5R7QGGudNOBsdhU7KAtWrbQqRvSfyLXEfX/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Gpo0aBrdsBPj8YuQ3qTGLUM5robsg3+E7WNNjrM5UA7hg8PbFL8Wf4+A1eqaYBhNI
	 X8hjEKNceMOZQiEgvThvan86TVdA0isTFcrh5fLP7cKjjEfAidOLrYPkLw+MMCkKNi
	 Kjjz18z06M69vmTUAzsoautUGxHQwofveu8d8KUY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1760450AbgJXPGw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Oct 2020 11:06:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:60710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760429AbgJXPGv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 24 Oct 2020 11:06:51 -0400
Received: from localhost (unknown [104.132.1.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1948222203;
        Sat, 24 Oct 2020 15:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603552011;
        bh=VcDXgxS5R7QGGudNOBsdhU7KAtWrbQqRvSfyLXEfX/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YVoqSE6zIzneLSvE8qcJ1rGneE9wqFn8W/NTHthso3v8Jmv1+/UUciUzU6nOmkclg
         iHQOZmMcbzS5AYR1JW0fmtuLaLuMIs2M+pP0rFNdJjmIhJd1nFTcmMpzlugirii0HA
         JOu7TkRCPqDm19fuzGRp9Nr2/hmYHgQm9HDKNs4Q=
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, kernel-team@android.com
Cc:     cang@codeaurora.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        bvanassche@acm.org, Jaegeuk Kim <jaegeuk@google.com>
Subject: [PATCH v3 1/5] scsi: ufs: atomic update for clkgating_enable
Date:   Sat, 24 Oct 2020 08:06:42 -0700
Message-Id: <20201024150646.1790529-2-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.29.0.rc1.297.gfa9743e501-goog
In-Reply-To: <20201024150646.1790529-1-jaegeuk@kernel.org>
References: <20201024150646.1790529-1-jaegeuk@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@google.com>

When giving a stress test which enables/disables clkgating, we hit device
timeout sometimes. This patch avoids subtle racy condition to address it.

If we use __ufshcd_release(), I've seen that gate_work can be called in parallel
with ungate_work, which results in UFS timeout when doing hibern8.
Should avoid it.

Signed-off-by: Jaegeuk Kim <jaegeuk@google.com>
---
 drivers/scsi/ufs/ufshcd.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index b8f573a02713..e0b479f9eb8a 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1807,19 +1807,19 @@ static ssize_t ufshcd_clkgate_enable_store(struct device *dev,
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
2.29.0.rc1.297.gfa9743e501-goog

