From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 17/19] megaraid_sas: Do not limit queue_depth to 1k in non-RDPQ mode
Date: Thu, 19 Oct 2017 02:49:04 -0700
Message-ID: <1508406546-25944-18-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1508406546-25944-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:44834 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752621AbdJSJun (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Oct 2017 05:50:43 -0400
Received: by mail-pg0-f67.google.com with SMTP id j3so6770679pga.1
        for <linux-scsi@vger.kernel.org>; Thu, 19 Oct 2017 02:50:43 -0700 (PDT)
In-Reply-To: <1508406546-25944-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Earlier, driver load fails if memory allocation for request frame pool
fails due to the higher queue_depth requirement. Patch 0016 in this
series allows dynamically reducing queue_depth if memory allocations
fail rather than failing load.
With this, there is no need to limit queue_depth to 1k now.

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 8b7a08af275e..745da54c11aa 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -272,10 +272,6 @@ megasas_fusion_update_can_queue(struct megasas_instance *instance, int fw_boot_c
 		instance->max_fw_cmds = cur_max_fw_cmds;
 		instance->ldio_threshold = ldio_threshold;
 
-		if (!instance->is_rdpq)
-			instance->max_fw_cmds =
-				min_t(u16, instance->max_fw_cmds, 1024);
-
 		if (reset_devices)
 			instance->max_fw_cmds = min(instance->max_fw_cmds,
 						(u16)MEGASAS_KDUMP_QUEUE_DEPTH);
-- 
2.14.1.dirty
