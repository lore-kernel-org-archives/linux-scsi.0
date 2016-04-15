From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: [PATCH 2/4] megaraid_sas: call ISR function to clean up pending replies in OCR path
Date: Fri, 15 Apr 2016 00:23:31 -0700
Message-ID: <1460705013-6482-3-git-send-email-sumit.saxena@broadcom.com>
References: <1460705013-6482-1-git-send-email-sumit.saxena@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:34419 "EHLO
	mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbcDOHYD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Apr 2016 03:24:03 -0400
Received: by mail-pf0-f170.google.com with SMTP id c20so54336205pfc.1
        for <linux-scsi@vger.kernel.org>; Fri, 15 Apr 2016 00:24:02 -0700 (PDT)
In-Reply-To: <1460705013-6482-1-git-send-email-sumit.saxena@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, hch@infradead.org, thenzl@redhat.com
Cc: kashyap.desai@broadcom.com, linux-scsi@vger.kernel.org, sumit.saxena@broadcom.com

In OCR path, before calling chip reset calls function megasas_wait_for_outstanding_fusion to check reason
of OCR. In case of firmware FAULT initiated OCR and DCMD timeout initiated timeout, driver will clear any
outstanding reply(yet to be processed by driver) in reply queues before going for chip reset.
This code is added to handle a scenario when IO timeout initiated adapter reset and management application
initiated adapter reset(by sending command to FAULT firmware) happens simultaneously since adapter reset
function is safe-guarded by reset_mutex so only thread will be doing controller reset. Consider IO timeout
thread gets mutex and proceeds with adapter reset process after disabling interrupts and by the time
managementapplication has fired command to firmware to do adapter reset and the same command is completed by
firmware but since interrupts are disabled, driver will not get completion and the same command will be in
outstanding/pendingcommands list of driver and refires same command from IO timeout thread after chip reset
which will again FAULT firmware and evntually causes kill adapter.

Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 320c1a0..e2dc205 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -2762,6 +2762,7 @@ int megasas_wait_for_outstanding_fusion(struct megasas_instance *instance,
 			dev_warn(&instance->pdev->dev, "Found FW in FAULT state,"
 			       " will reset adapter scsi%d.\n",
 				instance->host->host_no);
+			megasas_complete_cmd_dpc_fusion((unsigned long)instance);
 			retval = 1;
 			goto out;
 		}
@@ -2769,6 +2770,7 @@ int megasas_wait_for_outstanding_fusion(struct megasas_instance *instance,
 		if (reason == MFI_IO_TIMEOUT_OCR) {
 			dev_info(&instance->pdev->dev,
 				"MFI IO is timed out, initiating OCR\n");
+			megasas_complete_cmd_dpc_fusion((unsigned long)instance);
 			retval = 1;
 			goto out;
 		}
-- 
2.4.11

