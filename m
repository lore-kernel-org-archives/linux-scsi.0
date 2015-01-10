From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 08/10] megaraid_sas: fix megasas_fire_cmd_fusion calling convention
Date: Sat, 10 Jan 2015 18:11:21 +0100
Message-ID: <1420909883-19479-9-git-send-email-hch@lst.de>
References: <1420909883-19479-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:34198 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754548AbbAJRMY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Jan 2015 12:12:24 -0500
In-Reply-To: <1420909883-19479-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit.Saxena@avagotech.com, kashyap.desai@avagotech.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org

The fusion HBAs don't really use the instance template like the other
variants, as it branches off at a much higher level.  So instead of
trying to squeeze megasas_fire_cmd_fusion into the wrong calling
convention call it locally with argument data types that match what
is passed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 73 ++++++++++++-----------------
 1 file changed, 29 insertions(+), 44 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index b1e053b..5a45764 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -230,6 +230,31 @@ inline void megasas_return_mfi_mpt_pthr(struct megasas_instance *instance,
 }
 
 /**
+ * megasas_fire_cmd_fusion -	Sends command to the FW
+ */
+static void
+megasas_fire_cmd_fusion(struct megasas_instance *instance,
+		union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc)
+{
+#if defined(writeq) && defined(CONFIG_64BIT)
+	u64 req_data = (((u64)le32_to_cpu(req_desc->u.low) << 32) |
+			le32_to_cpu(req_desc->u.high));
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
@@ -721,8 +746,7 @@ megasas_ioc_init_fusion(struct megasas_instance *instance)
 			break;
 	}
 
-	instance->instancet->fire_cmd(instance, req_desc.u.low,
-				      req_desc.u.high, instance->reg_set);
+	megasas_fire_cmd_fusion(instance, &req_desc);
 
 	wait_and_poll(instance, cmd, MFI_POLL_TIMEOUT_SECS);
 
@@ -1133,34 +1157,6 @@ fail_alloc_mfi_cmds:
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
@@ -1947,9 +1943,7 @@ megasas_build_and_issue_cmd_fusion(struct megasas_instance *instance,
 	 */
 	atomic_inc(&instance->fw_outstanding);
 
-	instance->instancet->fire_cmd(instance,
-				      req_desc->u.low, req_desc->u.high,
-				      instance->reg_set);
+	megasas_fire_cmd_fusion(instance, req_desc);
 
 	return 0;
 }
@@ -2328,8 +2322,7 @@ megasas_issue_dcmd_fusion(struct megasas_instance *instance,
 		return;
 	}
 	atomic_set(&cmd->mfi_mpt_pthr, MFI_MPT_ATTACHED);
-	instance->instancet->fire_cmd(instance, req_desc->u.low,
-				      req_desc->u.high, instance->reg_set);
+	megasas_fire_cmd_fusion(instance, req_desc);
 }
 
 /**
@@ -2816,14 +2809,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int iotimeout)
 							   frame */
 							megasas_return_cmd_fusion(instance, cmd_fusion);
 						} else {
-							instance->instancet->
-							fire_cmd(instance,
-								 req_desc->
-								 u.low,
-								 req_desc->
-								 u.high,
-								 instance->
-								 reg_set);
+							megasas_fire_cmd_fusion(instance, req_desc);
 						}
 					}
 				}
@@ -2978,7 +2964,6 @@ void megasas_fusion_ocr_wq(struct work_struct *work)
 }
 
 struct megasas_instance_template megasas_instance_template_fusion = {
-	.fire_cmd = megasas_fire_cmd_fusion,
 	.enable_intr = megasas_enable_intr_fusion,
 	.disable_intr = megasas_disable_intr_fusion,
 	.clear_intr = megasas_clear_intr_fusion,
-- 
1.9.1

