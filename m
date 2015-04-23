From: <Sumit.Saxena@avagotech.com>
Subject: [PATCH v3 13/18] megaraid_sas : add endianess conversions for all ones
Date: Thu, 23 Apr 2015 16:33:09 +0530
Message-ID: <201504231105.t3NB5PRW030571@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2lp0203.outbound.protection.outlook.com ([207.46.163.203]:26144
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932361AbbDWLDR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Apr 2015 07:03:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com

Add noop conversions for all ones to make sparse happy.

From: Christoph Hellwig <hch@lst.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c   |    2 +-
 drivers/scsi/megaraid/megaraid_sas_fp.c     |    7 ++++---
 drivers/scsi/megaraid/megaraid_sas_fusion.c |    9 +++++----
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index f91fa08..9299eaf 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1219,7 +1219,7 @@ megasas_build_dcdb(struct megasas_instance *instance, struct scsi_cmnd *scp,
 	*/
 	if (scp->device->type == TYPE_TAPE) {
 		if ((scp->request->timeout / HZ) > 0xFFFF)
-			pthru->timeout = 0xFFFF;
+			pthru->timeout = cpu_to_le16(0xFFFF);
 		else
 			pthru->timeout = cpu_to_le16(scp->request->timeout / HZ);
 	}
diff --git a/drivers/scsi/megaraid/megaraid_sas_fp.c b/drivers/scsi/megaraid/megaraid_sas_fp.c
index e9138a2..2001ffb 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fp.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fp.c
@@ -769,7 +769,7 @@ static u8 mr_spanset_get_phy_params(struct megasas_instance *instance, u32 ld,
 	if (pd != MR_PD_INVALID)
 		*pDevHandle = MR_PdDevHandleGet(pd, map);
 	else {
-		*pDevHandle = MR_PD_INVALID;
+		*pDevHandle = cpu_to_le16(MR_PD_INVALID);
 		if ((raid->level >= 5) &&
 			(!do_invader  || (do_invader &&
 			(raid->regTypeReqOnRead != REGION_TYPE_UNUSED))))
@@ -864,7 +864,8 @@ u8 MR_GetPhyParams(struct megasas_instance *instance, u32 ld, u64 stripRow,
 		/* Get dev handle from Pd. */
 		*pDevHandle = MR_PdDevHandleGet(pd, map);
 	else {
-		*pDevHandle = MR_PD_INVALID; /* set dev handle as invalid. */
+		/* set dev handle as invalid. */
+		*pDevHandle = cpu_to_le16(MR_PD_INVALID);
 		if ((raid->level >= 5) &&
 			(!do_invader  || (do_invader &&
 			(raid->regTypeReqOnRead != REGION_TYPE_UNUSED))))
@@ -1109,7 +1110,7 @@ MR_BuildRaidContext(struct megasas_instance *instance,
 					ref_in_start_stripe, io_info,
 					pRAID_Context, map);
 		/* If IO on an invalid Pd, then FP is not possible.*/
-		if (io_info->devHandle == MR_PD_INVALID)
+		if (io_info->devHandle == cpu_to_le16(MR_PD_INVALID))
 			io_info->fpOkForIo = FALSE;
 		return retval;
 	} else if (isRead) {
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 18873a7..b995774 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -415,7 +415,7 @@ megasas_alloc_cmds_fusion(struct megasas_instance *instance)
 
 	reply_desc = fusion->reply_frames_desc;
 	for (i = 0; i < fusion->reply_q_depth * count; i++, reply_desc++)
-		reply_desc->Words = ULLONG_MAX;
+		reply_desc->Words = cpu_to_le64(ULLONG_MAX);
 
 	io_frames_sz = fusion->io_frames_alloc_sz;
 
@@ -1997,7 +1997,8 @@ complete_cmd_fusion(struct megasas_instance *instance, u32 MSIxIndex)
 
 	num_completed = 0;
 
-	while ((d_val.u.low != UINT_MAX) && (d_val.u.high != UINT_MAX)) {
+	while (d_val.u.low != cpu_to_le32(UINT_MAX) &&
+	       d_val.u.high != cpu_to_le32(UINT_MAX)) {
 		smid = le16_to_cpu(reply_desc->SMID);
 
 		cmd_fusion = fusion->cmd_list[smid - 1];
@@ -2061,7 +2062,7 @@ complete_cmd_fusion(struct megasas_instance *instance, u32 MSIxIndex)
 		    fusion->reply_q_depth)
 			fusion->last_reply_idx[MSIxIndex] = 0;
 
-		desc->Words = ULLONG_MAX;
+		desc->Words = cpu_to_le64(ULLONG_MAX);
 		num_completed++;
 		threshold_reply_count++;
 
@@ -2488,7 +2489,7 @@ void  megasas_reset_reply_desc(struct megasas_instance *instance)
 		fusion->last_reply_idx[i] = 0;
 	reply_desc = fusion->reply_frames_desc;
 	for (i = 0 ; i < fusion->reply_q_depth * count; i++, reply_desc++)
-		reply_desc->Words = ULLONG_MAX;
+		reply_desc->Words = cpu_to_le64(ULLONG_MAX);
 }
 
 /*
-- 
1.7.1

