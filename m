From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 2/6] qla4xxx: Fix kernel panic during discovery logout.
Date: Mon, 23 Apr 2012 22:32:33 -0700
Message-ID: <1335245557-17169-3-git-send-email-vikas.chaudhary@qlogic.com>
References: <1335245557-17169-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:28251
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751829Ab2DXFsJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Apr 2012 01:48:09 -0400
In-Reply-To: <1335245557-17169-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Manish Rangankar <manish.rangankar@qlogic.com>

From: Manish Rangankar <manish.rangankar@qlogic.com>

Update the session and connection parameter before sending
connection logged in event to iscsiadm because in some
scenario logout may come in just after we send the logged
in event to user, which free up session, connection and ddb,
but DPC is still updating session and connect parameter
which can lead to panic.

Signed-off-by: Manish Rangankar <manish.rangankar@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_init.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index 90ee5d8..0548436 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -884,8 +884,8 @@ int qla4xxx_ddb_change(struct scsi_qla_host *ha, uint32_t fw_ddb_index,
 		switch (state) {
 		case DDB_DS_SESSION_ACTIVE:
 		case DDB_DS_DISCOVERY:
-			ddb_entry->unblock_sess(ddb_entry->sess);
 			qla4xxx_update_session_conn_param(ha, ddb_entry);
+			ddb_entry->unblock_sess(ddb_entry->sess);
 			status = QLA_SUCCESS;
 			break;
 		case DDB_DS_SESSION_FAILED:
@@ -897,6 +897,7 @@ int qla4xxx_ddb_change(struct scsi_qla_host *ha, uint32_t fw_ddb_index,
 		}
 		break;
 	case DDB_DS_SESSION_ACTIVE:
+	case DDB_DS_DISCOVERY:
 		switch (state) {
 		case DDB_DS_SESSION_FAILED:
 			/*
-- 
1.7.9.1.265.gb3a76


