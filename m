From: Robert LeBlanc <robert@leblancnet.us>
Subject: [PATCH] Pass iface for connection
Date: Tue,  6 Jun 2017 12:19:14 -0600
Message-ID: <20170606181914.6047-1-robert@leblancnet.us>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f53.google.com ([74.125.83.53]:36828 "EHLO
        mail-pg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751239AbdFFSTa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jun 2017 14:19:30 -0400
Received: by mail-pg0-f53.google.com with SMTP id a70so30173752pge.3
        for <linux-scsi@vger.kernel.org>; Tue, 06 Jun 2017 11:19:30 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com
Cc: linux-scsi@vger.kernel.org, Robert LeBlanc <robert@leblancnet.us>

---
 usr/netlink.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/usr/netlink.c b/usr/netlink.c
index 1a0bf80..c474375 100644
--- a/usr/netlink.c
+++ b/usr/netlink.c
@@ -848,10 +848,13 @@ krecv_pdu_end(struct iscsi_conn *conn)
 int
 ktransport_ep_connect(iscsi_conn_t *conn, int non_blocking)
 {
-	int rc, addrlen;
+	int rc, addrlen = sizeof(struct sockaddr_storage);
 	struct iscsi_uevent *ev;
-	struct sockaddr *dst_addr = (struct sockaddr *)&conn->saddr;
+	struct sockaddr_storage *dst_addr = (struct sockaddr_storage *)&conn->saddr;
 	struct iovec iov[2];
+	struct iscsi_session *tmp_session = (struct iscsi_session *)conn->session;
+	node_rec_t *tmp_rec = (node_rec_t *)&tmp_session->nrec;
+	iface_rec_t *tmp_iface = (iface_rec_t *)&tmp_rec->iface;
 
 	log_debug(7, "in %s", __FUNCTION__);
 
@@ -868,19 +871,16 @@ ktransport_ep_connect(iscsi_conn_t *conn, int non_blocking)
 		ev->u.ep_connect.non_blocking = non_blocking;
 	}
 
-	if (dst_addr->sa_family == PF_INET)
-		addrlen = sizeof(struct sockaddr_in);
-	else if (dst_addr->sa_family == PF_INET6)
-		addrlen = sizeof(struct sockaddr_in6);
-	else {
+	if (dst_addr->ss_family != AF_INET && dst_addr->ss_family != AF_INET6) {
 		log_error("%s unknown addr family %d",
-			 __FUNCTION__, dst_addr->sa_family);
+			 __FUNCTION__, dst_addr->ss_family);
 		return -EINVAL;
 	}
 	memcpy(setparam_buf + sizeof(*ev), dst_addr, addrlen);
+	iface_copy(setparam_buf + sizeof(*ev) + addrlen, tmp_iface);
 
 	iov[1].iov_base = ev;
-	iov[1].iov_len = sizeof(*ev) + addrlen;
+	iov[1].iov_len = sizeof(*ev) + addrlen + sizeof(iface_rec_t);
 	rc = __kipc_call(iov, 2);
 	if (rc < 0)
 		return rc;
-- 
2.11.0
