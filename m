From: Souptick Joarder <jrdr.linux@gmail.com>
Subject: [PATCH] scsi: megaraid: Use dma_pool_zalloc()
Date: Thu, 15 Feb 2018 21:55:06 +0530
Message-ID: <20180215162506.GA9306@jordon-HP-15-Notebook-PC>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:45529 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1424203AbeBOQXt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Feb 2018 11:23:49 -0500
Received: by mail-pg0-f67.google.com with SMTP id e11so117464pgq.12
        for <linux-scsi@vger.kernel.org>; Thu, 15 Feb 2018 08:23:49 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com
Cc: megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org

Use dma_pool_zalloc() instead of dma_pool_alloc + memset

Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index a71ee67..905ea36 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4022,7 +4022,7 @@ static int megasas_create_frame_pool(struct megasas_instance *instance)

 		cmd = instance->cmd_list[i];

-		cmd->frame = dma_pool_alloc(instance->frame_dma_pool,
+		cmd->frame = dma_pool_zalloc(instance->frame_dma_pool,
 					    GFP_KERNEL, &cmd->frame_phys_addr);

 		cmd->sense = dma_pool_alloc(instance->sense_dma_pool,
@@ -4038,7 +4038,6 @@ static int megasas_create_frame_pool(struct megasas_instance *instance)
 			return -ENOMEM;
 		}

-		memset(cmd->frame, 0, instance->mfi_frame_size);
 		cmd->frame->io.context = cpu_to_le32(cmd->index);
 		cmd->frame->io.pad_0 = 0;
 		if ((instance->adapter_type == MFI_SERIES) && reset_devices)
--
1.9.1
