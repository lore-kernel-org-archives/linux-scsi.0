From: Kashyap Desai <kashyap.desai@broadcom.com>
Subject: [PATCH v3 5/8] megaraid_sas: Send SYNCHRONIZE_CACHE for VD to firmware
Date: Fri, 21 Oct 2016 06:33:33 -0700
Message-ID: <1477056816-7058-6-git-send-email-kashyap.desai@broadcom.com>
References: <1477056816-7058-1-git-send-email-kashyap.desai@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:36496 "EHLO
        mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755335AbcJUNeZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Oct 2016 09:34:25 -0400
Received: by mail-pf0-f181.google.com with SMTP id e6so57249628pfk.3
        for <linux-scsi@vger.kernel.org>; Fri, 21 Oct 2016 06:34:25 -0700 (PDT)
In-Reply-To: <1477056816-7058-1-git-send-email-kashyap.desai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, sumit.saxena@broadcom.com, Kashyap Desai <kashyap.desai@broadcom.com>

>From previous patch we have below changes in v2 (only for Virtual Disk)-
1.  Updated change log.  Provided more detail in change log.
2.  Agreed to remove module parameter. If we remove module parameter, we
    can ask customer to disable WCE on drive to get similar impact.
3.  Always Send SYNCHRONIZE_CACHE  for JBOD (non Raid) Device to Firmware.

Current megaraid_sas driver returns SYNCHRONIZE_CACHE(related to Drive
Cache)  command  back to SCSI layer without sending it down to firmware as
firmware supposed to take care of flushing disk cache for all drives
belongs to Virtual Disk at the time of system reboot/shutdown.

We evaluate and understood that for Raid Volume, why driver should not
send SYNC_CACHE command to the Firmware.
There may be a some reason in past, but now it looks to be not required and
we have fixed this issue as part of this patch.

 - Additional background -
There are some instance of MegaRaid FW (E.a Gen2 and Gen2.5 FW) set WCE bit
for Virtual Disk but firmware does not reply correct status for SYNCH_CACHE.
It is very difficult to find out which Device ID and firmware has capability
to manage SYNC_CACHE, so we managed to figure out which are the new firmware
(canHandleSyncCache is set in scratch pad register at 0xB4) and use that
interface for correct behavior as explained above.

E.g Liberator/Thunderbolt MegaRaid FW returns SYNC_CACHE as Unsupported
command (this is a firmware bug) and eventually command will be failed to SML.
This will cause File system to go Read-only.

 - New behavior described -

IF application requests SYNCH_CACHE
   IF 'JBOD'
              Driver sends SYNCH_CACHE command to the FW
               FW sends SYNCH_CACHE to drive
               FW obtains status from drive and returns same status back to driver
   ELSEIF 'VirtualDisk'
               IF any FW which supports new API bit called canHandleSyncCache
                              Driver sends SYNCH_CACHE command to the FW
                              FW does not send SYNCH_CACHE to drives
                              FW returns SUCCESS
               ELSE
                              Driver does not send SYNCH_CACHE command to the FW.
                              Driver return SUCCESS for that command.
               ENDIF
    ENDIF
ENDIF

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas.h        | 3 +++
 drivers/scsi/megaraid/megaraid_sas_base.c   | 7 ++-----
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 5 +++++
 3 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index ca86c88..43fd14f 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -1429,6 +1429,8 @@ enum FW_BOOT_CONTEXT {
 #define MR_MAX_REPLY_QUEUES_EXT_OFFSET_SHIFT    14
 #define MR_MAX_MSIX_REG_ARRAY                   16
 #define MR_RDPQ_MODE_OFFSET			0X00800000
+#define MR_CAN_HANDLE_SYNC_CACHE_OFFSET		0X01000000
+
 /*
 * register set for both 1068 and 1078 controllers
 * structure extended for 1078 registers
@@ -2140,6 +2142,7 @@ struct megasas_instance {
 	u8 is_imr;
 	u8 is_rdpq;
 	bool dev_handle;
+	bool fw_sync_cache_support;
 };
 struct MR_LD_VF_MAP {
 	u32 size;
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index c98d4f9..236b8ed 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1700,11 +1700,8 @@ megasas_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 		goto out_done;
 	}
 
-	/*
-	 * FW takes care of flush cache on its own for Virtual Disk.
-	 * No need to send it down for VD. For JBOD send SYNCHRONIZE_CACHE to FW.
-	 */
-	if ((scmd->cmnd[0] == SYNCHRONIZE_CACHE) && MEGASAS_IS_LOGICAL(scmd)) {
+	if ((scmd->cmnd[0] == SYNCHRONIZE_CACHE) && MEGASAS_IS_LOGICAL(scmd) &&
+		(!instance->fw_sync_cache_support)) {
 		scmd->result = DID_OK << 16;
 		goto out_done;
 	}
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index ec626fc..0edeeb1 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -748,6 +748,11 @@ megasas_ioc_init_fusion(struct megasas_instance *instance)
 		goto fail_fw_init;
 	}
 
+	instance->fw_sync_cache_support = (scratch_pad_2 &
+		MR_CAN_HANDLE_SYNC_CACHE_OFFSET) ? 1 : 0;
+	dev_info(&instance->pdev->dev, "FW supports sync cache\t: %s\n",
+		 instance->fw_sync_cache_support ? "Yes" : "No");
+
 	IOCInitMessage =
 	  dma_alloc_coherent(&instance->pdev->dev,
 			     sizeof(struct MPI2_IOC_INIT_REQUEST),
-- 
2.4.11

