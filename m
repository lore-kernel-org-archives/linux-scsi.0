From: michaelc@cs.wisc.edu
Subject: [PATCH 15/17] bnx2i: fix null ptr ref in conn get param
Date: Wed, 16 Feb 2011 15:04:39 -0600
Message-ID: <1297890281-9076-16-git-send-email-michaelc@cs.wisc.edu>
References: <1297890281-9076-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46676 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754611Ab1BPVEl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Feb 2011 16:04:41 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1GL4fHO021111
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2011 16:04:41 -0500
Received: from meanminna.corp.redhat.com (vpn-11-254.rdu.redhat.com [10.11.11.254])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p1GL4Tt4004636
	for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2011 16:04:40 -0500
In-Reply-To: <1297890281-9076-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Mike Christie <michaelc@cs.wisc.edu>

bnx2i has some checks to try and make sure the ep
is not destroyed while the addr/port is getting
read. However, if after this check:

if (!(bnx2i_conn && bnx2i_conn->ep && bnx2i_conn->ep->hba))
	goto out;

bnx2i_conn->ep is cleared by ep_disconnect then we will
oops.

This patches fixes the problem by having the driver
use the get_ep_param callback instead of get_conn_param.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/bnx2i/bnx2i_iscsi.c |   45 ++++++++++++++++++-------------------
 1 files changed, 22 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 05bb808..1809f9c 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1458,42 +1458,40 @@ static void bnx2i_conn_destroy(struct iscsi_cls_conn *cls_conn)
 
 
 /**
- * bnx2i_conn_get_param - return iscsi connection parameter to caller
- * @cls_conn:	pointer to iscsi cls conn
+ * bnx2i_ep_get_param - return iscsi ep parameter to caller
+ * @ep:		pointer to iscsi endpoint
  * @param:	parameter type identifier
  * @buf: 	buffer pointer
  *
- * returns iSCSI connection parameters
+ * returns iSCSI ep parameters
  */
-static int bnx2i_conn_get_param(struct iscsi_cls_conn *cls_conn,
-				enum iscsi_param param, char *buf)
+static int bnx2i_ep_get_param(struct iscsi_endpoint *ep,
+			      enum iscsi_param param, char *buf)
 {
-	struct iscsi_conn *conn = cls_conn->dd_data;
-	struct bnx2i_conn *bnx2i_conn = conn->dd_data;
-	int len = 0;
+	struct bnx2i_endpoint *bnx2i_ep = ep->dd_data;
+	struct bnx2i_hba *hba = bnx2i_ep->hba;
+	int len = -ENOTCONN;
 
-	if (!(bnx2i_conn && bnx2i_conn->ep && bnx2i_conn->ep->hba))
-		goto out;
+	if (!hba)
+		return -ENOTCONN;
 
 	switch (param) {
 	case ISCSI_PARAM_CONN_PORT:
-		mutex_lock(&bnx2i_conn->ep->hba->net_dev_lock);
-		if (bnx2i_conn->ep->cm_sk)
-			len = sprintf(buf, "%hu\n",
-				      bnx2i_conn->ep->cm_sk->dst_port);
-		mutex_unlock(&bnx2i_conn->ep->hba->net_dev_lock);
+		mutex_lock(&hba->net_dev_lock);
+		if (bnx2i_ep->cm_sk)
+			len = sprintf(buf, "%hu\n", bnx2i_ep->cm_sk->dst_port);
+		mutex_unlock(&hba->net_dev_lock);
 		break;
 	case ISCSI_PARAM_CONN_ADDRESS:
-		mutex_lock(&bnx2i_conn->ep->hba->net_dev_lock);
-		if (bnx2i_conn->ep->cm_sk)
-			len = sprintf(buf, "%pI4\n",
-				      &bnx2i_conn->ep->cm_sk->dst_ip);
-		mutex_unlock(&bnx2i_conn->ep->hba->net_dev_lock);
+		mutex_lock(&hba->net_dev_lock);
+		if (bnx2i_ep->cm_sk)
+			len = sprintf(buf, "%pI4\n", &bnx2i_ep->cm_sk->dst_ip);
+		mutex_unlock(&hba->net_dev_lock);
 		break;
 	default:
-		return iscsi_conn_get_param(cls_conn, param, buf);
+		return -ENOSYS;
 	}
-out:
+
 	return len;
 }
 
@@ -2204,7 +2202,7 @@ struct iscsi_transport bnx2i_iscsi_transport = {
 	.bind_conn		= bnx2i_conn_bind,
 	.destroy_conn		= bnx2i_conn_destroy,
 	.set_param		= iscsi_set_param,
-	.get_conn_param		= bnx2i_conn_get_param,
+	.get_conn_param		= iscsi_conn_get_param,
 	.get_session_param	= iscsi_session_get_param,
 	.get_host_param		= bnx2i_host_get_param,
 	.start_conn		= bnx2i_conn_start,
@@ -2213,6 +2211,7 @@ struct iscsi_transport bnx2i_iscsi_transport = {
 	.xmit_task		= bnx2i_task_xmit,
 	.get_stats		= bnx2i_conn_get_stats,
 	/* TCP connect - disconnect - option-2 interface calls */
+	.get_ep_param		= bnx2i_ep_get_param,
 	.ep_connect		= bnx2i_ep_connect,
 	.ep_poll		= bnx2i_ep_poll,
 	.ep_disconnect		= bnx2i_ep_disconnect,
-- 
1.7.2.3

