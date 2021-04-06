Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18CE3C433B4
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 11:52:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9EEB613B7
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 11:52:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343538AbhDFLw6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Apr 2021 07:52:58 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:16362 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243272AbhDFLw5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2021 07:52:57 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FF5SY3Qpzz93l6;
        Tue,  6 Apr 2021 19:50:37 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.498.0; Tue, 6 Apr 2021 19:52:37 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.orgc>,
        <linuxarm@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 3/6] scsi: hisi_sas: Call sas_unregister_ha() to roll back if .hw_init() fails
Date:   Tue, 6 Apr 2021 19:48:28 +0800
Message-ID: <1617709711-195853-4-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1617709711-195853-1-git-send-email-john.garry@huawei.com>
References: <1617709711-195853-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

Function sas_unregister_ha() needs to be called to roll back if
hisi_hba->hw->hw_init() fails in function hisi_sas_probe() or
hisi_sas_v3_probe(), so make that change.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 4 +++-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index a979edfd9a78..971c45a1401c 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -2689,12 +2689,14 @@ int hisi_sas_probe(struct platform_device *pdev,
 
 	rc = hisi_hba->hw->hw_init(hisi_hba);
 	if (rc)
-		goto err_out_register_ha;
+		goto err_out_hw_init;
 
 	scsi_scan_host(shost);
 
 	return 0;
 
+err_out_hw_init:
+	sas_unregister_ha(sha);
 err_out_register_ha:
 	scsi_remove_host(shost);
 err_out_ha:
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 51187dd53c86..d7f8ba0c1680 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -4761,7 +4761,7 @@ hisi_sas_v3_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	rc = hisi_sas_v3_init(hisi_hba);
 	if (rc)
-		goto err_out_register_ha;
+		goto err_out_hw_init;
 
 	scsi_scan_host(shost);
 
@@ -4778,6 +4778,8 @@ hisi_sas_v3_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	return 0;
 
+err_out_hw_init:
+	sas_unregister_ha(sha);
 err_out_register_ha:
 	scsi_remove_host(shost);
 err_out_free_irq_vectors:
-- 
2.26.2

