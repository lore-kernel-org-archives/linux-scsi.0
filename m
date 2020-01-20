Return-Path: <SRS0=2tGB=3J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A77CCC2D0DB
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 12:27:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8655421D7D
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 12:27:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728741AbgATM1T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jan 2020 07:27:19 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9216 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727107AbgATM04 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Jan 2020 07:26:56 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id B09B992273281E360AEA;
        Mon, 20 Jan 2020 20:26:53 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.439.0; Mon, 20 Jan 2020 20:26:45 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <linux-kernel@vger.kernel.org>, John Garry <john.garry@huawei.com>
Subject: [PATCH 6/7] scsi: hisi_sas: Rename hisi_sas_cq.pci_irq_mask
Date:   Mon, 20 Jan 2020 20:22:36 +0800
Message-ID: <1579522957-4393-7-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1579522957-4393-1-git-send-email-john.garry@huawei.com>
References: <1579522957-4393-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In future we will want to use hisi_sas_cq.pci_irq_mask for non-pci
interrupt masks, so rename to be more general.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       | 2 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 2 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 838549b19f86..2bdd64648ef0 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -180,7 +180,7 @@ struct hisi_sas_port {
 
 struct hisi_sas_cq {
 	struct hisi_hba *hisi_hba;
-	const struct cpumask *pci_irq_mask;
+	const struct cpumask *irq_mask;
 	int	rd_point;
 	int	id;
 	int	irq_no;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 61db3376b1f9..9a6deb21fe4d 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -2125,7 +2125,7 @@ hisi_sas_internal_task_abort(struct hisi_hba *hisi_hba,
 	case HISI_SAS_INT_ABT_DEV:
 		for (i = 0; i < hisi_hba->cq_nvecs; i++) {
 			struct hisi_sas_cq *cq = &hisi_hba->cq[i];
-			const struct cpumask *mask = cq->pci_irq_mask;
+			const struct cpumask *mask = cq->irq_mask;
 
 			if (mask && !cpumask_intersects(cpu_online_mask, mask))
 				continue;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 5f6c6f4ea504..a2debe0c8185 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2372,7 +2372,7 @@ static void setup_reply_map_v3_hw(struct hisi_hba *hisi_hba, int nvecs)
 					    BASE_VECTORS_V3_HW);
 		if (!mask)
 			goto fallback;
-		cq->pci_irq_mask = mask;
+		cq->irq_mask = mask;
 		for_each_cpu(cpu, mask)
 			hisi_hba->reply_map[cpu] = queue;
 	}
-- 
2.17.1

