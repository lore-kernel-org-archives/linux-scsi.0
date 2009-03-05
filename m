From: michaelc@cs.wisc.edu
Subject: [PATCH 12/14] iscsi class: remove host no argument from session creation callout
Date: Thu,  5 Mar 2009 14:46:06 -0600
Message-ID: <12362859782406-git-send-email-michaelc@cs.wisc.edu>
References: <12362859683749-git-send-email-michaelc@cs.wisc.edu>
 <12362859693831-git-send-email-michaelc@cs.wisc.edu>
 <12362859702687-git-send-email-michaelc@cs.wisc.edu>
 <123628597367-git-send-email-michaelc@cs.wisc.edu>
 <12362859734023-git-send-email-michaelc@cs.wisc.edu>
 <12362859743025-git-send-email-michaelc@cs.wisc.edu>
 <12362859742776-git-send-email-michaelc@cs.wisc.edu>
 <12362859754088-git-send-email-michaelc@cs.wisc.edu>
 <1236285975607-git-send-email-michaelc@cs.wisc.edu>
 <12362859763502-git-send-email-michaelc@cs.wisc.edu>
 <12362859771656-git-send-email-michaelc@cs.wisc.edu>
 <12362859771239-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:52837 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755098AbZCEUqX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Mar 2009 15:46:23 -0500
In-Reply-To: <12362859771239-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

We do not need to have llds set the host no for the session's
parent, because we know the session's parent is going to be
the host. This removes it from the session creation callback
and converts the drivers.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |    3 +--
 drivers/scsi/cxgb3i/cxgb3i_iscsi.c       |    5 +----
 drivers/scsi/iscsi_tcp.c                 |    4 +---
 drivers/scsi/scsi_transport_iscsi.c      |    7 ++++---
 include/scsi/scsi_transport_iscsi.h      |    2 +-
 5 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 6c61ed1..13d7674 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -397,7 +397,7 @@ static void iscsi_iser_session_destroy(struct iscsi_cls_session *cls_session)
 static struct iscsi_cls_session *
 iscsi_iser_session_create(struct iscsi_endpoint *ep,
 			  uint16_t cmds_max, uint16_t qdepth,
-			  uint32_t initial_cmdsn, uint32_t *hostno)
+			  uint32_t initial_cmdsn)
 {
 	struct iscsi_cls_session *cls_session;
 	struct iscsi_session *session;
@@ -423,7 +423,6 @@ iscsi_iser_session_create(struct iscsi_endpoint *ep,
 	if (iscsi_host_add(shost,
 			   ep ? ib_conn->device->ib_device->dma_device : NULL))
 		goto free_host;
-	*hostno = shost->host_no;
 
 	/*
 	 * we do not support setting can_queue cmd_per_lun from userspace yet
diff --git a/drivers/scsi/cxgb3i/cxgb3i_iscsi.c b/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
index 307f55e..ae4a930 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
@@ -334,13 +334,12 @@ static void cxgb3i_ep_disconnect(struct iscsi_endpoint *ep)
  * @cmds_max:		max # of commands
  * @qdepth:		scsi queue depth
  * @initial_cmdsn:	initial iscsi CMDSN for this session
- * @host_no:		pointer to return host no
  *
  * Creates a new iSCSI session
  */
 static struct iscsi_cls_session *
 cxgb3i_session_create(struct iscsi_endpoint *ep, u16 cmds_max, u16 qdepth,
-		      u32 initial_cmdsn, u32 *host_no)
+		      u32 initial_cmdsn)
 {
 	struct cxgb3i_endpoint *cep;
 	struct cxgb3i_hba *hba;
@@ -359,8 +358,6 @@ cxgb3i_session_create(struct iscsi_endpoint *ep, u16 cmds_max, u16 qdepth,
 	cxgb3i_api_debug("ep 0x%p, cep 0x%p, hba 0x%p.\n", ep, cep, hba);
 	BUG_ON(hba != iscsi_host_priv(shost));
 
-	*host_no = shost->host_no;
-
 	cls_session = iscsi_session_setup(&cxgb3i_iscsi_transport, shost,
 					  cmds_max,
 					  sizeof(struct iscsi_tcp_task) +
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index ad8676c..b3e5e08 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -765,8 +765,7 @@ iscsi_sw_tcp_conn_get_stats(struct iscsi_cls_conn *cls_conn,
 
 static struct iscsi_cls_session *
 iscsi_sw_tcp_session_create(struct iscsi_endpoint *ep, uint16_t cmds_max,
-			    uint16_t qdepth, uint32_t initial_cmdsn,
-			    uint32_t *hostno)
+			    uint16_t qdepth, uint32_t initial_cmdsn)
 {
 	struct iscsi_cls_session *cls_session;
 	struct iscsi_session *session;
@@ -789,7 +788,6 @@ iscsi_sw_tcp_session_create(struct iscsi_endpoint *ep, uint16_t cmds_max,
 
 	if (iscsi_host_add(shost, NULL))
 		goto free_host;
-	*hostno = shost->host_no;
 
 	cls_session = iscsi_session_setup(&iscsi_sw_tcp_transport, shost,
 					  cmds_max,
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 4f22f9e..2340e2c 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1197,14 +1197,15 @@ iscsi_if_create_session(struct iscsi_internal *priv, struct iscsi_endpoint *ep,
 {
 	struct iscsi_transport *transport = priv->iscsi_transport;
 	struct iscsi_cls_session *session;
-	uint32_t host_no;
+	struct Scsi_Host *shost;
 
 	session = transport->create_session(ep, cmds_max, queue_depth,
-					    initial_cmdsn, &host_no);
+					    initial_cmdsn);
 	if (!session)
 		return -ENOMEM;
 
-	ev->r.c_session_ret.host_no = host_no;
+	shost = iscsi_session_to_shost(session);
+	ev->r.c_session_ret.host_no = shost->host_no;
 	ev->r.c_session_ret.sid = session->sid;
 	return 0;
 }
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index ac29fbd..457588e 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -88,7 +88,7 @@ struct iscsi_transport {
 	uint64_t host_param_mask;
 	struct iscsi_cls_session *(*create_session) (struct iscsi_endpoint *ep,
 					uint16_t cmds_max, uint16_t qdepth,
-					uint32_t sn, uint32_t *hn);
+					uint32_t sn);
 	void (*destroy_session) (struct iscsi_cls_session *session);
 	struct iscsi_cls_conn *(*create_conn) (struct iscsi_cls_session *sess,
 				uint32_t cid);
-- 
1.6.0.6

