From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] megaraid_sas: Fallback to older scanning if not disks are found
Date: Fri, 15 Jan 2016 15:13:13 +0100
Message-ID: <1452867193-41266-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47908 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752987AbcAOONR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jan 2016 09:13:17 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit Saxena <sumit.saxena@avagotech.com>
Cc: Kashyap Desai <kashyap.desai@avagotech.com>, megaraidlinux.pdl@avagotech.com, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

commit 21c9e160a51383d4cb0b882398534b0c95c0cc3b implemented a
new driver lookup using the MR_DCMD_LD_LIST_QUERY firmware command.
However, this command might not work properly on older firmware,
causing the command to return no drives instead of an error.
This causes a regression on older firmware as the driver will
no longer detect any drives.
This patch checks if MR_DCMD_LD_LIST_QUERY return no drives,
and falls back to the original method if so.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index f97ec34..79dff70 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4107,6 +4107,10 @@ megasas_ld_list_query(struct megasas_instance *instance, u8 query_type)
 		ret = megasas_issue_polled(instance, cmd);
 
 	tgtid_count = le32_to_cpu(ci->count);
+	if (tgtid_count == 0) {
+		/* No drives found, try the older LD list DCMD */
+		ret = 1;
+	}
 
 	if ((ret == 0) && (tgtid_count <= (instance->fw_supported_vd_count))) {
 		memset(instance->ld_ids, 0xff, MEGASAS_MAX_LD_IDS);
-- 
1.8.5.6

