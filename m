Return-Path: <SRS0=2tGB=3J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E532FC2D0DB
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 12:27:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6AB2217F4
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 12:27:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729064AbgATM07 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jan 2020 07:26:59 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9218 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728913AbgATM06 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Jan 2020 07:26:58 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id C2DEA15C7F90CA827964;
        Mon, 20 Jan 2020 20:26:53 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.439.0; Mon, 20 Jan 2020 20:26:44 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <linux-kernel@vger.kernel.org>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        "John Garry" <john.garry@huawei.com>
Subject: [PATCH 2/7] scsi: hisi_sas: replace spin_lock_irqsave/spin_unlock_restore with spin_lock/spin_unlock
Date:   Mon, 20 Jan 2020 20:22:32 +0800
Message-ID: <1579522957-4393-3-git-send-email-john.garry@huawei.com>
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

From: Xiang Chen <chenxiang66@hisilicon.com>

After changed tasklet to workqueue or threaded irq, some critical
resources are only used on threads (not in interrupt or bottom half of
interrupt), so replace spin_lock_irqsave/spin_unlock_restore with
spin_lock/spin_unlock to protect those critical resources.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 48 +++++++++++---------------
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 12 +++----
 2 files changed, 26 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index c653cce2644a..3e103e86e964 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -163,13 +163,11 @@ static void hisi_sas_slot_index_clear(struct hisi_hba *hisi_hba, int slot_idx)
 
 static void hisi_sas_slot_index_free(struct hisi_hba *hisi_hba, int slot_idx)
 {
-	unsigned long flags;
-
 	if (hisi_hba->hw->slot_index_alloc ||
 	    slot_idx >= HISI_SAS_UNRESERVED_IPTT) {
-		spin_lock_irqsave(&hisi_hba->lock, flags);
+		spin_lock(&hisi_hba->lock);
 		hisi_sas_slot_index_clear(hisi_hba, slot_idx);
-		spin_unlock_irqrestore(&hisi_hba->lock, flags);
+		spin_unlock(&hisi_hba->lock);
 	}
 }
 
@@ -185,12 +183,11 @@ static int hisi_sas_slot_index_alloc(struct hisi_hba *hisi_hba,
 {
 	int index;
 	void *bitmap = hisi_hba->slot_index_tags;
-	unsigned long flags;
 
 	if (scsi_cmnd)
 		return scsi_cmnd->request->tag;
 
-	spin_lock_irqsave(&hisi_hba->lock, flags);
+	spin_lock(&hisi_hba->lock);
 	index = find_next_zero_bit(bitmap, hisi_hba->slot_index_count,
 				   hisi_hba->last_slot_index + 1);
 	if (index >= hisi_hba->slot_index_count) {
@@ -198,13 +195,13 @@ static int hisi_sas_slot_index_alloc(struct hisi_hba *hisi_hba,
 				hisi_hba->slot_index_count,
 				HISI_SAS_UNRESERVED_IPTT);
 		if (index >= hisi_hba->slot_index_count) {
-			spin_unlock_irqrestore(&hisi_hba->lock, flags);
+			spin_unlock(&hisi_hba->lock);
 			return -SAS_QUEUE_FULL;
 		}
 	}
 	hisi_sas_slot_index_set(hisi_hba, index);
 	hisi_hba->last_slot_index = index;
-	spin_unlock_irqrestore(&hisi_hba->lock, flags);
+	spin_unlock(&hisi_hba->lock);
 
 	return index;
 }
@@ -220,7 +217,6 @@ static void hisi_sas_slot_index_init(struct hisi_hba *hisi_hba)
 void hisi_sas_slot_task_free(struct hisi_hba *hisi_hba, struct sas_task *task,
 			     struct hisi_sas_slot *slot)
 {
-	unsigned long flags;
 	int device_id = slot->device_id;
 	struct hisi_sas_device *sas_dev = &hisi_hba->devices[device_id];
 
@@ -247,9 +243,9 @@ void hisi_sas_slot_task_free(struct hisi_hba *hisi_hba, struct sas_task *task,
 		}
 	}
 
-	spin_lock_irqsave(&sas_dev->lock, flags);
+	spin_lock(&sas_dev->lock);
 	list_del_init(&slot->entry);
-	spin_unlock_irqrestore(&sas_dev->lock, flags);
+	spin_unlock(&sas_dev->lock);
 
 	memset(slot, 0, offsetof(struct hisi_sas_slot, buf));
 
@@ -489,14 +485,14 @@ static int hisi_sas_task_prep(struct sas_task *task,
 	slot_idx = rc;
 	slot = &hisi_hba->slot_info[slot_idx];
 
-	spin_lock_irqsave(&dq->lock, flags);
+	spin_lock(&dq->lock);
 	wr_q_index = dq->wr_point;
 	dq->wr_point = (dq->wr_point + 1) % HISI_SAS_QUEUE_SLOTS;
 	list_add_tail(&slot->delivery, &dq->list);
-	spin_unlock_irqrestore(&dq->lock, flags);
-	spin_lock_irqsave(&sas_dev->lock, flags);
+	spin_unlock(&dq->lock);
+	spin_lock(&sas_dev->lock);
 	list_add_tail(&slot->entry, &sas_dev->list);
-	spin_unlock_irqrestore(&sas_dev->lock, flags);
+	spin_unlock(&sas_dev->lock);
 
 	dlvry_queue = dq->id;
 	dlvry_queue_slot = wr_q_index;
@@ -562,7 +558,6 @@ static int hisi_sas_task_exec(struct sas_task *task, gfp_t gfp_flags,
 {
 	u32 rc;
 	u32 pass = 0;
-	unsigned long flags;
 	struct hisi_hba *hisi_hba;
 	struct device *dev;
 	struct domain_device *device = task->dev;
@@ -606,9 +601,9 @@ static int hisi_sas_task_exec(struct sas_task *task, gfp_t gfp_flags,
 		dev_err(dev, "task exec: failed[%d]!\n", rc);
 
 	if (likely(pass)) {
-		spin_lock_irqsave(&dq->lock, flags);
+		spin_lock(&dq->lock);
 		hisi_hba->hw->start_delivery(dq);
-		spin_unlock_irqrestore(&dq->lock, flags);
+		spin_unlock(&dq->lock);
 	}
 
 	return rc;
@@ -659,12 +654,11 @@ static struct hisi_sas_device *hisi_sas_alloc_dev(struct domain_device *device)
 {
 	struct hisi_hba *hisi_hba = dev_to_hisi_hba(device);
 	struct hisi_sas_device *sas_dev = NULL;
-	unsigned long flags;
 	int last = hisi_hba->last_dev_id;
 	int first = (hisi_hba->last_dev_id + 1) % HISI_SAS_MAX_DEVICES;
 	int i;
 
-	spin_lock_irqsave(&hisi_hba->lock, flags);
+	spin_lock(&hisi_hba->lock);
 	for (i = first; i != last; i %= HISI_SAS_MAX_DEVICES) {
 		if (hisi_hba->devices[i].dev_type == SAS_PHY_UNUSED) {
 			int queue = i % hisi_hba->queue_count;
@@ -684,7 +678,7 @@ static struct hisi_sas_device *hisi_sas_alloc_dev(struct domain_device *device)
 		i++;
 	}
 	hisi_hba->last_dev_id = i;
-	spin_unlock_irqrestore(&hisi_hba->lock, flags);
+	spin_unlock(&hisi_hba->lock);
 
 	return sas_dev;
 }
@@ -1965,14 +1959,14 @@ hisi_sas_internal_abort_task_exec(struct hisi_hba *hisi_hba, int device_id,
 	slot_idx = rc;
 	slot = &hisi_hba->slot_info[slot_idx];
 
-	spin_lock_irqsave(&dq->lock, flags);
+	spin_lock(&dq->lock);
 	wr_q_index = dq->wr_point;
 	dq->wr_point = (dq->wr_point + 1) % HISI_SAS_QUEUE_SLOTS;
 	list_add_tail(&slot->delivery, &dq->list);
-	spin_unlock_irqrestore(&dq->lock, flags);
-	spin_lock_irqsave(&sas_dev->lock, flags);
+	spin_unlock(&dq->lock);
+	spin_lock(&sas_dev->lock);
 	list_add_tail(&slot->entry, &sas_dev->list);
-	spin_unlock_irqrestore(&sas_dev->lock, flags);
+	spin_unlock(&sas_dev->lock);
 
 	dlvry_queue = dq->id;
 	dlvry_queue_slot = wr_q_index;
@@ -2001,9 +1995,9 @@ hisi_sas_internal_abort_task_exec(struct hisi_hba *hisi_hba, int device_id,
 	spin_unlock_irqrestore(&task->task_state_lock, flags);
 	WRITE_ONCE(slot->ready, 1);
 	/* send abort command to the chip */
-	spin_lock_irqsave(&dq->lock, flags);
+	spin_lock(&dq->lock);
 	hisi_hba->hw->start_delivery(dq);
-	spin_unlock_irqrestore(&dq->lock, flags);
+	spin_unlock(&dq->lock);
 
 	return 0;
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index a0e05a118f2c..e05faf315dcd 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -773,7 +773,6 @@ slot_index_alloc_quirk_v2_hw(struct hisi_hba *hisi_hba,
 	struct hisi_sas_device *sas_dev = device->lldd_dev;
 	int sata_idx = sas_dev->sata_idx;
 	int start, end;
-	unsigned long flags;
 
 	if (!sata_dev) {
 		/*
@@ -797,12 +796,12 @@ slot_index_alloc_quirk_v2_hw(struct hisi_hba *hisi_hba,
 		end = 64 * (sata_idx + 2);
 	}
 
-	spin_lock_irqsave(&hisi_hba->lock, flags);
+	spin_lock(&hisi_hba->lock);
 	while (1) {
 		start = find_next_zero_bit(bitmap,
 					hisi_hba->slot_index_count, start);
 		if (start >= end) {
-			spin_unlock_irqrestore(&hisi_hba->lock, flags);
+			spin_unlock(&hisi_hba->lock);
 			return -SAS_QUEUE_FULL;
 		}
 		/*
@@ -814,7 +813,7 @@ slot_index_alloc_quirk_v2_hw(struct hisi_hba *hisi_hba,
 	}
 
 	set_bit(start, bitmap);
-	spin_unlock_irqrestore(&hisi_hba->lock, flags);
+	spin_unlock(&hisi_hba->lock);
 	return start;
 }
 
@@ -843,9 +842,8 @@ hisi_sas_device *alloc_dev_quirk_v2_hw(struct domain_device *device)
 	struct hisi_sas_device *sas_dev = NULL;
 	int i, sata_dev = dev_is_sata(device);
 	int sata_idx = -1;
-	unsigned long flags;
 
-	spin_lock_irqsave(&hisi_hba->lock, flags);
+	spin_lock(&hisi_hba->lock);
 
 	if (sata_dev)
 		if (!sata_index_alloc_v2_hw(hisi_hba, &sata_idx))
@@ -876,7 +874,7 @@ hisi_sas_device *alloc_dev_quirk_v2_hw(struct domain_device *device)
 	}
 
 out:
-	spin_unlock_irqrestore(&hisi_hba->lock, flags);
+	spin_unlock(&hisi_hba->lock);
 
 	return sas_dev;
 }
-- 
2.17.1

