From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH v2] megaraid_sas: Do not use 32-bit atomic request descriptor for Ventura controllers
Date: Wed, 14 Feb 2018 00:10:52 -0800
Message-ID: <1518595852-1490-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:36020 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754589AbeBNILG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Feb 2018 03:11:06 -0500
Received: by mail-qk0-f196.google.com with SMTP id 15so25660942qkl.3
        for <linux-scsi@vger.kernel.org>; Wed, 14 Feb 2018 00:11:06 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, stable@vger.kernel.org

Problem Statement:
Sending I/O through 32 bit descriptors to Ventura series of controller
results in IO timeout on certain conditions.

This error only occurs on systems with high I/O activity on
Ventura series controllers.

Changes in this patch will prevent driver from using 32 bit descriptor
and use 64 bit Descriptors.

Cc: <stable@vger.kernel.org>
Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
---
Changes in v2:
Removed below text from function description:
 * Ventura supports 32 bit Descriptor.
 * Prior to Ventura (12G) MR controller supports 64 bit Descriptor.

 drivers/scsi/megaraid/megaraid_sas_fusion.c | 42 ++++++++++-------------------
 1 file changed, 14 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 073ced07e662..dc8e850fbfd2 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -216,36 +216,30 @@ inline void megasas_return_cmd_fusion(struct megasas_instance *instance,
 /**
  * megasas_fire_cmd_fusion -	Sends command to the FW
  * @instance:			Adapter soft state
- * @req_desc:			32bit or 64bit Request descriptor
+ * @req_desc:			64bit Request descriptor
  *
- * Perform PCI Write. Ventura supports 32 bit Descriptor.
- * Prior to Ventura (12G) MR controller supports 64 bit Descriptor.
+ * Perform PCI Write.
  */
 
 static void
 megasas_fire_cmd_fusion(struct megasas_instance *instance,
 		union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc)
 {
-	if (instance->adapter_type == VENTURA_SERIES)
-		writel(le32_to_cpu(req_desc->u.low),
-			&instance->reg_set->inbound_single_queue_port);
-	else {
 #if defined(writeq) && defined(CONFIG_64BIT)
-		u64 req_data = (((u64)le32_to_cpu(req_desc->u.high) << 32) |
-				le32_to_cpu(req_desc->u.low));
+	u64 req_data = (((u64)le32_to_cpu(req_desc->u.high) << 32) |
+		le32_to_cpu(req_desc->u.low));
 
-		writeq(req_data, &instance->reg_set->inbound_low_queue_port);
+	writeq(req_data, &instance->reg_set->inbound_low_queue_port);
 #else
-		unsigned long flags;
-		spin_lock_irqsave(&instance->hba_lock, flags);
-		writel(le32_to_cpu(req_desc->u.low),
-			&instance->reg_set->inbound_low_queue_port);
-		writel(le32_to_cpu(req_desc->u.high),
-			&instance->reg_set->inbound_high_queue_port);
-		mmiowb();
-		spin_unlock_irqrestore(&instance->hba_lock, flags);
+	unsigned long flags;
+	spin_lock_irqsave(&instance->hba_lock, flags);
+	writel(le32_to_cpu(req_desc->u.low),
+		&instance->reg_set->inbound_low_queue_port);
+	writel(le32_to_cpu(req_desc->u.high),
+		&instance->reg_set->inbound_high_queue_port);
+	mmiowb();
+	spin_unlock_irqrestore(&instance->hba_lock, flags);
 #endif
-	}
 }
 
 /**
@@ -982,7 +976,6 @@ megasas_ioc_init_fusion(struct megasas_instance *instance)
 	const char *sys_info;
 	MFI_CAPABILITIES *drv_ops;
 	u32 scratch_pad_2;
-	unsigned long flags;
 	ktime_t time;
 	bool cur_fw_64bit_dma_capable;
 
@@ -1121,14 +1114,7 @@ megasas_ioc_init_fusion(struct megasas_instance *instance)
 			break;
 	}
 
-	/* For Ventura also IOC INIT required 64 bit Descriptor write. */
-	spin_lock_irqsave(&instance->hba_lock, flags);
-	writel(le32_to_cpu(req_desc.u.low),
-	       &instance->reg_set->inbound_low_queue_port);
-	writel(le32_to_cpu(req_desc.u.high),
-	       &instance->reg_set->inbound_high_queue_port);
-	mmiowb();
-	spin_unlock_irqrestore(&instance->hba_lock, flags);
+	megasas_fire_cmd_fusion(instance, &req_desc);
 
 	wait_and_poll(instance, cmd, MFI_POLL_TIMEOUT_SECS);
 
-- 
2.16.1
