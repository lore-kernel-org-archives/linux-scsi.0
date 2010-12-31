From: michaelc@cs.wisc.edu
Subject: [PATCH 5/5] libiscsi: use bh locking instead of irq with session lock
Date: Fri, 31 Dec 2010 02:22:22 -0600
Message-ID: <1293783742-8238-6-git-send-email-michaelc@cs.wisc.edu>
References: <1293783742-8238-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40317 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440Ab0LaIW2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Dec 2010 03:22:28 -0500
In-Reply-To: <1293783742-8238-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

The session lock is taken in threads, timers, and bottom halves
like softirqs and tasklets. All the code but
iscsi_conn/session_failure take the session lock with the spin_lock_bh
call. This was done because I thought some offload drivers
would be calling these functions from a irq. They never did,
so this patch has iscsi_conn/session_failure use the bh
locking.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index f460637..b0481a8 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1337,17 +1337,16 @@ void iscsi_session_failure(struct iscsi_session *session,
 {
 	struct iscsi_conn *conn;
 	struct device *dev;
-	unsigned long flags;
 
-	spin_lock_irqsave(&session->lock, flags);
+	spin_lock_bh(&session->lock);
 	conn = session->leadconn;
 	if (session->state == ISCSI_STATE_TERMINATE || !conn) {
-		spin_unlock_irqrestore(&session->lock, flags);
+		spin_unlock_bh(&session->lock);
 		return;
 	}
 
 	dev = get_device(&conn->cls_conn->dev);
-	spin_unlock_irqrestore(&session->lock, flags);
+	spin_unlock_bh(&session->lock);
 	if (!dev)
 	        return;
 	/*
@@ -1366,17 +1365,16 @@ EXPORT_SYMBOL_GPL(iscsi_session_failure);
 void iscsi_conn_failure(struct iscsi_conn *conn, enum iscsi_err err)
 {
 	struct iscsi_session *session = conn->session;
-	unsigned long flags;
 
-	spin_lock_irqsave(&session->lock, flags);
+	spin_lock_bh(&session->lock);
 	if (session->state == ISCSI_STATE_FAILED) {
-		spin_unlock_irqrestore(&session->lock, flags);
+		spin_unlock_bh(&session->lock);
 		return;
 	}
 
 	if (conn->stop_stage == 0)
 		session->state = ISCSI_STATE_FAILED;
-	spin_unlock_irqrestore(&session->lock, flags);
+	spin_unlock_bh(&session->lock);
 
 	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
 	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_rx);
-- 
1.7.0.1

