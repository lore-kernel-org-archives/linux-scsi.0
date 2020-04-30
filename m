Return-Path: <SRS0=Cu6i=6O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 796B4C8300A
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 13:20:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5827F2076D
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 13:20:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgD3NUb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Apr 2020 09:20:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:60754 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726896AbgD3NUK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Apr 2020 09:20:10 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 68704AF3F;
        Thu, 30 Apr 2020 13:20:02 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH RFC v3 25/41] megaraid_sas: use reserved commands
Date:   Thu, 30 Apr 2020 15:18:48 +0200
Message-Id: <20200430131904.5847-26-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200430131904.5847-1-hare@suse.de>
References: <20200430131904.5847-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Implement support for reserved commands to allow the block
layer to track all commands.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/megaraid/megaraid_sas.h        |   8 +-
 drivers/scsi/megaraid/megaraid_sas_base.c   | 142 +++++++++++++++++-----------
 drivers/scsi/megaraid/megaraid_sas_fusion.c |  33 +++----
 3 files changed, 106 insertions(+), 77 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index b47306a66650..bb765e715011 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -2336,7 +2336,6 @@ struct megasas_instance {
 	struct megasas_aen_event *ev;
 
 	struct megasas_cmd **cmd_list;
-	struct list_head cmd_pool;
 	/* used to sync fire the cmd to fw */
 	spinlock_t mfi_pool_lock;
 	/* used to sync fire the cmd to fw */
@@ -2353,6 +2352,7 @@ struct megasas_instance {
 	struct semaphore ioctl_sem;
 
 	struct Scsi_Host *host;
+	struct scsi_device *host_dev;
 
 	wait_queue_head_t int_cmd_wait_q;
 	wait_queue_head_t abort_cmd_wait_q;
@@ -2680,11 +2680,15 @@ void megasas_free_host_crash_buffer(struct megasas_instance *instance);
 int megasas_io_attach(struct megasas_instance *instance);
 void megasas_io_detach(struct megasas_instance *instance);
 
+struct megasas_cmd *megasas_get_cmd(struct megasas_instance *instance,
+	int direction, bool persistent);
+void megasas_complete_cmd(struct megasas_instance *instance,
+	struct megasas_cmd *cmd, u8 alt_status);
 void megasas_return_cmd_fusion(struct megasas_instance *instance,
 	struct megasas_cmd_fusion *cmd);
 int megasas_issue_blocked_cmd(struct megasas_instance *instance,
 	struct megasas_cmd *cmd, int timeout);
-void __megasas_return_cmd(struct megasas_instance *instance,
+void megasas_return_cmd(struct megasas_instance *instance,
 	struct megasas_cmd *cmd);
 
 void megasas_return_mfi_mpt_pthr(struct megasas_instance *instance,
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 8498e6a1d67c..45adfd4b6b07 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -299,26 +299,29 @@ megasas_issue_dcmd(struct megasas_instance *instance, struct megasas_cmd *cmd)
 /**
  * megasas_get_cmd -	Get a command from the free pool
  * @instance:		Adapter soft state
+ * @direction:		DMA direction
+ * @persistent:		Allocate persistent command
  *
  * Returns a free command from the pool
  */
-struct megasas_cmd *megasas_get_cmd(struct megasas_instance
-						  *instance)
+struct megasas_cmd *
+megasas_get_cmd(struct megasas_instance *instance, int direction,
+		bool persistent)
 {
-	unsigned long flags;
+	struct scsi_cmnd *scmd;
 	struct megasas_cmd *cmd = NULL;
+	u32 index;
 
-	spin_lock_irqsave(&instance->mfi_pool_lock, flags);
+	scmd = scsi_get_reserved_cmd(instance->host_dev, direction,
+				     persistent);
+	if (WARN_ON(!scmd))
+		return NULL;
 
-	if (!list_empty(&instance->cmd_pool)) {
-		cmd = list_entry((&instance->cmd_pool)->next,
-				 struct megasas_cmd, list);
-		list_del_init(&cmd->list);
-	} else {
-		dev_err(&instance->pdev->dev, "Command pool empty!\n");
-	}
+	index = scmd->request->tag;
+	cmd = instance->cmd_list[index];
+	WARN_ON(cmd->index != index);
+	cmd->scmd = scmd;
 
-	spin_unlock_irqrestore(&instance->mfi_pool_lock, flags);
 	return cmd;
 }
 
@@ -330,10 +333,10 @@ struct megasas_cmd *megasas_get_cmd(struct megasas_instance
 void
 megasas_return_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd)
 {
-	unsigned long flags;
 	u32 blk_tags;
 	struct megasas_cmd_fusion *cmd_fusion;
 	struct fusion_context *fusion = instance->ctrl_context;
+	struct scsi_cmnd *scmd = cmd->scmd;
 
 	/* This flag is used only for fusion adapter.
 	 * Wait for Interrupt for Polled mode DCMD
@@ -341,8 +344,6 @@ megasas_return_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd)
 	if (cmd->flags & DRV_DCMD_POLLED_MODE)
 		return;
 
-	spin_lock_irqsave(&instance->mfi_pool_lock, flags);
-
 	if (fusion) {
 		blk_tags = instance->max_scsi_cmds + cmd->index;
 		cmd_fusion = fusion->cmd_list[blk_tags];
@@ -355,10 +356,7 @@ megasas_return_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd)
 	cmd->frame->io.context = cpu_to_le32(cmd->index);
 	if (!fusion && reset_devices)
 		cmd->frame->hdr.cmd = MFI_CMD_INVALID;
-	list_add(&cmd->list, (&instance->cmd_pool)->next);
-
-	spin_unlock_irqrestore(&instance->mfi_pool_lock, flags);
-
+	scsi_put_reserved_cmd(scmd);
 }
 
 static const char *
@@ -1169,7 +1167,7 @@ megasas_issue_blocked_abort_cmd(struct megasas_instance *instance,
 	int ret = 0;
 	u32 opcode;
 
-	cmd = megasas_get_cmd(instance);
+	cmd = megasas_get_cmd(instance, DMA_NONE, false);
 
 	if (!cmd)
 		return -1;
@@ -1713,10 +1711,10 @@ megasas_build_and_issue_cmd(struct megasas_instance *instance,
 {
 	struct megasas_cmd *cmd;
 	u32 frame_count;
+	u32 index = scmd->request->tag;
 
-	cmd = megasas_get_cmd(instance);
-	if (!cmd)
-		return SCSI_MLQUEUE_HOST_BUSY;
+	cmd = instance->cmd_list[index];
+	WARN_ON(cmd->index != index);
 
 	/*
 	 * Logical drive command
@@ -2031,6 +2029,9 @@ static int megasas_slave_configure(struct scsi_device *sdev)
 	int ret_target_prop = DCMD_FAILED;
 	bool is_target_prop = false;
 
+	if (scsi_device_is_virtual(sdev))
+		return 0;
+
 	if (instance->pd_list_not_supported) {
 		if (!MEGASAS_IS_LOGICAL(sdev) && sdev->type == TYPE_DISK) {
 			pd_index = (sdev->channel * MEGASAS_MAX_DEV_PER_CHANNEL) +
@@ -2069,6 +2070,9 @@ static int megasas_slave_alloc(struct scsi_device *sdev)
 	struct megasas_instance *instance = shost_priv(sdev->host);
 	struct MR_PRIV_DEVICE *mr_device_priv_data;
 
+	if (scsi_device_is_virtual(sdev))
+		return 0;
+
 	if (!MEGASAS_IS_LOGICAL(sdev)) {
 		/*
 		 * Open the OS scan to the SYSTEM PD
@@ -2296,7 +2300,7 @@ static int megasas_get_ld_vf_affiliation_111(struct megasas_instance *instance,
 	int ld, retval = 0;
 	u8 thisVf;
 
-	cmd = megasas_get_cmd(instance);
+	cmd = megasas_get_cmd(instance, DMA_FROM_DEVICE, false);
 
 	if (!cmd) {
 		dev_printk(KERN_DEBUG, &instance->pdev->dev, "megasas_get_ld_vf_affiliation_111:"
@@ -2403,7 +2407,7 @@ static int megasas_get_ld_vf_affiliation_12(struct megasas_instance *instance,
 	int i, j, retval = 0, found = 0, doscan = 0;
 	u8 thisVf;
 
-	cmd = megasas_get_cmd(instance);
+	cmd = megasas_get_cmd(instance, DMA_FROM_DEVICE, false);
 
 	if (!cmd) {
 		dev_printk(KERN_DEBUG, &instance->pdev->dev, "megasas_get_ld_vf_affiliation12: "
@@ -2578,7 +2582,7 @@ int megasas_sriov_start_heartbeat(struct megasas_instance *instance,
 	struct megasas_dcmd_frame *dcmd;
 	int retval = 0;
 
-	cmd = megasas_get_cmd(instance);
+	cmd = megasas_get_cmd(instance, DMA_TO_DEVICE, false);
 
 	if (!cmd) {
 		dev_printk(KERN_DEBUG, &instance->pdev->dev, "megasas_sriov_start_heartbeat: "
@@ -4286,8 +4290,6 @@ void megasas_free_cmds(struct megasas_instance *instance)
 	/* Free the cmd_list buffer itself */
 	kfree(instance->cmd_list);
 	instance->cmd_list = NULL;
-
-	INIT_LIST_HEAD(&instance->cmd_pool);
 }
 
 /**
@@ -4305,8 +4307,6 @@ void megasas_free_cmds(struct megasas_instance *instance)
  * the context. But we wanted to keep the differences between 32 and 64 bit
  * systems to the mininum. We always use 32 bit integers for the context. In
  * this driver, the 32 bit values are the indices into an array cmd_list.
- * This array is used only to look up the megasas_cmd given the context. The
- * free commands themselves are maintained in a linked list called cmd_pool.
  */
 int megasas_alloc_cmds(struct megasas_instance *instance)
 {
@@ -4353,8 +4353,6 @@ int megasas_alloc_cmds(struct megasas_instance *instance)
 		cmd->index = i;
 		cmd->scmd = NULL;
 		cmd->instance = instance;
-
-		list_add_tail(&cmd->list, &instance->cmd_pool);
 	}
 
 	/*
@@ -4400,7 +4398,7 @@ megasas_get_pd_info(struct megasas_instance *instance, struct scsi_device *sdev)
 	u16 device_id = 0;
 
 	device_id = (sdev->channel * MEGASAS_MAX_DEV_PER_CHANNEL) + sdev->id;
-	cmd = megasas_get_cmd(instance);
+	cmd = megasas_get_cmd(instance, DMA_FROM_DEVICE, false);
 
 	if (!cmd) {
 		dev_err(&instance->pdev->dev, "Failed to get cmd %s\n", __func__);
@@ -4492,7 +4490,7 @@ megasas_get_pd_list(struct megasas_instance *instance)
 
 	ci = instance->pd_list_buf;
 
-	cmd = megasas_get_cmd(instance);
+	cmd = megasas_get_cmd(instance, DMA_FROM_DEVICE, false);
 
 	if (!cmd) {
 		dev_printk(KERN_DEBUG, &instance->pdev->dev, "(get_pd_list): Failed to get cmd\n");
@@ -4623,7 +4621,7 @@ megasas_get_ld_list(struct megasas_instance *instance)
 	ci = instance->ld_list_buf;
 	ci_h = instance->ld_list_buf_h;
 
-	cmd = megasas_get_cmd(instance);
+	cmd = megasas_get_cmd(instance, DMA_FROM_DEVICE, false);
 
 	if (!cmd) {
 		dev_printk(KERN_DEBUG, &instance->pdev->dev, "megasas_get_ld_list: Failed to get cmd\n");
@@ -4740,7 +4738,7 @@ megasas_ld_list_query(struct megasas_instance *instance, u8 query_type)
 	ci = instance->ld_targetid_list_buf;
 	ci_h = instance->ld_targetid_list_buf_h;
 
-	cmd = megasas_get_cmd(instance);
+	cmd = megasas_get_cmd(instance, DMA_FROM_DEVICE, false);
 
 	if (!cmd) {
 		dev_warn(&instance->pdev->dev,
@@ -4861,7 +4859,7 @@ megasas_host_device_list_query(struct megasas_instance *instance,
 	ci = instance->host_device_list_buf;
 	ci_h = instance->host_device_list_buf_h;
 
-	cmd = megasas_get_cmd(instance);
+	cmd = megasas_get_cmd(instance, DMA_FROM_DEVICE, false);
 
 	if (!cmd) {
 		dev_warn(&instance->pdev->dev,
@@ -5049,7 +5047,7 @@ void megasas_get_snapdump_properties(struct megasas_instance *instance)
 	if (!ci)
 		return;
 
-	cmd = megasas_get_cmd(instance);
+	cmd = megasas_get_cmd(instance, DMA_FROM_DEVICE, false);
 
 	if (!cmd) {
 		dev_dbg(&instance->pdev->dev, "Failed to get a free cmd\n");
@@ -5131,7 +5129,7 @@ megasas_get_ctrl_info(struct megasas_instance *instance)
 	ci = instance->ctrl_info_buf;
 	ci_h = instance->ctrl_info_buf_h;
 
-	cmd = megasas_get_cmd(instance);
+	cmd = megasas_get_cmd(instance, DMA_FROM_DEVICE, false);
 
 	if (!cmd) {
 		dev_printk(KERN_DEBUG, &instance->pdev->dev, "Failed to get a free cmd\n");
@@ -5280,7 +5278,7 @@ int megasas_set_crash_dump_params(struct megasas_instance *instance,
 	struct megasas_cmd *cmd;
 	struct megasas_dcmd_frame *dcmd;
 
-	cmd = megasas_get_cmd(instance);
+	cmd = megasas_get_cmd(instance, DMA_NONE, false);
 
 	if (!cmd) {
 		dev_err(&instance->pdev->dev, "Failed to get a free cmd\n");
@@ -5355,7 +5353,7 @@ megasas_issue_init_mfi(struct megasas_instance *instance)
 	 *
 	 * We will not get a NULL command below. We just created the pool.
 	 */
-	cmd = megasas_get_cmd(instance);
+	cmd = megasas_get_cmd(instance, DMA_TO_DEVICE, false);
 
 	init_frame = (struct megasas_init_frame *)cmd->frame;
 	initq_info = (struct megasas_init_queue_info *)
@@ -5441,7 +5439,7 @@ megasas_init_adapter_mfi(struct megasas_instance *instance)
 		sema_init(&instance->ioctl_sem, (MEGASAS_MFI_IOCTL_CMDS));
 	}
 
-	instance->cur_can_queue = instance->max_scsi_cmds;
+	instance->cur_can_queue = instance->max_fw_cmds - 1;
 	/*
 	 * Create a pool of commands
 	 */
@@ -6451,7 +6449,7 @@ megasas_get_seq_num(struct megasas_instance *instance,
 	dma_addr_t el_info_h = 0;
 	int ret;
 
-	cmd = megasas_get_cmd(instance);
+	cmd = megasas_get_cmd(instance, DMA_FROM_DEVICE, false);
 
 	if (!cmd) {
 		return -ENOMEM;
@@ -6513,7 +6511,7 @@ megasas_prepare_aen(struct megasas_instance *instance, u32 seq_num,
 	struct megasas_cmd *cmd;
 	struct megasas_dcmd_frame *dcmd;
 
-	cmd = megasas_get_cmd(instance);
+	cmd = megasas_get_cmd(instance, DMA_FROM_DEVICE, true);
 	if (!cmd)
 		return NULL;
 
@@ -6674,7 +6672,7 @@ megasas_get_target_prop(struct megasas_instance *instance,
 	u16 targetId = ((sdev->channel % 2) * MEGASAS_MAX_DEV_PER_CHANNEL) +
 			sdev->id;
 
-	cmd = megasas_get_cmd(instance);
+	cmd = megasas_get_cmd(instance, DMA_FROM_DEVICE, false);
 
 	if (!cmd) {
 		dev_err(&instance->pdev->dev,
@@ -6781,7 +6779,9 @@ int megasas_io_attach(struct megasas_instance *instance)
 	/*
 	 * Export parameters required by SCSI mid-layer
 	 */
-	host->can_queue = instance->max_scsi_cmds;
+	host->can_queue = instance->max_fw_cmds;
+	host->nr_reserved_cmds =
+		host->can_queue - instance->max_scsi_cmds;
 	host->sg_tablesize = instance->max_num_sge;
 
 	/* Will be adjusted later */
@@ -6803,6 +6803,15 @@ int megasas_io_attach(struct megasas_instance *instance)
 		return -ENODEV;
 	}
 
+	instance->host_dev = scsi_get_virtual_dev(host,
+				MEGASAS_MAX_CHANNELS, 0);
+	if (!instance->host_dev) {
+		dev_err(&instance->pdev->dev,
+			"Failed to add host dev from %s %d\n",
+			__func__, __LINE__);
+		scsi_remove_host(host);
+		return -ENODEV;
+	}
 	return 0;
 }
 
@@ -6812,6 +6821,10 @@ int megasas_io_attach(struct megasas_instance *instance)
  */
 void megasas_io_detach(struct megasas_instance *instance)
 {
+	if (instance->host_dev) {
+		scsi_free_host_dev(instance->host_dev);
+		instance->host_dev = NULL;
+	}
 	scsi_remove_host(instance->host);
 }
 
@@ -7248,7 +7261,6 @@ static inline void megasas_init_ctrl_params(struct megasas_instance *instance)
 	/*
 	 * Initialize locks and queues
 	 */
-	INIT_LIST_HEAD(&instance->cmd_pool);
 	INIT_LIST_HEAD(&instance->internal_reset_pending_q);
 
 	atomic_set(&instance->fw_outstanding, 0);
@@ -7458,7 +7470,7 @@ static void megasas_flush_cache(struct megasas_instance *instance)
 	if (atomic_read(&instance->adprecovery) == MEGASAS_HW_CRITICAL_ERROR)
 		return;
 
-	cmd = megasas_get_cmd(instance);
+	cmd = megasas_get_cmd(instance, DMA_NONE, false);
 
 	if (!cmd)
 		return;
@@ -7497,24 +7509,42 @@ static void megasas_shutdown_controller(struct megasas_instance *instance,
 {
 	struct megasas_cmd *cmd;
 	struct megasas_dcmd_frame *dcmd;
+	int ret;
 
 	if (atomic_read(&instance->adprecovery) == MEGASAS_HW_CRITICAL_ERROR)
 		return;
 
-	cmd = megasas_get_cmd(instance);
+	cmd = megasas_get_cmd(instance, DMA_NONE, false);
 
 	if (!cmd)
 		return;
 
-	if (instance->aen_cmd)
-		megasas_issue_blocked_abort_cmd(instance,
+	if (instance->aen_cmd) {
+		ret = megasas_issue_blocked_abort_cmd(instance,
 			instance->aen_cmd, MFI_IO_TIMEOUT_SECS);
-	if (instance->map_update_cmd)
-		megasas_issue_blocked_abort_cmd(instance,
+		if (ret != DCMD_SUCCESS)
+			dev_err(&instance->pdev->dev,
+				"Failed to abort AEN command, ret=%d\n", ret);
+		instance->aen_cmd = NULL;
+	}
+	if (instance->map_update_cmd) {
+		ret = megasas_issue_blocked_abort_cmd(instance,
 			instance->map_update_cmd, MFI_IO_TIMEOUT_SECS);
-	if (instance->jbod_seq_cmd)
-		megasas_issue_blocked_abort_cmd(instance,
+		if (ret != DCMD_SUCCESS)
+			dev_err(&instance->pdev->dev,
+				"Failed to abort map update command, ret=%d\n",
+				ret);
+		instance->map_update_cmd = NULL;
+	}
+	if (instance->jbod_seq_cmd) {
+		ret = megasas_issue_blocked_abort_cmd(instance,
 			instance->jbod_seq_cmd, MFI_IO_TIMEOUT_SECS);
+		if (ret != DCMD_SUCCESS)
+			dev_err(&instance->pdev->dev,
+				"Failed to abort jbod seq command, ret=%d\n",
+				ret);
+		instance->jbod_seq_cmd = NULL;
+	}
 
 	dcmd = &cmd->frame->dcmd;
 
@@ -8096,7 +8126,7 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
 		return -ENOTSUPP;
 	}
 
-	cmd = megasas_get_cmd(instance);
+	cmd = megasas_get_cmd(instance, DMA_BIDIRECTIONAL, false);
 	if (!cmd) {
 		dev_printk(KERN_DEBUG, &instance->pdev->dev, "Failed to get a cmd packet\n");
 		return -ENOMEM;
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 483146051957..f5915c9f474c 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -49,17 +49,10 @@
 
 
 extern void megasas_free_cmds(struct megasas_instance *instance);
-extern struct megasas_cmd *megasas_get_cmd(struct megasas_instance
-					   *instance);
-extern void
-megasas_complete_cmd(struct megasas_instance *instance,
-		     struct megasas_cmd *cmd, u8 alt_status);
 int
 wait_and_poll(struct megasas_instance *instance, struct megasas_cmd *cmd,
 	      int seconds);
 
-void
-megasas_return_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd);
 int megasas_alloc_cmds(struct megasas_instance *instance);
 int
 megasas_clear_intr_fusion(struct megasas_instance *instance);
@@ -343,10 +336,11 @@ megasas_fusion_update_can_queue(struct megasas_instance *instance, int fw_boot_c
 	if (fw_boot_context == OCR_CONTEXT) {
 		cur_max_fw_cmds = cur_max_fw_cmds - 1;
 		if (cur_max_fw_cmds < instance->max_fw_cmds) {
-			instance->cur_can_queue =
-				cur_max_fw_cmds - (MEGASAS_FUSION_INTERNAL_CMDS +
-						MEGASAS_FUSION_IOCTL_CMDS);
+			instance->cur_can_queue = cur_max_fw_cmds;
 			instance->host->can_queue = instance->cur_can_queue;
+			instance->host->nr_reserved_cmds =
+				MEGASAS_FUSION_INTERNAL_CMDS +
+				MEGASAS_FUSION_IOCTL_CMDS;
 			instance->ldio_threshold = ldio_threshold;
 		}
 	} else {
@@ -1291,7 +1285,8 @@ megasas_sync_pd_seq_num(struct megasas_instance *instance, bool pend) {
 	pd_seq_h = fusion->pd_seq_phys[(instance->pd_seq_map_id & 1)];
 	pd_seq_map_sz = struct_size(pd_sync, seq, MAX_PHYSICAL_DEVICES - 1);
 
-	cmd = megasas_get_cmd(instance);
+	cmd = megasas_get_cmd(instance,
+		pend ? DMA_TO_DEVICE : DMA_FROM_DEVICE, pend);
 	if (!cmd) {
 		dev_err(&instance->pdev->dev,
 			"Could not get mfi cmd. Fail from %s %d\n",
@@ -1379,10 +1374,11 @@ megasas_get_ld_map_info(struct megasas_instance *instance)
 	u32 size_map_info;
 	struct fusion_context *fusion;
 
-	cmd = megasas_get_cmd(instance);
+	cmd = megasas_get_cmd(instance, DMA_FROM_DEVICE, false);
 
 	if (!cmd) {
-		dev_printk(KERN_DEBUG, &instance->pdev->dev, "Failed to get cmd for map info\n");
+		dev_printk(KERN_DEBUG, &instance->pdev->dev,
+			   "Failed to get cmd for map info\n");
 		return -ENOMEM;
 	}
 
@@ -1473,13 +1469,13 @@ megasas_sync_map_info(struct megasas_instance *instance)
 	dma_addr_t ci_h = 0;
 	u32 size_map_info;
 
-	cmd = megasas_get_cmd(instance);
+	cmd = megasas_get_cmd(instance, DMA_TO_DEVICE, true);
 
 	if (!cmd) {
-		dev_printk(KERN_DEBUG, &instance->pdev->dev, "Failed to get cmd for sync info\n");
+		dev_printk(KERN_DEBUG, &instance->pdev->dev,
+			   "Failed to get cmd for sync info\n");
 		return -ENOMEM;
 	}
-
 	fusion = instance->ctrl_context;
 
 	if (!fusion) {
@@ -1699,8 +1695,7 @@ void megasas_configure_queue_sizes(struct megasas_instance *instance)
 		instance->max_mpt_cmds = instance->max_fw_cmds;
 
 	instance->max_scsi_cmds = instance->max_fw_cmds - instance->max_mfi_cmds;
-	instance->cur_can_queue = instance->max_scsi_cmds;
-	instance->host->can_queue = instance->cur_can_queue;
+	instance->cur_can_queue = instance->max_fw_cmds;
 
 	fusion->reply_q_depth = 2 * ((max_cmd + 1 + 15) / 16) * 16;
 
@@ -4477,7 +4472,7 @@ megasas_issue_tm(struct megasas_instance *instance, u16 device_handle,
 
 	fusion = instance->ctrl_context;
 
-	cmd_mfi = megasas_get_cmd(instance);
+	cmd_mfi = megasas_get_cmd(instance, DMA_NONE, false);
 
 	if (!cmd_mfi) {
 		dev_err(&instance->pdev->dev, "Failed from %s %d\n",
-- 
2.16.4

