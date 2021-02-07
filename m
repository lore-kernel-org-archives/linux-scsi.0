Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B459CC433DB
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 11:41:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90CCA64E4D
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 11:41:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbhBGLkq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 7 Feb 2021 06:40:46 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:12083 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbhBGLkW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Feb 2021 06:40:22 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DYRwg3gzSzMVwb;
        Sun,  7 Feb 2021 19:37:55 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Sun, 7 Feb 2021 19:39:30 +0800
From:   Xiaofei Tan <tanxiaofei@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>, Xiaofei Tan <tanxiaofei@huawei.com>
Subject: [PATCH for-next 13/32] scsi: hptiop: Replace spin_lock_irqsave with spin_lock in hard IRQ
Date:   Sun, 7 Feb 2021 19:36:44 +0800
Message-ID: <1612697823-8073-14-git-send-email-tanxiaofei@huawei.com>
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
 drivers/scsi/hptiop.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index db4c7a7..5424e31 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -834,11 +834,10 @@ static irqreturn_t hptiop_intr(int irq, void *dev_id)
 {
 	struct hptiop_hba  *hba = dev_id;
 	int  handled;
-	unsigned long flags;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock(hba->host->host_lock);
 	handled = hba->ops->iop_intr(hba);
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock(hba->host->host_lock);
 
 	return handled;
 }
-- 
2.8.1

