From: michaelc@cs.wisc.edu
Subject: [PATCH 01/25] iscsi class, iscsi_tcp/iser: add host arg to session creation
Date: Wed, 21 May 2008 15:53:56 -0500
Message-ID: <1211403260-5487-2-git-send-email-michaelc@cs.wisc.edu>
References: <1211403260-5487-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45172 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935745AbYEUUy0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 May 2008 16:54:26 -0400
In-Reply-To: <1211403260-5487-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

iscsi offload (bnx2i and qla4xx) allocate a scsi host per hba,
so the session creation path needs a shost/host_no argument.
Software iscsi/iser will follow the same behabior as before
where it allcoates a host per session, but in the future iser
will probably look more like bnx2i where the host's parent is
the hardware (rnic for iser and for bnx2i it is the nic), because
it does not use a socket layer like how iscsi_tcp does.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |    1 +
 drivers/scsi/iscsi_tcp.c                 |    5 ++-
 drivers/scsi/scsi_transport_iscsi.c      |   46 ++++++++++++++++++++++++------
 include/scsi/iscsi_if.h                  |    7 ++++
 include/scsi/libiscsi.h                  |    1 +
 include/scsi/scsi_transport_iscsi.h      |    4 +-
 6 files changed, 51 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index aeb58ca..efc1219 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -368,6 +368,7 @@ static struct iscsi_transport iscsi_iser_transport;
 static struct iscsi_cls_session *
 iscsi_iser_session_create(struct iscsi_transport *iscsit,
 			 struct scsi_transport_template *scsit,
+			 struct Scsi_Host *shost,
 			 uint16_t cmds_max, uint16_t qdepth,
 			 uint32_t initial_cmdsn, uint32_t *hostno)
 {
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 72b9b2a..81c421a 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -1871,8 +1871,9 @@ iscsi_conn_get_stats(struct iscsi_cls_conn *cls_conn, struct iscsi_stats *stats)
 static struct iscsi_cls_session *
 iscsi_tcp_session_create(struct iscsi_transport *iscsit,
 			 struct scsi_transport_template *scsit,
-			 uint16_t cmds_max, uint16_t qdepth,
-			 uint32_t initial_cmdsn, uint32_t *hostno)
+			 struct Scsi_Host *shost, uint16_t cmds_max,
+			 uint16_t qdepth, uint32_t initial_cmdsn,
+			 uint32_t *hostno)
 {
 	struct iscsi_cls_session *cls_session;
 	struct iscsi_session *session;
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 65d1737..2a6669d 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1017,21 +1017,38 @@ int iscsi_session_event(struct iscsi_cls_session *session,
 EXPORT_SYMBOL_GPL(iscsi_session_event);
 
 static int
-iscsi_if_create_session(struct iscsi_internal *priv, struct iscsi_uevent *ev)
+iscsi_if_create_session(struct iscsi_internal *priv, struct iscsi_uevent *ev,
+			uint32_t host_no, uint32_t initial_cmdsn,
+			uint16_t cmds_max, uint16_t queue_depth)
 {
 	struct iscsi_transport *transport = priv->iscsi_transport;
 	struct iscsi_cls_session *session;
-	uint32_t hostno;
+	struct Scsi_Host *shost = NULL;
 
-	session = transport->create_session(transport, &priv->t,
-					    ev->u.c_session.cmds_max,
-					    ev->u.c_session.queue_depth,
-					    ev->u.c_session.initial_cmdsn,
-					    &hostno);
+	/*
+	 * Software iscsi allocates a host per session, but
+	 * offload drivers (and possibly iser one day) allocate a host per
+	 * hba/nic/rnic. Offload will match a host here, but software will
+	 * return a new hostno after the create_session callback has returned.
+	 */
+	if (host_no != UINT_MAX) {
+		shost = scsi_host_lookup(host_no);
+		if (IS_ERR(shost)) {
+			printk(KERN_ERR "Could not find host no %u to "
+			       "create session\n", host_no);
+			return -ENODEV;
+		}
+	}
+
+	session = transport->create_session(transport, &priv->t, shost,
+					    cmds_max, queue_depth,
+					    initial_cmdsn, &host_no);
+	if (shost)
+		scsi_host_put(shost);
 	if (!session)
 		return -ENOMEM;
 
-	ev->r.c_session_ret.host_no = hostno;
+	ev->r.c_session_ret.host_no = host_no;
 	ev->r.c_session_ret.sid = session->sid;
 	return 0;
 }
@@ -1190,6 +1207,7 @@ static int
 iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 {
 	int err = 0;
+	uint32_t host_no = UINT_MAX;
 	struct iscsi_uevent *ev = NLMSG_DATA(nlh);
 	struct iscsi_transport *transport = NULL;
 	struct iscsi_internal *priv;
@@ -1208,7 +1226,17 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 
 	switch (nlh->nlmsg_type) {
 	case ISCSI_UEVENT_CREATE_SESSION:
-		err = iscsi_if_create_session(priv, ev);
+		err = iscsi_if_create_session(priv, ev, host_no,
+					      ev->u.c_session.initial_cmdsn,
+					      ev->u.c_session.cmds_max,
+					      ev->u.c_session.queue_depth);
+		break;
+	case ISCSI_UEVENT_CREATE_BOUND_SESSION:
+		err = iscsi_if_create_session(priv, ev,
+					ev->u.c_bound_session.host_no,
+					ev->u.c_bound_session.initial_cmdsn,
+					ev->u.c_bound_session.cmds_max,
+					ev->u.c_bound_session.queue_depth);
 		break;
 	case ISCSI_UEVENT_DESTROY_SESSION:
 		session = iscsi_session_lookup(ev->u.d_session.sid);
diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index e19e584..1883c85 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -50,6 +50,7 @@ enum iscsi_uevent_e {
 	ISCSI_UEVENT_TGT_DSCVR		= UEVENT_BASE + 15,
 	ISCSI_UEVENT_SET_HOST_PARAM	= UEVENT_BASE + 16,
 	ISCSI_UEVENT_UNBIND_SESSION	= UEVENT_BASE + 17,
+	ISCSI_UEVENT_CREATE_BOUND_SESSION	= UEVENT_BASE + 18,
 
 	/* up events */
 	ISCSI_KEVENT_RECV_PDU		= KEVENT_BASE + 1,
@@ -78,6 +79,12 @@ struct iscsi_uevent {
 			uint16_t	cmds_max;
 			uint16_t	queue_depth;
 		} c_session;
+		struct msg_create_bound_session {
+			uint32_t	host_no;
+			uint32_t	initial_cmdsn;
+			uint16_t	cmds_max;
+			uint16_t	queue_depth;
+		} c_bound_session;
 		struct msg_destroy_session {
 			uint32_t	sid;
 		} d_session;
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index cd3ca63..f24cf02 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -24,6 +24,7 @@
 #define LIBISCSI_H
 
 #include <linux/types.h>
+#include <linux/wait.h>
 #include <linux/mutex.h>
 #include <linux/timer.h>
 #include <linux/workqueue.h>
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index aab1eae..02a8520 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -92,8 +92,8 @@ struct iscsi_transport {
 	unsigned int max_conn;
 	unsigned int max_cmd_len;
 	struct iscsi_cls_session *(*create_session) (struct iscsi_transport *it,
-		struct scsi_transport_template *t, uint16_t, uint16_t,
-		uint32_t sn, uint32_t *hn);
+		struct scsi_transport_template *t, struct Scsi_Host *shost,
+		uint16_t cmds_max, uint16_t qdepth, uint32_t sn, uint32_t *hn);
 	void (*destroy_session) (struct iscsi_cls_session *session);
 	struct iscsi_cls_conn *(*create_conn) (struct iscsi_cls_session *sess,
 				uint32_t cid);
-- 
1.5.4.1

