From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH v3 24/39] megaraid_sas: set pd_after_lb from MR_BuildRaidContext and initialize pDevHandle to MR_DEVHANDLE_INVALID
Date: Fri, 10 Feb 2017 00:59:24 -0800
Message-ID: <1486717179-23320-25-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1486717179-23320-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f44.google.com ([74.125.83.44]:34530 "EHLO
        mail-pg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752310AbdBJKno (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Feb 2017 05:43:44 -0500
Received: by mail-pg0-f44.google.com with SMTP id 14so9742874pgg.1
        for <linux-scsi@vger.kernel.org>; Fri, 10 Feb 2017 02:43:03 -0800 (PST)
In-Reply-To: <1486717179-23320-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Issue is limited for Syncro firmware where pd_after_lb is not set but is accidentally used.
Not a functional issue, but results in low performance due to improper load balancing between two LUNs.

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas_fp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fp.c b/drivers/scsi/megaraid/megaraid_sas_fp.c
index 68582d9..a5517e7 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fp.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fp.c
@@ -948,6 +948,7 @@ static u8 mr_spanset_get_phy_params(struct megasas_instance *instance, u32 ld,
 	struct fusion_context *fusion;
 
 	fusion = instance->ctrl_context;
+	*pDevHandle = cpu_to_le16(MR_DEVHANDLE_INVALID);
 
 	/*Get row and span from io_info for Uneven Span IO.*/
 	row	    = io_info->start_row;
@@ -986,7 +987,6 @@ static u8 mr_spanset_get_phy_params(struct megasas_instance *instance, u32 ld,
 				MR_PdDevHandleGet(r1_alt_pd, map);
 		}
 	} else {
-		*pDevHandle = cpu_to_le16(MR_DEVHANDLE_INVALID);
 		if ((raid->level >= 5) &&
 			((fusion->adapter_type == THUNDERBOLT_SERIES)  ||
 			((fusion->adapter_type == INVADER_SERIES) &&
@@ -1013,6 +1013,7 @@ static u8 mr_spanset_get_phy_params(struct megasas_instance *instance, u32 ld,
 			(span << RAID_CTX_SPANARM_SPAN_SHIFT) | physArm;
 		io_info->span_arm = pRAID_Context->span_arm;
 	}
+	io_info->pd_after_lb = pd;
 	return retval;
 }
 
@@ -1049,7 +1050,7 @@ u8 MR_GetPhyParams(struct megasas_instance *instance, u32 ld, u64 stripRow,
 	struct fusion_context *fusion;
 
 	fusion = instance->ctrl_context;
-
+	*pDevHandle = cpu_to_le16(MR_DEVHANDLE_INVALID);
 
 	row =  mega_div64_32(stripRow, raid->rowDataSize);
 
@@ -1102,8 +1103,6 @@ u8 MR_GetPhyParams(struct megasas_instance *instance, u32 ld, u64 stripRow,
 					MR_PdDevHandleGet(r1_alt_pd, map);
 		}
 	} else {
-		/* set dev handle as invalid. */
-		*pDevHandle = cpu_to_le16(MR_DEVHANDLE_INVALID);
 		if ((raid->level >= 5) &&
 			((fusion->adapter_type == THUNDERBOLT_SERIES)  ||
 			((fusion->adapter_type == INVADER_SERIES) &&
@@ -1132,6 +1131,7 @@ u8 MR_GetPhyParams(struct megasas_instance *instance, u32 ld, u64 stripRow,
 			(span << RAID_CTX_SPANARM_SPAN_SHIFT) | physArm;
 		io_info->span_arm = pRAID_Context->span_arm;
 	}
+	io_info->pd_after_lb = pd;
 	return retval;
 }
 
-- 
2.8.3
