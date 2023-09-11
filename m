Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE081CA0EC8
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Sep 2023 02:32:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239238AbjILCca (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Sep 2023 22:32:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239077AbjILCcS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Sep 2023 22:32:18 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B462932C32
        for <linux-scsi@vger.kernel.org>; Mon, 11 Sep 2023 18:57:25 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40D95C116B6;
        Mon, 11 Sep 2023 23:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694474869;
        bh=gKOvxGB4qVeFzI7hX1eispc+sVINwxTBdGEtgTCls1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BIvhzXVjMtRC2esqOmuy4dO88usEcfjkERIliQu9+GZzJGA5wE9yl/UhkmYJKCTKC
         vBLA6TOkbvcM78vQe0e1gxysl2meVWUqgq/R2Kqh/NAOgj1RjGSiLVdQbwK55Bo14C
         woMeOu2lF+LaGfv88NDBKDNW7I7KS5Jfw0yG3L2J5CKhl6pVnhZsua4o8ZiukuCbzA
         DlydJEz3sv4h0NkH9ulI7P63UWDSt00xbvYTG7n3OTy3PDbBu828jI/sMjuP8nL1vi
         9unXDdEG7x9H5cSdOEE3BF21DWncMkqKbbvNqTCc1WVhQZbmfJvTpZPzPy3HTzI58d
         9sr72Do8TKSrg==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Jack Wang <jinpu.wang@ionos.com>
Subject: [PATCH v2 03/10] scsi: pm8001: Introduce pm8001_init_tasklet()
Date:   Tue, 12 Sep 2023 08:27:38 +0900
Message-ID: <20230911232745.325149-4-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230911232745.325149-1-dlemoal@kernel.org>
References: <20230911232745.325149-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Factor out the identical code for initializing tasklets in
pm8001_pci_alloc() and pm8001_pci_resume() and instead use the new
function pm8001_init_tasklet().

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Acked-by: Jack Wang <jinpu.wang@ionos.com>
---
 drivers/scsi/pm8001/pm8001_init.c | 51 ++++++++++++++++---------------
 1 file changed, 27 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 3b7d47cd70ba..c490c8509494 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -218,6 +218,27 @@ static void pm8001_tasklet(unsigned long opaque)
 		BUG_ON(1);
 	PM8001_CHIP_DISP->isr(pm8001_ha, irq_vector->irq_id);
 }
+
+static void pm8001_init_tasklet(struct pm8001_hba_info *pm8001_ha)
+{
+	int i;
+
+	/*  Tasklet for non msi-x interrupt handler */
+	if ((!pm8001_ha->pdev->msix_cap || !pci_msi_enabled()) ||
+	    (pm8001_ha->chip_id == chip_8001)) {
+		tasklet_init(&pm8001_ha->tasklet[0], pm8001_tasklet,
+			     (unsigned long)&(pm8001_ha->irq_vector[0]));
+		return;
+	}
+	for (i = 0; i < PM8001_MAX_MSIX_VEC; i++)
+		tasklet_init(&pm8001_ha->tasklet[i], pm8001_tasklet,
+			     (unsigned long)&(pm8001_ha->irq_vector[i]));
+}
+
+#else
+
+static void pm8001_init_tasklet(struct pm8001_hba_info *pm8001_ha) {}
+
 #endif
 
 /**
@@ -512,7 +533,6 @@ static struct pm8001_hba_info *pm8001_pci_alloc(struct pci_dev *pdev,
 {
 	struct pm8001_hba_info *pm8001_ha;
 	struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
-	int j;
 
 	pm8001_ha = sha->lldd_ha;
 	if (!pm8001_ha)
@@ -543,17 +563,8 @@ static struct pm8001_hba_info *pm8001_pci_alloc(struct pci_dev *pdev,
 	else
 		pm8001_ha->iomb_size = IOMB_SIZE_SPC;
 
-#ifdef PM8001_USE_TASKLET
-	/* Tasklet for non msi-x interrupt handler */
-	if ((!pdev->msix_cap || !pci_msi_enabled())
-	    || (pm8001_ha->chip_id == chip_8001))
-		tasklet_init(&pm8001_ha->tasklet[0], pm8001_tasklet,
-			(unsigned long)&(pm8001_ha->irq_vector[0]));
-	else
-		for (j = 0; j < PM8001_MAX_MSIX_VEC; j++)
-			tasklet_init(&pm8001_ha->tasklet[j], pm8001_tasklet,
-				(unsigned long)&(pm8001_ha->irq_vector[j]));
-#endif
+	pm8001_init_tasklet(pm8001_ha);
+
 	if (pm8001_ioremap(pm8001_ha))
 		goto failed_pci_alloc;
 	if (!pm8001_alloc(pm8001_ha, ent))
@@ -1362,7 +1373,7 @@ static int __maybe_unused pm8001_pci_resume(struct device *dev)
 	struct sas_ha_struct *sha = pci_get_drvdata(pdev);
 	struct pm8001_hba_info *pm8001_ha;
 	int rc;
-	u8 i = 0, j;
+	u8 i = 0;
 	DECLARE_COMPLETION_ONSTACK(completion);
 
 	pm8001_ha = sha->lldd_ha;
@@ -1390,17 +1401,9 @@ static int __maybe_unused pm8001_pci_resume(struct device *dev)
 	rc = pm8001_request_irq(pm8001_ha);
 	if (rc)
 		goto err_out_disable;
-#ifdef PM8001_USE_TASKLET
-	/*  Tasklet for non msi-x interrupt handler */
-	if ((!pdev->msix_cap || !pci_msi_enabled()) ||
-	    (pm8001_ha->chip_id == chip_8001))
-		tasklet_init(&pm8001_ha->tasklet[0], pm8001_tasklet,
-			(unsigned long)&(pm8001_ha->irq_vector[0]));
-	else
-		for (j = 0; j < PM8001_MAX_MSIX_VEC; j++)
-			tasklet_init(&pm8001_ha->tasklet[j], pm8001_tasklet,
-				(unsigned long)&(pm8001_ha->irq_vector[j]));
-#endif
+
+	pm8001_init_tasklet(pm8001_ha);
+
 	PM8001_CHIP_DISP->interrupt_enable(pm8001_ha, 0);
 	if (pm8001_ha->chip_id != chip_8001) {
 		for (i = 1; i < pm8001_ha->number_of_intr; i++)
-- 
2.41.0

