Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EAEDC433DB
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 11:41:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24FF664E43
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 11:41:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbhBGLld (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 7 Feb 2021 06:41:33 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:12483 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbhBGLlC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Feb 2021 06:41:02 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DYRx049X7zjKp2;
        Sun,  7 Feb 2021 19:38:12 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Sun, 7 Feb 2021 19:39:25 +0800
From:   Xiaofei Tan <tanxiaofei@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>, Xiaofei Tan <tanxiaofei@huawei.com>
Subject: [PATCH for-next 02/32] scsi: ipr: Replace spin_lock_irqsave with spin_lock in hard IRQ
Date:   Sun, 7 Feb 2021 19:36:33 +0800
Message-ID: <1612697823-8073-3-git-send-email-tanxiaofei@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1612697823-8073-1-git-send-email-tanxiaofei@huawei.com>
References: <1612697823-8073-1-git-send-email-tanxiaofei@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

It is redundant to do irqsave and irqrestore in hardIRQ context, where
it has been in a irq-disabled context.

Signed-off-by: Xiaofei Tan <tanxiaofei@huawei.com>
---
 drivers/scsi/ipr.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index e451102..0309e8f 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -5815,7 +5815,6 @@ static irqreturn_t ipr_isr(int irq, void *devp)
 {
 	struct ipr_hrr_queue *hrrq = (struct ipr_hrr_queue *)devp;
 	struct ipr_ioa_cfg *ioa_cfg = hrrq->ioa_cfg;
-	unsigned long hrrq_flags = 0;
 	u32 int_reg = 0;
 	int num_hrrq = 0;
 	int irq_none = 0;
@@ -5823,10 +5822,10 @@ static irqreturn_t ipr_isr(int irq, void *devp)
 	irqreturn_t rc = IRQ_NONE;
 	LIST_HEAD(doneq);
 
-	spin_lock_irqsave(hrrq->lock, hrrq_flags);
+	spin_lock(hrrq->lock);
 	/* If interrupts are disabled, ignore the interrupt */
 	if (!hrrq->allow_interrupts) {
-		spin_unlock_irqrestore(hrrq->lock, hrrq_flags);
+		spin_unlock(hrrq->lock);
 		return IRQ_NONE;
 	}
 
@@ -5862,7 +5861,7 @@ static irqreturn_t ipr_isr(int irq, void *devp)
 	if (unlikely(rc == IRQ_NONE))
 		rc = ipr_handle_other_interrupt(ioa_cfg, int_reg);
 
-	spin_unlock_irqrestore(hrrq->lock, hrrq_flags);
+	spin_unlock(hrrq->lock);
 	list_for_each_entry_safe(ipr_cmd, temp, &doneq, queue) {
 		list_del(&ipr_cmd->queue);
 		del_timer(&ipr_cmd->timer);
@@ -5883,16 +5882,15 @@ static irqreturn_t ipr_isr_mhrrq(int irq, void *devp)
 {
 	struct ipr_hrr_queue *hrrq = (struct ipr_hrr_queue *)devp;
 	struct ipr_ioa_cfg *ioa_cfg = hrrq->ioa_cfg;
-	unsigned long hrrq_flags = 0;
 	struct ipr_cmnd *ipr_cmd, *temp;
 	irqreturn_t rc = IRQ_NONE;
 	LIST_HEAD(doneq);
 
-	spin_lock_irqsave(hrrq->lock, hrrq_flags);
+	spin_lock(hrrq->lock);
 
 	/* If interrupts are disabled, ignore the interrupt */
 	if (!hrrq->allow_interrupts) {
-		spin_unlock_irqrestore(hrrq->lock, hrrq_flags);
+		spin_unlock(hrrq->lock);
 		return IRQ_NONE;
 	}
 
@@ -5900,7 +5898,7 @@ static irqreturn_t ipr_isr_mhrrq(int irq, void *devp)
 		if ((be32_to_cpu(*hrrq->hrrq_curr) & IPR_HRRQ_TOGGLE_BIT) ==
 		       hrrq->toggle_bit) {
 			irq_poll_sched(&hrrq->iopoll);
-			spin_unlock_irqrestore(hrrq->lock, hrrq_flags);
+			spin_unlock(hrrq->lock);
 			return IRQ_HANDLED;
 		}
 	} else {
@@ -5911,7 +5909,7 @@ static irqreturn_t ipr_isr_mhrrq(int irq, void *devp)
 				rc =  IRQ_HANDLED;
 	}
 
-	spin_unlock_irqrestore(hrrq->lock, hrrq_flags);
+	spin_unlock(hrrq->lock);
 
 	list_for_each_entry_safe(ipr_cmd, temp, &doneq, queue) {
 		list_del(&ipr_cmd->queue);
@@ -10087,16 +10085,15 @@ static int ipr_request_other_msi_irqs(struct ipr_ioa_cfg *ioa_cfg,
 static irqreturn_t ipr_test_intr(int irq, void *devp)
 {
 	struct ipr_ioa_cfg *ioa_cfg = (struct ipr_ioa_cfg *)devp;
-	unsigned long lock_flags = 0;
 	irqreturn_t rc = IRQ_HANDLED;
 
 	dev_info(&ioa_cfg->pdev->dev, "Received IRQ : %d\n", irq);
-	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+	spin_lock(ioa_cfg->host->host_lock);
 
 	ioa_cfg->msi_received = 1;
 	wake_up(&ioa_cfg->msi_wait_q);
 
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+	spin_unlock(ioa_cfg->host->host_lock);
 	return rc;
 }
 
-- 
2.8.1

