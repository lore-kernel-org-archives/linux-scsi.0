Return-Path: <SRS0=2tGB=3J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C55F4C33CA1
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 12:27:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5F2322464
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 12:27:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728600AbgATM1G (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jan 2020 07:27:06 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9219 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728901AbgATM06 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Jan 2020 07:26:58 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id B989B718139A8316F1D3;
        Mon, 20 Jan 2020 20:26:53 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.439.0; Mon, 20 Jan 2020 20:26:45 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <linux-kernel@vger.kernel.org>, John Garry <john.garry@huawei.com>
Subject: [PATCH 7/7] scsi: hisi_sas: Use reply map for v2 hw
Date:   Mon, 20 Jan 2020 20:22:37 +0800
Message-ID: <1579522957-4393-8-git-send-email-john.garry@huawei.com>
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

With the aim of boosting performance, switch v2 hw to using reply map, i.e.
pseudo blk-mq.

This really when we're running a distro with irqbalance running. The reason
being that the irqbalance can fiddle with the completion queue affinity,
such that we random cpus servicing the CQs. It's not much better without
irqbalance, where it is always cpu0.

Distro read fio performance for 6x SAS SSDs goes from ~450K IOPS ->
650K IOPS.

To continuing support manually setting the irq affinity, introduce module
parameter auto_affine_interrupts, which is default off.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  3 ++
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 54 +++++++++++++++++++++++++-
 2 files changed, 56 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 2bdd64648ef0..0612fc929a2d 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -10,6 +10,7 @@
 #include <linux/acpi.h>
 #include <linux/clk.h>
 #include <linux/debugfs.h>
+#include <linux/device.h>
 #include <linux/dmapool.h>
 #include <linux/iopoll.h>
 #include <linux/lcm.h>
@@ -385,6 +386,8 @@ struct hisi_hba {
 	spinlock_t lock;
 	struct semaphore sem;
 
+	struct irq_affinity_desc affinity_masks[HISI_SAS_MAX_QUEUES];
+
 	struct timer_list timer;
 	struct workqueue_struct *wq;
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index e05faf315dcd..533515e85f64 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -417,6 +417,11 @@ struct sig_atten_lu_s {
 	u32 sas_phy_ctrl;
 };
 
+static bool auto_affine_interrupts;
+module_param(auto_affine_interrupts, bool, 0444);
+MODULE_PARM_DESC(auto_affine_interrupts, "Enable auto-affinity of completion queue interrupts:\n"
+		 "default is off");
+
 static const struct hisi_sas_hw_error one_bit_ecc_errors[] = {
 	{
 		.irq_msk = BIT(SAS_ECC_INTR_DQE_ECC_1B_OFF),
@@ -3304,6 +3309,24 @@ static irq_handler_t fatal_interrupts[HISI_SAS_FATAL_INT_NR] = {
 	fatal_axi_int_v2_hw
 };
 
+static void setup_reply_map_v2_hw(struct hisi_hba *hisi_hba)
+{
+	int queue, cpu;
+
+	for (queue = 0; queue < hisi_hba->queue_count; queue++) {
+		struct hisi_sas_cq *cq = &hisi_hba->cq[queue];
+		struct irq_affinity_desc *mask;
+		struct cpumask *cpumask;
+
+		mask = &hisi_hba->affinity_masks[queue];
+		cpumask = &mask->mask;
+
+		cq->irq_mask = cpumask;
+		for_each_cpu(cpu, cpumask)
+			hisi_hba->reply_map[cpu] = queue;
+	}
+}
+
 /**
  * There is a limitation in the hip06 chipset that we need
  * to map in all mbigen interrupts, even if they are not used.
@@ -3315,6 +3338,27 @@ static int interrupt_init_v2_hw(struct hisi_hba *hisi_hba)
 	int irq, rc = 0, irq_map[128];
 	int i, phy_no, fatal_no, queue_no;
 
+	if (auto_affine_interrupts) {
+		struct irq_affinity_desc *masks;
+		struct irq_affinity desc = {};
+		int nvec;
+
+		nvec = hisi_hba->queue_count;
+		masks = irq_create_affinity_masks(nvec, &desc);
+		if (!masks)
+			return -ENOMEM;
+
+		memcpy(hisi_hba->affinity_masks, masks, nvec * sizeof(*masks));
+		kfree(masks);
+
+		hisi_hba->reply_map = devm_kcalloc(dev, nr_cpu_ids,
+						   sizeof(unsigned int),
+						   GFP_KERNEL);
+		if (!hisi_hba->reply_map)
+			return -ENOMEM;
+		setup_reply_map_v2_hw(hisi_hba);
+	}
+
 	for (i = 0; i < 128; i++)
 		irq_map[i] = platform_get_irq(pdev, i);
 
@@ -3358,11 +3402,16 @@ static int interrupt_init_v2_hw(struct hisi_hba *hisi_hba)
 
 	for (queue_no = 0; queue_no < hisi_hba->queue_count; queue_no++) {
 		struct hisi_sas_cq *cq = &hisi_hba->cq[queue_no];
+		unsigned long irqflags = IRQF_ONESHOT;
+
+		if (auto_affine_interrupts)
+			irqflags |= IRQF_NOBALANCING;
 
 		cq->irq_no = irq_map[queue_no + 96];
+
 		rc = devm_request_threaded_irq(dev, cq->irq_no,
 					       cq_interrupt_v2_hw,
-					       cq_thread_v2_hw, IRQF_ONESHOT,
+					       cq_thread_v2_hw, irqflags,
 					       DRV_NAME " cq", cq);
 		if (rc) {
 			dev_err(dev, "irq init: could not request cq interrupt %d, rc=%d\n",
@@ -3370,6 +3419,9 @@ static int interrupt_init_v2_hw(struct hisi_hba *hisi_hba)
 			rc = -ENOENT;
 			goto err_out;
 		}
+
+		if (auto_affine_interrupts)
+			irq_set_affinity(cq->irq_no, cq->irq_mask);
 	}
 
 	hisi_hba->cq_nvecs = hisi_hba->queue_count;
-- 
2.17.1

