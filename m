From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 13/19] megaraid_sas: Update current host time to FW during IOC Init
Date: Thu, 19 Oct 2017 02:49:00 -0700
Message-ID: <1508406546-25944-14-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1508406546-25944-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:51540 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752626AbdJSJuc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Oct 2017 05:50:32 -0400
Received: by mail-pg0-f65.google.com with SMTP id p9so6755482pgc.8
        for <linux-scsi@vger.kernel.org>; Thu, 19 Oct 2017 02:50:32 -0700 (PDT)
In-Reply-To: <1508406546-25944-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Driver needs to send current host time to firmware during init.

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index a630a31aecf8..277fd16305ee 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -773,6 +773,7 @@ megasas_ioc_init_fusion(struct megasas_instance *instance)
 	MFI_CAPABILITIES *drv_ops;
 	u32 scratch_pad_2;
 	unsigned long flags;
+	struct timeval tv;
 
 	fusion = instance->ctrl_context;
 
@@ -821,6 +822,12 @@ megasas_ioc_init_fusion(struct megasas_instance *instance)
 	IOCInitMessage->SystemRequestFrameBaseAddress = cpu_to_le64(fusion->io_request_frames_phys);
 	IOCInitMessage->HostMSIxVectors = instance->msix_vectors;
 	IOCInitMessage->HostPageSize = MR_DEFAULT_NVME_PAGE_SHIFT;
+
+	do_gettimeofday(&tv);
+	/* Convert to milliseconds as per FW requirement */
+	IOCInitMessage->TimeStamp = cpu_to_le64((tv.tv_sec * 1000) +
+						(tv.tv_usec / 1000));
+
 	init_frame = (struct megasas_init_frame *)cmd->frame;
 	memset(init_frame, 0, MEGAMFI_FRAME_SIZE);
 
-- 
2.14.1.dirty
