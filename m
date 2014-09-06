From: <Sumit.Saxena@avagotech.com>
Subject: [PATCH 02/11] megaraid_sas : Use writeq for 64bit pci write to
 avoid spinlock overhead
Date: Sat, 6 Sep 2014 18:55:46 +0530
Message-ID: <201409061328.s86DS4h1012830@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0053.outbound.protection.outlook.com ([157.56.111.53]:10308
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751284AbaIFNld (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 6 Sep 2014 09:41:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, aradford@gmail.com

Use writeq() for 64bit PCI write instead of writel() to avoid additional lock overhead.

Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 57b47fe..c69c1ac 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -1065,6 +1065,13 @@ megasas_fire_cmd_fusion(struct megasas_instance *instance,
 			u32 req_desc_hi,
 			struct megasas_register_set __iomem *regs)
 {
+#if defined(writeq) && defined(CONFIG_64BIT)
+	u64 req_data = 0;
+
+	req_data = req_desc_hi;
+	req_data = ((req_data << 32) | (u32)req_desc_lo);
+	writeq(le64_to_cpu(req_data), &(regs)->inbound_low_queue_port);
+#else
 	unsigned long flags;
 
 	spin_lock_irqsave(&instance->hba_lock, flags);
@@ -1072,6 +1079,7 @@ megasas_fire_cmd_fusion(struct megasas_instance *instance,
 	writel(le32_to_cpu(req_desc_lo), &(regs)->inbound_low_queue_port);
 	writel(le32_to_cpu(req_desc_hi), &(regs)->inbound_high_queue_port);
 	spin_unlock_irqrestore(&instance->hba_lock, flags);
+#endif
 }
 
 /**
-- 
1.8.3.1

