From: michaelc@cs.wisc.edu
Subject: [PATCH 2/3] iscsi_tcp: propogate EAGAIN from sendpage to libiscsi
Date: Mon, 15 Jun 2009 22:11:09 -0500
Message-ID: <1245121870-2515-2-git-send-email-michaelc@cs.wisc.edu>
References: <1245121870-2515-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:37383 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751123AbZFPDLS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Jun 2009 23:11:18 -0400
In-Reply-To: <1245121870-2515-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

The net layer might return -EAGAIN because it could not
get space/mem within the sock sndtimeo or becuase the tcp/ip
connection was down. For the latter we do not want to retry
because the conn/session should just be shutdown and restarted.
libiscsi knows the state of the session recovery so propogate
this error to that layer. It will either do iscsi recovery
or have us retry the operation. Right now if we have partially
sent a pdu we would always retry the IO xmit slowing down
recovery.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/iscsi_tcp.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index b7c092d..518dbd9 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -253,8 +253,6 @@ static int iscsi_sw_tcp_xmit_segment(struct iscsi_tcp_conn *tcp_conn,
 
 		if (r < 0) {
 			iscsi_tcp_segment_unmap(segment);
-			if (copied || r == -EAGAIN)
-				break;
 			return r;
 		}
 		copied += r;
@@ -275,11 +273,17 @@ static int iscsi_sw_tcp_xmit(struct iscsi_conn *conn)
 
 	while (1) {
 		rc = iscsi_sw_tcp_xmit_segment(tcp_conn, segment);
-		if (rc < 0) {
+		/*
+		 * We may not have been able to send data because the conn
+		 * is getting stopped. libiscsi will know so propogate err
+		 * for it to do the right thing.
+		 */
+		if (rc == -EAGAIN)
+			return rc;
+		else if (rc < 0) {
 			rc = ISCSI_ERR_XMIT_FAILED;
 			goto error;
-		}
-		if (rc == 0)
+		} else if (rc == 0)
 			break;
 
 		consumed += rc;
-- 
1.6.2.2

