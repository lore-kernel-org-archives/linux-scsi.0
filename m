From: michaelc@cs.wisc.edu
Subject: [PATCH 05/25] iscsi: add iscsi host helpers
Date: Wed, 21 May 2008 15:54:00 -0500
Message-ID: <1211403260-5487-6-git-send-email-michaelc@cs.wisc.edu>
References: <1211403260-5487-1-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-2-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-3-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-4-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-5-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45185 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936209AbYEUUy1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 May 2008 16:54:27 -0400
In-Reply-To: <1211403260-5487-5-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This finishes the host/session unbinding, by adding some helpers
to add and remove hosts and the session they manage.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |   17 +++-----
 drivers/scsi/iscsi_tcp.c                 |   18 +++-----
 drivers/scsi/libiscsi.c                  |   60 ++++++++++++++++++++++++++---
 drivers/scsi/scsi_transport_iscsi.c      |   20 ++++++++++
 include/scsi/libiscsi.h                  |   11 ++++-
 include/scsi/scsi_transport_iscsi.h      |    4 ++
 6 files changed, 99 insertions(+), 31 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 5a75004..62e35e5 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -371,10 +371,8 @@ static void iscsi_iser_session_destroy(struct iscsi_cls_session *cls_session)
 {
 	struct Scsi_Host *shost = iscsi_session_to_shost(cls_session);
 
-	iscsi_session_teardown(cls_session);
-	scsi_remove_host(shost);
-	iscsi_host_teardown(shost);
-	scsi_host_put(shost);
+	iscsi_host_remove(shost);
+	iscsi_host_free(shost);
 }
 
 static struct iscsi_cls_session *
@@ -396,7 +394,7 @@ iscsi_iser_session_create(struct Scsi_Host *shost,
 		return NULL;
 	}
 
-	shost = scsi_host_alloc(&iscsi_iser_sht, 0);
+	shost = iscsi_host_alloc(&iscsi_iser_sht, 0, ISCSI_MAX_CMD_PER_LUN);
 	if (!shost)
 		return NULL;
 	shost->transportt = iscsi_iser_scsi_transport;
@@ -405,9 +403,7 @@ iscsi_iser_session_create(struct Scsi_Host *shost,
 	shost->max_channel = 0;
 	shost->max_cmd_len = 16;
 
-	iscsi_host_setup(shost, qdepth);
-
-	if (scsi_add_host(shost, NULL))
+	if (iscsi_host_add(shost, NULL))
 		goto free_host;
 	*hostno = shost->host_no;
 
@@ -443,10 +439,9 @@ iscsi_iser_session_create(struct Scsi_Host *shost,
 	return cls_session;
 
 remove_host:
-	scsi_remove_host(shost);
+	iscsi_host_remove(shost);
 free_host:
-	iscsi_host_teardown(shost);
-	scsi_host_put(shost);
+	iscsi_host_free(shost);
 	return NULL;
 }
 
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 8cdcaf3..e19d92f 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -1866,7 +1866,7 @@ iscsi_tcp_session_create(struct Scsi_Host *shost, uint16_t cmds_max,
 		return NULL;
 	}
 
-	shost = scsi_host_alloc(&iscsi_sht, sizeof(struct iscsi_host));
+	shost = iscsi_host_alloc(&iscsi_sht, 0, qdepth);
 	if (!shost)
 		return NULL;
 	shost->transportt = iscsi_tcp_scsi_transport;
@@ -1874,10 +1874,9 @@ iscsi_tcp_session_create(struct Scsi_Host *shost, uint16_t cmds_max,
 	shost->max_id = 0;
 	shost->max_channel = 0;
 	shost->max_cmd_len = 16;
+	shost->can_queue = cmds_max;
 
-	iscsi_host_setup(shost, qdepth);
-
-	if (scsi_add_host(shost, NULL))
+	if (iscsi_host_add(shost, NULL))
 		goto free_host;
 	*hostno = shost->host_no;
 
@@ -1912,10 +1911,9 @@ iscsi_tcp_session_create(struct Scsi_Host *shost, uint16_t cmds_max,
 remove_session:
 	iscsi_session_teardown(cls_session);
 remove_host:
-	scsi_remove_host(shost);
+	iscsi_host_remove(shost);
 free_host:
-	iscsi_host_teardown(shost);
-	scsi_host_put(shost);
+	iscsi_host_free(shost);
 	return NULL;
 }
 
@@ -1924,11 +1922,9 @@ static void iscsi_tcp_session_destroy(struct iscsi_cls_session *cls_session)
 	struct Scsi_Host *shost = iscsi_session_to_shost(cls_session);
 
 	iscsi_r2tpool_free(cls_session->dd_data);
-	iscsi_session_teardown(cls_session);
 
-	scsi_remove_host(shost);
-	iscsi_host_teardown(shost);
-	scsi_host_put(shost);
+	iscsi_host_remove(shost);
+	iscsi_host_free(shost);
 }
 
 static int iscsi_tcp_slave_configure(struct scsi_device *sdev)
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 64b1dd8..73c37c0 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1764,8 +1764,39 @@ void iscsi_pool_free(struct iscsi_pool *q)
 }
 EXPORT_SYMBOL_GPL(iscsi_pool_free);
 
-void iscsi_host_setup(struct Scsi_Host *shost, uint16_t qdepth)
+/**
+ * iscsi_host_add - add host to system
+ * @shost: scsi host
+ * @pdev: parent device
+ *
+ * This should be called by partial offload and software iscsi drivers
+ * to add a host to the system.
+ */
+int iscsi_host_add(struct Scsi_Host *shost, struct device *pdev)
+{
+	return scsi_add_host(shost, pdev);
+}
+EXPORT_SYMBOL_GPL(iscsi_host_add);
+
+/**
+ * iscsi_host_alloc - allocate a host and driver data
+ * @sht: scsi host template
+ * @dd_data_size: driver host data size
+ * @qdepth: default device queue depth
+ *
+ * This should be called by partial offload and software iscsi drivers.
+ * To access the driver specific memory use the iscsi_host_priv() macro.
+ */
+struct Scsi_Host *iscsi_host_alloc(struct scsi_host_template *sht,
+				   int dd_data_size, uint16_t qdepth)
 {
+	struct Scsi_Host *shost;
+
+	shost = scsi_host_alloc(sht, sizeof(struct iscsi_host) + dd_data_size);
+	if (!shost)
+		return NULL;
+	shost->transportt->eh_timed_out = iscsi_eh_cmd_timed_out;
+
 	if (qdepth > ISCSI_MAX_CMD_PER_LUN || qdepth < 1) {
 		if (qdepth != 0)
 			printk(KERN_ERR "iscsi: invalid queue depth of %d. "
@@ -1773,22 +1804,37 @@ void iscsi_host_setup(struct Scsi_Host *shost, uint16_t qdepth)
 			       qdepth, ISCSI_MAX_CMD_PER_LUN);
 		qdepth = ISCSI_DEF_CMD_PER_LUN;
 	}
-
-	shost->transportt->create_work_queue = 1;
-	shost->transportt->eh_timed_out = iscsi_eh_cmd_timed_out;
 	shost->cmd_per_lun = qdepth;
+	return shost;
+}
+EXPORT_SYMBOL_GPL(iscsi_host_alloc);
+
+/**
+ * iscsi_host_remove - remove host and sessions
+ * @shost: scsi host
+ *
+ * This will also remove any sessions attached to the host, but if userspace
+ * is managing the session at the same time this will break. TODO: add
+ * refcounting to the netlink iscsi interface so a rmmod or host hot unplug
+ * does not remove the memory from under us.
+ */
+void iscsi_host_remove(struct Scsi_Host *shost)
+{
+	iscsi_host_for_each_session(shost, iscsi_session_teardown);
+	scsi_remove_host(shost);
 }
-EXPORT_SYMBOL_GPL(iscsi_host_setup);
+EXPORT_SYMBOL_GPL(iscsi_host_remove);
 
-void iscsi_host_teardown(struct Scsi_Host *shost)
+void iscsi_host_free(struct Scsi_Host *shost)
 {
 	struct iscsi_host *ihost = shost_priv(shost);
 
 	kfree(ihost->netdev);
 	kfree(ihost->hwaddress);
 	kfree(ihost->initiatorname);
+	scsi_host_put(shost);
 }
-EXPORT_SYMBOL_GPL(iscsi_host_teardown);
+EXPORT_SYMBOL_GPL(iscsi_host_free);
 
 /**
  * iscsi_session_setup - create iscsi cls session and host and session
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 9c00a15..6fdaa2e 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -279,6 +279,24 @@ static int iscsi_is_session_dev(const struct device *dev)
 	return dev->release == iscsi_session_release;
 }
 
+static int iscsi_iter_session_fn(struct device *dev, void *data)
+{
+	void (* fn) (struct iscsi_cls_session *) = data;
+
+	if (!iscsi_is_session_dev(dev))
+		return 0;
+	fn(iscsi_dev_to_session(dev));
+	return 0;
+}
+
+void iscsi_host_for_each_session(struct Scsi_Host *shost,
+				 void (*fn)(struct iscsi_cls_session *))
+{
+	device_for_each_child(&shost->shost_gendev, fn,
+			      iscsi_iter_session_fn);
+}
+EXPORT_SYMBOL_GPL(iscsi_host_for_each_session);
+
 /**
  * iscsi_scan_finished - helper to report when running scans are done
  * @shost: scsi host
@@ -1599,6 +1617,8 @@ iscsi_register_transport(struct iscsi_transport *tt)
 	priv->daemon_pid = -1;
 	priv->iscsi_transport = tt;
 	priv->t.user_scan = iscsi_user_scan;
+	if (!(tt->caps & CAP_DATA_PATH_OFFLOAD))
+		priv->t.create_work_queue = 1;
 
 	priv->dev.class = &iscsi_transport_class;
 	snprintf(priv->dev.bus_id, BUS_ID_SIZE, "%s", tt->name);
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 8a6271c..9a26d71 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -32,6 +32,7 @@
 #include <scsi/iscsi_if.h>
 
 struct scsi_transport_template;
+struct scsi_host_template;
 struct scsi_device;
 struct Scsi_Host;
 struct scsi_cmnd;
@@ -41,6 +42,7 @@ struct iscsi_cls_session;
 struct iscsi_cls_conn;
 struct iscsi_session;
 struct iscsi_nopin;
+struct device;
 
 /* #define DEBUG_SCSI */
 #ifdef DEBUG_SCSI
@@ -311,6 +313,8 @@ struct iscsi_host {
 	char			local_address[ISCSI_ADDRESS_BUF_LEN];
 };
 
+#define iscsi_host_priv(_shost) \
+	(shost_priv(_shost) + sizeof(struct iscsi_host))
 /*
  * scsi host template
  */
@@ -330,8 +334,11 @@ extern int iscsi_host_set_param(struct Scsi_Host *shost,
 				int buflen);
 extern int iscsi_host_get_param(struct Scsi_Host *shost,
 				enum iscsi_host_param param, char *buf);
-extern void iscsi_host_setup(struct Scsi_Host *shost, uint16_t qdepth);
-extern void iscsi_host_teardown(struct Scsi_Host *shost);
+extern int iscsi_host_add(struct Scsi_Host *shost, struct device *pdev);
+extern struct Scsi_Host *iscsi_host_alloc(struct scsi_host_template *sht,
+					  int dd_data_size, uint16_t qdepth);
+extern void iscsi_host_remove(struct Scsi_Host *shost);
+extern void iscsi_host_free(struct Scsi_Host *shost);
 
 /*
  * session management
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 702eda2..761f62d 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -207,6 +207,10 @@ struct iscsi_cls_host {
 	char scan_workq_name[KOBJ_NAME_LEN];
 };
 
+extern void iscsi_host_for_each_session(struct Scsi_Host *shost,
+				void (*fn)(struct iscsi_cls_session *));
+
+
 /*
  * session and connection functions that can be used by HW iSCSI LLDs
  */
-- 
1.5.4.1

