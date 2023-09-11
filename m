Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE7E4EEB57D
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Sep 2023 03:02:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232531AbjIKDCT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 Sep 2023 23:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbjIKDCP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Sep 2023 23:02:15 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A880BB0
        for <linux-scsi@vger.kernel.org>; Sun, 10 Sep 2023 20:02:11 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA181C433C9;
        Mon, 11 Sep 2023 03:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694401331;
        bh=CLxJThbcwKovpWhuPEoLGPcDu3VVfm5SMyaJSuAlGE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QzT1visii7sN0vx4/EMl7MX6601SeRMQYh1io1MUMgK3MKxrzF5N97dNJdDGmiGBs
         zehlkMVNEXR88VUcBZbRPi1o7nIU92StxFWVcv3csGCFfFGKQM0TLf3GADvuPgYD5g
         0E7mnQhK00xVVChQ6BfWIqcnHvQPnseglXM/VlACMe5B6oUzHQ1XXsiIs0qCXDpjMz
         bPxxe8VS6oUKLSZN+YPfnIezEmrEZGf6W8KeY2GNIZzvUSgu0tTNKEwxWxUJqfzSsP
         Dbl5C40Gbnr/FxaQbQU94cF9y2cN0ivgFWXg3K2SJ9RDT9RkNv1V5HDtc8e02d0jmY
         4BDJ9iuV5HZ4g==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Jack Wang <jinpu.wang@ionos.com>
Subject: [PATCH 02/10] scsi: pm8001: Introduce pm8001_free_irq()
Date:   Mon, 11 Sep 2023 12:01:59 +0900
Message-ID: <20230911030207.242917-3-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230911030207.242917-1-dlemoal@kernel.org>
References: <20230911030207.242917-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of repeating the same code twice in pm8001_pci_remove() and
pm8001_pci_suspend() to free IRQs, introduuce the function
pm8001_free_irq() to do that.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/pm8001/pm8001_init.c | 49 ++++++++++++++++++-------------
 1 file changed, 28 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 443a3176c6c0..3b7d47cd70ba 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -274,6 +274,7 @@ static irqreturn_t pm8001_interrupt_handler_intx(int irq, void *dev_id)
 }
 
 static u32 pm8001_request_irq(struct pm8001_hba_info *pm8001_ha);
+static void pm8001_free_irq(struct pm8001_hba_info *pm8001_ha);
 
 /**
  * pm8001_alloc - initiate our hba structure and 6 DMAs area.
@@ -1057,6 +1058,24 @@ static u32 pm8001_request_irq(struct pm8001_hba_info *pm8001_ha)
 			   SHOST_TO_SAS_HA(pm8001_ha->shost));
 }
 
+static void pm8001_free_irq(struct pm8001_hba_info *pm8001_ha)
+{
+#ifdef PM8001_USE_MSIX
+	struct pci_dev *pdev = pm8001_ha->pdev;
+	int i;
+
+	for (i = 0; i < pm8001_ha->number_of_intr; i++)
+		synchronize_irq(pci_irq_vector(pdev, i));
+
+	for (i = 0; i < pm8001_ha->number_of_intr; i++)
+		free_irq(pci_irq_vector(pdev, i), &pm8001_ha->irq_vector[i]);
+
+	pci_free_irq_vectors(pdev);
+#else
+	free_irq(pm8001_ha->irq, pm8001_ha->sas);
+#endif
+}
+
 /**
  * pm8001_pci_probe - probe supported device
  * @pdev: pci device which kernel has been prepared for.
@@ -1252,24 +1271,17 @@ static int pm8001_init_ccb_tag(struct pm8001_hba_info *pm8001_ha)
 static void pm8001_pci_remove(struct pci_dev *pdev)
 {
 	struct sas_ha_struct *sha = pci_get_drvdata(pdev);
-	struct pm8001_hba_info *pm8001_ha;
+	struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
 	int i, j;
-	pm8001_ha = sha->lldd_ha;
+
 	sas_unregister_ha(sha);
 	sas_remove_host(pm8001_ha->shost);
 	list_del(&pm8001_ha->list);
 	PM8001_CHIP_DISP->interrupt_disable(pm8001_ha, 0xFF);
 	PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha);
 
-#ifdef PM8001_USE_MSIX
-	for (i = 0; i < pm8001_ha->number_of_intr; i++)
-		synchronize_irq(pci_irq_vector(pdev, i));
-	for (i = 0; i < pm8001_ha->number_of_intr; i++)
-		free_irq(pci_irq_vector(pdev, i), &pm8001_ha->irq_vector[i]);
-	pci_free_irq_vectors(pdev);
-#else
-	free_irq(pm8001_ha->irq, sha);
-#endif
+	pm8001_free_irq(pm8001_ha);
+
 #ifdef PM8001_USE_TASKLET
 	/* For non-msix and msix interrupts */
 	if ((!pdev->msix_cap || !pci_msi_enabled()) ||
@@ -1309,7 +1321,8 @@ static int __maybe_unused pm8001_pci_suspend(struct device *dev)
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct sas_ha_struct *sha = pci_get_drvdata(pdev);
 	struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
-	int  i, j;
+	int j;
+
 	sas_suspend_ha(sha);
 	flush_workqueue(pm8001_wq);
 	scsi_block_requests(pm8001_ha->shost);
@@ -1319,15 +1332,9 @@ static int __maybe_unused pm8001_pci_suspend(struct device *dev)
 	}
 	PM8001_CHIP_DISP->interrupt_disable(pm8001_ha, 0xFF);
 	PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha);
-#ifdef PM8001_USE_MSIX
-	for (i = 0; i < pm8001_ha->number_of_intr; i++)
-		synchronize_irq(pci_irq_vector(pdev, i));
-	for (i = 0; i < pm8001_ha->number_of_intr; i++)
-		free_irq(pci_irq_vector(pdev, i), &pm8001_ha->irq_vector[i]);
-	pci_free_irq_vectors(pdev);
-#else
-	free_irq(pm8001_ha->irq, sha);
-#endif
+
+	pm8001_free_irq(pm8001_ha);
+
 #ifdef PM8001_USE_TASKLET
 	/* For non-msix and msix interrupts */
 	if ((!pdev->msix_cap || !pci_msi_enabled()) ||
-- 
2.41.0

