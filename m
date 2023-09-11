Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AB74CA0EC3
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Sep 2023 02:32:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239046AbjILCc2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Sep 2023 22:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239098AbjILCcN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Sep 2023 22:32:13 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4A8318B8AD
        for <linux-scsi@vger.kernel.org>; Mon, 11 Sep 2023 18:57:25 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67EB1C116B4;
        Mon, 11 Sep 2023 23:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694474868;
        bh=kNHaaj0jx8YOghOyszCDjy8PPD3WeMoDW2go3Tasx+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CvzDEaB9j2ssmnQfh52z3ETx3q5J4Ta11XFsxVXYs5swJpTF+iBfPs340IihzKl48
         uN6Uac3JvMZInEc8s5IGBv3nHyYyZCXRpWxS4rZ5YagaJNTs62ge0XzxFw0IXeL6LR
         ZC2vT6GZLttbnKknyYfiFgRoFqWuIZV6S02feC9iIJQxgf0Jo/AEa9yqyxQkFms4Ac
         WgDiHfau1wABcH2QEBnAN5TwehvQfkbn7DCccPTIu9T2Hb5b7TC1WwrnLxd6T4QSuV
         fJPavq9wMPkjIbnegjks/VjuA3M8dGhIpTMzliJuEBg/3i24oL5C9VqMeGaH5UtOR1
         wwOtrB4/GD1ng==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Jack Wang <jinpu.wang@ionos.com>
Subject: [PATCH v2 01/10] scsi: pm8001: Setup IRQs on resume
Date:   Tue, 12 Sep 2023 08:27:36 +0900
Message-ID: <20230911232745.325149-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230911232745.325149-1-dlemoal@kernel.org>
References: <20230911232745.325149-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The function pm8001_pci_resume() only calls pm8001_request_irq() without
calling pm8001_setup_irq(). This causes the IRQ allocation to fail,
whihc leads all drives being removed from the system.

Fix this issue by integrating the code for pm8001_setup_irq() directly
inside pm8001_request_irq() so that msix setup is performed both during
normal initialization and resume operations.

Fixes: dbf9bfe61571 ("[SCSI] pm8001: add SAS/SATA HBA driver")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Acked-by: Jack Wang <jinpu.wang@ionos.com>
---
 drivers/scsi/pm8001/pm8001_init.c | 51 +++++++++++--------------------
 1 file changed, 17 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 5e5ce1e74c3b..443a3176c6c0 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -273,7 +273,6 @@ static irqreturn_t pm8001_interrupt_handler_intx(int irq, void *dev_id)
 	return ret;
 }
 
-static u32 pm8001_setup_irq(struct pm8001_hba_info *pm8001_ha);
 static u32 pm8001_request_irq(struct pm8001_hba_info *pm8001_ha);
 
 /**
@@ -294,13 +293,6 @@ static int pm8001_alloc(struct pm8001_hba_info *pm8001_ha,
 	pm8001_dbg(pm8001_ha, INIT, "pm8001_alloc: PHY:%x\n",
 		   pm8001_ha->chip->n_phy);
 
-	/* Setup Interrupt */
-	rc = pm8001_setup_irq(pm8001_ha);
-	if (rc) {
-		pm8001_dbg(pm8001_ha, FAIL,
-			   "pm8001_setup_irq failed [ret: %d]\n", rc);
-		goto err_out;
-	}
 	/* Request Interrupt */
 	rc = pm8001_request_irq(pm8001_ha);
 	if (rc)
@@ -1031,47 +1023,38 @@ static u32 pm8001_request_msix(struct pm8001_hba_info *pm8001_ha)
 }
 #endif
 
-static u32 pm8001_setup_irq(struct pm8001_hba_info *pm8001_ha)
-{
-	struct pci_dev *pdev;
-
-	pdev = pm8001_ha->pdev;
-
-#ifdef PM8001_USE_MSIX
-	if (pci_find_capability(pdev, PCI_CAP_ID_MSIX))
-		return pm8001_setup_msix(pm8001_ha);
-	pm8001_dbg(pm8001_ha, INIT, "MSIX not supported!!!\n");
-#endif
-	return 0;
-}
-
 /**
  * pm8001_request_irq - register interrupt
  * @pm8001_ha: our ha struct.
  */
 static u32 pm8001_request_irq(struct pm8001_hba_info *pm8001_ha)
 {
-	struct pci_dev *pdev;
+	struct pci_dev *pdev = pm8001_ha->pdev;
+#ifdef PM8001_USE_MSIX
 	int rc;
 
-	pdev = pm8001_ha->pdev;
+	if (pci_find_capability(pdev, PCI_CAP_ID_MSIX)) {
+		rc = pm8001_setup_msix(pm8001_ha);
+		if (rc) {
+			pm8001_dbg(pm8001_ha, FAIL,
+				   "pm8001_setup_irq failed [ret: %d]\n", rc);
+			return rc;
+		}
 
-#ifdef PM8001_USE_MSIX
-	if (pdev->msix_cap && pci_msi_enabled())
-		return pm8001_request_msix(pm8001_ha);
-	else {
-		pm8001_dbg(pm8001_ha, INIT, "MSIX not supported!!!\n");
-		goto intx;
+		if (pdev->msix_cap && pci_msi_enabled())
+			return pm8001_request_msix(pm8001_ha);
 	}
+
+	pm8001_dbg(pm8001_ha, INIT, "MSIX not supported!!!\n");
 #endif
 
-intx:
 	/* initialize the INT-X interrupt */
 	pm8001_ha->irq_vector[0].irq_id = 0;
 	pm8001_ha->irq_vector[0].drv_inst = pm8001_ha;
-	rc = request_irq(pdev->irq, pm8001_interrupt_handler_intx, IRQF_SHARED,
-		pm8001_ha->name, SHOST_TO_SAS_HA(pm8001_ha->shost));
-	return rc;
+
+	return request_irq(pdev->irq, pm8001_interrupt_handler_intx,
+			   IRQF_SHARED, pm8001_ha->name,
+			   SHOST_TO_SAS_HA(pm8001_ha->shost));
 }
 
 /**
-- 
2.41.0

