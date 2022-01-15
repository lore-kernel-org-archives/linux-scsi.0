Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64D40C433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 15 Jan 2022 09:05:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232707AbiAOJFd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 15 Jan 2022 04:05:33 -0500
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:57739 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232696AbiAOJFc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 15 Jan 2022 04:05:32 -0500
Received: from pop-os.home ([90.126.236.122])
        by smtp.orange.fr with ESMTPA
        id 8f04nie42hTNk8f04n3ox2; Sat, 15 Jan 2022 10:05:31 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sat, 15 Jan 2022 10:05:31 +0100
X-ME-IP: 90.126.236.122
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     John Garry <john.garry@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: hisi_sas: Remove useless DMA-32 fallback configuration
Date:   Sat, 15 Jan 2022 10:05:22 +0100
Message-Id: <1bf2d3660178b0e6f172e5208bc0bd68d31d9268.1642237482.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

As stated in [1], dma_set_mask() with a 64-bit mask never fails if
dev->dma_mask is non-NULL.
So, if it fails, the 32 bits case will also fail for the same reason.

Simplify code and remove some dead code accordingly.

[1]: https://lore.kernel.org/linux-kernel/YL3vSPK5DXTNvgdx@infradead.org/#t

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 3 ---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 2 --
 2 files changed, 5 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index a05ec7aece5a..2f53a2ee024a 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -2666,9 +2666,6 @@ static struct Scsi_Host *hisi_sas_shost_alloc(struct platform_device *pdev,
 		goto err_out;
 
 	error = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64));
-	if (error)
-		error = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32));
-
 	if (error) {
 		dev_err(dev, "No usable DMA addressing method\n");
 		goto err_out;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index a45ef9a5e12e..a01a3a7b706b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -4695,8 +4695,6 @@ hisi_sas_v3_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_out;
 
 	rc = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
-	if (rc)
-		rc = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
 	if (rc) {
 		dev_err(dev, "No usable DMA addressing method\n");
 		rc = -ENODEV;
-- 
2.32.0

