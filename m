Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67FEAC49EA2
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Jun 2021 03:13:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43ECA613BF
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Jun 2021 03:13:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbhFQDPz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Jun 2021 23:15:55 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:7460 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbhFQDPy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Jun 2021 23:15:54 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G56WY4m2SzZgwf;
        Thu, 17 Jun 2021 11:10:49 +0800 (CST)
Received: from dggema769-chm.china.huawei.com (10.1.198.211) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 17 Jun 2021 11:13:45 +0800
Received: from localhost (10.174.179.215) by dggema769-chm.china.huawei.com
 (10.1.198.211) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Thu, 17
 Jun 2021 11:13:45 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <alim.akhtar@samsung.com>, <avri.altman@wdc.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH v2 -next] scsi: ufs: fix build warning without CONFIG_PM
Date:   Thu, 17 Jun 2021 11:13:26 +0800
Message-ID: <20210617031326.36908-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggema769-chm.china.huawei.com (10.1.198.211)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

drivers/scsi/ufs/ufshcd.c:9770:12: warning: ‘ufshcd_rpmb_resume’ defined but not used [-Wunused-function]
 static int ufshcd_rpmb_resume(struct device *dev)
            ^~~~~~~~~~~~~~~~~~
drivers/scsi/ufs/ufshcd.c:9037:12: warning: ‘ufshcd_wl_runtime_resume’ defined but not used [-Wunused-function]
 static int ufshcd_wl_runtime_resume(struct device *dev)
            ^~~~~~~~~~~~~~~~~~~~~~~~
drivers/scsi/ufs/ufshcd.c:9017:12: warning: ‘ufshcd_wl_runtime_suspend’ defined but not used [-Wunused-function]
 static int ufshcd_wl_runtime_suspend(struct device *dev)
            ^~~~~~~~~~~~~~~~~~~~~~~~~

Move it into #ifdef block to fix this.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
v2: Fix build error while CONFIG_PM_SLEEP is n

 drivers/scsi/ufs/ufshcd.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index b87ff68aa9aa..708b3b62fc4d 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8926,6 +8926,7 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	return ret;
 }
 
+#ifdef CONFIG_PM
 static int __ufshcd_wl_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 {
 	int ret;
@@ -9052,6 +9053,7 @@ static int ufshcd_wl_runtime_resume(struct device *dev)
 
 	return ret;
 }
+#endif
 
 #ifdef CONFIG_PM_SLEEP
 static int ufshcd_wl_suspend(struct device *dev)
@@ -9766,6 +9768,7 @@ static inline int ufshcd_clear_rpmb_uac(struct ufs_hba *hba)
 	return ret;
 }
 
+#ifdef CONFIG_PM
 static int ufshcd_rpmb_resume(struct device *dev)
 {
 	struct ufs_hba *hba = wlun_dev_to_hba(dev);
@@ -9774,6 +9777,7 @@ static int ufshcd_rpmb_resume(struct device *dev)
 		ufshcd_clear_rpmb_uac(hba);
 	return 0;
 }
+#endif
 
 static const struct dev_pm_ops ufs_rpmb_pm_ops = {
 	SET_RUNTIME_PM_OPS(NULL, ufshcd_rpmb_resume, NULL)
-- 
2.17.1

