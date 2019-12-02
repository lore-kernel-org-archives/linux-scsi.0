Return-Path: <SRS0=lopX=ZY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6043C33C99
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Dec 2019 15:39:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BFE52084F
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Dec 2019 15:39:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727602AbfLBPjd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Dec 2019 10:39:33 -0500
Received: from mx2.suse.de ([195.135.220.15]:44836 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727566AbfLBPjb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 2 Dec 2019 10:39:31 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0D881C1A9;
        Mon,  2 Dec 2019 15:39:26 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH 09/11] megaraid_sas: switch fusion adapters to MQ
Date:   Mon,  2 Dec 2019 16:39:12 +0100
Message-Id: <20191202153914.84722-10-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191202153914.84722-1-hare@suse.de>
References: <20191202153914.84722-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fusion adapters can steer completions to individual queues, and
we now have support for shared host-wide tags.
So we can enable multiqueue support for fusion adapters and
drop the hand-crafted interrupt affinity settings.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/megaraid/megaraid_sas.h        |  1 -
 drivers/scsi/megaraid/megaraid_sas_base.c   | 65 +++++++++--------------------
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 14 ++++---
 3 files changed, 28 insertions(+), 52 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index bd8184072bed..844ea2d6dbb8 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -2261,7 +2261,6 @@ enum MR_PERF_MODE {
 
 struct megasas_instance {
 
-	unsigned int *reply_map;
 	__le32 *producer;
 	dma_addr_t producer_h;
 	__le32 *consumer;
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index a4bc81479284..9d0d74e3d491 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -37,6 +37,7 @@
 #include <linux/poll.h>
 #include <linux/vmalloc.h>
 #include <linux/irq_poll.h>
+#include <linux/blk-mq-pci.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -3106,6 +3107,19 @@ megasas_bios_param(struct scsi_device *sdev, struct block_device *bdev,
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
@@ -3414,9 +3428,11 @@ static struct scsi_host_template megasas_template = {
 	.eh_timed_out = megasas_reset_timer,
 	.shost_attrs = megaraid_host_attrs,
 	.bios_param = megasas_bios_param,
+	.map_queues = megasas_map_queues,
 	.change_queue_depth = scsi_change_queue_depth,
 	.max_segment_size = 0xffffffff,
 	.no_write_same = 1,
+	.host_tagset = 1,
 };
 
 /**
@@ -5695,34 +5711,6 @@ megasas_setup_jbod_map(struct megasas_instance *instance)
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
@@ -6021,12 +6009,6 @@ static int megasas_init_fw(struct megasas_instance *instance)
 					instance->is_rdpq = (scratch_pad_1 & MR_RDPQ_MODE_OFFSET) ?
 								1 : 0;
 
-				if (instance->adapter_type >= INVADER_SERIES &&
-				    !instance->msix_combined) {
-					instance->msix_load_balance = true;
-					instance->smp_affinity_enable = false;
-				}
-
 				/* Save 1-15 reply post index address to local memory
 				 * Index 0 is already saved from reg offset
 				 * MPI2_REPLY_POST_HOST_INDEX_OFFSET
@@ -6145,8 +6127,6 @@ static int megasas_init_fw(struct megasas_instance *instance)
 			goto fail_init_adapter;
 	}
 
-	megasas_setup_reply_map(instance);
-
 	dev_info(&instance->pdev->dev,
 		"current msix/online cpus\t: (%d/%d)\n",
 		instance->msix_vectors, (unsigned int)num_online_cpus());
@@ -6780,6 +6760,9 @@ static int megasas_io_attach(struct megasas_instance *instance)
 	host->max_id = MEGASAS_MAX_DEV_PER_CHANNEL;
 	host->max_lun = MEGASAS_MAX_LUN;
 	host->max_cmd_len = 16;
+	if (instance->adapter_type != MFI_SERIES && instance->msix_vectors > 0)
+		host->nr_hw_queues = instance->msix_vectors -
+			instance->low_latency_index_start;
 
 	/*
 	 * Notify the mid-layer about the new controller
@@ -6947,11 +6930,6 @@ static inline int megasas_alloc_mfi_ctrl_mem(struct megasas_instance *instance)
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
@@ -6968,8 +6946,6 @@ static int megasas_alloc_ctrl_mem(struct megasas_instance *instance)
 
 	return 0;
  fail:
-	kfree(instance->reply_map);
-	instance->reply_map = NULL;
 	return -ENOMEM;
 }
 
@@ -6982,7 +6958,6 @@ static int megasas_alloc_ctrl_mem(struct megasas_instance *instance)
  */
 static inline void megasas_free_ctrl_mem(struct megasas_instance *instance)
 {
-	kfree(instance->reply_map);
 	if (instance->adapter_type == MFI_SERIES) {
 		if (instance->producer)
 			dma_free_coherent(&instance->pdev->dev, sizeof(u32),
@@ -7645,8 +7620,6 @@ megasas_resume(struct pci_dev *pdev)
 	if (rval < 0)
 		goto fail_reenable_msix;
 
-	megasas_setup_reply_map(instance);
-
 	if (instance->adapter_type != MFI_SERIES) {
 		megasas_reset_reply_desc(instance);
 		if (megasas_ioc_init_fusion(instance)) {
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index e301458bcbae..bae96b82bb10 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -2731,6 +2731,7 @@ megasas_build_ldio_fusion(struct megasas_instance *instance,
 	struct MR_PRIV_DEVICE *mrdev_priv;
 	struct RAID_CONTEXT *rctx;
 	struct RAID_CONTEXT_G35 *rctx_g35;
+	u32 tag = blk_mq_unique_tag(scp->request);
 
 	device_id = MEGASAS_DEV_INDEX(scp);
 
@@ -2837,7 +2838,7 @@ megasas_build_ldio_fusion(struct megasas_instance *instance,
 				    instance->msix_vectors));
 	else
 		cmd->request_desc->SCSIIO.MSIxIndex =
-			instance->reply_map[raw_smp_processor_id()];
+			blk_mq_unique_tag_to_hwq(tag);
 
 	if (instance->adapter_type >= VENTURA_SERIES) {
 		/* FP for Optimal raid level 1.
@@ -3080,6 +3081,7 @@ megasas_build_syspd_fusion(struct megasas_instance *instance,
 	u16 pd_index = 0;
 	u16 os_timeout_value;
 	u16 timeout_limit;
+	u32 tag = blk_mq_unique_tag(scmd->request);
 	struct MR_DRV_RAID_MAP_ALL *local_map_ptr;
 	struct RAID_CONTEXT	*pRAID_Context;
 	struct MR_PD_CFG_SEQ_NUM_SYNC *pd_sync;
@@ -3169,7 +3171,7 @@ megasas_build_syspd_fusion(struct megasas_instance *instance,
 				    instance->msix_vectors));
 	else
 		cmd->request_desc->SCSIIO.MSIxIndex =
-			instance->reply_map[raw_smp_processor_id()];
+			blk_mq_unique_tag_to_hwq(tag);
 
 	if (!fp_possible) {
 		/* system pd firmware path */
@@ -3373,7 +3375,7 @@ megasas_build_and_issue_cmd_fusion(struct megasas_instance *instance,
 {
 	struct megasas_cmd_fusion *cmd, *r1_cmd = NULL;
 	union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc;
-	u32 index;
+	u32 index, blk_tag, unique_tag;
 
 	if ((megasas_cmd_type(scmd) == READ_WRITE_LDIO) &&
 		instance->ldio_threshold &&
@@ -3389,7 +3391,9 @@ megasas_build_and_issue_cmd_fusion(struct megasas_instance *instance,
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
-	cmd = megasas_get_cmd_fusion(instance, scmd->request->tag);
+	unique_tag = blk_mq_unique_tag(scmd->request);
+	blk_tag = blk_mq_unique_tag_to_tag(unique_tag);
+	cmd = megasas_get_cmd_fusion(instance, blk_tag);
 
 	if (!cmd) {
 		atomic_dec(&instance->fw_outstanding);
@@ -3430,7 +3434,7 @@ megasas_build_and_issue_cmd_fusion(struct megasas_instance *instance,
 	 */
 	if (cmd->r1_alt_dev_handle != MR_DEVHANDLE_INVALID) {
 		r1_cmd = megasas_get_cmd_fusion(instance,
-				(scmd->request->tag + instance->max_fw_cmds));
+				(blk_tag + instance->max_fw_cmds));
 		megasas_prepare_secondRaid1_IO(instance, cmd, r1_cmd);
 	}
 
-- 
2.16.4

