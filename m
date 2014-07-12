From: michaelc@cs.wisc.edu
Subject: [PATCH 4/4] libiscsi: return new error code when nop times out
Date: Sat, 12 Jul 2014 15:51:51 -0500
Message-ID: <1405198311-64449-5-git-send-email-michaelc@cs.wisc.edu>
References: <1405198311-64449-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:40871 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752786AbaGLUwF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 Jul 2014 16:52:05 -0400
Received: from localhost.localdomain (c-24-245-27-162.hsd1.mn.comcast.net [24.245.27.162])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.14.1/8.14.1) with ESMTP id s6CKpvxL007638
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sat, 12 Jul 2014 15:52:04 -0500
In-Reply-To: <1405198311-64449-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Mike Christie <michaelc@cs.wisc.edu>

When a iscsi nop as ping timedout we were failing with the
common connection error code, ISCSI_ERR_CONN_FAILED. This
patch adds a new error code for this problem so can properly
track/distinguish in userspace.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |    2 +-
 include/scsi/iscsi_if.h |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index f2db82b..b0813fd 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2097,7 +2097,7 @@ static void iscsi_check_transport_timeouts(unsigned long data)
 				  conn->ping_timeout, conn->recv_timeout,
 				  last_recv, conn->last_ping, jiffies);
 		spin_unlock(&session->frwd_lock);
-		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
+		iscsi_conn_failure(conn, ISCSI_ERR_NOP_TIMEDOUT);
 		return;
 	}
 
diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index fd0421c..95ed942 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -527,6 +527,7 @@ enum iscsi_err {
 	ISCSI_ERR_XMIT_FAILED		= ISCSI_ERR_BASE + 19,
 	ISCSI_ERR_TCP_CONN_CLOSE	= ISCSI_ERR_BASE + 20,
 	ISCSI_ERR_SCSI_EH_SESSION_RST	= ISCSI_ERR_BASE + 21,
+	ISCSI_ERR_NOP_TIMEDOUT		= ISCSI_ERR_BASE + 22,
 };
 
 /*
-- 
1.7.1

