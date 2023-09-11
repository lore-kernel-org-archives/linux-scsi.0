Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C612DCA0EC3
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Sep 2023 02:32:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239095AbjILCcn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Sep 2023 22:32:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238422AbjILCcW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Sep 2023 22:32:22 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C237B18178B
        for <linux-scsi@vger.kernel.org>; Mon, 11 Sep 2023 18:57:26 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B9ACC116B5;
        Mon, 11 Sep 2023 23:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694474870;
        bh=cUzZXOzkMDkBO/29eKPRW+npFaqCvHC9TFmmpOl2d20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D9pCVO3VPdhlmy62xwcMJ1UBCnf+1ooZC4rvIBEfLv/dljuy3rL7njV4cb3zKvuuA
         GLUPD6zMHnKynbtc9ACWVVQoW4ff0fSMC3EUxDDSSrrraiGSf+cRxsMMfU6gaPrbA/
         MIeYvta6luwmz2AwSr7L5NiToZsX0id8eYEl5cqGnqMTw/1D6BwSqE/40ELo1Os0EI
         +FF9aq9mhV/6hNDwd5Z0eSlfubv7cUFLAp6VryJjQplG0dpU/6oZYOb9KGV3svA6NL
         Bq5Ors071YBOvFjDlMWMccz9uREMjyxgaSYko8pb/ae78xSeCgZmJYTlkb+m/Lk++1
         CSFIFjaZUlNrg==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Jack Wang <jinpu.wang@ionos.com>
Subject: [PATCH v2 04/10] scsi: pm8001: Introduce pm8001_kill_tasklet()
Date:   Tue, 12 Sep 2023 08:27:39 +0900
Message-ID: <20230911232745.325149-5-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230911232745.325149-1-dlemoal@kernel.org>
References: <20230911232745.325149-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Factor out the identical code for killing tasklets in
pm8001_pci_remove() and pm8001_pci_suspend() and instead use the new
function pm8001_kill_tasklet().

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Acked-by: Jack Wang <jinpu.wang@ionos.com>
---
 drivers/scsi/pm8001/pm8001_init.c | 40 +++++++++++++++----------------
 1 file changed, 19 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index c490c8509494..44a027d76fba 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -235,9 +235,25 @@ static void pm8001_init_tasklet(struct pm8001_hba_info *pm8001_ha)
 			     (unsigned long)&(pm8001_ha->irq_vector[i]));
 }
 
+static void pm8001_kill_tasklet(struct pm8001_hba_info *pm8001_ha)
+{
+	int i;
+
+	/* For non-msix and msix interrupts */
+	if ((!pm8001_ha->pdev->msix_cap || !pci_msi_enabled()) ||
+	    (pm8001_ha->chip_id == chip_8001)) {
+		tasklet_kill(&pm8001_ha->tasklet[0]);
+		return;
+	}
+
+	for (i = 0; i < PM8001_MAX_MSIX_VEC; i++)
+		tasklet_kill(&pm8001_ha->tasklet[i]);
+}
+
 #else
 
 static void pm8001_init_tasklet(struct pm8001_hba_info *pm8001_ha) {}
+static void pm8001_kill_tasklet(struct pm8001_hba_info *pm8001_ha) {}
 
 #endif
 
@@ -1283,7 +1299,7 @@ static void pm8001_pci_remove(struct pci_dev *pdev)
 {
 	struct sas_ha_struct *sha = pci_get_drvdata(pdev);
 	struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
-	int i, j;
+	int i;
 
 	sas_unregister_ha(sha);
 	sas_remove_host(pm8001_ha->shost);
@@ -1292,16 +1308,7 @@ static void pm8001_pci_remove(struct pci_dev *pdev)
 	PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha);
 
 	pm8001_free_irq(pm8001_ha);
-
-#ifdef PM8001_USE_TASKLET
-	/* For non-msix and msix interrupts */
-	if ((!pdev->msix_cap || !pci_msi_enabled()) ||
-	    (pm8001_ha->chip_id == chip_8001))
-		tasklet_kill(&pm8001_ha->tasklet[0]);
-	else
-		for (j = 0; j < PM8001_MAX_MSIX_VEC; j++)
-			tasklet_kill(&pm8001_ha->tasklet[j]);
-#endif
+	pm8001_kill_tasklet(pm8001_ha);
 	scsi_host_put(pm8001_ha->shost);
 
 	for (i = 0; i < pm8001_ha->ccb_count; i++) {
@@ -1332,7 +1339,6 @@ static int __maybe_unused pm8001_pci_suspend(struct device *dev)
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct sas_ha_struct *sha = pci_get_drvdata(pdev);
 	struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
-	int j;
 
 	sas_suspend_ha(sha);
 	flush_workqueue(pm8001_wq);
@@ -1345,16 +1351,8 @@ static int __maybe_unused pm8001_pci_suspend(struct device *dev)
 	PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha);
 
 	pm8001_free_irq(pm8001_ha);
+	pm8001_kill_tasklet(pm8001_ha);
 
-#ifdef PM8001_USE_TASKLET
-	/* For non-msix and msix interrupts */
-	if ((!pdev->msix_cap || !pci_msi_enabled()) ||
-	    (pm8001_ha->chip_id == chip_8001))
-		tasklet_kill(&pm8001_ha->tasklet[0]);
-	else
-		for (j = 0; j < PM8001_MAX_MSIX_VEC; j++)
-			tasklet_kill(&pm8001_ha->tasklet[j]);
-#endif
 	pm8001_info(pm8001_ha, "pdev=0x%p, slot=%s, entering "
 		      "suspended state\n", pdev,
 		      pm8001_ha->name);
-- 
2.41.0

