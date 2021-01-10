Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71628C433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Jan 2021 19:06:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F58822B43
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Jan 2021 19:06:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbhAJTGJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 Jan 2021 14:06:09 -0500
Received: from bedivere.hansenpartnership.com ([96.44.175.130]:49982 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726267AbhAJTGJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 10 Jan 2021 14:06:09 -0500
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id A1FF8128038C;
        Sun, 10 Jan 2021 11:05:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1610305528;
        bh=4XW5npyc9zq6QyHgZJfewa8gmDpW7bVmrIyvnkZJ0Zk=;
        h=Message-ID:Subject:From:To:Date:From;
        b=SLtUMFR8DSlviuJAW606BNV0hMZrVuL3I986DH/+PnWZIL4D1qKXxBjWAKsmcDJ+B
         UgJkRcQV9v0JboS0cNykgbUCPUQGv8rZ7WKEndkOZmnhfhRdHWvpZYRWufOEjYqqPc
         +B/PfZCYtALOoeLaZzovuF9XbbRyv1gFSvWhtt90=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 9d5BKh-Te1iN; Sun, 10 Jan 2021 11:05:28 -0800 (PST)
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:600:8280:66d1::c447])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 4A4B61280383;
        Sun, 10 Jan 2021 11:05:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1610305528;
        bh=4XW5npyc9zq6QyHgZJfewa8gmDpW7bVmrIyvnkZJ0Zk=;
        h=Message-ID:Subject:From:To:Date:From;
        b=SLtUMFR8DSlviuJAW606BNV0hMZrVuL3I986DH/+PnWZIL4D1qKXxBjWAKsmcDJ+B
         UgJkRcQV9v0JboS0cNykgbUCPUQGv8rZ7WKEndkOZmnhfhRdHWvpZYRWufOEjYqqPc
         +B/PfZCYtALOoeLaZzovuF9XbbRyv1gFSvWhtt90=
Message-ID: <14455f8f5d119cb74d3dbe66898863a1a79c0f0b.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.11-rc2
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Sun, 10 Jan 2021 11:05:27 -0800
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is two driver fixes (megaraid_sas and hisi_sas).  The megaraid one
is a revert of a previous revert of a cpu hotplug fix which exposed a
bug in the block layer which has been fixed in this merge window and
the hisi_sas performance enhancement comes from switching to interrupt
managed completion queues, which depended on the addition of
devm_platform_get_irqs_affinity() which is now upstream via the irq
tree in the last merge window.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

      scsi: hisi_sas: Expose HW queues for v2 hw

Martin K. Petersen (1):
      Revert "Revert "scsi: megaraid_sas: Added support for shared host tagset for cpuhotplug""

And the diffstat:

 drivers/scsi/hisi_sas/hisi_sas.h            |  4 ++
 drivers/scsi/hisi_sas/hisi_sas_main.c       | 11 +++++
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c      | 66 +++++++++++++++++++++++------
 drivers/scsi/megaraid/megaraid_sas_base.c   | 39 +++++++++++++++++
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 29 +++++++------
 5 files changed, 123 insertions(+), 26 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 2b28dd405600..e821dd32dd28 100644
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
@@ -294,6 +295,7 @@ enum {
 
 struct hisi_sas_hw {
 	int (*hw_init)(struct hisi_hba *hisi_hba);
+	int (*interrupt_preinit)(struct hisi_hba *hisi_hba);
 	void (*setup_itct)(struct hisi_hba *hisi_hba,
 			   struct hisi_sas_device *device);
 	int (*slot_index_alloc)(struct hisi_hba *hisi_hba,
@@ -393,6 +395,8 @@ struct hisi_hba {
 	u32 refclk_frequency_mhz;
 	u8 sas_addr[SAS_ADDR_SIZE];
 
+	int *irq_map; /* v2 hw */
+
 	int n_phy;
 	spinlock_t lock;
 	struct semaphore sem;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index b6d4419c32f2..cf0bfac920a8 100644
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
index b57177b52fac..9adfdefef9ca 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -3302,6 +3302,28 @@ static irq_handler_t fatal_interrupts[HISI_SAS_FATAL_INT_NR] = {
 	fatal_axi_int_v2_hw
 };
 
+#define CQ0_IRQ_INDEX (96)
+
+static int hisi_sas_v2_interrupt_preinit(struct hisi_hba *hisi_hba)
+{
+	struct platform_device *pdev = hisi_hba->platform_dev;
+	struct Scsi_Host *shost = hisi_hba->shost;
+	struct irq_affinity desc = {
+		.pre_vectors = CQ0_IRQ_INDEX,
+		.post_vectors = 16,
+	};
+	int resv = desc.pre_vectors + desc.post_vectors, minvec = resv + 1, nvec;
+
+	nvec = devm_platform_get_irqs_affinity(pdev, &desc, minvec, 128,
+					       &hisi_hba->irq_map);
+	if (nvec < 0)
+		return nvec;
+
+	shost->nr_hw_queues = hisi_hba->cq_nvecs = nvec - resv;
+
+	return 0;
+}
+
 /*
  * There is a limitation in the hip06 chipset that we need
  * to map in all mbigen interrupts, even if they are not used.
@@ -3310,14 +3332,11 @@ static int interrupt_init_v2_hw(struct hisi_hba *hisi_hba)
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
@@ -3331,7 +3350,7 @@ static int interrupt_init_v2_hw(struct hisi_hba *hisi_hba)
 	for (phy_no = 0; phy_no < hisi_hba->n_phy; phy_no++) {
 		struct hisi_sas_phy *phy = &hisi_hba->phy[phy_no];
 
-		irq = irq_map[phy_no + 72];
+		irq = hisi_hba->irq_map[phy_no + 72];
 		rc = devm_request_irq(dev, irq, sata_int_v2_hw, 0,
 				      DRV_NAME " sata", phy);
 		if (rc) {
@@ -3343,7 +3362,7 @@ static int interrupt_init_v2_hw(struct hisi_hba *hisi_hba)
 	}
 
 	for (fatal_no = 0; fatal_no < HISI_SAS_FATAL_INT_NR; fatal_no++) {
-		irq = irq_map[fatal_no + 81];
+		irq = hisi_hba->irq_map[fatal_no + 81];
 		rc = devm_request_irq(dev, irq, fatal_interrupts[fatal_no], 0,
 				      DRV_NAME " fatal", hisi_hba);
 		if (rc) {
@@ -3354,24 +3373,22 @@ static int interrupt_init_v2_hw(struct hisi_hba *hisi_hba)
 		}
 	}
 
-	for (queue_no = 0; queue_no < hisi_hba->queue_count; queue_no++) {
+	for (queue_no = 0; queue_no < hisi_hba->cq_nvecs; queue_no++) {
 		struct hisi_sas_cq *cq = &hisi_hba->cq[queue_no];
 
-		cq->irq_no = irq_map[queue_no + 96];
+		cq->irq_no = hisi_hba->irq_map[queue_no + 96];
 		rc = devm_request_threaded_irq(dev, cq->irq_no,
 					       cq_interrupt_v2_hw,
 					       cq_thread_v2_hw, IRQF_ONESHOT,
 					       DRV_NAME " cq", cq);
 		if (rc) {
 			dev_err(dev, "irq init: could not request cq interrupt %d, rc=%d\n",
-				irq, rc);
+					cq->irq_no, rc);
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
@@ -3529,6 +3546,26 @@ static struct device_attribute *host_attrs_v2_hw[] = {
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
@@ -3553,10 +3590,13 @@ static struct scsi_host_template sht_v2_hw = {
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
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 6e4bf05c6d77..af192096a82b 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -37,6 +37,7 @@
 #include <linux/poll.h>
 #include <linux/vmalloc.h>
 #include <linux/irq_poll.h>
+#include <linux/blk-mq-pci.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -113,6 +114,10 @@ unsigned int enable_sdev_max_qd;
 module_param(enable_sdev_max_qd, int, 0444);
 MODULE_PARM_DESC(enable_sdev_max_qd, "Enable sdev max qd as can_queue. Default: 0");
 
+int host_tagset_enable = 1;
+module_param(host_tagset_enable, int, 0444);
+MODULE_PARM_DESC(host_tagset_enable, "Shared host tagset enable/disable Default: enable(1)");
+
 MODULE_LICENSE("GPL");
 MODULE_VERSION(MEGASAS_VERSION);
 MODULE_AUTHOR("megaraidlinux.pdl@broadcom.com");
@@ -3119,6 +3124,19 @@ megasas_bios_param(struct scsi_device *sdev, struct block_device *bdev,
 	return 0;
 }
 
+static int megasas_map_queues(struct Scsi_Host *shost)
+{
+	struct megasas_instance *instance;
+
+	instance = (struct megasas_instance *)shost->hostdata;
+
+	if (shost->nr_hw_queues == 1)
+		return 0;
+
+	return blk_mq_pci_map_queues(&shost->tag_set.map[HCTX_TYPE_DEFAULT],
+			instance->pdev, instance->low_latency_index_start);
+}
+
 static void megasas_aen_polling(struct work_struct *work);
 
 /**
@@ -3427,6 +3445,7 @@ static struct scsi_host_template megasas_template = {
 	.eh_timed_out = megasas_reset_timer,
 	.shost_attrs = megaraid_host_attrs,
 	.bios_param = megasas_bios_param,
+	.map_queues = megasas_map_queues,
 	.change_queue_depth = scsi_change_queue_depth,
 	.max_segment_size = 0xffffffff,
 };
@@ -6808,6 +6827,26 @@ static int megasas_io_attach(struct megasas_instance *instance)
 	host->max_lun = MEGASAS_MAX_LUN;
 	host->max_cmd_len = 16;
 
+	/* Use shared host tagset only for fusion adaptors
+	 * if there are managed interrupts (smp affinity enabled case).
+	 * Single msix_vectors in kdump, so shared host tag is also disabled.
+	 */
+
+	host->host_tagset = 0;
+	host->nr_hw_queues = 1;
+
+	if ((instance->adapter_type != MFI_SERIES) &&
+		(instance->msix_vectors > instance->low_latency_index_start) &&
+		host_tagset_enable &&
+		instance->smp_affinity_enable) {
+		host->host_tagset = 1;
+		host->nr_hw_queues = instance->msix_vectors -
+			instance->low_latency_index_start;
+	}
+
+	dev_info(&instance->pdev->dev,
+		"Max firmware commands: %d shared with nr_hw_queues = %d\n",
+		instance->max_fw_cmds, host->nr_hw_queues);
 	/*
 	 * Notify the mid-layer about the new controller
 	 */
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index b0c01cf0428f..fd607287608e 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -359,24 +359,29 @@ megasas_get_msix_index(struct megasas_instance *instance,
 {
 	int sdev_busy;
 
-	/* nr_hw_queue = 1 for MegaRAID */
-	struct blk_mq_hw_ctx *hctx =
-		scmd->device->request_queue->queue_hw_ctx[0];
-
-	sdev_busy = atomic_read(&hctx->nr_active);
+	/* TBD - if sml remove device_busy in future, driver
+	 * should track counter in internal structure.
+	 */
+	sdev_busy = atomic_read(&scmd->device->device_busy);
 
 	if (instance->perf_mode == MR_BALANCED_PERF_MODE &&
-	    sdev_busy > (data_arms * MR_DEVICE_HIGH_IOPS_DEPTH))
+	    sdev_busy > (data_arms * MR_DEVICE_HIGH_IOPS_DEPTH)) {
 		cmd->request_desc->SCSIIO.MSIxIndex =
 			mega_mod64((atomic64_add_return(1, &instance->high_iops_outstanding) /
 					MR_HIGH_IOPS_BATCH_COUNT), instance->low_latency_index_start);
-	else if (instance->msix_load_balance)
+	} else if (instance->msix_load_balance) {
 		cmd->request_desc->SCSIIO.MSIxIndex =
 			(mega_mod64(atomic64_add_return(1, &instance->total_io_count),
 				instance->msix_vectors));
-	else
+	} else if (instance->host->nr_hw_queues > 1) {
+		u32 tag = blk_mq_unique_tag(scmd->request);
+
+		cmd->request_desc->SCSIIO.MSIxIndex = blk_mq_unique_tag_to_hwq(tag) +
+			instance->low_latency_index_start;
+	} else {
 		cmd->request_desc->SCSIIO.MSIxIndex =
 			instance->reply_map[raw_smp_processor_id()];
+	}
 }
 
 /**
@@ -956,9 +961,6 @@ megasas_alloc_cmds_fusion(struct megasas_instance *instance)
 	if (megasas_alloc_cmdlist_fusion(instance))
 		goto fail_exit;
 
-	dev_info(&instance->pdev->dev, "Configured max firmware commands: %d\n",
-		 instance->max_fw_cmds);
-
 	/* The first 256 bytes (SMID 0) is not used. Don't add to the cmd list */
 	io_req_base = fusion->io_request_frames + MEGA_MPI2_RAID_DEFAULT_IO_FRAME_SIZE;
 	io_req_base_phys = fusion->io_request_frames_phys + MEGA_MPI2_RAID_DEFAULT_IO_FRAME_SIZE;
@@ -1102,8 +1104,9 @@ megasas_ioc_init_fusion(struct megasas_instance *instance)
 		MR_HIGH_IOPS_QUEUE_COUNT) && cur_intr_coalescing)
 		instance->perf_mode = MR_BALANCED_PERF_MODE;
 
-	dev_info(&instance->pdev->dev, "Performance mode :%s\n",
-		MEGASAS_PERF_MODE_2STR(instance->perf_mode));
+	dev_info(&instance->pdev->dev, "Performance mode :%s (latency index = %d)\n",
+		MEGASAS_PERF_MODE_2STR(instance->perf_mode),
+		instance->low_latency_index_start);
 
 	instance->fw_sync_cache_support = (scratch_pad_1 &
 		MR_CAN_HANDLE_SYNC_CACHE_OFFSET) ? 1 : 0;

