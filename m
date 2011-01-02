From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 06/16] BNX2I: Added code to handle the binding of an existing
 connection
Date: Sat, 01 Jan 2011 22:11:07 -0600
Message-ID: <4D1FFADB.60307@cs.wisc.edu>
References: <Eddie Wai <eddie.wai@broadcom.com> <1289430297-30221-7-git-send-email-eddie.wai@broadcom.com> <4CE49C85.2070109@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020703090405020208060705"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:53954 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324Ab1ABEOv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 1 Jan 2011 23:14:51 -0500
In-Reply-To: <4CE49C85.2070109@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com
Cc: Eddie Wai <eddie.wai@broadcom.com>, James Bottomley <JBottomley@novell.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>

This is a multi-part message in MIME format.
--------------020703090405020208060705
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 11/17/2010 09:24 PM, Mike Christie wrote:
> On 11/10/2010 05:04 PM, Eddie Wai wrote:
>> This is the case when iscsid gets re-launched due to features like
>> iSCSI boot which requires the daemon to re-launch due to
>> pivot root. If the code detected the connection had an existing
>> endpoint, the old endpoint must get cleaned up.
>>
>> Signed-off-by: Eddie Wai<eddie.wai@broadcom.com>
>> Acked-by: Anil Veerabhadrappa<anilgv@broadcom.com>
>> ---
>> drivers/scsi/bnx2i/bnx2i_iscsi.c | 7 +++++++
>> 1 files changed, 7 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c
>> b/drivers/scsi/bnx2i/bnx2i_iscsi.c
>> index 823e4fa..3b65c64 100644
>> --- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
>> +++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
>> @@ -1410,6 +1410,13 @@ static int bnx2i_conn_bind(struct
>> iscsi_cls_session *cls_session,
>> hba->netdev->name);
>> return -EEXIST;
>> }
>> + if (bnx2i_conn->ep) {
>> + printk(KERN_ALERT "bnx2i: Binding to an existing endpoint "
>> + "detected. Disconnecting the old...\n");
>> + mutex_lock(&hba->net_dev_lock);
>> + bnx2i_hw_ep_disconnect(bnx2i_conn->ep);
>> + mutex_unlock(&hba->net_dev_lock);
>> + }
>> bnx2i_ep->conn = bnx2i_conn;
>> bnx2i_conn->ep = bnx2i_ep;
>> bnx2i_conn->iscsi_conn_cid = bnx2i_ep->ep_iscsi_cid;
>
> Don't you still leak what bnx2i_free_ep frees?
>
> In userspace you should have iscsid/iscsi_sync_session match the iscsi
> endpoint with the iscsi conn and set transport_ep_handle. ep_disconnect
> will then get called like normal to clean up the old connection.
>

I went a different way. In the attached patch we detect the problem when 
binding and will force a disconnect of the old ep before binding a new one.

Try it out and let me know.

--------------020703090405020208060705
Content-Type: text/plain;
 name="iscsi-fix-ep-boot-leak.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="iscsi-fix-ep-boot-leak.patch"

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 7b2fc98..921c2cb 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -331,8 +331,7 @@ iscsi_iser_conn_destroy(struct iscsi_cls_conn *cls_conn)
 
 static int
 iscsi_iser_conn_bind(struct iscsi_cls_session *cls_session,
-		     struct iscsi_cls_conn *cls_conn, uint64_t transport_eph,
-		     int is_leading)
+		     struct iscsi_cls_conn *cls_conn, uint64_t transport_eph)
 {
 	struct iscsi_conn *conn = cls_conn->dd_data;
 	struct iscsi_iser_conn *iser_conn;
@@ -340,10 +339,6 @@ iscsi_iser_conn_bind(struct iscsi_cls_session *cls_session,
 	struct iscsi_endpoint *ep;
 	int error;
 
-	error = iscsi_conn_bind(cls_session, cls_conn, is_leading);
-	if (error)
-		return error;
-
 	/* the transport ep handle comes from user space so it must be
 	 * verified against the global ib connections list */
 	ep = iscsi_lookup_endpoint(transport_eph);
@@ -352,6 +347,11 @@ iscsi_iser_conn_bind(struct iscsi_cls_session *cls_session,
 			 (unsigned long long)transport_eph);
 		return -EINVAL;
 	}
+
+	error = iscsi_conn_bind(cls_session, cls_conn, ep);
+	if (error)
+		return error;
+
 	ib_conn = ep->dd_data;
 
 	/* binds the iSER connection retrieved from the previously
diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index eaaa881..97533e7 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -174,7 +174,7 @@ static int beiscsi_bindconn_cid(struct beiscsi_hba *phba,
  */
 int beiscsi_conn_bind(struct iscsi_cls_session *cls_session,
 		      struct iscsi_cls_conn *cls_conn,
-		      u64 transport_fd, int is_leading)
+		      u64 transport_fd)
 {
 	struct iscsi_conn *conn = cls_conn->dd_data;
 	struct beiscsi_conn *beiscsi_conn = conn->dd_data;
@@ -191,7 +191,7 @@ int beiscsi_conn_bind(struct iscsi_cls_session *cls_session,
 
 	beiscsi_ep = ep->dd_data;
 
-	if (iscsi_conn_bind(cls_session, cls_conn, is_leading))
+	if (iscsi_conn_bind(cls_session, cls_conn, ep))
 		return -EINVAL;
 
 	if (beiscsi_ep->phba != phba) {
diff --git a/drivers/scsi/be2iscsi/be_iscsi.h b/drivers/scsi/be2iscsi/be_iscsi.h
index 8950a70..4047ec1 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.h
+++ b/drivers/scsi/be2iscsi/be_iscsi.h
@@ -46,7 +46,7 @@ struct iscsi_cls_conn *beiscsi_conn_create(struct iscsi_cls_session
 
 int beiscsi_conn_bind(struct iscsi_cls_session *cls_session,
 		      struct iscsi_cls_conn *cls_conn,
-		      uint64_t transport_fd, int is_leading);
+		      uint64_t transport_fd);
 
 int beiscsi_conn_get_param(struct iscsi_cls_conn *cls_conn,
 			   enum iscsi_param param, char *buf);
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index f0dce26..7c5c1d9 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1373,7 +1373,7 @@ free_conn:
  */
 static int bnx2i_conn_bind(struct iscsi_cls_session *cls_session,
 			   struct iscsi_cls_conn *cls_conn,
-			   uint64_t transport_fd, int is_leading)
+			   uint64_t transport_fd)
 {
 	struct iscsi_conn *conn = cls_conn->dd_data;
 	struct bnx2i_conn *bnx2i_conn = conn->dd_data;
@@ -1399,7 +1399,7 @@ static int bnx2i_conn_bind(struct iscsi_cls_session *cls_session,
 		/* Peer disconnect via' FIN or RST */
 		return -EINVAL;
 
-	if (iscsi_conn_bind(cls_session, cls_conn, is_leading))
+	if (iscsi_conn_bind(cls_session, cls_conn, ep))
 		return -EINVAL;
 
 	if (bnx2i_ep->hba != hba) {
diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index be56617..84125e9 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -2264,7 +2264,7 @@ EXPORT_SYMBOL_GPL(cxgbi_create_conn);
 
 int cxgbi_bind_conn(struct iscsi_cls_session *cls_session,
 				struct iscsi_cls_conn *cls_conn,
-				u64 transport_eph, int is_leading)
+				u64 transport_eph)
 {
 	struct iscsi_conn *conn = cls_conn->dd_data;
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
@@ -2285,7 +2285,7 @@ int cxgbi_bind_conn(struct iscsi_cls_session *cls_session,
 	if (err < 0)
 		return err;
 
-	err = iscsi_conn_bind(cls_session, cls_conn, is_leading);
+	err = iscsi_conn_bind(cls_session, cls_conn, ep);
 	if (err)
 		return -EINVAL;
 
diff --git a/drivers/scsi/cxgbi/libcxgbi.h b/drivers/scsi/cxgbi/libcxgbi.h
index c57d59d..1bd50e3 100644
--- a/drivers/scsi/cxgbi/libcxgbi.h
+++ b/drivers/scsi/cxgbi/libcxgbi.h
@@ -718,7 +718,7 @@ int cxgbi_set_conn_param(struct iscsi_cls_conn *,
 int cxgbi_get_conn_param(struct iscsi_cls_conn *, enum iscsi_param, char *);
 struct iscsi_cls_conn *cxgbi_create_conn(struct iscsi_cls_session *, u32);
 int cxgbi_bind_conn(struct iscsi_cls_session *,
-			struct iscsi_cls_conn *, u64, int);
+			struct iscsi_cls_conn *, u64);
 void cxgbi_destroy_session(struct iscsi_cls_session *);
 struct iscsi_cls_session *cxgbi_create_session(struct iscsi_endpoint *,
 			u16, u16, u32);
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index fec47de..9961c22 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -651,8 +651,7 @@ free_addr:
 
 static int
 iscsi_sw_tcp_conn_bind(struct iscsi_cls_session *cls_session,
-		       struct iscsi_cls_conn *cls_conn, uint64_t transport_eph,
-		       int is_leading)
+		       struct iscsi_cls_conn *cls_conn, uint64_t transport_eph)
 {
 	struct Scsi_Host *shost = iscsi_session_to_shost(cls_session);
 	struct iscsi_host *ihost = shost_priv(shost);
@@ -685,7 +684,7 @@ iscsi_sw_tcp_conn_bind(struct iscsi_cls_session *cls_session,
 	if (err)
 		goto free_socket;
 
-	err = iscsi_conn_bind(cls_session, cls_conn, is_leading);
+	err = iscsi_conn_bind(cls_session, cls_conn, NULL);
 	if (err)
 		goto free_socket;
 
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index da8b615..76960fb 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -3137,16 +3137,18 @@ void iscsi_conn_stop(struct iscsi_cls_conn *cls_conn, int flag)
 EXPORT_SYMBOL_GPL(iscsi_conn_stop);
 
 int iscsi_conn_bind(struct iscsi_cls_session *cls_session,
-		    struct iscsi_cls_conn *cls_conn, int is_leading)
+		    struct iscsi_cls_conn *cls_conn,
+		    struct iscsi_endpoint *ep)
 {
 	struct iscsi_session *session = cls_session->dd_data;
 	struct iscsi_conn *conn = cls_conn->dd_data;
 
 	spin_lock_bh(&session->lock);
-	if (is_leading)
-		session->leadconn = conn;
+	session->leadconn = conn;
 	spin_unlock_bh(&session->lock);
 
+	ep->conn = cls_conn;
+	cls_conn->ep = ep;
 	/*
 	 * Unblock xmitworker(), Login Phase will pass through.
 	 */
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index f905ecb..035c8bd 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -975,7 +975,6 @@ iscsi_create_conn(struct iscsi_cls_session *session, int dd_size, uint32_t cid)
 
 	spin_lock_irqsave(&connlock, flags);
 	list_add(&conn->conn_list, &connlist);
-	conn->active = 1;
 	spin_unlock_irqrestore(&connlock, flags);
 
 	ISCSI_DBG_TRANS_CONN(conn, "Completed conn creation\n");
@@ -1001,7 +1000,6 @@ int iscsi_destroy_conn(struct iscsi_cls_conn *conn)
 	unsigned long flags;
 
 	spin_lock_irqsave(&connlock, flags);
-	conn->active = 0;
 	list_del(&conn->conn_list);
 	spin_unlock_irqrestore(&connlock, flags);
 
@@ -1430,6 +1428,26 @@ release_host:
 	return err;
 }
 
+static int iscsi_if_ep_disconnect(struct iscsi_transport *transport,
+				  u64 ep_handle)
+{
+	struct iscsi_cls_conn *conn;
+	struct iscsi_endpoint *ep;
+
+	if (!transport->ep_disconnect)
+		return -EINVAL;
+
+	ep = iscsi_lookup_endpoint(ep_handle);
+	if (!ep)
+		return -EINVAL;
+	conn = ep->conn;
+
+	transport->ep_disconnect(ep);
+	if (conn)
+		conn->ep = NULL;
+	return 0;
+}
+
 static int
 iscsi_if_transport_ep(struct iscsi_transport *transport,
 		      struct iscsi_uevent *ev, int msg_type)
@@ -1454,14 +1472,8 @@ iscsi_if_transport_ep(struct iscsi_transport *transport,
 						   ev->u.ep_poll.timeout_ms);
 		break;
 	case ISCSI_UEVENT_TRANSPORT_EP_DISCONNECT:
-		if (!transport->ep_disconnect)
-			return -EINVAL;
-
-		ep = iscsi_lookup_endpoint(ev->u.ep_disconnect.ep_handle);
-		if (!ep)
-			return -EINVAL;
-
-		transport->ep_disconnect(ep);
+		rc = iscsi_if_ep_disconnect(transport,
+					    ev->u.ep_disconnect.ep_handle);
 		break;
 	}
 	return rc;
@@ -1609,10 +1621,12 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
 		session = iscsi_session_lookup(ev->u.b_conn.sid);
 		conn = iscsi_conn_lookup(ev->u.b_conn.sid, ev->u.b_conn.cid);
 
+		if (conn && conn->ep)
+			iscsi_if_ep_disconnect(transport, conn->ep->id);
+
 		if (session && conn)
 			ev->r.retcode =	transport->bind_conn(session, conn,
-					ev->u.b_conn.transport_eph,
-					ev->u.b_conn.is_leading);
+					ev->u.b_conn.transport_eph);
 		else
 			err = -EINVAL;
 		break;
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 748382b..006148e 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -388,7 +388,7 @@ extern void iscsi_conn_teardown(struct iscsi_cls_conn *);
 extern int iscsi_conn_start(struct iscsi_cls_conn *);
 extern void iscsi_conn_stop(struct iscsi_cls_conn *, int);
 extern int iscsi_conn_bind(struct iscsi_cls_session *, struct iscsi_cls_conn *,
-			   int);
+			   struct iscsi_endpoint *);
 extern void iscsi_conn_failure(struct iscsi_conn *conn, enum iscsi_err err);
 extern void iscsi_session_failure(struct iscsi_session *session,
 				  enum iscsi_err err);
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 7fff94b..225fe57 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -95,7 +95,7 @@ struct iscsi_transport {
 				uint32_t cid);
 	int (*bind_conn) (struct iscsi_cls_session *session,
 			  struct iscsi_cls_conn *cls_conn,
-			  uint64_t transport_eph, int is_leading);
+			  uint64_t transport_eph);
 	int (*start_conn) (struct iscsi_cls_conn *conn);
 	void (*stop_conn) (struct iscsi_cls_conn *conn, int flag);
 	void (*destroy_conn) (struct iscsi_cls_conn *conn);
@@ -160,8 +160,8 @@ struct iscsi_cls_conn {
 	void *dd_data;			/* LLD private data */
 	struct iscsi_transport *transport;
 	uint32_t cid;			/* connection id */
+	struct iscsi_endpoint *ep;
 
-	int active;			/* must be accessed with the connlock */
 	struct device dev;		/* sysfs transport/container device */
 };
 
@@ -222,6 +222,7 @@ struct iscsi_endpoint {
 	void *dd_data;			/* LLD private data */
 	struct device dev;
 	uint64_t id;
+	struct iscsi_cls_conn *conn;
 };
 
 /*

--------------020703090405020208060705--
