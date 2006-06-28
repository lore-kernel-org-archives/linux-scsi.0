From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 7/9] iscsi: break up session creation into two stages
Date: Wed, 28 Jun 2006 12:00:30 -0500
Message-ID: <1151514030.11553.53.camel@madmax>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:31411 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1751426AbWF1RE2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jun 2006 13:04:28 -0400
Received: from [192.168.0.7] (c-69-180-139-167.hsd1.mn.comcast.net [69.180.139.167])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.6/8.13.6) with ESMTP id k5SH471b019955
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 28 Jun 2006 12:04:27 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

qla4xxx is initialized in two steps like other HW drivers.
It allocates the host, sets up the HW, then adds the host.
For iscsi part of HW setup is setting up persistent iscsi
sessions. At that time, the interupts are off and the driver
is not completely set up so we just want to allocate them.
We do not want to add them to sysfs and expose them to userspace
because userspace could try to do lots of fun things with them
like scanning and at that time the driver is not ready.

So this patch breakes up the session creation like other
functions that use the driver model in two the alloc
and add parts. When the driver is ready, it can then add
the sessions and userspace can begin using them.

This also fixes a bug in the addition error patch where
we forgot to do a get on the session.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index bebeb7d..f39da0c 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -287,20 +287,11 @@ void iscsi_block_session(struct iscsi_cl
 }
 EXPORT_SYMBOL_GPL(iscsi_block_session);
 
-/**
- * iscsi_create_session - create iscsi class session
- * @shost: scsi host
- * @transport: iscsi transport
- *
- * This can be called from a LLD or iscsi_transport.
- **/
 struct iscsi_cls_session *
-iscsi_create_session(struct Scsi_Host *shost,
-		     struct iscsi_transport *transport)
+iscsi_alloc_session(struct Scsi_Host *shost,
+		    struct iscsi_transport *transport)
 {
-	struct iscsi_host *ihost;
 	struct iscsi_cls_session *session;
-	int err;
 
 	session = kzalloc(sizeof(*session) + transport->sessiondata_size,
 			  GFP_KERNEL);
@@ -313,8 +304,20 @@ iscsi_create_session(struct Scsi_Host *s
 	INIT_LIST_HEAD(&session->host_list);
 	INIT_LIST_HEAD(&session->sess_list);
 
+	session->dev.parent = &shost->shost_gendev;
+	session->dev.release = iscsi_session_release;
+	device_initialize(&session->dev);
 	if (transport->sessiondata_size)
 		session->dd_data = &session[1];
+	return session;
+}
+EXPORT_SYMBOL_GPL(iscsi_alloc_session);
+
+int iscsi_add_session(struct iscsi_cls_session *session)
+{
+	struct Scsi_Host *shost = iscsi_session_to_shost(session);
+	struct iscsi_host *ihost;
+	int err;
 
 	/* this is released in the dev's release function */
 	scsi_host_get(shost);
@@ -325,37 +328,51 @@ iscsi_create_session(struct Scsi_Host *s
 
 	snprintf(session->dev.bus_id, BUS_ID_SIZE, "session%u",
 		 session->sid);
-	session->dev.parent = &shost->shost_gendev;
-	session->dev.release = iscsi_session_release;
-	err = device_register(&session->dev);
+	err = device_add(&session->dev);
 	if (err) {
 		dev_printk(KERN_ERR, &session->dev, "iscsi: could not "
 			   "register session's dev\n");
-		goto free_session;
+		goto release_host;
 	}
 	transport_register_device(&session->dev);
 
 	mutex_lock(&ihost->mutex);
 	list_add(&session->host_list, &ihost->sessions);
 	mutex_unlock(&ihost->mutex);
+	return 0;
 
-	return session;
-
-free_session:
-	kfree(session);
-	return NULL;
+release_host:
+	scsi_host_put(shost);
+	return err;
 }
-
-EXPORT_SYMBOL_GPL(iscsi_create_session);
+EXPORT_SYMBOL_GPL(iscsi_add_session);
 
 /**
- * iscsi_destroy_session - destroy iscsi session
- * @session: iscsi_session
+ * iscsi_create_session - create iscsi class session
+ * @shost: scsi host
+ * @transport: iscsi transport
  *
- * Can be called by a LLD or iscsi_transport. There must not be
- * any running connections.
+ * This can be called from a LLD or iscsi_transport.
  **/
-int iscsi_destroy_session(struct iscsi_cls_session *session)
+struct iscsi_cls_session *
+iscsi_create_session(struct Scsi_Host *shost,
+		     struct iscsi_transport *transport)
+{
+	struct iscsi_cls_session *session;
+
+	session = iscsi_alloc_session(shost, transport);
+	if (!session)
+		return NULL;
+
+	if (iscsi_add_session(session)) {
+		iscsi_free_session(session);
+		return NULL;
+	}
+	return session;
+}
+EXPORT_SYMBOL_GPL(iscsi_create_session);
+
+void iscsi_remove_session(struct iscsi_cls_session *session)
 {
 	struct Scsi_Host *shost = iscsi_session_to_shost(session);
 	struct iscsi_host *ihost = shost->shost_data;
@@ -367,11 +384,33 @@ int iscsi_destroy_session(struct iscsi_c
 	list_del(&session->host_list);
 	mutex_unlock(&ihost->mutex);
 
+	scsi_remove_target(&session->dev);
+
 	transport_unregister_device(&session->dev);
-	device_unregister(&session->dev);
-	return 0;
+	device_del(&session->dev);
 }
+EXPORT_SYMBOL_GPL(iscsi_remove_session);
 
+void iscsi_free_session(struct iscsi_cls_session *session)
+{
+	put_device(&session->dev);
+}
+
+EXPORT_SYMBOL_GPL(iscsi_free_session);
+
+/**
+ * iscsi_destroy_session - destroy iscsi session
+ * @session: iscsi_session
+ *
+ * Can be called by a LLD or iscsi_transport. There must not be
+ * any running connections.
+ **/
+int iscsi_destroy_session(struct iscsi_cls_session *session)
+{
+	iscsi_remove_session(session);
+	iscsi_free_session(session);
+	return 0;
+}
 EXPORT_SYMBOL_GPL(iscsi_destroy_session);
 
 static void iscsi_conn_release(struct device *dev)
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 2e3cb37..53493d5 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -199,6 +199,9 @@ #define iscsi_dev_to_session(_dev) \
 #define iscsi_session_to_shost(_session) \
 	dev_to_shost(_session->dev.parent)
 
+#define starget_to_session(_stgt) \
+	iscsi_dev_to_session(_stgt->dev.parent)
+
 struct iscsi_host {
 	int next_target_id;
 	struct list_head sessions;
@@ -208,8 +211,13 @@ struct iscsi_host {
 /*
  * session and connection functions that can be used by HW iSCSI LLDs
  */
+extern struct iscsi_cls_session *iscsi_alloc_session(struct Scsi_Host *shost,
+					struct iscsi_transport *transport);
+extern int iscsi_add_session(struct iscsi_cls_session *session);
 extern struct iscsi_cls_session *iscsi_create_session(struct Scsi_Host *shost,
 						struct iscsi_transport *t);
+extern void iscsi_remove_session(struct iscsi_cls_session *session);
+extern void iscsi_free_session(struct iscsi_cls_session *session);
 extern int iscsi_destroy_session(struct iscsi_cls_session *session);
 extern struct iscsi_cls_conn *iscsi_create_conn(struct iscsi_cls_session *sess,
 					    uint32_t cid);


