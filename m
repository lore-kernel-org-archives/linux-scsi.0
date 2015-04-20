From: <Sumit.Saxena@avagotech.com>
Subject: [PATCH RESEND 17/18] megaraid_sas : fix megasas_fire_cmd_fusion
 calling convention
Date: Mon, 20 Apr 2015 18:05:10 +0530
Message-ID: <201504201237.t3KCbMCa016895@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2lp0243.outbound.protection.outlook.com ([207.46.163.243]:55109
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752387AbbDTPdK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Apr 2015 11:33:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com

The fusion HBAs don't really use the instance template like the other
variants, as it branches off at a much higher level.  So instead of
trying to squeeze megasas_fire_cmd_fusion into the wrong calling
convention call it locally with argument data types that match what
is passed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c |   68 +++++++++++---------------
 1 files changed, 29 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 17ec153..6a1dd72 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -200,6 +200,31 @@ inline void megasas_return_cmd_fusion(struct megasas_instance *instance,
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
@@ -709,8 +734,7 @@ megasas_ioc_init_fusion(struct megasas_instance *instance)
 			break;
 	}
 
-	instance->instancet->fire_cmd(instance, req_desc.u.low,
-				      req_desc.u.high, instance->reg_set);
+	megasas_fire_cmd_fusion(instance, &req_desc);
 
 	wait_and_poll(instance, cmd, MFI_POLL_TIMEOUT_SECS);
 
@@ -1126,34 +1150,6 @@ fail_alloc_mfi_cmds:
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
@@ -1981,9 +1977,7 @@ megasas_build_and_issue_cmd_fusion(struct megasas_instance *instance,
 	 */
 	atomic_inc(&instance->fw_outstanding);
 
-	instance->instancet->fire_cmd(instance,
-				      req_desc->u.low, req_desc->u.high,
-				      instance->reg_set);
+	megasas_fire_cmd_fusion(instance, req_desc);
 
 	return 0;
 }
@@ -2354,8 +2348,7 @@ megasas_issue_dcmd_fusion(struct megasas_instance *instance,
 		printk(KERN_ERR "Couldn't issue MFI pass thru cmd\n");
 		return;
 	}
-	instance->instancet->fire_cmd(instance, req_desc->u.low,
-				      req_desc->u.high, instance->reg_set);
+	megasas_fire_cmd_fusion(instance, req_desc);
 }
 
 /**
@@ -2573,9 +2566,7 @@ void megasas_refire_mgmt_cmd(struct megasas_instance *instance)
 				(smid - 1),
 				le32_to_cpu(cmd_mfi->frame->dcmd.opcode));
 #endif
-			instance->instancet->fire_cmd(instance,
-				req_desc->u.low, req_desc->u.high,
-				instance->reg_set);
+			megasas_fire_cmd_fusion(instance, req_desc);
 		} else {
 #if BLK_TAG_DEBUG
 			dev_info(&instance->pdev->dev,
@@ -3019,7 +3010,6 @@ void megasas_fusion_ocr_wq(struct work_struct *work)
 }
 
 struct megasas_instance_template megasas_instance_template_fusion = {
-	.fire_cmd = megasas_fire_cmd_fusion,
 	.enable_intr = megasas_enable_intr_fusion,
 	.disable_intr = megasas_disable_intr_fusion,
 	.clear_intr = megasas_clear_intr_fusion,
-- 
1.7.1

