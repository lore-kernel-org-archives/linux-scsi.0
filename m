Return-Path: <SRS0=Vgdy=EE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED730C388F7
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 01:22:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A74E02064C
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 01:22:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729475AbgJ1WEx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Oct 2020 18:04:53 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:7076 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729338AbgJ1WCN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Oct 2020 18:02:13 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CLp3v577DzLqVv;
        Wed, 28 Oct 2020 20:36:59 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Wed, 28 Oct 2020 20:36:47 +0800
From:   John Garry <john.garry@huawei.com>
To:     <gregkh@linuxfoundation.org>, <rafael@kernel.org>,
        <martin.petersen@oracle.com>, <jejb@linux.ibm.com>,
        <tglx@linutronix.de>
CC:     <linuxarm@huawei.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <maz@kernel.org>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH v2 3/3] scsi: hisi_sas: Expose HW queues for v2 hw
Date:   Wed, 28 Oct 2020 20:33:07 +0800
Message-ID: <1603888387-52499-4-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1603888387-52499-1-git-send-email-john.garry@huawei.com>
References: <1603888387-52499-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

As a performance enhancement, make the completion queue interrupts
managed.

In addition, in commit bf0beec0607d ("blk-mq: drain I/O when all CPUs in a
hctx are offline"), CPU hotplug for MQ devices using managed interrupts
is made safe. So expose HW queues to blk-mq to take advantage of this.

Flag Scsi_host.host_tagset is also set to ensure that the HBA is not sent
more commands than it can handle. However the driver still does not use
request tag for IPTT as there are many HW bugs which means that special
rules apply for IPTT allocation.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  4 ++
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 11 ++++
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 71 ++++++++++++++++++++++----
 3 files changed, 75 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index a25cfc11c96d..33c4fb45dd99 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -14,6 +14,7 @@
 #include <linux/debugfs.h>
 #include <linux/dmapool.h>
 #include <linux/iopoll.h>
+#include <linux/irq.h>
 #include <linux/lcm.h>
 #include <linux/libata.h>
 #include <linux/mfd/syscon.h>
@@ -312,6 +313,7 @@ enum {
 
 struct hisi_sas_hw {
 	int (*hw_init)(struct hisi_hba *hisi_hba);
+	int (*interrupt_preinit)(struct hisi_hba *hisi_hba);
 	void (*setup_itct)(struct hisi_hba *hisi_hba,
 			   struct hisi_sas_device *device);
 	int (*slot_index_alloc)(struct hisi_hba *hisi_hba,
@@ -418,6 +420,8 @@ struct hisi_hba {
 	u32 refclk_frequency_mhz;
 	u8 sas_addr[SAS_ADDR_SIZE];
 
+	int irq_map[128]; /* v2 hw */
+
 	int n_phy;
 	spinlock_t lock;
 	struct semaphore sem;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 128583dfccf2..56f914203679 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -2614,6 +2614,13 @@ static struct Scsi_Host *hisi_sas_shost_alloc(struct platform_device *pdev,
 	return NULL;
 }
 
+static int hisi_sas_interrupt_preinit(struct hisi_hba *hisi_hba)
+{
+	if (hisi_hba->hw->interrupt_preinit)
+		return hisi_hba->hw->interrupt_preinit(hisi_hba);
+	return 0;
+}
+
 int hisi_sas_probe(struct platform_device *pdev,
 		   const struct hisi_sas_hw *hw)
 {
@@ -2671,6 +2678,10 @@ int hisi_sas_probe(struct platform_device *pdev,
 		sha->sas_port[i] = &hisi_hba->port[i].sas_port;
 	}
 
+	rc = hisi_sas_interrupt_preinit(hisi_hba);
+	if (rc)
+		goto err_out_ha;
+
 	rc = scsi_add_host(shost, &pdev->dev);
 	if (rc)
 		goto err_out_ha;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index b57177b52fac..d6b933c3d0a2 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -3302,6 +3302,37 @@ static irq_handler_t fatal_interrupts[HISI_SAS_FATAL_INT_NR] = {
 	fatal_axi_int_v2_hw
 };
 
+static int hisi_sas_v2_interrupt_preinit(struct hisi_hba *hisi_hba)
+{
+	struct platform_device *pdev = hisi_hba->platform_dev;
+	struct Scsi_Host *shost = hisi_hba->shost;
+	int rc, i, *irqs, count;
+	struct irq_affinity desc = {
+		.pre_vectors = 96, /* base of completion queue interrupts */
+		.post_vectors = 16,
+	};
+
+	rc = platform_get_irqs_affinity(pdev, &desc, &count, &irqs);
+	if (rc < 0)
+		return rc;
+
+	/* 128 interrupts are always expected */
+	if (count != 128) {
+		kfree(irqs);
+		return -EIO;
+	}
+
+	/* Store the IRQ numbers in the driver */
+	for (i = 0; i < 128; i++)
+		hisi_hba->irq_map[i] = irqs[i];
+
+	shost->nr_hw_queues = hisi_hba->cq_nvecs = hisi_hba->queue_count;
+
+	kfree(irqs);
+
+	return 0;
+}
+
 /*
  * There is a limitation in the hip06 chipset that we need
  * to map in all mbigen interrupts, even if they are not used.
@@ -3310,14 +3341,11 @@ static int interrupt_init_v2_hw(struct hisi_hba *hisi_hba)
 {
 	struct platform_device *pdev = hisi_hba->platform_dev;
 	struct device *dev = &pdev->dev;
-	int irq, rc = 0, irq_map[128];
+	int irq, rc = 0;
 	int i, phy_no, fatal_no, queue_no;
 
-	for (i = 0; i < 128; i++)
-		irq_map[i] = platform_get_irq(pdev, i);
-
 	for (i = 0; i < HISI_SAS_PHY_INT_NR; i++) {
-		irq = irq_map[i + 1]; /* Phy up/down is irq1 */
+		irq = hisi_hba->irq_map[i + 1]; /* Phy up/down is irq1 */
 		rc = devm_request_irq(dev, irq, phy_interrupts[i], 0,
 				      DRV_NAME " phy", hisi_hba);
 		if (rc) {
@@ -3331,7 +3359,7 @@ static int interrupt_init_v2_hw(struct hisi_hba *hisi_hba)
 	for (phy_no = 0; phy_no < hisi_hba->n_phy; phy_no++) {
 		struct hisi_sas_phy *phy = &hisi_hba->phy[phy_no];
 
-		irq = irq_map[phy_no + 72];
+		irq = hisi_hba->irq_map[phy_no + 72];
 		rc = devm_request_irq(dev, irq, sata_int_v2_hw, 0,
 				      DRV_NAME " sata", phy);
 		if (rc) {
@@ -3343,7 +3371,7 @@ static int interrupt_init_v2_hw(struct hisi_hba *hisi_hba)
 	}
 
 	for (fatal_no = 0; fatal_no < HISI_SAS_FATAL_INT_NR; fatal_no++) {
-		irq = irq_map[fatal_no + 81];
+		irq = hisi_hba->irq_map[fatal_no + 81];
 		rc = devm_request_irq(dev, irq, fatal_interrupts[fatal_no], 0,
 				      DRV_NAME " fatal", hisi_hba);
 		if (rc) {
@@ -3357,7 +3385,7 @@ static int interrupt_init_v2_hw(struct hisi_hba *hisi_hba)
 	for (queue_no = 0; queue_no < hisi_hba->queue_count; queue_no++) {
 		struct hisi_sas_cq *cq = &hisi_hba->cq[queue_no];
 
-		cq->irq_no = irq_map[queue_no + 96];
+		cq->irq_no = hisi_hba->irq_map[queue_no + 96];
 		rc = devm_request_threaded_irq(dev, cq->irq_no,
 					       cq_interrupt_v2_hw,
 					       cq_thread_v2_hw, IRQF_ONESHOT,
@@ -3368,10 +3396,8 @@ static int interrupt_init_v2_hw(struct hisi_hba *hisi_hba)
 			rc = -ENOENT;
 			goto err_out;
 		}
+		cq->irq_mask = irq_get_affinity_mask(cq->irq_no);
 	}
-
-	hisi_hba->cq_nvecs = hisi_hba->queue_count;
-
 err_out:
 	return rc;
 }
@@ -3529,6 +3555,26 @@ static struct device_attribute *host_attrs_v2_hw[] = {
 	NULL
 };
 
+static int map_queues_v2_hw(struct Scsi_Host *shost)
+{
+	struct hisi_hba *hisi_hba = shost_priv(shost);
+	struct blk_mq_queue_map *qmap = &shost->tag_set.map[HCTX_TYPE_DEFAULT];
+	const struct cpumask *mask;
+	unsigned int queue, cpu;
+
+	for (queue = 0; queue < qmap->nr_queues; queue++) {
+		mask = irq_get_affinity_mask(hisi_hba->irq_map[96 + queue]);
+		if (!mask)
+			continue;
+
+		for_each_cpu(cpu, mask)
+			qmap->mq_map[cpu] = qmap->queue_offset + queue;
+	}
+
+	return 0;
+
+}
+
 static struct scsi_host_template sht_v2_hw = {
 	.name			= DRV_NAME,
 	.proc_name		= DRV_NAME,
@@ -3553,10 +3599,13 @@ static struct scsi_host_template sht_v2_hw = {
 #endif
 	.shost_attrs		= host_attrs_v2_hw,
 	.host_reset		= hisi_sas_host_reset,
+	.map_queues		= map_queues_v2_hw,
+	.host_tagset		= 1,
 };
 
 static const struct hisi_sas_hw hisi_sas_v2_hw = {
 	.hw_init = hisi_sas_v2_init,
+	.interrupt_preinit = hisi_sas_v2_interrupt_preinit,
 	.setup_itct = setup_itct_v2_hw,
 	.slot_index_alloc = slot_index_alloc_quirk_v2_hw,
 	.alloc_dev = alloc_dev_quirk_v2_hw,
-- 
2.26.2

