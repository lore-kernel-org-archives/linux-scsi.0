Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 036C6C433DB
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 11:41:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE08764E3B
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 11:41:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbhBGLlZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 7 Feb 2021 06:41:25 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:12450 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbhBGLky (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Feb 2021 06:40:54 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DYRxV15gkzjJm5;
        Sun,  7 Feb 2021 19:38:38 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Sun, 7 Feb 2021 19:39:34 +0800
From:   Xiaofei Tan <tanxiaofei@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>, Xiaofei Tan <tanxiaofei@huawei.com>
Subject: [PATCH for-next 23/32] scsi: nsp32: Replace spin_lock_irqsave with spin_lock in hard IRQ
Date:   Sun, 7 Feb 2021 19:36:54 +0800
Message-ID: <1612697823-8073-24-git-send-email-tanxiaofei@huawei.com>
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
 drivers/scsi/nsp32.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index e44b1a0..d927fde 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -1152,12 +1152,11 @@ static irqreturn_t do_nsp32_isr(int irq, void *dev_id)
 	struct scsi_cmnd *SCpnt = data->CurrentSC;
 	unsigned short auto_stat, irq_stat, trans_stat;
 	unsigned char busmon, busphase;
-	unsigned long flags;
 	int ret;
 	int handled = 0;
 	struct Scsi_Host *host = data->Host;
 
-	spin_lock_irqsave(host->host_lock, flags);
+	spin_lock(host->host_lock);
 
 	/*
 	 * IRQ check, then enable IRQ mask
@@ -1421,7 +1420,7 @@ static irqreturn_t do_nsp32_isr(int irq, void *dev_id)
 	nsp32_write2(base, IRQ_CONTROL, 0);
 
  out2:
-	spin_unlock_irqrestore(host->host_lock, flags);
+	spin_unlock(host->host_lock);
 
 	nsp32_dbg(NSP32_DEBUG_INTR, "exit");
 
-- 
2.8.1

