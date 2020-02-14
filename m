Return-Path: <SRS0=bR62=4C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A401BC3B19F
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Feb 2020 16:35:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6DF8524696
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Feb 2020 16:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581698135;
	bh=IIQkzwaSYNPxypvwziHu1CMFfRZ5x+h9J6jgJYYVWiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=PnGZ27jcJSYALJpXq4iDYCglRN2SmQXmfb/MR9nv7HpQL1kJLERy81A+Iuv6F+yYh
	 IAHzkDy1WxhGACg6HnGTtPK0ds9gXDVmyCw8LvywkZXMdo7+nCryFkfVCTAdPtlR/1
	 rfcSVywKGwxDVDac1NPmTeh/YbGcPGzSSwJpV328=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405962AbgBNQYo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Feb 2020 11:24:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:33512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393174AbgBNQYo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 14 Feb 2020 11:24:44 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44BF424796;
        Fri, 14 Feb 2020 16:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697483;
        bh=IIQkzwaSYNPxypvwziHu1CMFfRZ5x+h9J6jgJYYVWiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X+Yqi8yXV2gBs1oF5iL3iXy1QWQGbAHPgvxN3LFm+CNVvIDStWJqO58etwUaRGzJi
         z0f2k1z7J00p7Htcl5GAweRGI6hVoQWAOlU0OlCWrFcaT2M3SncUl+mEU9JU07Lniv
         3WcN0x8hrZbI46Crgw1ff1wEGhDGNtVnzy2rY/PM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bean Huo <beanhuo@micron.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 4.4 014/100] scsi: ufs: Fix ufshcd_probe_hba() reture value in case ufshcd_scsi_add_wlus() fails
Date:   Fri, 14 Feb 2020 11:22:58 -0500
Message-Id: <20200214162425.21071-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214162425.21071-1-sashal@kernel.org>
References: <20200214162425.21071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

[ Upstream commit b9fc5320212efdfb4e08b825aaa007815fd11d16 ]

A non-zero error value likely being returned by ufshcd_scsi_add_wlus() in
case of failure of adding the WLs, but ufshcd_probe_hba() doesn't use this
value, and doesn't report this failure to upper caller.  This patch is to
fix this issue.

Fixes: 2a8fa600445c ("ufs: manually add well known logical units")
Link: https://lore.kernel.org/r/20200120130820.1737-2-huobean@gmail.com
Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index fcf5141bf950f..19f82069c68ac 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4324,7 +4324,8 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
 			ufshcd_init_icc_levels(hba);
 
 		/* Add required well known logical units to scsi mid layer */
-		if (ufshcd_scsi_add_wlus(hba))
+		ret = ufshcd_scsi_add_wlus(hba);
+		if (ret)
 			goto out;
 
 		scsi_scan_host(hba->host);
-- 
2.20.1

