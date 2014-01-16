From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/6] megaraid_sas_fusion: correctly pass queue info pointer
Date: Thu, 16 Jan 2014 11:25:33 +0100
Message-ID: <1389867936-118685-4-git-send-email-hare@suse.de>
References: <1389867936-118685-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39887 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535AbaAPKZi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Jan 2014 05:25:38 -0500
In-Reply-To: <1389867936-118685-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Kashyap Desai <kashyap.desai@lsi.com>, Adam Radford <aradford@gmail.com>

The pointer to the queue info structure is potentially
a 64-bit value, so we should be using the correct macros
to set the values in the init frame.

Cc: Kashyap Desai <kashyap.desai@lsi.com>
Cc: Adam Radford <aradford@gmail.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 0a588a6..5c30f9d 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -644,7 +644,10 @@ megasas_ioc_init_fusion(struct megasas_instance *instance)
 	/* Convert capability to LE32 */
 	cpu_to_le32s((u32 *)&init_frame->driver_operations.mfi_capabilities);
 
-	init_frame->queue_info_new_phys_addr_lo = cpu_to_le32((u32)ioc_init_handle);
+	init_frame->queue_info_new_phys_addr_hi =
+		cpu_to_le32(upper_32_bits(ioc_init_handle));
+	init_frame->queue_info_new_phys_addr_lo =
+		cpu_to_le32(lower_32_bits(ioc_init_handle));
 	init_frame->data_xfer_len = cpu_to_le32(sizeof(struct MPI2_IOC_INIT_REQUEST));
 
 	req_desc =
-- 
1.7.12.4

