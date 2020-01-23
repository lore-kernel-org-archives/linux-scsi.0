Return-Path: <SRS0=fhi0=3M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7939CC33CAA
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 06:13:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52D682467B
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 06:13:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726092AbgAWGNv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jan 2020 01:13:51 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9237 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725938AbgAWGNv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 23 Jan 2020 01:13:51 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id EF0F49EDA58A7335C42E;
        Thu, 23 Jan 2020 14:13:48 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Thu, 23 Jan 2020
 14:13:39 +0800
From:   Ye Bin <yebin10@huawei.com>
To:     <john.garry@huawei.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, Ye Bin <yebin10@huawei.com>
Subject: [PATCH] hisi_sas: Fix unreasonable exit processing of hisi_sas_v3_probe
Date:   Thu, 23 Jan 2020 14:12:49 +0800
Message-ID: <20200123061249.896-1-yebin10@huawei.com>
X-Mailer: git-send-email 2.17.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In this function, the exception return missed some processing.

Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index fa05e612d85a..394e20b8f622 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -3166,8 +3166,8 @@ hisi_sas_v3_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	struct Scsi_Host *shost;
 	struct hisi_hba *hisi_hba;
 	struct device *dev = &pdev->dev;
-	struct asd_sas_phy **arr_phy;
-	struct asd_sas_port **arr_port;
+	struct asd_sas_phy **arr_phy = NULL;
+	struct asd_sas_port **arr_port = NULL;
 	struct sas_ha_struct *sha;
 	int rc, phy_nr, port_nr, i;
 
@@ -3213,7 +3213,7 @@ hisi_sas_v3_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	arr_port = devm_kcalloc(dev, port_nr, sizeof(void *), GFP_KERNEL);
 	if (!arr_phy || !arr_port) {
 		rc = -ENOMEM;
-		goto err_out_ha;
+		goto err_out_iomap;
 	}
 
 	sha->sas_phy = arr_phy;
@@ -3254,7 +3254,7 @@ hisi_sas_v3_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	rc = scsi_add_host(shost, dev);
 	if (rc)
-		goto err_out_ha;
+		goto err_out_iomap;
 
 	rc = sas_register_ha(sha);
 	if (rc)
@@ -3262,14 +3262,20 @@ hisi_sas_v3_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
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
+err_out_iomap:
+	devm_kfree(dev, arr_phy);
+	devm_kfree(dev, arr_port);
+	pcim_iounmap(pdev, hisi_hba->regs);
 err_out_ha:
 	hisi_sas_debugfs_exit(hisi_hba);
 	scsi_host_put(shost);
-- 
2.17.2

