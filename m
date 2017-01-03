From: John Garry <john.garry@huawei.com>
Subject: [PATCH 2/3] scsi: hisi_sas: lock sensitive regions when servicing CQ interrupt
Date: Tue, 3 Jan 2017 20:24:49 +0800
Message-ID: <1483446290-185084-3-git-send-email-john.garry@huawei.com>
References: <1483446290-185084-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:57418 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758137AbdACLzo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Jan 2017 06:55:44 -0500
In-Reply-To: <1483446290-185084-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hanjun.guo@linaro.org, John Garry <john.garry@huawei.com>

There is a bug in the current driver in that certain hisi_hba
and port structure elements which we access when servicing
the CQ interrupt do not use thread-safe accesses; these include
hisi_sas_port linked-list of active slots (hisi_sas_port.entry),
bitmap of currently allocated IPTT (in hisi_hba.slot_index_tags),
and completion queue read pointer.

As a solution, lock these elements with the hisi_hba.lock.

Signed-off-by: John Garry <john.garry@huawei.com>
Reviewed-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 2 ++
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 8a1be0b..854fbea 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1596,6 +1596,7 @@ static irqreturn_t cq_interrupt_v1_hw(int irq, void *p)
 			hisi_hba->complete_hdr[queue];
 	u32 irq_value, rd_point = cq->rd_point, wr_point;
 
+	spin_lock(&hisi_hba->lock);
 	irq_value = hisi_sas_read32(hisi_hba, OQ_INT_SRC);
 
 	hisi_sas_write32(hisi_hba, OQ_INT_SRC, 1 << queue);
@@ -1628,6 +1629,7 @@ static irqreturn_t cq_interrupt_v1_hw(int irq, void *p)
 	/* update rd_point */
 	cq->rd_point = rd_point;
 	hisi_sas_write32(hisi_hba, COMPL_Q_0_RD_PTR + (0x14 * queue), rd_point);
+	spin_unlock(&hisi_hba->lock);
 
 	return IRQ_HANDLED;
 }
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index e506260..69b0f06 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -2493,6 +2493,7 @@ static void cq_tasklet_v2_hw(unsigned long val)
 
 	complete_queue = hisi_hba->complete_hdr[queue];
 
+	spin_lock(&hisi_hba->lock);
 	wr_point = hisi_sas_read32(hisi_hba, COMPL_Q_0_WR_PTR +
 				   (0x14 * queue));
 
@@ -2542,6 +2543,7 @@ static void cq_tasklet_v2_hw(unsigned long val)
 	/* update rd_point */
 	cq->rd_point = rd_point;
 	hisi_sas_write32(hisi_hba, COMPL_Q_0_RD_PTR + (0x14 * queue), rd_point);
+	spin_unlock(&hisi_hba->lock);
 }
 
 static irqreturn_t cq_interrupt_v2_hw(int irq_no, void *p)
-- 
1.9.1

