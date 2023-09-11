Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94F20EEB57D
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Sep 2023 03:02:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233191AbjIKDCa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 Sep 2023 23:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232997AbjIKDCW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Sep 2023 23:02:22 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9D3DB0
        for <linux-scsi@vger.kernel.org>; Sun, 10 Sep 2023 20:02:17 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15BA3C433CA;
        Mon, 11 Sep 2023 03:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694401337;
        bh=vABEydG0EYCgyHCobCdg3PK9jnt9KEDPVntcoCIfhcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q0tIEbJadfgjHpHnD09XcbH4nCPMZWe+vzCPkNp9CQXUENq9aoh39nxsh5B/LB5XW
         O4bByLeJYLumzGJLPXW+zq1blPt+tcNDbo14QR5oNaM16p0JP7Cl/UjzqTXkbpiAkP
         ekCO0JHCREFRtfabn8Sd8aMEeKoo7uce0EAbd5OR3tAbNT5snF+0qcibcz1dsr7vno
         tCnauMiX0m/GpA2erNUrQ+TCNNLEFzHLv3rI2LfaI40M2cU4PJesMocpS+UUilCKHz
         i21kINt8BGIzGtYFEWo5oKYe0eLBnCPKoquHszuFLPXD7juQFOqCRe5WYsfKxjrS8N
         E8UeuTzw7P86g==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Jack Wang <jinpu.wang@ionos.com>
Subject: [PATCH 09/10] scsi: pm8001: Remove PM8001_USE_TASKLET
Date:   Mon, 11 Sep 2023 12:02:06 +0900
Message-ID: <20230911030207.242917-10-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230911030207.242917-1-dlemoal@kernel.org>
References: <20230911030207.242917-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove the macro PM8001_USE_TASKLET used to conditionally use tasklets
for MSIX interrupts handling and replace it with the boolean module
parameter pm8001_use_tasklet. This parameter defaults to true and can be
true only if pm8001_use_msix is also true.

Code conditionnaly defined with PM8001_USE_TASKLET is modified to
instead use the parameter pm8001_use_tasklet.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/pm8001/pm8001_init.c | 40 ++++++++++++++++---------------
 drivers/scsi/pm8001/pm8001_sas.h  |  3 ---
 2 files changed, 21 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 8e59d0d46cd3..78c22421d6fe 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -60,6 +60,10 @@ bool pm8001_use_msix = true;
 module_param_named(use_msix, pm8001_use_msix, bool, 0444);
 MODULE_PARM_DESC(zoned, "Use MSIX interrupts. Default: true");
 
+static bool pm8001_use_tasklet = true;
+module_param_named(use_tasklet, pm8001_use_tasklet, bool, 0444);
+MODULE_PARM_DESC(zoned, "Use MSIX interrupts. Default: true");
+
 static struct scsi_transport_template *pm8001_stt;
 static int pm8001_init_ccb_tag(struct pm8001_hba_info *);
 
@@ -204,8 +208,6 @@ static void pm8001_free(struct pm8001_hba_info *pm8001_ha)
 	kfree(pm8001_ha);
 }
 
-#ifdef PM8001_USE_TASKLET
-
 /**
  * pm8001_tasklet() - tasklet for 64 msi-x interrupt handler
  * @opaque: the passed general host adapter struct
@@ -213,13 +215,12 @@ static void pm8001_free(struct pm8001_hba_info *pm8001_ha)
  */
 static void pm8001_tasklet(unsigned long opaque)
 {
-	struct pm8001_hba_info *pm8001_ha;
-	struct isr_param *irq_vector;
+	struct isr_param *irq_vector = (struct isr_param *)opaque;
+	struct pm8001_hba_info *pm8001_ha = irq_vector->drv_inst;
+
+	if (WARN_ON_ONCE(!pm8001_ha))
+		return;
 
-	irq_vector = (struct isr_param *)opaque;
-	pm8001_ha = irq_vector->drv_inst;
-	if (unlikely(!pm8001_ha))
-		BUG_ON(1);
 	PM8001_CHIP_DISP->isr(pm8001_ha, irq_vector->irq_id);
 }
 
@@ -227,6 +228,9 @@ static void pm8001_init_tasklet(struct pm8001_hba_info *pm8001_ha)
 {
 	int i;
 
+	if (!pm8001_use_tasklet)
+		return;
+
 	/*  Tasklet for non msi-x interrupt handler */
 	if ((!pm8001_ha->pdev->msix_cap || !pci_msi_enabled()) ||
 	    (pm8001_ha->chip_id == chip_8001)) {
@@ -243,6 +247,9 @@ static void pm8001_kill_tasklet(struct pm8001_hba_info *pm8001_ha)
 {
 	int i;
 
+	if (!pm8001_use_tasklet)
+		return;
+
 	/* For non-msix and msix interrupts */
 	if ((!pm8001_ha->pdev->msix_cap || !pci_msi_enabled()) ||
 	    (pm8001_ha->chip_id == chip_8001)) {
@@ -254,13 +261,6 @@ static void pm8001_kill_tasklet(struct pm8001_hba_info *pm8001_ha)
 		tasklet_kill(&pm8001_ha->tasklet[i]);
 }
 
-#else
-
-static void pm8001_init_tasklet(struct pm8001_hba_info *pm8001_ha) {}
-static void pm8001_kill_tasklet(struct pm8001_hba_info *pm8001_ha) {}
-
-#endif
-
 static irqreturn_t pm8001_handle_irq(struct pm8001_hba_info *pm8001_ha,
 				     int irq)
 {
@@ -270,12 +270,11 @@ static irqreturn_t pm8001_handle_irq(struct pm8001_hba_info *pm8001_ha,
 	if (!PM8001_CHIP_DISP->is_our_interrupt(pm8001_ha))
 		return IRQ_NONE;
 
-#ifdef PM8001_USE_TASKLET
+	if (!pm8001_use_tasklet)
+		return PM8001_CHIP_DISP->isr(pm8001_ha, irq);
+
 	tasklet_schedule(&pm8001_ha->tasklet[irq]);
 	return IRQ_HANDLED;
-#else
-	return PM8001_CHIP_DISP->isr(pm8001_ha, irq);
-#endif
 }
 
 /**
@@ -1538,6 +1537,9 @@ static int __init pm8001_init(void)
 {
 	int rc = -ENOMEM;
 
+	if (pm8001_use_tasklet && !pm8001_use_msix)
+		pm8001_use_tasklet = false;
+
 	pm8001_wq = alloc_workqueue("pm80xx", 0, 0);
 	if (!pm8001_wq)
 		goto err;
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index 612856b09187..e14c6668b0d3 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -85,7 +85,6 @@ do {									\
 
 extern bool pm8001_use_msix;
 
-#define PM8001_USE_TASKLET
 #define PM8001_READ_VPD
 
 
@@ -526,9 +525,7 @@ struct pm8001_hba_info {
 	int			number_of_intr;/*will be used in remove()*/
 	char			intr_drvname[PM8001_MAX_MSIX_VEC]
 				[PM8001_NAME_LENGTH+1+3+1];
-#ifdef PM8001_USE_TASKLET
 	struct tasklet_struct	tasklet[PM8001_MAX_MSIX_VEC];
-#endif
 	u32			logging_level;
 	u32			link_rate;
 	u32			fw_status;
-- 
2.41.0

