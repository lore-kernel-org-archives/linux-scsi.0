From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/6] megaraid_sas_fusion: Fixup fire_cmd syntax
Date: Thu, 16 Jan 2014 11:25:32 +0100
Message-ID: <1389867936-118685-3-git-send-email-hare@suse.de>
References: <1389867936-118685-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39890 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513AbaAPKZi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Jan 2014 05:25:38 -0500
In-Reply-To: <1389867936-118685-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Kashyap Desai <kashyap.desai@lsi.com>, Adam Radford <aradford@gmail.com>

The syntax for the 'fire_cmd' callback is not used correctly,
so fix it up to be consistent with the original definition.

Cc: Kashyap Desai <kashyap.desai@lsi.com>
Cc: Adam Radford <aradford@gmail.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 26 ++++++++++++--------------
 drivers/scsi/megaraid/megaraid_sas_fusion.h |  8 +-------
 2 files changed, 13 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index f655592..0a588a6 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -669,8 +669,8 @@ megasas_ioc_init_fusion(struct megasas_instance *instance)
 			break;
 	}
 
-	instance->instancet->fire_cmd(instance, req_desc->u.low,
-				      req_desc->u.high, instance->reg_set);
+	instance->instancet->fire_cmd(instance, req_desc->Words, 0,
+				      instance->reg_set);
 
 	wait_and_poll(instance, cmd);
 
@@ -1052,16 +1052,17 @@ fail_alloc_mfi_cmds:
  */
 void
 megasas_fire_cmd_fusion(struct megasas_instance *instance,
-			dma_addr_t req_desc_lo,
-			u32 req_desc_hi,
+			dma_addr_t frame_phys_addr,
+			u32 frame_count,
 			struct megasas_register_set __iomem *regs)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&instance->hba_lock, flags);
-
-	writel(le32_to_cpu(req_desc_lo), &(regs)->inbound_low_queue_port);
-	writel(le32_to_cpu(req_desc_hi), &(regs)->inbound_high_queue_port);
+	writel(le32_to_cpu(lower_32_bits(frame_phys_addr)),
+	       &(regs)->inbound_low_queue_port);
+	writel(le32_to_cpu(upper_32_bits(frame_phys_addr)),
+	       &(regs)->inbound_high_queue_port);
 	spin_unlock_irqrestore(&instance->hba_lock, flags);
 }
 
@@ -1830,8 +1831,7 @@ megasas_build_and_issue_cmd_fusion(struct megasas_instance *instance,
 	 */
 	atomic_inc(&instance->fw_outstanding);
 
-	instance->instancet->fire_cmd(instance,
-				      req_desc->u.low, req_desc->u.high,
+	instance->instancet->fire_cmd(instance, req_desc->Words, 0,
 				      instance->reg_set);
 
 	return 0;
@@ -2158,8 +2158,8 @@ megasas_issue_dcmd_fusion(struct megasas_instance *instance,
 		printk(KERN_ERR "Couldn't issue MFI pass thru cmd\n");
 		return;
 	}
-	instance->instancet->fire_cmd(instance, req_desc->u.low,
-				      req_desc->u.high, instance->reg_set);
+	instance->instancet->fire_cmd(instance, req_desc->Words, 0,
+				      instance->reg_set);
 }
 
 /**
@@ -2441,9 +2441,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost)
 							instance->instancet->
 							fire_cmd(instance,
 								 req_desc->
-								 u.low,
-								 req_desc->
-								 u.high,
+								 Words, 0,
 								 instance->
 								 reg_set);
 						}
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.h b/drivers/scsi/megaraid/megaraid_sas_fusion.h
index 35a5139..321896f 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
@@ -366,13 +366,7 @@ union MEGASAS_REQUEST_DESCRIPTOR_UNION {
 	struct MPI2_SCSI_TARGET_REQUEST_DESCRIPTOR         SCSITarget;
 	struct MPI2_RAID_ACCEL_REQUEST_DESCRIPTOR          RAIDAccelerator;
 	struct MEGASAS_RAID_MFA_IO_REQUEST_DESCRIPTOR      MFAIo;
-	union {
-		struct {
-			u32 low;
-			u32 high;
-		} u;
-		u64 Words;
-	};
+	u64 Words;
 };
 
 /* Default Reply Descriptor */
-- 
1.7.12.4

