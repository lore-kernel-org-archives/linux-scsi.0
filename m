Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7092C4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 02:50:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEE55619EC
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 02:50:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232801AbhKQCxT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Nov 2021 21:53:19 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:14947 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232733AbhKQCxL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Nov 2021 21:53:11 -0500
Received: from dggeme756-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Hv6mP19d4zZd1s;
        Wed, 17 Nov 2021 10:47:49 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 dggeme756-chm.china.huawei.com (10.3.19.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Wed, 17 Nov 2021 10:50:11 +0800
From:   chenxiang <chenxiang66@hisilicon.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <john.garry@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH 15/15] scsi: hisi_sas: Use autosuspend for SAS controller
Date:   Wed, 17 Nov 2021 10:45:08 +0800
Message-ID: <1637117108-230103-16-git-send-email-chenxiang66@hisilicon.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1637117108-230103-1-git-send-email-chenxiang66@hisilicon.com>
References: <1637117108-230103-1-git-send-email-chenxiang66@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggeme756-chm.china.huawei.com (10.3.19.102)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

For some scenarios, it may send many IOs in a short time, then SAS controller
will enter suspend and resume frequently which is invalid.
To avoid it, use autosuspend mode for SAS controller and set default
autosuspend delay time to 5s.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index a5695ae8b73b..d96fe636e984 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -4777,6 +4777,8 @@ hisi_sas_v3_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	scsi_scan_host(shost);
 
+	pm_runtime_set_autosuspend_delay(dev, 5000);
+	pm_runtime_use_autosuspend(dev);
 	/*
 	 * For the situation that there are ATA disks connected with SAS
 	 * controller, it additionally creates ata_port which will affect the
-- 
2.33.0

