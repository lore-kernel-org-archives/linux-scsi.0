Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8023BC433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 08:44:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3559364F68
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 08:44:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232690AbhBCIo1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Feb 2021 03:44:27 -0500
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:53014 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232665AbhBCIoU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Feb 2021 03:44:20 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R761e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UNlJyBX_1612341808;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UNlJyBX_1612341808)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 03 Feb 2021 16:43:33 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     intel-linux-scu@intel.com
Cc:     artur.paszkiewicz@intel.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] scsi: isci: convert sysfs sprintf/snprintf family to sysfs_emit
Date:   Wed,  3 Feb 2021 16:43:26 +0800
Message-Id: <1612341806-30230-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following coccicheck warning:

 ./drivers/scsi/isci/init.c:140:8-16: WARNING: use scnprintf or sprintf.

Reported-by: Abaci Robot<abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/scsi/isci/init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index c452849..741a98e 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -137,7 +137,7 @@ static ssize_t isci_show_id(struct device *dev, struct device_attribute *attr, c
 	struct sas_ha_struct *sas_ha = SHOST_TO_SAS_HA(shost);
 	struct isci_host *ihost = container_of(sas_ha, typeof(*ihost), sas_ha);
 
-	return snprintf(buf, PAGE_SIZE, "%d\n", ihost->id);
+	return sysfs_emit(buf, "%d\n", ihost->id);
 }
 
 static DEVICE_ATTR(isci_id, S_IRUGO, isci_show_id, NULL);
-- 
1.8.3.1

