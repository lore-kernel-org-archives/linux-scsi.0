From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 03/14] megaraid_sas: Return the DCMD status from megasas_get_seq_num
Date: Fri,  5 Jan 2018 05:27:38 -0800
Message-ID: <1515158869-26693-4-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1515158869-26693-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:39802 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751720AbeAEN3P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Jan 2018 08:29:15 -0500
Received: by mail-pl0-f68.google.com with SMTP id bi12so3039727plb.6
        for <linux-scsi@vger.kernel.org>; Fri, 05 Jan 2018 05:29:15 -0800 (PST)
In-Reply-To: <1515158869-26693-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

In megasas_get_seq_num, the status of the DCMD fired to FW is
not returned, always success is returned.
We could end up registering AEN request with incorrect sequence
number if the DCMD failed.
Return the DCMD status back to caller.
This was discovered during code review and very rare to see issue
in field to see AEN request failed bt FW.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 32 +++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index ed106cbd4440..38120917c609 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -5581,6 +5581,7 @@ megasas_get_seq_num(struct megasas_instance *instance,
 	struct megasas_dcmd_frame *dcmd;
 	struct megasas_evt_log_info *el_info;
 	dma_addr_t el_info_h = 0;
+	int ret;
 
 	cmd = megasas_get_cmd(instance);
 
@@ -5613,26 +5614,29 @@ megasas_get_seq_num(struct megasas_instance *instance,
 	megasas_set_dma_settings(instance, dcmd, el_info_h,
 				 sizeof(struct megasas_evt_log_info));
 
-	if (megasas_issue_blocked_cmd(instance, cmd, MFI_IO_TIMEOUT_SECS) ==
-		DCMD_SUCCESS) {
-		/*
-		 * Copy the data back into callers buffer
-		 */
-		eli->newest_seq_num = el_info->newest_seq_num;
-		eli->oldest_seq_num = el_info->oldest_seq_num;
-		eli->clear_seq_num = el_info->clear_seq_num;
-		eli->shutdown_seq_num = el_info->shutdown_seq_num;
-		eli->boot_seq_num = el_info->boot_seq_num;
-	} else
-		dev_err(&instance->pdev->dev, "DCMD failed "
-			"from %s\n", __func__);
+	ret = megasas_issue_blocked_cmd(instance, cmd, MFI_IO_TIMEOUT_SECS);
+	if (ret != DCMD_SUCCESS) {
+		dev_err(&instance->pdev->dev, "Failed from %s %d\n",
+			__func__, __LINE__);
+		goto dcmd_failed;
+	}
+
+	/*
+	 * Copy the data back into callers buffer
+	 */
+	eli->newest_seq_num = el_info->newest_seq_num;
+	eli->oldest_seq_num = el_info->oldest_seq_num;
+	eli->clear_seq_num = el_info->clear_seq_num;
+	eli->shutdown_seq_num = el_info->shutdown_seq_num;
+	eli->boot_seq_num = el_info->boot_seq_num;
 
+dcmd_failed:
 	pci_free_consistent(instance->pdev, sizeof(struct megasas_evt_log_info),
 			    el_info, el_info_h);
 
 	megasas_return_cmd(instance, cmd);
 
-	return 0;
+	return ret;
 }
 
 /**
-- 
2.14.1
