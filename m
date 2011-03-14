From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 05/13] qla4xxx: remove unused ddb flag DF_NO_RELOGIN
Date: Sun, 13 Mar 2011 22:24:19 -0700
Message-ID: <5E4F49720D0BAD499EE1F01232234BA872263B150B@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:26848
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752944Ab1CNFZh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Mar 2011 01:25:37 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Lalit Chandivade <lalit.chandivade@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Mike Christie <michaelc@cs.wisc.edu>

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
 #define DF_RELOGIN             0       /* Relogin to device */
-#define DF_NO_RELOGIN          1       /* Do not relogin if IOCTL
-                                        * logged it out */
 #define DF_ISNS_DISCOVERED     2       /* Device was discovered via iSNS */
 #define DF_FO_MASKED           3

diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index bf1c30b..8b5453a 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -1445,7 +1445,6 @@ int qla4xxx_process_ddb_changed(struct scsi_qla_host *ha, uint32_t fw_ddb_index,
                atomic_set(&ddb_entry->relogin_retry_count, 0);
                atomic_set(&ddb_entry->relogin_timer, 0);
                clear_bit(DF_RELOGIN, &ddb_entry->flags);
-               clear_bit(DF_NO_RELOGIN, &ddb_entry->flags);
                iscsi_unblock_session(ddb_entry->sess);
                iscsi_session_event(ddb_entry->sess,
                                    ISCSI_KEVENT_CREATE_SESSION);
@@ -1470,7 +1469,6 @@ int qla4xxx_process_ddb_changed(struct scsi_qla_host *ha, uint32_t fw_ddb_index,
                 */
                if (ddb_entry->fw_ddb_device_state == DDB_DS_SESSION_FAILED &&
                    !test_bit(DF_RELOGIN, &ddb_entry->flags) &&
-                   !test_bit(DF_NO_RELOGIN, &ddb_entry->flags) &&
                    qla4_is_relogin_allowed(ha, conn_err)) {
                        /*
                         * This triggers a relogin.  After the relogin_timer
--
1.7.3.2


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

