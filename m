From: <Sumit.Saxena@lsi.com>
Subject: [PATCH][SCSI] megaraid_sas: megaraid_sas driver init fails in
 kdump kernel
Date: Tue, 16 Jul 2013 02:26:05 +0530
Message-ID: <201307151253.r6FCrWTO011638@cosmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.199.154.253] ([213.199.154.253]:23086 "EHLO
	db9outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755996Ab3GOMzB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Jul 2013 08:55:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jbottomley@parallels.com
Cc: sumit.saxena@lsi.com, kashyap.desai@lsi.com, aradford@gmail.com, thenzl@redhat.com

Problem: When Hardware IOMMU is on, megaraid_sas driver initialization fails in kdump kernel with LSI MegaRAID controller(device id-0x73). This issue was reported to Redhat Bugzilla. Redhat bugzilla ID is 833299.

Actually this issue needs fix in firmware, but for firmware running in field, this driver fix is proposed to resolve the issue.
At firmware initialization time, if firmware does not come to ready state, driver will reset the adapter and retry for firmware transition to ready state unconditionally(not only executed for kdump kernel).

Signed-off-by: Sumit Saxena <sumit.saxena@lsi.com>
Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 4c4abe1..e009a6b 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3547,11 +3547,21 @@ static int megasas_init_fw(struct megasas_instance *instance)
 		break;
 	}
 
-	/*
-	 * We expect the FW state to be READY
-	 */
-	if (megasas_transition_to_ready(instance, 0))
-		goto fail_ready_state;
+	if (megasas_transition_to_ready(instance, 0)) {
+		atomic_set(&instance->fw_reset_no_pci_access, 1);
+		instance->instancet->adp_reset
+			(instance, instance->reg_set);
+		atomic_set(&instance->fw_reset_no_pci_access, 0);
+		dev_info(&instance->pdev->dev,
+			"megasas: FW restarted successfully from %s!\n",
+			__func__);
+
+		/*waitting for about 30 second before retry*/
+		ssleep(30);
+
+		if (megasas_transition_to_ready(instance, 0))
+			goto fail_ready_state;
+	}
 
 	/*
 	 * MSI-X host index 0 is common for all adapter.

