From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH v2 01/15] megaraid_sas: mismatch of allocated MFI frame size and length exposed in MFI MPT pass through command
Date: Wed,  5 Jul 2017 05:00:15 -0700
Message-ID: <1499256029-16319-2-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1499256029-16319-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:36798 "EHLO
        mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752505AbdGEMBM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jul 2017 08:01:12 -0400
Received: by mail-pf0-f170.google.com with SMTP id q86so128696154pfl.3
        for <linux-scsi@vger.kernel.org>; Wed, 05 Jul 2017 05:01:12 -0700 (PDT)
In-Reply-To: <1499256029-16319-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, hch@lst.de, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

 Fix - Driver allocated 256 byte MFI frames bytes but while sending MFI
 frame (embedded inside chain frame of MPT frame) to firmware, driver
 sets the length as 4k. This results in DMA read error messages during
 boot.

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index f990ab4d..f717fbc 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -3283,7 +3283,7 @@ irqreturn_t megasas_isr_fusion(int irq, void *devp)
 	mpi25_ieee_chain->Flags = IEEE_SGE_FLAGS_CHAIN_ELEMENT |
 		MPI2_IEEE_SGE_FLAGS_IOCPLBNTA_ADDR;
 
-	mpi25_ieee_chain->Length = cpu_to_le32(instance->max_chain_frame_sz);
+	mpi25_ieee_chain->Length = cpu_to_le32(instance->mfi_frame_size);
 }
 
 /**
-- 
1.8.3.1
