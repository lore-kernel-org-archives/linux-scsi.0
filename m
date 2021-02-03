Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 262B8C433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 07:41:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD56664E3E
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 07:41:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231670AbhBCHk6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Feb 2021 02:40:58 -0500
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:43644 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231560AbhBCHkz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Feb 2021 02:40:55 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UNkU.sP_1612337991;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UNkU.sP_1612337991)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 03 Feb 2021 15:40:00 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     alim.akhtar@samsung.com
Cc:     avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] scsi: ufs: convert sysfs sprintf/snprintf family to sysfs_emit
Date:   Wed,  3 Feb 2021 15:39:50 +0800
Message-Id: <1612337990-88873-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following coccicheck warning:

./drivers/scsi/ufs/ufshcd.c:1838:8-16: WARNING: use scnprintf or
sprintf.

./drivers/scsi/ufs/ufshcd.c:1815:8-16: WARNING: use scnprintf or
sprintf.

./drivers/scsi/ufs/ufshcd.c:1525:8-16: WARNING: use scnprintf or
sprintf.

Reported-by: Abaci Robot<abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/scsi/ufs/ufshcd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index fb32d12..292cb63 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1522,7 +1522,7 @@ static ssize_t ufshcd_clkscale_enable_show(struct device *dev,
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
 
-	return snprintf(buf, PAGE_SIZE, "%d\n", hba->clk_scaling.is_allowed);
+	return sysfs_emit(buf, "%d\n", hba->clk_scaling.is_allowed);
 }
 
 static ssize_t ufshcd_clkscale_enable_store(struct device *dev,
@@ -1812,7 +1812,7 @@ static ssize_t ufshcd_clkgate_delay_show(struct device *dev,
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
 
-	return snprintf(buf, PAGE_SIZE, "%lu\n", hba->clk_gating.delay_ms);
+	return sysfs_emit(buf, "%lu\n", hba->clk_gating.delay_ms);
 }
 
 static ssize_t ufshcd_clkgate_delay_store(struct device *dev,
@@ -1835,7 +1835,7 @@ static ssize_t ufshcd_clkgate_enable_show(struct device *dev,
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
 
-	return snprintf(buf, PAGE_SIZE, "%d\n", hba->clk_gating.is_enabled);
+	return sysfs_emit(buf, "%d\n", hba->clk_gating.is_enabled);
 }
 
 static ssize_t ufshcd_clkgate_enable_store(struct device *dev,
-- 
1.8.3.1

