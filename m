From: John Garry <john.garry@huawei.com>
Subject: [PATCH 09/15] hisi_sas: set dma mask before allocate DMA memory
Date: Tue, 6 Sep 2016 23:36:19 +0800
Message-ID: <1473176185-217808-10-git-send-email-john.garry@huawei.com>
References: <1473176185-217808-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:47498 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935727AbcIFPXw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Sep 2016 11:23:52 -0400
In-Reply-To: <1473176185-217808-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>

The device DMA mask was being set after the bulk of the
DMA allocations in the driver init, so potentially
DMA allocates fail.
To resolve, relocate before allocating the DMA memory when
initialising the driver.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index d58e223..2f872f7 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1439,6 +1439,12 @@ static struct Scsi_Host *hisi_sas_shost_alloc(struct platform_device *pdev,
 				     &hisi_hba->queue_count))
 		goto err_out;
 
+	if (dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64)) &&
+	    dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32))) {
+		dev_err(dev, "No usable DMA addressing method\n");
+		goto err_out;
+	}
+
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	hisi_hba->regs = devm_ioremap_resource(dev, res);
 	if (IS_ERR(hisi_hba->regs))
@@ -1486,13 +1492,6 @@ int hisi_sas_probe(struct platform_device *pdev,
 	hisi_hba = shost_priv(shost);
 	platform_set_drvdata(pdev, sha);
 
-	if (dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64)) &&
-	    dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32))) {
-		dev_err(dev, "No usable DMA addressing method\n");
-		rc = -EIO;
-		goto err_out_ha;
-	}
-
 	phy_nr = port_nr = hisi_hba->n_phy;
 
 	arr_phy = devm_kcalloc(dev, phy_nr, sizeof(void *), GFP_KERNEL);
-- 
1.9.1

