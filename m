Return-Path: <SRS0=8u70=CY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA531C43461
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 18:34:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C74A2145D
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 18:34:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="q/pfs+hs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728023AbgIOSer (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Sep 2020 14:34:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727983AbgIOSIx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Sep 2020 14:08:53 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EAF7C06178C;
        Tue, 15 Sep 2020 11:07:25 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id u21so6426944eja.2;
        Tue, 15 Sep 2020 11:07:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VDXs3UaUSwmfye/yNYLIy4eJ7yCHNkNrXTn6GB6XFac=;
        b=q/pfs+hsumRAnXu+NF0wi5xEYfVeLJ5L2CG8iJCKA9TRd+uGzCZKR7EoTR2u8JDpSK
         8/hn1IKXtxvVo+9aknOkqa6vsGL8ldMU8nq02uyzDSZbvbtinJVf6sGlSM1reRToZao9
         Rdl6eNDQoLIqv4G3ApC2J6AZA5CWhVFZi8cLDvbmck3Q3zoHzhYTa68YpFgtu0RhkoTd
         l64UrITJN/2clFm5np9UAh5rzAUbgza4XOPACRUzvjX8a1SX1ria6o3QmrCTF57zb0Ja
         YODNOGM1uu/Ck8h5FTX0LmSWfxi26hoahdCzpbHeJDBCiXC2hj/z3CyxWCPblJeQ673H
         w5/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VDXs3UaUSwmfye/yNYLIy4eJ7yCHNkNrXTn6GB6XFac=;
        b=EuHEod00xAN7cosvW3IOG+nDpgyz8FiFQshziNQVwYhmS2wFwJYYCbjQVOF08gH3I8
         PcpTKSdZB5m7iIsS8daEnOyS9xkQqh/LVFzPZhS/+kSqFWOriz8GPtGeBV4AW2QC8KBv
         gamcOB6KkuH81bQd205A1q9nQ/efXWYJMN3fCSeO8znYuFWDi/2/NBtHM7fLM/GC9Jw0
         pqxGqpFG2VvbURe20dueu0ih4y13Zm3hNA+DPWOrxinxhywSt6rBHSd87oPpA69UJHjL
         5ZYN8gXkwJSZM84UMSsJLiQW0qpGL57Z6eJEVSgg//OZqg1mF6tHRmrEBXfH7deEZt2N
         RUFQ==
X-Gm-Message-State: AOAM5307D+/d0W2kAS+sIi4ejbzlWI9betjtPcRCX7aRa9Fkh7zQHOkA
        TU7get6jFCakgsywuXkNuSaEMQiZIwo=
X-Google-Smtp-Source: ABdhPJz72nhYvzAUxd7KZk1YMtgLkjnH63lfB4uo4I0txBPNxy3wUtqpa7zshDmr7OV2MGAySgz5Fw==
X-Received: by 2002:a17:906:4a53:: with SMTP id a19mr22539391ejv.56.1600193244137;
        Tue, 15 Sep 2020 11:07:24 -0700 (PDT)
Received: from localhost.localdomain ([2a01:598:b890:1ee4:75d6:3bdd:1167:483e])
        by smtp.gmail.com with ESMTPSA id k25sm10687083ejk.3.2020.09.15.11.07.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2020 11:07:23 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] scsi: ufs-mediatek: use devm_platform_ioremap_resource_byname()
Date:   Tue, 15 Sep 2020 20:07:07 +0200
Message-Id: <20200915180708.12311-2-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200915180708.12311-1-huobean@gmail.com>
References: <20200915180708.12311-1-huobean@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Use devm_platform_ioremap_resource_byname() to simplify the code.

Signed-off-by: Bean Huo <beanhuo@micron.com>
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

