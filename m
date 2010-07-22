From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 1/2] iscsi_transport: Modidify recovery_tmo from sysfs
Date: Thu, 22 Jul 2010 16:57:43 +0530 (IST)
Message-ID: <alpine.OSX.1.00.1007221655210.1395@Vikas.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 115.113.65.67.static-pune-stdill.vsnl.net.in ([115.113.65.67]:24450
	"HELO Vikas.local" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with SMTP id S1757196Ab0GVL1r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jul 2010 07:27:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@suse.de, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org
Cc: ravi.anand@qlogic.com, vikas.chaudhary@qlogic.comB


Added support to modify session->recovery_tmo from sysfs

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/scsi_transport_iscsi.c |   43 ++++++++++++++++++++++++++++++----
 1 files changed, 38 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index b9aec30..d4b9662 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1783,14 +1783,42 @@ show_priv_session_##field(struct device *dev, 				\
 {									\
 	struct iscsi_cls_session *session = 				\
 			iscsi_dev_to_session(dev->parent);		\
+	if (session->field == -1)					\
+		return sprintf(buf, "off\n");				\
 	return sprintf(buf, format"\n", session->field);		\
 }
 
-#define iscsi_priv_session_attr(field, format)				\
+#define iscsi_priv_session_attr_store(field)				\
+static ssize_t								\
+store_priv_session_##field(struct device *dev,				\
+			   struct device_attribute *attr,		\
+			   const char *buf, size_t count)		\
+{									\
+	int val;							\
+	char *cp;							\
+	struct iscsi_cls_session *session =				\
+		iscsi_dev_to_session(dev->parent);			\
+	if ((session->state == ISCSI_SESSION_FREE) ||			\
+	    (session->state == ISCSI_SESSION_FAILED))			\
+		return -EBUSY;						\
+	if (strncmp(buf, "off", 3) == 0)				\
+		session->field = -1;					\
+	else {								\
+		val = simple_strtoul(buf, &cp, 0);			\
+		if (*cp != '\0' && *cp != '\n')				\
+			return -EINVAL;					\
+		session->field = val;					\
+	}								\
+	return count;							\
+}
+
+#define iscsi_priv_session_rw_attr(field, format)			\
 	iscsi_priv_session_attr_show(field, format)			\
-static ISCSI_CLASS_ATTR(priv_sess, field, S_IRUGO, show_priv_session_##field, \
-			NULL)
-iscsi_priv_session_attr(recovery_tmo, "%d");
+	iscsi_priv_session_attr_store(field)				\
+static ISCSI_CLASS_ATTR(priv_sess, field, S_IRUGO | S_IWUGO,		\
+			show_priv_session_##field,			\
+			store_priv_session_##field)
+iscsi_priv_session_rw_attr(recovery_tmo, "%d");
 
 /*
  * iSCSI host attrs
@@ -1821,6 +1849,11 @@ do {									\
 	count++;							\
 } while (0)
 
+#define SETUP_PRIV_SESSION_RW_ATTR(field)				\
+do {									\
+	priv->session_attrs[count] = &dev_attr_priv_sess_##field;	\
+	count++;							\
+} while (0)
 
 #define SETUP_SESSION_RD_ATTR(field, param_flag)			\
 do {									\
@@ -2008,7 +2041,7 @@ iscsi_register_transport(struct iscsi_transport *tt)
 	SETUP_SESSION_RD_ATTR(ifacename, ISCSI_IFACE_NAME);
 	SETUP_SESSION_RD_ATTR(initiatorname, ISCSI_INITIATOR_NAME);
 	SETUP_SESSION_RD_ATTR(targetalias, ISCSI_TARGET_ALIAS);
-	SETUP_PRIV_SESSION_RD_ATTR(recovery_tmo);
+	SETUP_PRIV_SESSION_RW_ATTR(recovery_tmo);
 	SETUP_PRIV_SESSION_RD_ATTR(state);
 
 	BUG_ON(count > ISCSI_SESSION_ATTRS);
-- 
1.7.0.5

