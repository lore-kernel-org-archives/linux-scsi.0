From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] megaraid_sas: Disable controller reset for ppc
Date: Wed,  2 Oct 2013 11:03:23 +0200
Message-ID: <1380704603-65238-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36509 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753041Ab3JBJD1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Oct 2013 05:03:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Sumit Saxena <sumit.saxena@lsi.com>, Adam Radford <aradford@gmail.com>

PPC (PCI ID 0x1000:0x0060) based HBAs will crash the firmware
when an OCR is attempted. So disable it for these controllers.

Cc: Sumit Saxena <sumit.saxena@lsi.com>
Cc: Adam Radford <aradford@gmail.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 0177295..fd75d6e 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -516,6 +516,17 @@ megasas_check_reset_ppc(struct megasas_instance *instance,
 	return 0;
 }
 
+/**
+ * megasas_adp_reset_ppc -  For controller reset
+ * @regs:                              MFI register set
+ */
+static int
+megasas_adp_reset_ppc(struct megasas_instance *instance,
+	struct megasas_register_set __iomem *regs)
+{
+	return 0;
+}
+
 static struct megasas_instance_template megasas_instance_template_ppc = {
 
 	.fire_cmd = megasas_fire_cmd_ppc,
@@ -523,7 +534,7 @@ static struct megasas_instance_template megasas_instance_template_ppc = {
 	.disable_intr = megasas_disable_intr_ppc,
 	.clear_intr = megasas_clear_intr_ppc,
 	.read_fw_status_reg = megasas_read_fw_status_reg_ppc,
-	.adp_reset = megasas_adp_reset_xscale,
+	.adp_reset = megasas_adp_reset_ppc,
 	.check_reset = megasas_check_reset_ppc,
 	.service_isr = megasas_isr,
 	.tasklet = megasas_complete_cmd_dpc,
-- 
1.7.12.4

