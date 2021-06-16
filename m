Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3972BC49EA3
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 03:45:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 247D26137D
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 03:45:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbhFPDry (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Jun 2021 23:47:54 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:7448 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230217AbhFPDry (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Jun 2021 23:47:54 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G4WH06GzRzZhm6;
        Wed, 16 Jun 2021 11:42:52 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 11:45:48 +0800
Received: from thunder-town.china.huawei.com (10.174.179.0) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 11:45:47 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        "Sumit Saxena" <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "megaraidlinux . pdl" <megaraidlinux.pdl@broadcom.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH v2 4/4] scsi: mvsas: use DEVICE_ATTR_RO/RW macro
Date:   Wed, 16 Jun 2021 11:44:19 +0800
Message-ID: <20210616034419.725-5-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
In-Reply-To: <20210616034419.725-1-thunder.leizhen@huawei.com>
References: <20210616034419.725-1-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.179.0]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use DEVICE_ATTR_RO/RW macro helper instead of plain DEVICE_ATTR, which makes
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


