Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FCD5C433DB
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Feb 2021 02:41:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F4FC64DD1
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Feb 2021 02:41:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234409AbhBDClQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Feb 2021 21:41:16 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:53602 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231299AbhBDClP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Feb 2021 21:41:15 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UNoQw31_1612406418;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UNoQw31_1612406418)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 04 Feb 2021 10:40:27 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     satishkh@cisco.com
Cc:     sebaddel@cisco.com, kartilak@cisco.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] [SCSI] fnic: convert sysfs sprintf/snprintf family to sysfs_emit
Date:   Thu,  4 Feb 2021 10:40:16 +0800
Message-Id: <1612406416-111761-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following coccicheck warning:

./drivers/scsi/fnic/fnic_attrs.c:43:8-16: WARNING: use scnprintf or
sprintf.

./drivers/scsi/fnic/fnic_attrs.c:35:8-16: WARNING: use scnprintf or
sprintf.

./drivers/scsi/fnic/fnic_attrs.c:29:8-16: WARNING: use scnprintf or
sprintf.

Reported-by: Abaci Robot<abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/scsi/fnic/fnic_attrs.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_attrs.c b/drivers/scsi/fnic/fnic_attrs.c
index aea0c3b..6e6e125 100644
--- a/drivers/scsi/fnic/fnic_attrs.c
+++ b/drivers/scsi/fnic/fnic_attrs.c
@@ -26,13 +26,13 @@ static ssize_t fnic_show_state(struct device *dev,
 	struct fc_lport *lp = shost_priv(class_to_shost(dev));
 	struct fnic *fnic = lport_priv(lp);
 
-	return snprintf(buf, PAGE_SIZE, "%s\n", fnic_state_str[fnic->state]);
+	return sysfs_emit(buf, "%s\n", fnic_state_str[fnic->state]);
 }
 
 static ssize_t fnic_show_drv_version(struct device *dev,
 				     struct device_attribute *attr, char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, "%s\n", DRV_VERSION);
+	return sysfs_emit(buf, "%s\n", DRV_VERSION);
 }
 
 static ssize_t fnic_show_link_state(struct device *dev,
@@ -40,8 +40,7 @@ static ssize_t fnic_show_link_state(struct device *dev,
 {
 	struct fc_lport *lp = shost_priv(class_to_shost(dev));
 
-	return snprintf(buf, PAGE_SIZE, "%s\n", (lp->link_up)
-			? "Link Up" : "Link Down");
+	return sysfs_emit(buf, "%s\n", (lp->link_up) ? "Link Up" : "Link Down");
 }
 
 static DEVICE_ATTR(fnic_state, S_IRUGO, fnic_show_state, NULL);
-- 
1.8.3.1

