Return-Path: <SRS0=XqvZ=B5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72865C433E3
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Aug 2020 15:27:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5835420897
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Aug 2020 15:27:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728802AbgHSP1W (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Aug 2020 11:27:22 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:9783 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726636AbgHSPZI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 19 Aug 2020 11:25:08 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 7F5A234F37896C527B4D;
        Wed, 19 Aug 2020 23:25:03 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Wed, 19 Aug 2020 23:24:53 +0800
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <don.brace@microsemi.com>,
        <kashyap.desai@broadcom.com>, <ming.lei@redhat.com>,
        <bvanassche@acm.org>, <dgilbert@interlog.com>,
        <paolo.valente@linaro.org>, <hare@suse.de>, <hch@lst.de>
CC:     <sumit.saxena@broadcom.com>, <linux-block@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <esc.storagedev@microsemi.com>, <megaraidlinux.pdl@broadcom.com>,
        <chenxiang66@hisilicon.com>, <luojiaxing@huawei.com>,
        Hannes Reinecke <hare@suse.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH v8 17/18] scsi: megaraid_sas: Added support for shared host tagset for cpuhotplug
Date:   Wed, 19 Aug 2020 23:20:35 +0800
Message-ID: <1597850436-116171-18-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1597850436-116171-1-git-send-email-john.garry@huawei.com>
References: <1597850436-116171-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Kashyap Desai <kashyap.desai@broadcom.com>

Fusion adapters can steer completions to individual queues, and
we now have support for shared host-wide tags.
So we can enable multiqueue support for fusion adapters.

Once driver enable shared host-wide tags, cpu hotplug feature is also
supported as it was enabled using below patchsets -
commit bf0beec0607d ("blk-mq: drain I/O when all CPUs in a hctx are
offline")

Currently driver has provision to disable host-wide tags using
"host_tagset_enable" module parameter.

Once we do not have any major performance regression using host-wide
tags, we will drop the hand-crafted interrupt affinity settings.

Performance is also meeting the expecatation - (used both none and
mq-deadline scheduler)
24 Drive SSD on Aero with/without this patch can get 3.1M IOPs
3 VDs consist of 8 SAS SSD on Aero with/without this patch can get 3.1M
IOPs.

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Hannes Reinecke <hare@suse.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c   | 39 +++++++++++++++++++++
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 29 ++++++++-------
 2 files changed, 55 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 861f7140f52e..6960922d0d7f 100644
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
index 0824410f78f8..a4251121f173 100644
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
-- 
2.26.2

