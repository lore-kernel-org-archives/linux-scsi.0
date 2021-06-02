Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE416C47083
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 03:52:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3F61613BF
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 03:52:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbhFBDyS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Jun 2021 23:54:18 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:3330 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbhFBDyQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2021 23:54:16 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Fvw2x1fFtz1BH5C;
        Wed,  2 Jun 2021 11:47:37 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 2 Jun 2021 11:52:19 +0800
Received: from thunder-town.china.huawei.com (10.174.177.72) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 2 Jun 2021 11:52:18 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH 1/1] scsi: mvsas: use DEVICE_ATTR_* macro
Date:   Wed, 2 Jun 2021 11:52:08 +0800
Message-ID: <20210602035208.10905-1-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.177.72]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use DEVICE_ATTR_* macro helper instead of plain DEVICE_ATTR, which makes
the code a bit shorter and easier to read.

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 drivers/scsi/mvsas/mv_init.c | 26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 6aa2697c4a15d24..53137f7d0e993da 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -692,22 +692,17 @@ static struct pci_driver mvs_pci_driver = {
 	.remove		= mvs_pci_remove,
 };
 
-static ssize_t
-mvs_show_driver_version(struct device *cdev,
-		struct device_attribute *attr,  char *buffer)
+static ssize_t driver_version_show(struct device *cdev,
+				   struct device_attribute *attr, char *buffer)
 {
 	return snprintf(buffer, PAGE_SIZE, "%s\n", DRV_VERSION);
 }
 
-static DEVICE_ATTR(driver_version,
-			 S_IRUGO,
-			 mvs_show_driver_version,
-			 NULL);
+static DEVICE_ATTR_RO(driver_version);
 
-static ssize_t
-mvs_store_interrupt_coalescing(struct device *cdev,
-			struct device_attribute *attr,
-			const char *buffer, size_t size)
+static ssize_t interrupt_coalescing_store(struct device *cdev,
+					  struct device_attribute *attr,
+					  const char *buffer, size_t size)
 {
 	unsigned int val = 0;
 	struct mvs_info *mvi = NULL;
@@ -745,16 +740,13 @@ mvs_store_interrupt_coalescing(struct device *cdev,
 	return strlen(buffer);
 }
 
-static ssize_t mvs_show_interrupt_coalescing(struct device *cdev,
-			struct device_attribute *attr, char *buffer)
+static ssize_t interrupt_coalescing_show(struct device *cdev,
+					 struct device_attribute *attr, char *buffer)
 {
 	return snprintf(buffer, PAGE_SIZE, "%d\n", interrupt_coalescing);
 }
 
-static DEVICE_ATTR(interrupt_coalescing,
-			 S_IRUGO|S_IWUSR,
-			 mvs_show_interrupt_coalescing,
-			 mvs_store_interrupt_coalescing);
+static DEVICE_ATTR_RW(interrupt_coalescing);
 
 static int __init mvs_init(void)
 {
-- 
2.26.0.106.g9fadedd


