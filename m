Return-Path: <SRS0=FSVS=CZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFA23C43461
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Sep 2020 08:40:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7669421D1B
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Sep 2020 08:40:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CA3Lf/ka"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbgIPIkf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Sep 2020 04:40:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbgIPIkf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Sep 2020 04:40:35 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEF37C06174A;
        Wed, 16 Sep 2020 01:40:33 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id c8so5436967edv.5;
        Wed, 16 Sep 2020 01:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=F6H3vb6UkKJmFpUf9sxgU5B2TZp/juwutKwOjUDSDmE=;
        b=CA3Lf/kaeVySbCp1bpQmBo+ydSP49rssWuo5adz0oB7pEIErJVq+stIL7AeJiU395O
         B+GmT/fX6ZcHBWFuNrO0ZYi0JJIk4D6FIghGzr6oWNJqq+MXjbI2UT8h4LfDyCCawmMd
         rOkm4NY1qyzB8pBOjuMHTbgaCMvFEwW1u5YyEyl7nVgwIROBDQrucqJwRPRvCk0Qjgsu
         ytfrTtUiCI0TxTP/7Q97WqrG0m/jwpbGuC7Ukg1dATjgdsd6/8669NKAwmO/Jm94gbb+
         R9z0XyikKQYws6z069vEL8Rw6zasJPuOVTixuvPgl7lL53lKi1fxTOYNQNnTaui0kklR
         tM1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=F6H3vb6UkKJmFpUf9sxgU5B2TZp/juwutKwOjUDSDmE=;
        b=JH+/2SLgd1p1m3aVuM7xzXxBlBue4w5VzjGYmddRzKXd1AiTyW2SnMM9Jtyscp6Xi3
         5bQkA9duN8ee47s7puCpxrvgEp7R7a1jYLp6sv91mQBsl9jVprjrssnlIhl1fP0mJL3o
         tm3y5DN6wRX2HFpgoqpIWUy1KukOtfTDfI0NHy/RNoLyoGDWKY74Ba16c3wwlaW4/82Q
         PdaE+savWHdORMwZKcX7yBAawzcegPWG8dMPl6LPbojrJL4lTr4eGKKFBzU4PZTCCQHo
         VXy5UqeB1GPpZjgH6xGJK9YKWZFEPybzyXerUrXZlvx77JMLfz21VeYt5lS0c7zXxCir
         cELg==
X-Gm-Message-State: AOAM533N7oCGopYmnMcrvKCOMNjMvdBhHLnuma/FWu8RB9ehMRPpLEBH
        cZ+xyEMTdbWtVHUv9uSZLCA=
X-Google-Smtp-Source: ABdhPJxjnq/hHu2jqsIZ6/xCKLc1Nv/Cr4viG90iJr5MNjVVXtrAKw/8QxqCGFEAjxW9sJ6XNBHj3Q==
X-Received: by 2002:a50:8523:: with SMTP id 32mr27570873edr.282.1600245632703;
        Wed, 16 Sep 2020 01:40:32 -0700 (PDT)
Received: from localhost.localdomain ([2a01:598:b890:270b:75d6:3bdd:1167:483e])
        by smtp.gmail.com with ESMTPSA id bm2sm13679106edb.30.2020.09.16.01.40.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2020 01:40:31 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] scsi: ufs-exynos: use devm_platform_ioremap_resource_byname()
Date:   Wed, 16 Sep 2020 10:40:17 +0200
Message-Id: <20200916084017.14086-1-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Use devm_platform_ioremap_resource_byname() to simplify the code.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---

v1-v2: change the patch commit subject

---
 drivers/scsi/ufs/ufs-exynos.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index 8f1b6f61a776..1eecbe550536 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -940,7 +940,6 @@ static int exynos_ufs_init(struct ufs_hba *hba)
 	struct device *dev = hba->dev;
 	struct platform_device *pdev = to_platform_device(dev);
 	struct exynos_ufs *ufs;
-	struct resource *res;
 	int ret;
 
 	ufs = devm_kzalloc(dev, sizeof(*ufs), GFP_KERNEL);
@@ -948,24 +947,21 @@ static int exynos_ufs_init(struct ufs_hba *hba)
 		return -ENOMEM;
 
 	/* exynos-specific hci */
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "vs_hci");
-	ufs->reg_hci = devm_ioremap_resource(dev, res);
+	ufs->reg_hci = devm_platform_ioremap_resource_byname(pdev, "vs_hci");
 	if (IS_ERR(ufs->reg_hci)) {
 		dev_err(dev, "cannot ioremap for hci vendor register\n");
 		return PTR_ERR(ufs->reg_hci);
 	}
 
 	/* unipro */
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "unipro");
-	ufs->reg_unipro = devm_ioremap_resource(dev, res);
+	ufs->reg_unipro = devm_platform_ioremap_resource_byname(pdev, "unipro");
 	if (IS_ERR(ufs->reg_unipro)) {
 		dev_err(dev, "cannot ioremap for unipro register\n");
 		return PTR_ERR(ufs->reg_unipro);
 	}
 
 	/* ufs protector */
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "ufsp");
-	ufs->reg_ufsp = devm_ioremap_resource(dev, res);
+	ufs->reg_ufsp = devm_platform_ioremap_resource_byname(pdev, "ufsp");
 	if (IS_ERR(ufs->reg_ufsp)) {
 		dev_err(dev, "cannot ioremap for ufs protector register\n");
 		return PTR_ERR(ufs->reg_ufsp);
-- 
2.17.1

