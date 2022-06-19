Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A923C43334
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jun 2022 11:56:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235114AbiFSL4S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 19 Jun 2022 07:56:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231256AbiFSL4R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Jun 2022 07:56:17 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D4E8120A4;
        Sun, 19 Jun 2022 04:56:14 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4LQrm05PZ0zhYQZ;
        Sun, 19 Jun 2022 19:54:08 +0800 (CST)
Received: from dggpeml500008.china.huawei.com (7.185.36.147) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sun, 19 Jun 2022 19:56:12 +0800
Received: from huawei.com (10.67.175.34) by dggpeml500008.china.huawei.com
 (7.185.36.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Sun, 19 Jun
 2022 19:56:12 +0800
From:   Ren Zhijie <renzhijie2@huawei.com>
To:     <stanley.chu@mediatek.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <matthias.bgg@gmail.com>,
        <powen.kao@mediatek.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        "Ren Zhijie" <renzhijie2@huawei.com>
Subject: [PATCH -next] scsi: ufs: ufs-mediatek: Fix build error and type unmatch
Date:   Sun, 19 Jun 2022 19:54:32 +0800
Message-ID: <20220619115432.205504-1-renzhijie2@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.175.34]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500008.china.huawei.com (7.185.36.147)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If CONFIG_PM_SLEEP is not set.

make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu-, will be failed, like this:

drivers/ufs/host/ufs-mediatek.c: In function ‘ufs_mtk_vreg_fix_vcc’:
drivers/ufs/host/ufs-mediatek.c:688:46: warning: format ‘%u’ expects argument of type ‘unsigned int’, but argument 4 has type ‘long unsigned int’ [-Wformat=]
    snprintf(vcc_name, MAX_VCC_NAME, "vcc-opt%u", res.a1);
                                             ~^   ~~~~~~
                                             %lu
drivers/ufs/host/ufs-mediatek.c: In function ‘ufs_mtk_system_suspend’:
drivers/ufs/host/ufs-mediatek.c:1371:8: error: implicit declaration of function ‘ufshcd_system_suspend’; did you mean ‘ufs_mtk_system_suspend’? [-Werror=implicit-function-declaration]
  ret = ufshcd_system_suspend(dev);
        ^~~~~~~~~~~~~~~~~~~~~
        ufs_mtk_system_suspend
drivers/ufs/host/ufs-mediatek.c: In function ‘ufs_mtk_system_resume’:
drivers/ufs/host/ufs-mediatek.c:1386:9: error: implicit declaration of function ‘ufshcd_system_resume’; did you mean ‘ufs_mtk_system_resume’? [-Werror=implicit-function-declaration]
  return ufshcd_system_resume(dev);
         ^~~~~~~~~~~~~~~~~~~~
         ufs_mtk_system_resume
cc1: some warnings being treated as errors

The declaration of func "ufshcd_system_suspend()" is depended on CONFIG_PM_SLEEP, so the function wrapper "ufs_mtk_system_suspend()" should warpped by CONFIG_PM_SLEEP too.

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: 3fd23b8dfb54("scsi: ufs: ufs-mediatek: Fix the timing of configuring device regulators")
Signed-off-by: Ren Zhijie <renzhijie2@huawei.com>
---
 drivers/ufs/host/ufs-mediatek.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index bfe04a4d1dce..4f1b30bf0c27 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -685,7 +685,7 @@ static int ufs_mtk_vreg_fix_vcc(struct ufs_hba *hba)
 	if (of_property_read_bool(np, "mediatek,ufs-vcc-by-num")) {
 		ufs_mtk_get_vcc_num(res);
 		if (res.a1 > UFS_VCC_NONE && res.a1 < UFS_VCC_MAX)
-			snprintf(vcc_name, MAX_VCC_NAME, "vcc-opt%u", res.a1);
+			snprintf(vcc_name, MAX_VCC_NAME, "vcc-opt%lu", res.a1);
 		else
 			return -ENODEV;
 	} else if (of_property_read_bool(np, "mediatek,ufs-vcc-by-ver")) {
@@ -1363,6 +1363,7 @@ static int ufs_mtk_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_PM_SLEEP
 int ufs_mtk_system_suspend(struct device *dev)
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
@@ -1385,6 +1386,7 @@ int ufs_mtk_system_resume(struct device *dev)
 
 	return ufshcd_system_resume(dev);
 }
+#endif
 
 int ufs_mtk_runtime_suspend(struct device *dev)
 {
-- 
2.17.1

