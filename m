Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA94BC433DB
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 11:44:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC4C464E43
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 11:44:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbhBGLnn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 7 Feb 2021 06:43:43 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:12456 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbhBGLlf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Feb 2021 06:41:35 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DYRxV2YlYzjJll;
        Sun,  7 Feb 2021 19:38:38 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Sun, 7 Feb 2021 19:39:33 +0800
From:   Xiaofei Tan <tanxiaofei@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>, Xiaofei Tan <tanxiaofei@huawei.com>
Subject: [PATCH for-next 20/32] scsi: myrb: Replace spin_lock_irqsave with spin_lock in hard IRQ
Date:   Sun, 7 Feb 2021 19:36:51 +0800
Message-ID: <1612697823-8073-21-git-send-email-tanxiaofei@huawei.com>
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
 drivers/scsi/myrb.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
index 3d8e91c..ecb57ee 100644
--- a/drivers/scsi/myrb.c
+++ b/drivers/scsi/myrb.c
@@ -2769,9 +2769,8 @@ static irqreturn_t DAC960_LA_intr_handler(int irq, void *arg)
 	struct myrb_hba *cb = arg;
 	void __iomem *base = cb->io_base;
 	struct myrb_stat_mbox *next_stat_mbox;
-	unsigned long flags;
 
-	spin_lock_irqsave(&cb->queue_lock, flags);
+	spin_lock(&cb->queue_lock);
 	DAC960_LA_ack_intr(base);
 	next_stat_mbox = cb->next_stat_mbox;
 	while (next_stat_mbox->valid) {
@@ -2806,7 +2805,7 @@ static irqreturn_t DAC960_LA_intr_handler(int irq, void *arg)
 		}
 	}
 	cb->next_stat_mbox = next_stat_mbox;
-	spin_unlock_irqrestore(&cb->queue_lock, flags);
+	spin_unlock(&cb->queue_lock);
 	return IRQ_HANDLED;
 }
 
@@ -3047,9 +3046,8 @@ static irqreturn_t DAC960_PG_intr_handler(int irq, void *arg)
 	struct myrb_hba *cb = arg;
 	void __iomem *base = cb->io_base;
 	struct myrb_stat_mbox *next_stat_mbox;
-	unsigned long flags;
 
-	spin_lock_irqsave(&cb->queue_lock, flags);
+	spin_lock(&cb->queue_lock);
 	DAC960_PG_ack_intr(base);
 	next_stat_mbox = cb->next_stat_mbox;
 	while (next_stat_mbox->valid) {
@@ -3082,7 +3080,7 @@ static irqreturn_t DAC960_PG_intr_handler(int irq, void *arg)
 			myrb_handle_scsi(cb, cmd_blk, scmd);
 	}
 	cb->next_stat_mbox = next_stat_mbox;
-	spin_unlock_irqrestore(&cb->queue_lock, flags);
+	spin_unlock(&cb->queue_lock);
 	return IRQ_HANDLED;
 }
 
@@ -3254,9 +3252,8 @@ static irqreturn_t DAC960_PD_intr_handler(int irq, void *arg)
 {
 	struct myrb_hba *cb = arg;
 	void __iomem *base = cb->io_base;
-	unsigned long flags;
 
-	spin_lock_irqsave(&cb->queue_lock, flags);
+	spin_lock(&cb->queue_lock);
 	while (DAC960_PD_hw_mbox_status_available(base)) {
 		unsigned char id = DAC960_PD_read_status_cmd_ident(base);
 		struct scsi_cmnd *scmd = NULL;
@@ -3285,7 +3282,7 @@ static irqreturn_t DAC960_PD_intr_handler(int irq, void *arg)
 		else
 			myrb_handle_scsi(cb, cmd_blk, scmd);
 	}
-	spin_unlock_irqrestore(&cb->queue_lock, flags);
+	spin_unlock(&cb->queue_lock);
 	return IRQ_HANDLED;
 }
 
@@ -3420,9 +3417,8 @@ static irqreturn_t DAC960_P_intr_handler(int irq, void *arg)
 {
 	struct myrb_hba *cb = arg;
 	void __iomem *base = cb->io_base;
-	unsigned long flags;
 
-	spin_lock_irqsave(&cb->queue_lock, flags);
+	spin_lock(&cb->queue_lock);
 	while (DAC960_PD_hw_mbox_status_available(base)) {
 		unsigned char id = DAC960_PD_read_status_cmd_ident(base);
 		struct scsi_cmnd *scmd = NULL;
@@ -3483,7 +3479,7 @@ static irqreturn_t DAC960_P_intr_handler(int irq, void *arg)
 		else
 			myrb_handle_scsi(cb, cmd_blk, scmd);
 	}
-	spin_unlock_irqrestore(&cb->queue_lock, flags);
+	spin_unlock(&cb->queue_lock);
 	return IRQ_HANDLED;
 }
 
-- 
2.8.1

