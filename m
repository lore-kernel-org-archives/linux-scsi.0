Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98C53C433E0
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 11:41:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6ABEC64E43
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 11:41:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbhBGLko (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 7 Feb 2021 06:40:44 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:12086 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbhBGLkW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Feb 2021 06:40:22 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DYRwg4cFQzMWS5;
        Sun,  7 Feb 2021 19:37:55 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Sun, 7 Feb 2021 19:39:31 +0800
From:   Xiaofei Tan <tanxiaofei@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>, Xiaofei Tan <tanxiaofei@huawei.com>
Subject: [PATCH for-next 16/32] scsi: megaraid: Replace spin_lock_irqsave with spin_lock in hard IRQ
Date:   Sun, 7 Feb 2021 19:36:47 +0800
Message-ID: <1612697823-8073-17-git-send-email-tanxiaofei@huawei.com>
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
 drivers/scsi/megaraid.c                   | 10 ++++------
 drivers/scsi/megaraid/megaraid_sas_base.c |  5 ++---
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 80f5469..7151752 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -1262,7 +1262,6 @@ static irqreturn_t
 megaraid_isr_iomapped(int irq, void *devp)
 {
 	adapter_t	*adapter = devp;
-	unsigned long	flags;
 	u8	status;
 	u8	nstatus;
 	u8	completed[MAX_FIRMWARE_STATUS];
@@ -1273,7 +1272,7 @@ megaraid_isr_iomapped(int irq, void *devp)
 	/*
 	 * loop till F/W has more commands for us to complete.
 	 */
-	spin_lock_irqsave(&adapter->lock, flags);
+	spin_lock(&adapter->lock);
 
 	do {
 		/* Check if a valid interrupt is pending */
@@ -1319,7 +1318,7 @@ megaraid_isr_iomapped(int irq, void *devp)
 
  out_unlock:
 
-	spin_unlock_irqrestore(&adapter->lock, flags);
+	spin_unlock(&adapter->lock);
 
 	return IRQ_RETVAL(handled);
 }
@@ -1338,7 +1337,6 @@ static irqreturn_t
 megaraid_isr_memmapped(int irq, void *devp)
 {
 	adapter_t	*adapter = devp;
-	unsigned long	flags;
 	u8	status;
 	u32	dword = 0;
 	u8	nstatus;
@@ -1349,7 +1347,7 @@ megaraid_isr_memmapped(int irq, void *devp)
 	/*
 	 * loop till F/W has more commands for us to complete.
 	 */
-	spin_lock_irqsave(&adapter->lock, flags);
+	spin_lock(&adapter->lock);
 
 	do {
 		/* Check if a valid interrupt is pending */
@@ -1399,7 +1397,7 @@ megaraid_isr_memmapped(int irq, void *devp)
 
  out_unlock:
 
-	spin_unlock_irqrestore(&adapter->lock, flags);
+	spin_unlock(&adapter->lock);
 
 	return IRQ_RETVAL(handled);
 }
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 63a4f48..5c6bf61 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3996,15 +3996,14 @@ static irqreturn_t megasas_isr(int irq, void *devp)
 {
 	struct megasas_irq_context *irq_context = devp;
 	struct megasas_instance *instance = irq_context->instance;
-	unsigned long flags;
 	irqreturn_t rc;
 
 	if (atomic_read(&instance->fw_reset_no_pci_access))
 		return IRQ_HANDLED;
 
-	spin_lock_irqsave(&instance->hba_lock, flags);
+	spin_lock(&instance->hba_lock);
 	rc = megasas_deplete_reply_queue(instance, DID_OK);
-	spin_unlock_irqrestore(&instance->hba_lock, flags);
+	spin_unlock(&instance->hba_lock);
 
 	return rc;
 }
-- 
2.8.1

