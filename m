Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A78C1C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 12:31:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A07B610D1
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 12:31:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236394AbhJLMdj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 08:33:39 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3968 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236323AbhJLMdf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 08:33:35 -0400
Received: from fraeml736-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HTFMC3MQ9z67Lqc;
        Tue, 12 Oct 2021 20:28:39 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml736-chm.china.huawei.com (10.206.15.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 12 Oct 2021 14:31:32 +0200
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 12 Oct 2021 13:31:29 +0100
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <yanaijie@huawei.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 1/4] scsi: hisi_sas: Initialise devices in .slave_alloc callback
Date:   Tue, 12 Oct 2021 20:26:25 +0800
Message-ID: <1634041588-74824-2-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1634041588-74824-1-git-send-email-john.garry@huawei.com>
References: <1634041588-74824-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

Put the driver custom SCSI device initialize procedure in the more
appropriate callback from the SCSI midlayer, and not from the libsas dev
found callback.

The .slave_alloc interface is called prior to sending any IO to the device,
which is what we want.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  1 +
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 17 ++++++++++++++---
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |  2 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  2 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  2 +-
 5 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 57be32ba0109..2213a91923a5 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -649,6 +649,7 @@ extern int hisi_sas_probe(struct platform_device *pdev,
 extern int hisi_sas_remove(struct platform_device *pdev);
 
 extern int hisi_sas_slave_configure(struct scsi_device *sdev);
+extern int hisi_sas_slave_alloc(struct scsi_device *sdev);
 extern int hisi_sas_scan_finished(struct Scsi_Host *shost, unsigned long time);
 extern void hisi_sas_scan_start(struct Scsi_Host *shost);
 extern int hisi_sas_host_reset(struct Scsi_Host *shost, int reset_type);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index bb1c8ef3a76f..0835ba7c0ac2 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -756,6 +756,20 @@ static int hisi_sas_init_device(struct domain_device *device)
 	return rc;
 }
 
+int hisi_sas_slave_alloc(struct scsi_device *sdev)
+{
+	struct domain_device *ddev;
+	int rc;
+
+	rc = sas_slave_alloc(sdev);
+	if (rc)
+		return rc;
+	ddev = sdev_to_domain_dev(sdev);
+
+	return hisi_sas_init_device(ddev);
+}
+EXPORT_SYMBOL_GPL(hisi_sas_slave_alloc);
+
 static int hisi_sas_dev_found(struct domain_device *device)
 {
 	struct hisi_hba *hisi_hba = dev_to_hisi_hba(device);
@@ -802,9 +816,6 @@ static int hisi_sas_dev_found(struct domain_device *device)
 	dev_info(dev, "dev[%d:%x] found\n",
 		sas_dev->device_id, sas_dev->dev_type);
 
-	rc = hisi_sas_init_device(device);
-	if (rc)
-		goto err_out;
 	sas_dev->dev_status = HISI_SAS_DEV_NORMAL;
 	return 0;
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 862f4e8b7eb5..51e7d12f5053 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1771,7 +1771,7 @@ static struct scsi_host_template sht_v1_hw = {
 	.max_sectors		= SCSI_DEFAULT_MAX_SECTORS,
 	.eh_device_reset_handler = sas_eh_device_reset_handler,
 	.eh_target_reset_handler = sas_eh_target_reset_handler,
-	.slave_alloc		= sas_slave_alloc,
+	.slave_alloc		= hisi_sas_slave_alloc,
 	.target_destroy		= sas_target_destroy,
 	.ioctl			= sas_ioctl,
 #ifdef CONFIG_COMPAT
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 236cf65c2f97..741a62e6bf77 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -3584,7 +3584,7 @@ static struct scsi_host_template sht_v2_hw = {
 	.max_sectors		= SCSI_DEFAULT_MAX_SECTORS,
 	.eh_device_reset_handler = sas_eh_device_reset_handler,
 	.eh_target_reset_handler = sas_eh_target_reset_handler,
-	.slave_alloc		= sas_slave_alloc,
+	.slave_alloc		= hisi_sas_slave_alloc,
 	.target_destroy		= sas_target_destroy,
 	.ioctl			= sas_ioctl,
 #ifdef CONFIG_COMPAT
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index f4517f3eb922..114a59654525 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -3157,7 +3157,7 @@ static struct scsi_host_template sht_v3_hw = {
 	.max_sectors		= SCSI_DEFAULT_MAX_SECTORS,
 	.eh_device_reset_handler = sas_eh_device_reset_handler,
 	.eh_target_reset_handler = sas_eh_target_reset_handler,
-	.slave_alloc		= sas_slave_alloc,
+	.slave_alloc		= hisi_sas_slave_alloc,
 	.target_destroy		= sas_target_destroy,
 	.ioctl			= sas_ioctl,
 #ifdef CONFIG_COMPAT
-- 
2.26.2

