Return-Path: <SRS0=Iqxk=77=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F689C433E1
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 13:35:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D433207E8
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 13:35:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730198AbgFRNfO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Jun 2020 09:35:14 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:42944 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726940AbgFRNfN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Jun 2020 09:35:13 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id B642BECFB37E2950F84A;
        Thu, 18 Jun 2020 21:35:06 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Thu, 18 Jun 2020 21:34:59 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Kukjin Kim <kgene@kernel.org>,
        "Krzysztof Kozlowski" <krzk@kernel.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        "Seungwon Jeon" <essuuj@gmail.com>
CC:     Wei Yongjun <weiyongjun1@huawei.com>, <linux-scsi@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH -next] scsi: ufs: ufs-exynos: Fix return value check in exynos_ufs_init()
Date:   Thu, 18 Jun 2020 13:38:37 +0000
Message-ID: <20200618133837.127274-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In case of error, the function devm_ioremap_resource() returns ERR_PTR()
and never returns NULL. The NULL test in the return value check should
be replaced with IS_ERR().

Fixes: 55f4b1f73631 ("scsi: ufs: ufs-exynos: Add UFS host support for Exynos SoCs")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index 440f2af83d9c..c918fbc6ca60 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -950,25 +950,25 @@ static int exynos_ufs_init(struct ufs_hba *hba)
 	/* exynos-specific hci */
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "vs_hci");
 	ufs->reg_hci = devm_ioremap_resource(dev, res);
-	if (!ufs->reg_hci) {
+	if (IS_ERR(ufs->reg_hci)) {
 		dev_err(dev, "cannot ioremap for hci vendor register\n");
-		return -ENOMEM;
+		return PTR_ERR(ufs->reg_hci);
 	}
 
 	/* unipro */
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "unipro");
 	ufs->reg_unipro = devm_ioremap_resource(dev, res);
-	if (!ufs->reg_unipro) {
+	if (IS_ERR(ufs->reg_unipro)) {
 		dev_err(dev, "cannot ioremap for unipro register\n");
-		return -ENOMEM;
+		return PTR_ERR(ufs->reg_unipro);
 	}
 
 	/* ufs protector */
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "ufsp");
 	ufs->reg_ufsp = devm_ioremap_resource(dev, res);
-	if (!ufs->reg_ufsp) {
+	if (IS_ERR(ufs->reg_ufsp)) {
 		dev_err(dev, "cannot ioremap for ufs protector register\n");
-		return -ENOMEM;
+		return PTR_ERR(ufs->reg_ufsp);
 	}
 
 	ret = exynos_ufs_parse_dt(dev, ufs);



