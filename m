From: michaelc@cs.wisc.edu
Subject: [PATCH 2/7] clear mtask
Date: Wed, 28 Feb 2007 17:32:16 -0600
Message-ID: <11727055433394-git-send-email-michaelc@cs.wisc.edu>
References: <1172705541949-git-send-email-michaelc@cs.wisc.edu> <11727055423762-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:56869 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254AbXB1Xck (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Feb 2007 18:32:40 -0500
In-Reply-To: <11727055423762-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

Consolidate the mtask clearing code.
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |   19 ++++++++-----------
 1 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 6346a91..5c176ab 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -577,7 +577,7 @@ void iscsi_conn_failure(struct iscsi_con
 }
 EXPORT_SYMBOL_GPL(iscsi_conn_failure);
 
-static int iscsi_xmit_imm_task(struct iscsi_conn *conn)
+static int iscsi_xmit_mtask(struct iscsi_conn *conn)
 {
 	struct iscsi_hdr *hdr = conn->mtask->hdr;
 	int rc, was_logout = 0;
@@ -591,6 +591,9 @@ static int iscsi_xmit_imm_task(struct is
 	if (rc)
 		return rc;
 
+	/* done with this in-progress mtask */
+	conn->mtask = NULL;
+
 	if (was_logout) {
 		set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
 		return -ENODATA;
@@ -643,11 +646,9 @@ static int iscsi_data_xmit(struct iscsi_
 		conn->ctask = NULL;
 	}
 	if (conn->mtask) {
-		rc = iscsi_xmit_imm_task(conn);
+		rc = iscsi_xmit_mtask(conn);
 	        if (rc)
 		        goto again;
-		/* done with this in-progress mtask */
-		conn->mtask = NULL;
 	}
 
 	/* process immediate first */
@@ -658,12 +659,10 @@ static int iscsi_data_xmit(struct iscsi_
 			list_add_tail(&conn->mtask->running,
 				      &conn->mgmt_run_list);
 			spin_unlock_bh(&conn->session->lock);
-			rc = iscsi_xmit_imm_task(conn);
+			rc = iscsi_xmit_mtask(conn);
 		        if (rc)
 			        goto again;
 	        }
-		/* done with this mtask */
-		conn->mtask = NULL;
 	}
 
 	/* process command queue */
@@ -701,12 +700,10 @@ static int iscsi_data_xmit(struct iscsi_
 			list_add_tail(&conn->mtask->running,
 				      &conn->mgmt_run_list);
 			spin_unlock_bh(&conn->session->lock);
-		        rc = tt->xmit_mgmt_task(conn, conn->mtask);
-			if (rc)
+		       	rc = iscsi_xmit_mtask(conn);
+		        if (rc)
 			        goto again;
 	        }
-		/* done with this mtask */
-		conn->mtask = NULL;
 	}
 
 	return -ENODATA;
-- 
1.4.1.1

