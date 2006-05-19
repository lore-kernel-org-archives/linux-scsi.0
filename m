From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 1/6] iscsi update: dont use sendpage for iscsi headers
Date: Thu, 18 May 2006 20:31:31 -0500
Message-ID: <1148002291.3248.21.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:59524 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932176AbWESBc1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 May 2006 21:32:27 -0400
Received: from [192.168.0.4] (c-69-180-176-191.hsd1.mn.comcast.net [69.180.176.191])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.6/8.13.6) with ESMTP id k4J1W609007193
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 18 May 2006 20:32:26 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

>From Zhen and ported by Mike:

Don't use sendpage for the headers. sendpage for the pdu headers
does not seem to have a performance impact, makes life harder
for mutiple data pdus to be in flight and still trips up some
network cards when it is from slab mem.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index d94038e..7c2ed7b 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -71,14 +71,6 @@ module_param_named(max_lun, iscsi_max_lu
 static kmem_cache_t *taskcache;
 
 static inline void
-iscsi_buf_init_virt(struct iscsi_buf *ibuf, char *vbuf, int size)
-{
-	sg_init_one(&ibuf->sg, (u8 *)vbuf, size);
-	ibuf->sent = 0;
-	ibuf->use_sendmsg = 0;
-}
-
-static inline void
 iscsi_buf_init_iov(struct iscsi_buf *ibuf, char *vbuf, int size)
 {
 	ibuf->sg.page = virt_to_page(vbuf);
@@ -324,7 +316,7 @@ iscsi_solicit_data_init(struct iscsi_con
 
 	r2t->sent = 0;
 
-	iscsi_buf_init_virt(&r2t->headbuf, (char*)hdr,
+	iscsi_buf_init_iov(&r2t->headbuf, (char*)hdr,
 			   sizeof(struct iscsi_hdr));
 
 	r2t->dtask = dtask;
@@ -1208,7 +1200,7 @@ iscsi_digest_final_send(struct iscsi_con
 	if (final)
 		crypto_digest_final(tcp_conn->data_tx_tfm, (u8*)digest);
 
-	iscsi_buf_init_virt(buf, (char*)digest, 4);
+	iscsi_buf_init_iov(buf, (char*)digest, 4);
 	rc = iscsi_sendpage(conn, buf, &tcp_ctask->digest_count, &sent);
 	if (rc) {
 		tcp_ctask->datadigest = *digest;
@@ -1265,7 +1257,7 @@ iscsi_solicit_data_cont(struct iscsi_con
 	}
 	conn->dataout_pdus_cnt++;
 
-	iscsi_buf_init_virt(&r2t->headbuf, (char*)hdr,
+	iscsi_buf_init_iov(&r2t->headbuf, (char*)hdr,
 			   sizeof(struct iscsi_hdr));
 
 	r2t->dtask = dtask;
@@ -1294,7 +1286,7 @@ iscsi_unsolicit_data_init(struct iscsi_c
 
 	iscsi_prep_unsolicit_data_pdu(ctask, &dtask->hdr,
 				      tcp_ctask->r2t_data_count);
-	iscsi_buf_init_virt(&tcp_ctask->headbuf, (char*)&dtask->hdr,
+	iscsi_buf_init_iov(&tcp_ctask->headbuf, (char*)&dtask->hdr,
 			   sizeof(struct iscsi_hdr));
 
 	list_add(&dtask->item, &tcp_ctask->dataqueue);
@@ -1361,7 +1353,7 @@ iscsi_tcp_cmd_init(struct iscsi_cmd_task
 	} else
 		tcp_ctask->xmstate = XMSTATE_R_HDR;
 
-	iscsi_buf_init_virt(&tcp_ctask->headbuf, (char*)ctask->hdr,
+	iscsi_buf_init_iov(&tcp_ctask->headbuf, (char*)ctask->hdr,
 			    sizeof(struct iscsi_hdr));
 }
 
@@ -1758,7 +1750,7 @@ handle_xmstate_w_pad(struct iscsi_conn *
 	int sent;
 
 	tcp_ctask->xmstate &= ~XMSTATE_W_PAD;
-	iscsi_buf_init_virt(&tcp_ctask->sendbuf, (char*)&tcp_ctask->pad,
+	iscsi_buf_init_iov(&tcp_ctask->sendbuf, (char*)&tcp_ctask->pad,
 			    tcp_ctask->pad_count);
 	if (iscsi_sendpage(conn, &tcp_ctask->sendbuf, &tcp_ctask->pad_count,
 			   &sent)) {
@@ -2078,8 +2070,8 @@ iscsi_tcp_mgmt_init(struct iscsi_conn *c
 {
 	struct iscsi_tcp_mgmt_task *tcp_mtask = mtask->dd_data;
 
-	iscsi_buf_init_virt(&tcp_mtask->headbuf, (char*)mtask->hdr,
-				    sizeof(struct iscsi_hdr));
+	iscsi_buf_init_iov(&tcp_mtask->headbuf, (char*)mtask->hdr,
+			   sizeof(struct iscsi_hdr));
 	tcp_mtask->xmstate = XMSTATE_IMM_HDR;
 
 	if (mtask->data_count)


