From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH v3 04/39] megaraid_sas: 32 bit descriptor fire cmd optimization
Date: Fri, 10 Feb 2017 00:59:04 -0800
Message-ID: <1486717179-23320-5-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1486717179-23320-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:33497 "EHLO
        mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751668AbdBJJKc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Feb 2017 04:10:32 -0500
Received: by mail-pf0-f180.google.com with SMTP id c73so4638347pfb.0
        for <linux-scsi@vger.kernel.org>; Fri, 10 Feb 2017 01:09:45 -0800 (PST)
In-Reply-To: <1486717179-23320-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

No functional change. Code refactor.
megasas_fire_cmd_fusion can always use 32 bit descriptor write for ventura. No need to pass extra flag.
Only IOC INIT required 64 bit Descriptor write.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 65 +++++++++++++++--------------
 1 file changed, 33 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 7516589..24b72c5 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -188,40 +188,35 @@ inline void megasas_return_cmd_fusion(struct megasas_instance *instance,
 
 /**
  * megasas_fire_cmd_fusion -	Sends command to the FW
+ * @instance:			Adapter soft state
+ * @req_desc:			32bit or 64bit Request descriptor
+ *
+ * Perform PCI Write. Ventura supports 32 bit Descriptor.
+ * Prior to Ventura (12G) MR controller supports 64 bit Descriptor.
  */
+
 static void
 megasas_fire_cmd_fusion(struct megasas_instance *instance,
-	union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc, bool is_32bit)
+		union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc)
 {
-	struct megasas_register_set __iomem *regs = instance->reg_set;
-	unsigned long flags;
-
-	if (is_32bit)
+	if (instance->is_ventura)
 		writel(le32_to_cpu(req_desc->u.low),
-			&(regs)->inbound_single_queue_port);
-	else if (instance->is_ventura) {
+			&instance->reg_set->inbound_single_queue_port);
+	else {
+#if defined(writeq) && defined(CONFIG_64BIT)
+		u64 req_data = (((u64)le32_to_cpu(req_desc->u.high) << 32) |
+				le32_to_cpu(req_desc->u.low));
+
+		writeq(req_data, &instance->reg_set->inbound_low_queue_port);
+#else
+		unsigned long flags;
 		spin_lock_irqsave(&instance->hba_lock, flags);
 		writel(le32_to_cpu(req_desc->u.low),
-			&(regs)->inbound_low_queue_port);
+			&instance->reg_set->inbound_low_queue_port);
 		writel(le32_to_cpu(req_desc->u.high),
-			&(regs)->inbound_high_queue_port);
+			&instance->reg_set->inbound_high_queue_port);
 		mmiowb();
 		spin_unlock_irqrestore(&instance->hba_lock, flags);
-	} else {
-#if defined(writeq) && defined(CONFIG_64BIT)
-	u64 req_data = (((u64)le32_to_cpu(req_desc->u.high) << 32) |
-			le32_to_cpu(req_desc->u.low));
-
-	writeq(req_data, &instance->reg_set->inbound_low_queue_port);
-#else
-
-	spin_lock_irqsave(&instance->hba_lock, flags);
-	writel(le32_to_cpu(req_desc->u.low),
-		&instance->reg_set->inbound_low_queue_port);
-	writel(le32_to_cpu(req_desc->u.high),
-		&instance->reg_set->inbound_high_queue_port);
-	mmiowb();
-	spin_unlock_irqrestore(&instance->hba_lock, flags);
 #endif
 	}
 }
@@ -771,6 +766,7 @@ megasas_ioc_init_fusion(struct megasas_instance *instance)
 	const char *sys_info;
 	MFI_CAPABILITIES *drv_ops;
 	u32 scratch_pad_2;
+	unsigned long flags;
 
 	fusion = instance->ctrl_context;
 
@@ -897,7 +893,14 @@ megasas_ioc_init_fusion(struct megasas_instance *instance)
 			break;
 	}
 
-	megasas_fire_cmd_fusion(instance, &req_desc, false);
+	/* For Ventura also IOC INIT required 64 bit Descriptor write. */
+	spin_lock_irqsave(&instance->hba_lock, flags);
+	writel(le32_to_cpu(req_desc.u.low),
+	       &instance->reg_set->inbound_low_queue_port);
+	writel(le32_to_cpu(req_desc.u.high),
+	       &instance->reg_set->inbound_high_queue_port);
+	mmiowb();
+	spin_unlock_irqrestore(&instance->hba_lock, flags);
 
 	wait_and_poll(instance, cmd, MFI_POLL_TIMEOUT_SECS);
 
@@ -2577,11 +2580,10 @@ megasas_build_and_issue_cmd_fusion(struct megasas_instance *instance,
 	 * Issue the command to the FW
 	 */
 
-	megasas_fire_cmd_fusion(instance, req_desc, instance->is_ventura);
+	megasas_fire_cmd_fusion(instance, req_desc);
 
 	if (r1_cmd)
-		megasas_fire_cmd_fusion(instance, r1_cmd->request_desc,
-				instance->is_ventura);
+		megasas_fire_cmd_fusion(instance, r1_cmd->request_desc);
 
 
 	return 0;
@@ -3001,7 +3003,7 @@ megasas_issue_dcmd_fusion(struct megasas_instance *instance,
 		return DCMD_NOT_FIRED;
 	}
 
-	megasas_fire_cmd_fusion(instance, req_desc, instance->is_ventura);
+	megasas_fire_cmd_fusion(instance, req_desc);
 	return DCMD_SUCCESS;
 }
 
@@ -3294,8 +3296,7 @@ void megasas_refire_mgmt_cmd(struct megasas_instance *instance)
 				cpu_to_le32(MR_DCMD_SYSTEM_PD_MAP_GET_INFO)))
 				&& !(cmd_mfi->flags & DRV_DCMD_SKIP_REFIRE);
 		if (refire_cmd)
-			megasas_fire_cmd_fusion(instance, req_desc,
-				instance->is_ventura);
+			megasas_fire_cmd_fusion(instance, req_desc);
 		else
 			megasas_return_cmd(instance, cmd_mfi);
 	}
@@ -3474,7 +3475,7 @@ megasas_issue_tm(struct megasas_instance *instance, u16 device_handle,
 		mr_request->tmReqFlags.isTMForLD = 1;
 
 	init_completion(&cmd_fusion->done);
-	megasas_fire_cmd_fusion(instance, req_desc, instance->is_ventura);
+	megasas_fire_cmd_fusion(instance, req_desc);
 
 	timeleft = wait_for_completion_timeout(&cmd_fusion->done, 50 * HZ);
 
-- 
2.8.3
