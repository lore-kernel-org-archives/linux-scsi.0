Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8173C48BD1
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Jun 2021 13:06:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7612613D3
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Jun 2021 13:06:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbhFKNIJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Jun 2021 09:08:09 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:5509 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbhFKNIG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Jun 2021 09:08:06 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G1gxt0HNSzZgG0;
        Fri, 11 Jun 2021 21:03:14 +0800 (CST)
Received: from dggema769-chm.china.huawei.com (10.1.198.211) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Fri, 11 Jun 2021 21:06:05 +0800
Received: from localhost (10.174.179.215) by dggema769-chm.china.huawei.com
 (10.1.198.211) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Fri, 11
 Jun 2021 21:06:04 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <alim.akhtar@samsung.com>, <avri.altman@wdc.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] scsi: ufs: fix build warning without CONFIG_PM
Date:   Fri, 11 Jun 2021 21:06:01 +0800
Message-ID: <20210611130601.34336-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
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
 drivers/scsi/ufs/ufshcd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index b87ff68aa9aa..0c54589e186a 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8926,6 +8926,7 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	return ret;
 }
 
+#ifdef CONFIG_PM_SLEEP
 static int __ufshcd_wl_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 {
 	int ret;
@@ -9053,7 +9054,6 @@ static int ufshcd_wl_runtime_resume(struct device *dev)
 	return ret;
 }
 
-#ifdef CONFIG_PM_SLEEP
 static int ufshcd_wl_suspend(struct device *dev)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
@@ -9766,6 +9766,7 @@ static inline int ufshcd_clear_rpmb_uac(struct ufs_hba *hba)
 	return ret;
 }
 
+#ifdef CONFIG_PM_SLEEP
 static int ufshcd_rpmb_resume(struct device *dev)
 {
 	struct ufs_hba *hba = wlun_dev_to_hba(dev);
@@ -9774,6 +9775,7 @@ static int ufshcd_rpmb_resume(struct device *dev)
 		ufshcd_clear_rpmb_uac(hba);
 	return 0;
 }
+#endif
 
 static const struct dev_pm_ops ufs_rpmb_pm_ops = {
 	SET_RUNTIME_PM_OPS(NULL, ufshcd_rpmb_resume, NULL)
-- 
2.17.1

