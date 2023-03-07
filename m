Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EA4CC678DB
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Mar 2023 05:39:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbjCGFjN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Mar 2023 00:39:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbjCGFjL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Mar 2023 00:39:11 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 223DF3B864
        for <linux-scsi@vger.kernel.org>; Mon,  6 Mar 2023 21:39:10 -0800 (PST)
Received: from kwepemi500016.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4PW42R3tlnzKqJh;
        Tue,  7 Mar 2023 13:37:03 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 kwepemi500016.china.huawei.com (7.221.188.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 7 Mar 2023 13:38:34 +0800
From:   chenxiang <chenxiang66@hisilicon.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linuxarm@huawei.com>, <linux-scsi@vger.kernel.org>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 1/4] scsi: hisi_sas: Add function complete_v3_hw()
Date:   Tue, 7 Mar 2023 14:09:12 +0800
Message-ID: <1678169355-76215-2-git-send-email-chenxiang66@hisilicon.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1678169355-76215-1-git-send-email-chenxiang66@hisilicon.com>
References: <1678169355-76215-1-git-send-email-chenxiang66@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemi500016.china.huawei.com (7.221.188.220)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

Put the work of processing cq slots in separate function complete_v3_hw(),
then it can be used by cq_thread_v3_hw() and other function when adding
poll support.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 0c3fcb8..835cb87 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2391,15 +2391,14 @@ static void slot_complete_v3_hw(struct hisi_hba *hisi_hba,
 		task->task_done(task);
 }
 
-static irqreturn_t  cq_thread_v3_hw(int irq_no, void *p)
+static void complete_v3_hw(struct hisi_sas_cq *cq)
 {
-	struct hisi_sas_cq *cq = p;
-	struct hisi_hba *hisi_hba = cq->hisi_hba;
-	struct hisi_sas_slot *slot;
 	struct hisi_sas_complete_v3_hdr *complete_queue;
-	u32 rd_point = cq->rd_point, wr_point;
+	struct hisi_hba *hisi_hba = cq->hisi_hba;
+	u32 rd_point, wr_point;
 	int queue = cq->id;
 
+	rd_point = cq->rd_point;
 	complete_queue = hisi_hba->complete_hdr[queue];
 
 	wr_point = hisi_sas_read32(hisi_hba, COMPL_Q_0_WR_PTR +
@@ -2408,6 +2407,7 @@ static irqreturn_t  cq_thread_v3_hw(int irq_no, void *p)
 	while (rd_point != wr_point) {
 		struct hisi_sas_complete_v3_hdr *complete_hdr;
 		struct device *dev = hisi_hba->dev;
+		struct hisi_sas_slot *slot;
 		u32 dw0, dw1, dw3;
 		int iptt;
 
@@ -2450,6 +2450,13 @@ static irqreturn_t  cq_thread_v3_hw(int irq_no, void *p)
 	/* update rd_point */
 	cq->rd_point = rd_point;
 	hisi_sas_write32(hisi_hba, COMPL_Q_0_RD_PTR + (0x14 * queue), rd_point);
+}
+
+static irqreturn_t cq_thread_v3_hw(int irq_no, void *p)
+{
+	struct hisi_sas_cq *cq = p;
+
+	complete_v3_hw(cq);
 
 	return IRQ_HANDLED;
 }
-- 
2.8.1

