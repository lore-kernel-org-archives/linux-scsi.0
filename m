Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDA3BC4708F
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 06:38:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B291F61376
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 06:38:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbhFBGkU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Jun 2021 02:40:20 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:2839 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231200AbhFBGkT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jun 2021 02:40:19 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Fvzkl3k5QzWq60;
        Wed,  2 Jun 2021 14:33:51 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 2 Jun 2021 14:38:34 +0800
Received: from thunder-town.china.huawei.com (10.174.177.72) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 2 Jun 2021 14:38:33 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH 1/1] rtc: x1205: use DEVICE_ATTR_RO macro
Date:   Wed, 2 Jun 2021 14:38:28 +0800
Message-ID: <20210602063828.10958-1-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.177.72]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use DEVICE_ATTR_RO macro helper instead of plain DEVICE_ATTR, which makes
the code a bit shorter and easier to read.

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 drivers/rtc/rtc-x1205.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/rtc/rtc-x1205.c b/drivers/rtc/rtc-x1205.c
index d1d5a44d9122ad9..351e4725a7a5439 100644
--- a/drivers/rtc/rtc-x1205.c
+++ b/drivers/rtc/rtc-x1205.c
@@ -566,8 +566,8 @@ static const struct rtc_class_ops x1205_rtc_ops = {
 	.set_alarm	= x1205_rtc_set_alarm,
 };
 
-static ssize_t x1205_sysfs_show_atrim(struct device *dev,
-				struct device_attribute *attr, char *buf)
+static ssize_t atrim_show(struct device *dev,
+			  struct device_attribute *attr, char *buf)
 {
 	int err, atrim;
 
@@ -577,10 +577,10 @@ static ssize_t x1205_sysfs_show_atrim(struct device *dev,
 
 	return sprintf(buf, "%d.%02d pF\n", atrim / 1000, atrim % 1000);
 }
-static DEVICE_ATTR(atrim, S_IRUGO, x1205_sysfs_show_atrim, NULL);
+static DEVICE_ATTR_RO(atrim);
 
-static ssize_t x1205_sysfs_show_dtrim(struct device *dev,
-				struct device_attribute *attr, char *buf)
+static ssize_t dtrim_show(struct device *dev,
+			  struct device_attribute *attr, char *buf)
 {
 	int err, dtrim;
 
@@ -590,7 +590,7 @@ static ssize_t x1205_sysfs_show_dtrim(struct device *dev,
 
 	return sprintf(buf, "%d ppm\n", dtrim);
 }
-static DEVICE_ATTR(dtrim, S_IRUGO, x1205_sysfs_show_dtrim, NULL);
+static DEVICE_ATTR_RO(dtrim);
 
 static int x1205_sysfs_register(struct device *dev)
 {
-- 
2.26.0.106.g9fadedd


