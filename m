Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95825CA0ECD
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Sep 2023 02:32:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239119AbjILCco (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Sep 2023 22:32:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239171AbjILCcW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Sep 2023 22:32:22 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C296618D03C
        for <linux-scsi@vger.kernel.org>; Mon, 11 Sep 2023 18:57:26 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16AD2C116B7;
        Mon, 11 Sep 2023 23:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694474871;
        bh=UR5JwJDrS2TqCS/8Bd7QRxilG6iP8uSQviIjl0j2CxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CRBU+vB9eRHo2PWZdI7eyLIbvCO2SKYXzdQjB8itp4loDk656QHtqH8OwTCogbeKK
         COiozHdjSHcu8+iuyr22VW7pxB70Sg2zoKu/NQhxzMONZLM7cT79YGWSd1CRHFvrXW
         gu1lXEYu9hae7f8z7e2F7BD1btZwB4JTAWsaXFN/GanDTLeedsxZXi9Xy8tJcr7WaA
         bWgK2PEjKjSTxGCL5iv3oyqGNT7uaMG803GVl/b9r6JGstcEsCzQvxN0ewOoJaBJiz
         ijSciWPYb/5MZbqCMbtGpCtZLPgz9UoTgz8zyuBJrZWDrpo5XjdKGBSLyiFBfTpNkK
         ba1x/bxAMNWnA==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Jack Wang <jinpu.wang@ionos.com>
Subject: [PATCH v2 05/10] scsi: pm8001: Introduce pm8001_handle_irq()
Date:   Tue, 12 Sep 2023 08:27:40 +0900
Message-ID: <20230911232745.325149-6-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230911232745.325149-1-dlemoal@kernel.org>
References: <20230911232745.325149-1-dlemoal@kernel.org>
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
Acked-by: Jack Wang <jinpu.wang@ionos.com>
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

