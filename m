From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH] add block/unblock to iscsi class
Date: Wed, 23 Feb 2005 00:19:48 -0800
Message-ID: <421C3CA4.8070009@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070207080203010106090309"
Received: from sabe.cs.wisc.edu ([128.105.6.20]:57552 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S261420AbVBWITs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Feb 2005 03:19:48 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-iscsi-devel <linux-iscsi-devel@lists.sourceforge.net>, linux-scsi <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------070207080203010106090309
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

The attached patch copies the code from the fc transport
class which allows a LLD to block and unblock a device.
The block/unblock code is used by the iscsi-sfnet
driver in replacement of a internal timer doing the
same thing.

I understand that the target code is under construction
and our group as well as the HW iSCSI guys are trying to move
to something closer to the fc's rport model, so I was not
sure if it is better to wait or get this basic functionality in
first so we (and other SW and HW iSCSI drivers) can kill some
of our duplicated code sooner and then incrementally update
the class.

Mike

--------------070207080203010106090309
Content-Type: text/x-patch;
 name="add-iscsi-block.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="add-iscsi-block.patch"

diff -aurp scsi-rc-fixes-2.6.orig/drivers/scsi/scsi_transport_iscsi.c scsi-rc-fixes-2.6.work2/drivers/scsi/scsi_transport_iscsi.c
--- scsi-rc-fixes-2.6.orig/drivers/scsi/scsi_transport_iscsi.c	2005-02-14 16:59:53.000000000 -0800
+++ scsi-rc-fixes-2.6.work2/drivers/scsi/scsi_transport_iscsi.c	2005-02-22 23:44:26.000000000 -0800
@@ -25,8 +25,10 @@
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_iscsi.h>
 
-#define ISCSI_SESSION_ATTRS 20
-#define ISCSI_HOST_ATTRS 2
+#include "scsi_priv.h"
+
+#define ISCSI_SESSION_ATTRS 21
+#define ISCSI_HOST_ATTRS 3
 
 struct iscsi_internal {
 	struct scsi_transport_template t;
@@ -40,17 +42,6 @@ struct iscsi_internal {
 
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
@@ -68,10 +59,31 @@ show_session_##field(struct class_device
 	return snprintf(buf, 20, format"\n", iscsi_##field(starget));	\
 }
 
+#define iscsi_session_store_fn(field, format_string)			\
+static ssize_t								\
+store_session_##field(struct class_device *cdev, const char *buf,	\
+		      size_t count)					\
+{									\
+	int val;							\
+	struct scsi_target *starget = transport_class_to_starget(cdev);	\
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);	\
+	struct iscsi_internal *i = to_iscsi_internal(shost->transportt); \
+									\
+	val = simple_strtoul(buf, NULL, 0);				\
+	i->fnt->set_##field(starget, val);				\
+	return count;							\
+}
+
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
@@ -81,7 +93,7 @@ iscsi_session_rd_attr(def_time2wait, "%h
 iscsi_session_rd_attr(def_time2retain, "%hu");
 iscsi_session_rd_attr(max_outstanding_r2t, "%hu");
 iscsi_session_rd_attr(erl, "%d");
-
+iscsi_session_rw_attr(session_recovery_tmo, "%d");
 
 #define iscsi_session_show_bool_fn(field)				\
 									\
@@ -242,18 +254,314 @@ static CLASS_DEVICE_ATTR(field, S_IRUGO,
 iscsi_host_rd_str_attr(initiator_name);
 iscsi_host_rd_str_attr(initiator_alias);
 
+#define iscsi_host_show_fn(field, format)				\
+									\
+static ssize_t								\
+show_host_##field(struct class_device *cdev, char *buf)			\
+{									\
+	struct Scsi_Host *shost = transport_class_to_shost(cdev);	\
+	struct iscsi_internal *i = to_iscsi_internal(shost->transportt); \
+									\
+	if (i->fnt->get_host_##field)					\
+		i->fnt->get_host_##field(shost);			\
+	return snprintf(buf, 20, format"\n", iscsi_host_##field(shost)); \
+}
+
+#define iscsi_host_store_fn(field, format_string)			\
+static ssize_t								\
+store_host_##field(struct class_device *cdev, const char *buf,		\
+		      size_t count)					\
+{									\
+	int val;							\
+	struct Scsi_Host *shost = transport_class_to_shost(cdev);	\
+	struct iscsi_internal *i = to_iscsi_internal(shost->transportt); \
+									\
+	val = simple_strtoul(buf, NULL, 0);				\
+	i->fnt->set_host_##field(shost, val);				\
+	return count;							\
+}
+
+#define iscsi_host_rw_attr(field, format)				\
+	iscsi_host_show_fn(field, format)				\
+	iscsi_host_store_fn(field, format)				\
+static CLASS_DEVICE_ATTR(field, S_IRUGO | S_IWUSR,			\
+			 show_host_##field, store_host_##field)
+
+iscsi_host_rw_attr(recovery_tmo, "%d");
+
+/**
+ * iscsi_device_block - called by target functions to block a scsi device
+ * @dev:	scsi device
+ * @data:	unused
+ **/
+static void iscsi_device_block(struct scsi_device *sdev, void *data)
+{
+	scsi_internal_device_block(sdev);
+}
+
+/**
+ * iscsi_device_unblock - called by target functions to unblock a scsi device
+ * @dev:	scsi device
+ * @data:	unused
+ **/
+static void iscsi_device_unblock(struct scsi_device *sdev, void *data)
+{
+	scsi_internal_device_unblock(sdev);
+}
+
+/**
+ * iscsi_target_block - block a target by temporarily putting all its scsi devices
+ *		into the SDEV_BLOCK state.
+ * @starget:	scsi target managed by this iscsi scsi lldd.
+ *
+ * scsi lldd's with a iSCSI transport call this routine to temporarily stop all
+ * scsi commands to all devices managed by this scsi target.  Called 
+ * from interrupt or normal process context.
+ *
+ * Returns zero if successful or error if not
+ *
+ * Notes:       
+ *	The timeout and timer types are extracted from the iscsi transport 
+ *	attributes from the caller's target pointer.  This routine assumes no
+ *	locks are held on entry.
+ **/
+int iscsi_target_block(struct scsi_target *starget)
+{
+	int timeout = iscsi_session_recovery_tmo(starget);
+	struct work_struct *work = &iscsi_session_recovery_work(starget);
+
+	if (timeout < 0 || (timeout * HZ) > SCSI_DEVICE_BLOCK_MAX_TIMEOUT)
+		return -EINVAL;
+
+	starget_for_each_device(starget, NULL, iscsi_device_block);
+
+	/* The scsi lld blocks this target for the timeout period only. */
+	schedule_delayed_work(work, timeout);
+	return 0;
+}
+EXPORT_SYMBOL(iscsi_target_block);
+
+/**
+ * iscsi_target_unblock - unblock a target following a iscsi_target_block request.
+ * @starget:	scsi target managed by this iscsi scsi lldd.	
+ *
+ * scsi lld's with a iSCSI transport call this routine to restart IO to all 
+ * devices associated with the caller's scsi target following a
+ * iscsi_target_block request.  Called from interrupt or normal process
+ * context.
+ *
+ * Notes:       
+ *	This routine assumes no locks are held on entry.
+ **/
+void iscsi_target_unblock(struct scsi_target *starget)
+{
+	/* 
+	 * Stop the target timer first. Take no action on the del_timer
+	 * failure as the state machine state change will validate the
+	 * transaction. 
+	 */
+	cancel_delayed_work(&iscsi_session_recovery_work(starget));
+	flush_scheduled_work();
+
+	starget_for_each_device(starget, NULL, iscsi_device_unblock);
+}
+EXPORT_SYMBOL(iscsi_target_unblock);
+
+/**
+ * iscsi_host_block - block all scsi devices managed by the calling host temporarily 
+ *		by putting each device in the SDEV_BLOCK state.
+ * @shost:	scsi host pointer that contains all scsi device siblings.
+ *
+ * scsi lld's with a iSCSI transport call this routine to temporarily stop all
+ * scsi commands to all devices managed by this host.  Called 
+ * from interrupt or normal process context.
+ *
+ * Returns zero if successful or error if not
+ *
+ * Notes:
+ *	The timeout and timer types are extracted from the iscsi transport 
+ *	attributes from the caller's host pointer.  This routine assumes no
+ *	locks are held on entry.
+ **/
+int iscsi_host_block(struct Scsi_Host *shost)
+{
+	struct scsi_device *sdev;
+	int timeout = iscsi_host_recovery_tmo(shost);
+	struct work_struct *work = &iscsi_host_recovery_work(shost);
+
+	if (timeout < 0 || (timeout * HZ) > SCSI_DEVICE_BLOCK_MAX_TIMEOUT)
+		return -EINVAL;
+
+	shost_for_each_device(sdev, shost)
+		scsi_internal_device_block(sdev);
+	schedule_delayed_work(work, timeout * HZ);
+
+	return 0;
+}
+EXPORT_SYMBOL(iscsi_host_block);
+
+/**
+ * iscsi_host_unblock - unblock all devices managed by this host following a 
+ *		iscsi_host_block request.
+ * @shost:	scsi host containing all scsi device siblings to unblock.
+ *
+ * scsi lld's with a iSCSI transport call this routine to restart IO to all scsi
+ * devices managed by the specified scsi host following an iscsi_host_block 
+ * request.  Called from interrupt or normal process context.
+ *
+ * Notes:       
+ *	This routine assumes no locks are held on entry.
+ **/
+void iscsi_host_unblock(struct Scsi_Host *shost)
+{
+	struct scsi_device *sdev;
+
+	/* 
+	 * Stop the host timer first. Take no action on the del_timer
+	 * failure as the state machine state change will validate the
+	 * transaction.
+	 */
+	cancel_delayed_work(&iscsi_host_recovery_work(shost));
+	flush_scheduled_work();
+
+	shost_for_each_device(sdev, shost)
+		scsi_internal_device_unblock(sdev);
+}
+EXPORT_SYMBOL(iscsi_host_unblock);
+
+/**
+ * iscsi_target_block_timedout - Timeout handler for blocked scsi targets
+ *			 that fail to recover in the alloted time.
+ * @data:	scsi target that failed to reappear in the alloted time.
+ **/
+static void iscsi_target_block_timedout(void *data)
+{
+	struct scsi_target *starget = (struct scsi_target *)data;
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct iscsi_internal *i = to_iscsi_internal(shost->transportt);
+
+	dev_printk(KERN_ERR, &starget->dev, 
+		   "blocked target time out: target resuming\n");
+
+	if (i->fnt->target_block_timedout)
+		i->fnt->target_block_timedout(starget);
+	/* 
+	 * set the device going again ... if the scsi lld didn't
+	 * unblock this device, then IO errors will probably
+	 * result if the host still isn't ready.
+	 */
+	starget_for_each_device(starget, NULL, iscsi_device_unblock);
+}
+
+static int iscsi_add_target(struct device *dev)
+{
+	struct scsi_target *starget = to_scsi_target(dev);
+
+	iscsi_session_recovery_tmo(starget) = 30;
+	INIT_WORK(&iscsi_session_recovery_work(starget),
+		  iscsi_target_block_timedout, starget);
+	return 0;
+}
+
+static int iscsi_remove_target(struct device *dev)
+{
+	struct scsi_target *starget = to_scsi_target(dev);
+	/* Stop the target timer */
+	cancel_delayed_work(&iscsi_session_recovery_work(starget));
+	flush_scheduled_work();
+	return 0;
+}
+
+static DECLARE_TRANSPORT_CLASS(iscsi_transport_class,
+			       "iscsi_transport",
+			       iscsi_add_target,
+			       iscsi_remove_target,
+			       NULL);
+
+/**
+ * iscsi_host_block_timedout - Timeout handler for blocked scsi hosts
+ *			 that fail to recover in the alloted time.
+ * @data:	scsi host that failed to recover its devices in the alloted
+ *		time.
+ **/
+static void iscsi_host_block_timedout(void *data)
+{
+	struct Scsi_Host *shost = (struct Scsi_Host *)data;
+	struct iscsi_internal *i = to_iscsi_internal(shost->transportt);
+	struct scsi_device *sdev;
+
+	dev_printk(KERN_ERR, &shost->shost_gendev, 
+		"blocked host time out: host resuming\n");
+
+	if (i->fnt->host_block_timedout)
+		i->fnt->host_block_timedout(shost);
+
+	shost_for_each_device(sdev, shost)
+		/* 
+		 * set the device going again ... if the scsi lld didn't
+		 * unblock this device, then IO errors will probably
+		 * result if the host still isn't ready.
+		 */
+		scsi_internal_device_unblock(sdev);
+}
+
+static int iscsi_add_host(struct device *dev)
+{
+	struct Scsi_Host *shost = dev_to_shost(dev);
+
+	iscsi_host_recovery_tmo(shost) = 30;
+	INIT_WORK(&iscsi_host_recovery_work(shost),
+		  iscsi_host_block_timedout, shost);
+	return 0;
+}
+
+static int iscsi_remove_host(struct device *dev)
+{
+	struct Scsi_Host *shost = dev_to_shost(dev);
+	/* Stop the host timer */
+	cancel_delayed_work(&iscsi_host_recovery_work(shost));
+	flush_scheduled_work();
+	return 0;
+}
+
+static DECLARE_TRANSPORT_CLASS(iscsi_host_class,
+			       "iscsi_host",
+			       iscsi_add_host,
+			       iscsi_remove_host,
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
 		count++;						\
 	}
 
+#define SETUP_HOST_RW_ATTR(field)					\
+	if (i->fnt->show_host_##field) {				\
+		i->host_attrs[count] = &class_device_attr_##field;	\
+		if (!i->fnt->set_host_##field) {			\
+			i->session_attrs[count]->attr.mode = S_IRUGO;	\
+			i->session_attrs[count]->store = NULL;		\
+		}							\
+		count++;						\
+	}
+
 static int iscsi_host_match(struct attribute_container *cont,
 			  struct device *dev)
 {
@@ -331,6 +639,7 @@ iscsi_attach_transport(struct iscsi_func
 	SETUP_SESSION_RD_ATTR(data_pdu_in_order);
 	SETUP_SESSION_RD_ATTR(data_sequence_in_order);
 	SETUP_SESSION_RD_ATTR(erl);
+	SETUP_SESSION_RW_ATTR(session_recovery_tmo);
 
 	BUG_ON(count > ISCSI_SESSION_ATTRS);
 	i->session_attrs[count] = NULL;
@@ -339,11 +648,12 @@ iscsi_attach_transport(struct iscsi_func
 	i->t.host_attrs.class = &iscsi_host_class.class;
 	i->t.host_attrs.match = iscsi_host_match;
 	attribute_container_register(&i->t.host_attrs);
-	i->t.host_size = 0;
+	i->t.host_size = sizeof(struct iscsi_host);
 
 	count = 0;
 	SETUP_HOST_RD_ATTR(initiator_name);
 	SETUP_HOST_RD_ATTR(initiator_alias);
+	SETUP_HOST_RW_ATTR(recovery_tmo);
 
 	BUG_ON(count > ISCSI_HOST_ATTRS);
 	i->host_attrs[count] = NULL;
diff -aurp scsi-rc-fixes-2.6.orig/include/scsi/scsi_transport_iscsi.h scsi-rc-fixes-2.6.work2/include/scsi/scsi_transport_iscsi.h
--- scsi-rc-fixes-2.6.orig/include/scsi/scsi_transport_iscsi.h	2005-02-14 16:59:06.000000000 -0800
+++ scsi-rc-fixes-2.6.work2/include/scsi/scsi_transport_iscsi.h	2005-02-22 23:44:14.000000000 -0800
@@ -50,6 +50,9 @@ struct iscsi_class_session {
 	int data_pdu_in_order;		/* 1 Yes, 0 No */
 	int data_sequence_in_order;	/* 1 Yes, 0 No */
 	int erl;
+
+	int session_recovery_tmo;	/* recovery timeout in seconds */
+	struct work_struct session_recovery_work;
 };
 
 /*
@@ -95,6 +98,20 @@ struct iscsi_class_session {
 	(((struct iscsi_class_session *)&(x)->starget_data)->data_sequence_in_order)
 #define iscsi_erl(x) \
 	(((struct iscsi_class_session *)&(x)->starget_data)->erl)
+#define iscsi_session_recovery_tmo(x) \
+	(((struct iscsi_class_session *)&(x)->starget_data)->session_recovery_tmo)
+#define iscsi_session_recovery_work(x) \
+	(((struct iscsi_class_session *)&(x)->starget_data)->session_recovery_work)
+
+struct iscsi_host {
+	int recovery_tmo;	/* recovery timeout in seconds */
+	struct work_struct recovery_work;
+};
+
+#define iscsi_host_recovery_tmo(x) \
+	(((struct iscsi_host *)(x)->shost_data)->recovery_tmo)
+#define iscsi_host_recovery_work(x) \
+	(((struct iscsi_host *)(x)->shost_data)->recovery_work)
 
 /*
  * The functions by which the transport class and the driver communicate
@@ -130,6 +147,9 @@ struct iscsi_function_template {
 	void (*get_data_pdu_in_order)(struct scsi_target *);
 	void (*get_data_sequence_in_order)(struct scsi_target *);
 	void (*get_erl)(struct scsi_target *);
+	void (*get_session_recovery_tmo)(struct scsi_target *);
+	void (*set_session_recovery_tmo)(struct scsi_target *, int);
+	void (*target_block_timedout)(struct scsi_target *);
 
 	/*
 	 * host atts
@@ -140,6 +160,9 @@ struct iscsi_function_template {
 	 */
 	ssize_t (*get_initiator_alias)(struct Scsi_Host *, char *, ssize_t);
 	ssize_t (*get_initiator_name)(struct Scsi_Host *, char *, ssize_t);
+	void (*get_host_recovery_tmo)(struct Scsi_Host *);
+	void (*set_host_recovery_tmo)(struct Scsi_Host *, int);
+	void (*host_block_timedout)(struct Scsi_Host *);
 	/*
 	 * The driver sets these to tell the transport class it
 	 * wants the attributes displayed in sysfs.  If the show_ flag
@@ -170,9 +193,15 @@ struct iscsi_function_template {
 	unsigned long show_erl:1;
 	unsigned long show_initiator_name:1;
 	unsigned long show_initiator_alias:1;
+	unsigned long show_session_recovery_tmo:1;
+	unsigned long show_host_recovery_tmo:1;
 };
 
 struct scsi_transport_template *iscsi_attach_transport(struct iscsi_function_template *);
 void iscsi_release_transport(struct scsi_transport_template *);
+int iscsi_target_block(struct scsi_target *starget);
+void iscsi_target_unblock(struct scsi_target *starget);
+int iscsi_host_block(struct Scsi_Host *shost);
+void iscsi_host_unblock(struct Scsi_Host *shost);
 
 #endif

--------------070207080203010106090309--
