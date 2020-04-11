Return-Path: <SRS0=XSNP=53=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E22A5C2BA19
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Apr 2020 23:06:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B68A921744
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Apr 2020 23:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586646395;
	bh=Nfe9w6MmF3w6Ne3snw4ketatwqXeyWFrfrZSpGBMIIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=E9Y8Efkli0B38Ksx29FFh18Dvr+dD8DKeRkJRQWs0TemJxxNcmFMKptjBuJLMHiKB
	 bSPQ9r8GthJSDhLJaLXUVkpSgS2FrbLmJCXkNz+/DDWM8hetTEX3OI0BsyNjtZtoEO
	 buIaMXLTmwuQ/pxf+ABlSe6Rcve8NFSO6xhQqZko=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728447AbgDKXGd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Apr 2020 19:06:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:41954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728441AbgDKXGc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 11 Apr 2020 19:06:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE9F8217D8;
        Sat, 11 Apr 2020 23:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646392;
        bh=Nfe9w6MmF3w6Ne3snw4ketatwqXeyWFrfrZSpGBMIIA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p7R4GX/aytF7UmCZo4OY1nWDd0eSyqsTWjVbQwrOPIDFN+tmaKjGc4PhoXQ569hDO
         Ym7/PdMHYZsIN7O2b/88heQmZQo3S+5Cv3/xWPZ1D6gy9Z56CuP3FlaM758n+jInzt
         Bwl3S9zOPdYZRwjNzMXUI5/eRZ7jjlwbFHtbm4AA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stanley Chu <stanley.chu@mediatek.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Bean Huo <beanhuo@micron.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.6 131/149] scsi: ufs: ufs-mediatek: ensure UniPro is not powered down before linkup
Date:   Sat, 11 Apr 2020 19:03:28 -0400
Message-Id: <20200411230347.22371-131-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230347.22371-1-sashal@kernel.org>
References: <20200411230347.22371-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Stanley Chu <stanley.chu@mediatek.com>

[ Upstream commit 7742ca797aa79f280853ffd3e7d2e2af3cd317a5 ]

MediaTek Chipsets can enter proprietary UniPro low-power mode during
suspend while link is in hibern8 state. Make sure leaving low-power mode
before every link startup to prevent lockup in any possible error recovery
path.

At the same time, re-factor related funcitons to improve code readability.

Link: https://lore.kernel.org/r/20200129105251.12466-2-stanley.chu@mediatek.com
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufs-mediatek.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
index 53eae5fe2ade2..7ac838cc15d16 100644
--- a/drivers/scsi/ufs/ufs-mediatek.c
+++ b/drivers/scsi/ufs/ufs-mediatek.c
@@ -30,6 +30,11 @@
 #define ufs_mtk_device_reset_ctrl(high, res) \
 	ufs_mtk_smc(UFS_MTK_SIP_DEVICE_RESET, high, res)
 
+#define ufs_mtk_unipro_powerdown(hba, powerdown) \
+	ufshcd_dme_set(hba, \
+		       UIC_ARG_MIB_SEL(VS_UNIPROPOWERDOWNCONTROL, 0), \
+		       powerdown)
+
 static void ufs_mtk_cfg_unipro_cg(struct ufs_hba *hba, bool enable)
 {
 	u32 tmp;
@@ -290,6 +295,8 @@ static int ufs_mtk_pre_link(struct ufs_hba *hba)
 	int ret;
 	u32 tmp;
 
+	ufs_mtk_unipro_powerdown(hba, 0);
+
 	/* disable deep stall */
 	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(VS_SAVEPOWERCONTROL), &tmp);
 	if (ret)
@@ -390,9 +397,7 @@ static int ufs_mtk_link_set_hpm(struct ufs_hba *hba)
 	if (err)
 		return err;
 
-	err = ufshcd_dme_set(hba,
-			     UIC_ARG_MIB_SEL(VS_UNIPROPOWERDOWNCONTROL, 0),
-			     0);
+	err = ufs_mtk_unipro_powerdown(hba, 0);
 	if (err)
 		return err;
 
@@ -413,14 +418,10 @@ static int ufs_mtk_link_set_lpm(struct ufs_hba *hba)
 {
 	int err;
 
-	err = ufshcd_dme_set(hba,
-			     UIC_ARG_MIB_SEL(VS_UNIPROPOWERDOWNCONTROL, 0),
-			     1);
+	err = ufs_mtk_unipro_powerdown(hba, 1);
 	if (err) {
 		/* Resume UniPro state for following error recovery */
-		ufshcd_dme_set(hba,
-			       UIC_ARG_MIB_SEL(VS_UNIPROPOWERDOWNCONTROL, 0),
-			       0);
+		ufs_mtk_unipro_powerdown(hba, 0);
 		return err;
 	}
 
-- 
2.20.1

