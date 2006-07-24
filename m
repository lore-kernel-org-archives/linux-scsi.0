From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 3/11] iscsi bugfixes: handle data rsp errors
Date: Mon, 24 Jul 2006 15:47:17 -0500
Message-ID: <1153774037.1040.34.camel@madmax>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:15040 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1751443AbWGXUsQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Jul 2006 16:48:16 -0400
Received: from [192.168.0.7] (c-24-118-221-159.hsd1.mn.comcast.net [24.118.221.159])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.6/8.13.6) with ESMTP id k6OKlt5h012536
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2006 15:48:15 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

if iscsi_data_rsp fails we must bail out. Since the pdu values like
data length are invalid we cannot continue to process the data since
it could over run buffers.

This fixes a bug with cisco 5428s where that target is sending 
too much data.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index ab324d9..7d78459 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -486,6 +486,8 @@ iscsi_tcp_hdr_recv(struct iscsi_conn *co
 	case ISCSI_OP_SCSI_DATA_IN:
 		tcp_conn->in.ctask = session->cmds[itt];
 		rc = iscsi_data_rsp(conn, tcp_conn->in.ctask);
+		if (rc)
+			return rc;
 		/* fall through */
 	case ISCSI_OP_SCSI_CMD_RSP:
 		tcp_conn->in.ctask = session->cmds[itt];
@@ -532,7 +534,7 @@ copy_hdr:
 	 * skbs to complete the command then we have to copy the header
 	 * for later use
 	 */
-	if (tcp_conn->in.zero_copy_hdr && tcp_conn->in.copy <
+	if (tcp_conn->in.zero_copy_hdr && tcp_conn->in.copy <=
 	   (tcp_conn->in.datalen + tcp_conn->in.padding +
 	    (conn->datadgst_en ? 4 : 0))) {
 		debug_tcp("Copying header for later use. in.copy %d in.datalen"


