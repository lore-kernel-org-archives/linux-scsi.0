From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 02/14] megaraid_sas: memset IOC INIT frame using correct size
Date: Fri,  5 Jan 2018 05:27:37 -0800
Message-ID: <1515158869-26693-3-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1515158869-26693-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:38007 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751646AbeAEN3N (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Jan 2018 08:29:13 -0500
Received: by mail-pg0-f66.google.com with SMTP id t67so1992046pgc.5
        for <linux-scsi@vger.kernel.org>; Fri, 05 Jan 2018 05:29:13 -0800 (PST)
In-Reply-To: <1515158869-26693-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Commit b9637d14dc00 ("scsi: megaraid_sas: Resize MFA frame used for
IOC INIT to 4k") increased the size of IOC INIT frame to 4k.
Need to use updated size when memsetting init_frame.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 0d6d4dedad62..ea3312205a0e 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -1048,7 +1048,7 @@ megasas_ioc_init_fusion(struct megasas_instance *instance)
 						(tv.tv_usec / 1000));
 
 	init_frame = (struct megasas_init_frame *)cmd->frame;
-	memset(init_frame, 0, MEGAMFI_FRAME_SIZE);
+	memset(init_frame, 0, IOC_INIT_FRAME_SIZE);
 
 	frame_hdr = &cmd->frame->hdr;
 	frame_hdr->cmd_status = 0xFF;
-- 
2.14.1
