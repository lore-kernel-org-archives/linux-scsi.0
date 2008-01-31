From: michaelc@cs.wisc.edu
Subject: [PATCH 10/12] iscsi: fix up iscsi printk prefix
Date: Thu, 31 Jan 2008 13:36:52 -0600
Message-ID: <1201808217932-git-send-email-michaelc@cs.wisc.edu>
References: <12018082143359-git-send-email-michaelc@cs.wisc.edu>
 <12018082142447-git-send-email-michaelc@cs.wisc.edu>
 <1201808215968-git-send-email-michaelc@cs.wisc.edu>
 <1201808215955-git-send-email-michaelc@cs.wisc.edu>
 <12018082162624-git-send-email-michaelc@cs.wisc.edu>
 <12018082161847-git-send-email-michaelc@cs.wisc.edu>
 <1201808216137-git-send-email-michaelc@cs.wisc.edu>
 <12018082174157-git-send-email-michaelc@cs.wisc.edu>
 <1201808217738-git-send-email-michaelc@cs.wisc.edu>
 <12018082172234-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:46736 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760578AbYAaThC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jan 2008 14:37:02 -0500
In-Reply-To: <12018082172234-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

Some iscsi class messages have the dev_printk prefix and some libiscsi
and iscsi_tcp messages have "iscsi" or the module name as a prefix which
is normally pretty useless when trying to figure out which session
or connection the message is attached to. This patch adds iscsi lib
and class dev_printks so all messages have a common prefix that
can be used to figure out which object printed it.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/iscsi_tcp.c            |   57 ++++++++++++++------------
 drivers/scsi/libiscsi.c             |   76 ++++++++++++++++++++---------------
 drivers/scsi/scsi_transport_iscsi.c |   56 ++++++++++++++------------
 include/scsi/libiscsi.h             |    7 +++
 include/scsi/scsi_transport_iscsi.h |    6 +++
 5 files changed, 116 insertions(+), 86 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index b6f99df..8a17867 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -629,8 +629,9 @@ iscsi_r2t_rsp(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 	int rc;
 
 	if (tcp_conn->in.datalen) {
-		printk(KERN_ERR "iscsi_tcp: invalid R2t with datalen %d\n",
-		       tcp_conn->in.datalen);
+		iscsi_conn_printk(KERN_ERR, conn,
+				  "invalid R2t with datalen %d\n",
+				  tcp_conn->in.datalen);
 		return ISCSI_ERR_DATALEN;
 	}
 
@@ -644,8 +645,9 @@ iscsi_r2t_rsp(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 	iscsi_update_cmdsn(session, (struct iscsi_nopin*)rhdr);
 
 	if (!ctask->sc || session->state != ISCSI_STATE_LOGGED_IN) {
-		printk(KERN_INFO "iscsi_tcp: dropping R2T itt %d in "
-		       "recovery...\n", ctask->itt);
+		iscsi_conn_printk(KERN_INFO, conn,
+				  "dropping R2T itt %d in recovery.\n",
+				  ctask->itt);
 		return 0;
 	}
 
@@ -655,7 +657,8 @@ iscsi_r2t_rsp(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 	r2t->exp_statsn = rhdr->statsn;
 	r2t->data_length = be32_to_cpu(rhdr->data_length);
 	if (r2t->data_length == 0) {
-		printk(KERN_ERR "iscsi_tcp: invalid R2T with zero data len\n");
+		iscsi_conn_printk(KERN_ERR, conn,
+				  "invalid R2T with zero data len\n");
 		__kfifo_put(tcp_ctask->r2tpool.queue, (void*)&r2t,
 			    sizeof(void*));
 		return ISCSI_ERR_DATALEN;
@@ -668,9 +671,10 @@ iscsi_r2t_rsp(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 
 	r2t->data_offset = be32_to_cpu(rhdr->data_offset);
 	if (r2t->data_offset + r2t->data_length > scsi_bufflen(ctask->sc)) {
-		printk(KERN_ERR "iscsi_tcp: invalid R2T with data len %u at "
-		       "offset %u and total length %d\n", r2t->data_length,
-		       r2t->data_offset, scsi_bufflen(ctask->sc));
+		iscsi_conn_printk(KERN_ERR, conn,
+				  "invalid R2T with data len %u at offset %u "
+				  "and total length %d\n", r2t->data_length,
+				  r2t->data_offset, scsi_bufflen(ctask->sc));
 		__kfifo_put(tcp_ctask->r2tpool.queue, (void*)&r2t,
 			    sizeof(void*));
 		return ISCSI_ERR_DATALEN;
@@ -736,8 +740,9 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 	/* verify PDU length */
 	tcp_conn->in.datalen = ntoh24(hdr->dlength);
 	if (tcp_conn->in.datalen > conn->max_recv_dlength) {
-		printk(KERN_ERR "iscsi_tcp: datalen %d > %d\n",
-		       tcp_conn->in.datalen, conn->max_recv_dlength);
+		iscsi_conn_printk(KERN_ERR, conn,
+				  "iscsi_tcp: datalen %d > %d\n",
+				  tcp_conn->in.datalen, conn->max_recv_dlength);
 		return ISCSI_ERR_DATALEN;
 	}
 
@@ -819,10 +824,12 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 		 * For now we fail until we find a vendor that needs it
 		 */
 		if (ISCSI_DEF_MAX_RECV_SEG_LEN < tcp_conn->in.datalen) {
-			printk(KERN_ERR "iscsi_tcp: received buffer of len %u "
-			      "but conn buffer is only %u (opcode %0x)\n",
-			      tcp_conn->in.datalen,
-			      ISCSI_DEF_MAX_RECV_SEG_LEN, opcode);
+			iscsi_conn_printk(KERN_ERR, conn,
+					  "iscsi_tcp: received buffer of "
+					  "len %u but conn buffer is only %u "
+					  "(opcode %0x)\n",
+					  tcp_conn->in.datalen,
+					  ISCSI_DEF_MAX_RECV_SEG_LEN, opcode);
 			rc = ISCSI_ERR_PROTO;
 			break;
 		}
@@ -1496,30 +1503,25 @@ iscsi_tcp_conn_create(struct iscsi_cls_session *cls_session, uint32_t conn_idx)
 	tcp_conn->tx_hash.tfm = crypto_alloc_hash("crc32c", 0,
 						  CRYPTO_ALG_ASYNC);
 	tcp_conn->tx_hash.flags = 0;
-	if (IS_ERR(tcp_conn->tx_hash.tfm)) {
-		printk(KERN_ERR "Could not create connection due to crc32c "
-		       "loading error %ld. Make sure the crc32c module is "
-		       "built as a module or into the kernel\n",
-			PTR_ERR(tcp_conn->tx_hash.tfm));
+	if (IS_ERR(tcp_conn->tx_hash.tfm))
 		goto free_tcp_conn;
-	}
 
 	tcp_conn->rx_hash.tfm = crypto_alloc_hash("crc32c", 0,
 						  CRYPTO_ALG_ASYNC);
 	tcp_conn->rx_hash.flags = 0;
-	if (IS_ERR(tcp_conn->rx_hash.tfm)) {
-		printk(KERN_ERR "Could not create connection due to crc32c "
-		       "loading error %ld. Make sure the crc32c module is "
-		       "built as a module or into the kernel\n",
-			PTR_ERR(tcp_conn->rx_hash.tfm));
+	if (IS_ERR(tcp_conn->rx_hash.tfm))
 		goto free_tx_tfm;
-	}
 
 	return cls_conn;
 
 free_tx_tfm:
 	crypto_free_hash(tcp_conn->tx_hash.tfm);
 free_tcp_conn:
+	iscsi_conn_printk(KERN_ERR, conn,
+			  "Could not create connection due to crc32c "
+			  "loading error. Make sure the crc32c "
+			  "module is built as a module or into the "
+			  "kernel\n");
 	kfree(tcp_conn);
 tcp_conn_alloc_fail:
 	iscsi_conn_teardown(cls_conn);
@@ -1627,7 +1629,8 @@ iscsi_tcp_conn_bind(struct iscsi_cls_session *cls_session,
 	/* lookup for existing socket */
 	sock = sockfd_lookup((int)transport_eph, &err);
 	if (!sock) {
-		printk(KERN_ERR "iscsi_tcp: sockfd_lookup failed %d\n", err);
+		iscsi_conn_printk(KERN_ERR, conn,
+				  "sockfd_lookup failed %d\n", err);
 		return -EEXIST;
 	}
 	/*
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 7e781fd..c76bd5c 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -416,8 +416,9 @@ static void iscsi_scsi_cmd_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 
 		if (datalen < 2) {
 invalid_datalen:
-			printk(KERN_ERR "iscsi: Got CHECK_CONDITION but "
-			       "invalid data buffer size of %d\n", datalen);
+			iscsi_conn_printk(KERN_ERR,  conn,
+					 "Got CHECK_CONDITION but invalid data "
+					 "buffer size of %d\n", datalen);
 			sc->result = DID_BAD_TARGET << 16;
 			goto out;
 		}
@@ -494,7 +495,7 @@ static void iscsi_send_nopout(struct iscsi_conn *conn, struct iscsi_nopin *rhdr)
 
 	mtask = __iscsi_conn_send_pdu(conn, (struct iscsi_hdr *)&hdr, NULL, 0);
 	if (!mtask) {
-		printk(KERN_ERR "Could not send nopout\n");
+		iscsi_conn_printk(KERN_ERR, conn, "Could not send nopout\n");
 		return;
 	}
 
@@ -522,9 +523,10 @@ static int iscsi_handle_reject(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		if (ntoh24(reject->dlength) >= sizeof(struct iscsi_hdr)) {
 			memcpy(&rejected_pdu, data, sizeof(struct iscsi_hdr));
 			itt = get_itt(rejected_pdu.itt);
-			printk(KERN_ERR "itt 0x%x had pdu (op 0x%x) rejected "
-				"due to DataDigest error.\n", itt,
-				rejected_pdu.opcode);
+			iscsi_conn_printk(KERN_ERR, conn,
+					  "itt 0x%x had pdu (op 0x%x) rejected "
+					  "due to DataDigest error.\n", itt,
+					  rejected_pdu.opcode);
 		}
 	}
 	return 0;
@@ -697,16 +699,19 @@ int iscsi_verify_itt(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 	if (hdr->itt != RESERVED_ITT) {
 		if (((__force u32)hdr->itt & ISCSI_AGE_MASK) !=
 		    (session->age << ISCSI_AGE_SHIFT)) {
-			printk(KERN_ERR "iscsi: received itt %x expected "
-				"session age (%x)\n", (__force u32)hdr->itt,
-				session->age & ISCSI_AGE_MASK);
+			iscsi_conn_printk(KERN_ERR, conn,
+					  "received itt %x expected session "
+					  "age (%x)\n", (__force u32)hdr->itt,
+					  session->age & ISCSI_AGE_MASK);
 			return ISCSI_ERR_BAD_ITT;
 		}
 
 		if (((__force u32)hdr->itt & ISCSI_CID_MASK) !=
 		    (conn->id << ISCSI_CID_SHIFT)) {
-			printk(KERN_ERR "iscsi: received itt %x, expected "
-				"CID (%x)\n", (__force u32)hdr->itt, conn->id);
+			iscsi_conn_printk(KERN_ERR, conn,
+					  "iscsi: received itt %x, expected "
+					  "CID (%x)\n",
+					  (__force u32)hdr->itt, conn->id);
 			return ISCSI_ERR_BAD_ITT;
 		}
 		itt = get_itt(hdr->itt);
@@ -717,16 +722,17 @@ int iscsi_verify_itt(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		ctask = session->cmds[itt];
 
 		if (!ctask->sc) {
-			printk(KERN_INFO "iscsi: dropping ctask with "
-			       "itt 0x%x\n", ctask->itt);
+			iscsi_conn_printk(KERN_INFO, conn, "dropping ctask "
+					  "with itt 0x%x\n", ctask->itt);
 			/* force drop */
 			return ISCSI_ERR_NO_SCSI_CMD;
 		}
 
 		if (ctask->sc->SCp.phase != session->age) {
-			printk(KERN_ERR "iscsi: ctask's session age %d, "
-				"expected %d\n", ctask->sc->SCp.phase,
-				session->age);
+			iscsi_conn_printk(KERN_ERR, conn,
+					  "iscsi: ctask's session age %d, "
+					  "expected %d\n", ctask->sc->SCp.phase,
+					  session->age);
 			return ISCSI_ERR_SESSION_FAILED;
 		}
 	}
@@ -1171,7 +1177,8 @@ failed:
 	mutex_lock(&session->eh_mutex);
 	spin_lock_bh(&session->lock);
 	if (session->state == ISCSI_STATE_LOGGED_IN)
-		printk(KERN_INFO "iscsi: host reset succeeded\n");
+		iscsi_session_printk(KERN_INFO, session,
+				     "host reset succeeded\n");
 	else
 		goto failed;
 	spin_unlock_bh(&session->lock);
@@ -1369,10 +1376,10 @@ static void iscsi_check_transport_timeouts(unsigned long data)
 	last_recv = conn->last_recv;
 	if (time_before_eq(last_recv + timeout + (conn->ping_timeout * HZ),
 			   jiffies)) {
-		printk(KERN_ERR "ping timeout of %d secs expired, "
-		       "last rx %lu, last ping %lu, now %lu\n",
-		       conn->ping_timeout, last_recv,
-		       conn->last_ping, jiffies);
+		iscsi_conn_printk(KERN_ERR, conn, "ping timeout of %d secs "
+				  "expired, last rx %lu, last ping %lu, "
+				  "now %lu\n", conn->ping_timeout, last_recv,
+				  conn->last_ping, jiffies);
 		spin_unlock(&session->lock);
 		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
 		return;
@@ -1953,9 +1960,10 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
 		}
 		spin_unlock_irqrestore(session->host->host_lock, flags);
 		msleep_interruptible(500);
-		printk(KERN_INFO "iscsi: scsi conn_destroy(): host_busy %d "
-		       "host_failed %d\n", session->host->host_busy,
-		       session->host->host_failed);
+		iscsi_conn_printk(KERN_INFO, conn, "iscsi conn_destroy(): "
+				  "host_busy %d host_failed %d\n",
+				  session->host->host_busy,
+				  session->host->host_failed);
 		/*
 		 * force eh_abort() to unblock
 		 */
@@ -1984,27 +1992,28 @@ int iscsi_conn_start(struct iscsi_cls_conn *cls_conn)
 	struct iscsi_session *session = conn->session;
 
 	if (!session) {
-		printk(KERN_ERR "iscsi: can't start unbound connection\n");
+		iscsi_conn_printk(KERN_ERR, conn,
+				  "can't start unbound connection\n");
 		return -EPERM;
 	}
 
 	if ((session->imm_data_en || !session->initial_r2t_en) &&
 	     session->first_burst > session->max_burst) {
-		printk("iscsi: invalid burst lengths: "
-		       "first_burst %d max_burst %d\n",
-		       session->first_burst, session->max_burst);
+		iscsi_conn_printk(KERN_INFO, conn, "invalid burst lengths: "
+				  "first_burst %d max_burst %d\n",
+				  session->first_burst, session->max_burst);
 		return -EINVAL;
 	}
 
 	if (conn->ping_timeout && !conn->recv_timeout) {
-		printk(KERN_ERR "iscsi: invalid recv timeout of zero "
-		      "Using 5 seconds\n.");
+		iscsi_conn_printk(KERN_ERR, conn, "invalid recv timeout of "
+				  "zero. Using 5 seconds\n.");
 		conn->recv_timeout = 5;
 	}
 
 	if (conn->recv_timeout && !conn->ping_timeout) {
-		printk(KERN_ERR "iscsi: invalid ping timeout of zero "
-		      "Using 5 seconds.\n");
+		iscsi_conn_printk(KERN_ERR, conn, "invalid ping timeout of "
+				  "zero. Using 5 seconds.\n");
 		conn->ping_timeout = 5;
 	}
 
@@ -2148,7 +2157,8 @@ void iscsi_conn_stop(struct iscsi_cls_conn *cls_conn, int flag)
 		iscsi_start_session_recovery(session, conn, flag);
 		break;
 	default:
-		printk(KERN_ERR "iscsi: invalid stop flag %d\n", flag);
+		iscsi_conn_printk(KERN_ERR, conn,
+				  "invalid stop flag %d\n", flag);
 	}
 }
 EXPORT_SYMBOL_GPL(iscsi_conn_stop);
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 35834bf..8e73ff0 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -350,8 +350,9 @@ static void session_recovery_timedout(struct work_struct *work)
 			     recovery_work.work);
 	unsigned long flags;
 
-	dev_printk(KERN_INFO, &session->dev, "iscsi: session recovery timed "
-		  "out after %d secs\n", session->recovery_tmo);
+	iscsi_cls_session_printk(KERN_INFO, session,
+				 "session recovery timed out after %d secs\n",
+				 session->recovery_tmo);
 
 	spin_lock_irqsave(&session->lock, flags);
 	switch (session->state) {
@@ -492,8 +493,8 @@ int iscsi_add_session(struct iscsi_cls_session *session, unsigned int target_id)
 		 session->sid);
 	err = device_add(&session->dev);
 	if (err) {
-		dev_printk(KERN_ERR, &session->dev, "iscsi: could not "
-			   "register session's dev\n");
+		iscsi_cls_session_printk(KERN_ERR, session,
+					 "could not register session's dev\n");
 		goto release_host;
 	}
 	transport_register_device(&session->dev);
@@ -597,8 +598,9 @@ void iscsi_remove_session(struct iscsi_cls_session *session)
 	err = device_for_each_child(&session->dev, NULL,
 				    iscsi_iter_destroy_conn_fn);
 	if (err)
-		dev_printk(KERN_ERR, &session->dev, "iscsi: Could not delete "
-			   "all connections for session. Error %d.\n", err);
+		iscsi_cls_session_printk(KERN_ERR, session,
+					 "Could not delete all connections "
+					 "for session. Error %d.\n", err);
 
 	transport_unregister_device(&session->dev);
 	device_del(&session->dev);
@@ -670,8 +672,8 @@ iscsi_create_conn(struct iscsi_cls_session *session, uint32_t cid)
 	conn->dev.release = iscsi_conn_release;
 	err = device_register(&conn->dev);
 	if (err) {
-		dev_printk(KERN_ERR, &conn->dev, "iscsi: could not register "
-			   "connection's dev\n");
+		iscsi_cls_session_printk(KERN_ERR, session, "could not "
+					 "register connection's dev\n");
 		goto release_parent_ref;
 	}
 	transport_register_device(&conn->dev);
@@ -778,8 +780,8 @@ int iscsi_recv_pdu(struct iscsi_cls_conn *conn, struct iscsi_hdr *hdr,
 	skb = alloc_skb(len, GFP_ATOMIC);
 	if (!skb) {
 		iscsi_conn_error(conn, ISCSI_ERR_CONN_FAILED);
-		dev_printk(KERN_ERR, &conn->dev, "iscsi: can not deliver "
-			   "control PDU: OOM\n");
+		iscsi_cls_conn_printk(KERN_ERR, conn, "can not deliver "
+				      "control PDU: OOM\n");
 		return -ENOMEM;
 	}
 
@@ -819,8 +821,8 @@ void iscsi_conn_error(struct iscsi_cls_conn *conn, enum iscsi_err error)
 
 	skb = alloc_skb(len, GFP_ATOMIC);
 	if (!skb) {
-		dev_printk(KERN_ERR, &conn->dev, "iscsi: gracefully ignored "
-			  "conn error (%d)\n", error);
+		iscsi_cls_conn_printk(KERN_ERR, conn, "gracefully ignored "
+				      "conn error (%d)\n", error);
 		return;
 	}
 
@@ -834,8 +836,8 @@ void iscsi_conn_error(struct iscsi_cls_conn *conn, enum iscsi_err error)
 
 	iscsi_broadcast_skb(skb, GFP_ATOMIC);
 
-	dev_printk(KERN_INFO, &conn->dev, "iscsi: detected conn error (%d)\n",
-		   error);
+	iscsi_cls_conn_printk(KERN_INFO, conn, "detected conn error (%d)\n",
+			      error);
 }
 EXPORT_SYMBOL_GPL(iscsi_conn_error);
 
@@ -890,8 +892,8 @@ iscsi_if_get_stats(struct iscsi_transport *transport, struct nlmsghdr *nlh)
 
 		skbstat = alloc_skb(len, GFP_ATOMIC);
 		if (!skbstat) {
-			dev_printk(KERN_ERR, &conn->dev, "iscsi: can not "
-				   "deliver stats: OOM\n");
+			iscsi_cls_conn_printk(KERN_ERR, conn, "can not "
+					      "deliver stats: OOM\n");
 			return -ENOMEM;
 		}
 
@@ -947,8 +949,9 @@ int iscsi_session_event(struct iscsi_cls_session *session,
 
 	skb = alloc_skb(len, GFP_KERNEL);
 	if (!skb) {
-		dev_printk(KERN_ERR, &session->dev, "Cannot notify userspace "
-			  "of session event %u\n", event);
+		iscsi_cls_session_printk(KERN_ERR, session,
+					 "Cannot notify userspace of session "
+					 "event %u\n", event);
 		return -ENOMEM;
 	}
 
@@ -971,8 +974,8 @@ int iscsi_session_event(struct iscsi_cls_session *session,
 		ev->r.unbind_session.sid = session->sid;
 		break;
 	default:
-		dev_printk(KERN_ERR, &session->dev, "Invalid event %u.\n",
-			   event);
+		iscsi_cls_session_printk(KERN_ERR, session, "Invalid event "
+					 "%u.\n", event);
 		kfree_skb(skb);
 		return -EINVAL;
 	}
@@ -983,8 +986,10 @@ int iscsi_session_event(struct iscsi_cls_session *session,
 	 */
 	rc = iscsi_broadcast_skb(skb, GFP_KERNEL);
 	if (rc < 0)
-		dev_printk(KERN_ERR, &session->dev, "Cannot notify userspace "
-			  "of session event %u. Check iscsi daemon\n", event);
+		iscsi_cls_session_printk(KERN_ERR, session,
+					 "Cannot notify userspace of session "
+					 "event %u. Check iscsi daemon\n",
+					 event);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(iscsi_session_event);
@@ -1017,16 +1022,15 @@ iscsi_if_create_conn(struct iscsi_transport *transport, struct iscsi_uevent *ev)
 
 	session = iscsi_session_lookup(ev->u.c_conn.sid);
 	if (!session) {
-		printk(KERN_ERR "iscsi: invalid session %d\n",
+		printk(KERN_ERR "iscsi: invalid session %d.\n",
 		       ev->u.c_conn.sid);
 		return -EINVAL;
 	}
 
 	conn = transport->create_conn(session, ev->u.c_conn.cid);
 	if (!conn) {
-		printk(KERN_ERR "iscsi: couldn't create a new "
-			   "connection for session %d\n",
-			   session->sid);
+		iscsi_cls_session_printk(KERN_ERR, session,
+					 "couldn't create a new connection.");
 		return -ENOMEM;
 	}
 
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 53f5909..5daa83c 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -344,6 +344,10 @@ extern int iscsi_session_get_param(struct iscsi_cls_session *cls_session,
 #define session_to_cls(_sess) \
 	hostdata_session(_sess->host->hostdata)
 
+#define iscsi_session_printk(prefix, _sess, fmt, a...)	\
+	iscsi_cls_session_printk(prefix,		\
+		(struct iscsi_cls_session *)session_to_cls(_sess), fmt, ##a)
+
 /*
  * connection management
  */
@@ -358,6 +362,9 @@ extern void iscsi_conn_failure(struct iscsi_conn *conn, enum iscsi_err err);
 extern int iscsi_conn_get_param(struct iscsi_cls_conn *cls_conn,
 				enum iscsi_param param, char *buf);
 
+#define iscsi_conn_printk(prefix, _c, fmt, a...) \
+	iscsi_cls_conn_printk(prefix, _c->cls_conn, fmt, ##a)
+
 /*
  * pdu and task processing
  */
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 83693ba..dbc96ef 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -212,6 +212,12 @@ struct iscsi_host {
 /*
  * session and connection functions that can be used by HW iSCSI LLDs
  */
+#define iscsi_cls_session_printk(prefix, _cls_session, fmt, a...) \
+	dev_printk(prefix, &(_cls_session)->dev, fmt, ##a)
+
+#define iscsi_cls_conn_printk(prefix, _cls_conn, fmt, a...) \
+	dev_printk(prefix, &(_cls_conn)->dev, fmt, ##a)
+
 extern int iscsi_session_chkready(struct iscsi_cls_session *session);
 extern struct iscsi_cls_session *iscsi_alloc_session(struct Scsi_Host *shost,
 					struct iscsi_transport *transport);
-- 
1.5.2.1

