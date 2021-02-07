Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A261C4332E
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 11:40:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3459564E59
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 11:40:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbhBGLkh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 7 Feb 2021 06:40:37 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:12478 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbhBGLkV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Feb 2021 06:40:21 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DYRx04gR9zjKpH;
        Sun,  7 Feb 2021 19:38:12 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Sun, 7 Feb 2021 19:39:26 +0800
From:   Xiaofei Tan <tanxiaofei@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>, Xiaofei Tan <tanxiaofei@huawei.com>
Subject: [PATCH for-next 04/32] scsi: qla4xxx: Replace spin_lock_irqsave with spin_lock in hard IRQ
Date:   Sun, 7 Feb 2021 19:36:35 +0800
Message-ID: <1612697823-8073-5-git-send-email-tanxiaofei@huawei.com>
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
 drivers/scsi/qla4xxx/ql4_isr.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
index 6f0e77d..9c64c8b 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -1353,10 +1353,9 @@ qla4_8xxx_msi_handler(int irq, void *dev_id)
 static irqreturn_t qla4_83xx_mailbox_intr_handler(int irq, void *dev_id)
 {
 	struct scsi_qla_host *ha = dev_id;
-	unsigned long flags;
 	uint32_t ival = 0;
 
-	spin_lock_irqsave(&ha->hardware_lock, flags);
+	spin_lock(&ha->hardware_lock);
 
 	ival = readl(&ha->qla4_83xx_reg->risc_intr);
 	if (ival == 0) {
@@ -1377,7 +1376,7 @@ static irqreturn_t qla4_83xx_mailbox_intr_handler(int irq, void *dev_id)
 	writel(ival, &ha->qla4_83xx_reg->mb_int_mask);
 	ha->isr_count++;
 exit:
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	spin_unlock(&ha->hardware_lock);
 	return IRQ_HANDLED;
 }
 
@@ -1393,14 +1392,13 @@ irqreturn_t
 qla4_8xxx_default_intr_handler(int irq, void *dev_id)
 {
 	struct scsi_qla_host *ha = dev_id;
-	unsigned long   flags;
 	uint32_t intr_status;
 	uint8_t reqs_count = 0;
 
 	if (is_qla8032(ha) || is_qla8042(ha)) {
 		qla4_83xx_mailbox_intr_handler(irq, dev_id);
 	} else {
-		spin_lock_irqsave(&ha->hardware_lock, flags);
+		spin_lock(&ha->hardware_lock);
 		while (1) {
 			if (!(readl(&ha->qla4_82xx_reg->host_int) &
 			    ISRX_82XX_RISC_INT)) {
@@ -1421,7 +1419,7 @@ qla4_8xxx_default_intr_handler(int irq, void *dev_id)
 				break;
 		}
 		ha->isr_count++;
-		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+		spin_unlock(&ha->hardware_lock);
 	}
 	return IRQ_HANDLED;
 }
@@ -1430,11 +1428,10 @@ irqreturn_t
 qla4_8xxx_msix_rsp_q(int irq, void *dev_id)
 {
 	struct scsi_qla_host *ha = dev_id;
-	unsigned long flags;
 	int intr_status;
 	uint32_t ival = 0;
 
-	spin_lock_irqsave(&ha->hardware_lock, flags);
+	spin_lock(&ha->hardware_lock);
 	if (is_qla8032(ha) || is_qla8042(ha)) {
 		ival = readl(&ha->qla4_83xx_reg->iocb_int_mask);
 		if (ival == 0) {
@@ -1457,7 +1454,7 @@ qla4_8xxx_msix_rsp_q(int irq, void *dev_id)
 	}
 	ha->isr_count++;
 exit_msix_rsp_q:
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	spin_unlock(&ha->hardware_lock);
 	return IRQ_HANDLED;
 }
 
-- 
2.8.1

