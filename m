Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A10BC433DB
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 01:07:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CFD5225AA
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 01:07:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728052AbhAEBAj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jan 2021 20:00:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:39206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728045AbhAEBAi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Jan 2021 20:00:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7B8422573;
        Tue,  5 Jan 2021 00:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609808364;
        bh=ba5DDOCOWU2rUNvSaILRUFl/P5ERLkhqrZq6lwPUL3U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qie897wiRwByoY0I4iAJXDF4ZYXWa8RMRcDYx9/F9HooOkR0WiTIgpaSgrQOuMOAq
         JsfyQDAW+5+5Ta9QsnfyTOkxrAjbMeRl1FlEQJFXQjIEPnJoEVpTHGQhEWIaGACsjI
         DqEJn3nMdn+P/9mtqOWMn+MwnzHFNjgWFQKAxgYOQlma8m15GJGE7dMx6Dha6oztGX
         BTt7GBRtaR71Zz7lxpBbRDVwAsEZckUGwLDTyyEYo81FYMrgMy9xBcd1aOZh46ixkC
         aqV1Y6BfbIaV9ujeZV8uazfYn6d2zj+Od2EppxhtplnWJtZy24ZGelBzFcvN/5WPWJ
         2GmV45fxDFujg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 06/17] scsi: ufs-pci: Fix recovery from hibernate exit errors for Intel controllers
Date:   Mon,  4 Jan 2021 19:59:04 -0500
Message-Id: <20210105005915.3954208-6-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210105005915.3954208-1-sashal@kernel.org>
References: <20210105005915.3954208-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 044d5bda7117891d6d0d56f2f807b7b11e120abd ]

Intel controllers can end up in an unrecoverable state after a hibernate
exit error unless a full reset and restore is done before anything else.
Force that to happen.

Link: https://lore.kernel.org/r/20201207083120.26732-4-adrian.hunter@intel.com
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd-pci.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
index 5d33c39fa82f0..888d8c9ca3a55 100644
--- a/drivers/scsi/ufs/ufshcd-pci.c
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -178,6 +178,23 @@ static int ufs_intel_resume(struct ufs_hba *hba, enum ufs_pm_op op)
 		      REG_UTP_TASK_REQ_LIST_BASE_L);
 	ufshcd_writel(hba, upper_32_bits(hba->utmrdl_dma_addr),
 		      REG_UTP_TASK_REQ_LIST_BASE_H);
+
+	if (ufshcd_is_link_hibern8(hba)) {
+		int ret = ufshcd_uic_hibern8_exit(hba);
+
+		if (!ret) {
+			ufshcd_set_link_active(hba);
+		} else {
+			dev_err(hba->dev, "%s: hibern8 exit failed %d\n",
+				__func__, ret);
+			/*
+			 * Force reset and restore. Any other actions can lead
+			 * to an unrecoverable state.
+			 */
+			ufshcd_set_link_off(hba);
+		}
+	}
+
 	return 0;
 }
 
-- 
2.27.0

