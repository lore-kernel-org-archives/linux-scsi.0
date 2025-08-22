Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96DD92E7BDF;
	Fri, 22 Aug 2025 07:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755849598; cv=none; b=n0BpErQjN7Kz9+ea5+qgz6CeeQWqZPJWy5JLLljmxyYYjqBDYOXNfZarFyDMm9LAL5uUvlXvHhjvFxIIDsxjxs5SoQhjw9wzclfAlpQLa4gdvubp9DO+qKz1FoUfObHqAyRubS9okUXdQniIBYZq1ltUJWExkMlY8WHDyZU6+qA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755849598; c=relaxed/simple;
	bh=xFCNNOvk+CIvgtSwTkc8/AB+SBLiFCFcgMeEscR6wQM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EZO9bTKnqY0qy1mIrFrFxrGXNvP7zluFxmP3LoJKmSvclQcr9/3uJe8ECK+EeEQPUcAJmSYZ+1caVQN6NqAn8qzdglk0qhsJHwVFy7HIBvl45PESN0dIlCT/E6lRMUdSQDq2oU9U7PH/daebB7WH+SHar9u2oeDJklbhy+4ZYzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=h-partners.com; spf=pass smtp.mailfrom=h-partners.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=h-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4c7XZz2JyBz1R8s9;
	Fri, 22 Aug 2025 15:56:59 +0800 (CST)
Received: from kwepemh200005.china.huawei.com (unknown [7.202.181.112])
	by mail.maildlp.com (Postfix) with ESMTPS id 3A56A1A016C;
	Fri, 22 Aug 2025 15:59:53 +0800 (CST)
Received: from localhost.localdomain (10.50.165.33) by
 kwepemh200005.china.huawei.com (7.202.181.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 22 Aug 2025 15:59:52 +0800
From: Yihang Li <liyihang9@h-partners.com>
To: <martin.petersen@oracle.com>, <James.Bottomley@HansenPartnership.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liyihang9@huawei.com>, <liuyonglong@huawei.com>,
	<prime.zeng@hisilicon.com>
Subject: [PATCH 2/4] scsi: hisi_sas: replace spin_lock/spin_unlock with spin_lock_irqsave/spin_unlock_restore
Date: Fri, 22 Aug 2025 15:59:49 +0800
Message-ID: <20250822075951.2051639-3-liyihang9@h-partners.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20250822075951.2051639-1-liyihang9@h-partners.com>
References: <20250822075951.2051639-1-liyihang9@h-partners.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemh200005.china.huawei.com (7.202.181.112)

After changing threaded irq to tasklet, some critical resources are used
on interrupt or bottom half of interrupt, so replace spin_lock/spin_unlock
with spin_lock_irqsave/spin_unlock_restore to protect those critical
resources.

Signed-off-by: Yihang Li <liyihang9@h-partners.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 47 +++++++++++++++-----------
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 12 ++++---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 15 ++++----
 3 files changed, 44 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 693198b7027e..cd24b7d4ef0f 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -193,11 +193,13 @@ static void hisi_sas_slot_index_clear(struct hisi_hba *hisi_hba, int slot_idx)
 
 static void hisi_sas_slot_index_free(struct hisi_hba *hisi_hba, int slot_idx)
 {
+	unsigned long flags;
+
 	if (hisi_hba->hw->slot_index_alloc ||
 	    slot_idx < HISI_SAS_RESERVED_IPTT) {
-		spin_lock(&hisi_hba->lock);
+		spin_lock_irqsave(&hisi_hba->lock, flags);
 		hisi_sas_slot_index_clear(hisi_hba, slot_idx);
-		spin_unlock(&hisi_hba->lock);
+		spin_unlock_irqrestore(&hisi_hba->lock, flags);
 	}
 }
 
@@ -213,11 +215,12 @@ static int hisi_sas_slot_index_alloc(struct hisi_hba *hisi_hba,
 {
 	int index;
 	void *bitmap = hisi_hba->slot_index_tags;
+	unsigned long flags;
 
 	if (rq)
 		return rq->tag + HISI_SAS_RESERVED_IPTT;
 
-	spin_lock(&hisi_hba->lock);
+	spin_lock_irqsave(&hisi_hba->lock, flags);
 	index = find_next_zero_bit(bitmap, HISI_SAS_RESERVED_IPTT,
 				   hisi_hba->last_slot_index + 1);
 	if (index >= HISI_SAS_RESERVED_IPTT) {
@@ -225,13 +228,13 @@ static int hisi_sas_slot_index_alloc(struct hisi_hba *hisi_hba,
 				HISI_SAS_RESERVED_IPTT,
 				0);
 		if (index >= HISI_SAS_RESERVED_IPTT) {
-			spin_unlock(&hisi_hba->lock);
+			spin_unlock_irqrestore(&hisi_hba->lock, flags);
 			return -SAS_QUEUE_FULL;
 		}
 	}
 	hisi_sas_slot_index_set(hisi_hba, index);
 	hisi_hba->last_slot_index = index;
-	spin_unlock(&hisi_hba->lock);
+	spin_unlock_irqrestore(&hisi_hba->lock, flags);
 
 	return index;
 }
@@ -239,6 +242,7 @@ static int hisi_sas_slot_index_alloc(struct hisi_hba *hisi_hba,
 void hisi_sas_slot_task_free(struct hisi_hba *hisi_hba, struct sas_task *task,
 			     struct hisi_sas_slot *slot, bool need_lock)
 {
+	unsigned long flags;
 	int device_id = slot->device_id;
 	struct hisi_sas_device *sas_dev = &hisi_hba->devices[device_id];
 
@@ -272,9 +276,9 @@ void hisi_sas_slot_task_free(struct hisi_hba *hisi_hba, struct sas_task *task,
 	}
 
 	if (need_lock) {
-		spin_lock(&sas_dev->lock);
+		spin_lock_irqsave(&sas_dev->lock, flags);
 		list_del_init(&slot->entry);
-		spin_unlock(&sas_dev->lock);
+		spin_unlock_irqrestore(&sas_dev->lock, flags);
 	} else {
 		list_del_init(&slot->entry);
 	}
@@ -436,15 +440,16 @@ void hisi_sas_task_deliver(struct hisi_hba *hisi_hba,
 	int dlvry_queue_slot, dlvry_queue;
 	struct sas_task *task = slot->task;
 	int wr_q_index;
+	unsigned long flags;
 
-	spin_lock(&dq->lock);
+	spin_lock_irqsave(&dq->lock, flags);
 	wr_q_index = dq->wr_point;
 	dq->wr_point = (dq->wr_point + 1) % HISI_SAS_QUEUE_SLOTS;
 	list_add_tail(&slot->delivery, &dq->list);
-	spin_unlock(&dq->lock);
-	spin_lock(&sas_dev->lock);
+	spin_unlock_irqrestore(&dq->lock, flags);
+	spin_lock_irqsave(&sas_dev->lock, flags);
 	list_add_tail(&slot->entry, &sas_dev->list);
-	spin_unlock(&sas_dev->lock);
+	spin_unlock_irqrestore(&sas_dev->lock, flags);
 
 	dlvry_queue = dq->id;
 	dlvry_queue_slot = wr_q_index;
@@ -485,9 +490,9 @@ void hisi_sas_task_deliver(struct hisi_hba *hisi_hba,
 	smp_wmb();
 	WRITE_ONCE(slot->ready, 1);
 
-	spin_lock(&dq->lock);
+	spin_lock_irqsave(&dq->lock, flags);
 	hisi_hba->hw->start_delivery(dq);
-	spin_unlock(&dq->lock);
+	spin_unlock_irqrestore(&dq->lock, flags);
 }
 
 static int hisi_sas_queue_command(struct sas_task *task, gfp_t gfp_flags)
@@ -690,11 +695,12 @@ static struct hisi_sas_device *hisi_sas_alloc_dev(struct domain_device *device)
 {
 	struct hisi_hba *hisi_hba = dev_to_hisi_hba(device);
 	struct hisi_sas_device *sas_dev = NULL;
+	unsigned long flags;
 	int last = hisi_hba->last_dev_id;
 	int first = (hisi_hba->last_dev_id + 1) % HISI_SAS_MAX_DEVICES;
 	int i;
 
-	spin_lock(&hisi_hba->lock);
+	spin_lock_irqsave(&hisi_hba->lock, flags);
 	for (i = first; i != last; i %= HISI_SAS_MAX_DEVICES) {
 		if (hisi_hba->devices[i].dev_type == SAS_PHY_UNUSED) {
 			int queue = i % hisi_hba->queue_count;
@@ -714,16 +720,18 @@ static struct hisi_sas_device *hisi_sas_alloc_dev(struct domain_device *device)
 		i++;
 	}
 	hisi_hba->last_dev_id = i;
-	spin_unlock(&hisi_hba->lock);
+	spin_unlock_irqrestore(&hisi_hba->lock, flags);
 
 	return sas_dev;
 }
 
 static void hisi_sas_sync_poll_cq(struct hisi_sas_cq *cq)
 {
+	unsigned long flags;
+
 	/* make sure CQ entries being processed are processed to completion */
-	spin_lock(&cq->poll_lock);
-	spin_unlock(&cq->poll_lock);
+	spin_lock_irqsave(&cq->poll_lock, flags);
+	spin_unlock_irqrestore(&cq->poll_lock, flags);
 }
 
 static bool hisi_sas_queue_is_poll(struct hisi_sas_cq *cq)
@@ -1155,12 +1163,13 @@ static void hisi_sas_release_task(struct hisi_hba *hisi_hba,
 {
 	struct hisi_sas_slot *slot, *slot2;
 	struct hisi_sas_device *sas_dev = device->lldd_dev;
+	unsigned long flags;
 
-	spin_lock(&sas_dev->lock);
+	spin_lock_irqsave(&sas_dev->lock, flags);
 	list_for_each_entry_safe(slot, slot2, &sas_dev->list, entry)
 		hisi_sas_do_release_task(hisi_hba, slot->task, slot, false);
 
-	spin_unlock(&sas_dev->lock);
+	spin_unlock_irqrestore(&sas_dev->lock, flags);
 }
 
 void hisi_sas_release_tasks(struct hisi_hba *hisi_hba)
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 4c7d026a44a8..d2d226ac4164 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -773,6 +773,7 @@ slot_index_alloc_quirk_v2_hw(struct hisi_hba *hisi_hba,
 	struct hisi_sas_device *sas_dev = device->lldd_dev;
 	int sata_idx = sas_dev->sata_idx;
 	int start, end;
+	unsigned long flags;
 
 	if (!sata_dev) {
 		/*
@@ -796,12 +797,12 @@ slot_index_alloc_quirk_v2_hw(struct hisi_hba *hisi_hba,
 		end = 64 * (sata_idx + 2);
 	}
 
-	spin_lock(&hisi_hba->lock);
+	spin_lock_irqsave(&hisi_hba->lock, flags);
 	while (1) {
 		start = find_next_zero_bit(bitmap,
 					hisi_hba->slot_index_count, start);
 		if (start >= end) {
-			spin_unlock(&hisi_hba->lock);
+			spin_unlock_irqrestore(&hisi_hba->lock, flags);
 			return -SAS_QUEUE_FULL;
 		}
 		/*
@@ -813,7 +814,7 @@ slot_index_alloc_quirk_v2_hw(struct hisi_hba *hisi_hba,
 	}
 
 	set_bit(start, bitmap);
-	spin_unlock(&hisi_hba->lock);
+	spin_unlock_irqrestore(&hisi_hba->lock, flags);
 	return start;
 }
 
@@ -842,8 +843,9 @@ hisi_sas_device *alloc_dev_quirk_v2_hw(struct domain_device *device)
 	struct hisi_sas_device *sas_dev = NULL;
 	int i, sata_dev = dev_is_sata(device);
 	int sata_idx = -1;
+	unsigned long flags;
 
-	spin_lock(&hisi_hba->lock);
+	spin_lock_irqsave(&hisi_hba->lock, flags);
 
 	if (sata_dev)
 		if (!sata_index_alloc_v2_hw(hisi_hba, &sata_idx))
@@ -874,7 +876,7 @@ hisi_sas_device *alloc_dev_quirk_v2_hw(struct domain_device *device)
 	}
 
 out:
-	spin_unlock(&hisi_hba->lock);
+	spin_unlock_irqrestore(&hisi_hba->lock, flags);
 
 	return sas_dev;
 }
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 2778ebe117bb..967cf5181fed 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -954,10 +954,11 @@ static void dereg_device_v3_hw(struct hisi_hba *hisi_hba,
 	struct hisi_sas_slot *slot, *slot2;
 	struct hisi_sas_device *sas_dev = device->lldd_dev;
 	u32 cfg_abt_set_query_iptt;
+	unsigned long flags;
 
 	cfg_abt_set_query_iptt = hisi_sas_read32(hisi_hba,
 		CFG_ABT_SET_QUERY_IPTT);
-	spin_lock(&sas_dev->lock);
+	spin_lock_irqsave(&sas_dev->lock, flags);
 	list_for_each_entry_safe(slot, slot2, &sas_dev->list, entry) {
 		cfg_abt_set_query_iptt &= ~CFG_SET_ABORTED_IPTT_MSK;
 		cfg_abt_set_query_iptt |= (1 << CFG_SET_ABORTED_EN_OFF) |
@@ -965,7 +966,7 @@ static void dereg_device_v3_hw(struct hisi_hba *hisi_hba,
 		hisi_sas_write32(hisi_hba, CFG_ABT_SET_QUERY_IPTT,
 			cfg_abt_set_query_iptt);
 	}
-	spin_unlock(&sas_dev->lock);
+	spin_unlock_irqrestore(&sas_dev->lock, flags);
 	cfg_abt_set_query_iptt &= ~(1 << CFG_SET_ABORTED_EN_OFF);
 	hisi_sas_write32(hisi_hba, CFG_ABT_SET_QUERY_IPTT,
 		cfg_abt_set_query_iptt);
@@ -1587,6 +1588,7 @@ static irqreturn_t phy_up_v3_hw(int phy_no, struct hisi_hba *hisi_hba)
 	struct hisi_sas_phy *phy = &hisi_hba->phy[phy_no];
 	struct asd_sas_phy *sas_phy = &phy->sas_phy;
 	struct device *dev = hisi_hba->dev;
+	unsigned long flags;
 
 	hisi_sas_phy_write32(hisi_hba, phy_no, PHYCTRL_PHY_ENA_MSK, 1);
 
@@ -1664,11 +1666,11 @@ static irqreturn_t phy_up_v3_hw(int phy_no, struct hisi_hba *hisi_hba)
 	}
 
 	phy->port_id = port_id;
-	spin_lock(&phy->lock);
+	spin_lock_irqsave(&phy->lock, flags);
 	/* Delete timer and set phy_attached atomically */
 	timer_delete(&phy->timer);
 	phy->phy_attached = 1;
-	spin_unlock(&phy->lock);
+	spin_unlock_irqrestore(&phy->lock, flags);
 
 	/*
 	 * Call pm_runtime_get_noresume() which pairs with
@@ -2560,11 +2562,12 @@ static int queue_complete_v3_hw(struct Scsi_Host *shost, unsigned int queue)
 {
 	struct hisi_hba *hisi_hba = shost_priv(shost);
 	struct hisi_sas_cq *cq = &hisi_hba->cq[queue];
+	unsigned long flags;
 	int completed;
 
-	spin_lock(&cq->poll_lock);
+	spin_lock_irqsave(&cq->poll_lock, flags);
 	completed = complete_v3_hw(cq);
-	spin_unlock(&cq->poll_lock);
+	spin_unlock_irqrestore(&cq->poll_lock, flags);
 
 	return completed;
 }
-- 
2.33.0

