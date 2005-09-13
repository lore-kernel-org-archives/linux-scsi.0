From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 4/9] iscsi: update some iscsi proto defs
Date: Mon, 12 Sep 2005 21:01:38 -0500
Message-ID: <1126576898.29245.24.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:18873 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932397AbVIMCB7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Sep 2005 22:01:59 -0400
Received: from max (c-24-118-218-223.hsd1.mn.comcast.net [24.118.218.223])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.1/8.13.1) with ESMTP id j8D21v3W010024
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 12 Sep 2005 21:01:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

from michaelc@cs.wisc.edu

Cleanup some iscsi_proto defs, add some missing values, and
fix some defs.

Signed-off-by: Alex Aizman <itn780@yahoo.com>
Signed-off-by: Dmitry Yusupov <dmitry_yus@yahoo.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -751,7 +751,7 @@ iscsi_hdr_recv(struct iscsi_conn *conn)
 						(void*)&mtask, sizeof(void*));
 				conn->tmabort_state =
 					((struct iscsi_tm_rsp *)hdr)->
-					response == SCSI_TCP_TM_RESP_COMPLETE ?
+					response == ISCSI_TMF_RSP_COMPLETE ?
 						TMABORT_SUCCESS:TMABORT_FAILED;
 				/* unblock eh_abort() */
 				wake_up(&conn->ehwait);
diff --git a/include/scsi/iscsi_proto.h b/include/scsi/iscsi_proto.h
--- a/include/scsi/iscsi_proto.h
+++ b/include/scsi/iscsi_proto.h
@@ -56,7 +56,8 @@ struct iscsi_hdr {
 	__be32		ttt;		/* Target Task Tag */
 	__be32		statsn;
 	__be32		exp_statsn;
-	uint8_t		other[16];
+	__be32		max_statsn;
+	uint8_t		other[12];
 };
 
 /************************* RFC 3720 Begin *****************************/
@@ -78,6 +79,11 @@ struct iscsi_hdr {
 #define ISCSI_OP_LOGOUT			0x06
 #define ISCSI_OP_SNACK			0x10
 
+#define ISCSI_OP_VENDOR1_CMD		0x1c
+#define ISCSI_OP_VENDOR2_CMD		0x1d
+#define ISCSI_OP_VENDOR3_CMD		0x1e
+#define ISCSI_OP_VENDOR4_CMD		0x1f
+
 /* Target Opcode values */
 #define ISCSI_OP_NOOP_IN		0x20
 #define ISCSI_OP_SCSI_CMD_RSP		0x21
@@ -90,12 +96,20 @@ struct iscsi_hdr {
 #define ISCSI_OP_ASYNC_EVENT		0x32
 #define ISCSI_OP_REJECT			0x3f
 
+struct iscsi_ahs_hdr {
+	__be16 ahslength;
+	uint8_t ahstype;
+	uint8_t ahspec[5];
+};
+
+#define ISCSI_AHSTYPE_CDB		1
+#define ISCSI_AHSTYPE_RLENGTH		2
+
 /* iSCSI PDU Header */
 struct iscsi_cmd {
 	uint8_t opcode;
 	uint8_t flags;
-	uint8_t rsvd2;
-	uint8_t cmdrn;
+	__be16 rsvd2;
 	uint8_t hlength;
 	uint8_t dlength[3];
 	uint8_t lun[8];
@@ -120,6 +134,13 @@ struct iscsi_cmd {
 #define ISCSI_ATTR_HEAD_OF_QUEUE	3
 #define ISCSI_ATTR_ACA			4
 
+struct iscsi_rlength_ahdr {
+	__be16 ahslength;
+	uint8_t ahstype;
+	uint8_t reserved;
+	__be32 read_length;
+};
+
 /* SCSI Response Header */
 struct iscsi_cmd_rsp {
 	uint8_t opcode;
@@ -227,7 +248,7 @@ struct iscsi_tm {
 	uint8_t rsvd2[8];
 };
 
-#define ISCSI_FLAG_TASK_MGMT_FUNCTION_MASK	0x7F
+#define ISCSI_FLAG_TM_FUNC_MASK			0x7F
 
 /* Function values */
 #define ISCSI_TM_FUNC_ABORT_TASK		1
@@ -257,14 +278,14 @@ struct iscsi_tm_rsp {
 };
 
 /* Response values */
-#define SCSI_TCP_TM_RESP_COMPLETE	0x00
-#define SCSI_TCP_TM_RESP_NO_TASK	0x01
-#define SCSI_TCP_TM_RESP_NO_LUN		0x02
-#define SCSI_TCP_TM_RESP_TASK_ALLEGIANT	0x03
-#define SCSI_TCP_TM_RESP_NO_FAILOVER	0x04
-#define SCSI_TCP_TM_RESP_NOT_SUPPORTED	0x05
-#define SCSI_TCP_TM_RESP_AUTH_FAILED	0x06
-#define SCSI_TCP_TM_RESP_REJECTED	0xff
+#define ISCSI_TMF_RSP_COMPLETE		0x00
+#define ISCSI_TMF_RSP_NO_TASK		0x01
+#define ISCSI_TMF_RSP_NO_LUN		0x02
+#define ISCSI_TMF_RSP_TASK_ALLEGIANT	0x03
+#define ISCSI_TMF_RSP_NO_FAILOVER	0x04
+#define ISCSI_TMF_RSP_NOT_SUPPORTED	0x05
+#define ISCSI_TMF_RSP_AUTH_FAILED	0x06
+#define ISCSI_TMF_RSP_REJECTED		0xff
 
 /* Ready To Transfer Header */
 struct iscsi_r2t_rsp {


