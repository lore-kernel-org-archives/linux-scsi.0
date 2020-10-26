Return-Path: <SRS0=a792=EB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9B94C2D0A3
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 19:51:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 918CD21D42
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 19:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603741893;
	bh=+RZ6OrpUHqjqPkrvv4eFRdslvghe++1OiSQEyk8BH0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=FawFr7Q8msdwXcjVp9nbIOMwZT0smpcZfIuwncFGgMDUJNbkET+LMcfldMgTXs9nO
	 T2uBN0MBWek9dl1xlAOFlCDdrRXxwp4zSgQ+arfQUE/VOoj3i64ZGiQrG6tkJ9Nn6z
	 W9w/ITTw6uyqF46/08cmsKB/thQQt6HJbcQyhLME=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728895AbgJZTvc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Oct 2020 15:51:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:47484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728866AbgJZTvb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Oct 2020 15:51:31 -0400
Received: from localhost (unknown [104.132.1.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D4C320773;
        Mon, 26 Oct 2020 19:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603741891;
        bh=+RZ6OrpUHqjqPkrvv4eFRdslvghe++1OiSQEyk8BH0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SFt+gE8+XGt7IjZb8F1YsfvY2bCqhJzTFgp2NYaDJ+XKJcPFmEycBnyQDVddeX4hk
         K1Nbu8MgIvmm+kdxE4KpfAgRU/z/iYlmYa2o48IDckNH5uDi+Tz1pGdmAie4f4HMa4
         2BjZio7eTOzQrJ2ZEX4wY+u21kVU4EVOXXrbqC88=
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com
Cc:     cang@codeaurora.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        bvanassche@acm.org, Jaegeuk Kim <jaegeuk@google.com>
Subject: [PATCH v4 1/5] scsi: ufs: atomic update for clkgating_enable
Date:   Mon, 26 Oct 2020 12:51:20 -0700
Message-Id: <20201026195124.363096-2-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.29.0.rc1.297.gfa9743e501-goog
In-Reply-To: <20201026195124.363096-1-jaegeuk@kernel.org>
References: <20201026195124.363096-1-jaegeuk@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@google.com>

When giving a stress test which enables/disables clkgating, we hit device
timeout sometimes. This patch avoids subtle racy condition to address it.

Note that, this requires a patch to address the device stuck by REQ_CLKS_OFF in
__ufshcd_release().

The fix is "scsi: ufs: avoid to call REQ_CLKS_OFF to CLKS_OFF".

Signed-off-by: Jaegeuk Kim <jaegeuk@google.com>
---
 drivers/scsi/ufs/ufshcd.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index cc8d5f0c3fdc..6c9269bffcbd 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1808,19 +1808,19 @@ static ssize_t ufshcd_clkgate_enable_store(struct device *dev,
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
+		__ufshcd_release(hba);
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

