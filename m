Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EF2BC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Dec 2021 11:27:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231808AbhLTL1E (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Dec 2021 06:27:04 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:15947 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231774AbhLTL0w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Dec 2021 06:26:52 -0500
Received: from dggeme756-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4JHcfS3lrQzZdjx;
        Mon, 20 Dec 2021 19:23:44 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 dggeme756-chm.china.huawei.com (10.3.19.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Mon, 20 Dec 2021 19:26:50 +0800
From:   chenxiang <chenxiang66@hisilicon.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <john.garry@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH v2 15/15] scsi: hisi_sas: Use autosuspend for the host controller
Date:   Mon, 20 Dec 2021 19:21:38 +0800
Message-ID: <1639999298-244569-16-git-send-email-chenxiang66@hisilicon.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1639999298-244569-1-git-send-email-chenxiang66@hisilicon.com>
References: <1639999298-244569-1-git-send-email-chenxiang66@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggeme756-chm.china.huawei.com (10.3.19.102)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

The controller may frequently enter and exit suspend for each IO which we
need to deal with. This is inefficient and may cause too much suspend and
resume activity for the controller.
To avoid this, use a default 5s autosuspend for the controller to stop
frequently suspending and resuming. This value may still be modified via
sysfs interfaces.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Acked-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 94eb48c93ab1..a45ef9a5e12e 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -4783,6 +4783,8 @@ hisi_sas_v3_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	scsi_scan_host(shost);
 
+	pm_runtime_set_autosuspend_delay(dev, 5000);
+	pm_runtime_use_autosuspend(dev);
 	/*
 	 * For the situation that there are ATA disks connected with SAS
 	 * controller, it additionally creates ata_port which will affect the
-- 
2.33.0

