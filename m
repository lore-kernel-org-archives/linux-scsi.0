From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH v3 01/14] megaraid_sas: mismatch of allocated MFI frame size and length exposed in MFI MPT pass through command
Date: Wed, 23 Aug 2017 04:46:55 -0700
Message-ID: <1503488828-2242-2-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1503488828-2242-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f54.google.com ([74.125.83.54]:35530 "EHLO
        mail-pg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753793AbdHWLrb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Aug 2017 07:47:31 -0400
Received: by mail-pg0-f54.google.com with SMTP id u191so6293581pgc.2
        for <linux-scsi@vger.kernel.org>; Wed, 23 Aug 2017 04:47:31 -0700 (PDT)
In-Reply-To: <1503488828-2242-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, hch@lst.de, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, stable@vger.kernel.org

 Fix - Driver allocated 256 byte MFI frames bytes but while sending MFI
 frame (embedded inside chain frame of MPT frame) to firmware, driver
 sets the length as 4k. This results in DMA read error messages during
 boot.

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Cc: stable@vger.kernel.org
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 6b9db73..84cd4f8 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -3289,7 +3289,7 @@ irqreturn_t megasas_isr_fusion(int irq, void *devp)
 	mpi25_ieee_chain->Flags = IEEE_SGE_FLAGS_CHAIN_ELEMENT |
 		MPI2_IEEE_SGE_FLAGS_IOCPLBNTA_ADDR;
 
-	mpi25_ieee_chain->Length = cpu_to_le32(instance->max_chain_frame_sz);
+	mpi25_ieee_chain->Length = cpu_to_le32(instance->mfi_frame_size);
 }
 
 /**
-- 
1.8.3.1
