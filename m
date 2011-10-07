From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH v2 11/14] qla4xxx: Fixed active session re-open issue.
Date: Fri, 7 Oct 2011 16:55:49 -0700
Message-ID: <1318031752-3836-12-git-send-email-vikas.chaudhary@qlogic.com>
References: <1318031752-3836-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:32550
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754828Ab1JHAHa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Oct 2011 20:07:30 -0400
In-Reply-To: <1318031752-3836-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Manish Rangankar <manish.rangankar@qlogic.com>

From: Manish Rangankar <manish.rangankar@qlogic.com>

When iscsid restarted for an existing active session, set DDB will
fail with status already logged in. In this case, we have to send
logged in event to iscsid.

JIRA Key: OPENISCSI-21

Signed-off-by: Manish Rangankar <manish.rangankar@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 205ecaf..8ed3e2f 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -1142,8 +1142,12 @@ static int qla4xxx_conn_start(struct iscsi_cls_conn *cls_conn)
 		*/
 		if (mbx_sts)
 			if (ddb_entry->fw_ddb_device_state ==
-							DDB_DS_SESSION_ACTIVE)
+						DDB_DS_SESSION_ACTIVE) {
+				iscsi_conn_start(ddb_entry->conn);
+				iscsi_conn_login_event(ddb_entry->conn,
+						ISCSI_CONN_STATE_LOGGED_IN);
 				goto exit_set_param;
+			}
 
 		ql4_printk(KERN_ERR, ha, "%s: Failed set param for index[%d]\n",
 			   __func__, ddb_entry->fw_ddb_index);
-- 
1.7.6


