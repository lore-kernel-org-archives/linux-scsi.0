Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C9D3C4332E
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 01:06:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4241122581
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 01:06:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728552AbhAEBFz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jan 2021 20:05:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:39224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728244AbhAEBA4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Jan 2021 20:00:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55822229CA;
        Tue,  5 Jan 2021 00:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609808389;
        bh=NfbENLbrHaqZlcMZodbtf1ymoyzKPsa7mmPLq2d/+6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J1IQzUmvhhZEW3IFmNWBVPUwcAj5UleN+P4hsFOY5e9HlSAtjVjqAb5rGIf9bdH5s
         3jXUkhFCvZIOMQ+XswZnEv2ehtZUjp0iCpu4TfecD+0CIvfDQGyx+wGZqK1K3FNsXH
         /NxDOK9U/8G8ZstBjdNcn/OG8/+3ZiYTzcdYusxKxi3VlmB9z1zwJ8HeUUrHA9Yysn
         QCs2TFlMAsAwgldZOWbaUUGCvvae/EI+llUc/T6VH22247kM9WI9paRk2sLl2loAW/
         7APN1GGsPhDO0sYzZ5Bwuiw1/8pscU+5UeS7yyQBGI/7O0OXyWTlmv6k8rwxQVjHi1
         o0oKMstiRJRPA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bean Huo <beanhuo@micron.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 2/8] scsi: ufs: Fix wrong print message in dev_err()
Date:   Mon,  4 Jan 2021 19:59:39 -0500
Message-Id: <20210105005946.3954395-2-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210105005946.3954395-1-sashal@kernel.org>
References: <20210105005946.3954395-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

[ Upstream commit 1fa0570002e3f66db9b58c32c60de4183b857a19 ]

Change dev_err() print message from "dme-reset" to "dme_enable" in function
ufshcd_dme_enable().

Link: https://lore.kernel.org/r/20201207190137.6858-3-huobean@gmail.com
Acked-by: Alim Akhtar <alim.akhtar@samsung.com>
Acked-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 675e16e61ebdd..b888117f4ecd3 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3593,7 +3593,7 @@ static int ufshcd_dme_enable(struct ufs_hba *hba)
 	ret = ufshcd_send_uic_cmd(hba, &uic_cmd);
 	if (ret)
 		dev_err(hba->dev,
-			"dme-reset: error code %d\n", ret);
+			"dme-enable: error code %d\n", ret);
 
 	return ret;
 }
-- 
2.27.0

