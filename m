From: vikas.chaudhary@qlogic.com
Subject: [PATCH 05/13] qla4xxx: remove unused ddb flag DF_NO_RELOGIN
Date: Mon, 21 Mar 2011 03:34:28 -0700
Message-ID: <1300703676-27398-5-git-send-email-vikas.chaudhary@qlogic.com>
References: <1300703676-27398-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:46168 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1753115Ab1CUKtP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Mar 2011 06:49:15 -0400
In-Reply-To: <1300703676-27398-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, ravi.anand@qlogic.com, lalit.chandivade@qlogic.com, vikas.chaudhary@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_def.h  |    2 --
 drivers/scsi/qla4xxx/ql4_init.c |    2 --
 2 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index b46d0dc..7aa60ee 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -286,8 +286,6 @@ struct ddb_entry {
  * DDB flags.
  */
 #define DF_RELOGIN		0	/* Relogin to device */
-#define DF_NO_RELOGIN		1	/* Do not relogin if IOCTL
-					 * logged it out */
 #define DF_ISNS_DISCOVERED	2	/* Device was discovered via iSNS */
 #define DF_FO_MASKED		3
 
diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index bf1c30b..8b5453a 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -1445,7 +1445,6 @@ int qla4xxx_process_ddb_changed(struct scsi_qla_host *ha, uint32_t fw_ddb_index,
 		atomic_set(&ddb_entry->relogin_retry_count, 0);
 		atomic_set(&ddb_entry->relogin_timer, 0);
 		clear_bit(DF_RELOGIN, &ddb_entry->flags);
-		clear_bit(DF_NO_RELOGIN, &ddb_entry->flags);
 		iscsi_unblock_session(ddb_entry->sess);
 		iscsi_session_event(ddb_entry->sess,
 				    ISCSI_KEVENT_CREATE_SESSION);
@@ -1470,7 +1469,6 @@ int qla4xxx_process_ddb_changed(struct scsi_qla_host *ha, uint32_t fw_ddb_index,
 		 */
 		if (ddb_entry->fw_ddb_device_state == DDB_DS_SESSION_FAILED &&
 		    !test_bit(DF_RELOGIN, &ddb_entry->flags) &&
-		    !test_bit(DF_NO_RELOGIN, &ddb_entry->flags) &&
 		    qla4_is_relogin_allowed(ha, conn_err)) {
 			/*
 			 * This triggers a relogin.  After the relogin_timer
-- 
1.7.3.2

