From: Kashyap Desai <kashyap.desai@broadcom.com>
Subject: [PATCH v3 7/8] megaraid_sas: Do not set MPI2_TYPE_CUDA for JBOD FP path for FW which does not support JBOD sequence map
Date: Fri, 21 Oct 2016 06:33:35 -0700
Message-ID: <1477056816-7058-8-git-send-email-kashyap.desai@broadcom.com>
References: <1477056816-7058-1-git-send-email-kashyap.desai@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:35473 "EHLO
        mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933402AbcJUNeb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Oct 2016 09:34:31 -0400
Received: by mail-pf0-f170.google.com with SMTP id s8so57270027pfj.2
        for <linux-scsi@vger.kernel.org>; Fri, 21 Oct 2016 06:34:30 -0700 (PDT)
In-Reply-To: <1477056816-7058-1-git-send-email-kashyap.desai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, sumit.saxena@broadcom.com, stable@vger.kernel.org

CC: stable@vger.kernel.org
Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 0edeeb1..1cf0e49 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -2005,6 +2005,8 @@ megasas_build_syspd_fusion(struct megasas_instance *instance,
 		io_request->DevHandle = pd_sync->seq[pd_index].devHandle;
 		pRAID_Context->regLockFlags |=
 			(MR_RL_FLAGS_SEQ_NUM_ENABLE|MR_RL_FLAGS_GRANT_DESTINATION_CUDA);
+		pRAID_Context->Type = MPI2_TYPE_CUDA;
+		pRAID_Context->nseg = 0x1;
 	} else if (fusion->fast_path_io) {
 		pRAID_Context->VirtualDiskTgtId = cpu_to_le16(device_id);
 		pRAID_Context->configSeqNum = 0;
@@ -2040,12 +2042,10 @@ megasas_build_syspd_fusion(struct megasas_instance *instance,
 		pRAID_Context->timeoutValue =
 			cpu_to_le16((os_timeout_value > timeout_limit) ?
 			timeout_limit : os_timeout_value);
-		if (fusion->adapter_type == INVADER_SERIES) {
-			pRAID_Context->Type = MPI2_TYPE_CUDA;
-			pRAID_Context->nseg = 0x1;
+		if (fusion->adapter_type == INVADER_SERIES)
 			io_request->IoFlags |=
 				cpu_to_le16(MPI25_SAS_DEVICE0_FLAGS_ENABLED_FAST_PATH);
-		}
+
 		cmd->request_desc->SCSIIO.RequestFlags =
 			(MPI2_REQ_DESCRIPT_FLAGS_FP_IO <<
 				MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
-- 
2.4.11

