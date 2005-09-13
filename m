From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 7/9] iscsi: rename some proto defs
Date: Mon, 12 Sep 2005 21:01:57 -0500
Message-ID: <1126576918.29245.27.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:20409 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932403AbVIMCCV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Sep 2005 22:02:21 -0400
Received: from max (c-24-118-218-223.hsd1.mn.comcast.net [24.118.218.223])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.1/8.13.1) with ESMTP id j8D22Kff010043
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 12 Sep 2005 21:02:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

from hare@suse.de

for a proper alignment between open-iscsi and iscsitarget the
definitions in include/iscsi_proto.h do not match exactly.

With this patch it's possible to have iscsitarget use
'include/iscsi_proto.h' instead of its own iscsi_hdr.h.

Signed-off-by: Alex Aizman <itn780@yahoo.com>
Signed-off-by: Dmitry Yusupov <dmitry_yus@yahoo.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>


diff --git a/include/scsi/iscsi_proto.h b/include/scsi/iscsi_proto.h
--- a/include/scsi/iscsi_proto.h
+++ b/include/scsi/iscsi_proto.h
@@ -548,9 +548,11 @@ struct iscsi_reject {
 	uint8_t flags;
 	uint8_t reason;
 	uint8_t rsvd2;
-	uint8_t rsvd3;
+	uint8_t hlength;
 	uint8_t dlength[3];
-	uint8_t rsvd4[16];
+	uint8_t rsvd3[8];
+	__be32  ffffffff;
+	uint8_t rsvd4[4];
 	__be32	statsn;
 	__be32	exp_cmdsn;
 	__be32	max_cmdsn;
@@ -560,17 +562,17 @@ struct iscsi_reject {
 };
 
 /* Reason for Reject */
-#define CMD_BEFORE_LOGIN	1
-#define DATA_DIGEST_ERROR	2
-#define DATA_SNACK_REJECT	3
-#define ISCSI_PROTOCOL_ERROR	4
-#define CMD_NOT_SUPPORTED	5
-#define IMM_CMD_REJECT		6
-#define TASK_IN_PROGRESS	7
-#define INVALID_SNACK		8
-#define BOOKMARK_REJECTED	9
-#define BOOKMARK_NO_RESOURCES	10
-#define NEGOTIATION_RESET	11
+#define ISCSI_REASON_CMD_BEFORE_LOGIN	1
+#define ISCSI_REASON_DATA_DIGEST_ERROR	2
+#define ISCSI_REASON_DATA_SNACK_REJECT	3
+#define ISCSI_REASON_PROTOCOL_ERROR	4
+#define ISCSI_REASON_CMD_NOT_SUPPORTED	5
+#define ISCSI_REASON_IMM_CMD_REJECT		6
+#define ISCSI_REASON_TASK_IN_PROGRESS	7
+#define ISCSI_REASON_INVALID_SNACK		8
+#define ISCSI_REASON_BOOKMARK_INVALID	9
+#define ISCSI_REASON_BOOKMARK_NO_RESOURCES	10
+#define ISCSI_REASON_NEGOTIATION_RESET	11
 
 /* Max. number of Key=Value pairs in a text message */
 #define MAX_KEY_VALUE_PAIRS	8192


