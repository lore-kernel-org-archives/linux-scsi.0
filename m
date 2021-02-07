Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE9CFC43381
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 11:41:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9D9664E3C
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 11:41:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbhBGLkt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 7 Feb 2021 06:40:49 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:12448 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbhBGLk0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Feb 2021 06:40:26 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DYRxV0b6mzjJlk;
        Sun,  7 Feb 2021 19:38:38 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Sun, 7 Feb 2021 19:39:37 +0800
From:   Xiaofei Tan <tanxiaofei@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>, Xiaofei Tan <tanxiaofei@huawei.com>
Subject: [PATCH for-next 29/32] scsi: stex: Replace spin_lock_irqsave with spin_lock in hard IRQ
Date:   Sun, 7 Feb 2021 19:37:00 +0800
Message-ID: <1612697823-8073-30-git-send-email-tanxiaofei@huawei.com>
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
 drivers/scsi/stex.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 1247120..1e797d1 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -886,9 +886,8 @@ static irqreturn_t stex_intr(int irq, void *__hba)
 	struct st_hba *hba = __hba;
 	void __iomem *base = hba->mmio_base;
 	u32 data;
-	unsigned long flags;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock(hba->host->host_lock);
 
 	data = readl(base + ODBL);
 
@@ -897,14 +896,14 @@ static irqreturn_t stex_intr(int irq, void *__hba)
 		writel(data, base + ODBL);
 		readl(base + ODBL); /* flush */
 		stex_mu_intr(hba, data);
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		spin_unlock(hba->host->host_lock);
 		if (unlikely(data & MU_OUTBOUND_DOORBELL_REQUEST_RESET &&
 			hba->cardtype == st_shasta))
 			queue_work(hba->work_q, &hba->reset_work);
 		return IRQ_HANDLED;
 	}
 
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock(hba->host->host_lock);
 
 	return IRQ_NONE;
 }
@@ -987,9 +986,8 @@ static irqreturn_t stex_ss_intr(int irq, void *__hba)
 	struct st_hba *hba = __hba;
 	void __iomem *base = hba->mmio_base;
 	u32 data;
-	unsigned long flags;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock(hba->host->host_lock);
 
 	if (hba->cardtype == st_yel) {
 		data = readl(base + YI2H_INT);
@@ -997,7 +995,7 @@ static irqreturn_t stex_ss_intr(int irq, void *__hba)
 			/* clear the interrupt */
 			writel(data, base + YI2H_INT_C);
 			stex_ss_mu_intr(hba);
-			spin_unlock_irqrestore(hba->host->host_lock, flags);
+			spin_unlock(hba->host->host_lock);
 			if (unlikely(data & SS_I2H_REQUEST_RESET))
 				queue_work(hba->work_q, &hba->reset_work);
 			return IRQ_HANDLED;
@@ -1011,14 +1009,14 @@ static irqreturn_t stex_ss_intr(int irq, void *__hba)
 				writel((1 << 22), base + YH2I_INT);
 			}
 			stex_ss_mu_intr(hba);
-			spin_unlock_irqrestore(hba->host->host_lock, flags);
+			spin_unlock(hba->host->host_lock);
 			if (unlikely(data & SS_I2H_REQUEST_RESET))
 				queue_work(hba->work_q, &hba->reset_work);
 			return IRQ_HANDLED;
 		}
 	}
 
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock(hba->host->host_lock);
 
 	return IRQ_NONE;
 }
-- 
2.8.1

