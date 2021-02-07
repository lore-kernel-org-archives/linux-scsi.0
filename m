Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7518CC433DB
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 11:43:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4875A64E3A
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 11:43:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbhBGLnQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 7 Feb 2021 06:43:16 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:12459 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbhBGLlh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Feb 2021 06:41:37 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DYRxV312czjJml;
        Sun,  7 Feb 2021 19:38:38 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Sun, 7 Feb 2021 19:39:38 +0800
From:   Xiaofei Tan <tanxiaofei@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>, Xiaofei Tan <tanxiaofei@huawei.com>
Subject: [PATCH for-next 31/32] scsi: wd719x: Replace spin_lock_irqsave with spin_lock in hard IRQ
Date:   Sun, 7 Feb 2021 19:37:02 +0800
Message-ID: <1612697823-8073-32-git-send-email-tanxiaofei@huawei.com>
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
 drivers/scsi/wd719x.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/wd719x.c b/drivers/scsi/wd719x.c
index edc8a13..ef372f3 100644
--- a/drivers/scsi/wd719x.c
+++ b/drivers/scsi/wd719x.c
@@ -657,10 +657,9 @@ static irqreturn_t wd719x_interrupt(int irq, void *dev_id)
 {
 	struct wd719x *wd = dev_id;
 	union wd719x_regs regs;
-	unsigned long flags;
 	u32 SCB_out;
 
-	spin_lock_irqsave(wd->sh->host_lock, flags);
+	spin_lock(wd->sh->host_lock);
 	/* read SCB pointer back from card */
 	SCB_out = wd719x_readl(wd, WD719X_AMR_SCB_OUT);
 	/* read all status info at once */
@@ -668,7 +667,7 @@ static irqreturn_t wd719x_interrupt(int irq, void *dev_id)
 
 	switch (regs.bytes.INT) {
 	case WD719X_INT_NONE:
-		spin_unlock_irqrestore(wd->sh->host_lock, flags);
+		spin_unlock(wd->sh->host_lock);
 		return IRQ_NONE;
 	case WD719X_INT_LINKNOSTATUS:
 		dev_err(&wd->pdev->dev, "linked command completed with no status\n");
@@ -705,7 +704,7 @@ static irqreturn_t wd719x_interrupt(int irq, void *dev_id)
 	}
 	/* clear interrupt so another can happen */
 	wd719x_writeb(wd, WD719X_AMR_INT_STATUS, WD719X_INT_NONE);
-	spin_unlock_irqrestore(wd->sh->host_lock, flags);
+	spin_unlock(wd->sh->host_lock);
 
 	return IRQ_HANDLED;
 }
-- 
2.8.1

