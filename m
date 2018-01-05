From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 06/14] megaraid_sas: unload flag should be set after scsi_remove_host is called
Date: Fri,  5 Jan 2018 05:27:41 -0800
Message-ID: <1515158869-26693-7-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1515158869-26693-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:36810 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751731AbeAEN3Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Jan 2018 08:29:24 -0500
Received: by mail-pg0-f65.google.com with SMTP id j2so782119pgv.3
        for <linux-scsi@vger.kernel.org>; Fri, 05 Jan 2018 05:29:23 -0800 (PST)
In-Reply-To: <1515158869-26693-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Issue - Driver returns DID_NO_CONNECT when unload is in progress, indicated
using instance->unload flag. In case of dynamic unload of driver, this flag
is set before calling scsi_remove_host(). While doing manual driver unload,
user will see lots of prints for Sync Cache command with DID_NO_CONNECT status.

Fix - Set the instance->unload flag after scsi_remove_host(). Allow device
removal process to be completed and do not block any command before that.
SCSI commands (like SYNC_CACHE) are received (as part of scsi_remove_host)
by driver during unload will be submitted further down to the drives.

Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 424858874d57..8a0776d6c6fa 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -6827,7 +6827,6 @@ static void megasas_detach_one(struct pci_dev *pdev)
 	u32 pd_seq_map_sz;
 
 	instance = pci_get_drvdata(pdev);
-	instance->unload = 1;
 	host = instance->host;
 	fusion = instance->ctrl_context;
 
@@ -6838,6 +6837,7 @@ static void megasas_detach_one(struct pci_dev *pdev)
 	if (instance->fw_crash_state != UNAVAILABLE)
 		megasas_free_host_crash_buffer(instance);
 	scsi_remove_host(instance->host);
+	instance->unload = 1;
 
 	if (megasas_wait_for_adapter_operational(instance))
 		goto skip_firing_dcmds;
-- 
2.14.1
