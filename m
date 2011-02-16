From: michaelc@cs.wisc.edu
Subject: [PATCH 16/17] iser: export addr and port
Date: Wed, 16 Feb 2011 15:04:40 -0600
Message-ID: <1297890281-9076-17-git-send-email-michaelc@cs.wisc.edu>
References: <1297890281-9076-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63322 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754670Ab1BPVEm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Feb 2011 16:04:42 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1GL4fDH021115
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2011 16:04:41 -0500
Received: from meanminna.corp.redhat.com (vpn-11-254.rdu.redhat.com [10.11.11.254])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p1GL4Tt5004636
	for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2011 16:04:41 -0500
In-Reply-To: <1297890281-9076-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Mike Christie <michaelc@cs.wisc.edu>

This pactch has iser export the address and port
of the endpoint.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 7b2fc98..8db008d 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -532,6 +532,29 @@ iscsi_iser_conn_get_stats(struct iscsi_cls_conn *cls_conn, struct iscsi_stats *s
 	stats->custom[3].value = conn->fmr_unalign_cnt;
 }
 
+static int iscsi_iser_get_ep_param(struct iscsi_endpoint *ep,
+				   enum iscsi_param param, char *buf)
+{
+	struct iser_conn *ib_conn = ep->dd_data;
+	int len;
+
+	switch (param) {
+	case ISCSI_PARAM_CONN_PORT:
+	case ISCSI_PARAM_CONN_ADDRESS:
+		if (!ib_conn || !ib_conn->cma_id)
+			return -ENOTCONN;
+
+		return iscsi_conn_get_addr_param((struct sockaddr_storage *)
+					&ib_conn->cma_id->route.addr.dst_addr,
+					param, buf);
+		break;
+	default:
+		return -ENOSYS;
+	}
+
+	return len;
+}
+
 static struct iscsi_endpoint *
 iscsi_iser_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
 		      int non_blocking)
@@ -637,6 +660,8 @@ static struct iscsi_transport iscsi_iser_transport = {
 				  ISCSI_MAX_BURST |
 				  ISCSI_PDU_INORDER_EN |
 				  ISCSI_DATASEQ_INORDER_EN |
+				  ISCSI_CONN_PORT |
+				  ISCSI_CONN_ADDRESS |
 				  ISCSI_EXP_STATSN |
 				  ISCSI_PERSISTENT_PORT |
 				  ISCSI_PERSISTENT_ADDRESS |
@@ -659,6 +684,7 @@ static struct iscsi_transport iscsi_iser_transport = {
 	.destroy_conn           = iscsi_iser_conn_destroy,
 	.set_param              = iscsi_iser_set_param,
 	.get_conn_param		= iscsi_conn_get_param,
+	.get_ep_param		= iscsi_iser_get_ep_param,
 	.get_session_param	= iscsi_session_get_param,
 	.start_conn             = iscsi_iser_conn_start,
 	.stop_conn              = iscsi_iser_conn_stop,
-- 
1.7.2.3

