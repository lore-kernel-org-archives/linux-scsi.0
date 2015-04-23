From: <Sumit.Saxena@avagotech.com>
Subject: [PATCH v3 17/18] megaraid_sas : fix megasas_fire_cmd_fusion
 calling convention
Date: Thu, 23 Apr 2015 16:34:09 +0530
Message-ID: <201504231106.t3NB6PX8030941@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1blp0186.outbound.protection.outlook.com ([207.46.163.186]:21641
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964811AbbDWLER (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Apr 2015 07:04:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com

The fusion HBAs don't really use the instance template like the other
variants, as it branches off at a much higher level.  So instead of
trying to squeeze megasas_fire_cmd_fusion into the wrong calling
convention call it locally with argument data types that match what
is passed.

From: Christoph Hellwig <hch@lst.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>

---
 drivers/scsi/megaraid/megaraid_sas_fusion.c |   72 +++++++++++---------------
 1 files changed, 31 insertions(+), 41 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 487cd34..826ba1c 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -182,6 +182,31 @@ inline void megasas_return_cmd_fusion(struct megasas_instance *instance,
 }
 
 /**
+ * megasas_fire_cmd_fusion -	Sends command to the FW
+ */
+static void
+megasas_fire_cmd_fusion(struct megasas_instance *instance,
+		union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc)
+{
+#if defined(writeq) && defined(CONFIG_64BIT)
+	u64 req_data = (((u64)le32_to_cpu(req_desc->u.high) << 32) |
+			le32_to_cpu(req_desc->u.low));
+
+	writeq(req_data, &instance->reg_set->inbound_low_queue_port);
+#else
+	unsigned long flags;
+
+	spin_lock_irqsave(&instance->hba_lock, flags);
+	writel(le32_to_cpu(req_desc->u.low),
+		&instance->reg_set->inbound_low_queue_port);
+	writel(le32_to_cpu(req_desc.u.high),
+		&instance->reg_set->inbound_high_queue_port);
+	spin_unlock_irqrestore(&instance->hba_lock, flags);
+#endif
+}
+
+
+/**
  * megasas_teardown_frame_pool_fusion -	Destroy the cmd frame DMA pool
  * @instance:				Adapter soft state
  */
@@ -679,8 +704,7 @@ megasas_ioc_init_fusion(struct megasas_instance *instance)
 			break;
 	}
 
-	instance->instancet->fire_cmd(instance, req_desc.u.low,
-				      req_desc.u.high, instance->reg_set);
+	megasas_fire_cmd_fusion(instance, &req_desc);
 
 	wait_and_poll(instance, cmd, MFI_POLL_TIMEOUT_SECS);
 
@@ -1096,34 +1120,6 @@ fail_alloc_mfi_cmds:
 }
 
 /**
- * megasas_fire_cmd_fusion -	Sends command to the FW
- * @frame_phys_addr :		Physical address of cmd
- * @frame_count :		Number of frames for the command
- * @regs :			MFI register set
- */
-void
-megasas_fire_cmd_fusion(struct megasas_instance *instance,
-			dma_addr_t req_desc_lo,
-			u32 req_desc_hi,
-			struct megasas_register_set __iomem *regs)
-{
-#if defined(writeq) && defined(CONFIG_64BIT)
-	u64 req_data = (((u64)le32_to_cpu(req_desc_hi) << 32) |
-			le32_to_cpu(req_desc_lo));
-
-	writeq(req_data, &(regs)->inbound_low_queue_port);
-#else
-	unsigned long flags;
-
-	spin_lock_irqsave(&instance->hba_lock, flags);
-
-	writel(le32_to_cpu(req_desc_lo), &(regs)->inbound_low_queue_port);
-	writel(le32_to_cpu(req_desc_hi), &(regs)->inbound_high_queue_port);
-	spin_unlock_irqrestore(&instance->hba_lock, flags);
-#endif
-}
-
-/**
  * map_cmd_status -	Maps FW cmd status to OS cmd status
  * @cmd :		Pointer to cmd
  * @status :		status of cmd returned by FW
@@ -1948,9 +1944,7 @@ megasas_build_and_issue_cmd_fusion(struct megasas_instance *instance,
 	 */
 	atomic_inc(&instance->fw_outstanding);
 
-	instance->instancet->fire_cmd(instance,
-				      req_desc->u.low, req_desc->u.high,
-				      instance->reg_set);
+	megasas_fire_cmd_fusion(instance, req_desc);
 
 	return 0;
 }
@@ -2311,8 +2305,7 @@ megasas_issue_dcmd_fusion(struct megasas_instance *instance,
 		printk(KERN_ERR "Couldn't issue MFI pass thru cmd\n");
 		return;
 	}
-	instance->instancet->fire_cmd(instance, req_desc->u.low,
-				      req_desc->u.high, instance->reg_set);
+	megasas_fire_cmd_fusion(instance, req_desc);
 }
 
 /**
@@ -2522,11 +2515,9 @@ void megasas_refire_mgmt_cmd(struct megasas_instance *instance)
 		req_desc = megasas_get_request_descriptor
 					(instance, smid - 1);
 		if (req_desc && (cmd_mfi->frame->dcmd.opcode !=
-				cpu_to_le32(MR_DCMD_LD_MAP_GET_INFO))) {
-			instance->instancet->fire_cmd(instance,
-				req_desc->u.low, req_desc->u.high,
-				instance->reg_set);
-		} else
+				cpu_to_le32(MR_DCMD_LD_MAP_GET_INFO)))
+			megasas_fire_cmd_fusion(instance, req_desc);
+		else
 			megasas_return_cmd(instance, cmd_mfi);
 	}
 }
@@ -2961,7 +2952,6 @@ void megasas_fusion_ocr_wq(struct work_struct *work)
 }
 
 struct megasas_instance_template megasas_instance_template_fusion = {
-	.fire_cmd = megasas_fire_cmd_fusion,
 	.enable_intr = megasas_enable_intr_fusion,
 	.disable_intr = megasas_disable_intr_fusion,
 	.clear_intr = megasas_clear_intr_fusion,
-- 
1.7.1

