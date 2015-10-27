From: Weidong Wang <wangweidong1@huawei.com>
Subject: [PATCH 1/3] megaraid_sas: Convert dev_printk to dev_<level>
Date: Tue, 27 Oct 2015 16:26:13 +0800
Message-ID: <1445934375-17784-2-git-send-email-wangweidong1@huawei.com>
References: <1445934375-17784-1-git-send-email-wangweidong1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1445934375-17784-1-git-send-email-wangweidong1@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, uday.lingala@avagotech.com, JBottomley@odin.com
Cc: megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, wangweidong1@huawei.com
List-Id: linux-scsi@vger.kernel.org

Reduce object size a little by using dev_<level>
calls instead of dev_printk(KERN_<LEVEL>.

Signed-off-by: Weidong Wang <wangweidong1@huawei.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 68 +++++++++++++++----------------
 1 file changed, 34 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index eaa81e5..ed9846d 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1884,7 +1884,7 @@ static int megasas_get_ld_vf_affiliation_111(struct megasas_instance *instance,
 	cmd = megasas_get_cmd(instance);
 
 	if (!cmd) {
-		dev_printk(KERN_DEBUG, &instance->pdev->dev, "megasas_get_ld_vf_affiliation_111:"
+		dev_dbg(&instance->pdev->dev, "megasas_get_ld_vf_affiliation_111:"
 		       "Failed to get cmd for scsi%d\n",
 			instance->host->host_no);
 		return -ENOMEM;
@@ -1908,7 +1908,7 @@ static int megasas_get_ld_vf_affiliation_111(struct megasas_instance *instance,
 					     sizeof(struct MR_LD_VF_AFFILIATION_111),
 					     &new_affiliation_111_h);
 		if (!new_affiliation_111) {
-			dev_printk(KERN_DEBUG, &instance->pdev->dev, "SR-IOV: Couldn't allocate "
+			dev_dbg(&instance->pdev->dev, "SR-IOV: Couldn't allocate "
 			       "memory for new affiliation for scsi%d\n",
 			       instance->host->host_no);
 			megasas_return_cmd(instance, cmd);
@@ -1995,7 +1995,7 @@ static int megasas_get_ld_vf_affiliation_12(struct megasas_instance *instance,
 	cmd = megasas_get_cmd(instance);
 
 	if (!cmd) {
-		dev_printk(KERN_DEBUG, &instance->pdev->dev, "megasas_get_ld_vf_affiliation12: "
+		dev_dbg(&instance->pdev->dev, "megasas_get_ld_vf_affiliation12: "
 		       "Failed to get cmd for scsi%d\n",
 		       instance->host->host_no);
 		return -ENOMEM;
@@ -2020,7 +2020,7 @@ static int megasas_get_ld_vf_affiliation_12(struct megasas_instance *instance,
 					     sizeof(struct MR_LD_VF_AFFILIATION),
 					     &new_affiliation_h);
 		if (!new_affiliation) {
-			dev_printk(KERN_DEBUG, &instance->pdev->dev, "SR-IOV: Couldn't allocate "
+			dev_dbg(&instance->pdev->dev, "SR-IOV: Couldn't allocate "
 			       "memory for new affiliation for scsi%d\n",
 			       instance->host->host_no);
 			megasas_return_cmd(instance, cmd);
@@ -2174,7 +2174,7 @@ int megasas_sriov_start_heartbeat(struct megasas_instance *instance,
 	cmd = megasas_get_cmd(instance);
 
 	if (!cmd) {
-		dev_printk(KERN_DEBUG, &instance->pdev->dev, "megasas_sriov_start_heartbeat: "
+		dev_dbg(&instance->pdev->dev, "megasas_sriov_start_heartbeat: "
 		       "Failed to get cmd for scsi%d\n",
 		       instance->host->host_no);
 		return -ENOMEM;
@@ -2188,7 +2188,7 @@ int megasas_sriov_start_heartbeat(struct megasas_instance *instance,
 					      sizeof(struct MR_CTRL_HB_HOST_MEM),
 					      &instance->hb_host_mem_h);
 		if (!instance->hb_host_mem) {
-			dev_printk(KERN_DEBUG, &instance->pdev->dev, "SR-IOV: Couldn't allocate"
+			dev_dbg(&instance->pdev->dev, "SR-IOV: Couldn't allocate"
 			       " memory for heartbeat host memory for scsi%d\n",
 			       instance->host->host_no);
 			retval = -ENOMEM;
@@ -2922,7 +2922,7 @@ megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
 			break;
 
 		default:
-			dev_printk(KERN_DEBUG, &instance->pdev->dev, "MFI FW status %#x\n",
+			dev_dbg(&instance->pdev->dev, "MFI FW status %#x\n",
 			       hdr->cmd_status);
 			cmd->scmd->result = DID_ERROR << 16;
 			break;
@@ -3332,7 +3332,7 @@ megasas_transition_to_ready(struct megasas_instance *instance, int ocr)
 		switch (fw_state) {
 
 		case MFI_STATE_FAULT:
-			dev_printk(KERN_DEBUG, &instance->pdev->dev, "FW in FAULT state!!\n");
+			dev_dbg(&instance->pdev->dev, "FW in FAULT state!!\n");
 			if (ocr) {
 				max_wait = MEGASAS_RESET_WAIT_TIME;
 				cur_state = MFI_STATE_FAULT;
@@ -3471,7 +3471,7 @@ megasas_transition_to_ready(struct megasas_instance *instance, int ocr)
 			break;
 
 		default:
-			dev_printk(KERN_DEBUG, &instance->pdev->dev, "Unknown state 0x%x\n",
+			dev_dbg(&instance->pdev->dev, "Unknown state 0x%x\n",
 			       fw_state);
 			return -ENODEV;
 		}
@@ -3493,7 +3493,7 @@ megasas_transition_to_ready(struct megasas_instance *instance, int ocr)
 		 * Return error if fw_state hasn't changed after max_wait
 		 */
 		if (curr_abs_state == abs_state) {
-			dev_printk(KERN_DEBUG, &instance->pdev->dev, "FW state [%d] hasn't changed "
+			dev_dbg(&instance->pdev->dev, "FW state [%d] hasn't changed "
 			       "in %d secs\n", fw_state, max_wait);
 			return -ENODEV;
 		}
@@ -3595,7 +3595,7 @@ static int megasas_create_frame_pool(struct megasas_instance *instance)
 					instance->pdev, total_sz, 256, 0);
 
 	if (!instance->frame_dma_pool) {
-		dev_printk(KERN_DEBUG, &instance->pdev->dev, "failed to setup frame pool\n");
+		dev_dbg(&instance->pdev->dev, "failed to setup frame pool\n");
 		return -ENOMEM;
 	}
 
@@ -3603,7 +3603,7 @@ static int megasas_create_frame_pool(struct megasas_instance *instance)
 						   instance->pdev, 128, 4, 0);
 
 	if (!instance->sense_dma_pool) {
-		dev_printk(KERN_DEBUG, &instance->pdev->dev, "failed to setup sense pool\n");
+		dev_dbg(&instance->pdev->dev, "failed to setup sense pool\n");
 
 		pci_pool_destroy(instance->frame_dma_pool);
 		instance->frame_dma_pool = NULL;
@@ -3631,7 +3631,7 @@ static int megasas_create_frame_pool(struct megasas_instance *instance)
 		 * whatever has been allocated
 		 */
 		if (!cmd->frame || !cmd->sense) {
-			dev_printk(KERN_DEBUG, &instance->pdev->dev, "pci_pool_alloc failed\n");
+			dev_dbg(&instance->pdev->dev, "pci_pool_alloc failed\n");
 			megasas_teardown_frame_pool(instance);
 			return -ENOMEM;
 		}
@@ -3710,7 +3710,7 @@ int megasas_alloc_cmds(struct megasas_instance *instance)
 	instance->cmd_list = kcalloc(max_cmd, sizeof(struct megasas_cmd*), GFP_KERNEL);
 
 	if (!instance->cmd_list) {
-		dev_printk(KERN_DEBUG, &instance->pdev->dev, "out of memory\n");
+		dev_dbg(&instance->pdev->dev, "out of memory\n");
 		return -ENOMEM;
 	}
 
@@ -3746,7 +3746,7 @@ int megasas_alloc_cmds(struct megasas_instance *instance)
 	 * Create a frame pool and assign one frame to each cmd
 	 */
 	if (megasas_create_frame_pool(instance)) {
-		dev_printk(KERN_DEBUG, &instance->pdev->dev, "Error creating frame DMA pool\n");
+		dev_dbg(&instance->pdev->dev, "Error creating frame DMA pool\n");
 		megasas_free_cmds(instance);
 	}
 
@@ -3775,7 +3775,7 @@ megasas_get_pd_list(struct megasas_instance *instance)
 	cmd = megasas_get_cmd(instance);
 
 	if (!cmd) {
-		dev_printk(KERN_DEBUG, &instance->pdev->dev, "(get_pd_list): Failed to get cmd\n");
+		dev_dbg(&instance->pdev->dev, "(get_pd_list): Failed to get cmd\n");
 		return -ENOMEM;
 	}
 
@@ -3785,7 +3785,7 @@ megasas_get_pd_list(struct megasas_instance *instance)
 		  MEGASAS_MAX_PD * sizeof(struct MR_PD_LIST), &ci_h);
 
 	if (!ci) {
-		dev_printk(KERN_DEBUG, &instance->pdev->dev, "Failed to alloc mem for pd_list\n");
+		dev_dbg(&instance->pdev->dev, "Failed to alloc mem for pd_list\n");
 		megasas_return_cmd(instance, cmd);
 		return -ENOMEM;
 	}
@@ -3870,7 +3870,7 @@ megasas_get_ld_list(struct megasas_instance *instance)
 	cmd = megasas_get_cmd(instance);
 
 	if (!cmd) {
-		dev_printk(KERN_DEBUG, &instance->pdev->dev, "megasas_get_ld_list: Failed to get cmd\n");
+		dev_dbg(&instance->pdev->dev, "megasas_get_ld_list: Failed to get cmd\n");
 		return -ENOMEM;
 	}
 
@@ -3881,7 +3881,7 @@ megasas_get_ld_list(struct megasas_instance *instance)
 				&ci_h);
 
 	if (!ci) {
-		dev_printk(KERN_DEBUG, &instance->pdev->dev, "Failed to alloc mem in get_ld_list\n");
+		dev_dbg(&instance->pdev->dev, "Failed to alloc mem in get_ld_list\n");
 		megasas_return_cmd(instance, cmd);
 		return -ENOMEM;
 	}
@@ -4094,7 +4094,7 @@ megasas_get_ctrl_info(struct megasas_instance *instance)
 	cmd = megasas_get_cmd(instance);
 
 	if (!cmd) {
-		dev_printk(KERN_DEBUG, &instance->pdev->dev, "Failed to get a free cmd\n");
+		dev_dbg(&instance->pdev->dev, "Failed to get a free cmd\n");
 		return -ENOMEM;
 	}
 
@@ -4104,7 +4104,7 @@ megasas_get_ctrl_info(struct megasas_instance *instance)
 				  sizeof(struct megasas_ctrl_info), &ci_h);
 
 	if (!ci) {
-		dev_printk(KERN_DEBUG, &instance->pdev->dev, "Failed to alloc mem for ctrl info\n");
+		dev_dbg(&instance->pdev->dev, "Failed to alloc mem for ctrl info\n");
 		megasas_return_cmd(instance, cmd);
 		return -ENOMEM;
 	}
@@ -4341,7 +4341,7 @@ megasas_init_adapter_mfi(struct megasas_instance *instance)
 						     &instance->reply_queue_h);
 
 	if (!instance->reply_queue) {
-		dev_printk(KERN_DEBUG, &instance->pdev->dev, "Out of DMA mem for reply queue\n");
+		dev_dbg(&instance->pdev->dev, "Out of DMA mem for reply queue\n");
 		goto fail_reply_queue;
 	}
 
@@ -4504,7 +4504,7 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	instance->bar = find_first_bit(&bar_list, sizeof(unsigned long));
 	if (pci_request_selected_regions(instance->pdev, instance->bar,
 					 "megasas: LSI")) {
-		dev_printk(KERN_DEBUG, &instance->pdev->dev, "IO memory region busy!\n");
+		dev_dbg(&instance->pdev->dev, "IO memory region busy!\n");
 		return -EBUSY;
 	}
 
@@ -4512,7 +4512,7 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	instance->reg_set = ioremap_nocache(base_addr, 8192);
 
 	if (!instance->reg_set) {
-		dev_printk(KERN_DEBUG, &instance->pdev->dev, "Failed to map IO mem\n");
+		dev_dbg(&instance->pdev->dev, "Failed to map IO mem\n");
 		goto fail_ioremap;
 	}
 
@@ -4958,7 +4958,7 @@ megasas_register_aen(struct megasas_instance *instance, u32 seq_num,
 								  aen_cmd, 30);
 
 			if (ret_val) {
-				dev_printk(KERN_DEBUG, &instance->pdev->dev, "Failed to abort "
+				dev_dbg(&instance->pdev->dev, "Failed to abort "
 				       "previous AEN command\n");
 				return ret_val;
 			}
@@ -5204,7 +5204,7 @@ static int megasas_probe_one(struct pci_dev *pdev,
 			       sizeof(struct megasas_instance));
 
 	if (!host) {
-		dev_printk(KERN_DEBUG, &pdev->dev, "scsi_host_alloc failed\n");
+		dev_dbg(&pdev->dev, "scsi_host_alloc failed\n");
 		goto fail_alloc_instance;
 	}
 
@@ -5224,7 +5224,7 @@ static int megasas_probe_one(struct pci_dev *pdev,
 		instance->ctrl_context = (void *)__get_free_pages(GFP_KERNEL,
 				instance->ctrl_context_pages);
 		if (!instance->ctrl_context) {
-			dev_printk(KERN_DEBUG, &pdev->dev, "Failed to allocate "
+			dev_dbg(&pdev->dev, "Failed to allocate "
 			       "memory for Fusion context info\n");
 			goto fail_alloc_dma_buf;
 		}
@@ -5243,7 +5243,7 @@ static int megasas_probe_one(struct pci_dev *pdev,
 					     &instance->consumer_h);
 
 		if (!instance->producer || !instance->consumer) {
-			dev_printk(KERN_DEBUG, &pdev->dev, "Failed to allocate"
+			dev_dbg(&pdev->dev, "Failed to allocate"
 			       "memory for producer, consumer\n");
 			goto fail_alloc_dma_buf;
 		}
@@ -5290,7 +5290,7 @@ static int megasas_probe_one(struct pci_dev *pdev,
 						    &instance->evt_detail_h);
 
 	if (!instance->evt_detail) {
-		dev_printk(KERN_DEBUG, &pdev->dev, "Failed to allocate memory for "
+		dev_dbg(&pdev->dev, "Failed to allocate memory for "
 		       "event detail structure\n");
 		goto fail_alloc_dma_buf;
 	}
@@ -5397,7 +5397,7 @@ static int megasas_probe_one(struct pci_dev *pdev,
 	 * Initiate AEN (Asynchronous Event Notification)
 	 */
 	if (megasas_start_aen(instance)) {
-		dev_printk(KERN_DEBUG, &pdev->dev, "start aen failed\n");
+		dev_dbg(&pdev->dev, "start aen failed\n");
 		goto fail_start_aen;
 	}
 
@@ -5973,14 +5973,14 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
 	memset(kbuff_arr, 0, sizeof(kbuff_arr));
 
 	if (ioc->sge_count > MAX_IOCTL_SGE) {
-		dev_printk(KERN_DEBUG, &instance->pdev->dev, "SGE count [%d] >  max limit [%d]\n",
+		dev_dbg(&instance->pdev->dev, "SGE count [%d] >  max limit [%d]\n",
 		       ioc->sge_count, MAX_IOCTL_SGE);
 		return -EINVAL;
 	}
 
 	cmd = megasas_get_cmd(instance);
 	if (!cmd) {
-		dev_printk(KERN_DEBUG, &instance->pdev->dev, "Failed to get a cmd packet\n");
+		dev_dbg(&instance->pdev->dev, "Failed to get a cmd packet\n");
 		return -ENOMEM;
 	}
 
@@ -6025,7 +6025,7 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
 						    ioc->sgl[i].iov_len,
 						    &buf_handle, GFP_KERNEL);
 		if (!kbuff_arr[i]) {
-			dev_printk(KERN_DEBUG, &instance->pdev->dev, "Failed to alloc "
+			dev_dbg(&instance->pdev->dev, "Failed to alloc "
 			       "kernel SGL buffer for IOCTL\n");
 			error = -ENOMEM;
 			goto out;
@@ -6111,7 +6111,7 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
 	 */
 	if (copy_to_user(&user_ioc->frame.hdr.cmd_status,
 			 &cmd->frame->hdr.cmd_status, sizeof(u8))) {
-		dev_printk(KERN_DEBUG, &instance->pdev->dev, "Error copying out cmd_status\n");
+		dev_dbg(&instance->pdev->dev, "Error copying out cmd_status\n");
 		error = -EFAULT;
 	}
 
-- 
1.9.0
