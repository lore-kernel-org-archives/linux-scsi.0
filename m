Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98977C63798
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 08:51:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41FFA2076B
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 08:51:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730857AbgKXIug (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Nov 2020 03:50:36 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7727 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730844AbgKXIuf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Nov 2020 03:50:35 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CgHlc4ytyzkdNx;
        Tue, 24 Nov 2020 16:50:04 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Tue, 24 Nov 2020 16:50:21 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH v2 2/3] scsi: hisi_sas: Fix up probe error handling for v3 hw
Date:   Tue, 24 Nov 2020 16:46:33 +0800
Message-ID: <1606207594-196362-3-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1606207594-196362-1-git-send-email-john.garry@huawei.com>
References: <1606207594-196362-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

Fix some rollbacks in function hisi_sas_v3_probe() and
interrupt_init_v3_hw().

Fixes: 8d98416a55eb ("scsi: hisi_sas: Switch v3 hw to MQ")
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index db409f6847bb..f6d0aa3a8c11 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2409,8 +2409,7 @@ static int interrupt_init_v3_hw(struct hisi_hba *hisi_hba)
 			      DRV_NAME " phy", hisi_hba);
 	if (rc) {
 		dev_err(dev, "could not request phy interrupt, rc=%d\n", rc);
-		rc = -ENOENT;
-		goto free_irq_vectors;
+		return -ENOENT;
 	}
 
 	rc = devm_request_irq(dev, pci_irq_vector(pdev, 2),
@@ -2418,8 +2417,7 @@ static int interrupt_init_v3_hw(struct hisi_hba *hisi_hba)
 			      DRV_NAME " channel", hisi_hba);
 	if (rc) {
 		dev_err(dev, "could not request chnl interrupt, rc=%d\n", rc);
-		rc = -ENOENT;
-		goto free_irq_vectors;
+		return -ENOENT;
 	}
 
 	rc = devm_request_irq(dev, pci_irq_vector(pdev, 11),
@@ -2427,8 +2425,7 @@ static int interrupt_init_v3_hw(struct hisi_hba *hisi_hba)
 			      DRV_NAME " fatal", hisi_hba);
 	if (rc) {
 		dev_err(dev, "could not request fatal interrupt, rc=%d\n", rc);
-		rc = -ENOENT;
-		goto free_irq_vectors;
+		return -ENOENT;
 	}
 
 	if (hisi_sas_intr_conv)
@@ -2449,16 +2446,11 @@ static int interrupt_init_v3_hw(struct hisi_hba *hisi_hba)
 		if (rc) {
 			dev_err(dev, "could not request cq%d interrupt, rc=%d\n",
 				i, rc);
-			rc = -ENOENT;
-			goto free_irq_vectors;
+			return -ENOENT;
 		}
 	}
 
 	return 0;
-
-free_irq_vectors:
-	pci_free_irq_vectors(pdev);
-	return rc;
 }
 
 static int hisi_sas_v3_init(struct hisi_hba *hisi_hba)
@@ -3311,11 +3303,11 @@ hisi_sas_v3_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	rc = interrupt_preinit_v3_hw(hisi_hba);
 	if (rc)
-		goto err_out_ha;
+		goto err_out_debugfs;
 	dev_err(dev, "%d hw queues\n", shost->nr_hw_queues);
 	rc = scsi_add_host(shost, dev);
 	if (rc)
-		goto err_out_ha;
+		goto err_out_free_irq_vectors;
 
 	rc = sas_register_ha(sha);
 	if (rc)
@@ -3342,8 +3334,12 @@ hisi_sas_v3_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 err_out_register_ha:
 	scsi_remove_host(shost);
-err_out_ha:
+err_out_free_irq_vectors:
+	pci_free_irq_vectors(pdev);
+err_out_debugfs:
 	hisi_sas_debugfs_exit(hisi_hba);
+err_out_ha:
+	hisi_sas_free(hisi_hba);
 	scsi_host_put(shost);
 err_out_regions:
 	pci_release_regions(pdev);
-- 
2.26.2

