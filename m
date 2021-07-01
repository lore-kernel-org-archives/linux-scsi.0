Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B368C11F66
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 00:51:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75B156146D
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 00:51:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235563AbhGAAxx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Jun 2021 20:53:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:57552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232066AbhGAAxw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 30 Jun 2021 20:53:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D010F61424;
        Thu,  1 Jul 2021 00:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625100682;
        bh=H6cuf8ISy4DjCGDDE+uMRILESFmwFtgKYDwCMkBmIe4=;
        h=From:To:Cc:Subject:Date:From;
        b=TnOGqyrt2022ci9TMZUZP7qK1iYtZKvcXz4XLXj9I2T9NcxIkFw7SzpWVZFDWrQou
         5n0TOLegXmAM03lGZRHDaNJq09cInU1P2byukJRNq3Lu/F+bNT+mIex2WUWmKmcKng
         CZIE+I/xtHMvi+oJWn+4BT+7BYWTtrsMBOyUbfMDCZQSk8fzht57IMmM4I7F79Kann
         1eHy5znBeWw9C6zVNKRPOspRZfOZKm9xusJRLX6owdBKtUaKH9D5qTsFRuOsgYGQax
         2TdpkYS9W89pGIO5dUcUl01YcpUnc0MvMg+mgO7br2R+4S4h15FMwOk2knTnY7moAr
         CeuJg+3dmNi5g==
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>, Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH] scsi: ufs: add missing host_lock in setup_xfer_req
Date:   Wed, 30 Jun 2021 17:51:17 -0700
Message-Id: <20210701005117.3846179-1-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch adds a host_lock which existed before on ufshcd_vops_setup_xfer_req.

Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Can Guo <cang@codeaurora.org>
Cc: Bean Huo <beanhuo@micron.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Asutosh Das <asutoshd@codeaurora.org>
Fixes: a45f937110fa ("scsi: ufs: Optimize host lock on transfer requests send/compl paths")
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 drivers/scsi/ufs/ufshcd.h | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index c98d540ac044..194755c9ddfe 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -1229,8 +1229,13 @@ static inline int ufshcd_vops_pwr_change_notify(struct ufs_hba *hba,
 static inline void ufshcd_vops_setup_xfer_req(struct ufs_hba *hba, int tag,
 					bool is_scsi_cmd)
 {
-	if (hba->vops && hba->vops->setup_xfer_req)
-		return hba->vops->setup_xfer_req(hba, tag, is_scsi_cmd);
+	if (hba->vops && hba->vops->setup_xfer_req) {
+		unsigned long flags;
+
+		spin_lock_irqsave(hba->host->host_lock, flags);
+		hba->vops->setup_xfer_req(hba, tag, is_scsi_cmd);
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
+	}
 }
 
 static inline void ufshcd_vops_setup_task_mgmt(struct ufs_hba *hba,
-- 
2.32.0.93.g670b81a890-goog

