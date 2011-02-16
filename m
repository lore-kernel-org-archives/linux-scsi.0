From: michaelc@cs.wisc.edu
Subject: [PATCH 11/17] libiscsi: add helper to convert addr to string
Date: Wed, 16 Feb 2011 15:04:35 -0600
Message-ID: <1297890281-9076-12-git-send-email-michaelc@cs.wisc.edu>
References: <1297890281-9076-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17013 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754635Ab1BPVEi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Feb 2011 16:04:38 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1GL4cn0021103
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2011 16:04:38 -0500
Received: from meanminna.corp.redhat.com (vpn-11-254.rdu.redhat.com [10.11.11.254])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p1GL4Tt0004636
	for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2011 16:04:37 -0500
In-Reply-To: <1297890281-9076-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Mike Christie <michaelc@cs.wisc.edu>

This adds a helper to convert a addr struct to
a string. This will be used by the drivers in
the next patches.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |   44 +++++++++++++++++++++++++++++++++++++++++---
 include/scsi/libiscsi.h |    2 ++
 2 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index da8b615..0c550d5 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -3352,6 +3352,47 @@ int iscsi_session_get_param(struct iscsi_cls_session *cls_session,
 }
 EXPORT_SYMBOL_GPL(iscsi_session_get_param);
 
+int iscsi_conn_get_addr_param(struct sockaddr_storage *addr,
+			      enum iscsi_param param, char *buf)
+{
+	struct sockaddr_in6 *sin6 = NULL;
+	struct sockaddr_in *sin = NULL;
+	int len;
+
+	switch (addr->ss_family) {
+	case AF_INET:
+		sin = (struct sockaddr_in *)addr;
+		break;
+	case AF_INET6:
+		sin6 = (struct sockaddr_in6 *)addr;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	switch (param) {
+	case ISCSI_PARAM_CONN_ADDRESS:
+	case ISCSI_HOST_PARAM_IPADDRESS:
+		if (sin)
+			len = sprintf(buf, "%pI4\n", &sin->sin_addr.s_addr);
+		else
+			len = sprintf(buf, "%pI6\n", &sin6->sin6_addr);
+		break;
+	case ISCSI_PARAM_CONN_PORT:
+		if (sin)
+			len = sprintf(buf, "%hu\n", be16_to_cpu(sin->sin_port));
+		else
+			len = sprintf(buf, "%hu\n",
+				      be16_to_cpu(sin6->sin6_port));
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return len;
+}
+EXPORT_SYMBOL_GPL(iscsi_conn_get_addr_param);
+
 int iscsi_conn_get_param(struct iscsi_cls_conn *cls_conn,
 			 enum iscsi_param param, char *buf)
 {
@@ -3416,9 +3457,6 @@ int iscsi_host_get_param(struct Scsi_Host *shost, enum iscsi_host_param param,
 	case ISCSI_HOST_PARAM_INITIATOR_NAME:
 		len = sprintf(buf, "%s\n", ihost->initiatorname);
 		break;
-	case ISCSI_HOST_PARAM_IPADDRESS:
-		len = sprintf(buf, "%s\n", ihost->local_address);
-		break;
 	default:
 		return -ENOSYS;
 	}
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 748382b..4bef19f 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -394,6 +394,8 @@ extern void iscsi_session_failure(struct iscsi_session *session,
 				  enum iscsi_err err);
 extern int iscsi_conn_get_param(struct iscsi_cls_conn *cls_conn,
 				enum iscsi_param param, char *buf);
+extern int iscsi_conn_get_addr_param(struct sockaddr_storage *addr,
+				     enum iscsi_param param, char *buf);
 extern void iscsi_suspend_tx(struct iscsi_conn *conn);
 extern void iscsi_suspend_queue(struct iscsi_conn *conn);
 extern void iscsi_conn_queue_work(struct iscsi_conn *conn);
-- 
1.7.2.3

