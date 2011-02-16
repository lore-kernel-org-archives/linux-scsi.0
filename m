From: michaelc@cs.wisc.edu
Subject: [PATCH 13/17] iscsi class: add callout to get iscsi_endpoint values
Date: Wed, 16 Feb 2011 15:04:37 -0600
Message-ID: <1297890281-9076-14-git-send-email-michaelc@cs.wisc.edu>
References: <1297890281-9076-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15617 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754639Ab1BPVEj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Feb 2011 16:04:39 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1GL4d2n009095
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2011 16:04:39 -0500
Received: from meanminna.corp.redhat.com (vpn-11-254.rdu.redhat.com [10.11.11.254])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p1GL4Tt2004636
	for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2011 16:04:39 -0500
In-Reply-To: <1297890281-9076-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Mike Christie <michaelc@cs.wisc.edu>

For drivers using the ep callbacks the addr and port
are attached to the endpoint instead of the conn.
This adds a callout to the iscsi_transport to get
ep values. It also adds locking around the get
param call to make sure that ep_disconnect does
not free the LLD's ep interconnect structs from
under us (the ep has a refcount so it will not
go away but the LLD may have structs from other
subsystems that are not allocated in the ep so
we need to protect them from getting freed).

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_transport_iscsi.c |   39 +++++++++++++++++++++++++++++++++-
 include/scsi/scsi_transport_iscsi.h |    2 +
 2 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index a631e58..b421839 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1782,13 +1782,48 @@ iscsi_conn_attr(data_digest, ISCSI_PARAM_DATADGST_EN);
 iscsi_conn_attr(ifmarker, ISCSI_PARAM_IFMARKER_EN);
 iscsi_conn_attr(ofmarker, ISCSI_PARAM_OFMARKER_EN);
 iscsi_conn_attr(persistent_port, ISCSI_PARAM_PERSISTENT_PORT);
-iscsi_conn_attr(port, ISCSI_PARAM_CONN_PORT);
 iscsi_conn_attr(exp_statsn, ISCSI_PARAM_EXP_STATSN);
 iscsi_conn_attr(persistent_address, ISCSI_PARAM_PERSISTENT_ADDRESS);
-iscsi_conn_attr(address, ISCSI_PARAM_CONN_ADDRESS);
 iscsi_conn_attr(ping_tmo, ISCSI_PARAM_PING_TMO);
 iscsi_conn_attr(recv_tmo, ISCSI_PARAM_RECV_TMO);
 
+#define iscsi_conn_ep_attr_show(param)					\
+static ssize_t show_conn_ep_param_##param(struct device *dev,		\
+					  struct device_attribute *attr,\
+					  char *buf)			\
+{									\
+	struct iscsi_cls_conn *conn = iscsi_dev_to_conn(dev->parent);	\
+	struct iscsi_transport *t = conn->transport;			\
+	struct iscsi_endpoint *ep;					\
+	ssize_t rc;							\
+									\
+	/*								\
+	 * Need to make sure ep_disconnect does not free the LLD's	\
+	 * interconnect resources while we are trying to read them.	\
+	 */								\
+	mutex_lock(&conn->ep_mutex);					\
+	ep = conn->ep;							\
+	if (!ep && t->ep_connect) {					\
+		mutex_unlock(&conn->ep_mutex);				\
+		return -ENOTCONN;					\
+	}								\
+									\
+	if (ep)								\
+		rc = t->get_ep_param(ep, param, buf);			\
+	else								\
+		rc = t->get_conn_param(conn, param, buf);		\
+	mutex_unlock(&conn->ep_mutex);					\
+	return rc;							\
+}
+
+#define iscsi_conn_ep_attr(field, param)				\
+	iscsi_conn_ep_attr_show(param)					\
+static ISCSI_CLASS_ATTR(conn, field, S_IRUGO,				\
+			show_conn_ep_param_##param, NULL);
+
+iscsi_conn_ep_attr(address, ISCSI_PARAM_CONN_ADDRESS);
+iscsi_conn_ep_attr(port, ISCSI_PARAM_CONN_PORT);
+
 /*
  * iSCSI session attrs
  */
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 00e5bf7..bf8f529 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -101,6 +101,8 @@ struct iscsi_transport {
 	void (*destroy_conn) (struct iscsi_cls_conn *conn);
 	int (*set_param) (struct iscsi_cls_conn *conn, enum iscsi_param param,
 			  char *buf, int buflen);
+	int (*get_ep_param) (struct iscsi_endpoint *ep, enum iscsi_param param,
+			     char *buf);
 	int (*get_conn_param) (struct iscsi_cls_conn *conn,
 			       enum iscsi_param param, char *buf);
 	int (*get_session_param) (struct iscsi_cls_session *session,
-- 
1.7.2.3

