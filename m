From: Vaughan Cao <vaughan.cao@oracle.com>
Subject: [PATCH] iscsi: quiesce connection error event during logout
Date: Thu, 21 Nov 2013 17:19:07 +0800
Message-ID: <1385025547-1693-1-git-send-email-vaughan.cao@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, vaughan.cao@oracle.com
List-Id: linux-scsi@vger.kernel.org

'connectionX:X: detected conn error(1020)' message appear during normal
logout phase because of connection close on target peer.
Quiesce it to avoid confusion.

Signed-off-by: Vaughan Cao <vaughan.cao@oracle.com>
---
 drivers/scsi/libiscsi.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index e399561..0e127d1 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1356,6 +1356,12 @@ void iscsi_conn_failure(struct iscsi_conn *conn, enum iscsi_err err)
 		spin_unlock_bh(&session->lock);
 		return;
 	}
+	/* Target closed the connection in response to logout */
+	if (session->state == ISCSI_STATE_LOGGING_OUT &&
+		err == ISCSI_ERR_TCP_CONN_CLOSE) {
+		spin_unlock_bh(&session->lock);
+		return;
+	}
 
 	if (conn->stop_stage == 0)
 		session->state = ISCSI_STATE_FAILED;
-- 
1.8.3.1
