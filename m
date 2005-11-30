From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 9/8] iscsi: check header digests for mgmt tasks
Date: Wed, 30 Nov 2005 02:27:19 -0600
Message-ID: <1133339239.4106.2.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:19899 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1751131AbVK3I10 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Nov 2005 03:27:26 -0500
Received: from [192.168.0.6] (c-69-180-176-191.hsd1.mn.comcast.net [69.180.176.191])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.1/8.13.1) with ESMTP id jAU8RPbK010063
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 30 Nov 2005 02:27:26 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Forgot to send this patch. Please merge with this patchset. Thanks.

>From Wang Zhenyu:

check header digest for cmd and mgmt tasks

Signed-off-by: Wang Zhenyu <zhenyu.z.wang@intel.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Alex Aizman <itn780@yahoo.com>
Signed-off-by: Dmitry Yusupov <dmitry_yus@yahoo.com>


diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index e6f9542..e3328e7 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -581,6 +581,12 @@ iscsi_hdr_recv(struct iscsi_conn *conn)
 		crypto_digest_digest(conn->rx_tfm, &sg, 1, (u8 *)&cdgst);
 		rdgst = *(uint32_t*)((char*)hdr + sizeof(struct iscsi_hdr) +
 				     conn->in.ahslen);
+		if (cdgst != rdgst) {
+			printk(KERN_ERR "iscsi_tcp: itt %x: hdrdgst error "
+			       "recv 0x%x calc 0x%x\n", conn->in.itt, rdgst,
+			       cdgst);
+			return ISCSI_ERR_HDR_DGST;
+		}
 	}
 
 	/* save opcode for later */
@@ -610,13 +616,6 @@ iscsi_hdr_recv(struct iscsi_conn *conn)
 		  conn->in.ahslen, conn->in.datalen);
 
 	if (conn->in.itt < session->cmds_max) {
-		if (conn->hdrdgst_en && cdgst != rdgst) {
-			printk(KERN_ERR "iscsi_tcp: itt %x: hdrdgst error "
-			       "recv 0x%x calc 0x%x\n", conn->in.itt, rdgst,
-			       cdgst);
-			return ISCSI_ERR_HDR_DGST;
-		}
-
 		ctask = (struct iscsi_cmd_task *)session->cmds[conn->in.itt];
 
 		if (!ctask->sc) {
@@ -1128,8 +1127,7 @@ more:
 		 */
 		rc = iscsi_hdr_recv(conn);
 		if (!rc && conn->in.datalen) {
-			if (conn->datadgst_en &&
-				conn->in.opcode != ISCSI_OP_LOGIN_RSP) {
+			if (conn->datadgst_en) {
 				BUG_ON(!conn->data_rx_tfm);
 				crypto_digest_init(conn->data_rx_tfm);
 			}
@@ -1179,8 +1177,7 @@ more:
 		}
 		conn->in.copy -= conn->in.padding;
 		conn->in.offset += conn->in.padding;
-		if (conn->datadgst_en &&
-			conn->in.opcode != ISCSI_OP_LOGIN_RSP) {
+		if (conn->datadgst_en) {
 			if (conn->in.padding) {
 				debug_tcp("padding -> %d\n", conn->in.padding);
 				memset(pad, 0, conn->in.padding);
@@ -2875,8 +2872,11 @@ iscsi_conn_stop(iscsi_connh_t connh, int
 		 * in hdr_extract() and will be re-negotiated at
 		 * set_param() time.
 		 */
-		if (flag == STOP_CONN_RECOVER)
+		if (flag == STOP_CONN_RECOVER) {
 			conn->hdr_size = sizeof(struct iscsi_hdr);
+			conn->hdrdgst_en = 0;
+			conn->datadgst_en = 0;
+		}
 	}
 	up(&conn->xmitsema);
 }


