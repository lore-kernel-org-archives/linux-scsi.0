Return-Path: <SRS0=mOiQ=7X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44FA6C433E4
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 17:33:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FF192070B
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 17:33:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbgFJRdq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Jun 2020 13:33:46 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:5815 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726524AbgFJRdq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 10 Jun 2020 13:33:46 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 4B41AC78CC531FA84610;
        Thu, 11 Jun 2020 01:33:27 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Thu, 11 Jun 2020 01:33:20 +0800
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <don.brace@microsemi.com>,
        <kashyap.desai@broadcom.com>, <sumit.saxena@broadcom.com>,
        <ming.lei@redhat.com>, <bvanassche@acm.org>, <hare@suse.com>,
        <hch@lst.de>, <shivasharan.srikanteshwara@broadcom.com>
CC:     <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <esc.storagedev@microsemi.com>, <chenxiang66@hisilicon.com>,
        <megaraidlinux.pdl@broadcom.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH RFC v7 10/12] megaraid_sas: switch fusion adapters to MQ
Date:   Thu, 11 Jun 2020 01:29:17 +0800
Message-ID: <1591810159-240929-11-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
References: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.com>

Fusion adapters can steer completions to individual queues, and
we now have support for shared host-wide tags.
So we can enable multiqueue support for fusion adapters and
drop the hand-crafted interrupt affinity settings.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/megaraid/megaraid_sas.h        |  1 -
 drivers/scsi/megaraid/megaraid_sas_base.c   | 59 +++++++--------------
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 24 +++++----
 3 files changed, 32 insertions(+), 52 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index af2c7a2a9565..b27a34a5f5de 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -2261,7 +2261,6 @@ enum MR_PERF_MODE {
 
 struct megasas_instance {
 
-	unsigned int *reply_map;
 	__le32 *producer;
 	dma_addr_t producer_h;
 	__le32 *consumer;
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 00668335c2af..e6bb2a64d51c 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -37,6 +37,7 @@
 #include <linux/poll.h>
 #include <linux/vmalloc.h>
 #include <linux/irq_poll.h>
+#include <linux/blk-mq-pci.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -3115,6 +3116,19 @@ megasas_bios_param(struct scsi_device *sdev, struct block_device *bdev,
 	return 0;
 }
 
+static int megasas_map_queues(struct Scsi_Host *shost)
+{
+	struct megasas_instance *instance;
+
+	instance = (struct megasas_instance *)shost->hostdata;
+
+	if (!instance->smp_affinity_enable)
+		return 0;
+
+	return blk_mq_pci_map_queues(&shost->tag_set.map[HCTX_TYPE_DEFAULT],
+			instance->pdev, instance->low_latency_index_start);
+}
+
 static void megasas_aen_polling(struct work_struct *work);
 
 /**
@@ -3423,8 +3437,10 @@ static struct scsi_host_template megasas_template = {
 	.eh_timed_out = megasas_reset_timer,
 	.shost_attrs = megaraid_host_attrs,
 	.bios_param = megasas_bios_param,
+	.map_queues = megasas_map_queues,
 	.change_queue_depth = scsi_change_queue_depth,
 	.max_segment_size = 0xffffffff,
+	.host_tagset = 1,
 };
 
 /**
@@ -5708,34 +5724,6 @@ megasas_setup_jbod_map(struct megasas_instance *instance)
 		instance->use_seqnum_jbod_fp = false;
 }
 
-static void megasas_setup_reply_map(struct megasas_instance *instance)
-{
-	const struct cpumask *mask;
-	unsigned int queue, cpu, low_latency_index_start;
-
-	low_latency_index_start = instance->low_latency_index_start;
-
-	for (queue = low_latency_index_start; queue < instance->msix_vectors; queue++) {
-		mask = pci_irq_get_affinity(instance->pdev, queue);
-		if (!mask)
-			goto fallback;
-
-		for_each_cpu(cpu, mask)
-			instance->reply_map[cpu] = queue;
-	}
-	return;
-
-fallback:
-	queue = low_latency_index_start;
-	for_each_possible_cpu(cpu) {
-		instance->reply_map[cpu] = queue;
-		if (queue == (instance->msix_vectors - 1))
-			queue = low_latency_index_start;
-		else
-			queue++;
-	}
-}
-
 /**
  * megasas_get_device_list -	Get the PD and LD device list from FW.
  * @instance:			Adapter soft state
@@ -6158,8 +6146,6 @@ static int megasas_init_fw(struct megasas_instance *instance)
 			goto fail_init_adapter;
 	}
 
-	megasas_setup_reply_map(instance);
-
 	dev_info(&instance->pdev->dev,
 		"current msix/online cpus\t: (%d/%d)\n",
 		instance->msix_vectors, (unsigned int)num_online_cpus());
@@ -6793,6 +6779,9 @@ static int megasas_io_attach(struct megasas_instance *instance)
 	host->max_id = MEGASAS_MAX_DEV_PER_CHANNEL;
 	host->max_lun = MEGASAS_MAX_LUN;
 	host->max_cmd_len = 16;
+	if (instance->adapter_type != MFI_SERIES && instance->msix_vectors > 0)
+		host->nr_hw_queues = instance->msix_vectors -
+			instance->low_latency_index_start;
 
 	/*
 	 * Notify the mid-layer about the new controller
@@ -6960,11 +6949,6 @@ static inline int megasas_alloc_mfi_ctrl_mem(struct megasas_instance *instance)
  */
 static int megasas_alloc_ctrl_mem(struct megasas_instance *instance)
 {
-	instance->reply_map = kcalloc(nr_cpu_ids, sizeof(unsigned int),
-				      GFP_KERNEL);
-	if (!instance->reply_map)
-		return -ENOMEM;
-
 	switch (instance->adapter_type) {
 	case MFI_SERIES:
 		if (megasas_alloc_mfi_ctrl_mem(instance))
@@ -6981,8 +6965,6 @@ static int megasas_alloc_ctrl_mem(struct megasas_instance *instance)
 
 	return 0;
  fail:
-	kfree(instance->reply_map);
-	instance->reply_map = NULL;
 	return -ENOMEM;
 }
 
@@ -6995,7 +6977,6 @@ static int megasas_alloc_ctrl_mem(struct megasas_instance *instance)
  */
 static inline void megasas_free_ctrl_mem(struct megasas_instance *instance)
 {
-	kfree(instance->reply_map);
 	if (instance->adapter_type == MFI_SERIES) {
 		if (instance->producer)
 			dma_free_coherent(&instance->pdev->dev, sizeof(u32),
@@ -7683,8 +7664,6 @@ megasas_resume(struct pci_dev *pdev)
 			goto fail_reenable_msix;
 	}
 
-	megasas_setup_reply_map(instance);
-
 	if (instance->adapter_type != MFI_SERIES) {
 		megasas_reset_reply_desc(instance);
 		if (megasas_ioc_init_fusion(instance)) {
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 319f241da4b6..8e25b700988e 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -373,24 +373,24 @@ megasas_get_msix_index(struct megasas_instance *instance,
 {
 	int sdev_busy;
 
-	/* nr_hw_queue = 1 for MegaRAID */
-	struct blk_mq_hw_ctx *hctx =
-		scmd->device->request_queue->queue_hw_ctx[0];
+	struct blk_mq_hw_ctx *hctx = scmd->request->mq_hctx;
 
 	sdev_busy = atomic_read(&hctx->nr_active);
 
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
-		cmd->request_desc->SCSIIO.MSIxIndex =
-			instance->reply_map[raw_smp_processor_id()];
+	} else {
+		u32 tag = blk_mq_unique_tag(scmd->request);
+
+		cmd->request_desc->SCSIIO.MSIxIndex = blk_mq_unique_tag_to_hwq(tag) + instance->low_latency_index_start;
+	}
 }
 
 /**
@@ -3326,7 +3326,7 @@ megasas_build_and_issue_cmd_fusion(struct megasas_instance *instance,
 {
 	struct megasas_cmd_fusion *cmd, *r1_cmd = NULL;
 	union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc;
-	u32 index;
+	u32 index, blk_tag, unique_tag;
 
 	if ((megasas_cmd_type(scmd) == READ_WRITE_LDIO) &&
 		instance->ldio_threshold &&
@@ -3342,7 +3342,9 @@ megasas_build_and_issue_cmd_fusion(struct megasas_instance *instance,
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
-	cmd = megasas_get_cmd_fusion(instance, scmd->request->tag);
+	unique_tag = blk_mq_unique_tag(scmd->request);
+	blk_tag = blk_mq_unique_tag_to_tag(unique_tag);
+	cmd = megasas_get_cmd_fusion(instance, blk_tag);
 
 	if (!cmd) {
 		atomic_dec(&instance->fw_outstanding);
@@ -3383,7 +3385,7 @@ megasas_build_and_issue_cmd_fusion(struct megasas_instance *instance,
 	 */
 	if (cmd->r1_alt_dev_handle != MR_DEVHANDLE_INVALID) {
 		r1_cmd = megasas_get_cmd_fusion(instance,
-				(scmd->request->tag + instance->max_fw_cmds));
+				(blk_tag + instance->max_fw_cmds));
 		megasas_prepare_secondRaid1_IO(instance, cmd, r1_cmd);
 	}
 
-- 
2.26.2

