From: "Nicholas A. Bellinger" <nick@pyxtechnologies.com>
Subject: [PATCH] scsi_transport_iscsi.c contexts
Date: Wed, 27 Apr 2005 16:55:47 -0700
Message-ID: <1114646147.20844.37.camel@haakon>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-OeRkohX60Eya6NfItcZL"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp801.mail.sc5.yahoo.com ([66.163.168.180]:28830 "HELO
	smtp801.mail.sc5.yahoo.com") by vger.kernel.org with SMTP
	id S262111AbVD1AF1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Apr 2005 20:05:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <mikenc@us.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>


--=-OeRkohX60Eya6NfItcZL
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

This patch against 2.6.12-rc3 is the first step for scsi_transport_iscsi
getting iSCSI Keys defined in RFC 3720 Section 12 and other values not
defined in this section as keys, but need to be exported out via sysfs
into the correct connection/session contexts.

Currently, scsi_transport_iscsi.[c,h] assume that all values are on a
per session basis.  These changes have been tested with the upcoming
iSCSI transport class enabled release of iscsi-initiator-core
(1.6.2.0-rc2), and should hopefully be 'breakage-free' with sfnet.

Comments?

-- 
Nicholas A. Bellinger <nick@pyxtechnologies.com>

-----------------------------------------------------------------------

Pretty straight forward changes to:

drivers/scsi/scsi_transport_iscsi.c

Added a connection_attrib[] member to iscsi_internal.

Made max_recv_data_segment_len, header_digest, data_digest, ip_address
and port per connection.

Added of_marker, if_marker, of_markint and if_markint from RFC 3720
Appendix A.  Also per connection.

Also moved around the various CPP macros for creating the class device
functions.  This should be much more reable now.

include/scsi/scsi_transport_iscsi.h

Added a struct iscsi_connection_class.

Added struct iscsi_connection_class to struct iscsi_session_class.

Split out the connection/session accessor macros.

Some reorginization of struct iscsi_function_template.



--=-OeRkohX60Eya6NfItcZL
Content-Disposition: attachment; filename=scsi_transport_iscsi_contexts.patch
Content-Type: text/x-patch; name=scsi_transport_iscsi_contexts.patch; charset=us-ascii
Content-Transfer-Encoding: 7bit

diff -urN linux-2.6.12-rc3/drivers/scsi/scsi_transport_iscsi.c linux-2.6.12-rc3-iscsi/drivers/scsi/scsi_transport_iscsi.c
--- linux-2.6.12-rc3/drivers/scsi/scsi_transport_iscsi.c	2005-04-27 15:02:03.000000000 -0700
+++ linux-2.6.12-rc3-iscsi/drivers/scsi/scsi_transport_iscsi.c	2005-04-27 17:36:20.000000000 -0700
@@ -3,6 +3,8 @@
  *
  * Copyright (C) IBM Corporation, 2004
  * Copyright (C) Mike Christie, 2004
+ * Copyright (C) PyX Technologies, 2005
+ * Copyright (C) Nicholas A. Bellinger <nab@kernel.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -25,7 +27,8 @@
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_iscsi.h>
 
-#define ISCSI_SESSION_ATTRS 20
+#define ISCSI_CONNECTION_ATTRS 9
+#define ISCSI_SESSION_ATTRS 15
 #define ISCSI_HOST_ATTRS 2
 
 struct iscsi_internal {
@@ -34,6 +37,7 @@
 	/*
 	 * We do not have any private or other attrs.
 	 */
+	struct class_device_attribute *connection_attrs[ISCSI_CONNECTION_ATTRS + 1];
 	struct class_device_attribute *session_attrs[ISCSI_SESSION_ATTRS + 1];
 	struct class_device_attribute *host_attrs[ISCSI_HOST_ATTRS + 1];
 };
@@ -51,68 +55,119 @@
 			       NULL,
 			       NULL,
 			       NULL);
+
 /*
- * iSCSI target and session attrs
+ * Format specification attributes
  */
-#define iscsi_session_show_fn(field, format)				\
+#define iscsi_show_fn(type, field, format)				\
 									\
 static ssize_t								\
-show_session_##field(struct class_device *cdev, char *buf)		\
+iscsi_show_##type##_##field(struct class_device *cdev, char *buf)	\
 {									\
 	struct scsi_target *starget = transport_class_to_starget(cdev);	\
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);	\
 	struct iscsi_internal *i = to_iscsi_internal(shost->transportt); \
 									\
 	if (i->fnt->get_##field)					\
-		i->fnt->get_##field(starget);				\
-	return snprintf(buf, 20, format"\n", iscsi_##field(starget));	\
+		 i->fnt->get_##field(starget);				\
+	return snprintf(buf, 20, format"\n", iscsi_##field(starget));   \
 }
 
+#define iscsi_connection_rd_attr(field, format)				\
+	iscsi_show_fn(connection, field, format)			\
+static CLASS_DEVICE_ATTR(field, S_IRUGO, iscsi_show_connection_##field, NULL);
+
 #define iscsi_session_rd_attr(field, format)				\
-	iscsi_session_show_fn(field, format)				\
-static CLASS_DEVICE_ATTR(field, S_IRUGO, show_session_##field, NULL);
+	iscsi_show_fn(session, field, format)				\
+static CLASS_DEVICE_ATTR(field, S_IRUGO, iscsi_show_session_##field, NULL);
 
-iscsi_session_rd_attr(tpgt, "%hu");
-iscsi_session_rd_attr(tsih, "%2x");
-iscsi_session_rd_attr(max_recv_data_segment_len, "%u");
-iscsi_session_rd_attr(max_burst_len, "%u");
-iscsi_session_rd_attr(first_burst_len, "%u");
-iscsi_session_rd_attr(def_time2wait, "%hu");
-iscsi_session_rd_attr(def_time2retain, "%hu");
-iscsi_session_rd_attr(max_outstanding_r2t, "%hu");
-iscsi_session_rd_attr(erl, "%d");
+/*
+ * Boolean attributes
+ */
+#define iscsi_show_bool_fn(type, field)                                 \
+                                                                        \
+static ssize_t                                                          \
+iscsi_show_##type##_bool_##field(struct class_device *cdev, char *buf)	\
+{                                                                       \
+        struct scsi_target *starget = transport_class_to_starget(cdev); \
+        struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);    \
+        struct iscsi_internal *i = to_iscsi_internal(shost->transportt); \
+                                                                        \
+        if (i->fnt->get_##field)                                        \
+                i->fnt->get_##field(starget);                           \
+                                                                        \
+        if (iscsi_##field(starget))                                     \
+                return sprintf(buf, "Yes\n");                           \
+        return sprintf(buf, "No\n");                                    \
+}
+
+#define iscsi_connection_rd_bool_attr(field)				\
+        iscsi_show_bool_fn(connection, field)				\
+static CLASS_DEVICE_ATTR(field, S_IRUGO, iscsi_show_connection_bool_##field, NULL);
 
+#define iscsi_session_rd_bool_attr(field)				\
+        iscsi_show_bool_fn(session, field)				\
+static CLASS_DEVICE_ATTR(field, S_IRUGO, iscsi_show_session_bool_##field, NULL);
 
-#define iscsi_session_show_bool_fn(field)				\
+/*
+ * This is used for iSCSI names. Normally, we follow
+ * the transport class convention of having the lld
+ * set the field, but in these cases the value is
+ * too large.
+ */
+#define iscsi_show_str_fn(type, field)					\
 									\
 static ssize_t								\
-show_session_bool_##field(struct class_device *cdev, char *buf)		\
-{									\
-	struct scsi_target *starget = transport_class_to_starget(cdev);	\
-	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);	\
-	struct iscsi_internal *i = to_iscsi_internal(shost->transportt); \
-									\
-	if (i->fnt->get_##field)					\
-		i->fnt->get_##field(starget);				\
-									\
-	if (iscsi_##field(starget))					\
-		return sprintf(buf, "Yes\n");				\
-	return sprintf(buf, "No\n");					\
+iscsi_show_##type##_str_##field(struct class_device *cdev, char *buf)	\
+{                                                                       \
+        ssize_t ret = 0;                                                \
+        struct scsi_target *starget = transport_class_to_starget(cdev); \
+        struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);    \
+        struct iscsi_internal *i = to_iscsi_internal(shost->transportt); \
+                                                                        \
+        if (i->fnt->get_##field)                                        \
+                ret = i->fnt->get_##field(starget, buf, PAGE_SIZE);     \
+        return ret;                                                     \
 }
 
-#define iscsi_session_rd_bool_attr(field)				\
-	iscsi_session_show_bool_fn(field)				\
-static CLASS_DEVICE_ATTR(field, S_IRUGO, show_session_bool_##field, NULL);
+#define iscsi_connection_rd_str_attr(field)				\
+        iscsi_show_str_fn(connection, field)				\
+static CLASS_DEVICE_ATTR(field, S_IRUGO, iscsi_show_connection_str_##field, NULL);
 
-iscsi_session_rd_bool_attr(initial_r2t);
-iscsi_session_rd_bool_attr(immediate_data);
-iscsi_session_rd_bool_attr(data_pdu_in_order);
-iscsi_session_rd_bool_attr(data_sequence_in_order);
+#define iscsi_session_rd_str_attr(field)				\
+        iscsi_show_str_fn(session, field)				\
+static CLASS_DEVICE_ATTR(field, S_IRUGO, iscsi_show_session_str_##field, NULL);
 
-#define iscsi_session_show_digest_fn(field)				\
+/*
+ * Again, this is used for iSCSI names. Normally, we follow
+ * the transport class convention of having the lld set
+ * the field, but in these cases the value is too large.
+ */
+#define iscsi_host_show_str_fn(field)                                   \
+                                                                        \
+static ssize_t                                                          \
+iscsi_show_host_str_##field(struct class_device *cdev, char *buf)	\
+{                                                                       \
+        int ret = 0;                                                    \
+        struct Scsi_Host *shost = transport_class_to_shost(cdev);       \
+        struct iscsi_internal *i = to_iscsi_internal(shost->transportt); \
+                                                                        \
+        if (i->fnt->get_##field)                                        \
+                ret = i->fnt->get_##field(shost, buf, PAGE_SIZE);       \
+        return ret;                                                     \
+}
+
+#define iscsi_host_rd_str_attr(field)                                   \
+        iscsi_host_show_str_fn(field)                                   \
+static CLASS_DEVICE_ATTR(field, S_IRUGO, iscsi_show_host_str_##field, NULL);
+
+/*
+ * Special case for Digests
+ */
+#define iscsi_show_connection_digest_fn(field)				\
 									\
 static ssize_t								\
-show_##field(struct class_device *cdev, char *buf)			\
+iscsi_show_connection_##field(struct class_device *cdev, char *buf)	\
 {									\
 	struct scsi_target *starget = transport_class_to_starget(cdev);	\
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);	\
@@ -126,121 +181,93 @@
 	return sprintf(buf, "None\n");					\
 }
 
-#define iscsi_session_rd_digest_attr(field)				\
-	iscsi_session_show_digest_fn(field)				\
-static CLASS_DEVICE_ATTR(field, S_IRUGO, show_##field, NULL);
-
-iscsi_session_rd_digest_attr(header_digest);
-iscsi_session_rd_digest_attr(data_digest);
-
-static ssize_t
-show_port(struct class_device *cdev, char *buf)
-{
-	struct scsi_target *starget = transport_class_to_starget(cdev);
-	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
-	struct iscsi_internal *i = to_iscsi_internal(shost->transportt);
-
-	if (i->fnt->get_port)
-		i->fnt->get_port(starget);
-
-	return snprintf(buf, 20, "%hu\n", ntohs(iscsi_port(starget)));
-}
-static CLASS_DEVICE_ATTR(port, S_IRUGO, show_port, NULL);
-
-static ssize_t
-show_ip_address(struct class_device *cdev, char *buf)
-{
-	struct scsi_target *starget = transport_class_to_starget(cdev);
-	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
-	struct iscsi_internal *i = to_iscsi_internal(shost->transportt);
-
-	if (i->fnt->get_ip_address)
-		i->fnt->get_ip_address(starget);
-
-	if (iscsi_addr_type(starget) == AF_INET)
-		return sprintf(buf, "%u.%u.%u.%u\n",
-			       NIPQUAD(iscsi_sin_addr(starget)));
-	else if(iscsi_addr_type(starget) == AF_INET6)
-		return sprintf(buf, "%04x:%04x:%04x:%04x:%04x:%04x:%04x:%04x\n",
-			       NIP6(iscsi_sin6_addr(starget)));
-	return -EINVAL;
-}
-static CLASS_DEVICE_ATTR(ip_address, S_IRUGO, show_ip_address, NULL);
-
-static ssize_t
-show_isid(struct class_device *cdev, char *buf)
-{
-	struct scsi_target *starget = transport_class_to_starget(cdev);
-	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
-	struct iscsi_internal *i = to_iscsi_internal(shost->transportt);
-
-	if (i->fnt->get_isid)
-		i->fnt->get_isid(starget);
-
-	return sprintf(buf, "%02x%02x%02x%02x%02x%02x\n",
-		       iscsi_isid(starget)[0], iscsi_isid(starget)[1],
-		       iscsi_isid(starget)[2], iscsi_isid(starget)[3],
-		       iscsi_isid(starget)[4], iscsi_isid(starget)[5]);
-}
-static CLASS_DEVICE_ATTR(isid, S_IRUGO, show_isid, NULL);
+#define iscsi_connection_rd_digest_attr(field)				\
+	iscsi_show_connection_digest_fn(field)				\
+static CLASS_DEVICE_ATTR(field, S_IRUGO, iscsi_show_connection_##field, NULL);
 
 /*
- * This is used for iSCSI names. Normally, we follow
- * the transport class convention of having the lld
- * set the field, but in these cases the value is
- * too large.
+ * Special case for iSCSI Port
  */
-#define iscsi_session_show_str_fn(field)				\
+#define iscsi_show_connection_port_fn()					\
 									\
 static ssize_t								\
-show_session_str_##field(struct class_device *cdev, char *buf)		\
+iscsi_show_connection_port(struct class_device *cdev, char *buf)	\
 {									\
-	ssize_t ret = 0;						\
 	struct scsi_target *starget = transport_class_to_starget(cdev);	\
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);	\
 	struct iscsi_internal *i = to_iscsi_internal(shost->transportt); \
 									\
-	if (i->fnt->get_##field)					\
-		ret = i->fnt->get_##field(starget, buf, PAGE_SIZE);	\
-	return ret;							\
+	if (i->fnt->get_port)						\
+		i->fnt->get_port(starget);				\
+									\
+	return snprintf(buf, 20, "%hu\n", ntohs(iscsi_port(starget)));	\
 }
 
-#define iscsi_session_rd_str_attr(field)				\
-	iscsi_session_show_str_fn(field)				\
-static CLASS_DEVICE_ATTR(field, S_IRUGO, show_session_str_##field, NULL);
-
-iscsi_session_rd_str_attr(target_name);
-iscsi_session_rd_str_attr(target_alias);
+#define iscsi_connection_rd_port()					\
+	iscsi_show_connection_port_fn()					\
+static CLASS_DEVICE_ATTR(port, S_IRUGO, iscsi_show_connection_port, NULL);
 
 /*
- * iSCSI host attrs
+ * Special case for iSCSI IP Address - Connection Only
  */
+#define iscsi_show_connection_ip_address_fn()				\
+									\
+static ssize_t								\
+iscsi_show_connection_ip_address(struct class_device *cdev, char *buf)	\
+{									\
+	struct scsi_target *starget = transport_class_to_starget(cdev);	\
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);	\
+	struct iscsi_internal *i = to_iscsi_internal(shost->transportt); \
+									\
+	if (i->fnt->get_ip_address)					\
+		i->fnt->get_ip_address(starget);			\
+									\
+	if (iscsi_addr_type(starget) == AF_INET)			\
+		return sprintf(buf, "%u.%u.%u.%u\n",			\
+			       NIPQUAD(iscsi_sin_addr(starget)));	\
+	else if(iscsi_addr_type(starget) == AF_INET6)			\
+		return sprintf(buf, "%04x:%04x:%04x:%04x:%04x:%04x:%04x:%04x\n", \
+			       NIP6(iscsi_sin6_addr(starget)));		\
+	return -EINVAL;							\
+}								
+
+#define iscsi_connection_rd_ip_address()				\
+	iscsi_show_connection_ip_address_fn()				\
+static CLASS_DEVICE_ATTR(ip_address, S_IRUGO, iscsi_show_connection_ip_address, NULL);
 
 /*
- * Again, this is used for iSCSI names. Normally, we follow
- * the transport class convention of having the lld set
- * the field, but in these cases the value is too large.
+ * Special case for iSCSI Initiator ISID - Session Wide
  */
-#define iscsi_host_show_str_fn(field)					\
+#define iscsi_show_session_isid_fn()					\
 									\
 static ssize_t								\
-show_host_str_##field(struct class_device *cdev, char *buf)		\
+iscsi_show_session_isid(struct class_device *cdev, char *buf)		\
 {									\
-	int ret = 0;							\
-	struct Scsi_Host *shost = transport_class_to_shost(cdev);	\
+	struct scsi_target *starget = transport_class_to_starget(cdev);	\
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);	\
 	struct iscsi_internal *i = to_iscsi_internal(shost->transportt); \
 									\
-	if (i->fnt->get_##field)					\
-		ret = i->fnt->get_##field(shost, buf, PAGE_SIZE);	\
-	return ret;							\
+	if (i->fnt->get_isid)						\
+		i->fnt->get_isid(starget);				\
+									\
+	return sprintf(buf, "%02x%02x%02x%02x%02x%02x\n",		\
+		       iscsi_isid(starget)[0], iscsi_isid(starget)[1],	\
+		       iscsi_isid(starget)[2], iscsi_isid(starget)[3],	\
+		       iscsi_isid(starget)[4], iscsi_isid(starget)[5]);	\
 }
 
-#define iscsi_host_rd_str_attr(field)					\
-	iscsi_host_show_str_fn(field)					\
-static CLASS_DEVICE_ATTR(field, S_IRUGO, show_host_str_##field, NULL);
+#define iscsi_session_rd_isid()						\
+	iscsi_show_session_isid_fn()					\
+static CLASS_DEVICE_ATTR(isid, S_IRUGO, iscsi_show_session_isid, NULL);
 
-iscsi_host_rd_str_attr(initiator_name);
-iscsi_host_rd_str_attr(initiator_alias);
+/*
+ * Used in iscsi_register_transport()
+ */
+#define SETUP_CONNECTION_RD_ATTR(field)					\
+	if (i->fnt->show_##field) {					\
+		i->connection_attrs[count] = &class_device_attr_##field; \
+		count++;						\
+	}
 
 #define SETUP_SESSION_RD_ATTR(field)					\
 	if (i->fnt->show_##field) {					\
@@ -254,6 +281,48 @@
 		count++;						\
 	}
 
+/*
+ * iSCSI keys - RFC 3720 Section 12 - Connection Only
+ */
+iscsi_connection_rd_attr(max_recv_data_segment_len, "%u");
+iscsi_connection_rd_ip_address();
+iscsi_connection_rd_port();
+iscsi_connection_rd_digest_attr(header_digest);
+iscsi_connection_rd_digest_attr(data_digest);
+
+/*
+ * iSCSI Keys - RFC 3720 Appendix A - Connection Only
+ */
+iscsi_connection_rd_attr(of_markint, "%hu");
+iscsi_connection_rd_attr(if_markint, "%hu");
+iscsi_connection_rd_bool_attr(of_marker);
+iscsi_connection_rd_bool_attr(if_marker);
+
+/*
+ * iSCSI Keys - RFC 3270 Section 12 - Session Wide
+ */
+iscsi_session_rd_isid();
+iscsi_session_rd_attr(tpgt, "%hu");
+iscsi_session_rd_attr(tsih, "%2x"); /* Not actually negoitated, returned in login PDU */
+iscsi_session_rd_attr(max_burst_len, "%u");
+iscsi_session_rd_attr(first_burst_len, "%u");
+iscsi_session_rd_attr(def_time2wait, "%hu");
+iscsi_session_rd_attr(def_time2retain, "%hu");
+iscsi_session_rd_attr(max_outstanding_r2t, "%hu");
+iscsi_session_rd_attr(erl, "%d");
+iscsi_session_rd_bool_attr(initial_r2t);
+iscsi_session_rd_bool_attr(immediate_data);
+iscsi_session_rd_bool_attr(data_pdu_in_order);
+iscsi_session_rd_bool_attr(data_sequence_in_order);
+iscsi_session_rd_str_attr(target_name);
+iscsi_session_rd_str_attr(target_alias);
+
+/*
+ * Still Session Wide - Defines as Host Attribute due to length limitiations.
+ */
+iscsi_host_rd_str_attr(initiator_name);
+iscsi_host_rd_str_attr(initiator_alias);
+
 static int iscsi_host_match(struct attribute_container *cont,
 			  struct device *dev)
 {
@@ -311,18 +380,27 @@
 	transport_container_register(&i->t.target_attrs);
 	i->t.target_size = sizeof(struct iscsi_class_session);
 
-	SETUP_SESSION_RD_ATTR(tsih);
+	SETUP_CONNECTION_RD_ATTR(max_recv_data_segment_len);
+	SETUP_CONNECTION_RD_ATTR(header_digest);
+	SETUP_CONNECTION_RD_ATTR(data_digest);
+	SETUP_CONNECTION_RD_ATTR(of_marker);
+	SETUP_CONNECTION_RD_ATTR(if_marker);
+	SETUP_CONNECTION_RD_ATTR(of_markint);
+	SETUP_CONNECTION_RD_ATTR(if_markint);
+	SETUP_CONNECTION_RD_ATTR(ip_address);
+	SETUP_CONNECTION_RD_ATTR(port);
+
+	BUG_ON(count > ISCSI_CONNECTION_ATTRS);
+	i->connection_attrs[count] = NULL;	
+
+	count = 0;
 	SETUP_SESSION_RD_ATTR(isid);
-	SETUP_SESSION_RD_ATTR(header_digest);
-	SETUP_SESSION_RD_ATTR(data_digest);
+	SETUP_SESSION_RD_ATTR(tsih);
 	SETUP_SESSION_RD_ATTR(target_name);
 	SETUP_SESSION_RD_ATTR(target_alias);
-	SETUP_SESSION_RD_ATTR(port);
 	SETUP_SESSION_RD_ATTR(tpgt);
-	SETUP_SESSION_RD_ATTR(ip_address);
 	SETUP_SESSION_RD_ATTR(initial_r2t);
 	SETUP_SESSION_RD_ATTR(immediate_data);
-	SETUP_SESSION_RD_ATTR(max_recv_data_segment_len);
 	SETUP_SESSION_RD_ATTR(max_burst_len);
 	SETUP_SESSION_RD_ATTR(first_burst_len);
 	SETUP_SESSION_RD_ATTR(def_time2wait);
diff -urN linux-2.6.12-rc3/include/scsi/scsi_transport_iscsi.h linux-2.6.12-rc3-iscsi/include/scsi/scsi_transport_iscsi.h
--- linux-2.6.12-rc3/include/scsi/scsi_transport_iscsi.h	2005-03-01 23:37:47.000000000 -0800
+++ linux-2.6.12-rc3-iscsi/include/scsi/scsi_transport_iscsi.h	2005-04-27 17:45:23.000000000 -0700
@@ -3,6 +3,7 @@
  *
  * Copyright (C) IBM Corporation, 2004
  * Copyright (C) Mike Christie, 2004
+ * Copyright (C) Nicholas A. Bellinger, 2005 <nab@kernel.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -27,21 +28,55 @@
 
 struct scsi_transport_template;
 
-struct iscsi_class_session {
-	uint8_t isid[6];
-	uint16_t tsih;
+struct iscsi_class_connection {
+	uint32_t max_recv_data_segment_len;
 	int header_digest;		/* 1 CRC32, 0 None */
 	int data_digest;		/* 1 CRC32, 0 None */
-	uint16_t tpgt;
+	int of_marker;			/* 1 Yes, 0 No */
+	int if_marker;			/* 1 Yes, 0 No */
+	uint32_t of_markint;
+	uint32_t if_markint;
 	union {
 		struct in6_addr sin6_addr;
 		struct in_addr sin_addr;
 	} u;
 	sa_family_t addr_type;		/* must be AF_INET or AF_INET6 */
 	uint16_t port;			/* must be in network byte order */
+};
+
+/*
+ * connection accessor macros
+ */
+#define iscsi_max_recv_data_segment_len(x) \
+	(((struct iscsi_class_connection *)&(x)->starget_data)->max_recv_data_segment_len)
+#define iscsi_header_digest(x) \
+        (((struct iscsi_class_connection *)&(x)->starget_data)->header_digest)
+#define iscsi_data_digest(x) \
+        (((struct iscsi_class_connection *)&(x)->starget_data)->data_digest)
+#define iscsi_of_marker(x) \
+	(((struct iscsi_class_connection *)&(x)->starget_data)->of_marker)
+#define iscsi_if_marker(x) \
+        (((struct iscsi_class_connection *)&(x)->starget_data)->if_marker)
+#define iscsi_of_markint(x) \
+        (((struct iscsi_class_connection *)&(x)->starget_data)->of_markint)
+#define iscsi_if_markint(x) \
+        (((struct iscsi_class_connection *)&(x)->starget_data)->if_markint)
+#define iscsi_addr_type(x) \
+        (((struct iscsi_class_connection *)&(x)->starget_data)->addr_type)
+#define iscsi_sin_addr(x) \
+        (((struct iscsi_class_connection *)&(x)->starget_data)->u.sin_addr)
+#define iscsi_sin6_addr(x) \
+        (((struct iscsi_class_connection *)&(x)->starget_data)->u.sin6_addr)
+#define iscsi_port(x) \
+        (((struct iscsi_class_connection *)&(x)->starget_data)->port)
+
+struct iscsi_class_session {
+	struct iscsi_class_connection conn; /* Only a Single Connection */
+	uint8_t isid[6];
+	uint16_t tsih;
+	uint16_t tpgt;
 	int initial_r2t;		/* 1 Yes, 0 No */
 	int immediate_data;		/* 1 Yes, 0 No */
-	uint32_t max_recv_data_segment_len;
 	uint32_t max_burst_len;
 	uint32_t first_burst_len;
 	uint16_t def_time2wait;
@@ -53,32 +88,18 @@
 };
 
 /*
- * accessor macros
+ * session accessor macros
  */
 #define iscsi_isid(x) \
 	(((struct iscsi_class_session *)&(x)->starget_data)->isid)
 #define iscsi_tsih(x) \
 	(((struct iscsi_class_session *)&(x)->starget_data)->tsih)
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
 #define iscsi_tpgt(x) \
 	(((struct iscsi_class_session *)&(x)->starget_data)->tpgt)
 #define iscsi_initial_r2t(x) \
 	(((struct iscsi_class_session *)&(x)->starget_data)->initial_r2t)
 #define iscsi_immediate_data(x) \
 	(((struct iscsi_class_session *)&(x)->starget_data)->immediate_data)
-#define iscsi_max_recv_data_segment_len(x) \
-	(((struct iscsi_class_session *)&(x)->starget_data)->max_recv_data_segment_len)
 #define iscsi_max_burst_len(x) \
 	(((struct iscsi_class_session *)&(x)->starget_data)->max_burst_len)
 #define iscsi_first_burst_len(x) \
@@ -101,19 +122,28 @@
  */
 struct iscsi_function_template {
 	/*
-	 * target attrs
+	 * target attrs - connection context
 	 */
-	void (*get_isid)(struct scsi_target *);
-	void (*get_tsih)(struct scsi_target *);
+	void (*get_max_recv_data_segment_len)(struct scsi_target *);
 	void (*get_header_digest)(struct scsi_target *);
 	void (*get_data_digest)(struct scsi_target *);
-	void (*get_port)(struct scsi_target *);
-	void (*get_tpgt)(struct scsi_target *);
+	void (*get_of_marker)(struct scsi_target *);
+	void (*get_if_marker)(struct scsi_target *);
+	void (*get_if_markint)(struct scsi_target *);
+	void (*get_of_markint)(struct scsi_target *);
 	/*
 	 * In get_ip_address the lld must set the address and
 	 * the address type
 	 */
 	void (*get_ip_address)(struct scsi_target *);
+	void (*get_port)(struct scsi_target *);
+
+	/*
+	 * target attrs - session context
+	 */
+	void (*get_isid)(struct scsi_target *);
+	void (*get_tsih)(struct scsi_target *);
+	void (*get_tpgt)(struct scsi_target *);
 	/*
 	 * The lld should snprintf the name or alias to the buffer
 	 */
@@ -121,7 +151,6 @@
 	ssize_t (*get_target_alias)(struct scsi_target *, char *, ssize_t);
 	void (*get_initial_r2t)(struct scsi_target *);
 	void (*get_immediate_data)(struct scsi_target *);
-	void (*get_max_recv_data_segment_len)(struct scsi_target *);
 	void (*get_max_burst_len)(struct scsi_target *);
 	void (*get_first_burst_len)(struct scsi_target *);
 	void (*get_def_time2wait)(struct scsi_target *);
@@ -132,10 +161,9 @@
 	void (*get_erl)(struct scsi_target *);
 
 	/*
-	 * host atts
-	 */
-
-	/*
+	 * host attrs - In this case the initiator_name and initiator_isid
+	 * make up the SCSI Initiator Port side of the Nexus.
+	 *
 	 * The lld should snprintf the name or alias to the buffer
 	 */
 	ssize_t (*get_initiator_alias)(struct Scsi_Host *, char *, ssize_t);
@@ -148,18 +176,28 @@
 	 * since we only use the values for sysfs but this is how
 	 * fc does it too.
 	 */
-	unsigned long show_isid:1;
-	unsigned long show_tsih:1;
+	/*
+	 * Connection Only.
+	 */
+	unsigned long show_max_recv_data_segment_len:1;
 	unsigned long show_header_digest:1;
 	unsigned long show_data_digest:1;
+	unsigned long show_of_marker:1;
+	unsigned long show_if_marker:1;
+	unsigned long show_of_markint:1;
+	unsigned long show_if_markint:1;
 	unsigned long show_port:1;
+	/*
+	 * Session Wide
+	 */
+	unsigned long show_isid:1;
+	unsigned long show_tsih:1;
 	unsigned long show_tpgt:1;
 	unsigned long show_ip_address:1;
 	unsigned long show_target_name:1;
 	unsigned long show_target_alias:1;
 	unsigned long show_initial_r2t:1;
 	unsigned long show_immediate_data:1;
-	unsigned long show_max_recv_data_segment_len:1;
 	unsigned long show_max_burst_len:1;
 	unsigned long show_first_burst_len:1;
 	unsigned long show_def_time2wait:1;

--=-OeRkohX60Eya6NfItcZL--

