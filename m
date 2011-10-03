From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 09/13] qla4xxx: Fixed device blocked issue on link up-down.
Date: Mon, 3 Oct 2011 10:29:23 -0700
Message-ID: <1317662967-30110-10-git-send-email-vikas.chaudhary@qlogic.com>
References: <1317662967-30110-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:34618
	"EHLO DB3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757113Ab1JCRlE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2011 13:41:04 -0400
In-Reply-To: <1317662967-30110-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Manish Rangankar <manish.rangankar@qlogic.com>

From: Manish Rangankar <manish.rangankar@qlogic.com>

Devices are getting blocked during continuous link up and down. Solution is,
during relogin unblock the session before sending connection logged in event.

JIRA Key: UPSISCSI-138

Signed-off-by: Manish Rangankar <manish.rangankar@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_init.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index cc10bac..e07d99b 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -900,6 +900,7 @@ int qla4xxx_process_ddb_changed(struct scsi_qla_host *ha, uint32_t fw_ddb_index,
 		switch (state) {
 		case DDB_DS_SESSION_ACTIVE:
 		case DDB_DS_DISCOVERY:
+			iscsi_unblock_session(ddb_entry->sess);
 			iscsi_conn_login_event(ddb_entry->conn,
 					       ISCSI_CONN_STATE_LOGGED_IN);
 			qla4xxx_update_session_conn_param(ha, ddb_entry);
-- 
1.7.6


