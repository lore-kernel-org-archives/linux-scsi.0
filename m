Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19900C433DB
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 11:42:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFF1564E43
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 11:42:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbhBGLmP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 7 Feb 2021 06:42:15 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:12087 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbhBGLlE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Feb 2021 06:41:04 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DYRwg54wXzMWJl;
        Sun,  7 Feb 2021 19:37:55 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Sun, 7 Feb 2021 19:39:29 +0800
From:   Xiaofei Tan <tanxiaofei@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>, Xiaofei Tan <tanxiaofei@huawei.com>
Subject: [PATCH for-next 11/32] scsi: esp_scsi: Replace spin_lock_irqsave with spin_lock in hard IRQ
Date:   Sun, 7 Feb 2021 19:36:42 +0800
Message-ID: <1612697823-8073-12-git-send-email-tanxiaofei@huawei.com>
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
 drivers/scsi/esp_scsi.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index 007ccef..1e44fb5 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -2175,10 +2175,9 @@ static void __esp_interrupt(struct esp *esp)
 irqreturn_t scsi_esp_intr(int irq, void *dev_id)
 {
 	struct esp *esp = dev_id;
-	unsigned long flags;
 	irqreturn_t ret;
 
-	spin_lock_irqsave(esp->host->host_lock, flags);
+	spin_lock(esp->host->host_lock);
 	ret = IRQ_NONE;
 	if (esp->ops->irq_pending(esp)) {
 		ret = IRQ_HANDLED;
@@ -2198,7 +2197,7 @@ irqreturn_t scsi_esp_intr(int irq, void *dev_id)
 				break;
 		}
 	}
-	spin_unlock_irqrestore(esp->host->host_lock, flags);
+	spin_unlock(esp->host->host_lock);
 
 	return ret;
 }
-- 
2.8.1

