Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63929C4320E
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 08:55:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 482F461167
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 08:55:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243851AbhHFIzV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Aug 2021 04:55:21 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:43180 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243788AbhHFIzT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Aug 2021 04:55:19 -0400
Received: from epcas3p3.samsung.com (unknown [182.195.41.21])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210806085502epoutp0234e9cf489b1ffc8164caa6b8845430f0~Yq78kbNb80320503205epoutp02X
        for <linux-scsi@vger.kernel.org>; Fri,  6 Aug 2021 08:55:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210806085502epoutp0234e9cf489b1ffc8164caa6b8845430f0~Yq78kbNb80320503205epoutp02X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1628240102;
        bh=MQQTApWByV9FXOfpNZN2RjbAliwdWlY4BO3NC3rYsCw=;
        h=Subject:Reply-To:From:To:Date:References:From;
        b=Tl1B3UCkElSaEVsNsfCEIoml4TRlx9wmnV0qOKPrBcEDD6kE2Pn4eUWsXMflSQaJC
         i86GZPa9uAEli7O7kM1cdAynb/97u3AKK92BLAxjxudT0crQhKfvA+we4pP48uDF3H
         K/3v9jfav+BEBHYwj2Z6+YmGg7O9Y7VL3nZbt+iQ=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas3p3.samsung.com (KnoxPortal) with ESMTP id
        20210806085502epcas3p36b78fd63c9d9c0c1d670ba1f240ba930~Yq78JTwEs0051900519epcas3p3B;
        Fri,  6 Aug 2021 08:55:02 +0000 (GMT)
Received: from epcpadp3 (unknown [182.195.40.17]) by epsnrtp4.localdomain
        (Postfix) with ESMTP id 4Ggznf1bk2z4x9QF; Fri,  6 Aug 2021 08:55:02 +0000
        (GMT)
Mime-Version: 1.0
Subject: [PATCH] scsi: ufs: Remove ufshcd_variant_hba_init/exit()
Reply-To: keosung.park@samsung.com
Sender: Keoseong Park <keosung.park@samsung.com>
From:   Keoseong Park <keosung.park@samsung.com>
To:     ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "jaegeuk@kernel.org" <jaegeuk@kernel.org>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1891546521.01628240102206.JavaMail.epsvc@epcpadp3>
Date:   Fri, 06 Aug 2021 17:33:44 +0900
X-CMS-MailID: 20210806083344epcms2p1fd38026d07cd74438b4aa2bbd95c3f20
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20210806083344epcms2p1fd38026d07cd74438b4aa2bbd95c3f20
References: <CGME20210806083344epcms2p1fd38026d07cd74438b4aa2bbd95c3f20@epcms2p1>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since hba->vops is checked in ufshcd_vops_init/exit(), there is no
need to check whether hba->vops is NULL in ufshcd_variant_hba_init/exit().

ufshcd_variant_hba_init/exit() has only one caller and only calls vops,
so it was removed.

Signed-off-by: Keoseong Park <keosung.park@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 32 ++++++--------------------------
 1 file changed, 6 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 05495c34a2b7..f1bd074627ff 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8438,29 +8438,6 @@ static int ufshcd_init_clocks(struct ufs_hba *hba)
 	return ret;
 }
 
-static int ufshcd_variant_hba_init(struct ufs_hba *hba)
-{
-	int err = 0;
-
-	if (!hba->vops)
-		goto out;
-
-	err = ufshcd_vops_init(hba);
-	if (err)
-		dev_err(hba->dev, "%s: variant %s init failed err %d\n",
-			__func__, ufshcd_get_var_name(hba), err);
-out:
-	return err;
-}
-
-static void ufshcd_variant_hba_exit(struct ufs_hba *hba)
-{
-	if (!hba->vops)
-		return;
-
-	ufshcd_vops_exit(hba);
-}
-
 static int ufshcd_hba_init(struct ufs_hba *hba)
 {
 	int err;
@@ -8496,9 +8473,12 @@ static int ufshcd_hba_init(struct ufs_hba *hba)
 	if (err)
 		goto out_disable_clks;
 
-	err = ufshcd_variant_hba_init(hba);
-	if (err)
+	err = ufshcd_vops_init(hba);
+	if (err) {
+		dev_err(hba->dev, "%s: variant %s init failed err %d\n",
+			__func__, ufshcd_get_var_name(hba), err);
 		goto out_disable_vreg;
+	}
 
 	ufs_debugfs_hba_init(hba);
 
@@ -8523,7 +8503,7 @@ static void ufshcd_hba_exit(struct ufs_hba *hba)
 		if (hba->eh_wq)
 			destroy_workqueue(hba->eh_wq);
 		ufs_debugfs_hba_exit(hba);
-		ufshcd_variant_hba_exit(hba);
+		ufshcd_vops_exit(hba);
 		ufshcd_setup_vreg(hba, false);
 		ufshcd_setup_clocks(hba, false);
 		ufshcd_setup_hba_vreg(hba, false);
-- 
2.17.1
