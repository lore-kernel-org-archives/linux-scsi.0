Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01E5CC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Jan 2021 01:28:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B28212360D
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Jan 2021 01:28:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729604AbhATB1i (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Jan 2021 20:27:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:46618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729344AbhATB12 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 19 Jan 2021 20:27:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B05B23137;
        Wed, 20 Jan 2021 01:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611105974;
        bh=kIiqZT07QAhNej8L6TLFgKeIFuu/Q7XuyWxPXs0BqQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nv6/qtRk0fah0BuFN6r+/aKIVcmYxaFxmQLDLkn06tZCyxv4a0C+qeIVDTvgJXETu
         4l9q3xFsCEVJASwdjU+yYUoQ9uqYDDv6qmUKIc4aTftRop57lp1naKGVdDblkpljyG
         f+rkr9lNxc4oV0C5ZJx/ZEN4BEdjx4k2rFyPvLkeKbn67T+2fBukIJbe/9TRXRmOUz
         gmAVeksAr1ASQmtNFJ22wodfsXEKQMjsZdmRdtR+BmRO1m5RMvrgxPxr+7rRAZ34R/
         jhnUMF+FlrDKPlXu57jdgm3lrX7cuAfAJ0kk6CqGEc646apPNboK5GxK/QI14efndF
         eRAghLmTBfyjw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 09/45] scsi: ufs: Relax the condition of UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL
Date:   Tue, 19 Jan 2021 20:25:26 -0500
Message-Id: <20210120012602.769683-9-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210120012602.769683-1-sashal@kernel.org>
References: <20210120012602.769683-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Stanley Chu <stanley.chu@mediatek.com>

[ Upstream commit 21acf4601cc63cf564c6fc1a74d81b191313c929 ]

UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL is intended to skip enabling
fWriteBoosterBufferFlushEn while WriteBooster is initializing.  Therefore
it is better to apply the checking during WriteBooster initialization only.

Link: https://lore.kernel.org/r/20201222072905.32221-3-stanley.chu@mediatek.com
Reviewed-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 7558b4abebfc5..cc0aebf54b079 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -283,7 +283,8 @@ static inline void ufshcd_wb_config(struct ufs_hba *hba)
 	if (ret)
 		dev_err(hba->dev, "%s: En WB flush during H8: failed: %d\n",
 			__func__, ret);
-	ufshcd_wb_toggle_flush(hba, true);
+	if (!(hba->quirks & UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL))
+		ufshcd_wb_toggle_flush(hba, true);
 }
 
 static void ufshcd_scsi_unblock_requests(struct ufs_hba *hba)
@@ -5353,9 +5354,6 @@ static int ufshcd_wb_toggle_flush_during_h8(struct ufs_hba *hba, bool set)
 
 static inline void ufshcd_wb_toggle_flush(struct ufs_hba *hba, bool enable)
 {
-	if (hba->quirks & UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL)
-		return;
-
 	if (enable)
 		ufshcd_wb_buf_flush_enable(hba);
 	else
-- 
2.27.0

