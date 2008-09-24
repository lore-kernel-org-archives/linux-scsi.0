From: michaelc@cs.wisc.edu
Subject: [PATCH 5/7] iscsi_tcp: return a descriptive error value during connection errors
Date: Wed, 24 Sep 2008 11:46:13 -0500
Message-ID: <1222274775-8834-6-git-send-email-michaelc@cs.wisc.edu>
References: <1222274775-8834-1-git-send-email-michaelc@cs.wisc.edu>
 <1222274775-8834-2-git-send-email-michaelc@cs.wisc.edu>
 <1222274775-8834-3-git-send-email-michaelc@cs.wisc.edu>
 <1222274775-8834-4-git-send-email-michaelc@cs.wisc.edu>
 <1222274775-8834-5-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:53702 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694AbYIXQq3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Sep 2008 12:46:29 -0400
In-Reply-To: <1222274775-8834-5-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

The segment->done functions return a iscsi error value which gives
a lot more info than conn failed, so this patch has us return
that value. I also add a new one for xmit failures.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/iscsi_tcp.c |   12 +++++++-----
 include/scsi/iscsi_if.h  |    1 +
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 4f096de..ed6c54c 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -979,7 +979,7 @@ iscsi_tcp_recv(read_descriptor_t *rd_desc, struct sk_buff *skb,
 
 error:
 	debug_tcp("Error receiving PDU, errno=%d\n", rc);
-	iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
+	iscsi_conn_failure(conn, rc);
 	return 0;
 }
 
@@ -1098,8 +1098,10 @@ iscsi_xmit(struct iscsi_conn *conn)
 
 	while (1) {
 		rc = iscsi_tcp_xmit_segment(tcp_conn, segment);
-		if (rc < 0)
+		if (rc < 0) {
+			rc = ISCSI_ERR_XMIT_FAILED;
 			goto error;
+		}
 		if (rc == 0)
 			break;
 
@@ -1108,7 +1110,7 @@ iscsi_xmit(struct iscsi_conn *conn)
 		if (segment->total_copied >= segment->total_size) {
 			if (segment->done != NULL) {
 				rc = segment->done(tcp_conn, segment);
-				if (rc < 0)
+				if (rc != 0)
 					goto error;
 			}
 		}
@@ -1123,8 +1125,8 @@ error:
 	/* Transmit error. We could initiate error recovery
 	 * here. */
 	debug_tcp("Error sending PDU, errno=%d\n", rc);
-	iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
-	return rc;
+	iscsi_conn_failure(conn, rc);
+	return -EIO;
 }
 
 /**
diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index f274d24..0c9514d 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -214,6 +214,7 @@ enum iscsi_err {
 	ISCSI_ERR_PARAM_NOT_FOUND	= ISCSI_ERR_BASE + 16,
 	ISCSI_ERR_NO_SCSI_CMD		= ISCSI_ERR_BASE + 17,
 	ISCSI_ERR_INVALID_HOST		= ISCSI_ERR_BASE + 18,
+	ISCSI_ERR_XMIT_FAILED		= ISCSI_ERR_BASE + 19,
 };
 
 /*
-- 
1.5.4.1

