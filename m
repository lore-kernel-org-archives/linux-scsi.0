From: michaelc@cs.wisc.edu
Subject: [PATCH 2/2] iscsi_tcp: export port being used
Date: Mon, 29 Sep 2014 13:55:42 -0500
Message-ID: <1412016942-4759-3-git-send-email-michaelc@cs.wisc.edu>
References: <1412016942-4759-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:42698 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753898AbaI2S4s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Sep 2014 14:56:48 -0400
Received: from localhost.localdomain (c-24-245-27-162.hsd1.mn.comcast.net [24.245.27.162])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.14.1/8.14.1) with ESMTP id s8TItn1e028576
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 29 Sep 2014 13:56:47 -0500
In-Reply-To: <1412016942-4759-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Mike Christie <michaelc@cs.wisc.edu>

This just has iscsi_tcp support ISCSI_PARAM_LOCAL_PORT which
exports the local port being used by the iscsi connection.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/iscsi_tcp.c |   10 ++++++++--
 drivers/scsi/libiscsi.c  |    1 +
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index a669f2d..427af0f 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -726,13 +726,18 @@ static int iscsi_sw_tcp_conn_get_param(struct iscsi_cls_conn *cls_conn,
 	switch(param) {
 	case ISCSI_PARAM_CONN_PORT:
 	case ISCSI_PARAM_CONN_ADDRESS:
+	case ISCSI_PARAM_LOCAL_PORT:
 		spin_lock_bh(&conn->session->frwd_lock);
 		if (!tcp_sw_conn || !tcp_sw_conn->sock) {
 			spin_unlock_bh(&conn->session->frwd_lock);
 			return -ENOTCONN;
 		}
-		rc = kernel_getpeername(tcp_sw_conn->sock,
-					(struct sockaddr *)&addr, &len);
+		if (param == ISCSI_PARAM_LOCAL_PORT)
+			rc = kernel_getsockname(tcp_sw_conn->sock,
+						(struct sockaddr *)&addr, &len);
+		else
+			rc = kernel_getpeername(tcp_sw_conn->sock,
+						(struct sockaddr *)&addr, &len);
 		spin_unlock_bh(&conn->session->frwd_lock);
 		if (rc)
 			return rc;
@@ -895,6 +900,7 @@ static umode_t iscsi_sw_tcp_attr_is_visible(int param_type, int param)
 		case ISCSI_PARAM_DATADGST_EN:
 		case ISCSI_PARAM_CONN_ADDRESS:
 		case ISCSI_PARAM_CONN_PORT:
+		case ISCSI_PARAM_LOCAL_PORT:
 		case ISCSI_PARAM_EXP_STATSN:
 		case ISCSI_PARAM_PERSISTENT_ADDRESS:
 		case ISCSI_PARAM_PERSISTENT_PORT:
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 191b597..0d8bc6c 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -3505,6 +3505,7 @@ int iscsi_conn_get_addr_param(struct sockaddr_storage *addr,
 			len = sprintf(buf, "%pI6\n", &sin6->sin6_addr);
 		break;
 	case ISCSI_PARAM_CONN_PORT:
+	case ISCSI_PARAM_LOCAL_PORT:
 		if (sin)
 			len = sprintf(buf, "%hu\n", be16_to_cpu(sin->sin_port));
 		else
-- 
1.7.1

