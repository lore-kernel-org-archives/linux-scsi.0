From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH v3 18/39] megaraid_sas: In validate raid map, raid capability is not converted to cpu format for all lds
Date: Fri, 10 Feb 2017 00:59:18 -0800
Message-ID: <1486717179-23320-19-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1486717179-23320-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f54.google.com ([74.125.83.54]:35666 "EHLO
        mail-pg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752481AbdBJJcp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Feb 2017 04:32:45 -0500
Received: by mail-pg0-f54.google.com with SMTP id 194so9240304pgd.2
        for <linux-scsi@vger.kernel.org>; Fri, 10 Feb 2017 01:32:45 -0800 (PST)
In-Reply-To: <1486717179-23320-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

On a host, if an ld is deleted there is a hole in the ld array returned
by the FW. But in MR_ValidateMapInfo we are not accounting for holes in
the ld array and traverse only upto index num_lds.
This patch takes care of converting the capability field of all the
valid lds in the ld raid map.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas_fp.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fp.c b/drivers/scsi/megaraid/megaraid_sas_fp.c
index d9b0f28..a0b0e68 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fp.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fp.c
@@ -452,7 +452,7 @@ u8 MR_ValidateMapInfo(struct megasas_instance *instance)
 	struct LD_LOAD_BALANCE_INFO *lbInfo;
 	PLD_SPAN_INFO ldSpanInfo;
 	struct MR_LD_RAID         *raid;
-	u16 ldCount, num_lds;
+	u16 num_lds, i;
 	u16 ld;
 	u32 expected_size;
 
@@ -495,10 +495,17 @@ u8 MR_ValidateMapInfo(struct megasas_instance *instance)
 	num_lds = le16_to_cpu(drv_map->raidMap.ldCount);
 
 	/*Convert Raid capability values to CPU arch */
-	for (ldCount = 0; ldCount < num_lds; ldCount++) {
-		ld = MR_TargetIdToLdGet(ldCount, drv_map);
+	for (i = 0; (num_lds > 0) && (i < MAX_LOGICAL_DRIVES_EXT); i++) {
+		ld = MR_TargetIdToLdGet(i, drv_map);
+
+		/* For non existing VDs, iterate to next VD*/
+		if (ld >= (MAX_LOGICAL_DRIVES_EXT - 1))
+			continue;
+
 		raid = MR_LdRaidGet(ld, drv_map);
 		le32_to_cpus((u32 *)&raid->capability);
+
+		num_lds--;
 	}
 
 	return 1;
-- 
2.8.3
