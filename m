Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B32FC433E6
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 11:44:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBA4164E43
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 11:44:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbhBGLoE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 7 Feb 2021 06:44:04 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:12455 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbhBGLlV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Feb 2021 06:41:21 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DYRxV2LNDzjJmN;
        Sun,  7 Feb 2021 19:38:38 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Sun, 7 Feb 2021 19:39:33 +0800
From:   Xiaofei Tan <tanxiaofei@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>, Xiaofei Tan <tanxiaofei@huawei.com>
Subject: [PATCH for-next 19/32] scsi: mvumi: Replace spin_lock_irqsave with spin_lock in hard IRQ
Date:   Sun, 7 Feb 2021 19:36:50 +0800
Message-ID: <1612697823-8073-20-git-send-email-tanxiaofei@huawei.com>
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
 drivers/scsi/mvumi.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 71b6a1f..b36164c 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -1790,11 +1790,10 @@ static void mvumi_handle_clob(struct mvumi_hba *mhba)
 static irqreturn_t mvumi_isr_handler(int irq, void *devp)
 {
 	struct mvumi_hba *mhba = (struct mvumi_hba *) devp;
-	unsigned long flags;
 
-	spin_lock_irqsave(mhba->shost->host_lock, flags);
+	spin_lock(mhba->shost->host_lock);
 	if (unlikely(mhba->instancet->clear_intr(mhba) || !mhba->global_isr)) {
-		spin_unlock_irqrestore(mhba->shost->host_lock, flags);
+		spin_unlock(mhba->shost->host_lock);
 		return IRQ_NONE;
 	}
 
@@ -1815,7 +1814,7 @@ static irqreturn_t mvumi_isr_handler(int irq, void *devp)
 	mhba->isr_status = 0;
 	if (mhba->fw_state == FW_STATE_STARTED)
 		mvumi_handle_clob(mhba);
-	spin_unlock_irqrestore(mhba->shost->host_lock, flags);
+	spin_unlock(mhba->shost->host_lock);
 	return IRQ_HANDLED;
 }
 
-- 
2.8.1

