Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56017C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 10:06:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3984360F25
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 10:06:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236059AbhHXKGk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Aug 2021 06:06:40 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3682 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236001AbhHXKGe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Aug 2021 06:06:34 -0400
Received: from fraeml702-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Gv4Th4Q14z67P4M;
        Tue, 24 Aug 2021 18:04:40 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml702-chm.china.huawei.com (10.206.15.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Tue, 24 Aug 2021 12:05:49 +0200
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 24 Aug 2021 11:05:47 +0100
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 1/5] scsi: hisi_sas: Use managed PCI functions
Date:   Tue, 24 Aug 2021 18:00:56 +0800
Message-ID: <1629799260-120116-2-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1629799260-120116-1-git-send-email-john.garry@huawei.com>
References: <1629799260-120116-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

Use managed PCI functions such as pcim_enable_device() and
pcim_iomap_regions() to simplify exception handling code.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 3ab669dc806f..e3be5743e77b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -518,6 +518,8 @@ struct hisi_sas_err_record_v3 {
 #define CHNL_INT_STS_INT2_MSK BIT(3)
 #define CHNL_WIDTH 4
 
+#define BAR_NO_V3_HW	5
+
 enum {
 	DSM_FUNC_ERR_HANDLE_MSI = 0,
 };
@@ -4676,15 +4678,15 @@ hisi_sas_v3_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	struct sas_ha_struct *sha;
 	int rc, phy_nr, port_nr, i;
 
-	rc = pci_enable_device(pdev);
+	rc = pcim_enable_device(pdev);
 	if (rc)
 		goto err_out;
 
 	pci_set_master(pdev);
 
-	rc = pci_request_regions(pdev, DRV_NAME);
+	rc = pcim_iomap_regions(pdev, 1 << BAR_NO_V3_HW, DRV_NAME);
 	if (rc)
-		goto err_out_disable_device;
+		goto err_out;
 
 	rc = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
 	if (rc)
@@ -4692,20 +4694,20 @@ hisi_sas_v3_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (rc) {
 		dev_err(dev, "No usable DMA addressing method\n");
 		rc = -ENODEV;
-		goto err_out_regions;
+		goto err_out;
 	}
 
 	shost = hisi_sas_shost_alloc_pci(pdev);
 	if (!shost) {
 		rc = -ENOMEM;
-		goto err_out_regions;
+		goto err_out;
 	}
 
 	sha = SHOST_TO_SAS_HA(shost);
 	hisi_hba = shost_priv(shost);
 	dev_set_drvdata(dev, sha);
 
-	hisi_hba->regs = pcim_iomap(pdev, 5, 0);
+	hisi_hba->regs = pcim_iomap_table(pdev)[BAR_NO_V3_HW];
 	if (!hisi_hba->regs) {
 		dev_err(dev, "cannot map register\n");
 		rc = -ENOMEM;
@@ -4799,10 +4801,6 @@ hisi_sas_v3_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 err_out_ha:
 	hisi_sas_free(hisi_hba);
 	scsi_host_put(shost);
-err_out_regions:
-	pci_release_regions(pdev);
-err_out_disable_device:
-	pci_disable_device(pdev);
 err_out:
 	return rc;
 }
@@ -4840,8 +4838,6 @@ static void hisi_sas_v3_remove(struct pci_dev *pdev)
 	sas_remove_host(sha->core.shost);
 
 	hisi_sas_v3_destroy_irqs(pdev, hisi_hba);
-	pci_release_regions(pdev);
-	pci_disable_device(pdev);
 	hisi_sas_free(hisi_hba);
 	debugfs_exit_v3_hw(hisi_hba);
 	scsi_host_put(shost);
-- 
2.26.2

