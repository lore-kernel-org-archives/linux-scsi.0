From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 04/13] target/iscsi: Remove unneeded wrapper functions
Date: Thu, 19 Jan 2012 13:39:14 -0800
Message-ID: <1327009163-10177-5-git-send-email-agrover@redhat.com>
References: <1327009163-10177-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3895 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897Ab2ASVjb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Jan 2012 16:39:31 -0500
In-Reply-To: <1327009163-10177-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, kiran.patil@intel.com

iscsit_get_lun_for_{cmd,tmr} are unnecessary.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/iscsi/iscsi_target.c        |    8 ++++----
 drivers/target/iscsi/iscsi_target_device.c |   19 -------------------
 drivers/target/iscsi/iscsi_target_device.h |    2 --
 3 files changed, 4 insertions(+), 25 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 357a6f2..c1a5e09 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1006,8 +1006,8 @@ done:
 	/*
 	 * The CDB is going to an se_device_t.
 	 */
-	ret = iscsit_get_lun_for_cmd(cmd, hdr->cdb,
-				get_unaligned_le64(&hdr->lun));
+	ret = transport_lookup_cmd_lun(&cmd->se_cmd,
+				       scsilun_to_int(&hdr->lun));
 	if (ret < 0) {
 		if (cmd->se_cmd.scsi_sense_reason == TCM_NON_EXISTENT_LUN) {
 			pr_debug("Responding to non-acl'ed,"
@@ -1746,8 +1746,8 @@ static int iscsit_handle_task_mgt_cmd(
 	 * Locate the struct se_lun for all TMRs not related to ERL=2 TASK_REASSIGN
 	 */
 	if (function != ISCSI_TM_FUNC_TASK_REASSIGN) {
-		ret = iscsit_get_lun_for_tmr(cmd,
-				get_unaligned_le64(&hdr->lun));
+		ret = transport_lookup_tmr_lun(&cmd->se_cmd,
+					       scsilun_to_int(&hdr->lun));
 		if (ret < 0) {
 			cmd->se_cmd.se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
 			se_tmr->response = ISCSI_TMF_RSP_NO_LUN;
diff --git a/drivers/target/iscsi/iscsi_target_device.c b/drivers/target/iscsi/iscsi_target_device.c
index f63ea35..bcc4098 100644
--- a/drivers/target/iscsi/iscsi_target_device.c
+++ b/drivers/target/iscsi/iscsi_target_device.c
@@ -28,25 +28,6 @@
 #include "iscsi_target_tpg.h"
 #include "iscsi_target_util.h"
 
-int iscsit_get_lun_for_tmr(
-	struct iscsi_cmd *cmd,
-	u64 lun)
-{
-	u32 unpacked_lun = scsilun_to_int((struct scsi_lun *)&lun);
-
-	return transport_lookup_tmr_lun(&cmd->se_cmd, unpacked_lun);
-}
-
-int iscsit_get_lun_for_cmd(
-	struct iscsi_cmd *cmd,
-	unsigned char *cdb,
-	u64 lun)
-{
-	u32 unpacked_lun = scsilun_to_int((struct scsi_lun *)&lun);
-
-	return transport_lookup_cmd_lun(&cmd->se_cmd, unpacked_lun);
-}
-
 void iscsit_determine_maxcmdsn(struct iscsi_session *sess)
 {
 	struct se_node_acl *se_nacl;
diff --git a/drivers/target/iscsi/iscsi_target_device.h b/drivers/target/iscsi/iscsi_target_device.h
index bef1cad..a0e2df9 100644
--- a/drivers/target/iscsi/iscsi_target_device.h
+++ b/drivers/target/iscsi/iscsi_target_device.h
@@ -1,8 +1,6 @@
 #ifndef ISCSI_TARGET_DEVICE_H
 #define ISCSI_TARGET_DEVICE_H
 
-extern int iscsit_get_lun_for_tmr(struct iscsi_cmd *, u64);
-extern int iscsit_get_lun_for_cmd(struct iscsi_cmd *, unsigned char *, u64);
 extern void iscsit_determine_maxcmdsn(struct iscsi_session *);
 extern void iscsit_increment_maxcmdsn(struct iscsi_cmd *, struct iscsi_session *);
 
-- 
1.7.1

