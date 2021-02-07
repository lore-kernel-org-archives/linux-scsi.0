Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78F0BC43381
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 11:40:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5625664E3C
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 11:40:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbhBGLki (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 7 Feb 2021 06:40:38 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:12082 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbhBGLkV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Feb 2021 06:40:21 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DYRwg48JvzMWRN;
        Sun,  7 Feb 2021 19:37:55 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Sun, 7 Feb 2021 19:39:29 +0800
From:   Xiaofei Tan <tanxiaofei@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>, Xiaofei Tan <tanxiaofei@huawei.com>
Subject: [PATCH for-next 10/32] scsi: bfa: Replace spin_lock_irqsave with spin_lock in hard IRQ
Date:   Sun, 7 Feb 2021 19:36:41 +0800
Message-ID: <1612697823-8073-11-git-send-email-tanxiaofei@huawei.com>
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
 drivers/scsi/bfa/bfad.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index 440ef32..8c6f3eb 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -1089,25 +1089,24 @@ bfad_intx(int irq, void *dev_id)
 {
 	struct bfad_s	*bfad = dev_id;
 	struct list_head	doneq;
-	unsigned long	flags;
 	bfa_boolean_t rc;
 
-	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	spin_lock(&bfad->bfad_lock);
 	rc = bfa_intx(&bfad->bfa);
 	if (!rc) {
-		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+		spin_unlock(&bfad->bfad_lock);
 		return IRQ_NONE;
 	}
 
 	bfa_comp_deq(&bfad->bfa, &doneq);
-	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+	spin_unlock(&bfad->bfad_lock);
 
 	if (!list_empty(&doneq)) {
 		bfa_comp_process(&bfad->bfa, &doneq);
 
-		spin_lock_irqsave(&bfad->bfad_lock, flags);
+		spin_lock(&bfad->bfad_lock);
 		bfa_comp_free(&bfad->bfa, &doneq);
-		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+		spin_unlock(&bfad->bfad_lock);
 	}
 
 	return IRQ_HANDLED;
@@ -1120,20 +1119,19 @@ bfad_msix(int irq, void *dev_id)
 	struct bfad_msix_s *vec = dev_id;
 	struct bfad_s *bfad = vec->bfad;
 	struct list_head doneq;
-	unsigned long   flags;
 
-	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	spin_lock(&bfad->bfad_lock);
 
 	bfa_msix(&bfad->bfa, vec->msix.entry);
 	bfa_comp_deq(&bfad->bfa, &doneq);
-	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+	spin_unlock(&bfad->bfad_lock);
 
 	if (!list_empty(&doneq)) {
 		bfa_comp_process(&bfad->bfa, &doneq);
 
-		spin_lock_irqsave(&bfad->bfad_lock, flags);
+		spin_lock(&bfad->bfad_lock);
 		bfa_comp_free(&bfad->bfa, &doneq);
-		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+		spin_unlock(&bfad->bfad_lock);
 	}
 
 	return IRQ_HANDLED;
-- 
2.8.1

