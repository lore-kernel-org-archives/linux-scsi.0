Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87DE9EEB57D
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Sep 2023 03:02:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232931AbjIKDCV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 Sep 2023 23:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232481AbjIKDCT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Sep 2023 23:02:19 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35B6AFB
        for <linux-scsi@vger.kernel.org>; Sun, 10 Sep 2023 20:02:14 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76516C433CA;
        Mon, 11 Sep 2023 03:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694401334;
        bh=jwFrI2plff8nqg1PjIYZlqSVNVCLIyMEbhw4BcyALzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ltfjPzMECCQj115qtL4IK1tri6cTAYWYVe1qOsf9QgVP5w6zTeneZSc/UFY+NAmOc
         ZhXxyiYiGvYtxHKHlkjlUQwhDXGAGwY8vNUodeauWdanVMgbSguI4sPRtnvFvw03+w
         Iu0b5LrxAMU3d7nhQcO5KbR7PJxgravOdNdYXNGZMsCQszTG1Kn6WHAqDi7l91MjyP
         oel9y6I1EB6j1CaP/R5QS84niLLJOPrKt83+UsX4R6ucOj0RoqqF9K9qtn+LbpVU0f
         M1Ne11mlvpwK53CpQPCNm3cWHdtJ6Ns68fjQ2o0wdQkBbuyKhBMlwQlgvzHZm+gER8
         frbg2rpwIEvwg==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Jack Wang <jinpu.wang@ionos.com>
Subject: [PATCH 05/10] scsi: pm8001: Introduce pm8001_handle_irq()
Date:   Mon, 11 Sep 2023 12:02:02 +0900
Message-ID: <20230911030207.242917-6-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230911030207.242917-1-dlemoal@kernel.org>
References: <20230911030207.242917-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Factor out the common code of pm8001_interrupt_handler_msix and of
pm8001_interrupt_handler_intx() into the new function
pm8001_handle_irq() and use this new helper in these two functions to
simplify the code.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/pm8001/pm8001_init.c | 50 ++++++++++++++-----------------
 1 file changed, 22 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 44a027d76fba..0ec43e155511 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -257,6 +257,23 @@ static void pm8001_kill_tasklet(struct pm8001_hba_info *pm8001_ha) {}
 
 #endif
 
+static irqreturn_t pm8001_handle_irq(struct pm8001_hba_info *pm8001_ha,
+				     int irq)
+{
+	if (unlikely(!pm8001_ha))
+		return IRQ_NONE;
+
+	if (!PM8001_CHIP_DISP->is_our_interrupt(pm8001_ha))
+		return IRQ_NONE;
+
+#ifdef PM8001_USE_TASKLET
+	tasklet_schedule(&pm8001_ha->tasklet[irq]);
+	return IRQ_HANDLED;
+#else
+	return PM8001_CHIP_DISP->isr(pm8001_ha, irq);
+#endif
+}
+
 /**
  * pm8001_interrupt_handler_msix - main MSIX interrupt handler.
  * It obtains the vector number and calls the equivalent bottom
@@ -267,22 +284,10 @@ static void pm8001_kill_tasklet(struct pm8001_hba_info *pm8001_ha) {}
  */
 static irqreturn_t pm8001_interrupt_handler_msix(int irq, void *opaque)
 {
-	struct isr_param *irq_vector;
-	struct pm8001_hba_info *pm8001_ha;
-	irqreturn_t ret = IRQ_HANDLED;
-	irq_vector = (struct isr_param *)opaque;
-	pm8001_ha = irq_vector->drv_inst;
+	struct isr_param *irq_vector = (struct isr_param *)opaque;
+	struct pm8001_hba_info *pm8001_ha = irq_vector->drv_inst;
 
-	if (unlikely(!pm8001_ha))
-		return IRQ_NONE;
-	if (!PM8001_CHIP_DISP->is_our_interrupt(pm8001_ha))
-		return IRQ_NONE;
-#ifdef PM8001_USE_TASKLET
-	tasklet_schedule(&pm8001_ha->tasklet[irq_vector->irq_id]);
-#else
-	ret = PM8001_CHIP_DISP->isr(pm8001_ha, irq_vector->irq_id);
-#endif
-	return ret;
+	return pm8001_handle_irq(pm8001_ha, irq_vector->irq_id);
 }
 
 /**
@@ -293,21 +298,10 @@ static irqreturn_t pm8001_interrupt_handler_msix(int irq, void *opaque)
 
 static irqreturn_t pm8001_interrupt_handler_intx(int irq, void *dev_id)
 {
-	struct pm8001_hba_info *pm8001_ha;
-	irqreturn_t ret = IRQ_HANDLED;
 	struct sas_ha_struct *sha = dev_id;
-	pm8001_ha = sha->lldd_ha;
-	if (unlikely(!pm8001_ha))
-		return IRQ_NONE;
-	if (!PM8001_CHIP_DISP->is_our_interrupt(pm8001_ha))
-		return IRQ_NONE;
+	struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
 
-#ifdef PM8001_USE_TASKLET
-	tasklet_schedule(&pm8001_ha->tasklet[0]);
-#else
-	ret = PM8001_CHIP_DISP->isr(pm8001_ha, 0);
-#endif
-	return ret;
+	return pm8001_handle_irq(pm8001_ha, 0);
 }
 
 static u32 pm8001_request_irq(struct pm8001_hba_info *pm8001_ha);
-- 
2.41.0

