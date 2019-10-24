Return-Path: <SRS0=uVXb=YR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B33D8CA9EBB
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 14:25:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78E432070B
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 14:25:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502592AbfJXOY5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Oct 2019 10:24:57 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:32828 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2409404AbfJXOY4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 24 Oct 2019 10:24:56 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 3F24D3117FE96FF371F1;
        Thu, 24 Oct 2019 22:24:50 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.439.0; Thu, 24 Oct 2019 22:24:40 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <linux-kernel@vger.kernel.org>, <hare@suse.com>,
        <ming.lei@redhat.com>, "John Garry" <john.garry@huawei.com>
Subject: [PATCH 1/6] scsi: hisi_sas: Use sbitmap for IPTT management
Date:   Thu, 24 Oct 2019 22:21:16 +0800
Message-ID: <1571926881-75524-2-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1571926881-75524-1-git-send-email-john.garry@huawei.com>
References: <1571926881-75524-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Using sbitmap will be more efficient in scenarios where we generate the
IPTT in the driver, so make the transition.

For non-v2 hw, we only use the sbitmap to manage reserved tags.

For v2 hw, we use separate sbitmap sets to manage SAS/SMP and SATA tags.

Using separate SATA sbitmaps for v2 hw was suggested by Hannes Reinecke.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |   7 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c  |  82 +++++++------------
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 107 +++++++++++++++++--------
 3 files changed, 109 insertions(+), 87 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 233c73e01246..fbfaa92765cf 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -279,6 +279,8 @@ struct hisi_sas_hw {
 			   struct hisi_sas_device *device);
 	int (*slot_index_alloc)(struct hisi_hba *hisi_hba,
 				struct domain_device *device);
+	void (*slot_index_free)(struct hisi_hba *hisi_hba, int slot_idx);
+	int (*bitmaps_alloc)(struct hisi_hba *hisi_hba);
 	struct hisi_sas_device *(*alloc_dev)(struct domain_device *device);
 	void (*sl_notify_ssp)(struct hisi_hba *hisi_hba, int phy_no);
 	void (*start_delivery)(struct hisi_sas_dq *dq);
@@ -388,10 +390,9 @@ struct hisi_hba {
 	struct timer_list timer;
 	struct workqueue_struct *wq;
 
-	int slot_index_count;
 	int last_slot_index;
 	int last_dev_id;
-	unsigned long *slot_index_tags;
+	struct sbitmap slot_index_tags;
 	unsigned long reject_stp_links_msk;
 
 	/* SCSI/SAS glue */
@@ -424,6 +425,8 @@ struct hisi_hba {
 	unsigned long flags;
 	const struct hisi_sas_hw *hw;	/* Low level hw interface */
 	unsigned long sata_dev_bitmap[BITS_TO_LONGS(HISI_SAS_MAX_DEVICES)];
+	struct sbitmap sata_slot_index_tags[HISI_SAS_MAX_DEVICES];
+	int sbitmap_alloc_hint;
 	struct work_struct rst_work;
 	struct work_struct debugfs_work;
 	u32 phy_state;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index a7af9483b678..f4937da9baf8 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -156,65 +156,36 @@ EXPORT_SYMBOL_GPL(hisi_sas_stop_phys);
 
 static void hisi_sas_slot_index_clear(struct hisi_hba *hisi_hba, int slot_idx)
 {
-	void *bitmap = hisi_hba->slot_index_tags;
+	struct sbitmap *slot_index_tags = &hisi_hba->slot_index_tags;
 
-	clear_bit(slot_idx, bitmap);
+	sbitmap_clear_bit(slot_index_tags, slot_idx);
 }
 
 static void hisi_sas_slot_index_free(struct hisi_hba *hisi_hba, int slot_idx)
 {
-	unsigned long flags;
-
-	if (hisi_hba->hw->slot_index_alloc ||
-	    slot_idx >= HISI_SAS_UNRESERVED_IPTT) {
-		spin_lock_irqsave(&hisi_hba->lock, flags);
-		hisi_sas_slot_index_clear(hisi_hba, slot_idx);
-		spin_unlock_irqrestore(&hisi_hba->lock, flags);
-	}
-}
-
-static void hisi_sas_slot_index_set(struct hisi_hba *hisi_hba, int slot_idx)
-{
-	void *bitmap = hisi_hba->slot_index_tags;
-
-	set_bit(slot_idx, bitmap);
+	if (hisi_hba->hw->slot_index_free)
+		hisi_hba->hw->slot_index_free(hisi_hba, slot_idx);
+	else if (slot_idx >= HISI_SAS_UNRESERVED_IPTT)
+		hisi_sas_slot_index_clear(hisi_hba,
+					  slot_idx - HISI_SAS_UNRESERVED_IPTT);
 }
 
 static int hisi_sas_slot_index_alloc(struct hisi_hba *hisi_hba,
 				     struct scsi_cmnd *scsi_cmnd)
 {
+	struct sbitmap *slot_index_tags = &hisi_hba->slot_index_tags;
 	int index;
-	void *bitmap = hisi_hba->slot_index_tags;
-	unsigned long flags;
 
 	if (scsi_cmnd)
 		return scsi_cmnd->request->tag;
 
-	spin_lock_irqsave(&hisi_hba->lock, flags);
-	index = find_next_zero_bit(bitmap, hisi_hba->slot_index_count,
-				   hisi_hba->last_slot_index + 1);
-	if (index >= hisi_hba->slot_index_count) {
-		index = find_next_zero_bit(bitmap,
-				hisi_hba->slot_index_count,
-				HISI_SAS_UNRESERVED_IPTT);
-		if (index >= hisi_hba->slot_index_count) {
-			spin_unlock_irqrestore(&hisi_hba->lock, flags);
-			return -SAS_QUEUE_FULL;
-		}
-	}
-	hisi_sas_slot_index_set(hisi_hba, index);
-	hisi_hba->last_slot_index = index;
-	spin_unlock_irqrestore(&hisi_hba->lock, flags);
+	index = sbitmap_get(slot_index_tags, hisi_hba->sbitmap_alloc_hint,
+			    false);
+	if (index == -1)
+		return index;
+	hisi_hba->sbitmap_alloc_hint = (index + 1) % slot_index_tags->depth;
 
-	return index;
-}
-
-static void hisi_sas_slot_index_init(struct hisi_hba *hisi_hba)
-{
-	int i;
-
-	for (i = 0; i < hisi_hba->slot_index_count; ++i)
-		hisi_sas_slot_index_clear(hisi_hba, i);
+	return index + HISI_SAS_UNRESERVED_IPTT;
 }
 
 void hisi_sas_slot_task_free(struct hisi_hba *hisi_hba, struct sas_task *task,
@@ -481,7 +452,7 @@ static int hisi_sas_task_prep(struct sas_task *task,
 				scsi_cmnd = task->uldd_task;
 			}
 		}
-		rc  = hisi_sas_slot_index_alloc(hisi_hba, scsi_cmnd);
+		rc = hisi_sas_slot_index_alloc(hisi_hba, scsi_cmnd);
 	}
 	if (rc < 0)
 		goto err_out_dif_dma_unmap;
@@ -1957,7 +1928,10 @@ hisi_sas_internal_abort_task_exec(struct hisi_hba *hisi_hba, int device_id,
 	port = to_hisi_sas_port(sas_port);
 
 	/* simply get a slot and send abort command */
-	rc = hisi_sas_slot_index_alloc(hisi_hba, NULL);
+	if (hisi_hba->hw->slot_index_alloc)
+		rc = hisi_hba->hw->slot_index_alloc(hisi_hba, device);
+	else
+		rc = hisi_sas_slot_index_alloc(hisi_hba, NULL);
 	if (rc < 0)
 		goto err_out;
 
@@ -2309,7 +2283,7 @@ int hisi_sas_alloc(struct hisi_hba *hisi_hba)
 	struct device *dev = hisi_hba->dev;
 	int i, j, s, max_command_entries = HISI_SAS_MAX_COMMANDS;
 	int max_command_entries_ru, sz_slot_buf_ru;
-	int blk_cnt, slots_per_blk;
+	int blk_cnt, slots_per_blk, rc;
 
 	sema_init(&hisi_hba->sem, 1);
 	spin_lock_init(&hisi_hba->lock);
@@ -2415,10 +2389,13 @@ int hisi_sas_alloc(struct hisi_hba *hisi_hba)
 	if (!hisi_hba->breakpoint)
 		goto err_out;
 
-	hisi_hba->slot_index_count = max_command_entries;
-	s = hisi_hba->slot_index_count / BITS_PER_BYTE;
-	hisi_hba->slot_index_tags = devm_kzalloc(dev, s, GFP_KERNEL);
-	if (!hisi_hba->slot_index_tags)
+	if (hisi_hba->hw->bitmaps_alloc)
+		rc = hisi_hba->hw->bitmaps_alloc(hisi_hba);
+	else
+		rc = sbitmap_init_node(&hisi_hba->slot_index_tags,
+				       HISI_SAS_RESERVED_IPTT, -1,
+				       GFP_KERNEL, dev_to_node(dev));
+	if (rc)
 		goto err_out;
 
 	s = sizeof(struct hisi_sas_initial_fis) * HISI_SAS_MAX_PHYS;
@@ -2435,7 +2412,6 @@ int hisi_sas_alloc(struct hisi_hba *hisi_hba)
 	if (!hisi_hba->sata_breakpoint)
 		goto err_out;
 
-	hisi_sas_slot_index_init(hisi_hba);
 	hisi_hba->last_slot_index = HISI_SAS_UNRESERVED_IPTT;
 
 	hisi_hba->wq = create_singlethread_workqueue(dev_name(dev));
@@ -2460,6 +2436,10 @@ void hisi_sas_free(struct hisi_hba *hisi_hba)
 		del_timer_sync(&phy->timer);
 	}
 
+	sbitmap_free(&hisi_hba->slot_index_tags);
+	for (i = 0; i < HISI_SAS_MAX_DEVICES; i++)
+		sbitmap_free(&hisi_hba->sata_slot_index_tags[i]);
+
 	if (hisi_hba->wq)
 		destroy_workqueue(hisi_hba->wq);
 }
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 61b1e2693b08..683e1b99c9ae 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -763,59 +763,96 @@ static u32 hisi_sas_phy_read32(struct hisi_hba *hisi_hba,
 	return readl(regs);
 }
 
-/* This function needs to be protected from pre-emption. */
+static int bitmaps_alloc_v2_hw(struct hisi_hba *hisi_hba)
+{
+	struct device *dev = hisi_hba->dev;
+	int sata_idx, i;
+
+	if (sbitmap_init_node(&hisi_hba->slot_index_tags,
+			      HISI_SAS_MAX_COMMANDS / 2, -1,
+			      GFP_KERNEL, dev_to_node(hisi_hba->dev)))
+		return -ENOMEM;
+
+	for (sata_idx = 0; sata_idx < HISI_MAX_SATA_SUPPORT_V2_HW; sata_idx++) {
+		if (sbitmap_init_node(&hisi_hba->sata_slot_index_tags[sata_idx],
+				      32, -1, GFP_KERNEL, dev_to_node(dev)))
+			goto free_slot_index_tags;
+	}
+
+	return 0;
+
+free_slot_index_tags:
+	sbitmap_free(&hisi_hba->slot_index_tags);
+	for (i = 0; i < HISI_MAX_SATA_SUPPORT_V2_HW; i++)
+		sbitmap_free(&hisi_hba->sata_slot_index_tags[sata_idx]);
+
+	return -ENOMEM;
+}
+
 static int
 slot_index_alloc_quirk_v2_hw(struct hisi_hba *hisi_hba,
 			     struct domain_device *device)
 {
+	struct sbitmap *slot_index_tags;
 	int sata_dev = dev_is_sata(device);
-	void *bitmap = hisi_hba->slot_index_tags;
 	struct hisi_sas_device *sas_dev = device->lldd_dev;
 	int sata_idx = sas_dev->sata_idx;
-	int start, end;
-	unsigned long flags;
+	int start;
+
+	if (sata_dev) {
+		int start;
+		int base = 64 * (sata_idx + 1);
 
-	if (!sata_dev) {
-		/*
-		 * STP link SoC bug workaround: index starts from 1.
-		 * additionally, we can only allocate odd IPTT(1~4095)
-		 * for SAS/SMP device.
-		 */
-		start = 1;
-		end = hisi_hba->slot_index_count;
-	} else {
 		if (sata_idx >= HISI_MAX_SATA_SUPPORT_V2_HW)
 			return -EINVAL;
-
 		/*
 		 * For SATA device: allocate even IPTT in this interval
 		 * [64*(sata_idx+1), 64*(sata_idx+2)], then each SATA device
 		 * own 32 IPTTs. IPTT 0 shall not be used duing to STP link
 		 * SoC bug workaround. So we ignore the first 32 even IPTTs.
 		 */
-		start = 64 * (sata_idx + 1);
-		end = 64 * (sata_idx + 2);
-	}
 
-	spin_lock_irqsave(&hisi_hba->lock, flags);
-	while (1) {
-		start = find_next_zero_bit(bitmap,
-					hisi_hba->slot_index_count, start);
-		if (start >= end) {
-			spin_unlock_irqrestore(&hisi_hba->lock, flags);
-			return -SAS_QUEUE_FULL;
-		}
-		/*
-		  * SAS IPTT bit0 should be 1, and SATA IPTT bit0 should be 0.
-		  */
-		if (sata_dev ^ (start & 1))
-			break;
-		start++;
+		slot_index_tags = &hisi_hba->sata_slot_index_tags[sata_idx];
+
+		start = sbitmap_get(slot_index_tags, 0, true);
+		if (start == -1)
+			return -ENOMEM;
+		start *= 2;
+		return start + base;
 	}
 
-	set_bit(start, bitmap);
-	spin_unlock_irqrestore(&hisi_hba->lock, flags);
-	return start;
+	slot_index_tags = &hisi_hba->slot_index_tags;
+	start = sbitmap_get(slot_index_tags, hisi_hba->sbitmap_alloc_hint,
+			    true);
+	if (start == -1)
+		return -ENOMEM;
+
+	/*
+	 * SAS/SMP IPTT bit0 should be 1, and SATA IPTT bit0 should be 0.
+	 */
+	return (start * 2) + 1;
+}
+
+static void slot_index_free_quirk_v2_hw(struct hisi_hba *hisi_hba, int slot_idx)
+{
+	struct sbitmap *slot_index_tags;
+
+	if (slot_idx & 1) {
+		int start = (slot_idx - 1) / 2;
+
+		slot_index_tags = &hisi_hba->slot_index_tags;
+		sbitmap_clear_bit(&hisi_hba->slot_index_tags, start);
+		hisi_hba->sbitmap_alloc_hint = (start + 1) %
+					       slot_index_tags->depth;
+	} else {
+		int sata_idx = (slot_idx / 64) - 1;
+		int base = 64 * (sata_idx + 1);
+
+		slot_index_tags = &hisi_hba->sata_slot_index_tags[sata_idx];
+		slot_idx -= base;
+		slot_idx /= 2;
+		sbitmap_clear_bit(slot_index_tags, slot_idx);
+	}
 }
 
 static bool sata_index_alloc_v2_hw(struct hisi_hba *hisi_hba, int *idx)
@@ -3559,6 +3596,8 @@ static const struct hisi_sas_hw hisi_sas_v2_hw = {
 	.hw_init = hisi_sas_v2_init,
 	.setup_itct = setup_itct_v2_hw,
 	.slot_index_alloc = slot_index_alloc_quirk_v2_hw,
+	.slot_index_free = slot_index_free_quirk_v2_hw,
+	.bitmaps_alloc = bitmaps_alloc_v2_hw,
 	.alloc_dev = alloc_dev_quirk_v2_hw,
 	.sl_notify_ssp = sl_notify_ssp_v2_hw,
 	.get_wideport_bitmap = get_wideport_bitmap_v2_hw,
-- 
2.17.1

