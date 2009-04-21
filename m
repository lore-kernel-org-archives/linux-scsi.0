From: michaelc@cs.wisc.edu
Subject: [PATCH 1/5] iscsi_tcp: don't fire conn error if pdu init fails
Date: Tue, 21 Apr 2009 15:32:31 -0500
Message-ID: <1240345956886-git-send-email-michaelc@cs.wisc.edu>
References: <1240345955183-git-send-email-michaelc@cs.wisc.edu>
 <1240345956764-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:35808 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756818AbZDUUcj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Apr 2009 16:32:39 -0400
In-Reply-To: <1240345956764-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

If a command's scsi cmd pdu setup fails then we can just fail
the IO to the scsi layer. If a DATA_OUT for a R2T fails then
we will want to drop the session, because it means we got a
bad request from the target (iscsi protocol error).

This patch has us propogate the error upwards so libiscsi_tcp
or libiscsi can decide what the best action is to take. It
also fixes a bug where we could try to grab the session lock
while holding it, because if iscsi_tcp drops the session in the
pdu setup callout the session lock is held when setting up the
scsi cmd pdu.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/iscsi_tcp.c    |    2 +-
 drivers/scsi/libiscsi_tcp.c |    5 ++++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index b3e5e08..f97fc7e 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -463,7 +463,7 @@ static int iscsi_sw_tcp_pdu_init(struct iscsi_task *task,
 	}
 
 	if (err) {
-		iscsi_conn_failure(conn, err);
+		/* got invalid offset/len */
 		return -EIO;
 	}
 	return 0;
diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index 91f8ce4..b579ca9 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -1036,8 +1036,11 @@ flush:
 
 	rc = conn->session->tt->init_pdu(task, r2t->data_offset + r2t->sent,
 					 r2t->data_count);
-	if (rc)
+	if (rc) {
+		iscsi_conn_failure(conn, ISCSI_ERR_XMIT_FAILED);
 		return rc;
+	}
+
 	r2t->sent += r2t->data_count;
 	goto flush;
 }
-- 
1.6.0.6

