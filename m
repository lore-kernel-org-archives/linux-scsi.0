From: <Sumit.Saxena@avagotech.com>
Subject: [PATCH RESEND 02/11] megaraid_sas : Use writeq for 64bit pci
 write to avoid spinlock overhead
Date: Fri, 12 Sep 2014 18:57:18 +0530
Message-ID: <201409121329.s8CDTepX022300@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0080.outbound.protection.outlook.com ([207.46.100.80]:5536
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753661AbaILN1e (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Sep 2014 09:27:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, aradford@gmail.com

Resending the patch. Addressed the review comments from Tomas Henzl.
Reduce the assingment for u64 req_data variable.

Use writeq() for 64bit PCI write instead of writel() to avoid additional lock overhead.

Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 57b47fe..8898817 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -1065,6 +1065,11 @@ megasas_fire_cmd_fusion(struct megasas_instance *instance,
 			u32 req_desc_hi,
 			struct megasas_register_set __iomem *regs)
 {
+#if defined(writeq) && defined(CONFIG_64BIT)
+	u64 req_data = (((u64)req_desc_hi << 32) | (u32)req_desc_lo);
+
+	writeq(le64_to_cpu(req_data), &(regs)->inbound_low_queue_port);
+#else
 	unsigned long flags;
 
 	spin_lock_irqsave(&instance->hba_lock, flags);
@@ -1072,6 +1077,7 @@ megasas_fire_cmd_fusion(struct megasas_instance *instance,
 	writel(le32_to_cpu(req_desc_lo), &(regs)->inbound_low_queue_port);
 	writel(le32_to_cpu(req_desc_hi), &(regs)->inbound_high_queue_port);
 	spin_unlock_irqrestore(&instance->hba_lock, flags);
+#endif
 }
 
 /**
-- 
1.8.3.1

