From: michaelc@cs.wisc.edu
Subject: [PATCH 14/17] cxgbi: convert to use iscsi_conn_get_addr_param
Date: Wed, 16 Feb 2011 15:04:38 -0600
Message-ID: <1297890281-9076-15-git-send-email-michaelc@cs.wisc.edu>
References: <1297890281-9076-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44542 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754650Ab1BPVEk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Feb 2011 16:04:40 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1GL4ee9003226
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2011 16:04:40 -0500
Received: from meanminna.corp.redhat.com (vpn-11-254.rdu.redhat.com [10.11.11.254])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p1GL4Tt3004636
	for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2011 16:04:40 -0500
In-Reply-To: <1297890281-9076-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Mike Christie <michaelc@cs.wisc.edu>

This has cxgbi use the iscsi_conn_get_addr_param helper
and the get ep callback.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c |    3 ++-
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c |    3 ++-
 drivers/scsi/cxgbi/libcxgbi.c      |   36 +++++++++++++++++-------------------
 drivers/scsi/cxgbi/libcxgbi.h      |    2 +-
 include/scsi/libiscsi.h            |    6 ------
 5 files changed, 22 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
index 69a6769..fc2cdb6 100644
--- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
+++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
@@ -137,7 +137,7 @@ static struct iscsi_transport cxgb3i_iscsi_transport = {
 	.destroy_conn	= iscsi_tcp_conn_teardown,
 	.start_conn	= iscsi_conn_start,
 	.stop_conn	= iscsi_conn_stop,
-	.get_conn_param	= cxgbi_get_conn_param,
+	.get_conn_param	= iscsi_conn_get_param,
 	.set_param	= cxgbi_set_conn_param,
 	.get_stats	= cxgbi_get_conn_stats,
 	/* pdu xmit req from user space */
@@ -152,6 +152,7 @@ static struct iscsi_transport cxgb3i_iscsi_transport = {
 	.xmit_pdu	= cxgbi_conn_xmit_pdu,
 	.parse_pdu_itt	= cxgbi_parse_pdu_itt,
 	/* TCP connect/disconnect */
+	.get_ep_param	= cxgbi_get_ep_param,
 	.ep_connect	= cxgbi_ep_connect,
 	.ep_poll	= cxgbi_ep_poll,
 	.ep_disconnect	= cxgbi_ep_disconnect,
diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index 719aa71..f3a4cd7 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -138,7 +138,7 @@ static struct iscsi_transport cxgb4i_iscsi_transport = {
 	.destroy_conn	= iscsi_tcp_conn_teardown,
 	.start_conn		= iscsi_conn_start,
 	.stop_conn		= iscsi_conn_stop,
-	.get_conn_param	= cxgbi_get_conn_param,
+	.get_conn_param	= iscsi_conn_get_param,
 	.set_param	= cxgbi_set_conn_param,
 	.get_stats	= cxgbi_get_conn_stats,
 	/* pdu xmit req from user space */
@@ -153,6 +153,7 @@ static struct iscsi_transport cxgb4i_iscsi_transport = {
 	.xmit_pdu	= cxgbi_conn_xmit_pdu,
 	.parse_pdu_itt	= cxgbi_parse_pdu_itt,
 	/* TCP connect/disconnect */
+	.get_ep_param	= cxgbi_get_ep_param,
 	.ep_connect	= cxgbi_ep_connect,
 	.ep_poll	= cxgbi_ep_poll,
 	.ep_disconnect	= cxgbi_ep_disconnect,
diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index b2acdef..fedf1be 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -543,6 +543,7 @@ static struct cxgbi_sock *cxgbi_check_route(struct sockaddr *dst_addr)
 	csk->dst = dst;
 	csk->daddr.sin_addr.s_addr = daddr->sin_addr.s_addr;
 	csk->daddr.sin_port = daddr->sin_port;
+	csk->daddr.sin_family = daddr->sin_family;
 	csk->saddr.sin_addr.s_addr = rt->rt_src;
 
 	return csk;
@@ -2200,32 +2201,34 @@ int cxgbi_set_conn_param(struct iscsi_cls_conn *cls_conn,
 }
 EXPORT_SYMBOL_GPL(cxgbi_set_conn_param);
 
-int cxgbi_get_conn_param(struct iscsi_cls_conn *cls_conn,
-			enum iscsi_param param, char *buf)
+int cxgbi_get_ep_param(struct iscsi_endpoint *ep, enum iscsi_param param,
+		       char *buf)
 {
-	struct iscsi_conn *iconn = cls_conn->dd_data;
+	struct cxgbi_endpoint *cep = ep->dd_data;
+	struct cxgbi_sock *csk;
 	int len;
 
 	log_debug(1 << CXGBI_DBG_ISCSI,
-		"cls_conn 0x%p, param %d.\n", cls_conn, param);
+		"cls_conn 0x%p, param %d.\n", ep, param);
 
 	switch (param) {
 	case ISCSI_PARAM_CONN_PORT:
-		spin_lock_bh(&iconn->session->lock);
-		len = sprintf(buf, "%hu\n", iconn->portal_port);
-		spin_unlock_bh(&iconn->session->lock);
-		break;
 	case ISCSI_PARAM_CONN_ADDRESS:
-		spin_lock_bh(&iconn->session->lock);
-		len = sprintf(buf, "%s\n", iconn->portal_address);
-		spin_unlock_bh(&iconn->session->lock);
-		break;
+		if (!cep)
+			return -ENOTCONN;
+
+		csk = cep->csk;
+		if (!csk)
+			return -ENOTCONN;
+
+		return iscsi_conn_get_addr_param((struct sockaddr_storage *)
+						 &csk->daddr, param, buf);
 	default:
-		return iscsi_conn_get_param(cls_conn, param, buf);
+		return -ENOSYS;
 	}
 	return len;
 }
-EXPORT_SYMBOL_GPL(cxgbi_get_conn_param);
+EXPORT_SYMBOL_GPL(cxgbi_get_ep_param);
 
 struct iscsi_cls_conn *
 cxgbi_create_conn(struct iscsi_cls_session *cls_session, u32 cid)
@@ -2292,11 +2295,6 @@ int cxgbi_bind_conn(struct iscsi_cls_session *cls_session,
 	cxgbi_conn_max_xmit_dlength(conn);
 	cxgbi_conn_max_recv_dlength(conn);
 
-	spin_lock_bh(&conn->session->lock);
-	sprintf(conn->portal_address, "%pI4", &csk->daddr.sin_addr.s_addr);
-	conn->portal_port = ntohs(csk->daddr.sin_port);
-	spin_unlock_bh(&conn->session->lock);
-
 	log_debug(1 << CXGBI_DBG_ISCSI,
 		"cls 0x%p,0x%p, ep 0x%p, cconn 0x%p, csk 0x%p.\n",
 		cls_session, cls_conn, ep, cconn, csk);
diff --git a/drivers/scsi/cxgbi/libcxgbi.h b/drivers/scsi/cxgbi/libcxgbi.h
index 23cbc58..0a20fd5 100644
--- a/drivers/scsi/cxgbi/libcxgbi.h
+++ b/drivers/scsi/cxgbi/libcxgbi.h
@@ -712,7 +712,7 @@ void cxgbi_cleanup_task(struct iscsi_task *task);
 void cxgbi_get_conn_stats(struct iscsi_cls_conn *, struct iscsi_stats *);
 int cxgbi_set_conn_param(struct iscsi_cls_conn *,
 			enum iscsi_param, char *, int);
-int cxgbi_get_conn_param(struct iscsi_cls_conn *, enum iscsi_param, char *);
+int cxgbi_get_ep_param(struct iscsi_endpoint *ep, enum iscsi_param, char *);
 struct iscsi_cls_conn *cxgbi_create_conn(struct iscsi_cls_session *, u32);
 int cxgbi_bind_conn(struct iscsi_cls_session *,
 			struct iscsi_cls_conn *, u64, int);
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 4bef19f..0f43677 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -212,9 +212,6 @@ struct iscsi_conn {
 	/* values userspace uses to id a conn */
 	int			persistent_port;
 	char			*persistent_address;
-	/* remote portal currently connected to */
-	int			portal_port;
-	char			portal_address[ISCSI_ADDRESS_BUF_LEN];
 
 	/* MIB-statistics */
 	uint64_t		txdata_octets;
@@ -319,9 +316,6 @@ struct iscsi_host {
 	/* hw address or netdev iscsi connection is bound to */
 	char			*hwaddress;
 	char			*netdev;
-	/* local address */
-	int			local_port;
-	char			local_address[ISCSI_ADDRESS_BUF_LEN];
 
 	wait_queue_head_t	session_removal_wq;
 	/* protects sessions and state */
-- 
1.7.2.3

