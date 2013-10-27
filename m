From: Or Gerlitz <ogerlitz@mellanox.com>
Subject: [PATCH 3/3] SCSI/libiscsi: Remove unneeded code
Date: Sun, 27 Oct 2013 15:23:26 +0200
Message-ID: <1382880206-2789-4-git-send-email-ogerlitz@mellanox.com>
References: <1382880206-2789-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailp.voltaire.com ([193.47.165.129]:44010 "EHLO mellanox.co.il"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753501Ab3J0NXe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Oct 2013 09:23:34 -0400
In-Reply-To: <1382880206-2789-1-git-send-email-ogerlitz@mellanox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, MChristie@fusionio.com, shlomop@mellanox.com, Mike Christie <michaelc@cs.wisc.edu>

From: Shlomo Pongratz <shlomop@mellanox.com>

We never will have a closed window and something on one of those lists.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Shlomo Pongratz <shlomop@mellanox.com>
---
 drivers/scsi/libiscsi.c |   12 ------------
 1 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 9c28c46..dd66d8a 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -108,18 +108,6 @@ static void __iscsi_update_cmdsn(struct iscsi_session *session,
 	if (exp_cmdsn != session->exp_cmdsn &&
 	    !iscsi_sna_lt(exp_cmdsn, session->exp_cmdsn))
 		session->exp_cmdsn = exp_cmdsn;
-
-	if (max_cmdsn != session->max_cmdsn &&
-	    !iscsi_sna_lt(max_cmdsn, session->max_cmdsn)) {
-		session->max_cmdsn = max_cmdsn;
-		/*
-		 * if the window closed with IO queued, then kick the
-		 * xmit thread
-		 */
-		if (!list_empty(&session->leadconn->cmdqueue) ||
-		    !list_empty(&session->leadconn->mgmtqueue))
-			iscsi_conn_queue_work(session->leadconn);
-	}
 }
 
 void iscsi_update_cmdsn(struct iscsi_session *session, struct iscsi_nopin *hdr)
-- 
1.7.1

