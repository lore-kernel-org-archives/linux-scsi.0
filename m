From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH v3 38/39] megaraid_sas: Change RAID_1_10_RMW_CMDS to RAID_1_PEER_CMDS and set value to 2
Date: Fri, 10 Feb 2017 00:59:38 -0800
Message-ID: <1486717179-23320-39-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1486717179-23320-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:35348 "EHLO
        mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752129AbdBJLCu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Feb 2017 06:02:50 -0500
Received: by mail-pf0-f178.google.com with SMTP id 202so5628190pfx.2
        for <linux-scsi@vger.kernel.org>; Fri, 10 Feb 2017 03:02:37 -0800 (PST)
In-Reply-To: <1486717179-23320-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

For RAID1 FastPath writes, driver needs to allocate extra commands
internally to accommodate for the extra peer command being sent.
Currently driver is allocating 2 extra commands for each but only
one extra command is necessary.
Set RAID_1_10_RMW_CMDS to 2 and also change macro name to
RAID_1_PEER_CMDS.

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 2 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 9928766..7500901 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -293,7 +293,7 @@ megasas_fusion_update_can_queue(struct megasas_instance *instance, int fw_boot_c
 
 	if (instance->is_ventura)
 		instance->max_mpt_cmds =
-		instance->max_fw_cmds * RAID_1_10_RMW_CMDS;
+		instance->max_fw_cmds * RAID_1_PEER_CMDS;
 	else
 		instance->max_mpt_cmds = instance->max_fw_cmds;
 }
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.h b/drivers/scsi/megaraid/megaraid_sas_fusion.h
index 8e8c35f..d78d7611 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
@@ -101,7 +101,7 @@ enum MR_RAID_FLAGS_IO_SUB_TYPE {
 #define MEGASAS_FP_CMD_LEN	16
 #define MEGASAS_FUSION_IN_RESET 0
 #define THRESHOLD_REPLY_COUNT 50
-#define RAID_1_10_RMW_CMDS 3
+#define RAID_1_PEER_CMDS 2
 #define JBOD_MAPS_COUNT	2
 
 enum MR_FUSION_ADAPTER_TYPE {
-- 
2.8.3
