From: michaelc@cs.wisc.edu
Subject: [PATCH 03/13] libiscsi: handle param allocation failures
Date: Wed, 13 May 2009 17:57:40 -0500
Message-ID: <1242255472240-git-send-email-michaelc@cs.wisc.edu>
References: <12422554702856-git-send-email-michaelc@cs.wisc.edu>
 <12422554711659-git-send-email-michaelc@cs.wisc.edu>
 <12422554711865-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:51807 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761963AbZEMW5x (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 May 2009 18:57:53 -0400
In-Reply-To: <12422554711865-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

If we could not allocate the initiator name or some other id like
the hwaddress or netdev, then userspace could deal with the failure
by just running in a dregraded mode.

Now we want to be able to switch values for the params and we
want some feedback, so this patch will check if a string like
the initiatorname could not be allocated and return an error.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |  108 ++++++++++++++--------------------------------
 1 files changed, 33 insertions(+), 75 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 11bc3e1..b4aaf2e 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2656,6 +2656,23 @@ int iscsi_conn_bind(struct iscsi_cls_session *cls_session,
 }
 EXPORT_SYMBOL_GPL(iscsi_conn_bind);
 
+static int iscsi_switch_str_param(char **param, char *new_val_buf)
+{
+	char *new_val;
+
+	if (*param) {
+		if (!strcmp(*param, new_val_buf))
+			return 0;
+	}
+
+	new_val = kstrdup(new_val_buf, GFP_NOIO);
+	if (!new_val)
+		return -ENOMEM;
+
+	kfree(*param);
+	*param = new_val;
+	return 0;
+}
 
 int iscsi_set_param(struct iscsi_cls_conn *cls_conn,
 		    enum iscsi_param param, char *buf, int buflen)
@@ -2728,38 +2745,15 @@ int iscsi_set_param(struct iscsi_cls_conn *cls_conn,
 		sscanf(buf, "%u", &conn->exp_statsn);
 		break;
 	case ISCSI_PARAM_USERNAME:
-		kfree(session->username);
-		session->username = kstrdup(buf, GFP_KERNEL);
-		if (!session->username)
-			return -ENOMEM;
-		break;
+		return iscsi_switch_str_param(&session->username, buf);
 	case ISCSI_PARAM_USERNAME_IN:
-		kfree(session->username_in);
-		session->username_in = kstrdup(buf, GFP_KERNEL);
-		if (!session->username_in)
-			return -ENOMEM;
-		break;
+		return iscsi_switch_str_param(&session->username_in, buf);
 	case ISCSI_PARAM_PASSWORD:
-		kfree(session->password);
-		session->password = kstrdup(buf, GFP_KERNEL);
-		if (!session->password)
-			return -ENOMEM;
-		break;
+		return iscsi_switch_str_param(&session->password, buf);
 	case ISCSI_PARAM_PASSWORD_IN:
-		kfree(session->password_in);
-		session->password_in = kstrdup(buf, GFP_KERNEL);
-		if (!session->password_in)
-			return -ENOMEM;
-		break;
+		return iscsi_switch_str_param(&session->password_in, buf);
 	case ISCSI_PARAM_TARGET_NAME:
-		/* this should not change between logins */
-		if (session->targetname)
-			break;
-
-		session->targetname = kstrdup(buf, GFP_KERNEL);
-		if (!session->targetname)
-			return -ENOMEM;
-		break;
+		return iscsi_switch_str_param(&session->targetname, buf);
 	case ISCSI_PARAM_TPGT:
 		sscanf(buf, "%d", &session->tpgt);
 		break;
@@ -2767,25 +2761,11 @@ int iscsi_set_param(struct iscsi_cls_conn *cls_conn,
 		sscanf(buf, "%d", &conn->persistent_port);
 		break;
 	case ISCSI_PARAM_PERSISTENT_ADDRESS:
-		/*
-		 * this is the address returned in discovery so it should
-		 * not change between logins.
-		 */
-		if (conn->persistent_address)
-			break;
-
-		conn->persistent_address = kstrdup(buf, GFP_KERNEL);
-		if (!conn->persistent_address)
-			return -ENOMEM;
-		break;
+		return iscsi_switch_str_param(&conn->persistent_address, buf);
 	case ISCSI_PARAM_IFACE_NAME:
-		if (!session->ifacename)
-			session->ifacename = kstrdup(buf, GFP_KERNEL);
-		break;
+		return iscsi_switch_str_param(&session->ifacename, buf);
 	case ISCSI_PARAM_INITIATOR_NAME:
-		if (!session->initiatorname)
-			session->initiatorname = kstrdup(buf, GFP_KERNEL);
-		break;
+		return iscsi_switch_str_param(&session->initiatorname, buf);
 	default:
 		return -ENOSYS;
 	}
@@ -2856,10 +2836,7 @@ int iscsi_session_get_param(struct iscsi_cls_session *cls_session,
 		len = sprintf(buf, "%s\n", session->ifacename);
 		break;
 	case ISCSI_PARAM_INITIATOR_NAME:
-		if (!session->initiatorname)
-			len = sprintf(buf, "%s\n", "unknown");
-		else
-			len = sprintf(buf, "%s\n", session->initiatorname);
+		len = sprintf(buf, "%s\n", session->initiatorname);
 		break;
 	default:
 		return -ENOSYS;
@@ -2925,29 +2902,16 @@ int iscsi_host_get_param(struct Scsi_Host *shost, enum iscsi_host_param param,
 
 	switch (param) {
 	case ISCSI_HOST_PARAM_NETDEV_NAME:
-		if (!ihost->netdev)
-			len = sprintf(buf, "%s\n", "default");
-		else
-			len = sprintf(buf, "%s\n", ihost->netdev);
+		len = sprintf(buf, "%s\n", ihost->netdev);
 		break;
 	case ISCSI_HOST_PARAM_HWADDRESS:
-		if (!ihost->hwaddress)
-			len = sprintf(buf, "%s\n", "default");
-		else
-			len = sprintf(buf, "%s\n", ihost->hwaddress);
+		len = sprintf(buf, "%s\n", ihost->hwaddress);
 		break;
 	case ISCSI_HOST_PARAM_INITIATOR_NAME:
-		if (!ihost->initiatorname)
-			len = sprintf(buf, "%s\n", "unknown");
-		else
-			len = sprintf(buf, "%s\n", ihost->initiatorname);
+		len = sprintf(buf, "%s\n", ihost->initiatorname);
 		break;
 	case ISCSI_HOST_PARAM_IPADDRESS:
-		if (!strlen(ihost->local_address))
-			len = sprintf(buf, "%s\n", "unknown");
-		else
-			len = sprintf(buf, "%s\n",
-				      ihost->local_address);
+		len = sprintf(buf, "%s\n", ihost->local_address);
 		break;
 	default:
 		return -ENOSYS;
@@ -2964,17 +2928,11 @@ int iscsi_host_set_param(struct Scsi_Host *shost, enum iscsi_host_param param,
 
 	switch (param) {
 	case ISCSI_HOST_PARAM_NETDEV_NAME:
-		if (!ihost->netdev)
-			ihost->netdev = kstrdup(buf, GFP_KERNEL);
-		break;
+		return iscsi_switch_str_param(&ihost->netdev, buf);
 	case ISCSI_HOST_PARAM_HWADDRESS:
-		if (!ihost->hwaddress)
-			ihost->hwaddress = kstrdup(buf, GFP_KERNEL);
-		break;
+		return iscsi_switch_str_param(&ihost->hwaddress, buf);
 	case ISCSI_HOST_PARAM_INITIATOR_NAME:
-		if (!ihost->initiatorname)
-			ihost->initiatorname = kstrdup(buf, GFP_KERNEL);
-		break;
+		return iscsi_switch_str_param(&ihost->initiatorname, buf);
 	default:
 		return -ENOSYS;
 	}
-- 
1.5.2.1

