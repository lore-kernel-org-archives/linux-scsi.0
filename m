From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 8/11] iscsi bugfixes: reduce memory allocations
Date: Mon, 24 Jul 2006 15:47:39 -0500
Message-ID: <1153774059.1040.40.camel@madmax>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:18624 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1751444AbWGXUu1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Jul 2006 16:50:27 -0400
Received: from [192.168.0.7] (c-24-118-221-159.hsd1.mn.comcast.net [24.118.221.159])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.6/8.13.6) with ESMTP id k6OKo5JS012559
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2006 15:50:26 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

We currently try to allocate a max_recv_data_segment_length
which can be very large (default is 64K), and common uses
are up to 1MB. It is very very difficult to allocte this
much contiguous memory and it turns out we never even use it.
We really only need a couple of pages, so this patch has us
allocates just what we know what we need today.

Later if vendors start adding vendor specific data and
we need to handle large buffers we can do this, but for
the last 4 years we have not seen anyone do this or request
it.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index b6c68be..aa20adc 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -511,13 +511,28 @@ iscsi_tcp_hdr_recv(struct iscsi_conn *co
 		break;
 	case ISCSI_OP_LOGIN_RSP:
 	case ISCSI_OP_TEXT_RSP:
-	case ISCSI_OP_LOGOUT_RSP:
-	case ISCSI_OP_NOOP_IN:
 	case ISCSI_OP_REJECT:
 	case ISCSI_OP_ASYNC_EVENT:
+		/*
+		 * It is possible that we could get a PDU with a buffer larger
+		 * than 8K, but there are no targets that currently do this.
+		 * For now we fail until we find a vendor that needs it
+		 */
+		if (DEFAULT_MAX_RECV_DATA_SEGMENT_LENGTH <
+		    tcp_conn->in.datalen) {
+			printk(KERN_ERR "iscsi_tcp: received buffer of len %u "
+			      "but conn buffer is only %u (opcode %0x)\n",
+			      tcp_conn->in.datalen,
+			      DEFAULT_MAX_RECV_DATA_SEGMENT_LENGTH, opcode);
+			rc = ISCSI_ERR_PROTO;
+			break;
+		}
+
 		if (tcp_conn->in.datalen)
 			goto copy_hdr;
 	/* fall through */
+	case ISCSI_OP_LOGOUT_RSP:
+	case ISCSI_OP_NOOP_IN:
 	case ISCSI_OP_SCSI_TMFUNC_RSP:
 		rc = iscsi_complete_pdu(conn, hdr, NULL, 0);
 		break;
@@ -625,9 +640,9 @@ iscsi_ctask_copy(struct iscsi_tcp_conn *
  *	byte counters.
  **/
 static inline int
-iscsi_tcp_copy(struct iscsi_tcp_conn *tcp_conn)
+iscsi_tcp_copy(struct iscsi_conn *conn)
 {
-	void *buf = tcp_conn->data;
+	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 	int buf_size = tcp_conn->in.datalen;
 	int buf_left = buf_size - tcp_conn->data_copied;
 	int size = min(tcp_conn->in.copy, buf_left);
@@ -638,7 +653,7 @@ iscsi_tcp_copy(struct iscsi_tcp_conn *tc
 	BUG_ON(size <= 0);
 
 	rc = skb_copy_bits(tcp_conn->in.skb, tcp_conn->in.offset,
-			   (char*)buf + tcp_conn->data_copied, size);
+			   (char*)conn->data + tcp_conn->data_copied, size);
 	BUG_ON(rc);
 
 	tcp_conn->in.offset += size;
@@ -785,22 +800,21 @@ iscsi_data_recv(struct iscsi_conn *conn)
 		spin_unlock(&conn->session->lock);
 	case ISCSI_OP_TEXT_RSP:
 	case ISCSI_OP_LOGIN_RSP:
-	case ISCSI_OP_NOOP_IN:
 	case ISCSI_OP_ASYNC_EVENT:
 	case ISCSI_OP_REJECT:
 		/*
 		 * Collect data segment to the connection's data
 		 * placeholder
 		 */
-		if (iscsi_tcp_copy(tcp_conn)) {
+		if (iscsi_tcp_copy(conn)) {
 			rc = -EAGAIN;
 			goto exit;
 		}
 
-		rc = iscsi_complete_pdu(conn, tcp_conn->in.hdr, tcp_conn->data,
+		rc = iscsi_complete_pdu(conn, tcp_conn->in.hdr, conn->data,
 					tcp_conn->in.datalen);
 		if (!rc && conn->datadgst_en && opcode != ISCSI_OP_LOGIN_RSP)
-			iscsi_recv_digest_update(tcp_conn, tcp_conn->data,
+			iscsi_recv_digest_update(tcp_conn, conn->data,
 			  			tcp_conn->in.datalen);
 		break;
 	default:
@@ -1911,21 +1925,9 @@ iscsi_tcp_conn_create(struct iscsi_cls_s
 	tcp_conn->in_progress = IN_PROGRESS_WAIT_HEADER;
 	/* initial operational parameters */
 	tcp_conn->hdr_size = sizeof(struct iscsi_hdr);
-	tcp_conn->data_size = DEFAULT_MAX_RECV_DATA_SEGMENT_LENGTH;
-
-	/* allocate initial PDU receive place holder */
-	if (tcp_conn->data_size <= PAGE_SIZE)
-		tcp_conn->data = kmalloc(tcp_conn->data_size, GFP_KERNEL);
-	else
-		tcp_conn->data = (void*)__get_free_pages(GFP_KERNEL,
-					get_order(tcp_conn->data_size));
-	if (!tcp_conn->data)
-		goto max_recv_dlenght_alloc_fail;
 
 	return cls_conn;
 
-max_recv_dlenght_alloc_fail:
-	kfree(tcp_conn);
 tcp_conn_alloc_fail:
 	iscsi_conn_teardown(cls_conn);
 	return NULL;
@@ -1973,12 +1975,6 @@ iscsi_tcp_conn_destroy(struct iscsi_cls_
 			crypto_free_tfm(tcp_conn->data_rx_tfm);
 	}
 
-	/* free conn->data, size = MaxRecvDataSegmentLength */
-	if (tcp_conn->data_size <= PAGE_SIZE)
-		kfree(tcp_conn->data);
-	else
-		free_pages((unsigned long)tcp_conn->data,
-			   get_order(tcp_conn->data_size));
 	kfree(tcp_conn);
 }
 
@@ -2131,39 +2127,6 @@ iscsi_conn_set_param(struct iscsi_cls_co
 	int value;
 
 	switch(param) {
-	case ISCSI_PARAM_MAX_RECV_DLENGTH: {
-		char *saveptr = tcp_conn->data;
-		gfp_t flags = GFP_KERNEL;
-
-		sscanf(buf, "%d", &value);
-		if (tcp_conn->data_size >= value) {
-			iscsi_set_param(cls_conn, param, buf, buflen);
-			break;
-		}
-
-		spin_lock_bh(&session->lock);
-		if (conn->stop_stage == STOP_CONN_RECOVER)
-			flags = GFP_ATOMIC;
-		spin_unlock_bh(&session->lock);
-
-		if (value <= PAGE_SIZE)
-			tcp_conn->data = kmalloc(value, flags);
-		else
-			tcp_conn->data = (void*)__get_free_pages(flags,
-							     get_order(value));
-		if (tcp_conn->data == NULL) {
-			tcp_conn->data = saveptr;
-			return -ENOMEM;
-		}
-		if (tcp_conn->data_size <= PAGE_SIZE)
-			kfree(saveptr);
-		else
-			free_pages((unsigned long)saveptr,
-				   get_order(tcp_conn->data_size));
-		iscsi_set_param(cls_conn, param, buf, buflen);
-		tcp_conn->data_size = value;
-		break;
-		}
 	case ISCSI_PARAM_HDRDGST_EN:
 		iscsi_set_param(cls_conn, param, buf, buflen);
 		tcp_conn->hdr_size = sizeof(struct iscsi_hdr);
diff --git a/drivers/scsi/iscsi_tcp.h b/drivers/scsi/iscsi_tcp.h
index 8083028..6a4ee70 100644
--- a/drivers/scsi/iscsi_tcp.h
+++ b/drivers/scsi/iscsi_tcp.h
@@ -78,8 +78,6 @@ struct iscsi_tcp_conn {
 	char			hdrext[4*sizeof(__u16) +
 				    sizeof(__u32)];
 	int			data_copied;
-	char			*data;		/* data placeholder */
-	int			data_size;	/* actual recv_dlength */
 	int			stop_stage;	/* conn_stop() flag: *
 						 * stop to recover,  *
 						 * stop to terminate */
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index c989bc6..03b3dee 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -360,6 +360,10 @@ int __iscsi_complete_pdu(struct iscsi_co
 
 		switch(opcode) {
 		case ISCSI_OP_LOGOUT_RSP:
+			if (datalen) {
+				rc = ISCSI_ERR_PROTO;
+				break;
+			}
 			conn->exp_statsn = be32_to_cpu(hdr->statsn) + 1;
 			/* fall through */
 		case ISCSI_OP_LOGIN_RSP:
@@ -383,7 +387,7 @@ int __iscsi_complete_pdu(struct iscsi_co
 			iscsi_tmf_rsp(conn, hdr);
 			break;
 		case ISCSI_OP_NOOP_IN:
-			if (hdr->ttt != ISCSI_RESERVED_TAG) {
+			if (hdr->ttt != ISCSI_RESERVED_TAG || datalen) {
 				rc = ISCSI_ERR_PROTO;
 				break;
 			}
@@ -1405,7 +1409,7 @@ iscsi_conn_setup(struct iscsi_cls_sessio
 	data = kmalloc(DEFAULT_MAX_RECV_DATA_SEGMENT_LENGTH, GFP_KERNEL);
 	if (!data)
 		goto login_mtask_data_alloc_fail;
-	conn->login_mtask->data = data;
+	conn->login_mtask->data = conn->data = data;
 
 	init_timer(&conn->tmabort_timer);
 	mutex_init(&conn->xmitmutex);
@@ -1477,7 +1481,7 @@ void iscsi_conn_teardown(struct iscsi_cl
 	}
 
 	spin_lock_bh(&session->lock);
-	kfree(conn->login_mtask->data);
+	kfree(conn->data);
 	__kfifo_put(session->mgmtpool.queue, (void*)&conn->login_mtask,
 		    sizeof(void*));
 	list_del(&conn->item);
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 3f69f7e..41904f6 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -135,6 +135,14 @@ struct iscsi_conn {
 	int			id;		/* CID */
 	struct list_head	item;		/* maintains list of conns */
 	int			c_stage;	/* connection state */
+	/*
+	 * Preallocated buffer for pdus that have data but do not
+	 * originate from scsi-ml. We never have two pdus using the
+	 * buffer at the same time. It is only allocated to
+	 * the default max recv size because the pdus we support
+	 * should always fit in this buffer
+	 */
+	char			*data;
 	struct iscsi_mgmt_task	*login_mtask;	/* mtask used for login/text */
 	struct iscsi_mgmt_task	*mtask;		/* xmit mtask in progress */
 	struct iscsi_cmd_task	*ctask;		/* xmit ctask in progress */


