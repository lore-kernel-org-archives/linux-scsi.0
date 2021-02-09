Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F84EC433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 09:12:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5833964EB4
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 09:12:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbhBIJLh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Feb 2021 04:11:37 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:26298 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230340AbhBIJB0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2021 04:01:26 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UOHsGms_1612861239;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UOHsGms_1612861239)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 09 Feb 2021 17:00:44 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     alim.akhtar@samsung.com
Cc:     avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] [PATCH 5.12/scsi-staging] scsi: ufs: convert sysfs sprintf/snprintf family to sysfs_emit
Date:   Tue,  9 Feb 2021 17:00:38 +0800
Message-Id: <1612861238-118301-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following coccicheck warning:

./drivers/scsi/ufs/ufshcd.c:1838:8-16: WARNING: use scnprintf or
sprintf.

Reported-by: Abaci Robot<abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/scsi/ufs/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 80620c8..a340c77 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1535,7 +1535,7 @@ static ssize_t ufshcd_clkscale_enable_show(struct device *dev,
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
 
-	return snprintf(buf, PAGE_SIZE, "%d\n", hba->clk_scaling.is_enabled);
+	return sysfs_emit(buf, "%d\n", hba->clk_scaling.is_enabled);
 }
 
 static ssize_t ufshcd_clkscale_enable_store(struct device *dev,
-- 
1.8.3.1

