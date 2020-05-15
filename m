Return-Path: <SRS0=Oq5V=65=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22FCEC433E1
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 14:17:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0032B2078C
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 14:17:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726249AbgEOORx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 May 2020 10:17:53 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4794 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726246AbgEOORv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 15 May 2020 10:17:51 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id B7A7AD2CF962CFDD3BB1;
        Fri, 15 May 2020 22:17:48 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.487.0; Fri, 15 May 2020 22:17:38 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linuxarm@huawei.com>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, John Garry <john.garry@huawei.com>
Subject: [PATCH 4/4] scsi: hisi_sas: Stop returning error code from slot_complete_vX_hw()
Date:   Fri, 15 May 2020 22:13:45 +0800
Message-ID: <1589552025-165012-5-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1589552025-165012-1-git-send-email-john.garry@huawei.com>
References: <1589552025-165012-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The error codes are never checked, so stop returning them.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 12 ++++--------
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 16 ++++++----------
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 16 ++++++----------
 3 files changed, 16 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index c205bff20943..2e1718f9ade2 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1175,15 +1175,14 @@ static void slot_err_v1_hw(struct hisi_hba *hisi_hba,
 
 }
 
-static int slot_complete_v1_hw(struct hisi_hba *hisi_hba,
-			       struct hisi_sas_slot *slot)
+static void slot_complete_v1_hw(struct hisi_hba *hisi_hba,
+				struct hisi_sas_slot *slot)
 {
 	struct sas_task *task = slot->task;
 	struct hisi_sas_device *sas_dev;
 	struct device *dev = hisi_hba->dev;
 	struct task_status_struct *ts;
 	struct domain_device *device;
-	enum exec_status sts;
 	struct hisi_sas_complete_v1_hdr *complete_queue =
 			hisi_hba->complete_hdr[slot->cmplt_queue];
 	struct hisi_sas_complete_v1_hdr *complete_hdr;
@@ -1194,7 +1193,7 @@ static int slot_complete_v1_hw(struct hisi_hba *hisi_hba,
 	cmplt_hdr_data = le32_to_cpu(complete_hdr->data);
 
 	if (unlikely(!task || !task->lldd_task || !task->dev))
-		return -EINVAL;
+		return;
 
 	ts = &task->task_status;
 	device = task->dev;
@@ -1260,7 +1259,7 @@ static int slot_complete_v1_hw(struct hisi_hba *hisi_hba,
 
 		slot_err_v1_hw(hisi_hba, task, slot);
 		if (unlikely(slot->abort))
-			return ts->stat;
+			return;
 		goto out;
 	}
 
@@ -1309,12 +1308,9 @@ static int slot_complete_v1_hw(struct hisi_hba *hisi_hba,
 
 out:
 	hisi_sas_slot_task_free(hisi_hba, task, slot);
-	sts = ts->stat;
 
 	if (task->task_done)
 		task->task_done(task);
-
-	return sts;
 }
 
 /* Interrupts */
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index c725cffe141e..e7e7849a4c14 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -2318,8 +2318,8 @@ static void slot_err_v2_hw(struct hisi_hba *hisi_hba,
 	}
 }
 
-static int
-slot_complete_v2_hw(struct hisi_hba *hisi_hba, struct hisi_sas_slot *slot)
+static void slot_complete_v2_hw(struct hisi_hba *hisi_hba,
+				struct hisi_sas_slot *slot)
 {
 	struct sas_task *task = slot->task;
 	struct hisi_sas_device *sas_dev;
@@ -2327,7 +2327,6 @@ slot_complete_v2_hw(struct hisi_hba *hisi_hba, struct hisi_sas_slot *slot)
 	struct task_status_struct *ts;
 	struct domain_device *device;
 	struct sas_ha_struct *ha;
-	enum exec_status sts;
 	struct hisi_sas_complete_v2_hdr *complete_queue =
 			hisi_hba->complete_hdr[slot->cmplt_queue];
 	struct hisi_sas_complete_v2_hdr *complete_hdr =
@@ -2337,7 +2336,7 @@ slot_complete_v2_hw(struct hisi_hba *hisi_hba, struct hisi_sas_slot *slot)
 	u32 dw0;
 
 	if (unlikely(!task || !task->lldd_task || !task->dev))
-		return -EINVAL;
+		return;
 
 	ts = &task->task_status;
 	device = task->dev;
@@ -2406,7 +2405,7 @@ slot_complete_v2_hw(struct hisi_hba *hisi_hba, struct hisi_sas_slot *slot)
 				 error_info[2], error_info[3]);
 
 		if (unlikely(slot->abort))
-			return ts->stat;
+			return;
 		goto out;
 	}
 
@@ -2456,12 +2455,11 @@ slot_complete_v2_hw(struct hisi_hba *hisi_hba, struct hisi_sas_slot *slot)
 	}
 
 out:
-	sts = ts->stat;
 	spin_lock_irqsave(&task->task_state_lock, flags);
 	if (task->task_state_flags & SAS_TASK_STATE_ABORTED) {
 		spin_unlock_irqrestore(&task->task_state_lock, flags);
 		dev_info(dev, "slot complete: task(%pK) aborted\n", task);
-		return SAS_ABORTED_TASK;
+		return;
 	}
 	task->task_state_flags |= SAS_TASK_STATE_DONE;
 	spin_unlock_irqrestore(&task->task_state_lock, flags);
@@ -2473,15 +2471,13 @@ slot_complete_v2_hw(struct hisi_hba *hisi_hba, struct hisi_sas_slot *slot)
 			spin_unlock_irqrestore(&device->done_lock, flags);
 			dev_info(dev, "slot complete: task(%pK) ignored\n",
 				 task);
-			return sts;
+			return;
 		}
 		spin_unlock_irqrestore(&device->done_lock, flags);
 	}
 
 	if (task->task_done)
 		task->task_done(task);
-
-	return sts;
 }
 
 static void prep_ata_v2_hw(struct hisi_hba *hisi_hba,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index df9f06224f8f..9acb67cae49c 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2156,8 +2156,8 @@ slot_err_v3_hw(struct hisi_hba *hisi_hba, struct sas_task *task,
 	}
 }
 
-static int
-slot_complete_v3_hw(struct hisi_hba *hisi_hba, struct hisi_sas_slot *slot)
+static void slot_complete_v3_hw(struct hisi_hba *hisi_hba,
+				struct hisi_sas_slot *slot)
 {
 	struct sas_task *task = slot->task;
 	struct hisi_sas_device *sas_dev;
@@ -2165,7 +2165,6 @@ slot_complete_v3_hw(struct hisi_hba *hisi_hba, struct hisi_sas_slot *slot)
 	struct task_status_struct *ts;
 	struct domain_device *device;
 	struct sas_ha_struct *ha;
-	enum exec_status sts;
 	struct hisi_sas_complete_v3_hdr *complete_queue =
 			hisi_hba->complete_hdr[slot->cmplt_queue];
 	struct hisi_sas_complete_v3_hdr *complete_hdr =
@@ -2175,7 +2174,7 @@ slot_complete_v3_hw(struct hisi_hba *hisi_hba, struct hisi_sas_slot *slot)
 	u32 dw0, dw1, dw3;
 
 	if (unlikely(!task || !task->lldd_task || !task->dev))
-		return -EINVAL;
+		return;
 
 	ts = &task->task_status;
 	device = task->dev;
@@ -2237,7 +2236,7 @@ slot_complete_v3_hw(struct hisi_hba *hisi_hba, struct hisi_sas_slot *slot)
 				 error_info[0], error_info[1],
 				 error_info[2], error_info[3]);
 		if (unlikely(slot->abort))
-			return ts->stat;
+			return;
 		goto out;
 	}
 
@@ -2282,12 +2281,11 @@ slot_complete_v3_hw(struct hisi_hba *hisi_hba, struct hisi_sas_slot *slot)
 	}
 
 out:
-	sts = ts->stat;
 	spin_lock_irqsave(&task->task_state_lock, flags);
 	if (task->task_state_flags & SAS_TASK_STATE_ABORTED) {
 		spin_unlock_irqrestore(&task->task_state_lock, flags);
 		dev_info(dev, "slot complete: task(%pK) aborted\n", task);
-		return SAS_ABORTED_TASK;
+		return;
 	}
 	task->task_state_flags |= SAS_TASK_STATE_DONE;
 	spin_unlock_irqrestore(&task->task_state_lock, flags);
@@ -2299,15 +2297,13 @@ slot_complete_v3_hw(struct hisi_hba *hisi_hba, struct hisi_sas_slot *slot)
 			spin_unlock_irqrestore(&device->done_lock, flags);
 			dev_info(dev, "slot complete: task(%pK) ignored\n ",
 				 task);
-			return sts;
+			return;
 		}
 		spin_unlock_irqrestore(&device->done_lock, flags);
 	}
 
 	if (task->task_done)
 		task->task_done(task);
-
-	return sts;
 }
 
 static irqreturn_t  cq_thread_v3_hw(int irq_no, void *p)
-- 
2.16.4

