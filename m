Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D298BC1B087
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 13:35:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96652235E4
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 13:35:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbgLGNf0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 08:35:26 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9028 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725803AbgLGNfY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2020 08:35:24 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CqPRR6nj6zhnrV;
        Mon,  7 Dec 2020 21:34:11 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.487.0; Mon, 7 Dec 2020 21:34:34 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, <hare@suse.de>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH] scsi: hisi_sas: Select a suitable queue for internal IOs
Date:   Mon, 7 Dec 2020 21:30:55 +0800
Message-ID: <1607347855-59091-1-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

For when managed interrupts are used (and shost->nr_hw_queues is set), a
fixed queue - set per-device - is still used for internal IOs.

If all the CPUs mapped to that queue are offlined, then the completions
for that queue are not serviced and any internal IOs will timeout.

Fix by selecting a queue for internal IOs from the queue mapped from
the current CPU in this scenario.

This is still not ideal, as it does not deal with CPU hotplug for inflight
internal IOs, and needs proper support from [0].

[0] https://lore.kernel.org/linux-scsi/20200703130122.111448-1-hare@suse.de/T/#m7d77d049b18f33a24ef206af69ebb66d07440556

Fixes: 8d98416a55eb ("scsi: hisi_sas: Switch v3 hw to MQ")
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
Hi Martin, James, This is based on mkp 5.10/scsi-fixes, and please try to
include for v5.10, sorry for the lateness, thanks!

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index c8dd8588f800..274ccf18ce2d 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -452,6 +452,12 @@ static int hisi_sas_task_prep(struct sas_task *task,
 		blk_tag = blk_mq_unique_tag(scmd->request);
 		dq_index = blk_mq_unique_tag_to_hwq(blk_tag);
 		*dq_pointer = dq = &hisi_hba->dq[dq_index];
+	} else if (hisi_hba->shost->nr_hw_queues)  {
+		struct Scsi_Host *shost = hisi_hba->shost;
+		struct blk_mq_queue_map *qmap = &shost->tag_set.map[HCTX_TYPE_DEFAULT];
+		int queue = qmap->mq_map[raw_smp_processor_id()];
+
+		*dq_pointer = dq = &hisi_hba->dq[queue];
 	} else {
 		*dq_pointer = dq = sas_dev->dq;
 	}
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 7133ca859b5e..960de375ce69 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2452,6 +2452,11 @@ static int interrupt_init_v3_hw(struct hisi_hba *hisi_hba)
 			rc = -ENOENT;
 			goto free_irq_vectors;
 		}
+		cq->irq_mask = pci_irq_get_affinity(pdev, i + BASE_VECTORS_V3_HW);
+		if (!cq->irq_mask) {
+			dev_err(dev, "could not get cq%d irq affinity!\n", i);
+			return -ENOENT;
+		}
 	}
 
 	return 0;
-- 
2.26.2

