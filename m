From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH] add block/unblock to iscsi class
Date: Mon, 28 Mar 2005 05:48:18 -0800
Message-ID: <42480B22.20407@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030800040109070403090001"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:8605 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S261868AbVC1NsI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Mar 2005 08:48:08 -0500
Received: from [192.168.0.2] ([199.108.226.254])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.1/8.13.1) with ESMTP id j2SDm4CF000445
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 28 Mar 2005 07:48:05 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------030800040109070403090001
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

The attached patch adds session block and unblock functions
similar to the rport block and unblock code.

The patch was built against scsi misc (but also pathces
against scsi rc fixes) and this patch
http://marc.theaimsgroup.com/?l=linux-scsi&m=111181778109783&w=2
which adds a scsi_flush_work function.

Signed-off-by: Mike Chrisite <michaelc@cs.wisc.edu>

--------------030800040109070403090001
Content-Type: text/x-patch;
 name="add-iscsi-block.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="add-iscsi-block.patch"

diff -aurp scsi-misc-2.6.orig/drivers/scsi/scsi_transport_iscsi.c scsi-misc-2.6.test/drivers/scsi/scsi_transport_iscsi.c
--- scsi-misc-2.6.orig/drivers/scsi/scsi_transport_iscsi.c	2005-03-25 21:34:54.000000000 -0800
+++ scsi-misc-2.6.test/drivers/scsi/scsi_transport_iscsi.c	2005-03-27 03:03:04.000000000 -0800
@@ -25,7 +25,9 @@
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_iscsi.h>
 
-#define ISCSI_SESSION_ATTRS 20
+#include "scsi_priv.h"
+
+#define ISCSI_SESSION_ATTRS 21
 #define ISCSI_HOST_ATTRS 2
 
 struct iscsi_internal {
@@ -34,23 +36,13 @@ struct iscsi_internal {
 	/*
 	 * We do not have any private or other attrs.
 	 */
+	struct transport_container session_cont;
 	struct class_device_attribute *session_attrs[ISCSI_SESSION_ATTRS + 1];
 	struct class_device_attribute *host_attrs[ISCSI_HOST_ATTRS + 1];
 };
 
 #define to_iscsi_internal(tmpl) container_of(tmpl, struct iscsi_internal, t)
 
-static DECLARE_TRANSPORT_CLASS(iscsi_transport_class,
-			       "iscsi_transport",
-			       NULL,
-			       NULL,
-			       NULL);
-
-static DECLARE_TRANSPORT_CLASS(iscsi_host_class,
-			       "iscsi_host",
-			       NULL,
-			       NULL,
-			       NULL);
 /*
  * iSCSI target and session attrs
  */
@@ -59,19 +51,40 @@ static DECLARE_TRANSPORT_CLASS(iscsi_hos
 static ssize_t								\
 show_session_##field(struct class_device *cdev, char *buf)		\
 {									\
-	struct scsi_target *starget = transport_class_to_starget(cdev);	\
-	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);	\
+	struct iscsi_class_session *session = iscsi_cdev_to_session(cdev); \
+	struct Scsi_Host *shost = iscsi_session_to_shost(session);	\
 	struct iscsi_internal *i = to_iscsi_internal(shost->transportt); \
 									\
 	if (i->fnt->get_##field)					\
-		i->fnt->get_##field(starget);				\
-	return snprintf(buf, 20, format"\n", iscsi_##field(starget));	\
+		i->fnt->get_##field(session);				\
+	return snprintf(buf, 20, format"\n", session->field);		\
+}
+
+#define iscsi_session_store_fn(field, format_string)			\
+static ssize_t								\
+store_session_##field(struct class_device *cdev, const char *buf,	\
+		      size_t count)					\
+{									\
+	struct iscsi_class_session *session = iscsi_cdev_to_session(cdev); \
+	struct Scsi_Host *shost = iscsi_session_to_shost(session);	\
+	struct iscsi_internal *i = to_iscsi_internal(shost->transportt); \
+	int val;							\
+									\
+	val = simple_strtoul(buf, NULL, 0);				\
+	i->fnt->set_##field(session, val);				\
+	return count;							\
 }
 
 #define iscsi_session_rd_attr(field, format)				\
 	iscsi_session_show_fn(field, format)				\
 static CLASS_DEVICE_ATTR(field, S_IRUGO, show_session_##field, NULL);
 
+#define iscsi_session_rw_attr(field, format)				\
+	iscsi_session_show_fn(field, format)				\
+	iscsi_session_store_fn(field, format)				\
+static CLASS_DEVICE_ATTR(field, S_IRUGO | S_IWUSR,			\
+			 show_session_##field, store_session_##field)
+
 iscsi_session_rd_attr(tpgt, "%hu");
 iscsi_session_rd_attr(tsih, "%2x");
 iscsi_session_rd_attr(max_recv_data_segment_len, "%u");
@@ -81,21 +94,21 @@ iscsi_session_rd_attr(def_time2wait, "%h
 iscsi_session_rd_attr(def_time2retain, "%hu");
 iscsi_session_rd_attr(max_outstanding_r2t, "%hu");
 iscsi_session_rd_attr(erl, "%d");
-
+iscsi_session_rw_attr(session_recovery_tmo, "%d");
 
 #define iscsi_session_show_bool_fn(field)				\
 									\
 static ssize_t								\
 show_session_bool_##field(struct class_device *cdev, char *buf)		\
 {									\
-	struct scsi_target *starget = transport_class_to_starget(cdev);	\
-	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);	\
+	struct iscsi_class_session *session = iscsi_cdev_to_session(cdev); \
+	struct Scsi_Host *shost = iscsi_session_to_shost(session);	\
 	struct iscsi_internal *i = to_iscsi_internal(shost->transportt); \
 									\
 	if (i->fnt->get_##field)					\
-		i->fnt->get_##field(starget);				\
+		i->fnt->get_##field(session);				\
 									\
-	if (iscsi_##field(starget))					\
+	if (session->field)						\
 		return sprintf(buf, "Yes\n");				\
 	return sprintf(buf, "No\n");					\
 }
@@ -114,14 +127,14 @@ iscsi_session_rd_bool_attr(data_sequence
 static ssize_t								\
 show_##field(struct class_device *cdev, char *buf)			\
 {									\
-	struct scsi_target *starget = transport_class_to_starget(cdev);	\
-	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);	\
+	struct iscsi_class_session *session = iscsi_cdev_to_session(cdev); \
+	struct Scsi_Host *shost = iscsi_session_to_shost(session);	\
 	struct iscsi_internal *i = to_iscsi_internal(shost->transportt); \
 									\
 	if (i->fnt->get_##field)					\
-		i->fnt->get_##field(starget);				\
+		i->fnt->get_##field(session);				\
 									\
-	if (iscsi_##field(starget))					\
+	if (session->field)						\
 		return sprintf(buf, "CRC32C\n");			\
 	return sprintf(buf, "None\n");					\
 }
@@ -136,33 +149,33 @@ iscsi_session_rd_digest_attr(data_digest
 static ssize_t
 show_port(struct class_device *cdev, char *buf)
 {
-	struct scsi_target *starget = transport_class_to_starget(cdev);
-	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct iscsi_class_session *session = iscsi_cdev_to_session(cdev);
+	struct Scsi_Host *shost = iscsi_session_to_shost(session);
 	struct iscsi_internal *i = to_iscsi_internal(shost->transportt);
 
 	if (i->fnt->get_port)
-		i->fnt->get_port(starget);
+		i->fnt->get_port(session);
 
-	return snprintf(buf, 20, "%hu\n", ntohs(iscsi_port(starget)));
+	return snprintf(buf, 20, "%hu\n", ntohs(session->port));
 }
 static CLASS_DEVICE_ATTR(port, S_IRUGO, show_port, NULL);
 
 static ssize_t
 show_ip_address(struct class_device *cdev, char *buf)
 {
-	struct scsi_target *starget = transport_class_to_starget(cdev);
-	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct iscsi_class_session *session = iscsi_cdev_to_session(cdev);
+	struct Scsi_Host *shost = iscsi_session_to_shost(session);
 	struct iscsi_internal *i = to_iscsi_internal(shost->transportt);
 
 	if (i->fnt->get_ip_address)
-		i->fnt->get_ip_address(starget);
+		i->fnt->get_ip_address(session);
 
-	if (iscsi_addr_type(starget) == AF_INET)
+	if (session->addr_type == AF_INET)
 		return sprintf(buf, "%u.%u.%u.%u\n",
-			       NIPQUAD(iscsi_sin_addr(starget)));
-	else if(iscsi_addr_type(starget) == AF_INET6)
+			       NIPQUAD(session->u.sin_addr));
+	else if(session->addr_type == AF_INET6)
 		return sprintf(buf, "%04x:%04x:%04x:%04x:%04x:%04x:%04x:%04x\n",
-			       NIP6(iscsi_sin6_addr(starget)));
+			       NIP6(session->u.sin6_addr));
 	return -EINVAL;
 }
 static CLASS_DEVICE_ATTR(ip_address, S_IRUGO, show_ip_address, NULL);
@@ -170,17 +183,17 @@ static CLASS_DEVICE_ATTR(ip_address, S_I
 static ssize_t
 show_isid(struct class_device *cdev, char *buf)
 {
-	struct scsi_target *starget = transport_class_to_starget(cdev);
-	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct iscsi_class_session *session = iscsi_cdev_to_session(cdev);
+	struct Scsi_Host *shost = iscsi_session_to_shost(session);
 	struct iscsi_internal *i = to_iscsi_internal(shost->transportt);
 
 	if (i->fnt->get_isid)
-		i->fnt->get_isid(starget);
+		i->fnt->get_isid(session);
 
 	return sprintf(buf, "%02x%02x%02x%02x%02x%02x\n",
-		       iscsi_isid(starget)[0], iscsi_isid(starget)[1],
-		       iscsi_isid(starget)[2], iscsi_isid(starget)[3],
-		       iscsi_isid(starget)[4], iscsi_isid(starget)[5]);
+		       session->isid[0], session->isid[1],
+		       session->isid[2], session->isid[3],
+		       session->isid[4], session->isid[5]);
 }
 static CLASS_DEVICE_ATTR(isid, S_IRUGO, show_isid, NULL);
 
@@ -196,12 +209,12 @@ static ssize_t								\
 show_session_str_##field(struct class_device *cdev, char *buf)		\
 {									\
 	ssize_t ret = 0;						\
-	struct scsi_target *starget = transport_class_to_starget(cdev);	\
-	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);	\
+	struct iscsi_class_session *session = iscsi_cdev_to_session(cdev); \
+	struct Scsi_Host *shost = iscsi_session_to_shost(session);	\
 	struct iscsi_internal *i = to_iscsi_internal(shost->transportt); \
 									\
 	if (i->fnt->get_##field)					\
-		ret = i->fnt->get_##field(starget, buf, PAGE_SIZE);	\
+		ret = i->fnt->get_##field(session, buf, PAGE_SIZE);	\
 	return ret;							\
 }
 
@@ -242,12 +255,227 @@ static CLASS_DEVICE_ATTR(field, S_IRUGO,
 iscsi_host_rd_str_attr(initiator_name);
 iscsi_host_rd_str_attr(initiator_alias);
 
+/**
+ * iscsi_block_session - block IO to session.
+ * @session: iscsi_session
+ *
+ * scsi lldd's with a iSCSI transport call this routine to temporarily stop all
+ * scsi commands to all devices managed by this scsi target.  Called 
+ * from interrupt or normal process context.
+ *
+ * Returns zero if successful or error if not
+ *
+ * Notes:       
+ *	This routine assumes no locks are held on entry.
+ **/
+int iscsi_block_session(struct iscsi_class_session *session)
+{
+	struct work_struct *work = &session->session_recovery_work;
+	struct Scsi_Host *shost = iscsi_session_to_shost(session);
+	struct iscsi_internal *i = to_iscsi_internal(shost->transportt);
+	int timeout;
+
+	i->fnt->get_session_recovery_tmo(session);
+	timeout = session->session_recovery_tmo;
+	if (timeout < 0)
+		return -EINVAL;
+
+	scsi_target_block(&session->dev);
+
+	/* The scsi lld blocks this target for the timeout period only. */
+	schedule_delayed_work(work, timeout);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(iscsi_block_session);
+
+/**
+ * iscsi_unblocksession - unblock IO to a session.
+ * @session:	scsi target managed by this iscsi scsi lldd.	
+ *
+ * scsi lld's with a iSCSI transport call this routine to restart IO to all 
+ * devices associated with the caller's scsi target following a
+ * iscsi_target_block request.  Called from normal process context.
+ *
+ * Notes:       
+ *	This routine assumes no locks are held on entry.
+ **/
+void iscsi_unblock_session(struct iscsi_class_session *session)
+{
+	/* 
+	 * Stop the target timer first. Take no action on the del_timer
+	 * failure as the state machine state change will validate the
+	 * transaction. 
+	 */
+	if (!cancel_delayed_work(&session->session_recovery_work))
+		flush_scheduled_work();
+
+	scsi_target_unblock(&session->dev);
+}
+EXPORT_SYMBOL_GPL(iscsi_unblock_session);
+
+/**
+ * iscsi_session_block_timedout - Timeout handler for blocked scsi targets
+ *			 that fail to recover in the alloted time.
+ * @data:	iscsi session that failed to reappear in the alloted time.
+ **/
+static void iscsi_session_block_timedout(void *data)
+{
+	struct iscsi_class_session *session = data;
+	struct Scsi_Host *shost = iscsi_session_to_shost(session);
+	struct iscsi_internal *i = to_iscsi_internal(shost->transportt);
+
+	dev_printk(KERN_ERR, &session->dev, 
+		   "blocked session time out: target resuming\n");
+
+	if (i->fnt->session_recovery_timedout)
+		i->fnt->session_recovery_timedout(session);
+	/* 
+	 * set the device going again ... if the scsi lld didn't
+	 * unblock this device, then IO errors will probably
+	 * result if the host still isn't ready.
+	 */
+	scsi_target_unblock(&session->dev);
+}
+
+/**
+ * iscsi_scan_session - called to perform a scsi scan on a session's target.
+ * @data:       session to be scanned.
+ **/
+static void
+iscsi_scan_session(void *data)
+{
+	struct iscsi_class_session *session = data;
+
+	scsi_scan_target(&session->dev, session->channel, session->target_id,
+			SCAN_WILD_CARD, 1);
+}
+
+static void iscsi_session_dev_release(struct device *dev)
+{
+	struct iscsi_class_session *session = iscsi_dev_to_session(dev);
+	struct Scsi_Host *shost = iscsi_session_to_shost(session);
+
+	kfree(session);
+	scsi_host_put(shost);
+}
+
+/**
+ * iscsi_add_session - add a session
+ * @shost: scsi host session is attached to
+ * @channel: channel on host session is attached to
+ *
+ * Allocate and add a iscsi session. After this call it will be accessable
+ * through sysfs. The LLD must set the create_workqueue bit in it's
+ * transport so iscsi_add_session can scan the sessions's target from
+ * the workqueue.
+ **/
+struct iscsi_class_session *
+iscsi_add_session(struct Scsi_Host *shost, unsigned int channel)
+{
+	struct iscsi_class_session *session;
+	struct iscsi_host *iscsi_host;
+	struct device *dev;
+
+	/*
+	 * get a handle for the session since it references the
+	 * template's internal data (this is released in the class's
+	 * release function)
+	 */
+	shost = scsi_host_get(shost);
+	if (!shost) {
+		printk(KERN_ERR "iSCSI: could not get reference to shost\n");
+		return NULL;
+	}
+	iscsi_host = shost->shost_data;
+
+	session = kmalloc(sizeof(*session), GFP_KERNEL);
+	if (!session) {
+		printk(KERN_ERR "iSCSI: could not allocate session\n");
+		goto put_host;
+	}
+
+	memset(session, 0, sizeof(*session));
+	INIT_WORK(&session->session_recovery_work,
+		  iscsi_session_block_timedout, session);
+	INIT_WORK(&session->scan_work, iscsi_scan_session, session);
+	session->session_recovery_tmo = 15;
+	session->channel = channel;
+	session->target_id = iscsi_host->next_target_id++;
+
+	dev = &session->dev;
+	snprintf(dev->bus_id, BUS_ID_SIZE, "session%u:%u:%u", shost->host_no,
+		 session->channel, session->target_id);
+	dev->parent = &shost->shost_gendev;
+	dev->release = iscsi_session_dev_release;
+	if (device_register(dev)) {
+		printk(KERN_ERR "iSCSI: could not register session dev\n");
+		goto free_session;
+	}
+
+	transport_register_device(dev);
+	scsi_queue_work(shost, &session->scan_work);
+
+	return session;
+
+ free_session:
+	kfree(session);
+ put_host:
+	scsi_host_put(shost);
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(iscsi_add_session);
+
+void
+iscsi_remove_session(struct iscsi_class_session *session)
+{
+	struct Scsi_Host *shost = iscsi_session_to_shost(session);
+
+	if (!cancel_delayed_work(&session->session_recovery_work))
+		flush_scheduled_work();
+	scsi_flush_work(shost);
+
+	transport_unregister_device(&session->dev);
+	device_unregister(&session->dev);
+}
+EXPORT_SYMBOL_GPL(iscsi_remove_session);
+
+static DECLARE_TRANSPORT_CLASS(iscsi_session_class,
+			       "iscsi_session",
+			       NULL,
+			       NULL,
+			       NULL);
+
+static int iscsi_setup_host(struct device *dev)
+{
+	struct Scsi_Host *shost = dev_to_shost(dev);
+	struct iscsi_host *ihost = shost->shost_data;
+
+	ihost->next_target_id = 0;
+	return 0;
+}
+
+static DECLARE_TRANSPORT_CLASS(iscsi_host_class,
+			       "iscsi_host",
+			       iscsi_setup_host,
+			       NULL,
+			       NULL);
+
 #define SETUP_SESSION_RD_ATTR(field)					\
 	if (i->fnt->show_##field) {					\
 		i->session_attrs[count] = &class_device_attr_##field;	\
 		count++;						\
 	}
 
+#define SETUP_SESSION_RW_ATTR(field)					\
+	if (i->fnt->show_##field) {					\
+		i->session_attrs[count] = &class_device_attr_##field;	\
+		if (!i->fnt->set_##field) {				\
+			i->session_attrs[count]->attr.mode = S_IRUGO;	\
+			i->session_attrs[count]->store = NULL;		\
+		}							\
+		count++;						\
+	}
+
 #define SETUP_HOST_RD_ATTR(field)					\
 	if (i->fnt->show_##field) {					\
 		i->host_attrs[count] = &class_device_attr_##field;	\
@@ -273,13 +501,18 @@ static int iscsi_host_match(struct attri
 	return &i->t.host_attrs.ac == cont;
 }
 
-static int iscsi_target_match(struct attribute_container *cont,
-			    struct device *dev)
+static int iscsi_dev_is_session(const struct device *dev)
+{
+	return dev->release == iscsi_session_dev_release;
+}
+
+static int iscsi_session_match(struct attribute_container *cont,
+			       struct device *dev)
 {
 	struct Scsi_Host *shost;
 	struct iscsi_internal *i;
 
-	if (!scsi_is_target_device(dev))
+	if (!iscsi_dev_is_session(dev))
 		return 0;
 
 	shost = dev_to_shost(dev->parent);
@@ -288,8 +521,8 @@ static int iscsi_target_match(struct att
 		return 0;
 
 	i = to_iscsi_internal(shost->transportt);
-	
-	return &i->t.target_attrs.ac == cont;
+
+	return &i->session_cont.ac == cont;
 }
 
 struct scsi_transport_template *
@@ -304,12 +537,12 @@ iscsi_attach_transport(struct iscsi_func
 
 	memset(i, 0, sizeof(struct iscsi_internal));
 	i->fnt = fnt;
+	i->t.create_work_queue = 1;
 
-	i->t.target_attrs.ac.attrs = &i->session_attrs[0];
-	i->t.target_attrs.ac.class = &iscsi_transport_class.class;
-	i->t.target_attrs.ac.match = iscsi_target_match;
-	transport_container_register(&i->t.target_attrs);
-	i->t.target_size = sizeof(struct iscsi_class_session);
+	i->session_cont.ac.attrs = &i->session_attrs[0];
+	i->session_cont.ac.class = &iscsi_session_class.class;
+	i->session_cont.ac.match = iscsi_session_match;
+	transport_container_register(&i->session_cont);
 
 	SETUP_SESSION_RD_ATTR(tsih);
 	SETUP_SESSION_RD_ATTR(isid);
@@ -331,6 +564,7 @@ iscsi_attach_transport(struct iscsi_func
 	SETUP_SESSION_RD_ATTR(data_pdu_in_order);
 	SETUP_SESSION_RD_ATTR(data_sequence_in_order);
 	SETUP_SESSION_RD_ATTR(erl);
+	SETUP_SESSION_RW_ATTR(session_recovery_tmo);
 
 	BUG_ON(count > ISCSI_SESSION_ATTRS);
 	i->session_attrs[count] = NULL;
@@ -339,7 +573,7 @@ iscsi_attach_transport(struct iscsi_func
 	i->t.host_attrs.ac.class = &iscsi_host_class.class;
 	i->t.host_attrs.ac.match = iscsi_host_match;
 	transport_container_register(&i->t.host_attrs);
-	i->t.host_size = 0;
+	i->t.host_size = sizeof(struct iscsi_host);
 
 	count = 0;
 	SETUP_HOST_RD_ATTR(initiator_name);
@@ -357,7 +591,7 @@ void iscsi_release_transport(struct scsi
 {
 	struct iscsi_internal *i = to_iscsi_internal(t);
 
-	transport_container_unregister(&i->t.target_attrs);
+	transport_container_unregister(&i->session_cont);
 	transport_container_unregister(&i->t.host_attrs);
   
 	kfree(i);
@@ -367,17 +601,18 @@ EXPORT_SYMBOL(iscsi_release_transport);
 
 static __init int iscsi_transport_init(void)
 {
-	int err = transport_class_register(&iscsi_transport_class);
+	int err = transport_class_register(&iscsi_session_class);
 
 	if (err)
 		return err;
+
 	return transport_class_register(&iscsi_host_class);
 }
 
 static void __exit iscsi_transport_exit(void)
 {
 	transport_class_unregister(&iscsi_host_class);
-	transport_class_unregister(&iscsi_transport_class);
+	transport_class_unregister(&iscsi_session_class);
 }
 
 module_init(iscsi_transport_init);
diff -aurp scsi-misc-2.6.orig/include/scsi/scsi_transport_iscsi.h scsi-misc-2.6.test/include/scsi/scsi_transport_iscsi.h
--- scsi-misc-2.6.orig/include/scsi/scsi_transport_iscsi.h	2005-03-25 21:34:28.000000000 -0800
+++ scsi-misc-2.6.test/include/scsi/scsi_transport_iscsi.h	2005-03-27 03:01:30.000000000 -0800
@@ -28,108 +28,91 @@
 struct scsi_transport_template;
 
 struct iscsi_class_session {
-	uint8_t isid[6];
-	uint16_t tsih;
-	int header_digest;		/* 1 CRC32, 0 None */
-	int data_digest;		/* 1 CRC32, 0 None */
-	uint16_t tpgt;
+	uint8_t 	isid[6];
+	uint16_t	tsih;
+	int		header_digest;	/* 1 CRC32, 0 None */
+	int		data_digest;	/* 1 CRC32, 0 None */
+	uint16_t	tpgt;
 	union {
-		struct in6_addr sin6_addr;
-		struct in_addr sin_addr;
+		struct in6_addr 	sin6_addr;
+		struct in_addr		sin_addr;
 	} u;
-	sa_family_t addr_type;		/* must be AF_INET or AF_INET6 */
-	uint16_t port;			/* must be in network byte order */
-	int initial_r2t;		/* 1 Yes, 0 No */
-	int immediate_data;		/* 1 Yes, 0 No */
-	uint32_t max_recv_data_segment_len;
-	uint32_t max_burst_len;
-	uint32_t first_burst_len;
-	uint16_t def_time2wait;
-	uint16_t def_time2retain;
-	uint16_t max_outstanding_r2t;
-	int data_pdu_in_order;		/* 1 Yes, 0 No */
-	int data_sequence_in_order;	/* 1 Yes, 0 No */
-	int erl;
+	sa_family_t	addr_type;	/* must be AF_INET or AF_INET6 */
+	uint16_t	port;		/* must be in network byte order */
+	int		initial_r2t;	/* 1 Yes, 0 No */
+	int		immediate_data; /* 1 Yes, 0 No */
+	uint32_t	max_recv_data_segment_len;
+	uint32_t	max_burst_len;
+	uint32_t	first_burst_len;
+	uint16_t	def_time2wait;
+	uint16_t	def_time2retain;
+	uint16_t	max_outstanding_r2t;
+	int		data_pdu_in_order;	/* 1 Yes, 0 No */
+	int		data_sequence_in_order; /* 1 Yes, 0 No */
+	int		erl;
+
+	int		session_recovery_tmo;	/* recovery timeout in secs */
+	struct work_struct session_recovery_work;
+	struct work_struct scan_work;
+	struct device	dev;
+	unsigned	channel;
+	unsigned	target_id;
+
+	void		*session_data;	/* LLD storage */
 };
 
-/*
- * accessor macros
- */
-#define iscsi_isid(x) \
-	(((struct iscsi_class_session *)&(x)->starget_data)->isid)
-#define iscsi_tsih(x) \
-	(((struct iscsi_class_session *)&(x)->starget_data)->tsih)
-#define iscsi_header_digest(x) \
-	(((struct iscsi_class_session *)&(x)->starget_data)->header_digest)
-#define iscsi_data_digest(x) \
-	(((struct iscsi_class_session *)&(x)->starget_data)->data_digest)
-#define iscsi_port(x) \
-	(((struct iscsi_class_session *)&(x)->starget_data)->port)
-#define iscsi_addr_type(x) \
-	(((struct iscsi_class_session *)&(x)->starget_data)->addr_type)
-#define iscsi_sin_addr(x) \
-	(((struct iscsi_class_session *)&(x)->starget_data)->u.sin_addr)
-#define iscsi_sin6_addr(x) \
-	(((struct iscsi_class_session *)&(x)->starget_data)->u.sin6_addr)
-#define iscsi_tpgt(x) \
-	(((struct iscsi_class_session *)&(x)->starget_data)->tpgt)
-#define iscsi_initial_r2t(x) \
-	(((struct iscsi_class_session *)&(x)->starget_data)->initial_r2t)
-#define iscsi_immediate_data(x) \
-	(((struct iscsi_class_session *)&(x)->starget_data)->immediate_data)
-#define iscsi_max_recv_data_segment_len(x) \
-	(((struct iscsi_class_session *)&(x)->starget_data)->max_recv_data_segment_len)
-#define iscsi_max_burst_len(x) \
-	(((struct iscsi_class_session *)&(x)->starget_data)->max_burst_len)
-#define iscsi_first_burst_len(x) \
-	(((struct iscsi_class_session *)&(x)->starget_data)->first_burst_len)
-#define iscsi_def_time2wait(x) \
-	(((struct iscsi_class_session *)&(x)->starget_data)->def_time2wait)
-#define iscsi_def_time2retain(x) \
-	(((struct iscsi_class_session *)&(x)->starget_data)->def_time2retain)
-#define iscsi_max_outstanding_r2t(x) \
-	(((struct iscsi_class_session *)&(x)->starget_data)->max_outstanding_r2t)
-#define iscsi_data_pdu_in_order(x) \
-	(((struct iscsi_class_session *)&(x)->starget_data)->data_pdu_in_order)
-#define iscsi_data_sequence_in_order(x) \
-	(((struct iscsi_class_session *)&(x)->starget_data)->data_sequence_in_order)
-#define iscsi_erl(x) \
-	(((struct iscsi_class_session *)&(x)->starget_data)->erl)
+#define iscsi_dev_to_session(_dev) \
+	container_of(_dev, struct iscsi_class_session, dev)
+
+#define iscsi_cdev_to_session(_cdev) \
+	iscsi_dev_to_session(_cdev->dev)
+
+#define iscsi_session_to_shost(_sess) \
+	dev_to_shost(_sess->dev.parent)
+
+struct iscsi_host {
+	unsigned	next_target_id;
+};
 
 /*
  * The functions by which the transport class and the driver communicate
  */
 struct iscsi_function_template {
 	/*
-	 * target attrs
+	 * session attrs
 	 */
-	void (*get_isid)(struct scsi_target *);
-	void (*get_tsih)(struct scsi_target *);
-	void (*get_header_digest)(struct scsi_target *);
-	void (*get_data_digest)(struct scsi_target *);
-	void (*get_port)(struct scsi_target *);
-	void (*get_tpgt)(struct scsi_target *);
+	void (*get_isid)(struct iscsi_class_session *);
+	void (*get_tsih)(struct iscsi_class_session *);
+	void (*get_header_digest)(struct iscsi_class_session *);
+	void (*get_data_digest)(struct iscsi_class_session *);
+	void (*get_port)(struct iscsi_class_session *);
+	void (*get_tpgt)(struct iscsi_class_session *);
 	/*
 	 * In get_ip_address the lld must set the address and
 	 * the address type
 	 */
-	void (*get_ip_address)(struct scsi_target *);
+	void (*get_ip_address)(struct iscsi_class_session *);
 	/*
 	 * The lld should snprintf the name or alias to the buffer
 	 */
-	ssize_t (*get_target_name)(struct scsi_target *, char *, ssize_t);
-	ssize_t (*get_target_alias)(struct scsi_target *, char *, ssize_t);
-	void (*get_initial_r2t)(struct scsi_target *);
-	void (*get_immediate_data)(struct scsi_target *);
-	void (*get_max_recv_data_segment_len)(struct scsi_target *);
-	void (*get_max_burst_len)(struct scsi_target *);
-	void (*get_first_burst_len)(struct scsi_target *);
-	void (*get_def_time2wait)(struct scsi_target *);
-	void (*get_def_time2retain)(struct scsi_target *);
-	void (*get_max_outstanding_r2t)(struct scsi_target *);
-	void (*get_data_pdu_in_order)(struct scsi_target *);
-	void (*get_data_sequence_in_order)(struct scsi_target *);
-	void (*get_erl)(struct scsi_target *);
+	ssize_t (*get_target_name)(struct iscsi_class_session *, char *,
+				   ssize_t);
+	ssize_t (*get_target_alias)(struct iscsi_class_session *, char *,
+				    ssize_t);
+	void (*get_initial_r2t)(struct iscsi_class_session *);
+	void (*get_immediate_data)(struct iscsi_class_session *);
+	void (*get_max_recv_data_segment_len)(struct iscsi_class_session *);
+	void (*get_max_burst_len)(struct iscsi_class_session *);
+	void (*get_first_burst_len)(struct iscsi_class_session *);
+	void (*get_def_time2wait)(struct iscsi_class_session *);
+	void (*get_def_time2retain)(struct iscsi_class_session *);
+	void (*get_max_outstanding_r2t)(struct iscsi_class_session *);
+	void (*get_data_pdu_in_order)(struct iscsi_class_session *);
+	void (*get_data_sequence_in_order)(struct iscsi_class_session *);
+	void (*get_erl)(struct iscsi_class_session *);
+	void (*get_session_recovery_tmo)(struct iscsi_class_session *);
+	void (*set_session_recovery_tmo)(struct iscsi_class_session *, int);
+	void (*session_recovery_timedout)(struct iscsi_class_session *);
 
 	/*
 	 * host atts
@@ -170,9 +153,15 @@ struct iscsi_function_template {
 	unsigned long show_erl:1;
 	unsigned long show_initiator_name:1;
 	unsigned long show_initiator_alias:1;
+	unsigned long show_session_recovery_tmo:1;
 };
 
 struct scsi_transport_template *iscsi_attach_transport(struct iscsi_function_template *);
 void iscsi_release_transport(struct scsi_transport_template *);
+int iscsi_block_session(struct iscsi_class_session *session);
+void iscsi_unblock_session(struct iscsi_class_session *session);
+struct iscsi_class_session *iscsi_add_session(struct Scsi_Host *shost,
+					      unsigned int channel);
+void iscsi_remove_session(struct iscsi_class_session *session);
 
 #endif

--------------030800040109070403090001--
