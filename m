From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 2/9] iscsi: preemt fix and cleanup
Date: Mon, 12 Sep 2005 21:01:32 -0500
Message-ID: <1126576892.29245.22.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:17849 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932306AbVIMCBo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Sep 2005 22:01:44 -0400
Received: from max (c-24-118-218-223.hsd1.mn.comcast.net [24.118.218.223])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.1/8.13.1) with ESMTP id j8D21hsd010018
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 12 Sep 2005 21:01:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

from zhenyu.z.wang@intel.com

Delay the head digest update until xmit time, like data digest update.
[To make things cleaner and avoid prempt bug]

Signed-off-by: Alex Aizman <itn780@yahoo.com>
Signed-off-by: Dmitry Yusupov <dmitry_yus@yahoo.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>


diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -129,14 +129,11 @@ iscsi_buf_left(struct iscsi_buf *ibuf)
 }
 
 static inline void
-iscsi_buf_init_hdr(struct iscsi_conn *conn, struct iscsi_buf *ibuf,
-		   char *vbuf, u8 *crc)
+iscsi_hdr_digest(struct iscsi_conn *conn, struct iscsi_buf *buf,
+		 u8* crc)
 {
-	iscsi_buf_init_virt(ibuf, vbuf, sizeof(struct iscsi_hdr));
-	if (conn->hdrdgst_en) {
-		crypto_digest_digest(conn->tx_tfm, &ibuf->sg, 1, crc);
-		ibuf->sg.length += sizeof(uint32_t);
-	}
+	crypto_digest_digest(conn->tx_tfm, &buf->sg, 1, crc);
+	buf->sg.length += sizeof(uint32_t);
 }
 
 static void
@@ -427,8 +424,8 @@ iscsi_solicit_data_init(struct iscsi_con
 
 	r2t->sent = 0;
 
-	iscsi_buf_init_hdr(conn, &r2t->headbuf, (char*)hdr,
-			   (u8 *)dtask->hdrext);
+	iscsi_buf_init_virt(&r2t->headbuf, (char*)hdr,
+			   sizeof(struct iscsi_hdr));
 
 	r2t->dtask = dtask;
 
@@ -1494,8 +1491,8 @@ iscsi_solicit_data_cont(struct iscsi_con
 	}
 	conn->dataout_pdus_cnt++;
 
-	iscsi_buf_init_hdr(conn, &r2t->headbuf, (char*)hdr,
-			   (u8 *)dtask->hdrext);
+	iscsi_buf_init_virt(&r2t->headbuf, (char*)hdr,
+			   sizeof(struct iscsi_hdr));
 
 	r2t->dtask = dtask;
 
@@ -1541,8 +1538,8 @@ iscsi_unsolicit_data_init(struct iscsi_c
 		hdr->flags = ISCSI_FLAG_CMD_FINAL;
 	}
 
-	iscsi_buf_init_hdr(conn, &ctask->headbuf, (char*)hdr,
-			   (u8 *)dtask->hdrext);
+	iscsi_buf_init_virt(&ctask->headbuf, (char*)hdr,
+			   sizeof(struct iscsi_hdr));
 
 	list_add(&dtask->item, &ctask->dataqueue);
 
@@ -1662,8 +1659,8 @@ iscsi_cmd_init(struct iscsi_conn *conn, 
 		zero_data(ctask->hdr.dlength);
 	}
 
-	iscsi_buf_init_hdr(conn, &ctask->headbuf, (char*)&ctask->hdr,
-			    (u8 *)ctask->hdrext);
+	iscsi_buf_init_virt(&ctask->headbuf, (char*)&ctask->hdr, 
+			    sizeof(struct iscsi_hdr));
 	conn->scsicmd_pdus_cnt++;
 }
 
@@ -1692,6 +1689,11 @@ iscsi_mtask_xmit(struct iscsi_conn *conn
 		mtask->xmstate &= ~XMSTATE_IMM_HDR;
 		if (mtask->data_count)
 			mtask->xmstate |= XMSTATE_IMM_DATA;
+		if (conn->c_stage != ISCSI_CONN_INITIAL_STAGE &&
+	    	    conn->stop_stage != STOP_CONN_RECOVER &&
+		    conn->hdrdgst_en)
+			iscsi_hdr_digest(conn, &mtask->headbuf,
+					(u8*)mtask->hdrext);
 		if (iscsi_sendhdr(conn, &mtask->headbuf, mtask->data_count)) {
 			mtask->xmstate |= XMSTATE_IMM_HDR;
 			if (mtask->data_count)
@@ -1723,6 +1725,8 @@ static inline int
 handle_xmstate_r_hdr(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 {
 	ctask->xmstate &= ~XMSTATE_R_HDR;
+	if (conn->hdrdgst_en) 
+		iscsi_hdr_digest(conn, &ctask->headbuf, (u8*)ctask->hdrext);
 	if (!iscsi_sendhdr(conn, &ctask->headbuf, 0)) {
 		BUG_ON(ctask->xmstate != XMSTATE_IDLE);
 		return 0; /* wait for Data-In */
@@ -1735,6 +1739,8 @@ static inline int
 handle_xmstate_w_hdr(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 {
 	ctask->xmstate &= ~XMSTATE_W_HDR;
+	if (conn->hdrdgst_en) 
+		iscsi_hdr_digest(conn, &ctask->headbuf, (u8*)ctask->hdrext);
 	if (iscsi_sendhdr(conn, &ctask->headbuf, ctask->imm_count)) {
 		ctask->xmstate |= XMSTATE_W_HDR;
 		return -EAGAIN;
@@ -1813,7 +1819,9 @@ handle_xmstate_uns_hdr(struct iscsi_conn
 		iscsi_unsolicit_data_init(conn, ctask);
 		BUG_ON(!ctask->dtask);
 		dtask = ctask->dtask;
-
+		if (conn->hdrdgst_en)
+			iscsi_hdr_digest(conn, &ctask->headbuf,
+					(u8*)dtask->hdrext);
 		ctask->xmstate &= ~XMSTATE_UNS_INIT;
 	}
 	if (iscsi_sendhdr(conn, &ctask->headbuf, ctask->data_count)) {
@@ -2118,7 +2126,9 @@ unsolicit_head_again:
 				    sizeof(void*));
 solicit_head_again:
 		r2t = ctask->r2t;
-
+		if (conn->hdrdgst_en)
+			iscsi_hdr_digest(conn, &r2t->headbuf, 
+					(u8*)r2t->dtask->hdrext);
 		if (iscsi_sendhdr(conn, &r2t->headbuf, r2t->data_count)) {
 			ctask->xmstate &= ~XMSTATE_SOL_DATA;
 			ctask->xmstate |= XMSTATE_SOL_HDR;
@@ -2889,14 +2899,8 @@ iscsi_conn_send_generic(struct iscsi_con
 
 	memcpy(&mtask->hdr, hdr, sizeof(struct iscsi_hdr));
 
-	if (conn->c_stage == ISCSI_CONN_INITIAL_STAGE ||
-	    conn->stop_stage == STOP_CONN_RECOVER)
-		iscsi_buf_init_virt(&mtask->headbuf, (char*)&mtask->hdr,
+	iscsi_buf_init_virt(&mtask->headbuf, (char*)&mtask->hdr,
 				    sizeof(struct iscsi_hdr));
-	else
-		/* this will update header digest */
-		iscsi_buf_init_hdr(conn, &mtask->headbuf, (char*)&mtask->hdr,
-				    (u8 *)mtask->hdrext);
 
 	spin_unlock_bh(&session->lock);
 


