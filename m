From: <Sumit.Saxena@avagotech.com>
Subject: [PATCH 2/5] megaraid_sas : Use Block layer tag support for
 internal command indexing
Date: Fri, 27 Mar 2015 17:25:27 +0530
Message-ID: <201503271157.t2RBuwjB032275@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0068.outbound.protection.outlook.com ([207.46.100.68]:3840
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752446AbbC0MLZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Mar 2015 08:11:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com

megaraid_sas driver will use block layer provided tag for indexing internal MPT frames to get any unique MPT frame tied with tag.
Each IO request submitted from SCSI mid layer will get associated MPT frame from MPT framepool (retrieved and return back using spinlock
inside megaraid_sas driver's submission/completion call back). Getting MPT frame from MPT Frame pool is very expensive operation because 
of associated spin lock operation (spinlock overhead increase on multi NUMA node). This type of locking in driver is very expensive
call considering each IO request need - Acquire and Release of the same lock.

With this support, in IO path driver will directly provide the unique command index(which is based on block layer tag)
and will get the MPT frame tied to the tag and this way driver can get rid off lock, which synchronizes the access to MPT frame pool 
while fetching and returning MPT frame from the pool.

This support in driver provides siginificant performance improvement(on multi NUMA node system)on latest upstream with SCSI.MQ
as well as on existing linux distributions.
Here is the data for test executed at Avago-
- IO Tool- FIO
- 4 Socket SMC server. (4 NUMA node server)
- 12 SSDs in JBOD mode .
- 4K Rand READ, QD=32
- SCSI MQ x86_64 (Latest Upstream kernel)
- upto 300% Performance Improvement.

If IOs are running on single Node, perfromance gain is less, but as soon as increase number of nodes, performance improvement
is significant. IOs running on all 4 NUMA nodes, with this patch applied IOPs observed was  1170K vs 344K IOPs seen without this patch.

Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
---
 drivers/scsi/megaraid/megaraid_sas.h        |   15 +--
 drivers/scsi/megaraid/megaraid_sas_base.c   |  182 +++++++++---------------
 drivers/scsi/megaraid/megaraid_sas_fusion.c |  199 ++++++++++++---------------
 drivers/scsi/megaraid/megaraid_sas_fusion.h |    6 +-
 4 files changed, 165 insertions(+), 237 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index bdcf2b6..e9a0820 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -153,6 +153,11 @@
 #define MFI_FRAME_DIR_BOTH			0x0018
 #define MFI_FRAME_IEEE                          0x0020
 
+/* Driver internal */
+#define DRV_DCMD_POLLED_MODE		0x1
+#define	BLK_TAG_DEBUG			0
+#define	BLK_TAG_REFCOUNT		0
+
 /*
  * Definition for cmd_status
  */
@@ -1042,11 +1047,6 @@ struct megasas_ctrl_info {
 
 #define VD_EXT_DEBUG 0
 
-enum MR_MFI_MPT_PTHR_FLAGS {
-	MFI_MPT_DETACHED = 0,
-	MFI_LIST_ADDED = 1,
-	MFI_MPT_ATTACHED = 2,
-};
 
 enum MR_SCSI_CMD_TYPE {
 	READ_WRITE_LDIO = 0,
@@ -1888,10 +1888,7 @@ struct megasas_cmd {
 
 	struct list_head list;
 	struct scsi_cmnd *scmd;
-
-	void *mpt_pthr_cmd_blocked;
-	atomic_t mfi_mpt_pthr;
-	u8 is_wait_event;
+	u8 flags;
 
 	struct megasas_instance *instance;
 	union {
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index a949f44..b549445 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -215,7 +215,6 @@ struct megasas_cmd *megasas_get_cmd(struct megasas_instance
 		cmd = list_entry((&instance->cmd_pool)->next,
 				 struct megasas_cmd, list);
 		list_del_init(&cmd->list);
-		atomic_set(&cmd->mfi_mpt_pthr, MFI_MPT_DETACHED);
 	} else {
 		printk(KERN_ERR "megasas: Command pool empty!\n");
 	}
@@ -225,52 +224,47 @@ struct megasas_cmd *megasas_get_cmd(struct megasas_instance
 }
 
 /**
- * __megasas_return_cmd -	Return a cmd to free command pool
+ * megasas_return_cmd -	Return a cmd to free command pool
  * @instance:		Adapter soft state
  * @cmd:		Command packet to be returned to free command pool
  */
 inline void
-__megasas_return_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd)
+megasas_return_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd)
 {
-	/*
-	 * Don't go ahead and free the MFI frame, if corresponding
-	 * MPT frame is not freed(valid for only fusion adapters).
-	 * In case of MFI adapters, anyways for any allocated MFI
-	 * frame will have cmd->mfi_mpt_mpthr set to MFI_MPT_DETACHED
+	unsigned long flags;
+	u32 blk_tags;
+	struct megasas_cmd_fusion *cmd_fusion;
+	struct fusion_context *fusion = instance->ctrl_context;
+
+	/* This flag is used only for fusion adapter.
+	 * Wait for Interrupt for Polled mode DCMD
 	 */
-	if (atomic_read(&cmd->mfi_mpt_pthr) != MFI_MPT_DETACHED)
+	if (cmd->flags & DRV_DCMD_POLLED_MODE)
 		return;
 
+	spin_lock_irqsave(&instance->mfi_pool_lock, flags);
+
+	if (fusion) {
+		blk_tags = instance->max_scsi_cmds + cmd->index;
+#if BLK_TAG_DEBUG
+		dev_info(&instance->pdev->dev,
+			"%s : opcode (0x%08x) tag (%04d) cmd flags (0x%08x)\n",
+				__func__, le32_to_cpu(cmd->frame->dcmd.opcode),
+				blk_tags, cmd->flags);
+#endif
+		cmd_fusion = fusion->cmd_list[blk_tags];
+		megasas_return_cmd_fusion(instance, cmd_fusion);
+	}
 	cmd->scmd = NULL;
 	cmd->frame_count = 0;
-	cmd->is_wait_event = 0;
-	cmd->mpt_pthr_cmd_blocked = NULL;
-
-	if ((instance->pdev->device != PCI_DEVICE_ID_LSI_FUSION) &&
-	    (instance->pdev->device != PCI_DEVICE_ID_LSI_INVADER) &&
-	    (instance->pdev->device != PCI_DEVICE_ID_LSI_FURY) &&
-	    (reset_devices))
+	cmd->flags = 0;
+	if (!fusion && reset_devices)
 		cmd->frame->hdr.cmd = MFI_CMD_INVALID;
-
-	atomic_set(&cmd->mfi_mpt_pthr, MFI_LIST_ADDED);
 	list_add(&cmd->list, (&instance->cmd_pool)->next);
-}
-
-/**
- * megasas_return_cmd -	Return a cmd to free command pool
- * @instance:		Adapter soft state
- * @cmd:		Command packet to be returned to free command pool
- */
-inline void
-megasas_return_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd)
-{
-	unsigned long flags;
 
-	spin_lock_irqsave(&instance->mfi_pool_lock, flags);
-	__megasas_return_cmd(instance, cmd);
 	spin_unlock_irqrestore(&instance->mfi_pool_lock, flags);
-}
 
+}
 
 /**
 *	The following functions are defined for xscale
@@ -954,7 +948,6 @@ megasas_issue_blocked_cmd(struct megasas_instance *instance,
 	int ret = 0;
 	cmd->cmd_status = ENODATA;
 
-	cmd->is_wait_event = 1;
 	instance->instancet->issue_dcmd(instance, cmd);
 	if (timeout) {
 		ret = wait_event_timeout(instance->int_cmd_wait_q,
@@ -1668,6 +1661,10 @@ static int megasas_slave_configure(struct scsi_device *sdev)
 	blk_queue_rq_timeout(sdev->request_queue,
 		MEGASAS_DEFAULT_CMD_TIMEOUT * HZ);
 
+	sdev_printk(KERN_INFO, sdev, "qdepth(%d), tagged(%d), "
+		"scsi_level(%d), cmd_que(%d)\n", sdev->queue_depth,
+		sdev->tagged_supported, sdev->scsi_level,
+		(sdev->inquiry[7] & 2) >> 1);
 	return 0;
 }
 
@@ -1976,11 +1973,7 @@ out:
 				    new_affiliation_111_h);
 	}
 
-	if (instance->ctrl_context && cmd->mpt_pthr_cmd_blocked)
-		megasas_return_mfi_mpt_pthr(instance, cmd,
-			cmd->mpt_pthr_cmd_blocked);
-	else
-		megasas_return_cmd(instance, cmd);
+	megasas_return_cmd(instance, cmd);
 
 	return retval;
 }
@@ -2147,11 +2140,7 @@ out:
 				    (MAX_LOGICAL_DRIVES + 1) *
 				    sizeof(struct MR_LD_VF_AFFILIATION),
 				    new_affiliation, new_affiliation_h);
-	if (instance->ctrl_context && cmd->mpt_pthr_cmd_blocked)
-		megasas_return_mfi_mpt_pthr(instance, cmd,
-			cmd->mpt_pthr_cmd_blocked);
-	else
-		megasas_return_cmd(instance, cmd);
+	megasas_return_cmd(instance, cmd);
 
 	return retval;
 }
@@ -2219,9 +2208,13 @@ int megasas_sriov_start_heartbeat(struct megasas_instance *instance,
 	printk(KERN_WARNING "megasas: SR-IOV: Starting heartbeat for scsi%d\n",
 	       instance->host->host_no);
 
-	if (!megasas_issue_polled(instance, cmd)) {
-		retval = 0;
-	} else {
+	if (instance->ctrl_context && !instance->mask_interrupts)
+		retval = megasas_issue_blocked_cmd(instance, cmd,
+			MEGASAS_ROUTINE_WAIT_TIME_VF);
+	else
+		retval = megasas_issue_polled(instance, cmd);
+
+	if (retval) {
 		printk(KERN_WARNING "megasas: SR-IOV: MR_DCMD_CTRL_SHARED_HOST"
 		       "_MEM_ALLOC DCMD timed out for scsi%d\n",
 		       instance->host->host_no);
@@ -2612,11 +2605,7 @@ megasas_service_aen(struct megasas_instance *instance, struct megasas_cmd *cmd)
 
 	instance->aen_cmd = NULL;
 
-	if (instance->ctrl_context && cmd->mpt_pthr_cmd_blocked)
-		megasas_return_mfi_mpt_pthr(instance, cmd,
-			cmd->mpt_pthr_cmd_blocked);
-	else
-		megasas_return_cmd(instance, cmd);
+	megasas_return_cmd(instance, cmd);
 
 	if ((instance->unload == 0) &&
 		((instance->issuepend_done == 1))) {
@@ -2978,8 +2967,7 @@ megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
 					       "failed, status = 0x%x.\n",
 					       cmd->frame->hdr.cmd_status);
 				else {
-					megasas_return_mfi_mpt_pthr(instance,
-						cmd, cmd->mpt_pthr_cmd_blocked);
+					megasas_return_cmd(instance, cmd);
 					spin_unlock_irqrestore(
 						instance->host->host_lock,
 						flags);
@@ -2987,8 +2975,7 @@ megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
 				}
 			} else
 				instance->map_id++;
-			megasas_return_mfi_mpt_pthr(instance, cmd,
-				cmd->mpt_pthr_cmd_blocked);
+			megasas_return_cmd(instance, cmd);
 
 			/*
 			 * Set fast path IO to ZERO.
@@ -3766,7 +3753,6 @@ int megasas_alloc_cmds(struct megasas_instance *instance)
 		cmd = instance->cmd_list[i];
 		memset(cmd, 0, sizeof(struct megasas_cmd));
 		cmd->index = i;
-		atomic_set(&cmd->mfi_mpt_pthr, MFI_LIST_ADDED);
 		cmd->scmd = NULL;
 		cmd->instance = instance;
 
@@ -3874,11 +3860,7 @@ megasas_get_pd_list(struct megasas_instance *instance)
 				MEGASAS_MAX_PD * sizeof(struct MR_PD_LIST),
 				ci, ci_h);
 
-	if (instance->ctrl_context && cmd->mpt_pthr_cmd_blocked)
-		megasas_return_mfi_mpt_pthr(instance, cmd,
-			cmd->mpt_pthr_cmd_blocked);
-	else
-		megasas_return_cmd(instance, cmd);
+	megasas_return_cmd(instance, cmd);
 
 	return ret;
 }
@@ -3965,11 +3947,7 @@ megasas_get_ld_list(struct megasas_instance *instance)
 				ci,
 				ci_h);
 
-	if (instance->ctrl_context && cmd->mpt_pthr_cmd_blocked)
-		megasas_return_mfi_mpt_pthr(instance, cmd,
-			cmd->mpt_pthr_cmd_blocked);
-	else
-		megasas_return_cmd(instance, cmd);
+	megasas_return_cmd(instance, cmd);
 	return ret;
 }
 
@@ -4050,11 +4028,7 @@ megasas_ld_list_query(struct megasas_instance *instance, u8 query_type)
 	pci_free_consistent(instance->pdev, sizeof(struct MR_LD_TARGETID_LIST),
 			    ci, ci_h);
 
-	if (instance->ctrl_context && cmd->mpt_pthr_cmd_blocked)
-		megasas_return_mfi_mpt_pthr(instance, cmd,
-			cmd->mpt_pthr_cmd_blocked);
-	else
-		megasas_return_cmd(instance, cmd);
+	megasas_return_cmd(instance, cmd);
 
 	return ret;
 }
@@ -4180,16 +4154,17 @@ megasas_get_ctrl_info(struct megasas_instance *instance)
 		le32_to_cpus((u32 *)&ctrl_info->adapterOperations2);
 		le32_to_cpus((u32 *)&ctrl_info->adapterOperations3);
 		megasas_update_ext_vd_details(instance);
+		instance->is_imr = (ctrl_info->memory_size ? 0 : 1);
+		dev_info(&instance->pdev->dev,
+				"controller type\t: %s(%dMB)\n",
+				instance->is_imr ? "iMR" : "MR",
+				le16_to_cpu(ctrl_info->memory_size));
 	}
 
 	pci_free_consistent(instance->pdev, sizeof(struct megasas_ctrl_info),
 			    ci, ci_h);
 
-	if (instance->ctrl_context && cmd->mpt_pthr_cmd_blocked)
-		megasas_return_mfi_mpt_pthr(instance, cmd,
-			cmd->mpt_pthr_cmd_blocked);
-	else
-		megasas_return_cmd(instance, cmd);
+	megasas_return_cmd(instance, cmd);
 	return ret;
 }
 
@@ -4244,11 +4219,7 @@ int megasas_set_crash_dump_params(struct megasas_instance *instance,
 	else
 		ret = megasas_issue_polled(instance, cmd);
 
-	if (instance->ctrl_context && cmd->mpt_pthr_cmd_blocked)
-		megasas_return_mfi_mpt_pthr(instance, cmd,
-			cmd->mpt_pthr_cmd_blocked);
-	else
-		megasas_return_cmd(instance, cmd);
+	megasas_return_cmd(instance, cmd);
 	return ret;
 }
 
@@ -4694,17 +4665,6 @@ static int megasas_init_fw(struct megasas_instance *instance)
 
 	tmp_sectors = min_t(u32, max_sectors_1 , max_sectors_2);
 
-	/*Check whether controller is iMR or MR */
-	if (ctrl_info->memory_size) {
-		instance->is_imr = 0;
-		dev_info(&instance->pdev->dev, "Controller type: MR,"
-			"Memory size is: %dMB\n",
-			le16_to_cpu(ctrl_info->memory_size));
-	} else {
-		instance->is_imr = 1;
-		dev_info(&instance->pdev->dev,
-			"Controller type: iMR\n");
-	}
 	instance->disableOnlineCtrlReset =
 	ctrl_info->properties.OnOffProperties.disableOnlineCtrlReset;
 	instance->mpio = ctrl_info->adapterOperations2.mpio;
@@ -4916,11 +4876,7 @@ megasas_get_seq_num(struct megasas_instance *instance,
 	pci_free_consistent(instance->pdev, sizeof(struct megasas_evt_log_info),
 			    el_info, el_info_h);
 
-	if (instance->ctrl_context && cmd->mpt_pthr_cmd_blocked)
-		megasas_return_mfi_mpt_pthr(instance, cmd,
-			cmd->mpt_pthr_cmd_blocked);
-	else
-		megasas_return_cmd(instance, cmd);
+	megasas_return_cmd(instance, cmd);
 
 	return 0;
 }
@@ -5085,6 +5041,7 @@ static int megasas_start_aen(struct megasas_instance *instance)
 static int megasas_io_attach(struct megasas_instance *instance)
 {
 	struct Scsi_Host *host = instance->host;
+	u32		error;
 
 	/*
 	 * Export parameters required by SCSI mid-layer
@@ -5134,12 +5091,21 @@ static int megasas_io_attach(struct megasas_instance *instance)
 		host->hostt->eh_device_reset_handler = NULL;
 		host->hostt->eh_bus_reset_handler = NULL;
 	}
+	error = scsi_init_shared_tag_map(host, host->can_queue);
+	if (error) {
+		dev_err(&instance->pdev->dev,
+			"Failed to shared tag from %s %d\n",
+			__func__, __LINE__);
+		return -ENODEV;
+	}
 
 	/*
 	 * Notify the mid-layer about the new controller
 	 */
 	if (scsi_add_host(host, &instance->pdev->dev)) {
-		printk(KERN_DEBUG "megasas: scsi_add_host failed\n");
+		dev_err(&instance->pdev->dev,
+			"Failed to add host from %s %d\n",
+			__func__, __LINE__);
 		return -ENODEV;
 	}
 
@@ -5257,8 +5223,6 @@ static int megasas_probe_one(struct pci_dev *pdev,
 		fusion = instance->ctrl_context;
 		memset(fusion, 0,
 			((1 << PAGE_SHIFT) << instance->ctrl_context_pages));
-		INIT_LIST_HEAD(&fusion->cmd_pool);
-		spin_lock_init(&fusion->mpt_pool_lock);
 	}
 	break;
 	default: /* For all other supported controllers */
@@ -5512,11 +5476,7 @@ static void megasas_flush_cache(struct megasas_instance *instance)
 		dev_err(&instance->pdev->dev, "Command timedout"
 			" from %s\n", __func__);
 
-	if (instance->ctrl_context && cmd->mpt_pthr_cmd_blocked)
-		megasas_return_mfi_mpt_pthr(instance, cmd,
-			cmd->mpt_pthr_cmd_blocked);
-	else
-		megasas_return_cmd(instance, cmd);
+	megasas_return_cmd(instance, cmd);
 
 	return;
 }
@@ -5563,11 +5523,7 @@ static void megasas_shutdown_controller(struct megasas_instance *instance,
 		dev_err(&instance->pdev->dev, "Command timedout"
 			"from %s\n", __func__);
 
-	if (instance->ctrl_context && cmd->mpt_pthr_cmd_blocked)
-		megasas_return_mfi_mpt_pthr(instance, cmd,
-			cmd->mpt_pthr_cmd_blocked);
-	else
-		megasas_return_cmd(instance, cmd);
+	megasas_return_cmd(instance, cmd);
 
 	return;
 }
@@ -6193,11 +6149,7 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
 			kbuff_arr[i] = NULL;
 	}
 
-	if (instance->ctrl_context && cmd->mpt_pthr_cmd_blocked)
-		megasas_return_mfi_mpt_pthr(instance, cmd,
-			cmd->mpt_pthr_cmd_blocked);
-	else
-		megasas_return_cmd(instance, cmd);
+	megasas_return_cmd(instance, cmd);
 	return error;
 }
 
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 3cd1d5f..9ce4813 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -57,6 +57,7 @@
 #include "megaraid_sas_fusion.h"
 #include "megaraid_sas.h"
 
+
 extern void megasas_free_cmds(struct megasas_instance *instance);
 extern struct megasas_cmd *megasas_get_cmd(struct megasas_instance
 					   *instance);
@@ -156,28 +157,30 @@ megasas_clear_intr_fusion(struct megasas_register_set __iomem *regs)
  * megasas_get_cmd_fusion -	Get a command from the free pool
  * @instance:		Adapter soft state
  *
- * Returns a free command from the pool
+ * Returns a blk_tag indexed mpt frame
  */
-struct megasas_cmd_fusion *megasas_get_cmd_fusion(struct megasas_instance
-						  *instance)
+inline struct megasas_cmd_fusion *megasas_get_cmd_fusion(struct megasas_instance
+						  *instance, u32 blk_tag)
 {
-	unsigned long flags;
 	struct fusion_context *fusion =
 		(struct fusion_context *)instance->ctrl_context;
-	struct megasas_cmd_fusion *cmd = NULL;
-
-	spin_lock_irqsave(&fusion->mpt_pool_lock, flags);
-
-	if (!list_empty(&fusion->cmd_pool)) {
-		cmd = list_entry((&fusion->cmd_pool)->next,
-				 struct megasas_cmd_fusion, list);
-		list_del_init(&cmd->list);
-	} else {
-		printk(KERN_ERR "megasas: Command pool (fusion) empty!\n");
-	}
 
-	spin_unlock_irqrestore(&fusion->mpt_pool_lock, flags);
-	return cmd;
+#if BLK_TAG_REFCOUNT
+	struct megasas_cmd_fusion *cmd = NULL;
+	cmd = fusion->cmd_list[blk_tag];
+	if (blk_tag > instance->max_fw_cmds) {
+		dev_err(&instance->pdev->dev,
+			"request tags (%04d) max_fw_cmds (%04d) "
+			"can_queue (%04d) max_scsi_cmds (%04d)\n",
+			blk_tag, instance->max_fw_cmds,
+			instance->host->can_queue, instance->max_scsi_cmds);
+		panic("Invalid blk tag");
+	}
+	if (atomic_inc_return(&cmd->refcount) > 1)
+		dev_err(&instance->pdev->dev, "request tags %d from %s %d\n",
+			blk_tag, __func__, __LINE__);
+#endif
+	return fusion->cmd_list[blk_tag];
 }
 
 /**
@@ -188,45 +191,11 @@ struct megasas_cmd_fusion *megasas_get_cmd_fusion(struct megasas_instance
 inline void megasas_return_cmd_fusion(struct megasas_instance *instance,
 	struct megasas_cmd_fusion *cmd)
 {
-	unsigned long flags;
-	struct fusion_context *fusion =
-		(struct fusion_context *)instance->ctrl_context;
-
-	spin_lock_irqsave(&fusion->mpt_pool_lock, flags);
-
 	cmd->scmd = NULL;
-	cmd->sync_cmd_idx = (u32)ULONG_MAX;
 	memset(cmd->io_request, 0, sizeof(struct MPI2_RAID_SCSI_IO_REQUEST));
-	list_add(&cmd->list, (&fusion->cmd_pool)->next);
-
-	spin_unlock_irqrestore(&fusion->mpt_pool_lock, flags);
-}
-
-/**
- * megasas_return_mfi_mpt_pthr - Return a mfi and mpt to free command pool
- * @instance:		Adapter soft state
- * @cmd_mfi:		MFI Command packet to be returned to free command pool
- * @cmd_mpt:		MPT Command packet to be returned to free command pool
- */
-inline void megasas_return_mfi_mpt_pthr(struct megasas_instance *instance,
-		struct megasas_cmd *cmd_mfi,
-		struct megasas_cmd_fusion *cmd_fusion)
-{
-	unsigned long flags;
-
-	/*
-	 * TO DO: optimize this code and use only one lock instead of two
-	 * locks being used currently- mpt_pool_lock is acquired
-	 * inside mfi_pool_lock
-	 */
-	spin_lock_irqsave(&instance->mfi_pool_lock, flags);
-	megasas_return_cmd_fusion(instance, cmd_fusion);
-	if (atomic_read(&cmd_mfi->mfi_mpt_pthr) != MFI_MPT_ATTACHED)
-		dev_err(&instance->pdev->dev, "Possible bug from %s %d\n",
-			__func__, __LINE__);
-	atomic_set(&cmd_mfi->mfi_mpt_pthr, MFI_MPT_DETACHED);
-	__megasas_return_cmd(instance, cmd_mfi);
-	spin_unlock_irqrestore(&instance->mfi_pool_lock, flags);
+#if BLK_TAG_REFCOUNT
+	(void)atomic_dec_and_test(&cmd->refcount);
+#endif
 }
 
 /**
@@ -326,7 +295,6 @@ megasas_free_cmds_fusion(struct megasas_instance *instance)
 	kfree(fusion->cmd_list);
 	fusion->cmd_list = NULL;
 
-	INIT_LIST_HEAD(&fusion->cmd_pool);
 }
 
 /**
@@ -527,6 +495,10 @@ megasas_alloc_cmds_fusion(struct megasas_instance *instance)
 	/*
 	 * Add all the commands to command pool (fusion->cmd_pool)
 	 */
+#if BLK_TAG_DEBUG
+	dev_info(&instance->pdev->dev,
+		"passthrough pool : mpt index\t mfi index\n");
+#endif
 
 	/* SMID 0 is reserved. Set SMID/index from 1 */
 	for (i = 0; i < max_cmd; i++) {
@@ -535,7 +507,15 @@ megasas_alloc_cmds_fusion(struct megasas_instance *instance)
 		memset(cmd, 0, sizeof(struct megasas_cmd_fusion));
 		cmd->index = i + 1;
 		cmd->scmd = NULL;
-		cmd->sync_cmd_idx = (u32)ULONG_MAX; /* Set to Invalid */
+		cmd->sync_cmd_idx = (i >= instance->max_scsi_cmds) ?
+				(i - instance->max_scsi_cmds) :
+				(u32)ULONG_MAX; /* Set to Invalid */
+#if BLK_TAG_DEBUG
+		if (cmd->sync_cmd_idx != (u32) ULONG_MAX)
+			dev_info(&instance->pdev->dev,
+				"\t\t\t[%d]\t[%d]\n",
+				i, cmd->sync_cmd_idx);
+#endif
 		cmd->instance = instance;
 		cmd->io_request =
 			(struct MPI2_RAID_SCSI_IO_REQUEST *)
@@ -544,7 +524,7 @@ megasas_alloc_cmds_fusion(struct megasas_instance *instance)
 		       sizeof(struct MPI2_RAID_SCSI_IO_REQUEST));
 		cmd->io_request_phys_addr = io_req_base_phys + offset;
 
-		list_add_tail(&cmd->list, &fusion->cmd_pool);
+		atomic_set(&cmd->refcount, 0);
 	}
 
 	/*
@@ -605,12 +585,8 @@ wait_and_poll(struct megasas_instance *instance, struct megasas_cmd *cmd,
 		msleep(20);
 	}
 
-	if (frame_hdr->cmd_status == 0xff) {
-		if (fusion)
-			megasas_return_mfi_mpt_pthr(instance, cmd,
-				cmd->mpt_pthr_cmd_blocked);
+	if (frame_hdr->cmd_status == 0xff)
 		return -ETIME;
-	}
 
 	return 0;
 }
@@ -820,11 +796,7 @@ megasas_get_ld_map_info(struct megasas_instance *instance)
 	else
 		ret = megasas_issue_polled(instance, cmd);
 
-	if (instance->ctrl_context && cmd->mpt_pthr_cmd_blocked)
-		megasas_return_mfi_mpt_pthr(instance, cmd,
-			cmd->mpt_pthr_cmd_blocked);
-	else
-		megasas_return_cmd(instance, cmd);
+	megasas_return_cmd(instance, cmd);
 
 	return ret;
 }
@@ -1953,7 +1925,8 @@ megasas_build_and_issue_cmd_fusion(struct megasas_instance *instance,
 
 	fusion = instance->ctrl_context;
 
-	cmd = megasas_get_cmd_fusion(instance);
+	cmd = megasas_get_cmd_fusion(instance, scmd->request->tag);
+
 	if (!cmd)
 		return SCSI_MLQUEUE_HOST_BUSY;
 
@@ -2013,6 +1986,7 @@ complete_cmd_fusion(struct megasas_instance *instance, u32 MSIxIndex)
 	union desc_value d_val;
 	struct LD_LOAD_BALANCE_INFO *lbinfo;
 	int threshold_reply_count = 0;
+	struct scsi_cmnd *scmd_local = NULL;
 
 	fusion = instance->ctrl_context;
 
@@ -2048,13 +2022,14 @@ complete_cmd_fusion(struct megasas_instance *instance, u32 MSIxIndex)
 		if (cmd_fusion->scmd)
 			cmd_fusion->scmd->SCp.ptr = NULL;
 
+		scmd_local = cmd_fusion->scmd;
 		status = scsi_io_req->RaidContext.status;
 		extStatus = scsi_io_req->RaidContext.exStatus;
 
 		switch (scsi_io_req->Function) {
 		case MPI2_FUNCTION_SCSI_IO_REQUEST:  /*Fast Path IO.*/
 			/* Update load balancing info */
-			device_id = MEGASAS_DEV_INDEX(cmd_fusion->scmd);
+			device_id = MEGASAS_DEV_INDEX(scmd_local);
 			lbinfo = &fusion->load_balance_info[device_id];
 			if (cmd_fusion->scmd->SCp.Status &
 			    MEGASAS_LOAD_BALANCE_FLAG) {
@@ -2072,29 +2047,25 @@ complete_cmd_fusion(struct megasas_instance *instance, u32 MSIxIndex)
 		case MEGASAS_MPI2_FUNCTION_LD_IO_REQUEST: /* LD-IO Path */
 			/* Map the FW Cmd Status */
 			map_cmd_status(cmd_fusion, status, extStatus);
-			scsi_dma_unmap(cmd_fusion->scmd);
-			cmd_fusion->scmd->scsi_done(cmd_fusion->scmd);
 			scsi_io_req->RaidContext.status = 0;
 			scsi_io_req->RaidContext.exStatus = 0;
 			megasas_return_cmd_fusion(instance, cmd_fusion);
+			scsi_dma_unmap(scmd_local);
+			scmd_local->scsi_done(scmd_local);
 			atomic_dec(&instance->fw_outstanding);
 
 			break;
 		case MEGASAS_MPI2_FUNCTION_PASSTHRU_IO_REQUEST: /*MFI command */
 			cmd_mfi = instance->cmd_list[cmd_fusion->sync_cmd_idx];
 
-			if (!cmd_mfi->mpt_pthr_cmd_blocked) {
-				if (megasas_dbg_lvl == 5)
-					dev_info(&instance->pdev->dev,
-						"freeing mfi/mpt pass-through "
-						"from %s %d\n",
-						 __func__, __LINE__);
-				megasas_return_mfi_mpt_pthr(instance, cmd_mfi,
-					cmd_fusion);
-			}
-
-			megasas_complete_cmd(instance, cmd_mfi, DID_OK);
-			cmd_fusion->flags = 0;
+			/* Poll mode. Dummy free.
+			 * In case of Interrupt mode, caller has reverse check.
+			 */
+			if (cmd_mfi->flags & DRV_DCMD_POLLED_MODE) {
+				cmd_mfi->flags &= ~DRV_DCMD_POLLED_MODE;
+				megasas_return_cmd(instance, cmd_mfi);
+			} else
+				megasas_complete_cmd(instance, cmd_mfi, DID_OK);
 			break;
 		}
 
@@ -2254,27 +2225,16 @@ build_mpt_mfi_pass_thru(struct megasas_instance *instance,
 	struct megasas_cmd_fusion *cmd;
 	struct fusion_context *fusion;
 	struct megasas_header *frame_hdr = &mfi_cmd->frame->hdr;
-	u32 opcode;
 
-	cmd = megasas_get_cmd_fusion(instance);
+	fusion = instance->ctrl_context;
+
+	cmd = megasas_get_cmd_fusion(instance,
+			instance->max_scsi_cmds + mfi_cmd->index);
 	if (!cmd)
 		return 1;
 
 	/*  Save the smid. To be used for returning the cmd */
 	mfi_cmd->context.smid = cmd->index;
-	cmd->sync_cmd_idx = mfi_cmd->index;
-
-	/* Set this only for Blocked commands */
-	opcode = le32_to_cpu(mfi_cmd->frame->dcmd.opcode);
-	if ((opcode == MR_DCMD_LD_MAP_GET_INFO)
-		&& (mfi_cmd->frame->dcmd.mbox.b[1] == 1))
-		mfi_cmd->is_wait_event = 1;
-
-	if (opcode == MR_DCMD_CTRL_EVENT_WAIT)
-		mfi_cmd->is_wait_event = 1;
-
-	if (mfi_cmd->is_wait_event)
-		mfi_cmd->mpt_pthr_cmd_blocked = cmd;
 
 	/*
 	 * For cmds where the flag is set, store the flag and check
@@ -2283,9 +2243,16 @@ build_mpt_mfi_pass_thru(struct megasas_instance *instance,
 	 */
 
 	if (frame_hdr->flags & cpu_to_le16(MFI_FRAME_DONT_POST_IN_REPLY_QUEUE))
-		cmd->flags = MFI_FRAME_DONT_POST_IN_REPLY_QUEUE;
-
-	fusion = instance->ctrl_context;
+		mfi_cmd->flags |= DRV_DCMD_POLLED_MODE;
+
+#if BLK_TAG_DEBUG
+	dev_info(&instance->pdev->dev,
+			"%s : opcode (0x%08x) poll_mode (%d) tag (%04d) mfi->index (%04d)\n",
+			__func__, le32_to_cpu(mfi_cmd->frame->dcmd.opcode),
+			mfi_cmd->flags,
+			instance->max_scsi_cmds + mfi_cmd->index,
+			cmd->sync_cmd_idx);
+#endif
 	io_req = cmd->io_request;
 
 	if ((instance->pdev->device == PCI_DEVICE_ID_LSI_INVADER) ||
@@ -2364,7 +2331,6 @@ megasas_issue_dcmd_fusion(struct megasas_instance *instance,
 		printk(KERN_ERR "Couldn't issue MFI pass thru cmd\n");
 		return;
 	}
-	atomic_set(&cmd->mfi_mpt_pthr, MFI_MPT_ATTACHED);
 	instance->instancet->fire_cmd(instance, req_desc->u.low,
 				      req_desc->u.high, instance->reg_set);
 }
@@ -2577,11 +2543,26 @@ void megasas_refire_mgmt_cmd(struct megasas_instance *instance)
 					(instance, smid - 1);
 		if (req_desc && (cmd_mfi->frame->dcmd.opcode !=
 				cpu_to_le32(MR_DCMD_LD_MAP_GET_INFO))) {
+#if BLK_TAG_DEBUG
+			dev_info(&instance->pdev->dev,
+				"%s : refire sync_cmd_idx (%04d) tag (%04d) opcode (0x%08x)\n",
+				__func__, cmd_fusion->sync_cmd_idx,
+				(smid - 1),
+				le32_to_cpu(cmd_mfi->frame->dcmd.opcode));
+#endif
 			instance->instancet->fire_cmd(instance,
 				req_desc->u.low, req_desc->u.high,
 				instance->reg_set);
-		} else
+		} else {
+#if BLK_TAG_DEBUG
+			dev_info(&instance->pdev->dev,
+				"%s : skip sync_cmd_idx (%04d) tag (%04d) opcode (0x%08x)\n",
+				__func__, cmd_fusion->sync_cmd_idx,
+				(smid - 1),
+				le32_to_cpu(cmd_mfi->frame->dcmd.opcode));
+#endif
 			megasas_return_cmd(instance, cmd_mfi);
+		}
 	}
 }
 
@@ -2618,6 +2599,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int iotimeout)
 	struct fusion_context *fusion;
 	u32 host_diag, abs_state, status_reg, reset_adapter;
 	u32 io_timeout_in_crash_mode = 0;
+	struct scsi_cmnd *scmd_local = NULL;
 
 	instance = (struct megasas_instance *)shost->hostdata;
 	fusion = instance->ctrl_context;
@@ -2685,15 +2667,16 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int iotimeout)
 			iotimeout = 0;
 
 		/* Now return commands back to the OS */
-		for (i = 0 ; i < instance->max_fw_cmds; i++) {
+		for (i = 0 ; i < instance->max_scsi_cmds; i++) {
 			cmd_fusion = fusion->cmd_list[i];
+			scmd_local = cmd_fusion->scmd;
 			if (cmd_fusion->scmd) {
-				scsi_dma_unmap(cmd_fusion->scmd);
-				cmd_fusion->scmd->result =
+				scmd_local->result =
 					megasas_check_mpio_paths(instance,
-								 cmd_fusion->scmd);
-				cmd_fusion->scmd->scsi_done(cmd_fusion->scmd);
+							scmd_local);
 				megasas_return_cmd_fusion(instance, cmd_fusion);
+				scsi_dma_unmap(scmd_local);
+				scmd_local->scsi_done(scmd_local);
 				atomic_dec(&instance->fw_outstanding);
 			}
 		}
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.h b/drivers/scsi/megaraid/megaraid_sas_fusion.h
index 56e6db2..9bd0314 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
@@ -679,8 +679,8 @@ struct megasas_cmd_fusion {
 	 */
 	u32 sync_cmd_idx;
 	u32 index;
-	u8 flags;
 	u8 pd_r1_lb;
+	atomic_t refcount;
 };
 
 struct LD_LOAD_BALANCE_INFO {
@@ -792,10 +792,6 @@ struct MR_FW_RAID_MAP_EXT {
 
 struct fusion_context {
 	struct megasas_cmd_fusion **cmd_list;
-	struct list_head cmd_pool;
-
-	spinlock_t mpt_pool_lock;
-
 	dma_addr_t req_frames_desc_phys;
 	u8 *req_frames_desc;
 
-- 
1.7.1

