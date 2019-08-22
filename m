Return-Path: <SRS0=BT6k=WS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC52EC3A5A1
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Aug 2019 14:14:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B92D622CE3
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Aug 2019 14:14:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732473AbfHVOO3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Aug 2019 10:14:29 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4767 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731614AbfHVOO3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Aug 2019 10:14:29 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 2B9E48B4BC0987C10FEC;
        Thu, 22 Aug 2019 22:14:26 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Thu, 22 Aug 2019
 22:14:16 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <john.garry@huawei.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>
CC:     <yi.zhang@huawei.com>, <zhengbin13@huawei.com>
Subject: [PATCH] scsi: hisi_sas: remove set but not used variable 'irq_value'
Date:   Thu, 22 Aug 2019 22:20:47 +0800
Message-ID: <1566483647-121127-1-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/scsi/hisi_sas/hisi_sas_v1_hw.c: In function cq_interrupt_v1_hw:
drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:1542:6: warning: variable irq_value set but not used [-Wunused-but-set-variable]

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 3912216..b198adc 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1534,11 +1534,9 @@ static irqreturn_t cq_interrupt_v1_hw(int irq, void *p)
 	struct hisi_sas_complete_v1_hdr *complete_queue =
 			(struct hisi_sas_complete_v1_hdr *)
 			hisi_hba->complete_hdr[queue];
-	u32 irq_value, rd_point = cq->rd_point, wr_point;
+	u32 rd_point = cq->rd_point, wr_point;

 	spin_lock(&hisi_hba->lock);
-	irq_value = hisi_sas_read32(hisi_hba, OQ_INT_SRC);
-
 	hisi_sas_write32(hisi_hba, OQ_INT_SRC, 1 << queue);
 	wr_point = hisi_sas_read32(hisi_hba,
 			COMPL_Q_0_WR_PTR + (0x14 * queue));
--
2.7.4

