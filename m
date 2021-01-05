Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C068C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 01:07:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC4BF22581
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 01:07:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728061AbhAEBAj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jan 2021 20:00:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:39214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727815AbhAEBAi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Jan 2021 20:00:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D274B225A9;
        Tue,  5 Jan 2021 00:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609808365;
        bh=0gazlHiRwnOZOpwzqr5Yp5TzvlslYu9zih3AHPdaybU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G8WLFIpuyYYcMyXNI66BHhxbYQetbqj+Z391uxjgsgOJ4ZmIFsJnJgH4TyCZ1b7x+
         dQZ1A0VgPHIP6JpKFAHkwWh58UuXgV8vcAe+g2OhgAsk3Zuxi1vVx69A0fwcGT3Trt
         kVhVyrJ4S8JEuutfY1LANvBtm4xP1UyKp0W1Nj7HX4xrKBp/0ZiMMXbE929WAdhcQC
         GUNOUtVpsi214TIArL5MUpGdorX6y4l6l0ctyLYcsvcLYn6EiNTf0QR400628g59d3
         80quZlGVgrGfGd8/4YFCXtTzncZ1BgV8L0uLCWbzUAFfOmrw5rjpruOYRPwFau0JDQ
         Ysg71hsu0l1Sw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 07/17] scsi: ufs-pci: Enable UFSHCD_CAP_RPM_AUTOSUSPEND for Intel controllers
Date:   Mon,  4 Jan 2021 19:59:05 -0500
Message-Id: <20210105005915.3954208-7-sashal@kernel.org>
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

[ Upstream commit dd78bdb6f810bdcb173b42379af558c676c8e0aa ]

Enable runtime PM auto-suspend by default for Intel host controllers.

Link: https://lore.kernel.org/r/20201207083120.26732-5-adrian.hunter@intel.com
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd-pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
index 888d8c9ca3a55..fadd566025b86 100644
--- a/drivers/scsi/ufs/ufshcd-pci.c
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -148,6 +148,8 @@ static int ufs_intel_common_init(struct ufs_hba *hba)
 {
 	struct intel_host *host;
 
+	hba->caps |= UFSHCD_CAP_RPM_AUTOSUSPEND;
+
 	host = devm_kzalloc(hba->dev, sizeof(*host), GFP_KERNEL);
 	if (!host)
 		return -ENOMEM;
-- 
2.27.0

